#!/usr/bin/env python3
"""Structural parser for ZASM 3.10 tokenized sources.

Line model (see docs/ZASM_FORMAT.md):
  line   = [label] [06 pad] statements [comment]   | comment-only line | empty
  02..05 NN  = token reference (NN = index+0x20 in the table at za_3.10 0xCB97)
  06 NN      = (NN-0x80) blanks (editor tabulation)
  FE / ';'   = comment introducer (FE is shown as the black square in the editor)
  a line that starts with anything that is not a label character, 06 or ';'/FE is a bare comment
"""
import re
import zasm_detok

TAB = zasm_detok.default_table()
REG_LO, REG_HI = 0x77, 0x9a          # operand tokens (registers/conditions); everything else is a mnemonic/directive

LABEL_RE = re.compile(rb'^[A-Za-z_$@.?][A-Za-z0-9_$@.?]*')


class Line:
    __slots__ = ('kind', 'label', 'colon', 'code', 'comment', 'raw', 'cmark', 'bare')

    def __init__(self):
        self.kind = 'empty'; self.label = None; self.colon = False; self.code = []
        self.comment = None; self.raw = b''; self.cmark = ';'; self.bare = False


def decode_cp866(b):
    return b.decode('cp866', errors='replace')


def items_of(b):
    """bytes -> list of ('T', code) | ('P', n) | ('C', byte)"""
    out = []
    i = 0
    n = len(b)
    while i < n:
        c = b[i]
        if c in (2, 3, 4, 5) and i + 1 < n and b[i+1] in TAB:
            out.append(('T', b[i+1])); i += 2
        elif c == 6 and i + 1 < n:
            out.append(('P', b[i+1] - 0x80)); i += 2
        else:
            out.append(('C', c)); i += 1
    return out


def render_items(items):
    """items -> bytes of display text (tokens expanded, no space insertion)"""
    out = bytearray()
    for k, v in items:
        if k == 'T': out += TAB[v].encode()
        elif k == 'P': out += b' ' * v
        else: out.append(v)
    return bytes(out)


def parse_line(raw):
    L = Line()
    L.raw = raw
    if not raw:
        return L
    c0 = raw[0]
    if c0 == 0xFE or c0 == 0x3B:
        L.kind = 'comment'; L.cmark = 'FE' if c0 == 0xFE else ';'
        L.comment = decode_cp866(render_items(items_of(raw[1:])))
        return L
    body = raw
    if c0 != 6:
        m = LABEL_RE.match(raw)
        if not m:
            L.kind = 'comment'; L.bare = True
            L.comment = decode_cp866(render_items(items_of(raw)))
            return L
        # label chars; a label may be followed by ':' ; then 06 pad, EOL
        end = m.end()
        nxt = raw[end:end+1]
        colon = False
        if nxt == b':':
            colon = True; end += 1; nxt = raw[end:end+1]
        if nxt not in (b'', b'\x06', b'\x20') and not (nxt == b'\xfe' or nxt == b';'):
            # e.g. "X в в 2D ..." or label directly followed by token -> treat label+rest as code if token follows
            if nxt and nxt[0] in (2, 3, 4, 5):
                pass
            else:
                L.kind = 'comment'; L.bare = True
                L.comment = decode_cp866(render_items(items_of(raw)))
                return L
        if nxt == b'\x20':
            # label followed by a literal blank: bare comment ("X  text") unless only blanks follow
            rest = raw[end:].lstrip(b' ')
            if rest and rest[0] not in (2, 3, 4, 5, 6, 0x3b, 0xfe):
                L.kind = 'comment'; L.bare = True
                L.comment = decode_cp866(render_items(items_of(raw)))
                return L
        L.label = raw[:m.end()].decode('ascii'); L.colon = colon
        body = raw[end:]
    L.kind = 'code'
    items = items_of(body)
    # split comment (first ';' or FE outside quotes)
    q = None; cut = None
    for idx, (k, v) in enumerate(items):
        if k != 'C': continue
        if q:
            if v == q: q = None
            continue
        if v in (0x22, 0x27):
            q = v; continue
        if v in (0x3B, 0xFE):
            cut = idx; L.cmark = 'FE' if v == 0xFE else ';'
            break
    if cut is not None:
        L.comment = decode_cp866(render_items(items[cut+1:]))
        items = items[:cut]
    L.code = items
    if not L.code and L.label is None and L.comment is None:
        L.kind = 'empty'
    return L


def split_statements(items):
    """split on ':' outside quotes -> list of item lists"""
    stmts = [[]]
    q = None
    for k, v in items:
        if k == 'C':
            if q:
                if v == q: q = None
            elif v in (0x22, 0x27): q = v
            elif v == 0x3A:
                stmts.append([]); continue
        stmts[-1].append((k, v))
    return stmts


def parse_bytes(data):
    return [parse_line(r) for r in data.split(b'\r')]


def is_mnemonic_token(code):
    return not (REG_LO <= code <= REG_HI)
