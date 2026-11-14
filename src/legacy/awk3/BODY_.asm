
START:
            di   

            call CYCL
            jr   $-3
CYCL:
            call CLRHD
; РАСЧЕТЫ И ВЫВОД 3D
            call REN3D

            call OHIDE

; УПРАВЛЕНИЕ ОТ КЕМПСТОНА
            in   a,(#1F)
            ld   b,a
            bit  0,a
            jr   z,B1
            ld   a,(GAMA)
            add  a,8
            ld   (GAMA),a
            ret  
B1:
            bit  1,a
            jr   z,B2
            ld   a,(GAMA)
            sub  8
            ld   (GAMA),a
            ret  
B2:
            bit  2,a
            jr   z,B3
            ld   a,(ALFA)
            add  a,8
            ld   (ALFA),a
            ret  
B3:
            bit  3,a
            jr   z,B4
            ld   a,(ALFA)
            sub  8
            ld   (ALFA),a
            ret  
B4:
            bit  4,a
            ret  z

; ПРОВЕРКА ВЫХОДА В АСМ
;-------------
EXIT:

;              PAGE    VOXAL
;              ld     de,(MTRK+1)
;              ld     a,(DRIVE+1)
;              jp     RETSTT

            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,#FF
            out  (c),a
            ld   a,#3F
            ld   i,a

            PAGE_ #17
            jp   #DB00


SIZEOBJ:
; aИНДЕКС ОБЪЕКТА
            ld   l,a
            ld   h,L97
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            PAGE_ OBJ3D
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            PAGE___NOARG
            ret  




; ПЕРЕБРОС ДАННЫХ ОБЪЕКТА В БУФЕР
REMOVEOBJ:
; lИНДЕКС ОБЪЕКТА
            ld   h,L97
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            PAGE_ OBJ3D
            ld   de,OBJBUF
            ld   c,#0
            ld   a,#FE
            ldi  
            ldi  
            ldi  
            ldi  
            ldi  
            ldi  
            ldi  
            ldi  
JJM3:
            rept 20
            cp   (hl)
            jr   z,JJM
            ldi  
            endr
            jp   JJM3
JJM:        inc  hl
            cp   (hl)
            jr   z,JJM2
            dec  hl
            ldi  
            ldi  
            jp   JJM3
JJM2:
            PAGE___NOARG
            ret  



Page_:
; ПЕРЕКЛЮЧЕНИЕ СТРАНИЦ
; А-КОД
            push bc
            ld   bc,#7FFD
            out  (c),a
            pop  bc
            ret  







;------------------------------------
; МАТЕМАТИКА




; ПОВЕРНУТЬ КООРДИНАТНУЮ СИСТЕМУ ПО
; МАТРИЦЕ SM_XY
;iy-RETURN ADR
; ПОРТИТ sp
; НАЧАЛЬНЫЕ ЗНАЧЕНИЯ КООРДИНАТ В DX,DY,DZ
; КОНЕЧНЫЕ В TX,TY,TZ
CALCRCORD:
            ld   (RIX+2),ix
DX:         ld   de,0
            ld   a,(SM_11+1)
            ld   ix,$+7
            jp   MULADE
            ld   sp,hl
DY:         ld   de,0
            ld   a,(SM_21+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   sp,hl
DZ:         ld   de,0
            ld   a,(SM_31+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   (TX+1),hl
            ld   de,(DX+1)          ;DX
            ld   a,(SM_12+1)
            ld   ix,$+7
            jp   MULADE
            ld   sp,hl
            ld   de,(DY+1)          ;DY
            ld   a,(SM_22+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   sp,hl
            ld   de,(DZ+1)          ;DZ
            ld   a,(SM_32+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   (TY+1),hl
            ld   de,(DX+1)          ;DX
            ld   a,(SM_13+1)
            ld   ix,$+7
            jp   MULADE
            ld   sp,hl
            ld   de,(DY+1)          ;DY
            ld   a,(SM_23+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   sp,hl
            ld   de,(DZ+1)          ;DZ
            ld   a,(SM_33+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   (TZ+1),hl
EXET1:
RIX:        ld   ix,0
            jp   (iy)


; ВЫВОД ХАЙДА
OHIDE:
            ld   (SSTK+1),sp
            ld   l,0
            ld   b,#A2
            exx  
            ld   hl,#4020
            ld   b,#0C
OH1:
;  ldsp,hl:inch:exx:ldh,b:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:exx
;  ldsp,hl:inch:exx:ldh,b:incl:HIDEM:incl:exx
            dec  hl
            ld   a,l
            add  a,32
            ld   l,a
            inc  hl
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            dec  b
            jp   nz,OH1

SSTK:       ld   sp,0
            ret  


; ОЧИСТИТЬ ЕГО
CLRHD:      ld   (LC529+1),sp
            ld   hl,#A260
            ld   de,#FFFF
            ld   b,#20
            ld   sp,hl
            dec  h
            rept 48
            push de
            endr
            djnz $-48-1-1
LC529:      ld   sp,0
            ret  




