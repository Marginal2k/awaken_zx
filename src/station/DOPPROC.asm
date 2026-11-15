;==============================================================================
; DOPPROC - вспомогательные процедуры: окна, списки, ввод кода клавиши, торговля, ГСЧ
;
; Где живёт: основной образ STATIONF.C, после BODY.
;
; Содержит: очистку окна по знакоместам (ClearWindowChars), ReadKey / PortToCode / PortsToCodes /
; CodesToPorts (настройка клавиш, TBKP), прокрутку списков и пометки строк (ScrollList, MarkRow*, EraseMark),
; вывод текста по индексу (PrintTextByIndex, FindTextByIndex), параметры окна (SaveWindowParams),
; данные планет (PlanetInfo*), пункты системного меню (MenuHideAll ... MenuRestore, кнопка M),
; окно ошибки (OpenErrorWindow), генераторы случайных чисел (Random, RandomSeed, RNDD),
; генерацию таблицы количеств и цен товаров (RandomizeTrade). См. GAME_DESIGN 3.1, 5.3, 1.3.
;==============================================================================

; Вывод спрайта в окне
; hl-спрайт 4Х4

DrawSpriteInWindow   ; orig: INWIN
; Вывод спрайта 4x4 в окне
            push hl
            ld   a,(WinBeginY+1)
            add  a,#05
            ld   l,a
            ld   a,(WinBeginX+1)
            add  a,#05
            ld   e,a
            ld   h,high(TBXX)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            add  a,(hl)
            ld   e,a
            pop  hl
            ld   a,32
.I_W1
            ex   af,af'
            ld   a,e
            ldi
            ldi
            ldi
            ldi
            ld   e,a
            NEXTLINEDE
            ex   af,af'
            dec  a
            jp   nz,.I_W1
            ret

ClearWindowChars   ; orig: CLINW
; Стереть окно по знакоместам
;  Стереть в окне по знакоместам расположе
;  Нное окно
;  ВСЕ ДАННЫЕ В Bxyw,Exyw
            ld   a,(WinBeginY+1)
            add  a,#0D
            ld   l,a
            ld   a,(WinBeginX+1)
            add  a,#05
            ld   e,a
            ld   h,high(TBXX)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            add  a,(hl)
            ld   e,a
            ld   a,(WinEndX+1)
            rra
            rra
            rra
            and  #1F
            sub  31
            neg
            add  a,a
            ld   c,a
            ld   b,0
            ld   hl,JJ7_7
            add  hl,bc

            ld   a,(WinEndY+1)
            sub  #0D
            rra
            rra
            rra
            and  #1F
            ld   b,a

            ld   a,(INVERSE)
            rra
            ld   a,#FF
            jr   nc,$+3
            inc  a
            ld   (CW00+1),a

            ld   (STK9+1),sp
CW1
            ld   sp,STKO
CW00
            ld   a,#FF
CW2
            rept 8
            ld   c,e
            jp   (hl)
            endr
            ld   a,e
            add  a,32
            ld   e,a
            jr   c,$+6
            ld   a,d
            sub  8
            ld   d,a
            djnz CW1

STK9
            ld   sp,0
            ret

JJ7_7
            rept 29
            ld   (de),a
            inc  e
            endr
            ld   (de),a
            ld   e,c
            inc  d
            ret

            dw   0
STKO
            dw   CW2+2
            dw   CW2+4
            dw   CW2+6
            dw   CW2+8
            dw   CW2+10
            dw   CW2+12
            dw   CW2+14
            dw   CW2+16
            dw   CW2+18

ReadKey   ; orig: READKEY
; Ждать и прочитать код клавиши
;  Чтение код клавиши не выходит пока не
;  Нажто что нибудь
            push bc
            push hl
            push de
            ld   b,10
            halt
            djnz $-1
            ld   bc,#7FFE
.R_K1
            ld   e,#80
            in   a,(c)
            rept 5
            rlc  e
            rrca
            jr   nc,.R_K2
            endr
            rrc  b
            jr   .R_K1
.R_K2
            ld   c,e
            call PortToCode
            pop  de
            pop  hl
            pop  bc
            ret

PortToCode   ; orig: TCODE
; Порт и маска -> код клавиши
; b-PORT,c-MASK
; reta-CODE
            ld   hl,TBKP-2
            INC_HL 2
            ld   a,(hl)
            cp   b
            jr   nz,$-4
            inc  hl
            ld   a,(hl)
            dec  hl
            cp   c
            jr   nz,$-10
            ld   bc,0-TBKP
            add  hl,bc
            ld   a,l
            srl  a
            add  a,29
            ret


PortsToCodes   ; orig: TOCODE
; Преобразовать порты в коды
;  Преобр. порты в коды
; bc-коды,de-порты
            push hl
.T_R2
            ld   a,(bc)
            and  a
            jr   z,.T_R1
            push bc
            ld   a,(de)
            cp   #7F
            jr   nc,.T_R4
            add  a,"0"
            jr   .T_R3
.T_R4
            cp   #80
            ld   a,"N"
            jr   z,.T_R3
            ld   a,(de)
            cp   #81
            ld   a,"Y"
            jr   z,.T_R3
            ld   a,(de)
            ld   b,a
            inc  de
            ld   a,(de)
            ld   c,a
            dec  de
            call PortToCode
.T_R3
            INC_DE 2
            pop  bc
            ld   (bc),a
            inc  bc
            jr   .T_R2
.T_R1
            pop  hl
            ret


CodesToPorts   ; orig: TOPORT
; Преобразовать коды в порты и маски
;  Преобр. коды в порты и маски
; bc-коды,de-порты
            push hl
.T_T2
            ld   a,(bc)
            and  a
            jr   z,.T_T1
            sub  29
            add  a,a
            add  a,low(TBKP)
            ld   l,a
            ld   a,high(TBKP)
            adc  a,0
            ld   h,a
            ld   a,(de)
            cp   #7F
            jr   c,.T_T6
            jr   z,.T_T4
            cp   #82
            jr   nc,.T_T4
            ld   a,(bc)
            cp   "Y"
            ld   a,#81
            jr   z,.T_T5
            ld   a,(bc)
            cp   "N"
            ld   a,#80
            jr   z,.T_T5
.T_T6
            ld   a,(bc)
            sub  "0"
.T_T5
            ld   (de),a
            inc  de
            jr   .T_T3
.T_T4
            ld   a,(hl)
            ld   (de),a
            inc  de
            inc  hl
            ld   a,(hl)
            ld   (de),a
.T_T3
            inc  de
            inc  bc
            jr   .T_T2
.T_T1
            pop  hl
            ret


Sct3
            pop  de
            ld   (Mcoord),de
            call CursorDrawSafe
            ret


ScrollList   ; orig: SCROL
; Прокрутка списка в окне
; hl-индекс в списке с которого видим
;  Список
; a-смещение, кот. нужно отступить
;  Что б не стирать
; rethl-ИНДЕКС
;  Надо задать адрес в переменной PROOUT
;  Кот. выходит на процедуру вывода в окне
;  Всего текста
;  Так же надо задать EINDX = числу строк
            ld   (SCRLS+1),a
            ld   c,a

            push bc
            push hl
            PAGE_ #17
            ld   hl,#5800
            ld   de,#D800
            ld   bc,#0300
            ldir
            PAGE___NOARG
            pop  hl
            pop  bc

;  Флажок что еще не было перепечатки
;  Экрана
            ld   a,(WinEndY+1)
            sub  c
            ret  c
            ret  z
            ld   (Amlin+1),a

            rra
            rra
            rra
            and  %00011111
            ld   c,a
            ld   de,(Mcoord)
            push de
            call CursorRestoreSafe
Sct1
            call ReadFireCancel
            jr   z,Sct3
            ld   a,c
            and  a
            jr   z,Sct1
            ld   a,(Mcoord+1)
            ld   d,a
            ld   a,(WinBeginY+1)
            ld   e,a
            ld   a,(WinEndY+1)
            srl  a
            add  a,e
            ld   b,a
            ld   a,(SCRLS+1)
            srl  a
            add  a,b
            cp   d
            jp   c,.Sct2
; Cat up, scrl down
            ld   a,l
            or   h
            jr   z,Sct1
            dec  hl
            jp   Sct28
.Sct2
; Cat down, scrl up
EINDX
            ld   de,0
            EXD
            SUB_DE
            ld   b,0
            sbc  hl,bc
            EXD
            jr   z,Sct1
            jr   c,Sct1
            inc  hl
Sct28
            push bc
            push hl
;  Перепечатка была
            PAGE_ #17
            ld   hl,#4000
            ld   de,#C000
            ld   bc,#1800
            ldir
            PAGE_ #18

            halt

Amlin
            ld   a,0
; Колич строк для стир* 8
            call ClearInWindow

            pop  hl
            push hl

;  Процедура вывода в окне всего списак
;  В зависимости от индекса в hl
PROOUT
            call 0
            pop  hl
            call ShowCursorBack+3           ; Без вывод курсора
            pop  bc

            jp   Sct1


;  Удалить последнюю пометку
; a-номер ее,ix-вектор

DeleteLastMark   ; orig: DELMK
; Удалить последнюю пометку
            inc  a
            ret  z
            dec  a
            push af
            call TESTM_
            call CursorRestoreSafe
            pop  af
            call EraseMark
            jp   CursorDrawSafe

TESTM2
;  Получаем Y координату
            ld   a,(Mcoord+1)
            ld   c,a
            ld   a,(ix+1)
            rlca
            rlca
            rlca
            and  #F8
;  Смещаем к строкам меню
            add  a,e
            ld   b,a
            ret

TESTM_
;  Только для окон со сменным размером
;  Определяем количество видимых пунктов
; d-кол.пунктов всего в списке
; ix-вектор
            ld   a,(ix+3)
            rlca
            rlca
            rlca
            sub  e
            sub  5
            and  #F8
            sla  d
            sla  d
            sla  d
            cp   d
            ret  nc
            ld   d,a
            ret


TESTM
; ix-вектор
; e-смещение по вертикали от начала окна
;  И до начала меню в пикселях
; d-кол.пунктов*8
; ret:
; Fc-on вылет какой то
; c-номер пункта
            call TESTM2
            ld   a,c
            sub  b
            ret  c                  ; Слишком высоко
            cp   d                  ; Кол.пунктов*высота
            ccf
            ret  c                  ; Слишком низко
            rrca
            rrca
            rrca
            and  #1F
            ld   c,a
            ret


DrawMark   ; orig: CHOOSE
; Вывод пометки строки
;  Вывод пометки
; ix-вектор окошка
; e-смещение по вертикали от начала окна
;  И до начала меню в пикселях
; d-кол.пунктов*8
; retd-НОМЕР ПУНКТА
            call TESTM
            ret  c
            ld   d,a
            jr   $+7

EraseMark   ; orig: DELCH
; Удаление пометки
;  Удаление пометки
; a-номер пункта
            ld   d,a
            call TESTM2
            ld   a,d
            rlca
            rlca
            rlca
            add  a,b
            cp   192-8
            ret  nc                 ; Вылет снизу
            ld   b,a
;  В "D"-номер пункта
;  В "B"-реальная координата Y пункта


;  Адрес на экране
            ld   a,(ix+0)           ; Коорд.X окна
            and  a
            jp   p,$+4
            xor  a
            rlca
            rlca
            rlca
            ld   c,a

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

            ld   b,(ix+2)
            ld   a,(ix+0)
            add  a,b
            sub  #21
            jr   c,.Q_2
            sub  b
            cpl
            dec  a
            ld   e,%10101010
            jr   .Q_1
.Q_2
            ld   a,b
            sub  2
            ld   e,0
            bit  7,(ix+0)
            jr   z,.Q_1
            inc  a
            add  a,(ix+0)
            ld   e,%01010101
.Q_1
            ld   b,a

            PAGES PGKRT
            call PaintMarkRow
            PAGES__NOARG
            ret


MarkRowStretch   ; orig: MARKO
; Пометить строку (окна с изменяемым размером)
;  Маркирует строку и стирает старый марк
;  Только для растягиваемых окон!!!!
; a-номер пункта
; d-кол. видимых пунктов,е-верхнее
; hl-шоу адрес окна
;  Смещение до первой строки
; ix-вектор
; Retfz-on если не надо запоминать
;  Новый номер пункта
; Reta-новый номер пункта
            push af
            push de
            EXD
            call LastDeskObject
            SUB_DE
            pop  de
            jr   nz,.MO1
            call TESTM_
            call TESTM
            jr   nc,$+5
.MO1
            pop  af
            xor  a
            ret
            pop  af
            cp   c
            ret  z
            call CursorRestoreSafe
            inc  a
            jr   z,$+8
            dec  a
            push de
            call EraseMark
            pop  de
            call DrawMark
            call CursorDrawSafe
            xor  a
            inc  a
            ld   a,d
            ret


MarkRowFixed   ; orig: MARKo
; Пометить строку (окна с фиксированным размером)
;  Маркирует строку и стирает старый марк
;  Только для не растягиваемых окон!!!!
; a-номер пункта
; d-кол. видимых пунктов,е-верхнее
; hl-шоу адрес окна
;  Смещение до первой строки
; ix-вектор
; Retfz-on если не надо запоминать
;  Новый номер пункта
; Reta-новый номер пункта
            push af
            push de
            EXD
            call LastDeskObject
            SUB_DE
            pop  de
            jr   nz,.MO2
            call TESTM
            jr   nc,$+5
.MO2
            pop  af
            xor  a
            ret
            pop  af
            cp   c
            ret  z
            call CursorRestoreSafe
            inc  a
            jr   z,$+8
            dec  a
            push de
            call EraseMark
            pop  de
            call DrawMark
            call CursorDrawSafe
            xor  a
            inc  a
            ld   a,d
            ret


PrintTextByIndex1   ; orig: LIST1
; Вывод текста по индексу, раздел 1
;  Вывод текста по индексу в ас 0
; hl-весь текст, разд. 1
            call FindTextByIndex1
            jp   OutText

PrintTextByIndex0   ; orig: LIST0
; Вывод текста по индексу, раздел 0 (через OTXT)
            call FindTextByIndex
            jp   PrintText

PrintTextByIndex   ; orig: LIST
; Вывод текста по индексу, раздел 0
;  Вывод текста по индексу в ас 0
; hl-весь текст, разд. 0
            call FindTextByIndex
            jp   OutText

FindTextByIndex1   ; orig: FLIST1
; Поиск текста по индексу, раздел 1
            push af
            ld   a,CR
            ld   (RAZD+1),a
            pop  af
            call FindTextByIndex
            ld   a,ET
            ld   (RAZD+1),a
            ret

FindTextByIndex   ; orig: FLIST
; Поиск текста по индексу
;  Поиск текста по индексу
            push de
            push bc
            inc  a
            ld   e,a
            ld   b,#FF
RAZD
            ld   a,ET
            cpir
            dec  e
            jp   nz,$-3
            pop  bc
            pop  de
            ret


PrintPlanetInfo   ; orig: PLIN
; Вывод информации о планете
;  Вывод инфо о плнете
; hl,de-данные генерации системы

            ld   a,h
            cp   4
            jr   nz,.U_1
;  Строй неизвестный
            ld   a,4
.U_3
            ld   hl,STROY
            call PrintTextByIndex
            ld   a,(Cord+1)
            add  a,8
            ld   h,a
            ld   l,#10
            ld   (Cord),hl
            RST_ "-"
            ld   a,(Cord+1)
            add  a,8
            ld   h,a
            ld   l,#22
            ld   (Cord),hl
            RST_ "-"
            ret

.U_1
;  Получение данных о планете
;  Если необитаемая то никаких уровней
            cp   3
            jr   z,.U_3

            push hl

            ld   hl,STROY
            call PrintTextByIndex
;  ТИП
            ld   a,(Cord+1)
            add  a,8
            ld   h,a
            ld   l,#12
            ld   (Cord),hl
            ld   a,e
            ld   hl,TYPE
            call PrintTextByIndex
;  Уровень
            pop  bc
            ld   a,(Cord+1)
            add  a,8
            ld   h,a
            ld   l,#22
            ld   (Cord),hl
            ld   b,0
            xor  a
            call PrintNumberPad
            ret


SaveWindowParams   ; orig: STOREW
; Запомнить параметры окна
;  Запомнить данные окна
            ld   a,(WinBeginX+1)
            ld   (BXW+1),a
            ld   a,(WinBeginY+1)
            ld   (BYW+1),a
            ld   a,(WinBeginXHi+1)
            ld   (BXH+1),a
            ld   a,(WinBeginYHi+1)
            ld   (BYH+1),a
            ld   a,(WinEndX+1)
            ld   (EXW+1),a
            ld   a,(WinEndY+1)
            ld   (EYW+1),a
            ld   a,(Cord)
            ld   (_Cord+1),a
            ld   a,(Cord+1)
            ld   (_Cord2+1),a
            ld   a,(Mode+1)
            ld   (_Mode+1),a
            ret

RestoreWindowParams   ; orig: RESTORW
; Восстановить параметры окна
;  Восстановить данные окна
BXW
            ld   a,0
            ld   (WinBeginX+1),a
BYW
            ld   a,0
            ld   (WinBeginY+1),a
BXH
            ld   a,0
            ld   (WinBeginXHi+1),a
BYH
            ld   a,0
            ld   (WinBeginYHi+1),a
EXW
            ld   a,0
            ld   (WinEndX+1),a
EYW
            ld   a,0
            ld   (WinEndY+1),a
_Mode
            ld   a,0
            ld   (Mode+1),a
_Cord
            ld   a,0
            ld   (Cord),a
_Cord2
            ld   a,0
            ld   (Cord+1),a
            ret


PlanetInfoHere   ; orig: PINFO2
; Данные планеты текущего местонахождения
;  Данные о планете нахождения
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)

PlanetInfo   ; orig: PINFO
; Данные планеты системы по номеру
;  Дача инфо о планете на системе
; hl,de-данные системы
; a-номер планеты с 0
; ret
; a=0-в системе нет планет
; a-кол. планет
; l-уровень 1-16
; h-строй 0-4
; e-ТИП 0-3
            ex   af,af'
            PAGES PGKRT
            ex   af,af'
            call GetSystemData
            ex   af,af'
            PAGES__NOARG
            ex   af,af'
            ret

; Для вызова из страницы языка

PlanetInfoHereLang   ; orig: PINFOL2
; PINFO2 для вызова из страницы языка
            call PlanetInfoHere
            ex   af,af'
            PAGES PGLANG
            ex   af,af'
            ret
; Для вызова из страницы языка

PlanetInfoLang   ; orig: PINFOL
; PINFO для вызова из страницы языка
            call PlanetInfo
            ex   af,af'
            PAGES PGLANG
            ex   af,af'
            ret


ShowCursorBack   ; orig: RETSCR
; Вернуть курсор после вывода
            call CursorDrawSafe
            PAGE___NOARG
            ret

HideCursor   ; orig: HIDESCR
; Убрать курсор перед выводом в экран
            push hl
            push de
            push bc
            ld   a,1
            ld   (CursorBusy+1),a
            PAGE_ #17
            ld   hl,#4000
            ld   de,#C000
            ld   bc,#1B00
.HS1
            rept 256
            ldi
            endr
            jp   pe,.HS1
            call CursorRestoreSafe
            pop  bc
            pop  de
            pop  hl
            PAGE_ #18
            ret


TestWindowOut   ; orig: TESTSZ
; Проверка вылета окна за экран
; hl-номер объекта
; Retfc-off если вылет окна
            xor  a
            call ObjFieldAddr
            ld   e,(hl)
            inc  hl
            bit  7,e
            ret  nz
            ld   d,(hl)
            inc  hl
            bit  7,d
            ret  nz
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            ld   a,l
            add  a,e
            cp   33
            ret  nc
            ld   a,h
            add  a,d
            cp   25
            ret  nc
            ld   a,l
            cp   4
            ccf
            ret  nc
            ld   a,h
            cp   4
            ccf
            ret


LineWindow2   ; orig: LINE2
; Описатель линии (нижняя строка)
            jp   $+3
            ret

LINE2_
            ld   hl,0
            ld   a,1
            ld   (Mode+1),a
            ld   a,(INVERSE)
            push af
            ld   a,#80
            ld   (INVERSE),a
            call Outln2
            pop  af
            ld   (INVERSE),a
            ld   a,3
            ld   (Cord),a
            ld   bc,(TIME)
            ld   a,b
            and  #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0"
            RST___NOARG
            ld   a,b
            and  #0F
            add  a,"0"
            RST___NOARG
            ld   a,c
            and  #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0"
            RST___NOARG
            ld   a,c
            and  #0F
            add  a,"0"
            RST___NOARG

            RST_ ":"

            ld   a,(TIME+2)
            ld   c,a
            and  #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0"
            RST___NOARG
            ld   a,c
            and  #0F
            add  a,"0"
            RST___NOARG

            RST_ ":"

            ld   a,(TIME+3)
            ld   c,a
            and  #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0"
            RST___NOARG
            ld   a,c
            and  #0F
            add  a,"0"
            RST___NOARG
            ret


MenuHideAll   ; orig: HIDEP1
; Пункт меню: скрыть все
;  Скрыть все
            ld   hl,DoNothing
            ld   (TaskCall+1),hl
            ld   a,1
            ld   (SurroundActivate+1),a
            rept 5
            halt
            endr
            ret

MenuCloseWindows   ; orig: HIDEP2
; Пункт меню: закрыть окна
;  Закрыть окна
            ld   hl,DoNothing
            ld   (TaskCall+1),hl
            ld   ix,Sur1
.HP_2
            ld   h,(ix+1)
            dec  h
            ret  z
            inc  h
            ld   l,(ix+0)
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            push hl
            call ObjFieldAddr4
            ld   a,(hl)
            and  %11000000
            pop  de
            inc  ix
            inc  ix
            jr   z,$+8
            ld   a,(hl)
            cpl
            and  %01100000
            jr   nz,.HP_2
            call CloseObject
            dec  ix
            dec  ix
            jp   .HP_2


MenuSaveSurround   ; orig: HIDEP3
; Пункт меню: запомнить среду
;  Запомнить среду
            ld   ix,Objvec
            ld   de,16
.H_11
            ld   a,(ix+0)
            cp   #80
            ret  z
            ld   a,(ix+0)
            ld   (ix+8),a
            ld   a,(ix+1)
            ld   (ix+9),a
            ld   a,(ix+2)
            ld   (ix+10),a
            ld   a,(ix+3)
            ld   (ix+11),a
            add  ix,de
            jr   .H_11

MenuArrange   ; orig: HIDEP4
; Пункт меню: расставить
;  Расставить
            jp   SetupCoords

MenuSetupSurround   ; orig: HIDEP5
; Пункт меню: установки среды
;  Установки среды
            ld   hl,WSETS_
            jp   OpenObject

MenuSetupGame   ; orig: HIDEP6
; Пункт меню: установки игры
;  Установки игры
            ld   hl,WSETG_
            jp   OpenObject

MenuRestore   ; orig: HIDEP7
; Пункт меню: восстановиться
;  Восстановиться
            ld   hl,WWOS_
            jp   OpenObject


PlanetCount   ; orig: AMPLAN
; Количество планет в системе
;  Количество планет в системе
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            ld   a,h
            xor  l
            xor  e
            xor  d
            and  7
            dec  a
            ret  p
            xor  a
            ret


PressButtonPair   ; orig: NATISNU
; Нажатие одной кнопки и отжатие другой
; de-текущая кнопка
; hl-другая кнопка
            push de
            ld   e,l
            ld   d,h
            call ObjFieldAddr4
            res  0,(hl)
            ld   h,d
            ld   l,e
            call CursorRestoreSafe
            call OutButton
            call CursorDrawSafe
            pop  hl
            ld   e,l
            ld   d,h
            call ObjFieldAddr4
            set  0,(hl)
            ld   h,d
            ld   l,e
            call CursorRestoreSafe
            call OutButton
            call CursorDrawSafe
            ret


CountTextLines   ; orig: KOLLIN
; Количество строк в тексте
;  Считает количество строк в тексте
; hl-текст
; retde-КОЛ.
            ld   de,0
            xor  a
            ld   (Cord),a
.D_I1
            ld   a,#08
            ld   (Cord+1),a
            push de
            call VirtualPrint
            pop  de
            inc  de
            jp   nc,.D_I1
            ret

PrintFromLine   ; orig: FROMLIN
; Вывод текста с номера строки
;  Вывод текста с номера линии
; e-номер
; hl-текст
; bc-коорд. вывода
            ld   (Cord),bc
            ld   a,e
            and  a
            jp   z,PrintText
.D_I2
            push de
            push bc
            call VirtualPrint
            pop  bc
            pop  de
            ld   (Cord),bc
            ret  c
            dec  e
            jp   nz,.D_I2
            jp   PrintText


OpenErrorWindow   ; orig: OPENER
; Подготовить и вывести окно ошибки
;  Готовит окно ошибки и выводит его
; a-номер ошибки с 0
            push af
            ld   (NERR+1),a
            ld   hl,WERR_
            call OpenObject
            pop  af
            ret

OpenErrorWindowLang   ; orig: OPENER_L
; OPENER для вызова из страницы языка
            push af
            PAGES PGNORM
            pop  af
            call OpenErrorWindow
            PAGES PGLANG
            ret


; ────────────────────────────────────────

; Генераторы

Random   ; orig: RND
; Генератор случайных чисел
            exx
            ld   hl,Sdo
            jp   RandomSeed
.RNDW
            exx
            ld   hl,.Sdw
            jp   RandomSeed
.RNDK1
            exx
            ld   hl,Sdk1
            jp   RandomSeed
.RNDK2
            exx
            ld   hl,Sdk2
            jp   RandomSeed
.RNDK3
            exx
            ld   hl,Sdk3
            jp   RandomSeed
.RNDT2
            exx
            ld   hl,Sdt2
            jp   RandomSeed
.RNDT1
            exx
            ld   hl,Sdt1
            jp   RandomSeed
.Sdw
            db   7,8,0
Sdo
            db   101,0,0
Sdt2
            db   44,0,0
Sdt1
            db   21,0,0
Sdk1
            db   247,0,0
Sdk2
            db   93,0,0
Sdk3
            db   29,0,0

RandomSeed   ; orig: RNDO
; Генератор по адресу семени в HL
; inhlADR OF SEED
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
            ld   h,a                ; 0
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


TradeEmpty   ; orig: NORT
; Нет планет: таблица торговли пуста
; Нет планет всю таблицу забить пустыми
; Данными

            ld   hl,TWRS
            ld   de,TWRS+1
            ld   bc,TKOL*2-1
            ld   (hl),0
            ldir
            ret

RandomizeTrade   ; orig: RANDTT
; Генерация таблицы количеств и цен товаров
; Генерилка таблицы колич. товаров и цен
            call PlanetInfoHere
            jr   z,TradeEmpty

            ld   a,h
            cp   4
            jr   z,TradeEmpty
            ld   (PSTROY+1),a

            ld   a,e
            ld   (PTYPE+1),a

            ld   hl,(PLACE+2)
            ld   (Sdo),hl
            ld   a,(TIME+2)
            and  %11111100
            ld   c,a
            ld   a,(PLANET)
            xor  c
            ld   (Sdo+2),a
; ТОВАРЫ ПРОПУСКАЯ АРТЕФАКТЫ, технологии и
; уникумы
            ld   hl,SPECTO
            exx
            ld   ix,CENS2
            ld   hl,TWRS+1
            ld   b,TKOL-3
RTB1
            push hl
            exx
            push hl
            exx
            call Random
            exx
            pop  hl
            exx
            ld   a,l
            and  #07
            bit  7,l
            jr   z,$+4
            neg
            add  a,(ix+0)
            ld   e,h
            pop  hl
            ld   d,a
            exx
PTYPE
            ld   a,0
            cp   (hl)
            inc  hl
            ld   e,0
            jr   nz,$+4
            ld   e,8
            exx
            ld   a,d
            exx
            sub  e
            exx
            jr   z,$+4
            jr   nc,$+4
            ld   a,5
            ld   (hl),a
            dec  hl

            ld   a,(ix+1)
            and  a
            ld   d,#3F
            jr   z,RTB3
            dec  a
            jr   nz,.RTB4
            ld   a,e
            and  %11000000
            ld   d,#BF
            jr   z,RTB3
            ld   d,#3F
            jr   RTB3
.RTB4
            dec  a
            ld   d,#BF
            jr   z,RTB3
PSTROY
            ld   a,0
            and  a
            jr   nz,RTB3
            set  7,e
            res  5,e
            res  4,e
RTB3
            ld   a,e
            and  d
            ld   c,a
            res  7,c
ZAPRET
            and  #80
            ld   d,a
            ld   a,c
            exx
            add  a,e
            sub  10                 ; ДЛЯ ТОГО что б БЫЛО
; Больше пустых строчек
            jr   nc,$+3
            xor  a
            exx
            or   d
            ld   d,a
            ld   a,(ZAPRET+1)
            xor  #80
            and  (hl)
            or   d
            ld   (hl),a
            inc  hl
; Изменение цены от количества на станции
; Прямо пропорционально
            rra
            and  #3F
            cp   8
            jr   c,$+4
            ld   a,8
            sub  (hl)
            jr   c,$+4
            ld   a,#FB
            neg
            ld   (hl),a
            inc  hl
            inc  hl
            inc  ix
            inc  ix
            dec  b
            jp   nz,RTB1
            dec  hl
            ld   (hl),0
            inc  hl
            ld   a,(ix+0)
            ld   (hl),a
            inc  hl
            ld   (hl),0
            inc  hl
            ld   a,(ix+2)
            ld   (hl),a
            inc  hl
            ld   (hl),0
            inc  hl
            ld   a,(ix+4)
            ld   (hl),a
            ret


RNDD
            push bc
            ld   hl,(RNDD1)
            ld   de,(RNDD2)
            ld   c,h
            ld   b,l
            inc  hl
            inc  h
            add  hl,de
            ld   a,e
            adc  a,l
            ld   c,a
            add  hl,bc
            ld   a,l
            xor  c
            xor  #75
            ld   l,e
            ld   e,a
            ld   a,h
            xor  b
            xor  #A7
            ld   h,d
            ld   d,a
            ld   (RNDD1),hl
            ld   (RNDD2),de
            ld   a,d
            xor  e
            xor  h
            xor  l
            pop  bc
            ret

SelectedShipNumber   ; orig: NUMSHIP
; Номер выбранного корабля/скимера
; Получет номер корабля или скимера
; Текущго выбранного в списке
; bc-номер
            PAGES PG3D
            ld   bc,(ShipIndex+1)
            ld   a,(ShipListFrom+1)
            add  a,c
            ld   c,a
            ld   b,0
            PAGES PGLANG
            ret
