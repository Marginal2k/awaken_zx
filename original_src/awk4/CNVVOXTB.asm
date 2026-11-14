;ПРЕОБРАЗОВАНИЕ ФОРМАТА ХРАНЕНИЯ
;ВОКСЕЛЕЙ
        org #6000
        ld hl,#8000
        ld de,#C000
        ld bc,#0100
M1
        ld a,(hl):inc h
        inc d,d,d
        ld (de),a
        dec d,d,d
        ld a,(hl):inc h
        ld (de),a
        inc d,d
        ld a,(hl):inc h
        ld (de),a
        dec d
        ld a,(hl)
        ld (de),a
        dec d
        dec h,h,h
        inc l,e
        dec bc
        ld a,b:or c:jp nz,M1
        ret
        org #8000
        insert "VOX.C"
