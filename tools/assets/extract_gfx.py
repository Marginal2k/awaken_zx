#!/usr/bin/env python3
"""ONE-TIME extractor: original binary graphics -> assets/gfx/*.png (+ assets/gfx/orig/ cache of the original packed bytes).
Usage: python tools/assets/extract_gfx.py <dir with the original assets (assets/ of the pre-conversion checkout)>
       python tools/assets/extract_gfx.py --from-orig      (re-render the pictures from assets/gfx/orig/, no other input needed)
Picture layouts (see zxgfx.bitmap_offset): station backgrounds are 'cell' (cell-linear, 8 bytes per 8x8 cell), panel and intro logo are 'screen'.
The intro logo is shown without its attribute bytes (white ink on black): the game overwrites them, only the bitmap is used."""
import sys, os, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import zxgfx, z80depack
FROM_ORIG = sys.argv[1] == '--from-orig'
SRC = sys.argv[1]
OUT = os.path.join(HERE, '..', '..', 'assets', 'gfx')
os.makedirs(OUT + '/orig', exist_ok=True)
cache = {}
SECTAB = [13, 11, 11, 12, 8, 14, 19, 15, 15, 13, 19, 12, 16, 20, 21, 20]


def rd(n): return open(os.path.join(SRC, n), 'rb').read()


def save_picture(name, scr, layout, attrs, origfile):
    im = zxgfx.scr_to_image(scr, layout, attrs)
    im.save(os.path.join(OUT, name))
    cache[name] = {'pixels': zxgfx.pixels_hash(im), 'orig': 'orig/' + origfile}


if FROM_ORIG:
    names = [(n, open(os.path.join(OUT, 'orig', n), 'rb').read()) for n in
             ['station_bg_%02d.hr' % (i + 1) for i in range(16)] + ['panel.hr', 'intro_logo.scr']]
else:
    s = rd('stscr.C')
    names, pos = [], 0
    for i, n in enumerate(SECTAB):
        ch = s[pos:pos + n * 256]
        pos += n * 256
        open(os.path.join(OUT, 'orig', 'station_bg_%02d.hr' % (i + 1)), 'wb').write(ch)
        names.append(('station_bg_%02d.hr' % (i + 1), ch))
    open(os.path.join(OUT, 'orig', 'panel.hr'), 'wb').write(rd('PANEL.C'))
    names.append(('panel.hr', rd('PANEL.C')))
    open(os.path.join(OUT, 'orig', 'intro_logo.scr'), 'wb').write(rd('intro_logo.scr'))
    names.append(('intro_logo.scr', rd('intro_logo.scr')))
for fn, data in names:
    if fn.startswith('station_bg'):
        save_picture(fn[:-3] + '.png', z80depack.depack(data[:data[4] | data[5] << 8]), 'cell', True, fn)
    elif fn == 'panel.hr':
        save_picture('panel.png', z80depack.depack(data), 'screen', True, fn)
    else:
        save_picture('intro_logo.png', data, 'screen', False, fn)
json.dump(cache, open(os.path.join(OUT, 'cache.json'), 'w'), indent=1, sort_keys=True)
# fonts, cursors (not re-rendered in --from-orig mode: they never changed)
if FROM_ORIG:
    print('ok (pictures only)')
    sys.exit(0)
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
