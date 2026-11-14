// run_trd.mjs - boot a TRD in the open ZX-M8XXX tab (Edge --remote-debugging-port)
// and take screenshots.
// Usage: node tools/cdp/run_trd.mjs <disk.trd> <outprefix> [steps...]
//   steps: wN = run N frames, s:name = screenshot to <outprefix>_name.png,
//          kKEY:N = hold matrix key KEY for N frames (names: zxDebug.keyNames()),
//          t:TEXT = typeText, m:ADDR:LEN = hex dump (decimal or #hex),
//          r = registers
// Default steps: w250 s:boot w500 s:later
// Machine: env MACHINE (default pentagon). Port/tab: CDP_PORT, EMU_URL.
import fs from 'fs';
import zlib from 'zlib';
// ZX screen (6912 bytes) -> 256x192 PNG
function scrPng(m) {
  const pal = [[0,0,0],[0,0,205],[205,0,0],[205,0,205],[0,205,0],[0,205,205],[205,205,0],[205,205,205],
               [0,0,0],[0,0,255],[255,0,0],[255,0,255],[0,255,0],[0,255,255],[255,255,0],[255,255,255]];
  const W = 256, H = 192, raw = Buffer.alloc((W * 3 + 1) * H);
  for (let y = 0; y < H; y++) {
    raw[y * (W * 3 + 1)] = 0;
    for (let x = 0; x < W; x++) {
      const a = ((y & 0xC0) << 5) | ((y & 7) << 8) | ((y & 0x38) << 2) | (x >> 3);
      const at = m[6144 + (y >> 3) * 32 + (x >> 3)];
      const on = (m[a] >> (7 - (x & 7))) & 1, br = (at & 64) ? 8 : 0;
      const c = pal[(on ? at & 7 : (at >> 3) & 7) + br];
      raw.set(c, y * (W * 3 + 1) + 1 + x * 3);
    }
  }
  const crc = (b) => { let c, t = []; for (let n = 0; n < 256; n++) { c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; t[n] = c >>> 0; }
    let x = 0xFFFFFFFF; for (const v of b) x = t[(x ^ v) & 255] ^ (x >>> 8); return (x ^ 0xFFFFFFFF) >>> 0; };
  const chunk = (ty, d) => { const l = Buffer.alloc(4); l.writeUInt32BE(d.length); const td = Buffer.concat([Buffer.from(ty), d]);
    const c = Buffer.alloc(4); c.writeUInt32BE(crc(td)); return Buffer.concat([l, td, c]); };
  const ih = Buffer.alloc(13); ih.writeUInt32BE(W, 0); ih.writeUInt32BE(H, 4); ih[8] = 8; ih[9] = 2;
  return Buffer.concat([Buffer.from([137,80,78,71,13,10,26,10]), chunk('IHDR', ih), chunk('IDAT', zlib.deflateSync(raw)), chunk('IEND', Buffer.alloc(0))]);
}
const [trd, outp, ...stepsArg] = process.argv.slice(2);
const steps = stepsArg.length ? stepsArg : ['w250', 's:boot', 'w500', 's:later'];
const port = process.env.CDP_PORT || 9222;
const want = process.env.EMU_URL || 'localhost:8095';
const machine = process.env.MACHINE || 'pentagon';
const list = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
const tab = list.find(t => t.type === 'page' && t.url.includes(want));
if (!tab) { console.error('no emulator tab ' + want); process.exit(2); }
const ws = new WebSocket(tab.webSocketDebuggerUrl);
await new Promise(r => ws.onopen = r);
let id = 0; const pend = new Map();
ws.onmessage = (m) => { const d = JSON.parse(m.data); if (pend.has(d.id)) { pend.get(d.id)(d); pend.delete(d.id); } };
async function ev(expr) {
  const n = ++id;
  const p = new Promise(r => pend.set(n, r));
  ws.send(JSON.stringify({ id: n, method: 'Runtime.evaluate', params: { expression: `(async()=>{${expr}\n})()`, awaitPromise: true, returnByValue: true, timeout: 600000 } }));
  const d = await p;
  if (d.result && d.result.exceptionDetails) throw new Error(JSON.stringify(d.result.exceptionDetails).slice(0, 1500));
  return d.result.result.value;
}
const b64 = fs.readFileSync(trd).toString('base64');
const name = trd.split(/[\\/]/).pop();
console.log(await ev(`
  await zxDebug.ready({machine:'${machine}'}); await zxDebug.start({machine:'${machine}'});
  const bin = Uint8Array.from(atob('${b64}'), c => c.charCodeAt(0));
  await zxDebug.loadFile(bin, '${name}');
  const r = await zxDebug.autoLoad({type:'trd'});
  zxDebug.resume();   // runFrames only advances a running machine
  return 'loaded ' + JSON.stringify(r);`));
for (const s of steps) {
  if (/^w\d+$/.test(s)) { await ev(`zxDebug.runFrames(${s.slice(1)}); return 1;`); }
  else if (s.startsWith('s:')) {
    // screen rendered from RAM: the visible bank (5, or 7 when port #7FFD bit 3 is set)
    const r = await ev(`const M=zxDebug.spectrum.memory, p=(M.screenBank===7?8:0);
      const b=zxDebug.peekBank(M.screenBank===7 ? 7 : 5) || zxDebug.snapshotMemory().slice(16384);
      return {p, scr: Array.from(b.slice(0, 6912))};`);
    const f = `${outp}_${s.slice(2)}.png`;
    fs.writeFileSync(f, scrPng(r.scr)); console.log('shot', f, '7FFD=' + r.p);
  } else if (s.startsWith('k')) {
    const [k, n] = s.slice(1).split(':');
    await ev(`zxDebug.keyDown('${k}'); zxDebug.runFrames(${n || 10}); zxDebug.keyUp('${k}'); return 1;`);
  } else if (s.startsWith('t:')) {
    await ev(`await zxDebug.typeText(${JSON.stringify(s.slice(2).replace(/\\n/g, '\n'))}); return 1;`);
  } else if (s.startsWith('m:')) {
    const [, a, l] = s.split(':'); const A = a.startsWith('#') ? parseInt(a.slice(1), 16) : +a;
    console.log(s, await ev(`const o=[];for(let i=0;i<${l};i++)o.push(zxDebug.peek(${A}+i).toString(16).padStart(2,'0'));return o.join(' ');`));
  } else if (s === 'r') {
    const R = await ev(`return zxDebug.captureRegisters();`);
    console.log(Object.entries(R).map(([k, v]) => k + '=' + (typeof v === 'number' ? v.toString(16) : v)).join(' '));
  }
}
ws.close(); process.exit(0);
