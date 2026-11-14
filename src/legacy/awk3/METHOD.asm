            ; create $M,29   (ZASM auto-label family)
            ; create $J,76   (ZASM auto-label family)
            ; create $R,10   (ZASM auto-label family)
            include "MACRO_.asm"
            include "EQUS_.asm"



            org  #A300


            ; ent $   (ZASM entry point marker)
            include "INIT_.asm"

; УПРАВЛЕНИЕ
            include "BODY_.asm"

END_:

; КЛИПИРОВАНИЕ
            include "CLIPMAT_.asm"
; ВСЕ 3Д
            include "3D-II_.asm"
            include "3D-I_.asm"

; ТАБЛИЦЫ
            ADRXX00
            include "3DTABS_.asm"
; ОБЪЕКТЫ
            include "OBJECTS_.asm"


