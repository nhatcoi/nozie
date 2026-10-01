'use strict';

const fs = require('node:fs');
const readline = require('node:readline');

/** Recursively turns Firestore-specific values into plain JSON (Timestamp → {_seconds,_nanoseconds}). */
function serialize(value) {
  if (value === null || value === undefined) return value;
  if (Array.isArray(value)) return value.map(serialize);
  if (typeof value === 'object') {
    if (typeof value.toDate === 'function' && value.seconds !== undefined) {
      return { _seconds: value.seconds, _nanoseconds: value.nanoseconds };
    }
    if (value.latitude !== undefined && value.longitude !== undefined && Object.keys(value).length === 2) {
      return { _latitude: value.latitude, _longitude: value.longitude };
    }
    if (typeof value.path === 'string' && typeof value.id === 'string' && value.firestore) {
      return { _ref: value.path }; // DocumentReference
    }
    const out = {};
    for (const [k, v] of Object.entries(value)) out[k] = serialize(v);
    return out;
  }
  return value;
}

/** Streams `{ id, data }` records from a Firestore collection, one page at a time. */
async function* readFirestore({ keyPath, collection = 'movies', pageSize = 500, limit = Infinity }) {
  const admin = require('firebase-admin');
  const credential = keyPath
    ? admin.credential.cert(JSON.parse(fs.readFileSync(keyPath, 'utf8')))
    : admin.credential.applicationDefault();
  const app = admin.initializeApp({ credential });
  try {
    const col = admin.firestore().collection(collection);
    let last = null;
    let yielded = 0;
    while (yielded < limit) {
      let q = col.orderBy(admin.firestore.FieldPath.documentId()).limit(Math.min(pageSize, limit - yielded));
      if (last) q = q.startAfter(last);
      const snap = await q.get();
      if (snap.empty) break;
      for (const doc of snap.docs) {
        yielded++;
        yield { id: doc.id, data: serialize(doc.data()) };
      }
      last = snap.docs[snap.docs.length - 1];
    }
  } finally {
    await app.delete();
  }
}

/** Streams records from an NDJSON file: one `{ "id": "...", "data": { ... } }` per line. */
async function* readNdjson(file) {
  const rl = readline.createInterface({ input: fs.createReadStream(file, 'utf8'), crlfDelay: Infinity });
  let lineNo = 0;
  for await (const line of rl) {
    lineNo++;
    if (!line.trim()) continue;
    let rec;
    try {
      rec = JSON.parse(line);
    } catch (e) {
      throw new Error(`${file}:${lineNo} is not valid JSON (${e.message})`);
    }
    if (!rec || typeof rec.id !== 'string' || typeof rec.data !== 'object') {
      throw new Error(`${file}:${lineNo} must look like {"id": "...", "data": {...}}`);
    }
    yield rec;
  }
}

module.exports = { readFirestore, readNdjson, serialize };
