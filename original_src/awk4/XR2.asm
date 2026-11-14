
;HAЧaЛO ПpoЦeДУpbЫBOДaПЛOCKOCTИ
;MUST BE ONLY FROM #XX00
Lc5
;TEXTURES: TEXTURE, xorMASK
        dw #0000
        dw #AA88
        dw #FFAA
        dw #55EE
        dw #00FF


MERZ
        ld a,(P00stur)
        xor %00110000
;ЧETЫPEX УГOЛЬhЫe
        ld (P00stur),a
        ld (P00trd),a
        ld (P00turi),a
;TPEX УГOЛЬhЫe
        ld a,(P00istr)
        xor %00110000
        ld (P00istr),a
        ld (P01istr),a
        ret

;ОБЩАЯ ИНИЦИАЛИЗАЦИЯ
INIT_
        xor a
        ld l,a
        ld h,a
        ld (Eye_a),hl
        ld (Eye_g),a
        ld hl,ADI3D_
        ld de,L97
        ld bc,#0100
        ldir
        ret



        org $`+#C0
E2
.31     ld (bc),a:inc c
MSK     xor #00
        exa
        ld a,LY
        ld l,a
        ld a,(bc)
        and (hl)
        inc l
        or (hl)
        ld (bc),a
Lc608   inc h
        res 1,h
        exx
        add ix,bc
        jr c,JJJ1
JJJ2
        ld a,l
Lc616   sub #00
        jr nc,$+6
Lc61a   add a,#00
        add ix,sp
        ld l,a
        add iy,de
        ld a,h
Lc622   sub #00
        jr nc,$+6
Lc626   add a,#00
        add iy,sp
        ld h,a
        exx


        ld a,d
BORD    cp #00
JUMP    jr nc,Lc66b


NXTE
        inc d
        ld a,LX
        ld l,a
        ld a,HX
        ld c,a
        sub HY
        jr nc,Lc654
        add a,a
        ld ($+11),a
        ld a,(bc)
        and (hl)
        inc l
        or (hl)
        ld (bc),a
        inc c
        exa
        jp Lc5

Lc654
        jr nz,VB1
        ld a,(hl)
        ld e,LY
        ld l,e
        or (hl)
        inc l
        ld e,a
        cpl
        and (hl)
        ld l,a
        ld a,(bc)
        and e
        or l
        ld (bc),a
VB1
        exa
MSK2    xor #00
        exa
        jp Lc608

JJJ1    exx:inc b:exx:jp JJJ2

Lc66b
JMP1    equ $-JUMP-2
        ld sp,#0000
        pop hl
        ret

Lc66e
JMP3    equ $-JUMP-2
        jp Lc6c0



;------------
Lc6b9   ld a,(Lc6cc)
        ld l,a
        jp Lc67f
Lc671
JMP2    equ $-JUMP-2
        ld l,d
        push hl

        ld hl,#0000
Lc675   equ $-#0002
        dec l
        ld e,(hl)
        inc l
Lc67b   dec l
        jr z,Lc6b9
        dec l
Lc67f   ld a,(hl)
        sub d
        jr z,Lc67b
        jr c,Lc67b
        ld (Lc675),hl
        ld d,a
        ld (Lc61a+1),a
        srl a
        exx
        ld l,a
        exx
        ld a,(hl)
        ld (Lc632+1),a
        dec l
        ld a,(hl)
        sub e
        jp c,Lc76a
        cp d
        jp c,Lc763
        ld e,a
        xor a

.8      rl e:rla:sub d:jr nc,$+3:add a,d
        rl e

        and a
        jr z,Lc75e
        sub d
        neg
        ld (Lc616+1),a
        ld a,e
        neg
        srl a
        exx
        ld c,#00
        rr c
        rra
        rr c
        rra
        rr c
        add a,#20
        ld b,a
        exx
        pop hl
        ld d,l,a,d
        jp Lc635

Lc75e
        ld (Lc616+1),a
        ld a,e
        cpl
        rra
        exx
        ld c,#00
        rr c
        sra a
        rr c
        sra a
        rr c
        add a,#20
        ld b,a
        exx
        pop hl
        ld d,l,a,d
        jp Lc635

Lc763   sub d
        neg
        ld (Lc616+1),a
        exx
        ld c,#20
        ld b,c
        exx
        pop hl
        ld d,l,a,d
        jp Lc635

Lc76a   neg
        cp d
        jr c,Lc7b1
        ld e,a
        xor a

.8      rl e:rla:sub d:jr nc,$+3:add a,d
        rl e

        ld (Lc616+1),a
        ld a,e
        inc a
        scf
        rra
        exx
        ld c,#00
        rr c
        sra a
        rr c
        sra a
        rr c
        add a,#20
        ld b,a
        exx
        pop hl
        ld d,l
        ld a,d

Lc635   ld l,#00
        cp l
        jp c,NXTE2
        ld a,l
        ld (BORD+1),a
        ld a,JMP3
        ld (JUMP+1),a
        ld a,d
        jp BORD;Lc635

Lc7b1
        ld (Lc616+1),a
        exx
        ld c,#00
        ld b,#20
        exx
        pop hl
        ld d,l
        ld a,d
        jp Lc635



;-----------
Lc70b   ld l,#01
        jp Lc6d1
Lc6c0
        ld l,d
        push hl
        ld hl,#0000
Lc6c4   equ $-#0002
        dec l
        ld e,(hl)
        inc l
Lc6ca   ld a,l
        cp #00
Lc6cc   equ $-#0001
        jr z,Lc70b
        inc l
        inc l
Lc6d1   ld a,(hl)
        sub d
        jr z,Lc6ca
        jr c,Lc6ca
        ld (Lc6c4),hl
        ld d,a
        ld (Lc626+1),a
        srl a
        exx
        ld h,a
        exx
        ld a,(hl)
        ld (Lc635+1),a
        dec l
        ld a,(hl)
        sub e
        jp c,Lc76al
        cp d
        jp c,Lc763l
        ld e,a
        xor a

.8      rl e:rla:sub d:jr nc,$+3:add a,d
        rl e

        and a
        jr z,Lc625l
        sub d
        neg
        ld (Lc622+1),a
        ld a,e
        neg
        srl a
        exx
        ld e,#00
        rr e
        rra
        rr e
        rra
        rr e
        add a,#20
        ld d,a
        exx
        pop hl
        ld d,l
        jp NXTE2

Lc625l
        ld (Lc622+1),a
        ld a,e
        cpl
        rra
        exx
        ld e,#00
        rr e
        sra a
        rr e
        sra a
        rr e
        add a,#20
        ld d,a
        exx
        pop hl
        ld d,l
        jp NXTE2

Lc763l  sub d
        neg
        ld (Lc622+1),a
        exx
        ld e,#20
        ld d,e
        exx
        pop hl
        ld d,l
        jp NXTE2

Lc76al  neg
        cp d
        jp c,Lc7b1l
        ld e,a
        xor a

.8      rl e:rla:sub d:jr nc,$+3:add a,d
        ld (Lc622+1),a

        ld a,e
        rla
        inc a
        scf
        rra
        exx
        ld e,#00
        rr e
        sra a
        rr e
        sra a
        rr e
        add a,#20
        ld d,a
        exx
        pop hl
        ld d,l

NXTE2
Lc62d   ld l,#00
Lc632   ld e,#00
        ld a,e:cp l
        jr c,NXTE3
        ld a,(Lc635+1)
        cp l:jr c,NXTE4
        ld a,l
        ld (BORD+1),a
        ld a,JMP1
        ld (JUMP+1),a
        jp NXTE
NXTE3
        ld a,(Lc635+1)
        cp e
        jr c,NXTE4
        ld a,e
        ld (BORD+1),a
        ld a,JMP2
        ld (JUMP+1),a
        jp NXTE
NXTE4
        ld (BORD+1),a
        ld a,JMP3
        ld (JUMP+1),a
        jp NXTE

Lc7b1l
        ld (Lc622+1),a
        exx
        ld e,#00
        ld d,#20
        exx
        pop hl
        ld d,l
        jp NXTE2








Lc7b4   exa
        ld l,a
        exa
        inc l
        jp Lc7f7
Lc7bb   ld l,#01
        jp Lc807


LLC     pop hl:ret

Polygon
        push hl
        ld a,(L91+#0A)
        ld b,a
        dec a
        ld (Lc6cc),a
        exa
        srl b
;ПОИСК МИН. И МАКС. ПО У УЗЛА
;ret
;e,d-МАКС, МИН
;c-МЛ.БАЙТ АДРЕСА МИН УЗЛА
        ld hl,L9e'+1
        ld de,#FF00
Lc7d2
        ld a,(hl):cp d
        jp nc,$+5:ld d,a
        ld c,l
        cp e
        jp c,$+4:ld e,a
        inc l,l
        djnz Lc7d2
        ld a,e:cp d:jr z,LLC
        ld (Lc62d+1),a
        ld a,d
        ld (Lc632+1),a
        ld (Lc635+1),a
        ld b,d
        ld l,c
Lc7f3   ld e,l
        dec l
        jr z,Lc7b4
Lc7f7   dec l
        cp (hl)
        jr z,Lc7f3
        ld l,e
        ld (Lc675),hl
        ld l,c
Lc800   ld e,l
        exa
        cp l
        jr z,Lc7bb
        inc l,l
Lc807   exa
        cp (hl)
        jr z,Lc800
        ld l,e
        ld (Lc6c4),hl
        ld a,(L91+#1A)
        add a,a
        ld c,a
        ld h,Lc5[
        ld l,a
        ld a,(hl)
        exa
        inc l
        ld a,(hl)
        ld (MSK+1),a
        ld (MSK2+1),a
        ld hl,(Lc675)
        dec l
        ld e,(hl)
        xor a
        srl b
        rr e
        rra
        srl b
        rr e
        rra
        scf
        rr b
        rr e
        rra
        add a,c
        ld LX,a
        ld HX,e
        ld hl,(Lc6c4)
        dec l
        ld e,(hl)
        xor a
        srl d
        rr e
        rra
        srl d
        rr e
        rra
        scf
        rr d
        rr e
        rra
        add a,c
        add a,#10
        ld LY,a
        ld HY,e
        ld h,L90k[
        ld (Lc66b+1),sp

        ld a,(Lc62d+1)
        ld e,a
        ld a,(Lc632+1)
        ld d,a
        cp e:jp nc,Lc66b
        ld (BORD+1),a
        ld a,JMP2
        ld (JUMP+1),a

        ld a,d
        ld sp,#FFE0
        jp BORD


RETT
        exx
        ld hl,0:add hl,sp
        ld a,l
        ld (Adt+1),a
        exx
Stkc    ld sp,0
        ret


;RENDER OBJ 2
Renobj2
        ld a,(Eye_b)
        ld b,a
        ld a,(Eyeb)
        sub b
        ld b,a
        add a,#40
        ld h,Sintb
        ld l,a
        ld a,(hl);COS
        ld (Om1_11+1),a
        ld (Om2_11+1),a
        ld l,b
        ld a,(hl);SIN
        ld (Om1_13+1),a
        ld (Om2_13+1),a
        ld a,(Indx)
        ld l,a
        ld h,L97[
        ld a,(hl)
        inc l
        ld h,(hl)
        ld l,a
        inc hl
;makeJUMP FOR MULTIPLY
        ld b,(hl)
        res 7,b
        ld a,#06
        sub b
        ld (Jmp4+1),a
        ld (Jmp5+1),a
        ld (Jmp6+1),a

        inc hl

        ld (Stkc+1),sp

        ld sp,L9c'+4

Ld534   ld a,(hl)
        inc hl
        or a:jr z,RETT
        ld LX,a
        ld b,(hl)
        inc hl
        ld c,(hl)
        inc hl
        ld d,(hl)
        inc hl

        ld (STORHL+1),hl

;REND FROM THIS DOT
;b,c,d-X,Y,z
;LX-COLOR andAMOUNT DOTS
        ld h,Multb
Om1_11  ld a,0
        sra a:ld l,b:sra l:sub l:ld l,a
        add a,b:ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        exa
Om1_13  ld a,0
        sra a:ld l,d:sra l:sub l:ld l,a
        add a,d:ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        ld l,b
        ld b,a
Om2_13  ld a,0
        neg
        sra a:sra l
        ld e,l
        sub l:ld l,a
        add a,e:ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        ld HX,a
Om2_11  ld a,0
        sra a:ld l,d:sra l:sub l:ld l,a
        add a,d:ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        ld HY,a

;RENDER ITSSELF FROM DOT


        ld l,c
        ld h,b
        exa:ld b,a

        add a,h:ld h,a
        ld d,l
        ld (Xb0+1),hl
        exa

        rlc b
        rlc c

        ld a,h:sub b:ld h,a
        ld (Xb1+1),hl

        ld a,l:sub c:ld l,a
        ld (Xb2+1),hl


        exa:ld h,a
        ld (Xb3+1),hl


;neg
        neg:ld h,a
        ld e,h
        ld (Xb5+1),hl

        ld a,h:add a,b:ld h,a
        ld (Xb4+1),hl

        ld l,d
        ld (Xb7+1),hl

        ld h,e
        ld (Xb6+1),hl


        ld b,LX
        ld a,HY
        ld d,HX
        add a,d
        ld HX,a
        rlc d
        sub d
        ld HY,a
        ld LY,a
        add a,d
        ld LX,a
        neg
        ld (Zb5+1),a
        add a,d
        ld (Zb4+1),a
        ld (Zb6+1),a
        sub d
        ld (Zb7+1),a

Xb0     ld de,0
        ld a,HX
        bit 0,b
        ld hl,$+6
        jp nz,Calcd;TAKE 1ST setDOT
Xb1     ld de,0
        ld a,HY
        bit 1,b
        ld hl,$+6
        jp nz,Calcd;REND OF z
Xb2     ld de,0
        ld a,LY
        bit 3,b
        ld hl,$+6
        jp nz,Calcd;REND OF X
        bit 2,b
Xb3     ld de,0
        ld a,LX
        ld hl,$+6
        jp nz,Calcd;REND OF zBACK
Xb4     ld de,0
Zb6     ld a,0
        bit 6,b
        ld hl,$+6
        jp nz,Calcd;REND OF Y
Xb5     ld de,0
Zb7     ld a,0
        bit 7,b
        ld hl,$+6
        jp nz,Calcd;REND OF z
Xb6     ld de,0
Zb5     ld a,0
        bit 5,b
        ld hl,$+6
        jp nz,Calcd;REND OF X BACK
Xb7     ld de,0
Zb4     ld a,0
        bit 4,b
        ld hl,$+6
        jp nz,Calcd;NOT REND OF ZBACK

STORHL  ld hl,0
        jp Ld534



;CALCULATION DOTS FROM SETTING BITS MASK
;И ПEPEBOД 3D CORDS in2D CORDS
Calcd
        exx
Tz      ld de,0
        ld l,a
        rlca
        and 1
        neg
        ld h,a
Jmp4    jr $
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        and a
        adc hl,de

        jp m,Ld73d

        ex de,hl
        exx
        ld a,e
        exx
        ld l,a
        rlca
        and 1
        neg
        ld h,a
Ty      ld bc,0
Jmp5    jr $
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        and a
        adc hl,bc
        jp p,$+10
        ld a,l
        cpl
        ld l,a
        ld a,h
        cpl
        ld h,a
        inc hl
        exa
;DIV
        ld a,d:or a:jp z,PP0
        xor a
        sli l:rl h:jr c,PP1
        sli l:rl h:jr c,PP1+6
        sli l:rl h:jr c,PP1+6*2
        sli l:rl h:jr c,PP1+6*3
        sli l:rl h:jr c,PP1+6*4
        sli l:rl h:jr c,PP1+6*5
        sli l:rl h:jr c,PP1+6*6
        sli l:rl h:jr c,PP1+6*7
        sli l:rl h:jr c,PP1+6*8
        sli l:rl h:ld b,l:jr c,PP1+6*9+1
        sli l:rl h:jr c,PP1+6*10+1
        sli l:rl h:jr c,PP1+6*11+1
        sli l:rl h:jr c,PP1+6*12+1
        sli l:rl h:jr c,PP1+6*13+1
        sli l:rl h:jr c,PP1+6*14+1
        sli l:rl h:jp c,PP1+6*15+1
;ZERO
        ld b,a
        jp PP9

PP1
        rla:cp d
        jr nc,PP2:adc hl,hl
        rla:cp d
        jr nc,PP2+7:adc hl,hl
        rla:cp d
        jr nc,PP2+7*2:adc hl,hl
        rla:cp d
        jr nc,PP2+7*3:adc hl,hl
        rla:cp d
        jr nc,PP2+7*4:adc hl,hl
        rla:cp d
        jr nc,PP2+7*5:adc hl,hl
        rla:cp d
        jr nc,PP2+7*6:adc hl,hl
        rla:cp d
        jr nc,PP2+7*7:adc hl,hl
        rla:ld b,l:cp d
        jr nc,PP2+7*8:adc hl,hl
        rla:cp d
        jr nc,PP2+7*9:adc hl,hl
        rla:cp d
        jr nc,PP2+7*10:adc hl,hl
        rla:cp d
        jr nc,PP2+7*11:adc hl,hl
        rla:cp d
        jr nc,PP2+7*12:adc hl,hl
        rla:cp d
        jr nc,PP2+7*13:adc hl,hl
        rla:cp d
        jr nc,PP2+7*14:adc hl,hl
        rla:ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+63+7*6



PP2

        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP3
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*2
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*3
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*4
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*5
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*6
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*7
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+8*8-1

        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+63+7
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+63+7*2
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+63+7*3
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+63+7*4
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp PP4+63+7*5


PP0
        ld a,l
        ld l,h
        ld h,0
        sbc hl,de
        jp nc,Ld73d
        add hl,de
        rla
        adc hl,hl
PP3
        sbc hl,de
        jp nc,Ld73d
        add hl,de
        rla
        adc hl,hl
PP4
        sbc hl,de:jr nc,$+3:add hl,de
        rla
        adc hl,hl
        sbc hl,de:jr nc,$+3:add hl,de
        rla
        adc hl,hl
        sbc hl,de:jr nc,$+3:add hl,de
        rla
        adc hl,hl
        sbc hl,de:jr nc,$+3:add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        ld b,a
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
PP9

        ld c,a
        exa
        ld hl,#30;MIDLE Y
        jp m,$+8
        sbc hl,bc
        jp $+4
        add hl,bc

        push hl
        exx
        ld a,d
        exx
        ld l,a
        rlca
        and 1
        neg
        ld h,a
Tx      ld bc,0
Jmp6    jr $
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        and a
        adc hl,bc
        jp p,$+10
        ld a,l
        cpl
        ld l,a
        ld a,h
        cpl
        ld h,a
        inc hl
        exa
;DIV
        ld a,d:or a:jp z,O0
        xor a
        sli l:rl h:jr c,O1
        sli l:rl h:jr c,O1+6
        sli l:rl h:jr c,O1+6*2
        sli l:rl h:jr c,O1+6*3
        sli l:rl h:jr c,O1+6*4
        sli l:rl h:jr c,O1+6*5
        sli l:rl h:jr c,O1+6*6
        sli l:rl h:jr c,O1+6*7
        sli l:rl h:jr c,O1+6*8
        sli l:rl h:ld b,l:jr c,O1+6*9+1
        sli l:rl h:jr c,O1+6*10+1
        sli l:rl h:jr c,O1+6*11+1
        sli l:rl h:jr c,O1+6*12+1
        sli l:rl h:jr c,O1+6*13+1
        sli l:rl h:jr c,O1+6*14+1
        sli l:rl h:jp c,O1+6*15+1
;ZERO
        ld b,a
        jp O9

O1
        rla:cp d
        jr nc,O2:adc hl,hl
        rla:cp d
        jr nc,O2+7:adc hl,hl
        rla:cp d
        jr nc,O2+7*2:adc hl,hl
        rla:cp d
        jr nc,O2+7*3:adc hl,hl
        rla:cp d
        jr nc,O2+7*4:adc hl,hl
        rla:cp d
        jr nc,O2+7*5:adc hl,hl
        rla:cp d
        jr nc,O2+7*6:adc hl,hl
        rla:cp d
        jr nc,O2+7*7:adc hl,hl
        rla:ld b,l:cp d
        jr nc,O2+7*8:adc hl,hl
        rla:cp d
        jr nc,O2+7*9:adc hl,hl
        rla:cp d
        jr nc,O2+7*10:adc hl,hl
        rla:cp d
        jr nc,O2+7*11:adc hl,hl
        rla:cp d
        jr nc,O2+7*12:adc hl,hl
        rla:cp d
        jr nc,O2+7*13:adc hl,hl
        rla:cp d
        jr nc,O2+7*14:adc hl,hl
        rla:ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+63+7*6



O2

        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O3
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*2
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*3
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*4
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*5
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*6
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*7
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+8*8-1

        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+63+7
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+63+7*2
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+63+7*3
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+63+7*4
        ld c,a
        ld a,l
        ld l,h
        ld h,c:jp O4+63+7*5


O0
        ld a,l
        ld l,h
        ld h,0
        sbc hl,de
        jp nc,Ld73c
        add hl,de
        rla
        adc hl,hl
O3
        sbc hl,de
        jp nc,Ld73c
        add hl,de
        rla
        adc hl,hl
O4
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        adc hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        ld b,a
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
        add hl,hl
        sbc hl,de
        jr nc,$+3
        add hl,de
        rla
O9
        ld c,a
        exa
        ld hl,#0080;MIDLE X
        jp m,$+13
        sbc hl,bc
        push hl
        ld hl,9
        add hl,sp
        ld sp,hl
        exx
        jp (hl)
        add hl,bc
        push hl
        ld hl,9
        add hl,sp
        ld sp,hl
        exx
        jp (hl)

;ECЛИ bcЯKИeПEPEПOЛHEHИЯ
Ld73d
        push de
        ld d,#80
        push de
        ld hl,9
        add hl,sp
        ld sp,hl
        exx
        jp (hl)
Ld73c
        ld d,#80
        push de
        ld hl,9
        add hl,sp
        ld sp,hl
        exx
        jp (hl)











;DRAW POLY
Drwpol
        ld a,(hl)
        and a
        ret z
        jp m,Ld8b2
        and #0F
        ld b,a
        call Vspoly
        jp p,Ld8a5
        xor a;MAY BE VISIBLE POLY
        ld (L91+#5A),a
        call Lda9f
        jr c,Ld8aa
        cpl
        and #F0
        jr nz,Ld8aa
        ld a,(hl)
        inc hl
.4      rrca
        and #07
        ld (L91+#1A),a
        ld a,c
        and #0F
        jr nz,Ld89a
        ld de,L9e' 
        ld a,b
        add a,a
        ld (L91+#0A),a
        ld b,L9c
        rrca
        ex af,af
        ld c,(hl)
        inc hl
        ld a,(bc)
        ld (de),a
        inc e
        inc c
        inc c
        ld a,(bc)
        ld (de),a
        inc e
        ex af,af
        dec a
        jp nz,$-13
        call Polygon
        jp Drwpol
Ld89a   call Clip
        call nc,Polygon
        jp Drwpol
Ld8a5   ld a,#01;UNVISIBLE POLY
        ld (L91+#5A),a
Ld8aa   inc b
        ld c,b
        ld b,#00
        add hl,bc
        jp Drwpol



;LINE DRAWING
Ld8b2   and #0F
        ld b,a
        bit 6,(hl)
        jr z,Ld8bf;ALWAYS VISIBLE
        ld a,(L91+#5A)
        and a
        jr nz,Ld8aa;LAST POLY WAS
;UNVISIBLE
;ifLAST POLY VIS THAT LINES VIS TOO
Ld8bf   dec b
        ld a,(hl)
        inc hl
        and #30
        jr z,Ld8d2;andMASK
        cp #10
        jr z,Ld8da;orMASK
;xorMASK
;COMAND xorc:jrc,
        ld de,#38A9
        ld a,Ld1l]
        jp Ld8df
;COMAND andc:jrnc,
Ld8d2   ld de,#30A1
        ld a,Ld1l]+8
        jp Ld8df
;COMAND orc:jrc,
Ld8da   ld de,#38B1
        ld a,Ld1l]
Ld8df   ld (L91+#4E),de
        ld (Ldadd),a
        ld HX,L9c
        ld a,(hl)
        ld LX,a
        inc hl
        ld e,(ix+#00)
        ld d,(ix+#01)
        ld (L91+#3E),de
        ld e,(ix+#02)
        ld d,(ix+#03)
        ld (L91+#4A),de
        ld a,(ix+#04)
        ld (L91+#4D),a
Ld907   ld a,(hl)
        ld LX,a
        inc hl
        push bc
        push hl
        ld hl,(L91+#3E)
        ld (L91+#3A),hl
        ld hl,(L91+#4A)
        ld (L91+#3C),hl
        ld a,(L91+#4D)
        ld (L91+#4C),a
        ld b,a
        ld e,(ix+#00)
        ld d,(ix+#01)
        ld (L91+#3E),de
        ld e,(ix+#02)
        ld d,(ix+#03)
        ld (L91+#4A),de
        and a
        ld a,(ix+#04)
        ld (L91+#4D),a
        jr z,Ld967
        and a
        jr z,Ld967
        or b
        ld b,a
        cpl
        and #F0
        jr nz,Ld967
        ld a,b
        and #0F
        jr nz,Ld96e
        ld a,(L91+#3A)
        ld (L91+#2A),a
        ld a,(L91+#3C)
        ld (L91+#2B),a
        ld a,(L91+#3E)
        ld (L91+#2C),a
        ld a,(L91+#4A)
        ld (L91+#2D),a
Ld964   call Drwlin;LDABE
Ld967   pop hl
        pop bc
        djnz Ld907
        jp Drwpol
Ld96e   ld hl,(L91+#3A)
        ld (L91+#0B),hl
        ld hl,(L91+#3C)
        ld (L91+#0D),hl
        ld a,(L91+#4C)
        ld (L91+#0F),a
        ld hl,(L91+#3E)
        ld (L91+#1B),hl
        ld hl,(L91+#4A)
        ld (L91+#1D),hl
        ld a,(L91+#4D)
        ld (L91+#1F),a
        push ix
        call CLIPLIN
        pop ix
        jr nz,Ld967
        ld hl,L9e*256
        ld a,(hl)
        inc l
        ld (L91+#2A),a
        ld a,(hl)
        inc l
        ld (L91+#2B),a
        ld a,(hl)
        inc l
        ld (L91+#2C),a
        ld a,(hl)
        ld (L91+#2D),a
        jp Ld964




Drwpol2
        ld a,(hl)
        and a
        ret z
        jp m,Ld9ea
        and #0F
        ld b,a
        call Vspoly
        jp p,Ld9dd
        xor a
        ld (L91+#5A),a
        ld a,(hl)
        inc hl
.4      rrca
        and #07
        ld (L91+#1A),a
        ld de,L9e' 
        ld a,b
        add a,a
        ld (L91+#0A),a
        ld b,L9c
        rrca
        ex af,af
        ld c,(hl)
        inc hl
        ld a,(bc)
        ld (de),a
        inc e
        inc c
        inc c
        ld a,(bc)
        ld (de),a
        inc e
        ex af,af
        dec a
        jp nz,$-13
        call Polygon
        jp Drwpol2
Ld9dd   ld a,#01
        ld (L91+#5A),a
Ld9e2   inc b
        ld c,b
        ld b,#00
        add hl,bc
        jp Drwpol2
Ld9ea   and #0F
        ld b,a
        bit 6,(hl)
        jr z,Ld9f7
        ld a,(L91+#5A)
        and a
        jr nz,Ld9e2
Ld9f7   dec b
        ld a,(hl)
        inc hl
        and #30
        jr z,Lda0a
        cp #10
        jr z,Lda12
        ld de,#38A9
        ld a,Ld1l]
        jp Lda17
Lda0a   ld de,#30A1
        ld a,Ld1l]+8
        jp Lda17
Lda12   ld de,#38B1
        ld a,Ld1l]
Lda17   ld (L91+#4E),de
        ld (Ldadd),a
        ld d,L9c
        ld e,(hl)
        inc hl
        ld a,(de)
        ld (L91+#2C),a
        inc e
        inc e
        ld a,(de)
        ld (L91+#2D),a
Lda2c   ld d,L9c
        ld e,(hl)
        inc hl
        push bc
        push hl
        ld hl,(L91+#2C)
        ld (L91+#2A),hl
        ld a,(de)
        ld (L91+#2C),a
        inc e
        inc e
        ld a,(de)
        ld (L91+#2D),a
        call Drwlin;LDABE
        pop hl
        pop bc
        djnz Lda2c
        jp Drwpol2
Lda9f   ld LX,b
        push hl
        ex de,hl
        inc de
        ld h,L9c
        ld c,#00
Ldaa8   ld a,(de)
        inc de
        add a,#04
        ld l,a
        ld a,(hl)
        and a
        jr z,Ldab9
        or c
        ld c,a
        djnz Ldaa8
        pop hl
        ld b,LX
        ret
Ldab9   scf
        pop hl
        ld b,LX
        ret



;DRAW LINE FROM SOME CORDS
Drwlin
        ld hl,(L91+#2A)
        ld de,(L91+#2C)
        and a
        sbc hl,de
        ret z
        add hl,de
;DRAW LINE CORDS inhl,de
;h,d-Y : l,e-X
Drawl1
        ld (Ldbbb),sp
        ld sp,#0020
        ld a,d
        sub h
        jr nc,Ldad8
        ex de,hl
        neg
Ldad8   ld d,a
        ld a,l
        and #07
        add a,#00
Ldadd   equ $-#0001
        ld c,a
        ld a,Ld1l[
        adc a,#00
        ld b,a
        ld a,(bc)
        ld c,a
        ld a,l
        srl h
        rr l
        srl h
        rr l
        scf
        rr h
        rr l
        sub e
        jr c,Ldb59
        cp d
        jr c,Ldb2d
        ld e,d
        ld d,a
        ld b,a
        srl a
        ex af,af
;PUT INSIDE COMAND FOR THIS LINE
        ld a,(L91+#4E);COMAND 1
        ld (Ldb0d),a
        ld a,(L91+#4F);COMAND 2
        ld (Ldb10),a
        ld a,(hl)
Ldb0d   nop
        rlc c
Ldb10   jr c,Ldb1d
Ldb12   ex af,af
        sub e
        jr c,Ldb23
        ex af,af
        djnz Ldb0d
        ld (hl),a
        jp Ldbba
Ldb1d   ld (hl),a
        dec l
        ld a,(hl)
        jp Ldb12
Ldb23   add a,d
        ex af,af
        ld (hl),a
        add hl,sp
        ld a,(hl)
        djnz Ldb0d
        jp Ldbba
Ldb2d   ld e,a
        ld a,d
        ld b,d
        srl a
        ex af,af
        ld a,(L91+#4E)
        ld (Ldb40),a
        ld a,(L91+#4F)
        ld (Ldb4a),a
Ldb3f   ld a,(hl)
Ldb40   nop
        ld (hl),a
        add hl,sp
        ex af,af
        sub e
        jr nc,Ldb4c
        add a,d
        rlc c
Ldb4a   jr c,Ldb52
Ldb4c   ex af,af
        djnz Ldb3f
        jp Ldbba
Ldb52   dec l
        ex af,af
        djnz Ldb3f
        jp Ldbba
Ldb59   neg
        cp d
        jr c,Ldb91
        ld e,d
        ld d,a
        ld b,a
        srl a
        ex af,af
        ld a,(L91+#4E)
        ld (Ldb71),a
        ld a,(L91+#4F)
        ld (Ldb74),a
        ld a,(hl)
Ldb71   nop
        rrc c
Ldb74   jr c,Ldb81
Ldb76   ex af,af
        sub e
        jr c,Ldb87
        ex af,af
        djnz Ldb71
        ld (hl),a
        jp Ldbba
Ldb81   ld (hl),a
        inc l
        ld a,(hl)
        jp Ldb76
Ldb87   add a,d
        ex af,af
        ld (hl),a
        add hl,sp
        ld a,(hl)
        djnz Ldb71
        jp Ldbba
Ldb91   ld e,a
        ld a,d
        ld b,d
        srl a
        ex af,af
        ld a,(L91+#4E)
        ld (Ldba4),a
        ld a,(L91+#4F)
        ld (Ldbae),a
Ldba3   ld a,(hl)
Ldba4   nop
        ld (hl),a
        add hl,sp
        ex af,af
        sub e
        jr nc,Ldbb0
        add a,d
        rrc c
Ldbae   jr c,Ldbb6
Ldbb0   ex af,af
        djnz Ldba3
        jp Ldbba
Ldbb6   inc l
        ex af,af
        djnz Ldba3
Ldbba   ld sp,#0000
Ldbbb   equ $-#0002
        ret






;CALC VISIBLE MASK FOR POLYGON
Vsmask
        push hl
        xor a
        ex af,af
        ld hl,L9c*256+1
Adt     ld a,0
        sub 4
        ld b,a
Ld814   ld c,#00
        ld a,(hl)
        inc l
        inc l
        cp #80
        jr z,Ld85d
        jr nc,Ld826
        and a
        jp nz,Ld82b
        jp Ld82d
Ld826   set 1,c
        jp Ld82d
Ld82b   set 0,c
Ld82d   ld a,(hl)
        and a
        jp m,Ld83f
        jp nz,Ld844
        dec l
        ld a,(hl)
        inc l
        cp #60
        jr nc,Ld844
        jp Ld846
Ld83f   set 3,c
        jp Ld846
Ld844   set 2,c
Ld846   inc l
        ld a,c
        rlca
        rlca
        rlca
        rlca
        xor #F0
        or c
        ld (hl),a
        ex af,af
        or (hl)
        ex af,af
        inc l
        ld a,l
        inc l
        cp b
        jp nz,Ld814
        pop hl
        ex af,af
        ret
Ld85d   pop hl
        xor a
        ret


;VISIBILITY POLYGON
;retFS-mPOLY VISIBLE
Vspoly
        push bc
        push hl
        inc hl
        cp #05
        jr nc,Lda5b
        ld d,(hl)
        inc hl
        ld e,(hl)
        inc hl
        ld a,(hl)
        jp Lda62
Lda5b   ld d,(hl)
        inc hl
        inc hl
        ld e,(hl)
        inc hl
        inc hl
        ld a,(hl)
Lda62   ld h,L9c
        ld l,d
        ld (Lda7a),sp
        ld sp,hl
        pop bc
        exx
        pop bc
        exx
        ld l,e
        ld sp,hl
        pop de
        exx
        pop de
        exx
        ld l,a
        ld sp,hl
        pop hl
        exx
        pop hl
        ld sp,#0000
Lda7a   equ $-#0002
        sbc hl,bc
        ex de,hl
        sbc hl,bc
        push hl
        exx
        sbc hl,bc
        ex de,hl
        sbc hl,bc
        ex (sp),hl
        exx
        pop hl
        call Mull
        push hl
        push de
        exx
        call Mull
        ex de,hl
        pop bc
        sbc hl,bc
        ex de,hl
        pop bc
        sbc hl,bc
        pop hl
        pop bc
        ret




