'use strict';

/**
 * Pure mapping from a Firestore `movies/{id}` document to rows for the Postgres schema
 * (movies, genres, movie_genres, episodes). No I/O here so it is fully unit-testable.
 */

const VND_PER_USD = 23000; // same rate the Flutter app used for display (Movie.priceValue)

function clip(value, max) {
  if (value === null || value === undefined) return null;
  const s = String(value).trim();
  if (s === '') return null;
  return s.length > max ? s.slice(0, max) : s;
}

function toInt(value) {
  if (value === null || value === undefined || value === '') return null;
  const n = Number(value);
  return Number.isFinite(n) ? Math.trunc(n) : null;
}

function toBool(value) {
  return value === true || value === 'true' || value === 1;
}

/** Accepts ISO strings, Date, Firestore Timestamp, and the serialized `{_seconds,_nanoseconds}` form. */
function toDate(value) {
  if (value === null || value === undefined) return null;
  let d = null;
  if (value instanceof Date) d = value;
  else if (typeof value === 'string') d = new Date(value);
  else if (typeof value === 'number') d = new Date(value);
  else if (typeof value === 'object') {
    if (typeof value.toDate === 'function') d = value.toDate();
    else {
      const seconds = value._seconds ?? value.seconds;
      if (seconds !== undefined) {
        const nanos = value._nanoseconds ?? value.nanoseconds ?? 0;
        d = new Date(Number(seconds) * 1000 + Math.floor(Number(nanos) / 1e6));
      }
    }
  }
  return d && !Number.isNaN(d.getTime()) ? d : null;
}

function toStringArray(value) {
  if (!Array.isArray(value)) return [];
  return value.map((v) => String(v ?? '').trim()).filter(Boolean);
}

function toObjectArray(value) {
  if (!Array.isArray(value)) return [];
  return value.filter((v) => v && typeof v === 'object' && !Array.isArray(v));
}

function toObject(value) {
  return value && typeof value === 'object' && !Array.isArray(value) ? value : null;
}

/** Lowercase ascii slug; strips Vietnamese diacritics. */
function slugify(text) {
  return String(text || '')
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/đ/g, 'd')
    .replace(/Đ/g, 'D')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 200);
}

/** `price: { usd }` wins; otherwise `{ vnd }` converted. Result in integer cents, never negative. */
function priceToCents(price) {
  const p = toObject(price);
  if (!p) return 0;
  let usd = null;
  if (p.usd !== undefined && p.usd !== null && Number.isFinite(Number(p.usd))) usd = Number(p.usd);
  else if (p.vnd !== undefined && p.vnd !== null && Number.isFinite(Number(p.vnd))) usd = Number(p.vnd) / VND_PER_USD;
  if (usd === null || usd < 0) return 0;
  // toFixed absorbs binary float error (1.005 * 100 = 100.49999999999999) before rounding to whole cents
  return Math.round(Number((usd * 100).toFixed(6)));
}

/** TMDB/IMDB votes are 0-10; the app shows 0-5. TMDB wins when both exist. */
function ratingFrom(tmdb, imdb) {
  for (const src of [tmdb, imdb]) {
    if (src && src.vote_average !== undefined && src.vote_average !== null && Number.isFinite(Number(src.vote_average))) {
      const rating = Math.min(5, Math.max(0, Math.round((Number(src.vote_average) / 2) * 10) / 10));
      return { rating, ratingCount: Math.max(0, toInt(src.vote_count) ?? 0) };
    }
  }
  return { rating: null, ratingCount: 0 };
}

function transformGenres(category) {
  const seen = new Set();
  const out = [];
  for (const c of toObjectArray(category)) {
    const name = clip(c.name, 120);
    if (!name) continue;
    const slug = clip(c.slug, 80) || slugify(name);
    if (!slug || seen.has(slug)) continue;
    seen.add(slug);
    out.push({ slug, name });
  }
  return out;
}

/**
 * Handles every episode shape found in the legacy data:
 *  - server structure: { server_name, server_data: [{ name, slug, link_m3u8, link_embed }] }
 *  - flat structure:   { name, slug, url | videoUrl | link_m3u8 | link_embed }
 */
function transformEpisodes(episodes) {
  const out = [];
  const used = new Set();

  const push = (serverName, item, fallbackIndex) => {
    const streamUrl = clip(item.link_m3u8 || item.url || item.videoUrl || item.stream_url, 2048);
    const embedUrl = clip(item.link_embed || item.embed_url, 2048);
    if (!streamUrl && !embedUrl) return;
    const name = clip(item.name || item.filename, 120) || `Episode ${fallbackIndex + 1}`;
    let slug = clip(item.slug, 120) || slugify(name) || `ep-${fallbackIndex + 1}`;
    const server = clip(serverName, 120) || '';
    let key = `${server}\u0000${slug}`;
    for (let n = 2; used.has(key); n++) {
      slug = `${clip(item.slug, 100) || slugify(name) || 'ep'}-${n}`;
      key = `${server}\u0000${slug}`;
    }
    used.add(key);
    out.push({ serverName: server, name, slug, streamUrl, embedUrl, position: out.length });
  };

  toObjectArray(episodes).forEach((ep, i) => {
    if (Array.isArray(ep.server_data)) {
      toObjectArray(ep.server_data).forEach((item, j) => push(ep.server_name, item, j));
    } else {
      push(ep.server_name || '', ep, i);
    }
  });
  return out;
}

/**
 * @param {string} docId Firestore document id (kept as movies.original_id so legacy
 *   purchases/wishlist/ratings keyed by it can be migrated later)
 * @param {object} data  document fields
 * @returns {{ ok: true, movie, genres, episodes } | { ok: false, reason: string }}
 */
function transformMovie(docId, data) {
  if (!docId) return { ok: false, reason: 'missing document id' };
  if (!data || typeof data !== 'object') return { ok: false, reason: 'empty document' };

  const name = clip(data.name, 255) || clip(data.originName, 255);
  if (!name) return { ok: false, reason: 'no name' };

  const slug = clip(data.slug, 255) || slugify(name) || slugify(docId);
  const year = toInt(data.year);

  const movie = {
    originalId: String(docId),
    slug,
    name,
    originName: clip(data.originName, 255),
    type: clip(data.type, 32) || 'single',
    status: clip(data.status, 32),
    content: data.content === undefined || data.content === null ? null : String(data.content),
    trailerUrl: clip(data.trailerUrl, 1024),
    posterUrl: clip(data.posterUrl, 1024),
    thumbUrl: clip(data.thumbUrl, 1024),
    quality: clip(data.quality, 32),
    duration: clip(data.time, 64),
    lang: clip(data.lang, 64),
    year: year !== null && year >= 1888 && year <= 2200 ? year : null,
    viewCount: Math.max(0, toInt(data.view) ?? 0),
    episodeCurrent: clip(data.episodeCurrent, 64),
    episodeTotal: clip(data.episodeTotal, 64),
    isCinema: toBool(data.chieurap),
    subExclusive: toBool(data.subDocquyen),
    isCopyright: toBool(data.isCopyright),
    directors: toStringArray(data.director),
    actors: toStringArray(data.actor),
    alternativeNames: toStringArray(data.alternativeNames),
    countries: toObjectArray(data.country),
    tmdb: toObject(data.tmdb),
    imdb: toObject(data.imdb),
    ...ratingFrom(toObject(data.tmdb), toObject(data.imdb)),
    priceCents: priceToCents(data.price),
    currency: 'USD',
    originalCreatedAt: toDate(data.originalCreatedAt),
    originalModifiedAt: toDate(data.originalModifiedAt),
  };

  return { ok: true, movie, genres: transformGenres(data.category), episodes: transformEpisodes(data.episodes) };
}

module.exports = { ratingFrom, transformMovie, transformGenres, transformEpisodes, priceToCents, slugify, toDate, VND_PER_USD };
