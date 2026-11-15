;==============================================================================
; BODYOCUR - вход в станцию, загрузка оверлеев, курсор и драйверы ввода
;
; Где живёт: ORG #6300 (STATION_ENTRY), первый модуль основного образа STATIONF.C (страница PGNORM).
;
; Вход (#6300): если STATE_FLAG = 1 (возврат из полёта) - принимает запись состояния из STATE_BUF в TIME;
; копирует загрузчик (LOADER.asm) в #4000 (директива disp) и запускает его: тот грузит файлы KARTA,
; MUZ1, HELP, D3D, LANG по TR-DOS в страницы 128K; затем настраивает вектор прерывания (таблица
; Forint = #8000, переход в #8181 на Interrupt), строит таблицы адресов экрана TBXX, ставит курсор
; (инсталляция, детект Kempston-джойстика/мыши) и переходит на StationStart (BODY.asm).
;
; Содержит также: SetPage/SetBank (порт #7FFD + NPG), курсор (CursorDraw, CursorRestore и др.),
; драйверы ввода ServeMouse / ServeJoystick / ServeKeyboard (Kempston, Q A O P, Space, M),
; таблицу направлений Directj/Directz. Спрайты курсоров (KSPOplus.s) лежат в #6000..#62FF.
; Константы портов: EQUS.asm. Подробности: docs/ANALYSIS.md 11-14.
;==============================================================================

; Процедуры начала и инициялизации
; Процедуры управлением курсором и его
; Выводом на экран

StationEntry                    ; точка входа образа STATIONF.C (#6300 = STATION_ENTRY)
; [glue] returning from the flight part: take over the state record left in screen RAM by the
; flight launcher (STATE_FLAG=1) before the loader code is copied over #4000
            ld   a,(STATE_FLAG)
            dec  a
            jr   nz,.NO_STATE
            ld   (STATE_FLAG),a
            ld   hl,STATE_BUF
            ld   de,TIME
            ld   bc,STATE_LEN
            ldir
.NO_STATE
            ld   hl,#5800
            ld   de,#5801
            ld   bc,#2FF
            ld   (hl),l
            ldir


            ld   de,#4000
            push de
            ld   bc,.block1-($+9)
            ld   hl,$+6
            ldir
            ret

            disp #4000
            ld   hl,.block1
            ld   de,_FREE
            ld   bc,END1-.block1
            ldir
            di
            xor  a
            out  (PORT_ULA),a
            ld   (Unclick+1),a
            PAGE_ PGFOTOS
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#1AFF
            ld   (hl),l
            ldir
            PAGE_ PG_SHADOW0

            include "LOADER.asm"

            di
            ld   hl,Forint
            ld   a,h
            ld   i,a
            ld   de,Forint+1
            ld   bc,#0100
            ld   (hl),#81
            ldir
            ld   hl,#8181
            ld   (hl),#C3
            inc  l
            ld   (hl),low(Interrupt)
            inc  l
            ld   (hl),high(Interrupt)

            ld   hl,Sur1
            ld   (SurroundPtr+1),hl


; Генерация таблицы поиска адреса по
; Координатам на экране и байт пиксели
; Для каждой позиции
; Mtbxx
            ld   hl,TBXX
            ld   de,#4000
.MT1
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            NEXTLINEDE
            inc  l
            jr   nz,.MT1
            inc  h
            inc  h
            xor  a
            ld   b,8
            ld   (hl),a
            inc  l
            djnz $-2
            inc  a
            cp   32
            jr   c,$-9


; Instcur
; Инсталирует курсор его управление
; Детектирует джойстик и мышь
; Установка начальных координат
            ld   hl,0
            ld   (Mcoord),hl
; Нижняя граница для курсора
            ld   a,191
            ld   (Bord2+1),a
; Левая
            ld   a,255
            ld   (Bord1+1),a
; Высота курсора
            ld   a,8
            ld   (High_+1),a
; Шаг курсора
            ld   a,2
            ld   (Speed+1),a
; Адрес места восстановления под курсором
            ld   hl,0
            ld   (ADWOST+1),hl
            ld   hl,KURSA
            ld   (CursorSpritePtr+1),hl


; Детект джойстик
            in   a,(PORT_KEMPSTON)
            and  #1F
            ld   a,1
            jr   nz,$+3
            dec  a
            ld   e,a
            ld   a,(JOYSTIK)
            res  7,a
            cpl
            and  e
            ld   (ServeJoystick+1),a
; Детект мыша
            ld   bc,PORT_MOUSE_X
            in   a,(c)
            inc  a
            ld   e,1
            jr   z,$+3
            dec  e
            ld   b,#FF
            in   a,(c)
            inc  a
            ld   a,1
            jr   z,$+3
            dec  a
            and  e
            ld   e,a
            ld   a,(MOUSE)
            res  7,a
            cpl
            and  e
            ld   (ServeMouse+1),a


; Не показываем окна и все остальное
            xor  a
            ld   (SurroundActivate+1),a

            ld   bc,SETSI
            ld   de,SETSD
            call PortsToCodes
            ld   bc,SETGI
            ld   de,SETGD
            call PortsToCodes

; Инициаизация координат и номеров
; Объектов
            call SetupCoords
            ld   ix,Objvec
            ld   c,0
            ld   de,16
.H_1
            ld   a,(ix+0)
            cp   #80
            jr   z,.H_2
            ld   l,(ix+12)
            ld   h,(ix+13)
            inc  hl
            ld   (hl),c
            inc  hl
            ld   (hl),0
            inc  c
            add  ix,de
            jp   .H_1
.H_2

            ld   hl,(WMAP_+1)
            ld   a,10
            call ObjFieldAddr
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            dec  l
            dec  h
            dec  l
            dec  h
            dec  h
            ADDHLHL 3
            ld   (BXKRT),hl

            PAGE_ PGKRT
            ld   de,(PLACE)
            ld   hl,(PLACE+2)
            call CenterMapAt
            PAGE_ PGNORM

            ld   a,(MUSIC+1)
            ld   (MusicLast+1),a
            ld   hl,WAY
            ld   (AWAYS),hl

            im   2
            ei

            jp   StationStart

            ent

.block1
            disp _FREE
;  Генерация таблицы поиска адреса по
;  Координатам в окне карты и байт пиксели
;  Для каждой позиции
; de-коорд. карты

MTBXX2
            ld   a,e
            add  a,8
            ld   e,a
            ld   a,d
            add  a,#10
            ld   l,a
            ld   h,high(TBXX)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            add  a,(hl)
            ld   e,a
; de-адрес на экране
            and  #1F
            ex   af,af'
            ld   a,e
            and  %11100000
            ld   e,a

            ld   hl,TBXX2
.MT_1
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            NEXTLINEDE
            inc  l
            jr   nz,.MT_1
            inc  h
            inc  h
            ex   af,af'
.MT3
            ld   b,8
            ld   (hl),a
            inc  l
            djnz $-2
            inc  a
            inc  l
            dec  l
            jr   nz,.MT3
            ret


MERZ
            ld   a,(P00sh1d)
            xor  %01100000
;  Четырех угольные
            ld   (P00stur),a
            ld   (P00trd),a
            ld   (P00turi),a
            ld   (P00sh1d),a
            ld   (P00sh2d),a
            ld   (P00kd4),a
            ld   (P00klpd),a
; Трех угольные
            ld   a,(P00kd5)
            xor  %01100000
            ld   (P00istr),a
            ld   (P01istr),a
            ld   (P00kd5),a
            ld   (P01kd5),a
            ld   (P00pshd),a
            ld   (P01pshd),a
            ret


SetBank   ; orig: PGS
; Сменить только банк (биты 0-2) порта #7FFD, сохранив остальные биты
            push bc
            ld   c,a
            ld   a,(NPG)
            and  %11111000
            or   c
            pop  bc

SetPage   ; orig: PG
; Записать A в порт #7FFD и в NPG
            push bc
            ld   (NPG),a
            ld   bc,PORT_PAGE
            out  (c),a
            pop  bc
            ret

.EXAS
            PAGE_ PGMUZ
            call #DB08
            im   1
            ld   a,#3F
            ld   i,a
            ld   iy,SYSVAR_IY


            PAGE_ PGNORM

            pop  hl
            ret


CursorRestoreSafe   ; orig: WOST
; Восстановить фон под курсором, сохраняя регистры
            push ix
            push af
            push hl
            push de
            push bc
            ld   a,1
            ld   (CursorBusy+1),a
            call CursorRestore
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  ix
            ret

CursorDrawSafe   ; orig: OUTC
; Нарисовать курсор, сохраняя регистры
            push ix
            push af
            push hl
            push de
            push bc
            ld   a,1
            ld   (CursorBusy+1),a
            call CursorDraw
            xor  a
            ld   (CursorBusy+1),a
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  ix
            ret

; bufz (БУФЕР ЗАПОМИНАНИЙ) В "kursa"
; Должны быть заданы с размером соответст-
; Вующим курсору
; Курсор: мин.размер 2знак.X1pix
; Должно быть восемь спрайтов
; Спрайт, маска и т.д.

CursorMoved   ; orig: TESTMOV
; Проверка движения/нажатий (Z = ничего не изменилось)
            push hl
            push de
            ld   hl,(Directz+1)
            ld   de,(Directz+3)
            ld   a,h
            or   l
            or   e
            or   d
            ld   hl,(Directj)
            ld   de,(Directj+2)
            or   l
            or   h
            or   e
            or   d
            pop  de
            pop  hl
            ret                     ; Z;no moves


CursorDrawIfMoved   ; orig: Outcur
; Нарисовать курсор, если было движение

            call CursorMoved
            ret  z

            call CursorRestore
;  Переключение вида курсора от положенния


CursorDraw   ; orig: Outc1
; Сохранить фон и нарисовать курсор (вид зависит от объекта под ним)


            call TakeIdent
            and  a
            ld   de,KURSA
            jp   z,.N_3+4
            dec  a
            rlca
            ld   l,a
            ld   h,high(Tabob)
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  h
            jr   z,.N_1
            dec  h
            ld   d,h
            ld   e,l
            call ObjFieldAddr4
            push hl
            ld   a,(hl)
            and  %11000000
            jr   nz,.N_1
            ld   a,(hl)
            ex   af,af'
            DEC_HL 3
            ld   a,(Mcoord+1)
            srl  a
            srl  a
            srl  a
            cp   (hl)
            ld   de,KURSAM
            jr   nz,.N_2
            ex   af,af'
            and  4
            jr   nz,.N_1
            jr   .N_1+3
.N_2
            ex   af,af'
            and  2
            jr   nz,.N_1
            ex   af,af'
            ld   b,a
            ld   a,(hl)
            INC_HL 2
            add  a,(hl)
            dec  a
            cp   b
            ld   de,KURSAS
            jr   z,.N_1+3
.N_1
            ld   de,KURSA
            ld   (CursorSpritePtr+1),de
            pop  ix
;  Определение последний ли обкт на столе
            ld   de,0-4
            add  ix,de
            call LastDeskObject
            ld   e,(ix+12)
            ld   d,(ix+13)
            SUB_DE
            jr   nz,.N_3

;  Окно ли это
            ld   a,(ix+4)
            and  #C0
            jr   nz,.N_3
;  Это окно
;  Объект последний и видимый
;  Переходим на обработчик события:
; "Куроср в области объекта"
            ld   l,(ix+6)
            ld   h,(ix+7)
;        ldde,N_3
;        pushde
;        jp(hl)

            ld   (TaskIX+2),ix
            ld   (TaskProc+1),hl


.N_3
            ld   de,(CursorSpritePtr+1)
            ld   (CursorSpritePtr+1),de

            ld   a,(CursorRestore+1)
            or   a
            ret  z

            ld   bc,(Mcoord)
            ld   a,c
            and  7
; and7,X * 32
            ld   l,0
            rra
            rr   l
            rra
            rr   l
            rra
            rr   l
            ld   h,a

CursorSpritePtr   ; orig: AKURSA
; Адрес набора спрайтов курсоров
            ld   de,0   ; Спрайты курсоров
            add  hl,de
            EXD
; Take adres on screen from tabl
            ld   h,high(TBXX)
            ld   l,b
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            or   (hl)
            ld   l,a
            ld   h,b
            ld   (ADWOST+1),hl
            push de
; 3Апоминание
            ld   de,CursorSaveBuf
            ld   a,(Mcoord+1)
            ld   b,a
            ld   a,191
            ld   c,a
            sub  b
            ld   b,a
.Porog
            cp   7
;  Порог=высота-1
.Shigh
            ld   a,8                ; Высота курсора
            ; ??? Заданная
            jr   nc,$+4
; Уменьшим высоту курсора если он выходит
; За экран снизу
            ld   a,b
            inc  a

            ld   (High_+1),a
            ld   b,a
.Zap1
            ldi
            ldi
            DEC_HL 2
            NEXTLINE
            djnz .Zap1

; Вывод
            ld   de,(ADWOST+1)
            pop  hl

            xor  a
            ld   (CursorRestore+1),a


; Вывод пол курсора
; Dеадрес на экране
; Нlадрес курсора
High_
            ld   b,8                ; Высота курсора
            ld   a,(Mcoord)
            cp   248
            jr   c,.Pri2
; Выводим половину
.Pri3
            ld   a,(de)
            and  (hl)
            inc  l
            xor  (hl)
            inc  l
            inc  l
            inc  l
            ld   (de),a
            NEXTLINEDE
            djnz .Pri3
            ret
.Pri2
; Вывод целого курсора
; Нlадрес не экране
; Dеадрес курсора
            ld   a,(de)
            and  (hl)
            inc  l
            xor  (hl)
            inc  l
            ld   (de),a
            inc  e
            ld   a,(de)
            and  (hl)
            inc  l
            xor  (hl)
            inc  l
            ld   (de),a
            dec  e
            NEXTLINEDE
            djnz .Pri2
            ret

CursorRestore   ; orig: Awost
; Восстановить фон под курсором из буфера

            ld   a,0
            and  a
            ret  nz
            inc  a
            ld   (CursorRestore+1),a

ADWOST
            ld   de,0               ; Адрес восстановл.
            ld   hl,CursorSaveBuf
            ld   c,#FF
            ld   a,(High_+1)
            ld   b,a
.Wo1
            ldi
            ldi
            DEC_DE 2
            NEXTLINEDE
            djnz .Wo1
            ret
;  Буфер запоминаний
CursorSaveBuf        ds   #10   ; orig: Bufz


;  Процедуры управления курсором мышью
;  Джойстиком и клавой

; Mouse driver from ZX-format
Directz     db   0                  ; FIRE
            db   0                  ; UP
            db   0                  ; DOWN
            db   0                  ; Right
            db   0                  ; LEFT
            db   0                  ; Cancel
            db   0                  ; Medium
;  Устанавливаются b1 если нажато
Mports      dw   0                  ; Cords мыхи
Nondef
            and  3
            jr   z,Mdrv4
            cp   1
            jr   z,.Nondef_
            xor  a
            ld   (Mdrv3+2),a
            ld   a,5
            ld   (Mdrv2+2),a
.Nondef_
            ld   hl,0
            ld   (Mdrv1),hl
            pop  ix
; MAIN

ServeMouse   ; orig: Servms
; Опрос мыши Kempston
            ld   a,0
            and  a
            ret  nz
            push ix
            ld   hl,Directz
            push hl
            pop  ix
            xor  a
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            ld   bc,PORT_MOUSE_BTN
            in   a,(c)
            cpl
Mdrv1
            jr   Nondef
            rra
Mdrv2
            rl   (ix+0)
            rra
Mdrv3
            rl   (ix+5)
            rra
            rl   (ix+6)
Mdrv4
            ld   hl,(Mcoord)
            ld   de,(Mports)
            ld   bc,PORT_MOUSE_X
            in   a,(c)
            ld   (Mports),a
            sub  e
            jr   z,.Mdrv9
            jp   p,.Mdrv6
            ld   (ix+4),1
.Zcm3
            add  a,a
            add  a,l
            jr   c,.Mdrv5
            xor  a
.Mdrv5
            ld   l,a
            jr   .Mdrv9
.Mdrv6
.Zcm4
            add  a,a
            add  a,l
            ld   (ix+3),1
            jr   c,.Mdrv7
            cp   #FE
            jr   c,.Mdrv8
.Mdrv7
            ld   a,#FE
.Mdrv8
            ld   l,a
.Mdrv9
            ld   b,#FF
            in   a,(c)
            ld   (Mports+1),a
            sub  d
            jr   z,.Mdrv14
            neg
            jp   p,.Mdrv11
            ld   (ix+1),1
.Zcm1
            add  a,a
            add  a,h
            jr   c,.Mdrv10
            xor  a
.Mdrv10
            ld   h,a
            jr   .Mdrv14
.Mdrv11
.Zcm2
            add  a,a
            add  a,h
            ld   (ix+2),1
            jr   c,.Mdrv12
            cp   #BF
            jr   c,.Mdrv13
.Mdrv12
            ld   a,#BF
.Mdrv13
            ld   h,a
.Mdrv14
            ld   (Mcoord),hl
            pop  ix
            ret

;  Процедура servjk
;  Управлениекоординатами курсора впикс
; еЛ.
; Спом. qaop,sp;kempstona
;  Буферы:
; Bufz  - 3апоминания под курсосром
; KURSA - курсор
;  Быть 3аданы сразмером соответствующим
; Курсору
; КУРСОР:мИн.PA3MEP 2znak.X1pix.
;  Должно быть 8 спрайтов
; (Курсор,маска,и тд.) каждый
;  И3 которых сдвинут слева на право на p
; ix.

;  Перед вызовом необходимо стирать буфер
;      Directj


ServeJoystick   ; orig: Servkj
; Опрос джойстика Kempston
; Service kempston joystic
            ld   a,0                ; FLAG
            and  a
            ret  nz
            in   a,(PORT_KEMPSTON)
            jp   CursorMove

ServeKeyboard   ; orig: Servqa
; Опрос клавиатуры (Q A O P, Space, M)
; Service qaop sp
            ld   e,0
            ld   c,PORT_ULA
            ld   hl,(KUP)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  3,e                ; UP
            ld   hl,(KDOWN)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  2,e                ; DOWN
            ld   hl,(KLEFT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  1,e                ; LEFT
            ld   hl,(KRIGHT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  0,e                ; Right
            ld   hl,(KFIRE)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  4,e                ; FIRE
            ld   hl,(KCANCEL)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  5,e                ; Cancel
            ld   a,e

CursorMove   ; orig: Gomove
; Сдвиг курсора по нажатому направлению
; Вызов проц. изменения координаты взав
;  Ис
; Мости от нажатой кнопки

;  Изменяются переменныесостояния нажатия
; Каких либо клавиш left,rihgt,up,down,f
; Ire,cancel
            ld   e,a
            ld   hl,Directj
            xor  a
            ld   d,a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a
            inc  hl
            xor  a
            rrc  e
            adc  a,a
            or   (hl)
            ld   (hl),a

            rrc  e
            res  5,e
            res  6,e
            ld   hl,Rlud
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a

            ld   de,SP1
            push de

            ld   bc,(Mcoord)
Speed
            ld   e,1
; Скорость курсора
Bord2
            ld   d,0
; Нижняя граница
Bord1
            ld   a,0
;  Правая граница
            jp   (hl)
SP1
            ld   (Mcoord),bc
            ret

ClearInput   ; orig: Cler
; Сбросить состояния предыдущего действия
            ld   hl,Directj
            xor  a
            rept 5
            ld   (hl),a
            inc  hl
            endr
            ld   (hl),a
            ret
Directj
            db   0                  ; Right
            db   0                  ; LEFT
            db   0                  ; DOWN
            db   0                  ; UP
            db   0                  ; FIRE
            db   0                  ; Cancel

Rlud        dw   .Nthmove
            dw   .Rud                ; Right
            dw   .Lud                ; LEFT
            dw   .Nthmove
            dw   .Dow                ; DOWN
            dw   .Rtdn               ; Right anddown
            dw   .Ltdn               ; LEFT andDOWN
            dw   .Nthmove
            dw   .Upi                ; UP
            dw   .Rtup               ; RIGHT andUP
            dw   .Ltup               ; LEFT andUP
            dw   .Nthmove
            dw   .Nthmove
            dw   .Nthmove
            dw   .Nthmove
            dw   .Nthmove

.Ltup
; Влево и bbepx
            ld   a,c
            sub  e
            jp   nc,$+4
            xor  a
            ld   c,a
            ld   a,b
            sub  e
            ld   b,a
            ret  nc
            ld   b,0
            ret
.Ltdn
; Влево и вниз
            ld   a,c
            sub  e
            jp   nc,$+4
            xor  a
            ld   c,a
            ld   a,b
            add  a,e
            ld   b,a
            cp   d
            ret  c
            ld   b,d
            ret
.Rtup
; Вправо и bbepx
            ld   l,a
            ld   a,c
            add  a,e
            ld   c,a
            jp   c,$+7
            cp   l
            jp   c,$+4
            ld   c,l
            ld   a,b
            sub  e
            ld   b,a
            ret  nc
            ld   b,0
            ret
.Rtdn
; Вправо и вниз
            ld   l,a
            ld   a,c
            add  a,e
            ld   c,a
            jp   c,$+7
            cp   l
            jp   c,$+4
            ld   c,l
            ld   a,b
            add  a,e
            cp   d
            ld   b,a
            ret  c
            ld   b,d
            ret
.Lud
; Влево
            ld   a,c
            sub  e
            ld   c,a
            ret  nc
            ld   c,0
            ret
.Rud
; Вправо
            ld   l,a
            ld   a,c
            add  a,e
            jp   c,$+6
            ld   c,a
            cp   l
            ret  c
            ld   c,l
            ret
.Nthmove
            ret
.Upi
; Bbepx
            ld   a,b
            sub  e
            ld   b,a
            ret  nc
            ld   b,0
            ret
.Dow
; ВНИЗ
            ld   a,b
            add  a,e
            cp   d
            ld   b,a
            ret  c
            ld   b,d
            ret
