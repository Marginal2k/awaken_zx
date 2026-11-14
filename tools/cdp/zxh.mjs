// zxh.mjs - deterministic scenario runner for the ZX-M8XXX tab (CDP).
// Usage: node tools/cdp/zxh.mjs <disk.trd|-> <scenario.txt | "step step ..."> [outprefix]
//   disk '-' = do not (re)load, continue current machine state (no reset)
// The machine stays STOPPED the whole time (page rAF loop cancelled); all progress is
// spectrum.runFrame() pumped by this script -> frame-exact and race free.
// Env: MACHINE (pentagon|128k..., default pentagon), BOOT=none (load disk, no autoLoad),
//      CDP_PORT, EMU_URL, LOCK_WAIT (seconds to wait for another session, default 120)
// Steps (newline / space / comma separated; '#' comment to end of line):
//   wN            run N frames
//   kKEY[:N]      hold key KEY N frames (default 6), release, 3 gap frames. Chord: kCAPS+1:6
//   dKEY / uKEY   key down / key up (no frames; use wN)
//   t:TEXT        typeText hold 6 gap 6 ('\n' = Enter; step runs to end of line)
//   s:name        screenshot of the VISIBLE screen (bank 5 or 7 per #7FFD bit 3), 2x -> <prefix>_name.png
//   S:name        real page screenshot (Page.captureScreenshot, incl. border)
//   m:ADDR:LEN    hex dump (dec or #hex)   r  registers   p  paging/frame/pc
//   u:ADDR[:N]    disassemble               until:ADDR:MAXFRAMES  run until PC==ADDR
//   say:TEXT      echo
import fs from 'fs';
import zlib from 'zlib';
const [disk, scen, outp = 'work/coder/run'] = process.argv.slice(2);
const port = process.env.CDP_PORT || 9222, want = process.env.EMU_URL || 'localhost:8095';
const machine = process.env.MACHINE || 'pentagon';
// ---- lock: one emulator session at a time ----
const lock = 'work/coder/emu.lock';
fs.mkdirSync('work/coder', { recursive: true });
const t0 = Date.now(), maxw = (+process.env.LOCK_WAIT || 120) * 1000;
for (;;) {
  try { fs.writeFileSync(lock, process.pid + ' ' + new Date().toISOString(), { flag: 'wx' }); break; }
  catch {
    let st; try { st = fs.statSync(lock); } catch { continue; }
    if (Date.now() - st.mtimeMs > 600000) { try { fs.unlinkSync(lock); } catch {} continue; }
    if (Date.now() - t0 > maxw) { console.error('emulator busy (lock ' + lock + ')'); process.exit(3); }
    await new Promise(r => setTimeout(r, 1000));
  }
}
process.on('exit', () => { try { fs.unlinkSync(lock); } catch {} });
process.on('SIGINT', () => process.exit(1));
// ---- PNG ----
const PAL = [[0,0,0],[0,0,205],[205,0,0],[205,0,205],[0,205,0],[0,205,205],[205,205,0],[205,205,205],
  [0,0,0],[0,0,255],[255,0,0],[255,0,255],[0,255,0],[0,255,255],[255,255,0],[255,255,255]];
const crcT = []; for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; crcT[n] = c >>> 0; }
const crc = b => { let x = 0xFFFFFFFF; for (const v of b) x = crcT[(x ^ v) & 255] ^ (x >>> 8); return (x ^ 0xFFFFFFFF) >>> 0; };
function png(W, H, raw) {
  const chunk = (ty, d) => { const l = Buffer.alloc(4); l.writeUInt32BE(d.length); const td = Buffer.concat([Buffer.from(ty), d]); const c = Buffer.alloc(4); c.writeUInt32BE(crc(td)); return Buffer.concat([l, td, c]); };
  const ih = Buffer.alloc(13); ih.writeUInt32BE(W, 0); ih.writeUInt32BE(H, 4); ih[8] = 8; ih[9] = 2;
  return Buffer.concat([Buffer.from([137,80,78,71,13,10,26,10]), chunk('IHDR', ih), chunk('IDAT', zlib.deflateSync(raw)), chunk('IEND', Buffer.alloc(0))]);
}
function scrPng(m, scale = 2) {
  const W = 256 * scale, H = 192 * scale, raw = Buffer.alloc((W * 3 + 1) * H);
  for (let y = 0; y < H; y++) {
    const sy = (y / scale) | 0; raw[y * (W * 3 + 1)] = 0;
    for (let x = 0; x < W; x++) {
      const sx = (x / scale) | 0;
      const a = ((sy & 0xC0) << 5) | ((sy & 7) << 8) | ((sy & 0x38) << 2) | (sx >> 3);
      const at = m[6144 + (sy >> 3) * 32 + (sx >> 3)];
      const on = (m[a] >> (7 - (sx & 7))) & 1, br = (at & 64) ? 8 : 0;
      raw.set(PAL[(on ? at & 7 : (at >> 3) & 7) + br], y * (W * 3 + 1) + 1 + x * 3);
    }
  }
  return png(W, H, raw);
}
// ---- CDP ----
const list = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
const tab = list.find(t => t.type === 'page' && t.url.includes(want));
if (!tab) { console.error('no emulator tab ' + want); process.exit(2); }
const ws = new WebSocket(tab.webSocketDebuggerUrl); await new Promise(r => ws.onopen = r);
let id = 0; const pend = new Map();
ws.onmessage = m => { const d = JSON.parse(m.data); if (pend.has(d.id)) { pend.get(d.id)(d); pend.delete(d.id); } };
const send = (method, params = {}) => { const n = ++id; const p = new Promise(r => pend.set(n, r)); ws.send(JSON.stringify({ id: n, method, params })); return p; };
async function ev(expr) {
  const d = await send('Runtime.evaluate', { expression: `(async()=>{${expr}\n})()`, awaitPromise: true, returnByValue: true, timeout: 600000 });
  if (d.result && d.result.exceptionDetails) throw new Error(JSON.stringify(d.result.exceptionDetails).slice(0, 1500));
  return d.result.result.value;
}
const hex = s => s.startsWith('#') ? parseInt(s.slice(1), 16) : s.startsWith('0x') ? parseInt(s, 16) : +s;
// ---- boot ----
for (let i = 0; i < 60 && !(await ev("return typeof zxDebug") === 'object'); i++) await new Promise(r => setTimeout(r, 500));
if (disk !== '-') {
  const b64 = fs.readFileSync(disk).toString('base64'), name = disk.split(/[\\/]/).pop();
  const auto = process.env.BOOT === 'none' ? "return 'loaded (no autoload)';"
    : "const r = await zxDebug.autoLoad({type:'trd'}); zxDebug.pause(); return 'autoLoad '+JSON.stringify(r);";
  console.log(await ev(`
    zxDebug.pause(); await zxDebug.ready({machine:'${machine}'}); await zxDebug.start({machine:'${machine}'}); zxDebug.pause();
    const bin = Uint8Array.from(atob('${b64}'), c => c.charCodeAt(0));
    await zxDebug.loadFile(bin, '${name}');
    ${auto}`));
} else await ev('zxDebug.pause(); return 1');
// ---- steps ----
const txt = fs.existsSync(scen) ? fs.readFileSync(scen, 'utf8') : scen.replace(/;/g, '\n');
const steps = txt.split('\n').map(l => l.replace(/\s#.*$|^#.*$/, '').trim()).filter(Boolean)
  .flatMap(l => (l.startsWith('t:') || l.startsWith('say:')) ? [l] : l.split(/[,\s]+/)).filter(Boolean);
const keys = k => k.split('+');
const run = n => ev(`zxDebug.runFrames(${n}); return 1;`);
for (const s of steps) {
  if (/^w\d+$/.test(s)) await run(+s.slice(1));
  else if (/^k[^:]+(:\d+)?$/.test(s)) {
    const [k, n] = s.slice(1).split(':');
    await ev(`const K=${JSON.stringify(keys(k))}; K.forEach(x=>zxDebug.keyDown(x)); zxDebug.runFrames(${n || 6}); K.forEach(x=>zxDebug.keyUp(x)); zxDebug.runFrames(3); return 1;`);
  } else if (/^d[^:]+$/.test(s)) await ev(`${JSON.stringify(keys(s.slice(1)))}.forEach(x=>zxDebug.keyDown(x)); return 1;`);
  else if (/^u[^:]+$/.test(s)) await ev(`${JSON.stringify(keys(s.slice(1)))}.forEach(x=>zxDebug.keyUp(x)); return 1;`);
  else if (s.startsWith('t:')) await ev(`zxDebug.typeText(${JSON.stringify(s.slice(2).replace(/\\n/g, '\n'))},{hold:6,gap:6}); return 1;`);
  else if (s.startsWith('s:')) {
    const r = await ev(`const sp=zxDebug.spectrum, M=sp.memory, bank=(M.screenBank===7?7:5);
      const b=zxDebug.peekBank(bank); return {bank, f:sp.totalFrames, scr:Array.from(b.slice(0,6912))};`);
    const f = `${outp}_${s.slice(2)}.png`; fs.mkdirSync(f.replace(/[\\/][^\\/]*$/, '') || '.', { recursive: true });
    fs.writeFileSync(f, scrPng(Buffer.from(r.scr))); console.log('shot', f, 'screenBank=' + r.bank, 'frame=' + r.f);
  } else if (s.startsWith('S:')) {
    const d = await send('Page.captureScreenshot', { format: 'png' });
    const f = `${outp}_${s.slice(2)}.png`; fs.writeFileSync(f, Buffer.from(d.result.data, 'base64')); console.log('page shot', f);
  } else if (s.startsWith('m:')) {
    const [, a, l] = s.split(':'); const A = hex(a);
    console.log(s, await ev(`const o=[];for(let i=0;i<${l};i++)o.push(zxDebug.peek((${A}+i)&65535).toString(16).padStart(2,'0'));return o.join(' ');`));
  } else if (s === 'r') {
    const R = await ev('return zxDebug.captureRegisters();');
    console.log('regs', Object.entries(R).map(([k, v]) => k + '=' + (typeof v === 'number' ? v.toString(16) : v)).join(' '));
  } else if (s === 'p') {
    console.log('paging', await ev(`const sp=zxDebug.spectrum,M=sp.memory;return JSON.stringify({frame:sp.totalFrames,romBank:M.currentRomBank,ramBank:M.currentRamBank,screenBank:M.screenBank,trdos:M.trdosActive,pagingDisabled:M.pagingDisabled,pc:sp.cpu.pc.toString(16)})`));
  } else if (s.startsWith('u:')) {
    const [, a, n] = s.split(':');
    console.log(await ev(`return zxDebug.disassemble(${hex(a)},${n || 8}).map(i=>i.addr.toString(16).padStart(4,'0')+'  '+Array.from(i.bytes).map(b=>b.toString(16).padStart(2,'0')).join(' ').padEnd(12)+' '+i.text).join('\\n')`));
  } else if (s.startsWith('until:')) {
    const [, a, mx] = s.split(':');
    console.log('until', await ev(`const sp=zxDebug.spectrum;let f=0;for(;f<${mx || 3000};f++){zxDebug.runFrames(1);if(sp.cpu.pc===${hex(a)})break;}return JSON.stringify({frames:f,pc:sp.cpu.pc.toString(16)})`));
  } else if (s.startsWith('say:')) console.log('--', s.slice(4));
  else { console.error('unknown step', s); process.exit(4); }
}
ws.close(); process.exit(0);
