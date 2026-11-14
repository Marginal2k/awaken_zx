#!/usr/bin/env python3
"""Search the extracted disks (work/extract/*) for byte chunks of the restored STORM modules (work/storm/out/*.bin).
usage: storm_find.py [-n CHUNK(32)] [-s STEP(256)] file.bin [file.bin ...]
Prints, per module, how many sampled chunks were found in which files (location of first hit)."""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
EXT = ROOT + '/work/extract'


def main():
    a = sys.argv[1:]
    n, step = 32, 256
    while a and a[0] in ('-n', '-s'):
        if a[0] == '-n': n = int(a[1])
        else: step = int(a[1])
        a = a[2:]
    files = {}
    for d in sorted(os.listdir(EXT)):
        for f in os.listdir(EXT + '/' + d):
            files['%s/%s' % (d, f)] = open('%s/%s/%s' % (EXT, d, f), 'rb').read()
    for m in a:
        data = open(m, 'rb').read()
        chunks = []
        for o in range(0, len(data) - n, step):
            c = data[o:o + n]
            if len(set(c)) > 6: chunks.append((o, c))      # skip flat/empty areas
        hits = {}
        for o, c in chunks:
            for fn, b in files.items():
                if fn.startswith(('awk2/S3D.C', 'awk2/VSPRIT')) and 'S3D' in m + fn and False: continue
                i = b.find(c)
                if i >= 0:
                    hits.setdefault(fn, []).append((o, i))
        print('%s: %d chunks sampled' % (os.path.basename(m), len(chunks)))
        for fn, h in sorted(hits.items(), key=lambda x: -len(x[1])):
            if len(h) * 20 < len(chunks): continue
            deltas = {}
            for o, i in h: deltas[i - o] = deltas.get(i - o, 0) + 1
            d, dn = max(deltas.items(), key=lambda x: x[1])
            print('   %-28s %3d/%d chunks (%.0f%%)  main shift file-module = %+d (%d chunks)' % (fn, len(h), len(chunks), 100.0 * len(h) / len(chunks), d, dn))


if __name__ == '__main__':
    main()
