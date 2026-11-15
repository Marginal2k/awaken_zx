#!/usr/bin/env python3
"""Run the whole phase-1 pipeline from archive/*.trd: extract -> detokenize -> convert -> assemble and compare with the 1999 binaries.
usage: python tools/rebuild_all.py [--docs]"""
import subprocess, sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
# src/storm is hand-maintained now (cleaned up after conversion): it is checked by verify_storm.py, never regenerated here.
steps = [['extract.py'], ['decode_all.py'], ['convert.py', 'awk1'], ['convert.py', 'awk3'], ['convert.py', 'awk4'], ['convert.py', 'awk6'],
         ['verify_original.py', 'all'], ['verify_storm.py', 'all']]
if '--docs' in sys.argv:      # regenerate docs/VERSIONS.md and docs/BINARIES.md (needs the demo releases in reference/)
    steps += [['compare_versions.py'], ['binmap.py']]
for s in steps:
    print('>>', ' '.join(s))
    r = subprocess.run([sys.executable, os.path.join(HERE, s[0])] + s[1:])
    if r.returncode: print('step failed:', s); sys.exit(r.returncode)
