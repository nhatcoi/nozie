'use strict';
/**
 * Runs the real importer against PostgreSQL using the API's own Flyway migration as the schema.
 * Skipped unless TEST_DATABASE_URL points at an EMPTY throwaway database.
 */
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { importMovies } = require('../src/importer');

const url = process.env.TEST_DATABASE_URL;
const skip = url ? false : 'set TEST_DATABASE_URL to run database tests';

const MIGRATIONS_DIR = path.join(__dirname, '../../../services/api/src/main/resources/db/migration');

async function* records(list) {
  for (const r of list) yield r;
}

const doc = (over = {}) => ({
  name: 'Movie', slug: 'movie', type: 'single', year: 2020, price: { usd: 3 },
  category: [{ name: 'Action', slug: 'action' }],
  episodes: [{ server_name: 'S1', server_data: [{ name: 'E1', slug: 'e1', link_m3u8: 'https://cdn/1.m3u8' }] }],
  ...over,
});

test('importer against PostgreSQL', { skip }, async (t) => {
  const { Pool } = require('pg');
  const pool = new Pool({ connectionString: url, max: 2 });
  t.after(() => pool.end());

  await pool.query('DROP SCHEMA public CASCADE; CREATE SCHEMA public;');
  for (const f of fs.readdirSync(MIGRATIONS_DIR).filter((n) => n.endsWith('.sql')).sort((a, b) => parseInt(a.slice(1)) - parseInt(b.slice(1)))) {
    await pool.query(fs.readFileSync(path.join(MIGRATIONS_DIR, f), 'utf8'));
  }

  const count = async (table) => Number((await pool.query(`SELECT count(*) FROM ${table}`)).rows[0].count);

  await t.test('inserts movies, genres and episodes', async () => {
    const stats = await importMovies(pool, records([
      { id: 'doc1', data: doc() },
      { id: 'doc2', data: doc({ name: 'Other', slug: 'other', category: [{ name: 'Action', slug: 'action' }, { name: 'Drama', slug: 'drama' }] }) },
      { id: 'bad', data: { year: 2020 } },
    ]));
    assert.equal(stats.inserted, 2);
    assert.equal(stats.skipped.length, 1);
    assert.equal(stats.failed.length, 0);
    assert.equal(await count('movies'), 2);
    assert.equal(await count('genres'), 2);
    assert.equal(await count('movie_genres'), 3);
    assert.equal(await count('episodes'), 2);
    const m = (await pool.query("SELECT price_cents, original_id FROM movies WHERE slug='movie'")).rows[0];
    assert.equal(m.price_cents, 300);
    assert.equal(m.original_id, 'doc1');
    const r = (await pool.query("SELECT rating, rating_count FROM movies WHERE slug='movie'")).rows[0];
    assert.equal(r.rating, null);
  });

  await t.test('is idempotent and keeps episode ids stable', async () => {
    const before = (await pool.query("SELECT id FROM episodes ORDER BY id")).rows.map((r) => r.id);
    const stats = await importMovies(pool, records([{ id: 'doc1', data: doc({ name: 'Renamed' }) }]));
    assert.equal(stats.inserted, 0);
    assert.equal(stats.updated, 1);
    assert.equal(await count('movies'), 2);
    assert.equal(await count('episodes'), 2);
    assert.equal((await pool.query("SELECT name FROM movies WHERE original_id='doc1'")).rows[0].name, 'Renamed');
    const after = (await pool.query("SELECT id FROM episodes ORDER BY id")).rows.map((r) => r.id);
    assert.deepEqual(after, before);
  });

  await t.test('removes episodes and genres that disappeared from the source', async () => {
    await importMovies(pool, records([{ id: 'doc1', data: doc({ episodes: [], category: [] }) }]));
    const left = await pool.query("SELECT count(*) FROM episodes e JOIN movies m ON m.id = e.movie_id WHERE m.original_id='doc1'");
    assert.equal(Number(left.rows[0].count), 0);
    const g = await pool.query("SELECT count(*) FROM movie_genres mg JOIN movies m ON m.id = mg.movie_id WHERE m.original_id='doc1'");
    assert.equal(Number(g.rows[0].count), 0);
  });

  await t.test('--keep-prices protects prices edited after the first import', async () => {
    await pool.query("UPDATE movies SET price_cents = 999 WHERE original_id='doc1'");
    await importMovies(pool, records([{ id: 'doc1', data: doc({ price: { usd: 1 } }) }]), { keepPrices: true });
    assert.equal((await pool.query("SELECT price_cents FROM movies WHERE original_id='doc1'")).rows[0].price_cents, 999);
    await importMovies(pool, records([{ id: 'doc1', data: doc({ price: { usd: 1 } }) }]));
    assert.equal((await pool.query("SELECT price_cents FROM movies WHERE original_id='doc1'")).rows[0].price_cents, 100);
  });

  await t.test('a slug owned by another movie gets a unique suffix instead of failing', async () => {
    const stats = await importMovies(pool, records([{ id: 'doc9', data: doc({ slug: 'other' }) }]));
    assert.equal(stats.failed.length, 0);
    assert.equal(stats.slugRenamed, 1);
    const slug = (await pool.query("SELECT slug FROM movies WHERE original_id='doc9'")).rows[0].slug;
    assert.match(slug, /^other-doc9$/);
  });

  await t.test('one bad document does not sink its batch', async () => {
    const stats = await importMovies(pool, records([
      { id: 'ok1', data: doc({ slug: 'ok-1', name: 'Ok1' }) },
      { id: 'evil', data: doc({ slug: 'evil', name: 'Evil', type: 'x', episodes: [{ server_name: 'S', server_data: [{ name: 'a\u0000b', slug: 's', link_m3u8: 'u' }] }] }) },
      { id: 'ok2', data: doc({ slug: 'ok-2', name: 'Ok2' }) },
    ]));
    assert.equal(stats.failed.length, 1);
    assert.equal(stats.failed[0].id, 'evil');
    assert.equal(stats.inserted, 2);
    assert.equal(await count("movies WHERE original_id = 'evil'"), 0);
  });

  await t.test('dry run writes nothing', async () => {
    const before = await count('movies');
    const stats = await importMovies(null, records([{ id: 'dry', data: doc({ slug: 'dry' }) }]), { dryRun: true });
    assert.equal(stats.inserted, 1);
    assert.equal(await count('movies'), before);
  });
});
