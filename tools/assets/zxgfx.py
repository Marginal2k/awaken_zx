"""ZX Spectrum graphics <-> PNG helpers (screen with attributes, 1-bit fonts, mask cursors)."""
from PIL import Image

NORMAL = [(0, 0, 0), (0, 0, 205), (205, 0, 0), (205, 0, 205), (0, 205, 0), (0, 205, 205), (205, 205, 0), (205, 205, 205)]
BRIGHT = [(0, 0, 0), (0, 0, 255), (255, 0, 0), (255, 0, 255), (0, 255, 0), (0, 255, 255), (255, 255, 0), (255, 255, 255)]


def bitmap_offset(y, xb, layout):
    """offset of the bitmap byte of pixel row y, byte column xb (0..31) inside the 6144 bitmap bytes.
    layout 'screen': the ZX Spectrum screen order (as in #4000..#57FF) - flight panel, intro logo, any raw screen.
    layout 'cell'  : cell-linear: 8 bytes (the 8 pixel rows) of cell 0, then of cell 1 ... cells row by row (cell = y//8*32 + xb).
                     This is the form of the station backgrounds: the station code (BODY.asm Rp1 'Nbs3') copies one cell (8 bytes) at a time
                     from the depacked picture to the screen."""
    if layout == 'cell':
        return ((y >> 3) * 32 + xb) * 8 + (y & 7)
    return ((y & 7) << 8) | (((y >> 3) & 7) << 5) | ((y >> 6) << 11) | xb


def scr_to_image(d, layout='screen', attrs=True):
    """6912 bytes (bitmap 6144 + attributes 768) -> RGB image 256x192.  attrs=False: ignore the attribute bytes (white ink on black)."""
    im = Image.new('RGB', (256, 192))
    px = im.load()
    for y in range(192):
        for xb in range(32):
            b = d[bitmap_offset(y, xb, layout)]
            a = d[6144 + (y >> 3) * 32 + xb] if attrs else 7
            pal = BRIGHT if a & 64 else NORMAL
            ink = pal[a & 7]
            pap = pal[(a >> 3) & 7]
            for k in range(8):
                px[xb * 8 + k, y] = ink if b & (0x80 >> k) else pap
    return im


def _nearest(c):
    best = None
    for br, pal in ((0, NORMAL), (1, BRIGHT)):
        for i, p in enumerate(pal):
            dd = sum((p[k] - c[k]) ** 2 for k in range(3))
            if best is None or dd < best[0]:
                best = (dd, i, br)
    return best[1], best[2]


def image_to_scr(im, name='image', layout='screen'):
    """RGB image 256x192 -> 6912 bytes.  Each 8x8 cell may use two colours of the same brightness (the ZX attribute limit)."""
    im = im.convert('RGB')
    if im.size != (256, 192):
        raise ValueError('%s: the picture must be 256x192 pixels, it is %dx%d' % (name, im.size[0], im.size[1]))
    px = im.load()
    out = bytearray(6912)
    for cy in range(24):
        for cx in range(32):
            cols = {}
            for y in range(8):
                for x in range(8):
                    ci = _nearest(px[cx * 8 + x, cy * 8 + y])
                    cols[ci] = cols.get(ci, 0) + 1
            brs = set(br for (i, br) in cols if i != 0)
            if len(brs) > 1:
                raise ValueError('%s: cell at pixel (%d,%d) mixes normal and bright colours' % (name, cx * 8, cy * 8))
            bright = brs.pop() if brs else 0
            idx = sorted(set(i for (i, br) in cols), key=lambda i: (-sum(n for (j, b2), n in cols.items() if j == i), i))
            if len(idx) > 2:
                raise ValueError('%s: cell at pixel (%d,%d) uses %d colours (max 2 per 8x8 cell)' % (name, cx * 8, cy * 8, len(idx)))
            paper = idx[0]
            ink = idx[1] if len(idx) > 1 else (7 if paper != 7 else 0)
            out[6144 + cy * 32 + cx] = (bright << 6) | (paper << 3) | ink
            for y in range(8):
                v = 0
                for x in range(8):
                    i, br = _nearest(px[cx * 8 + x, cy * 8 + y])
                    if i == ink and len(idx) > 1 or (len(idx) == 1 and False):
                        v |= 0x80 >> x
                Y = cy * 8 + y
                out[bitmap_offset(Y, cx, layout)] = v
    return bytes(out)


def image_to_bitmap(im, name='image'):
    """256x192 picture -> 6144 bitmap bytes in ZX screen order; white (or any bright) pixel = 1, black = 0 (no attributes)."""
    im = im.convert('L')
    if im.size != (256, 192):
        raise ValueError('%s: the picture must be 256x192 pixels, it is %dx%d' % (name, im.size[0], im.size[1]))
    px = im.load()
    out = bytearray(6144)
    for y in range(192):
        for xb in range(32):
            v = 0
            for k in range(8):
                if px[xb * 8 + k, y] > 127:
                    v |= 0x80 >> k
            out[bitmap_offset(y, xb, 'screen')] = v
    return bytes(out)


def pixels_hash(im):
    import hashlib
    im = im.convert('RGBA')
    return hashlib.sha256(im.tobytes() + str(im.size).encode()).hexdigest()


# ---- 1-bit fonts -------------------------------------------------------------------------------------------------------------
def glyphs_to_sheet(glyphs, cols, cw, ch, gw, gh):
    """glyphs: list of lists of rows (ints, MSB left, gw bits).  cell cw x ch, glyph gw x gh in the top-left corner.  black ink on white."""
    rows = (len(glyphs) + cols - 1) // cols
    im = Image.new('L', (cols * cw, rows * ch), 255)
    px = im.load()
    for n, g in enumerate(glyphs):
        ox, oy = (n % cols) * cw, (n // cols) * ch
        for y in range(gh):
            for x in range(gw):
                if g[y] & (1 << (gw - 1 - x)):
                    px[ox + x, oy + y] = 0
    return im


def sheet_to_glyphs(im, n, cols, cw, ch, gw, gh):
    im = im.convert('L')
    px = im.load()
    out = []
    for k in range(n):
        ox, oy = (k % cols) * cw, (k // cols) * ch
        rows = []
        for y in range(gh):
            v = 0
            for x in range(gw):
                if px[ox + x, oy + y] < 128:
                    v |= 1 << (gw - 1 - x)
            rows.append(v)
        out.append(rows)
    return out


# ---- PRO.f: 256 width bytes + 256 glyphs of 8 rows -------------------------------------------------------------------------------
def pro_to_png(b):
    gl = [list(b[256 + 8 * i:256 + 8 * i + 8]) for i in range(256)]
    return glyphs_to_sheet(gl, 16, 8, 8, 8, 8), list(b[:256])


def png_to_pro(im, widths):
    gl = sheet_to_glyphs(im, 256, 16, 8, 8, 8, 8)
    return bytes(widths) + bytes(v for g in gl for v in g)


# ---- FONT.f: 4x6 glyphs, two per 6 bytes (high nibble = even char), codes 32.. ----------------------------------------------------
FONT_CELL = (5, 7)


def font_to_png(b):
    n = len(b) // 6 * 2
    gl = []
    for c in range(n):
        p, odd = divmod(c, 2)
        gl.append([(b[p * 6 + r] >> (0 if odd else 4)) & 15 for r in range(6)])
    return glyphs_to_sheet(gl, 16, FONT_CELL[0], FONT_CELL[1], 4, 6)


def png_to_font(im, n):
    gl = sheet_to_glyphs(im, n, 16, FONT_CELL[0], FONT_CELL[1], 4, 6)
    out = bytearray()
    for p in range(n // 2):
        for r in range(6):
            out.append((gl[2 * p][r] << 4) | gl[2 * p + 1][r])
    return bytes(out)


# ---- cursors: 16 rows x (mask_l, img_l, mask_r, img_r); mask bit 1 = transparent -------------------------------------------------
def cursors_to_png(b):
    n = len(b) // 64
    im = Image.new('RGBA', (16 * n, 16), (0, 0, 0, 0))
    px = im.load()
    for c in range(n):
        for y in range(16):
            ml, il, mr, ir = b[c * 64 + y * 4:c * 64 + y * 4 + 4]
            for x in range(16):
                m, i = (ml, il) if x < 8 else (mr, ir)
                bit = 0x80 >> (x & 7)
                if not (m & bit):
                    px[c * 16 + x, y] = (255, 255, 255, 255) if i & bit else (0, 0, 0, 255)
    return im


def png_to_cursors(im, n):
    im = im.convert('RGBA')
    px = im.load()
    out = bytearray()
    for c in range(n):
        for y in range(16):
            row = [0, 0, 0, 0]
            for x in range(16):
                r, g, bl, a = px[c * 16 + x, y]
                k = 0 if x < 8 else 2
                bit = 0x80 >> (x & 7)
                if a < 128:
                    row[k] |= bit
                elif (r + g + bl) > 382:
                    row[k + 1] |= bit
            out += bytes(row)
    return bytes(out)
