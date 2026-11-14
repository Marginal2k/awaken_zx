
; МАКС. ДЛИННА ВСЕГО БУФЕРА ОПИСАТЕЛЯ
; СТОЛА
OVLEN:      equ  #80

PGKRT:      equ  #11
PGMUZ:      equ  #13
PGNORM:     equ  #10
PGBGD:      equ  #13
PGHLP:      equ  #17
PG3D:       equ  #14
PGLANG:     equ  #16
PGFOTOS:    equ  #17

FOTOS:      equ  #E700

CR:         equ  #0D
ET:         equ  #0A



Forint:     equ  #8000              ;LEN #101
Backscr:    equ  #C000

; ШИРИНА ПРОБЕЛА
SPLEN:      equ  2



; КОЛ. ТОВАРОВ
TKOL:       equ  30
; КОЛ. ВООРУЖ. КОРАБЛЯ
WKKOL:      equ  33
; КОЛ. ВООРУЖ. СКИМЕРА
WSKOL:      equ  14
; КОЛ. ПУНКТОВ СЕТАПА СРЕДЫ
SSKOL:      equ  13
; КОЛ. ПУНКТОВ СЕТАПА ИГРЫ
SGKOL:      equ  43
; КОЛИЧЕСТВО ПЕРСОНАЖЕЙ ВОБЩЕ
PKOL:       equ  50
; КОЛИЧЕСТВО ПУНКТОВ МЕНЮ ХЕЛПА
HKOL:       equ  8
; КОЛИЧЕСТВО КОРАБЛЕЙ
SHKOL:      equ  6
; КОЛИЧЕСТВО СКИММЕРОВ
SKKOL:      equ  4
; КОЛИЧЕСТВО ВОПРОСОВ ОСНОВНЫХ
QKOL:       equ  20
; КОЛИЧЕСТВО МИССИЙ
MKOL:       equ  15
; КОЛИЧЕСТВО СОБЫТИЙ
HPKOL:      equ  7




AVAR:       equ  #6300
; КООРДИНАТЫ ОКНА ПРОСМОТРА ВО ВСЕЙ КАРТЕ
EYEX:       equ  AVAR
EYEY:       equ  EYEX+1
; КООРДИНАТЫ ПЕРВОЙ КАРТЫ ИЗ НАБОРА
; ЧЕТЫРЕХ ВО ВСЕЙ КАРТЕ
KCORD:      equ  EYEY+1
; ДЛИННА И ВЫСОТА ОКНА ВЫВОДА КАРТЫ В ПКС
BXKRT:      equ  KCORD+2
BYKRT:      equ  BXKRT+1
; НОМЕР СТРАНИЦЫ
NPG:        equ  BYKRT+1
; КООРДИНАТЫ КУРСОРА
Mcoord:     equ  NPG+1
; АДРЕС ЗВЕЗДЫ С КОТОРОЙ МОЖНО ПРОЛОЖИТЬ
; МАРШРУТ
AWAYS:      equ  Mcoord+2
TNAME:      equ  AWAYS+2            ;17
RNDD1:      equ  TNAME+17
RNDD2:      equ  RNDD1+2
Cord:       equ  RNDD2+2

_FREE:      equ  Cord+2


TBXX:       equ  #8200              ;#300
Tabob:      equ  TBXX+#0300         ;#100;#80 ELEM
Bscr:       equ  Tabob+#0100        ;#300
SZTB:       equ  Bscr+#0300         ;#100
Font:       equ  SZTB+#0100         ;#800+#200 TABX
DATAM:      equ  Font+#0A00         ;<>200
;LEN=#1200  БЕЗ DATAM



KURSA:      equ  #6000
KURSAM:     equ  KURSA+#0100
KURSAS:     equ  KURSAM+#0100


Visibil:    equ  #70
Detaliz:    equ  #1F
Xvisibi:    equ  #60


Px:         equ  #1A
Pz:         equ  #1E

Olen:       equ  #40

