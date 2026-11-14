
;        include"EQUS"



;  ПОВЕРХНОСТЬ ПЛАНЕТЫ И НЕБО


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

;        include"LOADER"

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
; ERROR trailing tokens in 'ADHIDE,$': org ADHIDE,$
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
;defw
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


            ld   de,60*256          ;z
            ld   (ZET+1),de
            ld   a,4                ;X
            ld   (IKS+1),a
            ld   l,a
            ld   a,100              ;Y
            ld   (IGR+1),a
            ld   h,a
            call NEWPOS_
            ld   de,40*256          ;z
            ld   l,4                ;X
            ld   h,80               ;Y
            call NEWPSS_


E1:

            ld   b,A3D-2
            ld   de,Olen-1
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

;  ГЕНЕРИТЬ СКИМЕРЫ
            call GENS



            ld   a,PGSPR
            call PG
            call OUTALL

            ld   a,PG3D
            call PG
            call OUTALL2


            ld   a,PGNORM
            call PG

;  ИНТЕЛЕКТ
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
            ld   a,#3F
            ld   i,a
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
;a-INDEX
;hl-X,de-Y,bc-z
            exx  
            push ix
            push hl
            push de
            push bc
;  ИНДЕКС
            and  #7C
            ld   l,a
            srl  l
            ld   h,0
            ld   de,VOXAD
            add  hl,de
            ld   e,(hl)
            inc  l
            ld   d,(hl)

;  РЕАЛЬНЫЕ РАЗМЕРЫ СПРАЙТА
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

;        ldhl,(YPL)
;        lda,l:sub6:ldl,a
;        lda,h:sbca,0:ldh,a
;        ld(YPL),hl

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

;        ldhl,(YPL)
;        lda,l:adda,6:ldl,a
;        lda,h:adca,0:ldh,a
;       ld(YPL),hl

            ld   a,(IKS+1)
            ld   l,a
            ld   a,(IGR+1)
            sub  4
            ld   h,a
            ld   (IGR+1),a
            jp   NEWPOS_


ROLLT:
;  ПЕРЕМЕЩЕНИЕ ФОНА ВЛЕВО ВСЕГО ЧТО ЕСТЬ
            ld   a,PGSPR
            call PG
            call RLT
            ld   a,PGNORM
            jp   PG
ROLRT:
;  ПЕРЕМЕЩЕНИЕ ФОНА ВПРАВО
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
            out  (c),a
            pop  bc
            ret  


;  ВЗЯТЬ СЛОВО ИЗ АДРЕСА В hl
;  В СТРАНИЦЕ 3D
TAKEW:
;hl-АДРЕС СЛОВА
;retde-СЛОВО
            ld   a,PG3D
            call PG
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            ld   a,PGNORM
            call PG
            ret  

NEWEFA_:
;  ЗАДАТЬ ЭФЕКТ В КАНАЛЕ А

            ret  
NEWEFB_:
;  ЗАДАТЬ ЭФЕКТ В КАНАЛЕ Б

            ret  
VOXAD:
            dw   DRV1
            dw   DRV2
            dw   DOMA1








Messags:
            db   "AAAA",0




Mnums_:
;NUMBERS inORDER PRINT
;a-NUMBER
            ld   e,a
            ld   d,2
            jr   Frba
Mesag:
;a-NUMBER OF MESAG
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
;hl-TXT,"@"-END
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
;a-NUMBER
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
            rept 32
            push hl
            endr
            ld   sp,#5700
            rept 32
            push hl
            endr
            ld   sp,#5600
            rept 32
            push hl
            endr
            ld   sp,#5500
            rept 32
            push hl
            endr
            ld   sp,#5400
            rept 32
            push hl
            endr
            ld   sp,#5300
            rept 32
            push hl
            endr
            ld   sp,#5200
            rept 32
            push hl
            endr
            ld   sp,#5100
            rept 32
            push hl
            endr
Stk5:       ld   sp,0
            ret  

Rst10:
;a-CODE
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
            ex   af,af'
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
            ex   af,af'
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
            rrca 
            rrca 
            rrca 
            rrca 
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
;  ПeЧATЬ БE3 cДbИГa
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
;pИCOBAHИeПpИЦeЛabДAHHЫX KOOPДИHATAX
;bЫBOД HA TEHEBOЙ CKPИh
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
;cПPAЙT ПpИЦeЛa
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
;bЫBOДИЛaBPEMEHИ HA ПpИБ.ПAHEЛЬ,  TAK
;  ЖeИ3M. eГO
            ld   a,%10000000
            rrca 
            ld   ($-2),a
            ret  nc                 ;HAДO ЖДATЬ ДO CEKУhДЫ

;cЧИTAEM BPEMЯ
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
;bЫBOД BPEMEHИ
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
;  ПeЧATЬ ЧИcЛabБЦД И3 peГ.A
;bKOOPД. bc-KOPД. X
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
            ex   af,af'
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


;  ПЛeЙEP CEMПЛEB
; NOTE2
; "sfx"-IS aLOOP, WHICH CONTAINS
; IS aADDRESS OF THE SOUND EFFECT

Sfxa:
            ld   hl,0
            ld   a,h
            or   a
            jr   z,Sfxb
            ld   bc,#FFFD
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
Sfxb:
            ld   hl,0
            ld   a,h
            or   a
            jr   z,Sfxn
            ld   bc,#FFFD
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
Sfxn:
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
Nunu:       ld   a,0
            srl  a
            cp   4
            jr   nc,$+4
            ld   a,4
            out  (c),a
            ret  
Roka:
            db   20,2,%00001000,11
            db   1,1,%00001000,10
            db   20,2,%00001000,9
            db   1,1,%00001000,10
            db   20,2,%00001000,11
            db   1,1,%00001000,10,0
Eff13:
            db   20,0,%00000000,10
            db   10,0,%00000000,9
            db   20,0,%00000000,8
            db   10,0,%00000000,7
            db   20,0,%00000000,6
            db   10,0,%00000000,5,0
Eff19:
            db   80,1,%00001000,8
            db   70,1,%00001000,8
            db   60,1,%00001000,8
            db   80,1,%00001000,8
            db   70,1,%00001000,9
            db   60,1,%00001000,9
            db   80,1,%00001000,9
            db   70,1,%00001000,10
            db   60,1,%00001000,10
            db   80,1,%00001000,10
            db   70,1,%00001000,11
            db   60,1,%00001000,11
            db   80,1,%00001000,11
            db   70,1,%00001000,12
            db   60,1,%00001000,13
            db   70,1,%00001000,13,0
Eff1:
            db   40,0,%00000000,10
            db   50,0,%00000000,9
            db   40,0,%00000000,8
            db   50,0,%00000000,7
            db   40,0,%00000000,6
            db   50,0,%00000000,5,0
Eff14:
            db   20,1,%00000000,10
            db   10,1,%00000000,9
            db   20,1,%00000000,8
            db   10,1,%00000000,7
            db   20,1,%00000000,6
            db   10,1,%00000000,5,0
Eff2:
;SHOOT1
            db   #10,1,%00001000,12
            db   #40,1,%00001000,11
            db   #70,1,%00001000,10
            db   #20,2,%00001000,9
            db   #E0,2,%00001000,8
            db   #20,3,%00001000,7,0

Eff0:
;EXPLOSION
            db   #10,8,%00001000,15
            db   #10,8,%00001001,15
            db   #10,8,%00000000,15
            db   #80,8,%00000000,15
            db   #10,8,%00000001,15
            db   #80,7,%00001001,15
            db   #80,7,%00000001,15
            db   #80,5,%00000001,15
            db   #80,4,%00000000,14
            db   #80,3,%00000001,14
            db   1,0,%00000001,14
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000000,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000000,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,11
            db   1,0,%00000001,10
            db   1,0,%00000001,9
            db   1,0,%00000001,8
            db   1,0,%00000001,8
            db   1,0,%00000001,8
            db   1,0,%00000001,8
            db   1,0,%00000001,7
            db   1,0,%00000001,6
            db   1,0,%00000001,5
            db   1,0,%00000001,4
            db   1,0,%00000001,3,0

Eff11:
            db   100,2,4,9
            db   100,3,4,7
            db   100,2,4,5
            db   100,3,4,4
            db   100,2,4,2
            db   100,3,4,1,0

Eff21:
            db   200,1,32,12
            db   2,0,0,11
            db   50,0,0,12
            db   50,0,4,7
            db   50,0,4,1,0





Datal:
;hl-ADR ON SCREEN
;a-MEAN
            ld   c,a
            and  a
            jr   z,Dln1             ;ECЛИ BOOБЩe= 0
            cpl  
            and  7
            ld   a,c
            jr   nz,$+7
            add  a,8
            and  %11111000
            ld   c,a
            rrca 
            rrca 
            rrca 
            and  7
            jr   z,Dln1
            ld   b,a
            ld   de,#05AA
            rept 5
            ld   (hl),e
            inc  h
            endr
            ld   (hl),e
            ld   a,h
            sub  d
            ld   h,a
            inc  l
            djnz $-15
Dln1:
            ld   a,c
            ex   af,af'
            ld   a,c
            and  7
            jr   z,Dln2
            ld   c,a
            ld   b,0
            ex   de,hl
            ld   hl,Tabr
            add  hl,bc
            ld   a,(hl)
            rept 5
            ld   (de),a
            inc  d
            endr
            ld   (de),a
            ld   a,d
            sub  5
            ld   d,a
            ex   de,hl
            inc  l
Dln2:
            ex   af,af'
            ld   c,a
            and  7
            ld   a,c
            jr   z,$+4
            add  a,8
            rrca 
            rrca 
            rrca 
            and  7
            sub  6
            ret  nc
            neg  
            ld   b,a
            ld   de,#0005
            xor  a
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            ld   a,h
            sub  e
            ld   h,a
            inc  l
            djnz $-15
            ret  
Tabr:
            db   %10000000
            db   %10000000
            db   %10100000
            db   %10100000
            db   %10101000
            db   %10101000
            db   %10101010


Repanel:
;bЫBOД ИhДИKATOPOB ПAHEЛИ , aTAK ЖeBP
;EMEHИ
            ld   a,1
            ld   (Fspeed+1),a
            ld   (Ffire+1),a
            ld   (Fshild+1),a
            ld   (Ffuel+1),a
            call Datalin            ;ИhДИKATOPЫ
            ld   hl,(TIME+2)
            ld   de,(TIME)
            ld   b,#FF
            jp   Zerot1             ;BPEMЯ






Datalin:
;bЫBOД ДAHHЫX O 3AЩИTE ЭHEPГИИ И Дp.ИhФ
;O bbИДeCTATУcЛИhИИ
Fshild:     ld   a,0
            and  a
            jr   z,Ffuel
            ld   a,(SHILD)
            ld   hl,#49A1
            call Datal
            xor  a
            ld   (Fshild+1),a

Ffuel:      ld   a,0
            and  a
            jr   z,Ffire

            rra  
            ld   hl,#49E1
            call Datal

Ffire:      ld   a,0
            and  a
            jr   z,Fspeed
;        lda,(Peregrv+1)
            ld   hl,#5121
            call Datal
            xor  a
            ld   (Ffire+1),a

            ld   hl,#5181
            ld   hl,#51C1

Fspeed:     ld   a,0
            and  a
            jr   z,Fspd
            xor  a
            ld   (Fspeed+1),a
            ld   hl,(SPEED)
            ADDHLHL 5
            ABS_HL
            ld   a,h
            srl  a
            rr   l
            srl  a
            rr   l
            and  a
            jr   z,$+4
            ld   l,46
            ld   a,l
            cp   47
            jr   c,$+4
            ld   l,46
            ld   a,l
            ld   hl,#49B9
            call Datal
Fspd:
            ret  




            ADRXX00

PLANET_:
            incbin "assets/planet.C"
SKYS_:
            incbin "assets/CHAN6.C"
DRV1:
            incbin "assets/DRV1.C"
DRV2:
            incbin "assets/DRV2.C"
DOMA1:
            incbin "assets/DOMA1.C"




INTEL:
;  ИНТЕЛЕКТ ПОВЕДЕНИЯ КОРАБЛЕЙ
            ld   ix,Carsb-Olen
            jr   I2
I1:
            ld   a,(ix+0)
            cp   #80
            ret  z
I2:
            ld   de,Olen
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jr   z,I1
            ld   a,(ix+Mode)
            rlca 
            ld   l,a
            ld   h,0
            ld   de,MODES
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            ld   de,RET_
            push de
            jp   (hl)
RET_:
            ld   a,PG3D
            call PG
            ld   a,(ix+Rspd)
            or   a
            jr   z,I4
            ld   d,0
            ld   e,a
            call MOVEON
I3:
            call PRECORD
            ld   a,PGNORM
            call PG
            jp   I2
I4:
            call NULMOVE
            jr   I3



MODES:
            dw   FREEFLY
            ds   10,NTH

FREEFLY:
            ret  

NTH:
            ret  







;  ГЕНЕРИТЬ СКИММЕРЫ
GENS:
            ld   a,#01
            rrca 
            ld   ($-2),a
            ret  nz
            ld   a,r
            cp   22
            ret  nc
            call FNDFREE
            ret  z
            push hl
            pop  ix
            call RNDL1

            ld   a,h
            and  %11000000
            or   #60
            ld   (ix+Rspd),a

            rl   h
            ld   h,Spacebd-3
            ld   a,0
            jr   nc,$+5
            ld   h,0-Spacebd+3
            inc  a
            ld   (ix+0),l
            ld   (ix+1),h

            push af
            call RNDL2
            pop  af

            rl   h
            ld   h,Spacebd-3
            jr   nc,$+6
            ld   h,0-Spacebd+3
            add  a,2
            ld   (ix+4),l
            ld   (ix+5),h


            push af

            call RNDK1
            and  3
            rlca 
            rlca 
            ld   (ix+Indi),a

            pop  af
            inc  a
            ld   h,a
            ld   a,l
            and  #3F
            dec  h
            set  7,a
            jr   z,GS1
            dec  h
            set  6,a
            jr   z,GS1
            dec  h
            res  7,a
            jr   z,GS1
            res  6,a
GS1:
            ld   (ix+Beta),a


            xor  a
            ld   (ix+Alfa),a
            ld   (ix+Gama),a

            ld   (ix+Mode),0        ;SIMPLY FLY

            ret  










;  ГЕНЕРИТЬ ДЕРЕВЬЯ
GEND:
            call RND
            ld   ix,Carsb-Olen
            ld   a,l
            or   h
            or   #07
            and  #1F
            ld   b,a

G1:
            exx  

            ld   bc,Olen
G3:
            add  ix,bc
            ld   a,(ix+1)
            cp   #80
            jr   nz,G3
            ld   a,(ix+0)
            cp   #80
            ret  z

            call RNDT1
            ld   a,h
            bit  7,a
            jr   z,$+6
            or   #40
            jr   $+4
            and  #CF
            ld   (ix+0),l
            ld   (ix+1),a

            call RNDT2
            ld   a,h
            bit  7,h
            jr   z,$+6
            or   #40
            jr   $+4
            and  #CF
            ld   (ix+4),l
            ld   (ix+5),a

            ld   hl,0
            ld   (ix+2),l
            ld   (ix+3),h

            call RND
            and  3

            cp   3
            jr   nz,$+3
            dec  a

            rlca 
            rlca 
            or   #80
            ld   (ix+Indi),a


;  ВЗЯТЬ РЕАЛЬНЫЙ РАЗМЕР СПРАЙТА
            ld   l,a
            ld   h,high(L97)
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  de
            inc  de
            ex   de,hl

            call TAKEW

            ld   (ix+Alfa),e
            ld   (ix+Beta),d

            ld   (ix+Rspd),0
            ld   (ix+Mode),0


            ld   bc,Olen
            add  ix,bc

            exx  
            djnz G1
            ret  



FINDOBJ:
;  ПOИCK ПEPBOГO ПO TИПУ bd
;FZ-ON ifNOT FOUND
            ld   iy,Carsb-Olen
            ld   bc,Olen
Find2:
            call Findob
            ret  z
            ld   a,(iy+Type)
            cp   d
            jp   nz,Find2
            inc  a
            ret  


FOBJ:
;FIND OBJECT
;rethl-OBJ AD+1
;FZ-ON NO inBUF OBJS
;FZ-OFF FOUND
            ld   hl,Carsb-Olen+1
            ld   bc,Olen
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

FNDFREE:
;FIND FREE SPACE
;retFZ-ON ifNOT FOUND
            ld   hl,Carsb-Olen+1
            ld   de,Olen
Hhh3:
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
            ex   af,af'
            ld   a,l
            sub  Setup-1
            ld   l,a
            ex   af,af'
            jr   z,Hhh3
            ex   af,af'
            dec  l
            ex   af,af'
            ret  

RND:
            ld   hl,Sdo
            jp   RNDo
RNDW:
            ld   hl,Sdw
            jp   RNDo
RNDK1:
            ld   hl,Sdk1
            jp   RNDo
RNDK2:
            ld   hl,Sdk2
            jp   RNDo
RNDK3:
            ld   hl,Sdk3
            jp   RNDo
RNDT2:
            ld   hl,Sdt2
            jp   RNDo
RNDT1:
            ld   hl,Sdt1
            jp   RNDo
RNDL1:
            ld   hl,Sdl1
            jp   RNDo
RNDL2:
            ld   hl,Sdl2
            jp   RNDo
RNDL3:
            ld   hl,Sdl3
            jp   RNDo
Sdw:
;  ГEHEPATOP KAKOГO ЛAHДШaФTA
            db   7,8,0
Sdo:
            db   101,2,30
Sdl1:
            db   9,0,30
Sdl2:
            db   231,70,30
Sdl3:
            db   71,1,3
Sdt2:
            db   44,0,0
Sdt1:
            db   21,1,12
Sdk1:
            db   247,33,0
Sdk2:
            db   93,4,65
Sdk3:
            db   29,1,12
RNDo:
;inhlADR OF SEED
            push bc
            push de
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   a,(hl)
            push hl
            ld   e,a
            ld   h,b
            ld   l,c
            dec  hl
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            ex   de,hl
            ld   h,b
            ld   l,c
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,de
            adc  a,0
            add  hl,bc
            adc  a,0
            add  hl,bc
            adc  a,0
            add  hl,bc
            adc  a,0
            ld   d,h
            ld   e,l
            ld   l,h
            ld   h,a                ;0
            ld   b,0
            ld   c,e
            and  a
            sbc  hl,bc
            sbc  a,0
            ex   de,hl
            and  a
            sbc  hl,de
            sbc  a,0
            dec  hl
            ex   de,hl
            pop  hl
            ld   (hl),a
            dec  hl
            ld   (hl),d
            dec  hl
            ld   (hl),e
            xor  e
            xor  d
            ex   de,hl
            pop  de
            pop  bc
            ret  



Findob:
;HAЙTИ KAKOЙ hИБУДЬ OБЪEKT
;iy-VECTOR-OLEN
;bc-OLEN
;FZ-ON NOT FOUND
            add  iy,bc
            ld   a,(iy+1)
            cp   #80
            ret  nz
            ld   a,(iy+0)
            cp   #80
            jp   nz,Findob
            ret  


SERVICE:
            call Servms
            call Servkj
            call Servqa

            ld   a,(DIRECTZ)
            ld   c,a
            ld   a,(DIRECTZ+5)
            or   c
            jr   z,SV1
            ld   a,PG3D
            call PG
            call FLINE
;retFC-ON ЕСЛИ БЫЛ ВЫСТРЕЛ
            ex   af,af'
            ld   a,PGNORM
            call PG
            ex   af,af'
SV1:
            ld   a,(DIRECTZ+2)
            or   a
            call nz,ROLDN
            ld   a,(DIRECTZ+1)
            or   a
            call nz,ROLUP
            ld   a,(DIRECTZ+4)
            or   a
            call nz,ROLLT
            ld   a,(DIRECTZ+3)
            or   a
            call nz,ROLRT
            ld   a,(DIRECTZ+4)
            ld   c,a
            ld   a,(DIRECTZ+3)
            or   c
            ex   af,af'
            ld   a,PGSPR
            call PG
            ex   af,af'
            call z,RETURN
            ld   a,PGNORM
            call PG
            ret  

;MOUSE DRIVER FROM ZX-FORMAT
DIRECTZ:    db   0                  ;FIRE
            db   0                  ;UP
            db   0                  ;DOWN
            db   0                  ;RIGHT
            db   0                  ;LEFT
            db   0                  ;CANCEL
            db   0                  ;MEDIUM

MCOORD:     dw   0

;  УCTAHABЛИBAЮTCЯ b1 ECЛИ HAЖATO
Mports:     dw   0                  ;CORDS mЫXИ
Nondef:     and  3
            jr   z,Mdrv4
            cp   1
            jr   z,Nondef_
            xor  a
            ld   (Mdrv3+2),a
            ld   a,5
            ld   (Mdrv2+2),a
Nondef_:    ld   hl,0
            ld   (Mdrv1),hl
            pop  ix
;MAIN
Servms:
            ld   a,0
            and  a
            ret  nz
            push ix
            ld   hl,DIRECTZ
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
Mdrv1:      jr   Nondef
            rra  
Mdrv2:      rl   (ix+0)
            rra  
Mdrv3:      rl   (ix+5)
            rra  
            rl   (ix+6)
Mdrv4:
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
Mdrv6:
            ld   (ix+3),1
Mdrv9:      ld   b,#FF
            in   a,(c)
            ld   (Mports+1),a
            sub  d
            ld   (MCOORD),a
            jr   z,Mdrv14
            neg  
            jp   p,Mdrv11
            ld   (ix+1),1
            jr   Mdrv14
Mdrv11:
            ld   (ix+2),1
Mdrv14:
            pop  ix
            ret  
Servkj:
;SERVICE KEMPSTON JOYSTIC
            ld   a,0                ;FLAG
            and  a
            ret  nz
            in   a,(#1F)
            jp   Gomove

Servqa:
;SERVICE QAOP sp
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
Gomove:
;bЫ3OB ПpoЦ. И3MEHEHИЯ KOOPДИHATЫ b3AB
;  Иc
;MOCTИ OT HAЖATOЙ KHOПKИ

;  И3MEHЯЮTCЯ ПEPEMEHHЫeCOCTOЯhИЯ HAЖATИЯ
;KAKИX ЛИБO KЛABИШ LEFT,RIHGT,UP,DOWN,F
;IRE,CANCEL
            ld   e,a
            xor  a
            ld   d,a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+3
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+4
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+2
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+1
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ
            or   (hl)
            ld   (hl),a
            ret  


END_:



            org  #6000
Font:
            incbin "assets/FONT.C"
;        include"DATAM"
END0:


; 
