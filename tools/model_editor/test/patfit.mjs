import fs from 'node:fs';
import { renderZX, PATTERNS } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const W = frame.xh + 1, H = frame.yh + 1, X = +process.argv[4], Y = +process.argv[5];
const fm = new Int16Array(W * H).fill(-1);
const r = renderZX(m, { matrix: frame.matrix, pos: { x: 0, y: 0, z: frame.zet }, w: W, h: H, cx: frame.mdx, cy: frame.mdy, cull: 'pos', faceMap: fm });
m.faces.forEach((f, i) => {
  if (f.kind !== 'poly') return;
  const px = []; for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (fm[y * W + x] === i) px.push([x, y]);
  if (px.length < 8) return;
  const out = [];
  for (let p = 0; p < 5; p++) for (const par of [0, 1]) for (const xo of [0, 1, 2, 3, 4, 5, 6, 7]) {
    const [A, M] = PATTERNS[p]; let ok = 0;
    for (const [x, y] of px) { const row = ((y + Y + par) & 1) ? (A ^ M) : A; if (((row >> (7 - ((x + X + xo) & 7))) & 1) === frame.screen[Y + y][X + x]) ok++; }
    out.push([ok / px.length, p, par, xo]);
  }
  out.sort((a, b) => b[0] - a[0]);
  console.log('face', i, 'pat', f.hi, 'pixels', px.length, 'best', out.slice(0, 3).map((o) => o[0].toFixed(2) + ' p' + o[1] + ' par' + o[2] + ' xo' + o[3]).join(' | '));
});
