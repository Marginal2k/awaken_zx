#!/usr/bin/env python3
"""cmpbin.py built.bin original.bin  -> byte diff report"""
import sys
a = open(sys.argv[1], 'rb').read(); b = open(sys.argv[2], 'rb').read()
print('built %d bytes, original %d bytes' % (len(a), len(b)))
n = min(len(a), len(b))
diffs = [i for i in range(n) if a[i] != b[i]]
print('differing bytes in common range:', len(diffs))
# group into runs
runs = []
for i in diffs:
    if runs and i - runs[-1][1] <= 8: runs[-1][1] = i
    else: runs.append([i, i])
base = int(sys.argv[3], 0) if len(sys.argv) > 3 else 0
for s, e in runs[:int(sys.argv[4]) if len(sys.argv) > 4 else 30]:
    print('  %04X-%04X (%d)  built %s | orig %s' % (base + s, base + e, e - s + 1, a[s:e+1][:16].hex(' '), b[s:e+1][:16].hex(' ')))
if len(runs) > 30: print('  ... %d runs' % len(runs))
