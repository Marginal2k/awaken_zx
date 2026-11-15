;==============================================================================
; LANG - интерпретатор языка сценариев Paradox v1.0 (оверлей LANG.C)
;
; Где живёт: LANG.C, ORG #C000, страница PGLANG (#16).
;
; Вход: PARADOX (ix = программа CHECK_SCENARY из rules.paradox, OPERATION = номер операции торговли).
; Язык: команды _IF/_THAN/_ELSE/_NEXT/_CHANGE/..., аргументы (U_*/S_* - свойства на борту/на станции),
; операции (_PLUS, _EQUALLY...), таблицы символов CODE, CODE2..CODE15 с количествами KCOMn.
; Выполняет правила торговли и полиции при каждой сделке; результат - состояние окна/ошибки.
; Служебные: ReadNumber, ReadArgument, ReadOperator, JumpBySymbol, FindSymbol, PutWord/PutByte.
; Ниже сохранена легенда команд исходного файла. См. GAME_DESIGN 1.2, 4.4-4.5.
;==============================================================================

; Команды
; │_IF│_THAN│_ELSE│_NEXT│_CHANGE│_OVER
; │_ON│_OFF │_OPEN│_EXIT│_CLOSE │_MESSAGE
; │_TONN    │_mESSAGE   │_WYDWOR│
; Операнды переключения
; │T_TXT │T_HAPP│T_QUES│T_PERS│T_SKM│T_KRB
; │T_MISS│
; Аргументы
; │S_SHIP│U_WSKM│_MISSION│S_SKIMMER │_YES
; │U_SHIP│U_WKRB│_PERSTXT│U_SKIMMER │_NO
; │_TONAJ│U_SUMM│_HAPPAND│_STATUS   │_TXT
; │_MASSA│S_WKRB│U_CARGO │_NUMBER   │
; │_SKOBA│S_WSKM│S_CARGO │_OPERATION│
; │P_PLANET│R_PLANET│P_SYSTEM│R_SYSTEM
; Свойства
; │_SWKRB_C │_SWKRB_V │_UWKRB_S │_UCARGO_C
; │_SWKRB_S │_SWKRB_K │_SWSKM_C │_SCARGO_C
; │_SWSKM_V │_UWSKM_S │_SWSKM_S │_SCARGO_S
; │_SWSKM_K │_UWSKM_N │_SHIP_C  │_SKIMER_V
; │_Ukwrb_n │_SCARGO_M│_SHIP_S  │_SKIMER_C
; │_SHIP_T  │_PLANET_S│_PLANET_C│_PLANET_U
; │_SYSTEM_P│_SYSTEM_G│
; Процедуры
; │ReadNumber │ReadJumpAddress  │JumpBySymbol  │CountTonnage
; │ReadArgument │ReadHandlerAddress  │ReadOperator│RUN
; │ProcessArgument │FindSymbol  │FindTextInTree│T_NWKRB
; │T_NWSKM │T_NTWR    │PutWord   │PutByte
; │TakePlanetInfo│
; Операции
; │_PLUS │_EQUALLY│_LESS│_LESSEQ│_MORE
; │_MULTI│_MOREEQ │_OR  │_MINUS │_AND│_SET
; Операнды Изменения значения
; │STATU_S │GRU_z│GRU_Z│WKR_B│WSK_M │SUM_M
; │TONA_J  │


; ────────────────────────────────────────
;           Paradox v1.0        13.11.99
; ────────────────────────────────────────
; ИДЕЯ:
; Читаем по очередно первый аргумент
; Меж_аргумент (операция) и второй
; Аргумент
; Сохраняем все это в буфере в виде
; Чисел (для аргументов) и адресов
; Операций (для меж_аргументов)
; После прочтения всего выше описаного
; Происходит выполнение операции освобож-
; Даем буфер на два значения (убираем
; Меж_аргумент и второй аргумент)
; Результат остается на первом месте
; Далее идет чтение меж_аргумента и опять
; Уже второго аргумента и т.д.
; Результат всегда будет первым данным в
; Буфере. различий между логическими
; Данными и числовыми никакого лог. 0,1
; Числовые 0-65535 без знака.


;
; Основной код


; Структура, процедуры языка парадокс


PARADOX
            ld   ix,CHECK_SCENARY
            ld   (ParadoxSavedSP+1),sp
; Выкл. флаг выхода на след. #0D
            xor  a
            ld   (ParadoxExitFlag+1),a
; Iхтекст
ZP1
            ld   sp,(ParadoxSavedSP+1)
            ld   a,(ix)
            or   a
            ret  z
            inc  ix
            cp   " "
            jr   nz,ZP2
; Коментарий
; Ищем след. строку, т.е. символ #0D
ZP3

ParadoxSavedSP   ; orig: STKMEM
; Сохранённый SP интерпретатора
            ld   sp,0
            ld   a,(ix)
            inc  ix
            cp   #0D
            jr   nz,ZP3+3
ZP29

ParadoxExitFlag   ; orig: F_EXIT
; Флаг выхода из языка
            ld   a,0
            or   a
            jr   z,ZP1+4
            ret
ZP2
            cp   #0D
            jr   z,ZP29

            ld   hl,CODE-3
            ld   b,KCOM

            jp   JumpBySymbol


;
; Команды


_IF
; Проверка условия
; Iхслед. символ за командой
; Установим HL' на буфер строки аргументов

            exx
            ld   hl,ParadoxArgBuf
            exx

; Читаем первый аргумент
            call ReadArgument
.ZP8
; Читаем меж_аргумент
            call ReadOperator
; Читаем второй аргумент
            call ReadArgument
            call RUN

            ld   a,(ix)
            cp   ":"
            jr   z,ZP1
            cp   "@"
            jr   nz,.ZP8
            jr   ZP1
; ----------------------------------------------------------
_THAN
            exx
            dec  hl
            ld   a,(hl)
            dec  hl
            or   (hl)
            inc  hl
            inc  hl
            exx
            jr   nz,ZP1
ZP27
; Поиск скобок если таковые есть
; И прыжок через них
            ld   a,(ix)
            cp   "{"
; Если перв. "{"
            jr   z,.ZP28

            cp   #0D
            jr   nz,ZP3
; Если сначала #0D
            ld   a,(ix+1)
            cp   "{"
            jr   nz,ZP3
; А потом "{"
            inc  ix
; ИЩЕМ "}"
.ZP28
            inc  ix
            ld   a,(ix)
            cp   "}"
            jr   nz,.ZP28
            jr   ZP3
; ----------------------------------------------------------
_ELSE
            exx
            dec  hl
            ld   a,(hl)
            dec  hl
            or   (hl)
            inc  hl
            inc  hl
            exx
            jp   z,ZP1
            jr   ZP27
; ----------------------------------------------------------
_NEXT
            jp   ZP1
; ----------------------------------------------------------
_ON
            ld   a,1
ZP26
            ld   l,a
            ex   af,af'
            ld   a,l
            ex   af,af'
            call ReadJumpAddress
            jp   ZP1
; ----------------------------------------------------------
_OFF
            xor  a
            jr   ZP26
; ----------------------------------------------------------
_CHANGE
; Установим HL' на дополнительный буфер
            exx
            push hl
            ld   hl,ParadoxArgBuf2
            exx
            call ReadHandlerAddress
            call ReadOperator
            call ReadArgument
            ld   hl,.ZP30
            push hl
            exx
            ld   de,0-6
            add  hl,de
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push de
            exx
            pop  hl
            exx
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push de
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            push de
            ld   de,0-5
            add  hl,de
; Указатель буфера на первый аргумент
            exx
            pop  bc
; В стеке адрес  операции
; bc-второй аргумент
; hl-процедура считывания первого
; Аргумента и запоминание результата
; После обработки операции
            jp   (hl)
.ZP30
            exx
            pop  hl
            exx
            jp   ZP1
; ----------------------------------------------------------
_OPEN
; Скоба открыта
            jp   ZP1
; ----------------------------------------------------------
_CLOSE
; Скоба закрыта
            jp   ZP1
; ----------------------------------------------------------
_TONN
; Подсчет тонажа и его сторинг
            ld   de,-TWRI
            call CountTonnage
            ld   (TONN),a
            jp   ZP1
; ----------------------------------------------------------
_EXIT
; Просто выход из языка
            ld   sp,(ParadoxSavedSP+1)
            ret
; ----------------------------------------------------------
_MESSAGE
; Включим флаг выхода на след. #0D
            ld   a,1
            ld   (ParadoxExitFlag+1),a
            call ReadNumber
            dec  l
            ld   a,l
; Вывести сообщение по номеру в a
            push ix
            call OpenErrorWindowLang
            pop  ix
            jp   ZP1
; ----------------------------------------------------------
_mESSAGE
; Вывод сообщения о ошибке операции
; Но без выхода из языка на след. строке
            jp   _MESSAGE+5
; ----------------------------------------------------------
_WYDWOR
            ld   a,255
            ld   (ExpelTimer+1),a
            jp   ZP1
; ----------------------------------------------------------
_OVER

; ??????????
            jp   ZP1
; ??????????
;            ld   sp,(ParadoxSavedSP+1)
;            pop  af
;            Jp   gameover


;
; Операнды команды переключения
; Вход с A'-0(выкл),1(вкл)


T_TXT
; Включение и показ текста
            ex   af,af'
            or   a
            ret  z
            call ReadNumber
            push hl

; Структура разделителя:
; _p23s8t1

; Ищем начала тестов по разделителю "_"
            ld   hl,TXTES
.ZP33
            ld   bc,0
            ld   a,"_"
            cpir
            inc  hl
; Пропустили букву "p"
; Берем номер
            push ix
            push hl
            pop  ix
            call ReadNumber
            ld   c,l
            push ix
            pop  hl
            pop  ix
; Номер текущего персонажа
            ld   a,(PERSONAJ)
            cp   c
            jp   nz,.ZP33
; Не тот персонаж
            inc  hl
; Пропустили букву "s"
; Номер сцены
            push ix
            push hl
            pop  ix
            call ReadNumber
            ld   c,l
            push ix
            pop  hl
            pop  ix
            ld   a,(SCENA)
            cp   c
            jp   nz,.ZP33
            inc  hl
; Пропустили букву "t"
; Номер текста
            push ix
            push hl
            pop  ix
            call ReadNumber
            ld   c,l
            push ix
            pop  hl
            pop  ix
            pop  de
            push de
            ld   a,e
            cp   c
            jp   nz,.ZP33
            pop  de

            ld   a,(hl)
            inc  hl
            cp   CR
            jr   nz,$-4
; Пропустили разделитель строк как #0D
; Нlадрес текста
; Dеномер текста

            ld   a,(PERSONAJ)
            ld   bc,(SCENA-1)
            push hl
            call FindTextInTree
            ld   (hl),1
            pop  hl

; Вызов процедуры вывода текста
            ret


; ----------------------------------------------------------
T_PERS
; Вкл. персонажей
            call ReadNumber
            ld   de,t_PERS-1
ZP31
            add  hl,de
            ex   af,af'
            ld   (hl),a
            ret
; ----------------------------------------------------------
T_QUES
; В. вопросы
            call ReadNumber
            ld   de,t_QUES-1
            jr   ZP31
; ----------------------------------------------------------
T_MISS
; В. миссии
            call ReadNumber
            ld   de,t_MISS-1
            jr   ZP31
; ----------------------------------------------------------
T_HAPP
; В. события
            call ReadNumber
            ld   de,t_HAPP-1
            jr   ZP31
; ----------------------------------------------------------
T_KRB
; В. кораблей
            call SelectedShipNumber
            ex   af,af'
            or   a
            ld   a,c
            jr   nz,$+4
            ld   a,#FF
            ld   (SHIP),a
            ret
; ----------------------------------------------------------
T_SKM
; В. скимеров
            call SelectedShipNumber
            ex   af,af'
            or   a
            ld   a,c
            jr   nz,$+4
            ld   a,#FF
            ld   (SKIMMER),a
            ret


;
; Аргументы


U_SUMM
            ld   de,(SUMM)

PutWord   ; orig: PUTWORD
; Положить слово в буфер аргументов
            push de
            exx
            pop  de
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            exx
            ret
; ----------------------------------------------------------
U_WKRB
            call ZP21
            jp   PutWord
ZP21
            exx
            ld   b,KCOM4
            exx
            ld   de,CODE4-3
            call T_NWKRB
            ld   hl,$+6
            jp   ProcessArgument
; Процедура чтения значения
; Сюда будет переход, если аргумент без
; Выбора свойства, с номером или без
; hl-индекс
            ld   de,WKRBI
ZP38
            add  hl,de
            ld   a,(hl)
            or   a
            jp   p,$+4
            cpl
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
U_WSKM
            call ZP22
            jp   PutWord
ZP22
            exx
            ld   b,KCOM5
            exx
            ld   de,CODE5-3
            call T_NWSKM
            ld   hl,$+6
            jp   ProcessArgument
            ld   de,WSKMI
            jr   ZP38
; ----------------------------------------------------------
U_SHIP
            call $+6
            jp   PutWord
            ld   bc,(SHIP)
            ld   b,0
            exx
            ld   b,KCOM10
            exx
            ld   de,CODE10-3
            ld   hl,$+6
            jp   ProcessArgument
            ld   de,(SHIP)
            ld   d,0
            ret
; ----------------------------------------------------------
U_SKIMMER
            call $+6
            jp   PutWord
            ld   bc,(SKIMMER)
            ld   b,0
            exx
            ld   b,KCOM12
            exx
            ld   de,CODE12-3
            ld   hl,$+6
            jp   ProcessArgument
            ld   de,(SKIMMER)
            ld   d,0
            ret
; ----------------------------------------------------------
_MASSA
            ld   a,(TONN)

PutByte   ; orig: PUTBYTE
; Положить байт в буфер аргументов
            exx
            ld   (hl),a
            inc  hl
            ld   (hl),0
            inc  hl
            exx
            ret
; ----------------------------------------------------------
_TONAJ
            ld   a,(TONN+1)
            jp   PutByte
; ----------------------------------------------------------
_YES
            ld   a,1
            jp   PutByte
; ----------------------------------------------------------
_NO
            xor  a
            jp   PutByte
; ----------------------------------------------------------
_OPERATION
            ld   a,(OPERATION)
            jp   PutByte
; ----------------------------------------------------------
_STATUS
            ld   a,(STATUS)
            jp   PutByte
; ----------------------------------------------------------
S_CARGO
            call ZP24
            jp   PutWord
ZP24
            exx
            ld   b,KCOM9
            exx
            ld   de,CODE9-3
            call T_NTWR
            ld   hl,$+6
            jp   ProcessArgument
            add  hl,hl
            ld   de,TWRS
            add  hl,de
            ld   a,(hl)
            and  #7F
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
S_WKRB
; Проверить присутствие оснащения на
; Этой станции с этим уровнем развития
            call $+6
            jp   PutWord
            exx
            ld   b,KCOM6
            exx
            ld   de,CODE6-3
            call T_NWKRB
            ld   hl,$+6
            jp   ProcessArgument
            ld   de,TONNS
ZP16
            add  hl,hl
            add  hl,de
            ld   a,(hl)
            push af
            call PlanetInfoHereLang
            ld   a,l
            pop  hl
            cp   h
            ld   a,0
            jr   c,$+3
            inc  a
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
S_WSKM
            call $+6
            jp   PutWord
            exx
            ld   b,KCOM7
            exx
            ld   de,CODE7-3
            call T_NWSKM
            ld   hl,$+6
            jp   ProcessArgument
            ld   de,TONSS
            jr   ZP16
; ----------------------------------------------------------
S_SHIP
            call $+6
            jp   PutWord
            call SelectedShipNumber
            exx
            ld   b,KCOM10
            exx
            ld   de,CODE10-3
            ld   hl,$+6
            jp   ProcessArgument
; Кораблей на станции немерено
            ld   de,#7F
            ret
; ----------------------------------------------------------
S_SKIMMER
            call $+6
            jp   PutWord
            call SelectedShipNumber
            exx
            ld   b,KCOM12
            exx
            ld   de,CODE12-3
            ld   hl,$+6
            jp   ProcessArgument
            ld   de,#7F
            ret
; ----------------------------------------------------------
U_CARGO
            call ZP23
            jp   PutWord
ZP23
            exx
            ld   b,KCOM8
            exx
            ld   de,CODE8-3
            call T_NTWR
            ld   hl,$+6
            jp   ProcessArgument
            add  hl,hl
            ld   de,TWRI
            add  hl,de
            ld   e,(hl)
            ld   d,0
            ret
; ----------------------------------------------------------
_NUMBER
            dec  ix
            call ReadNumber
            EXD
            jp   PutWord
; ----------------------------------------------------------
_SKOBA
            call ReadArgument

            call ReadOperator
            call ReadArgument
            call RUN
            ld   a,(ix)
            cp   ")"
            jr   nz,_SKOBA+3
            inc  ix
            ret
; ----------------------------------------------------------
_HAPPAND
            call ReadNumber
            ld   de,t_HAPP
ZP37
            add  hl,de
            ld   a,(hl)
            jp   PutByte
; ----------------------------------------------------------
_MISSION
            call ReadNumber
            ld   de,t_MISS
            jr   ZP37
; ----------------------------------------------------------
_TXT
; Чтение состояния текста персонажа и
; Сцены короткий вариант записи. без
; Номера персонайа и сцены
            call ReadNumber
            EXD
            ld   a,(PERSONAJ)
            ld   bc,(SCENA-1)
            jr   ZP36

; ----------------------------------------------------------
_PERSTXT
; Чтение состояния текста персонажа и
; Сцены
            call ReadNumber
            ld   h,l
            push hl
            inc  ix
            call ReadNumber
            ld   h,l
            push hl
            inc  ix
            call ReadNumber
            EXD
            pop  bc
            pop  af
ZP36
            call FindTextInTree
            ld   a,(hl)
            jp   PutByte
; ----------------------------------------------------------
P_PLANET
; Планета пребывания
            call $+6
            jp   PutWord
            exx
            ld   b,KCOM11
            exx
            ld   c,0
            ld   de,CODE11-3
            ld   hl,$+6
            jp   ProcessArgument
            ret
; ----------------------------------------------------------
R_PLANET
; Планета перелета
            call $+6
            jp   PutWord
            exx
            ld   b,KCOM11
            exx
            ld   c,1
            ld   de,CODE11-3
            ld   hl,$+6
            jp   ProcessArgument
            ret
; ----------------------------------------------------------
P_SYSTEM
; Система пребывания
            call $+6
            jp   PutWord
            exx
            ld   b,KCOM13
            exx
            ld   c,0
            ld   de,CODE13-3
            ld   hl,$+6
            jp   ProcessArgument
            ret
; ----------------------------------------------------------
R_SYSTEM
; Система перелета
            call $+6
            jp   PutWord
            exx
            ld   b,KCOM13
            exx
            ld   c,1
            ld   de,CODE13-3
            ld   hl,$+6
            jp   ProcessArgument
            ret


;
; Операции
; Вход de-первый аргумент
;    bc-второй аргумент
; retde-РЕЗУЛЬТАТ


_EQUALLY
            EXD
            SUB_BC
            ld   de,1
            ret  z
            dec  de
            ret
; ----------------------------------------------------------
_MULTI
; de=bc*de
            ld   hl,0
            rept 3
            sla  c
            rl   b
            jr   nc,$+3
            add  hl,de
            add  hl,hl
            jp   c,.ZP32
            endr
            rept 12
            sla  c
            rl   b
            jr   nc,$+3
            add  hl,de
            add  hl,hl
            jr   c,.ZP32
            endr
            sla  c
            rl   b
            jr   nc,$+3
            add  hl,de
            ex   de,hl
            ret
.ZP32
            ld   de,#FFFF
            ret
; ----------------------------------------------------------
_PLUS
            EXD
            add  hl,bc
            jr   nc,$+5
            ld   hl,#FFFF
            EXD
            ret
; ----------------------------------------------------------
_MINUS
            EXD
            SUB_BC
            jr   nc,$+5
            ld   hl,0
            EXD
            ret
; ----------------------------------------------------------
_LESS
            EXD
            SUB_BC
            ld   de,1
            ret  c
            dec  de
            ret
; ----------------------------------------------------------
_MORE
            EXD
            SUB_BC
            ld   de,0
            ret  z
            ret  c
            inc  de
            ret
; ----------------------------------------------------------
_LESSEQ
            EXD
            SUB_BC
            ld   de,1
            ret  c
            ret  z
            dec  de
            ret
; ----------------------------------------------------------
_MOREEQ
            EXD
            SUB_BC
            ld   de,0
            ret  c
            inc  de
            ret
; ----------------------------------------------------------
_AND
            ld   a,d
            and  b
            ld   d,a
            ld   a,e
            and  c
            ld   e,a
            ret
; ----------------------------------------------------------
_OR
            ld   a,d
            or   b
            ld   d,a
            ld   a,e
            or   c
            ld   e,a
            ret
; ----------------------------------------------------------
_SET
            ld   d,b
            ld   e,c
            ret


;
; Свойства

; Вход с hl=#ffff !!! в стеке !!!, значит
; Аргумент был без номера, т.е. тот на
; Котором стоит курсор
; Если <>#ffff, то аргумент с номером


_SWKRB_C
; Цена осн.корабля
            ld   de,CENS
ZP13
            pop  hl
            ld   h,0
            add  hl,hl
            add  hl,de
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            ret
; ----------------------------------------------------------
_SWKRB_V
; Вес осн.корабля
            ld   de,TONNS+1
ZP14
            pop  hl
            ld   h,0
            add  hl,hl
            add  hl,de
            ld   e,(hl)
            ld   d,0
            ret
; ----------------------------------------------------------
_UWKRB_S
; Свойство проверяет все вооружение на
; Присутствие на этом уровне
            pop  hl
            call PlanetInfoHereLang
            ld   a,l
            ld   (ZP17+1),a
            ld   hl,TONNS
            ld   de,WKRBI
            ld   b,WKKOL
ZP18
            ld   a,(de)
            or   a
            jp   p,$+4
            cpl
            or   a
            jr   z,ZP19
ZP17
            ld   a,0
            cp   (hl)
            ld   a,0
            jr   c,ZP20
ZP19
            inc  hl
            inc  hl
            inc  de
            djnz ZP18
            ld   a,1
ZP20
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
_UWKRB_N
; Свойство проверяет вооружение
; На повторяемость подобных видов
            ld   bc,WKII
            ld   de,WKRBI
ZP12
            pop  hl
            ld   h,0
            ld   a,l
; Табл. связи типов вооруж.
            add  hl,de
            EXD
            push de
            add  a,a
            ld   l,a
            ld   h,0
            add  hl,bc
            EXD
            ld   a,(de)
            ld   c,a
            dec  c
.ZP50
            inc  c
            jr   z,.ZP49
            dec  hl
            ld   a,(hl)
            or   a
            jp   p,$+4
            cpl
            or   a
            jr   z,.ZP50
            pop  hl
            jr   .ZP52
.ZP49
            pop  hl
            inc  de
            ld   a,(de)
            ld   c,a
            inc  c
.ZP51
            dec  c
            jr   z,.ZP52
            inc  hl
            ld   a,(hl)
            or   a
            jp   p,$+4
            cpl
            or   a
            jr   z,.ZP51
.ZP52
            ld   de,0
            ret  z
            inc  de
            ret
; ----------------------------------------------------------
_SWKRB_S
; Проверить соответсвия оснащения кораблю
            ld   a,(SHIP)
            ld   de,KRBARM
ZP11
            pop  hl
            ld   h,0
            ADDHLHL 2
            add  hl,de
            rept 3
            cp   (hl)
            inc  hl
            jr   z,.ZP10
            endr
            cp   (hl)
.ZP10
            ld   de,0
            ret  z
            inc  de
            ret
; ----------------------------------------------------------
_SWKRB_K
            ld   de,WKRBI
ZP15
            pop  hl
            ld   h,0
            add  hl,de
            ld   a,#7F
            bit  7,(hl)
            jr   z,$+4
            ld   a,1
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
_SWSKM_C
            ld   de,CENS1
            jp   ZP13
; ----------------------------------------------------------
_SWSKM_V
            ld   de,TONSS+1
            jp   ZP14
; ----------------------------------------------------------
_UWSKM_S
            pop  hl
            call PlanetInfoHereLang
            ld   a,l
            ld   (ZP17+1),a
            ld   de,TONSS
            ld   hl,WSKMI
            ld   b,WSKOL
            jp   ZP18
; ----------------------------------------------------------
_UWSKM_N
            ld   bc,WSII
            ld   de,WSKMI
            jp   ZP12
; ----------------------------------------------------------
_SWSKM_S
            ld   de,SKMARM
            ld   a,(SKIMMER)
            jp   ZP11
; ----------------------------------------------------------
_SWSKM_K
            ld   de,WSKMI
            jp   ZP15
; ----------------------------------------------------------
_UCARGO_C
            ld   de,TWRI+1
            jp   ZP14
; ----------------------------------------------------------
_SCARGO_C
            ld   de,TWRS+1
            jp   ZP14
; ----------------------------------------------------------
_SCARGO_S
            pop  hl
            ld   h,0
            ld   de,TWRS
            add  hl,hl
            add  hl,de
            xor  a
            bit  7,(hl)
            jr   nz,$+3
            inc  a
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
_SCARGO_M
; Особенность:
; Данная свойство дает полный подсчет
; Тонажа всего корабля + скимер
; И добавляет еденицу текущего или
; Нумерованного товара
            pop  hl
            ld   h,0
            call CountTonnage
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
_SHIP_C
            ld   de,CNKR+1
ZP40
            pop  hl
            ld   h,0
            push hl
            ADDHLHL 2
            pop  bc
            add  hl,bc
            add  hl,de
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            ret
; ----------------------------------------------------------
_SHIP_T
            ld   de,CNKR
ZP39
            pop  hl
            ld   h,0
            push hl
            ADDHLHL 2
            pop  bc
            add  hl,bc
            add  hl,de
            ld   e,(hl)
            ld   d,0
            ret
; ----------------------------------------------------------
_SHIP_S
            ld   de,CNKR+4
            jp   ZP39
; ----------------------------------------------------------
_SKIMER_C
            ld   de,CNSK+1
            jp   ZP40
; ----------------------------------------------------------
_SKIMER_V
            ld   de,CNSK+4
            jp   ZP39
; ----------------------------------------------------------
_PLANET_S
            pop  bc
            call TakePlanetInfo
            ld   e,h
            ld   d,0
            ret
; ----------------------------------------------------------
_PLANET_C
            pop  bc
            call TakePlanetInfo
            ld   d,0
            ret
; ----------------------------------------------------------
_PLANET_U
            pop  bc
            call TakePlanetInfo
            EXD
            ld   d,0
            ret
; ----------------------------------------------------------
_SYSTEM_P
            pop  bc
            call TakePlanetInfo
            ld   e,a
            ld   d,0
            ret
; ----------------------------------------------------------
_SYSTEM_G
            pop  bc
            call TakePlanetInfo
            ld   e,d
            ld   d,0
            ret


;
; Операнды команды изменения значения
; Неразрешается операнду быть со свойством


; В стеке приходит адрес операции
; bc-второй аргумент
SUM_M
            ld   de,$+6
            jp   PutWord
            pop  de
            ld   hl,$+9
            push hl
            ld   hl,(SUMM)
            EXD
            jp   (hl)
            ld   (SUMM),de
            ret
; ----------------------------------------------------------
STATU_S
            ld   de,$+6
            jp   PutWord
            pop  de
            ld   hl,$+11
            push hl
            ld   hl,(STATUS)
            ld   h,0
            EXD
            jp   (hl)
            ld   a,e
            ld   (STATUS),a
            ret
; ----------------------------------------------------------
TONA_J
            ld   de,$+6
            jp   PutWord
            pop  de
            ld   hl,$+11
            push hl
            ld   hl,(TONN+1)
            ld   h,0
            EXD
            jp   (hl)
            ld   a,e
            ld   (TONN+1),a
            ret
; ----------------------------------------------------------
GRU_z
            call ZP23
ZP25
            ld   a,e
            ld   (.ZP54+1),hl
            ld   (.ZP54+4),a
            ld   de,$+6
            jp   PutWord
            pop  de
.ZP54
            ld   hl,0
            ld   a,0
            push hl
            ld   hl,$+9
            push hl
            ld   l,a
            ld   h,0
            EXD
            jp   (hl)
            pop  hl
            ld   a,d
            or   a
            jr   z,$+4
            ld   e,#7F
            ld   a,e
            and  #7F
            ld   e,a
            ld   a,(hl)
            and  #80
            or   e
            ld   (hl),a
            ret
; ----------------------------------------------------------
GRU_Z
            call ZP24
            jp   ZP25
; ----------------------------------------------------------
WKR_B
            call ZP21
ZP9
            ld   (.ZP53+1),hl
            ld   (.ZP53+4),a
            ld   de,$+6
            jp   PutWord
            pop  de
.ZP53
            ld   hl,0
            ld   a,0
            push hl
            ld   hl,$+9
            push hl
            ld   l,a
            ld   h,0
            EXD
            jp   (hl)
            pop  hl
            bit  7,(hl)
            ld   a,e
            jr   z,$+3
            cpl
            ld   (hl),a
            ret
; ----------------------------------------------------------
WSK_M
            call ZP22
            jp   ZP9


;
; Доп. процедуры


; Распознать число в нlиз данных в ix
; ix-на первую цифру числа

ReadNumber   ; orig: TAKENUM
; Распознать число из ix
            inc  ix
            ld   a,(ix)
            ld   b,1
            cp   "0"
            jr   c,.ZP5
            cp   "9"+1
            jr   nc,.ZP5
            inc  ix
            ld   a,(ix)
            inc  b
            cp   "0"
            jr   c,.ZP5
            cp   "9"+1
            jr   nc,.ZP5
            inc  ix
            ld   a,(ix)
            inc  b
            cp   "0"
            jr   c,.ZP5
            cp   "9"+1
            jr   nc,.ZP5
            inc  ix
            ld   a,(ix)
            inc  b
            cp   "0"
            jr   c,.ZP5
            cp   "9"+1
            jr   nc,.ZP5
            inc  b
            inc  ix
.ZP5
            ld   a,(ix-1)
            sub  48
            ld   l,a
            ld   h,0
            djnz $+3
            ret

            EXD
            ld   a,(ix-2)
            sub  48
            ld   l,a
            ld   a,b
            ld   h,0
            add  hl,hl
            push hl
            ADDHLHL 2
            pop  bc
            add  hl,bc
            add  hl,de
            ld   b,a
            djnz $+3
            ret

            EXD
            ld   a,(ix-3)
            sub  48
            ld   l,a
            ld   a,b
            ld   h,0
            push hl
            add  hl,hl
            pop  bc
            add  hl,bc
            ADDHLHL 3
            add  hl,bc
            ADDHLHL 2
            add  hl,de
            ld   b,a
            djnz $+3
            ret

            EXD
            ld   a,(ix-4)
            sub  48
            ld   l,a
            ld   a,b
            ld   h,0
            push hl
            add  hl,hl
            pop  bc
            add  hl,bc
            add  hl,hl
            add  hl,bc
            add  hl,hl
            add  hl,bc
            add  hl,hl
            add  hl,bc
            ADDHLHL 2
            add  hl,bc
            ADDHLHL 3
            add  hl,de
            ld   b,a
            djnz $+3
            ret

            EXD
            ld   a,(ix-5)
            sub  48
            ld   l,a
            ld   h,0
            push hl
            ADDHLHL 3
            pop  bc
            add  hl,bc
            add  hl,hl
            add  hl,bc
            add  hl,hl
            add  hl,bc
            ADDHLHL 4
            add  hl,bc
            ADDHLHL 4
            add  hl,de
            ret

; ----------------------------------------------------------

ReadOperator   ; orig: TAKEMEDARG
; Прочесть межаргумент (операцию)
; Читаем меж_аргумент
            ld   a,(ix)
            inc  ix
            ld   hl,CODE3-3
            ld   b,KCOM3
            call FindSymbol
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
; Dеадрес обработки меж аргумента
            push de
            exx
            pop  de
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            exx
            ret

; ----------------------------------------------------------

ReadJumpAddress   ; orig: TARGTURN
; Прочесть адрес переключателя положения
; Вкл./выкл.
; Rетнlадрес переключателя
            ld   a,(ix)
            inc  ix
            ld   hl,CODE15-3
            ld   b,KCOM15
            jp   JumpBySymbol
; ----------------------------------------------------------

ReadHandlerAddress   ; orig: TAKEJARG
; Прочесть адрес обработчика чтения
; Аргумента и его запоминание и поместим
; Его в буфер
            ld   a,(ix)
            inc  ix
            ld   hl,CODE14-3
            ld   b,KCOM14
            jp   JumpBySymbol
; ----------------------------------------------------------
; Прочесть аргумент

ReadArgument   ; orig: TAKEARG
; Прочесть аргумент
            ld   a,(ix)
            inc  ix
            ld   hl,CODE2-3
            ld   b,KCOM2

JumpBySymbol   ; orig: JUMPSYMB
; Переход по таблице обработчиков символов
; a-символ
; hl-таблица обработчиков символов
; b-количество символов в таблице
            call FindSymbol
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jp   (hl)


; ----------------------------------------------------------

FindSymbol   ; orig: FINDSYMB
; Поиск символа в таблице
; Поиск адреса в тблице по символу в a
; Нlтаблица
; b кол.пунктов поиска
; Retfz-on если нашли
; Автоматом переходит в $P3 если ничего не
; Нашли !!!
            ld   de,3
            add  hl,de
            cp   (hl)
            ret  z
            djnz FindSymbol+3
            jp   ZP3


; ----------------------------------------------------------

ProcessArgument   ; orig: OBRARGU
; Обработчик аргументов, считывание их
; Со свойствами и без
; ix-текст след. за символом аргумента
; bc-номер пункта где стоит курсор с 0
; hl-процедура чтения значения из таблицы
; de-таблица свойств аргумента-3
; B'-кол.элементов таблицы
            ld   (.ZP7+1),hl
; Маркер того что аргумент без числа
; Нужно для обработки выбора со свойством
            ld   l,c
            ld   h,0
            ld   a,(ix)
            cp   "."
            jr   z,.ZP4
            cp   "0"
            jr   c,$+6
            cp   "9"+1
            jr   c,.ZP6
; Чистый "аргумент", просто количество
.ZP7
            jp   0
; С числом
.ZP6
            push bc
            push de
            call ReadNumber
            pop  de
            pop  bc
            dec  hl
            ld   a,(ix)
            cp   "."
; Если с числом и с выбором свойства,
; Число в hl
            jr   nz,.ZP7
; С выбором свойства
.ZP4
            inc  ix
            inc  ix
            push hl
            EXD
            exx
            ld   a,b
            exx
            ld   b,a
            ld   a,(ix-1)
            jp   JumpBySymbol


; ----------------------------------------------------------
RUN
; Исполнение операции
            ld   hl,PutWord
            push hl
            exx
            ld   de,0-6
            add  hl,de
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push de
            exx
            pop  de
            exx
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push de
            exx
            pop  hl
            exx
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            push de
            ld   de,0-5
            add  hl,de
; Указатель буфера на первый аргумент
            exx
            pop  bc
; hl-адрес  операции
; de-первый аргумент
; bc-второй аргумент
            jp   (hl)
; de-результат


FindTextInTree   ; orig: FINDINTREE
; Поиск идентификатора текста по дереву персонажа и сцены
; Ищем идентификатор текста по дереву в
; Зависимости от номера персонажа и сцены
; a-персонаж
; b-сцена
; de-текст
; Rethl-адрес идентификатора текста
            ld   (._PERSONAJ+1),a
            ld   a,b
            ld   (._SCENA+1),a

            ld   hl,t_TREE
            ld   a,#FF
._PERSONAJ
            ld   b,0
; Поиск персонажа по номеру
.ZP34
            push bc
            ld   bc,0
            cpir
            pop  bc
            djnz .ZP34
            dec  a
._SCENA
            ld   b,0
; Поиск сцены по номеру
.ZP35
            push bc
            ld   bc,0
            cpir
            pop  bc
            djnz .ZP35
; Назад на идентификатор сцены т.к. номера
; Текстов с 1, и прибавим номер текста
; В сцене к адресу начала и будем на
; Нужном идентификаторе сцены
            dec  hl
            add  hl,de
            ret


; ----------------------------------------------------------

CountTonnage   ; orig: TAKETON
; Подсчёт общего веса
; Подсчет общего веса всего груза
; hl-индекс того пункта товара
; Который будет увеличен на еденицу для
; Проверки покупаемости по тонажу
; Для товара
; hl=0-twri простая проверка тонажа
; Reta- количество тонн груза
            add  hl,hl
            ld   de,TWRI
            add  hl,de
; Запомним адреса во всех группах накопления
; Веса, только в одной из них сработает
; Увеличение на еденицу компонента груза
; Или оснащения
            ld   (.ZP43+1),hl
; Таблица показателей веса товаров
; 0-Тонна
; 1-Человек 1/16тн
; 2-ДР.        0тн
            ld   hl,TWRM
            ld   a,TKOL
            ld   c,0
.ZP42
            ex   af,af'
            ld   a,(de)
            and  #7F
            push hl
.ZP43
            ld   hl,0
            SUB_DE
            pop  hl
            jr   nz,$+3
            inc  a
            inc  de
            inc  de
            ld   b,(hl)
            inc  hl
            dec  b
            jp   m,.ZP41
            rept 4
            rrca
            endr
            and  #0F
            dec  b
            jp   m,.ZP41
            xor  a
.ZP41
            add  a,c
            ld   c,a
            ex   af,af'
            dec  a
            jp   nz,.ZP42

            ld   hl,TONNS+1
            ld   de,WKRBI
            ld   a,WKKOL
.ZP44
            ex   af,af'
            ld   a,(de)
            inc  de
            or   a
            jp   p,$+4
            cpl
            ld   (.ZP45+1),a
            ld   b,(hl)
            inc  hl
            inc  hl
            xor  a
.ZP45
            add  a,0
            djnz $-2
            add  a,c
            ld   c,a
            ex   af,af'
            dec  a
            jp   nz,.ZP44

            ld   hl,TONSS+1
            ld   de,WSKMI
            ld   a,WSKOL
.ZP46
            ex   af,af'
            ld   a,(de)
            inc  de
            or   a
            jp   p,$+4
            cpl
            ld   (.ZP47+1),a
            ld   b,(hl)
            inc  hl
            inc  hl
            xor  a
.ZP47
            add  a,0
            djnz $-2
            add  a,c
            ld   c,a
            ex   af,af'
            dec  a
            jp   nz,.ZP46

            ld   a,(SKIMMER)
            inc  a
            jr   z,.ZP48
            dec  a
            ld   e,a
            rlca
            rlca
            add  a,e
            ld   e,a
            ld   d,0
            ld   hl,CNSK+4
            add  hl,de
            ld   a,(hl)
.ZP48
            add  a,c
            ret


; Берут текущий номер пункта
T_NWKRB
            ld   a,(NWKRB+1)
            ld   c,a
            ld   a,(IWKRB+1)
            add  a,c
            ld   c,a
            ld   b,0
            ret
T_NWSKM
            ld   a,(NWSKM+1)
            ld   c,a
            ld   a,(IWSKM+1)
            add  a,c
            ld   c,a
            ld   b,0
            ret
T_NTWR
            ld   a,(NTWR+1)
            ld   c,a
            ld   a,(ITWR+1)
            add  a,c
            ld   c,a
            ld   b,0
            ret


; Берет инфо о системе перелета или
; Нахождения в зав. от рег. c
; c=1 система перелета

TakePlanetInfo   ; orig: TAKE_PINFO
; Данные планеты/системы по региону
            dec  c
            jp   nz,PlanetInfoHereLang
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            ld   a,(WPLANET)
            jp   PlanetInfoLang


;
; Таблицы, данные


; Команды
; Количество команд
; Таблица символов и адресов команд
CODE
            db   "?"
            dw   _IF
            db   ":"
            dw   _THAN
            db   "{"
            dw   _OPEN
            db   "}"
            dw   _CLOSE
            db   "@"
            dw   _ELSE
            db   "+"
            dw   _ON
            db   "-"
            dw   _OFF
            db   "="
            dw   _CHANGE
            db   ","
            dw   _NEXT
            db   "T"
            dw   _TONN
            db   "M"
            dw   _MESSAGE
            db   "m"
            dw   _mESSAGE
            db   "^"
            dw   _EXIT
            db   "#"
            dw   _OVER
            db   "W"
            dw   _WYDWOR
KCOM        equ  ($-CODE)/3

; Меж_аргументы
CODE3
            db   "="
            dw   _EQUALLY
            db   "*"
            dw   _MULTI
            db   "+"
            dw   _PLUS
            db   "-"
            dw   _MINUS
            db   "<"
            dw   _LESS
            db   ">"
            dw   _MORE
            db   "["
            dw   _LESSEQ
            db   "]"
            dw   _MOREEQ
            db   "&"
            dw   _AND
            db   "!"
            dw   _OR
            db   ":"
            dw   _SET
KCOM3       equ  ($-CODE3)/3

; Аргументы
CODE2
            db   "c"
            dw   U_SUMM
            db   "o"
            dw   U_WKRB
            db   "i"
            dw   U_WSKM
            db   "k"
            dw   U_SHIP
            db   "r"
            dw   U_SKIMMER
            db   "j"
            dw   _MASSA
            db   "J"
            dw   _TONAJ
            db   "y"
            dw   _YES
            db   "n"
            dw   _NO
            db   "X"
            dw   _OPERATION
            db   "u"
            dw   _STATUS
            db   "G"
            dw   S_CARGO
            db   "O"
            dw   S_WKRB
            db   "I"
            dw   S_WSKM
            db   "K"
            dw   S_SHIP
            db   "R"
            dw   S_SKIMMER
            db   "g"
            dw   U_CARGO
            db   "e"
            dw   _HAPPAND
            db   "m"
            dw   _MISSION
            db   "p"
            dw   _PERSTXT
            db   "t"
            dw   _TXT
            db   "("
            dw   _SKOBA
            db   "1"
            dw   _NUMBER
            db   "2"
            dw   _NUMBER
            db   "3"
            dw   _NUMBER
            db   "4"
            dw   _NUMBER
            db   "5"
            dw   _NUMBER
            db   "6"
            dw   _NUMBER
            db   "7"
            dw   _NUMBER
            db   "8"
            dw   _NUMBER
            db   "9"
            dw   _NUMBER
            db   "0"
            dw   _NUMBER
            db   "L"
            dw   P_PLANET
            db   "l"
            dw   R_PLANET
            db   "Y"
            dw   P_SYSTEM
            db   "y"
            dw   R_SYSTEM
KCOM2       equ  ($-CODE2)/3


; Таблицы обработки свойств для каждого
; Вида аргументов вход с HL'=#ffff, значит
; Аргумент был без номера, т.е. тот на
; Котором стоит курсор
; Если <>#ffff, то аргумент с номером

; Свойства для вооружения корабля на борте
; Свойство "s" проверяет все вооружение
CODE4
            db   "s"
            dw   _UWKRB_S           ; Статус
            db   "n"
            dw   _UWKRB_N
KCOM4       equ  ($-CODE4)/3


; Свойства для вооружения скимера на борте
; Свойство "s" проверяет все вооружение
CODE5
            db   "s"
            dw   _UWSKM_S
            db   "n"
            dw   _UWSKM_N
KCOM5       equ  ($-CODE5)/3


; Свойства для вооружения корабля на станц
CODE6
            db   "c"
            dw   _SWKRB_C
            db   "v"
            dw   _SWKRB_V
            db   "s"
            dw   _SWKRB_S
            db   "k"
            dw   _SWKRB_K
KCOM6       equ  ($-CODE6)/3


; Свойства для вооружения скимера на станц
CODE7
            db   "c"
            dw   _SWSKM_C
            db   "v"
            dw   _SWSKM_V
            db   "s"
            dw   _SWSKM_S
            db   "k"
            dw   _SWSKM_K
KCOM7       equ  ($-CODE7)/3


; Свойства грузов на борте
CODE8
            db   "c"
            dw   _UCARGO_C
KCOM8       equ  ($-CODE8)/3


; Свойства грузов на станции
CODE9
            db   "c"
            dw   _SCARGO_C
            db   "s"
            dw   _SCARGO_S
            db   "m"
            dw   _SCARGO_M
KCOM9       equ  ($-CODE9)/3


; Свойства корабля
CODE10
            db   "c"
            dw   _SHIP_C
            db   "t"
            dw   _SHIP_T            ; Тонаж
            db   "s"
            dw   _SHIP_S
KCOM10      equ  ($-CODE10)/3


; Свойства планет
CODE11
            db   "s"
            dw   _PLANET_S
            db   "c"
            dw   _PLANET_C
            db   "u"
            dw   _PLANET_U
KCOM11      equ  ($-CODE11)/3


; Свойства систем
CODE13
            db   "p"
            dw   _SYSTEM_P
            db   "g"
            dw   _SYSTEM_G
KCOM13      equ  ($-CODE13)/3


; Свойства скимера
CODE12
            db   "c"
            dw   _SKIMER_C
            db   "v"
            dw   _SKIMER_V
KCOM12      equ  ($-CODE12)/3


; Операнды команды "изменение значения"
CODE14
            db   "c"
            dw   SUM_M
            db   "u"
            dw   STATU_S
            db   "g"
            dw   GRU_z
            db   "G"
            dw   GRU_Z
            db   "o"
            dw   WKR_B
            db   "i"
            dw   WSK_M
            db   "J"
            dw   TONA_J
KCOM14      equ  ($-CODE14)/3


; Операнды команды переключения
CODE15
            db   "t"
            dw   T_TXT
            db   "p"
            dw   T_PERS
            db   "v"
            dw   T_QUES
            db   "m"
            dw   T_MISS
            db   "e"
            dw   T_HAPP
            db   "K"
            dw   T_KRB
            db   "R"
            dw   T_SKM
KCOM15      equ  ($-CODE15)/3


; Буфер аргументов и операций

; Буфер используется так:
; Заносится первый аргумент,операция
; Второй аргумент, потом идет вычисление
; И весь результат попадает на первый
; Аргумент, далее заносим следующую
; Операцию и третий аргумент
; Если скобки, то буфер продливается
ParadoxArgBuf         ds   20   ; orig: ARG


; Дополнительный буфер
ParadoxArgBuf2        ds   20   ; orig: ARGD


CHECK_SCENARY
            incbin "gen/C_SCENAR.t"   ; GENERATED from assets/text/rules.paradox
            db   0


; Тексты сценария, конвертнутые
TXTES
