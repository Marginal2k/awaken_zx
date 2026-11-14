
            org  #6000
;  ПЕРЕКОДИРОВЩИК ТЕКСТА ОБЫЧНОГО В СВОЙ
;  ФОРМАТ, КОНЕЦ ТЕКСТА 0
;  СИМВОЫ:
;"@"-КОНЕЦ АБЗАЦА, ЗАНИМ ПРОПУСКАЕТСЯ
;    ЕЩЕ И ЕНТЕР
;"#"-КОНЕЦ ТЕКСТА ПРОПИСЫВАЕМ ET
;    ПРОПУСКАЕМ ДВА ЕНТЕРА
;  ЕНТЕР - ЗАМЕНЯЕМ НА ПРОБЕЛ

CR:         equ  #0D
ET:         equ  #0A

            ld   hl,TXT
            ld   de,TXT2
M4:
            ld   a,(hl)
            and  a
            jr   z,M3
            cp   #0D
            jr   nz,M1
            ld   a," "
            ld   (de),a
            inc  de
            inc  hl
            jr   M4
M1:
            cp   "@"
            jr   nz,M2
            ld   a,CR
            ld   (de),a
            inc  de
            inc  hl
            inc  hl
            jr   M4
M2:
            cp   "#"
            jr   nz,M9
            ld   a,ET
            ld   (de),a
            inc  hl
            inc  hl
            inc  hl
            inc  de
            jr   M4
M9:
            ldi  
            jp   M4
M3:
            ld   a,ET
            ld   (de),a
            inc  de
            ld   hl,TXT2
            ex   de,hl
            and  a
            sbc  hl,de
            ld   (#BFFE),hl
            ret  

            org  #8000
TXT:
            incbin "help.t"
            db   0
            org  #C000
TXT2:

