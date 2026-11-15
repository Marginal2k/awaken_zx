#!/usr/bin/env python3
"""ONE-TIME extractor: original binary graphics -> assets/gfx/*.png (+ assets/gfx/orig/ cache of the original packed bytes).
Usage: python tools/assets/extract_gfx.py <dir with the original assets (assets/ of the pre-conversion checkout)>"""
import sys, os, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import zxgfx, z80depack
SRC = sys.argv[1]
OUT = os.path.join(HERE, '..', '..', 'assets', 'gfx')
os.makedirs(OUT + '/orig', exist_ok=True)
cache = {}
SECTAB = [13, 11, 11, 12, 8, 14, 19, 15, 15, 13, 19, 12, 16, 20, 21, 20]


def rd(n): return open(os.path.join(SRC, n), 'rb').read()


s = rd('stscr.C')
pos = 0
for i, n in enumerate(SECTAB):
    ch = s[pos:pos + n * 256]
    pos += n * 256
    plen = ch[4] | ch[5] << 8
    scr = z80depack.depack(ch[:plen])
    im = zxgfx.scr_to_image(scr)
    name = 'station_bg_%02d.png' % (i + 1)
    im.save(os.path.join(OUT, name))
    open(os.path.join(OUT, 'orig', name[:-4] + '.hr'), 'wb').write(ch)
    cache[name] = {'pixels': zxgfx.pixels_hash(im), 'orig': 'orig/' + name[:-4] + '.hr'}
p = rd('PANEL.C')
scr = z80depack.depack(p)
im = zxgfx.scr_to_image(scr)
im.save(os.path.join(OUT, 'panel.png'))
open(os.path.join(OUT, 'orig', 'panel.hr'), 'wb').write(p)
cache['panel.png'] = {'pixels': zxgfx.pixels_hash(im), 'orig': 'orig/panel.hr'}
l = rd('intro_logo.scr')
im = zxgfx.scr_to_image(l)
im.save(os.path.join(OUT, 'intro_logo.png'))
open(os.path.join(OUT, 'orig', 'intro_logo.scr'), 'wb').write(l)
cache['intro_logo.png'] = {'pixels': zxgfx.pixels_hash(im), 'orig': 'orig/intro_logo.scr'}
json.dump(cache, open(os.path.join(OUT, 'cache.json'), 'w'), indent=1, sort_keys=True)
# fonts, cursors
im, widths = zxgfx.pro_to_png(rd('PRO.f'))
im.save(os.path.join(OUT, 'pro_font.png'))
with open(os.path.join(OUT, 'pro_font_widths.csv'), 'w', encoding='utf-8', newline='') as f:
    f.write('# Advance width in pixels of every character code of the station font (PRO.f); the glyphs are in pro_font.png (16 x 16 cells of 8 x 8, code = row*16+column).\n'
            '# Glyphs are drawn with the ink on the left of the 8-pixel cell; width = pixels to advance (a glyph may not be wider than 8).\n# code,char_cp866,width\n')
    for c in range(256):
        ch = bytes([c]).decode('cp866') if c >= 33 and c != 127 else ''
        f.write('%d,%s,%d\n' % (c, ch if ch not in ',"' else '"' + ch + '"', widths[c]))
zxgfx.font_to_png(rd('FONT.f')).save(os.path.join(OUT, 'panel_font.png'))
zxgfx.cursors_to_png(rd('KSPOplus.s')).save(os.path.join(OUT, 'cursors.png'))
print('ok')
