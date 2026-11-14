СДЕСЬ ПОЧТИ ВСЕ МОДИФИЦИРОВАНО И УСКОРЕНО
■CLRHD            ■MULADE
■POLYGON          ■RENOBJ
■DRWPOL
■DRWPOL2          ■DRWLIN
■DRAWL1           ■VSMASK
■VSPOLY
















            ADRXX00
LC5
ТЕКСТУРЫ, МАСКИ
            dw   #00FF
            dw   #AA77
            dw   #FF55
            dw   #5511
            dw   #0000


■MUL hl=a*de
MULADE:     ld   l,a
            xor  d
            exa
            ABSDE
            ld   a,l
            and  a
            jpp  $+5
            neg
            ld   c,0
            ld   h,c
            ld   l,c
            add  a,a
            add  a,a
            jrc  $+23
            add  a,a
            jrc  $+26
            add  a,a
            jrc  $+29
            add  a,a
            jrc  $+32
            add  a,a
            jrc  $+35
            add  a,a
            jrc  $+38
            add  a,a
            jrc  $+41
            jp   $+45
            rept 6:add hl,de:adc a,c:add hl,hl:adc a,a:jrnc $+4:endr
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            ld   l,h
            ld   h,a
            exa
            jpp  $+9
            EXD
            ld   hl,0
            sbc  hl,de
            jp   (ix)




САМ ЦИКЛ РИСОВАНИЯ ПОЛИГОНА
БЕЗ КОМЕНТАРИЕВ !
КАК РАБОТАЕТ ЗНАЮ, НО ОПИСАТЬ ВСЕ ..?!
            org  (($.h).e)+#C0

            rept 31:ld (bc),a:inc b:endr

            ld   a,(bc):and (hl):inc h
            or   (hl):ld (bc),a
LC608
            inc  c
            ld   a,e
E1          add  a,0
            ld   e,a
            ld   a,l
E2          add  a,0
            ld   l,a
            exx
            ld   a,l
            sub  c
            jrnc $+6
            add  a,e
            exx:dec e:exx
            ld   l,a
            ld   a,h
            sub  b
            jrnc $+6
            add  a,d
            exx:dec l:exx
            ld   h,a
            exx
            ret
PEHO1
            ld   h,LL90.h
            ld   d,h
            ld   a,(de):ld b,a
            sub  (hl)
COLR1       ld   h,L90.h
COLR2       ld   d,L90.h
            jrnc LC654
            EXD
            add  a,a
            ld   ($+13),a
            ld   a,(bc):and (hl):inc h
            or   (hl):ld (bc),a
            inc  b
            EXD
MSK         ld   a,0
            jp   LC5

LC654
            jrnz LC608
            ld   a,(de):or (hl):inc h
            ld   xl,a
            cpl:and (hl):ld xh,a
            ld   a,(bc):and xl:or xh
            ld   (bc),a
            jp   LC608



■■■■■■■■■■■■

PEHO2
            ld   h,LL90.h
            ld   d,h
            ld   a,(de):ld b,a
            sub  (hl)
COLR1_      ld   h,L90.h
COLR2_      ld   d,L90.h
            jrnc LC654
            EXD
            add  a,a
            ld   ($+13),a
            ld   a,(bc):and (hl):inc h
            or   (hl):ld (bc),a
            inc  b
            EXD
MSK_        ld   a,0
            jp   LC5







LC6B9       ld   a,(LC6CC)
            ld   l,a
            jp   LC67F
JMP2
SSK1        ld   sp,0
            ld   h,e
            push hl
            ld   hl,#0000
LC675       equ  $-#0002
            dec  l
            ld   e,(hl)
            inc  l
LC67B       dec  l
            jrz  LC6B9
            dec  l
LC67F       ld   a,(hl)
            sub  c
            jrz  LC67B
            jrc  LC67B
            ld   (LC675),hl
            ld   d,a
            exx:ld e,a:exx
            rra
            exx:ld l,a:exx
            ld   a,(hl)
            ld   (LC632+1),a
            dec  l
            ld   a,(hl)
            sub  e
            jpc  LC76A
            cp   d
            jpc  LC763
            ld   e,a
            xor  a

            DIVED
            rl   e

            and  a
            jrz  LC75E
            sub  d
            neg
            exx:ld c,a:exx
            ld   a,e
            neg
            ld   (E1+1),a
            jp   LC5_

LC75E
            exx:ld c,a:exx
            ld   a,e
            cpl
            ld   (E1+1),a
            jp   LC5_

LC763       sub  d
            neg
            exx
            ld   c,a
            exx
            ld   a,1:ld (E1+1),a
            jp   LC5_
LC76A       neg
            cp   d
            jrc  LC7B1
            ld   e,a
            xor  a

            DIVED
            rl   e

            exx:ld c,a:exx
            ld   a,e
            inc  a
            ld   (E1+1),a
LC5_
            ld   a,c
LC635       ld   l,#00
            cp   l
            jpc  NXTE2
            pop  hl:ld e,h
            jp   JMP3

LC7B1
            exx
            ld   c,a
            exx
            xor  a:ld (E1+1),a
            jp   LC5_



ЗДЕСЬ ОРЕДЕЛЯЕМ КОЕФИЦИЕНТЫ ДЛЯ ОПРЕДЕЛННОГО НАКЛОНА СТОРОНЫ ПОЛИГОНА
И ДР.
LC70B       ld   l,#01
            jp   LC6D1
JMP3
SSK2        ld   sp,0
            ld   h,e
            push hl
            ld   hl,#0000
LC6C4       equ  $-#0002
            dec  l
            ld   e,(hl)
            inc  l
LC6CA       ld   a,l
            cp   #00
LC6CC       equ  $-#0001
            jrz  LC70B
            inc  l
            inc  l
LC6D1       ld   a,(hl)
            sub  c
            jrz  LC6CA
            jrc  LC6CA
            ld   (LC6C4),hl
            ld   d,a
            exx:ld d,a:exx
            rra
            exx:ld h,a:exx
            ld   a,(hl)
            ld   (LC635+1),a
            dec  l
            ld   a,(hl)
            sub  e
            jpc  LC76AL
            cp   d
            jpc  LC763L
            ld   e,a
            xor  a

            DIVED
            rl   e

            and  a
            jrz  LC625L
            sub  d
            neg
            exx:ld b,a:exx
            ld   a,e
            neg
            ld   (E2+1),a
            jp   NXTE2

LC625L
            exx:ld b,a:exx
            ld   a,e
            cpl
            ld   (E2+1),a
            jp   NXTE2

LC763L      sub  d
            neg
            exx
            ld   b,a
            exx
            ld   a,1:ld (E2+1),a
            jp   NXTE2

LC76AL      neg
            cp   d
            jpc  LC7B1L
            ld   e,a
            xor  a

            DIVED
            exx:ld b,a:exx
            ld   a,e
            rla
            inc  a
            ld   (E2+1),a

NXTE2
LC62D       ld   l,#00
LC632       ld   e,#00
            ld   a,e
            cp   l
            ld   a,(LC635+1)
            jrc  NXTE3
            cp   l
            jrc  NXTE4
            ld   a,l
            ld   h,_JMP1.h
EXII
            bit  0,a
            jrz  $+3:inc h
            sub  c
            inc  a:rlca:neg:ld l,a
            ld   (SSK0+1),hl
            pop  hl:ld e,h
SSK0        ld   sp,0
            ret

NXTE3
            cp   e
            jrc  NXTE4
            ld   a,e
            ld   h,_JMP2.h
            jp   EXII
NXTE4
            ld   h,_JMP3.h
            jp   EXII

LC7B1L
            exx
            ld   b,a
            exx
            xor  a:ld (E2+1),a
            jp   NXTE2








LC7B4       exa
            ld   l,a
            exa
            inc  l
            jp   LC7F7
LC7BB       ld   l,#01
            jp   LC807


LLC         pop  hl
            ret


ВЫВОД ПОЛИГОНА
ВЕДЕМ ПОИСК МАКС. И МИН УЗЛА
ЗАДАЕМ НАЧ. ПАРАМЕТРЫ
POLYGON
            push hl
            ld   a,(LOW_CORDS_BUF)
            ld   b,a
            dec  a
            ld   (LC6CC),a
            exa
            srl  b
            ld   hl,L9E.e+1
            ld   de,#FF00
LC7D2
            ld   a,(hl)
            cp   d
            jpnc $+5
            ld   d,a
            ld   c,l
            cp   e
            jpc  $+4
            ld   e,a
            inc  l
            inc  l
            djnz LC7D2
            ld   a,e
            cp   d
            jrz  LLC
            ld   (LC62D+1),a
            ld   a,d
            ld   (LC632+1),a
            ld   (LC635+1),a
            ld   b,e
            ld   l,c
LC7F3       ld   e,l
            dec  l
            jrz  LC7B4
LC7F7       dec  l
            cp   (hl)
            jrz  LC7F3
            ld   l,e
            ld   (LC675),hl
            dec  l:ld e,(hl)
            ld   l,c:ld c,d
LC800       ld   d,l
            exa
            cp   l
            jrz  LC7BB
            inc  l
            inc  l
LC807       exa
            cp   (hl)
            jrz  LC800
            ld   l,d
            ld   (LC6C4),hl
            dec  l:ld d,(hl)
TEXTU_R     equ  $+1
            ld   a,0
            add  a,a
            ld   h,LC5.h
            ld   l,a
            add  a,L90.h
            ld   (COLR2+1),a
            add  a,#0A
            ld   (COLR2_+1),a
            add  a,#0A
            ld   (COLR1+1),a
            add  a,#0A
            ld   (COLR1_+1),a
            ld   a,(hl)
            ld   (MSK+1),a
            inc  l
            xor  (hl)
            ld   (MSK_+1),a
            ld   l,d
            ld   (SSK1+1),sp
            ld   (SSK2+1),sp
            ld   a,c
            cp   b
            ld   sp,_JMP2
            retc
JMP1
            ld   sp,(SSK1+1)
            pop  hl
            ret



STKC
            inc  sp
            ld   (ADT+1),sp
            ld   sp,0
            ret


ЗДЕСЬ СОЗДЕМ ОБЪЕКТ, ТОЧНЕЕ  КООРДИНТЫ
УЖЕ В ПРОСТРНСТВЕ И В 2D.
RENOBJ:
            ld   a,(INDX)
            ld   l,a
            call REMOVEOBJ
            ld   (STKC+6),sp
            ld   sp,L9C.e+#FF

            ld   hl,OBJBUF+1
ДЕЛАЕНИЕ JUMP
            ld   a,#06
            sub  (hl):rlca
            add  a,EXPT.h
            ld   (EXP4+1),a
            ld   (EXP6+1),a
            inc  l
            jp   LD597+3
LD597
            ld   hl,0
            ld   a,(hl)
            inc  l
            or   a
            jrz  STKC
            ld   xl,a
            ld   b,(hl)
            inc  l
            ld   c,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (LD597+1),hl

■b,c,d,xl-X,Y,z,COLOR andAMOUNT DOTS
            ld   h,MULTB

OM_13:      ld   a,0
            MULAD
            ld   (MVX3+1),a
OM_23:      ld   a,0
            MULAD
            ld   (MVY3+1),a
OM_33:      ld   a,0
            MULAD
            ld   (MVZ3+1),a

OM_12:      ld   a,0
            MULAC
            ld   d,a;MVX2
OM_22:      ld   a,0
            MULAC
            ld   xh,a;MVY2
OM_32:      ld   a,0
            MULAC
            ld   yh,a;MVZ2

OM_31:      ld   a,0
            MULAB
            ld   yl,a;MVZ1
OM_21:      ld   a,0
            MULAB
            ld   c,a;MVY1
OM_11:      ld   a,0
            MULAB
            ld   b,a;MVX1


            ld   e,xh
MVY3        ld   hl,0
MVX3        equ  $-2
            add  hl,bc
            add  hl,de
            ld   (XB0+1),hl
            rlc  b
            rlc  c
            rlc  d
            rlc  e
            SUB_BC
            ld   (XB1+1),hl
            SUB_DE
            ld   (XB3+1),hl
            add  hl,bc
            ld   (XB2+1),hl
            ld   a,l
            neg
            ld   l,a
            ld   a,h
            neg
            ld   h,a
            ld   (XB5+1),hl
            add  hl,bc
            ld   (XB4+1),hl
            SUB_DE
            ld   (XB6+1),hl
            SUB_BC
            ld   (XB7+1),hl
            ld   b,xl
MVZ3        ld   a,0
            ld   e,yh
            ld   d,yl
            add  a,d
            add  a,e
            ld   xh,a
            rlc  d
            rlc  e
            sub  d
            ld   yh,a
            sub  e
            ld   yl,a
            add  a,d
            ld   xl,a
            neg
            ld   (CTL+1),a
            add  a,d
            ld   (ZB4+1),a
            sub  e
            ld   c,a
            sub  d
            ld   (ZB7+1),a
XB0         ld   de,0
            ld   a,b
            cp   #01
            jrz  LD62F;SIMPLY GET DOT
            cp   #81
            ld   h,BBE.h
            jpnz BBE
            ld   hl,$+10
            ld   a,xh
            exx
            ld   l,a
            jp   CALCD
            ld   a,xh
            neg
            ld   xh,a
            ld   a,d
            neg
            ld   d,a
            ld   a,e
            neg
            ld   e,a
LD62F
            ld   hl,LD597
            ld   a,xh
            exx
            ld   l,a
            jp   CALCD
ПРОЦЕСС ПОСТРОЕНИЯ

            ADRXX00
BBE
            bit  0,b
            jrz  BBE1
            ld   l,BBE1.b
            ld   a,xh
            exx
            ld   l,a
            jp   CALCD
BBE1
            bit  1,b
            jrz  BBE2
XB1         ld   de,0
            ld   l,BBE2.b
            ld   a,yh
            exx
            ld   l,a
            jp   CALCD
BBE2
            bit  3,b
            jrz  BBE3
XB3         ld   de,0
            ld   l,BBE3.b
            ld   a,yl
            exx
            ld   l,a
            jp   CALCD
BBE3
            bit  2,b
            jrz  BBE4
XB2         ld   de,0
            ld   l,BBE4.b
            ld   a,xl
            exx
            ld   l,a
            jp   CALCD
BBE4
            bit  6,b
            jrz  BBE5
XB6         ld   de,0
            ld   l,BBE5.b
            ld   a,c
            exx
            ld   l,a
            jp   CALCD
BBE5
            bit  7,b
            jrz  BBE6
XB7         ld   de,0
            ld   l,BBE6.b
            exx
ZB7         ld   l,0
            jp  CALCD
BBE6
            bit  5,b
            jrz  BBE7
XB5         ld   de,0
            ld   l,BBE7.b
            exx
CTL         ld   l,0
            jp   CALCD
BBE7
            bit  4,b
            jpz  LD597
XB4         ld   de,0
            ld   hl,LD597
            exx
ZB4         ld   l,0

ПЕРЕВОД КООРДИНАТ В 2D
CALCD

EXP4        ld   h,EXPT.h
            ld   e,(hl):inc h
            ld   d,(hl)

            exx:ld a,e:exx:ld l,a

            ld   b,(hl):dec h
            ld   c,(hl)


TZ:         ld   hl,0
            adc  hl,de

            jpm  LD73D

            ld   (ZZZ+1),hl
            EXD

TY:         ld   hl,0
            adc  hl,bc


            jpp  $+10
            NEGHL
            exa
            ld   a,d:or a:jpz PP0:xor a
            SM3:jrc PP1:SM3:jrc PP1+6:SM3:jrc PP1+12:SM3:jrc PP1+18:SM3:jrc PP1+24:SM3:jrc PP1+30
            SM3:jrc PP1+36:SM3:jrc PP1+42:SM3:jrc PP1+48:SM3:ld b,l:jrc PP1+55:SM3:jrc PP1+61:SM3:jrc PP1+67
            SM3:jrc PP1+73:SM3:jrc PP1+79:SM3:jrc PP1+85:SM3:jpc PP1+91:ld b,a:jp PP9
PP1         rla:cp d:jrnc PP2
            SM2:jrnc PP2+7:SM2:jrnc PP2+14:SM2:jrnc PP2+21:SM2:jrnc PP2+28:SM2:jrnc PP2+35:SM2:jrnc PP2+42
            SM2:jrnc PP2+49:SM2:ld b,l:jrnc PP2+56:SM2:jrnc PP2+63:SM2:jrnc PP2+70:SM2:jrnc PP2+77
            SM2:jrnc PP2+84:SM2:jrnc PP2+91:SM2:jrnc PP2+98:adc hl,hl:rla:SM1:jp PP4+105

PP2         SM1:jp PP3:SM1:jp PP4:SM1:jp PP4+8:SM1:jp PP4+16:SM1:jp PP4+24:SM1:jp PP4+32:SM1:jp PP4+40:SM1:jp PP4+48
            SM1:jp PP4+56:SM1:jp PP4+63:SM1:jp PP4+70:SM1:jp PP4+77:SM1:jp PP4+84:SM1:jp PP4+91:SM1:jp PP4+98

PP0         ld   a,l:ld l,h:ld h,0:sbc hl,de:jpnc LD73D:add hl,de:rla:adc hl,hl
PP3         sbc  hl,de:jpnc LD73D:add hl,de:rla:adc hl,hl
PP4         sbc  hl,de:jrnc $+3:add hl,de:rept 6:rla:adc hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr
            rla:add hl,hl:ld b,a:sbc hl,de:jrnc $+3:add hl,de:rept 7:rla:add hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr:rla
PP9         ld   c,a
            exa
            ld   hl,YEND+1/2;MIDLE Y
            jpm  $+8
            sbc  hl,bc
            jp   $+4
            add  hl,bc

            push hl
            exx
            ld   a,d
            exx
            ld   l,a

EXP6        ld   h,EXPT.h
            ld   c,(hl):inc h
            ld   b,(hl)

TX:         ld   hl,0
            adc  hl,bc

ZZZ         ld   de,0

            jpp  $+10
            NEGHL
            exa
            ld   a,d:or a:jpz OO0:xor a
            SM3:jrc OO1:SM3:jrc OO1+6:SM3:jrc OO1+12:SM3:jrc OO1+18:SM3:jrc OO1+24:SM3:jrc OO1+30
            SM3:jrc OO1+36:SM3:jrc OO1+42:SM3:jrc OO1+48:SM3:ld b,l:jrc OO1+55:SM3:jrc OO1+61:SM3:jrc OO1+67
            SM3:jrc OO1+73:SM3:jrc OO1+79:SM3:jrc OO1+85:SM3:jpc OO1+91:ld b,a:jp OO9
OO1         rla:cp d:jrnc OO2
            SM2:jrnc OO2+7:SM2:jrnc OO2+14:SM2:jrnc OO2+21:SM2:jrnc OO2+28:SM2:jrnc OO2+35:SM2:jrnc OO2+42
            SM2:jrnc OO2+49:SM2:ld b,l:jrnc OO2+56:SM2:jrnc OO2+63:SM2:jrnc OO2+70:SM2:jrnc OO2+77
            SM2:jrnc OO2+84:SM2:jrnc OO2+91:SM2:jrnc OO2+98:adc hl,hl:rla:SM1:jp OO4+105

OO2         SM1:jp OO3:SM1:jp OO4:SM1:jp OO4+8:SM1:jp OO4+16:SM1:jp OO4+24:SM1:jp OO4+32:SM1:jp OO4+40:SM1:jp OO4+48
            SM1:jp OO4+56:SM1:jp OO4+63:SM1:jp OO4+70:SM1:jp OO4+77:SM1:jp OO4+84:SM1:jp OO4+91:SM1:jp OO4+98

OO0         ld   a,l:ld l,h:ld h,0:sbc hl,de:jpnc LD73C:add hl,de:rla:adc hl,hl
OO3         sbc  hl,de:jpnc LD73C:add hl,de:rla:adc hl,hl
OO4         sbc  hl,de:jrnc $+3:add hl,de:rept 6:rla:adc hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr
            rla:add hl,hl:ld b,a:sbc hl,de:jrnc $+3:add hl,de:rept 7:rla:add hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr:rla
OO9         ld   c,a
            exa
            ld   hl,#0080;MIDLE X
            jpm  $+9
            sbc  hl,bc
            push hl
            dec  sp
            exx
            jp   (hl)
            add  hl,bc
            push hl
            dec  sp
            exx
            jp   (hl)


ЕСЛИ ПЕРЕПОЛНЕНИЕ
LD73D
            push de
LD73C
            ld   d,#80
            push de
            dec  sp
            exx
            jp   (hl)


DRWPOL:
            ld   a,(hl)
            and  a
            retz
            jpm  LIN_E
            and  #0F
            ld   yl,a
            call VSPOLY
            jpp  LD8A5
            xor  a;MAY BE VISIBLE POLY
            ld   (F_VISI),a

            ld   b,yl
            push hl
            inc  l
            ld   d,L9C
            ld   c,#00
LDAA8       ld   a,(hl)
            inc  l
            add  a,#04
            ld   e,a
            ld   a,(de)
            and  a
            jrz  LDAB9
            or   c
            ld   c,a
            djnz LDAA8
            pop  hl
            cpl
            and  #F0
            jrnz LD8AA
            ld   e,(hl)
            inc  l
            ld   d,LL91.h
            ld   a,(de)
            ld   (TEXTU_R),a
            ld   a,c
            and  #0F
            jrnz LD89A
            ld   de,L9E.e
            ld   a,yl
            add  a,a
            ld   (LOW_CORDS_BUF),a
            ld   b,L9C
            rrca
            exa
            ld   c,(hl)
            inc  l
            ld   a,(bc)
            ld   (de),a
            inc  e
            inc  c
            inc  c
            ld   a,(bc)
            ld   (de),a
            inc  e
            exa
            dec  a
            jpnz $-13
            call POLYGON
            jp   DRWPOL
LD89A
            ld   b,yl
            call CLIP
            call nc,POLYGON
            jp   DRWPOL
LD8A5       ld   a,#01;UNVISIBLE POLY
            ld   (F_VISI),a
LD8AA
            ld   a,yl:inc a
            add  a,l:ld l,a
            jp   DRWPOL
LDAB9
            pop  hl
            ld   a,yl:inc a
            add  a,l:ld l,a
            jp   DRWPOL

РИСОВАНИЕ ЛИНИИ
LIN_E       and  #0F
            ld   yl,a:ld b,a
            bit  6,(hl)
            jrz  LD8BF;ALWAYS VISIBLE
            ld   a,(F_VISI)
            and  a
            jrnz LD8AA;LAST POLY WAS UNVISIBLE
■ifLAST POLY VIS THAT LINES VIS TOO
LD8BF       dec  b
            ld   a,(hl)
            inc  l
            and  #30
            jrz  LD8D2;andMASK
            cp   #10
            jrz  LD8DA;orMASK
■xorMASK
■COMAND xorc:jrc,
            ld   de,#38A9
            ld   a,MASKS.b
            jp   LD8DF
■COMAND andc:jrnc,
LD8D2       ld   de,#30A1
            ld   a,MASKS.b+8
            jp   LD8DF
■COMAND orc:jrc,
LD8DA       ld   de,#38B1
            ld   a,MASKS.b
LD8DF       ld   (COML1),de
            ld   (LDADD),a
            ld   xh,L9C
            ld   a,(hl)
            ld   xl,a
            inc  l
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (_LX0),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (_LY0),de
            ld   a,(ix+#04)
            ld   (_LF0),a
LD907       ld   a,(hl)
            ld   xl,a
            inc  l
            push bc
            push hl
            ld   hl,(_LX0)
            ld   (_LX1),hl
            ld   hl,(_LY0)
            ld   (_LY1),hl
            ld   a,(_LF0)
            ld   (_LF1),a
            ld   b,a
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (_LX0),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (_LY0),de
            and  a
            ld   a,(ix+#04)
            ld   (_LF0),a
            jrz  LD967
            and  a
            jrz  LD967
            or   b
            ld   b,a
            cpl
            and  #F0
            jrnz LD967
            ld   a,b
            and  #0F
            jrnz LD96E
            ld   a,(_LX1)
            ld   (L_FROM),a
            ld   a,(_LY1)
            ld   (L_FROM+1),a
            ld   a,(_LX0)
            ld   (L_TO),a
            ld   a,(_LY0)
            ld   (L_TO+1),a
LD964       call DRWLIN
LD967       pop  hl
            pop  bc
            djnz LD907
            jp   DRWPOL
LD96E       ld   hl,(_LX1)
            ld   (_X0),hl
            ld   hl,(_LY1)
            ld   (_Y0),hl
            ld   a,(_LF1)
            ld   (_F0),a
            ld   hl,(_LX0)
            ld   (_X1),hl
            ld   hl,(_LY0)
            ld   (_Y1),hl
            ld   a,(_LF0)
            ld   (_F1),a
            push ix
            call CLIPLINE
            pop  ix
            jrnz LD967
            ld   hl,L9E.e
            ld   a,(hl)
            inc  l
            ld   (L_FROM),a
            ld   a,(hl)
            inc  l
            ld   (L_FROM+1),a
            ld   a,(hl)
            inc  l
            ld   (L_TO),a
            ld   a,(hl)
            ld   (L_TO+1),a
            jp   LD964


DRWPOL2:
            ld   a,(hl)
            and  a
            retz
            jpm  LD9EA
            and  #0F
            ld   yl,a
            call VSPOLY
            jpp  LD9DD
            xor  a
            ld   (F_VISI),a
            ld   e,(hl)
            inc  l
            ld   d,LL91.h
            ld   a,(de)
            ld   (TEXTU_R),a
            ld   de,L9E.e
            ld   a,yl
            add  a,a
            ld   (LOW_CORDS_BUF),a
            ld   b,L9C
            rrca
            exa
            ld   c,(hl)
            inc  l
            ld   a,(bc)
            ld   (de),a
            inc  e
            inc  c
            inc  c
            ld   a,(bc)
            ld   (de),a
            inc  e
            exa
            dec  a
            jpnz $-13
            call POLYGON
            jp   DRWPOL2
LD9DD       ld   a,#01
            ld   (F_VISI),a
LD9E2
            ld   a,yl
            inc  a:add a,l:ld l,a
            jp   DRWPOL2

;LINES
LD9EA       and  #0F
            ld   yl,a:ld b,a
            bit  6,(hl)
            jrz  LD9F7
            ld   a,(F_VISI)
            and  a
            jrnz LD9E2
LD9F7       dec  b
            ld   a,(hl)
            inc  l
            and  #30
            jrz  LDA0A
            cp   #10
            jrz  LDA12
            ld   de,#38A9
            ld   a,MASKS.b
            jp   LDA17
LDA0A       ld   de,#30A1
            ld   a,MASKS.b+8
            jp   LDA17
LDA12       ld   de,#38B1
            ld   a,MASKS.b
LDA17       ld   (COML1),de
            ld   (LDADD),a
            ld   d,L9C
            ld   e,(hl)
            inc  l
            ld   a,(de)
            ld   (L_TO),a
            inc  e
            inc  e
            ld   a,(de)
            ld   (L_TO+1),a
LDA2C       ld   d,L9C
            ld   e,(hl)
            inc  l
            push bc
            push hl
            ld   hl,(L_TO)
            ld   (L_FROM),hl
            ld   a,(de)
            ld   (L_TO),a
            inc  e
            inc  e
            ld   a,(de)
            ld   (L_TO+1),a
            call DRWLIN
            pop  hl
            pop  bc
            djnz LDA2C
            jp   DRWPOL2



РИСОВАНИЕ ЛИНИИ
DRWLIN
            ld   hl,(L_FROM)
            ld   de,(L_TO)
            SUB_DE
            retz
            add  hl,de
РИСОВАНИЕ ЛИНИИ ИЗ hl,de
■h,d-Y : l,e-X
DRAWL1:
            ld   (LDBBB),sp
            ld   sp,#0020
            ld   a,d
            sub  h
            jrnc LDAD8
            EXD
            neg
LDAD8       ld   d,a
            ld   a,l
            and  #07
            add  a,#00
LDADD:      equ  $-#0001
            ld   c,a
            ld   a,MASKS.h
            adc  a,#00
            ld   b,a
            ld   a,(bc)
            ld   c,a
            ld   a,l
            srl  h
            rr   l
            srl  h
            rr   l
            scf
            rr   h
            rr   l
            sub  e
            jrc  LDB59
            cp   d
            jrc  LDB2D
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            exa
■PUT INSIDE COMAND FOR THIS LINE
            ld   a,(COML1);COMAND 1
            ld   (LDB0D),a
            ld   a,(COML2);COMAND 2
            ld   (LDB10),a
            ld   a,(hl)
LDB0D       nop
            rlc  c
LDB10       jrc  LDB1D
LDB12       exa
            sub  e
            jrc  LDB23
            exa
            djnz LDB0D
            ld   (hl),a
            jp   LDBBA
LDB1D       ld   (hl),a
            dec  l
            ld   a,(hl)
            jp   LDB12
LDB23       add  a,d
            exa
            ld   (hl),a
            add  hl,sp
            ld   a,(hl)
            djnz LDB0D
            jp   LDBBA
LDB2D       ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            exa
            ld   a,(COML1)
            ld   (LDB40),a
            ld   a,(COML2)
            ld   (LDB4A),a
LDB3F       ld   a,(hl)
LDB40       nop
            ld   (hl),a
            add  hl,sp
            exa
            sub  e
            jrnc LDB4C
            add  a,d
            rlc  c
LDB4A       jrc  LDB52
LDB4C       exa
            djnz LDB3F
            jp   LDBBA
LDB52       dec  l
            exa
            djnz LDB3F
            jp   LDBBA
LDB59       neg
            cp   d
            jrc  LDB91
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            exa
            ld   a,(COML1)
            ld   (LDB71),a
            ld   a,(COML2)
            ld   (LDB74),a
            ld   a,(hl)
LDB71       nop
            rrc  c
LDB74       jrc  LDB81
LDB76       exa
            sub  e
            jrc  LDB87
            exa
            djnz LDB71
            ld   (hl),a
            jp   LDBBA
LDB81       ld   (hl),a
            inc  l
            ld   a,(hl)
            jp   LDB76
LDB87       add  a,d
            exa
            ld   (hl),a
            add  hl,sp
            ld   a,(hl)
            djnz LDB71
            jp   LDBBA
LDB91       ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            exa
            ld   a,(COML1)
            ld   (LDBA4),a
            ld   a,(COML2)
            ld   (LDBAE),a
LDBA3       ld   a,(hl)
LDBA4       nop
            ld   (hl),a
            add  hl,sp
            exa
            sub  e
            jrnc LDBB0
            add  a,d
            rrc  c
LDBAE       jrc  LDBB6
LDBB0       exa
            djnz LDBA3
            jp   LDBBA
LDBB6       inc  l
            exa
            djnz LDBA3
LDBBA       ld   sp,#0000
LDBBB       equ  $-#0002
            ret




LD85D
            pop  hl
            xor  a
            ret

ПРОСЧЕТ МАСКИ ВИДЕНИЯ ОБЪЕКТА
VSMASK:
            push hl
            xor  a
            exa
ADT         ld   hl,L9C.e
LD814
            inc  l
            ld   c,#00
            ld   a,(hl)
            inc  l
            inc  l
            cp   #80
            jrz  LD85D
            jrnc LD826
            and  a
            jpnz LD82B
            ld   a,(hl)
            and  a
            jpm  LD83F
            jpnz LD844
            dec  l
            ld   a,(hl)
            inc  l
            cp   YEND+1
            jrnc LD844
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            exa
            or   (hl)
            exa
            inc  l
            jpnz LD814
            pop  hl
            exa
            ret

LD826       set  1,c
            ld   a,(hl)
            and  a
            jpm  LD83F
            jpnz LD844
            dec  l
            ld   a,(hl)
            inc  l
            cp   YEND+1
            jrnc LD844
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            exa
            or   (hl)
            exa
            inc  l
            jpnz LD814
            pop  hl
            exa
            ret

LD844       set  2,c
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            exa
            or   (hl)
            exa
            inc  l
            jpnz LD814
            pop  hl
            exa
            ret

LD82B       set  0,c
            ld   a,(hl)
            and  a
            jpm  LD83F
            jpnz LD844
            dec  l
            ld   a,(hl)
            inc  l
            cp   YEND+1
            jrnc LD844
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            exa
            or   (hl)
            exa
            inc  l
            jpnz LD814
            pop  hl
            exa
            ret

LD83F       set  3,c
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            exa
            or   (hl)
            exa
            inc  l
            jpnz LD814
            pop  hl
            exa
            ret

ПРОСЧЕТ ВИДИМОСТИ ПОЛИГОНА
■retFS-mPOLY VISIBLE
VSPOLY
            push hl
            inc  l
            ld   d,(hl)
            inc  l
            ld   e,(hl)
            inc  l
            ld   a,(hl)
            ld   h,L9C
            ld   l,d
            ld   (LDA7A),sp
            ld   sp,hl
            pop  bc
            exx:pop bc:exx
            ld   l,e
            ld   sp,hl
            pop  de
            exx:pop de:exx
            ld   l,a
            ld   sp,hl
            pop  hl
            exx
            pop  hl
            ld   sp,#0000
LDA7A       equ  $-#0002
            sbc  hl,bc
            EXD
            sbc  hl,bc
            push hl
            exx
            sbc  hl,bc
            EXD
            sbc  hl,bc
            ex   (sp),hl
            exx
            pop  hl
            ld   a,h
            xor  d
            exa
            ABSHL
            ld   a,d
            or   a
            jpp  $+11
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            inc  de
            ld   a,d
            or   a
            jpz  XFDA_1
            ld   a,h
            and  a
            jpz  XFDF_1
            cp   d
            jrc  $+4:EXD:ld a,h
            ld   b,l
            ld   hl,0:ld c,l
            rlca
            rla:jrc $+21
            rla:jrc $+24
            rla:jrc $+27
            rla:jrc $+30
            rla:jrc $+33
            rla:jrc $+36
            rla:jp $+39
            add  hl,de:adc a,c
 rept6:addhl,hl:rla:jrnc$+4:addhl,de:adca,c:endr
            ld   c,a:ld a,b
            ld   b,c:ld c,0
 rept8:addhl,hl:rla:jrnc$+4:addhl,de:adca,c:endr
            ld   e,a:ld d,b
            EXD
XFBE1_1
            exa
            jpp  $+16
            ld   b,h
            ld   c,l
            ld   hl,0
            sbc  hl,de
            EXD
            ld   hl,0
            sbc  hl,bc

            push hl
            push de
            exx
            ld   a,h
            xor  d
            exa
            ABSHL
            ld   a,d
            or   a
            jpp  $+11
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            inc  de
            ld   a,d
            or   a
            jpz  XFDA_2
            ld   a,h
            and  a
            jpz  XFDF_2
            cp   d
            jrc  $+4:EXD:ld a,h
            ld   b,l
            ld   hl,0:ld c,l
            rlca
            rla:jrc $+21
            rla:jrc $+24
            rla:jrc $+27
            rla:jrc $+30
            rla:jrc $+33
            rla:jrc $+36
            rla:jp $+39
            add  hl,de:adc a,c
 rept6:addhl,hl:rla:jrnc$+4:addhl,de:adca,c:endr
            ld   c,a:ld a,b
            ld   b,c:ld c,0
 rept8:addhl,hl:rla:jrnc$+4:addhl,de:adca,c:endr
            ld   e,a:ld d,b
            EXD
            exa
            jpp  $+16
            ld   b,h
            ld   c,l
            ld   hl,0
            sbc  hl,de
            EXD
            ld   hl,0
            sbc  hl,bc

            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret




ДЛЯ ПРОЦЕДУР УМНОЖЕНИЯ
XFDA_1      ld   a,h
            and  a
            jrz  LD030_1
            EXD
XFDF_1      ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jrc  $+26
            add  a,a
            jrc  $+29
            add  a,a
            jrc  $+32
            add  a,a
            jrc  $+35
            add  a,a
            jrc  $+38
            add  a,a
            jrc  $+41
            add  a,a
            jrc  $+44
            add  a,a
            jrc  $+47
            jp   $+47
            rept 7:add hl,de:adc a,c:add hl,hl:adc a,a:jrnc $+4:endr
            add  hl,de
            adc  a,c
            EXD
            ld   l,a
            ld   h,0
            jp   XFBE1_1

LD030_1
            ld   a,l
            cp   e
            jrc  $+4:ld a,e:ld e,l
            ld   l,h
            sla  a
            jrc  $+31
            rla
            jrc  $+63
            rla
            jrc  $+91
            rla
            jrc  $+115
            rla
            jpc  $+135
            rla
            jpc  $+150
            rla
            jpc  $+161
            rla
            jpc  XFBE1_1
            ld   e,a
            jp   XFBE1_1

            ld   h,a
 rept7:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

            ld   h,a
 rept6:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

            ld   h,a
 rept5:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

            ld   h,a
 rept4:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

            ld   h,a
 rept3:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

            ld   h,a
 rept2:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

            ld   h,a
            add  hl,de
            add  hl,hl
            jrnc $+3
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE1_1

XFDA_2      ld   a,h
            and  a
            jrz  LD030_2
            EXD
XFDF_2      ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jrc  $+26
            add  a,a
            jrc  $+29
            add  a,a
            jrc  $+32
            add  a,a
            jrc  $+35
            add  a,a
            jrc  $+38
            add  a,a
            jrc  $+41
            add  a,a
            jrc  $+44
            add  a,a
            jrc  $+47
            jp   $+47
            rept 7:add hl,de:adc a,c:add hl,hl:adc a,a:jrnc $+4:endr
            add  hl,de
            adc  a,c
            EXD
            ld   l,a
            ld   h,0
            exa
            jpp  $+16
            ld   b,h
            ld   c,l
            ld   hl,0
            sbc  hl,de
            EXD
            ld   hl,0
            sbc  hl,bc

            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret

LD030_2
            ld   a,l
            cp   e
            jrc  $+4:ld a,e:ld e,l
            ld   l,h
            sla  a
            jrc  _1
            rla
            jrc  _2
            rla
            jpc  _3
            rla
            jpc  _4
            rla
            jpc  _5
            rla
            jpc  _6
            rla
            jpc  _7
            rla
            jrc  $+3
            ld   e,a
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_1
            ld   h,a
 rept7:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_2
            ld   h,a
 rept6:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_3
            ld   h,a
 rept5:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_4
            ld   h,a
 rept4:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_5
            ld   h,a
 rept3:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_6
            ld   h,a
 rept2:addhl,de:addhl,hl:jrnc$+3:endr
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret
_7
            ld   h,a
            add  hl,de
            add  hl,hl
            jrnc $+3
            add  hl,de
            EXD
            ld   l,h
            exa:jpp $+16
            ld   b,h:ld c,l
            ld   hl,0:sbc hl,de
            EXD
            ld   hl,0:sbc hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            ret





