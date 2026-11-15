"""Human text form <-> game bytes (CP866 glyph codes).  See assets/README.md for the notation.
  \\n = CR (#0D, new line)   {stop} = #01   {tab1}..{tab5} = #02..#06   {nbsp} = #FF (non-breaking blank)   {sp} = explicit blank
  {xNN} = any byte (hex)     \\\\ = backslash   \\{ = brace   Cyrillic is typed as normal letters (stored as CP866)."""
import re
BS = chr(92)
NAMED = {'stop': 1, 'tab1': 2, 'tab2': 3, 'tab3': 4, 'tab4': 5, 'tab5': 6, 'nbsp': 255, 'sp': 32}
REV = {1: '{stop}', 2: '{tab1}', 3: '{tab2}', 4: '{tab3}', 5: '{tab4}', 6: '{tab5}', 255: '{nbsp}'}
ET = 10
CR = 13


def b2t(bs):
    out = []
    i = 0
    bs = list(bs)
    while i < len(bs):
        c = bs[i]
        if c == 255:
            j = i
            while j < len(bs) and bs[j] == 255:
                j += 1
            n = j - i
            out.append('{nbsp}' if n == 1 else '{nbsp*%d}' % n)
            i = j
            continue
        if c in REV:
            out.append(REV[c])
        elif c == CR:
            out.append(BS + 'n')
        elif c == 92:
            out.append(BS + BS)
        elif c == 123:
            out.append(BS + '{')
        elif 32 <= c < 127:
            out.append(chr(c))
        elif 128 <= c < 176 or 224 <= c < 242:
            out.append(bytes([c]).decode('cp866'))
        else:
            out.append('{x%02X}' % c)
        i += 1
    s = ''.join(out)
    # protect leading / trailing blanks (editors strip them)
    if s.startswith(' '):
        s = '{sp}' + s[1:]
    if s.endswith(' '):
        s = s[:-1] + '{sp}'
    return s


def t2b(s, where=''):
    out = []
    i = 0
    while i < len(s):
        ch = s[i]
        if ch == BS:
            n = s[i+1:i+2]
            if n == 'n':
                out.append(CR)
            elif n in (BS, '{'):
                out.append(ord(n))
            else:
                raise ValueError('bad escape %s%s in %s' % (BS, n, where))
            i += 2
        elif ch == '{':
            j = s.index('}', i)
            tag = s[i+1:j]
            i = j + 1
            m = re.fullmatch(r'nbsp\*(\d+)', tag)
            if m:
                out += [255] * int(m.group(1))
            elif tag in NAMED:
                out.append(NAMED[tag])
            elif re.fullmatch(r'x[0-9A-Fa-f]{2}', tag):
                out.append(int(tag[1:], 16))
            else:
                raise ValueError('bad tag {%s} in %s' % (tag, where))
        else:
            try:
                out += list(ch.encode('cp866'))
            except UnicodeEncodeError:
                raise ValueError('character %r (U+%04X) is not in the game code page CP866 (%s)' % (ch, ord(ch), where))
            i += 1
    return bytes(out)

# ---- file format -------------------------------------------------------------------------------
#  [LABEL]  or  [LABEL first=1]           section header
#  # ...                                    comment (ignored)
#  12 | text                                item 12 (ET #0A appended);  12 ~ text = last item without ET
#     | more text                           continuation (appended directly)


def parse_file(path):
    """-> list of (label, opts, [(id, bytes, has_et)])"""
    secs = []
    cur = None
    last = None
    for ln, raw in enumerate(open(path, encoding='utf-8').read().split('\n'), 1):
        line = raw.rstrip('\r')
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        m = re.match(r'^\[(\S+)((?:\s+\S+=\S+)*)\]\s*$', line)
        if m:
            opts = dict(kv.split('=') for kv in m.group(2).split())
            cur = (m.group(1), opts, [])
            secs.append(cur)
            last = None
            continue
        m = re.match(r'^(\d+)\s*([|~])(?: ?(.*))?$', line)
        if m and cur is not None:
            txt = (m.group(3) or '').rstrip()
            last = [int(m.group(1)), txt, m.group(2) == '|']
            cur[2].append(last)
            continue
        m = re.match(r'^\s+\|(?: ?(.*))?$', line)
        if m and last is not None:
            last[1] += (m.group(1) or '').rstrip()
            continue
        raise ValueError('%s:%d: cannot parse: %r' % (path, ln, line))
    res = []
    for lab, opts, items in secs:
        first = int(opts.get('first', 0))
        out = []
        for k, (i, txt, et) in enumerate(items):
            if i != first + k:
                raise ValueError('%s [%s]: item numbers must be consecutive, got %d, expected %d' % (path, lab, i, first + k))
            out.append((i, t2b(txt, '%s [%s] item %d' % (path, lab, i)), et))
        res.append((lab, opts, out))
    return res


def section_bytes(items, end=ET):
    b = bytearray()
    for i, bs, et in items:
        b += bs
        if et:
            b.append(end)
    return bytes(b)


def write_sections(path, header, sections):
    """sections: list of (label, opts, comments[list], items[list of bytes], last_has_et)"""
    o = [header.rstrip('\n'), '']
    for sec in sections:
        lab, opts, comments, items, last_et = sec[:5]
        crlist = len(sec) > 5 and sec[5]
        o.append('[%s%s]' % (lab, ''.join(' %s=%s' % kv for kv in opts.items())))
        for c in comments:
            o.append('# ' + c if c else '#')
        first = int(opts.get('first', 0))
        for k, bs in enumerate(items):
            sep = '~' if (k == len(items) - 1 and not last_et) else '|'
            t = b2t(bs)
            parts = t.split(BS + 'n')
            lines = [p + (BS + 'n' if n < len(parts) - 1 else '') for n, p in enumerate(parts)]
            for n, ln in enumerate(lines):
                if n == 0:
                    o.append('%d %s %s' % (first + k, sep, ln) if ln else '%d %s' % (first + k, sep))
                else:
                    if crlist:
                        o.append('    # line %d' % n)
                    o.append('    | ' + ln)
        o.append('')
    open(path, 'w', encoding='utf-8', newline='\n').write('\n'.join(o))


def emit_db(bs):
    """bytes -> asm db lines (generated files are numbers only: independent of source encodings)"""
    return ''.join('            db   ' + ','.join(str(c) for c in bs[i:i+16]) + '\n' for i in range(0, len(bs), 16))
