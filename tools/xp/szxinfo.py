#!/usr/bin/env python
"""szxinfo.py SNAP.szx [--png PREFIX] [--mem ADDR:LEN] [--bank B:OFF:LEN] [--sym LABELS]

Reads an Xpeccy+ / ZX-State SZX snapshot (128K/Pentagon): prints registers, #7FFD, visible screen,
and optionally dumps memory as the CPU sees it (using the snapshot's #7FFD paging, ROM ignored),
a raw RAM bank, or writes both screens (bank 5 / bank 7) as PNG.
  --mem  #8000:32   hexdump through current paging (addresses hex with # or 0x, else decimal)
  --bank 7:0:64     RAM bank 7, offset 0, 64 bytes
  --png  out/prefix -> prefix_scr5.png, prefix_scr7.png
  --sym  FILE       sjasmplus LABELSLIST/--sym file: names the PC and SP-stack words (return addresses)
"""
import argparse, re, struct, sys, zlib


def parse(path):
    d = open(path, 'rb').read()
    assert d[:4] == b'ZXST', 'not an SZX'
    i = 8; blocks = {}; pages = {}
    while i < len(d):
        t = d[i:i+4]; l = int.from_bytes(d[i+4:i+8], 'little'); b = d[i+8:i+8+l]; i += 8 + l
        if t == b'RAMP':
            flags = int.from_bytes(b[0:2], 'little'); pg = b[2]; data = b[3:]
            pages[pg] = zlib.decompress(data) if flags & 1 else data
        else:
            blocks.setdefault(t, b)
    return d, blocks, pages


def regs(b):
    af, bc, de, hl, af_, bc_, de_, hl_, ix, iy, sp, pc = struct.unpack('<12H', b[:24])
    return dict(AF=af, BC=bc, DE=de, HL=hl, AF_=af_, BC_=bc_, DE_=de_, HL_=hl_, IX=ix, IY=iy, SP=sp, PC=pc,
                I=b[24], R=b[25], IFF1=b[26], IFF2=b[27], IM=b[28])


def cpu_mem(pages, p7ffd):
    def rd(a):
        a &= 0xFFFF
        if a < 0x4000: return 0xFF  # ROM not stored
        if a < 0x8000: return pages[5][a - 0x4000]
        if a < 0xC000: return pages[2][a - 0x8000]
        return pages[p7ffd & 7][a - 0xC000]
    return rd


PAL = [(0,0,0),(0,0,205),(205,0,0),(205,0,205),(0,205,0),(0,205,205),(205,205,0),(205,205,205),
       (0,0,0),(0,0,255),(255,0,0),(255,0,255),(0,255,0),(0,255,255),(255,255,0),(255,255,255)]


def png(path, W, H, px):
    raw = b''.join(b'\0' + px[y*W*3:(y+1)*W*3] for y in range(H))
    def ch(t, b): c = struct.pack('>I', len(b)) + t + b; return c + struct.pack('>I', zlib.crc32(t + b) & 0xffffffff)
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + ch(b'IHDR', struct.pack('>IIBBBBB', W, H, 8, 2, 0, 0, 0)) + ch(b'IDAT', zlib.compress(raw)) + ch(b'IEND', b''))


def scr_png(path, m, scale=2):
    W, H = 256*scale, 192*scale; px = bytearray(W*H*3)
    for y in range(H):
        sy = y // scale
        for x in range(W):
            sx = x // scale
            a = ((sy & 0xC0) << 5) | ((sy & 7) << 8) | ((sy & 0x38) << 2) | (sx >> 3)
            at = m[6144 + (sy >> 3)*32 + (sx >> 3)]
            on = (m[a] >> (7 - (sx & 7))) & 1
            c = PAL[(at & 7 if on else (at >> 3) & 7) + (8 if at & 64 else 0)]
            o = (y*W + x)*3; px[o:o+3] = bytes(c)
    png(path, W, H, bytes(px))


def num(s): return int(s[1:], 16) if s.startswith('#') else int(s, 0)


def load_sym(path):
    """sjasmplus --sym file ('NAME: EQU 0x0000ABCD') -> sorted [(addr, name)] (values >= 0x4000 only)"""
    syms = []
    for ln in open(path, encoding='utf8', errors='replace'):
        m = re.match(r'^\s*([\w.@?!]+):?\s+EQU\s+(?:0x|\$|#)?([0-9A-Fa-f]+)', ln)
        if m and int(m.group(2), 16) >= 0x4000 and int(m.group(2), 16) < 0x10000:
            syms.append((int(m.group(2), 16), m.group(1)))
    return sorted(syms)


def name(syms, a):
    best = None
    for v, n in syms:
        if v <= a: best = (v, n)
        else: break
    return f'{best[1]}+{a-best[0]}' if best else ''


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('szx'); ap.add_argument('--png'); ap.add_argument('--mem', action='append', default=[])
    ap.add_argument('--bank', action='append', default=[]); ap.add_argument('--sym'); ap.add_argument('--stack', type=int, default=0)
    a = ap.parse_args()
    d, bl, pages = parse(a.szx)
    r = regs(bl[b'Z80R']); p7 = bl[b'SPCR'][1]; syms = load_sym(a.sym) if a.sym else []
    print(' '.join(f'{k}={v:04X}' if k not in ('I', 'R', 'IFF1', 'IFF2', 'IM') else f'{k}={v:02X}' for k, v in r.items()))
    print(f'#7FFD={p7:02X} ram@C000={p7&7} screen={"7 (shadow)" if p7 & 8 else "5 (normal)"} rom={"48" if p7 & 16 else "128"}  border={bl[b"SPCR"][0]}')
    if syms: print('PC =', name(syms, r['PC']))
    rd = cpu_mem(pages, p7)
    if a.stack:
        for k in range(a.stack):
            w = rd(r['SP'] + 2*k) | rd(r['SP'] + 2*k + 1) << 8
            print(f'  stack[{k}] @{(r["SP"]+2*k)&0xFFFF:04X} = {w:04X} {name(syms, w) if syms else ""}')
    for m in a.mem:
        ad, ln = m.split(':'); ad = num(ad); ln = num(ln)
        for o in range(0, ln, 16):
            print(f'{(ad+o)&0xFFFF:04X}: ' + ' '.join(f'{rd(ad+o+k):02X}' for k in range(min(16, ln-o))))
    for m in a.bank:
        b, off, ln = (num(x) for x in m.split(':'))
        for o in range(0, ln, 16):
            print(f'bank{b}+{off+o:04X}: ' + ' '.join(f'{pages[b][off+o+k]:02X}' for k in range(min(16, ln-o))))
    if a.png:
        for b in (5, 7): scr_png(f'{a.png}_scr{b}.png', pages[b])
        print('wrote', a.png + '_scr5.png', a.png + '_scr7.png')


if __name__ == '__main__':
    main()
