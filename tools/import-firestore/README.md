# import-firestore

One-off migration of the movie catalog from Firestore to the Nozie PostgreSQL database.

```
Firestore movies/{id}  ──export──▶  movies.ndjson  ──import──▶  PostgreSQL
                       └──────────────── import --key ─────────────────▶
```

## Setup

```bash
cd tools/import-firestore
npm install
```

You need a Firebase **service-account key** (Firebase Console → Project settings → Service accounts →
*Generate new private key*). Keep it outside git (`**/serviceAccountKey*.json` is ignored). The script only
**reads** Firestore.

## Usage

```bash
# 1. dump Firestore to a file (re-runnable, read-only)
node src/cli.js export --key ~/secrets/serviceAccountKey.json --out movies.ndjson

# 2. check what would happen, no database needed
node src/cli.js import --file movies.ndjson --dry-run

# 3. load into the local dev database (docker compose up -d postgres first)
DATABASE_URL=postgres://nozie:change-me-dev-only@localhost:5433/nozie \
  node src/cli.js import --file movies.ndjson
```

Importing into a non-localhost database requires `--yes`. The URL is read from `$DATABASE_URL`, never from the
command line.

| Option | Meaning |
|---|---|
| `--key <path>` | Service-account JSON (or `GOOGLE_APPLICATION_CREDENTIALS`) |
| `--collection <name>` | Source collection, default `movies` |
| `--limit <n>` | Stop after n documents (trial run) |
| `--dry-run` | Validate and count only |
| `--keep-prices` | On re-import keep `price_cents` of existing movies |

## Mapping

| Firestore | PostgreSQL |
|---|---|
| document id | `movies.original_id` (so legacy purchases/wishlist/ratings keyed by it can be migrated) |
| `name, originName, slug, type, status, content, *Url, quality, lang, year, view` | same-named columns (`time`→`duration`, `view`→`view_count`) |
| `chieurap, subDocquyen, isCopyright` | `is_cinema, sub_exclusive, is_copyright` |
| `director, actor, alternativeNames` | `text[]` columns |
| `country`, `tmdb`, `imdb` | `jsonb` |
| `price.usd` (or `price.vnd` ÷ 23000) | `price_cents` (integer cents, `USD`) |
| `category[]` | `genres` + `movie_genres` |
| `episodes[]` (`server_data[]` or flat) | `episodes` (stream/embed URLs stay private) |

## Guarantees

- **Idempotent**: re-running updates by `original_id`; episode ids are preserved so watch history keeps working.
- **Safe on bad data**: a document with no name is skipped and reported; one failing document does not abort its
  batch of 100; slug clashes get a unique suffix instead of failing.
- **Resumable**: nothing is deleted from movies; episodes/genres that vanished from the source are removed for that movie only.

## Tests

```bash
npm test                                   # pure transform tests
TEST_DATABASE_URL=postgres://... npm test  # + real PostgreSQL (DESTROYS the public schema of that database)
```
