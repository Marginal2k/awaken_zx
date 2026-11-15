# Testing / emulator harness (coder)

Emulator: **Xpeccy+** (https://github.com/dotkoval/xpeccy-plus; `tools/xp/run.py` takes the exe from env `XPECCY`, else `xpeccy-plus` on PATH), headless `--bench` mode, always with a private config dir:
`work\xpconf` (Pentagon, 512 KB RAM; copy of the user's config incl. ROMs) or `work\xpconf128` (Pentagon with 128 KB); never the user's own config.
Only processes started by the harness are ever stopped (no kill by image name: the user plays in their own emulator windows).
The earlier ZX-M8XXX/CDP harness (tools/cdp, tools/emu) was removed; `run.py --conf work/xpconf128` covers 128K.

## Regression (one command)

    python tools/xp/regress.py                   # build + verify_original + 21 test groups x 2 configs  (~27 min, one emulator run at a time)
    python tools/xp/regress.py --conf pent128    # one config (pent512 = work/xpconf, pent128 = work/xpconf128)
    python tools/xp/regress.py --no-build --only scr_,flight    # reuse build/, only tests whose name starts with a prefix (results are merged into the report)
    python tools/xp/regress.py --no-stab         # skip the 12000-frame stability runs

Output: `work/coder/reg/REPORT.md` (the table), `work/coder/reg/results.json`, per config `work/coder/reg/<pent512|pent128>/` (PNG shots, .szx snapshots, `regress.log`,
`_scen/` = the scenarios as run).  Exit code 0 = everything PASS.  Checks per test: all segments ran (rc 0), final PC >= #4000 (not in ROM = no reset/crash), shots not blank,
station button strip / green flight panel recognised, RAM values read from the snapshots (credits, speed, flight state), windows opened/closed visible as picture changes.
The runs are deterministic (emulated frames only): both configs give identical states.

### Result of the last full run (git a02e933, 2026-11-14/15): 42/42 PASS, no bug found

| step | result | evidence |
|---|---|---|
| `python build.py` (+ `--test-return`, `--test-ending`) | PASS | awaken.trd, awaken_nointro.trd, awaken_test_return.trd, awaken_test_ending.trd |
| `tools/verify_original.py all` | PASS | 11 x BYTE-EXACT (LABELS 465/465) |

Both configs (Pentagon 512 and 128 KB) PASS every row; evidence = shots/snapshots under `work/coder/reg/<config>/`.

| scenario (regress name) | scenario files | what is checked | evidence |
|---|---|---|---|
| intro | `tools/scen/ours_intro.txt` | logo, nebula, closing picture, station at ~3500 | `in_0800/1400/2000/3500/5000.png`, `intro.szx` PC in game (#DFFE) |
| intro_skip | `tools/xp/scen/ours_intro_skip.txt` (new) | SPACE at frame ~1005 -> closing picture at once, station by 3000 | `is_1060.png` identical to `in_2000.png`, `is_3000/4000.png` |
| station_boot_map | `tools/scen/ours_station.txt` | boot to station, cursor Q/A/O/P, click, map, M, 3000 idle frames | `station_*.png`, credits 23930 (24000 - 70 fee), PC #E017 |
| scr_help, scr_goods, scr_abonent, scr_news, scr_contract, scr_ship, scr_skimmer, scr_equip, scr_equipskim | `tools/xp/scen/ours_scr_<name>.txt` (new) | open the screen by clicking its button, then M on empty background -> "Закрыть все" closes the windows, station buttons are back | `scr_<name>_2open.png`, `_4closed.png`; ship/skimmer show the 3D model, equip/equipskim the item lists |
| scr_map | `tools/xp/scen/ours_scr_map.txt` (new) | map opens, "Листать" works, covered by the station button at the right edge | `scr_map_2open/3page/4cover.png` |
| flight_launch | `tools/scen/ours_flight.txt` | "Вылет" -> flight panel, clock continues | `fl_after2100.png`, `fl_state.szx` PC #DE64 |
| flight_keys | `tools/xp/scen/ours_fkey_*.txt` (new, 7 runs from `fl_state.szx`) | A, S, X, N, M, Space each change RAM against the no-key control run | bytes differing in flight state #9B00.. / object table #A200..: A 5+2, S 40+8, X 38+8, N 25+5, M 26+4; Space: Speed #A88F #14 -> #84; `fkey_*.png` (A draws the laser lines, S/X move the station up/down) |
| dock_relaunch_dock2 | `tools/scen/ours_dock.txt`, `ours_relaunch.txt`, `ours_dock2.txt` + `szxpoke.py DOCK` | docking, state carried (credits 31777), relaunch, second docking (fee: 31707) | `dk_c.png`, `rl_flight.png`, `dk2_b.png`, credits read from #984C |
| save_load | `tools/scen/ours_save1.txt`, `ours_save2.txt`, `ours_load.txt` | M menu -> "Сохраниться" -> slot 2 writes SAVE2 (record found in the disk image inside the snapshot); a TRD with that record in SAVE2 -> "Восстановиться" -> restart with the credits | `sv_save_win.png`, `sv_saved.png`, `ld_loaded.png`; credits after load 30777 = 31777 - 1000 (see below). Two steps: harness limit, disk writes do not survive an .szx segment |
| test_return_build | `tools/scen/ours_return_test.txt` | `--test-return` disk: flight returns to the station at once | `rr_c.png` |
| test_ending_build | `tools/scen/ours_ending_test.txt` | `--test-ending` disk: "Вылет" starts FINALF | `end_c.png`, PC #92EC (ending code, #7FFD=#01) |
| stab_station_12200f | `tools/xp/scen/ours_stab_station.txt` (new) | 2200 boot + 10 x 1000 frames with seeded random cursor/click/M input | PC #E016 in game, `stab_st_04/09.png` (sane station UI; a random click opened the skimmer equipment window) |
| stab_flight_10000f | `tools/xp/scen/ours_stab_flight.txt` (new) | 10 x 1000 flight frames with seeded random A/S/X/N/M/Space | PC #CDED (CONTROL bank, `Kd30+36`), `stab_fl_02/05/09.png` (panel intact, "Корабль в зоне станции. Уменьшить скорость") |

Observations (not failures):
* Restoring a save re-runs the "new game" start windows: the "Внимание ... оштрафованы на 1000 кредитов" window appears and the fine is taken (31777 loaded -> 30777).
  Landing from the flight shows only the "Добро пожаловать" window (fee 70).  Probably the original start path; worth a look by the author/technician.
* The 128 KB Pentagon needs nothing beyond what the 512 KB one shows: identical states and PCs in every scenario.
* The galaxy map cannot be closed (M does nothing on it); windows stay stacked, and "Закрыть все" needs an empty background spot, which the full-screen map does not leave.

### Harness notes from the regression
* Under heavy host load (other emulators, antivirus) Xpeccy+ sometimes hangs or silently starts a **blank machine** instead of loading the chained snapshot (picture = 128K menu, PC #3685).
  `run.py` now detects both (timeout; no "open SZX snapshot" in the log) and re-runs the segment (`--retries 3`, `--timeout 90`); runs are deterministic, so a retry is exact.
* Key hold times must be shorter than the segment (`run 80 keys 5:a/81` silently truncates the key at 75 frames); cursor speed is 2 zx px/frame from (0,0).
* Station start: window "Внимание" (one click closes it), then "Добро пожаловать" which does not block clicks.  Windows are closed with `M` on empty background -> menu "Закрыть все"
  (2nd item; the menu opens with the item under the cursor highlighted, one item = 8 px = 4 cursor frames).

## Tools (owned by the coder)

| tool | purpose |
|---|---|
| `tools/xp/run.py SCEN.txt [-o OUTDIR] [-d DISK] [--conf CONFDIR] [--brk F.xbrk] [--brk-log FILE or -] [--timeout S] [--retries N] [--keep]` | scenario runner: boots a TRD, runs N frames per segment, keys, PNG screenshots, chained through .szx snapshots |
| `tools/xp/regress.py [--conf C] [--only PREFIXES] [--no-build] [--no-stab]` | the full regression above, prints/writes the table |
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

## Our build - historical findings of the first bring-up (all fixed since, kept for the record)

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
