import fs from 'node:fs';
import { project } from '../js/zxrender.js';
import { loadAll } from './common.mjs';
const frame = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const m = loadAll()[1].models.find((e) => e.name === process.argv[3]).model;
const P = project(m, frame.matrix, { x: 0, y: 0, z: frame.zet }, { cx: frame.mdx, cy: frame.mdy });
P.forEach((p, i) => console.log(i, 'game', frame.verts[i].join(','), ' mine', p.ok ? p.x + ',' + p.y : 'off', ' d', p.ok ? [p.x - frame.verts[i][0], p.y - frame.verts[i][1]].join(',') : ''));
