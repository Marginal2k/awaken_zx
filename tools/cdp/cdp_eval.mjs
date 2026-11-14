// cdp_eval.mjs - evaluate JS (await-able) in the open ZX-M8XXX tab via Edge's
// remote-debugging port. Usage: node cdp_eval.mjs <file.js | -e "code"> [port]
// The code runs as an async function body: use `return` for the result.
import fs from 'fs';
const args = process.argv.slice(2);
let code = args[0] === '-e' ? args[1] : fs.readFileSync(args[0], 'utf8');
const port = (args[0] === '-e' ? args[2] : args[1]) || process.env.CDP_PORT || 9222;
const list = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
// emulator tab: EMU_URL (default localhost:8095 - 8000/8090 are taken by other tools here)
const want = process.env.EMU_URL || 'localhost:8095';
const tab = list.find(t => t.type === 'page' && t.url.includes(want));
if (!tab) { console.error('no emulator tab on port ' + port); process.exit(2); }
const ws = new WebSocket(tab.webSocketDebuggerUrl);
await new Promise(r => ws.onopen = r);
ws.onmessage = (m) => {
  const d = JSON.parse(m.data);
  if (d.id !== 1) return;
  const r = d.result || {};
  if (r.exceptionDetails) { console.error('EXC', JSON.stringify(r.exceptionDetails).slice(0, 2000)); process.exit(1); }
  const v = r.result && r.result.value;
  console.log(typeof v === 'string' ? v : JSON.stringify(v, null, 1));
  ws.close(); process.exit(0);
};
ws.send(JSON.stringify({ id: 1, method: 'Runtime.evaluate', params: {
  expression: `(async()=>{${code}\n})()`, awaitPromise: true, returnByValue: true, timeout: 600000 } }));
