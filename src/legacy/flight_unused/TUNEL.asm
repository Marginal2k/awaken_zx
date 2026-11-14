
;-----------------------------;
; SOURCE CODE OF GOA 4K INTRO ;
; 1998 EXPLODER/EXTREMELY     ;
; 1999 SOME REMAKES BY MYTHOS ;
;-----------------------------;
            org  #6400
TNSIN:      db   #FF,#FF,#FF,#FF,#FE,#FE,#FE,#FD
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


AM_MAP:     equ  #C000              ;LEN=#1300 UB1
T_TXR:      equ  #C000              ;LEN=#1000 UB1

USE_BN1:    equ  #14
USE_BN4:    equ  #16
PGZERO:     equ  #11

HIGH_:      equ  #18

            ; ent #6500   (ZASM entry point marker)

START:
            di   
            sub  a
            out  (#FE),a
            ld   hl,#5800
            ld   de,#5801
            ld   bc,#2FF
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
            ld   hl,END_
            ld   de,END_+1
            ld   bc,#C000-END_-1
            ld   (hl),0
            ldir 
            ld   a,USE_BN1
            call OOUT
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#12FF
            ld   (hl),l
            ldir 
            ld   a,USE_BN4
            call OOUT
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#3FFF
            ld   (hl),l
            ldir 

            call INSTALL
            call AMNINSTALL
            call IM_INSTALL
            ei   
            call ANINSTALL          ;RAYZ;3
            call TNINS
            call D_INSTALL
            call H_INSTALL          ;TUNNEL;3
            ld   c,0
            call CLNSCR
            ld   bc,300             ;TIME
            ld   hl,QN              ;ADR. OF outPROC.
            call YN

;-------
EXIT:       ld   sp,#3131
            ld   hl,0
            push hl
            jp   #3D2F



;-------------TUNNEL

QN:         ld   a,USE_BN4
            ld   de,#FFFF
;  ЧACTOTA KAДPOB, ЧEM БOЛЬШeTEM БЫCTPEE ЛETИm
;d-CKOPOCTЬ BPAЩEHИЯ
;e-CKOPOCTЬ ДbИЖEHИЯ bПEPEД
            ld   hl,I_SIN_0         ;ДAHHЫeO ЛЮФTE
            ld   bc,I_SIN_1
            jp   HNP00
;--
I_SIN_0:

;              dw     #7880
;             dw     #0000
;            dw     #0010


            dw   #8000
            dw   #0000
            dw   #0000

;              dw     #6880
;              dw     #0000
;              dw     #0018

I_SIN_1:
;              dw     #7A00
;              dw     #0000
;              dw     #000C

            dw   #8000
            dw   #0000
            dw   #0000

;              dw     #7380
;             dw     #0000
;            dw     #000C;14
;-------------------------------;
IM_INSTALL:
            ld   a,#6F
            ld   hl,IM_IT
            call Z_MAIN
            ld   de,#8000
            ld   h,#C0-#20
INI10:      ld   l,#00
INI11:      ld   a,(hl)
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
            ld   a,USE_BN4
HNI20:      call OOUT
            jp   B_I30
IM_IT:

            db   #14,#1C,#24,#2B,#31,#36,#3B,#00
            db   #04,#08,#0B,#0E,#11,#13,#15,#16
            db   #17,#18,#19,#1A,#1B,#1B,#1C,#1D
            db   #1D,#1E,#1E,#1F,#1F,#20,#20,#21
            db   #21,#21,#22,#22,#22,#23,#23,#23
            db   #24,#24,#24,#25,#25,#25,#26,#26
            db   #26,#26,#27,#27,#27,#27,#28,#28
            db   #28,#28,#28,#29,#29,#29,#29,#29



;---------------------;
HNC2PNT:    equ  #80
H_REND_LN:  equ  #7E00              ;COD=#0200
HNBNSCR:    equ  #80C0              ;BUF=#2600 #40 X #26


HNP00:
            call HHALT
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
            add  a,#60-HIGH_
            ld   (HNMP+2),a
;-------
HNMAIN:
            ld   d,HNBNSCR/#100
            exx  
HNMP:       ld   hl,CNMAP+#2000-#1300+#40
CNMAP:      equ  #C000              ;MAP=#4000
            call HNREND
;-
            call HHALT
;-
            call HNREND

            jp   C2PN
;-------
HNREND:     ld   (HNSP+1),sp
            ld   b,HIGH_
HNC01:      ld   sp,hl
            inc  h
            exx  
HNTP:       ld   bc,#8000
            ld   e,HNBNSCR
            jp   H_REND_LN
HNRET:      inc  d
            exx  
            djnz HNC01
HNSP:       ld   sp,#3131
            ret  


;-------------------------------;
H_INSTALL:
;---------
            ld   de,H_REND_LN
            ld   hl,H_IT1
            ld   bc,#4007
            call MOVES
            ld   de,HNRET
            call EXITN1
;-----------
            ld   ixl,HNC2PNT
            call B_I00
;-------
            ld   ixl,HNC2PNT
            ld   de,HNBNSCR
            ld   bc,#0100
            call C2P_I_S
            jp   C2P_IAD
;-------
H_IT1:      pop  hl                 ;10
            add  hl,bc              ;11
            res  6,h                ;8
            ld   a,(hl)             ;7
            ld   (de),a             ;7
            inc  e                  ;7;47


;---------------------;
B_TXR_BUF:  equ  #8000              ;TXR=#7000
;---------------

B_I00:      ld   a,USE_BN1
            call OOUT
            ld   d,B_TXR_BUF/#100
            ld   hl,T_TXR
B_I02:      ld   e,#00
            ld   b,#40
B_I01:      ld   a,(hl)
            add  a,ixl
            ld   (de),a
            inc  hl
            inc  e
            djnz B_I01
            inc  d
            bit  6,d
            jr   z,B_I02
;-
            ld   h,B_TXR_BUF/#100
            ld   d,h
B_I11:      ld   bc,#00C0
            ld   l,b
            ld   e,#40
            ldir 
            inc  h
            bit  6,h
            jr   z,B_I11
            jp   OOUT10
;--
B_I30:      ld   bc,#4000
            ld   hl,B_TXR_BUF
            ld   de,B_TXR_BUF+#4000
            ldir 
            ret  

;---------------------;
Z_MAIN:     ld   (ZNT00+1),hl
            ld   (ZNX00+1),a
            call OOUT10
            ld   hl,#0000
            ld   (TNVND1+1),hl
            ld   hl,#4000
            ld   (TNVND2+1),hl
            ld   hl,#8000
            ld   bc,#7FFF
            ld   a,c
            call FILL
;---
            ld   b,#3F
ZNI02:      push bc
ZNT00:      ld   hl,#2121
            ld   a,(hl)
            inc  hl
            ld   (ZNT00+1),hl
ZNX00:      ld   iyl,a              ;#6F ;#2C
;--
            ld   bc,#8000
TNVND1:     ld   de,#0000
            inc  e
            inc  e
            inc  e
            inc  de
            ld   (TNVND1+1),de
TNVND2:     ld   hl,#4000
            dec  h
            ld   (TNVND2+1),hl
TNVNC1:     ld   a,h
            ld   (bc),a
            add  hl,de
            inc  c
            bit  7,c
            jp   z,TNVNC1
;---
            ld   bc,TNSIN
            ld   ix,TNSIN+#40
ZNI01:      ld   h,#80
            ld   a,(bc)
            ld   l,a
            srl  l
            ld   e,(hl)
            ld   l,(ix+0)
            srl  l
            ld   d,(hl)
            sla  e
            set  7,d
;-
            ld   a,c
            ld   (de),a
            inc  e
            ld   a,iyl
            ld   (de),a
;-
            inc  ixl
            inc  c
            jr   nz,ZNI01
            pop  bc
            djnz ZNI02
;-------
            ld   ixl,#02
ZNI22:      ld   hl,#8100
ZNI20:      inc  l
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
ZNI21:      inc  hl
            bit  7,h
            jr   nz,ZNI20
            dec  ixl
            jr   nz,ZNI22
            ret  
;----------------------------------------
C2PNTP1:    equ  #6000
C2PNSR1:    equ  #60C0
C2PNTP2:    equ  #6100
C2PNSR2:    equ  #61C0
;-------
C2PN:
C2PN1:      ld   a,#00
            add  a,#80
            ld   (C2PN1+1),a
BNADD1:     ld   hl,#0000
            jr   nz,$+2+2
BLURNON:
            ld   h,#14
            ld   (C2PNAD1),hl
            call HHALT
            jr   nz,C2PNC00
            ld   hl,C2PNTP2
            call C2PNLNZ
            ld   hl,C2PNSR1
            call C2PNMOV
            ld   hl,C2PNTP1
            jr   C2PNLNZ
C2PNC00:
            ld   hl,C2PNTP1
            call C2PNLNZ
            ld   hl,C2PNSR2
            call C2PNMOV
            ld   hl,C2PNTP2
;-------
C2PNLNZ:
            ld   (C2PNSP1+1),hl
            ld   (C2PNSP2+1),sp
            ld   a,#26
C2PNSP1:
            ld   sp,#3131
            pop  hl
            pop  de
            ld   (C2PNSP1+1),sp
C2PNAD1:
            nop  
            nop  
            ld   sp,hl
            rept #20
            pop  hl
            ldi  
            endr
            dec  a
            jp   nz,C2PNSP1
C2PNSP2:
            ld   sp,#3131
            ret  
C2PNMOV:
            ld   (C2PNSP3+1),sp
            ld   sp,hl
C2PNMVE:
            ds   #80
C2PNSP3:
            ld   sp,#3131
            ret  
;-------
C2P_I_S:
            exx  
            ld   hl,C2PNMVE
            ld   d,ixl
            ld   c,#08
C2PNI02:
            ld   e,ixl
            ld   b,#04
C2PNI01:
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
            ld   a,#26
            call C2PNI20
;--
            ld   de,C2PNSR1
            ld   hl,C2P_SPR
            ld   b,h
            ld   c,l
            call C2PNI32
            ld   de,C2PNSR2
            ld   b,h
            ld   c,l
C2PNI32:
            ld   ixh,#08
C2PNI31:
            ld   ixl,#08
            ld   a,(hl)
            inc  hl
            and  #0F
            ld   iyl,a
            push bc
C2PNI30:
            ld   a,(bc)
            inc  bc
            and  #F0
            or   iyl
            ld   (de),a
            inc  e
            dec  ixl
            jr   nz,C2PNI30
            pop  bc
            dec  ixh
            jr   nz,C2PNI31
            ret  
C2P_IAD:
            halt 
            ld   a,(C2PN1+1)
            or   a
            ld   hl,C2PNSR1
            jr   z,$+2+3
            ld   hl,C2PNSR2
            jp   C2PNMOV
C2P_SPR:
            db   #88,#88,#AA,#AA,#EE,#EE,#FF,#FF
            db   #00,#22,#22,#AA,#AA,#BB,#BB,#FF
;-------
C2PNI20:
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
            ret  
;----------------------------------------
INSTALL:
;-------
            ld   hl,TNSIN+#7F
            ld   de,TNSIN+#81
            ld   a,(hl)
            ld   (de),a
            dec  l
            inc  e
            jr   nz,$-2-2
;-------
            ld   hl,C2PNTP1
            ld   de,#4000           ;4040
            ld   b,HIGH_
C2PNI10:
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
            ld   b,HIGH_*2
C2PNI11:
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
;-------
EXITN1:     ld   (hl),#C3
            inc  hl
            ld   (hl),e
            inc  hl
            ld   (hl),d
            ret  
EXITN2:     ld   (hl),#DD
            inc  hl
            ld   (hl),#E9
            ret  
OOUT10:     ld   a,PGZERO
OOUT:       ld   bc,#7FFD
            out  (c),a
            ret  
HHALT:      ei   
            halt 
            di   
            ret  
FILL:       ld   d,h
            ld   e,l
            inc  de
            ld   (hl),a
            ldir 
            ret  
MOVES:      ld   a,b
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
SIN:        ld   (SINNSP1+1),sp
            di   
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
SINNSP1:
            ld   sp,#3131
            ei   
            ret  
;-------
YN:
            ld   (YNCD+1),hl
YNC1:       push bc
YNCD:       call #CDCD
            pop  bc
            dec  bc
            ld   a,b
            or   c
            jr   nz,YNC1
;-------
            ei   
CLNSCR:
            ld   hl,#4000
            ld   b,HIGH_*8
M11:
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
            jp   nz,$+13
            ld   a,l
            add  a,32
            ld   l,a
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            djnz M11
            ret  


;---------------------;
D_C2P_T:    equ  #C0
D_VOXELZ:   equ  #8000              ;BUF=#4000
DNMAKENLN:  equ  #D000              ;COD=#0800
D_B_SCR:    equ  #D800              ;BUF=#2600 #00-#40 - SCR BUFF

D_VOLMZ:    equ  #D840              ;TAB=#2600 #40-#A0 - TAB VOLU
;MZ
D_BRIGHTZ:  equ  #DAE0              ;TAB=#2600 #A0-#00 - TAB BR
;IGHTZ

;---------------
D_INSTALL:
;-------
            call OOUT10
;--
            ld   de,DNMAKENLN
            ld   hl,DNIT1
            ld   bc,#400D+10+2
            call MOVES
            ld   (hl),#C9
;-------
            ld   ixh,D_VOLMZ/#100
            ld   hl,D_B_SCR-#0000
            ld   de,#0100
            ld   c,HIGH_            ;#26
DNI22:      push hl
            ld   ixl,D_VOLMZ
            ld   b,#60
DNI21:      ld   a,h
            cp   D_VOLMZ/#100+HIGH_ ;#26
            jr   c,$+2+1
            sub  a
            cp   D_VOLMZ/#100
            jr   nc,$+2+1
            sub  a
            ld   (ix+0),a
            inc  ixl
            add  hl,de
            djnz DNI21
            inc  ixh
            ld   hl,#FFFB           ;COMPRESS
            add  hl,de
            ex   de,hl
            pop  hl
            dec  c
            jr   nz,DNI22
;-------
            ld   d,D_BRIGHTZ/#100
            ld   a,HIGH_*2          ;#26
DNI31:      ld   e,D_BRIGHTZ
            ld   hl,DNIT2
            ld   bc,#0020
            ldir 
            dec  a
            jr   nz,DNI31
            ld   (BLURNON+1),a
;-------
            ld   ixl,#00
            call B_I00
;-------
            ld   hl,D_VOXELZ
            push hl
            ld   de,D_VOXELZ+#4000
            ld   bc,#0100
            ldir 
            pop  hl
DNI52:      ld   l,#00
DNI51:      ld   a,(hl)
            inc  h
            add  a,(hl)
            inc  l
            add  a,(hl)
            dec  h
            add  a,(hl)
            dec  l
            add  a,D_VOLMZ
            ld   (hl),a
            inc  l
            bit  6,l
            jr   z,DNI51
            ld   e,l
            ld   d,h
            ld   bc,#00C0
            ld   l,b
            ldir 
            inc  h
            bit  6,h
            jr   z,DNI52
;-------
            sub  a
            ld   (C2P_SPR),a
            ld   ixl,D_C2P_T
            ld   de,D_B_SCR
            ld   bc,#0100
            call C2P_I_S
            jp   C2P_IAD
;-------
DNIT1:      add  hl,bc              ;11
            ld   e,h                ;4
            ld   a,(de)             ;7
            exx                     ;4
            add  a,b                ;8
            ld   l,a                ;4
            ld   d,(hl)             ;7
            add  a,c                ;4
            ld   l,a                ;4
            ld   a,(hl)             ;7
            rept #06
            ld   (de),a             ;7
            inc  d                  ;4
            endr
            ld   (de),a             ;7
            inc  e                  ;4;54
            exx  
;-------
DNIT2:
            db   #C7,#C7,#C7,#C7
            db   #C6,#C6,#C6,#C6
            db   #C5,#C5,#C5,#C5
            db   #C4,#C4,#C4,#C4
            db   #C4,#C3,#C3,#C3
            db   #C3,#C3,#C2,#C2
            db   #C2,#C2,#C2,#C1
            db   #C1,#C1,#C1,#C1

;---------------------;
ANC2PNT:    equ  #89
ANBNSCR:    equ  #8000              ;BUF=#0980
ANRENDNLN:  equ  #9100              ;COD=#0180
ANRAYNDAT:  equ  #9300              ;BUF=#0100
ANRAYZ:     equ  #9400              ;TAB=#0400
ANSRLNTAB:  equ  #9800              ;TAB=#0100
ANGENNRAYZ: equ  #9900              ;COD=#0F00
ANGENNLIGH: equ  #A800              ;COD=#0480
ANMAP:      equ  #AD00              ;MAP=#1300
ANLIGHNVOL: equ  #C000              ;TAB=#2600
ANVOLZ:     equ  #F000              ;TAB=#1000
;---------------
AN:         call HHALT
            call ANPAN2
;--
            call ANPAN1
;-------
TNCALL:     ld   de,ANRAYNDAT
            ld   b,ANSRLNTAB/#100
ANPRAY1:
            ld   hl,ANRAYZ+#000
            exx  
ANPRAY2:
            ld   bc,ANRAYZ+#100
ANPRAY3:
            ld   hl,ANRAYZ+#200
ANPRAY4:
            ld   de,ANRAYZ+#300
            call ANGENNRAYZ
;-------
ANPNLIG:
            ld   hl,#2121
            ld   (ANGENL1+1),sp
            ld   sp,hl
            jp   ANGENNLIGH
ANGENL1:
            ld   sp,#3131
;--
            ld   ixl,#0D
            ld   hl,ANMAP
            ld   bc,ANBNSCR
            call ANRNDNM
;--
            call HHALT
            call ANPAN2
;--
            ld   ixl,#19
            ld   hl,ANMAP+#0680
            ld   bc,ANBNSCR+#0340
TNRET:      call ANRNDNM
;-------
            call ANPAN2
            jp   C2PN
;---------------
ANRNDNM:
            ld   (ANRN03+1),sp
            ld   sp,hl
            ld   h,ANRAYNDAT/#100
ANRN02:     jp   ANRENDNLN
ANRN01:     inc  bc
            dec  ixl
            jr   nz,ANRN02
ANRN03:     ld   sp,#3131
            ret  
;---------------
ANPAN1:
            ld   hl,ANSINN1
            call SIN
            ld   (ANPRAY1+1),a
            ld   hl,ANSINN2
            call SIN
            ld   (ANPRAY2+1),a
            ld   hl,ANSINN3
            call SIN
            ld   (ANPRAY3+1),a
ANSINN4:
            ld   hl,TNSIN
            inc  l
            inc  l
            inc  l
            ld   (ANSINN4+1),hl
            ld   a,(hl)
            srl  a
            ld   (ANPRAY4+1),a
            ret  
;-------
ANPAN2:
ANSINN6:
            ld   a,#A1
            dec  a
            jr   nz,$+2+1
            inc  a
            ld   (ANSINN6+1),a
            dec  a
            jr   z,ANSINN5
ANSINN7:
            ld   a,#00
            inc  a
            bit  6,a
            jr   z,$+2+1
            dec  a
            ld   (ANSINN7+1),a
            srl  a
            add  a,#27
            jr   TNCALL2
ANSINN5:
            ld   a,0
            inc  a
            cp   40
            jr   nz,$+2+1
            sub  a
            ld   (ANSINN5+1),a
            ld   e,a
            ld   d,#00
            ld   hl,ANTNMUZYKI
            add  hl,de
            ld   a,(hl)
            add  a,#38
TNCALL2:
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
;---------------
ANTNMUZYKI:
            db   #0F,#0F,#0F,#0E,#0E
            db   #0D,#0D,#0C,#0B,#0A
            db   #0A,#08,#07,#05,#04
            db   #03,#02,#01,#00,#00
            db   #00,#02,#03,#04,#05
            db   #07,#08,#09,#0A,#0A
            db   #0B,#0C,#0D,#0D,#0E
            db   #0E,#0F,#0F,#0F,#0F
;-------
ANSINN1:
            dw   #5080
            dw   #0000
            dw   #0030
ANSINN2:
            dw   #4080
            dw   #0000
            dw   #0018
ANSINN3:
            dw   #5880
            dw   #0000
            dw   #0038
;-------------------------------;
ANINSTALL:
            ld   a,USE_BN1
            call OOUT
            ld   hl,AM_MAP
            ld   de,ANMAP
            ld   bc,#1300
            ldir 
            call OOUT10

;-------
            ld   de,ANRENDNLN
            ld   hl,ANIT1
            ld   bc,#4006
            call MOVES
            dec  hl
            ld   de,ANRN01
            call EXITN1
;-------
            ld   de,ANGENNRAYZ
            ld   hl,ANIT2
            ld   bc,#000F
            call MOVES
            dec  hl
            dec  hl
            ld   (hl),#C9
;-------
            ld   hl,ANGENNLIGH
            ld   de,ANLIGHNVOL
            ld   c,#26
ANI32:      ld   b,#08
ANI31:      ld   (hl),#E1
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
;-------
            ld   hl,ANSRLNTAB
ANI41:      ld   a,l
            rrca 
            rrca 
            rrca 
            rrca 
            and  #0F
            ld   (hl),a
            inc  l
            jr   nz,ANI41
;-------
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
;-------
            ld   hl,ANVOLZ
            ld   d,#B0
            ld   c,#00
ANI72:      ld   e,d
            ld   b,#10
ANI71:      ld   a,e
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
ANI73:      ld   a,#80
            add  a,#80
            ld   (ANI73+1),a
            jr   nz,$+2+1
            dec  d
            dec  c
            jr   nz,ANI72
;-------
            ld   ixl,#28
            call ANPAN1
            dec  ixl
            jr   nz,$-2-3
;-------
            ld   a,#88
            ld   (C2P_SPR),a
            ld   ixl,ANC2PNT
            ld   de,ANBNSCR
            ld   bc,#0040
            call C2P_I_S

            jp   C2P_IAD
;-------
ANI51:      ld   a,(hl)
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
;-------
ANIT1:      pop  de                 ;10
            ld   l,e                ;4
            ld   e,(hl)             ;7
            ld   a,(de)             ;7
            ld   (bc),a             ;7
            inc  c                  ;4;39
;-------
ANIT2:      ld   a,(bc)             ;7
            inc  c                  ;4
            add  a,(hl)             ;7
            inc  l                  ;4
            ex   de,hl              ;4
            add  a,(hl)             ;7
            inc  l                  ;4
            exx                     ;4
            add  a,(hl)             ;7
            inc  l                  ;4
            ld   c,a                ;4
            ld   a,(bc)             ;7
            ld   (de),a             ;7
            inc  e                  ;4
            exx                     ;4;78
;-------------------------------;
AMNINSTALL:
            ld   a,#2C
            ld   iyl,#C0
            call Z_MAIN
            ld   de,#8000
            ld   h,#C0-#13
ANI10:      ld   l,#80-#40
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

TNINS:      ei   
            ld   a,#C3
            ld   (TNRET),a
;-
            ld   a,#50
            call TNCALL2
            sub  a
            ld   (ANPRAY1+1),a
            ld   (ANPRAY2+1),a
            ld   (ANPRAY3+1),a
            ld   (ANPRAY4+1),a

            ld   h,TNSIN/#100
            ld   de,ANRAYZ
            ld   c,#03
            call ANI51
            call ANI51
            ld   c,#05
            call ANI51
            call ANI51
;-------
            call TNCALL
            ei   
            ld   hl,ANBNSCR+#0C0+#10
            ld   de,ANBNSCR
            ld   ixl,#20
TNC02:      ld   bc,#20
            push bc
            ldir 
            pop  bc
            add  hl,bc
            push hl
            ld   h,d
            ld   l,e
            dec  l
            ld   b,#20
TNC01:      ld   a,(hl)
            sub  ANC2PNT
            ld   (hl),a
            ld   (de),a
            inc  de
            dec  l
            djnz TNC01
            pop  hl
            dec  ixl
            jr   nz,TNC02
            ld   hl,ANBNSCR+#7FF
            ld   de,ANBNSCR+#800
            ld   bc,#40*#20
TNC03:      ld   a,(hl)
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
END_:


