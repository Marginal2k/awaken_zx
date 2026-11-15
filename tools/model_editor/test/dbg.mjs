import fs from 'node:fs';
import { transformVertices } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const sh = m.scale - 1;
transformVertices(m, frame.matrix).forEach((v, i) => {
  const X = v.rx << sh, Y = v.ry << sh, Z = frame.zet + (v.rz << sh);
  const gx = frame.verts[i][0] - frame.mdx, gy = frame.verts[i][1] - frame.mdy;
  console.log(i, 'X', X, 'Y', Y, 'Z', Z, 'exact', (X * 256 / Z).toFixed(3), (Y * 256 / Z).toFixed(3), 'game', gx, gy);
});
