#!/usr/bin/env python3
"""ONE-TIME extractor of the flight data blocks (db in the old sources) -> assets/data/*.csv, assets/gfx/radar_sprites.png, assets/sound/effects.txt.
Usage: python tools/assets/extract_flight.py <dir with the old SETHJRET.asm OBJGENER.asm PANEL.asm BRAINDOP.asm>
(documentation of how the files were made; the build does not run it)"""
import sys, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import dbparse
from PIL import Image
SRC = sys.argv[1]
ROOT = os.path.join(HERE, '..', '..')


def lines(name):
    return open(os.path.join(SRC, name), encoding='utf-8').read().split('\n')


def bytes_between(L, a_label, b_label=None):
    i = next(k for k, l in enumerate(L) if l.startswith(a_label + ':'))
    j = next(k for k, l in enumerate(L) if k > i and l.startswith(b_label + ':')) if b_label else len(L)
    out = bytearray()
    for r in dbparse.parse_lines(L[i + 1:j]):
        if r[0] == 'bytes': out += bytes(r[1])
    return bytes(out)


def s8(v): return v - 256 if v > 127 else v


def w(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, 'w', encoding='utf-8', newline='\n').write(text)


D = os.path.join(ROOT, 'assets', 'data')
# ---------------- spawn tables (SETHJRET)
S = lines('SETHJRET.asm')
vt = bytes_between(S, 'VERTAB', 'STROYTAB')
govs = ['democracy', 'dictatorship', 'anarchy', 'uninhabited', 'unknown']
assert len(vt) == 4 * 16 + 9, len(vt)
rows = ['government,pirates,traders,police,military,hunters,pirates2,ufo,ufo2,hermit']
for g in range(5):
    rows.append(govs[g] + ',' + ','.join(str(v) for v in vt[g * 16:g * 16 + 9]))
w(D + '/spawn_types.csv', '''# Spawn probability of the flight, one row per government of the star system (GENSHIPS, OBJGENER.asm).
# Every column is a CUMULATIVE threshold: each frame a random number is compared with the thresholds in the order of the columns; the first
# column whose threshold is greater than the number gives the type of the new object (pirate, trader, police, military, hunter,
# harmless pirate, ufo, hostile ufo, hermit); above the last column nothing is generated.  So the numbers must rise from left to right.
# At arrival SETT adds a per-planet-level correction (spawn_level.csv + spawn_government.csv) to the 15 parameters that are kept in PLANDICTAT.
# Generated label: VERTAB (rows of 16 bytes: the 9 values and 7 zero bytes; the last row has only the 9 values, as in the original).
''' + '\n'.join(rows) + '\n')
st = bytes_between(S, 'STROYTAB', 'LEVLTAB')
assert len(st) == 16 * 3 + 15
rows = ['government,' + ','.join('p%02d' % i for i in range(1, 16)) + ',void']
for g in range(4):
    r = st[g * 16:g * 16 + 16]
    rows.append(govs[g] + ',' + ','.join(str(s8(v)) for v in r[:15]) + ',' + (str(s8(r[15])) if len(r) > 15 else ''))
w(D + '/spawn_government.csv', '''# Per-government offsets of the 15 flight parameters PLANDICTAT (SETHJRET.asm SETT).  Signed bytes (-128..127).
# value of parameter p = LEVLTAB base (spawn_level.csv) + this offset + level effect (see spawn_level.csv).  The parameters are the spawn/AI tuning numbers
# of the system; their individual meaning is not documented in the sources (INFERRED: they scale the thresholds of the spawn types).
# Generated label: STROYTAB (16 bytes per row, the last column "void" is never read; the last row has only 15 values, as in the original).
''' + '\n'.join(rows) + '\n')
lv = bytes_between(S, 'LEVLTAB', 'MODELSTAR')
assert len(lv) == 45
rows = ['param,base,mult,div']
for i in range(15):
    rows.append('p%02d,%d,%d,%d' % (i + 1, lv[i * 3], s8(lv[i * 3 + 1]), lv[i * 3 + 2]))
w(D + '/spawn_level.csv', '''# Planet-level dependence of the 15 flight parameters (LEVLTAB, SETHJRET.asm SETT).  One row per parameter p01..p15 (same order as spawn_government.csv).
# With lv = planet level - 1 (0..15):  value = base + government offset + (k * lv) >> s   where k = (|mult| - 1) with the sign of mult (mult 1 -> 0),
# and s = number of trailing zero bits of div (div 1 -> no shift, 2 -> 1, 4 -> 2, 8 -> 3).  base, div are unsigned bytes, mult is signed.
# Generated label: LEVLTAB (3 bytes per row: base, mult, div).
''' + '\n'.join(rows) + '\n')
# ---------------- NDATA
nd = bytes_between(S, 'NDATA', 'RETSTT')
assert len(nd) == 215
FIELDS = [('TIME', 4, 'game time: day word (0x0122), hour 0x10, minute 0x10 (hex-coded decimal)'),
          ('PLACE', 4, 'current system: map word 0x4B38, in-map word 0x4AF3'),
          ('WHERE', 4, 'target system (same as PLACE)'),
          ('PLANET', 1, 'planet number'), ('WPLANET', 1, 'target planet number'),
          ('SHIP', 1, 'ship model: 0xFF'), ('SKIMMER', 1, 'skimmer model: 0xFF = none'), ('STATUS', 1, 'legal status 0'), ('SUMM', 2, 'credits (word): 40000'),
          ('TONN', 2, 'tonnage bytes'),
          ('GOODS', 58, 'old layout: 34 zero bytes then 24 x 0xFF (hold list of the old record)'),
          ('BLOCK_A', 51, 'old layout: 31 zero bytes, 11 x 0xFF, 9 zero bytes (equipment counts of the old record)'),
          ('ORDER', 64, '4 x (0xFF + 15 zero bytes): empty contract orders'),
          ('SPEED_DALNO', 4, 'SPEED (2 bytes) and DALNO (2 bytes), all 0'),
          ('TAIL_B', 17, 'last 17 bytes: 2,1,1,3,1,1,2,3,2,1,1,1,1,1,1,1,0xFF (the old star-type / subscriber list)')]
assert sum(f[1] for f in FIELDS) == 215, sum(f[1] for f in FIELDS)


def rle(bs):
    out, i = [], 0
    while i < len(bs):
        j = i
        while j < len(bs) and bs[j] == bs[i]: j += 1
        out.append('%02X*%d' % (bs[i], j - i) if j - i > 2 else ' '.join('%02X' % bs[i] for _ in range(j - i)))
        i = j
    return ' '.join(out)


pos, rows = 0, ['label,size,bytes,meaning']
for nm, sz, mean in FIELDS:
    rows.append('%s,%d,%s,"%s"' % (nm, sz, rle(nd[pos:pos + sz]), mean)); pos += sz
w(D + '/newgame_flight.csv', '''# NDATA of the flight (SETHJRET.asm): an OLD, SHORT (215 bytes) version of the new-game record.  It is copied over the state record only by RETSTT, which no code
# calls (dead code, see docs/GAME_DESIGN.md 6.5), so it has no effect on the game; the real new game is assets/data/newgame.csv (512 bytes, station).
# Its field order differs from the real record (here PLANET and WPLANET follow WHERE; the real record has PLANET after PLACE), which is why it was abandoned.
# Names for the fields after TONN are only a description of the byte pattern.  bytes = hex bytes, "XX*N" = N times XX (as in newgame.csv).
# Generated label: NDATA.
''' + '\n'.join(rows) + '\n')
# ---------------- INDTABK tables (OBJGENER)
G = lines('OBJGENER.asm')
i = next(k for k, l in enumerate(G) if l.startswith('TPIRAT:'))
j = next(k for k, l in enumerate(G) if l.startswith('; ГЕНЕРАЦИЯ ОБЪЕКТОВ ОБЩАЯ'))
rows, cur = ['table,slot,model,weight'], None
for l in G[i:j]:
    m = re.match(r'^(T\w+|KREYSERS):', l)
    if m: cur, n = m.group(1), 0
    m = re.match(r'\s*db\s+(\w+),(\d+)', l)
    if m:
        rows.append('%s,%d,%s,%s' % (cur, n, m.group(1), m.group(2))); n += 1
w(D + '/ship_choice.csv', '''# Which ship model a newly generated object gets (OBJGENER.asm, tables INDTABK -> TPIRAT.. and KREYSERS).  One table per object type, 8 slots each; a random slot is taken.
# model  = symbolic index of the model in the flight object table (3DTABS.asm, I*), weight = value stored with it (60..150; INFERRED: energy / strength
#          of that ship), the same model may appear in several slots (more probable).
# table  = label of the table in the code (the pointer table INDTABK stays in OBJGENER.asm): TPIRAT pirates and harmless pirates, TTRADER traders, TARMY military,
#          TPOLICE police, THUNTER hunters, TUFO ufos (both kinds), TOTSHEL hermits (asteroids), KREYSERS cruisers (low weights = rare).
''' + '\n'.join(rows) + '\n')
# ---------------- radar sprites (PANEL)
P = lines('PANEL.asm')
SPR = [('VISUN', 3, 'compass marker of the sun, in front (z >= 0)'), ('UVISUN', 3, 'compass marker of the sun, behind'),
       ('VIEAR', 3, 'compass marker of the planet, in front'), ('UVIEAR', 3, 'compass marker of the planet, behind'),
       ('MCARGO', 3, 'radar blip: cargo container'), ('MROKET', 3, 'radar blip: rocket'), ('MSTATION', 3, 'radar blip: station'),
       ('MTRADER', 3, 'radar blip: trader (also types 10..15)'), ('MARMY', 3, 'radar blip: military'), ('MMIKR', 3, 'radar blip: micro ship'),
       ('MOTSHEL', 3, 'radar blip: hermit'), ('MHUNTER', 3, 'radar blip: hunter'), ('MUFO', 3, 'radar blip: ufo'),
       ('MUNKNOWN', 3, 'radar blip: unidentified object'), ('MPIRAT', 3, 'radar blip: pirate'), ('MPOLICE', 3, 'radar blip: police'),
       ('MASPR', 8, 'highlight frame drawn around the target in the 3D view (8x8)'),
       ('MLOCK', 8, 'the same highlight when a rocket is locked on that target (8x8 diamond; follows MASPR in memory)')]


def sprite_rows(name, rows):
    skip = 0
    if name == 'MLOCK':
        name, skip = 'MASPR', 64
    i = next(k for k, l in enumerate(P) if l.startswith(name + ':'))
    vals = []
    k = i + 1
    while skip:
        if re.match(r'\s*db\s+(\S+),(\S+)', P[k]): skip -= 1
        k += 1
    while len(vals) < rows * 8:
        m = re.match(r'\s*db\s+(\S+),(\S+)', P[k]); k += 1
        if m:
            vals.append((dbparse.num(m.group(1)) << 8) | dbparse.num(m.group(2)))
    for p in range(8):
        for r in range(rows):
            assert vals[p * rows + r] == vals[r] >> p, (name, p, r)
    assert all(v & 0xFF == 0 for v in vals[:rows])
    return [v >> 8 for v in vals[:rows]]


im = Image.new('L', (64, 24), 255)
px = im.load()
csv = ['name,cell,size,meaning']
for n, (name, size, mean) in enumerate(SPR):
    base = sprite_rows(name, size)
    ox, oy = (n % 8) * 8, (n // 8) * 8
    for y, b in enumerate(base):
        for x in range(8):
            if b & (0x80 >> x): px[ox + x, oy + y] = 0
    csv.append('%s,%d,%d,"%s"' % (name, n, size, mean))
os.makedirs(ROOT + '/assets/gfx', exist_ok=True)
im.save(ROOT + '/assets/gfx/radar_sprites.png')
w(ROOT + '/assets/gfx/radar_sprites.csv', '''# Radar / compass sprites of the flight panel (PANEL.asm).  radar_sprites.png: 8 sprites per row, every sprite in a cell of 8 x 8 pixels, black = ink.
# Only the shape of the sprite is stored; the 8 shifted copies (one per pixel column) are generated.  size = height in pixel rows
# (the width is at most 3 for the blips and 8 for the two target highlights).  cell = position in the sheet (row-major, 8 per row).
''' + '\n'.join(csv) + '\n')
# ---------------- AY effects (BRAINDOP)
B = lines('BRAINDOP.asm')
i = next(k for k, l in enumerate(B) if l.startswith('ROKA:'))
txt = ['''# AY-3-8910 sound effects of the flight (BRAINDOP.asm; played by SFXA = channel A, SFXB = channel B, started by loading the address of an effect into SFXA+1 / SFXB+1).
# One [LABEL] per effect.  One line = one frame (the effect advances one frame per game frame):  tone_lo  tone_hi  mixer  volume
#   tone_lo, tone_hi : the AY tone period (registers 0/1 of channel A, 2/3 of B): the pitch; tone_lo = 0 ENDS the effect (so a real period needs a non-zero low byte),
#   mixer            : bits for AY register 7 of the used channel (bit 0 = tone off, bit 3 = noise off; the player shifts the bits for channel B),
#   volume           : 0..15 (AY register 8 / 9).
# Numbers: decimal, 0xHEX or %binary (a line starting with # is a comment).  The terminating 0 is added by the generator.  Noise period and envelope are fixed by the player.
# Generated: build/gen/EFFECTS.inc (labels as given).  Use: ROKA (BODY.asm: warning when a rocket is launched at you), EFF0 explosion (channel B), EFF1 lock-on
# click, EFF2 laser shot, EFF11 laser hit on the player, EFF13 rocket launch / key beep, EFF14 beep, EFF19 anti-missile system, EFF21 hit on a target.
''']
for l in B[i:]:
    code, com = dbparse.strip_comment(l)
    m = re.match(r'^(\w+):', l)
    if m:
        txt.append('\n[%s]' % m.group(1)); continue
    m = re.match(r'\s*db\s+(.*)$', code)
    if m:
        a = dbparse.split_args(m.group(1))
        txt.append('%s %s %s %s' % tuple(('0x' + t[1:]) if t.startswith('#') else t for t in a[:4]))
        if len(a) == 5:
            assert a[4] == '0'
w(ROOT + '/assets/sound/effects.txt', '\n'.join(txt) + '\n')
print('ok')
