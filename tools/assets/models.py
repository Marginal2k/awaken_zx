"""3D object models: binary record <-> text file.  Used by extract_models.py (one-time) and gen_models.py (build).

Binary record (flight RENOBJ / REMOVEOBJ in src/flight, station viewer the same):
    byte 0           radius      (bounding size; not read by the renderer, kept as data)
    byte 1           scale       (size shift: the renderer shifts the projected coordinates by 6 - scale bits, so a bigger value = a bigger picture)
    groups, 4 bytes each:  mask, x, y, z   (x y z signed bytes), ended by one 00 byte
                     mask bit n (n = 0..7) = "make the copy whose x is negated if n&1, y if n&2, z if n&4"; so mask 01 is one point,
                     0F = mirrored in x and y (4 points), 33 = mirrored in x and z, FF = all 8.  The copies get the vertex numbers
                     0,1,2... in the order bit 0,1,3,2,6,7,5,4 (the order the renderer generates them), over all groups in file order.
    faces:           first byte F, then n vertex references, n = F & 15; references are vertex number * 5 (the renderer's 5-byte slot).
                     F bit 7 = 0: polygon, bits 4-6 = fill pattern (0..7), n = number of corners (3..8)
                     F bit 7 = 1: polyline, bit 6 = draw only if the previous polygon was visible, bits 4-5: 0 = AND, 1 = OR, 2/3 = XOR drawing mode
    00               end of the model (a face byte with n = 0)
Some face records carry a label in the old source (P00xxx, P01xxx): the program patches the first byte of that face at run time (engine flicker),
so the label must stay at that face: written as `label NAME` before the face.

Text file:
    # comment
    model NAME [ALIAS ...]          label(s) at the start of the record ('-' = none)
    radius N
    scale N
    group x y z mirror=xy           mirror = none|x|y|z|xy|xz|yz|xyz (copies = all sign combinations of the named axes), or mask=0xNN
    label NAME                      (before a face line) label on that face
    poly P v v v ...                polygon, fill pattern P 0..7, v = vertex numbers (3..8 corners)
    line F v v ...                  polyline, F = high nibble of the face byte (8..15, see above), v = vertex numbers
"""
import re

ORDER = [0, 1, 3, 2, 6, 7, 5, 4]
MIRRORS = {'none': 0x01, 'x': 0x03, 'y': 0x05, 'z': 0x11, 'xy': 0x0F, 'xz': 0x33, 'yz': 0x55, 'xyz': 0xFF}
MIRROR_OF = {v: k for k, v in MIRRORS.items()}


def s8(v):
    return v - 256 if v > 127 else v


def expand(mask, x, y, z):
    out = []
    for n in ORDER:
        if mask >> n & 1:
            out.append((-x if n & 1 else x, -y if n & 2 else y, -z if n & 4 else z))
    return out


def parse_binary(data, labels):
    """data: bytes of a whole object file; labels: [(offset, name)] -> list of models (dict)"""
    labd = {}
    for o, n in labels:
        labd.setdefault(o, []).append(n)
    pos, models = 0, []
    while pos < len(data):
        m = {'labels': labd.get(pos, []), 'radius': data[pos], 'scale': data[pos + 1], 'groups': [], 'faces': []}
        p = pos + 2
        while data[p] != 0:
            m['groups'].append((data[p], s8(data[p + 1]), s8(data[p + 2]), s8(data[p + 3])))
            p += 4
        p += 1
        while True:
            n = data[p] & 15
            if n == 0:
                break
            m['faces'].append({'labels': labd.get(p, []), 'byte': data[p], 'v': [i // 5 for i in data[p + 1:p + 1 + n]],
                               'raw': [i for i in data[p + 1:p + 1 + n]]})
            for i in data[p + 1:p + 1 + n]:
                if i % 5:
                    raise ValueError('vertex reference %d is not a multiple of 5' % i)
            p += n + 1
        m['end_labels'] = labd.get(p, [])      # a label right at the final 00 (none in practice)
        p += 1
        models.append(m)
        pos = p
    return models


def nverts(m):
    return sum(len(expand(*g)) for g in m['groups'])


def to_text(m, title=''):
    out = []
    if title:
        out.append('# ' + title)
    out.append('model ' + (' '.join(m['labels']) if m['labels'] else '-'))
    out.append('radius %d' % m['radius'])
    out.append('scale %d' % m['scale'])
    out.append('# group x y z mirror   -> vertex numbers (copies of the point, see tools/assets/models.py)')
    k = 0
    for mask, x, y, z in m['groups']:
        cnt = len(expand(mask, x, y, z))
        spec = ('mirror=' + MIRROR_OF[mask]) if mask in MIRROR_OF else ('mask=0x%02X' % mask)
        out.append('group %d %d %d %s        # v%d%s' % (x, y, z, spec, k, ('..v%d' % (k + cnt - 1)) if cnt > 1 else ''))
        k += cnt
    out.append('# faces: poly <fill 0..7> <vertex numbers>   |   line <flags 8..15> <vertex numbers>')
    for f in m['faces']:
        for l in f['labels']:
            out.append('label ' + l)
        b = f['byte']
        out.append(('line %d ' % (b >> 4) if b & 0x80 else 'poly %d ' % (b >> 4)) + ' '.join(map(str, f['v'])))
    for l in m['end_labels']:
        out.append('label ' + l)
    return '\n'.join(out) + '\n'


def from_text(text, where='model'):
    m = {'labels': [], 'radius': None, 'scale': None, 'groups': [], 'faces': [], 'end_labels': []}
    pending = []
    for ln, l in enumerate(text.split('\n'), 1):
        l = l.split('#')[0].strip()
        if not l:
            continue
        w = l.split()
        k = w[0]
        try:
            if k == 'model':
                m['labels'] = [] if w[1:] == ['-'] else w[1:]
            elif k == 'radius':
                m['radius'] = int(w[1], 0)
            elif k == 'scale':
                m['scale'] = int(w[1], 0)
            elif k == 'group':
                x, y, z = (int(a, 0) for a in w[1:4])
                if not all(-128 <= a <= 127 for a in (x, y, z)):
                    raise ValueError('coordinates must be -128..127')
                s = w[4]
                if s.startswith('mirror='):
                    mask = MIRRORS[s[7:]]
                elif s.startswith('mask='):
                    mask = int(s[5:], 0)
                else:
                    raise ValueError('mirror=... or mask=... expected')
                if not 1 <= mask <= 255:
                    raise ValueError('mask must be 1..255')
                m['groups'].append((mask, x, y, z))
            elif k == 'label':
                pending.append(w[1])
            elif k in ('poly', 'line'):
                hi = int(w[1], 0)
                vs = [int(a, 0) for a in w[2:]]
                if k == 'poly' and not 0 <= hi <= 7:
                    raise ValueError('poly fill pattern must be 0..7')
                if k == 'line' and not 8 <= hi <= 15:
                    raise ValueError('line flags must be 8..15')
                if not 2 <= len(vs) <= 15:
                    raise ValueError('a face needs 2..15 vertices')
                m['faces'].append({'labels': pending, 'byte': (hi << 4) | len(vs), 'v': vs})
                pending = []
            else:
                raise ValueError('unknown keyword %r' % k)
        except (ValueError, IndexError, KeyError) as e:
            raise SystemExit('%s line %d: %s' % (where, ln, e))
    m['end_labels'] = pending
    if m['radius'] is None or m['scale'] is None:
        raise SystemExit('%s: radius and scale are required' % where)
    nv = nverts(m)
    for f in m['faces']:
        for v in f['v']:
            if not 0 <= v < nv:
                raise SystemExit('%s: vertex number %d does not exist (the model has %d vertices: 0..%d)' % (where, v, nv, nv - 1))
        if nv * 5 > 255 and False:
            pass
    if nv * 5 > 255:
        raise SystemExit('%s: %d vertices; at most 51 (the renderer buffer is 255 bytes of 5-byte slots)' % (where, nv))
    return m


def to_inc(m):
    """-> asm lines (labels + db), identical bytes to the original record"""
    L = []
    for l in m['labels']:
        L.append('%s:' % l)
    L.append('            db   %d,%d' % (m['radius'], m['scale']))
    for mask, x, y, z in m['groups']:
        L.append('            db   #%02X,#%02X,#%02X,#%02X' % (mask, x & 255, y & 255, z & 255))
    L.append('            db   0')
    for f in m['faces']:
        for l in f['labels']:
            L.append('%s:' % l)
        L.append('            db   #%02X,' % f['byte'] + ','.join('%d' % (v * 5) for v in f['v']))
    for l in m['end_labels']:
        L.append('%s:' % l)
    L.append('            db   0')
    return L


def to_bytes(m):
    b = bytearray([m['radius'], m['scale']])
    for mask, x, y, z in m['groups']:
        b += bytes([mask, x & 255, y & 255, z & 255])
    b.append(0)
    for f in m['faces']:
        b.append(f['byte'])
        b += bytes(v * 5 for v in f['v'])
    b.append(0)
    return bytes(b)
