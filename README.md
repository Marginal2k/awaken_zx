# Awaken - source restoration

ZX Spectrum 128K game "Awaken" (Mythos / Rage Technologies, 1999).  Inputs: `archive/awk1..6.trd` (developer disks), `reference/` (released demos).
Goal: readable sjasmplus sources that build a complete, working game on a plain TR-DOS disk (no protection, all disk I/O in `src/common/disk.asm`, editable assets).

## Build and run

    python build.py                  # sjasmplus must be on PATH (or C:\sjasmplus) -> build/awaken.trd (+ awaken_nointro.trd, symbol files build/*.sym/.lst)
    python build.py --test-return    # test disk: the flight returns to the station at once  -> build/awaken_test_return.trd
    python build.py --test-ending    # test disk: "Вылет" starts the ending                  -> build/awaken_test_ending.trd

Load `build/awaken.trd` in a Pentagon/128K emulator with a Beta disk interface (TR-DOS) and `RUN` (autostart): intro animation (SPACE skips it) -> station -> "Вылет" -> flight -> fly into the station -> station.
128 KB is enough.  Emulator harness and scenarios: `docs/TESTING.md`, `tools/xp/`, `tools/scen/` (e.g. `python tools/xp/run.py tools/scen/ours_flight.txt -o work/xp_ours`).

## Controls

* Station: `Q` up, `A` down, `O` left, `P` right (or Kempston joystick/mouse), `Space` = click, `M` = cancel / system menu on empty background (save "Сохраниться", load "Восстановиться", settings).
* Flight (Elite-like): `A` laser, `S` / `X` pitch, `N` / `M` roll, `Space` throttle.  Docking: fly into the station's docking block (distance box, no docking computer).
* Intro: `Space` skips the effects.

## Save slots

Menu `M` -> "Сохраниться" -> "В позицию 1..5" writes the 512-byte state record into the file `SAVEn` (in place); "Восстановиться" -> "С позиции n" reloads the station with that record.

## Disk layout (`build/awaken.trd`, details and memory map in `docs/ANALYSIS.md` section 14)

`boot` (BASIC) -> `INTRO` (#6400) -> `STATIONF` (#6000, entry #6300) + banks `LANG D3D KARTA HELP MUZ1 stscr`; `ACTION` (#6000) + `VOXAL0 VOXAL CONTROL0 CONTROL OBJECT3D PANEL` (flight);
`SAVE0..SAVE5`; `FINALF` (ending, test build only).  Station and flight swap by reloading each other; the 512-byte state record (`TIME`) is handed over in screen RAM (`src/common/state.inc`, `launcher.asm`).

## Source tree

* `src/boot` - `boot.asm` (BASIC loader), `intro.asm` (disassembled intro of demo v0.2).
* `src/station`, `src/flight` - the game parts (ZASM 3.10 sources converted to sjasmplus; Cyrillic data files are Windows-1251 text with `ENCODING "DOS"`).
* `src/common` - `disk.asm` (the only TR-DOS access), `launcher.asm`, `state.inc` (the glue between the parts, marked `[glue]`).
* `src/storm` - finished isolated STORM 3D prototype (not part of the game); `src/legacy` - unused old sources, not built.
* `assets/` (+ `MANIFEST.md`) - binary blobs `incbin`ed by the sources.
* `work/phase1_src` - phase-1 conversion used by `tools/verify_original.py` (`python tools/verify_original.py all` checks that the developer-disk binaries rebuild byte-exact; `-DDISK_ORIGINAL` reproduces the 1999 loaders).
* Phase 1 tools: `python tools/rebuild_all.py` (extract disks, decode ZASM/STORM sources, convert, compare); `docs/ZASM_FORMAT.md`, `VERSIONS.md`, `BINARIES.md`, `CATALOGUE.md`.

## Status

Boots, plays the intro, runs the station (map, trade windows, save/load), launches the flight, docks and returns with the state carried, launches again; the ending program is on the disk but has no trigger
(open question, `docs/ANALYSIS.md` 13.4).  Verified in Xpeccy+ (Pentagon 512 and 128).  Not verified on real hardware.
