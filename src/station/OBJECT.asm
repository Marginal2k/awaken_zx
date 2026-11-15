;==============================================================================
; OBJECT - таблица описателей объектов интерфейса (Objvec) и описатель среды Sur1
;
; Где живёт: основной образ STATIONF.C, после DATAT. 16-байтные записи: координаты, статус (%OOYFXMSN),
; номер имени, обработчик, позиция/размер по умолчанию, процедура вывода (формат: GAME_DESIGN 1.3).
; Sur1 - список адресов процедур вывода объектов текущей среды; SurroundOn/Off включают их.
;==============================================================================

; Статус байт объекта
; %Ooyfxmsn
; Оо-тип объекта:
;   00-Окно,01-кнопка,10-линия
; N-ОКНО
;  1-Линия с именем,0-без линии
; N-кнопка
;  0-Ненажата,1-нажата
; Y-ОКНО
;  1-Будет удалятся огнем по обоям
; Y-кнока
;  0-Сортируется вниз стола
; F-кнопка
;  1-Кнопка с фиксацией
; S-окно, кнопка
;  1-Не может менять размер
; M-окно, кнопка
;  1-Не может двигаться

; b,вположение X, Y
; b,вразмеры   sx,sy
; b  статус байт
; b  номер имени окна или кнопки
; W   адрес процедуры обработки
; b,встандартные координаты положения
; W   адрес процедуры вывода объекта
; W   резерв

;  Линия
            dw   0,0
            db   %10000000
            db   0                  ; NUM MESAG inLintxt
            dw   LINE
            dw   #1700,#011B
            dw   LINE_,0

;  Линия 2 часы
            dw   0,0
            db   %10000000
            db   0                  ; Num mesag inlintxt
            dw   LineWindow2
            dw   #171B,#0105
            dw   LINE2_,0


; Объекты стола, кнопки вызова приложений
            dw   0,0
            db   %01000000
            db   0                  ; NUM MESAG inButtxt
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


; Объекты приложений


;  Просто информационное окна о
;  Ошибках и т.д
            dw   0,0
            db   %00100001
            db   20
            dw   WERR
            dw   #0507,#0812
            dw   WERR_,0


;  Приложение карта
;  Карта
            dw   0,0
            db   %00000001
            db   3
            dw   WMAP
            dw   #000B,#0F15
            dw   WMAP_,0
;  Память
            dw   0,0
            db   %01100000
            db   14
            dw   BMEM
            dw   #0F0B,#0205
            dw   BMEM_,0
;  Маршрут
            dw   0,0
            db   %01100000
            db   15
            dw   BMAR
            dw   #0F10,#0205
            dw   BMAR_,0
;  Очистить маршрут
            dw   0,0
            db   %01100000
            db   16
            dw   BCMAR
            dw   #1110,#0205
            dw   BCMAR_,0
;  Следуюшая звезда в памяти
            dw   0,0
            db   %01100000
            db   17
            dw   BNMEM
            dw   #110B,#0205
            dw   BNMEM_,0
;  Позиция маршрута
            dw   0,0
            db   %01100000
            db   18
            dw   BAWAY
            dw   #1310,#0205
            dw   BAWAY_,0
;  Центровка
            dw   0,0
            db   %01100000
            db   19
            dw   BCENT
            dw   #130B,#0205
            dw   BCENT_,0
;  След. абонент
            dw   0,0
            db   %01100000
            db   20
            dw   BNABO
            dw   #150B,#0205
            dw   BNABO_,0
;  Инфо о системе и свет. годах
            dw   0,0
            db   %00000001
            db   13
            dw   WINFS
            dw   #0000,#170B
            dw   WINFS_,0
;  Вращаются планеты
            dw   0,0
            db   %00000010
            db   14
            dw   WPLAN
            dw   #0F15,#0909
            dw   WPLAN_,0
; ????????????? Перелет на др. систему
            dw   0,0
            db   %01100000
            db   40
            dw   BPERE
            dw   #1510,#0205
            dw   BPERE_,0


;  Прилож.абоненты
            dw   0,0
            db   %00000001
            db   1                  ; NUM MESAG inWintxt
            dw   WABON
            dw   #0000,#0C0F
            dw   WABON_,0
;  Фото для абонента
            dw   0,0
            db   %00000010
            db   0
            dw   WFOTO
            dw   #0016,#0606
            dw   WFOTO_,0


;  Прил. помощь
;  Список пунктов помощи
            dw   0,0
            db   %00000001
            db   15
            dw   WHELPL
            dw   #0000,#0A0B
            dw   WHELPL_,0
;  Окно текста помощи
            dw   0,0
            db   %00000001
            db   16
            dw   WHELP
            dw   #000B,#1315
            dw   WHELP_,0


;  Прилож. новости
            dw   0,0
            db   %00000001
            db   2
            dw   WNEWS
            dw   #0308,#1010
            dw   WNEWS_,0


;  Прилож. корабль
;  Список кораблей
            dw   0,0
            db   %00000001
            db   17
            dw   WSHIP
            dw   #0000,#0A08
            dw   WSHIP_,0
;  Демо кораблей
            dw   0,0
            db   %00000001
            db   19
            dw   WDSHIP
            dw   #0015,#0C0B
            dw   WDSHIP_,0
;  Инфо кораблей
            dw   0,0
            db   %00000001
            db   18
            dw   WISHIP
            dw   #0008,#150D
            dw   WISHIP_,0
;  Продажа корабля кнопка
            dw   0,0
            db   %01110000
            db   10
            dw   BTSHIP
            dw   #0A00,#0205
            dw   BTSHIP_,0
;  Покупка корабля кнопка
            dw   0,0
            db   %01110001
            db   11
            dw   BBSHIP
            dw   #0C00,#0205
            dw   BBSHIP_,0
;  Сделка кнопка
            dw   0,0
            db   %01100000
            db   22
            dw   BSDEL
            dw   #0E00,#0205
            dw   BSDEL_,0


;  Прилож. миссии
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


;  Прилож.товары
;  Список товаров
            dw   0,0
            db   %00000001
            db   5
            dw   WTWR
            dw   #0000,#1319
            dw   WTWR_,0
;  Продать товар
            dw   0,0
            db   %01100000
            db   13
            dw   BTTW
            dw   #0019,#0305
            dw   BTTW_,0


;  Прилож. воружения
;  Продать
            dw   0,0
            db   %01110000
            db   10
            dw   BTRD
            dw   #001B,#0205
            dw   BTRD_,0
;  Купить
            dw   0,0
            db   %01110001
            db   11
            dw   BBUY
            dw   #021B,#0205
            dw   BBUY_,0
;  Вооруж. корабля
            dw   0,0
            db   %00000001
            db   6
            dw   WWKRB
            dw   #0000,#1019
            dw   WWKRB_,0
;  Вооруж. скимера
            dw   0,0
            db   %00000001
            db   7
            dw   WWSKM
            dw   #0000,#1019
            dw   WWSKM_,0
;  Инфо о вооруж.
            dw   0,0
            db   %00000001
            db   12
            dw   WINF
            dw   #1000,#0720
            dw   WINF_,0


;  Прилож. вспомог. окно
;  Всплывающее для сист. настроек
            dw   0,0
            db   %00100110
            db   0
            dw   WHIDE
CWHIDE      dw   #0208,#0909
            dw   WHIDE_,0
;  Установки среды
            dw   0,0
            db   %00000001
            db   10
            dw   WSETS
            dw   #0205,#0C0B
            dw   WSETS_,0
;  Установки игры
            dw   0,0
            db   %00000001
            db   11
            dw   WSETG
            dw   #0205,#0C11
            dw   WSETG_,0
;  Сохраниться
            dw   0,0
            db   %00100110
            db   0
            dw   WSOH
            dw   #0705,#0607
            dw   WSOH_,0
;  Восстановиться
            dw   0,0
            db   %00100110
            db   0
            dw   WWOS
            dw   #0710,#0607
            dw   WWOS_,0


;  Инфо о станции
            dw   0,0
            db   %00000011
            db   21
            dw   WWELCOME
            dw   #0606,#0714
            dw   WWELCOME_,0


            db   #80                ; END


Sur1
; Описатель среды, содержит шоу адреса
; Объектов, т.е. адреса процедур вывода
; Объекта
; Конец списка #0101
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
            dw   #0101              ; END
