"""Hrust 1.x ("HR") packer / depacker, the format of the game's DEPACK / DEHRUST routine (src/station/BODY.asm:847, src/flight/BODY.asm:436).

File layout:  'H' 'R'  <u16 unpacked size>  <u16 packed file size>  <6 bytes = the LAST 6 bytes of the unpacked data>  <bit/byte stream>
The stream is read by the Z80 code with a 16-bit bit buffer (MSB first, refilled with the next two stream bytes right after the 16th bit has been
consumed) and plain bytes taken from the same stream.  Commands (flag bit 1 = literal byte follows):
  0, <length code>, <offset>   copy; length code = base-3 chunks of 2 bits  ('00','01','10' = value+1, '11' = add 3 and continue)
        A=1..3 -> length A, A=5..16 -> length A-1, A=4 = long form:  '00' + 7 bits N : N=15 end of data, N<15: length = N*256 + next byte, N>15: length = N
        offsets:  length 1: 3 bits (1..8)
                  length 2: '11'+5 bits (1..32) '10'+byte (33..256) '01'+byte (257..512) '00'+byte (513..768)
                  length>=3: '10'+5 bits (1..32) '01'+byte (33..256) '00'+byte (257..512) '11'+k bits H' + byte  (k = 2 + number of "widen" commands)
                  with the byte L: offset = (256-H)*256 - L, H = 0xFF<<k | H' ; (byte >= 0xE0 with H=0xFF = special commands, not used here)
        "widen" command = a copy of length 2 with prefix '10' and byte 0xFE: rotates the window register D (one more bit for the '11' class)
This module writes valid streams (not byte-identical to the original packer, which used more command forms) and reads all of them.
"""
import sys

DEFAULT_D = 0xBF


class BitWriter:
    def __init__(self):
        self.out = bytearray()
        self.wpos = None
        self.nbits = 16          # force reservation of the first word
        self.word = 0

    def _flush_word(self):
        self.out[self.wpos] = self.word & 255
        self.out[self.wpos + 1] = self.word >> 8

    def start(self):
        self.wpos = len(self.out)
        self.out += bytes(2)
        self.word = 0
        self.nbits = 0

    def bit(self, b):
        if self.nbits == 16:
            self.wpos = len(self.out)
            self.out += bytes(2)
            self.word = 0
            self.nbits = 0
        self.word = (self.word << 1) | (b & 1)
        self.nbits += 1
        if self.nbits == 16:
            self._flush_word()
            # the decoder fetches the next word right after the 16th bit: reserve it now (before any byte that follows)
            self.wpos = len(self.out)
            self.out += bytes(2)
            self.word = 0
            self.nbits = 0

    def bits(self, value, n):
        for i in range(n - 1, -1, -1):
            self.bit((value >> i) & 1)

    def byte(self, v):
        self.out.append(v & 255)

    def finish(self):
        if self.nbits:
            self.word <<= (16 - self.nbits)
            self._flush_word()
        else:
            # a reserved but unused word: the decoder has fetched it, keep it
            pass
        return bytes(self.out)


def len_bits(A):
    """bits of the length code value A (1..16)"""
    m, c = divmod(A - 1, 3)
    if A == 16:
        return [1, 1] * 5
    return [1, 1] * m + [c >> 1, c & 1]


def length_to_A(L):
    return L if L <= 3 else L + 1


def offset_tokens(L, d, k):
    """-> (bits list of (value, nbits) items, byte or None) for copy length L (2..15 or >=3 generic) at distance d with the current window k;
    returns None when not encodable"""
    if L == 1:
        return ([(8 - d, 3)], None) if 1 <= d <= 8 else None
    if L == 2:
        if 1 <= d <= 32: return ([(0b11, 2), (32 - d, 5)], None)
        if 33 <= d <= 256: return ([(0b10, 2)], 256 - d)
        if 257 <= d <= 512: return ([(0b01, 2)], 512 - d)
        if 513 <= d <= 768: return ([(0b00, 2)], 768 - d)
        return None
    if 1 <= d <= 32: return ([(0b10, 2), (32 - d, 5)], None)
    if 33 <= d <= 256: return ([(0b01, 2)], 256 - d)
    if 257 <= d <= 512: return ([(0b00, 2)], 512 - d)
    # extended class '11' + k bits + byte
    hi = d - 1 >> 8                 # (256-H) - 1 where d in ((256-H)*256-255 .. (256-H)*256)
    if hi < 0: return None
    # d = (256-H)*256 - L  with L in 0..255  ->  256-H = ceil(d/256)
    q = (d + 255) // 256
    H = 256 - q
    if H < 0 or H < (0xFF << k) & 0xFF:
        return None
    if H == 0xFF:
        return None
    Lb = q * 256 - d
    if Lb > 255: return None
    return ([(0b11, 2), (H & ((1 << k) - 1), k)], Lb)


def emit_copy(w, L, d, k):
    """emit a copy command; returns False if not encodable"""
    if L >= 4096 or L < 1:
        return False
    # length code
    if L <= 15:
        lb = len_bits(length_to_A(L))
        longform = None
    else:
        lb = [1, 1, 0, 0]          # A=4: long form
        longform = L
    ot = offset_tokens(L, d, k) if L <= 15 else offset_tokens(max(L, 3), d, k)
    if ot is None:
        return False
    w.bit(0)
    for b in lb: w.bit(b)
    if longform is not None:
        w.bits(0, 2)
        if L <= 127:
            w.bits(L, 7)
        else:
            w.bits(L >> 8, 7)
            w.byte(L & 255)
    items, byte = ot
    for v, n in items: w.bits(v, n)
    if byte is not None: w.byte(byte)
    return True


def copy_cost(L, d, k):
    """cost in bits of a copy command or None"""
    if L < 1 or L >= 4096: return None
    if L <= 15:
        c = 1 + len(len_bits(length_to_A(L)))
        ot = offset_tokens(L, d, k)
    else:
        c = 1 + 4 + 2 + 7 + (8 if L > 127 else 0)
        ot = offset_tokens(max(L, 3), d, k)
    if ot is None: return None
    items, byte = ot
    return c + sum(n for v, n in items) + (8 if byte is not None else 0)


def widen_needed(maxd):
    """smallest k such that the extended class covers distance maxd (k=2 is the default window)"""
    k = 2
    while True:
        # coverage of class '11': H from (0xFF<<k) .. 0xFE  ->  d up to (256 - ((0xFF<<k) & 0xFF)) * 256
        if (256 - ((0xFF << k) & 0xFF)) * 256 >= maxd or k >= 7:
            return k
        k += 1


def pack(data, maxk=None):
    data = bytes(data)
    n = len(data)
    if n < 8:
        raise ValueError('too short')
    body = data[:n - 6]
    tail = data[n - 6:]
    m = len(body)
    # window: try every k and keep the smallest result
    best = None
    k0 = widen_needed(m)
    for k in sorted(set([k0, max(2, k0 - 1)])):
        r = _pack_k(body, k)
        if best is None or len(r) < len(best[1]):
            best = (k, r)
    k, stream = best
    packed_len = 12 + len(stream)
    hdr = b'HR' + n.to_bytes(2, 'little') + packed_len.to_bytes(2, 'little') + tail
    return hdr + stream


def _pack_k(body, k):
    m = len(body)
    INF = 1 << 60
    # candidate matches per position through a 2-byte hash
    maxd = (256 - ((0xFF << k) & 0xFF)) * 256
    pos2 = {}
    cost = [INF] * (m + 1)
    choice = [None] * (m + 1)
    cost[0] = 0
    # the first byte is an implicit literal (no flag): DP starts at position 1
    cost[1] = 8
    choice[1] = (0, 0, 0)
    # forward DP
    chains = {body[0:2]: [0]}
    for i in range(1, m):
        ci = cost[i]
        if ci >= INF:
            pass
        # literal
        if ci + 9 < cost[i + 1]:
            cost[i + 1] = ci + 9
            choice[i + 1] = (i, 0, 0)
        if i + 1 < m:
            key = body[i:i + 2]
            cand = chains.get(key, [])
            seen = 0
            bestlen_for_d = []
            for j in reversed(cand):
                d = i - j
                if d > maxd: break
                L = 2
                lim = min(m - i, 400)
                while L < lim and body[j + L - d + d - d + 0] == body[i + L] if False else False:
                    L += 1
                # explicit compare
                L = 2
                while L < lim and body[i + L] == body[i + L - d]:
                    L += 1
                bestlen_for_d.append((d, L))
                seen += 1
                if seen >= 48 and L < 8:
                    pass
                if seen >= 24:
                    break
            for d, Lmax in bestlen_for_d:
                lens = set([Lmax, 2, 3])
                lens.update(range(2, min(Lmax, 17) + 1))
                for t in (127, 128, 255, 256):
                    if t <= Lmax: lens.add(t)
                for L in lens:
                    if L > Lmax: continue
                    c = copy_cost(L, d, k)
                    if c is None: continue
                    if ci + c < cost[i + L]:
                        cost[i + L] = ci + c
                        choice[i + L] = (i, L, d)
            chains.setdefault(key, []).append(i)
    # trace back
    cmds = []
    p = m
    while p > 0:
        i, L, d = choice[p]
        cmds.append((i, L, d))
        p = i
    cmds.reverse()
    w = BitWriter()
    w.start()
    w.byte(body[0])          # implicit first literal
    # widen commands first
    for _ in range(k - 2):
        w.bit(0); [w.bit(b) for b in len_bits(2)]; w.bits(0b10, 2); w.byte(0xFE)
    for i, L, d in cmds:
        if i == 0:
            continue
        if L == 0:
            w.bit(1); w.byte(body[i])
        else:
            assert emit_copy(w, L, d, k), (L, d, k)
    # end marker: flag 0, A=4 (1100), 00, 7 bits = 15
    w.bit(0)
    for b in (1, 1, 0, 0): w.bit(b)
    w.bits(0, 2); w.bits(15, 7)
    return w.finish()


def unpack(packed):
    """reference depacker = the real game routine run in a Z80 core (tools/assets/z80depack.py)"""
    import z80depack
    return z80depack.depack(packed)
