;==============================================================================
; OBR2 - обработчики кнопок станции
;
; Где живёт: основной образ STATIONF.C (цепочка BODYOCUR, OBR, OBR2).
;
; B<имя> - обработчик кнопки (начинается с jp $+3, подменяется при активации), B<имя>_ - дескриптор вывода
; (ld hl,0 / jp OutButton). Из названий и комментариев: BMEM - запомнить звезду, BNMEM - следующая звезда
; в памяти, BMAR - проложить маршрут, BCMAR - стереть маршрут, BCENT - центр карты, BPERE - перелёт на
; другую систему (копирует WHERE в PLACE и идёт на StationStart), BNABO - следующий персонаж, BEXIT -
; вылет ([glue]: LaunchFlight), BMAP, BNEWS, BHELP, BBUY/BTRD, BWKRB/BWSKM/BKRB/BSKM (оборудование).
; Подробнее: GAME_DESIGN 1.3, 4, 5.4; соглашения об именах: docs/STATION_LABELS.md.
;==============================================================================

;--------------------------------
; Обработчик событий объектов кнопок
; Передаются
; Номер объекта в de
; a-CODE of key,1-left,0-right
;--------------------------------
; После обработчика сразу идет шоу
; Процедура
;--------------------------------
; Вывод объектов и инфы в них
;--------------------------------


BSDEL
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
; Сделка
            ld   a,(NSHIP+1)
            inc  a
            ret  z

            PAGES PG3D
            ld   a,(NSHIP+1)
            ld   (ShipIndex+1),a
            PAGES__NOARG

BT2
            ld   a,0
            or   a
            ld   c,1
            jr   z,$+3
            inc  c
            ld   a,(T3D+1)
            or   a
            ld   a,c
            jr   z,$+4
            add  a,2
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HideCursor
            call LINE_
            call ShowCursorBack
; Закрыть все

            ld   de,(WSHIP_+1)
            call CloseObject
            call ERASH
            xor  a
            ld   (Unclick+1),a
            ret


BSDEL_
            ld   hl,0
            jp   OutButton


BTSHIP
            jp   $+3
            ld   hl,$+6
            call ButtonHandler
            ret  c
            PAGES PG3D
            xor  a
            ld   (ShipIndex+1),a
            PAGES__NOARG
            ld   a,1
            ld   (WSHIPZ+1),a
            ld   a,(T3D+1)
            or   a
            ld   a,(SHIP)
            jr   z,$+5
            ld   a,(SKIMMER)
            inc  a
            EXD
            ld   de,(BBSHIP_+1)
            jr   z,Bb
            ld   a,1
            ld   (BT2+1),a
            EXD
            jp   PressButtonPair
BTSHIP_
            ld   hl,0
            jp   OutButton


BBSHIP
            jp   $+3
            ld   hl,$+6
            call ButtonHandler
            ret  c
            PAGES PG3D
            xor  a
            ld   (ShipIndex+1),a
            PAGES__NOARG
            ld   a,1
            ld   (WSHIPZ+1),a
Bb
            xor  a
            ld   (BT2+1),a
            ld   hl,(BTSHIP_+1)
            jp   PressButtonPair
BBSHIP_
            ld   hl,0
            jp   OutButton


BABON
; de-number
; Proc obrab
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
; Обработчик
            ld   hl,WFOTO_
            call OpenObject
            ld   hl,WABON_
            jp   OpenObject

BABON_
            ld   hl,0
            jp   OutButton


BHELP
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   hl,WHELP_
            call OpenObject
            ld   hl,WHELPL_
            jp   OpenObject
BHELP_
            ld   hl,0
            jp   OutButton


BNEWS
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   hl,WNEWS_
            jp   OpenObject

BNEWS_
            ld   hl,0
            jp   OutButton


BMAP
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a

            ld   hl,BPERE_
            call OpenObject
            ld   hl,BNABO_
            call OpenObject
            ld   hl,WINFS_
            call OpenObject
            ld   hl,BMEM_
            call OpenObject
            ld   hl,BMAR_
            call OpenObject
            ld   hl,BCMAR_
            call OpenObject
            ld   hl,BNMEM_
            call OpenObject
            ld   hl,BCENT_
            call OpenObject
            ld   hl,BAWAY_
            call OpenObject
            ld   hl,WMAP_
            call OpenObject
            ld   hl,WPLAN_
            jp   OpenObject
BMAP_
            ld   hl,0
            jp   OutButton


BBUY
            jp   $+3
            ld   hl,$+6
            call ButtonHandler
            ret  c
            xor  a
            ld   (BT1+1),a
            ld   hl,(BTRD_+1)
            jp   PressButtonPair


BBUY_
            ld   hl,0
            jp   OutButton


BTRD
            jp   $+3
            ld   hl,$+6
            call ButtonHandler
            ret  c
            ld   a,1
            ld   (BT1+1),a
            ld   hl,(BBUY_+1)
            jp   PressButtonPair

BTRD_
            ld   hl,0
            jp   OutButton


BPERE
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   hl,(WHERE)
            ld   (PLACE),hl
            ld   hl,(WHERE+2)
            ld   (PLACE+2),hl
            ld   a,(WPLANET)
            ld   (PLANET),a
            pop  hl
            jp   StationStart
BPERE_
            ld   hl,0
            jp   OutButton


; Запомнить звезду
BMEM
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
; Установка перерисовки окна карты планет
; После отжатия этой кнопки
            ld   a,1
            ld   (WPLANZ+1),a

; Поиск звезды текущей в списке памяти
            PAGES PGKRT
            call FindStarInMemory
            ex   af,af'
            PAGES__NOARG
            ex   af,af'

            jp   p,FGOT
            ld   hl,MSTARS
            ld   bc,5
            ld   a,(hl)
            inc  a
            jr   z,$+7
            dec  a
            ret  m
            add  hl,bc
            jr   $-7
            ld   de,(WHERE)
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            ld   de,(WHERE+2)
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            ld   a,(WPLANET)
            ld   (hl),a
B_M1
            call HideCursor
            call WINF_S
            call WMAP_
            call ShowCursorBack
            ret
BMEM_
            ld   hl,0
            jp   OutButton

; Забыть звезду
FGOT
            DEC_DE 3
            ld   a,#FF
            ld   (de),a
            jr   B_M1


; Проложить маршрут
BMAR
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a

; Поиск звезды текущей в маршрутном
; Списке
            PAGES PGKRT
            call FindStarInRoute
            ex   af,af'
            PAGES__NOARG
            ex   af,af'

            jp   p,FGOT2
; Включение звезды
            ld   hl,(AWAYS)
; hl-адр. звезды с которой идет
; Постройка
            ld   a,(hl)
            inc  a
            jr   z,.B_R1
            ld   de,5
            add  hl,de
; hl-адр. следующей
; Проверим если это конец списка
            ld   a,(hl)
            inc  a
            ret  m                  ; Нет места
            jr   z,.B_R1             ; Нашли свободное
; Ищем первое свободное место
            ld   bc,5
            push hl
            add  hl,bc
            ld   a,(hl)
            inc  a
            jp   m,.B_R2             ; Нет места
            jr   nz,$-6
            pop  de
            push hl
            add  hl,bc
            SUB_DE
            ld   b,h
            ld   c,l
            add  hl,de
            dec  hl
            EXD
            pop  hl
            dec  hl
            lddr
            inc  hl
; hl-покажет на свободное место
.B_R1
; Вписываем на свободное
            ld   de,(WHERE)
            ld   (AWAYS),hl
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            ld   de,(WHERE+2)
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            ld   a,(WPLANET)
            ld   (hl),a
            jr   B_M19
; Нет места
.B_R2
            pop  hl
            ret
BMAR_
            ld   hl,0
            jp   OutButton

; Забыть звезду в маршруте
FGOT2
            DEC_DE 3
; Адрес стираемой звезды
            ld   h,d
            ld   l,e
            ld   bc,5
            add  hl,bc
            ld   a,(hl)
            inc  a
            jp   m,.B_R3
            push de
            push hl
            add  hl,bc
            ld   a,(hl)
            inc  a
            jp   p,$-3
            pop  de
            SUB_DE
            ld   b,h
            ld   c,l
            EXD
            pop  de
            ldir
.B_R3
            ld   bc,0-5
            add  hl,bc
            ld   (hl),#FF
B_M19
            PAGES PGKRT
            call MarkRouteLine
            PAGES__NOARG
            jp   B_M1


; Стереть маршрут
BCMAR
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a

            ld   hl,WAY
; Вписали дрес звезды кот. нет но первой
; С кот. постройка будет
            ld   (AWAYS),hl
            ld   bc,5
            ld   a,(hl)
            cp   #80
            jr   z,$+7
            ld   (hl),#FF
            add  hl,bc
            jr   $-8
            jr   B_M19

BCMAR_
            ld   hl,0
            jp   OutButton


; След. звезда в списке памяти
BNMEM
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a

            ld   a,(MSTARS)
            inc  a
            ret  z

.B_E1
            ld   hl,MSTARS
            ld   de,5
.B_E2
            add  hl,de
            ld   a,(hl)
            inc  a
            jp   p,$+6
            ld   hl,MSTARS
            jr   z,.B_E2
            ld   (.B_E1+1),hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jr   B_E10

BNMEM_
            ld   hl,0
            jp   OutButton


; След. персонаж в списке памяти
BNABO
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a

.B_E7
            ld   hl,ABONS

.B_E8
            inc  hl
            ld   a,(hl)
            and  a
            jp   p,$+6
            ld   hl,ABONS
            jr   z,.B_E8
            ld   (.B_E7+1),hl
            ld   a,(hl)
            and  a
            ret  z
            ld   de,ABONS
            sbc  hl,de
            ADDHLHL 2
            ld   de,PSTARS
            add  hl,de
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jr   B_E10

BNABO_
            ld   hl,0
            jp   OutButton


BCENT
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a

            ld   de,(PLACE)
            ld   hl,(PLACE+2)
B_E10
            PAGE_ PGKRT
            call CenterMap
            PAGE___NOARG

            jp   B_M1
BCENT_
            ld   hl,0
            jp   OutButton


BAWAY
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret

            ld   a,1
            ld   (WPLANZ+1),a
            PAGES PGKRT
            call FindStarInRoute
            ex   af,af'
            PAGES__NOARG
            ex   af,af'

            ret  m                  ; Звезда не на линии
            DEC_DE 3
            ld   (AWAYS),de
            jp   B_M1
BAWAY_
            ld   hl,0
            jp   OutButton


BTTW
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   a,11
            jp   F_S60

BTTW_
            ld   hl,0
            jp   OutButton


BMISS
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   hl,WMISS2_
            call OpenObject
            ; ??? А%   hl,WMISS1_
            jp   OpenObject

BMISS_
            ld   hl,0
            jp   OutButton


BTWR
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   hl,BTTW_
            call OpenObject
            ld   hl,WTWR_
            jp   OpenObject
BTWR_
            ld   hl,0
            jp   OutButton


BWKRB
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            xor  a
            ld   (ARMINF+1),a
            ld   hl,WINF_
            call OpenObject
            ld   hl,BTRD_
            call OpenObject
            ld   hl,BBUY_
            call OpenObject
            ld   hl,WWKRB_
            jp   OpenObject

BWKRB_
            ld   hl,0
            jp   OutButton


BWSKM
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   a,WKKOL
            ld   (ARMINF+1),a
            ld   hl,WINF_
            call OpenObject
            ld   hl,BTRD_
            call OpenObject
            ld   hl,BBUY_
            call OpenObject
            ld   hl,WWSKM_
            jp   OpenObject

BWSKM_
            ld   hl,0
            jp   OutButton


BKRB
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            xor  a
            call SET1_

            ld   hl,BSDEL_
            call OpenObject
            ld   hl,BBSHIP_
            call OpenObject
            ld   hl,BTSHIP_
            call OpenObject
            ld   hl,WSHIP_
            call OpenObject
            ld   hl,WISHIP_
            call OpenObject
            ld   hl,WDSHIP_
            jp   OpenObject
BKRB_
            ld   hl,0
            jp   OutButton


SET1_
            ld   (T3D+1),a
            ld   a,1
            ld   (WSHIPZ+1),a
            ld   a,#FF
            ld   (NSHIP+1),a
            xor  a
            ld   (BT2+1),a
            ld   hl,(BBSHIP_+1)
            ld   a,4
            call ObjFieldAddr
            set  0,(hl)
            ld   hl,(BTSHIP_+1)
            ld   a,4
            call ObjFieldAddr
            res  0,(hl)
            PAGES PG3D
            xor  a
            ld   (ShipIndex+1),a
            PAGES__NOARG
            ret


BSKM
            jp   $+3
            ld   hl,$+7
            call ButtonHandler
            ret
            ld   a,1
            call SET1_

            ld   hl,BSDEL_
            call OpenObject
            ld   hl,BBSHIP_
            call OpenObject
            ld   hl,BTSHIP_
            call OpenObject
            ld   hl,WSHIP_
            call OpenObject
            ld   hl,WISHIP_
            call OpenObject
            ld   hl,WDSHIP_
            jp   OpenObject
BSKM_
            ld   hl,0
            jp   OutButton


BEXIT
            jp   $+3
            call ButtonHandler
            ret  c
            ld   a,(KFC)
            and  a
            ret  m
; Exit to XAS
; [glue] original: jp EXAS (back to the ZASM/XAS debugger); the game launches the flight part instead
            IFDEF TEST_ENDING           ; build.py --test-ending: the button starts the ending instead (the real trigger is unknown, see docs)
            jp   LaunchEnding
            ELSE
            jp   LaunchFlight
            ENDIF

BEXIT_
            ld   hl,0
            jp   OutButton


LINE
            jp   $+3
            call z,MoveSizeObject
            ret  c
            push af
            call Unclick
            call ActivateObject
            jp   z,.LN_1
            call CursorRestoreSafe
            ld   de,$+5
            push de
            jp   (hl)
            call CursorDrawSafe
.LN_1
            pop  af
            ret

LINE_
            ld   hl,0
            ld   a,1
            ld   (Mode+1),a
            call OutLine
            inc  hl
            ld   a,(hl)
            ld   hl,Lintxt
            call FindTextByIndex

            call OutText             ; Status
            push hl
            ld   a,(STATUS)
            rlca
            rlca
            rlca
            and  7
            cp   4
            jr   c,$+4
            ld   a,3
            ld   hl,Tstatus
            call FindTextByIndex
            call OutText             ; Witch status
            pop  hl
            call OutText             ; Money
            ld   bc,(SUMM)
            xor  a
            call PrintNumberPad
            call OutText             ; Tonash
            ld   bc,(TONN)
            ld   b,0
            call PrintNumber2
            RST_ ":"
            ld   bc,(TONN+1)
            ld   b,0
            jp   PrintNumber2
