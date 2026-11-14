# Awaken - source restoration (phase 1)

ZX Spectrum 128K game "Awaken" (Mythos / Rage Technologies, 1999). Input: `archive/awk1..6.trd` (developer disks), `reference/` (released demos).

* `python tools/rebuild_all.py` - extract all disks, decode ZASM 3.10 / STORM sources, convert to sjasmplus, assemble and compare with the disk binaries.
* `work/extract/<disk>/` extracted files, `work/catalogue.json`; `original_src/<disk>/` decoded sources (editor view); `src/<disk>/` sjasmplus conversion
  (`src/awk1/SPACE.asm` = 3D flight part, `src/awk6/DOS.asm` = station part; build with `sjasmplus SPACE.asm` inside that directory).
* `docs/ZASM_FORMAT.md` format + language; `docs/VERSIONS.md`, `docs/BINARIES.md`, `docs/CATALOGUE.md` generated tables.
* `tools/verify_original.py all` / `awk1 --variant objects_line` - byte comparison report (3DPART, CONTROL0 exact; DATAS, OBJECT3D exact with the documented variant).

## Build (phase 2a)

    python build.py        # sjasmplus must be on PATH; -> build/awaken.trd (boot, STATIONF/LANG/D3D/KARTA/HELP/MUZ1/stscr, ACTION/VOXAL0/VOXAL/CONTROL0/CONTROL/OBJECT3D/PANEL)

Tree: `src/boot`, `src/station`, `src/flight`, `src/common/disk.asm` (all TR-DOS access), `assets/` (+MANIFEST.md), `src/legacy` (not built), `work/phase1_src` (phase-1 conversion used by `tools/verify_original.py`).
Status: builds; boot and station<->flight switching not yet working/tested - see docs/ANALYSIS.md section 9.
