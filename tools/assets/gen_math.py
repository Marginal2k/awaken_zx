#!/usr/bin/env python3
"""Math tables of the 3D engine, computed instead of stored.  Run by build.py: writes build/gen/{0E0200,D9200,station_D9200,CSTB}.d and ways.d.

All tables are 256-byte "pages" (the code indexes them with an 8-bit value; the angle is 256 units per full circle).

  0E0200.d (512)  page 0: n*n low byte, page 1: n*n high byte, n = 0..255                       (square table for the map / distance code)
  CSTB.d   (512)  cosine, 14 bit: 16-bit word round(16384 * cos(2*pi*n/256)), two's complement; page 0 = low bytes, page 1 = high bytes
  D9200.d  (512)  page 0 = "multiplication" table: n < 128: n*n // 127, n >= 128: the same for 255 - n  (quarter-square multiplication, MULTB)
                  page 1 = sine, signed byte round(128 * sin(2*pi*n/256)) limited to -127..127                       (SINTB)
  station_D9200.d (768)  the same two pages + page 2 = square root table: n = 0: 0, n <= 64: 16*round(sqrt(n)), n > 64: round(16*sqrt(n)) (255 max),
                  except n = 1, 2 (32) and the two irregular values of the original table listed in SQRT_EXCEPTIONS below
  ways.d   (702)  dotted rings around the map markers: assets/data/map_rings.txt (see that file)

Not computed (kept as binary files in assets/, see README): D9000.d (initial memory image of the 3D variable area, not a table), KORNI.d, ATAGTAB.d
(irregular tables of the original developers that no simple formula reproduces exactly)."""
import math, os, sys, re
HERE = os.path.dirname(os.path.abspath(__file__))

SQRT_EXCEPTIONS = {1: 32, 2: 32, 175: 211, 244: 240}      # values of the original table that differ from the formula


def rnd(x):
    return math.floor(x + 0.5)


def squares():
    return bytes((n * n) & 255 for n in range(256)) + bytes((n * n) >> 8 for n in range(256))


def cosine14():
    w = [rnd(16384 * math.cos(2 * math.pi * n / 256)) & 0xFFFF for n in range(256)]
    return bytes(v & 255 for v in w) + bytes(v >> 8 for v in w)


def mult_sine():
    f = lambda n: (n * n) // 127
    mult = bytes(f(n) if n < 128 else f(255 - n) for n in range(256))
    sine = bytes(max(-127, min(127, rnd(128 * math.sin(2 * math.pi * n / 256)))) & 255 for n in range(256))
    return mult + sine


def sqrt_page():
    out = []
    for n in range(256):
        if n in SQRT_EXCEPTIONS: out.append(SQRT_EXCEPTIONS[n])
        elif n == 0: out.append(0)
        elif n <= 64: out.append(16 * rnd(math.sqrt(n)))
        else: out.append(min(255, rnd(16 * math.sqrt(n))))
    return bytes(out)


def rings(path):
    """[ring r] sections of 'x y' lines -> bytes: per ring the points as signed byte pairs, then 0x80"""
    out = bytearray()
    ring = None
    for ln, l in enumerate(open(path, encoding='utf-8').read().split('\n'), 1):
        l = l.split('#')[0].strip()
        if not l: continue
        if l.startswith('['):
            if ring is not None: out.append(0x80)
            ring = l
            continue
        try:
            x, y = (int(a) for a in l.split())
            if not (-127 <= x <= 127 and -127 <= y <= 127): raise ValueError('-127..127 expected')
        except ValueError as e:
            raise SystemExit('map_rings.txt line %d: "x y" with numbers -127..127 expected (%s)' % (ln, e))
        out += bytes([x & 255, y & 255])
    out.append(0x80)
    return bytes(out)


def generate(root, outdir):
    os.makedirs(outdir, exist_ok=True)
    ms = mult_sine()
    files = {'0E0200.d': squares(), 'CSTB.d': cosine14(), 'D9200.d': ms, 'station_D9200.d': ms + sqrt_page(),
             'ways.d': rings(os.path.join(root, 'assets', 'data', 'map_rings.txt'))}
    for n, b in files.items():
        open(os.path.join(outdir, n), 'wb').write(b)
    return len(files)


if __name__ == '__main__':
    root = os.path.join(HERE, '..', '..')
    print('gen_math: %d files' % generate(root, os.path.join(root, 'build', 'gen')))
