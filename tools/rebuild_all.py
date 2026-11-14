#!/usr/bin/env python3
"""Run the whole phase-1 pipeline: extract -> detokenize -> convert -> assemble/verify -> reports."""
import subprocess, sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
steps = [['extract.py'], ['decode_all.py'], ['convert.py', 'awk1'], ['convert.py', 'awk3'], ['convert.py', 'awk4'], ['convert.py', 'awk6'],
         ['convert_storm.py', 'awk4'], ['verify_original.py', 'all'], ['verify_original.py', 'awk1', '--variant', 'objects_line'],
         ['compare_versions.py'], ['binmap.py']]
for s in steps:
    print('>>', ' '.join(s))
    r = subprocess.run([sys.executable, os.path.join(HERE, s[0])] + s[1:])
    if r.returncode: print('step failed:', s); sys.exit(r.returncode)
