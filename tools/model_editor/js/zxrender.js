// "ZX view": software renderer reproducing the game's 3D engine (src/flight/3D-I.asm, 3D-II.asm; the station viewer src/station/XR2.asm is the same engine).
//
// Facts taken from the code (see README.md, section "Renderer facts"):
//  * a vertex (x,y,z signed bytes) is multiplied by the 3x3 byte matrix with the game's quarter-square multiply (MULAB: a*b/127, table MULTB),
//    the three sums are 8-bit signed; mirrored copies are the same terms with negated signs;
//  * camera space: X to the left, Y up, Z away from the viewer. The record is shifted by (scale-1) bits (the code jumps 6-scale bytes into 5 `add hl,hl`)
//    and added to the 16-bit object position (TX,TY,TZ);
//  * perspective: screen = centre -/+ 256*|N|/Z  (16-bit long division; X positive = left of centre, Y positive = above centre); Z <= 0 or a quotient > 65535 = off-screen;
//  * polygons: back-face test on the first three corners (0,1,2; for 5..8 corners 0,2,4); visible = cross product sign (opts.cull);
//    fill pattern 0..4 = pattern table LC5 (3D-II.asm:12): row byte A / A^M alternating by screen row; a SET bit is the DARK pixel (the shadow screen is cleared to FF):
//    0 black, 1 = 25% lit, 2 = 50% (checkerboard), 3 = 75% lit, 4 = white.  Patterns 5..7 read code bytes behind the table (not meaningful);
//  * polylines (face byte bit 7): Bresenham 1-pixel lines; mode bits 4-5: 0 = AND (clears bits: lit line), 1 = OR (sets bits: dark line), 2/3 = XOR;
//    bit 6 = draw only if the previous polygon was visible.  Faces are drawn in file order (later ones overwrite earlier ones: the painter order is the model order).

import { expandGroup, ORDER } from './format.js';

// pattern table LC5 (word = mask byte, row byte): 0..4 are the table; 5..7 are the bytes behind it: in the flight image the code of CLRHD (ED 73 | 29 D1 | 31 00),
// in the station overlay the zero padding (the flicker routine MERZ toggles bits 5-6 of labelled faces: 1<->7, 2<->4, 3<->5)
const PAT_BASE = [[0xFF, 0x00], [0x77, 0xAA], [0x55, 0xFF], [0x11, 0x55], [0x00, 0x00]];
export const PATTERNS_BY_ENGINE = {
  flight: [...PAT_BASE, [0xED, 0x73], [0x29, 0xD1], [0x31, 0x00]],
  station: [...PAT_BASE, [0x00, 0x00], [0x00, 0x00], [0x00, 0x00]],
};
export const PATTERNS = PATTERNS_BY_ENGINE.flight;
export const PATTERN_NAMES = ['0 black', '1 25% lit', '2 50% lit', '3 75% lit', '4 white', '5 (code bytes)', '6 (code bytes)', '7 (code bytes)'];

const f = (n) => { n &= 255; if (n >= 128) n = 255 - n; return Math.floor((n * n) / 127); };
const s8 = (v) => ((v + 128) & 255) - 128;
// MULAB: a = a*b (signed), exactly the macro in src/flight/MACRO.asm
export function mulab(a, b) {
  const sa = a >> 1;
  const d = (sa - (b >> 1)) & 255;
  const s = (d + b) & 255;
  return s8(f(s) - f(d));
}

// matrix: rows of the camera X,Y,Z as 9 signed bytes [m11 m12 m13 m21 ... m33] (OM_ij in 3D-II.asm)
export function matrixFromAngles(yaw, pitch, roll = 0) {
  const cy = Math.cos(yaw), sy = Math.sin(yaw), cp = Math.cos(pitch), sp = Math.sin(pitch), cr = Math.cos(roll), sr = Math.sin(roll);
  // R = Rroll * Rpitch(x) * Ryaw(y)
  const ry = [[cy, 0, sy], [0, 1, 0], [-sy, 0, cy]];
  const rx = [[1, 0, 0], [0, cp, -sp], [0, sp, cp]];
  const rz = [[cr, -sr, 0], [sr, cr, 0], [0, 0, 1]];
  const mul = (A, B) => A.map((r, i) => [0, 1, 2].map((j) => r[0] * B[0][j] + r[1] * B[1][j] + r[2] * B[2][j]));
  const R = mul(rz, mul(rx, ry));
  return R.flat().map((v) => Math.max(-127, Math.min(127, Math.round(v * 127))));
}

// camera-space vertices of a model: [{rx,ry,rz, group}] in vertex order.  Reproduces RENDI (3D-II.asm:675): the X and Y sums are packed in one 16-bit register
// (high byte X, low byte Y), the mirrored copies are made by subtracting the doubled (RLC) terms, so the code's +-1 rounding quirks are reproduced.
const rlc = (v) => ((v << 1) | ((v >> 7) & 1)) & 255;
const sgn8 = (v) => ((v & 255) ^ 128) - 128;
export function transformVertices(m, M) {
  const out = [];
  for (let gi = 0; gi < m.groups.length; gi++) {
    const g = m.groups[gi];
    const c = [g.x, g.y, g.z];
    const T = [0, 1, 2].map((i) => [0, 1, 2].map((j) => mulab(M[3 * i + j], c[j]) & 255)); // T[i][j] = row i (X,Y,Z), coordinate j
    const bc = (T[0][0] << 8) | T[1][0], de = (T[0][1] << 8) | T[1][1], hl = (T[0][2] << 8) | T[1][2];
    const bc2 = (rlc(T[0][0]) << 8) | rlc(T[1][0]), de2 = (rlc(T[0][1]) << 8) | rlc(T[1][1]);
    const W = [];
    W[0] = (hl + bc + de) & 0xFFFF;
    W[1] = (W[0] - bc2) & 0xFFFF;
    W[3] = (W[1] - de2) & 0xFFFF;
    W[2] = (W[3] + bc2) & 0xFFFF;
    W[5] = ((((256 - (W[2] >> 8)) & 255) << 8) | ((256 - (W[2] & 255)) & 255));
    W[4] = (W[5] + bc2) & 0xFFFF;
    W[6] = (W[4] - de2) & 0xFFFF;
    W[7] = (W[6] - bc2) & 0xFFFF;
    const z3 = T[2][2], zd = T[2][0], ze = T[2][1], zd2 = rlc(zd), ze2 = rlc(ze);
    const Z = [];
    Z[0] = (z3 + zd + ze) & 255;
    Z[1] = (Z[0] - zd2) & 255;
    Z[3] = (Z[1] - ze2) & 255;
    Z[2] = (Z[3] + zd2) & 255;
    Z[5] = (256 - Z[2]) & 255;
    Z[4] = (Z[5] + zd2) & 255;
    Z[6] = (Z[4] - ze2) & 255;
    Z[7] = (Z[6] - zd2) & 255;
    for (const n of ORDER) {
      if (!((g.mask >> n) & 1)) continue;
      out.push({ rx: sgn8(W[n] >> 8), ry: sgn8(W[n] & 255), rz: sgn8(Z[n]), group: gi });
    }
  }
  return out;
}

export const ZBIAS = 12;
// project: returns [{x,y,ok}] screen positions (centre cx,cy), pos = object position in camera space (tx,ty,tz), 16-bit
export function project(m, M, pos, view) {
  const shift = Math.max(0, m.scale - 1);
  const focal = view.focal || 256;
  return transformVertices(m, M).map((v) => {
    const X = pos.x + (v.rx << shift), Y = pos.y + (v.ry << shift), Z = pos.z + (v.rz << shift);
    if (Z <= 0) return { x: 0, y: 0, ok: false, z: Z };
    const Zd = Z - (view.zbias ?? ZBIAS);   // the game's division behaves like dividing by Z-12 (measured: 322 of 324 vertex coordinates exact on 9 emulator frames)
    if (Zd <= 0) return { x: 0, y: 0, ok: false, z: Z };
    const qx = Math.floor((Math.abs(X) * focal) / Zd), qy = Math.floor((Math.abs(Y) * focal) / Zd);
    if (qx > 0xFFFF || qy > 0xFFFF) return { x: 0, y: 0, ok: false, z: Z };
    return { x: X >= 0 ? view.cx + qx : view.cx - qx, y: Y >= 0 ? view.cy + qy : view.cy - qy, ok: true, z: Z };
  });
}

// cross product of the first three corners (screen); `cull`: 'neg' = visible if the value is negative
export function faceCross(face, P) {
  const n = face.v.length;
  const i0 = face.v[0], i1 = n >= 5 ? face.v[2] : face.v[1], i2 = n >= 5 ? face.v[4] : face.v[2];
  const a = P[i0], b = P[i1], c = P[i2];
  if (!a || !b || !c) return 0;
  return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
}
export const isVisible = (cross, cull) => (cull === 'pos' ? cross > 0 : cross < 0);

// bitmap buffer: bit = 1 dark (game polarity). lit() converts.
export class Bitmap {
  constructor(w, h) { this.w = w; this.h = h; this.d = new Uint8Array(w * h).fill(1); }
  lit(x, y) { return this.d[y * this.w + x] ? 0 : 1; }
}

function clipPoly(pts, w, h) {
  // Sutherland-Hodgman against [0,w-1] x [0,h-1] (float coordinates)
  const edges = [
    (p) => p.x >= 0, (p) => p.x <= w - 1, (p) => p.y >= 0, (p) => p.y <= h - 1];
  const inter = [
    (a, b) => { const t = (0 - a.x) / (b.x - a.x); return { x: 0, y: a.y + t * (b.y - a.y) }; },
    (a, b) => { const t = (w - 1 - a.x) / (b.x - a.x); return { x: w - 1, y: a.y + t * (b.y - a.y) }; },
    (a, b) => { const t = (0 - a.y) / (b.y - a.y); return { x: a.x + t * (b.x - a.x), y: 0 }; },
    (a, b) => { const t = (h - 1 - a.y) / (b.y - a.y); return { x: a.x + t * (b.x - a.x), y: h - 1 }; }];
  let out = pts;
  for (let e = 0; e < 4 && out.length; e++) {
    const inp = out; out = [];
    for (let i = 0; i < inp.length; i++) {
      const a = inp[i], b = inp[(i + 1) % inp.length];
      const ia = edges[e](a), ib = edges[e](b);
      if (ia) out.push(a);
      if (ia !== ib) out.push(inter[e](a, b));
    }
  }
  return out;
}

function fillPolygon(bm, pts, pattern, opts) {
  const w = bm.w, h = bm.h;
  const c = clipPoly(pts, w, h).map((p) => ({ x: Math.round(p.x), y: Math.round(p.y) }));
  if (c.length < 2) return;
  let ymin = Infinity, ymax = -Infinity;
  for (const p of c) { ymin = Math.min(ymin, p.y); ymax = Math.max(ymax, p.y); }
  const L = new Array(ymax - ymin + 1).fill(Infinity), R = new Array(ymax - ymin + 1).fill(-Infinity);
  for (let i = 0; i < c.length; i++) {
    const a = c[i], b = c[(i + 1) % c.length];
    const dy = b.y - a.y;
    const steps = Math.max(Math.abs(dy), 1);
    const y0 = Math.min(a.y, b.y), y1 = Math.max(a.y, b.y);
    if (dy === 0) { const k = a.y - ymin; L[k] = Math.min(L[k], a.x, b.x); R[k] = Math.max(R[k], a.x, b.x); continue; }
    for (let y = y0; y <= y1; y++) {
      const t = (y - a.y) / dy;
      const x = Math.round(a.x + t * (b.x - a.x));
      const k = y - ymin; L[k] = Math.min(L[k], x); R[k] = Math.max(R[k], x);
    }
  }
  const [A, Mk] = (PATTERNS_BY_ENGINE[opts.engine || 'flight'])[pattern];
  for (let y = ymin; y <= ymax; y++) {
    const k = y - ymin;
    if (L[k] > R[k] || y < 0 || y >= h) continue;
    // rows alternate A / A^M starting with A at the polygon's top row (measured on emulator frames); columns are anchored to the 8-pixel screen bytes
    const par = (y - ymin) & 1;
    const row = par ? (A ^ Mk) & 255 : A;
    for (let x = Math.max(0, L[k]); x <= Math.min(w - 1, R[k]); x++) {
      bm.d[y * w + x] = (row >> (7 - (((x + (opts.xOrigin || 0)) & 7)))) & 1;
      if (opts.faceMap) opts.faceMap[y * w + x] = opts.curFace;
    }
  }
}

function drawLine(bm, a, b, mode) {
  let x0 = Math.round(a.x), y0 = Math.round(a.y); const x1 = Math.round(b.x), y1 = Math.round(b.y);
  const dx = Math.abs(x1 - x0), dy = -Math.abs(y1 - y0), sx = x0 < x1 ? 1 : -1, sy = y0 < y1 ? 1 : -1;
  let err = dx + dy;
  for (;;) {
    if (x0 >= 0 && x0 < bm.w && y0 >= 0 && y0 < bm.h) {
      const i = y0 * bm.w + x0;
      if (mode === 0) bm.d[i] = 0; else if (mode === 1) bm.d[i] = 1; else bm.d[i] ^= 1;
    }
    if (x0 === x1 && y0 === y1) break;
    const e2 = 2 * err;
    if (e2 >= dy) { err += dy; x0 += sx; }
    if (e2 <= dx) { err += dx; y0 += sy; }
  }
}

// opts: matrix (9 bytes), pos {x,y,z}, w,h, cx,cy, focal, cull ('neg'|'pos'), parity, rowOrigin, xOrigin, clear (bit)
// returns {bm, P (projected), visible [bool per face], cross [per face]}
export function renderZX(m, opts) {
  const w = opts.w || 256, h = opts.h || 192;
  const view = { cx: opts.cx ?? w / 2, cy: opts.cy ?? h / 2, focal: opts.focal || 256 };
  const bm = new Bitmap(w, h);
  if (opts.clear === 0) bm.d.fill(0);
  const P = project(m, opts.matrix, opts.pos, view);
  const visible = [], cross = [];
  let prevVisible = true;
  m.faces.forEach((face, fi) => {
    const pts = face.v.map((i) => P[i]);
    const valid = pts.every((p) => p && p.ok);
    if (face.kind === 'poly') {
      const cr = valid ? faceCross(face, P) : 0;
      cross[fi] = cr;
      let vis = valid && isVisible(cr, opts.cull || 'pos');
      if (opts.override && opts.override[fi] !== undefined) vis = opts.override[fi];
      visible[fi] = vis; prevVisible = vis;
      opts.curFace = fi;
      if (vis) fillPolygon(bm, pts, opts.flicker && face.labels.length ? face.hi ^ 6 : face.hi, opts);
    } else {
      const only = (face.hi & 4) !== 0;
      visible[fi] = valid && (!only || prevVisible);
      cross[fi] = 0;
      if (visible[fi]) for (let i = 0; i + 1 < pts.length; i++) drawLine(bm, pts[i], pts[i + 1], face.hi & 3);
    }
  });
  return { bm, P, visible, cross };
}
