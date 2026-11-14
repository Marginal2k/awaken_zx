        include "EQUS"



        org #FF00
        jp INIT_;ИНИТ 3D
        jp OUTAL2_;ВЫВОД 3D
        jp NXTO_;ДЛЯ ВЫХОДА ИЗ ВОКСЕЛЕЙ
        dw ADI3D_;ТАБЛИЦА АДРЕСОВ ОБЪЕКТ
        jp Moveon;ВЫЧИСЛ. ПРИРАШ. ИЗМЕН
        jp Precord;ИЗМ. КООРД. ОБЪЕКТОВ
        jp Nulmove;ОЧИСТ.ПРИРАЩЕНИЯ ИЗМ.
        jp Fline;РИСОВАТЬ ЛАЗЕР ИГРОКА


        org #C000
L90k
        insert "D9000.C"

Eye_a   equ #C200
Eye_b   equ #C201
Eye_g   equ #C202
Eyea    equ #C203
Eyeb    equ #C204
Eyeg    equ #C205

L91     equ #C221
L90     equ #C200

        ds #0100

Multb   equ $.h
Sintb   equ Multb+1
        insert "D9200.C"
L9c     equ $.h
        ds #0100
L9d     equ $.h
        ds #0100
L9e     equ $.h
        ds #0100
;TAБЛИЦaДЛЯ ПOДCEЧETA KOPHЯ
;ПEPBЫЙ БaЙT KOPEHЬ И3 "kpУГЛoГo" ЧИcЛa
;BTOP. cЛOBO ИHBEPTHУTOE ПO 3HAKУ ЧИcЛO
; KAK OCTATOK
Korn
        insert "korni.C"


        include "XR2"


            ADRXX00
L95
        db Lceb1.b
        db Lcdf6.b
        db Lcdcd.b
        db 0
        db Lcda4.b
        db Lc903.b
        db Lc91d.b
        db 0
        db Lcd7b.b
        db Lc937.b
        db Lc951.b
        db 0,0,2,0,1
        db Lc96b.b
        db Lc902.b
        db Lc971.b
        db 0
        db Lc977.b
        db Lc912.b
        db Lc989.b
        db 0
        db Lc9a1.b
        db Lc9b3.b
        db Lc9ba.b
        db 0,0,0,0,0
        db Lc9cc.b
        db Lc9d2.b
        db Lc902.b
        db 0
        db Lc9d8.b
        db Lc9ea.b
        db Lc9fc.b
        db 0
        db Lca03.b
        db Lca15.b
        db Lc960.b
        ds 21
        db Lca2d.b
        db Lca33.b
        db Lca45.b
        db 0
        db Lc902.b
        db Lca57.b
        db Lc92c.b
        db 0
        db Lca5e.b
        db Lca64.b
        db Lca79.b
        db 0,0,0,0,0
        db Lca94.b
        db Lcab0.b
        db Lcab7.b
        db 0
        db Lcad6.b
        db Lc902.b
        db Lcae1.b
        db 0
        db Lcae7.b
        db Lcec8.b
        db Lcafc.b
        db 0,0,0,#0A,#90
        db Lcb15.b
        db Lcb31.b
        db Lcb46.b
        db 0
        db Lcb51.b
        db Lcec8.b
        db Lc902.b
        db 0
        db Lcb58.b
        db Lcb77.b
        db Lcb90.b
        ds 21
        db Lcb96.b
        db Lcb9c.b
        db Lcbae.b
        db 0
        db Lcbc0.b
        db Lcbc6.b
        db Lcbe1.b
        db 0
        db Lc902.b
        db Lc946.b
        db Lcbf6.b
        db 0,#82,#72,#3C,#7F
        db Lcbfd.b
        db Lcc19.b
        db Lcc24.b
        db 0
        db Lcc39.b
        db Lcc58.b
        db Lcc5e.b
        db 0
        db Lcc77.b
        db Lc902.b
        db Lcec8.b
        db #15,#0A,#1C,#1D,#A4
        db Lcc7e.b
        db Lcc9a.b
        db Lccb9.b
        db 0
        db Lccc0.b
        db Lccd5.b
        db Lcec8.b
        db 0
        db Lccee.b
        db Lccf9.b
        db Lc902.b

            ADRXX00
L96
        db Lceb1.h
        db Lcdf6.h
        db Lcdcd.h
        db 0
        db Lcda4.h
        db Lc903.h
        db Lc91d.h
        db 0
        db Lcd7b.h
        db Lc937.h
        db Lc951.h
        db 0,0,0,0,0
        db Lc96b.h
        db Lc902.h
        db Lc971.h
        db 0
        db Lc977.h
        db Lc912.h
        db Lc989.h
        db 0
        db Lc9a1.h
        db Lc9b3.h
        db Lc9ba.h
        db 0,#55,1,0,0
        db Lc9cc.h
        db Lc9d2.h
        db Lc902.h
        db 0
        db Lc9d8.h
        db Lc9ea.h
        db Lc9fc.h
        db 0
        db Lca03.h
        db Lca15.h
        db Lc960.h
        ds 21
        db Lca2d.h
        db Lca33.h
        db Lca45.h
        db 0
        db Lc902.h
        db Lca57.h
        db Lc92c.h
        db 0
        db Lca5e.h
        db Lca64.h
        db Lca79.h
        db 0,0,2,0,0
        db Lca94.h
        db Lcab0.h
        db Lcab7.h
        db 0
        db Lcad6.h
        db Lc902.h
        db Lcae1.h
        db 0
        db Lcae7.h
        db Lcec8.h
        db Lcafc.h
        db 0,0,0,0,0
        db Lcb15.h
        db Lcb31.h
        db Lcb46.h
        db 0
        db Lcb51.h
        db Lcec8.h
        db Lc902.h
        db 0
        db Lcb58.h
        db Lcb77.h
        db Lcb90.h
        ds 21
        db Lcb96.h
        db Lcb9c.h
        db Lcbae.h
        db 0
        db Lcbc0.h
        db Lcbc6.h
        db Lcbe1.h
        db 0
        db Lc902.h
        db Lc946.h
        db Lcbf6.h
        db #20,#B2,0,0,#64
        db Lcbfd.h
        db Lcc19.h
        db Lcc24.h
        db 0
        db Lcc39.h
        db Lcc58.h
        db Lcc5e.h
        db 0
        db Lcc77.h
        db Lc902.h
        db Lcec8.h
        db 0,0,0,0,0
        db Lcc7e.h
        db Lcc9a.h
        db Lccb9.h
        db 0
        db Lccc0.h
        db Lccd5.h
        db Lcec8.h
        db 0
        db Lccee.h
        db Lccf9.h
        db Lc902.h
        db 0,0,0,0,0

;bcЯKИeMACKИ
Ld1l
        dw #4080
        dw #1020
        dw #0408
        dw #0102
        dw #BF7F
        dw #EFDF
        dw #FBF7
        dw #FEFD




Sets2   db 0
Sets    db 0
Indx    db 0
Objx    dw 0
Objy    dw 0
Objz    dw 0
Speed   dw 0

Indt1   db 0
Indt2   db 0






        include "XCLP"
        include "XR1"


OUTAL2_
        ld a,(Cmode+1):or a
        jr nz,OO1
        ld a,(SPEED)
        or a:ld h,#00:jp p,$+4:dec h
        ld l,a
        ADDHLHL 6
        ld (Speed),hl
OO1
        ld a,(UNGLE):ld c,a
        ld a,(Eye_b)
        add a,c
        ld (Eye_b),a
        call Moveu
        call Ren3d
        call MERZ
        ret



;ПpoЦeДУpЫ УПPABЛEHИЯ KOPAБЛEM, OПpeДeЛ
;EHИeeГO
;CTOЛKHOBEHИЙ

Moveu
        call Touch;GOING THROUGH STA
;T OBJECTS
        jp Calcstp
Touch
Cmode   ld a,0
        dec a
        ret m
        ld (Cmode+1),a
        ret
Lm1
;СТОЛКНОВЕНИЕ С ОБЪЕКТОМ
        ld a,(Cmode+1):or a:ret nz
        ld a,4
        ld (Cmode+1),a
        ld a,(SPEED):neg
        ld (SPEED),a
        ld hl,(Speed)
        call NEGHL
        ld (Speed),hl
        ld hl,(XPL+1)
        call NEGHL
        ld (XPL+1),hl
        ld hl,(YPL+1)
        call NEGHL
        ld (YPL+1),hl
        ld hl,(ZPL+1)
        call NEGHL
        ld (ZPL+1),hl
        ret

NEGHL   ld a,l:cpl:ld l,a
        ld a,h:cpl:ld h,a:inc hl:ret




;YOUR TURNS
Calcstp
        ld a,(Sm_13+1)
        ld de,(Speed)
        ld ix,$+7
        jp MULL
        ld (XPL+1),hl
        bit 7,h
        ld de,(XXP):add hl,de
        ld (XXP),hl
        ld a,(XXP+2)
        jr z,$+6:sbc a,0
        jr $+4:adc a,0
        ld (XXP+1),a
        ld a,(Sm_23+1)
        ld de,(Speed)
        ld ix,$+7
        jp MULL
        ld (YPL+1),hl
        bit 7,h
        ld de,(YYP):add hl,de
        ld (YYP),hl
        ld a,(YYP+2)
        jr z,$+6:sbc a,0
        jr $+4:adc a,0
        ld (YYP+1),a
        ld a,(Sm_33+1)
        ld de,(Speed)
        ld ix,$+7
        jp MULL
        ld (ZPL+1),hl
        bit 7,h
        ld de,(ZZP):add hl,de
        ld (ZZP),hl
        ld a,(ZZP+2)
        jr z,$+6:sbc a,0
        jr $+4:adc a,0
        ld (ZZP+1),a
        ret






Korni
;de-CTAPШaЯ ЧACTЬ ЧИcЛa
;reta-MEAN
        ld a,d
        and a
        jr z,Kor
        ld l,a
        ld h,Korn.h
        ld a,(hl)
        inc h
        ld c,a
        cpl
        exa
        ld b,#FF
        inc bc
        sla c
        rl b
        dec bc
        ld a,(hl)
        inc h
        ld h,(hl)
        ld l,a
        exa
        add hl,de
      rept 5:add hl,bc:ret nc:dec bc,bc:inc a:endr
        add hl,bc
        ret nc
        inc a
        ret
Kor
;ПOДcЧET KOPHЯ БE3 TAБЛИЦЫ, ДЛЯ MAЛEHЬK
;ИX ДAHHЫX
;de-DATA <2116
;a-MEAN
        ex de,hl
        ld bc,0-1
        xor a
     rept 14:add hl,bc:ret nc:inc a:dec bc,bc:endr
        add hl,bc
        ret nc
        inc a
        ret





Vsline
;CHECK WISIBILITY OF LINE
;CORDS OF LINE inCORDLINE BUFER
        ld hl,L9c*256+1
        xor a
        exa
        ld b,10
Ld84    ld c,#00
        ld a,(hl)
        inc l
        inc l
        cp #80
        jr z,Ld85
        jr nc,$+9
        and a
        jp nz,$+11
        jp $+10
        set 1,c
        jp $+5
        set 0,c
        ld a,(hl)
        and a
        jp m,$+16
        jp nz,$+18
        dec l
        ld a,(hl)
        inc l
        cp #60
        jr nc,$+10
        jp $+10
        set 3,c
        jp $+5
        set 2,c
        inc l
        ld a,c
        rlca
        rlca
        rlca
        rlca
        xor #F0
        or c
        ld (hl),a
        exa
        or (hl)
        exa
Ld83    inc l
        ld a,l
        inc l
        cp b
        jp nz,Ld84
        exa
        ret
Ld85    inc l
        ld (hl),c
        jp Ld83





Shmtrx
;CALC SHIP MATRIX VECTOR
Eyea_   ld a,0
        ld h,Sintb
        ld l,a
        ld b,(hl);SIN a
        add a,#40
        ld l,a
        ld c,(hl);COS a
Eyeb_   ld a,0
        ld l,a
        ld a,(hl);SIN b
        ld xl,a
        ld a,l
        add a,#40
        ld l,a
        ld a,(hl);COS b
        ld yl,a
Eyeg_   ld a,0
        ld l,a
        ld a,(hl);SIN G
        ld d,a
        ld a,l
        add a,#40
        ld l,a
        ld e,(hl);COS G
        ld h,Multb
        ld a,xl
        sra a
        ld l,e
        sra l
        sub l
        ld l,a
        add a,e
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        ld (Hm_13+1),a
        ld a,yl
        sra a
        ld l,b
        sra l
        sub l
        ld l,a
        add a,b
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        ld xh,a
        ld a,xl
        sra a
        ld l,c
        sra l
        sub l
        ld l,a
        add a,c
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        sra a
        ld l,d
        sra l
        sub l
        ld l,a
        add a,d
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        sub xh
        jp po,$+9
        neg
        jp po,$+4
        dec a
        ld (Hm_23+1),a
        ld a,yl
        sra a
        ld l,c
        sra l
        sub l
        ld l,a
        add a,c
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        ld xh,a;CB*CA
        ld a,xl
        sra a
        ld l,b
        sra l
        sub l
        ld l,a
        add a,b
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        sra a
        ld l,d
        sra l
        sub l
        ld l,a
        add a,d
        ld e,(hl)
        ld l,a
        ld a,(hl)
        sub e
        add a,xh
        jp po,$+9
        neg
        jp po,$+4
        dec a
        ld (Hm_33+1),a
        ret






;------------------------
;bЫBOД ЛИhИИ b3D ПPOCTPAHCTBE
;------------------------
Outline
;de-Z1,hl-Y1,bc-X1
;DE'-Z2,HL'-Y2,BC'-X2
        call Clc2d3d
        ret nz
        ld (L9c*256),hl
        ld (L9c*256+2),de
        exx
        call Clc2d3d
        ret nz
        ld (L9c*256+5),hl
        ld (L9c*256+7),de
        exx
        call Vsline
        ret z
        ld b,a
        cpl
        and #F0
        ret nz
        ld a,b
        and #0F
        ld hl,Masklin
        jp nz,Drwpol
        jp Drwpol2;DRAW POLY.
Masklin
        db %10110010,0,5,0







;И3MEHЯEM KOOPДИHATЫ,3ABИ. ДbИЖEHИЯ
Precord
        ld (Stk1+1),sp
        ld l,(ix+Indi)
        ld h,L97.h
        ld sp,hl
        pop hl
        inc hl
        ld b,(hl):bit 7,b:jp nz,Stk1
        res 7,b
        ld a,#06
        sub b
        ld hl,100
        ld ($+4),a
        jr $
        ADDHLHL 5
        ld a,Spacebd
        sub h
        ld b,a
        ld a,xl
        ld l,a
        ld a,xh
        ld h,a
        ld sp,hl
Stpx_   ld hl,0
        pop de
        or a
        adc hl,de
        jp pe,Exes
        ld a,h:jp p,$+4:cpl:cp b
        jr nc,Exes

XPL     ld de,0
        or a:sbc hl,de
        jp pe,Exes
        ld a,h:jp p,$+4:cpl:cp b
        jr nc,Exes

        push hl
Stpy_   ld hl,0
        inc sp
        inc sp
        pop de
        or a
        adc hl,de
        jp pe,Exes
        ld a,h:jp p,$+4:cpl:cp b
        jr nc,Exes

YPL     ld de,0
        or a:sbc hl,de
        jp pe,Exes
        ld a,h:jp p,$+4:cpl:cp b
        jr nc,Exes

        push hl
Stpz_   ld hl,0
        inc sp
        inc sp
        pop de
        or a
        adc hl,de
        jp pe,Exes
        ld a,h:jp p,$+4:cpl:cp b
        jr nc,Exes

ZPL     ld de,0
        or a:sbc hl,de
        jp pe,Exes
        ld a,h:jp p,$+4:cpl:cp b
        jr nc,Exes

        push hl
Stk1    ld sp,0
        ret
Exes
;ЕСЛИ ОБЪЕКТ ЗА ГРАНИЦЕЙ
        ld (ix+0),0
        ld (ix+1),#80
        ld (ix+Setup),#FF
        ld sp,(Stk1+1)
        ret

;ЗАДАНИЕ СМЕЩЕНИЙ В 0
Nulmove
        ld hl,0
        ld (Stpx_+1),hl
        ld (Stpy_+1),hl
        ld (Stpz_+1),hl
        ret

        include "BLOK1"


;ИhДEKCHAЯ TAБЛИЦaOБЪEKTOB
ADI3D_
        dw Sturm
        dw Sturm
        dw Istr
        dw Istr
        dw Turi
        dw Turi
        dw Trad
        dw Trad

        org ADI3D_+#80
        dw DREVO1
        dw DREVO1
        dw DREVO2
        dw DREVO2
        dw DOM1
        dw DOM1


;ДAHHЫeOБЪEKTOB
Objcts
        include "OBJX"

END

