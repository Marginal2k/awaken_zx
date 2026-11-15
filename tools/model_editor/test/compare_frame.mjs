// compare the ZX-view renderer with a station snapshot (frame.json from szx_frame.py): finds the window offset and prints the best agreement
import fs from 'node:fs';
import * as F from '../js/format.js';
import { renderZX } from '../js/zxrender.js';
import { loadAll } from './common.mjs';

const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const modelName = process.argv[3] || 'Klopd';
const station = loadAll()[1];
const m = station.models.find((e) => e.name === modelName).model;
const W = frame.xh + 1, H = frame.yh + 1;
const results = [];
for (const cull of ['neg', 'pos'])
  for (const parity of [0, 1])
    for (const rowOrigin of ['abs', 'top'])
      for (const flip of [1, -1]) {
        const matrix = frame.matrix.map((v, i) => v);
        const r = renderZX(m, { matrix, pos: { x: 0, y: 0, z: frame.zet }, w: W, h: H, cx: frame.mdx, cy: frame.mdy, cull, parity, rowOrigin, xOrigin: 0 });
        // search window position on the screen
        let best = { score: -1 };
        for (let y0 = 0; y0 <= 192 - H; y0++) for (let x0 = 0; x0 <= 256 - W; x0++) {
          for (const xo of [0]) {
            let ok = 0;
            for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (frame.screen[y0 + y][x0 + x] === r.bm.d[y * W + x]) ok++;
            if (ok > best.score) best = { score: ok, x0, y0 };
          }
        }
        results.push({ cull, parity, rowOrigin, flip, ...best, of: W * H, lit: r.bm.d.reduce((a, v) => a + (v ? 0 : 1), 0) });
        break;
      }
results.sort((a, b) => b.score - a.score);
console.table(results);
