#!/usr/bin/env python3
"""cmplabels.py sym.txt LABELS.asm  : compare sjasmplus symbol dump with ZASM makelab file"""
import sys, re
sym = {}
for ln in open(sys.argv[1], encoding='latin1'):
    m = re.match(r'(\S+): EQU 0x([0-9A-Fa-f]+)', ln)
    if m: sym[m.group(1)] = int(m.group(2), 16)
lab = {}
for ln in open(sys.argv[2], encoding='utf8'):
    m = re.match(r'(\S+?):?\s+equ\s+(\d+)', ln)
    if m: lab[m.group(1)] = int(m.group(2))
bad = []; ok = 0; miss = []
for k, v in lab.items():
    kk = k if k in sym else (k + '_' if k + '_' in sym else None)
    if kk is None:
        miss.append(k); continue
    if sym[kk] == v: ok += 1
    else: bad.append((v, k, sym[kk]))
print('labels in file %d, equal %d, different %d, missing %d' % (len(lab), ok, len(bad), len(miss)))
bad.sort()
for v, k, s in bad[:int(sys.argv[3]) if len(sys.argv) > 3 else 40]:
    print('  %-14s file %5d (%04X)  built %5d (%04X)  delta %+d' % (k, v, v, s, s, s - v))
print('missing:', miss[:20])
