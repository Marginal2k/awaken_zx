#!/usr/bin/env python3
"""ONE-TIME extractor: model records in src/flight/OBJECTS*.asm and src/station/OBJX.asm -> assets/models/{flight,station}/NAME.txt + index.txt.
Usage: python tools/assets/extract_models.py <OBJECTS.asm> <OBJECTS2.asm> <OBJECTSS.asm> <OBJX.asm>   (the original db sources)
Checks that the text files regenerate exactly the original bytes."""
import sys, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import dbparse, models

ROOT = os.path.join(HERE, '..', '..')


def stream(path):
    L = open(path, encoding='utf-8').read().split('\n')
    L = [l + ':' if re.match(r'^[A-Za-z_]\w*\s*$', l) else l for l in L]
    data, labs = bytearray(), []
    for r in dbparse.parse_lines(L):
        if r[0] == 'label': labs.append((len(data), r[1]))
        elif r[0] == 'bytes': data += bytes(r[1])
        elif r[0] == 'other': raise SystemExit('unexpected line %r' % (r,))
    return bytes(data), labs


SETS = [('flight', 'OBJECTS'), ('flight', 'OBJECTS2'), ('flight', 'OBJECTSS'), ('station', 'OBJX')]
HEAD = {'flight': 'Flight objects: models in the order of the old source files OBJECTS.asm, OBJECTS2.asm, OBJECTSS.asm (the order is the memory layout of bank OBJ3D).',
        'station': 'Station 3D viewer models in the order of the old source OBJX.asm.'}
index = {'flight': [], 'station': []}
for (kind, name), path in zip(SETS, sys.argv[1:5]):
    data, labs = stream(path)
    ms = models.parse_binary(data, labs)
    d = os.path.join(ROOT, 'assets', 'models', kind)
    os.makedirs(d, exist_ok=True)
    index[kind].append((name, []))
    seen = set()
    for m in ms:
        fn = m['labels'][0] if m['labels'] else '_blank'
        if fn.lower() in seen:
            raise SystemExit('duplicate file name ' + fn)
        seen.add(fn.lower())
        txt = models.to_text(m, '%s (record of %s)' % (fn, name))
        open(os.path.join(d, fn + '.txt'), 'w', encoding='utf-8', newline='\n').write(txt)
        back = models.from_text(txt, fn)
        assert models.to_bytes(back) == models.to_bytes(m), fn
        index[kind][-1][1].append(fn)
    rebuilt = b''.join(models.to_bytes(models.from_text(open(os.path.join(d, (m['labels'][0] if m['labels'] else '_blank') + '.txt'), encoding='utf-8').read())) for m in ms)
    assert rebuilt == data, name
for kind, secs in index.items():
    with open(os.path.join(ROOT, 'assets', 'models', kind, 'index.txt'), 'w', encoding='utf-8', newline='\n') as f:
        f.write('# %s\n# One [SECTION] per generated include file (build/gen/<SECTION>.inc); the lines are the model files (NAME.txt) in this directory, in memory order.\n'
                '# Adding a model: create NAME.txt and add NAME here (and a reference to its label in the object index table of the code).\n' % HEAD[kind])
        for name, fns in secs:
            f.write('\n[%s]\n' % name + '\n'.join(fns) + '\n')
print('ok')
