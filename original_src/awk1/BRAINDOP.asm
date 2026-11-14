■PRECORD    ■GETADRY        ■GETADR
■GETINDX    ■GETINDY        ■GETIND
■FINDOB     ■FINDPEACE      ■FINDALL
■FINDUFO    ■FINDPIRAT      ■TESTSUBJ
■OPONE      ■FIREING        ■FLOTSTART
■FLOTSTART2 ■SFXA           ■CHECKALL
■FINDOBJ    ■FINDASTER      ■FINDFREE
■NEARCARGO  ■CHECKOBJ       ■YESCARGO
■MAKEEXPLO  ■RASTOY         ■OUTLINE
■RND        ■RNDW           ■RNDK1
■RNDK2      ■RNDK3          ■RNDT2
■RNDT1      ■RNDL1          ■RNDL2
■RNDL3      ■RNDL4          ■RNDL5
■RNDL7      ■RNDL8          ■RNDL9
■VSLINE







PRECORD
ИЗМЕНЯЕМ КООРДИНАТЫ В ЗАВИСИМОСТИ ОТ
ДВИЖЕНИЯ
            ld   (STK1+1),sp

            ld   a,(ix+TYPE)
            cp   T_TRASH
            jrnz PD1
            ld   hl,(STPX+1)
            ld   (RSTPX+1),hl
            rept 1:sra h:rr l:endr
            ld   (STPX+1),hl
            ld   hl,(STPY+1)
            ld   (RSTPY+1),hl
            rept 1:sra h:rr l:endr
            ld   (STPY+1),hl
            ld   hl,(STPZ+1)
            ld   (RSTPZ+1),hl
            rept 1:sra h:rr l:endr
            ld   (STPZ+1),hl
PD1
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
            ld   a,xl
            ld   l,a
            ld   a,xh
            ld   h,a
            ld   sp,hl
STPX_       ld   hl,0
STPX        ld   de,0
            SUB_DE
            pop  de
            ld   a,d
            cp   #80
            jrz  STK1
            and  a
            adc  hl,de
            jppe EXES
            ld   a,h
            jpp  $+4
            cpl
            cp   b
            jpnc EXES
            push hl
STPY_       ld   hl,0
STPY        ld   de,0
            SUB_DE
            inc  sp
            inc  sp
            pop  de
            and  a
            adc  hl,de
            jppe EXES
            ld   a,h
            jpp  $+4
            cpl
            cp   b
            jrnc EXES
            push hl
STPZ_       ld   hl,0
STPZ        ld   de,0
            SUB_DE
            inc  sp
            inc  sp
            pop  de
            and  a
            adc  hl,de
            jppe EXES
            ld   a,h
            jpp  $+4
            cpl
            cp   b
            jrnc EXES
            push hl
STK1        ld   sp,0
            ld   a,(NOSTAT)
            and  a
            jpz  REXE
            ld   d,#12
            call FINDOBJ
            jpz  REXE
НАХОДИМ САМУЮ БОЛЬШУЮ КООРДИНАТУ СТАНЦИИ
            ld   a,(iy+5)
            ACPL_A
            ld   b,a
            ld   a,(iy+3)
            ACPL_A
            ld   c,a
            ld   a,(iy+1)
            ACPL_A
            cp   c
            jrnc $+3
            ld   a,c
            cp   b
            jrnc $+3
            ld   a,b
            cp   LAUNGH
ЕСЛИ ЕЩЕ ДАЛЕКО
            jrc  MESST
            ld   a,#80
            ld   (MESST+1),a
            jr   REXE
MESST       ld   a,0
            and  a
            jpp  REXE
РЕЖИМ СТЫКОВКИ СО СТАНЦИЕЙ
            ld   a,24
            ld   (MESST+1),a
            MESAG   _DOCKING
            jr   REXE
EXES
ЕСЛИ КОРАБЛЬ ЗА ГРАНИЦЕЙ
            ld   sp,(STK1+1)
            call DEATHX
            ld   a,(ix+TYPE)
            cp   T_STATION
            jrnz REXE
ЕСЛИ СТАНЦИЯ ЗА ГРАНИЦЕЙ
            xor  a
            ld   (STATGEN),a
            ld   (NOSTAT),a
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
EXE2
            call FINDOB
            retz
            ld   a,(iy+TYPE)
            cp   T_STATION
            jrnz EXE2
            call DEATHY
            jp   EXE2

REXE
            ld   a,(ix+TYPE)
            cp   T_TRASH
            retnz
RSTPX       ld   hl,0
            ld   (STPX+1),hl
RSTPY       ld   hl,0
            ld   (STPY+1),hl
RSTPZ       ld   hl,0
            ld   (STPZ+1),hl
            ret


GETADRY
ПОЛУЧЕНИЕ АДРЕСА ВЕКТОРА ИЗ ИНДЕКСА ЕГО
В РЕГ. iy
            push hl
            call GETADR
            push hl
            pop  iy,hl
            ret


GETADR
ПОЛУЧЕНИЕ АДРЕСА ВЕКТОРА ИЗ ИНДЕКСА ЕГО
■a-ИНДЕКС
■rethl-АДРЕС
            ld   l,0
            srl  a
            rr   l
            srl  a
            rr   l
            add  a,CARSB.h
            ld   h,a
            ret



GETINDX
ПОЛУЧЕНИЕ ИНДЕКСА ИЗ АДРЕСА В iy
■ix-АДРЕС
■reta-ИНДЕКС
            push hl,ix
            pop  hl
            call GETIND
            pop  hl
            ret


GETINDY
ПОЛУЧЕНИЕ ИНДЕКСА ИЗ АДРЕСА В iy
■iy-АДРЕС
■reta-ИНДЕКС
            push hl,iy
            pop  hl
            call GETIND
            pop  hl
            ret


GETIND
ПОЛУЧЕНИЕ ИНДЕКСА ИЗ АДРЕСА В hl
■hl-АДРЕС
■reta-ИНДЕКС
            ld   a,h
            sub  CARSB.h
            sla  l
            rla
            sla  l
            rla
            ret


■----------------------
ПОИСКОВИКИ ЧЕГО ЛИБО
■----------------------

FINDOB
НАЙТИ КАКОЙ НИБУДЬ ОБЪЕКТ
■iy-VECTOR-OLEN
■bc-OLEN
■FZ-ON ТО НЕ НАЙДЕНО
            add  iy,bc
            ld   a,(iy+1)
            cp   #80
            retnz
            ld   a,(iy)
            cp   #80
            jpnz FINDOB
            ret


FINDPEACE
НАЙТИ МИРНОГО
            call RNDL3
            ld   a,l
PWNPI       cp   #A0
            ld   a,SPLAYER
            inc  a
            dec  a
            retnc
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
FP2L
            call FINDOB
            retz
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_PIRAT
            jrz  FP2L
            cp   T_STATION
            jrz  $+6
            cp   T_CHIP
            jrnc FP2L
            call GETINDY
            inc  e;cБPOC FZ
            ret


FINDALL
НАЙТИ ЛЮБОГО НО НЕ УФО
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
FP6L
            call FINDOB
            retz
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_UFO
            jrz  FP6L
            cp   T_UFO2
            jrz  FP6L
            call GETINDY
            inc  e;cБPOC FZ
            ret


FINDUFO
НАЙТИ УФО
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
FP3L
            call FINDOB
            retz
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_UFO
            jrz  $+6
            cp   T_UFO2
            jrnz FP3L
            call GETINDY
            inc  e
            ret


FINDPIRAT
НАЙТИ ПИРАТА
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
FP2
            call FINDOB
            retz
            ld   e,(iy+TYPE)
            ld   a,e
            cp   T_PIRAT2
            jrz  $+6
            cp   PIRAT
            jrnz FP2
            call GETINDY
            inc  e
            ret
■---------------------------------


TESTSUBJ
ТЕСТИРОВАНИЕ ПЕРСОНАЖА НА ПРЕДМЕТ ЕГО
УЖЕ ИСЧЕЗНОВЕНИЯ
            ld   a,(ix+SUBJ)
            inc  a
            jrnz TS1
            ld   hl,OLEN*SPLAYER+CARSB
            jr   TS2
TS1
            dec  a
            call GETADR
TS2
            ld   (OPONE+2),hl
            inc  l
            ld   a,(hl)
            cp   #80
            retz
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
OPONE       ld   iy,0
            ld   a,(ix+SUBJ)
            cp   SPLAYER
            jrnz FG2
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
FG2
            ld   a,(iy+PX+1)
            cp   #80
            scf
            retz
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


FIREING
ОРГАНИЗАЦИЯ ВЫСТРЕЛА ПЕРСОНАЖА В КОГО
ЛИБО, ВЫВДО ЛУЧА, ИНИЦИАЛИЗАЦИЯ ДАННЫХ
■SUBJ & ACTN
            ld   a,(ix+PX+1)
            cp   #80
            scf
            retz
            ld   b,a
            ld   c,(ix+PX)
            ld   l,(ix+PY)
            ld   h,(ix+PY+1)
            ld   e,(ix+PZ)
            ld   d,(ix+PZ+1)
            exx
            call OPONE
            retc
            ld   a,r
PWPPI       cp   #4A
            jrc  FG1
            set  0,(iy+ACTN);FIRE
            push hl,ix
            pop  hl
            call GETIND
            pop  hl
            ld   (iy+SUBJ),a
FG1
            ld   a,d
            exx
            and  d
            retm
            push hl
            ld   hl,(TX+1)
            SUB_BC
            pop  hl
            scf
            retpe
            push hl
            ld   hl,(TZ+1)
            SUB_DE
            pop  hl
            scf
            retpe
            push hl,de
            ld   de,(TY+1)
            SUB_DE
            pop  de,hl
            scf
            retpe
            push ix
            call OUTLINE
            pop  ix
            and  a
            ret


FLOTSTART
ПРОВЕРКИ НА СТАРТ ФЛОТА И ЕГО СТРАРТ
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            retnz;НЕ ОН
            ld   a,C_FIGHT

СТАРТ ФЛОТА АСТЕРОИДА С РЕЖИМОМ
В РЕГ. a
FLOTSTART2
            bit  2,(ix+SETUP)
ЕСЛИ ВЫПУСК ФЛОТА УЖЕ БЫЛ
            retnz
            ld   (A_MODE+3),a
            call RNDL5
            ld   a,l
            cp   10
ПО ВЕРОЯТНОСТИ ВЫПУСКАТЬ НЕ НАДО
            retnc
            set  2,(ix+SETUP)
ВЫПУСК ФЛОТА
            ld   a,r
            and  1
            inc  a
            ld   b,a
FLT1
            exx
            call FINDFREE
НЕТ СВОБОДНОГО МЕСТА В БУФЕРЕ
            retz
            push ix
            pop  hl
            call GETIND
            ld   (iy+BSUBJ),a
ТИП ОБЪЕКТА НА КОТОРЫЙ НУЖНО ВЕРНУТЬСЯ
ОТШЕЛЬНИК
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
            jrc  $+4
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
A_MODE      ld   (iy+MODE),C_FIGHT
РЕЖИМ ВОЗВРАТА НА АСТЕРОИД
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
            jpnz FLT1
            ret




CHECKALL
ПРОВЕРКИ НА ВЕРОЯТНОСТЬ ПОДБИРАНИЯ ГРУЗА
ФОРСАЖА, ОБЛЕТА
ЕСЛИ FC-ON ТО СВОБОДНЫЙ ПОЛЕТ, ЗНАЧИТ
ЧТО ТО ВЫБРАЛОСЬ ИНАЧЕ НАДО ВОЕВАТЬ
ДАЛЕЕ
            ld   a,r
            cp   VTKCG
            jrc  CHECKA2
            call YESCARGO
            jrz  CHECKA2
            call NEARCARGO
            ld   (ix+MODE),C_GETCARGO
            ld   (ix+SUBJ),a
            scf
            ret
CHECKA2
            call RNDK3
            ld   a,h
            cp   #FA
            jrc  FS3
            ld   a,l
ВЕРОЯТНОСТЬ ФОРСАЖА
            cp   VFRS
            jrc  FS3
            ld   a,(ix+MODE)
            ld   (ix+OMODE),a
ФОРСАЖ
            ld   (ix+MODE),C_FORSAGE
FS3
            ld   a,(ix+PX+1)
            ACPL_A
МИНИМАЛЬНОЕ РАССТОЯНИЕ ПО X,Y В ПУТИ
ПРОЛЕТА ДЛЯ ОБЛЕТА
            cp   DLRAZI
            retnc
            ld   a,(ix+PY+1)
            ACPL_A
            cp   DLRAZI
            retnc
            ld   a,(ix+PZ+1)
            ACPL_A
ДАЛЬНОСТЬ ОТ ИГРОКА ДЛЯ ОБЛЕТА
            cp   DLRAZ
            retnc
            ld   a,(ix+MODE)
            ld   (ix+OMODE),a
ОБЛЕТ
            ld   (ix+MODE),C_FLYAROUND
ВРЕМЯ ОБЛЕТА
            ld   (ix+POWOR),TIMEOBL
            ret




ПОСИК АСТЕРОИДА
FINDASTER
            ld   d,T_HERMIT
            call FINDOBJ
            jpz  GOSIMPLY
            call GETINDY
            ld   (ix+BSUBJ),a
            jp   GOSIMPLY



FINDOBJ
ПОИСК ПЕРВОГО ПО ТИПУ В "D"
■FZ-ON ЕСЛИ НЕ НАЙДЕН
■retiyАДРЕС ВЕКТОРА ОБЪЕКТА
            ld   iy,CARSB-OLEN
            ld   bc,OLEN
FIND2
            call FINDOB
            retz
            ld   a,(iy+TYPE)
            cp   d
            jpnz FIND2
            inc  a
            ret



FINDFREE
НАЙТИ СВОБОДНЫЙ ВЕКТОР
■retFZ-ON ЕСЛИ НЕ НАДЕН
■retiyАДРЕС СВОБОДНОГО ВЕКТОРА
            ld   iy,CARSB-OLEN
            ld   de,OLEN
HHH3
            add  iy,de
            ld   a,(iy+1)
            cp   #80
            jrnz HHH3
            ld   a,(iy)
            cp   #80
            retz
            ld   a,(iy+SETUP)
            ld   (iy+SETUP),0
            inc  a
            jrz  HHH3
            ret


NEARCARGO
НАЙТИ САМЫЙ БЛИЖАЙШИЙ ГРУЗ
            ld   a,#FF
            ld   (NEARC+1),a
            ld   hl,CARGS-1
NXTCA2
            inc  hl
            ld   a,(hl)
            cp   #FE
            jrz  NRC1
            inc  a
            jpz  $-7
            dec  a
            exx
            call GETADR
            inc  l
            ld   a,(hl)
            cp   #80
            jrz  NOCA1
            dec  l
            push hl
            pop  iy
            call RASTOY
NEARC       cp   #FF
            jrnc $+11
            ld   (NEARC+1),a
            exx
            ld   a,(hl)
            exx
            ld   (NRC1+1),a
            exx
            jp   NXTCA2
NOCA1
            exx
            ld   (hl),#FF
            jp   NXTCA2
NRC1
            ld   a,0
            ret


CHECKOBJ
С ФЛАГОМ z-ON ПОКАЗАТЬ ТЕХ, КТО МОЖЕТ
БРАТЬ ГРУЗЫ
            ld   a,(ix+TYPE)
            cp   T_PIRAT
            retz
            cp   T_LEGIONER
            retz
            cp   T_PIRAT2
            retz
            cp   T_HERMIT
            retz
            cp   T_TRADER
            retz
            cp   T_MIKR
            ret


YESCARGO
ПРОВЕРКА ЕСТЬ ЛИ ГРУЗЫ
ТАК ЖЕ ОТСЕИТЬ ТЕХ КТО НЕБЕРЕТ ГРУЗЫ
■retFZ-ON НЕТ
■FZ-OFF ЕСТЬ
            call CHECKOBJ
            jrz  $+4
            xor  a
            ret
            ld   hl,CARGS-1
            inc  hl
            ld   a,(hl)
            cp   #FE
            retz
            inc  a
            jpz  $-6
            ret


MAKEEXPLO
ЗАДАТЬ ДАННЫЕ О ВЗРЫВЕ И ОСКОЛКАХ
ОБЪЕКТА

УСТАНОВКА СКОРОСТИ ПОЛЕТА ОСКОЛКОВ
СПЕЦИАЛЬНО ДЛЯ АСТЕРОИДА ОТДЕЛЬНО
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            ld   a,#A0
            jrnz $+4:ld a,#40
            ld   (OSKOLSPEED+1),a

            ld   a,(ix+INDI)
            call SIZEOBJ
            ld   a,h
            exa
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
            jrnc $+7
            ld   a,#10
            ld   (CEX+1),a
            ld   a,(ix+TYPE)
            cp   T_CHIP
            jpnc JJ11
            ld   hl,CARSB-OLEN+1
            ld   a,r:and 3:add a,2
JJ12
            exa
            ld   de,OLEN
            add  hl,de
            ld   a,(hl)
            cp   #80
            jpnz $-4
            dec  hl
            ld   a,(hl)
            cp   #80
            jpz  JJ11
            ld   d,xh
            ld   e,xl
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
            ld   a,r:and #1F
OSKOLSPEED  or   #A0
            ld   (de),a;SPEED
            inc  e
            inc  e
            ld   a,T_CHIP
            ld   (de),a
            inc  e
            ld   (de),a;ENERGY
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
            exa
            dec  a
            jpnz JJ12
JJ11
ЗВУК ВЗРЫВА
            ld   hl,EFF0
            ld   (SFXB+1),hl
            jp   DEATHX


RASTOY
ВЗЯТЬ РАССТОЯНИЕ КРАТНОЕ #100 ОТ ОДНОГО
ОБЪЕКТА В ixДО ДРУГОГО  iy
■reta
            ld   e,(ix+0)
            ld   d,(ix+1)
            ld   l,(iy+0)
            ld   h,(iy+1)
            SUB_DE
            jpp  $+10
            NEGHL
            push hl
            ld   e,(ix+2)
            ld   d,(ix+3)
            ld   l,(iy+2)
            ld   h,(iy+3)
            SUB_DE
            jpp  $+10
            NEGHL
            push hl
            ld   e,(ix+4)
            ld   d,(ix+5)
            ld   l,(iy+4)
            ld   h,(iy+5)
            SUB_DE
            jpp  $+10
            NEGHL
            pop  de
            ld   a,h
            cp   d
            jrnc $+3
            ld   a,d
            pop  de
            cp   d
            retnc
            ld   a,d
            ret



■------------------------
ВЫВОД ЛИНИИ В 3D ПРОСТРАНСТВЕ
■------------------------
OUTLINE
■de-Z1,hl-Y1,bc-X1
■DE'-Z2,HL'-Y2,BC'-X2
            call CALC2D3D
            retnz
            ld   (L9C*256),hl
            ld   (L9C*256+2),de
            exx
            call CALC2D3D
            retnz
            ld   (L9C*256+5),hl
            ld   (L9C*256+7),de
            exx
            call VSLINE
            retz
            ld   b,a
            cpl
            and  #F0
            retnz
            ld   a,b
            and  #0F
            ld   hl,MASKLINE
            jpnz DRWPOL
            jp   DRWPOL2
MASKLINE
            db   %10110010,0,5,0



RND
            exx
            ld   hl,SDO
            jp   RNDO
RNDW
            exx
            ld   hl,SDW
            jp   RNDO
RNDK1
            exx
            ld   hl,SDK1
            jp   RNDO
RNDK2
            exx
            ld   hl,SDK2
            jp   RNDO
RNDK3
            exx
            ld   hl,SDK3
            jp   RNDO
RNDT2
            exx
            ld   hl,SDT2
            jp   RNDO
RNDT1
            exx
            ld   hl,SDT1
            jp   RNDO
RNDL1
            exx
            ld   hl,SDL1
            jp   RNDO
RNDL2
            exx
            ld   hl,SDL2
            jp   RNDO
RNDL3
            exx
            ld   hl,SDL3
            jp   RNDO

RNDL4
            exx
            ld   hl,SDL4
            jp   RNDO
RNDL5
            exx
            ld   hl,SDL5
            jp   RNDO
RNDL7
            exx
            ld   hl,SDL7
            jp   RNDO
RNDL8
            exx
            ld   hl,SDL8
            jp   RNDO
RNDL9
            exx
            ld   hl,SDL9
            jp   RNDO


SDW
            db   7,8,0
SDO
            db   101,0,0
SDL1
            db   9,0,0
SDL2
            db   231,0,0
SDL3
            db   71,1,0
SDL4
            db   10,0,0
SDL5
            db   77,1,0
SDL7
            db   200,0,0
SDL8
            db   13,0,0
SDL9
            db   13,3,1
SDT2
            db   44,0,0
SDT1
            db   21,0,0
SDK1
            db   247,0,0
SDK2
            db   93,0,0
SDK3
            db   29,0,0
RNDO
■inhlADR OF SEED
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
            ld   h,a;0
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



VSLINE
ПРОВЕРКА ВИДИМОСТИ ЛИНИИ
            ld   hl,L9C.e+1
            xor  a
            exa
            ld   b,10
LD84        ld   c,#00
            ld   a,(hl)
            inc  l
            inc  l
            cp   #80
            jrz  LD85
            jrnc $+9
            and  a
            jpnz $+11
            jp   $+10
            set  1,c
            jp   $+5
            set  0,c
            ld   a,(hl)
            and  a
            jpm  $+16
            jpnz $+18
            dec  l
            ld   a,(hl)
            inc  l
            cp   YEND+1
            jrnc $+10
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
            exa
            or   (hl)
            exa
LD83        inc  l
            ld   a,l
            inc  l
            cp   b
            jpnz LD84
            exa
            ret
LD85        inc  l
            ld   (hl),c
            jp   LD83




ПЛЕЙЕР СЕМПЛОВ
SFXA
            ld   hl,0
            ld   a,h
            or   a
            jrz  SFXB
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
            jrnz SFXB
            ld   (SFXA+2),a
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            or   %00001001
            ld   b,#BF
            out  (c),a
SFXB
            ld   hl,0
            ld   a,h
            or   a
            jrz  SFXN
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
            jrnz SFXN
            ld   (SFXB+2),a
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            or   %00010010
            ld   b,#BF
            out  (c),a
SFXN
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
            jrc  $+4
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
NUNU        ld   a,0
            srl  a
            cp   4
            jrnc $+4
            ld   a,4
            out  (c),a
            ret
ROKA
            db   20,2,%00001000,11
            db   01,1,%00001000,10
            db   20,2,%00001000,09
            db   01,1,%00001000,10
            db   20,2,%00001000,11
            db   01,1,%00001000,10,0
EFF13
            db   20,0,%00000000,10
            db   10,0,%00000000,09
            db   20,0,%00000000,08
            db   10,0,%00000000,07
            db   20,0,%00000000,06
            db   10,0,%00000000,05,0
EFF19
            db   80,1,%00001000,08
            db   70,1,%00001000,08
            db   60,1,%00001000,08
            db   80,1,%00001000,08
            db   70,1,%00001000,09
            db   60,1,%00001000,09
            db   80,1,%00001000,09
            db   70,1,%00001000,10
            db   60,1,%00001000,10
            db   80,1,%00001000,10
            db   70,1,%00001000,11
            db   60,1,%00001000,11
            db   80,1,%00001000,11
            db   70,1,%00001000,12
            db   60,1,%00001000,13
            db   70,1,%00001000,13,0
EFF1
            db   40,0,%00000000,10
            db   50,0,%00000000,09
            db   40,0,%00000000,08
            db   50,0,%00000000,07
            db   40,0,%00000000,06
            db   50,0,%00000000,05,0
EFF14
            db   20,1,%00000000,10
            db   10,1,%00000000,09
            db   20,1,%00000000,08
            db   10,1,%00000000,07
            db   20,1,%00000000,06
            db   10,1,%00000000,05,0
EFF2
■SHOOT1
            db   #10,1,%00001000,12
            db   #40,1,%00001000,11
            db   #70,1,%00001000,10
            db   #20,2,%00001000,9
            db   #E0,2,%00001000,8
            db   #20,3,%00001000,7,0

EFF0
■EXPLOSION
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
            db   1,0,%00000001,09
            db   1,0,%00000001,08
            db   1,0,%00000001,08
            db   1,0,%00000001,08
            db   1,0,%00000001,08
            db   1,0,%00000001,07
            db   1,0,%00000001,06
            db   1,0,%00000001,05
            db   1,0,%00000001,04
            db   1,0,%00000001,03,0

EFF11
            db   100,2,4,9
            db   100,3,4,7
            db   100,2,4,5
            db   100,3,4,4
            db   100,2,4,2
            db   100,3,4,1,0

EFF21
            db   200,1,32,12
            db   2,0,0,11
            db   50,0,0,12
            db   50,0,4,7
            db   50,0,4,1,0

