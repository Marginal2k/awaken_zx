;ПРЕОБРАЗОВАНИЕ ФОРМАТА ХРАНЕНИЯ
;ВОКСЕЛЕЙ
            org  #6000
            ld   hl,#8000
            ld   de,#C000
            ld   bc,#0100
M1:
            ld   a,(hl)
            inc  h
.3:         inc  d
            ld   (de),a
.3:         dec  d
            ld   a,(hl)
            inc  h
            ld   (de),a
.2:         inc  d
            ld   a,(hl)
            inc  h
            ld   (de),a
            dec  d
            ld   a,(hl)
            ld   (de),a
            dec  d
.3:         dec  h
            inc  l
            inc  e
            dec  bc
            ld   a,b
            or   c
            jp   nz,M1
            ret  
            org  #8000
            incbin "VOX"
