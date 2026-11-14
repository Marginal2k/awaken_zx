#!/usr/bin/env python3
"""Detokenize every source found in work/extract -> original_src/<disk>/<name>.asm (+ index)."""
import os, sys, json, hashlib, re
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import zasm_detok, storm_detok

def is_text(d):
    return len(d) > 0 and all(b == 0x0d or b == 0x0a or b >= 0x20 for b in d) and b'\r' in d

def main():
    cat = json.load(open(ROOT + '/work/catalogue.json'))
    idx = []
    used = set()
    for dn, d in cat.items():
        if not dn.startswith('awk'): continue
        for c in d['files']:
            p = '%s/work/extract/%s/%s' % (ROOT, dn, c['file'])
            data = open(p, 'rb').read()
            ln = c['length']
            fmt = None; text = None; warn = []
            if c['type'] == 'a' and c['start'] == 28019:
                fmt = 'zasm'; text = zasm_detok.to_text(data[:ln])
            elif c['type'] == 'C' and c['start'] == 49163 and c['name'].strip() not in ('LOADER',) or (c['type'] == 'C' and c['start'] == 49163):
                try:
                    t, w = storm_detok.detok(data[:ln])
                    fmt = 'storm'; text = t; warn = w
                except Exception as e:
                    warn = ['STORM failed: %r' % e]
            elif c['type'] == 'C' and c['start'] == c['length'] and c['length'] <= len(data) and is_text(data[:ln]):
                fmt = 'text'; text = data[:ln].decode('cp866').replace('\r', '\n')
            if fmt is None: continue
            od = '%s/original_src/%s' % (ROOT, dn)
            os.makedirs(od, exist_ok=True)
            fn = re.sub(r'\.[^.]*$', '', c['file']) if c['type'] != 'C' else c['file'].rsplit('.', 1)[0]
            ext = {'zasm': 'asm', 'storm': 'storm.asm', 'text': 'txt.asm'}[fmt]
            out = '%s/%s.%s' % (od, fn, ext)
            if out.lower() in used:
                out = '%s/%s~%d.%s' % (od, fn, c['idx'], ext)
            used.add(out.lower())
            open(out, 'w', encoding='utf-8', newline='\n').write(text)
            idx.append(dict(disk=dn, name=c['name'].rstrip(), fmt=fmt, out=os.path.relpath(out, ROOT), lines=text.count('\n'),
                            md5=hashlib.md5(text.encode()).hexdigest(), warn=warn))
    json.dump(idx, open(ROOT + '/work/source_index.json', 'w'), indent=1, ensure_ascii=False)
    print(len(idx), 'sources;', sum(1 for i in idx if i['warn']), 'with warnings')
    for i in idx:
        if i['warn']: print(i['out'], i['warn'])
main()
