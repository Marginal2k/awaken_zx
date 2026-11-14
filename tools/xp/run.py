#!/usr/bin/env python
"""run.py - Xpeccy+ headless scenario runner (--bench mode), chained through .szx snapshots.

usage: python tools/xp/run.py SCENARIO.txt [-o OUTDIR] [-d DISK.trd] [-l LABELS] [--brk FILE.xbrk] [--keep]

Scenario file (one directive per line, '#' comments):
  disk  PATH            TRD/SCL to autostart (also -d); relative to cwd
  machine pent          xpeccy machine id (default pent; also pent1024, zx128, scorp ...)
  run N [shot NAME] [keys SPEC] [hash] [state]
                        run N more frames (segment). keys: bench-keys with FRAME relative to the
                        segment start, e.g.  keys 10:E/6,40:joy:fire/8   (E=Enter C=Caps S=Symbol _=Space,
                        digits/lowercase letters, joy:up+fire, joyb:, nmi).
                        shot NAME -> OUTDIR/NAME.png (last frame of the segment, with border)
  save NAME             also write OUTDIR/NAME.szx at segment end (chain snapshot is always kept)
  from SNAP.szx         start segment 1 from a snapshot instead of autostarting the disk
  say TEXT              echo
Segments are chained: segment 1 autostarts the disk, segment k>1 starts from the .szx saved at the end
of segment k-1. NOTE: a frame boundary is a snapshot boundary, so keys pressed in the last frames of
a segment may be held across it; keep >=10 frames between a key and a segment end.
Raw passthrough: any line starting with '!' is appended verbatim to that segment's xpeccy args
(e.g.  !--bp 0x6300  or  !-l build/awaken.lab).
"""
import argparse, os, re, subprocess, struct, sys, zlib

XP = r'D:\Emulators\ZX\XpeccyPlus\xpeccy-plus.exe'
CONF = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'work', 'xpconf'))

def ppm2png(src, dst):
    d = open(src, 'rb').read()
    m = re.match(rb'P6\s+(\d+)\s+(\d+)\s+(\d+)\s', d)
    w, h = int(m.group(1)), int(m.group(2)); px = d[m.end():]
    raw = b''.join(b'\0' + px[y*w*3:(y+1)*w*3] for y in range(h))
    def ch(t, b): c = struct.pack('>I', len(b)) + t + b; return c + struct.pack('>I', zlib.crc32(t + b) & 0xffffffff)
    open(dst, 'wb').write(b'\x89PNG\r\n\x1a\n' + ch(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0)) + ch(b'IDAT', zlib.compress(raw, 6)) + ch(b'IEND', b''))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('scen'); ap.add_argument('-o', default='work/coder/xp'); ap.add_argument('-d')
    ap.add_argument('-l'); ap.add_argument('--brk', action='append', default=[]); ap.add_argument('--brk-log')
    ap.add_argument('--keep', action='store_true'); ap.add_argument('--timeout', type=int, default=150)
    a = ap.parse_args()
    os.makedirs(a.o, exist_ok=True)
    disk, machine, start = a.d, 'pent', None
    segs = []; cur = None
    for ln in open(a.scen, encoding='utf8'):
        ln = ln.split('#')[0].strip()
        if not ln: continue
        if ln.startswith('!'):
            (cur or {}).setdefault('raw', []).extend(ln[1:].split()) if cur else None; continue
        w = ln.split(None, 1); k = w[0]; rest = w[1] if len(w) > 1 else ''
        if k == 'disk': disk = rest.strip()
        elif k == 'machine': machine = rest.strip()
        elif k == 'from': start = rest.strip()
        elif k == 'say': print('--', rest)
        elif k == 'run':
            t = rest.split(); seg = {'n': int(t[0]), 'raw': []}
            i = 1
            while i < len(t):
                if t[i] in ('shot', 'keys'): seg[t[i]] = t[i+1]; i += 2
                else: seg[t[i]] = True; i += 1
            segs.append(seg); cur = seg
        elif k == 'save' and cur is not None: cur['save'] = rest.strip()
        else: print('unknown directive:', ln, file=sys.stderr); return 4
    prev = start; rc = 0
    for i, s in enumerate(segs):
        snap = os.path.join(a.o, f'_chain{i}.szx')
        cmd = [XP, '--confdir', CONF, '-m', machine]
        if prev is None:
            if not disk: print('no disk', file=sys.stderr); return 4
            cmd += ['--autostart', disk]
        else: cmd += [prev]
        if a.l: cmd += ['-l', a.l]
        for b in a.brk: cmd += ['--brk', b]
        if a.brk_log: cmd += ['--brk-log', a.brk_log]
        cmd += s['raw']
        if 'keys' in s: cmd += ['--bench-keys', s['keys']]
        if 'hash' in s: cmd += ['--bench-hash']
        shot = os.path.join(a.o, (s.get('shot') or f'_s{i}') + '.ppm')
        cmd += ['--bench', str(s['n']), '--bench-shot', shot, '--bench-save', snap]
        try:
            r = subprocess.run(cmd, capture_output=True, text=True, timeout=a.timeout)
        except subprocess.TimeoutExpired as e:
            # subprocess.run already killed OUR process; never kill by image name -
            # the user may have their own emulator windows open
            print(f'[seg {i}] TIMEOUT after {a.timeout}s (our xpeccy run killed)'); return 9
        rc = r.returncode
        out = (r.stdout + r.stderr).strip()
        keep = [l for l in out.splitlines() if re.search(r'ERR|WARN|bench:|SPAN|BP|reak|hash:|^F\d{8}|rror', l) and 'setTabOrder' not in l and 'QFSFileEngine' not in l]
        nl = chr(10)
        print(f'[seg {i}] run {s["n"]} rc={rc}' + ''.join(nl + '   ' + l for l in keep))
        if os.path.exists(shot):
            if 'shot' in s: ppm2png(shot, shot[:-4] + '.png'); print('   shot', shot[:-4] + '.png')
            os.remove(shot)
        if 'save' in s and os.path.exists(snap):
            import shutil; shutil.copy(snap, os.path.join(a.o, s['save'] + '.szx'))
        if prev and prev != start and not a.keep and os.path.exists(prev): os.remove(prev)
        prev = snap
        if rc not in (0, 2): break
        if rc == 2: break
    if prev and not a.keep and os.path.exists(prev): pass
    return rc

if __name__ == '__main__':
    sys.exit(main())
