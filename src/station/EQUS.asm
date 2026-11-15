;==============================================================================
; EQUS - константы и карта памяти станции
;
; Страницы: PGNORM #10 (основной образ), PGKRT #11 (KARTA), PGMUZ/PGBGD #13 (музыка и фоновые картинки),
; PG3D #14 (D3D), PGLANG #16 (LANG), PGHLP/PGFOTOS #17 (HELP, фотографии). Значения - то, что пишется в порт
; #7FFD (бит 4 = ПЗУ 48K).
;
; Память основной страницы: #6000 курсоры, #6300 AVAR (переменные: EYEX, EYEY, KCORD, NPG, Mcoord...),
; #8000 Forint (таблица векторов IM2), #8200 TBXX/Tabob/Bscr/SZTB/Font/DATAM (таблицы экрана, шрифт, данные).
; Количества (TKOL, WKKOL...), размеры буферов, а в конце файла - порты и коды команд (PORT_*, OPCODE_*).
; Метки, на которые ссылаются генераторы ассетов (CR, ET, TKOL, WKKOL, WSKOL, PGMUZ...), не переименовывались.
;==============================================================================

; Макс. длинна всего буфера описателя
; Стола
OVLEN       equ  #80

PGKRT       equ  #11
PGMUZ       equ  #13
PGNORM      equ  #10
PGBGD       equ  #13
PGHLP       equ  #17
PG3D        equ  #14
PGLANG      equ  #16
PGFOTOS     equ  #17

FOTOS       equ  #E700

CR          equ  #0D
ET          equ  #0A


Forint      equ  #8000              ; LEN #101
Backscr     equ  #C000

; Ширина пробела
SPLEN       equ  2


; Кол. товаров
TKOL        equ  30
; Кол. вооруж. корабля
WKKOL       equ  33
; Кол. вооруж. скимера
WSKOL       equ  14
; Кол. пунктов сетапа среды
SSKOL       equ  13
; Кол. пунктов сетапа игры
SGKOL       equ  43
; Количество персонажей вобще
PKOL        equ  50
; Количество пунктов меню хелпа
HKOL        equ  8
; Количество кораблей
SHKOL       equ  6
; Количество скиммеров
SKKOL       equ  4
; Количество вопросов основных
QKOL        equ  20
; Количество миссий
MKOL        equ  15
; Количество событий
HPKOL       equ  7


AVAR        equ  #6300
; Координаты окна просмотра во всей карте
EYEX        equ  AVAR
EYEY        equ  EYEX+1
; Координаты первой карты из набора
; Четырех во всей карте
KCORD       equ  EYEY+1
; Длинна и высота окна вывода карты в пкс
BXKRT       equ  KCORD+2
BYKRT       equ  BXKRT+1
; Номер страницы
NPG         equ  BYKRT+1
; Координаты курсора
Mcoord      equ  NPG+1
; Адрес звезды с которой можно проложить
; Маршрут
AWAYS       equ  Mcoord+2
TNAME       equ  AWAYS+2            ; 17
RNDD1       equ  TNAME+17
RNDD2       equ  RNDD1+2
Cord        equ  RNDD2+2

_FREE       equ  Cord+2


TBXX        equ  #8200              ; #300
Tabob       equ  TBXX+#0300         ; #100;#80 ELEM
Bscr        equ  Tabob+#0100        ; #300
SZTB        equ  Bscr+#0300         ; #100
Font        equ  SZTB+#0100         ; #800+#200 TABX
DATAM       equ  Font+#0A00         ; <>200
; Len=#1200  без DATAM


KURSA       equ  #6000
KURSAM      equ  KURSA+#0100
KURSAS      equ  KURSAM+#0100


Visibil     equ  #70
Detaliz     equ  #1F
Xvisibi     equ  #60


Px          equ  #1A
Pz          equ  #1E

Olen        equ  #40

; ------------------------------------------------------------------------------
; Оборудование ZX Spectrum / Kempston / TR-DOS (используются в BODY, BODYOCUR)
; ------------------------------------------------------------------------------
PORT_PAGE       equ  #7FFD              ; переключение страниц 128K (бит 3 - теневой экран, бит 4 - ПЗУ 48K)
PORT_AY_REG     equ  #FFFD              ; AY: номер регистра (чтение - значение)
PORT_AY_DATA    equ  #BFFD              ; AY: данные
PORT_ULA        equ  #FE                ; клавиатура, бордюр, звук
PORT_KEMPSTON   equ  #1F                ; джойстик Kempston
PORT_MOUSE_X    equ  #FBDF              ; мышь Kempston: координата X (Y - порт #FFDF)
PORT_MOUSE_BTN  equ  #FADF              ; мышь Kempston: кнопки
SYSVAR_IY       equ  #5C3A              ; значение IY для ПЗУ (системные переменные)
OPCODE_RET      equ  #C9                ; код команды ret (патч "объект выключен")
OPCODE_LD_HL    equ  #21                ; код команды ld hl,nn (патч "объект включен")
PG_SHADOW0      equ  #18                ; значение порта страниц: банк 0, ПЗУ 48K, теневой экран
