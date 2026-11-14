#!/usr/bin/env python3
"""Regenerate src/storm/** from the STORM sources on the developer disks.

  awk2 / awk5  type C, start #C00B  : tokenized STORM files, decoded here with tools/storm_detok2.py (JP/CALL fix)
  awk4         type C, start==length: plain-text STORM exports (the editor's own text export)  -> src/storm/awk4/
  assets       every non-source type-C/B blob of awk2 -> src/storm/assets/NAME.bin  (cut to the catalogue length)

usage: python tools/storm_gen.py            (no arguments)
Files that are listed in MASTERS (src/storm/make_*.asm) are hand written and never overwritten.
"""
import sys, os, re, json
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import convert_storm as cs
import storm_detok2 as sd

OUT = ROOT + '/src/storm'
DEC = ROOT + '/work/storm/decoded'

# textual patches applied to the *decoded* text of a module before conversion: (module, old, new, count)
# ED_ : XR2 (disk file "XR2", 10427 bytes) is newer than S3D.C.  Its four 'JP NC,ED_' were 'JP NC,Ld73d' (x2) and
#       'JP NC,Ld73c' (x2) in the version that was compiled into S3D.C (they are still so in file "xR2").  ED_ is the
#       emergency exit of VSPRITE, which does not exist in the S3D build.
PATCH = {
    'XR2': [('JP NC,ED_', ['JP NC,Ld73d', 'JP NC,Ld73d', 'JP NC,Ld73c', 'JP NC,Ld73c'])],
}


def asset_files(cat):
    names = {}
    seen = {}
    res = []
    for c in cat['awk2']['files']:
        if c['type'] == 'C' and c['start'] == 49163: continue
        if c['name'].startswith(('sts', 'STORM', 'XAS', 'HC_')): continue
        nm = c['name'].rstrip()
        base = nm.replace('+', '_plus')
        k = base.lower()
        fn = base + ('_lc' if k in seen else '') + '.bin'
        seen[k] = 1
        res.append((nm, fn, c))
        names['B' + nm] = 'assets/' + fn
    return names, res


def apply_patch(mod, text):
    for old, news in PATCH.get(mod, []):
        parts = text.split(old)
        assert len(parts) == len(news) + 1, (mod, old, len(parts))
        text = parts[0] + ''.join(n + p for n, p in zip(news, parts[1:]))
    return text


def header(src, mod, extra=''):
    return '; %s -- restored from %s%s\n; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)\n' % (mod, src, extra)


def main():
    cat = json.load(open(ROOT + '/work/catalogue.json'))
    names, assets = asset_files(cat)
    os.makedirs(OUT + '/assets', exist_ok=True)
    os.makedirs(OUT + '/awk4', exist_ok=True)
    os.makedirs(OUT + '/awk5', exist_ok=True)
    for nm, fn, c in assets:
        data = open('%s/work/extract/awk2/%s' % (ROOT, c['file']), 'rb').read()[:c['length']]
        open('%s/assets/%s' % (OUT, fn), 'wb').write(data)
    nmap = {}
    for k, v in names.items():
        nmap[k] = v
        nmap[k[1:]] = v
    nwarn = 0
    # ---- awk2 / awk5
    for disk, sub in (('awk2', ''), ('awk5', 'awk5/')):
        os.makedirs(DEC + '/' + disk, exist_ok=True)
        for c in cat[disk]['files']:
            if not (c['type'] == 'C' and c['start'] == 49163): continue
            B = open('%s/work/extract/%s/%s' % (ROOT, disk, c['file']), 'rb').read()[:c['length']]
            text, w = sd.detok(B)
            mod = c['name'].rstrip().replace('+', '_plus')
            if disk == 'awk2' and c['file'] == 'xR2.C': mod = 'XR2_lc'
            open('%s/%s/%s.txt' % (DEC, disk, mod), 'w', encoding='utf8', newline='\n').write(text)
            text = apply_patch(mod, text)
            ws = []
            conv = cs.Conv(names={**nmap, 'LXR2': 'XR2.asm'}, warn=ws.append)
            out = conv.convert(text)
            if c['file'] == 'xR2.C':
                pass
            fn = '%s/%s%s.asm' % (OUT, sub, mod)
            open(fn, 'w', encoding='utf8', newline='\n').write(header('%s/%s (%d bytes, STORM tokenized)' % (disk, c['file'], c['length']), mod) + out)
            for x in ws: print('WARN', disk, mod, x); nwarn += 1
    # ---- awk4 plain text
    for c in cat['awk4']['files']:
        if not (c['type'] == 'C' and c['start'] == c['length']): continue
        raw = open('%s/work/extract/awk4/%s' % (ROOT, c['file']), 'rb').read()[:c['length']]
        text = raw.decode('cp866').replace('\r\n', '\n').replace('\r', '\n')
        mod = c['name'].rstrip()
        ws = []
        conv = cs.Conv(names=nmap, warn=ws.append)
        out = conv.convert(text)
        open('%s/awk4/%s.asm' % (OUT, mod), 'w', encoding='utf8', newline='\n').write(
            header('awk4/%s (%d bytes, plain-text STORM export)' % (c['file'], c['length']), mod) + out)
        for x in ws: print('WARN awk4', mod, x); nwarn += 1
    print('done, %d warnings' % nwarn)


if __name__ == '__main__':
    main()
