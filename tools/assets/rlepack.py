"""Packer for the intro closing picture ("Awaken - Second Breeze") for edited pictures: a tiny RLE format with its own 41-byte depacker (machine code below).
The ORIGINAL picture is stored by the 1999 packer (assets/gfx/orig/intro_depack.bin) which has no known compressor; as long as the picture is not changed
that original blob is used (byte-identical build).  A changed picture is packed with this module instead.

Blob layout (same contract as the original: the intro copies the blob to the screen-overlay area and does `call` on its first byte; the blob
depacks the 6912 bytes of a ZX screen (bitmap + attributes, ZX screen byte order) to #4000 and returns):
    code (41 bytes, position independent), then the token stream:
    control byte c:  0          end
                     1..127     c literal bytes follow
                     128..255   repeat: (c & 127) + 2 copies of the next byte
Z80 source of the depacker (assembled by hand):
        ld   de,#4000
        ld   bc,DATA-L1          ; L1 = address of the instruction after the CALL
        xor  a : inc a           ; NZ for the ROM routine
        call #1FC6               ; ROM: pop hl / ret z / jp (hl)   -> HL = L1, continues at L1
L1:     add  hl,bc               ; hl = data
LOOP:   ld   a,(hl) : inc hl : or a : ret z
        ld   c,a : rlca : jr c,REP
        ld   b,0 : ldir : jr LOOP
REP:    ld   a,c : and #7F : add a,2 : ld c,a : ld a,(hl) : inc hl
R1:     ld   (de),a : inc de : dec c : jr nz,R1 : jr LOOP
"""
CODE = bytes([0x11, 0x00, 0x40, 0x01, 0x1E, 0x00, 0xAF, 0x3C, 0xCD, 0xC6, 0x1F, 0x09,
              0x7E, 0x23, 0xB7, 0xC8, 0x4F, 0x07, 0x38, 0x06, 0x06, 0x00, 0xED, 0xB0, 0x18, 0xF2,
              0x79, 0xE6, 0x7F, 0xC6, 0x02, 0x4F, 0x7E, 0x23, 0x12, 0x13, 0x0D, 0x20, 0xFB, 0x18, 0xE3])
assert len(CODE) == 0x29


def pack(scr):
    out = bytearray(CODE)
    i, n = 0, len(scr)
    lit = bytearray()

    def flush():
        while lit:
            chunk = lit[:127]
            out.append(len(chunk)); out.extend(chunk)
            del lit[:127]
    while i < n:
        j = i
        while j < n and scr[j] == scr[i] and j - i < 129:
            j += 1
        if j - i >= 3:
            flush()
            out.append(0x80 | (j - i - 2)); out.append(scr[i])
            i = j
        else:
            lit.append(scr[i]); i += 1
    flush()
    out.append(0)
    return bytes(out)


def depack(blob, load=0x7000):
    """check helper: run the blob in the Z80 core, return the 6912 bytes at #4000"""
    import zx, warnings
    warnings.filterwarnings('ignore')
    s = zx.Spectrum(); s.reset_and_wait()
    s.write(0x4000, bytes(6912))
    s.write(load, blob)
    s.iff1 = False; s.iff2 = False
    s.sp = 0xBF00; s.write(0xBF00, bytes([0x00, 0xB0])); s.write(0xB000, bytes([0x18, 0xFE]))
    s.pc = load
    s.run(duration=2.0, fast_forward=True)
    assert s.pc == 0xB000, 'depacker did not return'
    return s.read(0x4000, 6912)
