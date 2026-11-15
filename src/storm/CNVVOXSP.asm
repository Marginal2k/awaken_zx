        ; Перекодирует спрайт воксельный из
        ; Формата #0х в #хх
        org  #6000
        ld   de,#8000
        ld   bc,#0C00
M1
        ld   a,(de)
        ld   l,a
        dup  4
        rlca
        edup
        or   l
        ld   (de),a
        inc  de
        dec  bc
        ld   a,b
        or   c
        jp   nz,M1
        ret
        org  #8000
        incbin "assets/CHAN1.bin"
