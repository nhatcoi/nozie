#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const { parseArgs } = require('node:util');
const { readFirestore, readNdjson } = require('./source');
const { importMovies } = require('./importer');

const HELP = `
Nozie catalog migration: Firestore -> PostgreSQL

  export   Dump a Firestore collection to an NDJSON file (read-only on Firestore)
  import   Load movies into PostgreSQL from an NDJSON file or straight from Firestore

Examples
  node src/cli.js export --key ./serviceAccountKey.json --out movies.ndjson
  DATABASE_URL=postgres://nozie:***@localhost:5433/nozie \\
    node src/cli.js import --file movies.ndjson --dry-run
  DATABASE_URL=... node src/cli.js import --file movies.ndjson
  DATABASE_URL=... node src/cli.js import --key ./serviceAccountKey.json

Options
  --key <path>          Firebase service-account JSON (or set GOOGLE_APPLICATION_CREDENTIALS)
  --collection <name>   Firestore collection (default: movies)
  --file <path>         NDJSON input for import
  --out <path>          NDJSON output for export
  --limit <n>           Stop after n documents (handy for a trial run)
  --dry-run             Validate and count only; do not touch the database
  --keep-prices         On re-import, do not overwrite price_cents of existing movies
  --yes                 Required to write to a database that is not localhost

The database URL is read from $DATABASE_URL (never from the command line, so it stays out of shell history).
`;

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function isLocal(url) {
  try {
    const h = new URL(url).hostname;
    return h === 'localhost' || h === '127.0.0.1' || h === '::1' || h === '[::1]';
  } catch {
    return false;
  }
}

async function main() {
  const { positionals, values } = parseArgs({
    allowPositionals: true,
    options: {
      key: { type: 'string' },
      collection: { type: 'string', default: 'movies' },
      file: { type: 'string' },
      out: { type: 'string' },
      limit: { type: 'string' },
      'dry-run': { type: 'boolean', default: false },
      'keep-prices': { type: 'boolean', default: false },
      yes: { type: 'boolean', default: false },
      help: { type: 'boolean', short: 'h', default: false },
    },
  });
  const command = positionals[0];
  if (values.help || !command) return console.log(HELP);

  const limit = values.limit ? Number(values.limit) : Infinity;
  if (values.limit && !(limit > 0)) fail('--limit must be a positive number');

  const firestore = () => {
    if (!values.key && !process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      fail('Firestore access needs --key <serviceAccount.json> or GOOGLE_APPLICATION_CREDENTIALS');
    }
    return readFirestore({ keyPath: values.key, collection: values.collection, limit });
  };

  if (command === 'export') {
    if (!values.out) fail('export needs --out <file.ndjson>');
    const out = fs.createWriteStream(values.out, { encoding: 'utf8' });
    let n = 0;
    for await (const rec of firestore()) {
      if (!out.write(JSON.stringify(rec) + '\n')) await new Promise((r) => out.once('drain', r));
      n++;
    }
    await new Promise((r) => out.end(r));
    console.log(`exported ${n} documents from "${values.collection}" to ${values.out}`);
    return;
  }

  if (command === 'import') {
    const source = values.file ? readNdjson(values.file) : firestore();
    let pool = null;
    if (!values['dry-run']) {
      const url = process.env.DATABASE_URL;
      if (!url) fail('set DATABASE_URL (e.g. postgres://user:pass@localhost:5433/nozie)');
      if (!isLocal(url) && !values.yes) {
        fail('DATABASE_URL is not localhost: re-run with --yes to confirm you mean to write to that database');
      }
      const { Pool } = require('pg');
      pool = new Pool({ connectionString: url, max: 4 });
    }
    try {
      const started = Date.now();
      const stats = await importMovies(pool, source, {
        dryRun: values['dry-run'],
        keepPrices: values['keep-prices'],
        log: (m) => console.log(m),
      });
      const secs = ((Date.now() - started) / 1000).toFixed(1);
      console.log(`\n${values['dry-run'] ? 'DRY RUN - nothing written\n' : ''}` +
        `documents read : ${stats.read}\n` +
        `${values['dry-run'] ? 'would import   ' : 'inserted       '}: ${stats.inserted}\n` +
        `updated        : ${stats.updated}\n` +
        `episodes       : ${stats.episodes}\n` +
        `genre links    : ${stats.genreLinks}\n` +
        `slugs renamed  : ${stats.slugRenamed}\n` +
        `skipped        : ${stats.skipped.length}\n` +
        `failed         : ${stats.failed.length}\n` +
        `time           : ${secs}s`);
      for (const s of stats.skipped.slice(0, 20)) console.log(`  skipped ${s.id}: ${s.reason}`);
      for (const f of stats.failed.slice(0, 20)) console.log(`  FAILED  ${f.id}: ${f.reason}`);
      if (stats.failed.length > 0) process.exitCode = 2;
    } finally {
      if (pool) await pool.end();
    }
    return;
  }

  fail(`unknown command "${command}"\n${HELP}`);
}

main().catch((e) => {
  console.error(`error: ${e.message}`);
  process.exit(1);
});
