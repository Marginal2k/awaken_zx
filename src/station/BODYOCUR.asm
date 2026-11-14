;MTBXX2     ■MERZ
;PGS        ■PG
;EXAS       ■WOST
;OUTC       ■TESTMOV
;Outcur     ■Outc1
;Awost      ■Directz
;Servms     ■Servkj
;Servqa     ■Cler
;Directj    ■Rlud













; ПРОЦЕДУРЫ НАЧАЛА И ИНИЦИЯЛИЗАЦИИ
; ПРОЦЕДУРЫ УПРАВЛЕНИЕМ КУРСОРОМ И ЕГО
; ВЫВОДОМ НА ЭКРАН

; [glue] returning from the flight part: take over the state record left in screen RAM by the
; flight launcher (STATE_FLAG=1) before the loader code is copied over #4000
            ld   a,(STATE_FLAG)
            dec  a
            jr   nz,NO_STATE
            ld   (STATE_FLAG),a
            ld   hl,STATE_BUF
            ld   de,TIME
            ld   bc,STATE_LEN
            ldir
NO_STATE:
            ld   hl,#5800
            ld   de,#5801
            ld   bc,#2FF
            ld   (hl),l
            ldir 


            ld   de,#4000
            push de
            ld   bc,block1-($+9)
            ld   hl,$+6
            ldir 
            ret  

            disp #4000
            ld   hl,block1
            ld   de,_FREE
            ld   bc,END1-block1
            ldir 
            di   
            xor  a
            out  (#FE),a
            ld   (Unclick+1),a
            PAGE_ #17
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#1AFF
            ld   (hl),l
            ldir 
            PAGE_ #18

            include "LOADER.asm"

            di   
            ld   hl,Forint
            ld   a,h
            ld   i,a
            ld   de,Forint+1
            ld   bc,#0100
            ld   (hl),#81
            ldir 
            ld   hl,#8181
            ld   (hl),#C3
            inc  l
            ld   (hl),low(Int)
            inc  l
            ld   (hl),high(Int)

            ld   hl,Sur1
            ld   (Adnsur+1),hl





; ГЕНЕРАЦИЯ ТАБЛИЦЫ ПОИСКА АДРЕСА ПО
; КООРДИНАТАМ НА ЭКРАНЕ И БАЙТ ПИКСЕЛИ
; ДЛЯ КАЖДОЙ ПОЗИЦИИ
;MTBXX
            ld   hl,TBXX
            ld   de,#4000
MT1:
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            NEXTLINEDE
            inc  l
            jr   nz,MT1
            inc  h
            inc  h
            xor  a
            ld   b,8
            ld   (hl),a
            inc  l
            djnz $-2
            inc  a
            cp   32
            jr   c,$-9








;Instcur
; ИНСТАЛИРУЕТ КУРСОР ЕГО УПРАВЛЕНИЕ
; ДЕТЕКТИРУЕТ ДЖОЙСТИК И МЫШЬ
; УСТАНОВКА НАЧАЛЬНЫХ КООРДИНАТ
            ld   hl,0
            ld   (Mcoord),hl
; НИЖНЯЯ ГРАНИЦА ДЛЯ КУРСОРА
            ld   a,191
            ld   (Bord2+1),a
; ЛЕВАЯ
            ld   a,255
            ld   (Bord1+1),a
; ВЫСОТА КУРСОРА
            ld   a,8
            ld   (High_+1),a
; ШАГ КУРСОРА
            ld   a,2
            ld   (Speed+1),a
; АДРЕС МЕСТА ВОССТАНОВЛЕНИЯ ПОД КУРСОРОМ
            ld   hl,0
            ld   (ADWOST+1),hl
            ld   hl,KURSA
            ld   (AKURSA+1),hl



; ДЕТЕКТ ДЖОЙСТИК
            in   a,(#1F)
            and  #1F
            ld   a,1
            jr   nz,$+3
            dec  a
            ld   e,a
            ld   a,(JOYSTIK)
            res  7,a
            cpl  
            and  e
            ld   (Servkj+1),a
; ДЕТЕКТ МЫША
            ld   bc,#FBDF
            in   a,(c)
            inc  a
            ld   e,1
            jr   z,$+3
            dec  e
            ld   b,#FF
            in   a,(c)
            inc  a
            ld   a,1
            jr   z,$+3
            dec  a
            and  e
            ld   e,a
            ld   a,(MOUSE)
            res  7,a
            cpl  
            and  e
            ld   (Servms+1),a


; НЕ ПОКАЗЫВАЕМ ОКНА И ВСЕ ОСТАЛЬНОЕ
            xor  a
            ld   (ACTIV+1),a

            ld   bc,SETSI
            ld   de,SETSD
            call TOCODE
            ld   bc,SETGI
            ld   de,SETGD
            call TOCODE

; ИНИЦИАИЗАЦИЯ КООРДИНАТ И НОМЕРОВ
; ОБЪЕКТОВ
            call SETCRDS
            ld   ix,Objvec
            ld   c,0
            ld   de,16
H_1:
            ld   a,(ix+0)
            cp   #80
            jr   z,H_2
            ld   l,(ix+12)
            ld   h,(ix+13)
            inc  hl
            ld   (hl),c
            inc  hl
            ld   (hl),0
            inc  c
            add  ix,de
            jp   H_1
H_2:

            ld   hl,(WMAP_+1)
            ld   a,10
            call TOOBJ
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            dec  l
            dec  h
            dec  l
            dec  h
            dec  h
            ADDHLHL 3
            ld   (BXKRT),hl

            PAGE_ PGKRT
            ld   de,(PLACE)
            ld   hl,(PLACE+2)
            call CENTRE2
            PAGE_ PGNORM

            ld   a,(MUSIC+1)
            ld   (LMUSIC+1),a
            ld   hl,WAY
            ld   (AWAYS),hl

            im   2
            ei   

            jp   Dalee

            ent

block1:
            disp _FREE
;  ГЕНЕРАЦИЯ ТАБЛИЦЫ ПОИСКА АДРЕСА ПО
;  КООРДИНАТАМ В ОКНЕ КАРТЫ И БАЙТ ПИКСЕЛИ
;  ДЛЯ КАЖДОЙ ПОЗИЦИИ
;de-КООРД. КАРТЫ

MTBXX2:
            ld   a,e
            add  a,8
            ld   e,a
            ld   a,d
            add  a,#10
            ld   l,a
            ld   h,high(TBXX)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            add  a,(hl)
            ld   e,a
;de-АДРЕС НА ЭКРАНЕ
            and  #1F
            ex   af,af'
            ld   a,e
            and  %11100000
            ld   e,a

            ld   hl,TBXX2
MT_1:
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            NEXTLINEDE
            inc  l
            jr   nz,MT_1
            inc  h
            inc  h
            ex   af,af'
MT3:
            ld   b,8
            ld   (hl),a
            inc  l
            djnz $-2
            inc  a
            inc  l
            dec  l
            jr   nz,MT3
            ret  





MERZ:
            ld   a,(P00sh1d)
            xor  %01100000
;  ЧETЫPEX УГOЛЬhЫe
            ld   (P00stur),a
            ld   (P00trd),a
            ld   (P00turi),a
            ld   (P00sh1d),a
            ld   (P00sh2d),a
            ld   (P00kd4),a
            ld   (P00klpd),a
;TPEX УГOЛЬhЫe
            ld   a,(P00kd5)
            xor  %01100000
            ld   (P00istr),a
            ld   (P01istr),a
            ld   (P00kd5),a
            ld   (P01kd5),a
            ld   (P00pshd),a
            ld   (P01pshd),a
            ret  



PGS:
            push bc
            ld   c,a
            ld   a,(NPG)
            and  %11111000
            or   c
            pop  bc
PG:
            push bc
            ld   (NPG),a
            ld   bc,#7FFD
            out  (c),a
            pop  bc
            ret  

EXAS:
            PAGE_ PGMUZ
            call #DB08
            im   1
            ld   a,#3F
            ld   i,a
            ld   iy,#5C3A


            PAGE_ PGNORM

            pop  hl
            ret  




WOST:
            push ix
            push af
            push hl
            push de
            push bc
            ld   a,1
            ld   (FWOST+1),a
            call Awost
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  ix
            ret  
OUTC:
            push ix
            push af
            push hl
            push de
            push bc
            ld   a,1
            ld   (FWOST+1),a
            call Outc1
            xor  a
            ld   (FWOST+1),a
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  ix
            ret  

;bufz (БУФЕР ЗАПОМИНАНИЙ) В "kursa"
; ДОЛЖНЫ БЫТЬ ЗАДАНЫ С РАЗМЕРОМ СООТВЕТСТ-
; ВУЮЩИМ КУРСОРУ
; КУРСОР: МИН.РАЗМЕР 2ЗНАК.X1pix
; ДОЛЖНО БЫТЬ ВОСЕМЬ СПРАЙТОВ
; СПРАЙТ, МАСКА И Т.Д.

TESTMOV:
            push hl
            push de
            ld   hl,(Directz+1)
            ld   de,(Directz+3)
            ld   a,h
            or   l
            or   e
            or   d
            ld   hl,(Directj)
            ld   de,(Directj+2)
            or   l
            or   h
            or   e
            or   d
            pop  de
            pop  hl
            ret                     ; z;NO MOVES


Outcur:

            call TESTMOV
            ret  z

            call Awost
;  ПЕРЕКЛЮЧЕНИЕ ВИДА КУРСОРА ОТ ПОЛОЖЕННИЯ


Outc1:


            call Tident
            and  a
            ld   de,KURSA
            jp   z,N_3+4
            dec  a
            rlca 
            ld   l,a
            ld   h,high(Tabob)
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  h
            jr   z,N_1
            dec  h
            ld   d,h
            ld   e,l
            call TOOBJ4
            push hl
            ld   a,(hl)
            and  %11000000
            jr   nz,N_1
            ld   a,(hl)
            ex   af,af'
            DEC_HL 3
            ld   a,(Mcoord+1)
            srl  a
            srl  a
            srl  a
            cp   (hl)
            ld   de,KURSAM
            jr   nz,N_2
            ex   af,af'
            and  4
            jr   nz,N_1
            jr   N_1+3
N_2:
            ex   af,af'
            and  2
            jr   nz,N_1
            ex   af,af'
            ld   b,a
            ld   a,(hl)
            INC_HL 2
            add  a,(hl)
            dec  a
            cp   b
            ld   de,KURSAS
            jr   z,N_1+3
N_1:
            ld   de,KURSA
            ld   (AKURSA+1),de
            pop  ix
;  ОПРЕДЕЛЕНИЕ ПОСЛЕДНИЙ ЛИ ОБКТ НА СТОЛЕ
            ld   de,0-4
            add  ix,de
            call LASTOBJ
            ld   e,(ix+12)
            ld   d,(ix+13)
            SUB_DE
            jr   nz,N_3

;  ОКНО ЛИ ЭТО
            ld   a,(ix+4)
            and  #C0
            jr   nz,N_3
;  ЭТО ОКНО
;  ОБЪЕКТ ПОСЛЕДНИЙ И ВИДИМЫЙ
;  ПЕРЕХОДИМ НА ОБРАБОТЧИК СОБЫТИЯ:
;"КУРОСР В ОБЛАСТИ ОБЪЕКТА"
            ld   l,(ix+6)
            ld   h,(ix+7)
;        ldde,N_3
;        pushde
;        jp(hl)

            ld   (IXZD+2),ix
            ld   (ZADAT+1),hl


N_3:
            ld   de,(AKURSA+1)
            ld   (AKURSA+1),de

            ld   a,(Awost+1)
            or   a
            ret  z

            ld   bc,(Mcoord)
            ld   a,c
            and  7
;and7,X * 32
            ld   l,0
            rra  
            rr   l
            rra  
            rr   l
            rra  
            rr   l
            ld   h,a
AKURSA:     ld   de,0               ;СПРАЙТЫ КУРСОРОВ
            add  hl,de
            EXD
;TAKE ADRES ON SCREEN FROM TABL
            ld   h,high(TBXX)
            ld   l,b
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            or   (hl)
            ld   l,a
            ld   h,b
            ld   (ADWOST+1),hl
            push de
;3AПOMИHAHИe
            ld   de,Bufz
            ld   a,(Mcoord+1)
            ld   b,a
            ld   a,191
            ld   c,a
            sub  b
            ld   b,a
Porog:      cp   7
;  ПОРОГ=ВЫСОТА-1
Shigh:      ld   a,8                ;ВЫСОТА КУРСОРА
            ; ??? ЗАДАННАЯ
            jr   nc,$+4
; УМЕНЬШИМ ВЫСОТУ КУРСОРА ЕСЛИ ОН ВЫХОДИТ
; ЗА ЭКРАН СНИЗУ
            ld   a,b
            inc  a

            ld   (High_+1),a
            ld   b,a
Zap1:
            ldi  
            ldi  
            DEC_HL 2
            NEXTLINE
            djnz Zap1

;bЫBOД
            ld   de,(ADWOST+1)
            pop  hl

            xor  a
            ld   (Awost+1),a


; ВЫВОД ПОЛ КУРСОРА
; deАДРЕС НА ЭКРАНЕ
; hlАДРЕС КУРСОРА
High_:      ld   b,8                ;ВЫСОТА КУРСОРА
            ld   a,(Mcoord)
            cp   248
            jr   c,Pri2
; ВЫВОДИМ ПОЛОВИНУ
Pri3:       ld   a,(de)
            and  (hl)
            inc  l
            xor  (hl)
            inc  l
            inc  l
            inc  l
            ld   (de),a
            NEXTLINEDE
            djnz Pri3
            ret  
Pri2:
; ВЫВОД ЦЕЛОГО КУРСОРА
;hlАДРЕС НЕ ЭКРАНЕ
;deАДРЕС КУРСОРА
            ld   a,(de)
            and  (hl)
            inc  l
            xor  (hl)
            inc  l
            ld   (de),a
            inc  e
            ld   a,(de)
            and  (hl)
            inc  l
            xor  (hl)
            inc  l
            ld   (de),a
            dec  e
            NEXTLINEDE
            djnz Pri2
            ret  
Awost:

            ld   a,0
            and  a
            ret  nz
            inc  a
            ld   (Awost+1),a

ADWOST:     ld   de,0               ;АДРЕС ВОССТАНОВЛ.
            ld   hl,Bufz
            ld   c,#FF
            ld   a,(High_+1)
            ld   b,a
Wo1:
            ldi  
            ldi  
            DEC_DE 2
            NEXTLINEDE
            djnz Wo1
            ret  
;  БУФЕР ЗАПОМИНАНИЙ
Bufz:       ds   #10












;  ПРОЦЕДУРЫ УПРАВЛЕНИЯ КУРСОРОМ МЫШЬЮ
;  ДЖОЙСТИКОМ И КЛАВОЙ

;MOUSE DRIVER FROM ZX-FORMAT
Directz:    db   0                  ;FIRE
            db   0                  ;UP
            db   0                  ;DOWN
            db   0                  ;RIGHT
            db   0                  ;LEFT
            db   0                  ;CANCEL
            db   0                  ;MEDIUM
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
            ld   hl,Directz
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
Mdrv4:      ld   hl,(Mcoord)
            ld   de,(Mports)
            ld   bc,#FBDF
            in   a,(c)
            ld   (Mports),a
            sub  e
            jr   z,Mdrv9
            jp   p,Mdrv6
            ld   (ix+4),1
Zcm3:       add  a,a
            add  a,l
            jr   c,Mdrv5
            xor  a
Mdrv5:      ld   l,a
            jr   Mdrv9
Mdrv6:
Zcm4:       add  a,a
            add  a,l
            ld   (ix+3),1
            jr   c,Mdrv7
            cp   #FE
            jr   c,Mdrv8
Mdrv7:      ld   a,#FE
Mdrv8:      ld   l,a
Mdrv9:      ld   b,#FF
            in   a,(c)
            ld   (Mports+1),a
            sub  d
            jr   z,Mdrv14
            neg  
            jp   p,Mdrv11
            ld   (ix+1),1
Zcm1:       add  a,a
            add  a,h
            jr   c,Mdrv10
            xor  a
Mdrv10:     ld   h,a
            jr   Mdrv14
Mdrv11:
Zcm2:       add  a,a
            add  a,h
            ld   (ix+2),1
            jr   c,Mdrv12
            cp   #BF
            jr   c,Mdrv13
Mdrv12:     ld   a,#BF
Mdrv13:     ld   h,a
Mdrv14:     ld   (Mcoord),hl
            pop  ix
            ret  

;  ПpoЦeДУPA SERVJK
;  УПPABЛEHИeKOOPДИHATAMИ KУPCOPA bПИKC
;eЛ.
;cПOM. QAOP,sp;KEMPSTONA
;  БУФEPЫ:
;BUFZ  - 3AПOMИHAHИЯ ПOД KУPCOCPOM
;KURSA - KУPCOP
;  БЫTЬ 3AДAHЫ cPA3MEPOM COOTBETCTBУЮЩИm
;KУPCOPУ
;KУPCOP:mИh.PA3MEP 2znak.X1pix.
;  ДOЛЖHO БЫTЬ 8 cПPAЙTOB
;(KУPCOP,MACKA,И TД.) KAЖДЫЙ
;  И3 KOTOPЫX cДbИhУT cЛEBA HA ПPABO HA p
;ix.

;  ПEPEД bЫ3OBOM HEOБXOДИMO CTИPATЬ БУФEP
;      DIRECTJ


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
            set  3,e                ;UP
            ld   hl,(KDOWN)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  2,e                ;DOWN
            ld   hl,(KLEFT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  1,e                ;LEFT
            ld   hl,(KRIGHT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  0,e                ;RIGHT
            ld   hl,(KFIRE)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  4,e                ;FIRE
            ld   hl,(KCANCEL)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  5,e                ;CANCEL
            ld   a,e
Gomove:
;bЫ3OB ПpoЦ. И3MEHEHИЯ KOOPДИHATЫ b3AB
;  Иc
;MOCTИ OT HAЖATOЙ KHOПKИ

;  И3MEHЯЮTCЯ ПEPEMEHHЫeCOCTOЯhИЯ HAЖATИЯ
;KAKИX ЛИБO KЛABИШ LEFT,RIHGT,UP,DOWN,F
;IRE,CANCEL
            ld   e,a
            ld   hl,Directj
            xor  a
            ld   d,a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a

            rrc  e
            res  5,e
            res  6,e
            ld   hl,Rlud
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a

            ld   de,SP1
            push de

            ld   bc,(Mcoord)
Speed:      ld   e,1
;CKOPOCTЬ KУPCOPA
Bord2:      ld   d,0
;hИЖhЯЯ ГPAHИЦa
Bord1:      ld   a,0
;  ПPABAЯ ГPAHИЦa
            jp   (hl)
SP1:
            ld   (Mcoord),bc
            ret  
Cler:
; СБPOCИTЬ COCTOЯhИЯ ПpeДЫДУЩeГO ДeЙCTBИЯ
            ld   hl,Directj
            xor  a
            rept 5
            ld   (hl),a
            inc  hl
            endr
            ld   (hl),a
            ret  
Directj:
            db   0                  ;RIGHT
            db   0                  ;LEFT
            db   0                  ;DOWN
            db   0                  ;UP
            db   0                  ;FIRE
            db   0                  ;CANCEL

Rlud:       dw   Nthmove
            dw   Rud                ;RIGHT
            dw   Lud                ;LEFT
            dw   Nthmove
            dw   Dow                ;DOWN
            dw   Rtdn               ;RIGHT andDOWN
            dw   Ltdn               ;LEFT andDOWN
            dw   Nthmove
            dw   Upi                ;UP
            dw   Rtup               ;RIGHT andUP
            dw   Ltup               ;LEFT andUP
            dw   Nthmove
            dw   Nthmove
            dw   Nthmove
            dw   Nthmove
            dw   Nthmove

Ltup:
;bЛEBO И BBEPX
            ld   a,c
            sub  e
            jp   nc,$+4
            xor  a
            ld   c,a
            ld   a,b
            sub  e
            ld   b,a
            ret  nc
            ld   b,0
            ret  
Ltdn:
;bЛEBO И BHИ3
            ld   a,c
            sub  e
            jp   nc,$+4
            xor  a
            ld   c,a
            ld   a,b
            add  a,e
            ld   b,a
            cp   d
            ret  c
            ld   b,d
            ret  
Rtup:
;bПPABO И BBEPX
            ld   l,a
            ld   a,c
            add  a,e
            ld   c,a
            jp   c,$+7
            cp   l
            jp   c,$+4
            ld   c,l
            ld   a,b
            sub  e
            ld   b,a
            ret  nc
            ld   b,0
            ret  
Rtdn:
;bПPABO И BHИ3
            ld   l,a
            ld   a,c
            add  a,e
            ld   c,a
            jp   c,$+7
            cp   l
            jp   c,$+4
            ld   c,l
            ld   a,b
            add  a,e
            cp   d
            ld   b,a
            ret  c
            ld   b,d
            ret  
Lud:
;bЛEBO
            ld   a,c
            sub  e
            ld   c,a
            ret  nc
            ld   c,0
            ret  
Rud:
;bПPABO
            ld   l,a
            ld   a,c
            add  a,e
            jp   c,$+6
            ld   c,a
            cp   l
            ret  c
            ld   c,l
            ret  
Nthmove:
            ret  
Upi:
;BBEPX
            ld   a,b
            sub  e
            ld   b,a
            ret  nc
            ld   b,0
            ret  
Dow:
;BHИ3
            ld   a,b
            add  a,e
            cp   d
            ld   b,a
            ret  c
            ld   b,d
            ret  



