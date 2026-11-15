// Awaken model editor: UI glue.
import { Workspace } from './store.js';
import { Viewport, ZX_PRESETS } from './views.js';
import { MIRRORS, MIRROR_OF, vertices, nverts, recordSize, serialize, ORDER, MAX_VERTS } from './format.js';
import { validate, BUDGET, BUDGET_NOTE } from './validate.js';
import { PATTERN_NAMES } from './zxrender.js';
import * as Ops from './ops.js';

const $ = (id) => document.getElementById(id);
const el = (tag, props = {}, ...kids) => {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(props)) {
    if (k === 'class') e.className = v; else if (k === 'text') e.textContent = v; else if (k.startsWith('on')) e.addEventListener(k.slice(2), v);
    else if (v !== undefined && v !== null && v !== false) e.setAttribute(k, v === true ? '' : v);
  }
  for (const kd of kids.flat()) if (kd !== null && kd !== undefined) e.append(kd.nodeType ? kd : document.createTextNode(kd));
  return e;
};

const app = {
  ws: new Workspace(),
  cur: null,
  sel: { vertex: null, face: null, group: null },
  adding: null,
  filter: '',
  autoWind: true,
  vp: null,
  get model() { return this.cur ? this.cur.model : null; },

  status(msg, kind = '') { const s = $('status'); s.textContent = msg; s.className = 'status ' + kind; },

  // ---- edit/undo ------------------------------------------------------------------------------
  beginEdit() { return this.cur.snapshot(); },
  endEdit(before, label) {
    if (this.cur.snapshot() === before) return;
    this.cur.undo.push(before); if (this.cur.undo.length > 300) this.cur.undo.shift();
    this.cur.redo.length = 0;
    this.refresh(['all']);
  },
  edit(label, fn) {
    const before = this.beginEdit();
    const r = fn(this.model);
    this.endEdit(before, label);
    return r;
  },
  undo() {
    if (!this.cur || !this.cur.undo.length) return;
    this.cur.redo.push(this.cur.snapshot());
    this.cur.model = JSON.parse(this.cur.undo.pop());
    this.fixSel(); this.refresh(['all']);
  },
  redo() {
    if (!this.cur || !this.cur.redo.length) return;
    this.cur.undo.push(this.cur.snapshot());
    this.cur.model = JSON.parse(this.cur.redo.pop());
    this.fixSel(); this.refresh(['all']);
  },
  fixSel() {
    const m = this.model; if (!m) return;
    const nv = nverts(m);
    if (this.sel.vertex !== null && this.sel.vertex >= nv) this.sel.vertex = null;
    if (this.sel.face !== null && this.sel.face >= m.faces.length) this.sel.face = null;
    if (this.sel.group !== null && this.sel.group >= m.groups.length) this.sel.group = null;
  },

  // ---- selection ------------------------------------------------------------------------------
  selectVertex(v) {
    this.sel.vertex = v; this.sel.group = v === null ? null : vertices(this.model)[v].group; this.sel.face = null;
    this.refresh(['view', 'groups', 'faces', 'hint']);
  },
  selectFace(f) { this.sel.face = f; this.sel.vertex = null; this.sel.group = null; this.refresh(['view', 'groups', 'faces', 'hint']); const r = document.querySelector(`.frow[data-i="${f}"]`); if (r) r.scrollIntoView({ block: 'nearest' }); },
  selectGroup(g) { this.sel.group = g; this.sel.face = null; this.sel.vertex = null; this.refresh(['view', 'groups', 'faces', 'hint']); },
  clearSel() { this.sel = { vertex: null, face: null, group: null }; this.refresh(['view', 'groups', 'faces', 'hint']); },

  // ---- add face by clicking vertices ----------------------------------------------------------
  startAdd(kind) {
    if (!this.model) return;
    this.adding = { kind, verts: [] };
    this.vp.setMode(this.vp.mode === 'zx' ? 'edit' : this.vp.mode); this.syncModeButtons();
    this.refresh(['view', 'hint']); $('view').focus();
  },
  addFaceClick(v) {
    const a = this.adding; if (!a || v === null) return;
    if (a.verts.length >= 3 && v === a.verts[0] && a.kind === 'poly') return this.finishAdd();
    if (a.verts.includes(v)) return;
    if (a.kind === 'poly' && a.verts.length >= 8) { this.status('a polygon has at most 8 corners', 'err'); return; }
    a.verts.push(v); this.refresh(['view']);
  },
  finishAdd() {
    const a = this.adding; if (!a) return;
    const min = a.kind === 'poly' ? 3 : 2;
    if (a.verts.length < min) { this.status(`need at least ${min} vertices`, 'err'); return; }
    this.adding = null;
    const hi = a.kind === 'poly' ? Number($('newPat')?.value ?? 2) : 9;
    let idx;
    this.edit('add face', (m) => {
      idx = Ops.addFace(m, a.kind, hi, a.verts);
      if (this.autoWind && a.kind === 'poly') {
        const before = JSON.stringify(m.faces[idx].v);
        const tmp = { ...m, faces: [m.faces[idx]] };
        if (Ops.autoWind(tmp)) this.status('winding flipped so that the face looks outwards', '');
      }
    });
    this.sel = { vertex: null, face: idx, group: null }; this.refresh(['all']);
  },
  cancelAdd() { if (this.adding) { this.adding = null; this.refresh(['view', 'hint']); } },

  // ---- refresh ---------------------------------------------------------------------------------
  refresh(parts = ['all'], soft = false) {
    const all = parts.includes('all');
    const has = (p) => all || parts.includes(p);
    if (has('list')) renderList();
    if (this.cur) {
      if (has('props')) renderProps();
      if (has('groups')) renderGroups();
      if (has('faces')) renderFaces();
      if (has('validate')) renderValidation();
      if (has('thumb')) this.vp.drawThumb($('thumb'));
      if (has('zxpanel') || has('viewbar')) renderViewBar();
      if (has('view')) this.vp.draw();
      if (has('hint')) renderHint();
    }
    updateButtons();
  },
};
window.app = app;

// =============================================================================================
// list
function modelInfo(e) {
  const errs = validate(e.model, e.kind).filter((x) => x.level === 'error').length;
  return { bytes: recordSize(e.model), nv: nverts(e.model), errs };
}
function renderList() {
  const box = $('list'); box.textContent = '';
  const q = app.filter.toLowerCase();
  for (const [kind, k] of Object.entries(app.ws.kinds)) {
    for (const sec of k.ix.sections) {
      const names = sec.models.filter((n) => !q || n.toLowerCase().includes(q));
      if (!names.length) continue;
      box.append(el('div', { class: 'lh', text: `${kind} / ${sec.name} (${names.length})` }));
      for (const n of names) {
        const e = k.entries.get(n); const inf = modelInfo(e);
        box.append(el('div', { class: 'li' + (app.cur === e ? ' on' : ''), 'data-name': n, onclick: () => openEntry(e) },
          el('span', { class: 'nm', text: n }),
          e.dirty ? el('span', { class: 'dot-d', text: '●', title: 'unsaved changes' }) : null,
          inf.errs ? el('span', { class: 'dot-e', text: '!', title: 'validation errors' }) : null,
          el('span', { class: 'meta', text: `${inf.nv}v ${inf.bytes}B` })));
      }
    }
  }
  const cnt = app.ws.dirtyCount;
  document.title = (cnt ? `* ` : '') + 'Awaken model editor';
}

function openEntry(e) {
  if (app.adding) app.cancelAdd();
  app.cur = e; app.sel = { vertex: null, face: null, group: null };
  app.vp.fitZoom(e.model); app.vp.pan = [0, 0]; app.vp.zx.auto = true; app.vp.zx.tz = 0;
  if (!$('zxEngineAuto')) { /* nothing */ }
  app.refresh(['all']);
}

// =============================================================================================
// model properties
function renderProps() {
  const m = app.model, box = $('model'); box.textContent = '';
  const e = app.cur;
  const kindTxt = `${e.kind}/${e.name}.txt  [${e.section}]`;
  box.append(
    el('div', { class: 'row' }, el('span', { class: 'code', text: kindTxt })),
    el('div', { class: 'row' }, el('label', { text: 'labels' }),
      el('input', { value: m.labels.join(' '), title: 'asm labels at the start of the record (first = main name, more = aliases); "-" = none', style: 'flex:1', onchange: (ev) => app.edit('labels', (mm) => { mm.labels = ev.target.value.trim().split(/\s+/).filter((x) => x && x !== '-'); }) })),
    el('div', { class: 'row' }, el('label', { text: 'radius' }),
      el('input', { type: 'number', min: 0, max: 255, value: m.radius, onchange: (ev) => app.edit('radius', (mm) => { mm.radius = Math.max(0, Math.min(255, +ev.target.value || 0)); }) }),
      el('button', { class: 'mini', text: 'auto', title: 'farthest vertex distance', onclick: () => app.edit('radius', (mm) => { mm.radius = Ops.autoRadius(mm); }) }),
      el('label', { text: 'scale', style: 'min-width:0;margin-left:8px' }),
      el('select', { onchange: (ev) => app.edit('scale', (mm) => { mm.scale = +ev.target.value; }) },
        [0, 1, 2, 3, 4, 5, 6].map((s) => el('option', { value: s, selected: s === m.scale, text: s }))),
      el('span', { class: 'v-info', text: `size shift ${Math.max(0, m.scale - 1)} bit` })),
    el('div', { class: 'row' }, el('label', { text: 'comment' }),
      el('input', { value: m.title, style: 'flex:1', title: 'first comment line of the file', onchange: (ev) => app.edit('comment', (mm) => { mm.title = ev.target.value; }) })),
  );
}

// =============================================================================================
// groups
function renderGroups() {
  const m = app.model, box = $('groups'); box.textContent = '';
  const nv = nverts(m);
  $('vcount').textContent = `${nv}/${MAX_VERTS} vertices`;
  const tb = el('table'), head = el('tr', {}, ...['#', 'verts', 'x', 'y', 'z', 'mirror', ''].map((t) => el('th', { text: t })));
  tb.append(head);
  let k = 0;
  m.groups.forEach((g, gi) => {
    const cnt = Ops.expandGroup(g).length;
    const mir = MIRROR_OF[g.mask];
    const num = (axis) => el('input', { type: 'number', min: -128, max: 127, value: g[axis], onchange: (ev) => app.edit('group ' + axis, (mm) => Ops.setGroupCoord(mm, gi, axis, +ev.target.value)) });
    const sel = el('select', { title: 'copies: all sign combinations of the named axes', onchange: (ev) => {
      const v = ev.target.value;
      if (v === 'mask') { const t = prompt('mask (1..255, e.g. 0x0F): bit n makes the copy with x negated if n&1, y if n&2, z if n&4', '0x' + g.mask.toString(16).toUpperCase().padStart(2, '0')); if (t === null) return renderGroups(); const mk = Number(t); if (!(mk >= 1 && mk <= 255)) return renderGroups(); doMask(gi, mk); }
      else doMask(gi, MIRRORS[v]);
    } }, [...Object.keys(MIRRORS), 'mask'].map((o) => el('option', { value: o, selected: mir ? o === mir : o === 'mask', text: o === 'mask' ? (mir ? 'custom mask...' : '0x' + g.mask.toString(16).toUpperCase().padStart(2, '0')) : o })));
    const tr = el('tr', { class: app.sel.group === gi ? 'sel' : '', onclick: (ev) => { if (ev.target.tagName === 'TR' || ev.target.tagName === 'TD') app.selectGroup(gi); } },
      el('td', { text: gi }), el('td', { text: cnt > 1 ? `${k}..${k + cnt - 1}` : String(k), class: 'v-info' }),
      el('td', {}, num('x')), el('td', {}, num('y')), el('td', {}, num('z')), el('td', {}, sel),
      el('td', {}, el('button', { class: 'mini', text: '▲', title: 'move up (renumbers vertices, faces follow)', onclick: () => { let j = gi; app.edit('move group', (mm) => { j = Ops.moveGroup(mm, gi, -1); }); app.sel.group = j; app.refresh(['all']); } }),
        el('button', { class: 'mini', text: '▼', onclick: () => { let j = gi; app.edit('move group', (mm) => { j = Ops.moveGroup(mm, gi, 1); }); app.sel.group = j; app.refresh(['all']); } }),
        el('button', { class: 'mini', text: '✕', title: 'delete group', onclick: () => delGroup(gi) })));
    tr.addEventListener('click', () => app.selectGroup(gi));
    tb.append(tr);
    k += cnt;
  });
  box.append(tb, el('div', { class: 'row' },
    el('button', { text: '+ group', onclick: () => { let gi; app.edit('add group', (mm) => { gi = Ops.addGroup(mm, {}); }); app.selectGroup(gi); } }),
    app.sel.vertex !== null ? el('span', { class: 'v-info', text: vinfo() }) : null));
}
function vinfo() {
  const v = vertices(app.model)[app.sel.vertex]; if (!v) return '';
  return `v${app.sel.vertex}: group ${v.group}, copy ${v.copy} at (${v.x}, ${v.y}, ${v.z})`;
}
function doMask(gi, mask) {
  let dropped = 0;
  app.edit('mirror', (mm) => { dropped = Ops.setGroupMask(mm, gi, mask); });
  if (dropped) app.status(`${dropped} face corner(s) pointed at vanished vertices and were removed`, 'err');
}
function delGroup(gi) {
  const m = app.model, vs = vertices(m);
  const gv = new Set(vs.map((v, i) => (v.group === gi ? i : -1)).filter((i) => i >= 0));
  const users = m.faces.filter((f) => f.v.some((v) => gv.has(v))).length;
  if (users && !confirm(`Group ${gi} is used by ${users} face(s); their corners will be removed. Delete it?`)) return;
  let dropped = 0;
  app.edit('delete group', (mm) => { dropped = Ops.removeGroup(mm, gi); });
  app.sel = { vertex: null, face: null, group: null }; app.refresh(['all']);
  if (dropped) app.status(`${dropped} corner(s) removed from faces`, 'err');
}

// =============================================================================================
// faces
const LINE_MODES = ['AND (lit line)', 'OR (dark line)', 'XOR', 'XOR'];
function renderFaces() {
  const m = app.model, box = $('faces'); box.textContent = '';
  $('fcount').textContent = `${m.faces.length}`;
  box.append(el('div', { class: 'row' },
    el('button', { text: '+ polygon', title: 'click vertices in order in the view', onclick: () => app.startAdd('poly') }),
    el('button', { text: '+ line', onclick: () => app.startAdd('line') }),
    el('label', { text: 'fill', style: 'min-width:0' }),
    el('select', { id: 'newPat' }, PATTERN_NAMES.slice(0, 5).map((n, i) => el('option', { value: i, text: n, selected: i === (app.lastPat ?? 2) }))),
    el('label', { style: 'min-width:0' }, el('input', { type: 'checkbox', checked: app.autoWind, onchange: (ev) => { app.autoWind = ev.target.checked; } }), ' auto-wind'),
  ));
  $('newPat') && ($('newPat').onchange = (ev) => { app.lastPat = +ev.target.value; });
  m.faces.forEach((f, i) => {
    const row = el('div', { class: 'frow' + (app.sel.face === i ? ' sel' : ''), 'data-i': i, onclick: (ev) => { if (!['INPUT', 'SELECT', 'BUTTON', 'OPTION'].includes(ev.target.tagName)) app.selectFace(i); } });
    const ctl = el('div', { class: 'row', style: 'margin:0' });
    if (f.kind === 'poly') {
      ctl.append(el('span', { text: 'poly' }), el('select', { title: 'fill pattern', onchange: (ev) => app.edit('pattern', (mm) => { mm.faces[i].hi = +ev.target.value; }) },
        PATTERN_NAMES.map((n, p) => el('option', { value: p, selected: p === f.hi, text: n }))));
    } else {
      ctl.append(el('span', { text: 'line' }), el('select', { title: 'drawing mode (face byte bits 4-5)', onchange: (ev) => app.edit('line mode', (mm) => { mm.faces[i].hi = (mm.faces[i].hi & 4) | 8 | +ev.target.value; }) },
        [0, 1, 2, 3].map((p) => el('option', { value: p, selected: p === (f.hi & 3), text: LINE_MODES[p] + (p === 3 ? ' (alias)' : '') }))),
        el('label', { title: 'face byte bit 6: draw only if the previous polygon is visible', style: 'min-width:0' }, el('input', { type: 'checkbox', checked: !!(f.hi & 4), onchange: (ev) => app.edit('line flag', (mm) => { mm.faces[i].hi = ev.target.checked ? mm.faces[i].hi | 4 : mm.faces[i].hi & ~4; }) }), ' if prev. visible'));
    }
    ctl.append(...[
      el('button', { class: 'mini', title: 'move up (faces are drawn in this order)', text: '▲', onclick: () => { let j = i; app.edit('move face', (mm) => { j = Ops.moveFace(mm, i, -1); }); app.sel.face = j; app.refresh(['all']); } }),
      el('button', { class: 'mini', text: '▼', onclick: () => { let j = i; app.edit('move face', (mm) => { j = Ops.moveFace(mm, i, 1); }); app.sel.face = j; app.refresh(['all']); } }),
      f.kind === 'poly' ? el('button', { class: 'mini', text: 'flip', title: 'reverse the winding', onclick: () => app.edit('flip', (mm) => Ops.flipFace(mm, i)) }) : null,
      el('button', { class: 'mini', text: '✕', title: 'delete face', onclick: () => delFace(i) })].filter(Boolean));
    const vin = el('input', { class: 'v', value: f.v.join(' '), title: 'vertex numbers, in drawing order (poly 3..8; clockwise seen from outside = visible)',
      onchange: (ev) => { const nv = ev.target.value.trim().split(/[\s,]+/).filter(Boolean).map(Number); if (nv.some((x) => !Number.isInteger(x) || x < 0)) { renderFaces(); return; } app.edit('face vertices', (mm) => { mm.faces[i].v = nv; }); } });
    const labs = el('div', { class: 'row', style: 'margin:0' },
      ...f.labels.map((l) => el('span', { class: 'lab', text: l, title: 'runtime-patched face: the code writes into this face byte; the label stays attached when you reorder' })),
      el('input', { placeholder: '+label', style: 'width:70px', title: 'add an assembler label to this face (the game code patches the face byte through it)', onchange: (ev) => { const t = ev.target.value.trim(); if (!t) return; app.edit('face label', (mm) => { mm.faces[i].labels.push(t); }); } }),
      f.labels.length ? el('button', { class: 'mini', text: 'clear labels', onclick: () => { if (confirm('The game code may reference these labels; removing them breaks the build if it does.')) app.edit('labels', (mm) => { mm.faces[i].labels = []; }); } }) : null);
    row.append(el('div', { class: 'fn', text: '#' + i }), el('div', {}, ctl, el('div', { class: 'row', style: 'margin:0' }, vin), f.labels.length || true ? labs : null));
    box.append(row);
  });
}
function delFace(i) {
  const f = app.model.faces[i];
  if (f.labels.length && !confirm(`Face ${i} carries the label(s) ${f.labels.join(', ')} that the game code patches; deleting it breaks the build if the code uses them. Delete?`)) return;
  app.edit('delete face', (mm) => Ops.removeFace(mm, i));
  app.sel.face = null; app.refresh(['all']);
}

// =============================================================================================
// validation
function renderValidation() {
  const m = app.model, e = app.cur, box = $('valid'); box.textContent = '';
  const res = validate(m, e.kind);
  const errs = res.filter((x) => x.level === 'error').length, warns = res.filter((x) => x.level === 'warn').length;
  $('vstat').textContent = `${errs} errors, ${warns} warnings`;
  $('vstat').className = errs ? 'v-error' : warns ? 'v-warn' : '';
  // sizes
  const rec = recordSize(m);
  const entries = [...app.ws.kinds[e.kind].entries.values()];
  const total = entries.reduce((a, en) => a + recordSize(en.model), 0), budget = BUDGET[e.kind];
  const pct = Math.min(100, (100 * total) / budget);
  box.append(
    el('div', { class: 'row' }, el('span', { text: `record ${rec} bytes` + (e.kind === 'flight' ? ` of 256 (OBJBUF)` : '') }), el('span', { class: 'v-info', text: `${nverts(m)} vertices, ${m.faces.length} faces` })),
    el('div', { class: 'row', style: 'margin-bottom:0' }, el('span', { text: `${e.kind} models total: ${total} of ${budget} bytes (${budget - total} free)`, class: total > budget ? 'v-error' : '' })),
    el('div', { class: 'bar' + (total > budget ? ' over' : '') }, el('i', { style: `width:${pct}%` })),
    el('div', { class: 'note', text: BUDGET_NOTE[e.kind] }));
  if (!res.length) box.append(el('div', { class: 'v-info', text: 'no problems found' }));
  for (const r of res) {
    box.append(el('div', { class: 'it v-' + r.level, onclick: () => { if (r.face !== undefined) app.selectFace(r.face); else if (r.vertex !== undefined) app.selectVertex(r.vertex); } }, `${r.level === 'error' ? '✖' : r.level === 'warn' ? '⚠' : 'ℹ'} ${r.msg}`));
  }
  if (res.some((r) => r.flip)) box.append(el('button', { text: 'Flip all inward faces', onclick: () => { let n = 0; app.edit('auto-wind', (mm) => { n = Ops.autoWind(mm); }); app.status(`${n} faces flipped`); } }));
}

// =============================================================================================
// view bar / hint
function renderViewBar() {
  const bar = $('viewbar'), vp = app.vp; bar.textContent = '';
  const chk = (label, get, set) => el('label', {}, el('input', { type: 'checkbox', checked: get(), onchange: (ev) => { set(ev.target.checked); vp.draw(); } }), label);
  if (vp.mode === 'zx') {
    const z = vp.zx;
    bar.append(
      el('select', { onchange: (ev) => { z.preset = ev.target.value; z.auto = true; z.tz = 0; app.refresh(['view', 'thumb', 'viewbar']); } }, Object.entries(ZX_PRESETS).map(([k, p]) => el('option', { value: k, selected: z.preset === k, text: p.name }))),
      el('label', {}, 'Z distance ', el('input', { type: 'number', value: vp.zxOptions(app.model).tz, step: 50, style: 'width:70px', onchange: (ev) => { z.auto = false; z.tz = +ev.target.value; app.refresh(['view', 'thumb']); } }),
        el('button', { class: 'mini', text: 'fit', onclick: () => { z.auto = true; z.tz = 0; app.refresh(['view', 'thumb', 'viewbar']); } })),
      el('label', {}, 'patterns 5-7: ', el('select', { onchange: (ev) => { z.engineAuto = ev.target.value === 'auto'; if (!z.engineAuto) z.engine = ev.target.value; app.refresh(['view', 'thumb']); } },
        [['auto', 'by window'], ['flight', 'flight image'], ['station', 'station overlay']].map(([v, t]) => el('option', { value: v, text: t, selected: (z.engineAuto ? 'auto' : z.engine) === v })))),
      chk('flicker (MERZ)', () => z.flicker, (v) => { z.flicker = v; app.refresh(['view', 'thumb']); }),
      chk('spin', () => z.spin, (v) => { z.spin = v; }),
      el('input', { type: 'color', value: z.color, title: 'lit pixel colour', onchange: (ev) => { z.color = ev.target.value; app.refresh(['view', 'thumb']); } }));
  } else {
    bar.append(chk('fill', () => vp.opt.fill, (v) => { vp.opt.fill = v; }), chk('normals', () => vp.opt.normals, (v) => { vp.opt.normals = v; }),
      chk('numbers', () => vp.opt.numbers, (v) => { vp.opt.numbers = v; }), chk('hidden faces', () => vp.opt.hidden, (v) => { vp.opt.hidden = v; }), chk('grid', () => vp.opt.grid, (v) => { vp.opt.grid = v; }),
      el('button', { text: 'fit', onclick: () => { vp.fitZoom(app.model); vp.draw(); } }));
  }
}
function renderHint() {
  const m = app.vp.mode;
  let t = '';
  if (app.adding) t = 'Click vertices in drawing order (clockwise seen from outside = visible). Click the first vertex again or press Enter to finish, Esc cancels.';
  else if (m === 'zx') t = 'ZX view = what the game draws: drag = rotate, wheel = distance, culling and fill patterns as in src/flight 3D-II. Edit in the other tabs.';
  else if (m === 'edit') t = 'Drag = orbit, Shift/right-drag = pan, wheel = zoom, double-click = fit. Click a vertex or face to select. Green arrow = outward normal (red = points inward). Hidden (back) faces are dashed.';
  else t = 'Drag a vertex to move it (integer snap, -128..127; mirrored copies follow). Arrow keys nudge the selected vertex. Drag empty space = pan, wheel = zoom.';
  $('hint').textContent = t + (app.sel.vertex !== null ? '   |   ' + vinfo() : '');
}
function updateButtons() {
  $('btnUndo').disabled = !app.cur || !app.cur.undo.length;
  $('btnRedo').disabled = !app.cur || !app.cur.redo.length;
  const n = app.ws.dirtyCount;
  $('btnSave').textContent = n ? `Save (${n})` : 'Save';
  $('btnSave').disabled = !app.ws.loaded || !n;
  for (const id of ['btnNew']) $(id).disabled = !app.ws.loaded;
  for (const id of ['btnDup', 'btnDel']) $(id).disabled = !app.cur;
}
app.syncModeButtons = () => { for (const b of document.querySelectorAll('#modes button')) b.classList.toggle('on', b.dataset.mode === app.vp.mode); };

// =============================================================================================
// actions
async function loadDone(how) {
  app.cur = null; app.sel = { vertex: null, face: null, group: null };
  const first = app.ws.allEntries()[0];
  app.refresh(['list']);
  if (first) openEntry(first);
  app.status(how);
}
$('btnOpen').onclick = async () => {
  try { const n = await app.ws.openDirectory(); await loadDone(`opened folder "${n}": ${app.ws.allEntries().length} models; Save writes into it`); }
  catch (e) { if (e.name !== 'AbortError') app.status(e.message, 'err'); }
};
$('fileInput').onchange = async (ev) => {
  try { await app.ws.loadFiles(ev.target.files); await loadDone(`${app.ws.allEntries().length} models loaded from files; Save downloads the changed files`); }
  catch (e) { app.status(e.message, 'err'); }
};
$('btnFiles').onclick = () => { $('fileInput').setAttribute('webkitdirectory', ''); $('fileInput').value = ''; $('fileInput').click(); };
$('btnSave').onclick = save;
async function save() {
  if (!app.ws.loaded) return;
  const bad = app.ws.allEntries().filter((e) => e.dirty && validate(e.model, e.kind).some((x) => x.level === 'error'));
  if (bad.length && !confirm(`These models have validation errors and the build will fail:\n${bad.map((e) => e.name).join(', ')}\nSave anyway?`)) return;
  try {
    const r = await app.ws.save();
    app.status(r.how === 'folder' ? `saved ${r.written} file(s)` + (r.deleted ? `, deleted ${r.deleted}` : '') + '. Next: python build.py' : `saved ${r.written} file(s) (${r.how}). Next: python build.py` + (r.deletedNames?.length ? ` (delete ${r.deletedNames.map((d) => d.kind + '/' + d.name + '.txt').join(', ')} yourself)` : ''), '');
    app.refresh(['list']); updateButtons();
  } catch (e) { app.status('save failed: ' + e.message, 'err'); }
}
$('btnUndo').onclick = () => app.undo();
$('btnRedo').onclick = () => app.redo();
for (const b of document.querySelectorAll('#modes button')) b.onclick = () => { app.vp.setMode(b.dataset.mode); app.syncModeButtons(); app.refresh(['viewbar', 'hint', 'view']); };
$('search').oninput = (ev) => { app.filter = ev.target.value; renderList(); };

// new / duplicate / delete
function info(html) { $('infoBody').innerHTML = html; $('dlgInfo').showModal(); }
$('infoOk').onclick = () => $('dlgInfo').close();
const REF_HELP = {
  flight: 'src/flight/3DTABS.asm (the object index table "L97": <code>dw far-model, near-model</code> per object index) and the code that spawns the object (src/flight/OBJGENER.asm, BRAINPRO.asm).',
  station: 'src/station/DATA3D.asm (the viewer table "L97": <code>dw model,model</code> per entry) and the ship list in src/station/BODY3D.asm / OBR.asm.',
};
$('btnNew').onclick = () => {
  $('newKind').textContent = ''; for (const k of Object.keys(app.ws.kinds)) $('newKind').append(el('option', { value: k, text: k, selected: app.cur?.kind === k }));
  const fillSec = () => { $('newSection').textContent = ''; for (const s of app.ws.sectionsOf($('newKind').value)) $('newSection').append(el('option', { value: s, text: s })); const o = $('newSection').options; if (o.length) o[o.length - 1].selected = true;
    $('newNote').innerHTML = `The new model is appended to the chosen section of index.txt (the memory order). <b>The game code does not know it yet</b>: after saving add a reference to its label in ${REF_HELP[$('newKind').value]} The size budget is shown in the Validation panel.`; };
  $('newKind').onchange = fillSec; fillSec();
  $('newName').value = ''; $('dlgNew').showModal();
};
$('newCancel').onclick = () => $('dlgNew').close();
$('newForm').onsubmit = (ev) => {
  ev.preventDefault();
  try {
    const name = $('newName').value.trim(), kind = $('newKind').value, sec = $('newSection').value, from = $('newFrom').value;
    let model;
    if (from === 'copy' && app.cur) { const d = Ops.duplicateModel(app.model, name); model = d.model; }
    else if (from === 'empty') model = Ops.ensureIds({ title: `${name} (new model)`, labels: [name], radius: 0, scale: 2, groups: [], faces: [], endLabels: [] });
    else model = Ops.templateModel(name);
    const e = app.ws.addEntry(kind, name, sec, model);
    $('dlgNew').close(); app.refresh(['list']); openEntry(e);
    app.status(`model ${name} added to ${kind}/index.txt [${sec}] - save, then reference its label in the code`);
    info(`<h3>Model ${name} created</h3><p>It is in the list and will be written to <code>${kind}/${name}.txt</code> and <code>${kind}/index.txt</code> [${sec}] when you save.</p><p><b>The game code does not know the model yet.</b> Add a reference to the label <code>${name}</code> in ${REF_HELP[kind]}</p><p>Free memory: see the Validation panel (${BUDGET_NOTE[kind]}).</p>`);
  } catch (e) { alert(e.message); }
};
$('btnDup').onclick = () => {
  const e = app.cur; if (!e) return;
  const name = prompt('Name of the copy (an assembler label):', e.name + '_copy'); if (!name) return;
  try {
    const { model, lostLabels } = Ops.duplicateModel(e.model, name);
    const ne = app.ws.addEntry(e.kind, name, e.section, model);
    app.refresh(['list']); openEntry(ne);
    app.status(`duplicated as ${name}` + (lostLabels ? ` (${lostLabels} runtime-patch face label(s) not copied: labels must be unique)` : ''));
  } catch (err) { alert(err.message); }
};
$('btnDel').onclick = async () => {
  const e = app.cur; if (!e) return;
  const labels = [e.model.labels, ...e.model.faces.map((f) => f.labels)].flat();
  let refs = '';
  try {
    const r = await fetch(`api/refs?name=${encodeURIComponent(e.name)}`); if (r.ok) { const j = await r.json(); refs = j.refs.length ? `\n\nReferenced in the source (${j.refs.length}):\n` + j.refs.slice(0, 12).join('\n') : '\n\nNo reference to this name found in src/.'; }
  } catch { /* static server without api */ }
  if (!confirm(`Delete model ${e.kind}/${e.name}?\n\nIt is removed from index.txt and its file is deleted on Save. The game code that refers to its label(s) (${labels.join(', ') || 'none'}) will no longer assemble.${refs}`)) return;
  app.ws.removeEntry(e.kind, e.name); app.cur = null;
  const first = app.ws.allEntries()[0];
  app.refresh(['list']); if (first) openEntry(first);
  app.status(`${e.name} deleted (written on Save)`);
};

// keyboard
window.addEventListener('keydown', (ev) => {
  const tag = ev.target.tagName;
  const typing = tag === 'INPUT' || tag === 'SELECT' || tag === 'TEXTAREA';
  if (ev.ctrlKey && ev.key.toLowerCase() === 's') { ev.preventDefault(); save(); return; }
  if (ev.ctrlKey && ev.key.toLowerCase() === 'z' && !typing) { ev.preventDefault(); app.undo(); return; }
  if (ev.ctrlKey && (ev.key.toLowerCase() === 'y' || (ev.shiftKey && ev.key.toLowerCase() === 'z')) && !typing) { ev.preventDefault(); app.redo(); return; }
  if (typing) return;
  if (ev.key === 'Escape') app.cancelAdd();
  else if (ev.key === 'Enter' && app.adding) app.finishAdd();
  else if (ev.key === 'Delete' && app.cur) { if (app.sel.face !== null) delFace(app.sel.face); else if (app.sel.group !== null) delGroup(app.sel.group); }
  else if (ev.key.startsWith('Arrow') && app.sel.vertex !== null && app.vp.mode in { front: 1, side: 1, top: 1 }) {
    ev.preventDefault();
    const ax = { front: ['x', 'y'], side: ['z', 'y'], top: ['x', 'z'] }[app.vp.mode];
    const v = vertices(app.model)[app.sel.vertex], g = app.model.groups[v.group];
    const bit = ORDER.filter((n) => (g.mask >> n) & 1)[v.copy];
    const sg = { x: bit & 1 ? -1 : 1, y: bit & 2 ? -1 : 1, z: bit & 4 ? -1 : 1 };
    const d = { ArrowLeft: [-1, 0], ArrowRight: [1, 0], ArrowUp: [0, -1], ArrowDown: [0, 1] }[ev.key];
    app.edit('nudge', (mm) => { const gg = mm.groups[v.group]; gg[ax[0]] = Ops.clamp8(gg[ax[0]] + d[0] * sg[ax[0]]); gg[ax[1]] = Ops.clamp8(gg[ax[1]] + d[1] * sg[ax[1]]); });
  }
});
window.addEventListener('beforeunload', (ev) => { if (app.ws.dirtyCount) { ev.preventDefault(); ev.returnValue = ''; } });

// spin animation for the ZX view
let last = 0;
function tick(t) {
  const vp = app.vp;
  if (vp.mode === 'zx' && vp.zx.spin && app.cur && t - last > 60) { vp.yaw += 0.05; vp.pitch = 0.35; last = t; vp.draw(); vp.drawThumb($('thumb')); }
  requestAnimationFrame(tick);
}

// init
function resize() {
  const c = $('view'), r = c.getBoundingClientRect();
  if (r.width > 50 && (c.width !== Math.round(r.width) || c.height !== Math.round(r.height))) { c.width = Math.round(r.width); c.height = Math.round(r.height); if (app.cur) app.vp.draw(); }
}
app.vp = new Viewport($('view'), app);
window.addEventListener('resize', resize);
new ResizeObserver(resize).observe($('center'));
requestAnimationFrame(tick);
(async () => {
  resize();
  updateButtons();
  try {
    const r = await fetch('models/flight/index.txt', { cache: 'no-store' });
    if (r.ok) { await app.ws.loadHttp('models/'); await loadDone(`loaded ${app.ws.allEntries().length} models from the server; Save writes through the server (or use Open folder)`); return; }
  } catch { /* not served by serve.py */ }
  app.status('Open the assets/models folder (Open folder) to start');
  $('hint').textContent = 'Open folder: pick the repository folder, assets or assets/models (Chrome / Edge). Without folder access use Open files and Save downloads the changed files.';
})();
