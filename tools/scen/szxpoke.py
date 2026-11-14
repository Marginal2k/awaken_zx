#!/usr/bin/env python
"""szxpoke.py IN.szx OUT.szx ADDR=HEXBYTES [ADDR=HEXBYTES ...]

Patch RAM of an SZX snapshot as the CPU sees it (current #7FFD paging, addresses >= #4000), e.g.
    szxpoke.py fl_state.szx fl_dock.szx A244=0001
Used by the scenario files to place the ship inside the station's docking box (a documented test poke)."""
import struct, sys, zlib
sys.path.insert(0, __import__('os').path.join(__import__('os').path.dirname(__file__), '..', 'xp'))
d = bytearray(open(sys.argv[1], 'rb').read())
assert d[:4] == b'ZXST'
i = 8; chunks = []; p7 = None
while i < len(d):
    t = bytes(d[i:i+4]); l = int.from_bytes(d[i+4:i+8], 'little'); chunks.append((t, i, l)); i += 8 + l
    if t == b'SPCR': p7 = d[i - l + 1]
pokes = []
for a in sys.argv[3:]:
    if a == 'DOCK':      # every T_STATION (#12) record of the flight object table CARSB (#A200, 26 x #40 bytes): x=y=0, z=#0100
        for i in range(26):
            base = 0xA200 + 64 * i
            pokes.append(('DOCK', base))
        continue
    ad, hx = a.split('='); pokes.append((int(ad, 16), bytes.fromhex(hx)))
if any(p[0] == 'DOCK' for p in pokes):
    pg2 = None
    for t, st, l in chunks:
        if t == b'RAMP' and d[st+8+2] == 2:
            fl = int.from_bytes(d[st+8:st+10], 'little'); raw = bytes(d[st+11:st+8+l])
            pg2 = zlib.decompress(raw) if fl & 1 else raw
    new = []
    for ad, base in pokes:
        if ad != 'DOCK': new.append((ad, base)); continue
        if pg2[base - 0x8000 + 18] == 0x12: new.append((base, bytes([0, 0, 0, 0, 0, 1])))
    pokes = new
out = bytearray(d[:8])
for t, st, l in chunks:
    body = bytearray(d[st+8:st+8+l])
    if t == b'RAMP':
        flags = int.from_bytes(body[0:2], 'little'); pg = body[2]
        data = bytearray(zlib.decompress(bytes(body[3:])) if flags & 1 else body[3:])
        for ad, bs in pokes:
            for k, v in enumerate(bs):
                a = ad + k
                if 0x4000 <= a < 0x8000: want = 5; off = a - 0x4000
                elif a < 0xC000: want = 2; off = a - 0x8000
                else: want = p7 & 7; off = a - 0xC000
                if want == pg: data[off] = v
        body = body[:3] + (zlib.compress(bytes(data)) if flags & 1 else data)
    out += t + struct.pack('<I', len(body)) + body
open(sys.argv[2], 'wb').write(out)
