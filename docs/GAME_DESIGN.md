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

(pending)

## 5. Map

(pending)

## 6. Flight

(pending)

## 7. Story

(pending)

## 8. Unused and unusual

(pending)

## 9. Gap list for a full game

(pending)

## 10. Asset inventory

(pending)
