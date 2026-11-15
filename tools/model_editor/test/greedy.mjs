import fs from 'node:fs';
import { renderZX } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const W = frame.xh + 1, H = frame.yh + 1, X = 176, Y = 16;
const score = (o) => { const r = renderZX(m, { matrix: frame.matrix, pos: { x: 0, y: 0, z: frame.zet }, w: W, h: H, cx: frame.mdx, cy: frame.mdy, cull: 'pos', engine: 'station', ...o });
  let ok = 0; for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (frame.screen[Y + y][X + x] === r.bm.d[y * W + x]) ok++; return [ok, r]; };
let [base, r0] = score({});
let ov = []; m.faces.forEach((f, i) => { ov[i] = r0.visible[i]; });
for (let it = 0; it < 8; it++) {
  let best = [base, -1];
  m.faces.forEach((f, i) => { const o = ov.slice(); o[i] = !o[i]; const [s] = score({ override: o }); if (s > best[0]) best = [s, i]; });
  if (best[1] < 0) break; ov[best[1]] = !ov[best[1]]; base = best[0]; console.log('flip', best[1], '->', base);
}
console.log('final visible', ov.map((v, i) => v ? i : '').filter((x) => x !== '').join(' '));
console.log('crosses', m.faces.map((f, i) => i + ':' + r0.cross[i]).join(' '));
