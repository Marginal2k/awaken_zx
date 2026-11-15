import fs from 'node:fs';
import { renderZX } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const W = frame.xh + 1, H = frame.yh + 1;
const res = []; const FL = process.argv[4] === 'fl';
for (const dx of [-2, -1, 0, 1, 2]) for (const dy of [-2, -1, 0, 1, 2]) for (const par of [0, 1]) for (const [X, Y] of [[176, 16], [176, 17], [175, 16], [176, 18], [177, 17], [177, 16]]) {
  const r = renderZX(m, { matrix: frame.matrix, pos: { x: 0, y: 0, z: frame.zet }, w: W, h: H, cx: frame.mdx + dx, cy: frame.mdy + dy, cull: 'pos', parity: par, engine: 'station', flicker: FL });
  let ok = 0; for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (frame.screen[Y + y][X + x] === r.bm.d[y * W + x]) ok++;
  res.push({ dx, dy, par, X, Y, ok });
}
res.sort((a, b) => b.ok - a.ok); console.table(res.slice(0, 8));
