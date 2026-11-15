// Model text format <-> model object <-> binary record.  Mirrors tools/assets/models.py (the reference) exactly.
// model = {title, labels:[], radius, scale, groups:[{mask,x,y,z}], faces:[{labels:[], kind:'poly'|'line', hi, v:[]}], endLabels:[]}
// hi: poly = fill pattern 0..7 ; line = flags 8..15 (bit 6 of the face byte = "only if previous polygon visible", bits 4-5 = AND/OR/XOR)

export const ORDER = [0, 1, 3, 2, 6, 7, 5, 4];
export const MIRRORS = { none: 0x01, x: 0x03, y: 0x05, z: 0x11, xy: 0x0F, xz: 0x33, yz: 0x55, xyz: 0xFF };
export const MIRROR_OF = Object.fromEntries(Object.entries(MIRRORS).map(([k, v]) => [v, k]));
export const MAX_VERTS = 51;          // L9C screen-vertex buffer: one 256-byte page of 5-byte slots; the reference is slot*5 in one byte
export const MAX_RECORD_FLIGHT = 256; // OBJBUF (flight copy buffer) is #100 bytes
export const MAX_CORNERS = 8;

const num = (s) => {
  if (s === undefined || !/^[+-]?(0[xX][0-9a-fA-F]+|\d+)$/.test(s)) throw new Error('number expected, got ' + s);
  return Number(s);
};

export function expandGroup(g) {
  const out = [];
  for (const n of ORDER) if ((g.mask >> n) & 1) out.push([n & 1 ? -g.x : g.x, n & 2 ? -g.y : g.y, n & 4 ? -g.z : g.z]);
  return out;
}

// all vertices in vertex-number order; each: {x,y,z,group,copy}
export function vertices(m) {
  const vs = [];
  m.groups.forEach((g, gi) => expandGroup(g).forEach((p, ci) => vs.push({ x: p[0], y: p[1], z: p[2], group: gi, copy: ci })));
  return vs;
}
export const nverts = (m) => m.groups.reduce((a, g) => a + expandGroup(g).length, 0);

export function parse(text, where = 'model') {
  const m = { title: '', labels: [], radius: null, scale: null, groups: [], faces: [], endLabels: [] };
  let pending = [];
  let seenModel = false;
  const lines = text.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i].replace(/\r$/, '');
    if (!seenModel && /^#\s?/.test(raw) && !m.title && raw.length > 2) m.title = raw.replace(/^#\s?/, '');
    const l = raw.split('#')[0].trim();
    if (!l) continue;
    const w = l.split(/\s+/);
    const k = w[0];
    try {
      if (k === 'model') { seenModel = true; m.labels = (w.length === 2 && w[1] === '-') ? [] : w.slice(1); }
      else if (k === 'radius') m.radius = num(w[1]);
      else if (k === 'scale') m.scale = num(w[1]);
      else if (k === 'group') {
        const [x, y, z] = [num(w[1]), num(w[2]), num(w[3])];
        if (![x, y, z].every((a) => a >= -128 && a <= 127)) throw new Error('coordinates must be -128..127');
        const s = w[4];
        let mask;
        if (s && s.startsWith('mirror=')) { mask = MIRRORS[s.slice(7)]; if (mask === undefined) throw new Error('bad mirror ' + s); }
        else if (s && s.startsWith('mask=')) mask = num(s.slice(5));
        else throw new Error('mirror=... or mask=... expected');
        if (!(mask >= 1 && mask <= 255)) throw new Error('mask must be 1..255');
        m.groups.push({ mask, x, y, z });
      } else if (k === 'label') pending.push(w[1]);
      else if (k === 'poly' || k === 'line') {
        const hi = num(w[1]);
        const v = w.slice(2).map(num);
        if (k === 'poly' && !(hi >= 0 && hi <= 7)) throw new Error('poly fill pattern must be 0..7');
        if (k === 'line' && !(hi >= 8 && hi <= 15)) throw new Error('line flags must be 8..15');
        if (!(v.length >= 2 && v.length <= 15)) throw new Error('a face needs 2..15 vertices');
        m.faces.push({ labels: pending, kind: k, hi, v });
        pending = [];
      } else throw new Error('unknown keyword ' + k);
    } catch (e) { throw new Error(`${where} line ${i + 1}: ${e.message}`); }
  }
  m.endLabels = pending;
  if (m.radius === null || m.scale === null) throw new Error(`${where}: radius and scale are required`);
  return m;
}

// same text as models.to_text(m, title)
export function serialize(m) {
  const out = [];
  if (m.title) out.push('# ' + m.title);
  out.push('model ' + (m.labels.length ? m.labels.join(' ') : '-'));
  out.push('radius ' + m.radius);
  out.push('scale ' + m.scale);
  out.push('# group x y z mirror   -> vertex numbers (copies of the point, see tools/assets/models.py)');
  let k = 0;
  for (const g of m.groups) {
    const cnt = expandGroup(g).length;
    const spec = g.mask in MIRROR_OF ? 'mirror=' + MIRROR_OF[g.mask] : 'mask=0x' + g.mask.toString(16).toUpperCase().padStart(2, '0');
    out.push(`group ${g.x} ${g.y} ${g.z} ${spec}        # v${k}${cnt > 1 ? '..v' + (k + cnt - 1) : ''}`);
    k += cnt;
  }
  out.push('# faces: poly <fill 0..7> <vertex numbers>   |   line <flags 8..15> <vertex numbers>');
  for (const f of m.faces) {
    for (const l of f.labels) out.push('label ' + l);
    out.push(`${f.kind} ${f.hi} ${f.v.join(' ')}`);
  }
  for (const l of m.endLabels) out.push('label ' + l);
  return out.join('\n') + '\n';
}

export const faceByte = (f) => (f.hi << 4) | f.v.length;

export function toBytes(m) {
  const b = [m.radius & 255, m.scale & 255];
  for (const g of m.groups) b.push(g.mask, g.x & 255, g.y & 255, g.z & 255);
  b.push(0);
  for (const f of m.faces) { b.push(faceByte(f)); for (const v of f.v) b.push(v * 5); }
  b.push(0);
  return Uint8Array.from(b);
}
export const recordSize = (m) => 2 + 4 * m.groups.length + 1 + m.faces.reduce((a, f) => a + 1 + f.v.length, 0) + 1;

// gen_models.py include text for one model (labels + db lines)
export function toInc(m) {
  const L = [];
  for (const l of m.labels) L.push(l + ':');
  L.push(`            db   ${m.radius},${m.scale}`);
  const h = (v) => '#' + (v & 255).toString(16).toUpperCase().padStart(2, '0');
  for (const g of m.groups) L.push(`            db   ${h(g.mask)},${h(g.x)},${h(g.y)},${h(g.z)}`);
  L.push('            db   0');
  for (const f of m.faces) {
    for (const l of f.labels) L.push(l + ':');
    L.push(`            db   ${h(faceByte(f))},` + f.v.map((v) => v * 5).join(','));
  }
  for (const l of m.endLabels) L.push(l + ':');
  L.push('            db   0');
  return L;
}

// index.txt: header comment lines kept, sections [{name, models:[...]}]
export function parseIndex(text) {
  const secs = []; let cur = null; const header = [];
  for (const raw of text.split('\n')) {
    const l = raw.split('#')[0].trim();
    if (!l) { if (!secs.length && raw.startsWith('#')) header.push(raw); continue; }
    const mm = /^\[(\w+)\]$/.exec(l);
    if (mm) { cur = { name: mm[1], models: [] }; secs.push(cur); }
    else if (!cur) throw new Error('index.txt: a [SECTION] line is expected first');
    else cur.models.push(l);
  }
  return { header, sections: secs };
}
export function serializeIndex(ix) {
  let s = ix.header.length ? ix.header.join('\n') + '\n' : '';
  for (const sec of ix.sections) s += `\n[${sec.name}]\n` + sec.models.join('\n') + '\n';
  return s;
}

// parse "db" lines of a generated .inc -> {bytes:[...], labels:{name:offset}}
export function parseInc(text) {
  const bytes = []; const labels = {};
  for (const raw of text.split('\n')) {
    const l = raw.split(';')[0].trim();
    if (!l) continue;
    let mm = /^(\w+):$/.exec(l);
    if (mm) { labels[mm[1]] = bytes.length; continue; }
    mm = /^db\s+(.*)$/i.exec(l);
    if (!mm) throw new Error('unexpected line ' + l);
    for (const t of mm[1].split(',')) { const s = t.trim(); bytes.push(s.startsWith('#') ? parseInt(s.slice(1), 16) : parseInt(s, 10)); }
  }
  return { bytes, labels };
}
