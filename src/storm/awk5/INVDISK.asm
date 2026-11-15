        include "HW.asm"

        org  #7000

        ld   c,1
        ld   a,1
        call TRDOS_COMMAND

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
        call TRDOS_COMMAND
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
        call TRDOS_COMMAND
        pop  bc
        djnz M1
        ret
