
;WINDOWS

; СТАТУС БАЙТ ОБЪЕКТА
;%OOYFXMSN
;OO-ТИП ОБЪЕКТА:
;   00-ОКНО,01-КНОПКА,10-ЛИНИЯ
;N-ОКНО
;  1-ЛИНИЯ С ИМЕНЕМ,0-БЕЗ ЛИНИИ
;N-КНОПКА
;  0-НЕНАЖАТА,1-НАЖАТА
;Y-ОКНО
;  1-БУДЕТ УДАЛЯТСЯ ОГНЕМ ПО ОБОЯМ
;Y-КНОКА
;  0-СОРТИРУЕТСЯ ВНИЗ СТОЛА
;F-КНОПКА
;  1-КНОПКА С ФИКСАЦИЕЙ
;S-ОКНО, КНОПКА
;  1-НЕ МОЖЕТ МЕНЯТЬ РАЗМЕР
;m-ОКНО, КНОПКА
;  1-НЕ МОЖЕТ ДВИГАТЬСЯ

; b,bПОЛОЖЕНИЕ X, Y
; b,bРАЗМЕРЫ   SX,SY
; b  СТАТУС БАЙТ
; b  НОМЕР ИМЕНИ ОКНА ИЛИ КНОПКИ
; W   АДРЕС ПРОЦЕДУРЫ ОБРАБОТКИ
; b,bСТАНДАРТНЫЕ КООРДИНАТЫ ПОЛОЖЕНИЯ
; W   АДРЕС ПРОЦЕДУРЫ ВЫВОДА ОБЪЕКТА
; W   РЕЗЕРВ

;  ЛИНИЯ
            dw   0,0
            db   %10000000
            db   0                  ;NUM MESAG inLintxt
            dw   LINE
            dw   #1700,#011B
            dw   LINE_,0

;  ЛИНИЯ 2 ЧАСЫ
            dw   0,0
            db   %10000000
            db   0                  ;NUM MESAG inLINTXT
            dw   LINE2
            dw   #171B,#0105
            dw   LINE2_,0







; ОБЪЕКТЫ СТОЛА, КНОПКИ ВЫЗОВА ПРИЛОЖЕНИЙ
            dw   0,0
            db   %01000000
            db   0                  ;NUM MESAG inButtxt
            dw   BABON
            dw   #130A,#0205
            dw   BABON_,0

            dw   0,0
            db   %01000000
            db   1
            dw   BNEWS
            dw   #130F,#0205
            dw   BNEWS_,0

            dw   0,0
            db   %01000000
            db   2
            dw   BMAP
            dw   #1302,#0204
            dw   BMAP_,0

            dw   0,0
            db   %01000000
            db   3
            dw   BMISS
            dw   #1505,#0205
            dw   BMISS_,0

            dw   0,0
            db   %01000000
            db   4
            dw   BTWR
            dw   #1306,#0204
            dw   BTWR_,0

            dw   0,0
            db   %01000000
            db   5
            dw   BWKRB
            dw   #1414,#0306
            dw   BWKRB_,0

            dw   0,0
            db   %01000000
            db   6
            dw   BWSKM
            dw   #141A,#0306
            dw   BWSKM_,0

            dw   0,0
            db   %01000000
            db   7
            dw   BKRB
            dw   #150A,#0205
            dw   BKRB_,0

            dw   0,0
            db   %01000000
            db   8
            dw   BSKM
            dw   #150F,#0205
            dw   BSKM_,0

            dw   0,0
            db   %01000000
            db   9
            dw   BEXIT
            dw   #1501,#0204
            dw   BEXIT_,0

            dw   0,0
            db   %01000000
            db   21
            dw   BHELP
            dw   #1300,#0202
            dw   BHELP_,0









; ОБЪЕКТЫ ПРИЛОЖЕНИЙ




;  ПРОСТО ИНФОРМАЦИОННОЕ ОКНА О
;  ОШИБКАХ И Т.Д
            dw   0,0
            db   %00100001
            db   20
            dw   WERR
            dw   #0507,#0812
            dw   WERR_,0













;  ПРИЛОЖЕНИЕ КАРТА
;  КАРТА
            dw   0,0
            db   %00000001
            db   3
            dw   WMAP
            dw   #000B,#0F15
            dw   WMAP_,0
;  ПАМЯТЬ
            dw   0,0
            db   %01100000
            db   14
            dw   BMEM
            dw   #0F0B,#0205
            dw   BMEM_,0
;  МАРШРУТ
            dw   0,0
            db   %01100000
            db   15
            dw   BMAR
            dw   #0F10,#0205
            dw   BMAR_,0
;  ОЧИСТИТЬ МАРШРУТ
            dw   0,0
            db   %01100000
            db   16
            dw   BCMAR
            dw   #1110,#0205
            dw   BCMAR_,0
;  СЛЕДУЮШАЯ ЗВЕЗДА В ПАМЯТИ
            dw   0,0
            db   %01100000
            db   17
            dw   BNMEM
            dw   #110B,#0205
            dw   BNMEM_,0
;  ПОЗИЦИЯ МАРШРУТА
            dw   0,0
            db   %01100000
            db   18
            dw   BAWAY
            dw   #1310,#0205
            dw   BAWAY_,0
;  ЦЕНТРОВКА
            dw   0,0
            db   %01100000
            db   19
            dw   BCENT
            dw   #130B,#0205
            dw   BCENT_,0
;  СЛЕД. АБОНЕНТ
            dw   0,0
            db   %01100000
            db   20
            dw   BNABO
            dw   #150B,#0205
            dw   BNABO_,0
;  ИНФО О СИСТЕМЕ И СВЕТ. ГОДАХ
            dw   0,0
            db   %00000001
            db   13
            dw   WINFS
            dw   #0000,#170B
            dw   WINFS_,0
;  ВРАЩАЮТСЯ ПЛАНЕТЫ
            dw   0,0
            db   %00000010
            db   14
            dw   WPLAN
            dw   #0F15,#0909
            dw   WPLAN_,0
;????????????? ПЕРЕЛЕТ НА ДР. СИСТЕМУ
            dw   0,0
            db   %01100000
            db   40
            dw   BPERE
            dw   #1510,#0205
            dw   BPERE_,0














;  ПРИЛОЖ.АБОНЕНТЫ
            dw   0,0
            db   %00000001
            db   1                  ;NUM MESAG inWintxt
            dw   WABON
            dw   #0000,#0C0F
            dw   WABON_,0
;  ФОТО ДЛЯ АБОНЕНТА
            dw   0,0
            db   %00000010
            db   0
            dw   WFOTO
            dw   #0016,#0606
            dw   WFOTO_,0












;  ПРИЛ. ПОМОЩЬ
;  СПИСОК ПУНКТОВ ПОМОЩИ
            dw   0,0
            db   %00000001
            db   15
            dw   WHELPL
            dw   #0000,#0A0B
            dw   WHELPL_,0
;  ОКНО ТЕКСТА ПОМОЩИ
            dw   0,0
            db   %00000001
            db   16
            dw   WHELP
            dw   #000B,#1315
            dw   WHELP_,0













;  ПРИЛОЖ. НОВОСТИ
            dw   0,0
            db   %00000001
            db   2
            dw   WNEWS
            dw   #0308,#1010
            dw   WNEWS_,0













;  ПРИЛОЖ. КОРАБЛЬ
;  СПИСОК КОРАБЛЕЙ
            dw   0,0
            db   %00000001
            db   17
            dw   WSHIP
            dw   #0000,#0A08
            dw   WSHIP_,0
;  ДЕМО КОРАБЛЕЙ
            dw   0,0
            db   %00000001
            db   19
            dw   WDSHIP
            dw   #0015,#0C0B
            dw   WDSHIP_,0
;  ИНФО КОРАБЛЕЙ
            dw   0,0
            db   %00000001
            db   18
            dw   WISHIP
            dw   #0008,#150D
            dw   WISHIP_,0
;  ПРОДАЖА КОРАБЛЯ КНОПКА
            dw   0,0
            db   %01110000
            db   10
            dw   BTSHIP
            dw   #0A00,#0205
            dw   BTSHIP_,0
;  ПОКУПКА КОРАБЛЯ КНОПКА
            dw   0,0
            db   %01110001
            db   11
            dw   BBSHIP
            dw   #0C00,#0205
            dw   BBSHIP_,0
;  СДЕЛКА КНОПКА
            dw   0,0
            db   %01100000
            db   22
            dw   BSDEL
            dw   #0E00,#0205
            dw   BSDEL_,0














;  ПРИЛОЖ. МИССИИ
            dw   0,0
            db   %00000001
            db   4
            dw   WMISS1
            dw   #0A06,#070B
            dw   WMISS1_,0

            dw   0,0
            db   %00000001
            db   4
            dw   WMISS2
            dw   #1006,#070E
            dw   WMISS2_,0











;  ПРИЛОЖ.ТОВАРЫ
;  СПИСОК ТОВАРОВ
            dw   0,0
            db   %00000001
            db   5
            dw   WTWR
            dw   #0000,#1319
            dw   WTWR_,0
;  ПРОДАТЬ ТОВАР
            dw   0,0
            db   %01100000
            db   13
            dw   BTTW
            dw   #0019,#0305
            dw   BTTW_,0










;  ПРИЛОЖ. ВОРУЖЕНИЯ
;  ПРОДАТЬ
            dw   0,0
            db   %01110000
            db   10
            dw   BTRD
            dw   #001B,#0205
            dw   BTRD_,0
;  КУПИТЬ
            dw   0,0
            db   %01110001
            db   11
            dw   BBUY
            dw   #021B,#0205
            dw   BBUY_,0
;  ВООРУЖ. КОРАБЛЯ
            dw   0,0
            db   %00000001
            db   6
            dw   WWKRB
            dw   #0000,#1019
            dw   WWKRB_,0
;  ВООРУЖ. СКИМЕРА
            dw   0,0
            db   %00000001
            db   7
            dw   WWSKM
            dw   #0000,#1019
            dw   WWSKM_,0
;  ИНФО О ВООРУЖ.
            dw   0,0
            db   %00000001
            db   12
            dw   WINF
            dw   #1000,#0720
            dw   WINF_,0









;  ПРИЛОЖ. ВСПОМОГ. ОКНО
;  ВСПЛЫВАЮЩЕЕ ДЛЯ СИСТ. НАСТРОЕК
            dw   0,0
            db   %00100110
            db   0
            dw   WHIDE
CWHIDE:     dw   #0208,#0909
            dw   WHIDE_,0
;  УСТАНОВКИ СРЕДЫ
            dw   0,0
            db   %00000001
            db   10
            dw   WSETS
            dw   #0205,#0C0B
            dw   WSETS_,0
;  УСТАНОВКИ ИГРЫ
            dw   0,0
            db   %00000001
            db   11
            dw   WSETG
            dw   #0205,#0C11
            dw   WSETG_,0
;  СОХРАНИТЬСЯ
            dw   0,0
            db   %00100110
            db   0
            dw   WSOH
            dw   #0705,#0607
            dw   WSOH_,0
;  ВОССТАНОВИТЬСЯ
            dw   0,0
            db   %00100110
            db   0
            dw   WWOS
            dw   #0710,#0607
            dw   WWOS_,0




;  ИНФО О СТАНЦИИ
            dw   0,0
            db   %00000011
            db   21
            dw   WWELCOME
            dw   #0606,#0714
            dw   WWELCOME_,0


            db   #80                ;END





Sur1:
; ОПИСАТЕЛЬ СРЕДЫ, СОДЕРЖИТ ШОУ АДРЕСА
; ОБЪЕКТОВ, Т.Е. АДРЕСА ПРОЦЕДУР ВЫВОДА
; ОБЪЕКТА
; КОНЕЦ СПИСКА #0101
            dw   LINE_
            dw   BABON_
            dw   BNEWS_
            dw   BMAP_
            dw   BMISS_
            dw   BTWR_
            dw   BWKRB_
            dw   BWSKM_
            dw   BKRB_
            dw   BSKM_
            dw   BEXIT_
            dw   BHELP_
            dw   WWELCOME_
            dw   #0101              ;END


