# ZASM 3.10 source format (as used by the Awaken developer disks)

ZASM 3.10 ("ZAsm v3.1 SetUp&Windows", (c) Rubts0FF / Vladimir, 15.01.1998 - 09.01.1999) is a resident
editor+assembler for the Pentagon/Scorpion TR-DOS world.  The program is `za_3.10` (TR-DOS type `e`, start 25976 = #6578,
length 32282) started by the BASIC loader `ZASM3.10`; the overlays `compile`, `service`, `setup`, `edit_m`, `replace`, `tabul`,
`fnt_ed` (type `o`, start 27766 = #6C76) are loaded on demand.  Sources are TR-DOS files of type `a`, start 28019 (#6D73),
length = exact text length (the last sector is padded with garbage, always cut to `length`!).

Everything below was verified two ways: by decoding the tables out of `za_3.10`, and by rebuilding the original binaries
byte-exact from the decoded sources (see ANALYSIS.md).

## 1. File layout

A file is a stream of lines, every line ends with `0D`.  There is no header and no line table.

| byte(s)        | meaning |
|----------------|---------|
| `0D`           | end of line |
| `02/03/04/05 NN` | token reference.  `NN-0x20` = index into the token table (below).  The four prefix bytes are interchangeable for decoding (they look like "spacing classes" chosen by the tokenizer, `05` before most mnemonics, `03` before operands followed by `,` `:` or EOL); the tokenizer decides them, the assembler ignores the difference. |
| `06 NN`        | `NN-0x80` blanks (editor tabulation: label field 12 wide, mnemonic field 5 wide).  Pure layout. |
| `FE`           | comment marker (shown as a black square in the editor, CP866 0xFE).  Same effect as `;` (used for headings/marked comments, some lines of "index" comments at the top of files). |
| `;`            | comment marker |
| other bytes    | plain text, CP866 (Cyrillic comments, strings in `db "..."`, ...) |

Line classes (see `tools/zasm_parse.py: parse_line`):

* empty line;
* **comment line**: starts with `;` or `FE`, **or** starts with anything that is not a label character / `06` (ZASM allows *bare* comment
  lines without `;` - mostly Russian prose; also a label followed by a literal blank and text, e.g. `X  text`);
* **code line**: `[label[:]] [06 pad] statement[:statement...] [;comment]`.  A label starts in column 0 (`[A-Za-z_$@.?][A-Za-z0-9_$@.?]*`, optional `:`).
  A label may be followed by literal blanks and then a token (`SPACEBORDER equ #7D`), by `06 NN`, or by end of line.
* statements are separated by `:`; the mnemonic token is glued to its operand in the file (`ld a,b:and 7` is stored with no blank after
  the token; the decoder inserts one blank after a mnemonic token when the next byte is not blank/`:`/`;`).
* Words in comments are tokenized too (a comment containing the word `hl` is stored as token `hl`); the original case of such words is lost (tokens are lower case).

## 2. Token table

In `za_3.10` (memory address #CB97 = file offset #661F) is one table of length-prefixed strings (prefix = 1 + string length),
terminated by `01 01`.  Token code = `0x20 + index`.  Complete table (166 entries, 0x20-0xC5):

```
20 ld   21 ex   22 im   23 rst  24 ret  25 add  26 adc  27 sub  28 sbc  29 and  2A xor  2B or   2C cp   2D push 2E pop  2F inc
30 dec  31 in   32 out  33 jp   34 call 35 jr   36 djnz 37 rlc  38 rrc  39 rl   3A rr   3B sla  3C sra  3D sli  3E srl  3F bit
40 res  41 set  42 nop  43 halt 44 di   45 ei   46 rlca 47 rla  48 rrca 49 rra  4A exx  4B daa  4C cpl  4D ccf  4E scf  4F ldi
50 ldir 51 ldd  52 lddr 53 cpi  54 cpir 55 cpd  56 cpdr 57 neg  58 inf  59 ini  5A inir 5B ind  5C indr 5D outi 5E otir 5F outd
60 otdr 61 reti 62 retn 63 rld  64 rrd  65 org  66 equ  67 db   68 dw   69 ds   6A defb 6B defw 6C defs 6D insert 6E include
6F if   70 ifdef 71 ifndef 72 ifused 73 ifnused 74 else 75 endif 76 make
-- operands (registers / conditions), codes 77..9A --
77 b 78 c 79 d 7A e 7B h 7C l 7D (hl) 7E a 7F xh 80 xl 81 yh 82 yl 83 (ix 84 (iy 85 (bc) 86 (de) 87 i 88 r 89 af 8A bc 8B de 8C hl
8D ix 8E iy 8F sp 90 (sp) 91 af' 92 (c) 93 nz 94 z 95 nc 96 c 97 po 98 pe 99 p 9A m
-- more directives / fused opcodes, 9B..C5 --
9B phase 9C unphase 9D dc 9E ent 9F rept A0 endr A1 loadtab A2 macro A3 endm A4 create A5 makelab A6 saveobj A7 exitm A8 ifp A9 exa
AA retz AB retnz AC retc AD retnc AE retm AF retp B0 retpo B1 retpe B2 jpz B3 jpnz B4 jpc B5 jpnc B6 jpm B7 jpp B8 jppo B9 jppe
BA callz BB callc BC callm BD callpe BE callnz BF callnc C0 callp C1 callpo C2 jrz C3 jrnz C4 jrc C5 jrnc
```

Notes: `(ix` / `(iy` are followed by `+d)` as plain text.  `sli` = undocumented `sll`; `inf` = `in f,(c)`; `exa` = `ex af,af'`;
`xh xl yh yl` = `ixh ixl iyh iyl`.  `retz`..`callnc` are fused opcode+condition tokens.
Unused-in-the-corpus tokens: `ifdef ifndef ifused ifnused loadtab dc` (never occur in the 97 sources).

Other string tables in `za_3.10` (UI texts, overlay names `compile edit_m setup service za_mon doctor za_print formater fnt_ed games
convert err_ed replace`, error messages in `compile`: "Invalid", "Alredy Defined", "JR out of Range", "Overflow" ...) are not needed for decoding.

## 3. Language semantics (verified by byte-exact rebuilds)

* **Expressions are evaluated strictly left to right, no operator precedence**: `YEND+1/2` = `(YEND+1)/2`, `$-1/16*16-$+16` = `((($-1)/16)*16)-$+16`.
  Operators: `+ - * /`, parentheses, unary minus.  Numbers: decimal, `#hex`, `%binary`, `"c"`/`"ab"` characters.  `$` = current address.
* **Postfix byte selectors**: `x.h` = high byte of x, `x.b` = low byte, `x.e` = low byte shifted left 8 ("expand": `L9C.e` turns the page number
  `L9C equ $.h` back into an address).  They bind to the primary immediately before (`(($-1).h).e`).
* **Multi-operand instructions**: `inc hl,de` = `inc hl : inc de`; the same for `dec push pop` (`pop af,bc,de,ix`, `push iy,de,bc,af`).
* **Auto labels** `$M<n> $J<n> $R<n> $P<n>`: created by the editor (marks / jump labels / ...); `create $M,29` reserves a family of 29.
  Converted to `ZM<n> ZJ<n> ZR<n> ZP<n>`.
* **Macros**: `NAME macro` ... `endm` (`exitm` leaves).  Parameters `=1`..`=9` in the body.  `ifp` = "if the first parameter was given",
  optional `else`, `endif`.  A macro is invoked by writing its name as a statement, arguments follow separated by blanks/commas.
  Macros may call macros (`ABSHL` -> `NEGHL`).  Macro files here: `MACRO`, `MACRO_`.
* `rept N` ... `endr` repeats the text (often written inline: `rept 6:rla:jrnc$+5:...:endr`).
* `include "NAME"` assembles the TR-DOS source file `NAME` (type `a`, exact name, case-sensitive: `vOXEL` and `VOXEL` are two different files).
* `insert "NAME.ext"` includes a binary file; TR-DOS name = `NAME`, type = first letter of `ext` (`VOX.dat` -> `VOX`, type `d`;
  `EFF.cod` -> type `c`; `DATAS.C` -> `DATAS`, type `C`; `ship.T` is type `T`, not `t`).
* `org A` sets the address; `phase A` ... `unphase` = assemble for address A but place the bytes at the current location (sjasmplus `DISP`/`ENT`).
  `ent A` = entry point marker (kept as a comment; **not** sjasmplus `ENT`).
* **Output control**: `make "F.C",A` ends the previous output file (everything emitted since the previous `make`) and starts a new one
  at address A (an implicit `org A`); `saveobj "F.C",A,len` writes the given memory range to a file right away;
  `makelab "LABELS"` writes all labels as `NAME equ value` into the TR-DOS source file `LABELS` (later `include`d when `ASM` is off).
* `if / else / endif`: the master files use `ASM equ ON` + `if ASM ... else insert "X.C" endif` so that big blocks can be skipped and loaded as
  already compiled binaries, with `LABELS` supplying their symbols.
* The assembler uses a 64K flat memory image, `phase`d code of one block may overlay other blocks (#C000 is reused by every overlay).
* Labels are case-sensitive in the corpus (mixed spellings occur in `awk6/XR2`, e.g. `L9e` vs `L9E`; each file is internally consistent).

Not present in the sources (so not analysed): `ifdef/ifndef/ifused/loadtab/dc/insert` of non-binary, `defb/defw/defs` (accepted as aliases of db/dw/ds).

## 4. Other ZASM files seen on the disks

| file | what it is |
|------|------------|
| `compile` (type `e`, 22 or 137 bytes, start 29298) | scratch file of the compile overlay (a fragment of line data); not part of the project |
| `LABELS` (type `a`) | output of `makelab`: `NAME equ decimal`, one per line |
| `METHOD` (awk3/awk4), `SPACE` (awk1), `DOS` (awk6) | project master files (list of includes + output control) |
| `D9000 D9200 CSTB KORNI VOX ...` (type `d`), `EFF`/`EFF1` (`c`), `FONT`/`PRO` (`f`), `EXPLOSIO`/`HIPERJMP` (`v`), `KSPO*` (`s`), `help ship skim C_SCENAR TREE` (`t`/`T`) | data blobs `insert`ed into the build |
| `sts6.2` (type `e`/`C`) | STS debugger (tool) |
| `CNVVOXVD`, `CNVVOXSP/TB/S3`, `OBJ>OBJ+`, `SCR>TOKN`, `PEREKOD`, `MAKEWAYS` | one-shot converter/generator programs of the author (voxel sprite converter, object converter, screen->token ...) |

## 5. Related formats found

* **STORM** (type `C`, start #C00B = 49163; disks awk2, awk5): lines stored back to front, fully tokenized incl. expressions.
  Decoded by `tools/storm_detok.py` (Python port of the algorithm in ZX-M8XXX `core/asm-detok.js`).  STORM postfix operators `[ ] ^ ` '`
  correspond to `.h .b round-up page-floor .e` (derived by comparing the STORM and ZASM versions of `XR2`).
* **Plain text sources** (awk4, type `C` with start == length): CR-terminated ASCII/CP866 text in STORM dialect (`INCL "X"` / `INCB "X"`).
  They are the text export of the STORM files (same content as awk2 for most modules).
* The ZASM versions of those STORM modules in awk4 (`LAND XR1 XR2 S3D VSPRITE ...`) were produced by ZASM's `convert` overlay and still contain
  unconverted STORM leftovers (`]`, `[`, `'`, numeric local labels `.8`) - intermediate, not buildable as is.
