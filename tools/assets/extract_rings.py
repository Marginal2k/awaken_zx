#!/usr/bin/env python3
"""ONE-TIME: assets/ways.d (old binary) -> assets/data/map_rings.txt.  Usage: python tools/assets/extract_rings.py <ways.d>"""
import sys, os
b = open(sys.argv[1], 'rb').read()
s8 = lambda v: v - 256 if v > 127 else v
rings, cur, i = [], [], 0
while i < len(b):
    if b[i] == 0x80:
        rings.append(cur); cur = []; i += 1
    else:
        cur.append((s8(b[i]), s8(b[i + 1]))); i += 2
out = ['''# Dotted rings that mark a star on the map (KARTA.asm, label PWAYS; the code addresses the rings at fixed offsets, so keep the number of points per ring).
# Six rings of growing radius; every line "x y" is the offset in pixels of one dot from the centre of the marker (signed, -127..127).
# The dots are drawn in this order (clockwise from the right).  Ring sizes are 28, 40, 52, 64, 76, 88 points; the code (MarkRouteLine) depends on these counts.
# Generated: build/gen/ways.d (a "[ring ...]" line ends the previous ring; every ring is closed by the byte 0x80).''']
for k, r in enumerate(rings):
    out.append('\n[ring %d: radius ~%d, %d points]' % (k + 1, 7 + 3 * k, len(r)))
    out += ['%d %d' % p for p in r]
d = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'assets', 'data')
open(os.path.join(d, 'map_rings.txt'), 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')
