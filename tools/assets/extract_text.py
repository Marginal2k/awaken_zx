#!/usr/bin/env python3
"""ONE-TIME extractor (kept for documentation / re-extraction from the pre-conversion sources, see git history before the
"assets" commits): reads the original db blocks and writes assets/text/*.txt.  The build does NOT run this; it runs gen_text.py.
Usage: python tools/assets/extract_text.py <path to a checkout of the sources from before the conversion>"""
import sys, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from dbparse import parse_lines
from textlib import write_sections, b2t, ET

SRC = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, '..', '..')
OUT = os.path.join(HERE, '..', '..', 'assets', 'text')
os.makedirs(OUT, exist_ok=True)


def rd(path):
    return open(os.path.join(SRC, path), 'rb').read()


def rdtext(path):
    raw = rd(path)
    try:
        return raw.decode('utf-8')
    except UnicodeDecodeError:
        return raw.decode('cp1251')



def sections_of(path, enc_cp1251=True):
    L = rdtext(path).split(chr(10))
    P = parse_lines(L)
    cur = None
    secs = {}
    order = []
    for p in P:
        if p[0] == 'label':
            cur = p[1]; secs[cur] = [bytearray(), []]; order.append(cur)
        elif p[0] == 'bytes' and cur:
            secs[cur][0] += bytes(p[1])
        elif p[0] == 'comment' and cur:
            secs[cur][1].append(p[1].strip())
    return order, secs


def split_items(bs, end=ET):
    bs = bytes(bs)
    if not bs:
        return [], True
    parts = bs.split(bytes([end]))
    if bs[-1] == end:
        return parts[:-1], True
    return parts, False


NOTE_LIMIT = ('Station text is printed with the proportional font PRO.f and justified over the window width (max 255 px); a '
              'line break is only made where "\\n" is written.')

META = {
    'MODELS': ['Station models: item N is the name of the station model N (1..16); the name is used in WELCOME ("model <1>").',
               'Each name ends with one blank (written {sp}) which is part of the text.  Max about 90 px.'],
    'WELCOME': ['Greeting when docking.  {stop} marks the three places where the program inserts a value: the station model',
                '(name from MODELS), the system (star) name and the hourly parking fee in credits; do not remove them.',
                'One paragraph, justified over the window width.'],
    'ERORS': ['Messages M01..M16 shown by the trade-rules script (assets/text/rules.paradox: "M09" = item 9).  Item 0 is empty.',
              'Shown in a message window (max 255 px wide, a few lines).  Items 10, 15, 16 contain "1000" / "50" credits: keep in sync with the script.'],
    'TSOH1': ['Names of the 5 save slots in the "Save" menu (one item, one line per slot).  Max about 120 px per line.'],
    'TWOS1': ['Names of the 5 save slots in the "Restore" menu (one item, one line per slot).  Max about 120 px per line.'],
    'TSETS1': ['Environment settings window: row labels.  Line 1.. in the order of SETSD/SETSI in assets/data/settings.csv',
               '(mouse, joystick, music, inverse, 6 station keys, ink, paper, bright).  Max about 110 px.'],
    'TSETG1': ['Game settings window: row labels, line 1.. = 28 controls of the ship (flight) followed by 15 controls of the skimmer;',
               'order = assets/data/settings.csv (SETGD).  Max about 110 px.'],
    'TABON1': ['Header of the subscriber list: "Name" TAB "Star".  {tab1} = start of column 2.'],
    'NABONS': ['Subscribers (item 1..16): "Name{tab1}Home star\\n".  Shown in the subscriber window and in the list.  Name max ~100 px.',
               'The 16 portraits belong to these items (not in the build, see docs/GAME_DESIGN.md G10).'],
    'TNEWS': ['News window.  Item 1 = no news, item 2 = the alien-invasion alert (the only real news).  Max 255 px, few lines.'],
    'THIDE': ['System menu (key M on an empty background): 8 lines.  Line order is the order of the handlers in OBR.asm: do not reorder.'],
    'Wintxt': ['Window titles, item = window type number (OBJECT.asm).  Item 0/1 empty.  Max about 100 px (title bar).'],
    'Buttxt': ['Button tooltips, item = button type number (OBJECT.asm).  Format: title "\\n" description.  Title lines are short buttons',
               '(max ~60 px, up to 3 lines: "Продать\\nвсе\\n" style), the description is justified over the tooltip width (<= 255 px).',
               'Items 24..40 are unused (empty), 41 = "Перелет" (travel, the description is empty).'],
    'Tstatus': ['Legal status of the player: 1 clean, 2 suspect, 3 wanted, 4 convicted.  Max ~80 px (shown after "Status:" in the status line).'],
    'Txt': ['Placeholder shown by the contract windows ("This is a prototype of the interface").'],
    'Lintxt': ['Status line captions: 1 "Status: ", 2 " Credits: ", 3 " Tonnage: ".  Leading/trailing blanks ({sp}) belong to the text.'],
    'TINFS1': ['System info window: the line captions (fuel, distance, planet ..., one line per row).  Line breaks are fixed,',
               '{nbsp*31} = a blank row of 31 non-breaking blanks.  Max ~110 px per caption (values are printed to the right).'],
    'TINFS2': ['System info window: header of the planet list.'],
    'STROY': ['Political system of a star system: 1 Democracy, 2 Dictatorship, 3 Anarchy, 4 Uninhabited, 5 Unknown.  Max ~110 px.'],
    'TYPE': ['Economy type of a system: 1 agricultural, 2 cultural, 3 technological, 4 general.  Max ~110 px.'],
    'TMISS1': ['Header of the contract list (no code uses it; the contract window is a placeholder).'],
    'TGOST': ['The four states (powers) of the galaxy, used by the system-info window: 1..4.  Max ~120 px.'],
    'TTWR1': ['Goods window header: column captions, {tab1}..{tab5} jump to the column starts set by the window.  Keep short (about 8 chars per column).'],
    'TTWR2': ['The 30 goods: one line per good, "name{tab5}unit" (units: тн ton, кг kg, г g, чл persons, эк pieces).  Line index = good number',
              '(1..30, line 0 is empty); pairs with assets/data/goods.csv by position.  Name max ~110 px before the {tab5} column.'],
    'TWKRB1': ['Ship-equipment window header: column captions.'],
    'TWKRB2': ['The 33 ship equipment names: one line per item, line index = item number (1..33; line 0 empty); pairs with',
               'assets/data/equipment_ship.csv and assets/text/equipment_docs.txt (TARMI items 1..33).  Max ~110 px.'],
    'TWSKM1': ['The 14 skimmer equipment names: line index 1..14; pairs with assets/data/equipment_skimmer.csv and TARMI items 34..47.  Max ~110 px.'],
    'TARMI': ['Encyclopaedia entries of the equipment: item 1..33 = ship equipment (order of TWKRB2), 34..47 = skimmer equipment (order of TWSKM1).',
              'Justified text over the info window width (<= 255 px); the visible window shows a limited number of lines (about 5-8):',
              'keep entries about the same length as the original (110-200 characters).  The sentence "Created in year N of the new era" has the',
              'year in it; the year has no program meaning.'],
    'THLPL': ['Help: the menu of the 8 chapters.  Line 1..8 = chapter 1..8 (line 0 is empty); the order is the order of the chapters in help.tok.'],
    'help.tok': ['Help text: 8 chapters (items 1..8).  Item N is shown when menu line N is chosen.  "\\n" = new line, empty lines separate paragraphs.',
                 'Shown in the help window (<= 255 px wide), scrolls (about 20 lines on screen; the help buffer LINES holds 1024 lines).'],
    'ship.tok': ['Ship descriptions for the 3D viewer: items 1..7 = the 7 ships in the order of assets/data/ships.csv.  Layout of an item:',
                 'name "\\n\\n" story "\\n\\n" "Characteristics:" "\\n" "Speed N" "\\n" "Armour N" "\\n" "Weight N" -- the numbers are plain text here and',
                 'are NOT read from ships.csv (keep them in sync by hand).'],
    'skim.tok': ['Skimmer descriptions for the 3D viewer: items 1..4 = the 4 skimmers, same layout as ship.tok (Speed, Weight).'],
    'NAMSH': ['Ship purchase list (ships 1..6, legal): one line per ship "\\nName{tab1}price".  The price is plain text (not read from ships.csv: keep in sync).',
              'The list is split in two sections because the label TD1 (end of the "legal" list) lies between them.'],
    'NAMSH7': ['The seventh ship (illegal, sold only on some stations): "Name{tab1}price".'],
    'NAMSK': ['Skimmer purchase list (4 skimmers): one line per skimmer "\\nName{tab1}price" (price plain text, keep in sync with ships.csv).'],
    'TSHIP': ['Header of the purchase list: "Model" {tab1} "Price", then a blank row ({nbsp*31}).'],
    'NAMTAB': ['Greek letters / name parts used to build star names (item 1..16); a star name = part + number (see KARTA.asm).  Max ~60 px.'],
}
FLIGHT_META = {
    '_SYSTEMREADY': 'All systems ready.', '_SYSTEMOK': 'All systems work normally.', '_MODEON': 'Mode on.', '_MODEOFF': 'Mode off.',
    '_FREEFLY': 'Free-flight system on.', '_GETTARGET': 'Target acquired.', '_FRONT': 'Front view.', '_BACK': 'Rear view.',
    '_LOSTTARGET': 'Target lost.', '_ALLTARGET': 'All targets captured.', '_HAVE': 'Left (followed by a number and _ROKET)',
    '_ROKET': 'rockets (continuation of _HAVE)', '_NOROKET': 'Rockets are out.', '_DESTROY': 'Target destroyed.',
    '_GAMEOVER': 'Ship destroyed, game over.', '_NOTARGET': 'Target not captured.', '_POWERRAY': 'Power beam.',
    '_ROKETGO': 'Rocket launched.', '_SYSTEMOFF': 'Switched off', '_SYSTEMSOFF': 'Switched off (plural)', '_ANTIROKET': 'Anti-rocket system activated.',
    '_TARGETOFF': 'Acquired targets forgotten.', '_TAKING': 'Object picked up.', '_HIPER': 'Hyperjump (3 lines)', '_DOCKING': 'Docking (3 lines)',
    '_DROPCARGO': 'Cargo dropped.', '_DROPMINE': 'Mine dropped.', '_NOMINE': 'No mines.', '_NOCARGO': 'No cargo.'}

HDR = ('# Awaken - %s\n# UTF-8.  Notation: see assets/README.md (section "Text notation").  In short: "ID | text", "\\n" = new line in the game,\n'
       '# {stop}/{tab1..5}/{nbsp}/{sp}/{xNN} = control bytes, continuation lines start with "    |", lines starting with # are comments.\n'
       '# The IDs and the [LABEL] names are used by the code: do not rename or renumber.')

FILES = {
    'station_ui.txt': ('station user interface (windows, buttons, messages, settings)',
                       ['MODELS', 'WELCOME', 'ERORS', 'TSOH1', 'TWOS1', 'TSETS1', 'TSETG1', 'THIDE', 'Wintxt', 'Buttxt', 'Tstatus', 'Txt', 'Lintxt',
                        'TINFS1', 'TINFS2', 'STROY', 'TYPE', 'TMISS1', 'TGOST']),
    'trade_names.txt': ('names of goods and equipment (the numbers are in assets/data/*.csv, paired by position)',
                        ['TTWR1', 'TTWR2', 'TWKRB1', 'TWKRB2', 'TWSKM1']),
    'equipment_docs.txt': ('encyclopaedia of the equipment', ['TARMI']),
    'subscribers_news.txt': ('subscribers and news', ['TABON1', 'NABONS', 'TNEWS']),
}
CRLIST = {'TSOH1', 'TWOS1', 'TSETS1', 'TSETG1', 'THIDE', 'TTWR2', 'TWKRB2', 'TWSKM1', 'THLPL', 'TINFS1', 'NAMSH', 'NAMSK', 'Buttxt_'}


def mk(label, bs, comments_extra=(), opts=None, end=ET):
    items, last_et = split_items(bs, end)
    meta = list(META.get(label, []))
    meta += ['orig comment: ' + c for c in comments_extra if c]
    return (label, opts or {}, meta, items, last_et, label in CRLIST)


def main():
    order, secs = sections_of('src/station/DATAT.asm')
    for fn, (title, labels) in FILES.items():
        assert all(l in secs for l in labels)
        write_sections(os.path.join(OUT, fn), HDR % title, [mk(l, secs[l][0], secs[l][1]) for l in labels])
    assert set(sum([v[1] for v in FILES.values()], [])) == set(order), set(order) - set(sum([v[1] for v in FILES.values()], []))
    # help
    o2, s2 = sections_of('src/station/HELP.asm')
    secs_h = [mk('THLPL', s2['THLPL'][0], s2['THLPL'][1]), mk('help.tok', rd('assets/help.tok'), (), {'first': '1'})]
    write_sections(os.path.join(OUT, 'help.txt'), HDR % 'in-game manual', secs_h)
    # ships
    o3, s3 = sections_of('src/station/DATA3D.asm')
    nam = s3['NAMSH'][0]
    # NAMSH runs up to the label TD1 (the label lies at the ET that ends the 6 legal ships), then one more ship
    # the generic parser puts TD1 in a section of its own
    assert 'TD1' in s3
    sh = [mk('ship.tok', rd('assets/ship.tok'), (), {'first': '1'}), mk('skim.tok', rd('assets/skim.tok'), (), {'first': '1'}),
          ('NAMSH', {}, META['NAMSH'], [bytes(nam)], False, True)]
    td1 = bytes(s3['TD1'][0])        # ET + ship 7 + ET
    assert td1[0] == ET and td1[-1] == ET and td1.count(bytes([ET])) == 2
    sh.append(('NAMSH7', {}, META['NAMSH7'], [td1[1:-1]], True, False))
    sh.append(mk('NAMSK', s3['NAMSK'][0], ()))
    sh.append(mk('TSHIP', s3['TSHIP'][0], s3['TSHIP'][1]))
    write_sections(os.path.join(OUT, 'ships.txt'), HDR % 'ships and skimmers (viewer descriptions, purchase lists)', sh)
    # star name parts
    o4, s4 = sections_of('src/station/CIRCMATH.asm')
    # NAMTAB runs into code: cut at the first non-data; sections_of collected only db bytes so the rest is code (no bytes)
    write_sections(os.path.join(OUT, 'star_names.txt'), HDR % 'star name parts', [mk('NAMTAB', s4['NAMTAB'][0])])
    # flight messages
    L = rdtext('src/flight/COMPUTE.asm').split(chr(10))
    i0 = [i for i, l in enumerate(L) if l.startswith('_SYSTEMREADY:')][0]
    i1 = [i for i, l in enumerate(L) if l.startswith('_NOCARGO:')][0] + 3
    P = parse_lines(L[i0:i1])
    cur = None; fs = {}; forder = []
    for p in P:
        if p[0] == 'label': cur = p[1]; fs[cur] = bytearray(); forder.append(cur)
        elif p[0] == 'bytes': fs[cur] += bytes(p[1])
    fl = []
    for l in forder:
        m = META_FL(l)
        fl.append((l, {}, m, split_items(fs[l])[0], True, False))
    write_sections(os.path.join(OUT, 'flight_messages.txt'), HDR % 'flight computer messages (shown in the message line of the flight panel)', fl)
    # rules script
    b = rd('assets/C_SCENAR.t')
    open(os.path.join(OUT, "rules.paradox"), "w", encoding="utf-8", newline="").write(b.decode("cp866").replace(chr(13), chr(10)))


def META_FL(l):
    return ['Flight computer message %s: %s' % (l, FLIGHT_META.get(l, '')), 'Printed in the message line of the flight panel (panel font FONT.f); the message is',
            'terminated by \\n (new line) and the engine byte #0A.  Line width about 28 characters of the panel font.  Lines: one per \\n.']


main()
