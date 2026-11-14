#!/usr/bin/env python3
"""ZASM 3.10 tokenized source ('a' files, start=28019) -> plain text.

Token table: za_3.10 @ 0xCB97 (length-prefixed strings, code = index + 0x20).
Prefix bytes 02/03/04/05 + code = token reference; 06 NN = (NN-0x80) spaces; 0D = end of line.
See docs/ZASM_FORMAT.md
"""
import sys, os
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

def load_table(za):
    base = 25976
    i = 0xcb97 - base
    tab = {}
    n = 0
    while za[i] != 1:
        L = za[i]
        tab[0x20 + n] = za[i+1:i+L].decode('ascii')
        i += L; n += 1
    return tab

def default_table():
    p = ROOT + '/work/extract/awk1/za_3.10.e'
    return load_table(open(p, 'rb').read())

TAB = None

def detok_bytes(data, tab=None, raw_ctrl='keep'):
    """Return list of lines (bytes in CP866 for plain text parts; token text ascii)."""
    global TAB
    if tab is None:
        if TAB is None: TAB = default_table()
        tab = TAB
    out = bytearray()
    i = 0; n = len(data)
    while i < n:
        b = data[i]
        if b in (2, 3, 4, 5) and i + 1 < n:
            t = data[i+1]
            if t in tab:
                out += tab[t].encode('ascii'); i += 2; continue
            out += b'<?%02X%02X>' % (b, t); i += 2; continue
        if b == 6 and i + 1 < n:
            out += b' ' * (data[i+1] - 0x80); i += 2; continue
        if b == 0x0d:
            out += b'\n'; i += 1; continue
        out.append(b); i += 1
    return bytes(out)

def to_text(data, tab=None):
    """Editor view of a ZASM file (UTF-8 text).  Mnemonic tokens glued to their operand get one blank
    inserted (the editor shows them glued; the assembler does not need the blank)."""
    import zasm_parse as zp
    CR = bytes([13])
    parts = data.split(CR)
    if data.endswith(CR): parts = parts[:-1]
    out = []
    for raw in parts:
        L = zp.parse_line(raw)
        if L.kind == 'empty':
            out.append(''); continue
        if L.kind == 'comment':
            pre = '' if L.bare else (';' if L.cmark == ';' else chr(0x25a0))
            out.append(pre + L.comment); continue
        s = ''
        if L.label: s += L.label + (':' if L.colon else '')
        prev_mn = False
        for k, v in L.code:
            if k == 'T':
                if prev_mn: s += ' '
                s += zp.TAB[v]; prev_mn = zp.is_mnemonic_token(v)
            elif k == 'P':
                s += ' ' * v; prev_mn = False
            else:
                if prev_mn and v not in (0x20, 0x3a): s += ' '
                s += bytes([v]).decode('cp866'); prev_mn = False
        if L.comment is not None:
            s += (';' if L.cmark == ';' else chr(0x25a0)) + L.comment
        out.append(s)
    return chr(10).join(out) + chr(10)

if __name__ == '__main__':
    d = open(sys.argv[1], 'rb').read()
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stdout.write(to_text(d))
