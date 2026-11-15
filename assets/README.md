# assets/ - editable game content

Everything the player sees or reads is a human-editable file here.  `python build.py` first runs the converters in `tools/assets/` which write the
game form into `build/gen/` (generated, never edit), and the sources `include` / `incbin` those files.  The result is byte-identical to the
1999 data unless you edit an asset.

    assets/text/*.txt          texts (UTF-8)                       -> tools/assets/gen_text.py   -> build/gen/<LABEL>.inc, *.tok, C_SCENAR.t
    assets/data/*.csv          numeric tables                      -> tools/assets/gen_tables.py -> build/gen/<LABEL>.inc
    assets/gfx/*.png (+csv)    pictures, fonts, cursors, sprites   -> tools/assets/gen_gfx.py    -> build/gen/*.C *.scr *.f *.s *.bin SECTAB.inc
                                                                   tools/assets/gen_flight.py (radar sprites) -> build/gen/RADAR_*.inc
    assets/models/*/*.txt      one text file per 3D model          -> tools/assets/gen_models.py -> build/gen/OBJECTS*.inc OBJX.inc
    assets/data/spawn_*.csv, ship_choice.csv, newgame_flight.csv, map_rings.txt
                               flight / map data                   -> tools/assets/gen_flight.py, gen_math.py -> build/gen/*.inc, ways.d
    assets/sound/effects.txt   AY sound effects of the flight      -> tools/assets/gen_flight.py -> build/gen/EFFECTS.inc
    assets/music/              station music: station.pt3 (standard PT3 module) + pt3player.bin -> tools/assets/gen_music.py -> build/gen/MUZ1.C
    assets/ending/             code of the ending (the 3 ending pictures are gfx/ending_*.png) -> gen_gfx.py -> build/gen/FINALF.C
    (math tables)              computed by tools/assets/gen_math.py: 0E0200.d CSTB.d D9200.d station_D9200.d (no files in assets/)
    assets/*.d *.v *.c ... binary blobs that stay binary (see "What stays binary")
    tools/assets/extract_*.py  one-time extractors used to create the files above (documentation of how they were made; not run by the build)

## Text notation (assets/text/*.txt)

    [LABEL]            section = one label of the code (do not rename).  [LABEL first=1] = numbering starts at 1 (the .tok files).
    # ...              comment (also between the lines of an item).  Every section starts with comments: where it appears, limits.
    12 | text          item 12.  The generator appends the end byte (#0A).   12 ~ text = last item without end byte (rare).
        | more text    continuation line (appended directly to the item; only a visual break in the file).
    \n                 CR = new line in the game (#0D).  A real line break in the file is NOT a game line break.
    {stop}  {tab1}..{tab5}  {nbsp}  {nbsp*31}  {sp}  {xNN}  \\  \{
                       #01 stop (the program prints a number/name here and continues) / #02..#06 column tab / #FF non-breaking blank /
                       an explicit blank (use it at the start or end of an item: editors strip trailing blanks) / any byte in hex.
    Items that are lists (TWKRB2, TTWR2, ...) are ONE item with one line per entry; the comment "# line N" marks the entry number.

Item numbers are the numbers the code uses (item 0 is normally empty).  Numbers must stay consecutive; adding an item to a list that is
indexed by another table (goods, equipment) means changing all paired tables (csv + text) and the constants in EQUS.asm.

Files: `station_ui.txt` windows/buttons/messages/settings/state names, `trade_names.txt` goods and equipment names + units, `equipment_docs.txt`
encyclopaedia, `subscribers_news.txt`, `help.txt` (menu + 8 chapters), `ships.txt` (viewer descriptions, purchase lists), `star_names.txt`,
`flight_messages.txt` (flight computer, one section per message), `rules.paradox` (trade-rules script, see below).

`rules.paradox` is a program, not prose: statement groups per line, `Mnn` shows item nn of ERORS.  Russian comments after the statements are
free text (encoded to CP866).  Edit carefully; it is interpreted at every deal.

### Encoding and the characters of the game font
The game uses the DOS code page CP866 for text: the code of a letter is the index of its glyph in the font `gfx/pro_font.png` (flight panel: `panel_font.png`).
The converter encodes the UTF-8 text with CP866.  Available glyphs of the station font (all 256 codes have a width entry; empty = blank):
* ASCII 33..126 (all printable characters, Latin letters, digits, punctuation);
* Russian: А-Я а-я (CP866 128..175, 224..239), Ё Ё (240, 241 = Ё ё);
* codes 176..223: box-drawing / pseudo-graphics glyphs of CP866 (drawn in the font, write them as {xB0}..{xDF});
* codes 127 and 242..255: other small glyphs (not inspected one by one; 255 = {nbsp}).
Other characters (any accented Latin letter, Polish, Czech ...) are not available: draw them into `pro_font.png` (replace the glyphs of codes you do not need,
set the width in `pro_font_widths.csv`) and type the character that CP866 has at that code (or write {xNN}).  For an English version just replace the text:
the Latin glyphs exist and are proportional (widths in `pro_font_widths.csv`).  Characters outside CP866 give an error that names the item.
Panel font (flight): 4x6 pixel glyphs for codes 32..239 (`panel_font.png`); the flight messages use it, check the glyphs you need exist.
Limits: the station windows are at most 255 pixels wide; text is justified over the window; long texts must fit the visible lines.  Each section comment says what is known.

## Tables (assets/data/*.csv)

`#` lines at the top explain every column; the generated labels are listed in `tools/assets/tablespec.py`.  Numbers: decimal, `0x..` or `#..` hex;
signed bytes may be negative.  Row counts are fixed (`TKOL`, `WKKOL`, `WSKOL` in EQUS.asm).

| file | feeds labels | rows | content |
|--|--|--|--|
| goods.csv | SPECTO TWRM CENS2 | 30 | price, ban level, cheap-where economy, weight class (names: trade_names.txt TTWR2) |
| equipment_ship.csv | KRBARM CENS TONNS WKII | 33 | price, level, mass, family steps, ships on which it cannot be installed |
| equipment_skimmer.csv | SKMARM CENS1 TONSS WSII | 14 | same for skimmers |
| ships.csv / skimmers.csv | CNKR / CNSK | 7 / 4 | tonnage, price, speed, legal flag / price, speed, weight |
| shipdat.csv | SHIPDAT | 16 | ships/skimmers skipped per planet level |
| keyboard.csv | TBKP | 62 | key code -> port, mask |
| settings_env.csv, settings_game.csv | SETSD SETSI, SETGD SETGI | 13, 43 | defaults of the two settings windows (ports, masks, key letters) |
| newgame.csv | TIME ... ABONS | 23 fields | the new-game state record (also the content of the SAVE0..5 slots) |

The numbers printed in `text/ships.txt` (viewer text: speed, tonnage, weight; purchase lists: price) are NOT typed there: they are tags `{=ships.N.speed}` ... that the
text generator fills from `ships.csv` / `skimmers.csv` (one source of truth).  The original game printed some numbers that differ from the table values (ship 2 speed 110 vs 120, ...);
those are kept in the csv columns `shown_price / shown_speed / shown_tonnage` (empty = same as the real column; clear the cells to make the texts consistent); `weight` of ships is print-only.

### Flight data tables
| file | feeds | content |
|--|--|--|
| spawn_types.csv | VERTAB | cumulative spawn thresholds per government (pirates, traders, police, military, hunters, harmless pirates, ufo, hostile ufo, hermits) |
| spawn_government.csv, spawn_level.csv | STROYTAB, LEVLTAB | per-government offsets and per-planet-level formula of the 15 flight parameters PLANDICTAT (formula in the csv header) |
| ship_choice.csv | TPIRAT TTRADER TARMY TPOLICE THUNTER TUFO TOTSHEL KREYSERS | which model (symbolic index) a new object gets, 8 weighted slots per type |
| newgame_flight.csv | NDATA | the OLD 215-byte new-game record of the flight; only used by dead code (RETSTT), field order differs from the real 512-byte record, see assets/data/newgame.csv for the real new game (names match: TIME PLACE WHERE PLANET WPLANET SHIP SKIMMER STATUS SUMM TONN ...) |
| map_rings.txt | ways.d (PWAYS) | six dotted rings (x y offsets) around the map markers; the code addresses them at fixed offsets |

`sound/effects.txt`: AY effects as frames `tone_lo tone_hi mixer volume` (format in the file header).  `gfx/radar_sprites.png` (+csv): the 3x3 radar blips, compass markers and the two 8x8 target highlights;
only the shape is stored, the 8 pre-shifted copies are generated.

### 3D models (assets/models)
`models/flight/*.txt` (103 flight objects: ships far/near versions, stations, rockets, asteroids ...) and `models/station/*.txt` (10 models of the 3D viewer): one text file per model,
`index.txt` of each directory lists the files in memory order (the labels are those of the old sources, the code and `3DTABS.asm` refer to them).  Format (documented in `tools/assets/models.py`):
`radius`, `scale`, `group x y z mirror=xy` (a point plus its mirror copies, numbered v0, v1 ... in the order of the groups), `poly <fill 0..7> v v v` (polygon), `line <flags> v v` (polyline), `label NAME`
before a face that the program patches at run time (engine flicker).  Limit: at most 51 vertices per model.  Edit a coordinate and rebuild: the object changes in the game.

## Graphics (assets/gfx)

| file | in game | format / limits |
|--|--|--|
| station_bg_01..16.png | stscr (16 Hrust-packed station backgrounds, loaded one at a time to a bank at #C000) | 256x192 RGB, ZX palette (normal 205 / bright 255 levels), at most 2 colours per 8x8 cell, normal or bright per cell (not mixed). The depacked data is **cell-linear** (8 bytes = one 8x8 cell, cells row by row, then 768 attribute bytes; the station code copies it cell by cell to the screen), the PNG shows the picture as the game displays it |
| panel.png | PANEL (flight HUD, unpacked by the flight at load) | same rules, normal ZX screen byte order |
| intro_logo.png | boot intro "Awaken" logo (raw screen, bitmap in the lower third) | white ink on black; the game uses only the bitmap bits and overwrites the attribute bytes, so colours are not editable |
| intro_closing.png | intro closing picture "Awaken - Second Breeze" | 256x192, ZX colours, 2 per 8x8 cell; original packed blob while unchanged, else own RLE packer (compressed size at most 6912 bytes, long runs pack well); verified: matches the running intro 100 %, an edited picture appears in the game |
| ending_1_spas_mir.png, ending_2_sdelal_eto.png, ending_3_galaxy.png | the three 256x192 1-bit screens of the ending (FINALF) | white = ink, black = paper; colours (red cycling) are set by the code; the texts "ТЫ СПАС МИР", "ТЫ СДЕЛАЛ ЭТО" are part of the pictures; build = round trip checked, not run in the emulator after an edit |
| radar_sprites.png, radar_sprites.csv | radar blips / compass markers / target frames of the flight panel | 8x8 cells, 3x3 blips, see the csv |
| pro_font.png, pro_font_widths.csv | PRO.f station proportional font | 128x128, 16x16 cells of 8x8, black = ink, code = row*16+column; width per code in the csv (advance in pixels) |
| panel_font.png | FONT.f flight panel font | 4x6 glyphs, cell 5x7, 16 per row, codes 32..239 |
| cursors.png | KSPOplus.s mouse cursors | 12 cursors of 16x16, RGBA: transparent = see-through, white = ink, black = paper |
| cache.json, orig/ | - | original packed bytes of the pictures + pixel hash |

Packing: `tools/assets/hrust.py` writes the game's Hrust 1.x format (`HR` header; format documented at the top of the module; validated against the real
game depacker run in a Z80 core, `tools/assets/z80depack.py`).  It is not byte-identical to the original packer (the original used more command forms and packs ~3 % smaller),
therefore **a picture whose pixels are unchanged is taken from `orig/` (byte-identical build)**; a changed picture is converted and packed (a few seconds, cached in `build/gfxcache/`).
After a change the sector count of each picture is recalculated (`SECTAB.inc`) and `stscr` is rebuilt.  A picture may not need more than 21 sectors (the loader buffer).
Verified in the emulator (work/assets_tech2): the unchanged PNGs equal the screenshots of the running game pixel by pixel in the free background areas (station 05: 100 % of 3600 non-black pixels; flight panel static strips 100 %; intro logo bitmap 100 %), and a changed station_bg_05.png (magenta block + stripes, 8 -> 9 sectors) appears in the running station exactly as drawn.
`python tools/assets/extract_gfx.py --from-orig` re-renders the PNGs from `orig/` (layouts: `zxgfx.bitmap_offset`).

## What stays binary (and why)

| file | why |
|--|--|
| music/pt3player.bin | the 3617-byte PT3 player (Nick of GDC, v1.0): machine code with its tables and the module address #E921 built in; not disassembled (needs a data/code analysis of self-modifying code).  The tune itself is `music/station.pt3` (a normal PT3 module, plays in any PT3 player) |
| ending/finalf_code.bin | the 681 bytes of code of the ending (start-up, colour cycling, key wait; self-modifying, interleaved with stack tricks) + 1 trailing byte; the three pictures are `gfx/ending_*.png` |
| gfx/orig/intro_depack.bin | the original intro blob: depacker + closing picture packed by the 1999 packer (undocumented, no compressor known).  Used while `gfx/intro_closing.png` is unchanged; an edited picture is packed by `tools/assets/rlepack.py` (own RLE, own 41-byte depacker, max 6912 bytes) |
| EFF.c | compiled (generated) hyperjump effect procedure = machine code |
| EXPLOSIO.v, HIPERJMP.v, VOX.d | voxel sprite data of the flight effects, format only known to the STORM code |
| D9000.d | not a table: the initial memory image of the 3D variable area (L90/L91, rubbish from the developer's memory); the engine overwrites it |
| KORNI.d, ATAGTAB.d | square-root / arctangent tables with irregular values that no formula reproduces exactly (KORNI page 1 even holds a scrambled hybrid); kept as data, not meant to be edited |
| unused/ | files of the developer disks that no build uses |
| KARTA.asm star sprites | generated drawing code, not data |

Computed instead of stored (`tools/assets/gen_math.py`, formulas in its header): `0E0200.d` (squares), `CSTB.d` (14-bit cosine), `D9200.d` / `station_D9200.d` (quarter-square multiplication table, sine, square-root page with two irregular values listed in the script).

## Round trip test (done)
Text: changing one letter of a help line (`Контракты` -> `Контракта` in help.txt) changes exactly one byte of HELP.C; reverting restores every output.
Picture: changing one cell of station_bg_05.png repacks only that picture (8 -> 9 sectors, SECTAB regenerated) and the packed result depacks (real game depacker) to the edited picture;
the other 15 pictures stay byte-identical.
