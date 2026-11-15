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

Three separate things share the word "ship": (a) the **purchasable ships/skimmers** (stat tables + descriptions in the station, section 2.1), (b) the **3D models shown in the station viewer** (`OBJX.asm`, section 2.2), (c) the **flight objects** (`OBJECTS*.asm`, section 2.3).  They are **not linked by data**: the viewer models, the flight models and the shop ships were drawn independently.  Line numbers: `work/tech/u8/src_*`.

### 2.1 Shop ships and skimmers (7 + 4)
Stat record `CNKR` (DATA_M.asm:691): per ship 5 bytes = tonnage (capacity, t), price (word), speed, legal flag (1 = legal, 0 = illegal and not sold); `CNSK` (DATA_M.asm:716) per skimmer: tonnage 0, price (word), speed, weight (t).  Descriptions in `ship.tok`/`skim.tok`, price list in the buy windows `NAMSH`/`NAMSK` (DATA3D.asm:287-305).  VERIFIED.
| # | ship | CNKR capacity / price / speed | text says (ship.tok) | price in list |
|--|--|--|--|--|
| 0 | Доминион | 100 / 64000 / 130 | speed 130, tonnage 100, weight 28 | 64000 |
| 1 | Софист | 90 / 44000 / 120 | 110 / 120 / 29 | 44000 |
| 2 | Мемфис | 60 / 40000 / 140 | 140 / 60 / 20 | 40000 |
| 3 | Фирс | 70 / 35000 / 110 | 110 / 75 / 25 | 35000 |
| 4 | Орсан | 72 / 34000 / 90 | 90 / 90 / 32 | 34000 |
| 5 | Барос | 80 / 27000 / 100 | 100 / 110 / 30 | 27000 |
| 6 | Карэн | 50 / 12000 / 70, **illegal** | 60 / 50 / 33 | **13000** |
| s0 | Фервест | - / 30000 / 170, weight 5 | 170 / 5 | 30000 |
| s1 | Кридон ("Кридан" in the list) | 27000 / 150 / 4 | 150 / 4 | 27000 |
| s2 | Протос | 24000 / 130 / 3 | 130 / 3 | 24000 |
| s3 | Алгол | 18000 / 100 / 2 | 100 / 2 | 18000 |
**Inconsistencies to decide when finishing** (data is duplicated in three places): capacities and speeds in `CNKR` differ from the description texts for ships 1, 3, 4, 5 (tonnage 90/70/72/80 vs 120/75/90/110) and 6 (speed 70 vs 60); "Карэн" costs 12000 in `CNKR` but 13000 in the list; "Кридон" vs "Кридан".  The game logic uses `CNKR`/`CNSK`.  VERIFIED.
Class hints from the texts: Доминион = top aristocracy, Софист = aristocracy, Мемфис = fast mid-class, Фирс = representative mid-class, Орсан = old low-class ship, Барос = best trading ship (110 t), Карэн = relic of the "past era", fits little equipment.  Skimmer = surface vehicle with "прыжковый движок" (jumping engine), "ходовой модуль" (wheels), "стыковочный узел" (docking unit); skimmers do **not** exist in flight (only a control list for them in the settings, `TSETG1`).

### 2.2 Station 3D viewer (window "Корабль"/"Скиммер", "3D обзор", `BODY3D.asm`, `DATA3D.asm`, `OBJX.asm`)
* The viewer (rotating wire/solid model with a clipper `CLPXR1`, projection `XR2`) takes the model address from the table at `L97` (DATA3D.asm:326-345): 11 entries (each `dw model,model`): 0 Pushkad, 1 Klopd, 2 Kryld, 3 Treugd, 4 Kobrad, 5 Wognd, 6 Pushkad (again: the relic Карэн uses the first model), 7 Istr, 8 Sturm, 9 Turi, 10 Trad.  Ships 0..6 use entries 0..6, skimmers 0..3 use entries 7..10 (index +28/4 in `ISHIP`, BODY3D.asm:200ff).  The names are only the **labels** (Russian transliteration: Пушка, Клоп, Крыло, Треугольник, Кобра, Вогнутый, Ист(ребитель?), Штурм, Тур(...), Тряд) - no name strings in the data.  Texts shown next to the model come from `TISHIP`/`TISKIM` (item = ship number).  VERIFIED.
* `OBJX.asm` (10856 bytes, 333 lines of `db`) contains the 10 distinct models.

### 2.3 Flight objects (OBJECTS.asm 5763 B of model bytes, OBJECTS2.asm 1063 B "old models", OBJECTSS.asm 3754 B stations)
**Model record** (from `REMOVEOBJ`, flight BODY.asm:380-410, and `RENOBJ`, 3D-II.asm:635; the record is copied to `OBJBUF`): 2-byte header (`#6D,#02` = size/radius, scale shift), then **vertices** as 4-byte entries `colour/amount, x, y, z` (signed bytes) ending with a `#00` byte, a `#00` separator, then **faces**: each begins with a byte whose low nibble `n` = number of vertex indices following (copied `n+1` bytes) and whose high nibble = colour/type (`#43` = triangle, `#44`/`#24` = quad, `#16` = 6-gon); vertex indices are multiples of 5 (offsets into the vertex array); a `#00` ends the model.  Sub-blocks `P00xxx`, `P01xxx` (labels in the files) are extra part lists (e.g. stations' turret/door parts, animated parts).  The in-game form uses far (`KNnn`, low-detail) and near (`Kdnn`, detailed) versions of every ship; `3DTABS.asm:470-700` is the **object index table** `L97` (`dw far, near` per index; index byte = `low($)`).  INFERRED from the code that reads it (no format document in the sources).
All objects (flight index names, 3DTABS.asm:470-700):
| group (AI type) | indices | models | notes |
|--|--|--|--|
| police in space (`T_POLICE`) | IPOL1..4 | KN01pol1/Kd1, KN06pol2/Kd6, KN29pol6/Kd29, KN27pol7/Kd27 | names "pol1,2,6,7" mean the original numbering had 7 police models |
| police launched from stations | IPLS1..3 | KN21plS3/Kd21, KN25plS4/Kd25, KN28plS5/Kd28 | |
| military (`T_MILITARY`) | IMLT1..4 | mlt1 Kd2, mlt2 Kd9, mlt3 Kd17, mlt4 Kd26 | |
| cargo ships | IGRZ1..5 | grz1 Kd3, grz2 Kd8, grz3 Kd11, grz4 Kd30, grz5 Kd31 | traders and pirates also use them |
| "trade, sold at the station" (pirates/traders/hunters) | ITRG1..6 | trg1 Kd4, trg2 Kd5, trg3 Kd10, trg4 Kd16, KOBRA/KOBRAD, KRYL/KRYLD (OBJECTS2 "СТАРЫЕ МОДЕЛИ КОРАБЛЕЙ") | six = the six sellable ship classes |
| UFO (`T_UFO`) | IUFO1..8 | ufo2 Kd13, ufo3 Kd14, ufo4 Kd18, ufo5 Kd20, ufo6 Kd23, ufo7 Kd24, UFO1/UFO1D, Kd12 | aliens |
| cruisers | IKRS1..4 | KN07krs1/Kd7, Kd15, Kd19, Kd22 | |
| micro ships (launched from others) | IMIK1..2 | micKN, micKd1, micKd2 | `T_MIKR` |
| rocket | IROK, IROKUFO | ROKET (15 B), UfoRD | 2 rocket types (`SETUP` bit 3 = РКН1/РКН2) |
| cargo containers | ICRG, ICRGUFO | CRG1, KontUFO | |
| cyber killers | IKIB, IKIBUFO | Kib_K, ufo_K | the "Кибер Флот" |
| repair droid | IREMDR | REM_DR | the "Ремонтный Дроид" equipment |
| asteroids | IASTER1..3 | ASTER1 (120 B), ASTER2, ASTER3 | |
| debris / target / trash | IOSKOL, ITARGET, ITRASH | OSKOL, TARGET (invisible target), TRASH (afterburner dust) | |
| stations | IST1..IST16 + IST_PIRAT, IPRISON, IST_U1, IST_U2, IST_SCINCE, IGIP_PL | St1..St16 (one per planet level), St_pirat (pirate base), Prison, St_u1/St_u2 (UFO bases?), St_scince (science station), Gip_pl (hyper gate / "гипер планета"?) | stations are made of parts (`T_STATION`, docking block flag `SETUP` bit 4); 16 + 6 = 22 models |
**Only the 16 level stations are generated today**: `STATTB` (OBJGENER.asm:25) lists `ST1k..ST16k`; `IST_PIRAT, IPRISON, IST_U1, IST_U2, IST_SCINCE, IGIP_PL` are in the index table but referenced by no code (grep: no hit outside 3DTABS.asm).  Other index names **never referenced by name** outside the table: `IKIB`/`IKIBUFO` (cyber killers), `IREMDR` (repair droid), `IASTER3`, `ITARGET`, `IUFO8`, `IROKUFO`, `ICRGUFO` (the player's "Ремонтный Дроид" release `DROPDROID` is `ret`, SETCONTR.asm:290; the key list has "Выпуск флота" with no handler: INFERRED).  So the *models and equipment for droid, cyber fleet and some UFO variants exist but the behaviour is missing*.  VERIFIED by grep.
The player's own ship is **not a 3D object** (cockpit view); the viewer models of section 2.2 appear nowhere in flight.

### 2.4 Per-object runtime record (flight, `OLEN` = #40 = 64 bytes each at `CARSB` = #A200, 25 objects; fields EQUS.asm:300-430)
`INDI` model index, x/y/z (3 words), angles `ALFA/BETA/GAMA`, `MODE` current AI mode (`C_*`, section 6), `SUBJ` current target (`SPLAYER` = 26 = the player), `ACTN` flags (attacks you / rocket attacks / rocket killed you), `RAND` id, `MSPD` max speed, `RSPD` speed, `LZS` laser/weapon bit mask, `TYPE` (`T_PIRAT`..`T_TARGET`), `ENERGY`, `RCO` rocket counter, `OSUBJ`, `OMODE` fallback mode, `POWOR`, `SETUP` bits (cargo count, own fleet released, rocket type, container "NIMA"/ station docking), `PMODE` previous mode, `PX/PY/PZ` target coordinates, `BSUBJ/TSUBJ` return subject/type, `MENE` max energy, `TOWR` cargo type, `FORSAG` afterburner byte, `SPT` turn angle, `PLAN` planet number.  Only **25 objects** can exist at once (the buffer CARSB), including stations' parts and projectiles.  VERIFIED (EQUS.asm).

## 3. Goods, equipment, economy

Line numbers: `work/tech/u8/src_station_*.asm`.  The economy is **table driven and fully working in the station** (buy/sell goods, ships, skimmers, equipment; prices vary per system and time); nothing in flight changes money except picking up cargo.  The rules are in the script `C_SCENAR.t` (section 1.2) and the tables in `DATA_M.asm`.

### 3.1 Goods (30 kinds; `TTWR2` names, `CENS2` base price/ban, `SPECTO`, `TWRM`; DATA_M.asm:250-366)
Columns: base ("average") price in credits per unit; "ban" = how often the good is illegal (`0` never, `1` rarely, `2` often, `3` always banned in democracies, comment at DATA_M.asm:327-332); "cheap where" = system economy type (`TYPE`: 0 агрокультурная, 1 культурная, 2 технологическая, 3 общая) in which the good is 8 credits cheaper; weight class (`TWRM`: 0 = tonnes, 1 = persons, 1/16 t each, 2 = negligible weight (kg/g)).

| # | good | unit | avg price | ban | cheap where (0 agro,1 cult,2 tech,3 gen) | weight class |
|--|--|--|--|--|--|--|
| 0 | Текстиль | тн | 19 | 1 | 3 | 0 |
| 1 | С/Х Продукты | тн | 20 | 1 | 0 | 0 |
| 2 | С/Х Техника | тн | 90 | 1 | 0 | 0 |
| 3 | Стройматериалы | тн | 21 | 1 | 2 | 0 |
| 4 | Стройтехника | тн | 95 | 1 | 2 | 0 |
| 5 | Вода | тн | 17 | 1 | 0 | 0 |
| 6 | Спиртное | тн | 27 | 2 | 1 | 0 |
| 7 | Пиво | тн | 28 | 2 | 1 | 0 |
| 8 | Табак | тн | 18 | 2 | 0 | 0 |
| 9 | Медикаменты | тн | 30 | 0 | 2 | 0 |
| 10 | Оборудование | тн | 60 | 1 | 2 | 0 |
| 11 | Электроника | тн | 65 | 1 | 2 | 0 |
| 12 | Компьютеры | тн | 70 | 1 | 2 | 0 |
| 13 | Энергоносители | тн | 80 | 1 | 2 | 0 |
| 14 | Минералы | тн | 55 | 1 | 3 | 0 |
| 15 | Радиактивные Руды | тн | 72 | 2 | 2 | 0 |
| 16 | Черные Металлы | тн | 67 | 1 | 3 | 0 |
| 17 | Цветные Металлы | тн | 80 | 1 | 3 | 0 |
| 18 | Драгоценные Металлы | кг | 100 | 1 | 1 | 2 |
| 19 | Драгоценные Камни | г | 120 | 1 | 1 | 2 |
| 20 | Предметы Роскоши | кг | 110 | 2 | 1 | 2 |
| 21 | Легкое Вооружение | тн | 80 | 1 | 3 | 0 |
| 22 | Тяжелое Вооружение | тн | 125 | 2 | 2 | 0 |
| 23 | Наркотики | кг | 140 | 3 | 1 | 2 |
| 24 | Рабы | чл | 130 | 3 | 1 | 1 |
| 25 | Проститутки | чл | 120 | 3 | 1 | 1 |
| 26 | Трансплантанты | кг | 170 | 3 | 2 | 2 |
| 27 | Уникумы | чл | 230 | 3 | 1 | 1 |
| 28 | Технологии | эк | 240 | 0 | 0 | 2 |
| 29 | Артефакты | тн | 250 | 0 | 0 | 0 |

Unit codes come from the name table: тн = tonne, кг, г, чл = persons, эк = "equivalents" (technologies).  Player record: `TWRI` (30 x [amount, purchase price]); station table `TWRS` (30 x [amount, price], bit 7 of the amount = banned here), regenerated by `RANDTT` (DOPPROC.asm:1358) every time you arrive (`Dalee`): seeded by system coordinates, planet and **hour/4** (`TIME+2 & #FC`), so the offers drift every 4 game hours; price = base + random(-7..+7), -8 in the specialised economy type; quantity from a second random byte (many goods are absent on purpose, "для того что б было больше пустых строчек"); the last three goods (technologies, artefacts, "уникумы") are skipped by the generator loop (`TKOL-3`) and get fixed values.  The ban flag depends on the planet government (`PSTROY`: democracy strictest).  The price also falls with the quantity on the station.  VERIFIED (code), arithmetic details INFERRED.
Rules (script X=9/10/11): buy = 1 unit per click, needs credits (`M01`), free capacity (`M03` "Превышение тоннажа"), max **120** of one good (`g]120`: `M06`); sell = if the good is banned here (`G.s=n`): `M10` "Сделка незаконна! Вы облагаетесь штрафом в 1000 кредитов!" - the stack is confiscated and 1000 cr fine; a sale must not push credits above **65000** (`M11` "Превышение максимальной разрешенной суммы!") - credits are 16-bit, **65000 is the economy cap**; "sell all" (X=11) = same for the whole stack.  Starting purse: 25000 credits, capacity 50 t (`TONN` = 0,50).

### 3.2 Ship equipment (33 items; names `TWKRB2`, prices `CENS`, level/mass `TONNS`, families `WKII`, incompatibilities `KRBARM`)
Columns: shop name, "old name" (comment names of the older generation in DATA_M.asm:165-197), price in credits, "from level" = lowest planet level whose station sells it (`TONNS` first byte), mass in tonnes (second byte; counts against capacity), "same-family steps" `WKII` (signed up/down count to neighbouring items of the same family: only one laser / shield / droid ... may be installed, else `Подобный тип оснащения уже имеется!`), and the ship numbers (0-based, 6 = Карэн) on which the item *cannot* be installed (`KRBARM`, 4 slots per item; the best ship, number 0, never appears, the relic 6 appears everywhere: consistent with the Карэн text).
| # | shop name | old comment name | price | from level | mass t | same-family steps (up,down) | not installable on ship # (0-based) |
|--|--|--|--|--|--|--|--|
| 1 | Топливо МРП | Топл. 'Космонефть' | 4 | 1 | 1 | #00,#01 |  |
| 2 | Топливо ЛНП | Топл. 'Рубин' | 10 | 1 | 1 | #FF,#00 | 6 |
| 3 | Ракета рп1 | Ракт РЛН-1 | 15 | 1 | 2 | #00,#01 |  |
| 4 | Ракета рп2 | Ракт РЛН-2 | 30 | 3 | 1 | #FF,#00 | 6 |
| 5 | Мина | Мина МХ-1 | 20 | 1 | 1 | #00,#00 |  |
| 6 | Лазер 'Ксоникс' | Лаз. 'Град' | 900 | 3 | 3 | #00,#04 |  |
| 7 | Лазер 'Корпс' | Лаз. 'Штурм-1' | 2300 | 5 | 4 | #FF,#03 | 6 |
| 8 | Лазер 'Динейел' | Лаз. 'Штурм-2' | 5300 | 10 | 3 | #FE,#02 | 5/6 |
| 9 | Лазер 'Милениал' | Лаз. 'Смерть-1' | 14000 | 12 | 2 | #FD,#01 | 5/4/6 |
| 10 | Лазер 'Эпик' | Лаз. 'Смерть-2' | 25000 | 16 | 2 | #FC,#00 | 5/4/3/6 |
| 11 | Противоракетная Система | Проракт.С. ПС-1 | 300 | 3 | 1 | #00,#01 |  |
| 12 | Противоракетная Система п2 | Проракт.С. ПС-2 | 1500 | 7 | 1 | #FF,#00 | 6 |
| 13 | Система Защиты 'Дифёрт' | С.Защ 'Крепость' | 1500 | 2 | 2 | #00,#02 | 6 |
| 14 | Система Защиты 'Сёрфейс' | С.Защ 'Оборона-1' | 9500 | 10 | 2 | #FF,#01 | 5/6 |
| 15 | Система Защиты 'Сейсмис' | С.Защ 'Оборона-2' | 22000 | 15 | 1 | #FE,#00 | 5/4/3/6 |
| 16 | Форсаж Движок 'Риал' | Форс Движ 'Фотон' | 800 | 4 | 4 | #00,#01 |  |
| 17 | Форсаж Движок 'Вист' | Форс Движ 'Протон' | 6900 | 8 | 3 | #FF,#00 | 5/6 |
| 18 | Ремонтный Дроид 'Ситизан' | Ремонтный Дроид РД-1 | 1900 | 7 | 1 | #00,#02 | 6 |
| 19 | Ремонтный Дроид 'Ситрэн' | Ремонтный Дроид РД-2 | 5200 | 12 | 2 | #FF,#01 | 5/6/4 |
| 20 | Ремонтный Дроид 'Эйлиас' | Ремонтный Дроид РД-3 | 15000 | 14 | 3 | #FE,#00 | 5/4/3/6 |
| 21 | Силовой Луч | С 'Силовой луч' | 300 | 4 | 1 | #00,#00 |  |
| 22 | Система Наведения | С наведения | 900 | 5 | 1 | #00,#00 |  |
| 23 | Система 'Гиперслед' | С 'Гиперслед' | 19300 | 12 | 1 | #00,#00 | 5/4/6 |
| 24 | Система Возврата | С Возврата | 600 | 9 | 2 | #00,#00 | 2/5/6 |
| 25 | Система Свободного Полета | С Свободного Полета | 300 | 6 | 1 | #00,#00 | 5/6 |
| 26 | Система Забора Топлива | С Заправки | 700 | 8 | 1 | #00,#00 |  |
| 27 | Система Распознавания | С Распознавания | 7300 | 10 | 1 | #00,#00 | 6 |
| 28 | Идентификатор Целей | Идент Целей | 1800 | 10 | 1 | #00,#00 | 6 |
| 29 | Маршрутизатор | МАРШРУТИЗАТОР | 2300 | 5 | 1 | #00,#00 | 6 |
| 30 | Криогенный Модуль | Криоген Устан | 380 | 6 | 2 | #00,#00 | 2/6 |
| 31 | Посадочный Модуль | Посадоч Модуль | 23700 | 13 | 3 | #00,#00 | 5/3/1/6 |
| 32 | Кибер Флот | Кибер Киллер ККР-0562 | 15100 | 16 | 4 | #00,#00 | 5/3/2/6 |
| 33 | Гипер Система 'Фостэр'<ET> | Гипер С 'Дьявол' | 21800 | 16 | 5 | #00,#00 | 6 |

Rules (X=5/6): buy needs a ship (`M05`), the item must be sold at this station level (`M08`), installable on the current ship (`O.s`, `M07`), no member of the same family installed (`o.n`, `M13`), count below the maximum `O.k` (`M06`), money (`M01`), tonnage (`M03`); sell returns the full catalogue price (no depreciation).  Counts are bytes in `WKRBI` (0..100 for fuel/rockets/mines; `#FF` = not installed, `#FE` = installed for yes/no items; `#80` ends the table).  `TARMI` (DATAT.asm:82) holds the encyclopaedia text of every item.

### 3.3 Skimmer equipment (14 items; `TWSKM1`, `CENS1`, `TONSS`, `WSII`, `SKMARM`)
| # | shop name | old comment name | price | from level | mass t | same-family steps (up,down) | not installable on skimmer # (0-based) |
|--|--|--|--|--|--|--|--|
| 1 | Топливо СМРП | Топл 'Бензол' | 7 | 1 | 1 | #00,#00 |  |
| 2 | Ракета срп1 | Ракет СРК-1 | 15 | 1 | 2 | #00,#01 |  |
| 3 | Ракета срп2 | Ракет СРК-2 | 30 | 3 | 1 | #FF,#00 | 2/3 |
| 4 | Лазер 'Бейл' | Лаз 'Силовой' | 400 | 4 | 1 | #00,#02 |  |
| 5 | Лазер 'Эксиал' | Лаз 'Ураган-1' | 1100 | 10 | 2 | #FF,#01 | 3 |
| 6 | Лазер 'Фэйк' | Лаз 'Ураган-2' | 2300 | 13 | 1 | #FE,#00 | 1/2/3 |
| 7 | Система Защиты 'Дьюорф' | С Защ 'Броня-1' | 500 | 6 | 3 | #00,#01 |  |
| 8 | Система Защиты 'Интенд' | С Защ 'Броня-2' | 1700 | 9 | 2 | #FF,#00 | 1/2/3 |
| 9 | Прыжковый Движок 'Плизант' | Прыжк. Движок 'Даль-1' | 600 | 6 | 3 | #00,#01 | 3 |
| 10 | Прыжковый Движок 'Сэйкрид' | Прыжк. Движок 'Даль-2' | 1500 | 12 | 2 | #FF,#00 | 3/2 |
| 11 | Противоракетная Система | Протракет Сист | 300 | 7 | 1 | #00,#00 |  |
| 12 | Стыковочный Узел | Стыковочный Узел | 600 | 8 | 1 | #00,#00 | 1 |
| 13 | Ходовой Модуль | Ходовой Модуль | 600 | 9 | 2 | #00,#00 | 3 |
| 14 | Бомба<ET> | Бомба БР-0910 | 1000 | 12 | 7 | #00,#00 | 2/3 |


Same rules with the `I/i` operands (X=7/8); a ship is needed first (`255-k@M05`).  A skimmer has no tonnage of its own: its weight `R.v` is added to the ship's load.

### 3.4 Ships and skimmers: price, tonnage, legal status
Stats in section 2.1.  Script X=1..4: **buy ship** (X=1) is refused if you already own a ship (`k<255 = y` -> `M02` "В наличии уже имеется!"), so you must sell first; needs credits (`M01`), new tonnage not smaller than the current load (`K.t<j`: `M03`), installed equipment still installable (`o.s`: `M07`); then the ship is bought, money paid, capacity `J` = new tonnage.  **Sell ship** (X=2) is refused with `M04` "Ваш корабль находится в розыске!" if the ship's legal flag is 0 (`k.s = n`).  **The starting ship Карэн is illegal, so as written it cannot be sold, and since buying needs "no ship", the player is locked to Карэн** (INFERRED from reading the script).  This start (ship 6, status 67, 25000 cr) is only the **test default of `DATA_M.asm`**: the flight image carries the real *new-game record* `NDATA` (SETHJRET.asm:221, used by the commented-out `RETSTT` "return to station with all data reset"): day #0122, 10:10, place #4B38/#4AF3, **no ship, no skimmer (#FF), status 0 (Чистый), 40000 credits**, empty cargo and equipment.  With that record the player has to buy a ship first, so the lock does not arise; see section 7.2 and 8.  **Skimmer** (X=3/4): one at a time, needs a ship and free tonnage.  Offers per planet level: `SHIPDAT` (DATA_M.asm:221; per level 1..16 the number of best ships / skimmers to *skip*: level 1 skips 5 ships and 3 skimmers, levels 15-16 skip nothing): low-level stations sell only the cheapest ship (Барос, 27000) and skimmer (Алгол); Карэн is never for sale.

### 3.5 Legal status, fines, fees
* `STATUS` byte (DATA_M.asm:790, start **67**): class = `STATUS >> 5`, shown in the status line (OBR2.asm:1081): 0 **Чистый** (0..31), 1 **Подозреваемый** (32..63), 2 **Розыскиваемый** (64..95), 3 **Приговоренный** (96..127); capped at 127.  In flight `CHSTATUS` (SLOWPRO.asm:557) raises it when the player is the aggressor: by a per-object-type value (table `STABL`) and by fixed +8 / +32 in the police-start code (BRAINPRO.asm:829, 1165); the table was not decoded (INFERRED).  Police behaviour reads it: status >= 64 ("РОЗЫСКИВАЕМЫЙ", SLOWPRO.asm:890) makes police attack you; status >= 80 ("ВЫШЕ ПРЕДЕЛА", SLOWPRO.asm:~890) makes the station launch police.  Nothing lowers it in flight, only the station start check below (-48) lowers it.
* Start check, run at **every arrival** (script X=15, `Dalee` BODY.asm:30-45): status < 48: nothing; 48..63: `M16` "Галактическая полиция предупреждает Вас ... неблагоприятный гражданин ... оштрафованы на 50 кредитов" and -50 cr; >= 64: `M15` "Вы находитесь в розыске! Все тяжёлое вооружение ... демонтировано ... оштрафованы на 1000 кредитов", -1000 cr, status -= 48, lasers 1..5 (`o6..o10`), rockets (`o3`, `o4`) and the cyber fleet (`o32`) removed (mines and the rest stay).  VERIFIED.
* Parking fee: level x 5 credits (`WELCOME` text shows it), script X=16 (run when `PLATA` is set): if you cannot pay (credits <= level x 1, `c-L.u=0`), `M14` "За неоплату стоянки, Вы выдворяетесь в открытый космос!", credits = 0 and `W` (`_WYDWOR`); otherwise credits -= level x 5.  The station-side expulsion `WYDWOR` (BODY.asm:44-52) is an empty branch: no real launch happens (INFERRED).  In tests the fee at a level-14 station was 70 cr (docs/ANALYSIS.md 13.1).
* Illegal sale fine: 1000 cr (`M10`).

### 3.6 Fuel
Fuel = ship equipment slots 1-2 (МРП / ЛНП) in `WKRBI`/`FUEL`; the jump range on the map is `FUEL` (low byte / 2) light years.  "Система Забора Топлива" (scoop: fuel from the star surface) and skimmer fuel "СМРП" exist.  Refuelling = buying fuel as equipment (4 and 10 credits per unit).

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

The flight part is an Elite-like 3D space flight with a surprisingly rich AI.  It is a **sandbox**: you can fly, fight, collect cargo, jump between stars and dock, but the player **cannot die** and no mission is checked.  Line numbers: `work/tech/u8/src_flight_*.asm`.

### 6.1 Main loop and what the player can do (BODY.asm:40-200, keys table SETCONTR.asm:255-285)
Per frame (`CYCL`): `GENSHIPS` (spawning), stars, clock `TIMER`, 3D render (`REN3D`), shield/laser recharge, `SHIPINTELEGENT` (AI of every object), `MVSTT` (station move), `MVSUN` (sun/planet move), voxel animations `EXPL`, `MOVEU`, laser hit test `SHUT`, then result flags (`ACTION`: bit 0 laser hit on you, bit 1 rocket launched at you, bit 2 rocket hit you).  Player actions (28 labelled controls in `TSETG1`; handlers `SETCONTR.asm`): pitch/yaw/roll, laser, throttle up / brake, on-board computer, rocket lock-on (`NAVOD`) / forget lock, fire rockets 1-3, **afterburner** (`JUMPDRIVE` "Форсаж"; leaves `TRASH` objects), "free flight" system, "targeting" light, "return" system, **power ray** `ZAHWAT` (tractor: toggles `FLINE2`, picks up containers), anti-missile system, drop container (`DROPCR`), drop mine, **hyperjump** (`HIPER`, section 5.4), release droid (`DROPDROID`: **`ret` only**), front/rear view.  Messages shown on the panel are listed in section 10 (26 strings in COMPUTE.asm:573-667).  VERIFIED.

### 6.2 Object types and AI modes
* Types (`TYPE`, EQUS.asm:331-347): `T_PIRAT` 0 pirate, `T_TRADER` 1 trader, `T_MILITARY` 2 military, `T_POLICE` 3 police, `T_LEGIONER` 4 hunter/"legionnaire" (bounty hunter), `T_PIRAT2` 5 harmless pirate, `T_UFO` 6, `T_UFO2` 7 hostile UFO, `T_HERMIT` 8 hermit (lives at an asteroid), `T_MIKR` 9 micro-ship, `T_CHIP` #10 debris, `T_ROKET` #11 rocket, `T_STATION` #12 station part, `T_CARGO` #13 cargo container, `T_TRASH` #14 afterburner trash, `T_TARGET` #16 invisible target.
* Modes (`MODE`, EQUS.asm:264-306; dispatch table `ITAB`, BRAINPRO.asm): 0 STAY, 1 GOPLANET, 2 FIGHT (attack), 3 GOSTAR, 4 FLYFREE, 5 DEFENCE, 6 JUMPOUT (end of hyperjump), 7 JUMPING (start of hyperjump), 8 NAVODROKET (guided rocket), 9 STAYSTAT (station idle), 10 DEFENCESTAT, 11 STARTPOLICE (police leaving the station), 12 BACKPOLICE, 13 BACKTOASTER, 14 GETCARGO, 15 GOAWAY, 16 FLYAWAY (flee when attacked), 17 TURNOUT, 18 GOASTER (asteroid drift), 19 FORSAGE, 20 FLYAROUND (evade at collision), 21 RETURN.  Each AI procedure is named after its role: `TRADE`, `POLIC`, `HUNTE`, `UFO__`/`UUFO_`, `ARMY_`, `OTSHE`, `UPIRA`, `TOPEACE`, `STYSTAT` (SLOWPRO.asm index lines 1-20).  VERIFIED (names and comments).
* Behaviour summary (from the comments and procedures): police patrol, **attack the player when STATUS >= 64** (`POLIC2` SLOWPRO.asm:880-897: compares status with `l` of a random value), launch from the station when status >= 80 (`STYSTAT`, "ВЫЛЕТ ПОЛИЦИИ", count 2..3) and return (`BACKPOLICE`); every attack by the player on an object makes `CHSTATUS` raise the status; pirates (`T_PIRAT`) hunt traders and the player; traders carry cargo and flee; hunters (`T_LEGIONER`) attack outlaws; military fight pirates/UFO; UFOs are hostile aliens with their own rockets/containers; **hermits** sit near asteroids (`TOTSHEL` table uses `IASTER1/2` + `C_BACKTOASTER`); ships that are shot drop containers (`NEWCARGO`) with a goods type (`TOWR`); rockets guide on a locked target (`NAVODROKET`); a ship can release its own fleet (`SETUP` bit 2) and "micro ships".  INFERRED from names/tables, individual procedures not traced one by one.

### 6.3 Spawning and system dependence
* `GENSHIPS` (OBJGENER.asm:563) rolls a random byte each frame against `GNUM` (spawn-rate threshold; `NWSUN` sets it to #FF at arrival, so spawning is held back after a jump: INFERRED); a free slot of the 25-object buffer `CARSB` is required (`FINDFREE`).  The type is picked from the **cumulative probability table `VERTAB`** (SETHJRET.asm:724-820) by the government of the current planet; the table is the cutoff threshold per type, in the order Пираты, Мирные (trader), Полиция, Военные, Легионеры, Пират2, УФО, УФО2, Отшельник, each system type has its own row:
| government | pirates | traders | police | military | hunters | pirate2 | UFO | UFO2 | hermit | max |
|--|--|--|--|--|--|--|--|--|--|--|
| Демократия | <4 | <40 | <70 | <80 | <90 | <94 | <95 | <96 | <100 | 100 |
| Диктатура | <10 | <40 | <70 | <100 | <110 | <112 | <113 | <116 | <121 | 121 |
| Анархия | <20 | <24 | <27 | <36 | <47 | <60 | <62 | <68 | <72 | 72 |
| Необитаемая | <1 | <2 | <3 | <10 | <12 | <16 | <28 | <40 | <60 | 60 |
| Неизвестная | <1 | <2 | <3 | <4 | <5 | <6 | <7 | <8 | <9 | 9 |
  (a random byte 0..127 is compared; above the last threshold nothing spawns.)  So democracies are busy and mostly peaceful (traders and police), dictatorships have many military, anarchies are pirate-heavy and empty, **uninhabited/unknown systems are almost empty but UFOs and hermits dominate** (aliens).  The thresholds are adjusted at run time by `SETT` with `STROYTAB` (offsets per government) and `LEVLTAB` (level multipliers) into `PLANDICTAT` (15 bytes).  (An older fixed copy of the thresholds is in the code at OBJGENER.asm:600-640: `#0A`, `#43`, `#50`, `#5A`, `#5E`, `#63`, `#6B`, `#70`.)  VERIFIED (tables), the probability reading INFERRED.
* Ship model choice per type (`INDTABK`, OBJGENER.asm:465-560): 8 weighted rows per type (model index, value 60..150: INFERRED energy/speed): pirate = trg1..trg6, grz1/2; trader = trg1, trg5, trg6, grz1..5; military = mlt1..4; police = pol1..4; hunter = trg1..6; UFO = ufo1..7; hermit = asteroids; cruisers `KREYSERS` = krs1..4 with low probability (10..1).
* Raids (`FORRAID`, `TYPERAID`): groups of pirates are spawned at once (`DOPGEN`).
* **The sun and planets** (`MVSUN`, `NWSUN`, `BLACKSUN`, `SUNB`, SLOWPRO.asm:1052-1380): a star (`MODELSTAR`) and up to 6 planets (`PLANETES`, `MODELPLANET`, count from `PINFO`) are rendered as sprites/voxels (`STARHSUN.asm`: starfield, hyperspace tunnel, sun disc `CIRCLE`); the player's distance to the sun (`FARSUN`) and to the planet (`FAREAR`, `VISPLAN`) feed the "height" and "temperature" gauges.  A **black hole** (`BLACKSUN`) appears at one specific random value (`RNDL9` == #8746) and drifts toward the player.  Hyperjump "arrival" puts the ship near the sun or near the "Дьявол"-system point (`SNZ` = #0200 close if the Devil/hyper system is installed, 17<<8 far: SETHJRET.asm:500-509).
* Asteroids: `IASTER1/2` (ASTER3 unused) form fields with hermits; the "power ray" can pick up mined cargo.  VERIFIED (code existence).

### 6.4 Cargo, mines, rockets
* Containers (`T_CARGO`, up to 10 held in `CARGS`, 3DTABS.asm:752) are picked up inside range by `ZAHWAT` (SETCONTR.asm:~700-785): capacity check against `TONN+1` (but not for "persons"/high-bit goods), max 200 of one kind (`cp 201`), the amount is added **directly into the state record `TWRI`** (so cargo picked in flight is real station cargo); a trap container (SETUP bit 4, "NIMA") explodes in the hold (`ACTION` bit 2).  Drop: `DROPCR` takes the first non-empty cargo slot.  Messages `_TAKING`, `_DROPCARGO`, `_NOCARGO`.
* Rockets: 3 launch keys, 2 rocket types (`RKN1/RKN2`, equipment "Ракета рп1/рп2"), guided via `NAVOD`/`NAVODROKET`, counters `ROKETN1..3`; anti-missile system (`UNROKET`) deflects.  Mines (`DROPMINE`, "Мина").
* Shield (`SHILD`): hit by laser -1, by rocket -40, by collision -40; recharges by itself (`PSRZI`, `PEREGREV` for laser heat).

### 6.5 What ends a flight
1. **Docking** (the only normal end): `CRASH` (3D-I.asm:711-744) -> `RETST` (SLOWPRO.asm:1800) -> `RETSTAT` (SETHJRET.asm:393) -> reload of STATIONF with the state record handed over (ANALYSIS 13.1): when the player enters the docking block of a `T_STATION` object the distance box is `|x|,|y|,|z| < 1024`; no speed or angle check, no docking computer.  The message `_DOCKING` ("Корабль в зоне стыковки со станцией. Уменьшить скорость.") exists but speed is not enforced.
2. **Death is disabled**: `GAMEOVER` (SLOWPRO.asm:77, text `_GAMEOVER` "Корабль уничтожен. Конец игры.") is reached by `jpc/jpnc GAMEOVER` at five places in the main loop (BODY.asm:78, 84, 95, 151, 185: shield < 0, **height >= 46** over a planet, **temperature >= 46** near the star) and every one of them is **commented out**.  The shield value is a byte and `sub 40` underflows without a check, so the player is effectively immortal (the shield bar wraps, INFERRED).  `GAMEOVER` itself ends with `EXIT` -> (glue) `LaunchStation`.
3. The original `EXIT` jumped back to the ZASM assembler (`RETASM.asm`), `RETSTT` (restart with reset data `NDATA`) is commented out (BODY.asm:353): the developers ran the flight from the assembler.
4. Test builds: `-DTEST_RETURN` (`LOADI2.asm:91`) returns at once.

### 6.6 Other flight systems
* HUD/panel (`PANEL.asm`, `SETCONTR.asm`, `COMPUTE.asm`): compass/radar (`COMPOS`, `RADAR`), messages with a scroll, number printing `PRINTNUM`, the clock; panel picture `PANEL.C` (Hrust-packed, see section 10).
* Voxel effects: hyperspace tunnel `HIPERJMP.v`, explosions `EXPLOSIO.v` (5120 B), voxel sprites `VOX.d`; they are `VOXAL`/`VOXAL0` banks.
* Sound: beeper effects `EFF.c` (`EFF0..EFF14`, called through `SFXA/SFXB`) in flight; the station plays a PT3 module (`MUZ1`), flight has no music (INFERRED).
* Not implemented in flight: skimmers (surface landing: "Система посадки на планету", "Посадочный Модуль"), the droid, the "fleet" release, mission checks, news triggers, trading in space.  STORM (`src/storm`, `LAND`) is the planned landing/surface engine (voxel landscape + skimmers + houses) and is **not connected** (section 8).

## 7. Story

**There is no written plot in the game: no intro text, no dialogues, no mission text.**  The story has to be assembled from small hints.  What is *certain* is the setting and the (one-sentence) ending; everything else is INFERRED.

### 7.1 Setting (all from texts)
* **Time**: the calendar is "новейшая эра" (current era, years 3..121 appear in the equipment history, e.g. "создано в 121 году новейшей эры") counted "по кореанскому летоисчислению" (ship.tok, skim.tok: "...по кореанскому летоисчислению" = by the **Korean** reckoning of years) with a much older "прошлая эра" (years 9800-9987 "прошлой эры": cold-store, landing module, hyper-flight service, antimatter scoop `TARMI` entries 24-31).  The game clock starts at day #0122 (=290), 10:10.
* **Space**: "три мира" (three worlds) - ship descriptions speak about "аристократия трех миров", "торговый флот трех миров", "низшие классы трех миров"; the map has three named states plus free lands (`TGOST`, DATAT.asm:755): **Федерация Галактики** (the "Галактическая Федерация"; the start region), **Конфедерация Первых**, **Содружество Миров**, and **Свободные Земли**.  Social classes: "высшая аристократия / аристократия / средний класс / низшие классы" (buyers of ships).  Governments of planets: демократия, диктатура, анархия, необитаемая.  Ranks of the police record: Чистый - Подозреваемый - Розыскиваемый - Приговоренный.
* **Currency/units**: "кредиты", "кредов", light years "сл", tonnes/kg/g/persons/"эк" (equivalents of technologies).  The goods list is a social picture: рабы, проститутки, наркотики, трансплантанты, уникумы (!), технологии, артефакты (30 goods, section 3).
* **Station life**: "Орбитальная станция, модель Гесмест ... рада приветствовать Вас! Сообщаем Вам, что почасовая оплата услуг орбитальной станции составляет N кредитов."  Documentation of equipment ("Документация оснащения", `TARMI`) reads like an in-world technical encyclopaedia.  Station help: "Галактическая инфосфера" (the info terminal of the station/ship: "Все управление системой осуществляется с помощью манипулятора и клавиатуры станционного или бортового терминала").
* **Ship names** (7): Доминион, Софист, Мемфис, Фирс, Орсан, Барос, Карэн; skimmers (4, "скимеры" = planet-surface hover craft): Фервест, Кридон, Протос, Алгол.  Station models (16): Гесмест, Аквадиз, Асфер, Квадокс, Рубирон, Иринекс, Сервест, Орегон, Глидер, Дистрой, Ретоер, Орфост, Фальварк, Мезатрон, Левиофан, Паралакс.  Equipment makers/trademarks: Ксоникс, Корпс, Динейел, Милениал, Эпик (lasers), Дифёрт, Сёрфейс, Сейсмис (shields), Риал, Вист (afterburners), Ситизан, Ситрэн, Эйлиас (repair droids), Фостэр (hyper system), Бейл, Эксиал, Фэйк (skimmer lasers), Дьюорф, Интенд (skimmer shields), Плизант, Сэйкрид (skimmer jump engines).

### 7.2 The start of the game (what the player experiences)
**Two different starts exist in the sources.**  (A) the *build default* in `DATA_M.asm` (what you see today): the story below.  (B) the *intended new game* `NDATA` in the flight image (SETHJRET.asm:221, 512-byte record; used only by the commented-out `RETSTT`): clean status 0, **no ship**, no skimmer, **40000 credits**, empty hold, at the same place (tile 75,56, planet 1): you start as a civilian with a purse and must go to the shipyard first.  (A) looks like the author's test setup for the police rules (wanted, relic ship).  Which one is the "real" start is the author's decision.  Details of (A):
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

Goal of the next phase: every text and every non-code asset becomes a human-editable file under `assets/` and a script converts it to the in-game form before the build.  Difficulty: **E** = easy (plain 1:1 conversion), **M** = medium (a small converter with a checksum test against the current binary), **H** = hard (needs a packer, or the layout references itself / the code).  "db-in-asm" = the data lives as `db`/`dw` lines in a source file, "incbin" = a binary file in `assets/`.  Sizes in bytes.  Line numbers are in `work/tech/u8/src_*` (same as `src/*`).  A round-trip test for every converter is easy to add: build, `md5` the assembled `.C` bank files (`build/station/*`, `build/flight/*`) and compare with the pre-conversion build.

### 10.1 Station texts (all db-in-asm; cp1251 source + `ENCODING "DOS"`; char set CP866 glyph codes; terminators ET `#0A`/CR `#0D`; control codes 1..6, `#FF` blank)
| # | where | what | size | in-game form | proposed editable form | diff |
|--|--|--|--|--|--|--|
| T1 | DATAT.asm:4 MODELS, 24 WELCOME, 34 ERORS, 405 THIDE ... (all labels, section 1.4) | all UI texts: station models, welcome, messages M01-M16, save/load lists, settings labels, window titles, button help, status, info headers, goods/equipment names, tables of states/types | about 12 KB of strings, 28 KB of source | ET-separated item lists, `<ET>`=#0A `<CR>`=#0D `<1>..<6>` tab/stop codes, `ds 31,255` blank lines | `assets/text/station_ui.txt` (one `[LABEL]` section, one item per line group, escapes `\n` for CR, `\t2` for tab codes) | E |
| T2 | DATAT.asm:82 TARMI | 47 encyclopaedia entries (33 ship + 14 skimmer equipment) | 5.5 KB | same | `assets/text/equipment_docs.txt` | E |
| T3 | DATAT.asm:373-396 NABONS/TABON1/TNEWS | 16 subscribers (name + home star tab), 2 news items | 0.5 KB | same | `assets/text/subscribers.csv` (name, star), `assets/text/news.txt` | E |
| T4 | HELP.asm:124 `help.tok` (incbin) + HELP.asm `THLPL` (db numbers) | manual (8 chapters) + chapter menu | 3646 + 90 | plain CP866 bytes, CR line break, ET end; THLPL as decimal CP866 numbers | `assets/text/help.txt` (UTF-8, chapters separated by a marker line) ; menu in the same file | E |
| T5 | station.asm:74/76 `ship.tok`, `skim.tok` (incbin) | 7 ship + 4 skimmer descriptions (speed/tonnage/weight embedded as text) | 1623 + 657 | plain CP866 | `assets/text/ships.txt`, ideally generated from `ships.csv` (section 10.2) so the numbers cannot disagree | E |
| T6 | DATA3D.asm:287-310 NAMSH/NAMSK/TSHIP | ship/skimmer buy list (name, price as *text*), header | ~300 | CP866 numbers + literal digits | generated from `ships.csv` | E (but prices are duplicated text) |
| T7 | CIRCMATH.asm:1472 NAMTAB | 16 Greek-letter name parts for star names | 90 | CP866 numbers, ET separated | `assets/text/star_names.txt` | E |
| T8 | PNT.asm:1512 SPECTB | key symbols ENT/SS/SP | 12 | ASCII | stay in asm | - |
| T9 | LANG.asm:2172 `C_SCENAR.t` (incbin) | trade-rules script, Paradox language | 1500 | ASCII commands + CP866 comments | `assets/text/rules.paradox` (UTF-8 comments; converter maps to CP866) - note the message numbers M01..M16 index `ERORS` | E |
| T10 | LANG.asm:2181 `TXTES` | converted scenario texts (dialogues) | **empty** | planned format in `LANGUAGE.C` (`_p1s1t1@ ... #`) | `assets/text/scenario.txt` + a converter (does not exist; the language manual defines it) | M (new tool) |
| T11 | flight COMPUTE.asm:573-667 | 26 panel messages (`_SYSTEMREADY` ... `_NOCARGO`), cp866 as decimal numbers + CR + ED | ~700 | numbers | `assets/text/flight_messages.txt` | E |
| T12 | `LANGUAGE.C`, `TREE.t` (awk6, not built) | language manual; dialogue-tree layout | 7934 + 494 | CP866 text | copy into `docs/` or `assets/text/` as reference | E |
Counts: ~270 text items.  All Russian; the project wants an EN/RU option later: text files with a language suffix and the same converter would do (the game uses one fixed table per label, length differences matter only in the 255-byte-wide window layout, not in storage).

### 10.2 Station data tables (db-in-asm; binary numbers; many are index-paired - edit as one spreadsheet)
| # | where | what | size | proposed editable form | diff |
|--|--|--|--|--|--|
| D1 | DATA_M.asm:334 CENS2, 250 SPECTO, 290 TWRM (+ names T1) | 30 goods: price, ban level, cheap-where type, weight class, unit | 30 x 4 | `assets/data/goods.csv` (name, unit, price, ban, specialty, weight class); converter emits the 3 tables + names | E |
| D2 | DATA_M.asm:376 CENS, 435 TONNS, 498 WKII, 163 KRBARM, 829 WKRBI defaults (+ names T1/T2) | 33 ship equipment: price, level, mass, family up/down, incompatible ships, start count | 33 x 12 | `assets/data/equipment_ship.csv` | E |
| D3 | DATA_M.asm:412 CENS1, 473 TONSS, 535 WSII, 202 SKMARM, 869 WSKMI | 14 skimmer equipment | 14 x 12 | `assets/data/equipment_skimmer.csv` | E |
| D4 | DATA_M.asm:691 CNKR, 716 CNSK, 221 SHIPDAT | 7 ships + 4 skimmers (tonnage, price, speed, legal, weight) and the offer-per-level skip table | 60 | `assets/data/ships.csv` (+ `shipdat.csv`); also feeds T5/T6 | E |
| D5 | DATA_M.asm:766-960 TIME ... ABONS (initial values of the state record) | new-game defaults (see also `NDATA` in flight SETHJRET.asm:221 - two different starts, section 7.2) | 512 | `assets/data/newgame.csv` (field name, offset, value) → emitted into both images; must also decide NDATA | M |
| D6 | DATA_M.asm:563-667 TBKP, SETSI, SETGI; 960-1026 SETSD, SETGD | keyboard port/mask tables, default keys of the settings windows | ~250 | `assets/data/keys.csv` | M |
| D7 | flight SETHJRET.asm:724-920 VERTAB, STROYTAB, LEVLTAB; OBJGENER.asm:465-560 INDTABK etc. | spawn probabilities by government/level, ship tables per AI type | ~330 | `assets/data/spawn.csv` | M |
| D8 | DATA_M.asm:8-160 Tabx | jump table of glyph routines (addresses) | 320 | stays asm (code table) | - |

### 10.3 Station graphics, fonts, binary blobs
| # | file / where | what | size | in-game form | proposed editable form | diff |
|--|--|--|--|--|--|--|
| G1 | `assets/PRO.f` (station.asm:24, `SZTB`) | station proportional font, CP866 codes, 9 bytes/char (8 rows + width) | 2304 | raw | `assets/gfx/pro_font.png` (glyph sheet, 16x16 chars, width encoded in a column or a `pro_font_widths.csv`) | M |
| G2 | `assets/KSPOplus.s` (station.asm:10) | mouse cursor sprites (several cursors with masks) | 768 | raw 1-bit sprite+mask | `assets/gfx/cursors.png` | M |
| G3 | `assets/stscr.C` (LOADER.asm:15,117, BODY.asm:847 `DEPACK`) | **16 station background pictures** in one file; sector counts `13,11,11,12,8,14,19,15,15,13,19,12,16,20,21,20` = 239 sectors; each is Hrust-packed (same depacker as the flight panel) | 61184 | packed, 16 chunks at fixed sector boundaries | `assets/gfx/station_bg_01..16.png` (256x192, 2 colours/cell attributes) + converter needing a **Hrust 1.x packer** (a Python packer must be written or an existing one used; the depacker is in the sources) and the sector-size padding | **H** |
| G4 | `assets/MUZ1.C` (LOADER.asm FILE2, bank 3 at #DB00) | PT3 player v1.0 (Nick of GDC) + a ProTracker 3.4 module "compilation of Virtual Agression by Mast/FtL 24.03.99" (credit!) | 6054 | player code + module | split into `assets/music/station.pt3` (module) and player stays binary; converter = concatenate with the player prefix | M |
| G5 | `assets/ways.d` (KARTA.asm:1609 `PWAYS`) | dotted-line patterns for route lines (6 patterns x several phases) | 702 | raw | generated by script from a pattern text or keep binary | M |
| G6 | KARTA.asm:1615-2113 SPRP..SQUADR | six star-marker sprites as *generated drawing code* (`rept`/LDX), not data | ~10 KB code | code | stay asm; to change a marker redraw by hand | - |
| G7 | `assets/station_D9200.d`, `D9000.d` | math tables (multiplication/sine, 768 + 512) | 1280 | raw | **regenerate by script** (not edited); write `tools/gen_tables.py` once and verify md5 | M |
| G8 | `assets/0E0200.d`, `KORNI.d` (CIRCMATH.asm:1716-1719) | table #0E00/#0200 (512) and integer square-root table KORNI (768) | 1280 | raw | generated by script | M |
| G9 | OBJX.asm (station) | 10 viewer 3D models | 10.8 KB | vertex/face bytes (section 2.3) | `assets/models/station_ships/*.obj` (+ converter and scale rules) or hand-editable `.txt` | M-H |
| G10 | `FOTOS` #E700 | **missing**: 16 subscriber portraits (128 B each = 32x32, 1 bit) are expected here but not in the build | 2048 | n/a | `assets/gfx/portraits/pNN.png` 32x32 + converter (new) | M (new content) |
| G11 | `src/storm`/awk5 | nothing used | - | - | - | - |

### 10.4 Flight data
| # | file / where | what | size | in-game form | proposed editable form | diff |
|--|--|--|--|--|--|--|
| F1 | OBJECTS.asm (1695 lines) | ~66 ship/object models (far KN + near Kd + sub-parts) | 5763 | vertex/face bytes | `assets/models/*.obj`-like text + converter; indices in `3DTABS.asm` L97 table stay | M-H |
| F2 | OBJECTS2.asm | 14 older models (Kobra, Kryl, asteroids, rocket, container, UFO1, target, trash, debris) | 1063 | same | same | M-H |
| F3 | OBJECTSS.asm | 22 stations (16 level stations + pirate/prison/UFO/science/hyper-gate) | 3754 | same | same | M-H |
| F4 | `assets/EFF.c` (flight.asm:129) | **compiled** hyperjump effect procedure (machine code produced by a generator) | 1333 | code | keep binary (generator unknown) | H |
| F5 | `assets/FONT.f` (flight.asm:174) | panel/message font | 624 | raw 1-bit | `assets/gfx/panel_font.png` | M |
| F6 | `assets/PANEL.C` | HUD panel picture, Hrust-packed | 1463 | packed (unpacked to #6373 by `DEHRUST`, LOADI2) | `assets/gfx/panel.png` + Hrust packer | **H** |
| F7 | `assets/VOX.d` (1024), `EXPLOSIO.v` (5120), `HIPERJMP.v` (3328) | voxel sprite data: effects (explosion animation, hyperspace tunnel) | 9.5 KB | raw voxel/sprite lists | binary stays (format `.v` = voxel sprite, tools in STORM `CNVVOX*`); optional PNG strips after format analysis | H |
| F8 | `assets/D9000.d`, `D9200.d`, `CSTB.d`, `ATAGTAB.d`, `KORNI.d`, `0E0200.d` | math tables (sine/multiplication, atan, sqrt, cosine/sine-bin) | 512+512+512+256+768+512 | raw | regenerate by script (as G7/G8) | M |
| F9 | PANEL.asm:194, 794-1130 | radar blip sprites (`MINISPRITE`, `MOTAB`.. per object type: station, trader, army, micro, asteroid, hunter, UFO, unknown, pirate, police) as `%` bit lines | ~900 | `db %...` | `assets/gfx/radar_sprites.png` | M |
| F10 | BRAINDOP.asm:1297-1420 | AY sound effects (ROKA, EFF0/1/2/11/13/14/19/21) as 4-byte step lists (tone, noise, mixer, volume) | ~300 | numbers | `assets/sound/effects.txt` (text, one line per step) | E |
| F11 | 3DTABS.asm:204-380, SETHJRET.asm:221 NDATA | default state record (flight copy) + the *intended new game* | 2 x 512 | numbers | covered by D5 | M |
| F12 | `DATAS.C`, `3DPART.C` (flight.asm:59, 84) | **self-built** images: `savebin` then `incbin` of the same name (layout loop) | 2 images | machine code | stays asm (not an asset); do not touch | H |
| F13 | flight object-index table 3DTABS.asm:470-700 | index → model addresses | ~280 | `dw` + `equ low($)` | generated with the models (F1-F3) if models become files | M |

### 10.5 Boot, intro, ending, saves
| # | file | what | size | form | proposed editable form | diff |
|--|--|--|--|--|--|--|
| B1 | `assets/intro_logo.scr` | the "Awaken" logo (SCREEN$) used by the intro | 6912 | ZX screen | `assets/gfx/intro_logo.png` (256x192, attribute cells) + converter | E-M |
| B2 | `assets/intro_depack.bin` | depacker + **packed closing picture "Awaken - Second Breeze"** (copied over the logo area; the stub calls it) | 1743 | code + packed picture | picture as PNG + Hrust-like packer **if the packer format is identical** (the code at the start is the depacker; format not analysed) | **H** |
| B3 | `src/boot/intro.asm` | intro effects (code ~2.1 KB; unrolled generated code; no text) | - | code | stays asm | - |
| B4 | `assets/FINALF.C` | the ending program (#6000, 19114 B): galaxy picture + big pixel letters "ТЫ СДЕЛАЛ ЭТО" / "ТЫ СПАС МИР" / "НО НАДОЛГО" drawn from bitmaps (no text strings in the file); colours cycle; no disk access | 19114 | code + graphics mixed, banked | needs disassembly: `src/ending/finalf.asm` first; the texts exist only as bitmaps (to edit them, re-draw or add a string renderer) | **H** |
| B5 | `build.py` SAVE0..SAVE5 | 512-byte state records written by the build | 6 x 512 | raw | generated from `newgame.csv` (D5) | E |
| B6 | boot BASIC (`src/boot/boot.asm`) | loader | 123 | BASIC bytes | stays | - |

### 10.6 STORM data (`src/storm`; code stays asm; the data blobs below are all `INCBIN`)
| file | used by | size | what | editable form |
|--|--|--|--|--|
| `assets/D9000.bin`, `D9000_plus.bin`, `D9200.bin`, `korni.bin` | S3D.asm:20/36/48, INVTAB3D.asm:31, BLK5.asm:65 | 512/512/768/768 | math tables (same family as G7/G8) | regenerate |
| `assets/VOX.bin`, `VOX2.bin`, `CHAN1.bin`, `CHAN6.bin`, `drv2.bin`, `DRV1.bin`, `DRV2_UC.bin`, `DOMA1.bin`, `planet.bin` | CNVVOXTB/VOXEL/VSPRITE/VXXX/LAND/CNVVOXS3/CNVVOXSP | 1024..3072 each | voxel sprite and terrain data: channels (landscape height/colour maps?), driver/units (skimmer/vehicle sprites DRV), house (DOMA = "дома") and planet sprites | binary; converting to PNG needs format analysis (INFERRED names) |
| `assets/FONT.bin` | LAND.asm:2308 | 1024 | font of the STORM prototype | `assets/gfx/storm_font.png` |
Total STORM data: 14 files, ~20 KB.  Not on the disk; only needed if the surface-landing part is revived.

Contents of the math tables, `ways.d`, `KSPOplus.s`, `VOX.d` and the voxel/STORM blobs are INFERRED from names, sizes and the code that reads them; the sizes and incbin lines are VERIFIED (`assets/MANIFEST.md`, grep).

### 10.7 Summary by effort
Easy (text + tables as CSV/TXT, ~80 % of the "editable" value): T1-T7, T9, T11, D1-D4, F10, B5.  Medium: fonts/sprites as PNG (G1, G2, F5, F9), tables regenerated by script (G7, G8, F8), settings/new-game record (D5, D6, D7), models (G9, F1-F3, needs a model text format), music split (G4), intro logo (B1).  Hard: everything Hrust-packed (G3 stscr, F6 panel, B2 closing picture) - **a Hrust 1.x packer must exist first**; the ending (B4) and the voxel/sprite files (F7), compiled effect `EFF.c` (F4), self-referencing images (F12).  The pictures are small (16 backgrounds, one panel, one closing picture), so a Python Hrust packer or an "uncompressed store" mode (a depacker-compatible stream with literals only; larger but valid) is enough: INFERRED, the format must be read from `DEPACK` (BODY.asm:847).
