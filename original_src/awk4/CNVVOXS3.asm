;ПЕРЕКОДИРУЕТ СПРАЙТ ВОКСЕЛЬНЫЙ ИЗ
;ФОРМАТА #0Х В #ХХ
;ПЛЮС ВЫРЕЗАЕТ СПРАЙТ РАЗМЕРОМ
        org #6000
        ld de,#8000
        ld hl,#C000
        ld b,32
M2
        push bc,hl
        ld b,14
M1
        ld a,(hl)
        ld c,a
        rlca:rlca:rlca:rlca
        or c
        ld (de),a
        inc hl,de
        djnz M1
        pop hl
        ld bc,64
        add hl,bc
        pop bc
        djnz M2
        ret
        org #C000
        insert "drv2.C"

