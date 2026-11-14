;WSHIP      ■WDSHIP
;WSHIPZ     ■WISHIP
;WHELP      ■WHELPL
;WINF       ■WSETS
;WABON      ■WMAP
;WNEWS      ■WFOTO
;WERR       ■WMISS1
;WMISS2     ■WTWR
;WWKRB      ■WWSKM
;WSOH       ■WWOS
;WHIDE      ■WSETG
;WINFS      ■WPLAN
;WPLANZ     ■WWELCOME









;--------------------------------
; ОБРАБОТЧИК СОБЫТИЙ ОБЪЕКТОВ ОКОН
; ПЕРЕДАЮТСЯ
; НОМЕР ОБЪЕКТА В de
;a-CODE OF KEY,1-LEFT,0-RIGHT
;--------------------------------
; ПОСЛЕ ОБРАБОТЧИКА СРАЗУ ИДЕТ ШОУ
; ПРОЦЕДУРА
;--------------------------------
; ВЫВОД ОБЪЕКТОВ И ИНФЫ В НИХ
;--------------------------------







; ПРОДАЖА ПОКУПКА КОРАБЛЕЙ
WSHIP:
; ПЕРЕХОД ЕСЛИ КУРСОР В ОБЛАСТИ ОКНА
            jp   WSHIPC
; ЕСЛИ БЫЛО ДЕЙСТВИЕ В ОБЛАСТИ ОКНА
; НАЖАТИЕ КНОПКИ МЫШИ
            call WINOBR1
            ret  c
            dec  a
; ЕСЛИ ЭТО ДЕЙСТВИЕ КНОПКОЙ ОГОНЬ
            jr   z,F_S29
; ЕСЛИ ЭТО ДЕЙСТВИЕ КНОПКОЙ ОТМЕНА
            call ERSOBJ
; ЕСЛИ ОТМЕНОЙ ПО ДРУГОЙ ЧАСТИ
            jr   nz,F_S28
; ЕСЛИ ОТМЕНОЙ ПО ВЕРХНЕЙ ИНФО ЛИНИИ
; ТО УДАЛЕНИЕ ОКНА
ERASH:
            ld   hl,RET_
            ld   (ZADACHA+1),hl
            ld   de,(BSDEL_+1)
            call ERSOBJ2
            ld   de,(WDSHIP_+1)
            call ERSOBJ2
            ld   de,(WISHIP_+1)
            call ERSOBJ2
            ld   de,(BTSHIP_+1)
            call ERSOBJ2
            ld   de,(BBSHIP_+1)
            jp   ERSOBJ2
; ЕСЛИ ОТМЕНОЙ ПО ВСЕМУ ОКНУ КРОМЕ ВЕРХНЕЙ
; ЛИНИИ. ОБЫЧНО СКРОЛЛ
F_S28:
            ret  

; ЕСЛИ ОГНЕМ ПО ВСЕМУ ОКНУ
; ОБЫЧНО ВЫБОР ЧЕГО ТО
F_S29:
            call HIDESCR
            PAGES PG3D
            ld   a,(NSHIP+1)
            cp   #FF
            jr   z,$+5
            ld   (SHIPIND+1),a
            PAGES__NOARG
            ld   hl,0
            ld   (IISH+1),hl
            call RETSCR
            ld   a,1
            ld   (WSHIPZ+1),a
            ret  

; ЕСЛИ ПРОСТО КУРСОР В ОБЛАСТИ ОКНА
WSHIPC:
            ld   de,#1E1B
            ld   hl,WSHIP_
NSHIP:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NSHIP+1),a
            ret  


; ЭТА ЧАСТЬ НЕОБХОДИМА ДЛЯ ВЫВОДА ОКНА
; И В ОКНЕ
WSHIP_:
; ВЫВОД ПУНКТОВ НАЗВАНИЙ КОРАБЛЕЙ
            ld   hl,0
            call Outwin

            xor  a
            ld   (Mode+1),a
            ld   a,#FF
            ld   (NSHIP+1),a
            ld   a,36
            ld   (CXTAB1+1),a

            ld   a,(BT2+1)
            or   a
            jr   z,U0
            ld   a,(T3D+1)
            or   a
            ld   a,(SHIP)
            jr   z,$+5
            ld   a,(SKIMMER)
            jr   U01
U0:
            call PINFO2
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
U01:
            ex   af,af'
            PAGES PG3D
            ld   a,(BT2+1)
            ld   h,a
            ld   a,(T3D+1)
            call NSHIP_
            PAGES__NOARG
            ex   af,af'
            ld   (WSHIPC+2),a
            ret  









; ДЕМО КОРАБЛЯ
WDSHIP:
            jp   WDSHIPC
            call WINOBR3
            ret  c
            dec  a
            jr   z,F_S30
            call ERSOBJ
            jr   nz,$+9
            ld   hl,RET_
            ld   (ZADACHA+1),hl
            ret  

            PAGES PG3D
            ld   hl,#0020
            call SETZET
            PAGES__NOARG
            ret  
F_S30:
            PAGES PG3D
            ld   hl,#FFE0
            call SETZET
            PAGES__NOARG
            ret  
WDSHIPC:
            ret  

; СЛУЖИТ ЕСЛИ НЕОБХОДИМО ПЕРЕД ВЫВОДОМ
; ОКНА ПРОВЕРИТЬ ЕГО СУЩЕСТВОВАНИЕ ВООБЩЕ
WDSHI_P:
            ld   de,WDSHIP_
            call FOBJ
            ret  nz
WDSHIP_:
            ld   hl,0
            call BLACKWP
            call Outwin
            call WHITEW
            ld   hl,(WDSHIP_+1)
            call TESTSZ
            ld   hl,RET_
            jr   nc,$+5
            ld   hl,WSHIPZ
            ld   (ZADACHA+1),hl
            EXD
            ADDHLHL 3
            EXD
            exx  
            PAGES PG3D
            ld   de,0

            ld   a,(Exw+1)
            sub  13
            ld   l,a
            ld   a,(Eyw+1)
            sub  14
            ld   h,a
            ld   a,(T3D+1)
            call ISHIP

            ld   hl,(ZADACHA+1)
            ld   de,RET_
            SUB_DE
            jr   z,$+9
            halt 
            ld   a,(T3D+1)
            call OSHIP

            PAGES__NOARG
            ret  


W_Z2:
; ВЫСТАВЛЯЕТ ОКНО НА ВЕРХ
            ld   a,(Unclick+1)
            or   a
            ret  nz
            ld   (WSHIPZ+1),a
            call HIDESCR
            call WSHIP_
            call WISHI_P
            ld   de,(WDSHIP_+1)
            call Mactive
            call WDSHI_P
            jp   RETSCR

WSHIPZ:
; ЗАДАЧА ВЫВОДА КОРАБЛЕЙ
            ld   a,0
            or   a
            jr   nz,W_Z2
            call LASTOBJ
            ld   de,WDSHIP_
            SUB_DE
; НЕ ПОСЛЕДНИЙ НА СТОЛЕ
            ret  nz
            call HIDESCR
            call CLINW
            halt 
            PAGES PG3D
T3D:
            ld   a,0
            call OSHIP
            PAGES__NOARG
            call RETSCR
            ret  






; ИНФО КОРАБЛЯ
WISHIP:
            jp   WISHIPC
            call WINOBR1
            ret  c
            dec  a
            jr   z,F_S31
            call ERSOBJ
            ret  z

            call IISHI

            ld   hl,NISH
            ld   (PROOUT+1),hl
IKISH:
            ld   hl,0
            ld   (EINDX+1),hl
            ld   a,#08
IISH:
            ld   hl,0
            call SCROL
            ld   (IISH+1),hl
            ret  
F_S31:
            ret  
WISHIPC:
            ret  


WISHI_P:
            ld   de,WISHIP_
            call FOBJ
            ret  nz
WISHIP_:
            ld   hl,0
            call Outwin
            ld   hl,(IISH+1)
            call NISH
            ret  
NISH:
            PAGES PG3D
            ld   a,(T3D+1)
            call SHIPI
            PAGES__NOARG
            ret  
IISHI:
            PAGES PG3D
            ld   a,(T3D+1)
            call ISHIPI
            PAGES__NOARG
            ld   (IKISH+1),de
            ret  









WHELP:
            jp   WHELPC
            call WINOBR1
            ret  c
            dec  a
            jr   z,F_S24
            call ERSOBJ
            jr   nz,F_S25
            ld   de,(WHELPL_+1)
            jp   ERSOBJ2
F_S25:

; СКРОЛ
            ld   hl,DHLP3
            ld   (PROOUT+1),hl
IKHLP:
            ld   hl,0
            ld   (EINDX+1),hl
            ld   a,#08
IHLP:
            ld   hl,0
            call SCROL
            ld   (IHLP+1),hl

            ret  
F_S24:
            ret  

WHELPC:
            ret  

WHELP_:
            ld   hl,0
            call Outwin
            call DHLP2
            ld   hl,(IHLP+1)
            call DHLP3
            ret  


DHLP2:
            ld   a,1
            ld   (Mode+1),a
            PAGES PGHLP
            call DHLP2_
            PAGES__NOARG
            ld   (IKHLP+1),de
            ret  




DHLP3:
            PAGES PGHLP
            call DHLP3_
            PAGES__NOARG
            ret  











WHELPL:
; ХЕЛП
            jp   WHELPLC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S27
            call ERSOBJ
            jr   nz,F_S26
            ld   de,(WHELP_+1)
            jp   ERSOBJ2

F_S26:
            call DHLPL2

            ld   de,(WHELPLC+1)
            ld   a,(NHLPL+1)
            call DELMK
            ld   a,#FF
            ld   (NHLPL+1),a

            ld   hl,DHLPL3
            ld   (PROOUT+1),hl
            ld   hl,HKOL-1
            ld   (EINDX+1),hl
            ld   a,#08
IHLPL:
            ld   hl,0
            call SCROL
            ld   (IHLPL+1),hl
            ret  
F_S27:
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
            call SETHIND
            PAGES__NOARG
            call HIDESCR
            call WHELP_
            call WHELPL_
            call RETSCR
            ret  



WHELPLC:
            ld   de,#1E0B
            ld   hl,WHELPL_
NHLPL:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NHLPL+1),a
            ret  

WHELPL_:
; ВЫВОД ПУНКТОВ УСТАНОВКИ
            ld   hl,0
            call Outwin

            ld   a,#FF
            ld   (NHLPL+1),a

            call DHLPL2

            ld   hl,(IHLPL+1)
DHLPL3:

            PAGES PGHLP
            call DHLPL1
            PAGES__NOARG
            ex   af,af'
            ld   (WHELPLC+2),a
            ret  

DHLPL2:
            xor  a
            ld   (Mode+1),a
            ret  













; ИНФО О ВООРУЖЕНИИ
WINF:
            jp   WINFC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S16
            call ERSOBJ
            ret  z
            call DINF2
            ld   hl,DINF3
            ld   (PROOUT+1),hl
IKOL:
            ld   hl,0
            ld   (EINDX+1),hl
            ld   a,#08
IINF:
            ld   hl,0
            call SCROL
            ld   (IINF+1),hl
            ret  
F_S16:
            ret  
WINFC:
            ret  
WIN_F:
            ld   de,WINF_
            call FOBJ
            ret  nz
WINF_:
            ld   hl,0
            call Outwin
            call DINF2
            ld   hl,(IINF+1)
            call DINF3
            ret  

DINF2:
            ld   a,1
            ld   (Mode+1),a
ARMINF:
            ld   a,0
            ld   hl,TARMI
            call FLIST
            ld   (AINF+1),hl
            call KOLLIN
            ld   (IKOL+1),de
            ret  

DINF3:
            EXD
AINF:
            ld   hl,0
            ld   bc,#0800
            call FROMLIN
            ret  











WSETS:
; СЕТАП СРЕДЫ
            jp   WSETSC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S10
            call ERSOBJ
            jr   nz,F_S10_1
            ld   bc,SETSI
            ld   de,SETSD
            jp   TOPORT
F_S10_1:
            call DSETS2

            ld   de,(WSETSC+1)
            ld   a,(NSETS+1)
            call DELMK
            ld   a,#FF
            ld   (NSETS+1),a

            ld   hl,DSETS3
            ld   (PROOUT+1),hl
            ld   hl,SSKOL-1
            ld   (EINDX+1),hl
            ld   a,#08
ISETS:
            ld   hl,0
            call SCROL
            ld   (ISETS+1),hl
            ret  
F_S10:
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
            jr   nc,W_S2
            ld   a,(hl)
            cp   "Y"
            ld   a,"N"
            jr   z,$+4
            ld   a,"Y"
            ld   (hl),a
            jr   W_S3
W_S2:
            ld   a,(hl)
            ld   (hl),"_"
            call HIDESCR
            push hl
            push bc
            call WSET_S
            call RETSCR
; ЧТЕНИЕ КЛАВЫ ДО ПЕРВОЙ КЛАВИШИ
            pop  bc
W_S4:
            call READKEY
            cp   29
            jr   z,W_S4
; ЕСЛИ НЕ CS
            ld   e,a
            ld   a,c
            cp   10
            jr   c,W_S1
            cp   12
            ld   a,e
            jr   nc,W_S5
            cp   "0"
            jr   c,W_S4
            cp   "8"
            jr   nc,W_S4
            jr   W_S1
W_S5:
            cp   "0"
            jr   c,W_S4
            cp   "2"
            jr   nc,W_S4
W_S1:
            pop  hl
            ld   (hl),e
W_S3:
            call HIDESCR
            call WSET_S
            call RETSCR
            ret  

WSETSC:
            ld   de,#1E0B
            ld   hl,WSETS_
NSETS:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NSETS+1),a
            ret  

WSET_S:
            ld   de,WSETS_
            call FOBJ
            ret  nz
WSETS_:
; ВЫВОД ПУНКТОВ УСТАНОВКИ
            ld   hl,0
            call Outwin

            ld   a,#FF
            ld   (NSETS+1),a

            call DSETS2

            ld   hl,(ISETS+1)
DSETS3:
            call DSETS1
            ex   af,af'
            ld   (WSETSC+2),a
            ret  
DSETS1:

;hl-ИНДЕКС ВЫВОДА
            EXD

; КОРД.Y НА САМУЮ ПЕРВУЮ СТРОКУ
            ld   hl,#0800
            ld   (Cord),hl

            ld   hl,TSETS1
            push de
            ld   a,e
            call LIST1
            ld   a,8
            ld   (Cord+1),a
; ИНДЕКС ВЫВОДА
            pop  hl

; ДАННЫЕ СОСТОЯНИЯ
            ld   bc,SETSI
            add  hl,bc
            xor  a
            ex   af,af'
W_SS1:
            ld   a,(CXTAB1+1)
            ld   (Cord),a
            ld   a,(hl)
            or   a
            ret  z
            call SPECSYM
            inc  hl
            ex   af,af'
            inc  a
            ex   af,af'
            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z
            ld   a,(Eyw+1)
            ld   c,a
            ld   a,(Cord+1)
            add  a,8
            cp   c
            ret  nc
            ld   (Cord+1),a
            jp   W_SS1


DSETS2:
            xor  a
            ld   (Mode+1),a
            ld   a,66
            ld   (CXTAB1+1),a
            ret  


















WMAP:
            jp   WMAPC
            call WINOBR2
            ret  c
            dec  a
            jp   z,F_S14
            ld   a,(KFC)
            and  a
            jp   m,W_K5
            call ERSOBJ
            jr   nz,W_K5
            ld   de,(BPERE_+1)
            call ERSOBJ2
            ld   de,(BMEM_+1)
            call ERSOBJ2
            ld   de,(BMAR_+1)
            call ERSOBJ2
            ld   de,(BCMAR_+1)
            call ERSOBJ2
            ld   de,(BNMEM_+1)
            call ERSOBJ2
            ld   de,(BCENT_+1)
            call ERSOBJ2
            ld   de,(BAWAY_+1)
            call ERSOBJ2
            ld   de,(BNABO_+1)
            call ERSOBJ2
            ld   de,(WINFS_+1)
            call ERSOBJ2
            ld   de,(WPLAN_+1)
            call ERSOBJ2

            ld   hl,RET_
            ld   (ZADACHA+1),hl
            ret  
W_K5:
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
            jr   c,K_T1
            sub  c
            ld   l,8
            jr   nc,K_T1
            ld   l,0
K_T2:
            ld   a,d
            sub  b
            ld   h,#F8
            jr   c,$+4
            ld   h,#08
K_T1:
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
            call SHOWK
            pop  ix

            call Tfire
            rra  
            jp   c,W_K5

            ret  




F_S14:
            PAGE_ PGKRT

            ld   a,(Bxw+1)
            add  a,5
            ld   l,a
            ld   a,(Byw+1)
            add  a,13
            ld   h,a
            call STARCH
            PAGE___NOARG


            call HIDESCR
            call WK1
            call STOREW
            call WINF_S
            call RESTORW
            ld   de,(WPLAN_+1)
            call Mactiv
            call WPLA_N
            call RETSCR

            ret  
WMAPC:
            ret  

SHOWK:
; ВЫВЕСТИ КАРТУ
            call HIDESCR
            call WK1
            halt 
            jp   RETSCR


; ВЫВОД В ОКНЕ КАРТЫ
WK1:
            ld   hl,(WMAP_+1)
            call TESTSZ
            ret  nc
            call CLINW

WK2:
            ld   hl,(WMAP_+1)
            call TESTSZ
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
W_K4:
            ld   a,0
            and  a
            call nz,MTBXX2_
W_K2:
            ld   a,0
            and  a
            call nz,GENKART

;h-yh,l-xh;hl-YHXH
;d-yl,e-xl;de-YLXL
            ld   de,0
            ld   a,(Exw+1)
            sub  13
            ld   l,a
            ld   a,(Eyw+1)
            sub  14
            ld   h,a

W_K6:
            ld   a,0
            and  a
            call nz,INIt
            ld   a,(INVERSE)
            call KARTOUT
            PAGES__NOARG
            xor  a
            ld   (W_K4+1),a
            ld   (W_K6+1),a
            ret  
WMAP_:
; САМА КАРТА В КРУПНОМ МАСШТАБЕ
            ld   hl,0
            call BLACKWP
            call Outwin
            call WHITEW
            ld   a,1
            ld   (W_K2+1),a
            ld   (W_K4+1),a
            ld   (W_K6+1),a
            jp   WK2



















WNEWS:
            jp   WNEWSC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S3
            call ERSOBJ
            ret  z
            ret  
F_S3:
            ret  
WNEWSC:
            ret  

WNEWS_:
            ld   hl,0
            call Outwin
            ld   a,1
            ld   (Mode+1),a
            ld   a,(NEWS)
            ld   hl,TNEWS
            jp   LIST


















WABON:
            jp   WABONC             ;НА ОБРАБ. КУРСОР В ОБЛ
; ОБРАБОТЧИК НАЖАТИЯ КНОПКОК ОГОНЬ И ОТМЕ
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S1
            call ERSOBJ
            jr   nz,F_S1_1
; ДЕСТРУКТОР
            ld   de,(WFOTO_+1)
            jp   ERSOBJ2
F_S1_1:

; ОБРАБОТЧИК ОТМЕНЫ ПО ОКНУ
            ret  
F_S1:
; ОБРАБОТЧИК ОГНЯ ПО ОКНУ
            ret  
WABONC:
;"КУРОСР В ОБЛАСТИ ОБЪЕКТА"
;ix=ADR ВЕКТОРА ОПИСАТЕЛЯ
            ld   de,#1E1B
            ld   hl,WABON_
NABON:      ld   a,#FF
            call MARKO
            ret  z
            ld   (NABON+1),a
            call HIDESCR
            call WFOT_O
            call RETSCR
            ret  


WABON_:
            ld   hl,0
            call Outwin
            xor  a
            ld   (Mode+1),a
            ld   a,#FF
            ld   (NABON+1),a
            ld   a,80
            ld   (CXTAB1+1),a
            ld   hl,TABON1
            call Outtxt
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,W_N2
; ВЫВОД АБОНЕНТОВ,0-КОНЕЦ СПИСКА
;1-НЕВИДИМ,2-ВИДИМ
            ld   de,ABONS
            ld   b,#FF
W_N1:
            inc  b
            ld   a,(de)
            inc  de
            dec  a
            jr   z,$-4
            jp   m,W_N2
            ld   a,b
            ld   hl,NABONS
            call LIST
            ex   af,af'
            inc  a
            ex   af,af'
            jp   nc,W_N1
W_N2:
            ex   af,af'
            ld   (WABONC+2),a
            ret  






















WFOTO:
            jp   WFOTOC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S15
            call ERSOBJ
            ret  z
            ret  
F_S15:
            ret  
WFOTOC:
            ret  

WFOT_O:
            ld   de,WFOTO_
            call FOBJ
            ret  nz
WFOTO_:
            ld   hl,0
            call BLACKW
            call Outwin
            call WHITEW
            ld   hl,(WFOTO_+1)
            call TESTSZ
            ret  nc
; НОМЕР ПЕРСОНАЖА
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
            call INWIN
            PAGES__NOARG
            ret  











; ПРОСТО ОШИБКА
WERR:
            jp   WERRC
            call WINOBR1
            ret  c
            jp   ERSOBJ2
WERRC:
            ret  

WERR_:
            ld   hl,0
            call Outwin
NERR:
            ld   a,0
            ld   hl,ERORS
            call LIST0
            ret  




















WMISS1:
            jp   WMISS1C
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S4
            call ERSOBJ
            ret  z
            ret  
F_S4:

            ret  

WMISS1C:
            ret  

WMISS1_:
            ld   hl,0
            call Outwin
            ld   a,1
            ld   (Mode+1),a
            ld   hl,Txt
            jp   OTXT





















WMISS2:
            jp   WMISS2C
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S5
            call ERSOBJ
            ret  z
            ret  
F_S5:

            ret  
WMISS2C:
            ret  

WMISS2_:
            ld   hl,0
            call Outwin
            ld   a,1
            ld   (Mode+1),a
            ld   hl,Txt
            jp   Outtxt




















WTWR:
            jp   WTWRC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S6
            call ERSOBJ
            jr   nz,W_R1
            ld   de,(BTTW_+1)
            jp   ERSOBJ2
W_R1:
            call DTWR2

            ld   de,(WTWRC+1)
            ld   a,(NTWR+1)
            call DELMK
            ld   a,#FF
            ld   (NTWR+1),a

            ld   hl,DTWR3
            ld   (PROOUT+1),hl
            ld   hl,TKOL-1
            ld   (EINDX+1),hl
            ld   a,#20
ITWR:
            ld   hl,0
            call SCROL
            ld   (ITWR+1),hl
            ret  
F_S6:
; ВЫБОР ПУНКТА
; МАРКЕР ПОКУПКИ ТОВАРА
            ld   a,(NTWR+1)
            inc  a
            ret  z
            ld   hl,(Mcoord)
            ld   a,(Bxw+1)
            sub  l
            neg  
            cp   135
            ld   a,10
            jr   c,$+3
            dec  a
F_S60:
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HIDESCR
            call LINE_
            call WTWR_
            call RETSCR
            ret  
WTWRC:
            ld   de,#1E23
            ld   hl,WTWR_
NTWR:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NTWR+1),a
            ret  

WTWR_:
; ВЫВОД ТОВРОВ
            ld   hl,0
            call Outwin
            call DTWR2
; ВЫВОД НЕЙМ СТРОКИ И ВСЕХ ТОВАРОВ

            ld   a,#FF
            ld   (NTWR+1),a

            ld   hl,TTWR1
            call Outtxt
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,TW_N1
            ld   hl,(ITWR+1)

DTWR3:
            call DTWR1
TW_N1:
            ex   af,af'
            ld   (WTWRC+2),a
            ret  

DTWR1:
;hl-ИНДЕКС ВЫВОДА

            EXD

; КОРД.Y НА САМУЮ ПЕРВУЮ СТРОКУ С ТОВАРОМ
            ld   hl,#2000
            ld   (Cord),hl

            ld   hl,TTWR2
            push de
            ld   a,e
            call LIST1

            ld   a,32
            ld   (Cord+1),a

; ИНДЕКС ВЫВОДА
            pop  hl

            add  hl,hl
            ld   b,h
            ld   c,l

; ВЫВОД ТОВАРОВ,#FF-КОНЕЦ СПИСКА

; ТОВАР НА СТАНЦИИ, КОЛ.,ЦЕНА
            ld   hl,TWRS
            add  hl,bc
            EXD

; ТОВАР У ИГРОКА, КОЛ. СТАРАЯ ЦЕНА
            ld   hl,TWRI
            add  hl,bc
            xor  a
            ex   af,af'
W_T1:
            ld   a,(CXTAB1+1)
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
            call ONUMB

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z


            ld   a,(de)
            inc  de
            rla  
            jr   nc,$+12

; КООРД. ПЕЧАТИ "■" КАК ЗАПР. ТОВАР
            ld   a,109
            ld   (Cord),a

            RST_ 254

            ld   a,(CXTAB2+1)
            ld   (Cord),a
            ld   a,(de)
            inc  de
            ld   c,a
            ld   b,0
            call ONUMB

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

            ld   a,(CXTAB3+1)
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
            call ONUMB

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

            ld   a,(CXTAB4+1)
            ld   (Cord),a
            ld   c,(hl)
            ld   b,0
            inc  hl
            call ONUMB

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

            ld   a,(Eyw+1)
            ld   c,a
            ld   a,(Cord+1)
            add  a,8
            cp   c
            ret  nc
            ld   (Cord+1),a
            jp   W_T1
DTWR2:
; ДОПОЛН.ПРОЦЕДУРЫ ДЛЯ ПОДГОТОВКИ
; ВЫВОДА В ОКНО ТОВАРОВ
;   push ix:callRANDTT:popix
            xor  a
            ld   (Mode+1),a
            ld   a,96
            ld   (CXTAB1+1),a
            ld   a,114
            ld   (CXTAB2+1),a
            ld   a,136
            ld   (CXTAB3+1),a
            ld   a,154
            ld   (CXTAB4+1),a
            ld   a,176
            ld   (CXTAB5+1),a
            ret  
















WWKRB:
            jp   WWKRBC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S7
            call ERSOBJ
            jr   nz,WK_1
; ДЕСТРУКТОР
DE_1:
            ld   de,(BBUY_+1)
            call ERSOBJ2
            ld   de,(BTRD_+1)
            call ERSOBJ2
            ld   de,(WINF_+1)
            call ERSOBJ2
            ret  
WK_1:
            call DWKRB2

; УДАЛЯЕМ ПОСЛЕДНИЙ МАРК
            ld   de,(WWKRBC+1)
            ld   a,(NWKRB+1)
            call DELMK
            ld   a,#FF
            ld   (NWKRB+1),a

            ld   hl,DWKRB3
            ld   (PROOUT+1),hl
            ld   hl,WKKOL-1
            ld   (EINDX+1),hl
            ld   a,#18
IWKRB:
            ld   hl,0
            call SCROL
            ld   (IWKRB+1),hl
            ret  
F_S7:
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
            jr   z,SDWK             ;СДЕЛКА
            ld   a,l
            ld   (ARMINF+1),a
            ld   hl,0
            ld   (IINF+1),hl
            call HIDESCR
            call WIN_F
            call WWKR_B
            call RETSCR
            ret  
SDWK:
BT1:        ld   a,0
            or   a
            ld   a,5
            jr   z,$+3
            inc  a
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HIDESCR
            call LINE_
            call WWKRB_
            call RETSCR
            ret  



WWKRBC:
            ld   de,#1E1B
            ld   hl,WWKRB_
NWKRB:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NWKRB+1),a
            ret  

WWKR_B:
            ld   de,WWKRB_
            call FOBJ
            ret  nz
WWKRB_:
; ВЫВОД ВООРУЖЕНИЕ КОРБЛЕЙ
            ld   hl,0
            call Outwin

            ld   a,#FF
            ld   (NWKRB+1),a

            call DWKRB2
; ВЫВОД НЕЙМ СТРОКИ И ВСЕХ ТОВАРОВ


            ld   hl,TWKRB1
            call Outtxt
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,WK_N1
            ld   hl,(IWKRB+1)

DWKRB3:
            call DWKRB1
WK_N1:
            ex   af,af'
            ld   (WWKRBC+2),a
            ret  

DWKRB1:
;hl-ИНДЕКС ВЫВОДА
;retA'-КОЛ. ВЫВЕДЕННЫХ СТРОК
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

W_K9:
; КОРД.Y НА САМУЮ ПЕРВУЮ СТРОКУ С ТОВАРОМ
            ld   bc,#1800
            ld   (Cord),bc

            push de
            ld   a,e
            call LIST1

            ld   a,#18
            ld   (Cord+1),a

; ИНДЕКС ВЫВОДА
            pop  bc

; ВООРУЖ У ИГРОКА, КОЛ.
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

; ВЫВОД ВООРУЖ.,#FF-КОНЕЦ СПИСКА

; ВООРУЖ НА СТАНЦИИ, ЦЕНА
            pop  hl
            add  hl,bc
            EXD
; СЧЕТЧИК НА КОЛИЧЕСТВО ВЫВЕДЕННЫХ СТРОК
            xor  a
            ex   af,af'
W_K1:
            ld   a,(CXTAB1+1)
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
            call ONUMB

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

; ЦЕНА
            ld   a,(CXTAB2+1)
            ld   (Cord),a
            ld   a,(de)
            ld   c,a
            inc  de
            ld   a,(de)
            ld   b,a
            inc  de
            xor  a
            call Onum5

            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z

; ВЕС
            ld   a,(CXTAB3+1)
            add  a,4
            ld   (Cord),a

            exx  
LEV1:       ld   a,0
            cp   (hl)
            inc  hl
            jr   nc,LV1
            inc  hl
            exx  
            RST_ "-"
            jr   LV2
LV1:
            ld   a,(hl)
            inc  hl
            exx  
            ld   c,a
            ld   b,0
            call ONUMB
LV2:
            jr   c,$+6
            dec  a
            ret  z
            dec  a
            ret  z


            ld   a,(CXTAB4+1)
            add  a,4
            ld   (Cord),a

            exx  
            EXD
            push hl
_KRBNUM:    ld   a,0
            or   a
            jp   m,_I1

            rept 4
            cp   (hl)
            inc  hl
            jr   z,_I1
            endr
            scf  
_I1:
            ld   a,251
            call c,Pntpro

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
            ld   a,(Eyw+1)
            ld   c,a
            ld   a,(Cord+1)
            add  a,8
            cp   c
            ret  nc
            ld   (Cord+1),a
            jp   W_K1

DWKRB2:
; ДОПОПЛН.ПРОЦЕДУРЫ ДЛЯ ПОДГОТОВКИ
; ВЫВОДА В ОКНО ВООРУЖЕНИЯ
            xor  a
            ld   (Mode+1),a
            ld   a,116
            ld   (CXTAB1+1),a
            ld   a,134
            ld   (CXTAB2+1),a
            ld   a,156
            ld   (CXTAB3+1),a
            ld   a,174
            ld   (CXTAB4+1),a
            call PINFO2
            ld   a,l
            ld   (LEV1+1),a
            ret  



















WWSKM:
            jp   WWSKMC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S8
            call ERSOBJ
            jp   z,DE_1             ;НА ДЕСТРУКТОР
            call DWKRB2

            ld   de,(WWSKMC+1)
            ld   a,(NWSKM+1)
            call DELMK
            ld   a,#FF
            ld   (NWSKM+1),a

            ld   hl,DWSKM3
            ld   (PROOUT+1),hl
            ld   hl,WSKOL-1
            ld   (EINDX+1),hl
            ld   a,#18
IWSKM:
            ld   hl,0
            call SCROL
            ld   (IWSKM+1),hl
            ret  
F_S8:
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
            jr   z,SDWS             ;СДЕЛКА
            ld   a,l
            ld   (ARMINF+1),a
            ld   hl,0
            ld   (IINF+1),hl
            call HIDESCR
            call WIN_F
            call WWSK_M
            call RETSCR
            ret  
SDWS:
            ld   a,(BT1+1)
            or   a
            ld   a,7
            jr   z,$+3
            inc  a
            ld   (OPERATION),a
            PAGES PGLANG
            call PARADOX
            PAGES__NOARG
            call HIDESCR
            call LINE_
            call WWSKM_
            call RETSCR
            ret  


WWSKMC:
            ld   de,#0F1B
            ld   hl,WWSKM_
NWSKM:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NWSKM+1),a
            ret  

WWSK_M:
            ld   de,WWSKM_
            call FOBJ
            ret  nz
WWSKM_:
; ВЫВОД ВООРУЖЕНИЕ КОРБЛЕЙ
            ld   hl,0
            call Outwin
            call DWKRB2
; ВЫВОД НЕЙМ СТРОКИ И ВСЕХ ТОВАРОВ

            ld   a,#FF
            ld   (NWSKM+1),a

            ld   hl,TWKRB1
            call Outtxt
            ex   af,af'
            xor  a
            ex   af,af'
            jp   c,WS_N1
            ld   hl,(IWSKM+1)

DWSKM3:
            call DWSKM1
WS_N1:
            ex   af,af'
            ld   (WWSKMC+2),a
            ret  

DWSKM1:
;hl-ИНДЕКС ВЫВОДА
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

















WSOH:
            jp   WSOHC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S12
            call ERSOBJ
            ret  z
            ret  
F_S12:
            call ERSOBJ2
            ld   a,(NSOH+1)

            ret  
WSOHC:
            ld   de,#2803
            ld   hl,WSOH_
NSOH:
            ld   a,#FF
            call MARKo
            ret  z
            ld   (NSOH+1),a
            ret  

WSOH_:
; ОКНО ПОКАЖЕТ ПОЗИЦИИ СОХРАНЕНИЯ
            ld   hl,0
            call Outwin

            ld   a,#FF
            ld   (NSOH+1),a
            xor  a
            ld   (Mode+1),a
            ld   hl,TSOH1
            jp   Outtxt















WWOS:
            jp   WWOSC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S13
            call ERSOBJ
            ret  z
            ret  
F_S13:
            call ERSOBJ2
            ld   a,(NWOS+1)

            ret  
WWOSC:
            ld   de,#2803
            ld   hl,WWOS_
NWOS:
            ld   a,#FF
            call MARKo
            ret  z
            ld   (NWOS+1),a
            ret  

WWOS_:
; ОКНО ПОКАЖЕТ ПОЗИЦИИ СОХРАНЕНИЯ
            ld   hl,0
            call Outwin

            ld   a,#FF
            ld   (NWOS+1),a
            xor  a
            ld   (Mode+1),a
            ld   hl,TWOS1
            jp   Outtxt
















WHIDE:
            jp   WHIDEC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S9
            call ERSOBJ
            ret  z
            ret  
F_S9:
            call ERSOBJ2
            ld   a,(NHIDE+1)
            inc  a
            ret  z
            dec  a
            jp   z,HIDEP1
            dec  a
            jp   z,HIDEP2
            dec  a
            jp   z,HIDEP3
            dec  a
            jp   z,HIDEP4
            dec  a
            jp   z,HIDEP5
            dec  a
            jp   z,HIDEP6
            dec  a
            jp   z,HIDEP7
; СОХРАНИТЬСЯ
            ld   hl,WSOH_
            jp   NEWOBJ

WHIDEC:
            ld   de,#4003
            ld   hl,WHIDE_
NHIDE:
            ld   a,#FF
            call MARKo
            ret  z
            ld   (NHIDE+1),a
            ret  

WHIDE_:
            ld   hl,0
            call Outwin
; ОБНОВЛЯЕМ ПЕРЕМЕННУЮ НОМЕРА ПУНКТА
            ld   a,#FF
            ld   (NHIDE+1),a
            ld   a,1
            ld   (Mode+1),a
            ld   hl,THIDE
            jp   Outtxt





















WSETG:
; СЕТАП ИГРЫ
            jp   WSETGC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S11
            call ERSOBJ
            jr   nz,F_S11_1
            ld   bc,SETGI
            ld   de,SETGD
            jp   TOPORT
F_S11_1:
            call DSETG2

            ld   de,(WSETGC+1)
            ld   a,(NSETG+1)
            call DELMK
            ld   a,#FF
            ld   (NSETG+1),a

            ld   hl,DSETG3
            ld   (PROOUT+1),hl
            ld   hl,SGKOL-1
            ld   (EINDX+1),hl
            ld   a,#08
ISETG:
            ld   hl,0
            call SCROL
            ld   (ISETG+1),hl
            ret  
F_S11:
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
            jr   nz,W_G2
            ld   a,(hl)
            cp   "Y"
            ld   a,"N"
            jr   z,$+4
            ld   a,"Y"
            ld   (hl),a
            jr   W_G3
W_G2:
            ld   a,(hl)
            ld   (hl),"_"
            call HIDESCR
            push hl
            push bc
            call WSETG_
            call RETSCR
; ЧТЕНИЕ КЛАВЫ ДО ПЕРВОЙ КЛАВИШИ
            pop  bc
W_G4:
            call READKEY
            cp   29
            jr   z,W_G4
; ЕСЛИ НЕ CS
            pop  hl
            ld   (hl),a
W_G3:
            call HIDESCR
            call WSET_G
            call RETSCR

            ret  

WSETGC:
            ld   de,#1E0B
            ld   hl,WSETG_
NSETG:
            ld   a,#FF
            call MARKO
            ret  z
            ld   (NSETG+1),a
            ret  

WSET_G:
            ld   de,WSETG_
            call FOBJ
            ret  nz
; УСТАНОВКИ ИГРОВЫЕ
WSETG_:
; ВЫВОД ПУНКТОВ УСТАНОВКИ
            ld   hl,0
            call Outwin

            ld   a,#FF
            ld   (NSETG+1),a

            call DSETG2

            ld   hl,(ISETG+1)

DSETG3:
            call DSETG1
            ex   af,af'
            ld   (WSETGC+2),a
            ret  
DSETG1:

;hl-ИНДЕКС ВЫВОДА
            EXD

; КОРД.Y НА САМУЮ ПЕРВУЮ СТРОКУ
            ld   hl,#0800
            ld   (Cord),hl

            ld   hl,TSETG1
            push de
            ld   a,e
            call LIST1
            ld   a,8
            ld   (Cord+1),a
; ИНДЕКС ВЫВОДА
            pop  hl

; ДАННЫЕ СОСТОЯНИЯ
            ld   bc,SETGI
            add  hl,bc
            jp   W_SS1-2

DSETG2:
            xor  a
            ld   (Mode+1),a
            ld   a,110
            ld   (CXTAB1+1),a
            ret  











WINFS:
            jp   WINFSC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S20
            call ERSOBJ
            ret  z
            ret  
F_S20:
            ret  
WINFSC:
            ret  

WINF_S:
            ld   de,WINFS_
            call FOBJ
            ret  nz
WINFS_:
; ОКНО ПОКАЖЕТ ИНФУ И СИСТЕМЕ
            ld   hl,0
            call Outwin

            xor  a
            ld   (Mode+1),a
            ld   hl,TINFS1
            call Outtxt

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
            call Onum5


; РАСТОЯНИЕ
            ld   de,(WHERE)
            ld   bc,(WHERE+2)
            exx  
            ld   de,(PLACE)
            ld   bc,(PLACE+2)
            exx  
            PAGES PGKRT
            call FARER
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
            call Onum5


; ГЕНЕРИМ ИМЯ ЗВЕЗДЫ И ГОСУДАРСТВА
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            PAGES PGKRT
            call NAME
            ld   hl,(WHERE)
            call GOSTA
            ex   af,af'
            PAGES__NOARG

; ВЫВОД ГОСУДАРСТВА
            ld   hl,#2800
            ld   (Cord),hl
            ld   hl,TGOST
            ex   af,af'
            call LIST

; ВЫВОД ЗВЕЗДЫ
            ld   hl,#3000
            ld   (Cord),hl
            ld   hl,TNAME
            call Outtxt

; ПЛАНЕТА
            PAGES PGKRT
            ld   hl,#3822
            ld   (Cord),hl
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            ld   a,(WPLANET)
            call PNTPLAN
            PAGES__NOARG


            ld   a,(WPLANET)
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
; ПРОВЕРКА ГОСУДАРСТВА
            call PINFO

            and  a
            jr   nz,$+17
            ld   hl,#6000
            ld   (Cord),hl
            ld   hl,TINFS2
            call Outtxt
            jp   U_9

            exx  
            ld   hl,#4019
            ld   (Cord),hl
            exx  

            push af
            call PLIN
            pop  bc

            PAGES PGKRT

; ВЫВОД ПЛАНЕТ
            ld   a,0
            ld   hl,#6000
            ld   (Cord),hl
            push af
            push bc
            call PNTPLN
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,U_7
            ld   hl,#6020
            ld   (Cord),hl
            push af
            push bc
            call PNTPLN
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,U_7
            ld   hl,#6040
            ld   (Cord),hl
            push af
            push bc
            call PNTPLN
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,U_7
            ld   hl,#6800
            ld   (Cord),hl
            push af
            push bc
            call PNTPLN
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,U_7
            ld   hl,#6820
            ld   (Cord),hl
            push af
            push bc
            call PNTPLN
            pop  bc
            pop  af
            inc  a
            dec  b
            jr   z,U_7
            ld   hl,#6840
            ld   (Cord),hl
            call PNTPLN


U_7:
            PAGES__NOARG

U_9:
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            PAGES PGKRT
            call NAME
            ld   hl,(PLACE)
            call GOSTA
            ex   af,af'
            PAGES__NOARG

            ld   hl,#8000
            ld   (Cord),hl
            ld   hl,TGOST
            ex   af,af'
            call LIST

            ld   hl,#8800
            ld   (Cord),hl
            ld   hl,TNAME
            call Outtxt


            PAGES PGKRT
            ld   hl,#9022
            ld   (Cord),hl
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            call PNTPLAN
            PAGES__NOARG


; ПРОВЕРКА ГОСУДАРСТВА
            call PINFO2

            jr   z,U_10

            exx  
            ld   hl,#9819
            ld   (Cord),hl
            exx  

            push af
            call PLIN
            pop  bc

U_10:
            ret  


; ПОКАЗ ПЛАНЕТ СИСТЕМЫ
WPLAN:
            jp   WPLANC
            call WINOBR1
            ret  c
            dec  a
            jp   z,F_S22
            call ERSOBJ
            jr   nz,F_S23
            ld   hl,RET_
            ld   (ZADACHA+1),hl
F_S23:
            ret  
F_S22:
; ВЫБОР ПЛАНЕТЫ

            ld   a,(WPLANET)
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            call PINFO
            ret  z
            ex   af,af'

            ld   hl,(WPLAN_+1)
            xor  a
            call TOOBJ
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a

;HL-КООРД. ОКНА
;A-КОЛ. ПЛАНЕТ
            PAGES PGKRT
            ex   af,af'
            call PLANCH
            PAGES__NOARG
            call HIDESCR
            call WINF_S
            call WPLA_N
            call RETSCR
            ret  
WPLANC:
            ret  

WPLA_N:
            ld   de,WPLAN_
            call FOBJ
            ret  nz
WPLAN_:
; САМА КАРТА В КРУПНОМ МАСШТАБЕ
            ld   hl,0
            call BLACKWP
            call Outwin
            call WHITEW
            ld   hl,(WPLAN_+1)
            call TESTSZ
            ld   hl,RET_
            jr   nc,WN1
            ld   hl,WPLANZ
WN1:
            ld   (ZADACHA+1),hl

            call AMPLAN
            ret  z

            ex   af,af'
            PAGES PGKRT
            ex   af,af'
            call WHO
            PAGES__NOARG

            ret  




W_Z:
; ВЫСТАВЛЯЕТ ОКНО НА ВЕРХ
            ld   a,(Unclick+1)
            or   a
            ret  nz
            xor  a
            ld   (WPLANZ+1),a
            ld   de,(WPLAN_+1)
            call Mactive
            call HIDESCR
            call WPLA_N
            jp   RETSCR

WPLANZ:
; ЗАДАЧА ВЫВОДА ПЛАНЕТ
            ld   a,0
            or   a
            jr   nz,W_Z

            ld   a,%10000000
            rrca 
            ld   ($-2),a
            ret  nc

            call LASTOBJ
            ld   de,WPLAN_
            SUB_DE
; НЕ ПОСЛЕДНИЙ НА СТОЛЕ
            ret  nz

            call AMPLAN

            push af

            xor  a
            ld   hl,(WPLAN_+1)
            call TOOBJ
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
            jr   c,NJ1
            jr   z,NJ22
            dec  a
            cp   c
            jr   nc,NJ1
NJ22:
            ld   a,h
            inc  a
            sub  d
            jr   c,NJ1
            jr   z,NJ2
            dec  a
            cp   b
            jr   nc,NJ1
NJ2:
            call WOST
            ld   a,1
            jr   $+3
NJ1:
            xor  a
            ld   (NJ3+1),a
            push de
            call CLINW
            pop  de
            PAGES PGKRT

            pop  af

            call MOVPLAN
            PAGES__NOARG
NJ3:        ld   a,0
            or   a
            call nz,OUTC
            ret  


; ИНФО ПРИВЕТСТВИЕ
WWELCOME:
            jp   WWELCOMEC
            call WINOBR1
            ret  c
            dec  a
            ret  z
            jp   ERSOBJ
WWELCOMEC:
            ret  

WWELCOME_:
            ld   hl,0
            call Outwin
            ld   a,1
            ld   (Mode+1),a
            ld   hl,WELCOME
            call Outtxt
            push hl
; МОДЕЛЬ СТАНЦИИ
            call PINFO2
            ld   a,l
            dec  a
            ld   hl,MODELS
            call LIST
            pop  hl
            call Outtxt
            push hl
; СИСТЕМА, ПЛАНЕТА
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            PAGES PGKRT
            call NAME
            ld   hl,TNAME
            call Outtxt
            ld   a,(Cord)
            add  a,4
            ld   (Cord),a
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            call PNTPLAN
            PAGES__NOARG
            pop  hl
            call Outtxt
            push hl
; ЦЕНА ПРИБЫТИЯ
            call PINFO2
            ld   a,l
            add  a,a
            add  a,a
            add  a,l
            ld   c,a
            ld   b,0
            call ONUMB
            pop  hl
            call Outtxt
            ret  

