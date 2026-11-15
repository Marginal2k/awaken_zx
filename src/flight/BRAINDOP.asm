;VSLINE


PRECORD:
; ИЗМЕНЯЕМ КООРДИНАТЫ В ЗАВИСИМОСТИ ОТ
; ДВИЖЕНИЯ
            ld   (STK1+1),sp

            ld   a,(ix+TYPE)
            cp   T_TRASH
            jr   nz,.PD1
            ld   hl,(STPX+1)
            ld   (RSTPX+1),hl
            rept 1
            sra  h
            rr   l
            endr
            ld   (STPX+1),hl
            ld   hl,(STPY+1)
            ld   (RSTPY+1),hl
            rept 1
            sra  h
            rr   l
            endr
            ld   (STPY+1),hl
            ld   hl,(STPZ+1)
            ld   (RSTPZ+1),hl
            rept 1
            sra  h
            rr   l
            endr
            ld   (STPZ+1),hl
.PD1
            ld   a,(ix+INDI)
            call SIZEOBJ
            ld   a,#06
            sub  h
            ld   hl,200
            ld   ($+4),a
            jr   $
            ADDHLHL 5
            ld   a,SPACEBORDER
            sub  h
            ld   b,a
            ld   a,ixl
            ld   l,a
            ld   a,ixh
            ld   h,a
            ld   sp,hl
STPX_:      ld   hl,0
STPX:       ld   de,0
            SUB_DE
            pop  de
            ld   a,d
            cp   #80
            jr   z,STK1
            and  a
            adc  hl,de
            jp   pe,EXES
            ld   a,h
            jp   p,$+4
            cpl
            cp   b
            jp   nc,EXES
            push hl
STPY_:      ld   hl,0
STPY:       ld   de,0
            SUB_DE
            inc  sp
            inc  sp
            pop  de
            and  a
            adc  hl,de
            jp   pe,EXES
            ld   a,h
            jp   p,$+4
            cpl
            cp   b
            jr   nc,EXES
            push hl
STPZ_:      ld   hl,0
STPZ:       ld   de,0
            SUB_DE
            inc  sp
            inc  sp
            pop  de
            and  a
            adc  hl,de
            jp   pe,EXES
            ld   a,h
            jp   p,$+4
            cpl
            cp   b
            jr   nc,EXES
            push hl
STK1:       ld   sp,0
            ld   a,(NOSTAT)
            and  a
            jp   z,REXE
            ld   d,#12
            call FINDOBJ
            jp   z,REXE
; НАХОДИМ САМУЮ БОЛЬШУЮ КООРДИНАТУ СТАНЦИИ
            ld   a,(iy+5)
            ACPL_A
            ld   b,a
            ld   a,(iy+3)
            ACPL_A
            ld   c,a
            ld   a,(iy+1)
            ACPL_A
            cp   c
            jr   nc,$+3
            ld   a,c
            cp   b
            jr   nc,$+3
            ld   a,b
            cp   LAUNGH
; ЕСЛИ ЕЩЕ ДАЛЕКО
            jr   c,MESST
            ld   a,#80
            ld   (MESST+1),a
            jr   REXE
MESST:      ld   a,0
            and  a
            jp   p,REXE
; РЕЖИМ СТЫКОВКИ СО СТАНЦИЕЙ
            ld   a,24
            ld   (MESST+1),a
            MESAG _DOCKING
            jr   REXE
EXES:
; ЕСЛИ КОРАБЛЬ ЗА ГРАНИЦЕЙ
            ld   sp,(STK1+1)
            call DEATHX
            ld   a,(ix+TYPE)
            cp   T_STATION
            jr   nz,REXE
; ЕСЛИ СТАНЦИЯ ЗА ГРАНИЦЕЙ
            xor  a
            ld   (STATGEN),a
            ld   (NOSTAT),a
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
.EXE2
            call FINDOB
            ret  z
            ld   a,(iy+TYPE)
            cp   T_STATION
            jr   nz,.EXE2
            call DEATHY
            jp   .EXE2

REXE:
            ld   a,(ix+TYPE)
            cp   T_TRASH
            ret  nz
RSTPX:      ld   hl,0
            ld   (STPX+1),hl
RSTPY:      ld   hl,0
            ld   (STPY+1),hl
RSTPZ:      ld   hl,0
            ld   (STPZ+1),hl
            ret


GETADRY:
; ПОЛУЧЕНИЕ АДРЕСА ВЕКТОРА ИЗ ИНДЕКСА ЕГО
; В РЕГ. iy
            push hl
            call GETADR
            push hl
            pop  iy
            pop  hl
            ret


GETADR:
; ПОЛУЧЕНИЕ АДРЕСА ВЕКТОРА ИЗ ИНДЕКСА ЕГО
;a-ИНДЕКС
;rethl-АДРЕС
            ld   l,0
            srl  a
            rr   l
            srl  a
            rr   l
            add  a,high(CARSB)
            ld   h,a
            ret


GETINDX:
; ПОЛУЧЕНИЕ ИНДЕКСА ИЗ АДРЕСА В iy
;ix-АДРЕС
;reta-ИНДЕКС
            push hl
            push ix
            pop  hl
            call GETIND
            pop  hl
            ret


GETINDY:
; ПОЛУЧЕНИЕ ИНДЕКСА ИЗ АДРЕСА В iy
;iy-АДРЕС
;reta-ИНДЕКС
            push hl
            push iy
            pop  hl
            call GETIND
            pop  hl
            ret


GETIND:
; ПОЛУЧЕНИЕ ИНДЕКСА ИЗ АДРЕСА В hl
;hl-АДРЕС
;reta-ИНДЕКС
            ld   a,h
            sub  high(CARSB)
            sla  l
            rla
            sla  l
            rla
            ret


;----------------------
; ПОИСКОВИКИ ЧЕГО ЛИБО
;----------------------

FINDOB:
; НАЙТИ КАКОЙ НИБУДЬ ОБЪЕКТ
;iy-VECTOR-OLEN
;bc-OLEN
;FZ-ON ТО НЕ НАЙДЕНО
            add  iy,bc
            ld   a,(iy+1)
            cp   #80
            ret  nz
            ld   a,(iy)
            cp   #80
            jp   nz,FINDOB
            ret


FINDPEACE:
; НАЙТИ МИРНОГО
            call RNDL3
            ld   a,l
PWNPI:      cp   #A0
            ld   a,SPLAYER
            inc  a
            dec  a
            ret  nc
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
.FP2L
            call FINDOB
            ret  z
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_PIRAT
            jr   z,.FP2L
            cp   T_STATION
            jr   z,$+6
            cp   T_CHIP
            jr   nc,.FP2L
            call GETINDY
            inc  e                  ;cБPOC FZ
            ret


FINDALL:
; НАЙТИ ЛЮБОГО НО НЕ УФО
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
.FP6L
            call FINDOB
            ret  z
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_UFO
            jr   z,.FP6L
            cp   T_UFO2
            jr   z,.FP6L
            call GETINDY
            inc  e                  ;cБPOC FZ
            ret


FINDUFO:
; НАЙТИ УФО
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
.FP3L
            call FINDOB
            ret  z
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_UFO
            jr   z,$+6
            cp   T_UFO2
            jr   nz,.FP3L
            call GETINDY
            inc  e
            ret


FINDPIRAT:
; НАЙТИ ПИРАТА
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
.FP2
            call FINDOB
            ret  z
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_PIRAT2
            jr   z,$+6
            cp   PIRAT
            jr   nz,.FP2
            call GETINDY
            inc  e
            ret
;---------------------------------


TESTSUBJ:
; ТЕСТИРОВАНИЕ ПЕРСОНАЖА НА ПРЕДМЕТ ЕГО
; УЖЕ ИСЧЕЗНОВЕНИЯ
            ld   a,(ix+SUBJ)
            inc  a
            jr   nz,.TS1
            ld   hl,OLEN*SPLAYER+CARSB
            jr   .TS2
.TS1
            dec  a
            call GETADR
.TS2
            ld   (OPONE+2),hl
            inc  l
            ld   a,(hl)
            cp   #80
            ret  z
            ld   l,(ix+0)
            ld   h,(ix+1)
            ld   (DDX+1),hl
            ld   l,(ix+2)
            ld   h,(ix+3)
            ld   (DDY+1),hl
            ld   l,(ix+4)
            ld   h,(ix+5)
            ld   (DDZ+1),hl
            ret
OPONE:      ld   iy,0
            ld   a,(ix+SUBJ)
            cp   SPLAYER
            jr   nz,.FG2
            ld   bc,0
            ld   (TX+1),bc
            ld   (DX+1),bc
            ld   (DY+1),bc
            ld   (DZ+1),bc
            ld   hl,#FFB0
            ld   (TY+1),hl
            ld   de,0-1
            ld   (TZ+1),de
            ld   iy,PLAYER
            and  a
            ret
.FG2
            ld   a,(iy+PX+1)
            cp   #80
            scf
            ret  z
            and  a
            ld   l,(iy+0)
            ld   h,(iy+1)
            ld   (DX+1),hl
            ld   l,(iy+2)
            ld   h,(iy+3)
            ld   (DY+1),hl
            ld   l,(iy+4)
            ld   h,(iy+5)
            ld   (DZ+1),hl
            ld   c,(iy+PX)
            ld   b,a
            ld   (TX+1),bc
            ld   l,(iy+PY)
            ld   h,(iy+PY+1)
            ld   (TY+1),hl
            ld   e,(iy+PZ)
            ld   d,(iy+PZ+1)
            ld   (TZ+1),de
            ret


FIREING:
; ОРГАНИЗАЦИЯ ВЫСТРЕЛА ПЕРСОНАЖА В КОГО
; ЛИБО, ВЫВДО ЛУЧА, ИНИЦИАЛИЗАЦИЯ ДАННЫХ
;SUBJ & ACTN
            ld   a,(ix+PX+1)
            cp   #80
            scf
            ret  z
            ld   b,a
            ld   c,(ix+PX)
            ld   l,(ix+PY)
            ld   h,(ix+PY+1)
            ld   e,(ix+PZ)
            ld   d,(ix+PZ+1)
            exx
            call OPONE
            ret  c
            ld   a,r
PWPPI:      cp   #4A
            jr   c,FG1
            set  0,(iy+ACTN)        ;FIRE
            push hl
            push ix
            pop  hl
            call GETIND
            pop  hl
            ld   (iy+SUBJ),a
FG1:
            ld   a,d
            exx
            and  d
            ret  m
            push hl
            ld   hl,(TX+1)
            SUB_BC
            pop  hl
            scf
            ret  pe
            push hl
            ld   hl,(TZ+1)
            SUB_DE
            pop  hl
            scf
            ret  pe
            push hl
            push de
            ld   de,(TY+1)
            SUB_DE
            pop  de
            pop  hl
            scf
            ret  pe
            push ix
            call OUTLINE
            pop  ix
            and  a
            ret


FLOTSTART:
; ПРОВЕРКИ НА СТАРТ ФЛОТА И ЕГО СТРАРТ
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            ret  nz                 ;НЕ ОН
            ld   a,C_FIGHT

; СТАРТ ФЛОТА АСТЕРОИДА С РЕЖИМОМ
; В РЕГ. a
FLOTSTART2:
            bit  2,(ix+SETUP)
; ЕСЛИ ВЫПУСК ФЛОТА УЖЕ БЫЛ
            ret  nz
            ld   (A_MODE+3),a
            call RNDL5
            ld   a,l
            cp   10
; ПО ВЕРОЯТНОСТИ ВЫПУСКАТЬ НЕ НАДО
            ret  nc
            set  2,(ix+SETUP)
; ВЫПУСК ФЛОТА
            ld   a,r
            and  1
            inc  a
            ld   b,a
FLT1:
            exx
            call FINDFREE
; НЕТ СВОБОДНОГО МЕСТА В БУФЕРЕ
            ret  z
            push ix
            pop  hl
            call GETIND
            ld   (iy+BSUBJ),a
; ТИП ОБЪЕКТА НА КОТОРЫЙ НУЖНО ВЕРНУТЬСЯ
; ОТШЕЛЬНИК
            ld   (iy+TSUBJ),T_HERMIT
            ld   a,r
            and  1
            inc  a
            ld   b,a
            ld   a,r
            and  #7F
            ld   c,a
            ld   l,(ix+0)
            ld   h,(ix+1)
            add  hl,bc
            ld   (iy+0),l
            ld   (iy+1),h
            ld   l,(ix+2)
            ld   h,(ix+3)
            add  hl,bc
            ld   (iy+2),l
            ld   (iy+3),h
            ld   l,(ix+4)
            ld   h,(ix+5)
            add  hl,bc
            ld   (iy+4),l
            ld   (iy+5),h

            ld   c,IMIK1
            ld   a,r
            rla
            jr   c,$+4
            ld   c,IMIK2
            ld   (iy+INDI),c
            ld   (iy+MSPD),90
            ld   (iy+ALFA),0
            ld   a,r
            and  15
            ld   (iy+BETA),a
            ld   a,r
            and  7
            ld   (iy+GAMA),a
            ld   (iy+LZS),40
A_MODE:     ld   (iy+MODE),C_FIGHT
; РЕЖИМ ВОЗВРАТА НА АСТЕРОИД
            ld   (iy+OMODE),C_BACKTOASTER
            ld   (iy+ACTN),0
            ld   (iy+TYPE),T_MIKR
            ld   (iy+RCO),0
            ld   a,(ix+SUBJ)
            ld   (iy+SUBJ),a
            ld   (iy+OSUBJ),#FF
            ld   (iy+ENERGY),50
            ld   (iy+RSPD),1
            ld   (iy+SPT),2
            exx
            dec  b
            jp   nz,FLT1
            ret


CHECKALL:
; ПРОВЕРКИ НА ВЕРОЯТНОСТЬ ПОДБИРАНИЯ ГРУЗА
; ФОРСАЖА, ОБЛЕТА
; ЕСЛИ FC-ON ТО СВОБОДНЫЙ ПОЛЕТ, ЗНАЧИТ
; ЧТО ТО ВЫБРАЛОСЬ ИНАЧЕ НАДО ВОЕВАТЬ
; ДАЛЕЕ
            ld   a,r
            cp   VTKCG
            jr   c,CHECKA2
            call YESCARGO
            jr   z,CHECKA2
            call NEARCARGO
            ld   (ix+MODE),C_GETCARGO
            ld   (ix+SUBJ),a
            scf
            ret
CHECKA2:
            call RNDK3
            ld   a,h
            cp   #FA
            jr   c,.FS3
            ld   a,l
; ВЕРОЯТНОСТЬ ФОРСАЖА
            cp   VFRS
            jr   c,.FS3
            ld   a,(ix+MODE)
            ld   (ix+OMODE),a
; ФОРСАЖ
            ld   (ix+MODE),C_FORSAGE
.FS3
            ld   a,(ix+PX+1)
            ACPL_A
; МИНИМАЛЬНОЕ РАССТОЯНИЕ ПО X,Y В ПУТИ
; ПРОЛЕТА ДЛЯ ОБЛЕТА
            cp   DLRAZI
            ret  nc
            ld   a,(ix+PY+1)
            ACPL_A
            cp   DLRAZI
            ret  nc
            ld   a,(ix+PZ+1)
            ACPL_A
; ДАЛЬНОСТЬ ОТ ИГРОКА ДЛЯ ОБЛЕТА
            cp   DLRAZ
            ret  nc
            ld   a,(ix+MODE)
            ld   (ix+OMODE),a
; ОБЛЕТ
            ld   (ix+MODE),C_FLYAROUND
; ВРЕМЯ ОБЛЕТА
            ld   (ix+POWOR),TIMEOBL
            ret


; ПОСИК АСТЕРОИДА
FINDASTER:
            ld   d,T_HERMIT
            call FINDOBJ
            jp   z,GOSIMPLY
            call GETINDY
            ld   (ix+BSUBJ),a
            jp   GOSIMPLY


FINDOBJ:
; ПОИСК ПЕРВОГО ПО ТИПУ В "D"
;FZ-ON ЕСЛИ НЕ НАЙДЕН
;retiyАДРЕС ВЕКТОРА ОБЪЕКТА
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
.FIND2
            call FINDOB
            ret  z
            ld   a,(iy+TYPE)
            cp   d
            jp   nz,.FIND2
            inc  a
            ret


FINDFREE:
; НАЙТИ СВОБОДНЫЙ ВЕКТОР
;retFZ-ON ЕСЛИ НЕ НАДЕН
;retiyАДРЕС СВОБОДНОГО ВЕКТОРА
            ld   iy,CARSB-OLEN
            ld   de,OLEN
.HHH3
            add  iy,de
            ld   a,(iy+1)
            cp   #80
            jr   nz,.HHH3
            ld   a,(iy)
            cp   #80
            ret  z
            ld   a,(iy+SETUP)
            ld   (iy+SETUP),0
            inc  a
            jr   z,.HHH3
            ret


NEARCARGO:
; НАЙТИ САМЫЙ БЛИЖАЙШИЙ ГРУЗ
            ld   a,#FF
            ld   (NEARC+1),a
            ld   hl,CARGS-1
NXTCA2:
            inc  hl
            ld   a,(hl)
            cp   #FE
            jr   z,NRC1
            inc  a
            jp   z,$-7
            dec  a
            exx
            call GETADR
            inc  l
            ld   a,(hl)
            cp   #80
            jr   z,NOCA1
            dec  l
            push hl
            pop  iy
            call RASTOY
NEARC:      cp   #FF
            jr   nc,$+11
            ld   (NEARC+1),a
            exx
            ld   a,(hl)
            exx
            ld   (NRC1+1),a
            exx
            jp   NXTCA2
NOCA1:
            exx
            ld   (hl),#FF
            jp   NXTCA2
NRC1:
            ld   a,0
            ret


CHECKOBJ:
; С ФЛАГОМ z-ON ПОКАЗАТЬ ТЕХ, КТО МОЖЕТ
; БРАТЬ ГРУЗЫ
            ld   a,(ix+TYPE)
            cp   T_PIRAT
            ret  z
            cp   T_LEGIONER
            ret  z
            cp   T_PIRAT2
            ret  z
            cp   T_HERMIT
            ret  z
            cp   T_TRADER
            ret  z
            cp   T_MIKR
            ret


YESCARGO:
; ПРОВЕРКА ЕСТЬ ЛИ ГРУЗЫ
; ТАК ЖЕ ОТСЕИТЬ ТЕХ КТО НЕБЕРЕТ ГРУЗЫ
;retFZ-ON НЕТ
;FZ-OFF ЕСТЬ
            call CHECKOBJ
            jr   z,$+4
            xor  a
            ret
            ld   hl,CARGS-1
            inc  hl
            ld   a,(hl)
            cp   #FE
            ret  z
            inc  a
            jp   z,$-6
            ret


MAKEEXPLO:
; ЗАДАТЬ ДАННЫЕ О ВЗРЫВЕ И ОСКОЛКАХ
; ОБЪЕКТА

; УСТАНОВКА СКОРОСТИ ПОЛЕТА ОСКОЛКОВ
; СПЕЦИАЛЬНО ДЛЯ АСТЕРОИДА ОТДЕЛЬНО
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            ld   a,#A0
            jr   nz,$+4
            ld   a,#40
            ld   (OSKOLSPEED+1),a

            ld   a,(ix+INDI)
            call SIZEOBJ
            ld   a,h
            ex   af,af'
            ld   l,(ix+0)
            ld   h,(ix+1)
            ld   e,(ix+2)
            ld   d,(ix+3)
            ld   c,(ix+4)
            ld   b,(ix+5)
            ld   a,EXTIME
            exx
            ld   hl,NWVOS
            push ix
            call NEWVSPR
            pop  ix
            ld   a,1
            ld   (EXPL+1),a
            ld   a,(CEX+1)
            cp   #10
            jr   nc,$+7
            ld   a,#10
            ld   (CEX+1),a
            ld   a,(ix+TYPE)
            cp   T_CHIP
            jp   nc,JJ11
            ld   hl,CARSB-OLEN+1
            ld   a,r
            and  3
            add  a,2
JJ12:
            ex   af,af'
            ld   de,OLEN
            add  hl,de
            ld   a,(hl)
            cp   #80
            jp   nz,$-4
            dec  hl
            ld   a,(hl)
            cp   #80
            jp   z,JJ11
            ld   d,ixh
            ld   e,ixl
            EXD
            ldi
            ldi
            ldi
            ldi
            ldi
            ldi
            ld   a,IOSKOL
            ld   (de),a
            inc  e
            inc  e
            inc  e
            inc  e
            ld   a,4
            ld   (de),a
            inc  e
            inc  e
            xor  a
            ld   (de),a
            inc  e
            ld   a,r
            ld   c,a
            ld   b,0
            ld   a,(bc)
            ld   (de),a
            inc  e
            inc  bc
            ld   a,(bc)
            ld   (de),a
            inc  e
            inc  e
            ld   a,r
            and  #1F
OSKOLSPEED: or   #A0
            ld   (de),a             ;SPEED
            inc  e
            inc  e
            ld   a,T_CHIP
            ld   (de),a
            inc  e
            ld   (de),a             ;ENERGY
            inc  e
            ld   a,#FF
            ld   (de),a
            inc  e
            ld   (de),a
            xor  a
            inc  e
            ld   (de),a
            ld   bc,0-OMODE+1
            EXD
            add  hl,bc
            ex   af,af'
            dec  a
            jp   nz,JJ12
JJ11:
; ЗВУК ВЗРЫВА
            ld   hl,EFF0
            ld   (SFXB+1),hl
            jp   DEATHX


RASTOY:
; ВЗЯТЬ РАССТОЯНИЕ КРАТНОЕ #100 ОТ ОДНОГО
; ОБЪЕКТА В ixДО ДРУГОГО  iy
;reta
            ld   e,(ix+0)
            ld   d,(ix+1)
            ld   l,(iy+0)
            ld   h,(iy+1)
            SUB_DE
            jp   p,$+10
            NEGHL
            push hl
            ld   e,(ix+2)
            ld   d,(ix+3)
            ld   l,(iy+2)
            ld   h,(iy+3)
            SUB_DE
            jp   p,$+10
            NEGHL
            push hl
            ld   e,(ix+4)
            ld   d,(ix+5)
            ld   l,(iy+4)
            ld   h,(iy+5)
            SUB_DE
            jp   p,$+10
            NEGHL
            pop  de
            ld   a,h
            cp   d
            jr   nc,$+3
            ld   a,d
            pop  de
            cp   d
            ret  nc
            ld   a,d
            ret


;------------------------
; ВЫВОД ЛИНИИ В 3D ПРОСТРАНСТВЕ
;------------------------
OUTLINE:
;de-Z1,hl-Y1,bc-X1
;DE'-Z2,HL'-Y2,BC'-X2
            call CALC2D3D
            ret  nz
            ld   (L9C*256),hl
            ld   (L9C*256+2),de
            exx
            call CALC2D3D
            ret  nz
            ld   (L9C*256+5),hl
            ld   (L9C*256+7),de
            exx
            call VSLINE
            ret  z
            ld   b,a
            cpl
            and  #F0
            ret  nz
            ld   a,b
            and  #0F
            ld   hl,MASKLINE
            jp   nz,DRWPOL
            jp   DRWPOL2
MASKLINE:
            db   %10110010,0,5,0


RND:
            exx
            ld   hl,SDO
            jp   RNDO
RNDW:
            exx
            ld   hl,SDW
            jp   RNDO
RNDK1:
            exx
            ld   hl,SDK1
            jp   RNDO
RNDK2:
            exx
            ld   hl,SDK2
            jp   RNDO
RNDK3:
            exx
            ld   hl,SDK3
            jp   RNDO
RNDT2:
            exx
            ld   hl,SDT2
            jp   RNDO
RNDT1:
            exx
            ld   hl,SDT1
            jp   RNDO
RNDL1:
            exx
            ld   hl,SDL1
            jp   RNDO
RNDL2:
            exx
            ld   hl,SDL2
            jp   RNDO
RNDL3:
            exx
            ld   hl,SDL3
            jp   RNDO

RNDL4:
            exx
            ld   hl,SDL4
            jp   RNDO
RNDL5:
            exx
            ld   hl,SDL5
            jp   RNDO
RNDL7:
            exx
            ld   hl,SDL7
            jp   RNDO
RNDL8:
            exx
            ld   hl,SDL8
            jp   RNDO
RNDL9:
            exx
            ld   hl,SDL9
            jp   RNDO


SDW:
            db   7,8,0
SDO:
            db   101,0,0
SDL1:
            db   9,0,0
SDL2:
            db   231,0,0
SDL3:
            db   71,1,0
SDL4:
            db   10,0,0
SDL5:
            db   77,1,0
SDL7:
            db   200,0,0
SDL8:
            db   13,0,0
SDL9:
            db   13,3,1
SDT2:
            db   44,0,0
SDT1:
            db   21,0,0
SDK1:
            db   247,0,0
SDK2:
            db   93,0,0
SDK3:
            db   29,0,0
RNDO:
;inhlADR OF SEED
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
            EXD
            ld   h,b
            ld   l,c
            ADDHLHL 3
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
            SUB_BC
            sbc  a,0
            EXD
            SUB_DE
            sbc  a,0
            dec  hl
            EXD
            pop  hl
            ld   (hl),a
            dec  hl
            ld   (hl),d
            dec  hl
            ld   (hl),e
            push de
            exx
            pop  hl
            ret


VSLINE:
; ПРОВЕРКА ВИДИМОСТИ ЛИНИИ
            ld   hl,(low(L9C)*256)+1
            xor  a
            ex   af,af'
            ld   b,10
LD84:       ld   c,#00
            ld   a,(hl)
            inc  l
            inc  l
            cp   #80
            jr   z,LD85
            jr   nc,$+9
            and  a
            jp   nz,$+11
            jp   $+10
            set  1,c
            jp   $+5
            set  0,c
            ld   a,(hl)
            and  a
            jp   m,$+16
            jp   nz,$+18
            dec  l
            ld   a,(hl)
            inc  l
            cp   YEND+1
            jr   nc,$+10
            jp   $+10
            set  3,c
            jp   $+5
            set  2,c
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            ex   af,af'
            or   (hl)
            ex   af,af'
LD83:       inc  l
            ld   a,l
            inc  l
            cp   b
            jp   nz,LD84
            ex   af,af'
            ret
LD85:       inc  l
            ld   (hl),c
            jp   LD83


; ПЛЕЙЕР СЕМПЛОВ
SFXA:
            ld   hl,0
            ld   a,h
            or   a
            jr   z,SFXB
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
            ld   (SFXA+1),hl
            ld   a,(hl)
            or   a
            jr   nz,SFXB
            ld   (SFXA+2),a
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            or   %00001001
            ld   b,#BF
            out  (c),a
SFXB:
            ld   hl,0
            ld   a,h
            or   a
            jr   z,.SFXN
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
            ld   (SFXB+1),hl
            ld   a,(hl)
            or   a
            jr   nz,.SFXN
            ld   (SFXB+2),a
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            or   %00010010
            ld   b,#BF
            out  (c),a
.SFXN
            ld   c,#FD
            if   OFF
            ld   b,#FF
            ld   a,4
            out  (c),a
            ld   b,#BF
            ld   a,(NUNU+1)
            rlca
            rlca
            and  %00111100
            or   3
            out  (c),a
            endif
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
NUNU:       ld   a,0
            srl  a
            cp   4
            jr   nc,$+4
            ld   a,4
            out  (c),a
            ret
            include "gen/EFFECTS.inc"   ; GENERATED from assets/sound/effects.txt
