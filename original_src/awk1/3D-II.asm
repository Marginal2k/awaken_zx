■CLRHD            ■MULADE
■POLYGON          ■RENOBJ
■RENDOT2          ■DRWPOL
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

CLRHD:      ld   (LC529+1),sp
            ld   sp,#8C00
            ld   hl,#FFFF
            ld   b,#60
            rept 16:push hl:endr
            djnz $-16
LC529       ld   sp,0
            ret

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



            org  (($.h).e)+#C0

            rept 31:ld (bc),a:inc c:endr

MSK         xor  #00
            exa
            ld   a,yl
            ld   l,a
            ld   a,(bc)
            and  (hl)
            inc  l
            or   (hl)
            ld   (bc),a
LC608       inc  h
            res  1,h
            exx
            add  ix,bc
            jrc  JJJ1
JJJ2
            ld   a,l
LC616       sub  #00
            jrnc $+6
LC61A       add  a,#00
            add  ix,sp
            ld   l,a
            add  iy,de
            ld   a,h
LC622       sub  #00
            jrnc $+6
LC626       add  a,#00
            add  iy,sp
            ld   h,a
            exx


            ld   a,d
BORD        cp   #00
JUMP        jrnc LC66B


NXTE
            inc  d
            ld   a,xl
            ld   l,a
            ld   a,xh
            ld   c,a
            sub  yh
            jrnc LC654
            add  a,a
            ld   ($+11),a
            ld   a,(bc)
            and  (hl)
            inc  l
            or   (hl)
            ld   (bc),a
            inc  c
            exa
            jp   LC5

LC654
            jrnz VB1
            ld   a,(hl)
            ld   e,yl
            ld   l,e
            or   (hl)
            inc  l
            ld   e,a
            cpl
            and  (hl)
            ld   l,a
            ld   a,(bc)
            and  e
            or   l
            ld   (bc),a
VB1
            exa
MSK2        xor  #00
            exa
            jp   LC608

JJJ1        exx
            inc  b
            exx
            jp   JJJ2
LC66B
JMP1        equ  $-JUMP-2
            ld   sp,#0000
            pop  hl
            ret

LC66E
JMP3        equ  $-JUMP-2
            jp   LC6C0



LC6B9       ld   a,(LC6CC)
            ld   l,a
            jp   LC67F
LC671
JMP2        equ  $-JUMP-2
            ld   l,d
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
            sub  d
            jrz  LC67B
            jrc  LC67B
            ld   (LC675),hl
            ld   d,a
            ld   (LC61A+1),a
            rra
            exx
            ld   l,a
            exx
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
            ld   (LC616+1),a
            ld   a,e
            neg
            srl  a
            exx
            ld   c,#00
            rr   c
            rra
            rr   c
            rra
            rr   c
            add  a,#20
            ld   b,a
            exx
            pop  hl
            ld   d,l
            ld   a,d
            jp   LC635

LC75E
            ld   (LC616+1),a
            ld   a,e
            cpl
            rra
            exx
            ld   c,#00
            rr   c
            sra  a
            rr   c
            sra  a
            rr   c
            add  a,#20
            ld   b,a
            exx
            pop  hl
            ld   d,l
            ld   a,d
            jp   LC635

LC763       sub  d
            neg
            ld   (LC616+1),a
            exx
            ld   c,#20
            ld   b,c
            exx
            pop  hl
            ld   d,l
            ld   a,d
            jp   LC635
LC76A       neg
            cp   d
            jrc  LC7B1
            ld   e,a
            xor  a

            DIVED
            rl   e

            ld   (LC616+1),a
            ld   a,e
            inc  a
            scf
            rra
            exx
            ld   c,#00
            rr   c
            sra  a
            rr   c
            sra  a
            rr   c
            add  a,#20
            ld   b,a
            exx
            pop  hl
            ld   d,l
            ld   a,d

LC635       ld   l,#00
            cp   l
            jpc  NXTE2
            ld   a,l
            ld   (BORD+1),a
            ld   a,JMP3
            ld   (JUMP+1),a

            ld   a,d
            jp   BORD;LC635

LC7B1
            ld   (LC616+1),a
            exx
            ld   c,#00
            ld   b,#20
            exx
            pop  hl
            ld   d,l
            ld   a,d
            jp   LC635



LC70B       ld   l,#01
            jp   LC6D1
LC6C0
            ld   l,d
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
            sub  d
            jrz  LC6CA
            jrc  LC6CA
            ld   (LC6C4),hl
            ld   d,a
            ld   (LC626+1),a
            srl  a
            exx
            ld   h,a
            exx
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
            ld   (LC622+1),a
            ld   a,e
            neg
            srl  a
            exx
            ld   e,#00
            rr   e
            rra
            rr   e
            rra
            rr   e
            add  a,#20
            ld   d,a
            exx
            pop  hl
            ld   d,l
            jp   NXTE2

LC625L
            ld   (LC622+1),a
            ld   a,e
            cpl
            rra
            exx
            ld   e,#00
            rr   e
            sra  a
            rr   e
            sra  a
            rr   e
            add  a,#20
            ld   d,a
            exx
            pop  hl
            ld   d,l
            jp   NXTE2

LC763L      sub  d
            neg
            ld   (LC622+1),a
            exx
            ld   e,#20
            ld   d,e
            exx
            pop  hl
            ld   d,l
            jp   NXTE2

LC76AL      neg
            cp   d
            jpc  LC7B1L
            ld   e,a
            xor  a

            DIVED
            ld   (LC622+1),a

            ld   a,e
            rla
            inc  a
            scf
            rra
            exx
            ld   e,#00
            rr   e
            sra  a
            rr   e
            sra  a
            rr   e
            add  a,#20
            ld   d,a
            exx
            pop  hl
            ld   d,l

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
            ld   (BORD+1),a
            ld   a,JMP1
            ld   (JUMP+1),a
            jp   NXTE
NXTE3
            cp   e
            jrc  NXTE4
            ld   a,e
            ld   (BORD+1),a
            ld   a,JMP2
            ld   (JUMP+1),a
            jp   NXTE
NXTE4
            ld   (BORD+1),a
            ld   a,JMP3
            ld   (JUMP+1),a
            jp   NXTE

LC7B1L
            ld   (LC622+1),a
            exx
            ld   e,#00
            ld   d,#20
            exx
            pop  hl
            ld   d,l
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
            ld   b,d
            ld   l,c
LC7F3       ld   e,l
            dec  l
            jrz  LC7B4
LC7F7       dec  l
            cp   (hl)
            jrz  LC7F3
            ld   l,e
            ld   (LC675),hl
            ld   l,c
LC800       ld   e,l
            exa
            cp   l
            jrz  LC7BB
            inc  l
            inc  l
LC807       exa
            cp   (hl)
            jrz  LC800
            ld   l,e
            ld   (LC6C4),hl
TEXTU_R     equ  $+1
            ld   a,0
            add  a,a
            ld   c,a
            ld   h,LC5.h
            ld   l,a
            ld   a,(hl)
            exa
            inc  l
            ld   a,(hl)
            ld   (MSK+1),a
            ld   (MSK2+1),a
            ld   hl,(LC675)
            dec  l
            ld   e,(hl)
            xor  a
            srl  b
            rr   e
            rra
            srl  b
            rr   e
            rra
            scf
            rr   b
            rr   e
            rra
            add  a,c
            ld   xl,a
            ld   xh,e
            ld   hl,(LC6C4)
            dec  l
            ld   e,(hl)
            xor  a
            srl  d
            rr   e
            rra
            srl  d
            rr   e
            rra
            scf
            rr   d
            rr   e
            rra
            add  a,c
            add  a,#10
            ld   yl,a
            ld   yh,e
            ld   h,L90.h
            ld   (LC66B+1),sp

            ld   a,(LC62D+1)
            ld   e,a
            ld   a,(LC632+1)
            ld   d,a
            cp   e
            jpnc LC66B
            ld   (BORD+1),a
            ld   a,JMP2
            ld   (JUMP+1),a
            ld   a,d
            ld   sp,#FFE0
            jp   BORD





RENOBJ:
            ld   a,(INDX)
            ld   l,a
            call REMOVEOBJ
            ld   hl,OBJBUF+1
            ld   a,4
            ld   (ADT+1),a

ДЕЛАЕНИЕ JUMP
            ld   a,#06
            sub  (hl)
            ld   (JMP4+1),a
            ld   (JMP5+1),a
            ld   (JMP6+1),a

            inc  hl
LD597       ld   a,(hl)
            inc  hl
            and  a
            retz
            ld   xl,a
            ld   b,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push hl
            call RENDOT2
            pop  hl
            jp   LD597

RENDOT2
■b,c,d,xl-X,Y,z,COLOR andAMOUNT DOTS
            ld   h,MULTB
OM_11:      ld   a,0
            MULAB
            ld   (MVX1+1),a
OM_12:      ld   a,0
            MULAC
            ld   (MVX2+1),a
OM_13:      ld   a,0
            MULAD
            ld   (MVX3+1),a
OM_21:      ld   a,0
            MULAB
            ld   (MVY1+1),a
OM_22:      ld   a,0
            MULAC
            ld   (MVY2+1),a
OM_23:      ld   a,0
            MULAD
            ld   (MVY3+1),a
OM_31:      ld   a,0
            MULAB
            ld   (MVZ1+1),a
OM_32:      ld   a,0
            MULAC
            ld   (MVZ2+1),a
OM_33:      ld   a,0
            MULAD
            ld   (MVZ3+1),a

RENDI
            ld   (STKC+1),sp
ADT         ld   sp,L9C.e

MVY1        ld   bc,0
MVX1        equ  $-2
MVY2        ld   de,0
MVX2        equ  $-2
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
MVZ2        ld   de,0
MVZ1        equ  $-2
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
            ld   (ZB6+1),a
            sub  d
            ld   (ZB7+1),a
XB0         ld   de,0
            ld   a,b
            cp   #01
            jrz  LD62F;SIMPLY GET DOT
            cp   #81
            jrnz LD633
            ld   a,xh
            ld   hl,$+6
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
            ld   a,xh
            ld   hl,ENDC
            jp   CALCD
ПРОЦЕСС ПОСТРОЕНИЯ
LD633
            ld   a,xh
            bit  0,b
            ld   hl,$+6
            jpnz CALCD
XB1         ld   de,0
            ld   a,yh
            bit  1,b
            ld   hl,$+6
            jpnz CALCD
XB3         ld   de,0
            ld   a,yl
            bit  3,b
            ld   hl,$+6
            jpnz CALCD
            bit  2,b
XB2         ld   de,0
            ld   a,xl
            ld   hl,$+6
            jpnz CALCD
XB6         ld   de,0
ZB6         ld   a,0
            bit  6,b
            ld   hl,$+6
            jpnz CALCD
XB7         ld   de,0
ZB7         ld   a,0
            bit  7,b
            ld   hl,$+6
            jpnz CALCD
XB5         ld   de,0
CTL         ld   a,0
            bit  5,b
            ld   hl,$+6
            jpnz CALCD
XB4         ld   de,0
ZB4         ld   a,0
            bit  4,b
            ld   hl,$+6
            jpnz CALCD
ENDC
            ld   hl,0
            add  hl,sp
            ld   a,l
            ld   (ADT+1),a
STKC        ld   sp,0
            ret

ПЕРЕВОТ КООРДИНАТ В 2D
CALCD
            exx
TZ:         ld   de,0
            ld   l,a
            rlca
            and  1
            neg
            ld   h,a
JMP4        jr   $
            ADDHLHL 5
            and  a
            adc  hl,de

            jpm  LD73D

            EXD
            exx
            ld   a,e
            exx
            ld   l,a
            rlca
            and  1
            neg
            ld   h,a
TY:         ld   bc,0
JMP5        jr   $
            ADDHLHL 5
            and  a
            adc  hl,bc

            ld   (ZZZ+1),de

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
            rlca
            and  1
            neg
            ld   h,a
TX:         ld   bc,0
JMP6        jr   $
            ADDHLHL 5
            and  a
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
            jpm  $+13
            sbc  hl,bc
            push hl
            ld   hl,9
            add  hl,sp
            ld   sp,hl
            exx
            jp   (hl)
            add  hl,bc
            push hl
            ld   hl,9
            add  hl,sp
            ld   sp,hl
            exx
            jp   (hl)


ЕСЛИ ПЕРЕПОЛНЕНИЕ
LD73D
            push de
            ld   d,#80
            push de
            ld   hl,9
            add  hl,sp
            ld   sp,hl
            exx
            jp   (hl)
LD73C
            ld   d,#80
            push de
            ld   hl,9
            add  hl,sp
            ld   sp,hl
            exx
            jp   (hl)


DRWPOL:
            ld   a,(hl)
            and  a
            retz
            jpm  LIN_E
            and  #0F
            ld   b,a
            call VSPOLY
            jpp  LD8A5
            xor  a;MAY BE VISIBLE POLY
            ld   (L91+#5A),a
            call LDA9F
            jrc  LD8AA
            cpl
            and  #F0
            jrnz LD8AA
            ld   a,(hl)
            inc  hl
            rrca
            rrca
            rrca
            rrca
            and  #07
            ld   (TEXTU_R),a
            ld   a,c
            and  #0F
            jrnz LD89A
            ld   de,L9E.e
            ld   a,b
            add  a,a
            ld   (LOW_CORDS_BUF),a
            ld   b,L9C
            rrca
            exa
            ld   c,(hl)
            inc  hl
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
LD89A       call CLIP
            call nc,POLYGON
            jp   DRWPOL
LD8A5       ld   a,#01;UNVISIBLE POLY
            ld   (L91+#5A),a
LD8AA       inc  b
            ld   c,b
            ld   b,#00
            add  hl,bc
            jp   DRWPOL

РИСОВАНИЕ ЛИНИИ
LIN_E       and  #0F
            ld   b,a
            bit  6,(hl)
            jrz  LD8BF;ALWAYS VISIBLE
            ld   a,(L91+#5A)
            and  a
            jrnz LD8AA;LAST POLY WAS UNVISIBLE
■ifLAST POLY VIS THAT LINES VIS TOO
LD8BF       dec  b
            ld   a,(hl)
            inc  hl
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
LD8DF       ld   (L91+#4E),de
            ld   (LDADD),a
            ld   xh,L9C
            ld   a,(hl)
            ld   xl,a
            inc  hl
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (L91+#3E),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (L91+#4A),de
            ld   a,(ix+#04)
            ld   (L91+#4D),a
LD907       ld   a,(hl)
            ld   xl,a
            inc  hl
            push bc
            push hl
            ld   hl,(L91+#3E)
            ld   (L91+#3A),hl
            ld   hl,(L91+#4A)
            ld   (L91+#3C),hl
            ld   a,(L91+#4D)
            ld   (L91+#4C),a
            ld   b,a
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (L91+#3E),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (L91+#4A),de
            and  a
            ld   a,(ix+#04)
            ld   (L91+#4D),a
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
            ld   a,(L91+#3A)
            ld   (L91+#2A),a
            ld   a,(L91+#3C)
            ld   (L91+#2B),a
            ld   a,(L91+#3E)
            ld   (L91+#2C),a
            ld   a,(L91+#4A)
            ld   (L91+#2D),a
LD964       call DRWLIN
LD967       pop  hl
            pop  bc
            djnz LD907
            jp   DRWPOL
LD96E       ld   hl,(L91+#3A)
            ld   (_X0),hl
            ld   hl,(L91+#3C)
            ld   (_Y0),hl
            ld   a,(L91+#4C)
            ld   (_F0),a
            ld   hl,(L91+#3E)
            ld   (_X1),hl
            ld   hl,(L91+#4A)
            ld   (_Y1),hl
            ld   a,(L91+#4D)
            ld   (_F1),a
            push ix
            call CLIPLINE
            pop  ix
            jrnz LD967
            ld   hl,L9E.e
            ld   a,(hl)
            inc  l
            ld   (L91+#2A),a
            ld   a,(hl)
            inc  l
            ld   (L91+#2B),a
            ld   a,(hl)
            inc  l
            ld   (L91+#2C),a
            ld   a,(hl)
            ld   (L91+#2D),a
            jp   LD964


DRWPOL2:
            ld   a,(hl)
            and  a
            retz
            jpm  LD9EA
            and  #0F
            ld   b,a
            call VSPOLY
            jpp  LD9DD
            xor  a
            ld   (L91+#5A),a
            ld   a,(hl)
            inc  hl
            rrca
            rrca
            rrca
            rrca
            and  #07
            ld   (TEXTU_R),a
            ld   de,L9E.e
            ld   a,b
            add  a,a
            ld   (LOW_CORDS_BUF),a
            ld   b,L9C
            rrca
            exa
            ld   c,(hl)
            inc  hl
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
            ld   (L91+#5A),a
LD9E2       inc  b
            ld   c,b
            ld   b,#00
            add  hl,bc
            jp   DRWPOL2
LD9EA       and  #0F
            ld   b,a
            bit  6,(hl)
            jrz  LD9F7
            ld   a,(L91+#5A)
            and  a
            jrnz LD9E2
LD9F7       dec  b
            ld   a,(hl)
            inc  hl
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
LDA17       ld   (L91+#4E),de
            ld   (LDADD),a
            ld   d,L9C
            ld   e,(hl)
            inc  hl
            ld   a,(de)
            ld   (L91+#2C),a
            inc  e
            inc  e
            ld   a,(de)
            ld   (L91+#2D),a
LDA2C       ld   d,L9C
            ld   e,(hl)
            inc  hl
            push bc
            push hl
            ld   hl,(L91+#2C)
            ld   (L91+#2A),hl
            ld   a,(de)
            ld   (L91+#2C),a
            inc  e
            inc  e
            ld   a,(de)
            ld   (L91+#2D),a
            call DRWLIN
            pop  hl
            pop  bc
            djnz LDA2C
            jp   DRWPOL2

LDA9F       ld   xl,b
            push hl
            EXD
            inc  de
            ld   h,L9C
            ld   c,#00
LDAA8       ld   a,(de)
            inc  de
            add  a,#04
            ld   l,a
            ld   a,(hl)
            and  a
            jrz  LDAB9
            or   c
            ld   c,a
            djnz LDAA8
            pop  hl
            ld   b,xl
            ret
LDAB9       scf
            pop  hl
            ld   b,xl
            ret


РИСОВАНИЕ ЛИНИИ
DRWLIN
            ld   hl,(L91+#2A)
            ld   de,(L91+#2C)
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
            ld   a,(L91+#4E);COMAND 1
            ld   (LDB0D),a
            ld   a,(L91+#4F);COMAND 2
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
            ld   a,(L91+#4E)
            ld   (LDB40),a
            ld   a,(L91+#4F)
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
            ld   a,(L91+#4E)
            ld   (LDB71),a
            ld   a,(L91+#4F)
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
            ld   a,(L91+#4E)
            ld   (LDBA4),a
            ld   a,(L91+#4F)
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

ПРОСЧЕТ МАТРИЦЫ ВИДЕНИЯ ОБЪЕКТА
VSMASK:
            push hl
            xor  a
            exa
            ld   hl,L9C.e+1
            ld   a,(ADT+1)
            sub  4
            ld   b,a
LD814       ld   c,#00
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
            ld   a,l
            inc  l
            cp   b
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
            ld   a,l
            inc  l
            cp   b
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
            ld   a,l
            inc  l
            cp   b
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
            ld   a,l
            inc  l
            cp   b
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
            ld   a,l
            inc  l
            cp   b
            jpnz LD814
            pop  hl
            exa
            ret

ПРОСЧЕТ ВОДИМОСТИ ПОЛИГОНА
■retFS-mPOLY VISIBLE
VSPOLY
            push bc
            push hl
            inc  hl
            cp   #05
            jrnc LDA5B
            ld   d,(hl)
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   a,(hl)
            jp   LDA62
LDA5B       ld   d,(hl)
            inc  hl
            inc  hl
            ld   e,(hl)
            inc  hl
            inc  hl
            ld   a,(hl)
LDA62       ld   h,L9C
            ld   l,d
            ld   (LDA7A),sp
            ld   sp,hl
            pop  bc
            exx
            pop  bc
            exx
            ld   l,e
            ld   sp,hl
            pop  de
            exx
            pop  de
            exx
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
            call MULL
            push hl
            push de
            exx
            call MULL
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            pop  bc
            ret

ВСЯКИЕ МАСКИ
            ds   $-1/16*16-$+16
MASKS:
            dw   #4080
            dw   #1020
            dw   #0408
            dw   #0102
            dw   #BF7F
            dw   #EFDF
            dw   #FBF7
            dw   #FEFD

