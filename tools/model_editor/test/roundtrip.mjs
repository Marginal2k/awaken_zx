// Test 1: parse -> serialize is byte-identical for every model file and index.txt
import fs from 'node:fs';
import * as F from '../js/format.js';
import { loadAll, MODELS } from './common.mjs';
import path from 'node:path';

let n = 0, bad = 0;
const sets = loadAll();
for (const set of sets) {
  if (F.serializeIndex(set.ix) !== set.ixText) { bad++; console.log('INDEX MISMATCH', set.kind); }
  n++;
  for (const e of set.models) {
    n++;
    if (F.serialize(e.model) !== e.text) { bad++; console.log('MISMATCH', e.kind, e.name); }
  }
  const listed = new Set(set.models.map((e) => e.name + '.txt'));
  for (const f of fs.readdirSync(path.join(MODELS, set.kind))) if (f !== 'index.txt' && !listed.has(f)) console.log('NOT IN INDEX:', set.kind, f);
}
const nm = sets.reduce((a, s) => a + s.models.length, 0);
console.log(`roundtrip: ${n} files (${nm} models + 2 index), ${bad} mismatches`);
process.exit(bad ? 1 : 0);
