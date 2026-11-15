// Viewports: ZX view (game renderer) and edit views (orbit 3D, front / side / top orthographic, vertex dragging, face picking).
import { vertices, ORDER } from './format.js';
import { renderZX, matrixFromAngles } from './zxrender.js';
import { faceNormal, centroid, vpos, modelCenter } from './validate.js';

export const ZX_PRESETS = {
  full: { name: 'Full screen 256x192', w: 256, h: 192, cx: 128, cy: 96, engine: 'flight' },
  flight: { name: 'Flight window 256x96', w: 256, h: 96, cx: 128, cy: 48, engine: 'flight' },
  station: { name: 'Station viewer 72x72 (Ship screen)', w: 72, h: 72, cx: 36, cy: 36, engine: 'station' },
};

// float rotation for the edit views (the same orientation as the ZX view: camera X right, Y down, Z away)
export function rotFloat(yaw, pitch, roll = 0) {
  const m = matrixFromAngles(yaw, pitch, roll); // bytes /127
  return m.map((v) => v / 127);
}
const FIXED = {
  front: [1, 0, 0, 0, 1, 0, 0, 0, 1],   // screen x = X, y = Y
  side: [0, 0, 1, 0, 1, 0, -1, 0, 0],   // screen x = Z, y = Y
  top: [1, 0, 0, 0, 0, 1, 0, -1, 0],    // screen x = X, y = Z
};
const AXES = { front: ['x', 'y'], side: ['z', 'y'], top: ['x', 'z'] };

export class Viewport {
  constructor(canvas, app) {
    this.c = canvas; this.ctx = canvas.getContext('2d'); this.app = app;
    this.mode = 'edit';              // 'zx' | 'edit' | 'front' | 'side' | 'top'
    this.yaw = 0.6; this.pitch = 0.35; this.roll = 0;
    this.zoom = 2.2; this.pan = [0, 0];
    this.zx = { preset: 'full', tz: 0, auto: true, spin: false, flicker: false, pixel: 3, color: '#35e0c0', engineAuto: true, engine: 'flight' };
    this.opt = { fill: true, normals: true, numbers: true, hidden: true, grid: true, labels: true };
    this.hover = null; this.drag = null; this.scr = [];
    this.off = document.createElement('canvas');
    this._bind();
  }

  setMode(m) { this.mode = m; this.draw(); }

  // ----- geometry ---------------------------------------------------------------------------------
  R() { return this.mode in FIXED ? FIXED[this.mode] : rotFloat(this.yaw, this.pitch, this.roll); }
  project(m) {
    const R = this.R(), vs = vertices(m), w = this.c.width, h = this.c.height;
    const cen = this.mode === 'edit' ? modelCenter(m) : [0, 0, 0];
    const cx = w / 2 + this.pan[0], cy = h / 2 + this.pan[1];
    return vs.map((v) => {
      const p = [v.x - cen[0], v.y - cen[1], v.z - cen[2]];
      const X = R[0] * p[0] + R[1] * p[1] + R[2] * p[2], Y = R[3] * p[0] + R[4] * p[1] + R[5] * p[2], Z = R[6] * p[0] + R[7] * p[1] + R[8] * p[2];
      return { x: cx + X * this.zoom, y: cy + Y * this.zoom, z: Z, v };
    });
  }
  // inverse for the ortho views: screen -> {axisA, axisB} world values
  unproject(sx, sy) {
    const [a, b] = AXES[this.mode];
    return { [a]: (sx - this.c.width / 2 - this.pan[0]) / this.zoom, [b]: (sy - this.c.height / 2 - this.pan[1]) / this.zoom };
  }

  fitZoom(m) {
    let r = 20; for (const v of vertices(m)) r = Math.max(r, Math.hypot(v.x, v.y, v.z));
    const side = Math.min(this.c.width, this.c.height);
    this.zoom = (side * 0.42) / r; this.pan = [0, 0];
  }

  // ----- drawing ---------------------------------------------------------------------------------
  draw() {
    const m = this.app.model;
    if (!m) return;
    const c = this.c, ctx = this.ctx;
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    if (this.mode === 'zx') return this.drawZX(m);
    ctx.fillStyle = getComputedStyle(document.body).getPropertyValue('--view-bg') || '#111';
    ctx.fillRect(0, 0, c.width, c.height);
    const P = this.scr = this.project(m);
    if (this.opt.grid) this.drawGrid();
    const sel = this.app.sel;
    // faces
    const info = m.faces.map((f, i) => this.faceInfo(m, f, P));
    const order = m.faces.map((_, i) => i);
    // hidden first
    const drawFace = (i, hiddenPass) => {
      const f = m.faces[i], fi = info[i];
      if (!fi.pts) return;
      const isSel = sel.face === i;
      if (f.kind === 'poly') {
        if (fi.visible === hiddenPass) return;
        if (hiddenPass && !this.opt.hidden && !isSel) return;
        ctx.beginPath(); fi.pts.forEach((p, k) => (k ? ctx.lineTo(p.x, p.y) : ctx.moveTo(p.x, p.y))); ctx.closePath();
        if (!hiddenPass && this.opt.fill) { const a = [0.05, 0.18, 0.32, 0.5, 0.7][Math.min(4, f.hi)] + 0.05; ctx.fillStyle = `rgba(80,200,200,${a})`; ctx.fill(); }
        ctx.lineWidth = isSel ? 2.5 : 1;
        ctx.setLineDash(hiddenPass ? [3, 4] : []);
        ctx.strokeStyle = isSel ? '#ffd23f' : hiddenPass ? 'rgba(150,150,170,0.45)' : '#9fe0e0';
        ctx.stroke(); ctx.setLineDash([]);
      } else {
        const show = fi.visible;
        if (!show && !this.opt.hidden && !isSel) return;
        if (show === hiddenPass) return;
        ctx.beginPath(); fi.pts.forEach((p, k) => (k ? ctx.lineTo(p.x, p.y) : ctx.moveTo(p.x, p.y)));
        ctx.lineWidth = isSel ? 2.5 : 1.5; ctx.setLineDash(show ? [] : [3, 3]);
        ctx.strokeStyle = isSel ? '#ffd23f' : show ? '#ff9f43' : 'rgba(255,159,67,0.4)'; ctx.stroke(); ctx.setLineDash([]);
      }
    };
    order.forEach((i) => drawFace(i, true));
    order.forEach((i) => drawFace(i, false));
    // normals and winding of polygons
    if (this.opt.normals) {
      m.faces.forEach((f, i) => {
        const fi = info[i];
        if (f.kind !== 'poly' || !fi.pts || fi.pts.length < 3) return;
        const cx = fi.pts.reduce((a, p) => a + p.x, 0) / fi.pts.length, cy = fi.pts.reduce((a, p) => a + p.y, 0) / fi.pts.length;
        const nx = fi.normal[0], ny = fi.normal[1];
        const L = 16;
        ctx.strokeStyle = fi.inward ? '#ff5d5d' : fi.visible ? '#5dff8a' : 'rgba(93,255,138,0.35)'; ctx.lineWidth = 1.5;
        ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(cx + nx * L, cy + ny * L); ctx.stroke();
        ctx.fillStyle = ctx.strokeStyle; ctx.beginPath(); ctx.arc(cx + nx * L, cy + ny * L, 2.5, 0, 7); ctx.fill();
      });
    }
    if (sel.face !== null && m.faces[sel.face] && info[sel.face].pts) {
      const pts = info[sel.face].pts;
      ctx.font = 'bold 11px system-ui'; ctx.fillStyle = '#ffd23f'; ctx.textAlign = 'center';
      pts.forEach((p, k) => { ctx.fillText(String(k + 1), p.x + 10, p.y - 8); });
      if (pts.length >= 2) this.arrow(pts[0], pts[1], '#ffd23f');
    }
    // vertices
    const adding = this.app.adding;
    P.forEach((p, i) => {
      const selV = sel.vertex === i, selG = sel.group === p.v.group, hov = this.hover === i;
      const inFace = adding && adding.verts.includes(i);
      ctx.beginPath(); ctx.arc(p.x, p.y, selV ? 5.5 : hov ? 5 : 3.5, 0, 7);
      ctx.fillStyle = inFace ? '#ffd23f' : selV ? '#ffffff' : selG ? '#ffb86b' : hov ? '#ffe9a8' : '#4aa3ff'; ctx.fill();
      ctx.strokeStyle = '#000'; ctx.lineWidth = 1; ctx.stroke();
      if (this.opt.numbers) { ctx.font = '10px system-ui'; ctx.fillStyle = selG ? '#ffb86b' : '#a9c6ff'; ctx.textAlign = 'left'; ctx.fillText(String(i), p.x + 6, p.y - 5); }
    });
    if (adding) {
      ctx.fillStyle = '#ffd23f'; ctx.font = '12px system-ui'; ctx.textAlign = 'left';
      ctx.fillText(`Add ${adding.kind}: click vertices in order (${adding.verts.length}), Enter = finish, Esc = cancel`, 10, 20);
      ctx.strokeStyle = '#ffd23f'; ctx.lineWidth = 2; ctx.beginPath();
      adding.verts.forEach((v, k) => { const p = P[v]; if (p) (k ? ctx.lineTo(p.x, p.y) : ctx.moveTo(p.x, p.y)); });
      if (this.mouse && adding.verts.length) ctx.lineTo(this.mouse[0], this.mouse[1]);
      ctx.stroke();
    }
    this.drawGizmo();
  }

  faceInfo(m, f, P) {
    const pts = f.v.map((i) => P[i]);
    if (pts.some((p) => !p)) return { pts: null };
    let visible = true, normal = [0, 0, 0], inward = false;
    if (f.kind === 'poly' && pts.length >= 3) {
      const n = f.v.length, a = pts[0], b = n >= 5 ? pts[2] : pts[1], c = n >= 5 ? pts[4] : pts[2];
      const cr = (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
      visible = cr > 0;
      // outward normal in screen terms (dx,dy) of the model normal, unit length
      const vs = f.v.map((i) => vpos(P[i].v)), nn = faceNormal(vs), l = Math.hypot(...nn) || 1;
      const R = this.R();
      normal = [(R[0] * nn[0] + R[1] * nn[1] + R[2] * nn[2]) / l, (R[3] * nn[0] + R[4] * nn[1] + R[5] * nn[2]) / l, (R[6] * nn[0] + R[7] * nn[1] + R[8] * nn[2]) / l];
      const cc = centroid(vs), mc = modelCenter(m);
      inward = nn[0] * (cc[0] - mc[0]) + nn[1] * (cc[1] - mc[1]) + nn[2] * (cc[2] - mc[2]) < 0;
    } else if (f.kind === 'line') {
      visible = true;
    }
    return { pts, visible, normal, inward };
  }

  arrow(a, b, col) {
    const ctx = this.ctx, dx = b.x - a.x, dy = b.y - a.y, l = Math.hypot(dx, dy) || 1, ux = dx / l, uy = dy / l;
    const mx = a.x + dx * 0.5, my = a.y + dy * 0.5;
    ctx.fillStyle = col; ctx.beginPath(); ctx.moveTo(mx + ux * 6, my + uy * 6); ctx.lineTo(mx - ux * 4 - uy * 4, my - uy * 4 + ux * 4); ctx.lineTo(mx - ux * 4 + uy * 4, my - uy * 4 - ux * 4); ctx.fill();
  }

  drawGrid() {
    const ctx = this.ctx, c = this.c, R = this.R();
    const step = 16 * this.zoom;
    if (this.mode === 'edit') { this.drawAxes3D(); return; }
    const ox = c.width / 2 + this.pan[0], oy = c.height / 2 + this.pan[1];
    ctx.lineWidth = 1;
    const dark = getComputedStyle(document.body).getPropertyValue('--grid') || 'rgba(120,120,140,.18)';
    ctx.strokeStyle = dark;
    const f = step < 8 ? 4 : 1;
    for (let x = ox % (step * f); x < c.width; x += step * f) { ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, c.height); ctx.stroke(); }
    for (let y = oy % (step * f); y < c.height; y += step * f) { ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(c.width, y); ctx.stroke(); }
    ctx.strokeStyle = 'rgba(160,160,180,.5)';
    ctx.beginPath(); ctx.moveTo(ox, 0); ctx.lineTo(ox, c.height); ctx.moveTo(0, oy); ctx.lineTo(c.width, oy); ctx.stroke();
    // 127 / -128 limits
    ctx.strokeStyle = 'rgba(255,90,90,.35)'; ctx.setLineDash([4, 4]);
    ctx.strokeRect(ox - 128 * this.zoom, oy - 128 * this.zoom, 255 * this.zoom, 255 * this.zoom); ctx.setLineDash([]);
  }
  drawAxes3D() {
    const ctx = this.ctx, c = this.c, R = this.R();
    const m = this.app.model, cen = modelCenter(m);
    const ox = c.width / 2 + this.pan[0], oy = c.height / 2 + this.pan[1];
    const ax = [[1, 0, 0, '#ff6b6b', 'x'], [0, 1, 0, '#6bff8a', 'y'], [0, 0, 1, '#6bb0ff', 'z']];
    ctx.lineWidth = 1;
    for (const [x, y, z, col, name] of ax) {
      const X = R[0] * x + R[1] * y + R[2] * z, Y = R[3] * x + R[4] * y + R[5] * z;
      const s = -128 * this.zoom, e = 128 * this.zoom;
      // axes pass through model space origin: draw relative to the model centre offset
      const ocx = ox - (R[0] * cen[0] + R[1] * cen[1] + R[2] * cen[2]) * this.zoom, ocy = oy - (R[3] * cen[0] + R[4] * cen[1] + R[5] * cen[2]) * this.zoom;
      ctx.strokeStyle = col + '66'; ctx.beginPath(); ctx.moveTo(ocx + X * s, ocy + Y * s); ctx.lineTo(ocx + X * e, ocy + Y * e); ctx.stroke();
      ctx.fillStyle = col; ctx.font = '11px system-ui'; ctx.fillText(name, ocx + X * e + 3, ocy + Y * e + 3);
    }
  }
  drawGizmo() {
    const ctx = this.ctx, R = this.R(), ox = 38, oy = this.c.height - 38;
    ctx.font = '10px system-ui';
    for (const [x, y, z, col, name] of [[1, 0, 0, '#ff6b6b', '+X'], [0, 1, 0, '#6bff8a', '+Y'], [0, 0, 1, '#6bb0ff', '+Z']]) {
      const X = R[0] * x + R[1] * y + R[2] * z, Y = R[3] * x + R[4] * y + R[5] * z;
      ctx.strokeStyle = col; ctx.lineWidth = 2; ctx.beginPath(); ctx.moveTo(ox, oy); ctx.lineTo(ox + X * 26, oy + Y * 26); ctx.stroke();
      ctx.fillStyle = col; ctx.fillText(name, ox + X * 30 - 5, oy + Y * 30 + 4);
    }
  }

  // ----- ZX view ---------------------------------------------------------------------------------
  zxOptions(m) {
    const z = this.zx, P = ZX_PRESETS[z.preset];
    const shift = Math.max(0, m.scale - 1);
    let rad = 20; for (const v of vertices(m)) rad = Math.max(rad, Math.hypot(v.x, v.y, v.z));
    let tz = z.tz;
    if (z.auto || !tz) {
      tz = z.preset === 'station' ? 1500 : Math.round((rad * (1 << shift) * 256) / (0.42 * Math.min(P.w, P.h)) + rad * (1 << shift));
    }
    const engine = z.engineAuto ? P.engine : z.engine;
    return { matrix: matrixFromAngles(this.yaw, this.pitch, this.roll), pos: { x: 0, y: 0, z: tz }, w: P.w, h: P.h, cx: P.cx, cy: P.cy, engine, flicker: z.flicker, tz };
  }
  renderZXBitmap(m) { const o = this.zxOptions(m); return { o, r: renderZX(m, o) }; }
  drawZX(m) {
    const { o, r } = this.renderZXBitmap(m);
    this.lastZX = { o, r };
    const c = this.c, ctx = this.ctx;
    const S = Math.max(1, Math.min(Math.floor((c.width - 8) / o.w), Math.floor((c.height - 8) / o.h)));
    this.zxScale = S;
    const off = this.off; off.width = o.w; off.height = o.h;
    const octx = off.getContext('2d'), img = octx.createImageData(o.w, o.h);
    const col = this.zx.color, rr = parseInt(col.slice(1, 3), 16), gg = parseInt(col.slice(3, 5), 16), bb = parseInt(col.slice(5, 7), 16);
    for (let i = 0; i < o.w * o.h; i++) {
      const lit = r.bm.d[i] ? 0 : 1;
      img.data[i * 4] = lit ? rr : 0; img.data[i * 4 + 1] = lit ? gg : 0; img.data[i * 4 + 2] = lit ? bb : 0; img.data[i * 4 + 3] = 255;
    }
    octx.putImageData(img, 0, 0);
    ctx.fillStyle = '#202028'; ctx.fillRect(0, 0, c.width, c.height);
    const dx = Math.floor((c.width - o.w * S) / 2), dy = Math.floor((c.height - o.h * S) / 2);
    ctx.imageSmoothingEnabled = false;
    ctx.drawImage(off, dx, dy, o.w * S, o.h * S);
    ctx.strokeStyle = '#555'; ctx.strokeRect(dx - 0.5, dy - 0.5, o.w * S + 1, o.h * S + 1);
    this.zxRect = [dx, dy, S];
    ctx.fillStyle = '#9aa'; ctx.font = '11px system-ui'; ctx.textAlign = 'left';
    const vis = r.visible.filter((v, i) => v && m.faces[i].kind === 'poly').length;
    ctx.fillText(`${ZX_PRESETS[this.zx.preset].name}   distance Z=${o.tz}   x${S}   visible polygons ${vis}/${m.faces.filter((f) => f.kind === 'poly').length}`, 8, c.height - 8);
  }

  // thumbnail for the side panel
  drawThumb(canvas) {
    const m = this.app.model; if (!m) return;
    const o = { ...this.zxOptions(m) };
    const r = renderZX(m, o);
    canvas.width = o.w; canvas.height = o.h;
    const ctx = canvas.getContext('2d'), img = ctx.createImageData(o.w, o.h);
    const col = this.zx.color, rr = parseInt(col.slice(1, 3), 16), gg = parseInt(col.slice(3, 5), 16), bb = parseInt(col.slice(5, 7), 16);
    for (let i = 0; i < o.w * o.h; i++) { const lit = r.bm.d[i] ? 0 : 1; img.data[i * 4] = lit ? rr : 0; img.data[i * 4 + 1] = lit ? gg : 0; img.data[i * 4 + 2] = lit ? bb : 0; img.data[i * 4 + 3] = 255; }
    ctx.putImageData(img, 0, 0);
  }

  // ----- interaction -----------------------------------------------------------------------------
  pick(x, y, rad = 10) {
    let best = null, bd = rad * rad;
    this.scr.forEach((p, i) => { const d = (p.x - x) ** 2 + (p.y - y) ** 2; if (d < bd || (d === bd && best !== null && p.z < this.scr[best].z)) { bd = d; best = i; } });
    return best;
  }
  pickFace(x, y) {
    const m = this.app.model; let found = null;
    m.faces.forEach((f, i) => {
      if (f.kind !== 'poly') return;
      const fi = this.faceInfo(m, f, this.scr);
      if (!fi.pts || !fi.visible) return;
      let inside = false;
      for (let a = 0, b = fi.pts.length - 1; a < fi.pts.length; b = a++) {
        const p = fi.pts[a], q = fi.pts[b];
        if ((p.y > y) !== (q.y > y) && x < ((q.x - p.x) * (y - p.y)) / (q.y - p.y) + p.x) inside = !inside;
      }
      if (inside) found = i;
    });
    return found;
  }
  xy(e) { const r = this.c.getBoundingClientRect(); return [(e.clientX - r.left) * (this.c.width / r.width), (e.clientY - r.top) * (this.c.height / r.height)]; }

  _bind() {
    const c = this.c;
    c.addEventListener('mousedown', (e) => {
      const [x, y] = this.xy(e);
      c.focus();
      if (this.mode === 'zx') { this.drag = { type: 'orbit', x, y }; return; }
      const v = this.pick(x, y);
      if (this.app.adding && e.button === 0) { if (v !== null) this.app.addFaceClick(v); else this.app.addFaceClick(null); return; }
      if (e.button === 1 || e.button === 2 || (e.button === 0 && e.shiftKey)) { this.drag = { type: 'pan', x, y, p0: [...this.pan] }; e.preventDefault(); return; }
      if (v !== null) {
        this.app.selectVertex(v);
        if (this.mode in FIXED) { this.drag = { type: 'vertex', v, moved: false, before: this.app.beginEdit() }; }
        return;
      }
      const f = this.pickFace(x, y);
      if (f !== null) { this.app.selectFace(f); return; }
      this.app.clearSel();
      this.drag = this.mode === 'edit' ? { type: 'orbit', x, y } : { type: 'pan', x, y, p0: [...this.pan] };
    });
    window.addEventListener('mousemove', (e) => {
      const [x, y] = this.xy(e);
      this.mouse = [x, y];
      const d = this.drag;
      if (!d) {
        if (this.mode !== 'zx') { const h = this.pick(x, y); if (h !== this.hover) { this.hover = h; this.draw(); } else if (this.app.adding) this.draw(); }
        return;
      }
      if (d.type === 'orbit') { this.yaw += (x - d.x) * 0.01; this.pitch += (y - d.y) * 0.01; this.pitch = Math.max(-1.5, Math.min(1.5, this.pitch)); d.x = x; d.y = y; this.app.refresh(['view']); }
      else if (d.type === 'pan') { this.pan = [d.p0[0] + x - d.x, d.p0[1] + y - d.y]; this.draw(); }
      else if (d.type === 'vertex') {
        const m = this.app.model, vs = vertices(m), v = vs[d.v], g = m.groups[v.group];
        const w = this.unproject(x, y);
        const copyBit = ORDER.filter((n) => (g.mask >> n) & 1)[v.copy];
        const signs = { x: copyBit & 1 ? -1 : 1, y: copyBit & 2 ? -1 : 1, z: copyBit & 4 ? -1 : 1 };
        let changed = false;
        for (const [ax, val] of Object.entries(w)) {
          const nv = Math.max(-128, Math.min(127, Math.round(val * signs[ax])));
          if (g[ax] !== nv) { g[ax] = nv; changed = true; }
        }
        if (changed) { d.moved = true; this.app.refresh(['view', 'groups', 'thumb', 'validate'], true); }
      }
    });
    window.addEventListener('mouseup', () => {
      const d = this.drag; this.drag = null;
      if (d && d.type === 'vertex' && d.moved) this.app.endEdit(d.before, 'move vertex');
    });
    c.addEventListener('wheel', (e) => {
      e.preventDefault();
      const k = e.deltaY < 0 ? 1.12 : 1 / 1.12;
      if (this.mode === 'zx') { const o = this.zxOptions(this.app.model); this.zx.auto = false; this.zx.tz = Math.max(16, Math.round(o.tz / k)); this.app.refresh(['view', 'zxpanel']); }
      else { this.zoom = Math.max(0.2, Math.min(40, this.zoom * k)); this.draw(); }
    }, { passive: false });
    c.addEventListener('contextmenu', (e) => e.preventDefault());
    c.addEventListener('dblclick', () => { if (this.mode === 'edit' || this.mode in FIXED) { this.fitZoom(this.app.model); this.draw(); } });
  }
}
