// ui_load_disk.mjs - insert a disk image through the emulator's own UI file input
// (#loadDiskFile = Settings > Disk > "Load Disk..."), the same path as a user click.
// Usage: node tools/cdp/ui_load_disk.mjs <disk.trd> [inputId]
import path from 'path';
const file = path.resolve(process.argv[2]);
const inputId = process.argv[3] || 'loadDiskFile';
const list = await (await fetch(`http://127.0.0.1:${process.env.CDP_PORT || 9222}/json/list`)).json();
const tab = list.find(t => t.type === 'page' && t.url.includes(process.env.EMU_URL || 'localhost:8095'));
const ws = new WebSocket(tab.webSocketDebuggerUrl); await new Promise(r => ws.onopen = r);
let id = 0; const pend = new Map();
ws.onmessage = m => { const d = JSON.parse(m.data); if (pend.has(d.id)) { pend.get(d.id)(d); pend.delete(d.id); } };
const call = (method, params = {}) => new Promise(r => { const n = ++id; pend.set(n, r); ws.send(JSON.stringify({ id: n, method, params })); });
const doc = await call('DOM.getDocument', {});
const q = await call('DOM.querySelector', { nodeId: doc.result.root.nodeId, selector: '#' + inputId });
const r = await call('DOM.setFileInputFiles', { nodeId: q.result.nodeId, files: [file] });
console.log(r.error ? 'ERROR ' + JSON.stringify(r.error) : 'inserted ' + file + ' via #' + inputId);
ws.close(); process.exit(0);
