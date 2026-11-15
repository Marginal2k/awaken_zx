#!/usr/bin/env python3
"""In-game proof (test 3).  python tools/model_editor/test/ingame.py [OUTDIR]
 1. snapshot of the Ship screen with the unmodified Klopd (the ship of the "Корабль" screen) -> frame json
 2. edit Klopd through the editor's serializer (test/ingame_edit.mjs), python build.py, run the same scenario in Xpeccy+, snapshot + screenshot
 3. compare the editor's ZX-view render with the emulator window (vertices and pixels), before/after picture
 4. revert the model file, rebuild, gate check (DIFF [] MISSING [])
Outputs under work/model_editor/ingame (default)."""
import os, subprocess, sys, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
OUT = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'work', 'model_editor', 'ingame'))
os.makedirs(OUT, exist_ok=True)
py = sys.executable
def run(*a, **k):
    print('>', ' '.join(map(str, a))); r = subprocess.run(list(map(str, a)), cwd=ROOT, **k)
    if r.returncode: raise SystemExit('failed: %s' % (a,))
def scen(out):
    src = open(os.path.join(ROOT, 'tools', 'xp', 'scen', 'ours_scr_ship.txt'), encoding='utf8').read().split('\n')
    lines = []
    for l in src:
        lines.append(l)
        if l.startswith('run 300 shot scr_ship_2open'):
            lines.append('save ship_open'); break
    p = os.path.join(OUT, 'ship_open.txt'); open(p, 'w', encoding='utf8').write('\n'.join(lines) + '\n'); return p
model = os.path.join(ROOT, 'assets', 'models', 'station', 'Klopd.txt')
orig = open(model, 'rb').read()
sc = scen(OUT)
try:
    run(py, 'build.py')
    run(py, 'tools/xp/run.py', sc, '-o', os.path.join(OUT, 'base'), '--conf', 'work/xpconf')
    run(py, 'tools/model_editor/test/szx_frame.py', os.path.join(OUT, 'base', 'ship_open.szx'), os.path.join(OUT, 'base', 'frame_base.json'))
    run('node', 'tools/model_editor/test/ingame_edit.mjs', 'station', 'Klopd')
    run(py, 'build.py')
    run(py, 'tools/xp/run.py', sc, '-o', os.path.join(OUT, 'mod'), '--conf', 'work/xpconf')
    run(py, 'tools/model_editor/test/szx_frame.py', os.path.join(OUT, 'mod', 'ship_open.szx'), os.path.join(OUT, 'mod', 'frame_mod.json'))
    run(py, 'tools/model_editor/test/png_to_frame.py', os.path.join(OUT, 'mod', 'scr_ship_2open.png'), os.path.join(OUT, 'mod', 'frame_mod.json'))
    run(py, 'tools/model_editor/test/png_to_frame.py', os.path.join(OUT, 'base', 'scr_ship_2open.png'), os.path.join(OUT, 'base', 'frame_base.json'))
    # the modified model is on disk right now: compare (mod) with it, base against the original text
    run('node', 'tools/model_editor/test/frames.mjs', os.path.join(OUT, 'mod'), os.path.join(OUT, 'mod'), 'Klopd')
finally:
    open(model, 'wb').write(orig)
run(py, 'build.py')
run('node', 'tools/model_editor/test/frames.mjs', os.path.join(OUT, 'base'), os.path.join(OUT, 'base'), 'Klopd')
run(py, 'work/assets_tech/gate.py', 'check')
