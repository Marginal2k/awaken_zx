import fs from 'node:fs';
import { renderZX } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const W = frame.xh + 1, H = frame.yh + 1;
const M = frame.matrix;
const T = [M[0], M[3], M[6], M[1], M[4], M[7], M[2], M[5], M[8]];
const res = [];
for (const [tn, base] of [['id', M], ['T', T]])
  for (const s0 of [1, -1]) for (const s1 of [1, -1]) for (const s2 of [1, -1])
    for (const cull of ['neg', 'pos']) {
      const mm = base.map((v, i) => v * (i < 3 ? s0 : i < 6 ? s1 : s2));
      const r = renderZX(m, { matrix: mm, pos: { x: 0, y: 0, z: frame.zet }, w: W, h: H, cx: frame.mdx, cy: frame.mdy, cull });
      let best = { score: -1 };
      for (let y0 = 14; y0 <= 28; y0++) for (let x0 = 166; x0 <= 180; x0++) {
        let ok = 0;
        for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (frame.screen[y0 + y][x0 + x] === r.bm.d[y * W + x]) ok++;
        if (ok > best.score) best = { score: ok, x0, y0 };
      }
      res.push({ tn, s0, s1, s2, cull, ...best });
    }
res.sort((a, b) => b.score - a.score);
console.table(res.slice(0, 8));
