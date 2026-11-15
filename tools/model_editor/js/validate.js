// Validation of a model against the limits of the game's 3D engine.
import { vertices, nverts, recordSize, MAX_VERTS, MAX_RECORD_FLIGHT, MAX_CORNERS } from './format.js';

// Memory budgets (docs/GAME_DESIGN.md section 9.2): flight bank OBJ3D = 16384 bytes of which the models take OBJECT3D.C = 10580 (~5.8 KB free);
// station 3D viewer overlay D3D (#C000-#FE6A used) has ~150 bytes free: the budget for the station models is what they take now (1323 bytes) + 150.
export const BUDGET = { flight: 16384, station: 1323 + 150 };
export const BUDGET_NOTE = {
  flight: 'bank OBJ3D (#C000-#FFFF, 16384 B): all flight models together (OBJECT3D.C is 10580 B now, ~5.8 KB free)',
  station: 'station viewer overlay D3D: the models in OBJX take 1323 B now, the overlay has only ~150 B free',
};

const sub = (a, b) => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const len = (a) => Math.hypot(a[0], a[1], a[2]);

export const vpos = (v) => [v.x, v.y, v.z];

// Newell normal of a polygon (vertex coords); returned in the game's winding sense: the normal that points OUT of the model for a visible face.
// The game shows a polygon when the screen cross product of corners 0,1,2 is positive (x right, y down, z away): the right-hand normal (P1-P0)x(P2-P0)
// then points away from the viewer, so the outward normal is the opposite.
export function faceNormal(pts) {
  let n = [0, 0, 0];
  for (let i = 0; i < pts.length; i++) {
    const a = pts[i], b = pts[(i + 1) % pts.length];
    n[0] += (a[1] - b[1]) * (a[2] + b[2]);
    n[1] += (a[2] - b[2]) * (a[0] + b[0]);
    n[2] += (a[0] - b[0]) * (a[1] + b[1]);
  }
  // Newell gives the right-hand normal; outward (toward the viewer of a visible face) is its negative
  return [-n[0], -n[1], -n[2]];
}
export const centroid = (pts) => pts.reduce((c, p) => [c[0] + p[0] / pts.length, c[1] + p[1] / pts.length, c[2] + p[2] / pts.length], [0, 0, 0]);

export function modelCenter(m) {
  const vs = vertices(m);
  if (!vs.length) return [0, 0, 0];
  const lo = [Infinity, Infinity, Infinity], hi = [-Infinity, -Infinity, -Infinity];
  for (const v of vs) for (let i = 0; i < 3; i++) { const c = vpos(v)[i]; lo[i] = Math.min(lo[i], c); hi[i] = Math.max(hi[i], c); }
  return [0, 1, 2].map((i) => (lo[i] + hi[i]) / 2);
}

export function maxExtent(m) {
  let r = 0, c = 0;
  for (const v of vertices(m)) { r = Math.max(r, Math.hypot(v.x, v.y, v.z)); c = Math.max(c, Math.abs(v.x), Math.abs(v.y), Math.abs(v.z)); }
  return { euclid: r, cheb: c };
}

// -> [{level:'error'|'warn'|'info', msg, face?, vertex?}]
export function validate(m, kind) {
  const out = [];
  const add = (level, msg, extra = {}) => out.push({ level, msg, ...extra });
  const vs = vertices(m), nv = vs.length;
  if (nv > MAX_VERTS) add('error', `${nv} vertices: more than ${MAX_VERTS} (the screen-vertex buffer L9C is one 256-byte page of 5-byte slots; a reference is slot*5 in one byte)`);
  else if (nv > MAX_VERTS - 4) add('info', `${nv} of ${MAX_VERTS} vertices used`);
  if (!m.groups.length) add('warn', 'the model has no vertex groups (an empty placeholder model)');
  if (!m.faces.length) add('warn', 'the model has no faces');
  const rec = recordSize(m);
  if (kind === 'flight' && rec > MAX_RECORD_FLIGHT) add('error', `record is ${rec} bytes: the flight copy buffer OBJBUF holds ${MAX_RECORD_FLIGHT}`);
  if (m.scale < 1 || m.scale > 6) add('warn', `scale ${m.scale}: the renderer shifts by (scale-1) bits using a 5-step jump table, usable values are 1..6 (0 acts like 1)`);
  if (m.radius < 0 || m.radius > 255) add('error', 'radius must be 0..255');
  const used = new Array(nv).fill(0);
  const seenSig = new Map();
  m.faces.forEach((f, i) => {
    const tag = `face ${i}`;
    let bad = false;
    for (const v of f.v) { if (!(v >= 0 && v < nv)) { add('error', `${tag}: vertex ${v} does not exist (0..${nv - 1})`, { face: i }); bad = true; } else used[v]++; }
    if (f.kind === 'poly') {
      if (f.v.length < 3 || f.v.length > MAX_CORNERS) add('error', `${tag}: a polygon needs 3..${MAX_CORNERS} corners (has ${f.v.length})`, { face: i });
      if (f.hi > 4) add('warn', `${tag}: fill pattern ${f.hi} reads bytes behind the pattern table (flight: code bytes, station: zero = white); only 0..4 are real patterns, 5..7 appear only through the label flicker`, { face: i });
      if (new Set(f.v).size !== f.v.length) add('warn', `${tag}: repeats a vertex`, { face: i });
    } else if (f.v.length < 2) add('error', `${tag}: a line needs 2+ vertices`, { face: i });
    if (f.kind === 'poly' && !bad && f.v.length >= 3) {
      const pts = f.v.map((v) => vpos(vs[v]));
      const n = faceNormal(pts);
      const nl = len(n);
      if (nl < 1e-6) add('warn', `${tag}: degenerate polygon (zero area): never visible`, { face: i });
      else {
        const c = centroid(pts);
        const mc = modelCenter(m);
        if (f.v.length > 3) {
          const dmax = Math.max(...pts.map((p) => Math.abs(dot(sub(p, c), n)) / nl));
          if (dmax > 3) add('warn', `${tag}: not planar (a corner is ${dmax.toFixed(1)} units off the plane); the game only tests corners 0,1,2 (or 0,2,4) for visibility`, { face: i });
        }
        if (dot(n, sub(c, mc)) < 0) add('warn', `${tag}: faces inward (outward normal points towards the model centre): clockwise seen from outside is the visible winding`, { face: i, flip: true });
      }
      const sig = [...f.v].sort((a, b) => a - b).join(',');
      if (seenSig.has(sig)) add('info', `${tag}: same corner set as face ${seenSig.get(sig)}`, { face: i });
      else seenSig.set(sig, i);
    }
  });
  used.forEach((u, i) => { if (!u) add('warn', `vertex ${i} (group ${vs[i].group}) is not used by any face`, { vertex: i }); });
  const pos = new Map();
  vs.forEach((v, i) => { const k = vpos(v).join(','); if (pos.has(k) && !(v.group === vs[pos.get(k)].group)) add('info', `vertices ${pos.get(k)} and ${i} are at the same position`, { vertex: i }); else if (!pos.has(k)) pos.set(k, i); });
  const { euclid, cheb } = maxExtent(m);
  if (m.radius < Math.ceil(cheb) - 1) add('info', `radius ${m.radius} is smaller than the largest coordinate ${cheb}`);
  if (m.radius > Math.ceil(euclid) + 20) add('info', `radius ${m.radius} is much larger than the farthest vertex (${euclid.toFixed(0)})`);
  return out;
}

export function totalBytes(models) { return models.reduce((a, m) => a + recordSize(m), 0); }
