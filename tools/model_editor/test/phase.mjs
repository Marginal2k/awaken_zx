import fs from 'node:fs';
import { renderZX } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const m = loadAll()[1].models.find((e) => e.name === 'Klopd').model;
const rows = [];
for (const f of ['base', 'm0', 'm1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7']) {
  const fr = JSON.parse(fs.readFileSync('../../work/model_editor/ingame/frame_' + f + '.json', 'utf8'));
  const W = fr.xh + 1, H = fr.yh + 1, X = 176, Y = 16;
  const fm = new Int16Array(W * H).fill(-1);
  const r = renderZX(m, { matrix: fr.matrix, pos: { x: 0, y: 0, z: fr.zet }, w: W, h: H, cx: fr.mdx, cy: fr.mdy, faceMap: fm, engine: 'station' });
  m.faces.forEach((face, i) => {
    if (face.kind !== 'poly' || face.hi !== 2 || face.labels.length) return;
    const px = []; for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) if (fm[y * W + x] === i) px.push([x, y]);
    if (px.length < 40) return;
    const sc = [0, 1].map((p) => px.filter(([x, y]) => ((((x + y + p) & 1) ? 1 : 0) === fr.screen[Y + y][X + x])).length / px.length);
    const pts = face.v.map((k) => r.P[k]);
    const ymin = Math.min(...pts.map((p) => p.y)), xs = pts.filter((p) => p.y === ymin).map((p) => p.x);
    rows.push({ f, face: i, n: px.length, ph0: sc[0].toFixed(2), ph1: sc[1].toFixed(2), best: sc[0] > sc[1] ? 0 : 1, ymin, ymaxP: Math.max(...pts.map((p) => p.y)), xTop: xs.join('/'), xmin: Math.min(...pts.map(p => p.x)) });
  });
}
console.table(rows);
