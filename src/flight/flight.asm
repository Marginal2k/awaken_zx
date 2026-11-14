            DEVICE ZXSPECTRUM128
            ; create $M,29   (ZASM auto-label family)
            ; create $J,76   (ZASM auto-label family)
            ; create $R,10   (ZASM auto-label family)
            include "MACRO.asm"
            include "EQUS.asm"
            include "../common/disk.asm"
ASM:        equ  ON


; ДОГРУЗКА МЕТОК ЕСЛИ НЕТ НЕОБХОДИМОСТИ
; КОМПИЛИТЬ НЕКОТОРЫЕ БЛОКИ
            if   ASM
            else
            include "LABELS.asm"
            endif


            org  #6000
            ; ent $   (ZASM entry point marker)

; ПРОЦЕДУРА ЗАГРУЗКИ СТРАНИЦ
            include "LOADI2.asm"
; ПРОЦЕДУРА ИНИЦИАЛИЗАЦИИ
            include "INITV.asm"

            ent

ZM8:        equ  $-ZM9






            disp #6000
ZM15:
; НЕ ДОЛЖНЫ БЫТЬ В СТРАНИЦЕ
            include "SLOWPRO.asm"
; УПРАВЛЕНИЕ ПОЛЕТОМ И ФУНКЦИЯМИ ПАНЕЛИ
            include "SETCONTR.asm"
; ГЕНЕРАЦИЯ ОБЪЕКТОВ
            include "OBJGENER.asm"
ZM14:       equ  $-ZM15

            ent
END2:

            org  #8C00

            if   ASM
; ТАБЛИЦЫ
            include "3DTABS.asm"


ZM25:       equ  $-#8C00
            savebin "DATAS.C",#8C00,ZM25
            else
            incbin "DATAS.C"
            endif



; ОСНОВНОЕ ТЕЛО ИГРЫ
; МАТЕМАТИКА
            include "BODY.asm"
; [glue] flight -> station launcher (not in the 1999 sources; see common/launcher.asm)
            include "../common/state.inc"
            include "../common/launcher.asm"
            LAUNCHER_ROUTINE LaunchStation,"STATIONFC",#6000,STATION_ENTRY,STATE_BUF,TIME,1,0,0


END1:
            org  #C000

            if   ASM
; КЛИППИРОВАНИЕ
            include "CLIPMATR.asm"
; РЕНДЕРИНГ ВЫВОД ПОЛИГОНА - ОБСЧЕТ
            include "3D-II.asm"
ZM23:       equ  $-#C000
            savebin "3DPART.C",#C000,ZM23
            else
            incbin "3DPART.C"
            endif

; РЕНДЕРИНГ ОБЩИЙ РАСЧЕТ ПО МАТРИЦЕ
            include "3D-I.asm"

; ИНТЕЛЕКТ
; ДОПОЛНИТЕЛЬНЫЕ ПРОЦЕДУРЫ
            include "BRAINDOP.asm"
; ОСНОВНЫЕ ПРОЦЕДУРЫ
            include "BRAINPRO.asm"
END_:
            savebin "ACTION.C",#6000,$-#6000      ; main image (loaded to #6000 by the previous stage)








            if   ASM

MAKE_0:          equ  #C000
            org  MAKE_0

; ВОКСЕЛИ
VXTAB:
            incbin "VOX.d"
; СПРАЙТЫ АНИМАЦИ
VSPR:
; ВЗРЫВ
            incbin "EXPLOSIO.v"
VSPR2:
; ТЕЛЕПОРТ
            incbin "HIPERJMP.v"

; РАСЧЕТ МАТРИЦЫ ПРОСТРАНСТВА
            include "GMATRX.asm"

NEXTL1:

            endif


            savebin "VOXAL0.C",MAKE_0,$-MAKE_0
MAKE_1:          equ  NEXTL1
            org  MAKE_1


; ВЫВОД ВОКССПРАЙТА
            include "VOXEL~37.asm"

END_S:










            if   ASM

            savebin "VOXAL.C",MAKE_1,$-MAKE_1
MAKE_2:          equ  #C000
            org  MAKE_2

; ТАБЛИЦА ДЛЯ РАСЧЕТА КОРНЕЙ
KORN:
            incbin "KORNI.d"


LBE00:
            incbin "0E0200.d"
DOTB:
            ds   #100


; КОМПИЛЬНУТАЯ ПРОЦЕДУРА ЭФФЕКТА ГИПЕР
; ПЕРЕХОДА
JL1:
            incbin "EFF.c"
JL2:        equ  $-JL1


; ШРИФТ
FONT:
            incbin "FONT.f"


; ОБРАБОТКА ЗВЕЗД
; ВЫВОД ХАЙД СКРИНА
; ВЫВОД КРУГА С ЗАЛИВКОЙ
            include "STARHSUN.asm"



NEXTL2:

            endif


            savebin "CONTROL0.C",MAKE_2,$-MAKE_2
MAKE_3:          equ  NEXTL2
            org  MAKE_3



; ПРОЦЕДУРЫ УСТАНОВКИ ПАРАМЕТРОВ СРЕДЫ
; В ЗАВИСИМОСТИ ОТ СТАТУСА ПЛАНЕТАРНОЙ
; СИСТЕМЫ
; ПРОЦЕДУРА ВЫЗОВА ГИПЕР ПРЫЖКА
; ПРОЦЕДУРА ВОЗВРАТА НА СТАНЦИЮ
            include "SETHJRET.asm"

; ВЫВОД ИНДИКАТОРОВ ПАНЕЛИ, РАДАРА И
; КОМПОСОВ
            include "PANEL.asm"


; ВЫВОД СООБЩЕНИЙ В КОМПЬЮТЕР
            include "COMPUTE.asm"




; ОБЪЕКТЫ
            if   ASM
            savebin "CONTROL.C",MAKE_3,$-MAKE_3
MAKE_4:          equ  #C000
            org  MAKE_4
            include "OBJECTS.asm"
            include "OBJECTS2.asm"
            include "OBJECTSS.asm"
            endif


; СОЗДАНИЕ ФАЙЛА МЕТОК
            if   ASM
            ; makelab "LABELS"
            endif

            savebin "OBJECT3D.C",MAKE_4,$-MAKE_4

            ASSERT TIME == FLIGHT_STATE     ; common/state.inc: the station launcher copies the state record to this address
