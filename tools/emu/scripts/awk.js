// minimal harness for the current ZX-M8XXX (window.spectrum): boot build/awaken.trd, run frames, screenshots.
// steps (query steps=a,b,..): wN run N frames; c:name screenshot; boot; kK key tap (not implemented); m:ADDR:LEN dump
export async function run(zx, q, win) {
  const sp = win.spectrum; if (!sp) { await fetch('/result?name=dbg', {method:'POST', body: JSON.stringify({log:[Object.keys(win).filter(k=>/spec|zx|emu|app/i.test(k)).join(','), String(win.document.readyState), win.document.title]})}); return; }
  const res = { canvas: {}, log: [], mem: {} };
  const L = s => res.log.push(s);
  const machine = q.get('machine') || '128k';
  if (sp.setMachineType) sp.setMachineType(machine);
  sp.betaDiskEnabled = true;
  const trd = q.get('trd');
  const buf = new Uint8Array(await (await fetch(trd + '?' + Date.now(), { cache: 'no-store' })).arrayBuffer());
  L('machine ' + machine + ' trd bytes ' + buf.length);
  sp.stop && sp.stop();
  try { sp.loadDiskImage(buf, 'trd', 'awaken.trd', 0); } catch (e) { L('loadDiskImage: ' + e); }
  const regs = () => { const c = sp.cpu; return 'pc=' + c.pc.toString(16) + ' sp=' + c.sp.toString(16) + ' i=' + (c.i||0).toString(16); };
  L('bootTrdos=' + sp.bootTrdos());
  const steps = (q.get('steps') || 'w600').split(',').map(s => s.trim()).filter(Boolean);
  for (const st of steps) {
    const a = st.split(':');
    if (/^w\d+$/.test(st)) { for (let i = 0; i < +st.slice(1); i++) sp.runFrame(); L(st + ' ' + regs()); }
    else if (a[0] === 'c') { sp.runFrame(); res.canvas[a[1]] = win.document.querySelector('canvas').toDataURL('image/png'); L('shot ' + a[1] + ' ' + regs()); }
    else if (a[0] === 'm') { const ad = parseInt(a[1], 16), n = +a[2]; let s = ''; for (let i = 0; i < n; i++) s += (sp.memory.read(ad + i) & 255).toString(16).padStart(2, '0'); L('mem ' + a[1] + ': ' + s); }
  }
  res.regs = { pc: sp.cpu.pc, sp: sp.cpu.sp };
  await fetch('/result?name=' + (q.get('name') || 'awk'), { method: 'POST', body: JSON.stringify(res) });
  return { log: res.log.length };
}
