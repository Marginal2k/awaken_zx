; ПРЕОБРАЗУЕМ ФОРМАТ 3D ОБЪЕКТА В МОДЕРНИ-
; ЗИРОВАННЫЙ
; НОМЕРА УЗЛОВ КРАТНЫ 5 КАК И БЫЛО
; НО НУЛЕВОЙ УЗЕЛ ТЕПЕРЬ #FB
; ПО ФОРМУЛЕ N=nega- 5
            org  #6000
            ld   hl,#8000
            ld   bc,0
            xor  a
            cpir 
            ld   a,c
            cpl  
            ld   c,a
            ld   a,b
            cpl  
            ld   b,a
            inc  bc
            ld   hl,#8000
M3:
            call FIND
            ret  po
            call FIND
            ret  po
M4:
            call FIND
            ret  po
            call TONUM
            or   a
            jr   z,M2
            call FIND
            call FIND
            call FIND
            jp   M4
M2:
            call FIND
            call TONUM
            and  #0F
            jr   z,M31
            exx  
            ld   b,a
M1:
            exx  
            call FIND
            call TONUM
            neg  
            sub  5
            call TOCHR
            dec  hl
            ld   (hl),e
            dec  hl
            ld   (hl),d
            inc  hl
            inc  hl
            exx  
            djnz M1
            exx  
            jp   M2
M31:
            call FIND
            ret  po
            jp   M3


TOCHR:
            push bc
            ld   c,a
            and  #0F
            cp   #0A
            ld   e,"0"
            jr   c,$+4
            ld   e,"0"+7
            add  a,e
            ld   e,a
            ld   a,c
            and  #F0
            rrca 
            rrca 
            rrca 
            rrca 
            cp   #0A
            ld   d,"0"
            jr   c,$+4
            ld   d,"0"+7
            add  a,d
            ld   d,a
            pop  bc
            ret  
TONUM:
            ld   a,(hl)
            inc  hl
            ld   e,"0"
            cp   "A"
            jr   c,$+4
            ld   e,"0"+7
            sub  e
            rlca 
            rlca 
            rlca 
            rlca 
            ld   d,a
            ld   a,(hl)
            inc  hl
            ld   e,"0"
            cp   "A"
            jr   c,$+4
            ld   e,"0"+7
            sub  e
            or   d
            dec  bc
            dec  bc
            ret  
FIND:
            ld   a,"#"
            cpir 
            ret  



            org  #8000
            incbin "OBJECTS_"

