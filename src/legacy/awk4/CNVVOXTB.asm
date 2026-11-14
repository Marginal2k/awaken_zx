;ПРЕОБРАЗОВАНИЕ ФОРМАТА ХРАНЕНИЯ
;ВОКСЕЛЕЙ
            org  #6000
            ld   hl,#8000
            ld   de,#C000
            ld   bc,#0100
M1:
            ld   a,(hl)
            inc  h
            inc  d
            inc  d
            inc  d
            ld   (de),a
            dec  d
            dec  d
            dec  d
            ld   a,(hl)
            inc  h
            ld   (de),a
            inc  d
            inc  d
            ld   a,(hl)
            inc  h
            ld   (de),a
            dec  d
            ld   a,(hl)
            ld   (de),a
            dec  d
            dec  h
            dec  h
            dec  h
            inc  l
            inc  e
            dec  bc
            ld   a,b
            or   c
            jp   nz,M1
            ret  
            org  #8000
            incbin "VOX.C"
