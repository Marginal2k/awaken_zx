# Unused demo v0.2 files

Files from the Awaken v0.2 demo disk (reference/AwakenV0.2Demo.trd) that no code
in the 1999 sources or in the demo binaries loads (see docs/ANALYSIS.md section 13.4).
They look like material prepared for later parts of the game: screens (choose1/2,
6912 bytes = SCREEN$), full 16K memory banks (BANK0-5, BD0-3), panel variants
(PANELF, PANELMET, PANELFF), a scene (scene1po) and BAR.

Decision (user, 2026-11-14): keep them here as assets, do NOT put them on the game disk.

| file | bytes | TR-DOS start | md5 |
|--|--|--|--|
| BANK0.C | 16384 | 49152 | 88ed5fa4 |
| BANK1.C | 16384 | 49152 | b1d95324 |
| BANK2.C | 16384 | 49152 | c50ee7db |
| BANK3.C | 16384 | 49152 | 4891066a |
| BANK4.C | 16384 | 49152 | 761a83b5 |
| BANK5.C | 16384 | 49152 | 8afe551c |
| BAR.C | 3076 | 32768 | 283b36d6 |
| BD0.C | 16268 | 49152 | 0c54b930 |
| BD1.C | 16152 | 49152 | 3f094202 |
| BD2.C | 16248 | 49152 | 2e380a23 |
| BD3.C | 12048 | 49152 | 3c2d811d |
| PANELF.C | 1436 | 8224 | d8821bf6 |
| PANELFF.C | 1543 | 29283 | 9cd935b3 |
| PANELMET.C | 1423 | 8224 | fa5a6e59 |
| choose1.C | 6912 | 8224 | 728ea5b8 |
| choose2.C | 6912 | 8224 | dd93087b |
| scene1po.s | 18676 | 29296 | de746390 |
