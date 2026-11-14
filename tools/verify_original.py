#!/usr/bin/env python3
"""Assemble the converted sources with sjasmplus and compare the result with the binaries found on the disks.

usage: verify_original.py [awk1|awk6|all] [--variant NAME]
  works on a copy in work/build/<disk>[_variant]; writes work/verify_<disk>.txt
Variants (documented source/binary differences):
  awk1 objects_line : un-comment the line `;  db#33,#5F,#55,#50` in OBJECTS (binary was built before the line was commented out)
"""
import os, sys, re, shutil, subprocess, json
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
SJ = shutil.which('sjasmplus') or r'C:\sjasmplus\sjasmplus.exe'

PROJECTS = {
    'awk1': dict(master='SPACE.asm', outs=['DATAS.C', '3DPART.C', 'VOXAL0.C', 'VOXAL.C', 'CONTROL0.C', 'CONTROL.C', 'OBJECT3D.C'],
                 labels='LABELS.asm'),
    'awk6': dict(master='DOS.asm', outs=['LANG.C', 'D3D.C', 'KARTA.C', 'HELP.C'], labels=None),
}
VARIANTS = {
    ('awk1', 'objects_line'): [('OBJECTS.asm', r'^;  db#33,#5F,#55,#50', '            db   #33,#5F,#55,#50')],
}


def run(disk, variant=None):
    P = PROJECTS[disk]
    src = '%s/work/phase1_src/%s' % (ROOT, disk)
    bd = '%s/work/build/%s%s' % (ROOT, disk, ('_' + variant) if variant else '')
    if os.path.exists(bd): shutil.rmtree(bd)
    shutil.copytree(src, bd)
    for f, pat, rep in VARIANTS.get((disk, variant), []):
        t = open(bd + '/' + f, encoding='utf8').read()
        t2 = re.sub(pat, rep, t, flags=re.M)
        assert t != t2, 'variant patch did not apply'
        open(bd + '/' + f, 'w', encoding='utf8', newline='\n').write(t2)
    r = subprocess.run([SJ, '--nologo', '--msg=err', '--sym=sym.txt', P['master']], cwd=bd, capture_output=True, text=True)
    lines = ['## %s%s  (sjasmplus: %s)' % (disk, ' / ' + variant if variant else '', 'OK' if r.returncode == 0 else 'ERRORS'), '']
    if r.stdout.strip() or r.stderr.strip(): lines.append('```\n' + (r.stdout + r.stderr).strip()[:2000] + '\n```')
    lines.append('| output | built | original | diff bytes | result |\n|--|--|--|--|--|')
    for o in P['outs']:
        b = bd + '/' + o
        ref = '%s/work/extract/%s/%s' % (ROOT, disk, o)
        if not os.path.exists(b): lines.append('| %s | - | - | - | not built |' % o); continue
        a = open(b, 'rb').read(); c = open(ref, 'rb').read()
        n = min(len(a), len(c))
        nd = sum(1 for i in range(n) if a[i] != c[i])
        res = 'BYTE-EXACT' if (a == c) else ('size differs' if len(a) != len(c) else 'differs')
        lines.append('| %s | %d | %d | %d%s | %s |' % (o, len(a), len(c), nd, '' if len(a) == len(c) else ' (+%d tail)' % abs(len(a) - len(c)), res))
    if P['labels']:
        sym = {}
        for ln in open(bd + '/sym.txt', encoding='latin1'):
            m = re.match(r'(\S+): EQU 0x([0-9A-Fa-f]+)', ln)
            if m: sym[m.group(1)] = int(m.group(2), 16)
        lab = {}
        for ln in open(bd + '/' + P['labels'], encoding='utf8'):
            m = re.match(r'(\S+?):?\s+equ\s+(\d+)', ln)
            if m: lab[m.group(1)] = int(m.group(2))
        eq = sum(1 for k, v in lab.items() if sym.get(k) == v)
        lines.append('')
        lines.append('LABELS file (ZASM `makelab` output) vs built symbols: %d of %d equal' % (eq, len(lab)))
    txt = '\n'.join(lines) + '\n'
    open('%s/work/verify_%s%s.txt' % (ROOT, disk, ('_' + variant) if variant else ''), 'w', encoding='utf8').write(txt)
    print(txt)


if __name__ == '__main__':
    a = sys.argv[1:]
    variant = None
    if '--variant' in a:
        i = a.index('--variant'); variant = a[i+1]; del a[i:i+2]
    which = a[0] if a else 'all'
    for d in (PROJECTS if which == 'all' else [which]):
        run(d, variant if (d, variant) in VARIANTS else None)
