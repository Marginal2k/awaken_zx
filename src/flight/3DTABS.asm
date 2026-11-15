;#8C00
L90:
L91:        equ  L90+#100
            incbin "D9000.d"


L9C:        equ  high($)
            ds   #100

L9D:        equ  high($)
            ds   #100

L9E:        equ  high($)
            ds   #100


; Таблица логарифмов
TBLOG2:
            ds   #200


; Таблица квадратов
TB2X:
            ds   #100


TBXY:
            ds   #400


; Таблица умножения
MULTB:      equ  high($)

; Таблица синуса
SINTB:      equ  MULTB+1
            incbin "D9200.d"

; Таблица арктангенсов
ATAGTAB:
            incbin "ATAGTAB.d"


; Внутренние переменные

LA11:       dw   #7FFF
LA12:       dw   0
LB13:       dw   0
LA21:       dw   0
LA22:       dw   #7FFF
LB23:       dw   0
LA31:       dw   0
LA32:       dw   0
LB33:       dw   #7FFF
EYEA:       db   0
EYEB:       db   0
EYEG:       db   0
RNDD1:      dw   0
RNDD2:      dw   0


; Координаты прицела
PCORD:      dw   #2B77
ROKETN1:    db   #FF
ROKETN2:    db   #FF
ROKETN3:    db   #FF

SUNX:       db   0,0,0
SUNY:       db   0,0,0
SUNZ:       db   0,0,0

PLANETES:
            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#02,#00

            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#00,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF
            db   #00,#00,#80,#FF

            db   #00,#00,#80,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#80,#FF
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF

SNX:        db   0
            dw   #0000
SNY:        db   0
            dw   #0000
SNZ:        db   0
            dw   #E080
SSX:        db   0
            dw   #0000
SSY:        db   0
            dw   #0000
SSZ:        db   #FF
            dw   (-LAUNGH)-1

NOSUN:      db   0
NOSTAT:     db   0
STATGEN:    db   0

TTY:        db   0
TTX:        db   0
TTZ:        db   0
ETX:        db   0
ETY:        db   0
ETZ:        db   0
STX:        db   0
STY:        db   0
STZ:        db   0

SETS:       db   0
INDX:       db   0
OBJX:       dw   0
OBJY:       dw   0
OBJZ:       dw   0
EYE_A:      db   0
EYE_B:      db   0
EYE_G:      db   0
EYE_X:      dw   0
EYE_Y:      dw   0
EYE_Z:      dw   0
STPA:       db   0
STPB:       db   0
STPG:       db   0

INDT1:      db   0
INDT2:      db   0

LOW_CORDS_BUF: db   0


PLANDICTAT: ds   16
; Данные состояния вероятностей и частот
; различных действий

; Мощность лазера игрока
; мощность лазера противника по игроку
; мощность лазера противника по объекту
; скорость регенерации защиты игрока
; скорострельность лазера игрока
; скорость регенерации лазера игрока
; вероятность появления кораблей в общем
; вероятность нападения пирата на мирного
; вероятность нападения пирата на игрока
; вероятность попадания пирата в игрока
; вероятность нападения полиции на пирата
; вероятность появления рейда
; средний уровень энергии кораблей
; максимальный уровень энергии кораблей
; средняя скорострельность кораблей


;Вероятности появления
WERPO:      ds   9
; Пираты
; мирные
; полиция
; военные
; легионеры
; пират2
; уфо
; уфо2
; отшельник


; Данные о времени
TIME:       dw   #0122              ;День
            db   #10,#10            ;Часы,минуты

; Данные о текущей системе на которой
; находишся
PLACE:      dw   #4B38              ;Коорд. карты
            dw   #4AF4              ;Коорд. в карте
;            dw   #4AF3;коорд. в карте

; Данные о текущей планете на которой
; находишся, номер планеты снизу вверх
PLANET:     db   0

; Данные о системе на которую гипер
; прыжок настроен
WHERE:      dw   #4B38              ;Карты
            dw   #4AF4              ;Коорд. в карте
;            dw   #4AF3;в карте

; Данные о планете на которую будеш дел-
; Ать перелет, номер ...
WPLANET:    db   2

; Номер модели корабля
SHIP:       db   0

; Номер модели скиммера, если его нет #FF
SKIMMER:    db   #FF

; Статус
STATUS:     db   0

; Сумма в кредах
SUMM:       dw   65000

; Масса всего в тоннах и тоннаж корабля
TONN:       db   0,40

TWRI:
; Описание товаров по порядку,кол/цена
; за которую купил
            db   1,0                ;Текстиль
            db   2,0                ;С/Х Продукты
            db   3,0                ;С/Х Техника
            db   4,0                ;Стройматериялы
            db   5,0                ;Стройтехника
            db   1,0                ;Вода
            db   1,0                ;Спиртное
            db   1,0                ;Пиво
            db   1,0                ;Табак
            db   1,0                ;Медикаменты
            db   1,0                ;Оборудование
            db   1,0                ;Электроника
            db   1,0                ;Компьютеры
            db   1,0                ;Энергоностители
            db   1,0                ;Минералы
            db   0,0                ;Радиактивные руды
            db   0,0                ;Черн.металлы
            db   0,0                ;Цвет.металлы
            db   0,0                ;Драг.металлы
            db   0,0                ;Драг.камни
            db   0,0                ;Предметы роскоши
            db   0,0                ;легкое Вооружение
            db   0,0                ;тяжолое Вооружение
            db   0,0                ;Наркотики
            db   0,0                ;Рабы
            db   0,0                ;Проститутки
            db   0,0                ;Уникумы
            db   0,0                ;Трансплонтанты
            db   0,0                ;Технологии
            db   0,0                ;Артефакты

WKRBI:
; Описание купленного вооружения попорядк
;0-nop,MAY BE 0-100
;#FF-NOP,MAY BE #FF,#FE-YEP
FUEL:
            db   0                  ;Топл 'Космонефть'
            db   20                 ;Топл 'Рубин'
ROKS:
            db   100                ;Ракет РЛН-1
            db   0                  ;Ракет РЛН-2
MINA:
            db   10                 ;Мина МХ-1
LAZER:
            db   #FF                ;Лаз 'Град'
            db   #FF                ;Лаз 'Шторм-1'
            db   #FF                ;Лаз 'Шторм-2'
            db   #FF                ;Лаз 'Смерть-1'
            db   #FF                ;Лаз 'Смерть-2'
PROTR1:
            db   #FE                ;Протракет.Сис ПС-1
PROTR2:
            db   #FF                ;Протракет.Сис ПС-2
DEF:
            db   #FF                ;С.Защ 'Крепость'
            db   #FF                ;С.Защ 'Оборона-1'
            db   #FF                ;С.Защ 'Оборона-2'
FORSG:
            db   #FF                ;Форсаж Движок 'Фотон'
            db   #FF                ;Форсаж Движок 'Протон'
REMDR1:
            db   #FF                ;Ремонт Дроид РД-1
REMDR2:
            db   #FF                ;Ремонт Дроид РД-2
REMDR3:
            db   #FF                ;Ремонт Дроид РД-3
SSILUC:
            db   #FE                ;Сист 'Силовой луч'
SNAWEDEN:
            db   #FE                ;Сист НАВЕДЕНИЯ
SGIPSL:
            db   #FF                ;Сист 'Гиперслед'
SWOZWR:
            db   #FF                ;Сист Возврата
SSWPOL:
            db   #FE                ;Сист.Свободного Полета
SZAPRAW:
            db   #FF                ;С заправки
SRASPOZN:
            db   #FF                ;С распознавания
IDENTC:
            db   #FE                ;Идентификатор Целей
MARSHRUT:
            db   #FF                ;Маршрутизатор
KRIOGEN:
            db   #FF                ;Криогенная Установка
POSADMOD:
            db   #FF                ;Посадочный Модуль
KIBERKIL:
            db   #FF                ;Кибер Киллер ККР-0562
GDIABLO:
            db   #FE                ;Гипер Сист 'Дьявол'
            db   #80

WSKMI:
; Для скимера
; описание купленного вооружения по поряд
;0-NOP,MAY BE 0-200
;#FF-NOP,MAY BE #FF,#FE-YEP
            db   0                  ;Топл 'Бензол'
            db   0                  ;Ракет СРК-1
            db   0                  ;Ракет СРК-2
            db   #FF                ;Лаз 'Силовой'
            db   #FF                ;Лаз 'Ураган-1'
            db   #FF                ;Лаз 'Ураган-2'
            db   #FF                ;С Защ 'Броня-1'
            db   #FF                ;С Защ 'Броня-2'
            db   #FF                ;Прыжк. Движок 'Даль-1'
            db   #FF                ;Прыжк. Движок 'Даль-2'
            db   #FF                ;Протракет Сист
            db   #FF                ;Стыковочный Узел
            db   #FF                ;Ходовой Модуль
            db   #FF                ;Бомба БР-0910
            db   #80

; Состояние новостей
; сообщение (номер),
; время (час) до кот. держиться
; данные о системе и номер планеты
; где что.
; Состояние новотей
;0-нет,1..-состояние
NEWS:       db   1,0
            dw   0,0
            db   0

ORDER:
            db   #FF
            ds   15
            db   #FF
            ds   15
            db   #FF
            ds   15
            db   #FF
            ds   15
; Данные о мисси по доставке
; данные куда доставить(2W)
; данные времени (2W) к скольки доставить
; данные врем. (2W) во сколько сгенерили
; деньги (W)
; вес (B),если бит 7=1,то мисия взята
; и отказу не подлежит
; номер планеты (B)
; если первый байт = #FF то нет ордера

SPEED:
; Скорость купленного корабля,скимера
            db   100,100

; Дальность последней выбранной звезды
DALNO:      dw   0

; Буфер координат карты и в карте для
; запомненных звезд
MSTARS:     ds   50,#FF
            db   #80

; Буфер звезд маршрута
WAY:        ds   50,#FF
            db   #80

; Маска описатель линии, 0-3 биты
; количество узлов, далее номера узлов
; кратные 5 начиная с 0
WAYMASK:    db   %00100010
            ds   10

; Звезды где живут персонажи
PSTARS:
            dw   #4B39,#0006
            ds   PKOL*4-4

; Описание людей с которыми возможно или
; не возможно вести переговоры
; состояние 0-недоступен 1-доступен

ABONS:
            db   1
            ds   PKOL-1,0
            db   #80                ;END


SETSD:
; Данные о установках среды в портах
; и масках
; порт, маска;
; или просто число (0-126), пусто
; или #80/#81="N"/"Y",пусто
MOUSE:      db   #81,#00
JOYSTIK:    db   #80,#00
MUSIC:      db   #81,#00
INVERSE:    db   #80,#00
KUP:        db   #FB,#01
KDOWN:      db   #FD,#01
KLEFT:      db   #DF,#02
KRIGHT:     db   #DF,#01
KFIRE:      db   #7F,#01
KCANCEL:    db   #7F,#04
INK:        db   #00,#00
PAPER:      db   #05,#00
BRIGHT:     db   #00,#00

SETGD:
; Данные о установках игры в портах
; и масках
            db   #81,#00
            db   #FD,#02
            db   #FE,#04
            db   #BF,#04
            db   #BF,#02
            db   #7F,#08
            db   #7F,#04
            db   #FD,#01
            db   #7F,#01
            db   #7F,#02
            db   #DF,#01
            db   #BF,#10
            db   #FE,#08
            db   #F7,#01
            db   #F7,#02
            db   #F7,#04
            db   #BF,#08
            db   #FD,#08
            db   #FE,#02
            db   #FB,#08
            db   #7F,#10
            db   #FB,#01
            db   #FB,#02
            db   #FB,#04
            db   #FD,#10
            db   #FD,#04
            db   #FE,#10
; Для скиммера
            db   #FD,#02
            db   #FE,#04
            db   #BF,#04
            db   #BF,#02
            db   #FD,#01
            db   #7F,#01
            db   #7F,#02
            db   #DF,#01
            db   #BF,#10
            db   #FE,#08
            db   #F7,#01
            db   #BF,#08
            db   #FB,#01
            db   #FD,#04
            db   #7F,#10


; ────────────────────────────────────────

            ADRXX00
; Индексная таблица объектов
; содержит адреса объектов
; недетализированных и детализированных
; и придает индексы в порядке возрстания
L97:        equ  high($)

; Полиция в космосе
IPOL1:      equ  low($)
            dw   KN01pol1
            dw   Kd1
IPOL2:      equ  low($)
            dw   KN06pol2
            dw   Kd6
IPOL3:      equ  low($)
            dw   KN29pol6
            dw   Kd29
IPOL4:      equ  low($)
            dw   KN27pol7
            dw   Kd27

; Полиция из станции
IPLS1:      equ  low($)
            dw   KN21plS3
            dw   Kd21
IPLS2:      equ  low($)
            dw   KN25plS4
            dw   Kd25
IPLS3:      equ  low($)
            dw   KN28plS5
            dw   Kd28

; Военные
IMLT1:      equ  low($)
            dw   KN02mlt1
            dw   Kd2
IMLT2:      equ  low($)
            dw   KN09mlt2
            dw   Kd9
IMLT3:      equ  low($)
            dw   KN17mlt3
            dw   Kd17
IMLT4:      equ  low($)
            dw   KN26mlt4
            dw   Kd26

; Грузовые
IGRZ1:      equ  low($)
            dw   KN03grz1
            dw   Kd3
IGRZ2:      equ  low($)
            dw   KN08grz2
            dw   Kd8
IGRZ3:      equ  low($)
            dw   KN11grz3
            dw   Kd11
IGRZ4:      equ  low($)
            dw   KN30grz4
            dw   Kd30
IGRZ5:      equ  low($)
            dw   KN31grz5
            dw   Kd31

; Торговые, продаваемые на станции
ITRG1:      equ  low($)
            dw   KN04trg1
            dw   Kd4
ITRG2:      equ  low($)
            dw   KN05trg2
            dw   Kd5
ITRG3:      equ  low($)
            dw   KN10trg3
            dw   Kd10
ITRG4:      equ  low($)
            dw   KN16trg4
            dw   Kd16
ITRG5:      equ  low($)
            dw   KOBRA
            dw   KOBRAD
ITRG6:      equ  low($)
            dw   KRYL
            dw   KRYLD

; Уфо
IUFO1:      equ  low($)
            dw   KN13ufo2
            dw   Kd13
IUFO2:      equ  low($)
            dw   KN14ufo3
            dw   Kd14
IUFO3:      equ  low($)
            dw   KN18UFo4
            dw   Kd18
IUFO4:      equ  low($)
            dw   KN20ufo5
            dw   Kd20
IUFO5:      equ  low($)
            dw   KN23ufo6
            dw   Kd23
IUFO6:      equ  low($)
            dw   KN24ufo7
            dw   Kd24
IUFO7:      equ  low($)
            dw   UFO1D
            dw   UFO1
IUFO8:      equ  low($)
            dw   Kd12
            dw   Kd12

; Крейсера
IKRS1:      equ  low($)
            dw   KN07krs1
            dw   Kd7
IKRS2:      equ  low($)
            dw   Kd15
            dw   Kd15
IKRS3:      equ  low($)
            dw   Kd19
            dw   Kd19
IKRS4:      equ  low($)
            dw   Kd22
            dw   Kd22

; Микро кораблики
; вылетают из других
IMIK1:      equ  low($)
            dw   micKN
            dw   micKd1
IMIK2:      equ  low($)
            dw   micKN
            dw   micKd2

; Ракеты
IROK:       equ  low($)
            dw   ROKET
            dw   ROKET
IROKUFO:    equ  low($)
            dw   UfoRD
            dw   UfoRD

; Контейнеры
ICRG:       equ  low($)
            dw   CRG1
            dw   CRG1
ICRGUFO:    equ  low($)
            dw   KontUFO
            dw   KontUFO

; Киберкилеры
IKIB:       equ  low($)
            dw   Kib_K
            dw   Kib_K
IKIBUFO:    equ  low($)
            dw   ufo_K
            dw   ufo_K

; Ремдроид
IREMDR:     equ  low($)
            dw   REM_DR
            dw   REM_DR
; Астероид
IASTER1:    equ  low($)
            dw   ASTER1
            dw   ASTER1
IASTER2:    equ  low($)
            dw   ASTER2
            dw   ASTER2
IASTER3:    equ  low($)
            dw   ASTER3
            dw   ASTER3
; Осколок
IOSKOL:     equ  low($)
            dw   OSKOL
            dw   OSKOL
; Мнимая цель
ITARGET:    equ  low($)
            dw   TARGET
            dw   TARGET
; Мусор при форсаже
ITRASH:     equ  low($)
            dw   TRASH
            dw   TRASH

; Станции

IST1:       equ  low($)
            dw   St1
            dw   St1
IST2:       equ  low($)
            dw   St2
            dw   St2
IST3:       equ  low($)
            dw   St3
            dw   St3
IST4:       equ  low($)
            dw   St4
            dw   St4
IST5:       equ  low($)
            dw   St5
            dw   St5
IST6:       equ  low($)
            dw   St6
            dw   St6
IST7:       equ  low($)
            dw   St7
            dw   St7
IST8:       equ  low($)
            dw   St8
            dw   St8
IST9:       equ  low($)
            dw   St9
            dw   St9
IST10:      equ  low($)
            dw   St10
            dw   St10
IST11:      equ  low($)
            dw   St11
            dw   St11
IST12:      equ  low($)
            dw   St12
            dw   St12
IST13:      equ  low($)
            dw   St13
            dw   St13
IST14:      equ  low($)
            dw   St14
            dw   St14
IST15:      equ  low($)
            dw   St15
            dw   St15
IST16:      equ  low($)
            dw   St16
            dw   St16
IST_PIRAT:  equ  low($)
            dw   St_pirat
            dw   St_pirat
IPRISON:    equ  low($)
            dw   Prison
            dw   Prison
IST_U1:     equ  low($)
            dw   St_u1
            dw   St_u1
IST_U2:     equ  low($)
            dw   St_u2
            dw   St_u2
IST_SCINCE: equ  low($)
            dw   St_scince
            dw   St_scince
IGIP_PL:    equ  low($)
            dw   Gip_pl
            dw   Gip_pl


; ────────────────────────────────────────


; Буфер 3D объекта
OBJBUF:     ds   #100


CARGS:
; Буфер на 10 грузов
            ds   #0A,#FFFF
            db   #FE


            ADRXX00
; Буфер описатель положения и состояния
; объектов в космосе, на 25 объектовм !
CARSB:
            rept 25
            dw   #8000
            ds   OLEN-2
            endr
            dw   #8080
            ds   OLEN-2


; Буфер описатель игрока
PLAYER:
            dw   0
            dw   0
            dw   0
            db   0
; Углы
            db   0,0,0
            db   #FF                ;MARK OF PLAYER
            db   0
ACTION:     db   0
            dw   0
Speed:      db   20
            db   0
            db   0
            db   #FF                ;TYPE
            db   0
SHILD:      db   46


; Буфер данных вокснимаций не более чем
; на 8 анимаций одновременно !
VOXCOR:
            ds   18*8+7,0
            db   #FF
; Координаты X,Y,z(W)
; коэфициент масштабирования (B)
; время жизни (B)
; текущий адрес спрйта (W)
; начальный адрес анимации (W)
; текущий номер кадра (B)
; количество кадров (B)
; длинна спрайта в байтах (W)
