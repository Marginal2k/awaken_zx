;==============================================================================
; OBJGENER - генерация объектов: корабли по типу системы, станция, астероиды, груз
;
;
; Где живёт: блок disp #6000 внутри ACTION.C (после SETCONTR).
; GENSHIPS: каждый кадр бросает случайный байт против порога GNUM, при успехе берёт свободный слот
; (FindFreeSlot), выбирает тип по кумулятивной таблице вероятностей государства (SETT в SETHJRET.asm) и
; заполняет запись объекта (TYPE, MODE, MENE, POWOR ...). Станция/части станции: ST1k..ST16k.
; Читает: TIME..PLANET из записи состояния (src/common/state.inc), таблицы 3DTABS. GAME_DESIGN 6.3.
;==============================================================================

; Адреса объектов станций для каждого
; уровня развития
STATTB:
            dw   ST9k
            dw   ST14k
            dw   ST13k
            dw   ST4k
            dw   ST2k
            dw   ST1k
            dw   ST6k
            dw   ST5k
            dw   ST11k
            dw   ST7k
            dw   ST8k
            dw   ST16k
            dw   ST12k
            dw   ST3k
            dw   ST15k
            dw   ST10k


; Данные о 3D блоках станции

ST1k:
            dw   #0000,#0000,#0000
            db   IST1,#00
            dw   #80FF


ST2k:
            dw   #0000,#0000,#0000
            db   IST2,#00
            dw   #80FF

ST3k:
            dw   #0000,#0000,#0000
            db   IST3,#00
            dw   #80FF
ST4k:
            dw   #0000,#0000,#0000
            db   IST4,#00
            dw   #80FF
ST5k:
            dw   #0000,#0000,#0000
            db   IST5,#00
            dw   #80FF
ST6k:
            dw   #0000,#0000,#0000
            db   IST6,#00
            dw   #80FF
ST7k:
            dw   #0000,#0000,#0000
            db   IST7,#00
            dw   #80FF
ST8k:
            dw   #0000,#0000,#0000
            db   IST8,#00
            dw   #80FF
ST9k:
            dw   #0000,#0000,#0000
            db   IST9,#00
            dw   #80FF
ST10k:
            dw   #0000,#0000,#0000
            db   IST10,#00
            dw   #80FF
ST11k:
            dw   #0000,#0000,#0000
            db   IST11,#00
            dw   #80FF
ST12k:
            dw   #0000,#0000,#0000
            db   IST12,#00
            dw   #80FF
ST13k:
            dw   #0000,#0000,#0000
            db   IST13,#00
            dw   #80FF
ST14k:
            dw   #0000,#0000,#0000
            db   IST14,#00
            dw   #80FF
ST15k:
            dw   #0000,#0000,#0000
            db   IST15,#00
            dw   #80FF
ST16k:
            dw   #0000,#0000,#0000
            db   IST16,#00
            dw   #80FF


; Генерация станции
STATGEN_:
            ld   a,(STATGEN)
            and  a
            jp   nz,DGN1

            ld   bc,(SSZ)

            ld   de,(SSY)

            ld   hl,(SSX)

            ld   a,1
            ld   (STATGEN),a
            ld   (NOSTAT),a

            exx

            ld   a,#10
            ld   (SSETU+3),a

            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            ex   af,af'
            PAGE_ CONTR
            ex   af,af'
            call PlanetInfo
            PAGE___NOARG

            dec  l
            ld   h,0
; Таблица адресов объектов станций для
; каждого уровня развития
            add  hl,hl
            ld   de,STATTB
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   ixl,a
            ld   a,(hl)
            ld   ixh,a
; Регитр iудолжен принимать значения
; адресов комплексов станций в зависимости
; от уровня развития планеты

GS99:
            call FindFreeSlot
            ret  z                  ;Буфер полон
            exx
            push hl
            push de
            push bc
            push bc
            ld   c,(ix+0)
            ld   b,(ix+1)
            xor  a
            inc  a
            adc  hl,bc
            jp   po,$+4
            xor  a

            ld   (iy+0),l
            ld   (iy+1),h
            EXD
            ld   c,(ix+2)
            ld   b,(ix+3)
            or   a
            adc  hl,bc
            jp   po,$+4
            xor  a

            ld   (iy+2),l
            ld   (iy+3),h
            pop  hl
            ld   c,(ix+4)
            ld   b,(ix+5)
            or   a
            adc  hl,bc
            jp   po,$+4
            xor  a
            or   a
            jr   z,NNN1

            ld   (iy+4),l
            ld   (iy+5),h
            ld   a,(ix+6)
            ld   (iy+6),a
            ld   a,(ix+7)
            ld   (iy+8),a


            xor  a
            ld   (iy+ALFA),a
            ld   (iy+GAMA),a
            ld   (iy+MODE),C_STAYSTAT
            ld   (iy+SUBJ),a
            ld   (iy+ACTN),a
            ld   (iy+RAND),a
            ld   (iy+MSPD),a
            ld   (iy+RSPD),a
            ld   (iy+LZS),a
            ld   (iy+RSPD),a
            ld   (iy+TYPE),T_STATION
            ld   (iy+ENERGY),#FF
            ld   (iy+RCO),#FF
            ld   (iy+OSUBJ),#FF
            ld   (iy+OMODE),a
            ld   (iy+POWOR),a
SSETU:      ld   (iy+SETUP),#10
            ld   (SSETU+3),a

            ld   (iy+FORSAG),a

            ld   bc,8
            add  ix,bc
            ld   a,(ix+1)
            cp   #80
NNN2:
            pop  bc
            pop  de
            pop  hl
            ret  z
            jp   GS99
NNN1:
            call DEATHY
            jr   NNN2


; Дополнительная генерция
; либо на генерация станции, либо
; генерация рейдов
DOPGEN:

            ld   (DDE+1),hl

            ld   hl,(SSX+1)
            ld   a,h
            or   a
            jp   p,$+10
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            inc  hl
            ld   a,h

            ld   b,l
            ld   c,a
            ld   hl,(SSY+1)
            ld   a,h
            or   a
            jp   p,$+10
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            inc  hl
            ld   a,h

            ld   e,l
            or   c
            ld   c,a
            ld   hl,(SSZ+1)
            ld   a,h
            or   a
            jp   p,$+10
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            inc  hl
            ld   a,h

            or   c
            jr   nz,.DGN2

            ld   a,l
            cp   SPACEBS
            jr   nc,.DGN2
            ld   a,e
            cp   SPACEBS
            jr   nc,.DGN2
            ld   a,b
            cp   SPACEBS
            jr   nc,.DGN2

            jp   STATGEN_

.DGN2
            call RNDK2
            ld   a,h
            xor  l
            ret  nz

DGN1:

DDE:        ld   de,0
            ld   a,d
            cp   #23
            ret  nz
            ld   a,e
PWPR:       cp   #F2
            ret  c

            ld   a,#FF
DOPC1:
            ld   (DOPCOUNT+1),a
            and  a
            jp   p,.DOPC_
            ld   a,e
            and  3
            add  a,5
            ld   (DOPCOUNT+1),a
            ld   a,r
            rra
            ld   a,32
            jr   c,$+4
            ld   a,0
            ld   (FORRAID+1),a
            ld   a,T_UFO
            jr   c,$+4
            ld   a,T_PIRAT
            ld   (TYPERAID+3),a
.DOPC_
            call FindFreeSlot
; Если буфер полон
            ret  z
            push iy
            pop  ix
            call RNDT1
            ld   a,l
            xor  h
            and  %00011100
            or   %01000000
FORRAID:    add  a,0                ;32
            ld   (ix+INDI),a
            ld   l,a
            ld   (ix+MSPD),100

; Взять масштаб объекта
; в lдолжен быть установлен индекс
            ld   a,l
            call ObjectSize
            ld   a,h
            push af
            call RNDK1
            sra  h
            rr   l
            ld   (ix+4),l
            ld   (ix+5),h
            push hl
            call RNDK1
            sra  h
            rr   l
            ld   (ix+2),l
            ld   (ix+3),h
            push hl
            call RNDK1
            sra  h
            rr   l
            ld   (ix+0),l
            ld   (ix+1),h
            pop  de
            pop  bc
            pop  af
            ex   af,af'
            ld   a,26
            exx
            ld   hl,NWTEL
            call NewVoxelSprite
            ld   a,1
            ld   (EXPL+1),a
            ld   a,(CEX+1)
            cp   26
            jr   nc,$+7
            ld   a,26
            ld   (CEX+1),a
            ld   (ix+ALFA),0
            call RNDL2
            ld   a,l
            and  3
            bit  7,l
            jr   z,$+4
            neg
            add  a,h
            ld   (ix+BETA),a
            call RNDL3
            ld   a,l
            and  #1F
            ld   (ix+GAMA),a
            call RNDL7
            ld   a,l
            and  #55
            ld   l,a
            ld   a,h
            and  %00101010
            and  l
            ld   l,a
            ld   a,(PSSK+1)
            or   l
            ld   (ix+LZS),a
            call RNDL4
TYPERAID:   ld   (ix+TYPE),T_PIRAT
            ld   (ix+ACTN),0
            ld   (ix+RCO),0
            ld   (ix+OSUBJ),#FF
            ld   (ix+SUBJ),#FF
            ld   hl,(SDW)
            ld   (ix+RAND),l
            ld   (ix+RAND+1),h
            call RNDL8
            ld   a,(PSUEK+1)
            or   l
            ld   l,a
            ld   a,(PMUEK+1)
            ld   h,a
            ld   a,l
            cp   h
            jr   c,$+4
            ld   a,h
            dec  a
            ld   (ix+ENERGY),a
            ld   (ix+RSPD),#20
            xor  a
            ld   (ix+FORSAG),a
            ld   (ix+POWOR),a
            ld   (ix+BSUBJ),#FF
            ld   (ix+TSUBJ),#FF
            ld   (SDW+2),a
            call RNDW
            ld   a,(ix+MODE)
            ld   (ix+OMODE),a
            ld   a,r
            and  #0F
            inc  a
            and  #0F
            ld   b,a
            ld   (ix+SETUP),b
            jp   TONEWORD


; Таблицы видов кораблей для определенного
; типа персонажа
INDTABK:
            dw   TPIRAT
            dw   TTRADER
            dw   TARMY
            dw   TPOLICE
            dw   THUNTER
            dw   TPIRAT
            dw   TUFO
            dw   TUFO
            dw   TOTSHEL

            include "gen/INDTAB.inc"   ; GENERATED from assets/data/ship_choice.csv (TPIRAT TTRADER TARMY TPOLICE THUNTER TUFO TOTSHEL KREYSERS)


; Генерация объектов общая
GENSHIPS:
            ld   a,%10000000
            rrca
            ld   ($-2),a
            ret  nc


PWOPK:      nop
DOPCOUNT:   ld   a,0
            dec  a
;????
            jp   p,DOPC1
            call RND
            ld   a,l
PWPKO:
GNUM:       cp   #FD
; Если не надо сейчас генерить
;?????????
            jp   c,DOPGEN
; Ишем свободное место в буфере

            call FindFreeSlot
; Если буфер полон
            ret  z
            push iy
            pop  ix
            push hl
            call RNDL4
            call NearestSunDistance
            ld   a,l
            srl  a
            srl  a
            ld   d,SINTB
            ld   e,a
            ld   a,(de)
            ld   d,a
            rrca
            rrca
            rrca
            rrca
            and  #07
            ld   c,T_PIRAT
            sub  h
            jr   c,$+3
            xor  a
            neg


;?????
;            ld   c,T_TRADER
;            jr   CHSN


; Здесь хранятся установочные данные
; по вероятностям среды генерации
            cp   #0A
VARPS:      equ  $-1
            ld   a,h
            nop
; Пират
            jr   c,.CHSN
            cp   #43
            ld   c,T_TRADER
; Мирный
            jr   c,.CHSN
            cp   #50
            ld   c,T_MILITARY
; Полиция
            jr   c,.CHSN
            cp   #50
            ld   c,T_POLICE
; Военный
            jr   c,.CHSN
            cp   #5A
            ld   c,T_LEGIONER
; Легионер
            jr   c,.CHSN
            cp   #5E
            ld   c,T_PIRAT2
; Пират неопасный
            jr   c,.CHSN
            cp   #63
            ld   c,T_UFO
; Уфо
            jr   c,.CHSN
            cp   #6B
            ld   c,T_UFO2
; Уфо враждебный
            jr   c,.CHSN
            cp   #70
            ld   c,T_HERMIT
; Отшельник
            jr   c,.CHSN
            pop  de
            ret
.CHSN
            ld   a,c
            cp   T_HERMIT
            jr   nz,.CHSN2
            ld   a,(NOSTAT)
            or   a
            jr   z,.CHSN2
            pop  de
            ret
.CHSN2
            ld   (ix+TYPE),c
            sla  c
            ld   b,0
            ld   hl,INDTABK
            add  hl,bc
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            ld   a,r
            and  7
            rla
            add  a,l
            ld   l,a
            ld   a,h
            adc  a,0
            ld   h,a
            ld   a,(hl)
            ld   (ix+INDI),a
            inc  hl
            ld   l,(hl)

;?????????
;            ld   l,0

            ld   (ix+MSPD),l
            ld   h,d
            pop  de
; Тип корабля
            ld   l,a
            ld   a,(ix+TYPE)
            cp   T_UFO
            jr   z,.GSS99
            cp   T_UFO2
            jr   z,.GSS99
            ld   a,#80
            sub  h
            ld   h,a
            ld   a,#80
            sub  d
            srl  a
            add  a,25
            cp   h
; Если корабль просто летит
            jp   c,.GSS1
            ld   a,c
            cp   #10
            jp   z,.GSS1
.GSS99
; Масштабный коэфициент типа корабля
            ld   a,l
            call ObjectSize
            ld   a,h
            push af
; Он сделал гиппер прыжок сюда
; генерим координаты прыжка
            call RNDK1
            sra  h
            rr   l
            ld   (ix+4),l
            ld   (ix+5),h
            push hl
            call RNDK2
            sra  h
            rr   l
            ld   (ix+2),l
            ld   (ix+3),h
            push hl
            call RNDK3
            sra  h
            rr   l
            ld   (ix+0),l
            ld   (ix+1),h
            pop  de
            pop  bc
            pop  af
            ex   af,af'
            ld   a,26
            exx
; Создаем спрайт телепорта
            ld   hl,NWTEL
            call NewVoxelSprite
            ld   a,1
            ld   (EXPL+1),a
            ld   a,(CEX+1)
            cp   26
            jr   nc,$+7
            ld   a,26
            ld   (CEX+1),a

; Он летит в направлении к планете
            ld   (ix+MODE),C_GOPLANET

            call TONEARPLAN

; На генерация других данный
            jp   .GSH29

; Генерим данные координат когда корабль
; просто летел
.GSS1
            ld   a,r
            bit  1,a
            jp   z,.GSH1

            call FindObjectByType
            ld   a,(STATGEN)
            and  a
            jp   z,.GSH1
            ld   a,(ix+TYPE)
            cp   T_PIRAT
; Если пират то он не может генериться из
; станции
            jp   z,.GSH1
            cp   T_PIRAT2
            jp   nc,.GSH1


            ld   d,T_STATION
            call FindObjectByType
            jr   z,.GSH1

            ld   l,(iy+0)
            ld   h,(iy+1)
            ld   (ix+0),l
            ld   (ix+1),h
            ld   l,(iy+2)
            ld   h,(iy+3)
            ld   a,r
            and  1
            inc  a
            ld   d,a
            ld   e,#80
            add  hl,de
            ld   (ix+2),l
            ld   (ix+3),h
            ld   l,(iy+4)
            ld   h,(iy+5)
            ld   (ix+4),l
            ld   (ix+5),h
            ld   (ix+MODE),C_GOPLANET
; Делаем нос как будто он вылетает из
; станции
            ld   (ix+ALFA),#40
            ld   (ix+BETA),0
            ld   (ix+GAMA),0
            jp   .GSH299


; Летим к планете
.GSH1

            ld   hl,(SNX+1)
            ld   de,(SNY+1)
            ld   bc,(SNZ+1)
            ABSHL
            ABSDE
            ABSBC
.GSH23
            sla  l
            rl   h
            jp   m,.GSH21
            sla  e
            rl   d
            jp   m,.GSH22
            sla  c
            rl   b
            jp   p,.GSH23
            rr   b
            rr   c
            and  a
.GSH22
            rr   d
            rr   e
            and  a
.GSH21
            rr   h
            rr   l
            res  1,b
            res  1,d
            res  1,h
            ld   a,(SNX+2)
            and  a
            jp   p,$+10
            NEGHL
            ld   a,(SNY+2)
            and  a
            jp   p,$+10
            NEGDE
            ld   a,(SNZ+2)
            and  a
            jp   p,$+10
            NEGBC

            push bc
            push de
            push hl
            call RNDK1
            ld   a,h
            and  #0F
            jr   nz,$+4
            or   #07
            bit  7,h
            jr   z,$+3
            cpl
            ld   h,a
            pop  de
            add  hl,de
            ld   (ix+0),l
            ld   (ix+1),h
            call RNDK2
            ld   a,h
            and  #0F
            jr   nz,$+4
            or   #07
            bit  7,h
            jr   z,$+3
            cpl
            ld   h,a
            pop  de
            add  hl,de
            ld   (ix+2),l
            ld   (ix+3),h
            call RNDK3
            ld   a,h
            and  #03
            jr   nz,$+4
            or   #01
            bit  7,h
            jr   z,$+3
            cpl
            ld   h,a
            pop  de
            add  hl,de
            ld   (ix+4),l
            ld   (ix+5),h


            ld   (ix+MODE),C_GOPLANET
            call RNDK3
            ld   a,l
            and  7
            ld   l,a
            ld   a,(KOLPLANET+1)
            or   a
            jr   z,.GSH29
            ld   h,a
            ld   a,l
            cp   h
            jr   c,$+6
            srl  a
            jr   $-5

            ld   (ix+PLAN),a
            ld   iy,PLANETES-12
            ld   de,12
            ld   b,a
            inc  b
            add  iy,de
            djnz $-2

            call TOPLAN
; Углы

.GSH29
            ld   (ix+ALFA),0
.GSH299
            call RNDL7
            ld   a,l
            and  #55
            ld   l,a
            ld   a,h
            and  %00101010
            and  l
PSSK:       or   #20
            ld   (ix+LZS),a
            ld   (ix+ACTN),0
            ld   (ix+RCO),0
            ld   (ix+OSUBJ),#FF
            ld   (ix+SUBJ),#FF
            ld   hl,(SDW)
            ld   (ix+RAND),l
            ld   (ix+RAND+1),h
            call RNDL8
            ld   e,h
            ld   a,l
PSUEK:      or   50
PMUEK:      ld   h,100
            cp   h
            jr   c,$+4
            ld   a,h
            dec  a
            ld   (ix+ENERGY),a
            ld   a,e
            or   #A0
; Максимальный уровень энергии
            ld   (ix+MENE),a
            ld   a,#20
            ld   (ix+RSPD),a
            xor  a
            ld   (SDW+2),a
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jr   nz,.GNR1
            ld   (ix+ENERGY),240
            ld   (ix+MENE),250
            ld   a,(ix+ALFA)
            ld   (ix+RAND),a
            ld   a,(ix+BETA)
            ld   (ix+RAND+1),a
            ld   a,(ix+GAMA)
            ld   (ix+MSPD),a
.GNR1
            ld   a,(ix+TYPE)
            cp   T_UFO
            jr   nz,.GNR19
            cp   7
            jr   nz,.GNR19
            ld   (ix+ENERGY),240
            ld   (ix+MENE),250
            ld   (ix+LZS),110
            ld   (ix+FORSAG),0
.GNR19
            ld   a,(ix+MODE)
            ld   (ix+OMODE),a
            ld   a,r
            and  #0F
            inc  a
            and  #0F
            ld   c,a
            ld   a,(ix+TYPE)
            cp   T_HERMIT
            jr   nz,$+10
            ld   a,r
            and  #40
            jr   z,$+4
            set  2,c

            ld   (ix+SETUP),c
            ld   (ix+POWOR),0
            ld   (ix+BSUBJ),#FF
            ld   (ix+TSUBJ),#FF

;???????????
;            ld   a,#C9
;            ld   (PWOPK),a

TONEWORD:
            ld   a,(ix+INDI)
            call ObjectSize
            ld   a,h
            cp   4
            ld   a,2
            jr   nz,$+3
            dec  a
            ld   (ix+SPT),a
            jp   NewOrder


; Расчет углов к ближайшей планете
; если ближайшей нет то берется первая
; если планет нет то FZ-ON
;inix-вектор объекта
;retb-BETA,c-GAMA
TONEARPLAN:
            ld   iy,PLANETES
            ld   a,(KOLPLANET+1)
            or   a
            ret  z
            ld   b,a
            ld   de,12

            call VISPLAN
            jr   c,$+10
            add  iy,de
            djnz $-7
            ld   iy,PLANETES

; К планете в iy
TOPLAN:
            ld   l,(iy)
            ld   h,(iy+1)
            ld   e,(iy+2)
            ld   d,(iy+3)
            ld   (AG1+1),de
            ld   (AG1+4),hl
            ld   l,(iy+4)
            ld   h,(iy+5)
            ld   e,(iy+6)
            ld   d,(iy+7)
            ld   (AG2+1),de
            ld   (AG2+4),hl
            ld   l,(iy+8)
            ld   h,(iy+9)
            ld   e,(iy+10)
            ld   d,(iy+11)
            ld   (AG3+1),de
            ld   (AG3+4),hl
; Преобразов. дв.слово в слово
            call TOWORD
            push bc
            push de
            ld   e,(ix)
            ld   d,(ix+1)
            ld   c,(ix+2)
            ld   b,(ix+3)
            exx
            pop  hl
            pop  de
            ld   c,(ix+4)
            ld   b,(ix+5)
            exx
            jp   ONWAY2

; Проебразование двойного слова в слово
; всех трех аргументов параллельно
TOWORD:
;rethl,de,bc-слова

AG1:        ld   de,0
            ld   hl,0
            call MOD_DEHL
            ld   a,h
            and  #80
            or   d
            or   e
            jr   z,$+5
            ld   hl,#7F00
            push hl

AG2:        ld   de,0
            ld   hl,0
            call MOD_DEHL
            ld   a,h
            and  #80
            or   d
            or   e
            jr   z,$+5
            ld   hl,#7F00
            push hl

AG3:        ld   de,0
            ld   hl,0
            call MOD_DEHL
            ld   a,h
            and  #80
            or   d
            or   e
            jr   z,$+5
            ld   hl,#7F00
            ld   b,h
            ld   c,l
            pop  de
            pop  hl

            ld   a,(AG1+1)
            or   a
            jp   p,$+10
            NEGHL
            ld   a,(AG2+1)
            or   a
            jp   p,$+10
            NEGDE
            ld   a,(AG3+1)
            or   a
            ret  p
            NEGBC
            ret

MOD_DEHL:
            bit  7,d
            ret  z
            ld   a,d
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            ld   a,h
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            ld   bc,1
            add  hl,bc
            dec  bc
            EXD
            adc  hl,bc
            EXD
            ret
