Vsline
        ; Check wisibility of line
        ; Cords of line in cordline bufer
        ld   hl,+(L9c*256)+1
        xor  a
        ex   af,af
        ld   b,10
Ld84    ld   c,#00
        ld   a,(hl)
        inc  l
        inc  l
        cp   #80
        jr   z,Ld85
        jr   nc,$+9
        and  a
        jp   nz,$+11
        jp   $+10
        set  1,c
        jp   $+5
        set  0,c
        ld   a,(hl)
        and  a
        jp   m,$+16
        jp   nz,$+18
        dec  l
        ld   a,(hl)
        inc  l
        cp   Yend+1
        jr   nc,$+10
        jp   $+10
        set  3,c
        jp   $+5
        set  2,c
        inc  l
        ld   a,c
        rlca
        rlca
        rlca
        rlca
        xor  #F0
        or   c
        ld   (hl),a
        ex   af,af
        or   (hl)
        ex   af,af
Ld83    inc  l
        ld   a,l
        inc  l
        cp   b
        jp   nz,Ld84
        ex   af,af
        ret
Ld85    inc  l
        ld   (hl),c
        jp   Ld83

Shmtrx
; Calc SHIP matrix vector
Eyea_   ld   a,0
        ld   h,Sintb
        ld   l,a
        ld   b,(hl)             ; Sin a
        add  a,#40
        ld   l,a
        ld   c,(hl)             ; Cos a
Eyeb_   ld   a,0
        ld   l,a
        ld   a,(hl)             ; Sin b
        ld   ixl,a
        ld   a,l
        add  a,#40
        ld   l,a
        ld   a,(hl)             ; Cos b
        ld   iyl,a
Eyeg_   ld   a,0
        ld   l,a
        ld   a,(hl)             ; Sin G
        ld   d,a
        ld   a,l
        add  a,#40
        ld   l,a
        ld   e,(hl)             ; Cos G
        ld   h,Multb
        ld   a,ixl
        sra  a
        ld   l,e
        sra  l
        sub  l
        ld   l,a
        add  a,e
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        ld   (Hm_13+1),a
        ld   a,iyl
        sra  a
        ld   l,b
        sra  l
        sub  l
        ld   l,a
        add  a,b
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        ld   ixh,a
        ld   a,ixl
        sra  a
        ld   l,c
        sra  l
        sub  l
        ld   l,a
        add  a,c
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        sra  a
        ld   l,d
        sra  l
        sub  l
        ld   l,a
        add  a,d
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        sub  ixh
        jp   po,$+9
        neg
        jp   po,$+4
        dec  a
        ld   (Hm_23+1),a
        ld   a,iyl
        sra  a
        ld   l,c
        sra  l
        sub  l
        ld   l,a
        add  a,c
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        ld   ixh,a              ; Cb*ca
        ld   a,ixl
        sra  a
        ld   l,b
        sra  l
        sub  l
        ld   l,a
        add  a,b
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        sra  a
        ld   l,d
        sra  l
        sub  l
        ld   l,a
        add  a,d
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        add  a,ixh
        jp   po,$+9
        neg
        jp   po,$+4
        dec  a
        ld   (Hm_33+1),a
        ret

Findobj
        ; Поиск первого по типу b d
        ; Fz-on if not found
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
Find2
        call Findob
        ret  z
        ld   a,(iy+Type)
        cp   d
        jp   nz,Find2
        inc  a
        ret
Fobj
        ; Find object
        ; Ret hl-obj ad+1
        ; Fz-on no in buf objs
        ; Fz-off found
        ld   hl,+(Carsb-OBJ_LEN)+1
        ld   bc,OBJ_LEN
        jr   $+8
        dec  l
        ld   a,(hl)
        cp   #80
        ret  z
        inc  l
        add  hl,bc
        ld   a,(hl)
        cp   #80
        jr   z,$-10
        ret
Fndfree
        ; Find free space
        ; Ret fz-on if not found
        ld   hl,+(Carsb-OBJ_LEN)+1
        ld   de,OBJ_LEN
Hhh3
        add  hl,de
        ld   a,(hl)
        cp   #80
        jr   nz,$-4
        dec  l
        ld   a,(hl)
        cp   #80
        ret  z
        ld   a,l
        add  a,Setup
        ld   l,a
        ld   a,(hl)
        ld   (hl),0
        inc  a
        ex   af,af
        ld   a,l
        sub  Setup-1
        ld   l,a
        ex   af,af
        jr   z,Hhh3
        ex   af,af
        dec  l
        ex   af,af
        ret
        ; 3Адать данные O в3рыве и осколках объе
        ; Кта
        ; makeexplo
        ld   l,(ix+Indi)
        ld   h,L97
        ld   a,(hl)
        inc  l
        ld   h,(hl)
        ld   l,a
        inc  hl
        ld   a,(hl)
        and  7
        ex   af,af
        ld   l,(ix+0)
        ld   h,(ix+1)
        ld   e,(ix+2)
        ld   d,(ix+3)
        ld   c,(ix+4)
        ld   b,(ix+5)
        ld   a,#10
        exx
        ld   hl,Nwvos
        call Newvspr
        ld   a,1
        ld   (Expl+1),a
        ld   a,(Cex+1)
        cp   #10
        jr   nc,$+7
        ld   a,#10
        ld   (Cex+1),a
        ld   a,(ix+Type)
        cp   #10
        jp   nc,.Jj11
        ld   hl,+(Carsb-OBJ_LEN)+1
        ld   a,3
.Jj12
        ex   af,af
        ld   de,OBJ_LEN
        add  hl,de
        ld   a,(hl)
        cp   #80
        jp   nz,$-4
        dec  hl
        ld   a,(hl)
        cp   #80
        jp   z,.Jj11
        ld   d,ixh
        ld   e,ixl
        ex   de,hl
        ldi
        ldi
        ldi
        ldi
        ldi
        ldi
        ld   a,Ioskol
        ld   (de),a
        inc  e
        inc  e
        inc  e
        inc  e
        ld   a,4
        ld   (de),a
        inc  e
        inc  e
        xor  a
        ld   (de),a
        inc  e
        ld   a,r
        ld   c,a
        ld   b,0
        ld   a,(bc)
        ld   (de),a
        inc  e
        inc  bc
        ld   a,(bc)
        ld   (de),a
        inc  e
        inc  e
        ld   a,r
        rlca
        or   #E0
        ld   (de),a             ; SPEED
        inc  e
        inc  e
        ld   a,#10
        ld   (de),a             ; Type
        inc  e
        ld   (de),a             ; Energy
        inc  e
        ld   a,#FF
        ld   (de),a
        inc  e
        ld   (de),a
        xor  a
        inc  e
        ld   (de),a
        ld   bc,+(0-Omode)+1
        ex   de,hl
        add  hl,bc
        ex   af,af
        dec  a
        jp   nz,.Jj12
.Jj11
        ld   (ix+0),0
        ld   (ix+1),#80
        ld   (ix+Setup),#FF     ; Если только
        ; Убили
        ; Explosion
        ld   hl,Eff0
        ld   (Sfxb+1),hl
        ret
Rastoy
        ; В3ять растояние кратное #100 от одного
        ; Объекта b ix до др. b iy
        ; Ret in a
        ld   e,(ix+0)
        ld   d,(ix+1)
        ld   l,(iy+0)
        ld   h,(iy+1)
        and  a
        sbc  hl,de
        jp   p,$+10
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        push hl
        ld   e,(ix+2)
        ld   d,(ix+3)
        ld   l,(iy+2)
        ld   h,(iy+3)
        and  a
        sbc  hl,de
        jp   p,$+10
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        push hl
        ld   e,(ix+4)
        ld   d,(ix+5)
        ld   l,(iy+4)
        ld   h,(iy+5)
        and  a
        sbc  hl,de
        jp   p,$+10
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        pop  de
        ld   a,h
        cp   d
        jr   nc,$+3
        ld   a,d
        pop  de
        cp   d
        ret  nc
        ld   a,d
        ret

; ------------------------
; Вывод линии b 3d пространстве
; ------------------------
Outline
        ; De-z1,hl-Y1,bc-X1
        ; De'-z2,hl'-y2,bc'-x2
        call Clc2d3d
        ret  nz
        ld   (L9c*256),hl
        ld   ((L9c*256)+2),de
        exx
        call Clc2d3d
        ret  nz
        ld   ((L9c*256)+5),hl
        ld   ((L9c*256)+7),de
        exx
        call Vsline
        ret  z
        ld   b,a
        cpl
        and  #F0
        ret  nz
        ld   a,b
        and  #0F
        ld   hl,Masklin
        jp   nz,Drwpol
        jp   Drwpol2            ; Draw poly.
Masklin
        db   %10110010, 0, 5, 0

; Плейер семплев
; Note2
; "Sfx"-is a loop, which contains
; Is a address of the sound effect
;
Sfxa
        ld   hl,0
        ld   a,h
        or   a
        jr   z,Sfxb
        ld   bc,PORT_AY_REG
        xor  a
        out  (c),a
        ld   b,#BF
        outi
        ld   b,#FF
        ld   a,1
        out  (c),a
        ld   b,#BF
        outi
        ld   b,#FF
        ld   a,7
        out  (c),a
        in   a,(c)
        and  %11110110
        or   (hl)
        ld   b,#BF
        out  (c),a
        inc  hl
        ld   a,8
        ld   b,#FF
        out  (c),a
        ld   b,#BF
        outi
        ld   (Sfxa+1),hl
        ld   a,(hl)
        or   a
        jr   nz,Sfxb
        ld   (Sfxa+2),a
        ld   b,#FF
        ld   a,7
        out  (c),a
        in   a,(c)
        or   %00001001
        ld   b,#BF
        out  (c),a
Sfxb
        ld   hl,0
        ld   a,h
        or   a
        jr   z,Sfxn
        ld   bc,PORT_AY_REG
        ld   a,2
        out  (c),a
        ld   b,#BF
        outi
        ld   b,#FF
        ld   a,3
        out  (c),a
        ld   b,#BF
        outi
        ld   b,#FF
        ld   a,7
        out  (c),a
        in   a,(c)
        and  %11101101
        ld   b,a
        ld   a,(hl)
        rlca
        or   b
        ld   b,#BF
        out  (c),a
        inc  hl
        ld   a,9
        ld   b,#FF
        out  (c),a
        ld   b,#BF
        outi
        ld   (Sfxb+1),hl
        ld   a,(hl)
        or   a
        jr   nz,Sfxn
        ld   (Sfxb+2),a
        ld   b,#FF
        ld   a,7
        out  (c),a
        in   a,(c)
        or   %00010010
        ld   b,#BF
        out  (c),a
Sfxn
        ld   c,#FD
        ld   b,#FF
        ld   a,5
        out  (c),a
        ld   b,#BF
        ld   a,#0C
        out  (c),a
        ld   b,#FF
        ld   a,7
        out  (c),a
        ld   a,r
        cp   #20
        jr   c,$+4
        ld   a,#20
        and  %00100000
        ld   l,a
        in   a,(c)
        and  %11011011
        or   l
        ld   b,#BF
        out  (c),a
        ld   a,6
        ld   b,#FF
        out  (c),a
        ld   b,#BF
        ld   a,5
        out  (c),a
        ld   a,10
        ld   b,#FF
        out  (c),a
        ld   b,#BF
Nunu    ld   a,0
        srl  a
        cp   4
        jr   nc,$+4
        ld   a,4
        out  (c),a
        ret
Roka
        db   20, 2, %00001000, 11
        db   1, 1, %00001000, 10
        db   20, 2, %00001000, 9
        db   1, 1, %00001000, 10
        db   20, 2, %00001000, 11
        db   1, 1, %00001000, 10, 0
Eff13
        db   20, 0, %00000000, 10
        db   10, 0, %00000000, 9
        db   20, 0, %00000000, 8
        db   10, 0, %00000000, 7
        db   20, 0, %00000000, 6
        db   10, 0, %00000000, 5, 0
Eff19
        db   80, 1, %00001000, 8
        db   70, 1, %00001000, 8
        db   60, 1, %00001000, 8
        db   80, 1, %00001000, 8
        db   70, 1, %00001000, 9
        db   60, 1, %00001000, 9
        db   80, 1, %00001000, 9
        db   70, 1, %00001000, 10
        db   60, 1, %00001000, 10
        db   80, 1, %00001000, 10
        db   70, 1, %00001000, 11
        db   60, 1, %00001000, 11
        db   80, 1, %00001000, 11
        db   70, 1, %00001000, 12
        db   60, 1, %00001000, 13
        db   70, 1, %00001000, 13, 0
Eff1
        db   40, 0, %00000000, 10
        db   50, 0, %00000000, 9
        db   40, 0, %00000000, 8
        db   50, 0, %00000000, 7
        db   40, 0, %00000000, 6
        db   50, 0, %00000000, 5, 0
Eff14
        db   20, 1, %00000000, 10
        db   10, 1, %00000000, 9
        db   20, 1, %00000000, 8
        db   10, 1, %00000000, 7
        db   20, 1, %00000000, 6
        db   10, 1, %00000000, 5, 0
Eff2
        ; Shoot1
        db   #10, 1, %00001000, 12
        db   #40, 1, %00001000, 11
        db   #70, 1, %00001000, 10
        db   #20, 2, %00001000, 9
        db   #E0, 2, %00001000, 8
        db   #20, 3, %00001000, 7, 0

Eff0
        ; Explosion
        db   #10, 8, %00001000, 15
        db   #10, 8, %00001001, 15
        db   #10, 8, %00000000, 15
        db   #80, 8, %00000000, 15
        db   #10, 8, %00000001, 15
        db   #80, 7, %00001001, 15
        db   #80, 7, %00000001, 15
        db   #80, 5, %00000001, 15
        db   #80, 4, %00000000, 14
        db   #80, 3, %00000001, 14
        db   1, 0, %00000001, 14
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000000, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000000, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 10
        db   1, 0, %00000001, 9
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 7
        db   1, 0, %00000001, 6
        db   1, 0, %00000001, 5
        db   1, 0, %00000001, 4
        db   1, 0, %00000001, 3, 0

Eff11
        db   100, 2, 4, 9
        db   100, 3, 4, 7
        db   100, 2, 4, 5
        db   100, 3, 4, 4
        db   100, 2, 4, 2
        db   100, 3, 4, 1, 0

Eff21
        db   200, 1, 32, 12
        db   2, 0, 0, 11
        db   50, 0, 0, 12
        db   50, 0, 4, 7
        db   50, 0, 4, 1, 0
