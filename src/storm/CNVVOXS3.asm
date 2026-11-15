        ; Перекодирует спрайт воксельный из
        ; Формата #0х в #хх
        ; Плюс вырезает спрайт размером
        org  #6000
        ld   de,#8000
        ld   hl,#C000
        ld   b,32
M2
        push bc
        push hl
        ld   b,14
M1
        ld   a,(hl)
        ld   c,a
        dup  4
        rlca
        edup
        or   c
        ld   (de),a
        inc  hl
        inc  de
        djnz M1
        pop  hl
        ld   bc,64
        add  hl,bc
        pop  bc
        djnz M2
        ret
        org  #C000
        incbin "assets/drv2.bin"
