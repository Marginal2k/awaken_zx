
■#8C00
L90:
L91:        equ  L90+#100
            insert "D9000.dat"


L9C:        equ  $.h
            ds   #100

L9D:        equ  $.h
            ds   #100

L9E:        equ  $.h
            ds   #100


ТАБЛИЦА ЛОГАРИФМОВ
TBLOG2:
            ds   #200


ТАБЛИЦА КВАДРАТОВ
TB2X:
            ds   #100


TBXY:
            ds   #400


ТАБЛИЦА УМНОЖЕНИЯ
MULTB:      equ  $.h

ТАБЛИЦА СИНУСА
SINTB:      equ  MULTB+1
            insert "D9200.dat"

ТАБЛИЦА АРКТАНГЕНСОВ
ATAGTAB:
            insert "ATAGTAB.dat"




ВНУТРЕННИЕ ПЕРЕМЕННЫЕ

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


КООРДИНАТЫ ПРИЦЕЛА
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

SNX:        db   0:dw #0000
SNY:        db   0:dw #0000
SNZ:        db   0:dw #E080
SSX:        db   0:dw #0000
SSY:        db   0:dw #0000
SSZ:        db   #FF:dw -LAUNGH-1

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

LOW_CORDS_BUF:    db 0



PLANDICTAT: ds   16
ДАННЫЕ СОСТОЯНИЯ ВЕРОЯТНОСТЕЙ И ЧАСТОТ
РАЗЛИЧНЫХ ДЕЙСТВИЙ

МОЩНОСТЬ ЛАЗЕРА ИГРОКА
МОЩНОСТЬ ЛАЗЕРА ПРОТИВНИКА ПО ИГРОКУ
МОЩНОСТЬ ЛАЗЕРА ПРОТИВНИКА ПО ОБЪЕКТУ
СКОРОСТЬ РЕГЕНЕРАЦИИ ЗАЩИТЫ ИГРОКА
СКОРОСТРЕЛЬНОСТЬ ЛАЗЕРА ИГРОКА
СКОРОСТЬ РЕГЕНЕРАЦИИ ЛАЗЕРА ИГРОКА
ВЕРОЯТНОСТЬ ПОЯВЛЕНИЯ КОРАБЛЕЙ В ОБЩЕМ
ВЕРОЯТНОСТЬ НАПАДЕНИЯ ПИРАТА НА МИРНОГО
ВЕРОЯТНОСТЬ НАПАДЕНИЯ ПИРАТА НА ИГРОКА
ВЕРОЯТНОСТЬ ПОПАДАНИЯ ПИРАТА В ИГРОКА
ВЕРОЯТНОСТЬ НАПАДЕНИЯ ПОЛИЦИИ НА ПИРАТА
ВЕРОЯТНОСТЬ ПОЯВЛЕНИЯ РЕЙДА
СРЕДНИЙ УРОВЕНЬ ЭНЕРГИИ КОРАБЛЕЙ
МАКСИМАЛЬНЫЙ УРОВЕНЬ ЭНЕРГИИ КОРАБЛЕЙ
СРЕДНЯЯ СКОРОСТРЕЛЬНОСТЬ КОРАБЛЕЙ





■ВЕРОЯТНОСТИ ПОЯВЛЕНИЯ
WERPO:      ds   9
ПИРАТЫ
МИРНЫЕ
ПОЛИЦИЯ
ВОЕННЫЕ
ЛЕГИОНЕРЫ
ПИРАТ2
УФО
УФО2
ОТШЕЛЬНИК




ДАННЫЕ О ВРЕМЕНИ
TIME:       dw   #0122;ДЕНЬ
            db   #10,#10;ЧАСЫ,МИНУТЫ

ДАННЫЕ О ТЕКУЩЕЙ СИСТЕМЕ НА КОТОРОЙ
НАХОДИШСЯ
PLACE:      dw   #4B38;КООРД. КАРТЫ
            dw   #4AF4;КООРД. В КАРТЕ
;            dw   #4AF3;КООРД. В КАРТЕ

ДАННЫЕ О ТЕКУЩЕЙ ПЛАНЕТЕ НА КОТОРОЙ
НАХОДИШСЯ, НОМЕР ПЛАНЕТЫ СНИЗУ ВВЕРХ
PLANET:     db   0

ДАННЫЕ О СИСТЕМЕ НА КОТОРУЮ ГИПЕР
ПРЫЖОК НАСТРОЕН
WHERE:      dw   #4B38;КАРТЫ
            dw   #4AF4;КООРД. В КАРТЕ
;            dw   #4AF3;В КАРТЕ

ДАННЫЕ О ПЛАНЕТЕ НА КОТОРУЮ БУДЕШ ДЕЛ-
АТЬ ПЕРЕЛЕТ, НОМЕР ...
WPLANET:    db   2

НОМЕР МОДЕЛИ КОРАБЛЯ
SHIP:       db   0

НОМЕР МОДЕЛИ СКИММЕРА, ЕСЛИ ЕГО НЕТ #FF
SKIMMER:    db   #FF

СТАТУС
STATUS:     db   0

СУММА В КРЕДАХ
SUMM:       dw   65000

МАССА ВСЕГО В ТОННАХ И ТОННАЖ КОРАБЛЯ
TONN:       db   0,40

TWRI:
ОПИСАНИЕ ТОВАРОВ ПО ПОРЯДКУ,КОЛ/ЦЕНА
ЗА КОТОРУЮ КУПИЛ
            db   1,0;ТЕКСТИЛЬ
            db   2,0;С/Х Продукты
            db   3,0;С/Х Техника
            db   4,0;Стройматериялы
            db   5,0;Стройтехника
            db   1,0;Вода
            db   1,0;Спиртное
            db   1,0;Пиво
            db   1,0;Табак
            db   1,0;Медикаменты
            db   1,0;Оборудование
            db   1,0;Электроника
            db   1,0;Компьютеры
            db   1,0;Энергоностители
            db   1,0;Минералы
            db   0,0;РАДИАКТИВНЫЕ РУДЫ
            db   0,0;Черн.металлы
            db   0,0;Цвет.металлы
            db   0,0;Драг.металлы
            db   0,0;Драг.камни
            db   0,0;ПРЕДМЕТЫ РОСКОШИ
            db   0,0;легкое Вооружение
            db   0,0;тяжолое Вооружение
            db   0,0;Наркотики
            db   0,0;Рабы
            db   0,0;Проститутки
            db   0,0;Уникумы
            db   0,0;Трансплонтанты
            db   0,0;Технологии
            db   0,0;Артефакты

WKRBI:
ОПИСАНИЕ КУПЛЕННОГО ВООРУЖЕНИЯ ПОПОРЯДК
■0-nop,MAY BE 0-100
■#FF-NOP,MAY BE #FF,#FE-YEP
FUEL:
            db   0;Топл 'Космонефть'
            db   20;Топл 'Рубин'
ROKS:
            db   100;Ракет РЛН-1
            db   0;Ракет РЛН-2
MINA:
            db   10;Мина МХ-1
LAZER:
            db   #FF;Лаз 'Град'
            db   #FF;Лаз 'Шторм-1'
            db   #FF;Лаз 'Шторм-2'
            db   #FF;Лаз 'Смерть-1'
            db   #FF;Лаз 'Смерть-2'
PROTR1:
            db   #FE;Протракет.Сис ПС-1
PROTR2:
            db   #FF;Протракет.Сис ПС-2
DEF:
            db   #FF;С.Защ 'Крепость'
            db   #FF;С.Защ 'Оборона-1'
            db   #FF;С.Защ 'Оборона-2'
FORSG:
            db   #FF;Форсаж Движок 'Фотон'
            db   #FF;Форсаж Движок 'Протон'
REMDR1:
            db   #FF;Ремонт Дроид РД-1
REMDR2:
            db   #FF;Ремонт Дроид РД-2
REMDR3:
            db   #FF;Ремонт Дроид РД-3
SSILUC:
            db   #FE;Сист 'Силовой луч'
SNAWEDEN:
            db   #FE;Сист НАВЕДЕНИЯ
SGIPSL:
            db   #FF;Сист 'Гиперслед'
SWOZWR:
            db   #FF;Сист Возврата
SSWPOL:
            db   #FE;Сист.Свободного Полета
SZAPRAW:
            db   #FF;С заправки
SRASPOZN:
            db   #FF;С распознавания
IDENTC:
            db   #FE;Идентификатор Целей
MARSHRUT:
            db   #FF;МАРШРУТИЗАТОР
KRIOGEN:
            db   #FF;Криогенная Установка
POSADMOD:
            db   #FF;Посадочный Модуль
KIBERKIL:
            db   #FF;Кибер Киллер ККР-0562
GDIABLO:
            db   #FE;Гипер Сист 'Дьявол'
            db   #80

WSKMI:
ДЛЯ СКИМЕРА
ОПИСАНИЕ КУПЛЕННОГО ВООРУЖЕНИЯ ПО ПОРЯД
■0-NOP,MAY BE 0-200
■#FF-NOP,MAY BE #FF,#FE-YEP
            db   0;Топл 'Бензол'
            db   0;Ракет СРК-1
            db   0;Ракет СРК-2
            db   #FF;Лаз 'Силовой'
            db   #FF;Лаз 'Ураган-1'
            db   #FF;Лаз 'Ураган-2'
            db   #FF;С Защ 'Броня-1'
            db   #FF;С Защ 'Броня-2'
            db   #FF;Прыжк. Движок 'Даль-1'
            db   #FF;Прыжк. Движок 'Даль-2'
            db   #FF;Протракет Сист
            db   #FF;Стыковочный Узел
            db   #FF;Ходовой Модуль
            db   #FF;Бомба БР-0910
            db   #80

СОСТОЯНИЕ НОВОСТЕЙ
СООБЩЕНИЕ (НОМЕР),
ВРЕМЯ (ЧАС) ДО КОТ. ДЕРЖИТЬСЯ
ДАННЫЕ О СИСТЕМЕ И НОМЕР ПЛАНЕТЫ
ГДЕ ЧТО.
СОСТОЯНИЕ НОВОТЕЙ
■0-НЕТ,1..-СОСТОЯНИЕ
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
ДАННЫЕ О МИССИ ПО ДОСТАВКЕ
ДАННЫЕ КУДА ДОСТАВИТЬ(2W)
ДАННЫЕ ВРЕМЕНИ (2W) К СКОЛЬКИ ДОСТАВИТЬ
ДАННЫЕ ВРЕМ. (2W) ВО СКОЛЬКО СГЕНЕРИЛИ
ДЕНЬГИ (W)
ВЕС (B),ЕСЛИ БИТ 7=1,ТО МИСИЯ ВЗЯТА
И ОТКАЗУ НЕ ПОДЛЕЖИТ
НОМЕР ПЛАНЕТЫ (B)
ЕСЛИ ПЕРВЫЙ БАЙТ = #FF ТО НЕТ ОРДЕРА

SPEED:
СКОРОСТЬ КУПЛЕННОГО КОРАБЛЯ,СКИМЕРА
            db   100,100

ДАЛЬНОСТЬ ПОСЛЕДНЕЙ ВЫБРАННОЙ ЗВЕЗДЫ
DALNO:      dw   0

БУФЕР КООРДИНАТ КАРТЫ И В КАРТЕ ДЛЯ
ЗАПОМНЕННЫХ ЗВЕЗД
MSTARS:     ds   50,#FF
            db   #80

БУФЕР ЗВЕЗД МАРШРУТА
WAY:        ds   50,#FF
            db   #80

МАСКА ОПИСАТЕЛЬ ЛИНИИ, 0-3 БИТЫ
КОЛИЧЕСТВО УЗЛОВ, ДАЛЕЕ НОМЕРА УЗЛОВ
КРАТНЫЕ 5 НАЧИНАЯ С 0
WAYMASK:    db   %00100010
            ds   10

ЗВЕЗДЫ ГДЕ ЖИВУТ ПЕРСОНАЖИ
PSTARS:
            dw   #4B39,#0006
            ds   PKOL*4-4

ОПИСАНИЕ ЛЮДЕЙ С КОТОРЫМИ ВОЗМОЖНО ИЛИ
НЕ ВОЗМОЖНО ВЕСТИ ПЕРЕГОВОРЫ
СОСТОЯНИЕ 0-НЕДОСТУПЕН 1-ДОСТУПЕН

ABONS:
            db   1
            ds   PKOL-1,0
            db   #80;END



SETSD:
ДАННЫЕ О УСТАНОВКАХ СРЕДЫ В ПОРТАХ
И МАСКАХ
ПОРТ, МАСКА;
ИЛИ ПРОСТО ЧИСЛО (0-126), ПУСТО
ИЛИ #80/#81="N"/"Y",ПУСТО
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
ДАННЫЕ О УСТАНОВКАХ ИГРЫ В ПОРТАХ
И МАСКАХ
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
ДЛЯ СКИММЕРА
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




────────────────────────────────────────

            ADRXX00
ИНДЕКСНАЯ ТАБЛИЦА ОБЪЕКТОВ
СОДЕРЖИТ АДРЕСА ОБЪЕКТОВ
НЕДЕТАЛИЗИРОВАННЫХ И ДЕТАЛИЗИРОВАННЫХ
И ПРИДАЕТ ИНДЕКСЫ В ПОРЯДКЕ ВОЗРСТАНИЯ
L97:        equ  $.h

ПОЛИЦИЯ В КОСМОСЕ
IPOL1:      equ  $.b
            dw   KN01pol1
            dw   Kd1
IPOL2:      equ  $.b
            dw   KN06pol2
            dw   Kd6
IPOL3:      equ  $.b
            dw   KN29pol6
            dw   Kd29
IPOL4:      equ  $.b
            dw   KN27pol7
            dw   Kd27

ПОЛИЦИЯ ИЗ СТАНЦИИ
IPLS1:      equ  $.b
            dw   KN21plS3
            dw   Kd21
IPLS2:      equ  $.b
            dw   KN25plS4
            dw   Kd25
IPLS3:      equ  $.b
            dw   KN28plS5
            dw   Kd28

ВОЕННЫЕ
IMLT1:      equ  $.b
            dw   KN02mlt1
            dw   Kd2
IMLT2:      equ  $.b
            dw   KN09mlt2
            dw   Kd9
IMLT3:      equ  $.b
            dw   KN17mlt3
            dw   Kd17
IMLT4:      equ  $.b
            dw   KN26mlt4
            dw   Kd26

ГРУЗОВЫЕ
IGRZ1:      equ  $.b
            dw   KN03grz1
            dw   Kd3
IGRZ2:      equ  $.b
            dw   KN08grz2
            dw   Kd8
IGRZ3:      equ  $.b
            dw   KN11grz3
            dw   Kd11
IGRZ4:      equ  $.b
            dw   KN30grz4
            dw   Kd30
IGRZ5:      equ  $.b
            dw   KN31grz5
            dw   Kd31

ТОРГОВЫЕ, ПРОДАВАЕМЫЕ НА СТАНЦИИ
ITRG1:      equ  $.b
            dw   KN04trg1
            dw   Kd4
ITRG2:      equ  $.b
            dw   KN05trg2
            dw   Kd5
ITRG3:      equ  $.b
            dw   KN10trg3
            dw   Kd10
ITRG4:      equ  $.b
            dw   KN16trg4
            dw   Kd16
ITRG5:      equ  $.b
            dw   KOBRA
            dw   KOBRAD
ITRG6:      equ  $.b
            dw   KRYL
            dw   KRYLD

УФО
IUFO1:      equ  $.b
            dw   KN13ufo2
            dw   Kd13
IUFO2:      equ  $.b
            dw   KN14ufo3
            dw   Kd14
IUFO3:      equ  $.b
            dw   KN18UFo4
            dw   Kd18
IUFO4:      equ  $.b
            dw   KN20ufo5
            dw   Kd20
IUFO5:      equ  $.b
            dw   KN23ufo6
            dw   Kd23
IUFO6:      equ  $.b
            dw   KN24ufo7
            dw   Kd24
IUFO7:      equ  $.b
            dw   UFO1D
            dw   UFO1
IUFO8:      equ  $.b
            dw   Kd12
            dw   Kd12

КРЕЙСЕРА
IKRS1:      equ  $.b
            dw   KN07krs1
            dw   Kd7
IKRS2:      equ  $.b
            dw   Kd15
            dw   Kd15
IKRS3:      equ  $.b
            dw   Kd19
            dw   Kd19
IKRS4:      equ  $.b
            dw   Kd22
            dw   Kd22

МИКРО КОРАБЛИКИ
ВЫЛЕТАЮТ ИЗ ДРУГИХ
IMIK1:      equ  $.b
            dw   micKN
            dw   micKd1
IMIK2:      equ  $.b
            dw   micKN
            dw   micKd2

РАКЕТЫ
IROK:       equ  $.b
            dw   ROKET
            dw   ROKET
IROKUFO:    equ  $.b
            dw   UfoRD
            dw   UfoRD

КОНТЕЙНЕРЫ
ICRG:       equ  $.b
            dw   CRG1
            dw   CRG1
ICRGUFO:    equ  $.b
            dw   KontUFO
            dw   KontUFO

КИБЕРКИЛЕРЫ
IKIB:       equ  $.b
            dw   Kib_K
            dw   Kib_K
IKIBUFO:    equ  $.b
            dw   ufo_K
            dw   ufo_K

РЕМДРОИД
IREMDR:     equ  $.b
            dw   REM_DR
            dw   REM_DR
АСТЕРОИД
IASTER1:    equ  $.b
            dw   ASTER1
            dw   ASTER1
IASTER2:    equ  $.b
            dw   ASTER2
            dw   ASTER2
IASTER3:    equ  $.b
            dw   ASTER3
            dw   ASTER3
ОСКОЛОК
IOSKOL:     equ  $.b
            dw   OSKOL
            dw   OSKOL
МНИМАЯ ЦЕЛЬ
ITARGET:    equ  $.b
            dw   TARGET
            dw   TARGET
МУСОР ПРИ ФОРСАЖЕ
ITRASH:     equ  $.b
            dw   TRASH
            dw   TRASH

СТАНЦИИ

IST1:       equ  $.b
            dw   St1
            dw   St1
IST2:       equ  $.b
            dw   St2
            dw   St2
IST3:       equ  $.b
            dw   St3
            dw   St3
IST4:       equ  $.b
            dw   St4
            dw   St4
IST5:       equ  $.b
            dw   St5
            dw   St5
IST6:       equ  $.b
            dw   St6
            dw   St6
IST7:       equ  $.b
            dw   St7
            dw   St7
IST8:       equ  $.b
            dw   St8
            dw   St8
IST9:       equ  $.b
            dw   St9
            dw   St9
IST10:      equ  $.b
            dw   St10
            dw   St10
IST11:      equ  $.b
            dw   St11
            dw   St11
IST12:      equ  $.b
            dw   St12
            dw   St12
IST13:      equ  $.b
            dw   St13
            dw   St13
IST14:      equ  $.b
            dw   St14
            dw   St14
IST15:      equ  $.b
            dw   St15
            dw   St15
IST16:      equ  $.b
            dw   St16
            dw   St16
IST_PIRAT:  equ  $.b
            dw   St_pirat
            dw   St_pirat
IPRISON:    equ  $.b
            dw   Prison
            dw   Prison
IST_U1:     equ  $.b
            dw   St_u1
            dw   St_u1
IST_U2:     equ  $.b
            dw   St_u2
            dw   St_u2
IST_SCINCE: equ  $.b
            dw   St_scince
            dw   St_scince
IGIP_PL:    equ  $.b
            dw   Gip_pl
            dw   Gip_pl



────────────────────────────────────────






БУФЕР 3D ОБЪЕКТА
OBJBUF:     ds   #100


CARGS:
БУФЕР НА 10 ГРУЗОВ
            ds   #0A,#FFFF
            db   #FE



            ADRXX00
БУФЕР ОПИСАТЕЛЬ ПОЛОЖЕНИЯ И СОСТОЯНИЯ
ОБЪЕКТОВ В КОСМОСЕ, НА 25 ОБЪЕКТОВМ !
CARSB:
            rept 25:dw #8000:ds OLEN-2:endr
            dw   #8080
            ds   OLEN-2


БУФЕР ОПИСАТЕЛЬ ИГРОКА
PLAYER:
            dw   0
            dw   0
            dw   0
            db   0
УГЛЫ
            db   0,0,0
            db   #FF;MARK OF PLAYER
            db   0
ACTION:     db   0
            dw   0
Speed:      db   20
            db   0
            db   0
            db   #FF;TYPE
            db   0
SHILD:      db   46




БУФЕР ДАННЫХ ВОКСНИМАЦИЙ НЕ БОЛЕЕ ЧЕМ
НА 8 АНИМАЦИЙ ОДНОВРЕМЕННО !
VOXCOR:
            ds   18*8+7,0
            db   #FF
КООРДИНАТЫ X,Y,z(W)
КОЭФИЦИЕНТ МАСШТАБИРОВАНИЯ (B)
ВРЕМЯ ЖИЗНИ (B)
ТЕКУЩИЙ АДРЕС СПРЙТА (W)
НАЧАЛЬНЫЙ АДРЕС АНИМАЦИИ (W)
ТЕКУЩИЙ НОМЕР КАДРА (B)
КОЛИЧЕСТВО КАДРОВ (B)
ДЛИННА СПРАЙТА В БАЙТАХ (W)





