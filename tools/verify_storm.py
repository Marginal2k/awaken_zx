#!/usr/bin/env python3
"""Verification of the restored STORM modules (src/storm) against the developer disks.

usage: python tools/verify_storm.py [exact|build|frag|texts|inv|all]      (default: all)

 exact  src/storm/make_*.asm is assembled twice (memory pre-filled with #00 and #FF, -DFILL=n); bytes that differ between
        the two builds were never written by the source = alignment gaps (in the original files they hold stale memory) and
        are reported but not counted as differences.  Everything else is compared with the compiled file on the disk.
 build  modules without a compiled binary on any disk: must assemble with 0 errors.
 frag   source fragments that only make sense inside a bigger program: must convert cleanly, i.e. the only errors left are
        'Label not found' (labels of the missing context); the unresolved labels are counted.
 texts  the awk4 plain-text exports (STORM's own text export) must equal the awk2 token decodes line for line
        (code and comments); ignores the layout and the known XR2 'ED_' patch.
 inv    INVTAB3D semantic check: running its algorithm on D9000+ gives D9000.
"""
import sys, os, re, subprocess, json, difflib
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
SJ = os.environ.get('SJASMPLUS', 'C:/sjasmplus/sjasmplus')
SRC = ROOT + '/src/storm'
OUT = ROOT + '/work/storm/out'
TMP = ROOT + '/work/storm/tmp'
EXT = ROOT + '/work/extract'

# name, make file, built file, reference file (work/extract), load address
EXACT = [
    ('S3D',     'make_S3D.asm',     'S3D.bin',     'awk2/S3D.C.C',    0xC000),
    ('VSPRITE', 'make_VSPRITE.asm', 'VSPRITE.bin', 'awk2/VSPRIT.C.C', 0xC000),
]
BUILD = [   # name, make file, remark
    ('LAND',      'make_LAND.asm',      'planet landing program (7C00) + data; no compiled copy on any disk'),
    ('VXXX',      'make_VXXX.asm',      'voxel sprite experiment; no compiled copy'),
    ('VOXEL',     'make_VOXEL.asm',     'older voxel test program; CSIZE/CMOVE includes absent from all disks (not needed)'),
    ('tools',     'make_tools.asm',     'CNVVOXS3 CNVVOXSP CNVVOXTB INVTAB3D'),
    ('LOAD',      'make_LOAD.asm',      'awk5 raw-FDC animation loader'),
    ('LOAD+',     'make_LOAD_plus.asm', 'awk5 LOAD variant'),
    ('INVDISK',   'make_INVDISK.asm',   'awk5 disk sector inverter'),
]
FRAG = ['BLK1', 'BLK2', 'BLK3', 'BLK5', 'BLK6', 'BLK7', 'NXT', 'SERV', 'XR2_lc', 'XR1', 'XCLP', 'BLOK1', 'OBJX',
        'VOXL', 'VOXP', 'DATAM', 'LOADER']


def sj(args, cwd=SRC):
    r = subprocess.run([SJ, '--nologo', '--msg=err', '-I', SRC] + args, cwd=cwd, capture_output=True, text=True)
    return r.returncode, (r.stdout + r.stderr)


def ranges(idx, gap=1):
    rs = []
    for i in idx:
        if rs and i - rs[-1][1] <= gap: rs[-1][1] = i
        else: rs.append([i, i])
    return rs


def do_exact():
    os.makedirs(OUT, exist_ok=True)
    print('== exact (byte comparison with the disk binaries)')
    for name, make, outf, ref, base in EXACT:
        rc, msg = sj(['-DFILL=0', make])
        if rc:
            print('%-9s BUILD FAIL %s' % (name, msg.strip().splitlines()[:3])); continue
        a0 = open(OUT + '/' + outf, 'rb').read()
        sj(['-DFILL=255', make])
        a1 = open(OUT + '/' + outf, 'rb').read()
        b = open(EXT + '/' + ref, 'rb').read()
        n = min(len(a0), len(b))
        gap = {i for i in range(len(a0)) if a0[i] != a1[i]}
        diff = [i for i in range(n) if a0[i] != b[i] and i not in gap]
        gnz = sum(1 for i in gap if i < len(b) and b[i] != 0)
        ok = not diff and len(a0) == len(b)
        print('%-9s %-6s ours %d ref %d  ref=%s  gap bytes %d in %d runs (%d nonzero in ref)'
              % (name, 'EXACT' if ok else 'DIFF', len(a0), len(b), ref, len(gap), len(ranges(sorted(gap))), gnz))
        if diff:
            print('          %d differing bytes: %s' % (len(diff), ', '.join('%04X-%04X' % (base + s, base + e) for s, e in ranges(diff, 8)[:20])))


def do_build():
    print('== build (no binary to compare)')
    for name, make, rem in BUILD:
        rc, msg = sj([make])
        err = [l for l in msg.splitlines() if 'error' in l.lower()]
        print('%-9s %-9s %s' % (name, 'BUILDS' if not rc and not err else 'FAIL %d errors' % len(err), rem))
        for l in err[:3]: print('          ' + l)


def do_frag():
    os.makedirs(TMP, exist_ok=True)
    print('== fragments (convert cleanly; unresolved labels belong to the missing context)')
    for m in FRAG:
        w = TMP + '/frag_%s.asm' % m
        open(w, 'w').write('        DEVICE ZXSPECTRUM48\n        INCLUDE "EQUS.asm"\n        ORG #8000\n        INCLUDE "%s.asm"\n' % m)
        rc, msg = sj([w])
        errs = [l for l in msg.splitlines() if 'error:' in l]
        lab = [l for l in errs if 'Label not found' in l]
        other = [l for l in errs if 'Label not found' not in l]
        labs = sorted({l.split(': ')[-1] for l in lab})
        dup = [l for l in other if 'Duplicate label' in l]
        st = 'CLEAN' if not other else 'OLDNAMES' if len(dup) == len(other) else 'ERRORS'   # xR2 defines INIT itself (pre-INIT_ naming)
        print('%-8s %-8s unresolved labels %3d %s%s' % (m, st, len(labs), ' '.join(labs[:8]), ' ...' if len(labs) > 8 else ''))
        for l in other[:3]: print('          ' + l)


def norm(text):
    r = []
    for l in text.split('\n'):
        l = re.sub(r'\s+', ' ', l.rstrip('\r')).strip()
        if l: r.append(l)
    return r


KNOWN = {
    'CNVVOXTB': 'awk4 export has 2 extra header comment lines (src/storm uses the awk4 text)',
    'INVTAB3D': 'awk4 export has 1 extra header comment line (src/storm uses the awk4 text)',
    'XR2': 'awk4 export = older state: JP NC,Ld73d/Ld73c where the awk2 file (newer) has ED_ (the state compiled into S3D.C; src/storm patches it back)',
}


def do_texts():
    import storm_detok2 as sd
    print('== texts (awk4 plain-text exports vs awk2 token decodes, whole text incl. comments)')
    cat = json.load(open(ROOT + '/work/catalogue.json'))
    dec = {}
    for c in cat['awk2']['files']:
        if c['type'] == 'C' and c['start'] == 49163:
            B = open('%s/work/extract/awk2/%s' % (ROOT, c['file']), 'rb').read()[:c['length']]
            dec[c['name'].rstrip() + ('_lc' if c['file'] == 'xR2.C' else '')] = sd.detok(B)[0]
    ex = {}
    for c in cat['awk4']['files']:
        if c['type'] == 'C' and c['start'] == c['length']:
            ex[c['name'].rstrip()] = open('%s/work/extract/awk4/%s' % (ROOT, c['file']), 'rb').read()[:c['length']].decode('cp866').replace('\r', '\n')
    pairs = [(k, [k]) for k in ex if k not in ('LAND2', 'XR22', 'LAND', 'XR2')] + [('LAND', ['LAND', 'LAND2']), ('XR2', ['XR2', 'XR22'])]
    for k, parts in sorted(pairs):
        a = norm(''.join(ex[p] + '\n' for p in parts))
        b = norm(dec.get(k, ''))
        if k not in dec: print('%-9s no awk2 counterpart' % k); continue
        sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
        ops = [o for o in sm.get_opcodes() if o[0] != 'equal']
        note = KNOWN.get(k, '')
        print('%-9s %-9s %d lines vs %d, %d differing blocks  %s' % (k, 'IDENTICAL' if not ops else 'KNOWN' if note else 'DIFFERS', len(a), len(b), len(ops), note))
    for k in sorted(set(dec) - set(ex)):
        pass


def do_inv():
    print('== INVTAB3D algorithm: D9000+ -> D9000')
    src = open(EXT + '/awk2/D9000_2b.C', 'rb').read()[:512]
    dst = open(EXT + '/awk2/D9000.C', 'rb').read()[:512]
    m = bytearray(65536); m[0x9000:0x9200] = src
    hl = 0x9000
    g = lambda a: m[a & 0xFFFF]
    for _ in range(0x80):
        c = (~g(hl)) & 255; hl = (hl & 0xFF00) | ((hl + 1) & 0xFF)
        m[hl] = ((~g(hl)) & 255) & c
        hl = ((hl & 0xFF00) | ((hl - 1) & 0xFF)) + 0x100
        c = (~g(hl)) & 255; hl = (hl & 0xFF00) | ((hl + 1) & 0xFF)
        m[hl] = ((~g(hl)) & 255) & c
        hl = ((hl & 0xFF00) | ((hl + 1) & 0xFF)) - 0x100
    print('INVTAB3D  %s' % ('EXACT' if bytes(m[0x9000:0x9200]) == dst else 'DIFF'))


def main():
    w = sys.argv[1] if len(sys.argv) > 1 else 'all'
    for name, fn in (('exact', do_exact), ('build', do_build), ('frag', do_frag), ('texts', do_texts), ('inv', do_inv)):
        if w in ('all', name): fn()


if __name__ == '__main__':
    main()
