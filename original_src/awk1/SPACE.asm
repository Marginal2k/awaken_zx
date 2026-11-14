            create $M,29
            create $J,76
            create $R,10
            include "MACRO"
            include "EQUS"
ASM         equ  ON


ДОГРУЗКА МЕТОК ЕСЛИ НЕТ НЕОБХОДИМОСТИ
КОМПИЛИТЬ НЕКОТОРЫЕ БЛОКИ
            if   ASM
            else
            include "LABELS"
            endif


            org  #6000
            ent  $

ПРОЦЕДУРА ЗАГРУЗКИ СТРАНИЦ
            include "LOADI2"
ПРОЦЕДУРА ИНИЦИАЛИЗАЦИИ
            include "INITV"

            unphase

$M8         equ  $-$M9






            phase #6000
$M15
НЕ ДОЛЖНЫ БЫТЬ В СТРАНИЦЕ
            include "SLOWPRO"
УПРАВЛЕНИЕ ПОЛЕТОМ И ФУНКЦИЯМИ ПАНЕЛИ
            include "SETCONTR"
ГЕНЕРАЦИЯ ОБЪЕКТОВ
            include "OBJGENER"
$M14        equ  $-$M15

            unphase
END2

            org  #8C00

            if   ASM
ТАБЛИЦЫ
            include "3DTABS"


$M25        equ  $-#8C00
            saveobj "DATAS.C",#8C00,$M25
            else
            insert "DATAS.C"
            endif



ОСНОВНОЕ ТЕЛО ИГРЫ
МАТЕМАТИКА
            include "BODY"


END1
            org  #C000

            if   ASM
КЛИППИРОВАНИЕ
            include "CLIPMATR"
РЕНДЕРИНГ ВЫВОД ПОЛИГОНА - ОБСЧЕТ
            include "3D-II"
$M23        equ  $-#C000
            saveobj "3DPART.C",#C000,$M23
            else
            insert "3DPART.C"
            endif

РЕНДЕРИНГ ОБЩИЙ РАСЧЕТ ПО МАТРИЦЕ
            include "3D-I"

ИНТЕЛЕКТ
ДОПОЛНИТЕЛЬНЫЕ ПРОЦЕДУРЫ
            include "BRAINDOP"
ОСНОВНЫЕ ПРОЦЕДУРЫ
            include "BRAINPRO"
END








            if   ASM

            make "VOXAL0.C",#C000

ВОКСЕЛИ
VXTAB:
            insert "VOX.dat"
СПРАЙТЫ АНИМАЦИ
VSPR:
ВЗРЫВ
            insert "EXPLOSIO.van"
VSPR2:
ТЕЛЕПОРТ
            insert "HIPERJMP.van"

РАСЧЕТ МАТРИЦЫ ПРОСТРАНСТВА
            include "GMATRX"

NEXTL1:

            endif


            make "VOXAL.C",NEXTL1


ВЫВОД ВОКССПРАЙТА
            include "VOXEL"

END_S










            if   ASM

            make "CONTROL0.C",#C000

ТАБЛИЦА ДЛЯ РАСЧЕТА КОРНЕЙ
KORN:
            insert "KORNI.dat"


LBE00:
            insert "#0E#0200.dat"
DOTB:
            ds   #100


КОМПИЛЬНУТАЯ ПРОЦЕДУРА ЭФФЕКТА ГИПЕР
ПЕРЕХОДА
JL1:
            insert "EFF.cod"
JL2:        equ  $-JL1


ШРИФТ
FONT:
            insert "FONT.fnt"


ОБРАБОТКА ЗВЕЗД
ВЫВОД ХАЙД СКРИНА
ВЫВОД КРУГА С ЗАЛИВКОЙ
            include "STARHSUN"



NEXTL2:

            endif


            make "CONTROL.C",NEXTL2



ПРОЦЕДУРЫ УСТАНОВКИ ПАРАМЕТРОВ СРЕДЫ
В ЗАВИСИМОСТИ ОТ СТАТУСА ПЛАНЕТАРНОЙ
СИСТЕМЫ
ПРОЦЕДУРА ВЫЗОВА ГИПЕР ПРЫЖКА
ПРОЦЕДУРА ВОЗВРАТА НА СТАНЦИЮ
            include "SETHJRET"

ВЫВОД ИНДИКАТОРОВ ПАНЕЛИ, РАДАРА И
КОМПОСОВ
            include "PANEL"


ВЫВОД СООБЩЕНИЙ В КОМПЬЮТЕР
            include "COMPUTE"




ОБЪЕКТЫ
            if   ASM
            make "OBJECT3D.C",#C000
            include "OBJECTS"
            include "OBJECTS2"
            include "OBJECTSS"
            endif


СОЗДАНИЕ ФАЙЛА МЕТОК
            if   ASM
            makelab "LABELS"
            endif

