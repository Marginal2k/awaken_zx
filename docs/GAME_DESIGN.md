# Awaken - game design (reverse-engineered)

Tags: VERIFIED (file:line) / INFERRED.  Written by the technician, 2026-11-15, incrementally.

## 1. Text system

Line numbers refer to `src/station/*.asm` (UTF-8 copies in `work/tech/u8/src_station_*.asm`; DATAT/DATA_M/DATA3D are cp1251 in `src/`).

### 1.1 Storage and encoding
* All station texts are plain `db` byte strings, **not compressed, no dictionary tokens**.  The sources are Windows-1251 text with `ENCODING "DOS"` (DATAT.asm:2, DATA_M.asm:2, DATA3D.asm:2); sjasmplus converts each Cyrillic letter to the CP866 code (128..175, 224..241), which is the code of the glyph in the proportional font `assets/PRO.f` (station.asm:24).  VERIFIED (header comment of DATAT.asm; `help.tok` bytes decode cleanly with `cp866`).  The files switch back to `ENCODING "WIN"` at their end.
* The `*.tok` files (`help.tok` 3646 B, `ship.tok` 1623 B, `skim.tok` 657 B) are called "tokenised" after the tool that made them (`SCR>TOKN`) but contain **plain CP866 text**: `#0D` (CR) = line break, `#0A` (ET) = end of item, an empty last item.  VERIFIED (decoded with python `bytes.decode('cp866')`).  `incbin`ed at HELP.asm:124 (`THELP`), station.asm:74/76 (`TISHIP`, `TISKIM`).
* Control codes (PNT.asm `Outtxt` 1292ff, `OTXT` 141ff, `VTXT` 23ff, `Tood3`): `#0A` ET = end of text/item (EQUS.asm:18); `#0D` CR = new line (EQUS.asm:17); `#20` blank (`OTXT`/`VTXT` justify the words over the window width, minimum gap `SPLEN` = 2 px, EQUS.asm:26); `1` = stop output there (the caller prints a number/name and continues with the returned `hl`; used by `WELCOME`: "модель <1>, системы <1>, ... составляет <1> кредитов."); `2..6` = tab to `CXTAB1..CXTAB5` (column starts set by the window code); `#FF` = non-breaking blank (table headers use `ds 31,255` as blank line); key-name symbols `ENT`/`SS`/`SP` via `SPECTB` (PNT.asm:1485-1514).  VERIFIED.
* String tables = items separated by ET; an item is selected by number with `LIST`/`LIST0`/`LIST1`/`FLIST` (DOPPROC.asm:702-727: skip `a` ET-terminated items).  Item 0 is usually empty (`db <ET>` first; `Wintxt`: "0 = empty text, all names from 1", DATAT.asm:415).  VERIFIED.
* Fonts: `PRO.f` (2304 B proportional font for station text), `FONT.f` (624 B, flight panel).  Width table `SZTB` (PNT.asm `Hlt`).

### 1.2 What `LANG.asm` is
Not texts: it is the interpreter of the scripting language **"Paradox v1.0, 13.11.99"** (LANG.asm:36-58; command list `_IF _THAN _ELSE _NEXT _CHANGE _OVER _ON _OFF _OPEN _EXIT _CLOSE _MESSAGE _TONN _mESSAGE _WYDWOR`, operands for ship/skimmer/cargo/equipment/mission/person properties).  Entry `PARADOX` (LANG.asm:67); the program is `CHECK_SCENARY` (LANG.asm:2171) = `incbin "C_SCENAR.t"` (1500 B, the trade rules, see sections 3/4).  Called from BODY.asm:45/80, OBR.asm:1397/1675/2002, OBR2.asm:71 with `OPERATION` (DATA_M.asm:753) = number of the trade operation.  The language has switch operands `T_PERS T_QUES T_MISS T_HAPP T_TXT` (CODE15) and arguments `_MISSION _PERSTXT _HAPPAND`: designed for dialogues and missions too, but **`TXTES` ("converted scenario texts", LANG.asm:2181) is empty and `t_PERS/t_QUES/t_MISS/t_HAPP/t_TREE` (DATA_M.asm:1034-1057) are only reserved buffers (`ds PKOL/QKOL/MKOL/HPKOL` = 50/20/15/7)**.  Only the trade-rules script exists.  VERIFIED.
The script is **text** (ASCII commands, Russian comments in CP866), see `work/tech/c_scenar.txt`: `?X=9:{ ... }` = block for operation 9, `?a<b:` condition, `Mnn` = show message nn of `ERORS`, `=c-G.c` assignment, `T` = recount tonnage, `^` = end/ok, `W` = expel from station.  It is re-read at every deal, so it is editable data.

### 1.3 Window / button format
Every UI object is a 16-byte record (OBJECT.asm:1-30): `dw X,Y` (0,0 = not placed), `db status` (bits `OOYFXMSN`: type 00 window / 01 button / 10 line; N = window has a title line / button pressed; Y = erased by fire on the background; F = latching button; S = fixed size; m = immovable), `db name-number` (index into `Wintxt` / `Buttxt` / `Lintxt`), `dw handler`, `dw` default position+size (`#130A,#0205` = x,y,sx,sy in character cells), `dw draw-routine`, `dw reserve`.  Table: OBJECT.asm from line 38 (status lines, the desktop buttons, windows from ~line 300).  VERIFIED.
Window titles `Wintxt` (DATAT.asm:415, 21 titles); button tooltips `Buttxt` (DATAT.asm:442; item = title, CR, description; the table has 16 empty slots "; 23" and "; 40 inner buttons"); `TSETS1`/`TSETG1` = labels of the two settings windows (13 "environment" items and 43 "game" items: 28 ship-flight controls + 15 skimmer controls); `THIDE` = system menu; `TSOH1/TWOS1` = save/load slot lists.  Help: `THLPL` (menu of 8 chapters, HELP.asm, as numeric CP866 bytes) + `THELP` (= help.tok, 8 chapters).  VERIFIED.

### 1.4 Text categories (DATAT.asm unless stated; `work/tech/textstat.py`)
| label | line | items | content |
|--|--|--|--|
| MODELS | 4 | 16 | station models: Гесмест, Аквадиз, Асфер, Квадокс, Рубирон, Иринекс, Сервест, Орегон, Глидер, Дистрой, Ретоер, Орфост, Фальварк, Мезатрон, Левиофан, Паралакс |
| WELCOME | 24 | 1 (3 fields) | "Орбитальная станция, модель <1>, системы <1>, рада приветствовать Вас! ... почасовая оплата ... <1> кредитов." |
| ERORS | 34 | 16 | messages M01..M16 used by the script (listed in section 3) |
| TARMI | 82 | 47 | encyclopaedia entries of the equipment: 33 for the ship (order of `TWKRB2`) + 14 for the skimmer; "Было создано в N году новейшей эры" |
| TSOH1/TWOS1 | 294/301 | 5+5 | save/load slot names |
| TSETS1/TSETG1 | 309/326 | 13 / 43 | settings labels |
| TABON1, NABONS | 373/377 | 1+16 | subscriber names + home star, e.g. "Петр Грек<2>Миир" |
| TNEWS | 396 | 2 | "Новостей нет." and "Внимание! На Галактическую Федерацию напала враждебная расса инопланетян! ..." |
| THIDE | 405 | 8 | system menu |
| Wintxt | 415 | 21 | window titles |
| Buttxt | 442 | 22 (+16 empty) | button help texts |
| Tstatus | 573 | 4 | Чистый / Подозреваемый / Розыскиваемый / Приговоренный |
| Lintxt | 584 | 3 | "Статус: ", " Кредов: ", " Тоннаж: " |
| TINFS1/2 | 593/613 | 2 | header of the system-info window (fuel, distance, planet, "Строй", "Тип", "Уровень", planets of the system) |
| STROY | 621 | 5 | political system: Демократия, Диктатура, Анархия, Необитаемая, Неизвестный |
| TYPE | 628 | 4 | economy type: агрокультурная, культурная, технологическая, общая |
| TTWR1/TTWR2 | 640/648 | 1 / 30 | goods window header and the 30 goods names + units (тн, кг, г, чл, эк) |
| TWKRB1/TWKRB2 | 681/691 | 1 / 33 | ship equipment window header and 33 names |
| TWSKM1 | 727 | 14 | skimmer equipment names |
| TMISS1 | 745 | 1 | contract header "Доставка грузов ко времени / Звезда / Планета / Вес / Время / Цена" (no code uses it, section 4) |
| TGOST | 755 | 4 | states: Федерация Галактики, Конфедерация Первых, Содружество Миров, Свободные Земли (used by the system-info window, OBR.asm:2493/2611) |
| Txt | 580 | 1 | "Это есть прототип интерфейса" (placeholder printed by the contract windows) |
| help.tok | HELP.asm:124 | 8 chapters, 3646 B | in-game manual |
| ship.tok / skim.tok | station.asm:74/76 | 7 / 4 | descriptions of the 7 ships and 4 skimmers (3D viewer) |
| C_SCENAR.t | LANG.asm:2172 | 1500 B | trade-rules script |
About 12 KB of strings plus 5.9 KB of tok files.  Texts outside the station: flight-panel labels in `FONT.f`/PANEL (graphics, section 10) and the ending scroller in FINALF (section 7).

### 1.5 Quirks
* Typos in the original: "расса", "четырмя", "Исползуется", "компинсационные", "шарниры".  Not fixed (the user did not ask).
* The equipment encyclopaedia (TARMI) and the shop names (TWKRB2) differ from the comments in DATA_M.asm (older names: "Топл. 'Космонефть'", "Лаз. 'Град'", "Гипер С 'Дьявол'"): three naming generations (section 3).
* Tables are paired **by position**: TARMI[i] / TWKRB2[i] / CENS[i] / TONNS[i] / WKII[i] / KRBARM[i] / WKRBI[i]; goods TTWR2[i] / CENS2[i] / SPECTO[i] / TWRM[i] / TWRI[i].  Adding an item means editing all of them (DATA_M.asm) and the constants `TKOL`, `WKKOL`, `WSKOL` (EQUS.asm:31-37) and the script.
* A line in the source is not a line on screen: the formatter justifies words over the window width (`OTXT`).

## 2. Ships and objects

(pending)

## 3. Goods, equipment, economy

(pending)

## 4. Contracts, missions, news, subscriber

**Short answer: the contract/mission/news/subscriber *interfaces* exist, but there are no missions, no story contracts and no dialogues in the code or data.  All of it is stubs; the only working "rules" are the trade/police rules in the script.**  Line numbers: `work/tech/u8/src_station_*.asm` (= `src/station/*`) unless marked.

### 4.1 Contracts ("Контракт", `WMISS1/WMISS2`)
* Two windows exist ("список подписанных контрактов" / "список предлагаемых контрактов", per `help.tok` chapter 8): `WMISS1`, `WMISS2` (OBR.asm:1265-1349), opened by button `BMISS` (OBR2.asm:~780).  Both draw only the placeholder text `Txt` = "Это есть прототип интерфейса" (OBR.asm:1285-1288, 1324-1330).  The click handlers (`F_S4`, `F_S5`, `WMISS1C`) are a bare `ret`.  The header text `TMISS1` ("Доставка грузов ко времени / Звезда / Планета / Вес / Время / Цена", DATAT.asm:745) is referenced by no code.  VERIFIED (grep `TMISS1`).
* Data layout is planned, in the state record: `JLIST` (DATA_M.asm:679) = 160 bytes = 10 offers x 16 bytes: destination system 2 words (4 B), deadline 2 words (4 B), time of generation 2 words (4 B), reward word, weight byte (bit 7 = "taken, cannot be refused"), planet byte.  `ORDER` (DATA_M.asm:901) = 4 signed contracts x 16 bytes in the same layout, first byte `#FF` = no order.  **No code reads or writes `JLIST`/`ORDER`** (grep), so contracts are neither generated nor accepted nor delivered; flight has only the buffers (3DTABS.asm:355 `ORDER`) and nothing checks delivery.  Operations 12/13 ("контракт" buy/sell) are listed in the `OPERATION` comment (DATA_M.asm:742-750) but the script has no block for them.  VERIFIED.
* Design intent (INFERRED from the layout and the TMISS1 header): procedurally generated *cargo delivery* contracts "deliver N tonnes to star/planet by time T for money M", 10 offered + 4 accepted, like Elite's "cargo delivery" with a deadline.  Time unit = the game clock `TIME` (day word, hour, minute; starts day #0122 = 290, 10:10).

### 4.2 News ("Новости", `WNEWS_`)
* `WNEWS_` (OBR.asm:1048) prints item `NEWS` of the list `TNEWS` (DATAT.asm:396): index 0 empty, 1 "Новостей нет.", 2 "Внимание! На Галактическую Федерацию напала враждебная расса инопланетян! Призываем всех патриотов на защиту своего государства!".  `NEWS` (DATA_M.asm:897) = `db 1,0 / dw 0,0 / db 0` = message number (starts 1), "hour until which it is held", system coordinates and planet where the event happens (the comment says news is tied to a system + planet).  **Nothing ever writes `NEWS`** (station and flight grep), so only "Новостей нет." can ever be seen; the alien-invasion text is unreachable.  VERIFIED.
* Design intent (INFERRED): news items driven by the script/events (`t_HAPP` = 7 event flags, `_HAPPAND`) with a system+planet attached.

### 4.3 Subscribers ("Абонент", `WABON_`, `WFOTO_`)
* 16 named subscribers (`NABONS`, DATAT.asm:377: "Петр Грек - Миир", "Алексей Ворсин - Пика", "Николай Громов - Сули", "Борис Симонов - Лолэ", "Сергей Еремеев - Редиво", "Евгений Покровский - Каалис", "Григорий Опорский - Амиго", "Дмитрий Смирнов - Руокр", "Максим Руслов - Ювегацз", "Вадим Хлопотин - Пикасо", "Виталий Бордов - Тера", "Владимир Земерский - Аргона", "Денис Типовский - Цоки", "Павел Ворожин - Резера", "Кирил Риманов - Рубина", "Иван Ефремов - Ипраби"; person + home star; names look like real people, probably the author's friends/team).  `ABONS` (DATA_M.asm:952) = availability byte per person (1 = hidden, 2 = visible, 0 = end) for up to `PKOL` = 50 people; initially persons 1 and 2 are visible.  `PSTARS` (DATA_M.asm:943) = coordinates of the star where each person lives (map word + in-map word): only person 1 is filled (`#4B39,#0006`), the other 49 are zero.  The map button "Абонент" centres the map on the next visible person's star (OBR2.asm:650-680, `BNABO`); the Абонент window lists visible persons (`WABON_`, OBR.asm:1108-1141) and clicking one opens a photo window `WFOTO_` (OBR.asm:1185-1226) that blits 128 bytes per portrait from `FOTOS` = #E700 of bank #17.  **That address is inside the help text (`THELP` = #E3E2..#F220, build/station.sym), so there are no portraits: the window shows garbage/help text bytes.**  VERIFIED (sym addresses).
* There is no "call" action: the button help says "Вызов абонента с последующей интерактивной связью", `help.tok` chapter 6 says "Окна: список абонентов, досье на абонента, фото абонента. Кнопка: прервать связь" (dossier window + photo window + hang-up button), but the handlers `F_S1`, `F_S15`, `WABONC` are bare `ret` and no dossier text exists.  VERIFIED.

### 4.4 The script "Paradox" and the scenario-text design (`LANGUAGE.C` on awk6)
* The disk awk6 also holds `LANGUAGE.C` (7934 B) = the **language manual** and `TREE.t` (494 B) = the layout of the dialogue tree (neither is built into the game; extracted to `work/extract/awk6/`, decoded copy `work/tech/language_doc.txt`).  Contents: operands/commands as in `LANG.asm` and the text-file format for scenario texts: identifiers ` _p1s1t1@` (**p**ersonage 1, **s**cene 1, **t**ext 1), text left-aligned, `@` = paragraph end, `#` = end of text; one text may belong to several persons/scenes (` _p1s1t2 _p2s2t3@`); the converter joins lines until `@` and produces `TXTES` (empty in the build).  Switch commands `+p1 / -v1` (person, question `v`, text `t`, mission `m`, event `e` on/off), `#` = **end of game**, `=g1+10` change, `?cond:then@else`, `{ }` blocks, `T` recount tonnage, `^` leave.  The sample texts in the manual are jokes ("И пошел Иоан туда куда его послали!", "Я не русский разведчик не трогайте меня").  `TREE.t`: "all persons start with #FF, all scenes with #FE" = byte tree: per person a marker, per scene a marker followed by the count of texts.  So the intended mission system: persons (50) with scenes (dialogue states) and texts, questions (20), missions (15) and events (7) as on/off flags driven by the script, with `#` as a possible game-ending command.  INFERRED from the manual; flag arrays `t_PERS` (50), `t_QUES` (20), `t_MISS` (15), `t_HAPP` (7) sit at TIME+#2AB, +#2DD, +#2F1, +#300 (DATA_M.asm:1034-1041, offsets from `build/station.sym`).
* **These flags are outside the 512-byte state record** (`TIME` = #983B, record ends at #9A3B; `ABONS` = #9A41, `PERSONAJ` #9AE4, `t_PERS` #9AE6, `t_TREE` #9B42; `SETSD/SETGD` key settings #9A74/#9A8E).  Consequence: person availability, mission/event flags and the key settings are neither saved in `SAVEn` nor handed to the flight, so a mission system needs the record enlarged (the record is exactly 2 sectors; `PSTARS` already runs past the end: its last 6 bytes are outside).  VERIFIED (addresses); the consequence is INFERRED.

### 4.5 What *does* run: the trade/police rules (`C_SCENAR.t`, executed by `PARADOX`)
Run from `Dalee` (BODY.asm:30-50: operation 15 at every arrival/start, operation 16 for the parking fee) and from the trade windows (OBR.asm:1397/1675/2002, OBR2.asm:71).  `X` = the operation number (OPERATION, DATA_M.asm:742): 1/2 buy/sell ship, 3/4 skimmer, 5/6 ship equipment, 7/8 skimmer equipment, 9/10 goods, 11 sell all of a good, 15 start check, 16 parking fee.  Details (prices, tonnage, fines) are in section 3.
**No flight code ever reads a mission**: delivery would need a check at docking (`RETSTAT`, section 6), which does not exist.  Completion checking in flight: none.  VERIFIED (grep of flight sources for `ORDER`/`JLIST`: only the data buffer).

### 4.6 Flags and counters in the state record (offsets from TIME = #983B, `build/station.sym`)
| offset | label | size | meaning |
|--|--|--|--|
| +000 | TIME | 4 | day word (start #0122), hour, minute (BCD? shown as 0122:10:10) |
| +004/+008 | PLACE/PLANET | 4+4+1 | map tile word, in-map word, planet number where you are |
| +009/+00D | WHERE/WPLANET | same | selected destination |
| +00E/+00F | SHIP/SKIMMER | 1/1 | ship model 0..6 (start 6 = Карэн), skimmer #FF = none |
| +010 | STATUS | 1 | police status (start 67 = wanted!) |
| +011 | SUMM | 2 | credits (start 25000) |
| +013 | TONN | 2 | carried tonnage / ship capacity (start 0,50) |
| +015 | TWRI | 60 | 30 goods x (amount, buy price) |
| +051 | WKRBI/FUEL | 34 | ship equipment counts (first two = fuel types), `#80` terminator |
| +073 | WSKMI | 15 | skimmer equipment counts |
| +082 | NEWS | 6 | news slot |
| +089 | ORDER | 64 | 4 signed contracts |
| +0C9 | SPEED/DALNO | 2+2 | speed of ship/skimmer; distance to selected star |
| +0CD | MSTARS | 51 | 10 remembered stars x 5 bytes (map word, in-map word, planet) |
| +100 | WAY | 51 | route stars |
| +133 | WAYMASK | 11 | route line descriptor |
| +13E | PSTARS | 200 | person star coordinates (cut at +200) |

## 5. Map

**The galaxy is procedural: there is no star table.**  Every star, its name, planets, government, economy and the goods prices are computed from the 4 coordinate bytes of the star by small PRNGs.  Line numbers: `work/tech/u8/src_station_*.asm`.

### 5.1 Coordinates and map generation
* A star is addressed by two words: `PLACE`/`WHERE` = "map" word (`h` = x tile, `l` = y tile; start `#4B38` = tile 75,56) and "in-map" word (`#4AF3`: y = #4A, x = #F3 position inside the tile) plus a planet number (`PLANET`/`WPLANET`, 0 = lowest planet).  (DATA_M.asm:771-783; `WHERE` default in flight `#4B38,#4AF4`, 3DTABS.asm:204.)  Tile coordinates are bytes, so the grid is at most 256 x 256 tiles; INFERRED: ~128 stars per tile, i.e. millions of systems, only the area around 75,56 is "inhabited" (see 5.3).
* `GENKART` (KARTA.asm:653) fills four 256-byte buffers `KR1..KR4` (CIRCMATH.asm:1724) - the 2 x 2 tiles around the current view `KCORD` - with the PRNG `RNDI/RNX` (KARTA.asm:683-720) seeded from the tile coordinates; each buffer is a list of (x,y) star positions.  `MBUFM` (KARTA.asm:787) clips them to the window and builds the table of visible stars `DOTB`; `STARCH` (KARTA.asm:521) picks the star nearest to the cursor (`RAST` distance), then `OPRPLAN` finds the planet number from the remembered-stars list `MSTARS` (10 x 5 bytes; unknown stars -> planet 0).  Star markers are 6 small sprites in KARTA.asm:1615-2113 (`SPRP`.. `SPLUS SMINI STREUG SNULL SKREST SQUADR`: plus, mini, triangle, null, cross, square) used for memorised stars / route / persons; `ways.d` (702 B, `PWAYS`) = the dotted route-line patterns.  VERIFIED.
* Map windows: galaxy map (`WMAP`, OBR.asm:768), enlarged map `WMAP_`, system map with rotating planets (`WPLAN`, OBR.asm:2650), info window `WINFS`.  Buttons: `Память` (remember a star: 10 slots), `Маршрут` (route, up to 10 stars `WAY`), `Стереть маршрут`, `Листать звезды`, `Позиция`, `Центр`, `Абонент` (centre on the next subscriber's star), `Перелет`.  The big circle on the map = jump range from the fuel (`FUEL`: radius = fuel/2 low byte, KARTA.asm:28-35).  VERIFIED.

### 5.2 Names
* Star name = Greek-letter word (16 of `NAMTAB`: Алфа, Бета, Гамма, Дельта, Эпсилон, Дзета, Эта, Тета, Иота, Каппа, Ламбда, Сигма, Омега, Кси, Пи, Пси; CIRCMATH.asm:1472-1490, bytes are CP866 codes) + "-" + a number 0..255 + "/" + a number 0..255 + "-" + a letter А..П: e.g. "Алфа-123/45-В", computed from the 4 coordinate bytes (`NAME`, CIRCMATH.asm:1378, result in `TNAME`).  Planet name = letter + "-" + number (`PNTPLAN`, KARTA.asm:1406).  VERIFIED.
* The subscribers' home star names in `NABONS` ("Миир", "Пика", "Рубина", ...) are *hand-written* words that the generator can never produce: either each person's home star was meant to have a fixed name override, or the names are decoration (INFERRED).

### 5.3 System data (`PINFO_`, KARTA.asm:1496; same code in flight, SETHJRET.asm:663)
From the seed (`RNDD` PRNG, DOPPROC.asm:1500ff) for each star: number of planets = ((x^y^...)&7) - 1 clamped at 0 (so 0..6; 0 = "Планет нет"), for each planet one byte `%SSUUUUTT`: government `SS` (0..2 `STROY` Демократия, Диктатура, Анархия; 3 = Необитаемая), level `UUUU`+1 = 1..16 ("Уровень", also index of the station model and the docking fee), economy type `TT` (0..3 `TYPE`: агро, культурная, технологическая, общая).  The state (`GOSTA`, CIRCMATH.asm:1498) is a function of the tile rectangle:
| tiles (x, y) | state |
|--|--|
| x 74..77, y 54..57 | 0 Галактическая Федерация (the start tile 75,56 is inside) |
| x 71..73, y 52..55 | Содружество Миров (code comment "СОДР. МИРОВ") |
| x 71..73, y 56..58 | Конфедерация Первых |
| everything else | 3 Свободные Земли ("Неизвестный" government: `h` = 4, no data) |
(The numbers in the code comments of `GOSTA` 1 = Конфедерация / 2 = Содружество contradict the code, which returns 1 for the x71..73,y52..55 block; the `TGOST` list order is Федерация, Конфедерация, Содружество, Свободные Земли; so the labels of states 1 and 2 may be swapped on screen: INFERRED, check in game.)
So the "civilised" region is only 4 + 3 + 3 tile blocks (about 20 tiles); the rest of the 256 x 256 grid is free lands with unknown government, which the flight treats as "NEИЗВЕСТНАЯ" (`VERTAB` last row) and "НЕЗАСЕЛЕННАЯ" (uninhabited).  VERIFIED (code), the meaning INFERRED.
* Distance = integer square root (table `KORNI.d`) of (dx^2 + dy^2)/9 over the 16-bit coordinates (`FARER`, CIRCMATH.asm:1553; result 1..254, `#FF` = too far), in "сл" (light years).

### 5.4 Hyperjump rules
* **In the station** the map button `Перелет` (`BPERE`, OBR2.asm:333; object table OBJECT.asm:236 "ПЕРЕЛЕТ НА ДР. СИСТЕМУ", button text 40) just copies `WHERE/WPLANET` into `PLACE/PLANET` and jumps to `Dalee` (new screen: goods prices regenerated, start check run).  **No fuel check, no distance check, no time advance**: a free teleport (probably a development shortcut; the real jump is in flight).  VERIFIED (OBR2.asm:333-347).
* **In flight** `HIPER` (SETCONTR.asm:404, key "Гипер прыжок, +CS к звезде"): fuel units = `FUEL` word (if the high byte is 0 the low byte is halved), `DALNO` = distance of the selected star; refused if no fuel, distance > 255 (`h` != 0) or fuel < distance; jump to the same star costs 0 (same planet is refused unless a "Дьявол" system `GDIABLO` is fitted: "Гипер Система" can jump inside a system) and +1 tonne when only the planet changes; then `AFUEL` subtracts the fuel; ship message `_HIPER` ("Разогрев реактора. Подготовка к совершению гипер прыжка."), and `ZM18/ZM19` (SETHJRET.asm:23-190) loads the voxel hyperspace animation, then `SETIT/SETT` regenerates the destination system (planet/sun model, probability tables from government and level, see section 6).  `RETURNSYS` ("Система возврата") re-jumps to `PLACE` once (flag `SWOZWR`).  VERIFIED.
* Equipment that changes the jump: "Система 'Гиперслед'" (the "hyper-track" computer: "расчитать точку перелета к системе в момент нахождения за ней"), "Система Возврата", "Гипер Система 'Фостэр'" ("перелёт к любой планете или звезде", code name "Дьявол" in the old comments), "Топливо МРП/ЛНП" (two fuel types, fuel table `FUEL`).  Ship fuel is `FUEL` in the state record.

### 5.5 Which station you dock at
* In the station you are always at *one planet's orbital station*: the model name comes from the planet level (`WELCOME`: "Орбитальная станция, модель <MODELS[level]>, системы <name>-<planet>, ... почасовая оплата <5 x level> кредитов", OBR.asm:2817-2870; `PINFO2` level l -> fee `l*5`).  The tonnage/parking fee `L.u` (level) is used in the script: `=c-(L.u*5)` for the hourly fee (X=16).
* In flight `OBJGENER` (OBJGENER.asm:25 `STATTB`, :137-139) builds the station 3D object for the level of `PLACE/PLANET` (16 station models `St1..St16`, hand-modelled in OBJECTSS.asm), places the sun and planet models (`MODELSTAR`/`MODELPLANET` at SETHJRET.asm:921/947) and generates traffic.  Arrival at a planet: the ship appears near the planet with the station at some distance; flying into the docking block returns to the station of the planet you jumped to (`RETSTAT`, section 6).
* Selecting a planet on the map: the planet number of a star is only known when the star is in the memory list (`MSTARS` stores 5 bytes: map word, in-map word, planet), else planet 0 ("снизу вверх" = lowest planet first).  Planet count and per-planet data come from `PINFO` with the planet number as the iteration count.

### 5.6 Distances and time
The clock `TIME` is advanced by the clock routines only (station BODY.asm:219-234, flight `TIMER` COMPUTE.asm:454); a hyperjump does not add travel time (no code does `TIME += distance`).  The parking fee is charged through the `PLATA` flag (BODY.asm:36-52, script operation 16).  INFERRED.

## 6. Flight

(pending)

## 7. Story

**There is no written plot in the game: no intro text, no dialogues, no mission text.**  The story has to be assembled from small hints.  What is *certain* is the setting and the (one-sentence) ending; everything else is INFERRED.

### 7.1 Setting (all from texts)
* **Time**: the calendar is "новейшая эра" (current era, years 3..121 appear in the equipment history, e.g. "создано в 121 году новейшей эры") counted "по кореанскому летоисчислению" (ship.tok, skim.tok: "...по кореанскому летоисчислению" = by the **Korean** reckoning of years) with a much older "прошлая эра" (years 9800-9987 "прошлой эры": cold-store, landing module, hyper-flight service, antimatter scoop `TARMI` entries 24-31).  The game clock starts at day #0122 (=290), 10:10.
* **Space**: "три мира" (three worlds) - ship descriptions speak about "аристократия трех миров", "торговый флот трех миров", "низшие классы трех миров"; the map has three named states plus free lands (`TGOST`, DATAT.asm:755): **Федерация Галактики** (the "Галактическая Федерация"; the start region), **Конфедерация Первых**, **Содружество Миров**, and **Свободные Земли**.  Social classes: "высшая аристократия / аристократия / средний класс / низшие классы" (buyers of ships).  Governments of planets: демократия, диктатура, анархия, необитаемая.  Ranks of the police record: Чистый - Подозреваемый - Розыскиваемый - Приговоренный.
* **Currency/units**: "кредиты", "кредов", light years "сл", tonnes/kg/g/persons/"эк" (equivalents of technologies).  The goods list is a social picture: рабы, проститутки, наркотики, трансплантанты, уникумы (!), технологии, артефакты (30 goods, section 3).
* **Station life**: "Орбитальная станция, модель Гесмест ... рада приветствовать Вас! Сообщаем Вам, что почасовая оплата услуг орбитальной станции составляет N кредитов."  Documentation of equipment ("Документация оснащения", `TARMI`) reads like an in-world technical encyclopaedia.  Station help: "Галактическая инфосфера" (the info terminal of the station/ship: "Все управление системой осуществляется с помощью манипулятора и клавиатуры станционного или бортового терминала").
* **Ship names** (7): Доминион, Софист, Мемфис, Фирс, Орсан, Барос, Карэн; skimmers (4, "скимеры" = planet-surface hover craft): Фервест, Кридон, Протос, Алгол.  Station models (16): Гесмест, Аквадиз, Асфер, Квадокс, Рубирон, Иринекс, Сервест, Орегон, Глидер, Дистрой, Ретоер, Орфост, Фальварк, Мезатрон, Левиофан, Паралакс.  Equipment makers/trademarks: Ксоникс, Корпс, Динейел, Милениал, Эпик (lasers), Дифёрт, Сёрфейс, Сейсмис (shields), Риал, Вист (afterburners), Ситизан, Ситрэн, Эйлиас (repair droids), Фостэр (hyper system), Бейл, Эксиал, Фэйк (skimmer lasers), Дьюорф, Интенд (skimmer shields), Плизант, Сэйкрид (skimmer jump engines).

### 7.2 The start of the game (what the player experiences)
You start in the Galactic Federation (tile 75,56) in the *oldest, almost extinct ship model* "Карэн" ("Была создана в 9981 году прошлой эры... Многое новейшее оснащение не может быть установлено на его борт"), tonnage 50, speed 70, which is the one **illegal / not sold** ship in the table (`CNKR` last row, DATA_M.asm:712: "НЕЛЕГАЛЬНЫЙ КОРАБЛЬ, НЕ ПРОДАВАЕМЫЙ"), with 25000 credits, 50 t capacity and **police status 67 = "Розыскиваемый" (wanted)**.  Therefore the first screen after the intro is the "Внимание!" window: "Вы находитесь в розыске! Все тяжёлое вооружение с вашего корабля будет демонтировано в пользу государства. Помимо всего, Вы будете оштрафованы на 1000 кредитов." (script X=15 runs in `Dalee` at every arrival; it subtracts 48 from the status and the 1000 cr, removes the 5 lasers `o6..o10`, both rocket types `o3,o4` and the cyber fleet `o32`; item numbers are 1-based in the script.)  After it the status is 19 (Чистый) and the "Добро пожаловать!" window ("... оплата ... N кредитов") appears.  VERIFIED (C_SCENAR.t, DATA_M.asm:786-794).  Story reading (INFERRED): "Awaken" - you wake up (awaken) with a past: a stolen/legacy relic ship and a criminal record, in debt to the state.
* Restoring a saved game re-runs the same start check (docs/TESTING.md observations): it takes the 1000 cr fine once more when the saved status is still >= 64.

### 7.3 News and events
Only one hint exists: news item 2 (unreachable, section 4): "Внимание! На Галактическую Федерацию напала враждебная расса инопланетян! Призываем всех патриотов на защиту своего государства!" = an **alien invasion of the Federation**.  This matches flight: UFO types `T_UFO/T_UFO2` (`IUFO1..IUFO8`, unnamed aliens, much more frequent in *uninhabited/unknown* systems, section 6) and the "Космический флот убийц, действующих в автономном режиме" ("Кибер Флот / Кибер Киллер ККР-0562", an item you can buy; section 3).  So: the aliens (UFO) attack, patriots are called to defend the Federation; the player can become a patriot (military, `T_MILITARY`) or a criminal (pirates).
Also: "Галактическая полиция предупреждает Вас о том, что Вы уже числитесь как неблагоприятный гражданин. В целях предупреждения Вы будете оштрафованы на 50 кредитов" (status 48..63) - the police is a real force with attack escalation (`CHSTATUS`).

### 7.4 Subscribers
16 named persons (section 4.3) - their names are ordinary Russian first+last names (Петр Грек, Алексей Ворсин, ..., Иван Ефремов) with home stars (Миир, Пика, Сули, Лолэ, Редиво, Каалис, Амиго, Руокр, Ювегацз, Пикасо, Тера, Аргона, Цоки, Резера, Рубина, Ипраби).  They were to be dialogue partners and mission givers ("Вызов абонента с последующей интерактивной связью").  The names are probably real friends/team members or placeholders (INFERRED).  No dialogue text exists.  The manual of the script language (`LANGUAGE.C`, section 4.4) has joke sample lines only.

### 7.5 The ending (FINALF)
* `FINALF` (assets/FINALF.C, 19114 bytes at #6000, assets/MANIFEST.md) is a standalone program (code + graphics; no disk access).  Played in the emulator (`work/tech/end/ending_*.txt`, shots `work/tech/end/e000..e015.png`): a galaxy (spiral, Andromeda-like) picture in **6 colour phases that loop every 2400 frames** (red / green / blue backgrounds and negative images) with big pixel letters:
  * red phase (top and middle of the picture): **"ТЫ СДЕЛАЛ ЭТО"** (the letter Д is drawn like "О" with feet: reads "ТЫСОЕЛАЛ" at a glance; the second line is "ЭТО") = "You did it";
  * blue phase: **"ТЫ СПАС МИР"** and a second line **"НО НАДОЛГО"** ("but for a long time"/"but not for long" - ambiguous, probably "Ты спас мир. Но надолго?" as a sequel hook; the second line is half cut by the bottom of the screen in every frame, so the real text may be longer: INFERRED);
  * green phase: no text.
  No other text appears in the first 900 frames (30 shots every 30 frames).  So there is **no scrolling text and no mirrored text in the rendering**; the "mirrored" impression comes from the data: the letters are not stored as characters (searching the file for the words in cp866/cp1251/koi8-r, reversed, or as constant-difference sequences found nothing) but in the graphics, drawn by the code with a big font.  The text is therefore not editable as a string without re-drawing the bitmaps (section 10: hard).
* Trigger: unknown.  The demo's own trigger compared `PLACE` with a destination word at #98B0 (ANALYSIS 13.4: "destination reached"), so the intended ending is probably "you reached a certain star" = a quest goal; `LaunchEnding` (test build only) starts it.  With the `Paradox` command `#` = "конец игры" a script could also end the game (INFERRED, the interpreter code has not been checked for `#`).
* Flight game over: the text `_GAMEOVER` "Корабль уничтожен. Конец игры." exists, but every call is commented out (section 6): the player cannot die.

### 7.6 Other story-like material
* Title picture/closing picture of the intro: "Awaken - Second Breeze" (docs/ANALYSIS.md 13.5) = "Awaken" is itself a **sequel** (Second Breeze) of another project/demo?  (INFERRED.)
* `archive/opensourcezx.diz`: only the file_id of the *Open Source ZX-Spectrum Web Project* (www.opensourcezx.untergrund.net, mailto bugsy) where the sources were published; no game information.
* Versions: Demo v0.1 / v0.2 on `reference/` (docs/VERSIONS.md); the 1999 sources (Paradox 13.11.99) are the newest.

## 8. Unused and unusual

(pending)

## 9. Gap list for a full game

(pending)

## 10. Asset inventory

(pending)
