# Awaken model editor

A browser editor for the game's 3D models (`assets/models/flight/*.txt`, `assets/models/station/*.txt`): view, edit and create ship / station /
asteroid models and see them **as the game draws them** (ZX view). Static HTML + plain JS modules, no build step, no CDN, nothing to install
except Python (for the tiny local server) and Chrome / Edge.

## Start

```
python tools/model_editor/serve.py          # http://localhost:8780/  (first free port from 8780 up; never 8000/8090/8095/8851)
python tools/model_editor/serve.py --open   # same + opens the browser
```

The server serves the editor, serves `assets/models/` at `/models/` and lets **Save write straight into `assets/models/`** (PUT/DELETE
restricted to `flight|station/NAME.txt` and `index.txt`, 127.0.0.1 only). The editor then loads all 113 models by itself.

Other ways to open models (Chrome / Edge; opening `index.html` from `file://` does not work because of ES modules - always use the server):

* **Open folder** - File System Access API (`showDirectoryPicker`): pick the repository folder, `assets` or `assets/models`; Save writes back into the same files.
* **Open files** - fallback: pick the model files (or the folder); Save downloads the changed files.

## From the editor into the game

1. Edit, **Save** (Ctrl+S) - the files in `assets/models/` are the source of truth (`tools/assets/gen_models.py` reads them).
2. `python build.py` - regenerates `build/gen/OBJECTS*.inc` / `OBJX.inc`, assembles, writes `build/awaken.trd`.
3. Changing the shape of an existing model needs nothing else. A **new** model additionally needs a reference to its label in the code:
   flight: object index table `L97` in `src/flight/3DTABS.asm` (`dw far-model, near-model` per index) + the code that spawns the object;
   station viewer: table `L97` in `src/station/DATA3D.asm` (`dw model,model` per entry) + the ship list. The editor adds the name to `index.txt`
   (memory order of the bank) and says so; the Validation panel shows what is left in the bank.
   Face labels (`label P00xxx`) are patched by the game at run time (engine flicker): they stay attached to their face when you reorder, and the editor asks before deleting such a face.

## Screen

* left: model list (flight / station, by section of `index.txt`), search, markers: `●` unsaved, `!` validation error.
* tabs: **ZX view** (the game's renderer), **Edit 3D** (orbit), **Front / Side / Top** (orthographic, vertex dragging).
  All views use the game's axes: camera X right, Y down, Z away from the viewer (gizmo bottom left).
* **Edit 3D**: vertices with numbers, faces outlined/filled, green arrow = outward normal (red = points inwards), hidden (back) faces dashed and dimmed,
  selected face shows corner order 1,2,3.. and an arrow along its first edge. Drag = orbit, Shift/right-drag = pan, wheel = zoom, double click = fit.
* **Front/Side/Top**: drag a vertex (integer snap, clamped -128..127; mirrored copies follow because the file stores one group), arrow keys nudge.
* **ZX view**: window preset (full 256x192, flight window 256x96, station viewer 72x72), distance Z, flicker simulation (`MERZ`), spin, lit colour.
* right: Model (labels, radius with *auto*, scale, comment), live ZX preview, **vertex groups** (x y z, mirror, order; vertex numbers shown;
  changing a mirror or the order renumbers the vertices and the faces follow), **faces** (add polygon / line by clicking vertices in order, auto-wind,
  pattern or line mode, "if previous polygon visible", reorder, flip winding, delete, labels), **validation** and the memory budget.
* Undo / redo (Ctrl+Z / Ctrl+Y) per model, New / Duplicate / Delete (Delete warns and, with serve.py, lists where the label is used in `src/`).

## Renderer facts (read from `src/flight/3D-I.asm`, `3D-II.asm`; the station viewer `XR2.asm` is the same engine) and checked against the emulator

* Vertices: signed bytes; each group makes copies in the order 0,1,3,2,6,7,5,4 (see `tools/assets/models.py`). The copy is the product with the 3x3 byte matrix
  (`MULAB` = quarter-square table, `a*b/127`); X and Y sums are packed in one 16-bit register and the mirror copies are made by subtracting the *doubled* (`RLC`) terms,
  so the game has +-1 rounding quirks which the editor reproduces. The 3 sums are 8-bit signed.
* Projection: record coordinates are shifted by `scale-1` bits (the code jumps `6-scale` bytes into five `add hl,hl`; scale 0 acts like 1), added to the 16-bit object
  position and divided: `screen = centre +- 256*|N|/Z`. Camera space: X right, Y down, Z away. Measured: the division behaves like dividing by `Z-12`
  (322 of 324 vertex coordinates exact on 9 emulator frames). Z <= 0 or a quotient > 65535 = off screen. Centre: flight window (128,48) in a 256x96 window, station
  viewer (36,36) in a 72x72 window at screen (176,16); the station object distance `ZET` is 1500.
* Back-face rule (`VSPOLY`): first three corners (corners 0,1,2; with 5..8 corners 0,2,4); a polygon is drawn if the screen cross product
  `(x1-x0)*(y2-y0)-(x2-x0)*(y1-y0)` (y down) is **positive**, i.e. corners run **clockwise** on the screen. So the outward normal is `(P2-P0)x(P1-P0)`; faces
  wound the other way are invisible from outside. Faces are drawn in file order (painter order = model order; polygon fill overwrites).
* Fill patterns (table `LC5`, rows alternate `A` / `A xor M`, the first row of the polygon uses `A`, columns anchored to screen bytes). A **set bit is the dark pixel**
  (the shadow screen is cleared to #FF): 0 black, 1 = 25% lit, 2 = 50% (checkerboard), 3 = 75% lit, 4 = white. Patterns 5..7 read the bytes behind the table
  (flight: code bytes `ED 73 | 29 D1 | 31 00`, station: zero padding = white); they appear only through the label flicker `MERZ` (`xor %01100000` on the face byte: 1<->7, 2<->4, 3<->5).
* Lines (face byte bit 7): 1-pixel Bresenham, mode bits 4-5: 0 AND (clears bits = lit line), 1 OR (dark line), 2/3 XOR; bit 6 = only if the previous polygon was visible.
* Vertex limit: **51** (the screen-vertex buffer `L9C` is one 256-byte page of 5-byte slots; a reference is `slot*5` in one byte). Corners per polygon 3..8.
  Flight record <= **256 bytes** (`OBJBUF` is `#100`; the biggest model, Gip_pl, takes 251). Flight models all together: bank OBJ3D 16384 bytes, now 10580 (~5.8 KB free,
  `docs/GAME_DESIGN.md` 9.2). Station viewer: the models take 1323 bytes and the overlay D3D has only ~150 bytes free.

Accuracy: on 9 emulator frames of the station viewer the ZX view reproduces 99.4% of the vertex coordinates exactly and about 97% of the window pixels (the rest: the
label flicker phase and 1-pixel edge differences of the polygon filler). Not reproduced: the clipper's exact edge pixels, objects behind the camera, the flight
window's real scene (sun, other objects).

## Tests (`node` 22, in `tools/model_editor/test/`)

```
node tools/model_editor/test/roundtrip.mjs      # 1: parse -> serialize is byte-identical for all 113 models + 2 index.txt
node tools/model_editor/test/binary.mjs         # 2: JS binary encoder == build/gen/*.inc (bytes, labels, include text) == build/flight/OBJECT3D.C
node tools/model_editor/test/validate_all.mjs   # all shipped models validate without errors (needs no build)
python tools/model_editor/test/ingame.py        # 3: edit a model through the serializer, build, run the station in Xpeccy+, compare, revert, gate
```

`ingame.py` writes into `work/model_editor/ingame_run/` (screenshots, `zxview_vs_emulator.png` = emulator | editor | difference), restores the model file and runs
`work/assets_tech/gate.py check` (`DIFF [] MISSING []`). The comparison helpers (`szx_frame.py`, `png_to_frame.py`, `frames.mjs`) work on any station snapshot.

## Files

`index.html`, `style.css`, `js/format.js` (parse / serialize / binary / `.inc`), `js/zxrender.js` (game renderer), `js/validate.js`, `js/ops.js` (edit operations with
vertex renumbering), `js/store.js` (folder / http / file access), `js/views.js` (viewports), `js/app.js` (UI), `serve.py`.
