;==============================================================================
; BODY3D - просмотр 3D-моделей кораблей (оверлей D3D)
;
; Где живёт: оверлей D3D.C, ORG #C000, страница PG3D (#14); собирается: DATA3D, XR2, BODY3D, CLPXR1, OBJX.
;
; Что делает: окно "Корабль"/"Скиммер"/"3D обзор": InitClip3D задаёт границы клиппирования, DrawShip3D
; вращает и выводит модель (XR2 + CLPXR1), DrawShipMenu выводит список кораблей, DrawShipInfo - описание
; (тексты TISHIP/TISKIM). ShipIndex/ShipListFrom - текущий корабль и начало списка.
; Вызывается из OBR.asm (WSHIP, WISHIP...) через PAGES PG3D. См. GAME_DESIGN 2.2.
;==============================================================================

InitClip3D   ; orig: INITCLP
; Установка границ клиппирования 3D-вывода
;  Инициализация пределов клиппирования
; h-yh,l-xh;hl-YHXH
; d-yl,e-xl;de-YLXL

            ld   a,h
            inc  a
            srl  a
            ld   (MDY+1),a

            ld   a,l
            inc  a
            srl  a
            ld   (MDX+1),a

            ld   (YHXH+1),hl
            ld   (YLXL+1),de
            ld   a,l
            ld   l,e
            ld   e,a
            ld   (YHXL+1),hl
            ld   (YLXH+1),de
            ld   a,h
            ld   (YH1+1),a
            ld   (YH2+1),a
            ld   (YH3+1),a
            ld   (YH4+1),a
            ld   (YH5+1),a
            inc  a
            ld   (YH6+1),a
            ld   a,d
            ld   (YL1+1),a
            ld   (YL2+1),a
            ld   (YL3+1),a
            ld   (YL4+1),a
            ld   (YL5+1),a
            ld   a,e
            ld   (XH1+1),a
            ld   (XH2+1),a
            ld   (XH3+1),a
            ld   (XH4+1),a
            ld   (XH5+1),a
            ld   (XH6+1),a
            inc  a
            ld   (XH7+1),a
            ld   a,l
            ld   (XL1+1),a
            ld   (XL2+1),a
            ld   (XL3+1),a
            ld   (XL4+1),a
            ld   (XL5+1),a
            ld   (XL6+1),a
            ret


DrawShip3D   ; orig: OSHIP
; Цикл вывода 3D-модели корабля
;  Вывод кораблей
;  Цикл вывода 3D
; a-T3D
            dec  a
            jr   nz,.OSH1
            ld   a,8
            ld   (ALFA),a
            xor  a
            ld   (ALFA+2),a
            ld   a,(ALFA+1)
            add  a,2
            ld   (ALFA+1),a
            jr   .OSH2
.OSH1
            ld   a,(ALFA)
            add  a,1
            ld   (ALFA),a
            ld   a,(ALFA+1)
            add  a,2
            ld   (ALFA+1),a
            ld   a,(ALFA+2)
            add  a,3
            ld   (ALFA+2),a
.OSH2
            call Ren3d
            ei
            call MERZ
            ret


AddModelZ   ; orig: SETZET
; Прибавить смещение к координате Z объекта
;  Приращает коорд. зет для окбъекта
; hl-смещение z
            ld   de,(ZET)
            add  hl,de
            ld   a,h
            cp   2
            ret  c
            cp   #10
            ret  nc
            ld   (ZET),hl
            ret


;  Вывод всего меню кораблей

DrawShipMenu   ; orig: NSHIP_
; Вывод всего меню кораблей
; A'-кол. пунктов пропустить
; a-T3D
; h-BT2 =0 покупка, =1 продажа
            push hl
            push af
            ld   a,ET
            ld   (TD1),a
            ld   hl,#0800
            ld   (Cord),hl
            ld   hl,TSHIP
            call OutText

            ld   hl,#1800
            ld   (Cord),hl

; A'-индекс с которого выводить корабли в
;  Меню, зав. от уровня

            pop  af
            dec  a
            ld   hl,NAMSH
            jr   nz,$+5
            ld   hl,NAMSK
            pop  af
            or   a
            jr   z,.I1
            push hl
            ex   af,af'
            ld   c,a
            ex   af,af'
            ld   a,c
; Смотрим если номер на рохлю то дадим
; Ей вывестись
            cp   6
            jr   nz,$+7
            ld   a,CR
            ld   (TD1),a

            ld   a,c
            inc  a
            call FindTextByIndex1
            dec  hl
            ld   a,(hl)
            ld   (hl),ET
            EXD
            pop  hl
            ex   af,af'
            ld   (ShipListFrom+1),a
            call PrintTextByIndex1
            ex   af,af'
            ld   (de),a
            jr   .I2
.I1
            ex   af,af'
;  Запомнить номер с которого все корабли
            ld   (ShipListFrom+1),a
            call PrintTextByIndex1
.I2
            ld   a,(Cord+1)
            sub  #18
            rrca
            rrca
            rrca
            and  #1F
            inc  a
            ex   af,af'
            ret

CountShipLines   ; orig: ISHIPI
; Подсчёт строк описания корабля
;  Подсчет строк
; a-T3D
            ld   hl,TISHIP
            dec  a
            jr   nz,$+5
            ld   hl,TISKIM
            ld   a,(ShipIndex+1)
            ld   c,a
            ld   a,(ShipListFrom+1)
            add  a,c
            call FindTextByIndex
            call CountTextLines
            ret


InitShipView   ; orig: ISHIP
; Подготовка вывода корабля
;  Подготовка инициализация вывода корабл
; h-yh,l-xh;hl-YHXH
; d-yl,e-xl;de-YLXL
; DE'-коорд. окна
; a-T3D-0-ships, 1-skimmers
            push af
            call InitClip3D
            exx
            call MTBXX2
            pop  bc

ShipIndex   ; orig: SHIPIND
; Номер показываемого корабля (самомодиф.)
            ld   a,0
;  Прибавим номер с которого весь список
;  Показывает корабли

ShipListFrom   ; orig: FROMS
; Номер, с которого показывается список
            add  a,0
            add  a,a
            add  a,a
            dec  b
            jr   nz,$+4
            add  a,28
            ld   (Indexx),a

            ret


DrawShipInfo   ; orig: SHIPI
; Вывод информации о корабле
;  Вывод инфо о корабле
; a-T3D
; hl-номер строки
            push hl
            ld   hl,TISHIP
            dec  a
            jr   nz,$+5
            ld   hl,TISKIM
            ld   a,(ShipIndex+1)
            ld   c,a
            ld   a,(ShipListFrom+1)
            add  a,c
            call FindTextByIndex
            pop  de
            ld   bc,#0800
            call PrintFromLine
            ret
