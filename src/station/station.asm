            DEVICE ZXSPECTRUM128
            ; create $P,54   (ZASM auto-label family)

            include "EQUS.asm"
            include "MACRO.asm"
            include "../common/disk.asm"

; КУРСОРЫ
            org  #6000
            incbin "KSPOplus.s"

            org  #6300
            ; ent $   (ZASM entry point marker)

            include "BODYOCUR.asm"
            include "OBR.asm"
            include "OBR2.asm"

            ent

END1:
; РАЗМЕР,ШРИФТ
            org  SZTB
            incbin "PRO.f"

            include "DATA_M.asm"
LDAT:       equ  $-DATAM

            include "BODY.asm"
            include "DOPPROC.asm"
            include "PNT.asm"
END2:
            include "OBJ.asm"
            include "DATAT.asm"

Objvec:
            include "OBJECT.asm"


END_:
            savebin "STATIONF.C",#6000,$-#6000      ; main image (loaded to #6000 by the previous stage)
; ▒▒▒▒▒▒▒▒▒▒▒▒
MAKE_0:          equ  #C000
            org  MAKE_0
            include "LANG.asm"
END_L:
; ▒▒▒▒▒▒▒▒▒▒▒▒
            savebin "LANG.C",MAKE_0,$-MAKE_0
MAKE_1:          equ  #C000
            org  MAKE_1
            include "DATA3D.asm"
            ADRXX00
            include "XR2.asm"
            include "BODY3D.asm"
            include "CLPXR1.asm"

Objcts:
            include "OBJX.asm"
Eobj:

TISHIP:
;  ОПИСАНИЕ ПУНКТОВ ХЕЛПА
            db   ET
            incbin "ship.tok"
TISKIM:     equ  $-1
            incbin "skim.tok"

END_3D:
; ▒▒▒▒▒▒▒▒▒▒▒▒
            savebin "D3D.C",MAKE_1,$-MAKE_1
MAKE_2:          equ  #C000
            org  MAKE_2
            include "KARTA.asm"
            include "DRAWLIN.asm"
            include "CIRCMATH.asm"
; ▒▒▒▒▒▒▒▒▒▒▒▒
            savebin "KARTA.C",MAKE_2,$-MAKE_2
MAKE_3:          equ  #DB00
            org  MAKE_3
            include "HELP.asm"
END_H:

            savebin "HELP.C",MAKE_3,$-MAKE_3
