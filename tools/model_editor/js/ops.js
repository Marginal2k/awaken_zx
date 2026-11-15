// Editing operations on a model (all mutate `m`; the app wraps each call in an undo step).
import { ORDER, expandGroup, vertices, nverts, MAX_VERTS } from './format.js';
import { faceNormal, centroid, modelCenter, vpos, maxExtent } from './validate.js';

let nextId = 1;
export const ensureIds = (m) => { for (const g of m.groups) if (!g._id) g._id = nextId++; return m; };
export const clone = (m) => JSON.parse(JSON.stringify(m));
export const clamp8 = (v) => Math.max(-128, Math.min(127, Math.round(v)));

export const vertexKeys = (m) => {
  const k = [];
  for (const g of m.groups) for (const n of ORDER) if ((g.mask >> n) & 1) k.push(g._id + ':' + n);
  return k;
};

// run `mutate` (which may add/remove/reorder groups or change masks) and remap face vertex numbers so the faces keep pointing at the same copies.
// Corners whose vertex vanished are dropped; returns the number of dropped corners.
export function regroup(m, mutate) {
  ensureIds(m);
  const old = vertexKeys(m);
  mutate(m);
  ensureIds(m);
  const map = new Map(vertexKeys(m).map((k, i) => [k, i]));
  let dropped = 0;
  for (const f of m.faces) {
    const nv = [];
    for (const v of f.v) { const n = map.get(old[v]); if (n === undefined) dropped++; else nv.push(n); }
    f.v = nv;
  }
  return dropped;
}

export function setGroupCoord(m, gi, axis, value) { m.groups[gi][axis] = clamp8(value); }
export function setGroupMask(m, gi, mask) { return regroup(m, (mm) => { mm.groups[gi].mask = mask; }); }
export function addGroup(m, g = {}) {
  let gi = m.groups.length;
  regroup(m, (mm) => { mm.groups.push({ mask: g.mask ?? 1, x: clamp8(g.x ?? 0), y: clamp8(g.y ?? 0), z: clamp8(g.z ?? 0) }); });
  return gi;
}
export function removeGroup(m, gi) { return regroup(m, (mm) => { mm.groups.splice(gi, 1); }); }
export function moveGroup(m, gi, dir) {
  const j = gi + dir;
  if (j < 0 || j >= m.groups.length) return gi;
  regroup(m, (mm) => { const t = mm.groups[gi]; mm.groups[gi] = mm.groups[j]; mm.groups[j] = t; });
  return j;
}

export function addFace(m, kind, hi, v, labels = []) { m.faces.push({ labels, kind, hi, v: v.slice() }); return m.faces.length - 1; }
export function removeFace(m, fi) { return m.faces.splice(fi, 1)[0]; }
export function moveFace(m, fi, dir) {
  const j = fi + dir;
  if (j < 0 || j >= m.faces.length) return fi;
  const t = m.faces[fi]; m.faces[fi] = m.faces[j]; m.faces[j] = t;
  return j;
}
// keep the first corner, reverse the rest: flips the winding (and with it the visibility)
export function flipFace(m, fi) { const f = m.faces[fi]; f.v = [f.v[0], ...f.v.slice(1).reverse()]; }
export function setFaceKind(f, kind) {
  if (f.kind === kind) return;
  f.kind = kind; f.hi = kind === 'poly' ? 2 : 9;
}

// flip every polygon whose outward normal points to the model centre; returns the number flipped
export function autoWind(m) {
  const vs = vertices(m), mc = modelCenter(m);
  let n = 0;
  m.faces.forEach((f, i) => {
    if (f.kind !== 'poly' || f.v.length < 3 || f.v.some((v) => !vs[v])) return;
    const pts = f.v.map((v) => vpos(vs[v]));
    const nn = faceNormal(pts), c = centroid(pts);
    const d = nn[0] * (c[0] - mc[0]) + nn[1] * (c[1] - mc[1]) + nn[2] * (c[2] - mc[2]);
    if (d < 0) { flipFace(m, i); n++; }
  });
  return n;
}

export function autoRadius(m) { const { euclid, cheb } = maxExtent(m); return Math.min(255, Math.max(0, Math.ceil(Math.max(euclid, cheb)))); }

// new model skeleton: a ship-like wedge (nose, mirrored wings and tail)
export function templateModel(name) {
  const m = {
    title: `${name} (new model)`, labels: [name], radius: 70, scale: 2,
    groups: [{ mask: 0x01, x: 0, y: 0, z: 60 }, { mask: 0x0F, x: 30, y: 12, z: -40 }, { mask: 0x03, x: 60, y: 0, z: -30 }],
    faces: [], endLabels: [],
  };
  // vertices: 0 nose, 1..4 tail box (+,+) (-,+) (-,-) (+,-), 5,6 wing tips (x=60,-60)
  const P = (v) => ({ labels: [], kind: 'poly', hi: 2, v });
  m.faces.push(P([0, 1, 2]), P([0, 2, 3]), P([0, 3, 4]), P([0, 4, 1]), P([1, 4, 3, 2]), { labels: [], kind: 'poly', hi: 3, v: [0, 5, 1] }, { labels: [], kind: 'poly', hi: 3, v: [0, 2, 6] });
  m.radius = autoRadius(m);
  ensureIds(m);
  autoWind(m);
  return m;
}

// duplicate: new name = first label; labels of faces are dropped (an assembler label must be unique)
export function duplicateModel(m, name) {
  const c = clone(m);
  c.title = `${name} (copy of ${m.labels[0] || 'model'})`;
  c.labels = [name];
  let lost = 0;
  for (const f of c.faces) { lost += f.labels.length; f.labels = []; }
  c.endLabels = [];
  return { model: ensureIds(c), lostLabels: lost };
}

export { nverts, MAX_VERTS, expandGroup };
