// runs the node tests (the in-game proof is test/ingame.py)
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const here = path.dirname(fileURLToPath(import.meta.url));
let bad = 0;
for (const t of ['roundtrip.mjs', 'binary.mjs', 'validate_all.mjs']) {
  const r = spawnSync(process.execPath, [path.join(here, t)], { encoding: 'utf8' });
  console.log(`--- ${t}: ${r.status === 0 ? 'PASS' : 'FAIL'}\n${r.stdout.trim().split('\n').slice(-3).join('\n')}${r.stderr ? '\n' + r.stderr : ''}`);
  if (r.status) bad++;
}
process.exit(bad ? 1 : 0);
