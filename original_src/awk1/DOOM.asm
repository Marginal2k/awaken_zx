AM_MAP      equ  #C000;LEN=#1300 UB1
T_TXR       equ  #C000;LEN=#1000 UB1

USE_BN1     equ  #13
USE_BN2     equ  #11
PGZERO      equ  #10

HIGH        equ  #0C

HNC2PNT     equ  #80
H_REND_LN   equ  #7E00;COD=#0200
HNBNSCR     equ  #80C0;BUF=#2600 #40 X #26

CNMAP       equ  #C000;MAP=#4000

B_TXR_BUF   equ  #8000;TXR=#7000

C2PNTP1     equ  #6000
C2PNSR1     equ  #60C0
C2PNTP2     equ  #6100
C2PNSR2     equ  #61C0


ANC2PNT     equ  #89
ANBNSCR     equ  #8000;BUF=#0980
ANRENDNLN   equ  #9100;COD=#0180
ANRAYNDAT   equ  #9300;BUF=#0100
ANRAYZ      equ  #9400;TAB=#0400
ANSRLNTAB   equ  #9800;TAB=#0100
ANGENNRAYZ  equ  #9900;COD=#0F00
ANGENNLIGH  equ  #A800;COD=#0480
ANMAP       equ  #AD00;MAP=#1300
ANLIGHNVOL  equ  #C000;TAB=#2600
ANVOLZ      equ  #F000;TAB=#1000

■-----------------------------;
■ SOURCE CODE OF GOA 4K INTRO ;
■ 1998 EXPLODER/EXTREMELY     ;
■ 1999 SOME REMAKES BY MYTHOS ;
■-----------------------------;
            org  #6400
TNSIN       db   #FF,#FF,#FF,#FF,#FE,#FE,#FE,#FD
            db   #FD,#FC,#FB,#FA,#FA,#F9,#F8,#F6
            db   #F5,#F4,#F3,#F1,#F0,#EE,#ED,#EB
            db   #EA,#E8,#E6,#E4,#E2,#E0,#DE,#DC
            db   #DA,#D7,#D5,#D3,#D0,#CE,#CB,#C9
            db   #C6,#C4,#C1,#BE,#BC,#B9,#B6,#B3
            db   #B0,#AD,#AA,#A7,#A5,#A2,#9E,#9B
            db   #98,#95,#92,#8F,#8C,#89,#86,#83
            db   #80,#7C,#79,#76,#73,#70,#6D,#6A
            db   #67,#64,#61,#5D,#5A,#58,#55,#52
            db   #4F,#4C,#49,#46,#43,#41,#3E,#3B
            db   #39,#36,#34,#31,#2F,#2C,#2A,#28
            db   #25,#23,#21,#1F,#1D,#1B,#19,#17
            db   #15,#14,#12,#11,#0F,#0E,#0C,#0B
            db   #0A,#09,#07,#06,#05,#05,#04,#03
            db   #02,#02,#01,#01,#01,#00,#00,#00
            ds   #80



            ent  #6500

START
            di
            sub  a
            out  (#FE),a
            ld   hl,#5800
            ld   de,#5801
            ld   bc,HIGH*#20-1
            ld   (hl),%00101000
            ldir
            ld   c,#FF
            call CLNSCR
            ld   iy,#5C3A
            ld   (EXIT+1),sp
            call OOUT10
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#3FFF
            ld   (hl),l
            ldir
            ld   hl,#6000
            ld   de,#6001
            ld   bc,#03FF
            ld   (hl),l
            ldir
            ld   hl,END
            ld   de,END+1
            ld   bc,#C000-END-1
            ld   (hl),0
            ldir
            ld   a,USE_BN1
            call OOUT
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#12FF
            ld   (hl),l
            ldir
            ld   a,USE_BN2
            call OOUT
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#3FFF
            ld   (hl),l
            ldir

            call INSTALL
            call AMNINSTALL
            call IM_INSTALL
            call ANINSTALL
            call TNINS

            call OOUT10

            call H_INSTALL
            ld   c,0
            call CLNSCR

            call SERVICE2
            call SERVICE2



YNC1
            call QN
            ld   hl,0
            ld   (LFTRGT),hl
            ld   (UPDWN),hl
            ld   (SPEEDTURN+1),hl
            call SERVICE
            jpc  YNC2

            ld   a,(SPEEDTURN+1)
            or   a
            jpz  YNC3

            ld   a,%10001000
            rrca
            ld   ($-2),a
            jpnc YNC3
            ld   a,%10010000
            rrca
            ld   ($-2),a
            jpnc YNC3
            ld   hl,(UPDWN-2)
            ld   a,h:xor 1:ld h,a
            ld   (UPDWN-2),hl
YNC3

            jp   YNC1


ЭКСИТ
YNC2
            call CLNSCR

EXIT        ld   sp,#3131
            ld   hl,0
            push hl
            jp   #3D2F


TURNLT
            ld   a,(HNTP+1)
            cp   #18:retz
            ld   a,#01
            ld   (SPEEDTURN+2),a
            ret
TURNRT
            ld   a,(HNTP+1)
            cp   #08:retz
            ld   a,#FF
            ld   (SPEEDTURN+2),a
            ret
SPEEDUP
            ld   a,#FF
            ld   (SPEEDTURN+1),a
            ret
SPEEDDOWN
            ld   a,#01
            ld   (SPEEDTURN+1),a
            ret
ROLRT
            call CHANGEX
            ret

ROLLT
            call CHANGEX
            ret


CHANGEX
            ld   hl,(MCOORD)
            ld   l,#80
            ld   (LFTRGT),hl
            ret



ROLDN
            ld   bc,(MCOORD)
            ld   b,c:ld c,#00
            ld   hl,(UPDWN-2)
            add  hl,bc
            ex   de,hl
            ld   hl,#6B00
            or   a:sbc hl,de
            retnc
            ld   (UPDWN),bc
            ret

ROLUP
            ld   bc,(MCOORD)
            ld   b,c:ld c,#00
            ld   hl,(UPDWN-2)
            add  hl,bc
            ex   de,hl
            ld   hl,#9300
            or   a:sbc hl,de
            retc:retz
            ld   (UPDWN),bc
            ret



■TUNNEL

QN          ld   a,USE_BN2

SPEEDTURN   ld   de,#00FF

ЧАСТОТА КАДРОВ, ЧЕМ БОЛЬШЕ
ТЕМ БЫСТРЕЕ ЛЕТИМ
■d-СКОРОСТЬ ВРАЩЕНИЯ
■e-СКОРОСТЬ ДВИЖЕНИЯ
            ld   hl,I_SIN_0;ЛЮФТ 
            ld   bc,I_SIN_1;ЛЮФТ 

            push bc
            call OOUT
            ld   a,(HNTP+1)
            add  a,d
            and  #3F
            ld   (HNTP+1),a
            ld   a,(HNTP+2)
            add  a,e
            and  #3F
            or   #80
            ld   (HNTP+2),a
            call SIN
            sub  #60
            add  a,a
            ld   (HNMP+1),a
            pop  hl
            call SIN
            add  a,#60-HIGH
            ld   (HNMP+2),a

HNMAIN
            ld   d,HNBNSCR/#100
            exx
HNMP        ld   hl,CNMAP+#40+#2000-#1300
            call HNREND

            call HNREND


ВЫВОД КАРТИНКИ
C2PN        ld   a,#00
            add  a,#80
            ld   (C2PN+1),a

            jr   nz,C2PNC00
            ld   hl,C2PNTP2
            call C2PNLNZ
            ld   hl,C2PNSR1
            call C2PNMOV
            ld   hl,C2PNTP1
            jr   C2PNLNZ
C2PNC00
            ld   hl,C2PNTP1
            call C2PNLNZ
            ld   hl,C2PNSR2
            call C2PNMOV
            ld   hl,C2PNTP2

C2PNLNZ
            ld   (C2PNSP1+1),hl
            ld   (C2PNSP2+1),sp
            ld   a,HIGH*2
C2PNSP1
            ld   sp,#3131
            pop  hl
            pop  de
            ld   (C2PNSP1+1),sp
            ld   sp,hl
            rept #20
            pop  hl:ldi
            endr
            dec  a
            jp   nz,C2PNSP1
C2PNSP2
            ld   sp,#3131
            ret


C2PNMOV
            ld   (C2PNSP3+1),sp
            ld   sp,hl
C2PNMVE
            ds   #80
C2PNSP3
            ld   sp,#3131
            ret



РЕНДЕРИНГ ЭКРАНА В ЗАВИСИМОСТИ ОТ УГЛА
ПОВОРОТА И ПРИБЛИЖЕННОСТИ
HNREND      ld   (HNSP+1),sp
            ld   b,HIGH
HNC01       ld   sp,hl
            inc  h
            exx
HNTP        ld   bc,#8010
            ld   e,HNBNSCR
            jp   H_REND_LN
HNRET       inc  d
            exx
            djnz HNC01
HNSP        ld   sp,#3131
            ret










IM_INSTALL
            ld   a,#6F
            ld   hl,IM_IT
            call Z_MAIN
            ld   de,#8000
            ld   h,#C0-#20
INI10       ld   l,#00
INI11       ld   a,(hl)
            srl  a
            srl  a
            ld   (de),a
            inc  l
            inc  e
            ld   a,(hl)
            ld   (de),a
            inc  l
            inc  e
            jr   nz,INI11
            inc  h
            inc  d
            bit  6,d
            jr   z,INI10
            ld   a,USE_BN2
            call OOUT
            ld   bc,#4000
            ld   hl,B_TXR_BUF
            ld   de,B_TXR_BUF+#4000
            ldir
            ret







H_INSTALL
            ld   de,H_REND_LN
            ld   hl,H_IT1
            ld   bc,#4007
            call MOVES
            ld   de,HNRET
            call EXITN1
            ld   xl,HNC2PNT
            call B_I00
            ld   xl,HNC2PNT
            ld   de,HNBNSCR
            ld   bc,#0100


            exx
            ld   hl,C2PNMVE
            ld   d,xl
            ld   c,#08
C2PNI02
            ld   e,xl
            ld   b,#04
C2PNI01
            ld   (hl),#E1
            inc  hl
            ld   (hl),#22
            inc  hl
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            inc  e
            inc  e
            djnz C2PNI01
            inc  d
            dec  c
            jr   nz,C2PNI02
            exx

            ld   hl,C2PNTP1
            ld   a,HIGH*2
C2PNI20
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  h
            ld   (hl),d
            dec  l
            ld   (hl),e
            dec  h
            ex   de,hl
            add  hl,bc
            ex   de,hl
            inc  l
            inc  l
            inc  l
            inc  l
            dec  a
            jr   nz,C2PNI20

            call C_2

            ld   a,(C2PN+1)
            or   a
            ld   hl,C2PNSR1
            jr   z,$+2+3
            ld   hl,C2PNSR2
            jp   C2PNMOV







C_2
            ld   de,C2PNSR1
            ld   hl,C2P_SPR
            ld   b,h
            ld   c,l
            call C2PNI32
            ld   de,C2PNSR2
            ld   b,h
            ld   c,l
C2PNI32
            ld   xh,#08
C2PNI31
            ld   xl,#08
            ld   a,(hl)
            inc  hl
            and  #0F
            ld   yl,a
            push bc
C2PNI30
            ld   a,(bc)
            inc  bc
            and  #F0
            or   yl
            ld   (de),a
            inc  e
            dec  xl
            jr   nz,C2PNI30
            pop  bc
            dec  xh
            jr   nz,C2PNI31
            ret




H_IT1       pop  hl;10
            add  hl,bc;11
            res  6,h;8
            ld   a,(hl);7
            ld   (de),a;7
            inc  e;7;47










B_I00       ld   a,USE_BN1
            call OOUT
            ld   d,B_TXR_BUF/#100
            ld   hl,T_TXR
B_I02       ld   e,#00
            ld   b,#40
B_I01       ld   a,(hl)
            add  a,xl
            ld   (de),a
            inc  hl
            inc  e
            djnz B_I01
            inc  d
            bit  6,d
            jr   z,B_I02

            ld   h,B_TXR_BUF/#100
            ld   d,h
B_I11       ld   bc,#00C0
            ld   l,b
            ld   e,#40
            ldir
            inc  h
            bit  6,h
            jr   z,B_I11
            jp   OOUT10







Z_MAIN
■hlАДРЕС
■a КОМАНДА ldyl,a;incyl
            ld   (ZNT00+1),hl
            ld   (ZNX00+1),a
            call OOUT10

            ld   hl,#0000
            ld   (TNVND1+1),hl
            ld   hl,#4000
            ld   (TNVND2+1),hl
            ld   hl,#8000
            ld   bc,#7FFF
            ld   a,c
            ld   d,h
            ld   e,l
            inc  de
            ld   (hl),a
            ldir

            ld   b,#3F
ZNI02       push bc
ZNT00       ld   hl,#2121
            ld   a,(hl)
            inc  hl
            ld   (ZNT00+1),hl
ZNX00       ld   yl,a;#6F;#2C incyl

            ld   bc,#8000
TNVND1      ld   de,#0000
            inc  e
            inc  e
            inc  e
            inc  de
            ld   (TNVND1+1),de
TNVND2      ld   hl,#4000
            dec  h
            ld   (TNVND2+1),hl

СОСТАВЛЕНИЕ ТАБЛИЦЫ
TNVNC1      ld   a,h
            ld   (bc),a
            add  hl,de
            inc  c
            bit  7,c
            jp   z,TNVNC1

            ld   bc,TNSIN
            ld   ix,TNSIN+#40
ZNI01       ld   h,#80
            ld   a,(bc)
            ld   l,a
            srl  l
            ld   e,(hl)
            ld   l,(ix)
            srl  l
            ld   d,(hl)
            sla  e
            set  7,d

            ld   a,c
            ld   (de),a
            inc  e
            ld   a,yl
            ld   (de),a

            inc  xl
            inc  c
            jr   nz,ZNI01
            pop  bc
            djnz ZNI02

            ld   xl,#02
ZNI22       ld   hl,#8100
ZNI20       inc  l
            ld   a,(hl)
            cp   #FF
            jr   nz,ZNI21
            inc  h
            ld   d,(hl)
            dec  l
            ld   e,(hl)
            dec  h
            ld   (hl),e
            inc  l
            ld   (hl),d
ZNI21       inc  hl
            bit  7,h
            jr   nz,ZNI20
            dec  xl
            jr   nz,ZNI22
            ret









INSTALL
ДОДЕЛЫВАЕМ ТАБЛИЦУ СИНУСОВ
            ld   hl,TNSIN+#7F
            ld   de,TNSIN+#81
            ld   a,(hl)
            ld   (de),a
            dec  l
            inc  e
            jr   nz,$-2-2

            ld   hl,C2PNTP1
            ld   de,#4000;4040
            ld   b,HIGH
C2PNI10
            inc  l
            inc  l
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            inc  l
            inc  l
            ld   (hl),e
            inc  l
            ld   a,d
            add  a,#04
            ld   (hl),a
            inc  l
            ld   a,e
            add  a,#20
            ld   e,a
            jr   nc,$+2+4
            ld   a,d
            add  a,#08
            ld   d,a
            djnz C2PNI10
            ld   hl,C2PNTP1
            ld   de,C2PNTP2
            ld   b,HIGH*2
C2PNI11
            inc  l
            inc  l
            inc  e
            inc  e
            ld   a,(hl)
            ld   (de),a
            inc  l
            inc  e
            ld   a,(hl)
            add  a,#02
            ld   (de),a
            inc  l
            inc  e
            djnz C2PNI11
            ret




EXITN1      ld   (hl),#C3
            inc  hl
            ld   (hl),e
            inc  hl
            ld   (hl),d
            ret
OOUT10      ld   a,PGZERO
OOUT        ld   bc,#7FFD
            out  (c),a
            ret




MOVES       ld   a,b
            ld   b,#00
            push hl
            push bc
            ldir
            pop  bc
            pop  hl
            dec  a
            jr   nz,$-1-1-1-2-1-1
            ex   de,hl
            ret


SIN         ld   (SINNSP1+1),sp
            ld   sp,hl
            pop  bc
            pop  hl
            pop  de
            push de
            bit  7,b
            jr   z,$+2+3+3+1
            ld   a,e
            cpl
            ld   e,a
            ld   a,d
            cpl
            ld   d,a
            inc  de
            add  hl,de
            push hl
            add  hl,bc
            push hl
            ld   a,h
SINNSP1
            ld   sp,#3131
            ret









CLNSCR
            ld   hl,#4000
            ld   b,HIGH*8
M11
            ld   e,l
            rept 31
            ld   (hl),c
            inc  l
            endr
            ld   (hl),c
            ld   l,e
            inc  h
            ld   a,h
            and  7
            jpnz $+13
            ld   a,l
            add  a,32
            ld   l,a
            jrc  $+6
            ld   a,h
            sub  8
            ld   h,a
            djnz M11
            ret





ANINSTALL
            ld   a,USE_BN1
            call OOUT
            ld   hl,AM_MAP
            ld   de,ANMAP
            ld   bc,#1300
            ldir
            call OOUT10

ДЕЛАЕМ ПРОЦЕДУРУ
            ld   de,ANRENDNLN
            ld   hl,ANIT1
            ld   bc,#4006
            call MOVES
            dec  hl
            ld   de,ANRN01
            call EXITN1

ТОЖЕ ДЕЛАЕМ ПРОЦЕДУРУ
            ld   de,ANGENNRAYZ
            ld   hl,ANIT2
            ld   bc,#000F
            call MOVES
            dec  hl
            dec  hl
            ld   (hl),#C9

            ld   hl,ANGENNLIGH
            ld   de,ANLIGHNVOL
            ld   c,HIGH*2;#26
ANI32       ld   b,#08
ANI31       ld   (hl),#E1
            inc  hl
            ld   (hl),#22
            inc  hl
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            inc  e
            inc  e
            djnz ANI31
            ld   e,#00
            inc  d
            dec  c
            jr   nz,ANI32
            ld   de,ANGENL1
            call EXITN1

            ld   hl,ANSRLNTAB
ANI41       ld   a,l
            rrca
            rrca
            rrca
            rrca
            and  #0F
            ld   (hl),a
            inc  l
            jr   nz,ANI41

            ld   h,TNSIN/#100
            ld   de,ANRAYZ
            ld   c,#09
            call ANI51
            ld   c,#06
            call ANI51
            ld   c,#08
            call ANI51
            ld   c,#05
            call ANI51

            ld   hl,ANVOLZ
            ld   d,#B0
            ld   c,#00
ANI72       ld   e,d
            ld   b,#10
ANI71       ld   a,e
            cp   #80
            jr   c,$+2+2
            ld   a,#7F
            cp   #70
            jr   nc,$+2+2
            ld   a,#70
            sub  #70
            srl  a
            add  a,ANC2PNT
            ld   (hl),a
            dec  e
            inc  hl
            djnz ANI71
ANI73       ld   a,#80
            add  a,#80
            ld   (ANI73+1),a
            jr   nz,$+2+1
            dec  d
            dec  c
            jr   nz,ANI72
            ret



ANI51       ld   a,(hl)
            srl  a
            srl  a
            ld   (de),a
            ld   a,l
            add  a,c
            ld   l,a
            inc  e
            jr   nz,ANI51
            inc  d
            ret

ANIT1       pop  de;10
            ld   l,e;4
            ld   e,(hl);7
            ld   a,(de);7
            ld   (bc),a;7
            inc  c;4;39

ANIT2       ld   a,(bc);7
            inc  c;4
            add  a,(hl);7
            inc  l;4
            ex   de,hl;4
            add  a,(hl);7
            inc  l;4
            exx  ;4
            add  a,(hl);7
            inc  l;4
            ld   c,a;4
            ld   a,(bc);7
            ld   (de),a;7
            inc  e;4
            exx  ;4;78





AMNINSTALL
            ld   a,#2C
            ld   yl,#C0
            call Z_MAIN

            ld   a,#26

            ld   de,#8000
            ld   h,#C0-#13
ANI10
            ld   l,#80-#40
            ld   bc,#0080
            ldir
            inc  h
            dec  a
            jr   nz,ANI10


            ld   a,USE_BN1
            call OOUT
            ld   hl,#8000
            ld   de,AM_MAP
            ld   bc,#1300
            ldir
            ret




ANPAN2
            ld   a,#38
TNCALL2
            ld   l,a
            ld   h,#00
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
            ld   de,ANVOLZ
            add  hl,de
            ld   (ANPNLIG+1),hl
            ret


ANRNDNM
            ld   (ANRN03+1),sp
            ld   sp,hl
            ld   h,ANRAYNDAT/#100
ANRN02      jp   ANRENDNLN
ANRN01      inc  bc
            dec  xl
            jr   nz,ANRN02
ANRN03      ld   sp,#3131
            ret






TNINS

            ld   a,#50
            call TNCALL2

            ld   de,ANRAYNDAT
            ld   b,ANSRLNTAB/#100
            ld   hl,ANRAYZ+#000
            exx
            ld   bc,ANRAYZ+#100
            ld   hl,ANRAYZ+#200
            ld   de,ANRAYZ+#300
            call ANGENNRAYZ
ANPNLIG
            ld   hl,#2121
            ld   (ANGENL1+1),sp
            ld   sp,hl
            jp   ANGENNLIGH
ANGENL1
            ld   sp,#3131
            ld   xl,#0D
            ld   hl,ANMAP
            ld   bc,ANBNSCR
            call ANRNDNM
            call ANPAN2
            ld   xl,#19
            ld   hl,ANMAP+#0680
            ld   bc,ANBNSCR+#0340
            call ANRNDNM



            ld   hl,ANBNSCR+#0C0+#10
            ld   de,ANBNSCR
            ld   xl,#20
TNC02       ld   bc,#20
            push bc
            ldir
            pop  bc
            add  hl,bc
            push hl
            ld   h,d
            ld   l,e
            dec  l
            ld   b,#20
TNC01       ld   a,(hl)
            sub  ANC2PNT
            ld   (hl),a
            ld   (de),a
            inc  de
            dec  l
            djnz TNC01
            pop  hl
            dec  xl
            jr   nz,TNC02

            ld   hl,ANBNSCR+#7FF
            ld   de,ANBNSCR+#800
            ld   bc,#40*#20
TNC03       ld   a,(hl)
            ld   (de),a
            dec  hl
            inc  de
            dec  bc
            ld   a,b
            or   c
            jr   nz,TNC03

            ld   a,USE_BN1
            call OOUT
            ld   hl,ANBNSCR
            ld   de,T_TXR
            ld   bc,#1000
            ldir
            jp   OOUT10


SERVICE
            call Servms
            call Servkj
            call Servqa

            ld   a,(DIRECTZ)
            ld   c,a
            ld   a,(DIRECTZ+5):or c
            jr   z,SV1
ВЫСТРЕЛ
            scf
            ret
SV1
            ld   a,(DIRECTZ+2):or a
            call nz,ROLDN
            ld   a,(DIRECTZ+1):or a
            call nz,ROLUP
            ld   a,(DIRECTZ+4):or a
            call nz,ROLLT
            ld   a,(DIRECTZ+3):or a
            call nz,ROLRT
            ld   a,(DIRECTJ+4):or a
            call nz,TURNLT
            ld   a,(DIRECTJ+3):or a
            call nz,TURNRT
            ld   a,(DIRECTJ+1):or a
            call nz,SPEEDUP
            ld   a,(DIRECTJ+2):or a
            call nz,SPEEDDOWN
            ret

■MOUSE DRIVER FROM ZX-FORMAT
DIRECTJ     db   0;FIRE
            db   0;UP
            db   0;DOWN
            db   0;RIGHT
            db   0;LEFT
            db   0;CANCEL
            db   0;MEDIUM

DIRECTZ     db   0;FIRE
            db   0;UP
            db   0;DOWN
            db   0;RIGHT
            db   0;LEFT
            db   0;CANCEL
            db   0;MEDIUM

MCOORD      dw   0

 УCTAHABЛИBAЮTCЯ b1 ECЛИ HAЖATO
Mports      dw   0;CORDS mЫXИ
Nondef      and  3
            jr   z,Mdrv4
            cp   1
            jr   z,Nondef_
            xor  a
            ld   (Mdrv3+2),a
            ld   a,5
            ld   (Mdrv2+2),a
Nondef_     ld   hl,0
            ld   (Mdrv1),hl
            pop  ix
■MAIN
Servms
            ld   a,0
            and  a
            ret  nz
SERVICE2
            push ix
            ld   hl,DIRECTJ
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
            ld   hl,DIRECTZ
            push hl
            pop  ix
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
Mdrv1       jr   Nondef
            rra
Mdrv2       rl   (ix+0)
            rra
Mdrv3       rl   (ix+5)
            rra
            rl   (ix+6)
Mdrv4
            ld   de,(Mports)
            ld   bc,#FBDF
            in   a,(c)
            ld   (Mports),a
            sub  e
            ld   (MCOORD+1),a
            jr   z,Mdrv9
            jp   p,Mdrv6
            ld   (ix+4),1
            jr   Mdrv9
Mdrv6
            ld   (ix+3),1
Mdrv9       ld   b,#FF
            in   a,(c)
            ld   (Mports+1),a
            sub  d
            ld   (MCOORD),a
            jr   z,Mdrv14
            neg
            jp   p,Mdrv11
            ld   (ix+1),1
            jr   Mdrv14
Mdrv11
            ld   (ix+2),1
Mdrv14
            pop  ix
            ret
Servkj
■SERVICE KEMPSTON JOYSTIC
            ld   a,0;FLAG
            and  a
            ret  nz
            in   a,(#1F)
            jp   Gomove

Servqa
■SERVICE QAOP sp
            ld   e,0
            ld   c,#FE
            ld   hl,(KUP)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  3,e
            ld   hl,(KDOWN)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  2,e
            ld   hl,(KLEFT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  1,e
            ld   hl,(KRIGHT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  0,e
            ld   hl,(KFIRE)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  4,e
            ld   a,e
Gomove
            ld   e,a
            xor  a
            ld   d,a
            rrc  e
            adc  a,a
            ld   hl,DIRECTJ+3
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTJ+4
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTJ+2
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTJ+1
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTJ
            or   (hl)
            ld   (hl),a
            ret



KUP     db #FD,#04;d
KDOWN   db #FE,#04;X
KLEFT   db #FE,#02;z
KRIGHT  db #FE,#08;c
KFIRE   db #FD,#01
KSPPUP  db #7F,#01
KSPDDWN db #7F,#02
KCOMPUT db #DF,#01
KNAVOD  db #BF,#10
KPUSK   db #FE,#08
KCLEAR  db #F7,#01
KJUMP   db #BF,#08
PROTROK db #FB,#01
DOKING  db #FD,#04
KBOMB   db #7F,#10




I_SIN_0

■ MIN #6200
■ MID #8000
■ MAX #9E00
            dw   #8000
LFTRGT      dw   #0000
            dw   #0000

I_SIN_1

■ MIN #7800
■ MID #8000
■ MAX #9200
            dw   #8000
UPDWN       dw   #0000
            dw   #0000




IM_IT

 db #14,#1C,#24,#2B,#31,#36,#3B,#00
 db #04,#08,#0B,#0E,#11,#13,#15,#16
 db #17,#18,#19,#1A,#1B,#1B,#1C,#1D
 db #1D,#1E,#1E,#1F,#1F,#20,#20,#21
 db #21,#21,#22,#22,#22,#23,#23,#23
 db #24,#24,#24,#25,#25,#25,#26,#26
 db #26,#26,#27,#27,#27,#27,#28,#28
 db #28,#28,#28,#29,#29,#29,#29,#29


C2P_SPR

 db #88,#88,#AA,#AA,#EE,#EE,#FF,#FF
 db #00,#22,#22,#AA,#AA,#BB,#BB,#FF

END



