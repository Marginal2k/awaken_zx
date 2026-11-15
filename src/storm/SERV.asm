; MOUSE driver from zx-format
Directz db   0                  ; Fire
        db   0                  ; UP
        db   0                  ; DOWN
        db   0                  ; RIGHT
        db   0                  ; LEFT
        db   0                  ; Cancel
        db   0                  ; Medium
; Устанавливаются b 1 если нажато
Mports  dw   0                  ; Cords мыхи
Nondef  and  3
        jr   z,Mdrv4
        cp   1
        jr   z,Nondef_
        xor  a
        ld   (Mdrv3+2),a
        ld   a,5
        ld   (Mdrv2+2),a
Nondef_ ld   hl,0
        ld   (Mdrv1),hl
        pop  ix
; Main
Servms
        ld   a,0
        and  a
        ret  nz
        push ix
        ld   hl,Directz
        push hl
        pop  ix
        xor  a
        ld   (hl),a
        inc  hl
        ld   (hl),a
        inc  hl
        ld   (hl),a
        inc  hl
        ld   (hl),a
        inc  hl
        ld   (hl),a
        inc  hl
        ld   (hl),a
        inc  hl
        ld   (hl),a
        ld   bc,#FADF
        in   a,(c)
        cpl
Mdrv1   jr   Nondef
        rra
Mdrv2   rl   (ix+0)
        rra
Mdrv3   rl   (ix+5)
        rra
        rl   (ix+6)
Mdrv4   ld   hl,(Mcoord)
        ld   de,(Mports)
        ld   bc,#FBDF
        in   a,(c)
        ld   (Mports),a
        sub  e
        jr   z,Mdrv9
        jp   p,Mdrv6
        ld   (ix+4),1
Zcm3    add  a,a
        add  a,l
        jr   c,.Mdrv5
        xor  a
.Mdrv5  ld   l,a
        jr   Mdrv9
Mdrv6
Zcm4    add  a,a
        add  a,l
        ld   (ix+3),1
        jr   c,.Mdrv7
        cp   #FE
        jr   c,.Mdrv8
.Mdrv7  ld   a,#FE
.Mdrv8  ld   l,a
Mdrv9   ld   b,#FF
        in   a,(c)
        ld   (Mports+1),a
        sub  d
        jr   z,Mdrv14
        neg
        jp   p,Mdrv11
        ld   (ix+1),1
Zcm1    add  a,a
        add  a,h
        jr   c,.Mdrv10
        xor  a
.Mdrv10 ld   h,a
        jr   Mdrv14
Mdrv11
Zcm2    add  a,a
        add  a,h
        ld   (ix+2),1
        jr   c,.Mdrv12
        cp   #BF
        jr   c,.Mdrv13
.Mdrv12 ld   a,#BF
.Mdrv13 ld   h,a
Mdrv14  ld   (Mcoord),hl
        pop  ix
        ret
Servkj
        ; SERVICE kempston joystic
        ld   a,0                ; Flag
        and  a
        ret  nz
        in   a,(#1F)
        jp   Gomove

Servqa
        ; SERVICE qaop sp
        ld   e,0
        ld   c,#FE
        ld   hl,(KUP)
        ld   b,l
        in   a,(c)
        and  h
        jr   nz,$+4
        set  3,e                ; UP
        ld   hl,(KDOWN)
        ld   b,l
        in   a,(c)
        and  h
        jr   nz,$+4
        set  2,e                ; DOWN
        ld   hl,(KLEFT)
        ld   b,l
        in   a,(c)
        and  h
        jr   nz,$+4
        set  1,e                ; LEFT
        ld   hl,(KRIGHT)
        ld   b,l
        in   a,(c)
        and  h
        jr   nz,$+4
        set  0,e                ; RIGHT
        ld   hl,(KFIRE)
        ld   b,l
        in   a,(c)
        and  h
        jr   nz,$+4
        set  4,e                ; Fire
        ld   hl,(KCANCEL)
        ld   b,l
        in   a,(c)
        and  h
        jr   nz,$+4
        set  5,e                ; Cancel
        ld   a,e
Gomove
; Вы3ов проц. и3менения координаты b 3ав
; Ис
; Мости от нажатой кнопки

        ; И3меняются переменные состояния нажатия
        ; Каких либо клавиш LEFT,rihgt,UP,DOWN,F
        ; Ire,cancel
        ld   e,a
        ld   hl,Directj
        xor  a
        ld   d,a
        rrc  e
        adc  a,a
        or   (hl)
        ld   (hl),a
        inc  hl
        xor  a
        rrc  e
        adc  a,a
        or   (hl)
        ld   (hl),a
        inc  hl
        xor  a
        rrc  e
        adc  a,a
        or   (hl)
        ld   (hl),a
        inc  hl
        xor  a
        rrc  e
        adc  a,a
        or   (hl)
        ld   (hl),a
        inc  hl
        xor  a
        rrc  e
        adc  a,a
        or   (hl)
        ld   (hl),a
        inc  hl
        xor  a
        rrc  e
        adc  a,a
        or   (hl)
        ld   (hl),a

Cler
        ; Цбросить состояния предыдущего действия
        ld   hl,Directj
        xor  a
        dup  5
        ld   (hl),a
        inc  hl
        edup
        ld   (hl),a
        ret
Directj
        db   0                  ; RIGHT
        db   0                  ; LEFT
        db   0                  ; DOWN
        db   0                  ; UP
        db   0                  ; Fire
        db   0                  ; Cancel
