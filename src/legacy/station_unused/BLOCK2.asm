;MISTAB
;INIMIS
;OMLIN
;PRLNAM
;NAME
;NAME2
;NEWJ















;JLIST
;  СПИСОК РАБОТ
;  ДАННЫЕ КУДА ДОСТАВИТЬ(2W)
;  ДАННЫЕ ВРЕМЕНИ (2W) К СКОЛЬКИ ДОСТАВИТЬ
;  ДАННЫЕ ВРЕМ. (2W) ВО СКОЛЬКО СГЕНЕРИЛИ
;  ДЕНЬГИ (W)
;  ВЕС (B),БИТ 7=1 - МИСИЯ ВЗЯТА,НЕТ ОТКАЗ
;  НОМЕР ПЛАНЕТЫ (B)

MISTAB:
;  ТАБЛИЦА ИНДЕКС ГЕНЕРАТОРОВ ДЛЯ КАЖДОЙ
;  СТРОКИ МИССИИ
            db   2,25,51,77,101,124,153,172,207,228


INIMIS:
;  ИНИЦИАЛ. МИССИЙ
            ld   hl,(SYST2)
            ld   (Sdo+1),hl
            ld   ix,JLIST
            ld   de,MISTAB
            ld   b,10
ITB1:
            push bc
            ld   hl,(SYST1)
            ld   a,l
            xor  h
            ld   l,a
            ld   a,(de)
            inc  de
            xor  l
            ld   (Sdo),a
            push de
            call NEWJ
            pop  de
            ld   bc,16
            add  ix,bc
            pop  bc
            djnz ITB1
            ld   hl,(SYST2)
            ld   (Sdo+1),hl
            ld   de,MISTAB
            ld   ix,JLIST
            ld   b,10
NXTJ2:
            ld   hl,(SYST1)
            ld   a,l
            xor  h
            ld   l,a
            ld   a,(de)
            inc  de
            xor  l
            ld   (Sdo),a
            push de
            ld   l,(ix+4)
            ld   h,(ix+5)
            ld   de,(TIME)
            and  a
            sbc  hl,de
            jp   c,NWJ
            jr   nz,NXTJ
            ld   l,(ix+6)
            ld   h,(ix+7)
            ld   de,(TIME+2)
            and  a
            sbc  hl,de
            jp   z,NWJ
            jp   nc,NXTJ
NWJ:
            call NEWJ
NXTJ:
            call OMLIN
            pop  de
            dec  b
            jr   nz,NXTJ2
            ret  



;------------------------
OMLIN:
;  ВЫВОД СТРОКИ МИССИИ
            ld   a,(ix+0)
            inc  a
            ret  z
            push bc
            dec  a
            ld   e,a
            ld   d,(ix+1)
            ld   (RNDD2+1),de
            ld   l,(ix+2)
            ld   h,(ix+3)
            ld   (RNDD1+1),hl
            call NAME
            ld   hl,TNAME
            call Outtxt
            ld   a,11
            ld   (Cord+1),a
            ld   a,(ix+15)
            dec  a
            jr   z,$+9
            push af
            call RNDD
            pop  af
            jr   $-8
            call PRLNAM
            ld   a,19
            ld   (Cord+1),a
            ld   c,(ix+14)
            ld   b,0
            call Onum3
            ld   a,23
            ld   (Cord+1),a

            ld   a,(ix+5)
            and  #F0
            rrca 
            rrca 
            rrca 
            rrca 
            add  a,"0"
            RST___NOARG
            ld   a,(ix+5)
            and  #0F
            add  a,"0"
            RST___NOARG
            ld   a,(ix+4)
            and  #F0
            rrca 
            rrca 
            rrca 
            rrca 
            add  a,"0"
            RST___NOARG
            ld   a,(ix+4)
            and  #0F
            add  a,"0"
            RST___NOARG
            RST_ ":"
            ld   a,(ix+7)
            and  #F0
            rrca 
            rrca 
            rrca 
            rrca 
            add  a,"0"
            RST___NOARG
            ld   a,(ix+7)
            and  #0F
            add  a,"0"
            RST___NOARG

            ld   a,31
            ld   (Cord+1),a
            ld   l,(ix+12)
            ld   h,(ix+13)
            call Onum5
            ld   a,2
            ld   (Cord+1),a
            ld   a,(Cord+2)
            inc  a
            ld   (Cord+2),a
            ld   bc,16
            add  ix,bc
            pop  bc
            ret  



;------------------------

PRLNAM:
;  ПЕЧАТЬ ИМЯ ПЛАНЕТЫ
            push bc
            push de
            call RNDD
            ld   hl,(RNDD1+1)
            ld   a,l
            xor  h
            exx  
            and  1
            inc  a
            call NAME2
            ld   hl,TNAME
            call Outtxt
            pop  de
            pop  bc
            ret  





;--------------------------
NAME:
;  ГЕНЕРИТЬ ИМЯ
;  В БУФЕРЕ TNAME
;hl-yx,de-YX-ДАННЫЕ СИСТЕМЫ
            ld   a,h
            xor  d
            xor  e
            xor  l
            exx  
            and  3
            add  a,2
NAME2:
            ld   c,a
            ld   hl,TNAME
            exx  

            ld   a,l
            add  a,e
            ld   c,a
            ld   a,h
            add  a,d
            ld   b,a
            ld   d,h
            ld   e,l

            ld   hl,MNEMO
            ld   a,b
            ex   af,af'
            ld   b,c
            res  7,c
            sla  c
            bit  7,b
            ld   b,0
            add  hl,bc
            jr   z,NAM1
            inc  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            exx  
            dec  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            exx  
            jr   NAM2
NAM1:
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            exx  
            inc  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            exx  
NAM2:
            ld   hl,MNEMO
            ex   af,af'
            ld   c,a
            ld   b,a
            res  7,c
            sla  c
            bit  7,b
            ld   b,0
            add  hl,bc
            jr   z,NAM3
            inc  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
            dec  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
            jr   NAM4
NAM3:
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
            inc  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
NAM4:
            ld   hl,MNEMO
            ld   a,d
            ex   af,af'
            ld   d,e
            res  7,e
            sla  e
            bit  7,d
            ld   d,0
            add  hl,de
            jr   z,NAM5
            inc  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
            dec  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
            jr   NAM6
NAM5:
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
            inc  hl
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
            dec  c
            jr   z,ENAME
            exx  
NAM6:
            ld   hl,MNEMO
            ex   af,af'
            ld   e,a
            ld   d,a
            sla  e
            bit  7,d
            ld   d,0
            add  hl,de
            jr   z,NAM7
            inc  hl
NAM7:
            ld   a,(hl)
            exx  
            ld   (hl),a
            inc  hl
ENAME:
            ld   (hl),0
            ret  






;-------------------------------
NEWJ:
;  ГЕНЕРИМ КАРТУ БЛИЖАЙШУЮ И НОМЕР ЗВЕЗДЫ
;  ДЛЯ СПИСКА МИССИЙ ПЕРЕВОЗОК
;ix-ВЕКТОР ДАННЫХ О МИССИЯХ
            push bc
            ld   hl,(TIME)
            ld   (ix+8),l
            ld   (ix+9),h
            ld   a,(TIME+3)
            ld   (ix+11),a
            ld   (ix+10),#99
            call RND
            ld   a,h
            and  #0F
            cp   9
            jr   c,$+4
            sub  9
            inc  a
            ld   d,a
            ld   a,l
            and  #7F
            ld   e,a
;  СДВИГАЕМСЯ НА НУЖНУЮ КАРТУ
            ld   hl,(SYST1)
            dec  d
            jr   z,NJ2
            inc  l
            dec  d
            jr   z,NJ11
            inc  h
            dec  d
            jr   z,NJ12
            dec  l
            dec  d
            jr   z,NJ13
            dec  l
            dec  d
            jr   z,NJ14
            dec  h
            dec  d
            jr   z,NJ15
            dec  h
            dec  d
            jr   z,NJ16
            inc  l
            dec  d
            jr   z,NJ17
            inc  l
;  ОПРЕДЕЛИМ ГОСУДАРСТВО
            call GOSTA
            cp   3
            jr   nz,NJ2
;  ЕСЛИ СВОБ. ЗЕМЛИ ПЕРЕМЕСТИМ НА ШАГ НАЗА
            dec  l
NJ17:
            call GOSTA
            cp   3
            jr   nz,NJ2
            dec  l
NJ16:
            call GOSTA
            cp   3
            jr   nz,NJ2
            inc  h
NJ15:
            call GOSTA
            cp   3
            jr   nz,NJ2
            inc  h
NJ14:
            call GOSTA
            cp   3
            jr   nz,NJ2
            inc  l
NJ13:
            call GOSTA
            cp   3
            jr   nz,NJ2
            inc  l
NJ12:
            call GOSTA
            cp   3
            jr   nz,NJ2
            dec  h
NJ11:
            call GOSTA
            cp   3
            jr   nz,NJ2
            dec  l
NJ2:
;  ОПРЕДЕЛИМ ПО НОМЕРУ ЗВЕЗДЫ ЕСТЬ ЛИ У
;  НЕЕ ПЛАНЕТЫ И ВЫБЕРЕМ ЕЕ ЕСЛИ ЕСТЬ
;  ИНАЧЕ ДР. ЗВЕЗДА
            push hl
            push de
            EXD
            exx  
            ld   hl,KR0
            call RNDI

            pop  de
            exx  
            pop  hl
            exx  
            ld   h,high(KR0)
NJ4:
            ld   a,e
            sla  a
            ld   l,a
            ld   c,(hl)
            inc  l
            ld   b,(hl)
            ld   a,c
            xor  b
            exx  
            xor  h
            xor  l
            exx  
            rrca 
            rrca 
            and  7
            jr   nz,NJ3
;  ЗВЕЗДА БЕЗ ПЛАНЕТ
PO3:
            ld   a,e
            inc  a
            and  #7F
            ld   e,a
            jr   NJ4
NJ3:
            cp   7
            jr   nz,$+4
            ld   a,3
;a-КОЛ. ПЛАНЕТ-1

            push hl
            push de

            exx  
            push hl
            ld   (RNDD2+1),hl
            exx  
            ld   (RNDD1+1),bc
            push bc
            ld   e,a
            ld   d,a
            ld   c,0

            ld   (STK45+1),sp

PO1:
            exx  
            call RNDD
            ld   a,h
            xor  d
            xor  l
            xor  e
            exx  
            cpl  
            and  #C0
            jr   z,PO2
            push de
            inc  c
PO2:
            dec  e
            jr   nz,PO1
            ld   a,c
            and  a
            jp   nz,PO4
;  НА ЭТОЙ ЗВЕЗДЕ ВСЕ ПЛАНЕТЫ НЕ ЗАСЕЛЕНЫ
            pop  bc
            pop  hl
            exx  
            pop  de
            pop  hl
            jp   PO3
PO4:
            push de
            push bc
            call RND
            pop  bc
            pop  de
            ld   a,l
            and  7
            cp   c
            jr   c,$+5
            rra  
            jr   $-4
            inc  a
            ld   b,a
            ld   c,d
            pop  de
            djnz $-1

STK45:      ld   sp,0

            ld   a,e
            sub  c
            neg  

;a- НОМЕР ПЛАНЕТЫ
            inc  a

            ld   (ix+15),a

            pop  bc
            exx  
            pop  hl
            pop  bc
            pop  bc
            push hl
            ld   (RNDD2+1),hl
            exx  
            ld   (RNDD1+1),bc
            push bc
            ld   bc,(SYST2)
            ld   de,(SYST1)
            push ix
            call FARER
            pop  ix
            pop  bc
            pop  de
;  ОПРЕДЕЛИМ ВРЕМЯ ПРИБЫТИЯ


            push hl

            ld   a,l
            and  #77
            add  a,#11
            daa  
            ld   l,a
            ld   a,h
            and  #77
            adc  a,0
            daa  
            ld   h,a

;  ПРОПИСЫСВАЕМ НОВОЕ ВРЕМЯ ГЕНЕРАЦИИ

;  СУМИРУЕМ ИНТЕРВАЛ ПРОЛЕТА И ВРЕМЯ
;  ГЕНЕРАЦИИ, И ПРОПИСЫВАЕМ ЕГО
            ld   a,(ix+11)
            add  a,l
            daa  
            ld   (ix+7),a
            ld   a,(ix+8)
            adc  a,h
            daa  
            ld   (ix+4),a
            ld   a,(ix+9)
            adc  a,0
            daa  
            ld   (ix+5),a

            ld   (ix+0),e
            ld   (ix+1),d
            ld   (ix+2),c
            ld   (ix+3),b

            call RND
            EXD
            pop  hl
            srl  h
            rr   l
            srl  h
            rr   l
            ld   a,l
            and  #FC
            ld   l,a
            add  hl,hl
            add  hl,hl
            add  hl,hl
            ld   c,l
            ld   b,h
            add  hl,hl
            add  hl,hl
            add  hl,bc
            add  hl,bc
            ld   a,e
            and  %00011100
            add  a,5
            ld   e,a
            rlca 
            rlca 
            add  a,l
            ld   l,a
            ld   a,h
            adc  a,0
            ld   h,a
            ld   (ix+12),l
            ld   (ix+13),h          ;ДЕНЬГИ
            ld   (ix+14),e          ;МАССА
            pop  bc
            ret  

