"""Parser for ZASM-style `db`/`ds` blocks of the station data files (Windows-1251 source, ENCODING "DOS" = CP866 glyph codes).
Used by the one-time extractors (tools/assets/extract_*.py).  Not used by the build."""
import re
SYM = {'ET': 10, 'CR': 13, 'ED': 10}

def split_args(body):
    out, cur, q = [], '', False
    for ch in body:
        if ch == '"':
            q = not q; cur += ch
        elif ch == ',' and not q:
            out.append(cur.strip()); cur = ''
        else:
            cur += ch
    if cur.strip(): out.append(cur.strip())
    return out

def strip_comment(l):
    q = False
    for i, ch in enumerate(l):
        if ch == '"': q = not q
        elif ch == ';' and not q: return l[:i], l[i+1:]
    return l, ''

def num(x):
    x = x.strip()
    if x in SYM: return SYM[x]
    if x.startswith('#'): return int(x[1:], 16)
    if x.startswith('$') and len(x) > 1: return int(x[1:], 16)
    if x.startswith('%'): return int(x[1:], 2)
    return int(x)

def parse_arg(a, enc):
    if a.startswith('"'):
        return list(a[1:-1].encode(enc))
    return [num(a) & 0xFF]

def parse_lines(lines, enc='cp866'):
    """-> list of ('label',name) / ('bytes',[..],comment) / ('comment',text) / ('other',line)"""
    res = []
    for l in lines:
        code, com = strip_comment(l.rstrip('\r\n'))
        s = code.strip()
        if not s:
            if com.strip(): res.append(('comment', com.rstrip()))
            continue
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$', s)
        if m:
            res.append(('label', m.group(1))); s = m.group(2)
            if not s: continue
        m = re.match(r'^(db|DB)\s+(.*)$', s)
        if m:
            bs = []
            try:
                for a in split_args(m.group(2)): bs += parse_arg(a, enc)
            except ValueError:
                res.append(('other', l.rstrip())); continue
            res.append(('bytes', bs, com.strip())); continue
        m = re.match(r'^(dw|DW)\s+(.*)$', s)
        if m:
            bs = []
            try:
                for a in split_args(m.group(2)):
                    v = num(a)
                    bs += [v & 255, (v >> 8) & 255]
            except ValueError:
                res.append(('other', l.rstrip())); continue
            res.append(('bytes', bs, com.strip())); continue
        m = re.match(r'^ds\s+(\d+)\s*(?:,\s*(\S+))?$', s)
        if m:
            res.append(('bytes', [num(m.group(2)) if m.group(2) else 0] * int(m.group(1)), com.strip())); continue
        res.append(('other', l.rstrip()))
    return res
