;==============================================================================
; OBR - обработчики окон: корабли, справка, настройки, карта, новости, торговля, оборудование
;
; Где живёт: основной образ STATIONF.C (ORG #6300 цепочка BODYOCUR, OBR, OBR2).
;
; Для каждого окна три части: W<имя> - описатель-обработчик (при нажатии в области окна),
; W<имя>_ - процедура вывода (Outwin/BLACKW), N<имя>/I<имя>/F_Sxx - выбор пункта/индекс/реакция на огонь.
; Окна: WSHIP/WDSHIP/WISHIP (корабли), WHELP/WHELPL (справка), WINF/WINFS (информация),
; WSETS/WSETG (настройки среды и игры), WMAP/WPLAN (карта и планеты), WNEWS, WABON/WFOTO (абоненты),
; WERR, WMISS1/2, WTWR (товары), WWKRB/WWSKM (оборудование), WSOH/WWOS (сохранить/загрузить),
; WHIDE (системное меню), WWELCOME. Короткие метки там - соглашение исходного автора.
; Таблица соглашений и переименований: docs/STATION_LABELS.md.
;==============================================================================

;--------------------------------
; Обработчик событий объектов окон
; Передаются
; Номер объекта в de
; a-CODE of key,1-left,0-right
;--------------------------------
; После обработчика сразу идет шоу
; Процедура
;--------------------------------
; Вывод объектов и инфы в них
;--------------------------------


; Продажа покупка кораблей
WSHIP
; Переход если курсор в области окна
            jp   WSHIPC
; Если было действие в области окна
; Нажатие кнопки мыши
            call WindowHandler1
            ret  c
            dec  a
; Если это действие кнопкой огонь
            jr   z,F_S29
; Если это действие кнопкой отмена
            call EraseObject
; Если отменой по другой части
            jr   nz,F_S28
; Если отменой по верхней инфо линии
; То удаление окна
ERASH
            ld   hl,DoNothing
            ld   (TaskCall+1),hl
            ld   de,(BSDEL_+1)
            call CloseObject
            ld   de,(WDSHIP_+1)
            call CloseObject
            ld   de,(WISHIP_+1)
            call CloseObject
            ld   de,(BTSHIP_+1)
            call CloseObject
            ld   de,(BBSHIP_+1)
            jp   CloseObject
; Если отменой по всему окну кроме верхней
; Линии. обычно скролл
F_S28
            ret

; Если огнем по всему окну
; Обычно выбор чего то
F_S29
            call HideCursor
            PAGES PG3D
            ld   a,(NSHIP+1)
            cp   #FF
            jr   z,$+5
            ld   (ShipIndex+1),a
            PAGES__NOARG
            ld   hl,0
            ld   (IISH+1),hl
            call ShowCursorBack
            ld   a,1
            ld   (WSHIPZ+1),a
            ret

; Если просто курсор в области окна
WSHIPC
            ld   de,#1E1B
            ld   hl,WSHIP_
NSHIP
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NSHIP+1),a
            ret


; Эта часть необходима для вывода окна
; И в окне
WSHIP_
; Вывод пунктов названий кораблей
            ld   hl,0
            call OutWindow

            xor  a
            ld   (Mode+1),a
            ld   a,#FF
            ld   (NSHIP+1),a
            ld   a,36
            ld   (TabStop1+1),a

            ld   a,(BT2+1)
            or   a
            jr   z,.U0
            ld   a,(T3D+1)
            or   a
            ld   a,(SHIP)
            jr   z,$+5
            ld   a,(SKIMMER)
            jr   .U01
.U0
            call PlanetInfoHere
            dec  l
            ld   a,l
            add  a,a
            ld   e,a
            ld   d,0
            ld   hl,SHIPDAT
            add  hl,de
            ld   a,(T3D+1)
            or   a
            jr   z,$+3
            inc  hl
            ld   a,(hl)
.U01
            ex   af,af'
            PAGES PG3D
            ld   a,(BT2+1)
            ld   h,a
            ld   a,(T3D+1)
            call DrawShipMenu
            PAGES__NOARG
            ex   af,af'
            ld   (WSHIPC+2),a
            ret


; Демо корабля
WDSHIP
            jp   .WDSHIPC
            call WindowHandler3
            ret  c
            dec  a
            jr   z,.F_S30
            call EraseObject
            jr   nz,$+9
            ld   hl,DoNothing
            ld   (TaskCall+1),hl
            ret

            PAGES PG3D
            ld   hl,#0020
            call AddModelZ
            PAGES__NOARG
            ret
.F_S30
            PAGES PG3D
            ld   hl,#FFE0
            call AddModelZ
            PAGES__NOARG
            ret
.WDSHIPC
            ret

; Служит если необходимо перед выводом
; Окна проверить его существование вообще
WDSHI_P
            ld   de,WDSHIP_
            call FindDeskObject
            ret  nz
WDSHIP_
            ld   hl,0
            call SetBlackWindowPage
            call OutWindow
            call SetWhiteWindow
            ld   hl,(WDSHIP_+1)
            call TestWindowOut
            ld   hl,DoNothing
            jr   nc,$+5
            ld   hl,WSHIPZ
            ld   (TaskCall+1),hl
            EXD
            ADDHLHL 3
            EXD
            exx
            PAGES PG3D
            ld   de,0

            ld   a,(WinEndX+1)
            sub  13
            ld   l,a
            ld   a,(WinEndY+1)
            sub  14
            ld   h,a
            ld   a,(T3D+1)
            call InitShipView

            ld   hl,(TaskCall+1)
            ld   de,DoNothing
            SUB_DE
            jr   z,$+9
            halt
            ld   a,(T3D+1)
            call DrawShip3D

            PAGES__NOARG
            ret


W_Z2
; Выставляет окно на верх
            ld   a,(Unclick+1)
            or   a
            ret  nz
            ld   (WSHIPZ+1),a
            call HideCursor
            call WSHIP_
            call WISHI_P
            ld   de,(WDSHIP_+1)
            call ActivateObject
            call WDSHI_P
            jp   ShowCursorBack

WSHIPZ
; Задача вывода кораблей
            ld   a,0
            or   a
            jr   nz,W_Z2
            call LastDeskObject
            ld   de,WDSHIP_
            SUB_DE
; Не последний на столе
            ret  nz
            call HideCursor
            call ClearWindowChars
            halt
            PAGES PG3D
T3D
            ld   a,0
            call DrawShip3D
            PAGES__NOARG
            call ShowCursorBack
            ret


; Инфо корабля
WISHIP
            jp   WISHIPC
            call WindowHandler1
            ret  c
            dec  a
            jr   z,F_S31
            call EraseObject
            ret  z

            call IISHI

            ld   hl,NISH
            ld   (PROOUT+1),hl
IKISH
            ld   hl,0
            ld   (EINDX+1),hl
            ld   a,#08
IISH
            ld   hl,0
            call ScrollList
            ld   (IISH+1),hl
            ret
F_S31
            ret
WISHIPC
            ret


WISHI_P
            ld   de,WISHIP_
            call FindDeskObject
            ret  nz
WISHIP_
            ld   hl,0
            call OutWindow
            ld   hl,(IISH+1)
            call NISH
            ret
NISH
            PAGES PG3D
            ld   a,(T3D+1)
            call DrawShipInfo
            PAGES__NOARG
            ret
IISHI
            PAGES PG3D
            ld   a,(T3D+1)
            call CountShipLines
            PAGES__NOARG
            ld   (IKISH+1),de
            ret


WHELP
            jp   WHELPC
            call WindowHandler1
            ret  c
            dec  a
            jr   z,F_S24
            call EraseObject
            jr   nz,.F_S25
            ld   de,(WHELPL_+1)
            jp   CloseObject
.F_S25

; Скрол
            ld   hl,DHLP3
            ld   (PROOUT+1),hl
IKHLP
            ld   hl,0
            ld   (EINDX+1),hl
            ld   a,#08
IHLP
            ld   hl,0
            call ScrollList
            ld   (IHLP+1),hl

            ret
F_S24
            ret

WHELPC
            ret

WHELP_
            ld   hl,0
            call OutWindow
            call .DHLP2
            ld   hl,(IHLP+1)
            call DHLP3
            ret


.DHLP2
            ld   a,1
            ld   (Mode+1),a
            PAGES PGHLP
            call HelpDrawList
            PAGES__NOARG
            ld   (IKHLP+1),de
            ret


DHLP3
            PAGES PGHLP
            call HelpDrawItem
            PAGES__NOARG
            ret


WHELPL
; ХЕЛП
            jp   WHELPLC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S27
            call EraseObject
            jr   nz,.F_S26
            ld   de,(WHELP_+1)
            jp   CloseObject

.F_S26
            call DHLPL2

            ld   de,(WHELPLC+1)
            ld   a,(NHLPL+1)
            call DeleteLastMark
            ld   a,#FF
            ld   (NHLPL+1),a

            ld   hl,DHLPL3
            ld   (PROOUT+1),hl
            ld   hl,HKOL-1
            ld   (EINDX+1),hl
            ld   a,#08
IHLPL
            ld   hl,0
            call ScrollList
            ld   (IHLPL+1),hl
            ret
F_S27
            ld   a,(IHLPL+1)
            inc  a
            ret  z
            dec  a
            ld   c,a
            ld   hl,0
            ld   (IHLP+1),hl
            ld   a,(NHLPL+1)
            add  a,c
            ex   af,af'
            PAGES PGHLP
            ex   af,af'
            call HelpSetIndex
            PAGES__NOARG
            call HideCursor
            call WHELP_
            call WHELPL_
            call ShowCursorBack
            ret


WHELPLC
            ld   de,#1E0B
            ld   hl,WHELPL_
NHLPL
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NHLPL+1),a
            ret

WHELPL_
; Вывод пунктов установки
            ld   hl,0
            call OutWindow

            ld   a,#FF
            ld   (NHLPL+1),a

            call DHLPL2

            ld   hl,(IHLPL+1)
DHLPL3

            PAGES PGHLP
            call HelpDrawLine
            PAGES__NOARG
            ex   af,af'
            ld   (WHELPLC+2),a
            ret

DHLPL2
            xor  a
            ld   (Mode+1),a
            ret


; Инфо о вооружении
WINF
            jp   WINFC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S16
            call EraseObject
            ret  z
            call DINF2
            ld   hl,DINF3
            ld   (PROOUT+1),hl
IKOL
            ld   hl,0
            ld   (EINDX+1),hl
            ld   a,#08
IINF
            ld   hl,0
            call ScrollList
            ld   (IINF+1),hl
            ret
F_S16
            ret
WINFC
            ret
WIN_F
            ld   de,WINF_
            call FindDeskObject
            ret  nz
WINF_
            ld   hl,0
            call OutWindow
            call DINF2
            ld   hl,(IINF+1)
            call DINF3
            ret

DINF2
            ld   a,1
            ld   (Mode+1),a
ARMINF
            ld   a,0
            ld   hl,TARMI
            call FindTextByIndex
            ld   (AINF+1),hl
            call CountTextLines
            ld   (IKOL+1),de
            ret

DINF3
            EXD
AINF
            ld   hl,0
            ld   bc,#0800
            call PrintFromLine
            ret


WSETS
; Сетап среды
            jp   WSETSC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S10
            call EraseObject
            jr   nz,.F_S10_1
            ld   bc,SETSI
            ld   de,SETSD
            jp   CodesToPorts
.F_S10_1
            call DSETS2

            ld   de,(WSETSC+1)
            ld   a,(NSETS+1)
            call DeleteLastMark
            ld   a,#FF
            ld   (NSETS+1),a

            ld   hl,DSETS3
            ld   (PROOUT+1),hl
            ld   hl,SSKOL-1
            ld   (EINDX+1),hl
            ld   a,#08
ISETS
            ld   hl,0
            call ScrollList
            ld   (ISETS+1),hl
            ret
F_S10
            ld   a,(ISETS+1)
            inc  a
            ret  z
            dec  a
            ld   c,a
            ld   a,(NSETS+1)
            add  a,c
            ld   c,a
            ld   b,0
            ld   hl,SETSI
            add  hl,bc
            ld   a,c
            cp   4
            jr   nc,.W_S2
            ld   a,(hl)
            cp   "Y"
            ld   a,"N"
            jr   z,$+4
            ld   a,"Y"
            ld   (hl),a
            jr   .W_S3
.W_S2
            ld   a,(hl)
            ld   (hl),"_"
            call HideCursor
            push hl
            push bc
            call WSET_S
            call ShowCursorBack
; Чтение клавы до первой клавиши
            pop  bc
.W_S4
            call ReadKey
            cp   29
            jr   z,.W_S4
; Если не cs
            ld   e,a
            ld   a,c
            cp   10
            jr   c,.W_S1
            cp   12
            ld   a,e
            jr   nc,.W_S5
            cp   "0"
            jr   c,.W_S4
            cp   "8"
            jr   nc,.W_S4
            jr   .W_S1
.W_S5
            cp   "0"
            jr   c,.W_S4
            cp   "2"
            jr   nc,.W_S4
.W_S1
            pop  hl
            ld   (hl),e
.W_S3
            call HideCursor
            call WSET_S
            call ShowCursorBack
            ret

WSETSC
            ld   de,#1E0B
            ld   hl,WSETS_
NSETS
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NSETS+1),a
            ret

WSET_S
            ld   de,WSETS_
            call FindDeskObject
            ret  nz
WSETS_
; Вывод пунктов установки
            ld   hl,0
            call OutWindow

            ld   a,#FF
            ld   (NSETS+1),a

            call DSETS2

            ld   hl,(ISETS+1)
DSETS3
            call .DSETS1
            ex   af,af'
            ld   (WSETSC+2),a
            ret
.DSETS1

; hl-индекс вывода
            EXD

; Корд.Y на самую первую строку
            ld   hl,#0800
            ld   (Cord),hl

            ld   hl,TSETS1
            push de
            ld   a,e
            call PrintTextByIndex1
            ld   a,8
            ld   (Cord+1),a
; Индекс вывода
            pop  hl

; Данные состояния
            ld   bc,SETSI
            add  hl,bc
            xor  a
            ex   af,af'
W_SS1
            ld   a,(TabStop1+1)
            ld   (Cord),a
            ld   a,(hl)
            or   a
            ret  z
            call PrintSpecialChar
            inc  hl
            ex   af,af'
            inc  a
            ex   af,af'
            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z
            ld   a,(WinEndY+1)
            ld   c,a
            ld   a,(Cord+1)
            add  a,8
            cp   c
            ret  nc
            ld   (Cord+1),a
            jp   W_SS1


DSETS2
            xor  a
            ld   (Mode+1),a
            ld   a,66
            ld   (TabStop1+1),a
            ret


WMAP
            jp   .WMAPC
            call WindowHandler2
            ret  c
            dec  a
            jp   z,.F_S14
            ld   a,(KFC)
            and  a
            jp   m,.W_K5
            call EraseObject
            jr   nz,.W_K5
            ld   de,(BPERE_+1)
            call CloseObject
            ld   de,(BMEM_+1)
            call CloseObject
            ld   de,(BMAR_+1)
            call CloseObject
            ld   de,(BCMAR_+1)
            call CloseObject
            ld   de,(BNMEM_+1)
            call CloseObject
            ld   de,(BCENT_+1)
            call CloseObject
            ld   de,(BAWAY_+1)
            call CloseObject
            ld   de,(BNABO_+1)
            call CloseObject
            ld   de,(WINFS_+1)
            call CloseObject
            ld   de,(WPLAN_+1)
            call CloseObject

            ld   hl,DoNothing
            ld   (TaskCall+1),hl
            ret
.W_K5
            ld   l,(ix+0)
            ld   h,(ix+1)

            ADDHLHL 3
            EXD
            ld   a,(ix+2)
            ld   b,a
            srl  b
            srl  b
            ld   c,a
            add  a,a
            add  a,a
            add  a,c
            add  a,b
            rra
            ld   c,a

            ld   a,(ix+3)
            rlca
            rlca
            ld   b,a
            ld   hl,(Mcoord)
            ld   a,h
            sub  d
            ld   d,a
            ld   a,l
            sub  e
            sub  c
            ld   hl,#00F8
            jr   c,.K_T1
            sub  c
            ld   l,8
            jr   nc,.K_T1
            ld   l,0
.K_T2
            ld   a,d
            sub  b
            ld   h,#F8
            jr   c,$+4
            ld   h,#08
.K_T1
            EXD

            ld   hl,(EYEX)
            ld   bc,(KCORD)

            ld   a,h
            ld   h,c
            ld   c,a

            push de
            bit  7,e
            ld   d,0
            jr   z,$+4
            ld   d,#FF
            or   a
            adc  hl,de
            jp   p,$+6
            SUB_DE
            pop  de

            ld   a,h
            ld   h,c
            ld   c,a

            ld   a,h
            ld   h,b
            ld   b,l
            ld   l,a

            push de
            ld   a,e
            ld   e,d
            ld   d,a
            bit  7,e
            ld   d,0
            jr   z,$+4
            ld   d,#FF
            or   a
            adc  hl,de
            jp   p,$+6
            SUB_DE
            pop  de

            ld   a,b
            ld   b,h
            ld   h,l
            ld   l,a
            ld   (EYEX),hl

            ld   hl,(KCORD)
            SUB_BC
            ld   a,1
            jr   nz,$+3
            xor  a
            ld   (W_K2+1),a

            ld   (KCORD),bc

            push ix
            call .SHOWK
            pop  ix

            call ReadFireCancel
            rra
            jp   c,.W_K5

            ret


.F_S14
            PAGE_ PGKRT

            ld   a,(WinBeginX+1)
            add  a,5
            ld   l,a
            ld   a,(WinBeginY+1)
            add  a,13
            ld   h,a
            call ChooseStar
            PAGE___NOARG


            call HideCursor
            call .WK1
            call SaveWindowParams
            call WINF_S
            call RestoreWindowParams
            ld   de,(WPLAN_+1)
            call ActivateIfOnDesk
            call WPLA_N
            call ShowCursorBack

            ret
.WMAPC
            ret

.SHOWK
; Вывести карту
            call HideCursor
            call .WK1
            halt
            jp   ShowCursorBack


; Вывод в окне карты
.WK1
            ld   hl,(WMAP_+1)
            call TestWindowOut
            ret  nc
            call ClearWindowChars

WK2
            ld   hl,(WMAP_+1)
            call TestWindowOut
            ret  nc

            dec  l
            dec  h
            dec  l
            dec  h
            dec  h
            ADDHLHL 3
            EXD
            ADDHLHL 3
            EXD
            ld   (BXKRT),hl
            PAGES PGKRT
W_K4
            ld   a,0
            and  a
            call nz,MTBXX2_
W_K2
            ld   a,0
            and  a
            call nz,GenerateMapTiles

; h-yh,l-xh;hl-YHXH
; d-yl,e-xl;de-YLXL
            ld   de,0
            ld   a,(WinEndX+1)
            sub  13
            ld   l,a
            ld   a,(WinEndY+1)
            sub  14
            ld   h,a

W_K6
            ld   a,0
            and  a
            call nz,InitLineClip
            ld   a,(INVERSE)
            call DrawGalaxyMap
            PAGES__NOARG
            xor  a
            ld   (W_K4+1),a
            ld   (W_K6+1),a
            ret
WMAP_
; Сама карта в крупном масштабе
            ld   hl,0
            call SetBlackWindowPage
            call OutWindow
            call SetWhiteWindow
            ld   a,1
            ld   (W_K2+1),a
            ld   (W_K4+1),a
            ld   (W_K6+1),a
            jp   WK2


WNEWS
            jp   .WNEWSC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S3
            call EraseObject
            ret  z
            ret
.F_S3
            ret
.WNEWSC
            ret

WNEWS_
            ld   hl,0
            call OutWindow
            ld   a,1
            ld   (Mode+1),a
            ld   a,(NEWS)
            ld   hl,TNEWS
            jp   PrintTextByIndex


WABON
            jp   WABONC             ; На обраб. курсор в обл
; Обработчик нажатия кнопкок огонь и отме
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S1
            call EraseObject
            jr   nz,.F_S1_1
; Деструктор
            ld   de,(WFOTO_+1)
            jp   CloseObject
.F_S1_1

; Обработчик отмены по окну
            ret
.F_S1
; Обработчик огня по окну
            ret
WABONC
; "Куроср в области объекта"
; ix=adr вектора описателя
            ld   de,#1E1B
            ld   hl,WABON_
NABON
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NABON+1),a
            call HideCursor
            call WFOT_O
            call ShowCursorBack
            ret


WABON_
            ld   hl,0
            call OutWindow
            xor  a
            ld   (Mode+1),a
            ld   a,#FF
            ld   (NABON+1),a
            ld   a,80
            ld   (TabStop1+1),a
            ld   hl,TABON1
            call OutText
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,.W_N2
; Вывод абонентов,0-конец списка
; 1-Невидим,2-видим
            ld   de,ABONS
            ld   b,#FF
.W_N1
            inc  b
            ld   a,(de)
            inc  de
            dec  a
            jr   z,$-4
            jp   m,.W_N2
            ld   a,b
            ld   hl,NABONS
            call PrintTextByIndex
            ex   af,af'
            inc  a
            ex   af,af'
            jp   nc,.W_N1
.W_N2
            ex   af,af'
            ld   (WABONC+2),a
            ret


WFOTO
            jp   .WFOTOC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S15
            call EraseObject
            ret  z
            ret
.F_S15
            ret
.WFOTOC
            ret

WFOT_O
            ld   de,WFOTO_
            call FindDeskObject
            ret  nz
WFOTO_
            ld   hl,0
            call SetBlackWindow
            call OutWindow
            call SetWhiteWindow
            ld   hl,(WFOTO_+1)
            call TestWindowOut
            ret  nc
; Номер персонажа
            ld   a,(NABON+1)
            inc  a
            ret  z
            dec  a
            ld   b,a
            ld   h,#FF
            ld   de,ABONS
            inc  h
            ld   a,(de)
            inc  de
            dec  a
            jr   z,$-4
            djnz $-6
            xor  a
            srl  h
            rra
            ld   l,a
            ld   de,FOTOS
            add  hl,de
            PAGES PGFOTOS
            call DrawSpriteInWindow
            PAGES__NOARG
            ret


; Просто ошибка
WERR
            jp   .WERRC
            call WindowHandler1
            ret  c
            jp   CloseObject
.WERRC
            ret

WERR_
            ld   hl,0
            call OutWindow
NERR
            ld   a,0
            ld   hl,ERORS
            call PrintTextByIndex0
            ret


WMISS1
            jp   .WMISS1C
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S4
            call EraseObject
            ret  z
            ret
.F_S4

            ret

.WMISS1C
            ret

WMISS1_
            ld   hl,0
            call OutWindow
            ld   a,1
            ld   (Mode+1),a
            ld   hl,Txt
            jp   PrintText


WMISS2
            jp   .WMISS2C
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S5
            call EraseObject
            ret  z
            ret
.F_S5

            ret
.WMISS2C
            ret

WMISS2_
            ld   hl,0
            call OutWindow
            ld   a,1
            ld   (Mode+1),a
            ld   hl,Txt
            jp   OutText


WTWR
            jp   WTWRC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S6
            call EraseObject
            jr   nz,.W_R1
            ld   de,(BTTW_+1)
            jp   CloseObject
.W_R1
            call DTWR2

            ld   de,(WTWRC+1)
            ld   a,(NTWR+1)
            call DeleteLastMark
            ld   a,#FF
            ld   (NTWR+1),a

            ld   hl,DTWR3
            ld   (PROOUT+1),hl
            ld   hl,TKOL-1
            ld   (EINDX+1),hl
            ld   a,#20
ITWR
            ld   hl,0
            call ScrollList
            ld   (ITWR+1),hl
            ret
F_S6
; Выбор пункта
; Маркер покупки товара
            ld   a,(NTWR+1)
            inc  a
            ret  z
            ld   hl,(Mcoord)
            ld   a,(WinBeginX+1)
            sub  l
            neg
            cp   135
            ld   a,10
            jr   c,$+3
            dec  a
F_S60
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HideCursor
            call LINE_
            call WTWR_
            call ShowCursorBack
            ret
WTWRC
            ld   de,#1E23
            ld   hl,WTWR_
NTWR
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NTWR+1),a
            ret

WTWR_
; Вывод товров
            ld   hl,0
            call OutWindow
            call DTWR2
; Вывод нейм строки и всех товаров

            ld   a,#FF
            ld   (NTWR+1),a

            ld   hl,TTWR1
            call OutText
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,TW_N1
            ld   hl,(ITWR+1)

DTWR3
            call DTWR1
TW_N1
            ex   af,af'
            ld   (WTWRC+2),a
            ret

DTWR1
; hl-индекс вывода

            EXD

; Корд.Y на самую первую строку с товаром
            ld   hl,#2000
            ld   (Cord),hl

            ld   hl,TTWR2
            push de
            ld   a,e
            call PrintTextByIndex1

            ld   a,32
            ld   (Cord+1),a

; Индекс вывода
            pop  hl

            add  hl,hl
            ld   b,h
            ld   c,l

; Вывод товаров,#ff-конец списка

; Товар на станции, кол.,цена
            ld   hl,TWRS
            add  hl,bc
            EXD

; Товар у игрока, кол. старая цена
            ld   hl,TWRI
            add  hl,bc
            xor  a
            ex   af,af'
.W_T1
            ld   a,(TabStop1+1)
            ld   (Cord),a
            ld   a,(de)
            inc  a
            ret  z

            ex   af,af'
            inc  a
            ex   af,af'

            dec  a
            and  #7F
            jr   nz,$+9
            RST_ "-"
            jr   $+8
            ld   c,a
            ld   b,0
            call PrintNumber

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z


            ld   a,(de)
            inc  de
            rla
            jr   nc,$+12

            ld   a,109
            ld   (Cord),a

            RST_ 254

            ld   a,(TabStop2+1)
            ld   (Cord),a
            ld   a,(de)
            inc  de
            ld   c,a
            ld   b,0
            call PrintNumber

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

            ld   a,(TabStop3+1)
            ld   (Cord),a
            ld   a,(hl)
            and  #7F
            inc  a
            ret  z
            dec  a
            jr   nz,$+9
            RST_ "-"
            jr   $+8
            ld   c,a
            ld   b,0
            call PrintNumber

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

            ld   a,(hl)
            inc  hl
            rla
            jr   nc,$+12
            ld   a,134
            ld   (Cord),a
            RST_ 254

            ld   a,(TabStop4+1)
            ld   (Cord),a
            ld   c,(hl)
            ld   b,0
            inc  hl
            call PrintNumber

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

            ld   a,(WinEndY+1)
            ld   c,a
            ld   a,(Cord+1)
            add  a,8
            cp   c
            ret  nc
            ld   (Cord+1),a
            jp   .W_T1
DTWR2
; Дополн.процедуры для подготовки
; Вывода в окно товаров
;   push ix:callRANDTT:popix
            xor  a
            ld   (Mode+1),a
            ld   a,96
            ld   (TabStop1+1),a
            ld   a,114
            ld   (TabStop2+1),a
            ld   a,136
            ld   (TabStop3+1),a
            ld   a,154
            ld   (TabStop4+1),a
            ld   a,176
            ld   (TabStop5+1),a
            ret


WWKRB
            jp   WWKRBC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S7
            call EraseObject
            jr   nz,WK_1
; Деструктор
DE_1
            ld   de,(BBUY_+1)
            call CloseObject
            ld   de,(BTRD_+1)
            call CloseObject
            ld   de,(WINF_+1)
            call CloseObject
            ret
WK_1
            call DWKRB2

; Удаляем последний марк
            ld   de,(WWKRBC+1)
            ld   a,(NWKRB+1)
            call DeleteLastMark
            ld   a,#FF
            ld   (NWKRB+1),a

            ld   hl,DWKRB3
            ld   (PROOUT+1),hl
            ld   hl,WKKOL-1
            ld   (EINDX+1),hl
            ld   a,#18
IWKRB
            ld   hl,0
            call ScrollList
            ld   (IWKRB+1),hl
            ret
F_S7
            ld   a,(NWKRB+1)
            inc  a
            ret  z
            dec  a
            ld   l,a
            ld   a,(IWKRB+1)
            add  a,l
            ld   l,a
            ld   a,(ARMINF+1)
            cp   l
            jr   z,.SDWK             ; Сделка
            ld   a,l
            ld   (ARMINF+1),a
            ld   hl,0
            ld   (IINF+1),hl
            call HideCursor
            call WIN_F
            call WWKR_B
            call ShowCursorBack
            ret
.SDWK
BT1
            ld   a,0
            or   a
            ld   a,5
            jr   z,$+3
            inc  a
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HideCursor
            call LINE_
            call WWKRB_
            call ShowCursorBack
            ret


WWKRBC
            ld   de,#1E1B
            ld   hl,WWKRB_
NWKRB
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NWKRB+1),a
            ret

WWKR_B
            ld   de,WWKRB_
            call FindDeskObject
            ret  nz
WWKRB_
; Вывод вооружение корблей
            ld   hl,0
            call OutWindow

            ld   a,#FF
            ld   (NWKRB+1),a

            call DWKRB2
; Вывод нейм строки и всех товаров


            ld   hl,TWKRB1
            call OutText
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,WK_N1
            ld   hl,(IWKRB+1)

DWKRB3
            call DWKRB1
WK_N1
            ex   af,af'
            ld   (WWKRBC+2),a
            ret

DWKRB1
; hl-индекс вывода
; Reta'-кол. выведенных строк
            EXD

            ld   hl,CENS
            push hl
            ld   a,(SHIP)
            push af
            ld   hl,KRBARM
            push hl
            ld   hl,TONNS
            push hl
            ld   hl,WKRBI
            push hl
            ld   hl,TWKRB2

W_K9
; Корд.Y на самую первую строку с товаром
            ld   bc,#1800
            ld   (Cord),bc

            push de
            ld   a,e
            call PrintTextByIndex1

            ld   a,#18
            ld   (Cord+1),a

; Индекс вывода
            pop  bc

; Вооруж у игрока, кол.
            pop  hl
            add  hl,bc
            EXD

            sla  c
            rl   b
            push bc
            exx
            pop  bc
            pop  hl
            add  hl,bc
            EXD
            sla  c
            rl   b
            pop  hl
            add  hl,bc
            EXD
            exx

            pop  af
            ld   (_KRBNUM+1),a

; Вывод вооруж.,#ff-конец списка

; Вооруж на станции, цена
            pop  hl
            add  hl,bc
            EXD
; Счетчик на количество выведенных строк
            xor  a
            ex   af,af'
W_K1
            ld   a,(TabStop1+1)
            ld   (Cord),a

            ex   af,af'
            inc  a
            ex   af,af'

            ld   a,(hl)
            inc  hl
            cp   #80
            ret  z

            and  a
            jp   p,$+4
            cpl
            and  a
            jr   nz,$+9
            RST_ "-"
            jr   $+8
            ld   c,a
            ld   b,0
            call PrintNumber

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

; ЦЕНА
            ld   a,(TabStop2+1)
            ld   (Cord),a
            ld   a,(de)
            ld   c,a
            inc  de
            ld   a,(de)
            ld   b,a
            inc  de
            xor  a
            call PrintNumberPad

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

; ВЕС
            ld   a,(TabStop3+1)
            add  a,4
            ld   (Cord),a

            exx
LEV1
            ld   a,0
            cp   (hl)
            inc  hl
            jr   nc,.LV1
            inc  hl
            exx
            RST_ "-"
            jr   .LV2
.LV1
            ld   a,(hl)
            inc  hl
            exx
            ld   c,a
            ld   b,0
            call PrintNumber
.LV2
            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z


            ld   a,(TabStop4+1)
            add  a,4
            ld   (Cord),a

            exx
            EXD
            push hl
_KRBNUM
            ld   a,0
            or   a
            jp   m,._I1

            rept 4
            cp   (hl)
            inc  hl
            jr   z,._I1
            endr
            scf
._I1
            ld   a,251
            call c,PrintGlyph

            pop  hl

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

            ld   bc,4
            add  hl,bc

            EXD
            exx
            ld   a,(WinEndY+1)
            ld   c,a
            ld   a,(Cord+1)
            add  a,8
            cp   c
            ret  nc
            ld   (Cord+1),a
            jp   W_K1

DWKRB2
; Допоплн.процедуры для подготовки
; Вывода в окно вооружения
            xor  a
            ld   (Mode+1),a
            ld   a,116
            ld   (TabStop1+1),a
            ld   a,134
            ld   (TabStop2+1),a
            ld   a,156
            ld   (TabStop3+1),a
            ld   a,174
            ld   (TabStop4+1),a
            call PlanetInfoHere
            ld   a,l
            ld   (LEV1+1),a
            ret


WWSKM
            jp   WWSKMC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S8
            call EraseObject
            jp   z,DE_1             ; На деструктор
            call DWKRB2

            ld   de,(WWSKMC+1)
            ld   a,(NWSKM+1)
            call DeleteLastMark
            ld   a,#FF
            ld   (NWSKM+1),a

            ld   hl,DWSKM3
            ld   (PROOUT+1),hl
            ld   hl,WSKOL-1
            ld   (EINDX+1),hl
            ld   a,#18
IWSKM
            ld   hl,0
            call ScrollList
            ld   (IWSKM+1),hl
            ret
F_S8
            ld   a,(NWSKM+1)
            inc  a
            ret  z
            dec  a
            ld   l,a
            ld   a,(IWSKM+1)
            add  a,l
            add  a,WKKOL
            ld   l,a
            ld   a,(ARMINF+1)
            cp   l
            jr   z,.SDWS             ; Сделка
            ld   a,l
            ld   (ARMINF+1),a
            ld   hl,0
            ld   (IINF+1),hl
            call HideCursor
            call WIN_F
            call WWSK_M
            call ShowCursorBack
            ret
.SDWS
            ld   a,(BT1+1)
            or   a
            ld   a,7
            jr   z,$+3
            inc  a
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HideCursor
            call LINE_
            call WWSKM_
            call ShowCursorBack
            ret


WWSKMC
            ld   de,#0F1B
            ld   hl,WWSKM_
NWSKM
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NWSKM+1),a
            ret

WWSK_M
            ld   de,WWSKM_
            call FindDeskObject
            ret  nz
WWSKM_
; Вывод вооружение корблей
            ld   hl,0
            call OutWindow
            call DWKRB2
; Вывод нейм строки и всех товаров

            ld   a,#FF
            ld   (NWSKM+1),a

            ld   hl,TWKRB1
            call OutText
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,WS_N1
            ld   hl,(IWSKM+1)

DWSKM3
            call DWSKM1
WS_N1
            ex   af,af'
            ld   (WWSKMC+2),a
            ret

DWSKM1
; hl-индекс вывода
            EXD
            ld   hl,CENS1
            push hl
            ld   a,(SKIMMER)
            push af
            ld   hl,SKMARM
            push hl
            ld   hl,TONSS
            push hl
            ld   hl,WSKMI
            push hl
            ld   hl,TWSKM1
            jp   W_K9


WSOH
            jp   .WSOHC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S12
            call EraseObject
            ret  z
            ret
.F_S12
            call CloseObject
            ld   a,(NSOH+1)
; [glue] SAVE: item 0..4 of the window "В позицию N" -> file SAVE1..SAVE5 (the 1999 code of this
; function was not part of the sources; the demo had it in the older image)
            inc  a
            ret  z                      ; #FF: nothing selected
            ld   hl,TIME
            jp   DiskSlotSave
.WSOHC
            ld   de,#2803
            ld   hl,WSOH_
NSOH
            ld   a,#FF
            call MarkRowFixed
            ret  z
            ld   (NSOH+1),a
            ret

WSOH_
; Окно покажет позиции сохранения
            ld   hl,0
            call OutWindow

            ld   a,#FF
            ld   (NSOH+1),a
            xor  a
            ld   (Mode+1),a
            ld   hl,TSOH1
            jp   OutText


WWOS
            jp   .WWOSC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S13
            call EraseObject
            ret  z
            ret
.F_S13
            call CloseObject
            ld   a,(NWOS+1)
; [glue] LOAD: item 0..4 of "С позиции N" -> SAVE1..SAVE5 by the launcher: the station is reloaded and
; takes the record exactly like after a landing (LaunchStationSlot, launcher.asm)
            inc  a
            ret  z
            ld   (STATE_SLOT),a         ; (file SAVEn is read by the launcher stub after the station image is loaded)
            jp   LaunchStationSlot
.WWOSC
            ld   de,#2803
            ld   hl,WWOS_
NWOS
            ld   a,#FF
            call MarkRowFixed
            ret  z
            ld   (NWOS+1),a
            ret

WWOS_
; Окно покажет позиции сохранения
            ld   hl,0
            call OutWindow

            ld   a,#FF
            ld   (NWOS+1),a
            xor  a
            ld   (Mode+1),a
            ld   hl,TWOS1
            jp   OutText


WHIDE
            jp   .WHIDEC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S9
            call EraseObject
            ret  z
            ret
.F_S9
            call CloseObject
            ld   a,(NHIDE+1)
            inc  a
            ret  z
            dec  a
            jp   z,MenuHideAll
            dec  a
            jp   z,MenuCloseWindows
            dec  a
            jp   z,MenuSaveSurround
            dec  a
            jp   z,MenuArrange
            dec  a
            jp   z,MenuSetupSurround
            dec  a
            jp   z,MenuSetupGame
            dec  a
            jp   z,MenuRestore
; Сохраниться
            ld   hl,WSOH_
            jp   OpenObject

.WHIDEC
            ld   de,#4003
            ld   hl,WHIDE_
NHIDE
            ld   a,#FF
            call MarkRowFixed
            ret  z
            ld   (NHIDE+1),a
            ret

WHIDE_
            ld   hl,0
            call OutWindow
; Обновляем переменную номера пункта
            ld   a,#FF
            ld   (NHIDE+1),a
            ld   a,1
            ld   (Mode+1),a
            ld   hl,THIDE
            jp   OutText


WSETG
; Сетап игры
            jp   WSETGC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,F_S11
            call EraseObject
            jr   nz,.F_S11_1
            ld   bc,SETGI
            ld   de,SETGD
            jp   CodesToPorts
.F_S11_1
            call DSETG2

            ld   de,(WSETGC+1)
            ld   a,(NSETG+1)
            call DeleteLastMark
            ld   a,#FF
            ld   (NSETG+1),a

            ld   hl,DSETG3
            ld   (PROOUT+1),hl
            ld   hl,SGKOL-1
            ld   (EINDX+1),hl
            ld   a,#08
ISETG
            ld   hl,0
            call ScrollList
            ld   (ISETG+1),hl
            ret
F_S11
            ld   a,(ISETG+1)
            inc  a
            ret  z
            dec  a
            ld   c,a
            ld   a,(NSETG+1)
            add  a,c
            ld   c,a
            ld   b,0
            ld   hl,SETGI
            add  hl,bc
            ld   a,c
            and  a
            jr   nz,.W_G2
            ld   a,(hl)
            cp   "Y"
            ld   a,"N"
            jr   z,$+4
            ld   a,"Y"
            ld   (hl),a
            jr   .W_G3
.W_G2
            ld   a,(hl)
            ld   (hl),"_"
            call HideCursor
            push hl
            push bc
            call WSETG_
            call ShowCursorBack
; Чтение клавы до первой клавиши
            pop  bc
.W_G4
            call ReadKey
            cp   29
            jr   z,.W_G4
; Если не cs
            pop  hl
            ld   (hl),a
.W_G3
            call HideCursor
            call WSET_G
            call ShowCursorBack

            ret

WSETGC
            ld   de,#1E0B
            ld   hl,WSETG_
NSETG
            ld   a,#FF
            call MarkRowStretch
            ret  z
            ld   (NSETG+1),a
            ret

WSET_G
            ld   de,WSETG_
            call FindDeskObject
            ret  nz
; Установки игровые
WSETG_
; Вывод пунктов установки
            ld   hl,0
            call OutWindow

            ld   a,#FF
            ld   (NSETG+1),a

            call DSETG2

            ld   hl,(ISETG+1)

DSETG3
            call .DSETG1
            ex   af,af'
            ld   (WSETGC+2),a
            ret
.DSETG1

; hl-индекс вывода
            EXD

; Корд.Y на самую первую строку
            ld   hl,#0800
            ld   (Cord),hl

            ld   hl,TSETG1
            push de
            ld   a,e
            call PrintTextByIndex1
            ld   a,8
            ld   (Cord+1),a
; Индекс вывода
            pop  hl

; Данные состояния
            ld   bc,SETGI
            add  hl,bc
            jp   W_SS1-2

DSETG2
            xor  a
            ld   (Mode+1),a
            ld   a,110
            ld   (TabStop1+1),a
            ret


WINFS
            jp   .WINFSC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S20
            call EraseObject
            ret  z
            ret
.F_S20
            ret
.WINFSC
            ret

WINF_S
            ld   de,WINFS_
            call FindDeskObject
            ret  nz
WINFS_
; Окно покажет инфу и системе
            ld   hl,0
            call OutWindow

            xor  a
            ld   (Mode+1),a
            ld   hl,TINFS1
            call OutText

            ld   hl,#0831
            ld   (Cord),hl

            ld   hl,(FUEL)
            ld   a,h
            and  a
            jr   nz,$+4
            ld   a,l
            rra

            ld   c,a
            ld   b,0
            xor  a
            call PrintNumberPad


; Растояние
            ld   de,(WHERE)
            ld   bc,(WHERE+2)
            exx
            ld   de,(PLACE)
            ld   bc,(PLACE+2)
            exx
            PAGES PGKRT
            call StarDistance
            ld   c,a
            ld   b,0
            PAGES__NOARG
            ld   hl,#1031
            ld   (Cord),hl
            ld   a,#FF
            cp   c
            jr   nz,$+9
            RST_ "-"
            jr   $+6
            xor  a
            call PrintNumberPad


; Генерим имя звезды и государства
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            PAGES PGKRT
            call NAME
            ld   hl,(WHERE)
            call FindStateAtMap
            ex   af,af'
            PAGES__NOARG

; Вывод государства
            ld   hl,#2800
            ld   (Cord),hl
            ld   hl,TGOST
            ex   af,af'
            call PrintTextByIndex

; Вывод звезды
            ld   hl,#3000
            ld   (Cord),hl
            ld   hl,TNAME
            call OutText

; Планета
            PAGES PGKRT
            ld   hl,#3822
            ld   (Cord),hl
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            ld   a,(WPLANET)
            call PrintPlanetName
            PAGES__NOARG


            ld   a,(WPLANET)
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
; Проверка государства
            call PlanetInfo

            and  a
            jr   nz,$+17
            ld   hl,#6000
            ld   (Cord),hl
            ld   hl,TINFS2
            call OutText
            jp   .U_9

            exx
            ld   hl,#4019
            ld   (Cord),hl
            exx

            push af
            call PrintPlanetInfo
            pop  bc

            PAGES PGKRT

; Вывод планет
            ld   a,0
            ld   hl,#6000
            ld   (Cord),hl
            push af
            push bc
            call PrintPlanetNameHere
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,.U_7
            ld   hl,#6020
            ld   (Cord),hl
            push af
            push bc
            call PrintPlanetNameHere
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,.U_7
            ld   hl,#6040
            ld   (Cord),hl
            push af
            push bc
            call PrintPlanetNameHere
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,.U_7
            ld   hl,#6800
            ld   (Cord),hl
            push af
            push bc
            call PrintPlanetNameHere
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,.U_7
            ld   hl,#6820
            ld   (Cord),hl
            push af
            push bc
            call PrintPlanetNameHere
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,.U_7
            ld   hl,#6840
            ld   (Cord),hl
            call PrintPlanetNameHere


.U_7
            PAGES__NOARG

.U_9
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            PAGES PGKRT
            call NAME
            ld   hl,(PLACE)
            call FindStateAtMap
            ex   af,af'
            PAGES__NOARG

            ld   hl,#8000
            ld   (Cord),hl
            ld   hl,TGOST
            ex   af,af'
            call PrintTextByIndex

            ld   hl,#8800
            ld   (Cord),hl
            ld   hl,TNAME
            call OutText


            PAGES PGKRT
            ld   hl,#9022
            ld   (Cord),hl
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            call PrintPlanetName
            PAGES__NOARG


; Проверка государства
            call PlanetInfoHere

            jr   z,.U_10

            exx
            ld   hl,#9819
            ld   (Cord),hl
            exx

            push af
            call PrintPlanetInfo
            pop  bc

.U_10
            ret


; Показ планет системы
WPLAN
            jp   .WPLANC
            call WindowHandler1
            ret  c
            dec  a
            jp   z,.F_S22
            call EraseObject
            jr   nz,.F_S23
            ld   hl,DoNothing
            ld   (TaskCall+1),hl
.F_S23
            ret
.F_S22
; Выбор планеты

            ld   a,(WPLANET)
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            call PlanetInfo
            ret  z
            ex   af,af'

            ld   hl,(WPLAN_+1)
            xor  a
            call ObjFieldAddr
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a

; HL-коорд. окна
; A-кол. планет
            PAGES PGKRT
            ex   af,af'
            call ChoosePlanet
            PAGES__NOARG
            call HideCursor
            call WINF_S
            call WPLA_N
            call ShowCursorBack
            ret
.WPLANC
            ret

WPLA_N
            ld   de,WPLAN_
            call FindDeskObject
            ret  nz
WPLAN_
; Сама карта в крупном масштабе
            ld   hl,0
            call SetBlackWindowPage
            call OutWindow
            call SetWhiteWindow
            ld   hl,(WPLAN_+1)
            call TestWindowOut
            ld   hl,DoNothing
            jr   nc,.WN1
            ld   hl,WPLANZ
.WN1
            ld   (TaskCall+1),hl

            call PlanetCount
            ret  z

            ex   af,af'
            PAGES PGKRT
            ex   af,af'
            call PlanetsSelectionKind
            PAGES__NOARG

            ret


W_Z
; Выставляет окно на верх
            ld   a,(Unclick+1)
            or   a
            ret  nz
            xor  a
            ld   (WPLANZ+1),a
            ld   de,(WPLAN_+1)
            call ActivateObject
            call HideCursor
            call WPLA_N
            jp   ShowCursorBack

WPLANZ
; Задача вывода планет
            ld   a,0
            or   a
            jr   nz,W_Z

            ld   a,%10000000
            rrca
            ld   ($-2),a
            ret  nc

            call LastDeskObject
            ld   de,WPLAN_
            SUB_DE
; Не последний на столе
            ret  nz

            call PlanetCount

            push af

            xor  a
            ld   hl,(WPLAN_+1)
            call ObjFieldAddr
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            ld   hl,(Mcoord)
            srl  h
            srl  l
            srl  h
            srl  l
            srl  h
            srl  l
            ld   a,l
            inc  a
            sub  e
            jr   c,.NJ1
            jr   z,.NJ22
            dec  a
            cp   c
            jr   nc,.NJ1
.NJ22
            ld   a,h
            inc  a
            sub  d
            jr   c,.NJ1
            jr   z,.NJ2
            dec  a
            cp   b
            jr   nc,.NJ1
.NJ2
            call CursorRestoreSafe
            ld   a,1
            jr   $+3
.NJ1
            xor  a
            ld   (.NJ3+1),a
            push de
            call ClearWindowChars
            pop  de
            PAGES PGKRT

            pop  af

            call AnimatePlanets
            PAGES__NOARG
.NJ3
            ld   a,0
            or   a
            call nz,CursorDrawSafe
            ret


; Инфо приветствие
WWELCOME
            jp   .WWELCOMEC
            call WindowHandler1
            ret  c
            dec  a
            ret  z
            jp   EraseObject
.WWELCOMEC
            ret

WWELCOME_
            ld   hl,0
            call OutWindow
            ld   a,1
            ld   (Mode+1),a
            ld   hl,WELCOME
            call OutText
            push hl
; Модель станции
            call PlanetInfoHere
            ld   a,l
            dec  a
            ld   hl,MODELS
            call PrintTextByIndex
            pop  hl
            call OutText
            push hl
; Система, планета
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            PAGES PGKRT
            call NAME
            ld   hl,TNAME
            call OutText
            ld   a,(Cord)
            add  a,4
            ld   (Cord),a
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            call PrintPlanetName
            PAGES__NOARG
            pop  hl
            call OutText
            push hl
; Цена прибытия
            call PlanetInfoHere
            ld   a,l
            add  a,a
            add  a,a
            add  a,l
            ld   c,a
            ld   b,0
            call PrintNumber
            pop  hl
            call OutText
            ret
