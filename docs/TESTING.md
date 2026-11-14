# Testing / emulator harness (coder)

Emulator: **Xpeccy+** (`D:\Emulators\ZX\XpeccyPlus\xpeccy-plus.exe`), headless `--bench` mode, always with
`--confdir work\xpconf` (copy of the user's config incl. ROMs; never touch the real one).
The earlier ZX-M8XXX/CDP route (`tools/cdp/`) is obsolete (browser closed).

## Tools (owned by the coder)

| tool | purpose |
|---|---|
| `tools/xp/run.py SCEN.txt [-o OUTDIR] [-d DISK] [--brk F.xbrk] [--brk-log FILE or -] [--timeout S] [--keep]` | scenario runner: boots a TRD, runs N frames per segment, keys, PNG screenshots, chained through .szx snapshots |
| `tools/xp/szxinfo.py SNAP.szx [--sym F.sym] [--stack N] [--mem #ADDR:LEN] [--bank B:OFF:LEN] [--png PREFIX]` | registers, #7FFD, visible screen, memory as the CPU sees it, both screens as PNG, symbolic PC/stack |
| `tools/xp/scen/*.txt` | scenarios; `tools/xp/scen/trdos.xbrk` = log every TR-DOS call (#3D13) |

### Scenario syntax
```
disk reference/AwakenV0.2Demo.trd/Awakenv02.trd     # autostart (RUN boot); or -d on the command line
from work/coder/xp/demo_station.szx                  # alternative: start from a snapshot (disk is carried inside it)
machine pent                                         # default
run 4000 shot station                                # run N frames, PNG of the LAST frame (whole raster 896x320 incl. border)
run 100 shot x keys 5:p/12,5:a/78                    # --bench-keys: FRAME(relative to segment):KEYS/HOLD, one item = keys pressed together
save demo_station                                    # also keep OUTDIR/demo_station.szx
run 1 hash                                           # print the --bench-hash line (frames/ram/cpu hashes + PC)
```
Keys: digits/lowercase letters, `E` Enter, `C` Caps, `S` Symbol, `_` Space, `joy:up+fire` (Kempston), `nmi`.
Segments are chained through an SZX snapshot (disk image included). A frame boundary is a snapshot boundary, so release keys
>=10 frames before a segment end. Runs are deterministic (emulated frames only, no wall clock).

Things learned the hard way:
* `--bench-hash` makes long runs very slow / hang (>1500 frames): use it on short segments only.
* The screenshot shows the **visible** screen (normal/shadow per #7FFD bit 3) incl. border; 1 ZX pixel = 2x1 px.
  `szxinfo.py --png` dumps screen banks 5 and 7 separately.
* Log column `F` = frames since power on; breakpoint variable `FRAME` = `F - 14` after the autostart reset.
* **The Kempston mouse cannot be scripted in bench mode** (no key item for it). Use keyboard/joystick controls.
* Breakpoints (`--brk file.xbrk`, `--brk-log -`): one per line `KIND:ADDR:MASK:FLAGS:ACTION:COND:LOG`, e.g.
  `CPU:6300::FL:CNT::PC,SP` (log a fetch), `CPU:0000::FL:DBG:FRAME>100:PC,SP,[SP]` (stop, exit code 2),
  `RAM:05:0200-02FF:WL:DBG:PC==0xA3A7:PC,WR,HL,DE,BC` (RAM write), `IO:7FFD:C002:WL:CNT::PC,VAL` (port 7FFD writes).
  Flag `L` is required to get a log line; action `DBG` ends the run; `--bench-save x.szx` then holds the state at the stop.
  Instruction trace: `CPU:0000-FFFF::FL:CNT:FRAME>=N:PC,SP,[SP]` with N a few frames before the event (~17k lines/frame).
* Labels: build.py emits none for the station. Make them in a **scratch directory** (sjasmplus writes the .C files into cwd):
  `sjasmplus --nologo --msg=err -I <repo>/assets --sym=st.sym --lst=st.lst <repo>/src/station/station.asm`, then `szxinfo.py --sym st.sym`.

## Demo v0.2 flow (reference/AwakenV0.2Demo.trd/Awakenv02.trd, Pentagon, `--autostart`)

Scenarios: `tools/xp/scen/demo_boot.txt`, `demo_station.txt`, `demo_map.txt`; screenshots `work/coder/demo_*.png`.

| frame | what | file |
|---|---|---|
| ~470 | TR-DOS runs the BASIC boot `AWAKEN.B`, which loads the payload | |
| ~800 | intro animation | `demo_intro_0800.png` |
| ~1500 | "Awaken" logo + dithered nebula | `demo_intro_1500.png` |
| 1880-2970 | TR-DOS loads LANG, KARTA, HELP, D3D, stscr, MUZ1 into banks (log with `trdos.xbrk`) | |
| ~4000 | **station screen**: window "Добро пожаловать!", buttons `? Карта Товар Новости / Вылет Контракт Корабль Оснащение корабля`, status `ST: Чисто KR: 2000 TN: 13:50 Ранг: СОСУНОК`, clock | `demo_station.png` |

Station controls (defaults in `src/station/DATA_M.asm`, `BODYOCUR.asm`): cursor with the keyboard `Q` up, `A` down, `O` left, `P` right,
`Space` = click, `M` = cancel; the code also auto-detects a Kempston joystick (port #1F) and Kempston mouse (#FBDF / #FFDF / #FADF).
Cursor speed 2 px/frame, hot spot = arrow tip; ZX screen px = ((png_x-144)/2, png_y-64). The cursor is drawn only on some frames
(double buffering), so a single screenshot may miss it.

Key sequences, frames relative to the station state at frame 4000 (`work/coder/xp/demo_station.szx`, made by `demo_station.txt`):
* **Map ("Карта")**: `5:p/12,5:a/78` (cursor x~24, y~156; `demo_cursor_on_map.png`), then `5:_/6` -> after ~120 frames the galaxy map
  with system info and buttons `Память Маршрут Листать Стереть Центр Позиция Контракт Перелет` (`demo_map.png`).
* **Departure ("Вылет")**: `5:p/12,5:a/84` (`demo_cursor_on_vylet.png`), then `5:_/6`. TR-DOS loads two files (frames +4 and +373: the
  `ACTION` flight module, descriptor start #C000/#6000), then the screen goes black; PC wanders around #AB00-#ABC0 and RAM keeps changing
  (never returns, still black 3000 frames later). It is **not verified** whether this is the demo needing something we cannot supply in bench
  mode (Kempston mouse / second disk) or an emulator problem; the flight part was therefore not reachable and flight controls and the return
  to the station are undocumented.

## Our build (`python build.py` -> `build/awaken.trd`)

Run: `python tools/xp/run.py tools/xp/scen/ours_boot.txt -o work/coder/xp`.
Findings (verified with logs/snapshots; scratch fixes in `work/coder/lab/`, nothing applied to src):

1. **Boot stub bug (first crash).** `src/boot/boot.asm` assumes `PROG = 23755 (#5CCB)` and uses `RANDOMIZE USR 23760`. With TR-DOS paged
   the BASIC program is loaded at **PROG = #5D3B** (sysvar 5C53), so `USR 23760` = #5CD0 executes TR-DOS system variables -> garbage ->
   ROM reset (`0 OK, 20:1`). Fix: `BASIC_PROG equ 23867`, `USR 23872` (= #5D40 = PROG+5). Then `jp #6300` is reached at frame 647.
2. **`DISK_SECTAB` is assembled at #0000** (`src/common/disk.asm` is included before `org #6000`; sym `DISK_SECTAB = 0`). `LOADER.asm`
   reads it (i.e. ROM bytes) to choose the random `stscr` picture -> wrong `DISK_RDSEC` (B=#5C, track #1F) -> `DEPACK` runs wild. Fix: put
   the table inside the image *below #C000* (e.g. in BODYOCUR.asm after `jp Dalee`, before `ent`; not at the image tail, which is paged).
3. **`stscr` must be the full 239 sectors.** The demo catalogue entry for `stscr` says length 3230 but allocates 239 sectors (16 packed
   pictures, SECTAB = their sector counts); `assets/stscr.C` has only the first 3230 bytes. Use the full 61184 bytes
   (`work/coder/lab/stscr_full.C` = demo disk track 40 sector 3 + 239 sectors; first 3230 bytes identical) and keep the catalogue length 3230
   (`d.add_file('stscr','C',full,start=0xC000,length=3230)`).
4. **STATIONF tail is not loaded (next crash).** With 1-3 fixed the loader works and the init code at #4000 reaches `Dalee` (frame ~1233),
   but at frame 646 memory matches STATIONF.C exactly only up to #BBFF: TR-DOS function #0E from the boot stub loaded 92 sectors
   (#5C00 bytes) of the 102-sector file (KARTA 46, D3D 62, LANG 16 sectors load completely). The part #BC00..#C5C4 (1477 bytes incl. `Objvec`
   #C278, `Objcts`, `Sur1`) is zero. The init loop `H_1` (BODYOCUR) then walks garbage object pointers (e.g. #A453), writes `E7 00` into the
   unrolled `ldi` block `HS1` (#A453) which later runs wild -> `rst`/`jp` into ROM -> `NEW` (#0000) at frame 1287, SP=5.
   To do: find why `C=#0E, A=3` stops at 92 sectors (limit in the stub? TR-DOS?), or keep STATIONF below #BC00 / split it / read the tail
   with `C=#05`. Check: `szxinfo.py --bank` or `--mem` against STATIONF.C at frame 646 (`--bench 646 --bench-save`).
