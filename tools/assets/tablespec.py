"""Description of the data tables of the station (DATA_M.asm): which csv file feeds which asm labels.
Used by gen_tables.py (build) and extract_tables.py (one-time extraction from the old sources).
Column types: b = unsigned byte, w = 16-bit word (little endian), k = key character (a letter/digit, SS, SPACE or a number, stored as a byte).
Hex columns (fmt 'h') are written 0xNN in the csv; the generator accepts decimal, 0x.. and #.. everywhere."""

# name -> dict(csv, rows, labels = [(LABEL, [(column, type, fmt)], tail_bytes)], title, notes)
GOODS_HDR = [
    'Goods (30 kinds).  The goods NAMES and UNITS are in assets/text/trade_names.txt (TTWR2) - row id = line number there (1..30 -> id 0..29: id = line-1).',
    'cheap_where : economy type of the star system (TYPE in station_ui.txt: 0 agricultural, 1 cultural, 2 technological, 3 general) in which',
    '              the good is cheaper / lighter',
    'weight_class: 0 = tons (weighs its amount), 1 = persons (1/16 ton each), 2 = negligible weight (kg / g)',
    'price       : average ("base") price in credits per unit',
    'ban_level   : how often the good is illegal: 0 never, 1 rarely, 2 often, 3 always banned in democracies',
    'orig_comment is the developers comment in the old source (an older name of the good); it is ignored by the build.',
]
EQUIP_COMMON = [
    'price      : average price in credits',
    'level      : lowest planet level (1..16) whose station sells the item',
    'mass       : mass in tons (counts against the ship tonnage)',
    'family_up, family_down : steps to the neighbouring items of the same family (signed byte: 0xFF = -1, 0xFE = -2 ...); only one item per family',
    '             can be installed ("Подобный тип оснащения уже имеется!")',
    'no_*       : ship (skimmer) numbers (0-based) on which the item cannot be installed, 0xFF = unused slot (see ships.csv for the order)',
    'orig_comment is the developers comment in the old source (an older name of the item); it is ignored by the build.',
]
TABLES = {
    'goods': dict(csv='goods.csv', rows=30, title=GOODS_HDR, labels=[
        ('SPECTO', [('cheap_where', 'b', 'd')], []),
        ('TWRM', [('weight_class', 'b', 'd')], []),
        ('CENS2', [('price', 'b', 'd'), ('ban_level', 'b', 'd')], [0]),
    ]),
    'equipment_ship': dict(csv='equipment_ship.csv', rows=33, title=['Ship equipment (33 items).  Names: assets/text/trade_names.txt (TWKRB2, line = id), description: equipment_docs.txt (TARMI item = id).  id = 1..33.'] + EQUIP_COMMON, first_id=1, labels=[
        ('KRBARM', [('no_ship_1', 'b', 'h'), ('no_ship_2', 'b', 'h'), ('no_ship_3', 'b', 'h'), ('no_ship_4', 'b', 'h')], []),
        ('CENS', [('price', 'w', 'd')], []),
        ('TONNS', [('level', 'b', 'd'), ('mass', 'b', 'd')], []),
        ('WKII', [('family_up', 'b', 'h'), ('family_down', 'b', 'h')], []),
    ]),
    'equipment_skimmer': dict(csv='equipment_skimmer.csv', rows=14, title=['Skimmer equipment (14 items).  Names: assets/text/trade_names.txt (TWSKM1, line = id), description: equipment_docs.txt (TARMI item = 33 + id).  id = 1..14.'] + EQUIP_COMMON, first_id=1, labels=[
        ('SKMARM', [('no_skimmer_1', 'b', 'h'), ('no_skimmer_2', 'b', 'h'), ('no_skimmer_3', 'b', 'h'), ('no_skimmer_4', 'b', 'h')], []),
        ('CENS1', [('price', 'w', 'd')], []),
        ('TONSS', [('level', 'b', 'd'), ('mass', 'b', 'd')], []),
        ('WSII', [('family_up', 'b', 'h'), ('family_down', 'b', 'h')], []),
    ]),
    'ships': dict(csv='ships.csv', rows=7, first_id=1, title=[
        'The 7 ships in purchase order (id 1..7; the last one is the illegal starting ship, not sold).  Names / descriptions: text/ships.txt, 3D models: station OBJX.',
        'tonnage : capacity in tons          price : credits          speed : max speed shown in the viewer text (not read from here by the flight)',
        'legal   : 1 = legal (can be sold), 0 = illegal and unsellable',
        'NB: ship.tok / NAMSH in assets/text/ships.txt repeat the price and the speed as plain text; keep them in sync by hand.'], labels=[
        ('CNKR', [('tonnage', 'b', 'd'), ('price', 'w', 'd'), ('speed', 'b', 'd'), ('legal', 'b', 'd')], []),
    ]),
    'skimmers': dict(csv='skimmers.csv', rows=4, first_id=1, title=[
        'The 4 skimmers (id 1..4).  Names / descriptions: text/ships.txt.',
        'unused : always 0 (a skimmer has no tonnage of its own)   price : credits   speed : shown in the viewer text   weight : weight in tons added to the ship load',
        'NB: skim.tok / NAMSK in assets/text/ships.txt repeat price/speed/weight as plain text; keep them in sync by hand.'], labels=[
        ('CNSK', [('unused', 'b', 'd'), ('price', 'w', 'd'), ('speed', 'b', 'd'), ('weight', 'b', 'd')], []),
    ]),
    'shipdat': dict(csv='shipdat.csv', rows=16, first_id=1, title=[
        'Offer per planet level: id = planet level 1..16.  Number of ships / skimmers that are SKIPPED at the end of the list at a station of that level',
        '(0 = the station sells all; a high level station sells all, a low level one only the cheapest ones).'], labels=[
        ('SHIPDAT', [('skip_ships', 'b', 'd'), ('skip_skimmers', 'b', 'd')], []),
    ]),
    'keyboard': dict(csv='keyboard.csv', rows=None, first_id=0, title=[
        'Keyboard code -> port and mask (Spectrum half-row ports).  id = the code of the key as the station code sees it: 0..3 = CS, ENTER, SS, SPACE;',
        '4..33 unused (port 0), 34.. = digits 0..9 (codes 34..43), 44..57 unused, then letters A..Z in the alphabetical order of the ASCII table.  The',
        'file is a plain table; do not reorder.  port = high byte of the port (0xFE half-row 0 ...), mask = bit.'], labels=[
        ('TBKP', [('port', 'b', 'h'), ('mask', 'b', 'd')], []),
    ]),
}
# settings tables are special (one label per row): see gen_tables.py
