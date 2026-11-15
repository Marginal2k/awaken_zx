        ; Преобразование формата хранения
        ; Вокселей
        org  #6000
        ld   hl,#8000
        ld   de,#C000
        ld   bc,#0100
M1
        ld   a,(hl)
        inc  h
        dup  3
        inc  d
        edup
        ld   (de),a
        dup  3
        dec  d
        edup
        ld   a,(hl)
        inc  h
        ld   (de),a
        dup  2
        inc  d
        edup
        ld   a,(hl)
        inc  h
        ld   (de),a
        dec  d
        ld   a,(hl)
        ld   (de),a
        dec  d
        dup  3
        dec  h
        edup
        inc  l
        inc  e
        dec  bc
        ld   a,b
        or   c
        jp   nz,M1
        ret
        org  #8000
        incbin "assets/VOX.bin"
