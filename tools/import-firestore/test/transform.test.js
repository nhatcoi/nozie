'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { ratingFrom, transformMovie, priceToCents, slugify, toDate, transformEpisodes } = require('../src/transform');

test('maps a typical legacy movie document', () => {
  const r = transformMovie('abc123', {
    name: 'Phim Hay', originName: 'Great Movie', slug: 'phim-hay', type: 'single', year: 2021,
    time: '120 phút', view: 1500, chieurap: true, quality: 'FHD',
    category: [{ id: '1', name: 'Hành Động', slug: 'hanh-dong' }, { name: 'Kinh Dị' }],
    country: [{ id: 'c', name: 'Mỹ', slug: 'my' }],
    director: ['A', ' ', 'B'], actor: ['X'],
    price: { usd: 4.99 },
    tmdb: { vote_average: 7.2 },
    originalCreatedAt: { _seconds: 1700000000, _nanoseconds: 0 },
  });
  assert.equal(r.ok, true);
  assert.equal(r.movie.originalId, 'abc123');
  assert.equal(r.movie.priceCents, 499);
  assert.equal(r.movie.duration, '120 phút');
  assert.equal(r.movie.viewCount, 1500);
  assert.equal(r.movie.isCinema, true);
  assert.deepEqual(r.movie.directors, ['A', 'B']);
  assert.equal(r.movie.originalCreatedAt.toISOString(), '2023-11-14T22:13:20.000Z');
  assert.deepEqual(r.genres, [{ slug: 'hanh-dong', name: 'Hành Động' }, { slug: 'kinh-di', name: 'Kinh Dị' }]);
});

test('price: usd wins, vnd is converted, junk becomes free', () => {
  assert.equal(priceToCents({ usd: 0 }), 0);
  assert.equal(priceToCents({ usd: 1.005 }), 101);
  assert.equal(priceToCents({ vnd: 23000 }), 100);
  assert.equal(priceToCents({ usd: 2, vnd: 999999 }), 200);
  assert.equal(priceToCents({ usd: -5 }), 0);
  assert.equal(priceToCents({ usd: 'abc' }), 0);
  assert.equal(priceToCents(null), 0);
  assert.equal(priceToCents(undefined), 0);
});

test('rejects documents it cannot identify; derives a slug when missing', () => {
  assert.equal(transformMovie('x', { year: 2020 }).ok, false);
  assert.equal(transformMovie('', { name: 'n' }).ok, false);
  assert.equal(transformMovie('x', null).ok, false);
  assert.equal(transformMovie('x', { name: 'Đại Chiến Thế Giới' }).movie.slug, 'dai-chien-the-gioi');
});

test('invalid year, negative views and over-long fields are normalised', () => {
  const r = transformMovie('x', { name: 'N'.repeat(400), year: 99999, view: -4, quality: 'Q'.repeat(100) });
  assert.equal(r.movie.name.length, 255);
  assert.equal(r.movie.year, null);
  assert.equal(r.movie.viewCount, 0);
  assert.equal(r.movie.quality.length, 32);
});

test('episodes: server structure is flattened with stable positions', () => {
  const eps = transformEpisodes([
    { server_name: 'Vietsub #1', server_data: [
      { name: 'Tập 1', slug: 'tap-1', link_m3u8: 'https://cdn/1.m3u8', link_embed: 'https://e/1' },
      { name: 'Tập 2', slug: 'tap-2', link_embed: 'https://e/2' },
      { name: 'Tập 3', slug: 'tap-3' },
    ] },
  ]);
  assert.equal(eps.length, 2); // an episode with no URL at all is useless and dropped
  assert.equal(eps[0].serverName, 'Vietsub #1');
  assert.equal(eps[0].streamUrl, 'https://cdn/1.m3u8');
  assert.equal(eps[1].streamUrl, null);
  assert.deepEqual(eps.map((e) => e.position), [0, 1]);
});

test('episodes: flat structure and duplicate slugs are handled', () => {
  const eps = transformEpisodes([
    { name: 'Full', url: 'https://cdn/full.mp4' },
    { name: 'Full', url: 'https://cdn/full2.mp4' },
  ]);
  assert.equal(eps.length, 2);
  assert.notEqual(eps[0].slug, eps[1].slug);
});

test('dates accept ISO strings, Timestamp-like objects and garbage', () => {
  assert.equal(toDate('2020-01-02T03:04:05Z').toISOString(), '2020-01-02T03:04:05.000Z');
  assert.equal(toDate({ toDate: () => new Date(0) }).getTime(), 0);
  assert.equal(toDate({ seconds: 1, nanoseconds: 0 }).getTime(), 1000);
  assert.equal(toDate('not a date'), null);
  assert.equal(toDate(undefined), null);
});

test('slugify strips Vietnamese diacritics', () => {
  assert.equal(slugify('Đường Phố  Hỗn Loạn!'), 'duong-pho-hon-loan');
});

test('rating: 0-10 votes become 0-5, TMDB wins, junk is null', () => {
  assert.deepEqual(ratingFrom({ vote_average: 7.26, vote_count: 120 }, { vote_average: 9 }), { rating: 3.6, ratingCount: 120 });
  assert.deepEqual(ratingFrom(null, { vote_average: 8 }), { rating: 4, ratingCount: 0 });
  assert.deepEqual(ratingFrom({ vote_average: 12 }, null), { rating: 5, ratingCount: 0 });
  assert.deepEqual(ratingFrom({ vote_average: 'x' }, {}), { rating: null, ratingCount: 0 });
  assert.equal(transformMovie('a', { name: 'N', tmdb: { vote_average: 6, vote_count: 10 } }).movie.rating, 3);
});
