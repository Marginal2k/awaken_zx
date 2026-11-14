#!/usr/bin/env python3
"""STORM-style plain text sources (decoded STORM files from awk2, text versions on awk4) -> sjasmplus.

usage: convert_storm.py <disk> <srcdir-in-original_src>   e.g.  convert_storm.py awk4   (uses *.txt.asm)  or  awk2 (uses *.storm.asm)
Reuses tools/convert.py (expression/statement conversion); STORM postfix operators  X[ = high(X)  X] = low(X)  X^ = round up to 256.
"""
import sys, os, re, json, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import zasm_parse as zp
import convert as cv


def split_comment(s):
    q = None
    for i, ch in enumerate(s):
        if q:
            if ch == q: q = None
            continue
        if ch in '"\'': q = ch; continue
        if ch == ';': return s[:i], s[i+1:]
    return s, None


def parse_text_line(s):
    L = zp.Line()
    s = s.rstrip('\r')
    L.raw = s.encode('cp866', errors='replace')
    if not s.strip():
        return L
    if s[0] == ';':
        L.kind = 'comment'; L.comment = s[1:]; return L
    body = s
    if not s[0].isspace():
        m = re.match(r'[^\s:]+', s)
        L.label = m.group(); body = s[m.end():]
        if body.startswith(':'): L.colon = True; body = body[1:]
    code, com = split_comment(body)
    L.comment = com
    L.kind = 'code'
    L.code = [('C', ord(ch) if ord(ch) < 128 else ch.encode('cp866', errors='replace')[0]) for ch in code]
    if not code.strip() and L.label is None and com is None: L.kind = 'empty'
    return L


def main():
    disk = sys.argv[1]
    pat = '.storm.asm' if disk == 'awk2' else '.txt.asm'
    cv.STATE['storm'] = True
    src = '%s/original_src/%s' % (ROOT, disk)
    out = '%s/src/legacy/experimental_storm/%s' % (ROOT, disk)
    os.makedirs(out + '/assets', exist_ok=True)
    files = sorted(f for f in os.listdir(src) if f.endswith(pat))
    namemap = {}
    for f in files:
        stem = f[:-len(pat)].split('~')[0]
        namemap[stem] = f[:-len(pat)] + '.asm'
    cat = json.load(open(ROOT + '/work/catalogue.json'))
    for dsk in ('awk2', disk):
      for c in cat[dsk]['files']:
        if c['type'] != 'a' and not (c['type'] == 'C' and (c['start'] == 49163 or c['start'] == c['length'])):
            shutil.copyfile('%s/work/extract/%s/%s' % (ROOT, dsk, c['file']), '%s/assets/%s' % (out, c['file']))
            namemap['@' + c['name'].rstrip() + '.' + c['type']] = 'assets/' + c['file']
            namemap.setdefault('@' + c['name'].rstrip(), 'assets/' + c['file'])
    nwarn = 0
    for f in files:
        name = f[:-len(pat)]
        lines = [parse_text_line(x) for x in open('%s/%s' % (src, f), encoding='utf8').read().split('\n')]
        if lines and lines[-1].kind == 'empty': lines.pop()
        c = cv.Converter(disk, name, None, namemap, lines=lines)
        text = c.convert()
        text = cv.fix_macros(text)
        open('%s/%s.asm' % (out, name), 'w', encoding='utf8', newline='\n').write(text)
        for w in c.warn: print('WARN', w); nwarn += 1
    print(disk, len(files), 'files,', nwarn, 'warnings ->', out)


main()
