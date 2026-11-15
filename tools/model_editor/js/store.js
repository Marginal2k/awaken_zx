// Workspace: the model files, loading (File System Access API folder / http from serve.py / file list) and saving.
import { parse, serialize, parseIndex, serializeIndex } from './format.js';
import { ensureIds, clone } from './ops.js';

export class Entry {
  constructor(kind, name, section, text, where) {
    this.kind = kind; this.name = name; this.section = section;
    this.model = ensureIds(parse(text, where || name));
    this.savedText = text;          // what is on disk
    this.undo = []; this.redo = [];
    this.isNew = false;
  }
  get dirty() { return this.isNew || serialize(this.model) !== this.savedText; }
  snapshot() { return JSON.stringify(this.model); }
}

export class Workspace {
  constructor() {
    this.kinds = {};         // kind -> {ix, ixSaved, entries: Map}
    this.deleted = [];       // [{kind,name}]
    this.root = null;        // FileSystemDirectoryHandle (mode 'fs')
    this.mode = 'none';      // 'fs' | 'http' | 'files'
    this.fileMap = null;     // mode 'files': Map relpath -> File
    this.baseUrl = '';
  }

  get loaded() { return Object.keys(this.kinds).length > 0; }
  entry(kind, name) { return this.kinds[kind]?.entries.get(name); }
  allEntries() { return Object.entries(this.kinds).flatMap(([, k]) => [...k.entries.values()]); }

  async _ingest(readText) {   // readText(kind, file) -> Promise<string|null>
    this.kinds = {}; this.deleted = [];
    for (const kind of ['flight', 'station']) {
      const ixText = await readText(kind, 'index.txt');
      if (ixText === null) continue;
      const ix = parseIndex(ixText);
      const entries = new Map();
      for (const sec of ix.sections) {
        for (const name of sec.models) {
          const text = await readText(kind, name + '.txt');
          if (text === null) throw new Error(`${kind}/${name}.txt is listed in index.txt but missing`);
          entries.set(name, new Entry(kind, name, sec.name, text, `${kind}/${name}.txt`));
        }
      }
      this.kinds[kind] = { ix, ixSaved: ixText, entries };
    }
    if (!this.loaded) throw new Error('no flight/ or station/ folder with index.txt found');
  }

  // ---- loading ---------------------------------------------------------------------------------
  async openDirectory() {
    if (!window.showDirectoryPicker) throw new Error('showDirectoryPicker is not available in this browser (use Chrome or Edge, or "Open files")');
    let h = await window.showDirectoryPicker({ mode: 'readwrite', id: 'awaken-models' });
    // accept the repository root, assets/, assets/models or a folder that contains flight/ and station/
    const sub = async (d, n) => { try { return await d.getDirectoryHandle(n); } catch { return null; } };
    for (const path of [[], ['models'], ['assets', 'models']]) {
      let d = h; for (const p of path) { d = d && await sub(d, p); }
      if (d && (await sub(d, 'flight') || await sub(d, 'station'))) { h = d; break; }
    }
    this.root = h; this.mode = 'fs';
    await this._ingest(async (kind, file) => {
      try { const d = await h.getDirectoryHandle(kind); const f = await (await d.getFileHandle(file)).getFile(); return (await f.text()); }
      catch (e) { if (e.name === 'NotFoundError') return null; throw e; }
    });
    return h.name;
  }

  async loadHttp(base = 'models/') {
    this.mode = 'http'; this.baseUrl = base;
    await this._ingest(async (kind, file) => {
      const r = await fetch(`${base}${kind}/${file}`, { cache: 'no-store' });
      if (r.status === 404) return null;
      if (!r.ok) throw new Error(`${kind}/${file}: HTTP ${r.status}`);
      return r.text();
    });
  }

  async loadFiles(fileList) {   // <input type=file multiple webkitdirectory>: match files by "flight/NAME.txt" suffix of webkitRelativePath
    this.mode = 'files';
    const map = new Map();
    for (const f of fileList) {
      const rel = (f.webkitRelativePath || f.name).replace(/\\/g, '/').split('/');
      const n = rel.length;
      if (n >= 2 && (rel[n - 2] === 'flight' || rel[n - 2] === 'station')) map.set(rel[n - 2] + '/' + rel[n - 1], f);
    }
    this.fileMap = map;
    await this._ingest(async (kind, file) => { const f = map.get(kind + '/' + file); return f ? f.text() : null; });
  }

  // ---- model list operations ------------------------------------------------------------------
  addEntry(kind, name, section, model) {
    const k = this.kinds[kind];
    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(name)) throw new Error('the name must be an assembler label: letters, digits, underscore');
    if (k.entries.has(name) || [...k.entries.keys()].some((n) => n.toLowerCase() === name.toLowerCase())) throw new Error(`model ${name} already exists in ${kind}`);
    let sec = k.ix.sections.find((s) => s.name === section) || k.ix.sections[k.ix.sections.length - 1];
    const e = new Entry(kind, name, sec.name, serialize(model), name);
    e.model = model; e.savedText = ''; e.isNew = true;
    k.entries.set(name, e); sec.models.push(name);
    return e;
  }
  removeEntry(kind, name) {
    const k = this.kinds[kind];
    const e = k.entries.get(name);
    k.entries.delete(name);
    for (const s of k.ix.sections) s.models = s.models.filter((n) => n !== name);
    if (!e.isNew) this.deleted.push({ kind, name });
  }
  sectionsOf(kind) { return this.kinds[kind].ix.sections.map((s) => s.name); }
  indexText(kind) { return serializeIndex(this.kinds[kind].ix); }
  indexDirty(kind) { return this.indexText(kind) !== this.kinds[kind].ixSaved; }
  get dirtyCount() { return this.allEntries().filter((e) => e.dirty).length + this.deleted.length + Object.keys(this.kinds).filter((k) => this.indexDirty(k)).length; }

  // ---- saving ---------------------------------------------------------------------------------
  // returns [{path, text}] of everything that changed
  pending() {
    const out = [];
    for (const [kind, k] of Object.entries(this.kinds)) {
      for (const e of k.entries.values()) if (e.dirty) out.push({ path: `${kind}/${e.name}.txt`, text: serialize(e.model), entry: e });
      if (this.indexDirty(kind)) out.push({ path: `${kind}/index.txt`, text: this.indexText(kind), kind });
    }
    return out;
  }

  async save() {
    const items = this.pending();
    if (this.mode === 'fs') {
      for (const it of items) {
        const [kind, file] = it.path.split('/');
        const d = await this.root.getDirectoryHandle(kind, { create: true });
        const w = await (await d.getFileHandle(file, { create: true })).createWritable();
        await w.write(new Blob([it.text], { type: 'text/plain' })); await w.close();
      }
      for (const del of this.deleted) {
        try { const d = await this.root.getDirectoryHandle(del.kind); await d.removeEntry(del.name + '.txt'); } catch (e) { if (e.name !== 'NotFoundError') throw e; }
      }
      this._markSaved(items);
      return { written: items.length, deleted: this.deleted.splice(0).length, how: 'folder' };
    }
    if (this.mode === 'http') {   // serve.py accepts PUT/DELETE for assets/models/{flight,station}/*.txt
      let ok = true;
      for (const it of items) {
        const r = await fetch(this.baseUrl + it.path, { method: 'PUT', headers: { 'X-Model-Editor': '1' }, body: it.text });
        if (!r.ok) { ok = false; break; }
      }
      if (ok) {
        const n = this.deleted.length;
        for (const del of this.deleted) await fetch(`${this.baseUrl}${del.kind}/${del.name}.txt`, { method: 'DELETE', headers: { 'X-Model-Editor': '1' } });
        this.deleted = [];
        this._markSaved(items);
        return { written: items.length, deleted: n, how: 'folder' };
      }
    }
    // files (or a static server without PUT): download the changed files (the browser cannot write into the folder)
    for (const it of items) this.download(it.path.split('/')[1], it.text, it.path.split('/')[0]);
    this._markSaved(items);
    return { written: items.length, deleted: 0, how: 'download', deletedNames: this.deleted.splice(0) };
  }
  _markSaved(items) {
    for (const it of items) {
      if (it.entry) { it.entry.savedText = it.text; it.entry.isNew = false; }
      else if (it.kind) this.kinds[it.kind].ixSaved = it.text;
    }
  }
  download(name, text, kind) {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([text], { type: 'text/plain' }));
    a.download = name; document.body.appendChild(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(a.href), 2000);
  }
}
