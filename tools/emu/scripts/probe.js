// probe.js - what the emulator iframe exposes (debugging the harness itself)
export async function run(zx, q, w) {
  let i = 0;
  for (; i < 3000 && !w.zxDebug; i++) await new Promise(r => setTimeout(r, 50));
  const r = { waitedMs: i * 50, hasZxDebug: !!w.zxDebug, hasSpectrum: !!w.spectrum,
    includesLeft: w.document.querySelectorAll('[data-include]').length,
    bodyStart: w.document.body.innerText.slice(0, 300) };
  await fetch('/result?name=probe', { method: 'POST', body: JSON.stringify(r) });
  return r;
}
