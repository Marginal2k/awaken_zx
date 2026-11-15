Команды▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
│_IF│_THAN│_ELSE│_NEXT│_CHANGE│_OVER
│_ON│_OFF │_OPEN│_EXIT│_CLOSE │_MESSAGE
│_TONN    │_mESSAGE   │_WYDWOR│▒▒▒▒▒▒▒▒▒
Операнды переключения▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
│T_TXT │T_HAPP│T_QUES│T_PERS│T_SKM│T_KRB
│T_MISS│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
Аргументы▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
│S_SHIP│U_WSKM│_MISSION│S_SKIMMER │_YES
│U_SHIP│U_WKRB│_PERSTXT│U_SKIMMER │_NO
│_TONAJ│U_SUMM│_HAPPAND│_STATUS   │_TXT
│_MASSA│S_WKRB│U_CARGO │_NUMBER   │▒▒▒▒▒
│_SKOBA│S_WSKM│S_CARGO │_OPERATION│▒▒▒▒▒
│P_PLANET│R_PLANET│P_SYSTEM│R_SYSTEM▒▒▒▒
Свойства▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
│_SWKRB_C │_SWKRB_V │_UWKRB_S │_UCARGO_C
│_SWKRB_S │_SWKRB_K │_SWSKM_C │_SCARGO_C
│_SWSKM_V │_UWSKM_S │_SWSKM_S │_SCARGO_S
│_SWSKM_K │_UWSKM_N │_SHIP_C  │_SKIMER_V
│_UKWRB_N │_SCARGO_M│_SHIP_S  │_SKIMER_C
│_SHIP_T  │_PLANET_S│_PLANET_C│_PLANET_U
│_SYSTEM_P│_SYSTEM_G│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
Процедуры▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
│TAKENUM │TARGTURN  │JUMPSYMB  │TAKETON
│TAKEARG │TAKEJARG  │TAKEMEDARG│RUN
│OBRARGU │FINDSYMB  │FINDINTREE│T_NWKRB
│T_NWSKM │T_NTWR    │PUTWORD   │PUTBYTE
│TAKE_PINFO│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
Операции▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
│_PLUS │_EQUALLY│_LESS│_LESSEQ│_MORE▒▒▒▒
│_MULTI│_MOREEQ │_OR  │_MINUS │_AND│_SET
Операнды Изменения значения▒▒▒▒▒▒▒▒▒▒▒▒▒
│STATU_S │GRU_z│GRU_Z│WKR_B│WSK_M │SUM_M
│TONA_J  │▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒


────────────────────────────────────────
■           Paradox v1.0        13.11.99
────────────────────────────────────────
ИДЕЯ:
ЧИТАЕМ ПО ОЧЕРЕДНО ПЕРВЫЙ АРГУМЕНТ
МЕЖ_АРГУМЕНТ (ОПЕРАЦИЯ) И ВТОРОЙ
АРГУМЕНТ
СОХРАНЯЕМ ВСЕ ЭТО В БУФЕРЕ В ВИДЕ
ЧИСЕЛ (ДЛЯ АРГУМЕНТОВ) И АДРЕСОВ
ОПЕРАЦИЙ (ДЛЯ МЕЖ_АРГУМЕНТОВ)
ПОСЛЕ ПРОЧТЕНИЯ ВСЕГО ВЫШЕ ОПИСАНОГО
ПРОИСХОДИТ ВЫПОЛНЕНИЕ ОПЕРАЦИИ ОСВОБОЖ-
ДАЕМ БУФЕР НА ДВА ЗНАЧЕНИЯ (УБИРАЕМ
МЕЖ_АРГУМЕНТ И ВТОРОЙ АРГУМЕНТ)
РЕЗУЛЬТАТ ОСТАЕТСЯ НА ПЕРВОМ МЕСТЕ
ДАЛЕЕ ИДЕТ ЧТЕНИЕ МЕЖ_АРГУМЕНТА И ОПЯТЬ
УЖЕ ВТОРОГО АРГУМЕНТА И Т.Д.
РЕЗУЛЬТАТ ВСЕГДА БУДЕТ ПЕРВЫМ ДАННЫМ В
БУФЕРЕ. РАЗЛИЧИЙ МЕЖДУ ЛОГИЧЕСКИМИ
ДАННЫМИ И ЧИСЛОВЫМИ НИКАКОГО ЛОГ. 0,1
ЧИСЛОВЫЕ 0-65535 БЕЗ ЗНАКА.



▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
ОСНОВНОЙ КОД



СТРУКТУРА, ПРОЦЕДУРЫ ЯЗЫКА ПАРАДОКС


PARADOX
            ld   ix,CHECK_SCENARY
            ld   (STKMEM+1),sp
ВЫКЛ. ФЛАГ ВЫХОДА НА СЛЕД. #0D
            xor  a
            ld   (F_EXIT+1),a
■ ixТЕКСТ
$P1
            ld   sp,(STKMEM+1)
            ld   a,(ix)
            or   a:retz:inc ix
            cp   " "
            jrnz $P2
КОМЕНТАРИЙ
ИЩЕМ СЛЕД. СТРОКУ, Т.Е. СИМВОЛ #0D
$P3
STKMEM      ld   sp,0
            ld   a,(ix):inc ix
            cp   #0D:jrnz $P3+3
$P29
F_EXIT      ld   a,0
            or   a
            jrz  $P1+4
            ret
$P2
            cp   #0D:jrz $P29

            ld   hl,CODE-3
            ld   b,KCOM

            jp   JUMPSYMB










▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
КОМАНДЫ


_IF
ПРОВЕРКА УСЛОВИЯ
■ ixСЛЕД. СИМВОЛ ЗА КОМАНДОЙ
УСТАНОВИМ HL' НА БУФЕР СТРОКИ АРГУМЕНТОВ

            exx:ld hl,ARG:exx

ЧИТАЕМ ПЕРВЫЙ АРГУМЕНТ
            call TAKEARG
$P8
ЧИТАЕМ МЕЖ_АРГУМЕНТ
            call TAKEMEDARG
ЧИТАЕМ ВТОРОЙ АРГУМЕНТ
            call TAKEARG
            call RUN

            ld   a,(ix)
            cp   ":":jrz $P1
            cp   "@":jrnz $P8
            jr   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_THAN
            exx
            dec  hl:ld a,(hl):dec hl
            or   (hl):inc hl,hl
            exx
            jrnz $P1
$P27
ПОИСК СКОБОК ЕСЛИ ТАКОВЫЕ ЕСТЬ
И ПРЫЖОК ЧЕРЕЗ НИХ
            ld   a,(ix):cp "{"
ЕСЛИ ПЕРВ. "{"
            jrz  $P28

            cp   #0D
            jrnz $P3
ЕСЛИ СНАЧАЛА #0D
            ld   a,(ix+1)
            cp   "{"
            jrnz $P3
А ПОТОМ "{"
            inc  ix
ИЩЕМ "}"
$P28
            inc  ix
            ld   a,(ix)
            cp   "}"
            jrnz $P28
            jr   $P3
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_ELSE
            exx
            dec  hl:ld a,(hl):dec hl
            or   (hl):inc hl,hl
            exx
            jpz  $P1
            jr   $P27
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_NEXT
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_ON
            ld   a,1
$P26
            ld   l,a
            exa
            ld   a,l
            exa
            call TARGTURN
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_OFF
            xor  a
            jr   $P26
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_CHANGE
УСТАНОВИМ HL' НА ДОПОЛНИТЕЛЬНЫЙ БУФЕР
            exx
            push hl
            ld   hl,ARGD
            exx
            call TAKEJARG
            call TAKEMEDARG
            call TAKEARG
            ld   hl,$P30
            push hl
            exx
            ld   de,0-6
            add  hl,de
            ld   e,(hl):inc hl
            ld   d,(hl):inc hl
            push de:exx:pop hl:exx
            ld   e,(hl):inc hl
            ld   d,(hl):inc hl
            push de
            ld   e,(hl):inc hl
            ld   d,(hl)
            push de
            ld   de,0-5
            add  hl,de
УКАЗАТЕЛЬ БУФЕРА НА ПЕРВЫЙ АРГУМЕНТ
            exx:pop bc
В СТЕКЕ АДРЕС  ОПЕРАЦИИ
■bc-ВТОРОЙ АРГУМЕНТ
■hl-ПРОЦЕДУРА СЧИТЫВАНИЯ ПЕРВОГО
АРГУМЕНТА И ЗАПОМИНАНИЕ РЕЗУЛЬТАТА
ПОСЛЕ ОБРАБОТКИ ОПЕРАЦИИ
            jp   (hl)
$P30
            exx
            pop  hl
            exx
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_OPEN
СКОБА ОТКРЫТА
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_CLOSE
СКОБА ЗАКРЫТА
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_TONN
ПОДСЧЕТ ТОНАЖА И ЕГО СТОРИНГ
            ld   de,-TWRI
            call TAKETON
            ld   (TONN),a
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_EXIT
ПРОСТО ВЫХОД ИЗ ЯЗЫКА
            ld   sp,(STKMEM+1)
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MESSAGE
ВКЛЮЧИМ ФЛАГ ВЫХОДА НА СЛЕД. #0D
            ld   a,1
            ld   (F_EXIT+1),a
            call TAKENUM
            dec  l:ld a,l
ВЫВЕСТИ СООБЩЕНИЕ ПО НОМЕРУ В a
            push ix
            call OPENER_L
            pop  ix
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_mESSAGE
ВЫВОД СООБЩЕНИЯ О ОШИБКЕ ОПЕРАЦИИ
НО БЕЗ ВЫХОДА ИЗ ЯЗЫКА НА СЛЕД. СТРОКЕ
            jp   _MESSAGE+5
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_WYDWOR
            ld   a,255
            ld   (WYDWOR+1),a
            jp   $P1
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_OVER

■??????????
            jp   $P1
■??????????
;            ld   sp,(STKMEM+1)
;            pop  af
;            jp   GAMEOVER









▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
ОПЕРАНДЫ КОМАНДЫ ПЕРЕКЛЮЧЕНИЯ
ВХОД С A'-0(ВЫКЛ),1(ВКЛ)


T_TXT
ВКЛЮЧЕНИЕ И ПОКАЗ ТЕКСТА
            exa:or a:retz
            call TAKENUM
            push hl

СТРУКТУРА РАЗДЕЛИТЕЛЯ:
■ _p23s8t1

ИЩЕМ НАЧАЛА ТЕСТОВ ПО РАЗДЕЛИТЕЛЮ "_"
            ld   hl,TXTES
$P33
            ld   bc,0
            ld   a,"_"
            cpir
            inc  hl
ПРОПУСТИЛИ БУКВУ "p"
БЕРЕМ НОМЕР
            push ix
            push hl:pop ix
            call TAKENUM
            ld   c,l
            push ix:pop hl
            pop  ix
НОМЕР ТЕКУЩЕГО ПЕРСОНАЖА
            ld   a,(PERSONAJ)
            cp   c
            jpnz $P33
НЕ ТОТ ПЕРСОНАЖ
            inc  hl
ПРОПУСТИЛИ БУКВУ "s"
НОМЕР СЦЕНЫ
            push ix
            push hl:pop ix
            call TAKENUM
            ld   c,l
            push ix:pop hl
            pop  ix
            ld   a,(SCENA)
            cp   c
            jpnz $P33
            inc  hl
ПРОПУСТИЛИ БУКВУ "t"
НОМЕР ТЕКСТА
            push ix
            push hl:pop ix
            call TAKENUM
            ld   c,l
            push ix:pop hl
            pop  ix
            pop  de:push de
            ld   a,e
            cp   c
            jpnz $P33
            pop  de

            ld   a,(hl):inc hl
            cp   CR
            jrnz $-4
ПРОПУСТИЛИ РАЗДЕЛИТЕЛЬ СТРОК КАК #0D
■hlАДРЕС ТЕКСТА
■deНОМЕР ТЕКСТА

            ld   a,(PERSONAJ)
            ld   bc,(SCENA-1)
            push hl
            call FINDINTREE
            ld   (hl),1
            pop  hl

ВЫЗОВ ПРОЦЕДУРЫ ВЫВОДА ТЕКСТА
            ret


░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
T_PERS
ВКЛ. ПЕРСОНАЖЕЙ
            call TAKENUM
            ld   de,t_PERS-1
$P31
            add  hl,de
            exa
            ld   (hl),a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
T_QUES
В. ВОПРОСЫ
            call TAKENUM
            ld   de,t_QUES-1
            jr   $P31
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
T_MISS
В. МИССИИ
            call TAKENUM
            ld   de,t_MISS-1
            jr   $P31
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
T_HAPP
В. СОБЫТИЯ
            call TAKENUM
            ld   de,t_HAPP-1
            jr   $P31
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
T_KRB
В. КОРАБЛЕЙ
            call NUMSHIP
            exa:or a
            ld   a,c
            jrnz $+4:ld a,#FF
            ld   (SHIP),a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
T_SKM
В. СКИМЕРОВ
            call NUMSHIP
            exa:or a
            ld   a,c
            jrnz $+4:ld a,#FF
            ld   (SKIMMER),a
            ret







▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
АРГУМЕНТЫ


U_SUMM
            ld   de,(SUMM)
PUTWORD
            push de
            exx
            pop  de
            ld   (hl),e:inc hl
            ld   (hl),d:inc hl
            exx
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
U_WKRB
            call $P21
            jp   PUTWORD
$P21
            exx
            ld   b,KCOM4
            exx
            ld   de,CODE4-3
            call T_NWKRB
            ld   hl,$+6
            jp   OBRARGU
ПРОЦЕДУРА ЧТЕНИЯ ЗНАЧЕНИЯ
СЮДА БУДЕТ ПЕРЕХОД, ЕСЛИ АРГУМЕНТ БЕЗ
ВЫБОРА СВОЙСТВА, С НОМЕРОМ ИЛИ БЕЗ
■hl-ИНДЕКС
            ld   de,WKRBI
$P38
            add  hl,de
            ld   a,(hl)
            or   a:jpp $+4:cpl
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
U_WSKM
            call $P22
            jp   PUTWORD
$P22
            exx
            ld   b,KCOM5
            exx
            ld   de,CODE5-3
            call T_NWSKM
            ld   hl,$+6
            jp   OBRARGU
            ld   de,WSKMI
            jr   $P38
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
U_SHIP
            call $+6
            jp   PUTWORD
            ld   bc,(SHIP)
            ld   b,0
            exx
            ld   b,KCOM10
            exx
            ld   de,CODE10-3
            ld   hl,$+6
            jp   OBRARGU
            ld   de,(SHIP):ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
U_SKIMMER
            call $+6
            jp   PUTWORD
            ld   bc,(SKIMMER)
            ld   b,0
            exx
            ld   b,KCOM12
            exx
            ld   de,CODE12-3
            ld   hl,$+6
            jp   OBRARGU
            ld   de,(SKIMMER):ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MASSA
            ld   a,(TONN)
PUTBYTE
            exx
            ld   (hl),a:inc hl
            ld   (hl),0:inc hl
            exx
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_TONAJ
            ld   a,(TONN+1)
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_YES
            ld   a,1
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_NO
            xor  a
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_OPERATION
            ld   a,(OPERATION)
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_STATUS
            ld   a,(STATUS)
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
S_CARGO
            call $P24
            jp   PUTWORD
$P24
            exx
            ld   b,KCOM9
            exx
            ld   de,CODE9-3
            call T_NTWR
            ld   hl,$+6
            jp   OBRARGU
            add  hl,hl
            ld   de,TWRS
            add  hl,de
            ld   a,(hl)
            and  #7F:ld e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
S_WKRB
ПРОВЕРИТЬ ПРИСУТСТВИЕ ОСНАЩЕНИЯ НА
ЭТОЙ СТАНЦИИ С ЭТИМ УРОВНЕМ РАЗВИТИЯ
            call $+6
            jp   PUTWORD
            exx
            ld   b,KCOM6
            exx
            ld   de,CODE6-3
            call T_NWKRB
            ld   hl,$+6
            jp   OBRARGU
            ld   de,TONNS
$P16
            add  hl,hl
            add  hl,de
            ld   a,(hl)
            push af
            call PINFOL2
            ld   a,l
            pop  hl
            cp   h
            ld   a,0
            jrc  $+3:inc a
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
S_WSKM
            call $+6
            jp   PUTWORD
            exx
            ld   b,KCOM7
            exx
            ld   de,CODE7-3
            call T_NWSKM
            ld   hl,$+6
            jp   OBRARGU
            ld   de,TONSS
            jr   $P16
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
S_SHIP
            call $+6
            jp   PUTWORD
            call NUMSHIP
            exx
            ld   b,KCOM10
            exx
            ld   de,CODE10-3
            ld   hl,$+6
            jp   OBRARGU
КОРАБЛЕЙ НА СТАНЦИИ НЕМЕРЕНО
            ld   de,#7F
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
S_SKIMMER
            call $+6
            jp   PUTWORD
            call NUMSHIP
            exx
            ld   b,KCOM12
            exx
            ld   de,CODE12-3
            ld   hl,$+6
            jp   OBRARGU
            ld   de,#7F
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
U_CARGO
            call $P23
            jp   PUTWORD
$P23
            exx
            ld   b,KCOM8
            exx
            ld   de,CODE8-3
            call T_NTWR
            ld   hl,$+6
            jp   OBRARGU
            add  hl,hl
            ld   de,TWRI
            add  hl,de
            ld   e,(hl):ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_NUMBER
            dec  ix
            call TAKENUM
            EXD
            jp   PUTWORD
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SKOBA
            call TAKEARG

            call TAKEMEDARG
            call TAKEARG
            call RUN
            ld   a,(ix)
            cp   ")":jrnz _SKOBA+3
            inc  ix
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_HAPPAND
            call TAKENUM
            ld   de,t_HAPP
$P37
            add  hl,de
            ld   a,(hl)
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MISSION
            call TAKENUM
            ld   de,t_MISS
            jr   $P37
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_TXT
ЧТЕНИЕ СОСТОЯНИЯ ТЕКСТА ПЕРСОНАЖА И
СЦЕНЫ КОРОТКИЙ ВАРИАНТ ЗАПИСИ. БЕЗ
НОМЕРА ПЕРСОНАЙА И СЦЕНЫ
            call TAKENUM
            EXD
            ld   a,(PERSONAJ)
            ld   bc,(SCENA-1)
            jr   $P36

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_PERSTXT
ЧТЕНИЕ СОСТОЯНИЯ ТЕКСТА ПЕРСОНАЖА И
СЦЕНЫ
            call TAKENUM
            ld   h,l
            push hl
            inc  ix
            call TAKENUM
            ld   h,l
            push hl
            inc  ix
            call TAKENUM
            EXD
            pop  bc,af
$P36
            call FINDINTREE
            ld   a,(hl)
            jp   PUTBYTE
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
P_PLANET
ПЛАНЕТА ПРЕБЫВАНИЯ
            call $+6
            jp   PUTWORD
            exx
            ld   b,KCOM11
            exx
            ld   c,0
            ld   de,CODE11-3
            ld   hl,$+6
            jp   OBRARGU
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
R_PLANET
ПЛАНЕТА ПЕРЕЛЕТА
            call $+6
            jp   PUTWORD
            exx
            ld   b,KCOM11
            exx
            ld   c,1
            ld   de,CODE11-3
            ld   hl,$+6
            jp   OBRARGU
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
P_SYSTEM
СИСТЕМА ПРЕБЫВАНИЯ
            call $+6
            jp   PUTWORD
            exx
            ld   b,KCOM13
            exx
            ld   c,0
            ld   de,CODE13-3
            ld   hl,$+6
            jp   OBRARGU
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
R_SYSTEM
СИСТЕМА ПЕРЕЛЕТА
            call $+6
            jp   PUTWORD
            exx
            ld   b,KCOM13
            exx
            ld   c,1
            ld   de,CODE13-3
            ld   hl,$+6
            jp   OBRARGU
            ret









▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
ОПЕРАЦИИ
ВХОД de-ПЕРВЫЙ АРГУМЕНТ
■    bc-ВТОРОЙ АРГУМЕНТ
■retde-РЕЗУЛЬТАТ


_EQUALLY
            EXD
            SUB_BC
            ld   de,1:retz
            dec  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MULTI
■de=bc*de
            ld   hl,0
 rept 3:sla c:rl b:jrnc $+3:add hl,de:add hl,hl:jpc $P32:endr
 rept 12:sla c:rl b:jrnc $+3:add hl,de:add hl,hl:jrc $P32:endr
            sla  c:rl b
            jrnc $+3:add hl,de
            ex   de,hl
            ret
$P32
            ld   de,#FFFF
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_PLUS
            EXD
            add  hl,bc
            jrnc $+5:ld hl,#FFFF
            EXD
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MINUS
            EXD
            SUB_BC
            jrnc $+5:ld hl,0
            EXD
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_LESS
            EXD
            SUB_BC
            ld   de,1:retc
            dec  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MORE
            EXD
            SUB_BC
            ld   de,0:retz:retc
            inc  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_LESSEQ
            EXD
            SUB_BC
            ld   de,1:retc:retz
            dec  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_MOREEQ
            EXD
            SUB_BC
            ld   de,0:retc
            inc  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_AND
            ld   a,d:and b
            ld   d,a
            ld   a,e:and c
            ld   e,a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_OR
            ld   a,d:or b
            ld   d,a
            ld   a,e:or c
            ld   e,a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SET
            ld   d,b:ld e,c
            ret











▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
СВОЙСТВА

ВХОД С hl=#FFFF !!! В СТЕКЕ !!!, ЗНАЧИТ
АРГУМЕНТ БЫЛ БЕЗ НОМЕРА, Т.Е. ТОТ НА
КОТОРОМ СТОИТ КУРСОР
ЕСЛИ <>#FFFF, ТО АРГУМЕНТ С НОМЕРОМ


_SWKRB_C
ЦЕНА ОСН.КОРАБЛЯ
            ld   de,CENS
$P13
            pop  hl
            ld   h,0
            add  hl,hl
            add  hl,de
            ld   e,(hl):inc hl
            ld   d,(hl)
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWKRB_V
ВЕС ОСН.КОРАБЛЯ
            ld   de,TONNS+1
$P14
            pop  hl
            ld   h,0
            add  hl,hl
            add  hl,de
            ld   e,(hl):ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_UWKRB_S
СВОЙСТВО ПРОВЕРЯЕТ ВСЕ ВООРУЖЕНИЕ НА
ПРИСУТСТВИЕ НА ЭТОМ УРОВНЕ
            pop  hl
            call PINFOL2
            ld   a,l:ld ($P17+1),a
            ld   hl,TONNS
            ld   de,WKRBI
            ld   b,WKKOL
$P18
            ld   a,(de):or a:jpp $+4:cpl
            or   a:jrz $P19
$P17        ld   a,0
            cp   (hl)
            ld   a,0:jrc $P20
$P19
            inc  hl,hl,de
            djnz $P18
            ld   a,1
$P20
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_UWKRB_N
СВОЙСТВО ПРОВЕРЯЕТ ВООРУЖЕНИЕ
НА ПОВТОРЯЕМОСТЬ ПОДОБНЫХ ВИДОВ
            ld   bc,WKII
            ld   de,WKRBI
$P12
            pop  hl
            ld   h,0
            ld   a,l
ТАБЛ. СВЯЗИ ТИПОВ ВООРУЖ.
            add  hl,de
            EXD
            push de
            add  a,a
            ld   l,a
            ld   h,0
            add  hl,bc
            EXD
            ld   a,(de)
            ld   c,a:dec c
$P50
            inc  c:jrz $P49
            dec  hl
            ld   a,(hl):or a:jpp $+4:cpl
            or   a:jrz $P50
            pop  hl
            jr   $P52
$P49
            pop  hl
            inc  de
            ld   a,(de)
            ld   c,a:inc c
$P51
            dec  c:jrz $P52
            inc  hl
            ld   a,(hl):or a:jpp $+4:cpl
            or   a:jrz $P51
$P52
            ld   de,0:retz
            inc  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWKRB_S
ПРОВЕРИТЬ СООТВЕТСВИЯ ОСНАЩЕНИЯ КОРАБЛЮ
            ld   a,(SHIP)
            ld   de,KRBARM
$P11
            pop  hl
            ld   h,0
            ADDHLHL 2
            add  hl,de
      rept 3:cp (hl):inc hl:jrz $P10:endr
            cp (hl)
$P10
            ld   de,0:retz
            inc  de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWKRB_K
            ld   de,WKRBI
$P15
            pop  hl
            ld   h,0
            add  hl,de
            ld   a,#7F:bit 7,(hl)
            jrz  $+4:ld a,1
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWSKM_C
            ld   de,CENS1
            jp   $P13
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWSKM_V
            ld   de,TONSS+1
            jp   $P14
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_UWSKM_S
            pop  hl
            call PINFOL2
            ld   a,l:ld ($P17+1),a
            ld   de,TONSS
            ld   hl,WSKMI
            ld   b,WSKOL
            jp   $P18
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_UWSKM_N
            ld   bc,WSII
            ld   de,WSKMI
            jp   $P12
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWSKM_S
            ld   de,SKMARM
            ld   a,(SKIMMER)
            jp   $P11
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SWSKM_K
            ld   de,WSKMI
            jp   $P15
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_UCARGO_C
            ld   de,TWRI+1
            jp   $P14
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SCARGO_C
            ld   de,TWRS+1
            jp   $P14
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SCARGO_S
            pop  hl
            ld   h,0
            ld   de,TWRS
            add  hl,hl
            add  hl,de
            xor  a:bit 7,(hl)
            jrnz $+3:inc a
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SCARGO_M
ОСОБЕННОСТЬ:
ДАННАЯ СВОЙСТВО ДАЕТ ПОЛНЫЙ ПОДСЧЕТ
ТОНАЖА ВСЕГО КОРАБЛЯ + СКИМЕР
И ДОБАВЛЯЕТ ЕДЕНИЦУ ТЕКУЩЕГО ИЛИ
НУМЕРОВАННОГО ТОВАРА
            pop  hl
            ld   h,0
            call TAKETON
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SHIP_C
            ld   de,CNKR+1
$P40
            pop  hl
            ld   h,0
            push hl
            ADDHLHL 2
            pop  bc
            add  hl,bc
            add  hl,de
            ld   e,(hl):inc hl
            ld   d,(hl)
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SHIP_T
            ld   de,CNKR
$P39
            pop  hl
            ld   h,0
            push hl
            ADDHLHL 2
            pop  bc
            add  hl,bc
            add  hl,de
            ld   e,(hl):ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SHIP_S
            ld   de,CNKR+4
            jp   $P39
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SKIMER_C
            ld   de,CNSK+1
            jp   $P40
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SKIMER_V
            ld   de,CNSK+4
            jp   $P39
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_PLANET_S
            pop  bc
            call TAKE_PINFO
            ld   e,h:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_PLANET_C
            pop  bc
            call TAKE_PINFO
            ld   d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_PLANET_U
            pop  bc
            call TAKE_PINFO
            EXD
            ld   d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SYSTEM_P
            pop  bc
            call TAKE_PINFO
            ld   e,a:ld d,0
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
_SYSTEM_G
            pop  bc
            call TAKE_PINFO
            ld   e,d:ld d,0
            ret




▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
ОПЕРАНДЫ КОМАНДЫ ИЗМЕНЕНИЯ ЗНАЧЕНИЯ
НЕРАЗРЕШАЕТСЯ ОПЕРАНДУ БЫТЬ СО СВОЙСТВОМ


В СТЕКЕ ПРИХОДИТ АДРЕС ОПЕРАЦИИ
■bc-ВТОРОЙ АРГУМЕНТ
SUM_M
            ld   de,$+6
            jp   PUTWORD
            pop  de
            ld   hl,$+9
            push hl
            ld   hl,(SUMM)
            EXD
            jp   (hl)
            ld   (SUMM),de
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
STATU_S
            ld   de,$+6
            jp   PUTWORD
            pop  de
            ld   hl,$+11
            push hl
            ld   hl,(STATUS):ld h,0
            EXD
            jp   (hl)
            ld   a,e
            ld   (STATUS),a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
TONA_J
            ld   de,$+6
            jp   PUTWORD
            pop  de
            ld   hl,$+11
            push hl
            ld   hl,(TONN+1):ld h,0
            EXD
            jp   (hl)
            ld   a,e
            ld   (TONN+1),a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
GRU_z
            call $P23
$P25
            ld   a,e
            ld   ($P54+1),hl
            ld   ($P54+4),a
            ld   de,$+6
            jp   PUTWORD
            pop  de
$P54        ld   hl,0
            ld   a,0
            push hl
            ld   hl,$+9
            push hl
            ld   l,a:ld h,0
            EXD
            jp   (hl)
            pop  hl
            ld   a,d:or a
            jrz  $+4:ld e,#7F
            ld   a,e:and #7F:ld e,a
            ld   a,(hl):and #80:or e
            ld   (hl),a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
GRU_Z
            call $P24
            jp   $P25
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
WKR_B
            call $P21
$P9
            ld   ($P53+1),hl
            ld   ($P53+4),a
            ld   de,$+6
            jp   PUTWORD
            pop  de
$P53        ld   hl,0
            ld   a,0
            push hl
            ld   hl,$+9
            push hl
            ld   l,a:ld h,0
            EXD
            jp   (hl)
            pop  hl
            bit  7,(hl)
            ld   a,e:jrz $+3:cpl
            ld   (hl),a
            ret
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
WSK_M
            call $P22
            jp   $P9









▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
ДОП. ПРОЦЕДУРЫ


РАСПОЗНАТЬ ЧИСЛО В hlИЗ ДАННЫХ В ix
■ix-НА ПЕРВУЮ ЦИФРУ ЧИСЛА
TAKENUM
            inc  ix
            ld   a,(ix):ld b,1
            cp   "0":jrc $P5
            cp   "9"+1:jrnc $P5
            inc  ix
            ld   a,(ix):inc b
            cp   "0":jrc $P5
            cp   "9"+1:jrnc $P5
            inc  ix
            ld   a,(ix):inc b
            cp   "0":jrc $P5
            cp   "9"+1:jrnc $P5
            inc  ix
            ld   a,(ix):inc b
            cp   "0":jrc $P5
            cp   "9"+1:jrnc $P5
            inc  b
            inc  ix
$P5
            ld   a,(ix-1):sub 48:ld l,a
            ld   h,0
            djnz $+3:ret

            EXD
            ld   a,(ix-2):sub 48:ld l,a
            ld   a,b
            ld   h,0
            add  hl,hl
            push hl
            ADDHLHL 2
            pop  bc
            add  hl,bc
            add  hl,de
            ld   b,a
            djnz $+3:ret

            EXD
            ld   a,(ix-3):sub 48:ld l,a
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
            djnz $+3:ret

            EXD
            ld   a,(ix-4):sub 48:ld l,a
            ld   a,b
            ld   h,0
            push hl
            add  hl,hl
            pop  bc
            add  hl,bc:add hl,hl
            add  hl,bc:add hl,hl
            add  hl,bc:add hl,hl
            add  hl,bc:ADDHLHL 2
            add  hl,bc:ADDHLHL 3
            add  hl,de
            ld   b,a
            djnz $+3:ret

            EXD
            ld   a,(ix-5):sub 48:ld l,a
            ld   h,0
            push hl
            ADDHLHL 3
            pop  bc
            add  hl,bc:add hl,hl
            add  hl,bc:add hl,hl
            add  hl,bc:ADDHLHL 4
            add  hl,bc:ADDHLHL 4
            add  hl,de
            ret

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
TAKEMEDARG
ЧИТАЕМ МЕЖ_АРГУМЕНТ
            ld   a,(ix):inc ix
            ld   hl,CODE3-3
            ld   b,KCOM3
            call FINDSYMB
            inc  hl
            ld   e,(hl):inc hl
            ld   d,(hl)
■deАДРЕС ОБРАБОТКИ МЕЖ АРГУМЕНТА
            push de
            exx
            pop  de
            ld   (hl),e:inc hl
            ld   (hl),d:inc hl
            exx
            ret

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
TARGTURN
ПРОЧЕСТЬ АДРЕС ПЕРЕКЛЮЧАТЕЛЯ ПОЛОЖЕНИЯ
ВКЛ./ВЫКЛ.
■rethlАДРЕС ПЕРЕКЛЮЧАТЕЛЯ
            ld   a,(ix):inc ix
            ld   hl,CODE15-3
            ld   b,KCOM15
            jp   JUMPSYMB
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
TAKEJARG
ПРОЧЕСТЬ АДРЕС ОБРАБОТЧИКА ЧТЕНИЯ
АРГУМЕНТА И ЕГО ЗАПОМИНАНИЕ И ПОМЕСТИМ
ЕГО В БУФЕР
            ld   a,(ix):inc ix
            ld   hl,CODE14-3
            ld   b,KCOM14
            jp   JUMPSYMB
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
ПРОЧЕСТЬ АРГУМЕНТ
TAKEARG
            ld   a,(ix):inc ix
            ld   hl,CODE2-3
            ld   b,KCOM2
JUMPSYMB
■a-СИМВОЛ
■hl-ТАБЛИЦА ОБРАБОТЧИКОВ СИМВОЛОВ
■b-КОЛИЧЕСТВО СИМВОЛОВ В ТАБЛИЦЕ
            call FINDSYMB
            inc  hl
            ld   a,(hl):inc hl
            ld   h,(hl):ld l,a
            jp   (hl)


░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
FINDSYMB
ПОИСК АДРЕСА В ТБЛИЦЕ ПО СИМВОЛУ В a
■hlТАБЛИЦА
■b КОЛ.ПУНКТОВ ПОИСКА
■retFZ-ON ЕСЛИ НАШЛИ
АВТОМАТОМ ПЕРЕХОДИТ В $P3 ЕСЛИ НИЧЕГО НЕ
НАШЛИ !!!
            ld   de,3
            add  hl,de
            cp   (hl):retz
            djnz FINDSYMB+3
            jp   $P3




░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
OBRARGU
ОБРАБОТЧИК АРГУМЕНТОВ, СЧИТЫВАНИЕ ИХ
СО СВОЙСТВАМИ И БЕЗ
■ix-ТЕКСТ СЛЕД. ЗА СИМВОЛОМ АРГУМЕНТА
■bc-НОМЕР ПУНКТА ГДЕ СТОИТ КУРСОР С 0
■hl-ПРОЦЕДУРА ЧТЕНИЯ ЗНАЧЕНИЯ ИЗ ТАБЛИЦЫ
■de-ТАБЛИЦА СВОЙСТВ АРГУМЕНТА-3
■B'-КОЛ.ЭЛЕМЕНТОВ ТАБЛИЦЫ
            ld   ($P7+1),hl
МАРКЕР ТОГО ЧТО АРГУМЕНТ БЕЗ ЧИСЛА
НУЖНО ДЛЯ ОБРАБОТКИ ВЫБОРА СО СВОЙСТВОМ
            ld   l,c:ld h,0
            ld   a,(ix)
            cp   "."
            jrz  $P4
            cp   "0"
            jrc  $+6
            cp   "9"+1
            jrc  $P6
ЧИСТЫЙ "АРГУМЕНТ", ПРОСТО КОЛИЧЕСТВО
$P7
            jp   0
С ЧИСЛОМ
$P6
            push bc,de
            call TAKENUM
            pop  de,bc
            dec  hl
            ld   a,(ix)
            cp   "."
ЕСЛИ С ЧИСЛОМ И С ВЫБОРОМ СВОЙСТВА,
ЧИСЛО В hl
            jrnz $P7
С ВЫБОРОМ СВОЙСТВА
$P4
            inc  ix,ix
            push hl
            EXD
            exx:ld a,b:exx:ld b,a
            ld   a,(ix-1)
            jp   JUMPSYMB





░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
RUN
ИСПОЛНЕНИЕ ОПЕРАЦИИ
            ld   hl,PUTWORD
            push hl
            exx
            ld   de,0-6
            add  hl,de
            ld   e,(hl):inc hl
            ld   d,(hl):inc hl
            push de:exx:pop de:exx
            ld   e,(hl):inc hl
            ld   d,(hl):inc hl
            push de:exx:pop hl:exx
            ld   e,(hl):inc hl
            ld   d,(hl)
            push de
            ld   de,0-5
            add  hl,de
УКАЗАТЕЛЬ БУФЕРА НА ПЕРВЫЙ АРГУМЕНТ
            exx:pop bc
■hl-АДРЕС  ОПЕРАЦИИ
■de-ПЕРВЫЙ АРГУМЕНТ
■bc-ВТОРОЙ АРГУМЕНТ
            jp   (hl)
■de-РЕЗУЛЬТАТ






FINDINTREE
ИЩЕМ ИДЕНТИФИКАТОР ТЕКСТА ПО ДЕРЕВУ В
ЗАВИСИМОСТИ ОТ НОМЕРА ПЕРСОНАЖА И СЦЕНЫ
■a-ПЕРСОНАЖ
■b-СЦЕНА
■de-ТЕКСТ
■rethl-АДРЕС ИДЕНТИФИКАТОРА ТЕКСТА
            ld   (_PERSONAJ+1),a
            ld   a,b
            ld   (_SCENA+1),a

            ld   hl,t_TREE
            ld   a,#FF
_PERSONAJ   ld   b,0
ПОИСК ПЕРСОНАЖА ПО НОМЕРУ
$P34
            push bc
            ld   bc,0
            cpir
            pop  bc
            djnz $P34
            dec  a
_SCENA      ld   b,0
ПОИСК СЦЕНЫ ПО НОМЕРУ
$P35
            push bc
            ld   bc,0
            cpir
            pop  bc
            djnz $P35
НАЗАД НА ИДЕНТИФИКАТОР СЦЕНЫ Т.К. НОМЕРА
ТЕКСТОВ С 1, И ПРИБАВИМ НОМЕР ТЕКСТА
В СЦЕНЕ К АДРЕСУ НАЧАЛА И БУДЕМ НА
НУЖНОМ ИДЕНТИФИКАТОРЕ СЦЕНЫ
            dec  hl
            add  hl,de
            ret







░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
TAKETON
ПОДСЧЕТ ОБЩЕГО ВЕСА ВСЕГО ГРУЗА
■hl-ИНДЕКС ТОГО ПУНКТА ТОВАРА
КОТОРЫЙ БУДЕТ УВЕЛИЧЕН НА ЕДЕНИЦУ ДЛЯ
ПРОВЕРКИ ПОКУПАЕМОСТИ ПО ТОНАЖУ
ДЛЯ ТОВАРА
■hl=0-TWRI ПРОСТАЯ ПРОВЕРКА ТОНАЖА
■reta- КОЛИЧЕСТВО ТОНН ГРУЗА
            add  hl,hl
            ld   de,TWRI
            add  hl,de
ЗАПОМНИМ АДРЕСА ВО ВСЕХ ГРУППАХ НАКОПЛЕНИЯ
ВЕСА, ТОЛЬКО В ОДНОЙ ИЗ НИХ СРАБОТАЕТ
УВЕЛИЧЕНИЕ НА ЕДЕНИЦУ КОМПОНЕНТА ГРУЗА
ИЛИ ОСНАЩЕНИЯ
            ld   ($P43+1),hl
ТАБЛИЦА ПОКАЗАТЕЛЕЙ ВЕСА ТОВАРОВ
■0-ТОННА
■1-ЧЕЛОВЕК 1/16тн
■2-ДР.        0тн
            ld   hl,TWRM
            ld   a,TKOL
            ld   c,0
$P42
            exa
            ld   a,(de)
            and  #7F
            push hl
$P43        ld   hl,0:SUB_DE
            pop  hl
            jrnz $+3:inc a
            inc  de,de
            ld   b,(hl):inc hl
            dec  b:jpm $P41
            rept 4:rrca:endr:and #0F
            dec  b:jpm $P41
            xor  a
$P41
            add  a,c
            ld   c,a
            exa:dec a:jpnz $P42

            ld   hl,TONNS+1
            ld   de,WKRBI
            ld   a,WKKOL
$P44
            exa
            ld   a,(de):inc de
            or   a:jpp $+4:cpl
            ld   ($P45+1),a
            ld   b,(hl)
            inc  hl,hl
            xor  a
$P45        add  a,0
            djnz $-2
            add  a,c
            ld   c,a
            exa
            dec  a:jpnz $P44

            ld   hl,TONSS+1
            ld   de,WSKMI
            ld   a,WSKOL
$P46
            exa
            ld   a,(de):inc de
            or   a:jpp $+4:cpl
            ld   ($P47+1),a
            ld   b,(hl)
            inc  hl,hl
            xor  a
$P47        add  a,0
            djnz $-2
            add  a,c
            ld   c,a
            exa
            dec  a:jpnz $P46

            ld   a,(SKIMMER)
            inc  a
            jrz  $P48
            dec  a:ld e,a
            rlca:rlca:add a,e:ld e,a
            ld   d,0
            ld   hl,CNSK+4
            add  hl,de
            ld   a,(hl)
$P48
            add  a,c
            ret



БЕРУТ ТЕКУЩИЙ НОМЕР ПУНКТА
T_NWKRB
            ld   a,(NWKRB+1):ld c,a
            ld   a,(IWKRB+1):add a,c
            ld   c,a:ld b,0
            ret
T_NWSKM
            ld   a,(NWSKM+1):ld c,a
            ld   a,(IWSKM+1):add a,c
            ld   c,a:ld b,0
            ret
T_NTWR
            ld   a,(NTWR+1):ld c,a
            ld   a,(ITWR+1):add a,c
            ld   c,a:ld b,0
            ret


БЕРЕТ ИНФО О СИСТЕМЕ ПЕРЕЛЕТА ИЛИ
НАХОЖДЕНИЯ В ЗАВ. ОТ РЕГ. c
■c=1 СИСТЕМА ПЕРЕЛЕТА
TAKE_PINFO
            dec  c
            jpnz PINFOL2
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            ld   a,(WPLANET)
            jp   PINFOL


▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
ТАБЛИЦЫ, ДАННЫЕ


КОМАНДЫ
КОЛИЧЕСТВО КОМАНД
ТАБЛИЦА СИМВОЛОВ И АДРЕСОВ КОМАНД
CODE
            db   "?":dw _IF
            db   ":":dw _THAN
            db   "{":dw _OPEN
            db   "}":dw _CLOSE
            db   "@":dw _ELSE
            db   "+":dw _ON
            db   "-":dw _OFF
            db   "=":dw _CHANGE
            db   ",":dw _NEXT
            db   "T":dw _TONN
            db   "M":dw _MESSAGE
            db   "m":dw _mESSAGE
            db   "^":dw _EXIT
            db   "#":dw _OVER
            db   "W":dw _WYDWOR
KCOM        equ  $-CODE/3

МЕЖ_АРГУМЕНТЫ
CODE3
            db "=":dw _EQUALLY
            db "*":dw _MULTI
            db "+":dw _PLUS
            db "-":dw _MINUS
            db "<":dw _LESS
            db ">":dw _MORE
            db "[":dw _LESSEQ
            db "]":dw _MOREEQ
            db "&":dw _AND
            db "!":dw _OR
            db ":":dw _SET
KCOM3       equ  $-CODE3/3

АРГУМЕНТЫ
CODE2
            db "c":dw U_SUMM
            db "o":dw U_WKRB
            db "i":dw U_WSKM
            db "k":dw U_SHIP
            db "r":dw U_SKIMMER
            db "j":dw _MASSA
            db "J":dw _TONAJ
            db "y":dw _YES
            db "n":dw _NO
            db "X":dw _OPERATION
            db "u":dw _STATUS
            db "G":dw S_CARGO
            db "O":dw S_WKRB
            db "I":dw S_WSKM
            db "K":dw S_SHIP
            db "R":dw S_SKIMMER
            db "g":dw U_CARGO
            db "e":dw _HAPPAND
            db "m":dw _MISSION
            db "p":dw _PERSTXT
            db "t":dw _TXT
            db "(":dw _SKOBA
            db "1":dw _NUMBER
            db "2":dw _NUMBER
            db "3":dw _NUMBER
            db "4":dw _NUMBER
            db "5":dw _NUMBER
            db "6":dw _NUMBER
            db "7":dw _NUMBER
            db "8":dw _NUMBER
            db "9":dw _NUMBER
            db "0":dw _NUMBER
            db "L":dw P_PLANET
            db "l":dw R_PLANET
            db "Y":dw P_SYSTEM
            db "y":dw R_SYSTEM
KCOM2       equ  $-CODE2/3



ТАБЛИЦЫ ОБРАБОТКИ СВОЙСТВ ДЛЯ КАЖДОГО
ВИДА АРГУМЕНТОВ ВХОД С HL'=#FFFF, ЗНАЧИТ
АРГУМЕНТ БЫЛ БЕЗ НОМЕРА, Т.Е. ТОТ НА
КОТОРОМ СТОИТ КУРСОР
ЕСЛИ <>#FFFF, ТО АРГУМЕНТ С НОМЕРОМ

СВОЙСТВА ДЛЯ ВООРУЖЕНИЯ КОРАБЛЯ НА БОРТЕ
СВОЙСТВО "s" ПРОВЕРЯЕТ ВСЕ ВООРУЖЕНИЕ
CODE4
            db "s":dw _UWKRB_S■СТАТУС
            db "n":dw _UWKRB_N
KCOM4       equ  $-CODE4/3


СВОЙСТВА ДЛЯ ВООРУЖЕНИЯ СКИМЕРА НА БОРТЕ
СВОЙСТВО "s" ПРОВЕРЯЕТ ВСЕ ВООРУЖЕНИЕ
CODE5
            db "s":dw _UWSKM_S
            db "n":dw _UWSKM_N
KCOM5       equ  $-CODE5/3


СВОЙСТВА ДЛЯ ВООРУЖЕНИЯ КОРАБЛЯ НА СТАНЦ
CODE6
            db "c":dw _SWKRB_C
            db "v":dw _SWKRB_V
            db "s":dw _SWKRB_S
            db "k":dw _SWKRB_K
KCOM6       equ  $-CODE6/3


СВОЙСТВА ДЛЯ ВООРУЖЕНИЯ СКИМЕРА НА СТАНЦ
CODE7
            db "c":dw _SWSKM_C
            db "v":dw _SWSKM_V
            db "s":dw _SWSKM_S
            db "k":dw _SWSKM_K
KCOM7       equ  $-CODE7/3


СВОЙСТВА ГРУЗОВ НА БОРТЕ
CODE8
            db "c":dw _UCARGO_C
KCOM8       equ  $-CODE8/3


СВОЙСТВА ГРУЗОВ НА СТАНЦИИ
CODE9
            db "c":dw _SCARGO_C
            db "s":dw _SCARGO_S
            db "m":dw _SCARGO_M
KCOM9       equ  $-CODE9/3


СВОЙСТВА КОРАБЛЯ
CODE10
            db "c":dw _SHIP_C
            db "t":dw _SHIP_T■ТОНАЖ
            db "s":dw _SHIP_S
KCOM10      equ  $-CODE10/3


СВОЙСТВА ПЛАНЕТ
CODE11
            db "s":dw _PLANET_S
            db "c":dw _PLANET_C
            db "u":dw _PLANET_U
KCOM11      equ  $-CODE11/3


СВОЙСТВА СИСТЕМ
CODE13
            db "p":dw _SYSTEM_P
            db "g":dw _SYSTEM_G
KCOM13      equ  $-CODE13/3


СВОЙСТВА СКИМЕРА
CODE12
            db "c":dw _SKIMER_C
            db "v":dw _SKIMER_V
KCOM12      equ  $-CODE12/3




ОПЕРАНДЫ КОМАНДЫ "ИЗМЕНЕНИЕ ЗНАЧЕНИЯ"
CODE14
            db "c":dw SUM_M
            db "u":dw STATU_S
            db "g":dw GRU_z
            db "G":dw GRU_Z
            db "o":dw WKR_B
            db "i":dw WSK_M
            db "J":dw TONA_J
KCOM14      equ  $-CODE14/3


ОПЕРАНДЫ КОМАНДЫ ПЕРЕКЛЮЧЕНИЯ
CODE15
            db "t":dw T_TXT
            db "p":dw T_PERS
            db "v":dw T_QUES
            db "m":dw T_MISS
            db "e":dw T_HAPP
            db "K":dw T_KRB
            db "R":dw T_SKM
KCOM15      equ  $-CODE15/3



БУФЕР АРГУМЕНТОВ И ОПЕРАЦИЙ

БУФЕР ИСПОЛЬЗУЕТСЯ ТАК:
ЗАНОСИТСЯ ПЕРВЫЙ АРГУМЕНТ,ОПЕРАЦИЯ
ВТОРОЙ АРГУМЕНТ, ПОТОМ ИДЕТ ВЫЧИСЛЕНИЕ
И ВЕСЬ РЕЗУЛЬТАТ ПОПАДАЕТ НА ПЕРВЫЙ
АРГУМЕНТ, ДАЛЕЕ ЗАНОСИМ СЛЕДУЮЩУЮ
ОПЕРАЦИЮ И ТРЕТИЙ АРГУМЕНТ
ЕСЛИ СКОБКИ, ТО БУФЕР ПРОДЛИВАЕТСЯ
ARG         ds 20



ДОПОЛНИТЕЛЬНЫЙ БУФЕР
ARGD        ds 20


CHECK_SCENARY
            insert "C_SCENAR.txt"
            db   0



ТЕКСТЫ СЦЕНАРИЯ, КОНВЕРТНУТЫЕ
TXTES



