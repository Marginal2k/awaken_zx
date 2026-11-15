// Test 3 helper: apply an edit to one model file through the editor's own parser/ops/serializer (as the UI would), write it back.
// usage: node test/ingame_edit.mjs station Klopd   -> moves the wing group 1 (30 76 51 mirror=xy) to y=30 and the nose group 0 z 93 -> 60
import fs from 'node:fs';
import path from 'node:path';
import * as F from '../js/format.js';
import * as Ops from '../js/ops.js';
import { validate } from '../js/validate.js';
import { MODELS } from './common.mjs';

const [, , kind, name] = process.argv;
const file = path.join(MODELS, kind, name + '.txt');
const m = Ops.ensureIds(F.parse(fs.readFileSync(file, 'utf8'), name));
const before = JSON.stringify(m.groups.map((g) => [g.x, g.y, g.z]));
Ops.setGroupCoord(m, 1, 'y', 30);      // what dragging the wing vertices down in the Front view does
Ops.setGroupCoord(m, 0, 'z', 60);      // nose pulled back
console.log('groups before', before, '\ngroups after ', JSON.stringify(m.groups.map((g) => [g.x, g.y, g.z])));
console.log('validation', validate(m, kind).map((x) => x.level + ': ' + x.msg).join('; ') || 'ok');
fs.writeFileSync(file, F.serialize(m));
console.log('written', file, F.recordSize(m), 'bytes');
