            create $P,54

            include "EQUS"
            include "MACRO"

КУРСОРЫ
            org  #6000
            insert "KSPO+.spr"

            org  #6300
            ent  $

            include "BODYOCUR"
            include "OBR"
            include "OBR2"

            unphase

END1
РАЗМЕР,ШРИФТ
            org  SZTB
            insert "PRO.fnt"

            include "DATA_M"
LDAT        equ  $-DATAM

            include "BODY"
            include "DOPPROC"
            include "PNT"
END2
            include "OBJ"
            include "DATAT"

Objvec
            include "OBJECT"


END
▒▒▒▒▒▒▒▒▒▒▒▒
            make "LANG.C",#C000
            include "LANG"
END_L
▒▒▒▒▒▒▒▒▒▒▒▒
            make "D3D.C",#C000
            include "DATA3D"
            ADRXX00
            include "XR2"
            include "BODY3D"
            include "CLPXR1"

Objcts
            include "OBJX"
Eobj

TISHIP
 ОПИСАНИЕ ПУНКТОВ ХЕЛПА
            db   ET
            insert "ship.T"
TISKIM      equ  $-1
            insert "skim.T"

END_3D
▒▒▒▒▒▒▒▒▒▒▒▒
            make "KARTA.C",#C000
            include "KARTA"
            include "DRAWLIN"
            include "CIRCMATH"
▒▒▒▒▒▒▒▒▒▒▒▒
            make "HELP.C",#DB00
            include "HELP"
END_H

