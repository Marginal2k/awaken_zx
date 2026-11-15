// Test 3b: ZX-view renderer vs emulator frames (frame_*.json made by szx_frame.py): vertex positions and window pixels
import fs from 'node:fs';
import path from 'node:path';
import { renderZX, project } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
import { sheet } from './png.mjs';

const dir = process.argv[2], outDir = process.argv[3] || dir, name = process.argv[4] || 'Klopd';
const files = fs.readdirSync(dir).filter((f) => /^frame_.*\.json$/.test(f)).sort();
const m = loadAll()[1].models.find((e) => e.name === name).model;
let totV = 0, okV = 0, totP = 0, okP = 0;
const sheets = [];
for (const f of files) {
  const fr = JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8'));
  const W = fr.xh + 1, H = fr.yh + 1, X = 176, Y = 16;
  const P = project(m, fr.matrix, { x: 0, y: 0, z: fr.zet }, { cx: fr.mdx, cy: fr.mdy });
  let v = 0; P.forEach((p, i) => { totV++; if (p.x === fr.verts[i][0] && p.y === fr.verts[i][1]) { okV++; v++; } });
  const r = renderZX(m, { matrix: fr.matrix, pos: { x: 0, y: 0, z: fr.zet }, w: W, h: H, cx: fr.mdx, cy: fr.mdy, engine: 'station' });
  let ok = 0; for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (fr.screen[Y + y][X + x] === r.bm.d[y * W + x]) ok++;
  let gl = 0, ml = 0; for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) { gl += fr.screen[Y + y][X + x] ? 0 : 1; ml += r.bm.d[y * W + x] ? 0 : 1; }
  const blank = gl < 0.5 * ml;   // the game screen shows a frame that is cleared / not drawn yet (double buffering)
  if (!blank) { totP += W * H; okP += ok; }
  console.log(f, 'vertices exact', v + '/' + P.length, blank ? '(game window blank at the snapshot: pixels not compared)' : 'window pixels equal ' + (100 * ok / (W * H)).toFixed(1) + '%');
  const game = { w: W, h: H, get: (x, y) => (fr.screen[Y + y][X + x] ? 0 : 1) };
  const mine = { w: W, h: H, get: (x, y) => r.bm.lit(x, y) };
  const diff = { w: W, h: H, get: (x, y) => { const a = game.get(x, y), b = mine.get(x, y); return a === b ? a : 2; } };
  sheets.push(game, mine, diff);
}
console.log(`TOTAL vertices exact ${okV}/${totV} (${(100 * okV / totV).toFixed(1)}%), window pixels equal ${(100 * okP / totP).toFixed(2)}%`);
fs.writeFileSync(path.join(outDir, 'zxview_vs_emulator.png'), sheet(sheets.slice(0, 9), 3));
