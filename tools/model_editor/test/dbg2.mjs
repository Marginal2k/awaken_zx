import fs from 'node:fs';
import { transformVertices } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const sh = m.scale - 1;
transformVertices(m, frame.matrix).forEach((v, i) => {
  const X = Math.abs(v.rx << sh), Y = Math.abs(v.ry << sh), Z = frame.zet + (v.rz << sh);
  const gx = Math.abs(frame.verts[i][0] - frame.mdx), gy = Math.abs(frame.verts[i][1] - frame.mdy);
  const iv = (N, g) => g === 0 ? ['>', (N * 256 / 1).toFixed(0)] : [(N * 256 / (g + 1)).toFixed(1), (N * 256 / g).toFixed(1)];
  console.log(i, 'Z', Z, '0x' + Z.toString(16), 'Xint', iv(X, gx).join('..'), 'Yint', iv(Y, gy).join('..'));
});
