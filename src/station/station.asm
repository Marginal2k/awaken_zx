;==============================================================================
; station.asm - сборка станции (главный файл, sjasmplus)
;
; Собирает четыре образа (savebin, пути - в build/station/):
;   STATIONF.C  #6000.. страница PGNORM: курсоры (#6000), код #6300 (BODYOCUR, OBR, OBR2), шрифт и
;               таблицы (SZTB, DATA_M), BODY, DOPPROC, PNT, [glue] LaunchFlight / LaunchStationSlot /
;               DiskSlotSave / LaunchEnding, OBJ, DATAT, OBJECT (Objvec)
;   LANG.C      #C000 страница PGLANG (#16): интерпретатор Paradox (LANG)
;   D3D.C       #C000 страница PG3D (#14): DATA3D, XR2, BODY3D, CLPXR1, OBJX + тексты кораблей
;   KARTA.C     #C000 страница PGKRT (#11): KARTA, DRAWLIN, CIRCMATH
;   HELP.C      #DB00 страница PGHLP (#17): HELP
; Склейка помечена [glue]: её нет в исходниках 1999 года (см. docs/ANALYSIS.md 12-14, src/common/).
; Константы: EQUS.asm, макросы: MACRO.asm. Таблица переименований: docs/STATION_LABELS.md.
;==============================================================================

            DEVICE ZXSPECTRUM128
            include "EQUS.asm"
            include "MACRO.asm"
            include "../common/disk.asm"

; Курсоры (спрайты, #6000..#62FF)
            org  #6000
            incbin "gen/KSPOplus.s"   ; GENERATED from assets/gfx/cursors.png

            org  #6300
            include "BODYOCUR.asm"
            include "OBR.asm"
            include "OBR2.asm"

            ent

END1
; Таблица ширин символов и шрифт
            org  SZTB
            incbin "gen/PRO.f"   ; GENERATED from assets/gfx/pro_font.png + pro_font_widths.csv

            include "DATA_M.asm"
LDAT:       equ  $-DATAM

            include "BODY.asm"
            include "DOPPROC.asm"
            include "PNT.asm"
; [glue] station -> flight launcher (not in the 1999 sources; see common/launcher.asm)
            include "../common/state.inc"
            include "../common/launcher.asm"
            LAUNCHER_ROUTINE LaunchFlight,"ACTION  C",#6000,FLIGHT_ENTRY,FLIGHT_STATE,TIME,0,1,0
; [glue] save/load slots (the TR-DOS calls are in common/disk.asm); loading a slot restarts the station
            LAUNCHER_ROUTINE LaunchStationSlot,"STATIONFC",#6000,STATION_ENTRY,STATE_BUF,TIME,1,1,1
            DISK_SLOT_SAVE_ROUTINE
; [glue] ending: FINALF is a self-contained program (code + graphics, no disk access); the demo's STATIONF started it from #7119.
; No trigger exists in the 1999 sources; LaunchEnding is the entry point, build.py --test-ending connects it to the "Вылет" button.
            LAUNCHER_ROUTINE LaunchEnding,"FINALF  C",#6000,#6000,STATE_BUF,TIME,0,1,0
END2
            include "OBJ.asm"
            include "DATAT.asm"

Objvec
            include "OBJECT.asm"


END_
            savebin "STATIONF.C",#6000,$-#6000      ; main image (loaded to #6000 by the previous stage)
MAKE_0:          equ  #C000
            org  MAKE_0
            include "LANG.asm"
END_L
            savebin "LANG.C",MAKE_0,$-MAKE_0
MAKE_1:          equ  #C000
            org  MAKE_1
            include "DATA3D.asm"
            ADRXX00
            include "XR2.asm"
            include "BODY3D.asm"
            include "CLPXR1.asm"

Objcts
            include "gen/OBJX.inc"   ; GENERATED from assets/models/station/*.txt
Eobj

TISHIP
; Описание кораблей и скиммеров (тексты gen/ship.tok, gen/skim.tok)
            db   ET
            incbin "gen/ship.tok"      ; GENERATED from assets/text/ships.txt
TISKIM:     equ  $-1
            incbin "gen/skim.tok"      ; GENERATED from assets/text/ships.txt

END_3D
            savebin "D3D.C",MAKE_1,$-MAKE_1
MAKE_2:          equ  #C000
            org  MAKE_2
            include "KARTA.asm"
            include "DRAWLIN.asm"
            include "CIRCMATH.asm"
            savebin "KARTA.C",MAKE_2,$-MAKE_2
MAKE_3:          equ  #DB00
            org  MAKE_3
            include "HELP.asm"
END_H

            savebin "HELP.C",MAKE_3,$-MAKE_3
