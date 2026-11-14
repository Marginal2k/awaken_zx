;BSDEL      ■BTSHIP
;BBSHIP     ■BABON
;BHELP      ■BNEWS
;BMAP       ■BBUY
;BTRD       ■BPERE
;BMEM       ■BMAR
;BCMAR      ■BNMEM
;BNABO      ■BCENT
;BAWAY      ■BTALL
;BTTW       ■BMISS
;BTWR       ■BWKRB
;BWSKM      ■BKRB
;BSKM       ■BEXIT
;LINE








;--------------------------------
; ОБРАБОТЧИК СОБЫТИЙ ОБЪЕКТОВ КНОПОК
; ПЕРЕДАЮТСЯ
; НОМЕР ОБЪЕКТА В de
;a-CODE OF KEY,1-LEFT,0-RIGHT
;--------------------------------
; ПОСЛЕ ОБРАБОТЧИКА СРАЗУ ИДЕТ ШОУ
; ПРОЦЕДУРА
;--------------------------------
; ВЫВОД ОБЪЕКТОВ И ИНФЫ В НИХ
;--------------------------------










BSDEL:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
; СДЕЛКА
            ld   a,(NSHIP+1)
            inc  a
            ret  z

            PAGES PG3D
            ld   a,(NSHIP+1)
            ld   (SHIPIND+1),a
            PAGES__NOARG

BT2:        ld   a,0
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
            call HIDESCR
            call LINE_
            call RETSCR
; ЗАКРЫТЬ ВСЕ

            ld   de,(WSHIP_+1)
            call ERSOBJ2
            call ERASH
            xor  a
            ld   (Unclick+1),a
            ret  


BSDEL_:
            ld   hl,0
            jp   Outbut



BTSHIP:
            jp   $+3
            ld   hl,$+6
            call BUTOBR1
            ret  c
            PAGES PG3D
            xor  a
            ld   (SHIPIND+1),a
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
            jp   NATISNU
BTSHIP_:
            ld   hl,0
            jp   Outbut



BBSHIP:
            jp   $+3
            ld   hl,$+6
            call BUTOBR1
            ret  c
            PAGES PG3D
            xor  a
            ld   (SHIPIND+1),a
            PAGES__NOARG
            ld   a,1
            ld   (WSHIPZ+1),a
Bb:
            xor  a
            ld   (BT2+1),a
            ld   hl,(BTSHIP_+1)
            jp   NATISNU
BBSHIP_:
            ld   hl,0
            jp   Outbut










BABON:
;de-NUMBER
;PROC OBRAB
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
; ОБРАБОТЧИК
            ld   hl,WFOTO_
            call NEWOBJ
            ld   hl,WABON_
            jp   NEWOBJ

BABON_:
            ld   hl,0
            jp   Outbut













BHELP:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   hl,WHELP_
            call NEWOBJ
            ld   hl,WHELPL_
            jp   NEWOBJ
BHELP_:
            ld   hl,0
            jp   Outbut















BNEWS:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   hl,WNEWS_
            jp   NEWOBJ

BNEWS_:
            ld   hl,0
            jp   Outbut















BMAP:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a

            ld   hl,BPERE_
            call NEWOBJ
            ld   hl,BNABO_
            call NEWOBJ
            ld   hl,WINFS_
            call NEWOBJ
            ld   hl,BMEM_
            call NEWOBJ
            ld   hl,BMAR_
            call NEWOBJ
            ld   hl,BCMAR_
            call NEWOBJ
            ld   hl,BNMEM_
            call NEWOBJ
            ld   hl,BCENT_
            call NEWOBJ
            ld   hl,BAWAY_
            call NEWOBJ
            ld   hl,WMAP_
            call NEWOBJ
            ld   hl,WPLAN_
            jp   NEWOBJ
BMAP_:
            ld   hl,0
            jp   Outbut


















BBUY:
            jp   $+3
            ld   hl,$+6
            call BUTOBR1
            ret  c
            xor  a
            ld   (BT1+1),a
            ld   hl,(BTRD_+1)
            jp   NATISNU


BBUY_:
            ld   hl,0
            jp   Outbut














BTRD:
            jp   $+3
            ld   hl,$+6
            call BUTOBR1
            ret  c
            ld   a,1
            ld   (BT1+1),a
            ld   hl,(BBUY_+1)
            jp   NATISNU

BTRD_:
            ld   hl,0
            jp   Outbut







BPERE:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   hl,(WHERE)
            ld   (PLACE),hl
            ld   hl,(WHERE+2)
            ld   (PLACE+2),hl
            ld   a,(WPLANET)
            ld   (PLANET),a
            pop  hl
            jp   Dalee
BPERE_:
            ld   hl,0
            jp   Outbut

















; ЗАПОМНИТЬ ЗВЕЗДУ
BMEM:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
; УСТАНОВКА ПЕРЕРИСОВКИ ОКНА КАРТЫ ПЛАНЕТ
; ПОСЛЕ ОТЖАТИЯ ЭТОЙ КНОПКИ
            ld   a,1
            ld   (WPLANZ+1),a

; ПОИСК ЗВЕЗДЫ ТЕКУЩЕЙ В СПИСКЕ ПАМЯТИ
            PAGES PGKRT
            call FSTAR
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
B_M1:
            call HIDESCR
            call WINF_S
            call WMAP_
            call RETSCR
            ret  
BMEM_:
            ld   hl,0
            jp   Outbut

; ЗАБЫТЬ ЗВЕЗДУ
FGOT:
            DEC_DE 3
            ld   a,#FF
            ld   (de),a
            jr   B_M1
















; ПРОЛОЖИТЬ МАРШРУТ
BMAR:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a

; ПОИСК ЗВЕЗДЫ ТЕКУЩЕЙ В МАРШРУТНОМ
; СПИСКЕ
            PAGES PGKRT
            call FSTAR2
            ex   af,af'
            PAGES__NOARG
            ex   af,af'

            jp   p,FGOT2
; ВКЛЮЧЕНИЕ ЗВЕЗДЫ
            ld   hl,(AWAYS)
;hl-АДР. ЗВЕЗДЫ С КОТОРОЙ ИДЕТ
; ПОСТРОЙКА
            ld   a,(hl)
            inc  a
            jr   z,B_R1
            ld   de,5
            add  hl,de
;hl-АДР. СЛЕДУЮЩЕЙ
; ПРОВЕРИМ ЕСЛИ ЭТО КОНЕЦ СПИСКА
            ld   a,(hl)
            inc  a
            ret  m                  ;НЕТ МЕСТА
            jr   z,B_R1             ;НАШЛИ СВОБОДНОЕ
; ИЩЕМ ПЕРВОЕ СВОБОДНОЕ МЕСТО
            ld   bc,5
            push hl
            add  hl,bc
            ld   a,(hl)
            inc  a
            jp   m,B_R2             ;НЕТ МЕСТА
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
;hl-ПОКАЖЕТ НА СВОБОДНОЕ МЕСТО
B_R1:
; ВПИСЫВАЕМ НА СВОБОДНОЕ
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
; НЕТ МЕСТА
B_R2:
            pop  hl
            ret  
BMAR_:
            ld   hl,0
            jp   Outbut

; ЗАБЫТЬ ЗВЕЗДУ В МАРШРУТЕ
FGOT2:
            DEC_DE 3
; АДРЕС СТИРАЕМОЙ ЗВЕЗДЫ
            ld   h,d
            ld   l,e
            ld   bc,5
            add  hl,bc
            ld   a,(hl)
            inc  a
            jp   m,B_R3
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
B_R3:
            ld   bc,0-5
            add  hl,bc
            ld   (hl),#FF
B_M19:
            PAGES PGKRT
            call MARKOL
            PAGES__NOARG
            jp   B_M1








; СТЕРЕТЬ МАРШРУТ
BCMAR:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a

            ld   hl,WAY
; ВПИСАЛИ ДРЕС ЗВЕЗДЫ КОТ. НЕТ НО ПЕРВОЙ
; С КОТ. ПОСТРОЙКА БУДЕТ
            ld   (AWAYS),hl
            ld   bc,5
            ld   a,(hl)
            cp   #80
            jr   z,$+7
            ld   (hl),#FF
            add  hl,bc
            jr   $-8
            jr   B_M19

BCMAR_:
            ld   hl,0
            jp   Outbut












; СЛЕД. ЗВЕЗДА В СПИСКЕ ПАМЯТИ
BNMEM:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a

            ld   a,(MSTARS)
            inc  a
            ret  z

B_E1:       ld   hl,MSTARS
            ld   de,5
B_E2:
            add  hl,de
            ld   a,(hl)
            inc  a
            jp   p,$+6
            ld   hl,MSTARS
            jr   z,B_E2
            ld   (B_E1+1),hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jr   B_E10

BNMEM_:
            ld   hl,0
            jp   Outbut






; СЛЕД. ПЕРСОНАЖ В СПИСКЕ ПАМЯТИ
BNABO:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a

B_E7:       ld   hl,ABONS

B_E8:
            inc  hl
            ld   a,(hl)
            and  a
            jp   p,$+6
            ld   hl,ABONS
            jr   z,B_E8
            ld   (B_E7+1),hl
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

BNABO_:
            ld   hl,0
            jp   Outbut








BCENT:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a

            ld   de,(PLACE)
            ld   hl,(PLACE+2)
B_E10:
            PAGE_ PGKRT
            call CENTRE
            PAGE___NOARG

            jp   B_M1
BCENT_:
            ld   hl,0
            jp   Outbut











BAWAY:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  

            ld   a,1
            ld   (WPLANZ+1),a
            PAGES PGKRT
            call FSTAR2
            ex   af,af'
            PAGES__NOARG
            ex   af,af'

            ret  m                  ;ЗВЕЗДА НЕ НА ЛИНИИ
            DEC_DE 3
            ld   (AWAYS),de
            jp   B_M1
BAWAY_:
            ld   hl,0
            jp   Outbut




















BTTW:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   a,11
            jp   F_S60

BTTW_:
            ld   hl,0
            jp   Outbut
















BMISS:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   hl,WMISS2_
            call NEWOBJ
            ; ??? а%   hl,WMISS1_
            jp   NEWOBJ

BMISS_:
            ld   hl,0
            jp   Outbut















BTWR:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   hl,BTTW_
            call NEWOBJ
            ld   hl,WTWR_
            jp   NEWOBJ
BTWR_:
            ld   hl,0
            jp   Outbut




















BWKRB:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            xor  a
            ld   (ARMINF+1),a
            ld   hl,WINF_
            call NEWOBJ
            ld   hl,BTRD_
            call NEWOBJ
            ld   hl,BBUY_
            call NEWOBJ
            ld   hl,WWKRB_
            jp   NEWOBJ

BWKRB_:
            ld   hl,0
            jp   Outbut



















BWSKM:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   a,WKKOL
            ld   (ARMINF+1),a
            ld   hl,WINF_
            call NEWOBJ
            ld   hl,BTRD_
            call NEWOBJ
            ld   hl,BBUY_
            call NEWOBJ
            ld   hl,WWSKM_
            jp   NEWOBJ

BWSKM_:
            ld   hl,0
            jp   Outbut















BKRB:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            xor  a
            call SET1_

            ld   hl,BSDEL_
            call NEWOBJ
            ld   hl,BBSHIP_
            call NEWOBJ
            ld   hl,BTSHIP_
            call NEWOBJ
            ld   hl,WSHIP_
            call NEWOBJ
            ld   hl,WISHIP_
            call NEWOBJ
            ld   hl,WDSHIP_
            jp   NEWOBJ
BKRB_:
            ld   hl,0
            jp   Outbut


SET1_:
            ld   (T3D+1),a
            ld   a,1
            ld   (WSHIPZ+1),a
            ld   a,#FF
            ld   (NSHIP+1),a
            xor  a
            ld   (BT2+1),a
            ld   hl,(BBSHIP_+1)
            ld   a,4
            call TOOBJ
            set  0,(hl)
            ld   hl,(BTSHIP_+1)
            ld   a,4
            call TOOBJ
            res  0,(hl)
            PAGES PG3D
            xor  a
            ld   (SHIPIND+1),a
            PAGES__NOARG
            ret  












BSKM:
            jp   $+3
            ld   hl,$+7
            call BUTOBR1
            ret  
            ld   a,1
            call SET1_

            ld   hl,BSDEL_
            call NEWOBJ
            ld   hl,BBSHIP_
            call NEWOBJ
            ld   hl,BTSHIP_
            call NEWOBJ
            ld   hl,WSHIP_
            call NEWOBJ
            ld   hl,WISHIP_
            call NEWOBJ
            ld   hl,WDSHIP_
            jp   NEWOBJ
BSKM_:
            ld   hl,0
            jp   Outbut


















BEXIT:
            jp   $+3
            call BUTOBR1
            ret  c
            ld   a,(KFC)
            and  a
            ret  m
;EXIT TO XAS
; [glue] original: jp EXAS (back to the ZASM/XAS debugger); the game launches the flight part instead
            jp   LaunchFlight

BEXIT_:
            ld   hl,0
            jp   Outbut















LINE:
            jp   $+3
            call z,Movsiz
            ret  c
            push af
            call Unclick
            call Mactive
            jp   z,LN_1
            call WOST
            ld   de,$+5
            push de
            jp   (hl)
            call OUTC
LN_1:
            pop  af
            ret  

LINE_:
            ld   hl,0
            ld   a,1
            ld   (Mode+1),a
            call Outlin
            inc  hl
            ld   a,(hl)
            ld   hl,Lintxt
            call FLIST

            call Outtxt             ;STATUS
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
            call FLIST
            call Outtxt             ;WITCH STATUS
            pop  hl
            call Outtxt             ;MONEY
            ld   bc,(SUMM)
            xor  a
            call Onum5
            call Outtxt             ;TONASH
            ld   bc,(TONN)
            ld   b,0
            call Onum2
            RST_ ":"
            ld   bc,(TONN+1)
            ld   b,0
            jp   Onum2

