import fs from 'node:fs';
import { transformVertices } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const out = [];
const all=[];
for (const [fr, name] of [0,1,2,3,4,5,6,7].map(i=>['work/model_editor/ingame/frame_m'+i+'.json','Klopd']).concat([['work/model_editor/ingame/frame_base.json','Klopd']])) {
  const frame = JSON.parse(fs.readFileSync('../../' + fr, 'utf8'));
  const m = loadAll()[1].models.find((e) => e.name === name).model;
  const sh = m.scale - 1;
  const data = transformVertices(m, frame.matrix).map((v, i) => ({ X: Math.abs(v.rx << sh), Y: Math.abs(v.ry << sh), Z: frame.zet + (v.rz << sh), gx: Math.abs(frame.verts[i][0] - frame.mdx), gy: Math.abs(frame.verts[i][1] - frame.mdy) }));
  all.push(...data);
}
{ const data = all;
  const variants = {
    floor: (N, Z) => Math.floor(N * 256 / Z),
    'Z-8': (N, Z) => Math.floor(N * 256 / (Z - 8)),
    'Z-10': (N, Z) => Math.floor(N * 256 / (Z - 10)),
    'Z&~15': (N, Z) => Math.floor(N * 256 / (Z & ~15)),
    'Z&~31': (N, Z) => Math.floor(N * 256 / (Z & ~31)),
    'Z&~7': (N, Z) => Math.floor(N * 256 / (Z & ~7)),
    'N+3': (N, Z) => Math.floor((N + 3) * 256 / Z),
    'N+2': (N, Z) => Math.floor((N + 2) * 256 / Z),
    'N+4': (N, Z) => Math.floor((N + 4) * 256 / Z),
    'N+1': (N, Z) => Math.floor((N + 1) * 256 / Z),
    'Z-(Z>>7)': (N, Z) => Math.floor(N * 256 / (Z - (Z >> 7))),
    'Z-(Z>>8)*2': (N, Z) => Math.floor(N * 256 / (Z - (Z >> 8) * 2)),
    'Z-12': (N, Z) => Math.floor(N * 256 / (Z - 12)),
    'Z-9': (N, Z) => Math.floor(N * 256 / (Z - 9)),
    'Z-11': (N, Z) => Math.floor(N * 256 / (Z - 11)),
    'Z-(Z>>8)*1.5': (N, Z) => Math.floor(N * 256 / (Z - (Z >> 8) * 1.5)),
    'Z-(Z>>9)*5': (N, Z) => Math.floor(N * 256 / (Z - (Z >> 9) * 5)),
    'Z-(Z>>6)/2': (N, Z) => Math.floor(N * 256 / (Z - (Z >> 7))),
    'Zc': (N, Z) => Math.floor(N * 256 / (Z - 12 + (Z>>9))),
    'N+2,Z-4': (N, Z) => Math.floor((N + 2) * 256 / (Z - 4)),
  };
  for (const [k, f] of Object.entries(variants)) {
    let ok = 0, n = 0; for (const d of data) { n += 2; if (f(d.X, d.Z) === d.gx) ok++; if (f(d.Y, d.Z) === d.gy) ok++; }
    console.log(k, ok, '/', n);
  }
}
