■ITAB             ■NTH
■OBLET            ■WOZWRAT
■FORSAGE          ■NOCARGO
■GETCARGO         ■BACKAS
■SROKA            ■GOAWAY
■GOSUN            ■GOEAR
■GOSIMPLY         ■FIGHT
■NAVODFIRE        ■FIROK
■JTYPE            ■DEFENCE
■BACKUP           ■BACKALL
■TOTHEALL         ■TURNOUT
■OTLET            ■STARTPOLICE
■STATDEF          ■STYSTAT
■STAYSTATION      ■NAVODROKET
■JUMPING          ■FREEFLY
■GOASTER          ■JUMPOUT
■SHIPINTELEGENT





ITAB
            dw   STAY
            dw   GOEAR
            dw   FIGHT
            dw   GOSUN
            dw   FREEFLY
            dw   DEFENCE
            dw   JUMPOUT
            dw   JUMPING
            dw   NAVODROKET
            dw   STYSTAT
            dw   STATDEF
            dw   STARTPOLICE
            dw   BACKUP
            dw   BACKAS
            dw   GETCARGO
            dw   GOAWAY
            dw   OTLET
            dw   TURNOUT
            dw   GOASTER
            dw   FORSAGE
            dw   OBLET
            dw   WOZWRAT
NTH
            ret




OBLET
ОБЛЕТ ИГРОКА, ПОВОРОТ НА 20 ГРАДУСОВ ПО
УГЛУ BETA
            ld   a,(ix+ALFA)
            add  a,2
            ld   (ix+ALFA),a
            ld   a,(ix+POWOR)
            dec  a
            ld   (ix+POWOR),a
            jpnz GOSIMPLY
ВОЗВРАТ
            ld   (ix+MODE),C_RETURN
            ld   (ix+POWOR),TIMEOBL
            jp   GOSIMPLY


WOZWRAT
ВОЗВРАТ ПОСЛЕ ОБЛЕТА, ПОВОРОТ НАЗАД 20гд
            ld   a,(ix+ALFA)
            sub  2
            ld   (ix+ALFA),a
            ld   a,(ix+POWOR)
            dec  a
            ld   (ix+POWOR),a
            jpnz GOSIMPLY
            ld   a,(ix+OMODE)
            ld   (ix+MODE),a
            jp   GOSIMPLY


FORSAGE
ФОРСАЖ ОБЪЕКТА
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jrnc FS4
            ld   a,#11:rrca:ld ($-2),a
            jrnc FS1
            ld   a,(ix+FORSAG)
            cp   #0F
            jrnc FS1
            inc  a
            ld   (ix+FORSAG),a
FS1
            ld   a,(ix+1)
            ACPL_A
            ld   c,a
            ld   a,(ix+3)
            ACPL_A
            ld   b,a
            ld   a,(ix+5)
            ACPL_A
            cp   b
            jrnc $+3
            ld   a,b
            cp   c
            jrnc $+3
            ld   a,c
            cp   JMIN_
            jpnc GOSIMPLY
FS4
            ld   a,(ix+OMODE)
            ld   (ix+MODE),a
            ld   (ix+FORSAG),0
            jp   GOSIMPLY


NOCARGO
            call NEWORD
            jp   GOSIMPLY


GETCARGO
ПОДОБРАТЬ ГРУЗ
            ld   a,(ix+SUBJ)
            call GETADR
АДРЕС ГРУЗА hl
            inc  l
            ld   a,(hl)
            cp   #80
ЕСЛИ ГРУЗА УЖЕ НЕТ
            jrz  NOCARGO
ПРОВЕРИТЬ ГРУЗ ЛИ ЭТО ?
            ld   a,l
            add  a,TYPE-1
            ld   l,a
            ld   c,(hl)
            sub  TYPE
            ld   l,a
            ld   a,c
            cp   T_CARGO
ЕСЛИ ЭТО НЕ ГРУЗ
            jrnz NOCARGO
ГРУЗ!
            push hl
            pop  iy
МЕРИМ РАССТОЯНИЕ
            call RASTOY
            cp   1
ЕСЛИ ЕЩЕ ДАЛЕКО
            jpnc TOTHEALL
ВЗЯЛИ
            bit  4,(iy+SETUP)
            call DEATHY
            jpz  NOCARGO
ВЗРЫВ, ПОДОБРАНА МИНА
            call MAKEEXPLO
            jp   GOSIMPLY
DEATHY
            ld   (iy+1),#80
            ld   (iy+0),0
            ld   (iy+SETUP),#FF
            ret


BACKAS
ВОЗВРАТ НА АСТЕРОИД
            ld   a,(ix+BSUBJ)
            call GETADRY
            ld   a,(iy+1)
            cp   #80
            jpz  FINDASTER
            ld   a,(iy+TYPE)
            cp   (ix+TSUBJ)
            jpnz FINDASTER
            call RASTOY
            cp   LAUNGHFAR
            jrnc $+9
            res  2,(iy+SETUP)
            jp   DEATHX
            call TOTHEALL_
            jp   GOSIMPLY




SROKA
РАКЕТНАЯ АТАКА НА СТАНЦИЮ
            ld   (ix+MODE),C_DEFENCESTAT
            jp   SINT3


GOAWAY
            call CHECKA2
            jr   GSUN1


GOSUN
ДВИЖЕНИЕ ПО ЗАДАННОМУ УГЛУ НАПРАВЛЕНИЯ
ПО ИДЕЕ НА СОЛНЦЕ
            call CHECKALL
            jpc  GOSIMPLY
GSUN1
            call FAREAR
            ld   a,l
            cp   4
            jrnc GOS1
            add  a,a
            add  a,a
            add  a,40
            ld   (Jjj1+1),a
            call RND
ПРОВЕРКА НА ГИПЕР ПЕРЕХОД
            ld   a,h
            srl  a
Jjj1        cp   40
            jrc  GOS1
            ld   a,l
            cp   #7F
            jrnz GOS1
            ld   (ix+MODE),C_JUMPOUT
            jp   GOSIMPLY
GOS1
            call FARSUN
            ld   a,l
            cp   4
            jrnc GOSIMPLY
ЕСЛИ ЗВЕЗД БЛИЗКО
            ld   a,(ix+BETA)
            inc  a
            ld   (ix+BETA),a
            jp   GOSIMPLY



GOEAR
            ld   b,(ix+PLAN):inc b
            ld   iy,PLANETES-12
            ld   de,12
            add  iy,de:djnz $-2
            call TOPLAN


            call CHECKALL
            jpc  GOSIMPLY
            ld   a,(STATGEN)
            and  a
            jrz  GOSIMPLY
            ld   a,(ix+TYPE)
            cp   T_PIRAT
            jrz  GOSIMPLY
            cp   T_PIRAT2
            jrnc GOSIMPLY
            call RNDL4
            ld   a,h
            cp   #41
            jrnz GOSIMPLY
            ld   a,l
            cp   VWZST
            jrc  GOSIMPLY
ВОЗВРАТ НА СТАНЦИЮ
            ld   (ix+MODE),C_BACKPOLICE
GOSIMPLY
            ld   a,(ix+1)
            cp   #80
            retz
            ld   a,(ix+ALFA)
            ld   (EYEA_+1),a
            ld   a,(ix+BETA)
            add  a,#80
            ld   (EYEB_+1),a
            ld   a,(ix+GAMA)
            ld   (EYEG_+1),a
            ld   a,(ix+RSPD)
            ld   e,a
            inc  a
            cp   (ix+MSPD)
            jrc  $+3
            dec  a
            ld   (ix+RSPD),a
            ld   a,(ix+TYPE)
            cp   T_CHIP
            jrnc NNI1
УБИРТЬ ФОРСАЖ ТОЛЬКО КОРАБЛЯМ
            ld   a,(ix+MODE)
            cp   C_FORSAGE;FORSAGE
            jrz  $+6
            ld   (ix+FORSAG),0
NNI1
            ld   d,(ix+FORSAG)
            jp   MOVEON


FIGHT
РЕЖИМ НАПАДЕНИЯ НА ОБЪЕКТ
            ld   a,(ix+SUBJ)
            inc  a
            jrnz FGH7
            ld   a,r
            cp   120
            jrc  FTT1
            call YESCARGO
            jrz  FTT1
            call NEARCARGO
            ld   (ix+MODE),C_GETCARGO
            ld   (ix+SUBJ),a
            jp   GOSIMPLY
FTT1
            call NEWORD
            ld   a,(ix+SUBJ)
            inc  a
            jpnz GOSIMPLY
            ld   a,(ix+OMODE)
            cp   C_FIGHT
            jpz  GOSIMPLY
            sla  a
            ld   l,a
            ld   h,0
            ld   de,ITAB
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jp   (hl)
FGH7
            call FLOTSTART
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jpz  GOASTER
            ld   a,(ix+ENERGY)
            cp   35
            jrnc FGT9
            ld   a,r
            cp   100
            ld   c,a
            jrc  FGH71
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jrz  FGH71
            cp   T_MIKR
            jrz  FGH71
            ld   (ix+MODE),C_JUMPOUT
            jp   GOSIMPLY
FGH71
            ld   a,c
            cp   50
            jrnc FGT9
            ld   a,(ix+TYPE)
            cp   T_POLICE
            jrz  FGT9
            cp   T_MILITARY
            jrz  FGT9
            cp   T_HERMIT
            jrnz DFN102
            bit  2,(ix+SETUP)
            jrnz FGT9
DFN102
            call DROPCARGO
РЕЖИМ СВОБОДНОГО ПОЛЕТА
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jpz  GOSIMPLY
            ld   (ix+MODE),C_GOAWAY
            jp   GOSIMPLY
FGT9
            call TESTSUBJ
            jrnz FGH1
            ld   (ix+SUBJ),#FF
            jp   GOSIMPLY
FGH1
            call OPONE
            jpc  FGHT1
            ld   a,(ix+RCO)
            dec  a
            jpm  $+9
            ld   (ix+RCO),a
            jpz  FIROK2


DDX         ld   de,0
DDY         ld   bc,0
            ld   hl,(DX+1)
            exx
            ld   hl,(DY+1)
            ld   de,(DZ+1)
DDZ         ld   bc,0
            exx





ОРГАНИЗАЦИЯ ОГНЯ ЛАЗЕРОМ ИЛИ РАКЕТАМИ
ПЕРСОНАЖА ПО ПЕРСОНАЖУ
NAVODFIRE

НАВЕДЕНИЕ НОСА
            call ONWAY

НАЙТИ МАКСИМАЛЬНЫЙ УГОЛ, ВЗЯВ ЕГО ПО
МОДУЛЮ И ПО ЧЕТВЕРТИ

            ld   a,h
            cp   l
            jrnc $+3
            ld   a,l

            cp   VISUNGLE
            jpnc GOSIMPLY
            call RND
            ld   a,l
            cp   (ix+LZS)
            jrnc FIROK
            call FIREING
            jrnc $+5
FGHT1
            call NEWORD
            jp   GOSIMPLY


FIROK
РАКЕТНЯ АТАКА
            cp   #F0
            jpnz GOSIMPLY
            ld   a,h
            cp   #5F
            jpc  GOSIMPLY
            ld   a,(ix+TYPE)
            cp   T_MIKR
            jpz  GOSIMPLY
            ld   a,(ix+RCO)
            and  a
            jpnz GOSIMPLY
            call FIROK22
            ld   c,(ix+TYPE)
            ld   b,0
            ld   hl,JTYPE
            add  hl,bc
            ld   a,(hl)
            ld   (ix+RCO),a
            jp   GOSIMPLY
FIROK2
            call FIROK22
            jp   GOSIMPLY
FIROK22
            ld   c,(ix+SUBJ)
            exx
            ld   l,(ix+0)
            ld   h,(ix+1)
            ld   e,(ix+2)
            ld   d,(ix+3)
            ld   c,(ix+4)
            ld   b,(ix+5)
            exx
            exa:xor a:exa
НОМЕР ОБЪЕКТ КТО ПУСТИЛ РАКЕТУ
            call GETINDX
            ld   b,a
            bit  3,(ix+SETUP)
            ld   a,MINREN
            jrz  $+4:ld a,MAXREN
            jp   RKN11


JTYPE
СЧЕТЧИК ПОВТОРНОГО ПУСКА РАКЕТ ДЛЯ
КАЖДОГО ПЕРСОНАЖА
            db   20 ■ПИРАТ
            db   0  ■МИРНЫЙ
            db   18 ■ВОЕННЫЙ
            db   30 ■ПОЛИЦИЯ
            db   0  ■ЛЕГИОНЕР
            db   30 ■ПИРАТ2
            db   35 ■УФО
            db   10 ■УФО2
            db   40 ■ОТШЕЛЬНИК


DEFENCE
РЕЖИМ ЗАЩИТЫ ОТ НАПАДЕНИЯ
            ld   a,(ix+SUBJ)
            inc  a
            jrnz DFN7
            ld   a,r
            cp   126
            jrc  DFC1
            call YESCARGO
            jrz  DFC1
            call NEARCARGO
            ld   (ix+MODE),C_GETCARGO
            ld   (ix+SUBJ),a
            jp   GOSIMPLY
DFC1
            call NEWORD
            ld   a,(ix+SUBJ)
            inc  a
            jpnz GOSIMPLY
            ld   a,(ix+OMODE)
            cp   C_DEFENCE
            jpz  GOSIMPLY
            sla  a
            ld   l,a
            ld   h,0
            ld   de,ITAB
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jp   (hl)
DFN7
            ld   a,(ix+ENERGY)
            cp   35
            jpnc DFN1
            ld   a,r
            cp   100
            ld   c,a
            jrc  DFN71
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jrz  DFN71
            cp   T_MIKR
            jrz  DFN71
            ld   (ix+MODE),C_JUMPOUT
            jp   GOSIMPLY
DFN71
            ld   a,c
            cp   40
            jrc  DFN1
            ld   a,(ix+TYPE)
            cp   T_POLICE
            jrz  DFN1
            cp   T_MILITARY
            jrz  DFN1
            cp   T_HERMIT
            jrnz DFN101
            bit  2,(ix+SETUP)
            jrnz DFN1
DFN101
            call DROPCARGO
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jpz  GOSIMPLY
            ld   (ix+MODE),C_GOAWAY
            jp   GOSIMPLY
DFN1
            call TESTSUBJ
            jrnz FGH11
            ld   (ix+SUBJ),#FF
            jp   GOSIMPLY
FGH11

            ld   a,(ix+RCO)
            dec  a
            jpm  $+9
            ld   (ix+RCO),a
            jpz  FIROK2

            call FLOTSTART
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jpz  GOASTER

            call RNDTURN

            ld   de,(DX+1)
            ld   bc,(DY+1)
            ld   hl,(DDX+1)
            exx
            ld   hl,(DDY+1)
            ld   de,(DDZ+1)
            ld   bc,(DZ+1)
            exx
            jp   NAVODFIRE




BACKUP
ВОЗВРАЩЕНИЕ НА СТАНЦИЮ, СТАДИЯ 2
ДВИЖЕНИЕ В СТОРОНУ СТАНЦИИ
            ld   d,T_STATION
            call FINDOBJ
            jpz  GOSIMPLY
BACKALL
            call RASTOY
            cp   LAUNGHFAR
            jrc  DEATHX
TOTHEALL
            call TOTHEALL_
            jp   GOSIMPLY

TOTHEALL_
            exx
            ld   l,(iy+2)
            ld   h,(iy+3)
            ld   e,(iy+4)
            ld   d,(iy+5)
            ld   c,(ix+4)
            ld   b,(ix+5)
            exx
            ld   e,(ix+0)
            ld   d,(ix+1)
            ld   l,(iy+0)
            ld   h,(iy+1)
            ld   c,(ix+2)
            ld   b,(ix+3)
            jp   ONWAY2
DEATHX
            ld   (ix+1),#80
            ld   (ix+0),0
            ld   (ix+SETUP),#FF
            ret

TURNOUT
ПОВОРОТ КУДАТО
            ld   a,(ix+POWOR)
            dec  a
            ld   (ix+POWOR),a
            exa
            ld   a,(ix+BETA)
            add  a,4
            ld   (ix+BETA),a
            ld   a,(ix+GAMA)
            add  a,2
            ld   (ix+GAMA),a
            exa
            jpnz GOSIMPLY
            ld   (ix+POWOR),TMOTLET
            ld   (ix+MODE),C_FLYAWAY
            jp   GOSIMPLY


OTLET
ОТЛЕТ В ЗАДАННОМ НАПРАВЛЕНИИ СЕКУНДУ
ДРУГУЮ
В POWOR-ВРЕМЯ В КАДРАХ
В PMODE-ПРЕДЫДУЩИЙ РЕЖИМ
            ld   a,(ix+POWOR)
            dec  a
            ld   (ix+POWOR),a
            jrnz OTLET2
            ld   a,(ix+PMODE)
            ld   (ix+MODE),a
            jp   GOSIMPLY
OTLET2
            call TESTSUBJ
            jpz  GOSIMPLY
            call RND
            ld   a,l
            cp   (ix+LZS)
            jpnc FIROK
            call FIREING
            jp   GOSIMPLY


STARTPOLICE
РЕЖИМ ПУСКА ПОЛИЦИИ ИЗ СТАНЦИИ
            ld   a,10
            inc  a
            and  #0F
            ld   ($-4),a
            jpnz STAYSTATION
ПОИСК СВОБОДНОГО МЕСТА
            call FINDFREE
            jpz  STAYSTATION

            ld   a,(ix+RAND)
            call GETADR
            inc  l
            ld   a,(hl)
            cp   #80
            jrnz $+9
            ld   (ix+MODE),C_STAYSTAT
            jp   STAYSTATION

            ld   l,(ix+0)
            ld   h,(ix+1)
            ld   (iy+0),l
            ld   (iy+1),h
            ld   a,r
            and  1
            inc  a
            ld   b,a
            ld   c,#80
            ld   l,(ix+2)
            ld   h,(ix+3)
            add  hl,bc
            ld   (iy+2),l
            ld   (iy+3),h
            ld   l,(ix+4)
            ld   h,(ix+5)
            ld   (iy+4),l
            ld   (iy+5),h

ЗАДАНИЕ ВИДА ПОЛИЦИИ В ЗАВИСИМОСТИ ОТ
ГОСУДАРСТВА
            ld   hl,(PLACE)
            call GOSTA

            rlca:rlca
            add  a,IPLS1

            ld   (iy+INDI),a
            ld   (iy+MSPD),150
            ld   (iy+ALFA),#40
            ld   (iy+BETA),0
            ld   (iy+GAMA),0
            ld   (iy+LZS),70
            ld   (iy+MODE),C_FIGHT
РЕЖИМ ВОЗВРАТА BACKUP
            ld   (iy+OMODE),C_BACKPOLICE
            ld   (iy+ACTN),0
            ld   (iy+TYPE),T_POLICE
            ld   (iy+RCO),0
            ld   a,(ix+RAND)
            ld   (iy+OSUBJ),#FF
            ld   (iy+SUBJ),a
            ld   (iy+ENERGY),100
            ld   (iy+RSPD),30
            ld   (iy+SPT),2

            ld   a,(ix+OMODE)
            dec  a
            ld   (ix+OMODE),a
            jrnz $+6
РЕЖИМ STAYSTATION
            ld   (ix+MODE),C_STAYSTAT
            jp   STAYSTATION


STATDEF
СТАНЦИЯ ЗАЩИЩАЕТСЯ
УНИЧТОЖЕНИЕ ТРЕХ РАКЕТ НАПРАВЛЕННЫХ НА
НЕЕ
            ld   a,%10010010
            rrca
            ld   ($-2),a
            jpnc STAYSTATION
            exx
            ld   e,3
            exx
            ld   hl,CARSB-OLEN+1
            ld   de,OLEN
            jp   STD1
STD3
            dec  l
            ld   a,(hl)
            cp   #80
            jrz  STD2
            inc  l
STD1
            add  hl,de
            ld   a,(hl)
            cp   #80
            jrz  STD3
            ld   a,l
            add  a,TYPE-1
            ld   l,a
            ld   c,(hl)
            dec  l,l,l,l,l
■RAND=SUBJ OF STARTING ROKET
            ld   b,(hl)
            ld   (ix+RAND),b
            inc  l,l
            ld   b,(hl)

            sub  TYPE-1
            ld   l,a
            ld   a,c
            cp   T_ROKET
            jrnz STD1
            ld   a,b
            exx
            call GETADR
            ld   a,l
            add  a,TYPE
            ld   l,a
            ld   a,(hl)
            cp   T_STATION
            exx
            jrnz STD1
■makeEXPL.
            exx
            push de
            exx
            push hl,de
            push ix
            dec  l
            push hl
            pop  ix
            call MAKEEXPLO
            pop  ix
            pop  de,hl
            exx
            pop  de
            dec  e
            exx
            jrnz STD1
STD2
РЕЖИМ ВЫПУСК ПОЛИЦИИ НА НАПАДАЮЩЕГО
            call CHNPOL
            jrnc STAYSTATION
■MODE START POLICE
            ld   (ix+MODE),C_STARTPOLICE
            ld   a,r
            and  1
            add  a,2
            ld   (ix+OMODE),a
            ld   a,(ix+RAND)
            cp   SPLAYER
            ld   c,32
            call z,CHSTATUS
            jp   STAYSTATION

ПЕРЕХОД В РЕЖИМ STAYSTATION, ЧТО БЫ
ЧАСТИ СТАНЦИИ СТОЯЛИ НА МЕСТЕ



STYSTAT
ПРОВЕРИТЬ СТАТУС ИГРОКА, ЕСЛИ СТАТУС
ПЛОХ, ТО ВЫЛЕТ ПОЛИЦИИ
            ld   a,r
            cp   VWLPL
            jrc  STTT9
            call RNDL4
            ld   a,l
            cp   40
            jrnc STTT9
            ld   a,(STATUS)
            cp   80;ВЫЩЕ ПРЕДЕЛА
            ld   a,SPLAYER
            jrnc STTT1
STTT9
            ld   d,0
            call FINDOBJ
            jrz  STTT2
            call GETINDY
            jr   STTT1
STTT2
            ld   d,7
            call FINDOBJ
            jrz  STTT3
            call GETINDY
            jr   STTT1
STTT3
            ld   d,5
            call FINDOBJ
            jrz  STAYSTATION
            call GETINDY
STTT1
ИНИТ РЕЖИМА ПУСКА КОРАБЛЕЙ
            exa
ЕСЛИ ЕСТЬ ПОЛИЦИЯ В КОСМОСЕ
            ld   d,3
            call FINDOBJ
            jrnz STAYSTATION
ПОИСК ЧАСТИ СТАНЦИИ
            ld   d,#12
            call FINDOBJ
            jrz  STAYSTATION
            ld   (iy+MODE),C_STARTPOLICE
            exa
            ld   (iy+RAND),a
            ld   (iy+OMODE),2
STAYSTATION
            ld   hl,0
            ld   (STPX_+1),hl
            ld   (STPY_+1),hl
            ld   (STPZ_+1),hl
            ret


NAVODROKET
ДВИЖЕНИЕ РАКЕТЫ ПО СЛЕДУ ЦЕЛИ
            ld   a,(ix+MSPD);SUBJ
            call GETADRY
НАВЕДЕНА РАКЕТА
            set  1,(iy+ACTN)
            ld   a,(ix+RAND)
КТО ПУСТИЛ РАКЕТУ
            ld   (iy+OSUBJ),a
            call GETINDX
            ld   (iy+SUBJ),a
            ld   c,(iy+0)
            ld   a,(iy+1)
            cp   #80
            jrnz NR1
            ld   a,(ix+LZS)
            and  a
            jrz  $M21
            MESAG   _LOSTTARGET
$M21
            ld   d,xh
            ld   e,xl
            jp   EXPLO2
NR1
            ld   b,a
            exx
            ld   c,0
            exx
            ld   l,(ix+0)
            ld   h,(ix+1)
            call CHARCO
            ld   (ix+0),l
            ld   (ix+1),h
            ld   c,(iy+2)
            ld   b,(iy+3)
            ld   l,(ix+2)
            ld   h,(ix+3)
            call CHARCO
            ld   (ix+2),l
            ld   (ix+3),h
            ld   c,(iy+4)
            ld   b,(iy+5)
            ld   l,(ix+4)
            ld   h,(ix+5)
            call CHARCO
            ld   e,yl
            ld   d,yh
            exx
            ld   a,c
            exx
            and  a
            jrz  EXPLO1
            ld   (ix+4),l
            ld   (ix+5),h
            inc  (ix+ALFA)
            inc  (ix+BETA)
            inc  (ix+BETA)
            inc  (ix+GAMA)
            inc  (ix+GAMA)
            inc  (ix+GAMA)
            ld   hl,0
            ld   (STPX_+1),hl
            ld   (STPY_+1),hl
            ld   (STPZ_+1),hl
            ret

EXPLO1
ПРОВЕРИМ ЕСЛИ ЭТО ИГРОК ПО МРКЕРУ
            ld   a,(ix+MSPD)
            call GETADR
            ld   a,l:or MODE:ld l,a
            ld   a,(hl)
            inc  a
            jrz  EXL4
            call DEATHX
EXL4
РАКЕТА ПОПАЛА В ЦЕЛЬ
            set  2,(iy+ACTN)
            ld   a,(ix+LZS)
            and  a
            jrz  EXPLO2
ЦЕЛЬ УНИЧТОЖЕНА
            MESAG   _DESTROY
EXPLO2
            push ix
            ld   xh,d
            ld   xl,e
            call MAKEEXPLO
            pop  ix
            ret


JUMPING
ПРЫЖОК В ГИПЕР ПРОСТРАНСТВО, ТЯНЕМ ВРЕМЯ
НА ПРОПАДАНИЕ СПРАЙТА, А ПОТОМ ИСЧЕЗНЕТ
КОРАБЛЬ
            dec  (ix+LZS)
            jpz  DEATHX
            ld   a,(ix+RSPD)
            and  a
            jpz  GOSIMPLY
            srl  a
            ld   (ix+RSPD),a
            jp   GOSIMPLY
STAY
            ld   a,(ix+RSPD)
            and  a
            jrz  SY1
            dec  a
            dec  a
            ld   (ix+RSPD),a
            call GOSIMPLY
            ret
            jp   SY2
SY1
            ld   hl,0
            ld   (STPX_+1),hl
            ld   (STPY_+1),hl
            ld   (STPZ_+1),hl
            ret
SY2
            call RND
            ld   de,#F000
            SUB_DE
            retc
            jp   NEWORD



FREEFLY
СВОБОДНЫЙ ПОЛЕТ С ВРАЩЕНИЕМ
            inc  (ix+BETA)
            inc  (ix+BETA)
            inc  (ix+GAMA)
            inc  (ix+GAMA)
            inc  (ix+GAMA)
            jp   GA1


GOASTER
ДВИЖЕНИЕ ДЛЯ АСТЕРОИДА
            call YESCARGO
            jrz  GA1
            call NEARCARGO
            ld   (ix+SUBJ),a
            ld   a,C_GETCARGO
            call FLOTSTART2
GA1
            inc  (ix+ALFA)
            ld   a,(ix+RAND)
            ld   (EYEA_+1),a
            ld   a,(ix+RAND+1)
            add  a,#80
            ld   (EYEB_+1),a
            ld   a,(ix+MSPD)
            ld   (EYEG_+1),a
            ld   e,(ix+RSPD)
            ld   d,0
            jp   MOVEON


JUMPOUT
ГИПЕР ПРЫЖОК КУДАТО ОТ СЮДА
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
            ld   a,26
            exx
            ld   hl,NWTEL
            call NEWVSPR
            ld   a,1
            ld   (EXPL+1),a
            ld   a,(CEX+1)
            cp   26
            jrnc $+7
            ld   a,26
            ld   (CEX+1),a
            ld   (ix+MODE),C_JUMPING
ИНИЦИИРУЕМ ВРЕМЯ ЖИЗНИ ПЕРЕД
ИСЧЕЗНОВЕНИЕМ
            ld   (ix+LZS),18
            ret







■---------------------------------------
ЦЕНТР ОБРАБОТКИ ИНТЕЛЕКТА
■---------------------------------------

SHIPINTELEGENT
СПИСОК ОБЪЕКТОВ
            ld   ix,CARSB-OLEN
            jr   $+8
            ld   a,(ix+0)
            cp   #80
            retz;КОНЕЦ СПИСКА
SINT1
            ld   de,OLEN
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jpz  $-16;ПУСТО-КОНЕЦ


ВОССТАНОВЛЕНИЕ ЭНЕРГИИ ОБЪЕКТА, ЕСЛИ
ЕЕ НЕ ДОСТАТОЧНО
            ld   a,(ix+TYPE)
            cp   T_CHIP
ЕСЛИ НЕ КОРАБЛИ
            jpnc SINT2
ЕСЛИ ЭНЕРГИИ МЕНЬШЕ, ТО ДОБАВИТЬ
МАКСИМАЛЬНЫЙ УРОВЕНЬ ЭНЕРГИИ КОРАБЛЕЙ
            ld   a,(ix+MENE)
            dec  a
            ld   h,a
ЕСЛИ ЭНЕРГИИ МЕНЬШЕ, ТО ДОБАВИТЬ
            ld   a,(ix+ENERGY)
            cp   h
            jrnc SINT2
            inc  a
            ld   (ix+ENERGY),a

SINT2
ЕСЛИ БЫЛО ДЕЙСТВИЕ СО СТОРОНЫ
            ld   a,(ix+ACTN)
            and  a
            jpz  SINT3;НЕБЫЛО
            bit  1,a

ЕСЛИ РАКЕТНАЯ АТАКА
            jpnz ROKATAC

ЛАЗЕРНАЯ АТКА
            ld   a,(ix+TYPE)
            cp   T_STATION

ЕСЛИ ОБЪЕКТ НЕ СТАНЦИЯ
            jrnz SINT4

ЭТО СТАНЦИЯ, ЕЕ ЛАЗЕРОМ НЕ ВОЗЬМЕШЬ
СТАРТ ПОЛИЦИИ НА НАПАДАЮЩЕГО
            ld   a,(ix+SUBJ)
КТО НАПАЛ
            ld   (ix+RAND),a
ЕСТЬ ЛИ ПОЛИЦИЯ УЖЕ В КОСМОСЕ?
            call CHNPOL
            jpnc SINT3

РЕЖИМ ВЫПУСКА
            ld   (ix+MODE),C_STARTPOLICE
            ld   a,r
            and  1
            add  a,2

КОЛИЧЕСТВО ПОЛИЦИИ
            ld   (ix+OMODE),a
            ld   a,(ix+RAND)
            cp   SPLAYER

ИЗМЕНЕНИЕ СТАТУСА ЕСЛИ НАПАЛ ИГРОК
            ld   c,8
            call z,CHSTATUS
            jp   SINT3

ЕСЛИ НАПАЛ ИГРОК, ТО ОДНО ПРИРАЩЕНИЕ
ЭНЕРГИИ ИНАЧЕ ДРУГОЕ
SINT4
            ld   a,(ix+SUBJ)
            cp   SPLAYER
PMLPL       ld   c,#0A
            jrnz SINT44
PMLI        ld   c,#0A

ЕСЛИ ЭТО БЫЛ ПРОТИВОРАКЕТНЫЙ ЛАЗЕР
            bit  3,(ix+ACTN)
            jrz  SINT44
            ld   a,(PROTR1)
            inc  a
            ld   c,30;PROTRAK1
            jrnz SINT44
            ld   a,(PROTR2)
            inc  a
            ld   c,60;PROTRAK2
            jrnz SINT44
            ld   c,20;PROTRAK2
SINT44
ИЗМЕНЯЕМ ЭНЕРГИЮ
            ld   a,(ix+ENERGY)
            sub  c
ЕСЛИ ЭНЕРГИЯ НЕ КОНЧИЛАСЬ
            jpnc SINT5
ВЗРЫВ ОБЪЕКТА
            call MAKEEXPLO
            ld   (ix+ACTN),0
            jp   SINT1

РАКЕТНАЯ АТАКА НА ОБЪЕКТ
ROKATAC

ТИП ОБЪЕКТА
            ld   a,(ix+TYPE)
            cp   T_STATION
ЕСЛИ АТАКА НА СТАНЦИЮ
            jpz  SROKA
            cp   T_CHIP
ЕСЛИ НЕ КОРАБЛЬ
            jrnc SINT3

РЕЖИМ ЗАЩИТЫ
            ld   a,(ix+MODE)
            cp   C_JUMPING
            jpz  SINT3
            cp   C_JUMPOUT
            jpz  SINT3
            ld   (ix+MODE),C_DEFENCE
            jp   SINT3

АТАКА ЛАЗЕРОМ НО ЭНЕРГИЯ НЕ КОНЧИЛАСЬ
SINT5
            ld   (ix+ENERGY),a
            ld   a,(ix+TYPE)
            cp   T_CHIP
ЕСЛИ НЕ КОРАБЛЬ
            jpnc SINT3
СМОТРИМ ТЕКУЩИЙ РЕЖИМ ЕГО ДЕЙСТВИЙ
            ld   a,(ix+MODE)
            cp   C_FIGHT

            jpnz SINT8

ЕСЛИ РЕЖИМ СРАЖЕНИЯ
ПРОВЕРКА СУБЪЕКТА НА КОГО НАПАДАЛИ ДО
ТОГО КАК В НАС СТРЕЛЬНУЛИ
            ld   c,(ix+SUBJ)
            inc  c
ЕСЛИ НЕТ СУБЪЕКТА ТО ОПРЕДЕЛЕНИЕ
БУДУЩЕГО РЕЖИМА УЧИТЫВАЯ ОБЪЕКТ
            jrz  SINT6
■----------
ЕСТЬ СУБЪЕКТ НАПАДЕНИЯ
СЛУЧАЙНО МОЖНО ПЕРЕЙТИ В НАПАДЕНИЕ НА
НОВОГО ПРОТИВНИКА
            ld   a,r
            cp   10
            jrc  SINT6
            jp   SINT3
SINT8
            cp   4;FREEFLY
            jpc  SINT6
            cp   10
            jpc  SINT3
SINT6
ОПРЕДЕЛИМ ВЕРОЯТНОСТЬ ПЕРЕХОДА В
НАПАДЕНИЕ ИЛИ ОБРАТНУЮ ВЕРОЯТНОСТЬ
ПЕРЕХОДА В ЗАЩИТУ ДЛЯ ОПР. ОБЪЕКТ
            ld   a,(ix+TYPE)
            and  #0F
            cp   T_POLICE
            ld   c,#70
            jpz  SINT7
            cp   T_PIRAT
            ld   c,#75
            jpz  SINT7
            cp   T_TRADER
            ld   c,#50
            jpz  SINT7
SINT7
            ld   a,(ix+MODE)
            cp   C_JUMPING
            jrz  SINT3
            cp   C_JUMPOUT
            jrz  SINT3
            ld   a,r
            cp   c
            ld   a,C_FIGHT
            jrc  $+4
            ld   a,C_DEFENCE
            ld   (ix+MODE),a

SINT3
ВЫЗОВ ПРОЦЕДУРЫ ОБРБОТКИ СОСТОЯНИЯ
СТИРАЕМ АКТИВНОСТЬ НА ОБЪЕКТ
            ld   (ix+ACTN),0
БЕРЕМ РЕЖИМ СОСТОЯНИЯ
            ld   a,(ix+MODE)
            sla  a
            ld   l,a
            ld   h,0
            ld   de,ITAB
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            push ix
            ld   de,$+5
            push de
            jp   (hl)
            pop  ix
            call PRECORD
            jp   SINT1


