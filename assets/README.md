# assets/ - editable game content

Everything the player sees or reads is a human-editable file here.  `python build.py` first runs the converters in `tools/assets/` which write the
game form into `build/gen/` (generated, never edit), and the sources `include` / `incbin` those files.  The result is byte-identical to the
1999 data unless you edit an asset.

    assets/text/*.txt          texts (UTF-8)                       -> tools/assets/gen_text.py   -> build/gen/<LABEL>.inc, *.tok, C_SCENAR.t
    assets/data/*.csv          numeric tables                      -> tools/assets/gen_tables.py -> build/gen/<LABEL>.inc
    assets/gfx/*.png (+csv)    pictures, fonts, cursors            -> tools/assets/gen_gfx.py    -> build/gen/*.C *.scr *.f *.s SECTAB.inc
    assets/*.d *.v *.c *.C ... binary blobs that stay binary (see "What stays binary")
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

The prices and speeds are also written as plain text in `text/ships.txt` (viewer text, purchase list): keep them equal by hand.

## Graphics (assets/gfx)

| file | in game | format / limits |
|--|--|--|
| station_bg_01..16.png | stscr (16 Hrust-packed station backgrounds, loaded one at a time to a bank at #C000) | 256x192 RGB, ZX palette (normal 205 / bright 255 levels), at most 2 colours per 8x8 cell, normal or bright per cell (not mixed). The depacked data is **cell-linear** (8 bytes = one 8x8 cell, cells row by row, then 768 attribute bytes; the station code copies it cell by cell to the screen), the PNG shows the picture as the game displays it |
| panel.png | PANEL (flight HUD, unpacked by the flight at load) | same rules, normal ZX screen byte order |
| intro_logo.png | boot intro "Awaken" logo (raw screen, bitmap in the lower third) | white ink on black; the game uses only the bitmap bits and overwrites the attribute bytes, so colours are not editable |
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
| MUZ1.C | PT3 player + a third-party tune (Virtual Aggression compilation by Mast/FtL): code and module in one blob; split into player + .pt3 not done |
| FINALF.C | the ending: one program with its own code and bitmap texts ("ТЫ СДЕЛАЛ ЭТО" ...) in one self-contained 19 KB image, no string table, graphics interleaved with code; needs a disassembly first |
| intro_depack.bin | intro depacker (code, a different packer from Hrust: no `HR` header) + the packed closing picture "Awaken - Second Breeze"; its format was not reconstructed |
| EFF.c | compiled (generated) hyperjump effect procedure = machine code |
| EXPLOSIO.v, HIPERJMP.v, VOX.d | voxel sprite data of the flight effects, format only known to the STORM code |
| D9000.d, D9200.d, CSTB.d, ATAGTAB.d, KORNI.d, 0E0200.d, station_D9200.d | math tables (sine / multiplication / atan / square root); could be generated by a script (not done) and are not meant to be edited |
| ways.d | dotted-line pattern bytes of route lines on the map |
| unused/ | files of the developer disks that no build uses |
| flight: OBJECTS*.asm, 3DTABS, panel radar sprites (`%` lines), AY sound effects, spawn tables (SETHJRET/OBJGENER), NDATA | still `db` blocks in the asm sources (models = vertex/face data; the others are small data tables) - not yet converted |
| station OBJX.asm (10 viewer models), KARTA.asm star sprites (generated drawing code) | models / code |

## Round trip test (done)
Text: changing one letter of a help line (`Контракты` -> `Контракта` in help.txt) changes exactly one byte of HELP.C; reverting restores every output.
Picture: changing one cell of station_bg_05.png repacks only that picture (8 -> 9 sectors, SECTAB regenerated) and the packed result depacks (real game depacker) to the edited picture;
the other 15 pictures stay byte-identical.
