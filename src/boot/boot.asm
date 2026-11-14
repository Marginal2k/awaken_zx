; ------------------------------------------------------------------------------------------
; boot.asm - TR-DOS boot program "boot" (BASIC):   10 REM <machine code>   20 RANDOMIZE USR 23872
; Replaces the v0.2 demo's AWAKEN.B (which carried the intro animation as a payload inside the BASIC file; see
; docs/ANALYSIS.md).  It loads the intro (INTRO.C, src/boot/intro.asm) to #6400 and starts it at #6500; the intro
; shows the animation and then loads the station part (STATIONF) and starts it at #6300.
; ------------------------------------------------------------------------------------------
            DEVICE ZXSPECTRUM48
            include "../common/disk.asm"
            include "../common/state.inc"

; With TR-DOS paged in, PROG = #5D3B (23867); the REM body starts at PROG+5 = #5D40 = 23872.
BASIC_PROG  equ  23867                  ; PROG under TR-DOS (sysvar PROG at 23635 holds this value)
INTRO_ORG   equ  #6400
INTRO_ENT   equ  #6500

            org  BASIC_PROG
            db   0,10                   ; line 10 (big endian)
            dw   LINE10_END-LINE10      ; line length
LINE10:     db   #EA                    ; REM
START:
            di
            ld   sp,#5FFF
            ld   iy,#5C3A
            xor  a
            out  (#FE),a                ; black border
            xor  a
            ld   (STATE_FLAG),a         ; [glue] cold start: no state record to take over
            IFDEF NO_INTRO              ; test disk (build.py makes awaken_nointro.trd): straight to the station
            DISK_LOAD NAME_INTRO,#6000
            jp   #6300
NAME_INTRO:
            db   "STATIONFC"
            ELSE
            DISK_LOAD NAME_INTRO,INTRO_ORG
            jp   INTRO_ENT
NAME_INTRO:
            db   "INTRO   C"
            ENDIF
; TR-DOS reads the catalogue into a 256-byte buffer just behind the BASIC program (#5D3B + program length).  The intro's
; tail stub is copied to #5D3B and calls TR-DOS from there (code up to #5D9F), so the program is padded (as the 119-byte AWAKEN.B was) to keep the buffer
; behind the stub (the demo's much longer AWAKEN.B had the same effect).
            ds   48,#20
            db   13
LINE10_END:
            db   0,20                   ; line 20: RANDOMIZE USR 23872
            dw   LINE20_END-LINE20
LINE20:     db   #F9,#C0
            db   "23872"
            db   #0E,0,0
            dw   START
            db   0,13
LINE20_END:
PROG_END:
            db   #80,#AA,20,0           ; TR-DOS BASIC trailer: autostart line 20
            savebin "AWAKEN.B",BASIC_PROG,$-BASIC_PROG
