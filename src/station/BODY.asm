;==============================================================================
; BODY - главный цикл станции, прерывание, среда объектов, обработка нажатий
;
; Где живёт: основной образ STATIONF.C (страница PGNORM, #6000..), собирается после DATA_M
; (station.asm: BODYOCUR, OBR, OBR2, шрифт, DATA_M, BODY, DOPPROC, PNT, OBJ, DATAT, OBJECT).
;
; Точки входа:
;   StationStart  - начало станции: сброс флагов платы и выдворения, генерация цен
;                   (RandomizeTrade), первая отрисовка (Repaint), проверка PARADOX (операция 15);
;                   сюда переходят BODYOCUR (после инициализации) и кнопка "Перелёт" (OBR2).
;   MainLoop      - главный цикл: ждёт кадр (halt), вызывает фоновую задачу окна (TaskCall),
;                   при событии платы запускает PARADOX (операция 16), выводит часы (LineWindow2),
;                   опрашивает огонь/отмену (ReadFireCancel) и вызывает OnFire / Unclick.
;   Interrupt     - обработчик IM2 (вектор в #8181 ставит BODYOCUR): опрос мыши/джойстика/клавиатуры,
;                   курсор, музыка (страница PGMUZ, #DB05), счёт игрового времени TIME в BCD.
;   Repaint       - полная перерисовка: очистка таблиц и буферов, активация объектов среды.
;   SurroundOn/Off, SurroundActivate - включение/выключение объектов "среды" (набор окон и
;                   кнопок стола, описатель Sur1 в OBJECT.asm).
;   TakeIdent, OnFire, Click, Unclick, CheckClickHandler - какой объект под курсором и вызов его
;                   обработчика (описатели объектов: OBJECT.asm, 16 байт, см. GAME_DESIGN 1.3).
;   ObjFieldAddr  - адрес поля записи объекта по номеру.
;   DEPACK        - распаковщик Hrust (используется загрузчиком картинок станции).
;
; Читает/пишет: TIME, PLACE, OPERATION и др. поля записи состояния (DATA_M), NPG, буфер экрана
; объектов (Tabob, Bscr из EQUS). Подробности: docs/GAME_DESIGN.md разд. 1.3, 6.1, 8.3;
; таблица переименований: docs/STATION_LABELS.md.
;==============================================================================

DoNothing   ; orig: RET_
; Пустой обработчик (ret), заглушка по умолчанию
            ret


; Begin making screen

StationStart   ; orig: Dalee
; Начало работы станции: сброс флагов, генерация цен, первая отрисовка
            xor  a
            ld   (ExpelTimer+1),a
            ld   (FeeFlag+1),a
            ld   a,#80
            ld   (ZAPRET+1),a
            call RandomizeTrade
            xor  a
            ld   (ZAPRET+1),a
            call Repaint

; Начальная проверка
            PAGES PGLANG
            ld   a,15
            ld   (OPERATION),a
            call PARADOX
            PAGES__NOARG


MainLoop   ; orig: M1
; Главный цикл станции (опрос кнопок, часы, события)

RepaintFlag   ; orig: FORRP
; Флаг: 0 = нужна полная перерисовка экрана (самомодифицируемый операнд)
            ld   a,0
            and  a
            call z,Repaint

            halt


TaskCall   ; orig: ZADACHA
; Вызов текущей фоновой задачи окна (call патчится)
            call DoNothing

TaskIX   ; orig: IXZD
; IX текущей задачи
            ld   ix,0

TaskProc   ; orig: ZADAT
; Адрес процедуры текущей задачи (DoNothing по умолчанию)
            call DoNothing
            ld   hl,DoNothing
            ld   (TaskProc+1),hl


FeeFlag   ; orig: PLATA
; Флаг: сработало событие платы (вызывает PARADOX, операция 16)
            ld   a,0
            or   a
            jr   z,.PL_1
            xor  a
            ld   (FeeFlag+1),a
            ld   (RepaintFlag+1),a
            PAGES PGLANG
            ld   a,16
            ld   (OPERATION),a
            call PARADOX
            PAGES__NOARG
.PL_1

ExpelTimer   ; orig: WYDWOR
; Счётчик выдворения игрока со станции
            ld   a,0
            dec  a
            jp   m,.PL_2
            ld   (ExpelTimer+1),a
            jr   nz,.PL_2

; Выдворение в космос

.PL_2


; Вывод часов
            call SaveWindowParams
            call LINE2_
            call RestoreWindowParams

            call ReadFireCancel
            ld   c,a

.OLDFIRE
            ld   d,0

            ld   a,c
            ld   (.OLDFIRE+1),a

            or   d
            jp   z,MainLoop
            ld   a,c
            cp   d
            jp   nc,.M23
            call Unclick
            jp   MainLoop
.M23
            call OnFire
            jp   MainLoop


Interrupt   ; orig: Int
; Обработчик прерывания IM2: музыка, часы, курсор, ввод
            di
            ld   (STK7+1),sp
            ld   sp,IntStackTop
            push ix
            push iy
            push af
            push hl
            push de
            push bc
            ex   af,af'
            push af
            exx
            push hl
            push de
            push bc

            ld   a,(NPG)
            push af

            PAGES__NOARG


            call ClearInput
            call ServeJoystick
            call ServeKeyboard
            call ServeMouse


CursorBusy   ; orig: FWOST
; Флаг: курсор не рисовать в этом прерывании
            ld   a,0
            or   a
            jr   nz,.FW1
            call CursorDrawIfMoved
.FW1

            ld   a,(MUSIC)
            cp   #81
            jr   z,.INT4
            ld   c,a
            ld   a,(MusicLast+1)
            cp   c
            ld   (MusicLast+1),a
            jr   z,ClockTick
            ld   bc,PORT_AY_REG
            ld   a,7
            out  (c),a
            in   a,(c)
            ld   (AyMixerSaved+1),a
            ld   a,b
            ld   b,#BF
            out  (c),a
            ld   b,a
            ld   a,8
            out  (c),a
            xor  a
            ld   b,#BF
            out  (c),a
            ld   b,#FF
            ld   a,9
            out  (c),a
            xor  a
            ld   b,#BF
            out  (c),a
            ld   b,#FF
            ld   a,10
            out  (c),a
            xor  a
            ld   b,#BF
            out  (c),a
            jr   ClockTick

.INT4
; Играть музон

MusicLast   ; orig: LMUSIC
; Последний номер мелодии (самомодиф. операнд)
            cp   0
            ld   (MusicLast+1),a
            jr   z,MusicPlay
            ld   bc,PORT_AY_REG
            ld   a,7
            out  (c),a
            ld   b,#BF

AyMixerSaved   ; orig: L7
; Сохранённый регистр 7 AY (микшер)
            ld   a,0
            out  (c),a

MusicPlay   ; orig: INT5
; Вызов проигрывателя музыки (#DB05)
            PAGES PGMUZ
            call #DB05

ClockTick   ; orig: INT3
; Счёт кадров и часы игрового времени (BCD в TIME)
            ld   a,50
            dec  a
            ld   ($-2),a
            jr   nz,.INT2
            ld   a,50
            ld   ($-9),a
            ld   a,(TIME+3)
            add  a,1
            daa
            ld   (TIME+3),a
            ld   a,1
            jr   c,$+3
            dec  a
            ld   (FeeFlag+1),a
            ld   a,(TIME+2)
            adc  a,0
            daa
            ld   (TIME+2),a
            ld   a,(TIME)
            adc  a,0
            daa
            ld   (TIME),a
            ld   a,(TIME+1)
            adc  a,0
            daa
            ld   (TIME+1),a
.INT2

            pop  af
            call SetPage

            ld   hl,(STK7+1)
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   (STK7+1),hl
            ld   (IntNextJump+1),de

            ld   hl,CW2+2
            ld   (STKO),hl
            ld   hl,CW2+4
            ld   (STKO+2),hl
            ld   hl,CW2+6
            ld   (STKO+4),hl
            ld   hl,CW2+8
            ld   (STKO+6),hl
            ld   hl,CW2+10
            ld   (STKO+8),hl
            ld   hl,CW2+12
            ld   (STKO+10),hl
            ld   hl,CW2+14
            ld   (STKO+12),hl
            ld   hl,CW2+16
            ld   (STKO+14),hl
            ld   hl,CW2+18
            ld   (STKO+16),hl

            pop  bc
            pop  de
            pop  hl
            exx
            pop  af
            ex   af,af'
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  iy
            pop  ix
STK7
            ld   sp,0
            ei

IntNextJump   ; orig: JUMP0
; Переход, прочитанный из стека прерывания
            jp   0


            ds   #30

IntStackTop   ; orig: STKL
; Вершина стека прерывания


ReadFireCancel   ; orig: Tfire
; Опрос огня/отмены: A = 0 ничего, b0 отмена, b1 огонь
; TAKE ABOUT FIRE retina
; А=0 ничего не нажато
; Б0=1 отмена
; Б1=1 огонь
            push bc
            ld   a,(Directj+4)
            ld   c,a
            ld   a,(Directz)
            or   c
            add  a,a
            ld   c,a
            ld   a,(Directj+5)
            ld   b,a
            ld   a,(Directz+5)
            or   b
            or   c
            pop  bc
            ret

SurroundOff   ; orig: Suroff
; Выключить все объекты среды (патч кода ret)
; Все объекты среды будут вофф,t.E. нев
; Идимы и не досягаемы
; hl-adr of surround
            ld   a,(hl)
            ld   e,a
            inc  hl
            ld   a,(hl)
            dec  a
            ret  z
            inc  a
            inc  hl
            ld   d,a
            ld   a,OPCODE_RET          ; Признак офф
            ld   (de),a
            jp   SurroundOff

SurroundOn   ; orig: Suron
; Включить все объекты среды
; Все объекты среды будут boh,t.E. моут
; Быть видимы
; hl-adr of surround
            ld   a,(hl)
            ld   e,a
            inc  hl
            ld   a,(hl)
            dec  a
            ret  z
            inc  a
            inc  hl
            ld   d,a
            ld   a,OPCODE_LD_HL       ; Признак вкл
            ld   (de),a
            jp   SurroundOn


Repaint
; Перерисовать екран вобъектах
; Очистка таблиц и буферов, дизактивация
; Bcex объектов
; Активация объектов данной среды

; Если не отпущена кнопка то не перерисов
            ld   a,(Unclick+1)
            or   a
            ret  nz

            call HideCursor

            ld   a,(INK)
            ld   c,a
            ld   a,(PAPER)
            rlca
            rlca
            rlca
            or   c
            ld   c,a
            ld   a,(BRIGHT)
            rrca
            rrca
            or   c
            ld   (OCOLOR+1),a

            ld   a,1
            ld   (RepaintFlag+1),a
            call InitBufScreen
            call InitTabob
            ld   hl,Sur1
            call SurroundOff


SurroundPtr   ; orig: Adnsur
; Адрес текущего описателя среды
            ld   hl,Sur1
; Adr sur that now
            push hl
; Активация объектов среды

SurroundActivate   ; orig: ACTIV
; Активация объектов среды
            ld   a,0
            and  a
            call z,SurroundOn
            pop  hl
; Сортировка объектов так:
; Первые на стол кнопки, кроме той
; Которая может быть самой последней
; Потом окна по порядку
            push hl
            push hl
            pop  ix
            ld   bc,Objvec+4
            ld   a,1
            cp   (ix+1)
            jr   z,.E_S1
.E_S2
            ld   a,1
            cp   (ix+3)
            jr   z,.E_S1
            ld   h,(ix+1)
            ld   l,(ix+0)
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            ADDHLHL 4
            add  hl,bc
            ld   a,(hl)
            and  %11100000
            cp   %01000000
            inc  ix
            inc  ix
            jr   nz,.E_S2
; Кнопка которая сортится на низ стола

            push bc
; Разжатие в самом начале
            ld   hl,(SurroundPtr+1)
            ld   bc,OVLEN-1
            add  hl,bc
            ld   d,h
            ld   e,l
            INC_DE 2
            ld   bc,OVLEN
            lddr

; Сжатие в месте объекта
            ld   c,(ix+0)
            ld   b,(ix+1)
            push bc
            push ix
            pop  hl
            ld   d,h
            ld   e,l
            INC_HL 2
            ld   bc,OVLEN
            ldir
            ld   hl,(SurroundPtr+1)
            pop  bc
            ld   (hl),c
            inc  hl
            ld   (hl),b

            pop  bc
            jp   .E_S2
.E_S1
            pop  hl
; Вывод объектов среды
.Rp3
            ld   e,(hl)
            inc  hl
            ld   a,(hl)
            dec  a
            jp   z,.Rp1
            inc  a
            inc  hl
            ld   d,a
            push hl
            ld   hl,.Rp2
            push hl
            EXD
            jp   (hl)
.Rp2
            pop  hl
            jp   .Rp3
; Чистка екрана от частей лишних объекто
; b,ha всего ekpaha
.Rp1
            PAGES PGBGD
            ld   hl,#5800
            ld   de,Backscr+#1800
            ld   b,high(Tabob)
            exx
            ld   hl,Bscr
            ld   de,#4000
            ld   bc,Backscr         ; Adr of back
; SCR
Nbs2
            ld   a,(hl)
            and  a
            jr   z,Nbs3
            exx
            dec  a
            rlca
            ld   c,a
            inc  c
            ld   a,(bc)
            inc  a
OCOLOR
            ld   c,0
            exx
            jp   z,Nbs3
            ld   a,c
            add  a,7
            ld   c,a
            inc  bc
            ld   a,d
            jp   Nbs1
Nbs3
            ld   a,d
            ex   af,af'
;  rept7: lda,(bc):incc:ld(de),a:incd
            rept 7
            ld   a,(bc)
            inc  c
            ld   (de),a
            inc  d
            endr

            ld   a,(bc)
            inc  bc
            ld   (de),a

            exx
            ld   a,(de)
            ld   c,a
            exx

            ex   af,af'
Nbs1
            inc  e
            jr   nz,$+4
            add  a,8
            ld   d,a
            inc  hl

            exx
            ld   (hl),c
            inc  hl
            inc  de
            exx

            ld   a,h
            cp   high(Bscr)+3
            jp   c,Nbs2
            PAGES__NOARG
            jp   ShowCursorBack


TakeIdent   ; orig: Tident
; Идентификатор объекта под курсором
; Take ident unde cursor ina
; Destroy hl,bc
            ld   bc,(Mcoord)
            srl  b
            srl  b
            srl  b
            srl  c
            srl  c
            srl  c

TakeIdentXY   ; orig: Tident2
; Идентификатор объекта по координатам BC
            ld   a,b
            and  #18
            rra
            rra
            rra
            add  a,high(Bscr)
            ld   h,a
            ld   a,b
            and  7
            rra
            rra
            rra
            rra
            add  a,c
            ld   l,a
            ld   a,(hl)
            ret

OnFire   ; orig: Fire
; Обработка нажатия огня (выбор объекта)
; DrawMark some thing
            jr   nz,$+4
            or   #80
            ld   hl,#FFF0
            ld   (.DNUM+1),hl
            push af
            call TakeIdent
            and  a
            jp   z,.Nthf
            dec  a
            rlca
            ld   l,a
            ld   h,high(Tabob)
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  h
            jp   z,.Nthf
            dec  h
            ld   d,h
            ld   e,l

            ld   (.DNUM+1),hl
            push hl
            push de
            call .N_L2
            pop  de
            pop  hl
            ld   a,(RepaintFlag+1)
            or   a
            jr   z,.EXF

            xor  a
            call ObjFieldAddr
            push hl
            pop  ix
            INC_HL 4
            ld   a,(hl)             ; Setup byte
            ld   (SPBYTE+1),a
            inc  hl
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            INC_HL 3
            pop  af
            dec  a
            ld   (KFC),a
            jp   (hl)
.EXF
            pop  af
            ret

.Nthf
            ld   a,(SurroundActivate+1)
            and  a
            jr   z,$+9
            xor  a
            ld   (SurroundActivate+1),a
            ld   (RepaintFlag+1),a
            pop  af
            dec  a
            jr   z,.N_L1
            dec  a
            ret  nz
; Стирание окон которые по fire backgroun
; Должны удалятся
.N_L2
            ld   hl,(SurroundPtr+1)
            inc  hl
            ld   b,(hl)
            dec  b
            ret  z
            inc  b
            dec  hl
            ld   c,(hl)
            inc  bc
            ld   a,(bc)
            inc  bc
            ld   e,a
            ld   a,(bc)
            ld   d,a
            push hl
; Номер объекта кот. не стирать
.DNUM
            ld   hl,#FFF0
            xor  a
            sbc  hl,de
            jr   z,.DN1
            ld   l,e
            ld   h,d
            call ObjFieldAddr4
            ld   a,(hl)
            and  %11100000
.DN1
            cp   %00100000
            pop  hl
            INC_HL 2
            jp   nz,.N_L2+3
            call CloseObject
            jp   .N_L2

.N_L1
; Появление сетап окна по отмене
            ld   (KFC),a
            ld   hl,(Mcoord)
            rept 3
            srl  h
            srl  l
            endr
            ld   a,h
            cp   15
            jr   c,$+4
            ld   h,15
            ld   a,l
            cp   23
            jr   c,$+4
            ld   l,23
            ld   (CWHIDE),hl
            ld   hl,WHIDE_
            jp   OpenObject


;--------------
Unclick
; Отжатие последней нажатой кнопки
; retFZ-КАК В Mactive
            ld   a,0
            and  a
            ret  z
            push de
            push hl
Rghl
            ld   de,0
            call ActivateObject
            call Click
            xor  a
            ld   (Unclick+1),a

UnclickHandler   ; orig: UNPROC
; Адрес обработчика отжатия кнопки
            call DoNothing
            ld   hl,DoNothing
            ld   (UnclickHandler+1),hl
            pop  hl
            pop  de
            scf
            ret


;-------------

CheckClickHandler   ; orig: Chccl
; Проверка, надо ли выполнять обработчик кнопки
; Снеск,надо ли выполянть обработчик
; de-number of obj
; Retfz-off=1 eta жекнопка
            push hl
            push de
            push bc
            EXD
            call ObjFieldAddr4
            ld   a,(hl)
            pop  bc
            pop  de
            pop  hl
            and  1
            ret


;--------------
Click
; Click some button
; de-number of obj
            push hl
            push bc
            push de
            EXD
            call ObjFieldAddr4
            ld   a,(hl)
            bit  4,a
            jr   nz,.R_CL
            xor  1
            ld   (hl),a
            call CursorRestoreSafe
            pop  hl
            push hl
            halt
            call OutButton
            call CursorDrawSafe
.R_CL
            pop  de
            pop  bc
            pop  hl
            ret


;-------------------

InitBufScreen   ; orig: Ibscr
; Заполнить буфер экрана идентификатором объекта
; Init buf screen
; Where idents is по всей площади объекта
            push hl
            push de
            push bc
            ld   hl,Bscr
            ld   de,Bscr+1
            ld   bc,#02FF
            ld   (hl),l
            ldir
            pop  bc
            pop  de
            pop  hl
            ret

InitTabob   ; orig: Itabob
; Очистить таблицу объектов
; Init tabob
; 1-Ident of object   from "1"
; Zero is void field on screen
; 2-3-Adr обработчика
; If3=0 than ident free
; Max #55 idents
            push hl
            push de
            push bc
            ld   hl,Tabob
            ld   de,Tabob+1
            ld   bc,#7F
            ld   (hl),#FF
            ldir
            pop  bc
            pop  de
            pop  hl
            ret

ObjFieldAddr4   ; orig: TOOBJ4
; Адрес поля 4 записи объекта
            ld   a,4

ObjFieldAddr   ; orig: TOOBJ
; Адрес поля записи объекта: HL = номер, A = смещение
; hl-номер объекта
; a-смещение после адреса
; rethl-АДРЕС ОБЪЕКТА
            push bc
            ADDHLHL 4
            ld   c,low(Objvec)
            add  a,c
            ld   c,a
            ld   a,high(Objvec)
            adc  a,0
            ld   b,a
            add  hl,bc
            or   a
            pop  bc
            ret

; Депакер
DEPACK
; hl-адр. что депакить
; de-адр. куда депакить
            push de
            push hl
            inc  hl
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            dec  bc
            EXD
            add  hl,bc
            EXD
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            dec  bc
            pop  hl
            add  hl,bc
            sbc  hl,de
            add  hl,de
            jr   c,$+4
            ld   d,h
            ld   e,l
            lddr
            EXD
            pop  de
            ld   c,#0C
            add  hl,bc
            push hl
            pop  ix
            ld   a,#03
            dec  hl
            ld   b,(hl)
            dec  hl
            ld   c,(hl)
            push bc
            dec  a
            jr   nz,$-6
            ld   b,a
            exx
            ld   d,#BF
            ld   c,#10
            call .LL4115
.LL4036
            ld   a,(ix+#00)
            inc  ix
            exx
.LL403C
            ld   (de),a
            inc  de
.LL403E
            exx
.LL403F
            add  hl,hl
            djnz $+5
            call .LL4115
            jr   c,.LL4036
            ld   e,#01
.LL4049
            ld   a,#80
            add  hl,hl
            djnz $+5
            call .LL4115
            rla
            jr   c,$-7
            cp   #03
            jr   c,$+7
            add  a,e
            ld   e,a
            xor  c
            jr   nz,.LL4049
            add  a,e
            cp   #04
            jr   z,.LL40C4
            adc  a,#FF
            cp   #02
            exx
.LL4067
            ld   c,a
.LL4068
            exx
            ld   a,#BF
            jr   c,.LL4082
.LL406D
            add  hl,hl
            djnz $+5
            call .LL4115
            rla
            jr   c,.LL406D
            jr   z,.LL407D
            inc  a
            add  a,d
            jr   nc,.LL4084
            sub  d
.LL407D
            inc  a
            jr   nz,.LL408D
            ld   a,#EF
.LL4082
            rrca
            cp   a
.LL4084
            add  hl,hl
            djnz $+5
            call .LL4115
            rla
            jr   c,.LL4084
.LL408D
            exx
            ld   h,#FF
            jr   z,.LL409B
            ld   h,a
            inc  a
            ld   a,(ix+#00)
            inc  ix
            jr   z,.LL40A6
.LL409B
            ld   l,a
            add  hl,de
            ldir
.LL409F
            jr   .LL403E
.LL40A1
            exx
            rrc  d
            jr   .LL403F
.LL40A6
            cp   #E0
            jr   c,.LL409B
            rlca
            xor  c
            inc  a
            jr   z,.LL40A1
            sub  #10
.LL40B1
            ld   l,a
            ld   c,a
            ld   h,#FF
            add  hl,de
            ldi
            ld   a,(ix+#00)
            inc  ix
            ld   (de),a
            inc  hl
            inc  de
            ld   a,(hl)
            jp   .LL403C
.LL40C4
            ld   a,#80
.LL40C6
            add  hl,hl
            djnz $+5
            call .LL4115
            adc  a,a
            jr   nz,.LL40F3
            jr   c,.LL40C6
            ld   a,#FC
            jr   .LL40F6
.LL40D5
            ld   b,a
            ld   c,(ix+#00)
            inc  ix
            ccf
            jr   .LL4068
.LL40DE
            cp   #0F
            jr   c,.LL40D5
            jr   nz,.LL4067
            ld   b,#03
            EXD
.LL40E7
            pop  de
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            djnz .LL40E7
            ld   hl,#2758
            exx
            ret
.LL40F3
            sbc  a,a
            ld   a,#EF
.LL40F6
            add  hl,hl
            djnz $+5
            call .LL4115
            rla
            jr   c,.LL40F6
            exx
            jr   nz,.LL40B1
            bit  7,a
            jr   z,.LL40DE
            sub  #EA
            add  a,a
            ld   b,a
            ld   a,(ix+#00)
            inc  ix
            ld   (de),a
            inc  de
            djnz $-7
            jr   .LL409F
.LL4115
            ld   b,c
            ld   l,(ix+#00)
            inc  ix
            ld   h,(ix+#00)
            inc  ix
            ret
