■RET_       ■Dalee
■Int        ■LMUSIC
■Tfire      ■Suroff
■Suron      ■Repaint
■Tident     ■Fire
■Unclick    ■Chccl
■Click      ■Ibscr
■Itabob     ■TOOBJ4
■TOOBJ      ■DEPACK













RET_
            ret




■BEGIN MAKING SCREEN
Dalee
            xor  a
            ld   (WYDWOR+1),a
            ld   (PLATA+1),a
            ld   a,#80
            ld   (ZAPRET+1),a
            call RANDTT
            xor  a:ld (ZAPRET+1),a
            call Repaint

НАЧАЛЬНАЯ ПРОВЕРКА
            PAGES PGLANG
            ld   a,15
            ld   (OPERATION),a
            call PARADOX
            PAGES



M1

FORRP
            ld   a,0
            and  a
            call z,Repaint

            halt



ZADACHA     call RET_

IXZD
            ld   ix,0
ZADAT
            call RET_
            ld   hl,RET_
            ld   (ZADAT+1),hl


PLATA       ld   a,0:or a
            jrz  PL_1
            xor  a:ld (PLATA+1),a
            ld   (FORRP+1),a
            PAGES PGLANG
            ld   a,16
            ld   (OPERATION),a
            call PARADOX
            PAGES
PL_1

WYDWOR      ld   a,0:dec a
            jpm  PL_2
            ld   (WYDWOR+1),a
            jrnz PL_2

ВЫДВОРЕНИЕ В КОСМОС

PL_2


ВЫВОД ЧАСОВ
            call STOREW
            call LINE2_
            call RESTORW

            call Tfire
            ld   c,a

OLDFIRE
            ld   d,0

            ld   a,c
            ld   (OLDFIRE+1),a

            or   d
            jp   z,M1
            ld   a,c
            cp   d
            jp   nc,M23
            call Unclick
            jp   M1
M23
            call Fire
            jp   M1




Int
            di
            ld   (STK7+1),sp
            ld   sp,STKL
            push ix,iy,af,hl,de,bc
            exa
            push af
            exx
            push hl,de,bc

            ld   a,(NPG):push af

            PAGES


            call Cler
            call Servkj
            call Servqa
            call Servms


FWOST
            ld   a,0:or a:jr nz,FW1
            call Outcur
FW1

            ld   a,(MUSIC)
            cp   #81
            jr   z,INT4
            ld   c,a
            ld   a,(LMUSIC+1):cp c
            ld   (LMUSIC+1),a
            jr   z,INT3
            ld   bc,#FFFD
            ld   a,7:out (c),a:in a,(c)
            ld   (L7+1),a
            ld   a,b
            ld   b,#BF:out (c),a
            ld   b,a
            ld   a,8:out (c),a
            xor  a:ld b,#BF
            out  (c),a
            ld   b,#FF
            ld   a,9:out (c),a:xor a
            ld   b,#BF:out (c),a
            ld   b,#FF
            ld   a,10:out (c),a:xor a
            ld   b,#BF:out (c),a
            jr   INT3

INT4
ИГРАТЬ МУЗОН
LMUSIC
            cp   0
            ld   (LMUSIC+1),a
            jr   z,INT5
            ld   bc,#FFFD
            ld   a,7:out (c),a:ld b,#BF
L7
            ld   a,0:out (c),a
INT5
            PAGES PGMUZ
            call #DB05

INT3
            ld   a,50
            dec  a
            ld   ($-2),a
            jr   nz,INT2
            ld   a,50
            ld   ($-9),a
            ld   a,(TIME+3):add a,1:daa
            ld   (TIME+3),a
            ld   a,1
            jrc  $+3:dec a:ld (PLATA+1),a
            ld   a,(TIME+2):adc a,0:daa
            ld   (TIME+2),a
            ld   a,(TIME):adc a,0:daa
            ld   (TIME),a
            ld   a,(TIME+1):adc a,0:daa
            ld   (TIME+1),a
INT2

            pop  af:call PG

            ld   hl,(STK7+1)
            ld   e,(hl):inc hl
            ld   d,(hl):inc hl
            ld   (STK7+1),hl
            ld   (JUMP0+1),de

            ld   hl,CW2+2
            ld   (STKO),hl
            ld   hl,CW2+4
            ld   (STKO+2),hl
            ld   hl,CW2+6
            ld   (STKO+4),hl
            ld   hl,CW2+8
            ld   (STKO+6),hl
            ld   hl,CW2+10
            ld   (STKO+8),hl
            ld   hl,CW2+12
            ld   (STKO+10),hl
            ld   hl,CW2+14
            ld   (STKO+12),hl
            ld   hl,CW2+16
            ld   (STKO+14),hl
            ld   hl,CW2+18
            ld   (STKO+16),hl

            pop  bc,de,hl
            exx
            pop  af
            exa
            pop  bc,de,hl,af,iy,ix
STK7
            ld   sp,0
            ei
JUMP0
            jp   0


            ds   #30
STKL


Tfire
■TAKE ABOUT FIRE retina
А=0 НИЧЕГО НЕ НАЖАТО
Б0=1 ОТМЕНА
Б1=1 ОГОНЬ
            push bc
            ld   a,(Directj+4)
            ld   c,a
            ld   a,(Directz)
            or   c:add a,a:ld c,a
            ld   a,(Directj+5)
            ld   b,a
            ld   a,(Directz+5)
            or   b:or c
            pop  bc
            ret
Suroff
■BCE OБЪEKTЫ CPEДЫ БУДУT bOФФ,T.E. HEB
ИДИmЫ И HE ДOCЯГAEMЫ
■hl-ADR OF SURROUND
            ld   a,(hl)
            ld   e,a
            inc  hl
            ld   a,(hl)
            dec  a
            ret  z
            inc  a
            inc  hl
            ld   d,a
            ld   a,#C9;ПpИ3HAK OФФ
            ld   (de),a
            jp   Suroff
Suron
■BCE OБЪEKTЫ CPEДЫ БУДУT bOH,T.E. MOУT
■ БЫTЬ bИДИmЫ
■hl-ADR OF SURROUND
            ld   a,(hl)
            ld   e,a
            inc  hl
            ld   a,(hl)
            dec  a
            retz
            inc  a
            inc  hl
            ld   d,a
            ld   a,#21;ПpИ3HAK OH
            ld   (de),a
            jp   Suron









Repaint
ПEPEPИCOBATЬ EKPAH bOБЪEKTAX
■OЧИCTKA TAБЛИЦ И БУФEPOB, ДИ3AKTИBAЦИЯ
■ BCEX OБЪEKTOB
■AKTИBAЦИЯ OБЪEKTOB ДAHHOЙ CPEДЫ

ЕСЛИ НЕ ОТПУЩЕНА КНОПКА ТО НЕ ПЕРЕРИСОВ
            ld   a,(Unclick+1):or a:ret nz

            call HIDESCR

            ld   a,(INK)
            ld   c,a
            ld   a,(PAPER)
            rlca
            rlca
            rlca
            or   c:ld c,a
            ld   a,(BRIGHT)
            rrca
            rrca
            or   c
            ld   (OCOLOR+1),a

            ld   a,1
            ld   (FORRP+1),a
            call Ibscr
            call Itabob
            ld   hl,Sur1
            call Suroff


Adnsur      ld   hl,Sur1
■ADR SUR THAT NOW
            push hl
■AKTИBAЦИЯ OБЪEKTOB CPEДЫ
ACTIV       ld   a,0
            and  a
            call z,Suron
            pop  hl
СОРТИРОВКА ОБЪЕКТОВ ТАК:
ПЕРВЫЕ НА СТОЛ КНОПКИ, КРОМЕ ТОЙ
КОТОРАЯ МОЖЕТ БЫТЬ САМОЙ ПОСЛЕДНЕЙ
ПОТОМ ОКНА ПО ПОРЯДКУ
            push hl,hl
            pop  ix
            ld   bc,Objvec+4
            ld   a,1:cp (ix+1)
            jr   z,E_S1
E_S2
            ld   a,1:cp (ix+3)
            jr   z,E_S1
            ld   h,(ix+1)
            ld   l,(ix+0)
            inc  hl
            ld   a,(hl):inc hl
            ld   h,(hl)
            ld   l,a
            ADDHLHL 4
            add  hl,bc
            ld   a,(hl)
            and  %11100000
            cp   %01000000
            inc  ix,ix
            jr   nz,E_S2
КНОПКА КОТОРАЯ СОРТИТСЯ НА НИЗ СТОЛА

            push bc
РАЗЖАТИЕ В САМОМ НАЧАЛЕ
            ld   hl,(Adnsur+1)
            ld   bc,OVLEN-1
            add  hl,bc
            ld   d,h
            ld   e,l:INC_DE 2
            ld   bc,OVLEN:lddr

СЖАТИЕ В МЕСТЕ ОБЪЕКТА
            ld   c,(ix+0)
            ld   b,(ix+1):push bc
            push ix:pop hl
            ld   d,h
            ld   e,l:INC_HL 2
            ld   bc,OVLEN
            ldir
            ld   hl,(Adnsur+1):pop bc
            ld   (hl),c:inc hl
            ld   (hl),b

            pop  bc
            jp   E_S2
E_S1
            pop  hl
■bЫBOД OБЪEKTOB CPEДЫ
Rp3
            ld   e,(hl)
            inc  hl
            ld   a,(hl)
            dec  a
            jp   z,Rp1
            inc  a
            inc  hl
            ld   d,a
            push hl
            ld   hl,Rp2
            push hl
            EXD
            jp   (hl)
Rp2
            pop  hl
            jp   Rp3
ЧИCTKA EKPAHA OT ЧACTEЙ ЛИШhИX OБЪEKTO
■b,HA BCEГO EKPAHA
Rp1
            PAGES PGBGD
            ld   hl,#5800
            ld   de,Backscr+#1800
            ld   b,Tabob.h
            exx
            ld   hl,Bscr
            ld   de,#4000
            ld   bc,Backscr;ADR OF BACK
■SCR
Nbs2
            ld   a,(hl)
            and  a
            jr   z,Nbs3
            exx
            dec  a
            rlca
            ld   c,a
            inc  c
            ld   a,(bc)
            inc  a
OCOLOR      ld   c,0
            exx
            jp   z,Nbs3
            ld   a,c
            add  a,7
            ld   c,a
            inc  bc
            ld   a,d
            jp   Nbs1
Nbs3
            ld   a,d:exa
 rept7:lda,(bc):incc:ld(de),a:incd:endr

            ld   a,(bc)
            inc  bc
            ld   (de),a

            exx:ld a,(de):ld c,a:exx

            exa
Nbs1
            inc  e
            jrnz $+4
            add  a,8
            ld   d,a
            inc  hl

            exx:ld (hl),c:inc hl,de:exx

            ld   a,h
            cp   Bscr.h+3
            jpc  Nbs2
            PAGES
            jp   RETSCR



Tident
■TAKE IDENT UNDE CURSOR ina
■DESTROY hl,bc
            ld   bc,(Mcoord)
            srl  b
            srl  b
            srl  b
            srl  c
            srl  c
            srl  c
Tident2
            ld   a,b
            and  #18
            rra
            rra
            rra
            add  a,Bscr.h
            ld   h,a
            ld   a,b
            and  7
            rra
            rra
            rra
            rra
            add  a,c
            ld   l,a
            ld   a,(hl)
            ret
Fire
■CHOOSE SOME THING
            jr   nz,$+4
            or   #80
            ld   hl,#FFF0
            ld   (DNUM+1),hl
            push af
            call Tident
            and  a
            jp   z,Nthf
            dec  a
            rlca
            ld   l,a
            ld   h,Tabob.h
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  h
            jp   z,Nthf
            dec  h
            ld   d,h
            ld   e,l

            ld   (DNUM+1),hl
            push hl,de
            call N_L2
            pop  de,hl
            ld   a,(FORRP+1):or a:jr z,EXF

            xor  a:call TOOBJ
            push hl:pop ix
            INC_HL 4
            ld   a,(hl);SETUP BYTE
            ld   (SPBYTE+1),a
            inc  hl,hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a:INC_HL 3
            pop  af
            dec  a
            ld   (KFC),a
            jp   (hl)
EXF
            pop  af:ret

Nthf
            ld   a,(ACTIV+1)
            and  a
            jr   z,$+9
            xor  a:ld (ACTIV+1),a
            ld   (FORRP+1),a
            pop  af
            dec  a
            jr   z,N_L1
            dec  a
            ret  nz
СТИРАНИЕ ОКОН КОТОРЫЕ ПО FIRE BACKGROUN
ДОЛЖНЫ УДАЛЯТСЯ
N_L2
            ld   hl,(Adnsur+1)
            inc  hl
            ld   b,(hl)
            dec  b:ret z
            inc  b:dec hl
            ld   c,(hl)
            inc  bc
            ld   a,(bc):inc bc:ld e,a
            ld   a,(bc)
            ld   d,a
            push hl
НОМЕР ОБЪЕКТА КОТ. НЕ СТИРАТЬ
DNUM        ld   hl,#FFF0
            xor  a:sbc hl,de
            jr   z,DN1
            ld   l,e
            ld   h,d
            call TOOBJ4
            ld   a,(hl):and %11100000
DN1
            cp   %00100000
            pop  hl
            INC_HL 2
            jp   nz,N_L2+3
            call ERSOBJ2
            jp   N_L2

N_L1
ПОЯВЛЕНИЕ СЕТАП ОКНА ПО ОТМЕНЕ
            ld   (KFC),a
            ld   hl,(Mcoord)
            rept 3:srl h:srl l:endr
            ld   a,h
            cp   15:jr c,$+4:ld h,15
            ld   a,l
            cp   23:jr c,$+4:ld l,23
            ld   (CWHIDE),hl
            ld   hl,WHIDE_
            jp   NEWOBJ








■--------------
Unclick
ОТЖАТИЕ ПОСЛЕДНЕЙ НАЖАТОЙ КНОПКИ
■retFZ-КАК В Mactive
            ld   a,0
            and  a
            ret  z
            push de,hl
Rghl        ld   de,0
            call Mactive
            call Click
            xor  a:ld (Unclick+1),a
UNPROC      call RET_
            ld   hl,RET_
            ld   (UNPROC+1),hl
            pop  hl,de
            scf:ret




■-------------
Chccl
■CHECK,HAДO ЛИ bЫПOЛЯHTЬ OБPAБOTЧИK
■de-NUMBER OF OBJ
■retFZ-OFF=1 ETA ЖeKHOПKA
            push hl,de,bc
            EXD
            call TOOBJ4
            ld   a,(hl)
            pop  bc,de,hl
            and  1
            ret







■--------------
Click
■CLICK SOME BUTTON
■de-NUMBER OF OBJ
            push hl,bc,de
            EXD
            call TOOBJ4
            ld   a,(hl)
            bit  4,a
            jr   nz,R_CL
            xor  1:ld (hl),a
            call WOST
            pop  hl:push hl
            halt
            call Outbut
            call OUTC
R_CL
            pop  de,bc,hl
            ret






■-------------------
Ibscr
■INIT BUF SCREEN
■WHERE IDENTS IS ПO BCEЙ ПЛOЩaДИ OБЪEKTA
            push hl,de,bc
            ld   hl,Bscr
            ld   de,Bscr+1
            ld   bc,#02FF
            ld   (hl),l
            ldir
            pop  bc,de,hl
            ret
Itabob
■INIT TABOB
■1-IDENT OF OBJECT   FROM "1"
■ZERO IS VOID FIELD ON SCREEN
■2-3-ADR OБPAБOTЧИKA
■if3=0 THAN IDENT FREE
■MAX #55 IDENTS
            push hl,de,bc
            ld   hl,Tabob
            ld   de,Tabob+1
            ld   bc,#7F
            ld   (hl),#FF
            ldir
            pop  bc,de,hl
            ret

TOOBJ4
            ld   a,4
TOOBJ
■hl-НОМЕР ОБЪЕКТА
■a-СМЕЩЕНИЕ ПОСЛЕ АДРЕСА
■rethl-АДРЕС ОБЪЕКТА
            push bc
            ADDHLHL 4
            ld   c,Objvec.b:add a,c:ld c,a
            ld   a,Objvec.h:adc a,0:ld b,a
            add  hl,bc
            or   a:pop bc
            ret

ДЕПАКЕР
DEPACK
■hl-АДР. ЧТО ДЕПАКИТЬ
■de-АДР. КУДА ДЕПАКИТЬ
            push de
            push hl
            inc  hl
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            dec  bc
            EXD
            add  hl,bc
            EXD
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            dec  bc
            pop  hl
            add  hl,bc
            sbc  hl,de
            add  hl,de
            jr   c,$+4
            ld   d,h
            ld   e,l
            lddr
            EXD
            pop  de
            ld   c,#0C
            add  hl,bc
            push hl
            pop  ix
            ld   a,#03
            dec  hl
            ld   b,(hl)
            dec  hl
            ld   c,(hl)
            push bc
            dec  a
            jr   nz,$-6
            ld   b,a
            exx
            ld   d,#BF
            ld   c,#10
            call LL4115
LL4036      ld   a,(ix+#00)
            inc  ix
            exx
LL403C      ld   (de),a
            inc  de
LL403E      exx
LL403F      add  hl,hl
            djnz $+5
            call LL4115
            jr   c,LL4036
            ld   e,#01
LL4049      ld   a,#80
            add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,$-7
            cp   #03
            jr   c,$+7
            add  a,e
            ld   e,a
            xor  c
            jr   nz,LL4049
            add  a,e
            cp   #04
            jr   z,LL40C4
            adc  a,#FF
            cp   #02
            exx
LL4067      ld   c,a
LL4068      exx
            ld   a,#BF
            jr   c,LL4082
LL406D      add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,LL406D
            jr   z,LL407D
            inc  a
            add  a,d
            jr   nc,LL4084
            sub  d
LL407D      inc  a
            jr   nz,LL408D
            ld   a,#EF
LL4082      rrca
            cp   a
LL4084      add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,LL4084
LL408D      exx
            ld   h,#FF
            jr   z,LL409B
            ld   h,a
            inc  a
            ld   a,(ix+#00)
            inc  ix
            jr   z,LL40A6
LL409B      ld   l,a
            add  hl,de
            ldir
LL409F      jr   LL403E
LL40A1      exx
            rrc  d
            jr   LL403F
LL40A6      cp   #E0
            jr   c,LL409B
            rlca
            xor  c
            inc  a
            jr   z,LL40A1
            sub  #10
LL40B1      ld   l,a
            ld   c,a
            ld   h,#FF
            add  hl,de
            ldi
            ld   a,(ix+#00)
            inc  ix
            ld   (de),a
            inc  hl
            inc  de
            ld   a,(hl)
            jp   LL403C
LL40C4      ld   a,#80
LL40C6      add  hl,hl
            djnz $+5
            call LL4115
            adc  a,a
            jr   nz,LL40F3
            jr   c,LL40C6
            ld   a,#FC
            jr   LL40F6
LL40D5      ld   b,a
            ld   c,(ix+#00)
            inc  ix
            ccf
            jr   LL4068
LL40DE      cp   #0F
            jr   c,LL40D5
            jr   nz,LL4067
            ld   b,#03
            EXD
LL40E7      pop  de
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            djnz LL40E7
            ld   hl,#2758
            exx
            ret
LL40F3      sbc  a,a
            ld   a,#EF
LL40F6      add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,LL40F6
            exx
            jr   nz,LL40B1
            bit  7,a
            jr   z,LL40DE
            sub  #EA
            add  a,a
            ld   b,a
            ld   a,(ix+#00)
            inc  ix
            ld   (de),a
            inc  de
            djnz $-7
            jr   LL409F
LL4115      ld   b,c
            ld   l,(ix+#00)
            inc  ix
            ld   h,(ix+#00)
            inc  ix
            ret



