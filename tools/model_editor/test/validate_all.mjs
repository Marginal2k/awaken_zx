// Test 4: validation over all shipped models (they must have no errors) + winding convention check (faces facing inward must be rare)
import { validate, BUDGET, totalBytes } from '../js/validate.js';
import { loadAll } from './common.mjs';
let err = 0, inward = 0, faces = 0, warns = {};
for (const set of loadAll()) {
  for (const e of set.models) {
    const r = validate(e.model, set.kind);
    for (const x of r) {
      if (x.level === 'error') { err++; console.log('ERROR', set.kind, e.name, x.msg); }
      if (x.flip) inward++;
      const k = x.msg.replace(/\d+/g, 'N').slice(0, 60); warns[k] = (warns[k] || 0) + 1;
    }
    faces += e.model.faces.filter((f) => f.kind === 'poly').length;
  }
  console.log(set.kind, 'total bytes', totalBytes(set.models.map((e) => e.model)), 'budget', BUDGET[set.kind]);
}
console.log(`polygons ${faces}, wound inward ${inward} (${(100 * inward / faces).toFixed(1)}%), errors ${err}`);
console.log(warns);
process.exit(err ? 1 : 0);
