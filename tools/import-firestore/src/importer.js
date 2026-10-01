'use strict';

const { transformMovie } = require('./transform');

const BATCH_SIZE = 100;

const UPSERT_MOVIE = `
INSERT INTO movies (
  original_id, slug, name, origin_name, type, status, content, trailer_url, poster_url, thumb_url,
  quality, duration, lang, year, view_count, episode_current, episode_total,
  is_cinema, sub_exclusive, is_copyright, directors, actors, alternative_names,
  countries, tmdb, imdb, price_cents, currency, original_created_at, original_modified_at, rating, rating_count)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$32,$33)
ON CONFLICT (original_id) WHERE original_id IS NOT NULL DO UPDATE SET
  slug = EXCLUDED.slug, name = EXCLUDED.name, origin_name = EXCLUDED.origin_name, type = EXCLUDED.type,
  status = EXCLUDED.status, content = EXCLUDED.content, trailer_url = EXCLUDED.trailer_url,
  poster_url = EXCLUDED.poster_url, thumb_url = EXCLUDED.thumb_url, quality = EXCLUDED.quality,
  duration = EXCLUDED.duration, lang = EXCLUDED.lang, year = EXCLUDED.year, view_count = EXCLUDED.view_count,
  episode_current = EXCLUDED.episode_current, episode_total = EXCLUDED.episode_total,
  is_cinema = EXCLUDED.is_cinema, sub_exclusive = EXCLUDED.sub_exclusive, is_copyright = EXCLUDED.is_copyright,
  directors = EXCLUDED.directors, actors = EXCLUDED.actors, alternative_names = EXCLUDED.alternative_names,
  countries = EXCLUDED.countries, tmdb = EXCLUDED.tmdb, imdb = EXCLUDED.imdb,
  price_cents = CASE WHEN $31 THEN movies.price_cents ELSE EXCLUDED.price_cents END,
  currency = EXCLUDED.currency, original_created_at = EXCLUDED.original_created_at,
  original_modified_at = EXCLUDED.original_modified_at, rating = EXCLUDED.rating, rating_count = EXCLUDED.rating_count,
  updated_at = now()
RETURNING id, (xmax = 0) AS inserted`;

const UPSERT_EPISODE = `
INSERT INTO episodes (movie_id, server_name, name, slug, stream_url, embed_url, position)
VALUES ($1,$2,$3,$4,$5,$6,$7)
ON CONFLICT (movie_id, server_name, slug) DO UPDATE SET
  name = EXCLUDED.name, stream_url = EXCLUDED.stream_url, embed_url = EXCLUDED.embed_url, position = EXCLUDED.position
RETURNING id`;

/** A different movie already owns this slug → make ours unique and stable. */
async function resolveSlug(client, movie) {
  const { rows } = await client.query('SELECT original_id FROM movies WHERE slug = $1', [movie.slug]);
  if (rows.length === 0 || rows[0].original_id === movie.originalId) return movie.slug;
  const suffix = movie.originalId.toLowerCase().replace(/[^a-z0-9]/g, '').slice(0, 8);
  return `${movie.slug.slice(0, 240)}-${suffix}`;
}

async function writeMovie(client, t, options) {
  const m = t.movie;
  const slug = await resolveSlug(client, m);
  const { rows } = await client.query(UPSERT_MOVIE, [
    m.originalId, slug, m.name, m.originName, m.type, m.status, m.content, m.trailerUrl, m.posterUrl, m.thumbUrl,
    m.quality, m.duration, m.lang, m.year, m.viewCount, m.episodeCurrent, m.episodeTotal,
    m.isCinema, m.subExclusive, m.isCopyright, m.directors, m.actors, m.alternativeNames,
    JSON.stringify(m.countries), m.tmdb ? JSON.stringify(m.tmdb) : null, m.imdb ? JSON.stringify(m.imdb) : null,
    m.priceCents, m.currency, m.originalCreatedAt, m.originalModifiedAt, options.keepPrices,
    m.rating, m.ratingCount,
  ]);
  const movieId = rows[0].id;

  const genreIds = [];
  for (const g of t.genres) {
    const r = await client.query(
      'INSERT INTO genres (slug, name) VALUES ($1, $2) ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name RETURNING id',
      [g.slug, g.name]);
    genreIds.push(r.rows[0].id);
  }
  await client.query('DELETE FROM movie_genres WHERE movie_id = $1', [movieId]);
  for (const id of genreIds) {
    await client.query('INSERT INTO movie_genres (movie_id, genre_id) VALUES ($1, $2)', [movieId, id]);
  }

  // Upsert (not delete+insert) so episode ids, and the watch history pointing at them, survive a re-import.
  const episodeIds = [];
  for (const e of t.episodes) {
    const r = await client.query(UPSERT_EPISODE, [movieId, e.serverName, e.name, e.slug, e.streamUrl, e.embedUrl, e.position]);
    episodeIds.push(r.rows[0].id);
  }
  await client.query('DELETE FROM episodes WHERE movie_id = $1 AND NOT (id = ANY($2::uuid[]))', [movieId, episodeIds]);

  return { inserted: rows[0].inserted, slugChanged: slug !== m.slug, episodes: episodeIds.length, genres: genreIds.length };
}

async function inTransaction(pool, fn) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const result = await fn(client);
    await client.query('COMMIT');
    return result;
  } catch (e) {
    await client.query('ROLLBACK').catch(() => {});
    throw e;
  } finally {
    client.release();
  }
}

/**
 * @param pool    pg Pool, or null for a dry run (transform + validate only)
 * @param records async iterable of { id, data }
 */
async function importMovies(pool, records, { keepPrices = false, dryRun = false, log = () => {} } = {}) {
  const stats = { read: 0, inserted: 0, updated: 0, skipped: [], failed: [], episodes: 0, genreLinks: 0, slugRenamed: 0 };
  let batch = [];

  const flush = async () => {
    if (batch.length === 0) return;
    const items = batch;
    batch = [];
    if (dryRun) {
      for (const t of items) {
        stats.inserted++;
        stats.episodes += t.episodes.length;
        stats.genreLinks += t.genres.length;
      }
      return;
    }
    const apply = (results) => {
      for (const r of results) {
        r.inserted ? stats.inserted++ : stats.updated++;
        stats.episodes += r.episodes;
        stats.genreLinks += r.genres;
        if (r.slugChanged) stats.slugRenamed++;
      }
    };
    try {
      apply(await inTransaction(pool, async (c) => {
        const out = [];
        for (const t of items) out.push(await writeMovie(c, t, { keepPrices }));
        return out;
      }));
    } catch (batchError) {
      // One bad document must not sink its 99 neighbours: retry them one by one.
      log(`batch failed (${batchError.message}); retrying ${items.length} movies individually`);
      for (const t of items) {
        try {
          apply([await inTransaction(pool, (c) => writeMovie(c, t, { keepPrices }))]);
        } catch (e) {
          stats.failed.push({ id: t.movie.originalId, reason: e.message });
        }
      }
    }
  };

  for await (const rec of records) {
    stats.read++;
    const t = transformMovie(rec.id, rec.data);
    if (!t.ok) {
      stats.skipped.push({ id: rec.id, reason: t.reason });
      continue;
    }
    batch.push(t);
    if (batch.length >= BATCH_SIZE) await flush();
    if (stats.read % 500 === 0) log(`processed ${stats.read} documents`);
  }
  await flush();
  return stats;
}

module.exports = { importMovies };
