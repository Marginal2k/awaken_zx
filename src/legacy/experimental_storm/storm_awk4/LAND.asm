            include "EQUS.asm"



;ПОВЕРХНОСТЬ ПЛАНЕТЫ И НЕБО


            org  #7C00
START:
            ld   hl,#4000
            ld   de,#4001
            ld   bc,#1800
            ld   (hl),l
            ldir 
            ld   bc,#02FF
            ld   (hl),%00000111
            ldir 

            include "LOADER.asm"

            di   

MAKEDRP:
            ld   a,PGSPR
            call PG
            ld   hl,MODUL
            ld   de,ADHIDE
            ld   bc,DS1-DROPSCR
            ldir 
            ex   de,hl
            ld   bc,191*DLEN
            add  hl,bc
            ex   de,hl
            ld   bc,4
            ldir 

            ld   bc,#0010
            exx  
            ld   de,DS1
            ld   a,96
            ld   hl,DS0
            ld   bc,DLEN
            ex   af,af'
MDS1:
            exx  
            ld   hl,(DS0+1)
            add  hl,bc
            ld   (DS0+1),hl
            ld   hl,(DS01+1)
            add  hl,bc
            ld   (DS01+1),hl
            exx  
            push hl
            push bc
            ldir 
            pop  bc
            pop  hl
            ex   af,af'
            dec  a
            jr   z,MDS2
            ex   af,af'
            exx  
            ld   hl,(DS0+1)
            add  hl,bc
            ld   (DS0+1),hl
            ld   hl,(DS01+1)
            or   a
            sbc  hl,bc
            inc  h
            ld   a,h
            and  7
            jr   nz,$+12
            ld   a,l
            add  a,32
            ld   l,a
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            ld   (DS01+1),hl
            exx  
            push hl
            push bc
            ldir 
            pop  bc
            pop  hl
            jr   MDS1
MDS2:
            ld   hl,#8000
            ld   (DS0+1),hl
            ld   hl,#4010
            ld   (DS01+1),hl
            ld   a,PGNORM
            call PG




            ld   hl,0
            ld   (Adtt+1),hl
            ld   hl,Tbuf
            ld   (Atbuf+1),hl
            ld   (Frba+1),hl
            inc  hl
            ld   de,Tbuf+2
            ld   bc,#20
            ld   (hl),1
            ldir 
            ld   (hl),0
            ld   hl,DIRECTZ
            ld   de,DIRECTZ+1
            ld   bc,7
            ld   (hl),0
            ldir 
            jp   DALEE

MODUL:
; ERROR trailing tokens in 'ADHIDE,$': ORG ADHIDE,$
DROPSCR:
            ld   ((STK92+1+191)*DLEN),sp
DS0:
            ld   sp,#8000
            pop  hl
            pop  de
            pop  bc
            pop  af
            exx  
            ex   af,af'
            pop  hl
            pop  de
            pop  bc
            pop  af
DS01:       ld   sp,#4010
            push af
            push bc
            push de
            push hl
            exx  
            ex   af,af'
            push af
            push bc
            push de
            push hl
DS1:
DLEN:       equ  DS1-DS0

STK92:      ld   sp,0
            ret  



            org  HSCR
;DEFW
DEFW_:
            ds   Olen*(A3D-1)
            ds   Olen
            dw   PLANET_
            dw   SKYS_
            db   #C3
            dw   Messags
            db   #C3
            dw   NEWEFA_
            db   #C3
            dw   NEWEFB_
            db   #C3
            dw   Mnums_
            dw   #2B7B
            db   #C3
            dw   VOXOBJ_
DDLEN:      equ  $-HSCR

            org  #8C00

DALEE:
            ld   a,PG3D
            call PG
            call INIT
            ld   a,PGNORM
            call PG

            ld   hl,DEFW_
            ld   de,VARS
            ld   bc,DDLEN
            ldir 


            ld   de,60*256          ;Z
            ld   (ZET+1),de
            ld   a,4                ;X
            ld   (IKS+1),a
            ld   l,a
            ld   a,100              ;Y
            ld   (IGR+1),a
            ld   h,a
            call NEWPOS_
            ld   de,40*256          ;Z
            ld   l,4                ;X
            ld   h,80               ;Y
            call NEWPSS_


E1:

            ld   b,A3D-2,de,Olen-1
            ld   hl,Carsb
D1:
            ld   (hl),0
            inc  l
            ld   (hl),#80
            add  hl,de
            djnz D1
            ld   (hl),#80
            inc  l
            ld   (hl),#80



            call GEND


            ld   a,#FF
            ld   (PLAYER+Type),a
            ld   (PLAYER+Mode),a

            xor  a
            ld   (SPEED),a


M2:

;ГЕНЕРИТЬ СКИМЕРЫ
            call GENS



            ld   a,PGSPR
            call PG
            call OUTALL

            ld   a,PG3D
            call PG
            call OUTALL2


            ld   a,PGNORM
            call PG

;ИНТЕЛЕКТ
            call INTEL

            call Pricel
            call Sfxa
            call Timer


            call Repanel

            ld   a,#7F
            in   a,(#FE)
            rrca 
            push af
            call nc,UP
            pop  af
            rrca 
            push af
            call nc,DOWN
            pop  af
            rrca 
            push af
            call nc,RIGHT
            pop  af
            rrca 
            push af
            call nc,LEFT
            pop  af
            rrca 
            jp   nc,EXIT

            call SERVICE

            ld   a,PGSPR
            call PG
            call ADHIDE
            ld   a,PGNORM
            call PG

            jp   M2


EXIT:
            im   1
            ld   a,#3F,i,a
            ld   iy,#5C3A

            ld   a,#14
            call PG
            ld   hl,FILN4
            ld   de,23773
            ld   bc,9
            ldir 
            xor  a
            ld   hl,#C000
            ld   c,#0E
            di   
            call #3D13
            ld   a,#13
            call PG
            ld   hl,FILN3
            ld   de,23773
            ld   bc,9
            ldir 
            xor  a
            ld   hl,#C000
            ld   c,#0E
            di   
            call #3D13

            ld   a,PGNORM
            call PG
            ei   
            ret  

FILN4:      db   "PAGE4   C"
FILN3:      db   "PAGE3   C"




VOXOBJ_:
;A-INDEX
;HL-X,DE-Y,BC-Z
            exx  
            push ix
            push hl
            push de
            push bc
;ИНДЕКС
            and  #7C
            ld   l,a
            srl  l
            ld   h,0
            ld   de,VOXAD
            add  hl,de
            ld   e,(hl)
            inc  l
            ld   d,(hl)

;РЕАЛЬНЫЕ РАЗМЕРЫ СПРАЙТА
            ld   hl,(EYEA)
            exx  
            push hl
            or   #80
            ld   l,a
            ld   h,high(L97)
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  hl
;MULTIPLY
            ld   a,(hl)
            pop  hl
            ex   af,af'
            ld   a,PGSPR
            call PG
            ex   af,af'
            call D3D2
            ld   a,PG3D
            call PG

            exx  
            pop  bc
            pop  de
            pop  hl
            pop  ix
            exx  
            jp   NXTO

LEFT:
            ld   de,(ZET+1)
            ld   a,(IKS+1)
            inc  a
            ld   l,a
            ld   (IKS+1),a
            ld   a,(IGR+1)
            ld   h,a
            jp   NEWPOS_


RIGHT:
            ld   de,(ZET+1)
            ld   a,(IKS+1)
            dec  a
            ld   l,a
            ld   (IKS+1),a
            ld   a,(IGR+1)
            ld   h,a
            jp   NEWPOS_

NEWPOS_:
            ld   a,PGSPR
            call PG
            call NEWPOS
            ld   a,PGNORM
            jp   PG
NEWPSS_:
            ld   a,PGSPR
            call PG
            call NEWPSS
            ld   a,PGNORM
            jp   PG


UP:
ZET:        ld   de,0
            ld   a,e
            add  a,#40
            ld   e,a
            ld   a,d
            adc  a,0
            cp   68
            ret  nc
            ld   d,a
            ld   (ZET+1),de

;        LD HL,(YPL)
;        LD A,L:SUB 6:LD L,A
;        LD A,H:SBC A,0:LD H,A
;        LD (YPL),HL

IKS:        ld   l,24
IGR:        ld   a,38
            add  a,4
            ld   h,a
            ld   (IGR+1),a
            jp   NEWPOS_

DOWN:
            ld   de,(ZET+1)
            ld   a,e
            sub  #40
            ld   e,a
            ld   a,d
            sbc  a,0
            cp   57
            ret  c
            ld   d,a
            ld   (ZET+1),de

;        LD HL,(YPL)
;        LD A,L:ADD A,6:LD L,A
;        LD A,H:ADC A,0:LD H,A
;       LD (YPL),HL

            ld   a,(IKS+1)
            ld   l,a
            ld   a,(IGR+1)
            sub  4
            ld   h,a
            ld   (IGR+1),a
            jp   NEWPOS_


ROLLT:
;ПЕРЕМЕЩЕНИЕ ФОНА ВЛЕВО ВСЕГО ЧТО ЕСТЬ
            ld   a,PGSPR
            call PG
            call RLT
            ld   a,PGNORM
            jp   PG
ROLRT:
;ПЕРЕМЕЩЕНИЕ ФОНА ВПРАВО
            ld   a,PGSPR
            call PG
            call RRT
            ld   a,PGNORM
            jp   PG

ROLUP:
            ld   a,%10001000
            rrca 
            ld   ($-2),a
            ret  nc
            ld   a,(SPEED)
            inc  a
            jp   m,$+6
            cp   MSPEED2
            ret  nc
            ld   (SPEED),a
            call TAKSPD
            ret  
ROLDN:
            ld   a,(ROLUP+1)
            rlca 
            ld   (ROLUP+1),a
            ret  nc
            ld   a,(SPEED)
            dec  a
            jp   p,$+6
            cp   MSPEED
            ret  c
            ld   (SPEED),a
            call TAKSPD
            ret  

TAKSPD:
            ex   af,af'
            ld   a,PGSPR
            call PG
            ex   af,af'
            call TAKESPD
            ld   a,PGNORM
            jp   PG


PG:
            push bc
            ld   bc,#7FFD
            out  a
            pop  bc
            ret  


;ВЗЯТЬ СЛОВО ИЗ АДРЕСА В HL
;В СТРАНИЦЕ 3D
TAKEW:
;HL-АДРЕС СЛОВА
;RET DE-СЛОВО
            ld   a,PG3D
            call PG
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            ld   a,PGNORM
            call PG
            ret  

NEWEFA_:
;ЗАДАТЬ ЭФЕКТ В КАНАЛЕ А

            ret  
NEWEFB_:
;ЗАДАТЬ ЭФЕКТ В КАНАЛЕ Б

            ret  
VOXAD:
            dw   DRV1
            dw   DRV2
            dw   DOMA1








Messags:
_DB:        ; ??? "AAAA",0




Mnums_:
;NUMBERS IN ORDER PRINT
;A-NUMBER
            ld   e,a
            ld   d,2
            jr   Frba
Mesag:
;A-NUMBER OF MESAG
            ld   hl,Messags
            and  a
            jr   z,$+13
            ld   e,a
            ld   bc,#FFFF
            xor  a
            cpir 
            dec  e
            jr   nz,$-3
            ex   de,hl
Frba:       ld   hl,Tbuf
            ld   b,#10
Mg3:
            inc  hl
            ld   a,(hl)
            dec  a
            jr   z,Mg2
            inc  a
            jr   z,Mg11
            inc  hl
            djnz Mg3
            ret  
Mg11:
            ld   hl,Tbuf
            djnz Mg3
            ret  
Mg2:
            ld   (hl),d
            dec  hl
            ld   (hl),e
            inc  hl
            inc  hl
            ld   (Frba+1),hl
            ret  
Tbuf:       ds   #20,#01
            dw   #0000

Print:
;HL-TXT,"@"-END
Adtt:       ld   hl,0
            ld   a,h
            or   l
            jr   nz,Pnt3
Atbuf:      ld   hl,0
            ld   e,(hl)
            inc  hl
            ld   a,(hl)
            cp   2
            jr   nz,Prt1
            ld   (hl),1
            ld   a,e
            push hl
            push bc
            call Prntnum
            pop  bc
            pop  hl
            ld   a,(Cord+1)
            inc  a
            ld   (Cord+1),a
            ld   a,1
Prt1:
            and  a
            jr   nz,Prt3
            ld   hl,Tbuf
            ld   (Atbuf+1),hl
            ret  
Prt3:
            inc  hl
            ld   (Atbuf+1),hl
            dec  a
            jr   nz,Prt2
            ret  
Prt2:
            inc  a
            ld   d,a
            dec  hl
            ld   (hl),1
            ex   de,hl
Pnt3:
            ld   a,(hl)
            inc  hl
            ld   (Adtt+1),hl
            or   a
            jr   z,Pnte
            cp   1
            jr   z,Pnt1
            jp   Rst10
Pnte:
            ld   hl,0
            ld   (Adtt+1),hl
            ret  
Pnt1:
            inc  hl
            ld   (Adtt+1),hl
            xor  a
            ld   (Cord+1),a
            jp   Scroll
Prntnum:
;A-NUMBER
            cp   100
            jr   c,Pnum1
            ld   c,0
            ld   b,100
            sub  b
            inc  c
            sub  b
            jr   nc,$-2
            add  a,b
            ld   b,a
            ld   a,c
            add  a,"0"
            push bc
            call Rst10
            pop  af
Pnum1:
            ld   b,a
            cp   10
            ld   c,0
            jr   c,Pnum2
            ld   b,10
            sub  b
            inc  c
            sub  b
            jp   nc,$-2
            add  a,b
            ld   b,a
Pnum2:
            ld   a,c
            add  a,"0"
            push bc
            call Rst10
            pop  af
            add  a,"0"
            jp   Rst10

Scroll:
            ld   (Stk5+1),sp
            ld   hl,0
            ld   sp,#5800
.32:        push hl
            ld   sp,#5700
.32:        push hl
            ld   sp,#5600
.32:        push hl
            ld   sp,#5500
.32:        push hl
            ld   sp,#5400
.32:        push hl
            ld   sp,#5300
.32:        push hl
            ld   sp,#5200
.32:        push hl
            ld   sp,#5100
.32:        push hl
Stk5:       ld   sp,0
            ret  

Rst10:
;A-CODE
            ld   bc,Font
            ld   l,a
            srl  l
            ld   h,0
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,bc
            inc  hl
            ex   de,hl
            ex   af,af
Cord:       ld   c,0
            ld   a,c
            cp   #18
            jr   c,Rst1
            push de
            call Scroll
            pop  de
            ld   c,0                ;BEGIN X OF WIN FOR PR
Rst1:
            ld   b,c
            ld   h,#50
            ld   a,#F4
            srl  b
            add  a,b
            ld   l,a
            inc  c
            ld   a,c
            ld   (Cord+1),a
Rst2:
            bit  0,c
            ld   b,#F0
            jr   nz,$+4
            ld   b,#0F
            ex   af,af
            rra  
            jr   nc,$+6
            ld   a,c
            xor  1
            ld   c,a
            bit  0,c
            ld   c,b
            jr   nz,Rpr
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
.4:         rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
.4:         rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
.4:         rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
.4:         rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
.4:         rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
.4:         rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            rrca 
            rrca 
            rrca 
            rrca 
            and  c
            or   b
            ld   (hl),a
            ret  
Rpr:
;ПEЧATЬ БE3 CДBИГA
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            ret  

Pricel:
;PИCOBAHИE ПPИЦEЛA B ДAHHЫX KOOPДИHATAX
;BЫBOД HA TEHEBOЙ CKPИH
            ld   bc,(Pcord)         ;#2B77
            ld   h,b
            ld   a,c
            srl  h
            rra  
            srl  h
            rra  
            scf  
            rr   h
            rra  
            ld   l,a
            ex   de,hl
            ld   a,c
            and  7
            rla  
            rla  
            ld   l,a
            ld   h,0
            ld   bc,Mpricel
            add  hl,bc
            ex   de,hl
            ld   bc,#0020
            inc  l
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            add  hl,bc
            dec  l
            inc  de
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            inc  l
            inc  de
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            inc  l
            inc  de
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            dec  de
            dec  de
            dec  de
            dec  l
            add  hl,bc
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            add  hl,bc
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            ret  

Mpricel:
;CПPAЙT ПPИЦEЛA
            db   %10000000
            db   %00011110,%00111100,%00000000
            db   %01000000
            db   %00001111,%00011110,%00000000
            db   %00100000
            db   %00000111,%10001111,%00000000
            db   %00010000
            db   %00000011,%11000111,%10000000
            db   %00001000
            db   %00000001,%11100011,%11000000
            db   %00000100
            db   %00000000,%11110001,%11100000
            db   %00000010
            db   %00000000,%01111000,%11110000
            db   %00000001
            db   %00000000,%00111100,%01111000

Timer:
;BЫBOДИЛA BPEMEHИ HA ПPИБ.ПAHEЛЬ,  TAK
;ЖE И3M. EГO
            ld   a,%10000000
            rrca 
            ld   ($-2),a
            ret  nc                 ;HAДO ЖДATЬ ДO CEKУHДЫ

;CЧИTAEM BPEMЯ
            ld   bc,0
            ld   hl,(TIME+2)        ;#3418
            ld   a,l
            add  a,1
            daa  
            ld   l,a
            ld   a,h
            jr   nc,$+4
            set  0,b
            adc  a,c
            daa  
            ld   h,a
            ld   de,(TIME)          ;#0122
            ld   a,e
            jr   nc,$+4
            set  1,b
            adc  a,c
            daa  
            ld   e,a
            ld   a,d
            jr   nc,$+4
            set  2,b
            adc  a,c
            daa  
            ld   d,a
Zerotim:
            ld   (TIME+2),hl
            ld   (TIME),de
;BЫBOД BPEMEHИ
Zerot1:
            ld   a,l
            ld   c,#2F
            call Prnum
            ld   a,l
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#2E
            call Prnum
            bit  0,b
            ret  z
            ld   a,h
            ld   c,#2C
            call Prnum
            ld   a,h
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#2B
            call Prnum
            bit  1,b
            ret  z
            ld   a,e
            ld   c,#29
            call Prnum
            ld   a,e
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#28
            call Prnum
            bit  2,b
            ret  z
            ld   a,d
            ld   c,#27
            call Prnum
            ld   a,d
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#26
Prnum:
;ПEЧATЬ ЧИCЛA B БЦД И3 PEГ.A
;B KOOPД. B C-KOPД. X
            exx  
            and  #0F
            add  a,"0"
            ld   l,a
            srl  l
            ld   h,0
            add  hl,hl
            add  hl,hl
            add  hl,hl
            ld   de,Font
            add  hl,de
            inc  hl
            ex   de,hl
            ex   af,af
            ld   b,#10              ;Y KOOPД.
            ld   a,b
            and  #18
            or   #40
            inc  a
            ld   h,a
            ld   a,b
            and  7
            or   a
            rra  
            rra  
            rra  
            rra  
            ld   l,a
            exx  
            ld   a,c
            exx  
            ld   c,a
            srl  a
            add  a,l
            ld   l,a
            inc  c
            call Rst2
            exx  
            ret  


