#!/usr/bin/env python3
"""szx_frame.py SNAP.szx OUT.json - dump what the station 3D viewer was doing in a snapshot: the object matrix (OM_ij operands of RenderObject, D3D overlay page),
ZET (distance), Indexx (model table index), clip window (MDX/MDY/XH/YH) and the 256x192 screen bitmap (game polarity: bit 1 = dark)."""
import sys, os, re, json
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'xp'))
import szxinfo

def main():
    d, b, pages = szxinfo.parse(sys.argv[1])
    sym = {}
    for l in open(os.path.join(ROOT, 'build', 'station.sym')):
        m = re.match(r'(\S+): EQU 0x([0-9A-F]+)', l)
        if m: sym[m.group(1)] = int(m.group(2), 16)
    # find the page holding the D3D overlay (best match with the built overlay file)
    ov = open(os.path.join(ROOT, 'build', 'station', 'D3D.C'), 'rb').read()
    pg = max(pages, key=lambda p: sum(1 for i in range(0, len(ov), 7) if pages[p][i] == ov[i]))
    p = pages[pg]
    g = lambda n, o=0: p[sym[n] - 0xC000 + o]
    s8 = lambda v: v - 256 if v > 127 else v
    om = [s8(g('Om_%d%d' % (i, j), 1)) for i in (1, 2, 3) for j in (1, 2, 3)]
    s = pages[5]
    bm = []
    for y in range(192):
        a = ((y & 0xC0) << 5) | ((y & 7) << 8) | ((y & 0x38) << 2)
        row = []
        for xb in range(32):
            v = s[a + xb]
            row += [(v >> (7 - k)) & 1 for k in range(8)]
        bm.append(row)
    s16 = lambda lo, hi: (lo | hi << 8) - 65536 if hi > 127 else lo | hi << 8
    base = 0xC600 - 0xC000
    verts = [[s16(p[base + 5 * k], p[base + 5 * k + 1]), s16(p[base + 5 * k + 2], p[base + 5 * k + 3]), p[base + 5 * k + 4]] for k in range(52)]
    out = dict(verts=verts, page=pg, matrix=om, zet=g('ZET') + 256 * g('ZET', 1), indexx=g('Indexx'), alfa=[g('ALFA', i) for i in range(3)],
               mdx=g('MDX', 1), mdy=g('MDY', 1), xh=g('XH1', 1), yh=g('YH1', 1), screen=bm)
    json.dump(out, open(sys.argv[2], 'w'))
    print('page', pg, 'matrix', om, 'zet', out['zet'], 'indexx', out['indexx'], 'md', out['mdx'], out['mdy'])

main()
