#!/usr/bin/env python3
"""ONE-TIME: the original intro blob (depacker + 1999-packed closing picture) -> assets/gfx/intro_closing.png (+ cache.json entry, orig/intro_depack.bin).
The blob is run in the Z80 core (it is position independent and returns after depacking 6912 bytes to #4000).
Usage: python tools/assets/extract_closing.py <intro_depack.bin>"""
import sys, os, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import zxgfx, rlepack
src = sys.argv[1]
gfx = os.path.join(HERE, '..', '..', 'assets', 'gfx')
blob = open(src, 'rb').read()
scr = rlepack.depack(blob)
assert set(scr[6144:]) == {7}, 'attributes are not all 7'
im = zxgfx.scr_to_image(scr)
im.save(os.path.join(gfx, 'intro_closing.png'))
if os.path.abspath(src) != os.path.abspath(os.path.join(gfx, 'orig', 'intro_depack.bin')):
    shutil.copy(src, os.path.join(gfx, 'orig', 'intro_depack.bin'))
cache = json.load(open(os.path.join(gfx, 'cache.json')))
cache['intro_closing.png'] = {'pixels': zxgfx.pixels_hash(im), 'orig': 'orig/intro_depack.bin'}
json.dump(cache, open(os.path.join(gfx, 'cache.json'), 'w'), indent=1, sort_keys=True)
print('ok', len(blob))
