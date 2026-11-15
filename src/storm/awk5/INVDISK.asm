        org  #7000

        ld   c,1
        ld   a,1
        call #3D13

        ld   de,#0100
        ld   (#5CF4),de

        ld   b,159
M1
        push bc
        ld   de,(#5CF4)
        push de
        ld   bc,#8005
        ld   hl,#8000
        push hl
        call #3D13
        pop  hl
        ld   a,(hl)
        cpl
        ld   (hl),a
        inc  l
        jr   nz,$-4
        inc  h
        jr   nz,$-7
        ld   hl,#8000
        pop  de
        ld   bc,#8006
        call #3D13
        pop  bc
        djnz M1
        ret
