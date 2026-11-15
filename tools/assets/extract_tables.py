#!/usr/bin/env python3
"""ONE-TIME extractor: old DATA_M.asm (db/dw blocks) -> assets/data/*.csv.  Not part of the build (gen_tables.py is).
Usage: python tools/assets/extract_tables.py <checkout of the pre-conversion sources> <build dir with station.sym + STATIONF.C of the pre-conversion build>"""
import sys, os, re, csv
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from dbparse import parse_lines
from tablespec import TABLES

SRC = sys.argv[1]
BLD = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, '..', '..', 'build')
OUT = os.path.join(HERE, '..', '..', 'assets', 'data')
os.makedirs(OUT, exist_ok=True)
L = open(os.path.join(SRC, 'src/station/DATA_M.asm'), 'rb').read().decode('cp1251').split('\n')
P = parse_lines(L)
labels = {}
cur = None
for p in P:
    if p[0] == 'label':
        cur = p[1]; labels[cur] = {'bytes': [], 'rows': []}
    elif p[0] == 'bytes' and cur:
        labels[cur]['rows'].append((len(labels[cur]['bytes']), p[2]))
        labels[cur]['bytes'] += p[1]


def fmt(v, kind):
    return '0x%02X' % v if kind == 'h' else str(v)


def write_csv(path, header_lines, cols, rows):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        for h in header_lines: f.write('# ' + h + '\n')
        w = csv.writer(f, lineterminator='\n')
        w.writerow(cols)
        for r in rows: w.writerow(r)


def comment_at(label, off):
    for o, c in labels[label]['rows']:
        if o == off: return c
    return ''


for name, T in TABLES.items():
    n = T['rows']
    # row sizes
    rs = {lab: sum(2 if t == 'w' else 1 for _, t, _ in cols) for lab, cols, tail in T['labels']}
    if n is None:
        n = len(labels[T['labels'][0][0]]['bytes']) // 2
    cols = ['id'] + [c for _, cs, _ in T['labels'] for c, _, _ in cs] + ['orig_comment']
    rows = []
    first = T.get('first_id', 0)
    if name == 'goods': first = 0
    if name == 'keyboard': first = 29
    for i in range(n):
        r = [first + i]
        for lab, cs, tail in T['labels']:
            bs = labels[lab]['bytes']
            assert len(bs) == n * rs[lab] + len(tail), (name, lab, len(bs), n, rs[lab])
            o = i * rs[lab]
            for c, t, f in cs:
                if t == 'w': v = bs[o] | bs[o+1] << 8; o += 2
                else: v = bs[o]; o += 1
                r.append(fmt(v, f))
        r.append(comment_at(T['labels'][0][0], i * rs[T['labels'][0][0]]))
        rows.append(r)
    hdr = list(T['title'])
    if name == 'keyboard':
        hdr = ['Keyboard code -> Spectrum port and mask (table TBKP).  id = key code: 29 CS, 30 ENTER, 31 SS, 32 SPACE, 48..57 digits 0..9, 65..90 letters A..Z',
               '(the ASCII code); the other rows are unused (port 0, mask 0).  port = high byte of the port address (0xFE = row CS..V, 0xFD = A..G, 0xFB = Q..T,',
               '0xF7 = 1..5, 0xEF = 0..6, 0xDF = Y..P, 0xBF = H..ENTER, 0x7F = B..SPACE), mask = bit of the key in the half-row.  Do not add or remove rows.']
    if name == 'goods':
        hdr[0] = 'Goods (30 kinds), id 0..29.  The goods NAMES and UNITS are in assets/text/trade_names.txt (TTWR2): line number = id + 1.'
    write_csv(os.path.join(OUT, T['csv']), hdr, cols, rows)
    print(name, n, 'rows')

# ---- settings -------------------------------------------------------------------------------------------------------
def keyname(v):
    if v == 31: return 'SS'
    if v == 32: return 'SPACE'
    if 32 < v < 127 and chr(v).isalnum(): return chr(v)
    return '0x%02X' % v

env_labels = 'MOUSE JOYSTIK MUSIC INVERSE KUP KDOWN KLEFT KRIGHT KFIRE KCANCEL INK PAPER BRIGHT'.split()
sd = labels['SETSD']['bytes'] if labels['SETSD']['bytes'] else None
# SETSD has no db after its label (the next label starts at once): rebuild from the label rows
env = []
for lb in env_labels:
    b = labels[lb]['bytes']; assert len(b) == 2
    env.append((lb, b[0], b[1], labels[lb]['rows'][0][1]))
si = labels['SETSI']['bytes']
assert len(si) == 14 and si[13] == 0
rows = [[lb, '0x%02X' % p, '0x%02X' % m, keyname(si[i]) , c] for i, (lb, p, m, c) in enumerate(env)]
write_csv(os.path.join(OUT, 'settings_env.csv'),
          ['Defaults of the environment settings window (tables SETSD = value + mask and SETSI = key letters; the labels MOUSE.. are used by the code).',
           'label  : the code label of the setting (do not rename)',
           'value  : for a switch 0x81 = "Y" (on), 0x80 = "N" (off); for a key: the keyboard half-row port (high byte, see keyboard.csv); for INK/PAPER/BRIGHT: the number',
           'mask   : key bit mask (keys) or 0',
           'key    : the letter shown in the settings window for this row (a letter/digit, SS, SPACE or a number)',
           'The row captions are in assets/text/station_ui.txt (TSETS1), same order.  13 rows, do not add or remove.'],
          ['label', 'value', 'mask', 'key', 'orig_comment'], rows)
gd = labels['SETGD']['bytes']; gi = labels['SETGI']['bytes']
assert len(gd) == 86 and len(gi) == 44 and gi[43] == 0, (len(gd), len(gi))
gnames = ['ship mouse', 'ship up', 'ship down', 'ship left', 'ship right', 'ship roll left', 'ship roll right', 'ship laser']
rows = []
for i in range(43):
    rows.append([i + 1, '0x%02X' % gd[2*i], '0x%02X' % gd[2*i+1], keyname(gi[i])])
write_csv(os.path.join(OUT, 'settings_game.csv'),
          ['Defaults of the game settings window (tables SETGD = port + mask and SETGI = key letters).  id 1..28 = ship (flight) controls, 29..43 = skimmer controls.',
           'The row captions are in assets/text/station_ui.txt (TSETG1), line = id.  value/port: 0x81 = "Y" (on) for the mouse row, otherwise the half-row port',
           '(high byte of the keyboard port, see keyboard.csv); mask = key bit; key = the letter shown.  43 rows, do not add or remove.'],
          ['id', 'port', 'mask', 'key'], rows)

# ---- new game state record --------------------------------------------------------------------------------------------
sym = {l.split()[0].rstrip(':'): int(l.split('0x')[1], 16) for l in open(os.path.join(BLD, 'station.sym')) if '0x' in l}
img = open(os.path.join(BLD, 'station', 'STATIONF.C'), 'rb').read()
order = 'TIME PLACE PLANET WHERE WPLANET SHIP SKIMMER STATUS SUMM TONN TWRI WKRBI FUEL WSKMI NEWS ORDER SPEED DALNO MSTARS WAY WAYMASK PSTARS ABONS'.split()
MEAN = {
    'TIME': 'game time: day (word, little endian) then hour, minute (hex-coded decimal: 0x10 = 10)',
    'PLACE': 'current system: map coordinate word, coordinate-in-map word',
    'PLANET': 'current planet number (counted from the bottom)',
    'WHERE': 'target system of the hyperjump: map coordinate word, coordinate in the map word',
    'WPLANET': 'target planet number',
    'SHIP': 'ship model number (0-based, 6 = Karen the starting ship)',
    'SKIMMER': 'skimmer model number, 0xFF = none',
    'STATUS': 'legal status (class = status/32: 0 clean, 1 suspect, 2 wanted, 3 convicted)',
    'SUMM': 'credits (word, little endian: 0x61A8 = 25000)',
    'TONN': 'two bytes (0, 50): tonnage related, see docs/GAME_DESIGN.md 3.2',
    'TWRI': 'goods in the hold: 30 pairs (count, price paid), all 0',
    'WKRBI': '(label only: same address as FUEL)',
    'FUEL': 'ship equipment counts, 33 items + terminator 0x80 (WKRBI = FUEL = item 1): 0..100 = count, 0xFF = not installed, 0xFE = installed',
    'WSKMI': 'skimmer equipment counts, 14 items + terminator 0x80',
    'NEWS': 'news state: message number, hours to keep it, system words, planet',
    'ORDER': '4 contract orders of 16 bytes each, first byte 0xFF = empty',
    'SPEED': 'speed of the bought ship, skimmer',
    'DALNO': 'distance of the last chosen star (word)',
    'MSTARS': 'remembered stars: 50 bytes 0xFF + terminator 0x80',
    'WAY': 'route stars: 50 bytes 0xFF + terminator 0x80',
    'WAYMASK': 'route line mask + 10 bytes',
    'PSTARS': 'systems where the subscribers live (PKOL * 4 bytes)',
    'ABONS': 'subscriber states: 1 = not available, 2 = available; terminated by 0',
}
addr = [sym[k] for k in order] + [sym['SETSD']]
rows = []
for i, k in enumerate(order):
    b = img[addr[i] - 0x6000: addr[i+1] - 0x6000]
    if k == 'WKRBI': b = img[sym['WKRBI']-0x6000: sym['FUEL']-0x6000]
    toks = []
    j = 0
    while j < len(b):
        k2 = j
        while k2 < len(b) and b[k2] == b[j]: k2 += 1
        if k2 - j >= 4: toks.append('%02X*%d' % (b[j], k2 - j)); j = k2
        else: toks.append('%02X' % b[j]); j += 1
    rows.append([k, len(b), ' '.join(toks), MEAN[k]])
write_csv(os.path.join(OUT, 'newgame.csv'),
          ['Initial state of a new game: the 512-byte state record of the station (labels TIME ... ABONS, DATA_M.asm), which also becomes the content of the',
           'save slots SAVE0..SAVE5 written by the build.  Each row is one labelled field.  bytes = hex bytes separated by blanks, "XX*N" = N times XX.',
           'size is checked against the number of bytes (the record layout is fixed: do not change the sizes).  NB: the flight has its own copy (NDATA, flight/SETHJRET.asm) used',
           'only on a separate path; see docs/GAME_DESIGN.md 7.2.  Values are binary: words are little endian.'],
          ['label', 'size', 'bytes', 'meaning'], rows)
print('newgame', len(rows), 'fields', sum(r[1] for r in rows), 'bytes')
