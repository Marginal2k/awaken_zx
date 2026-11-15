            DEVICE ZXSPECTRUM128
            include "MACRO.asm"
            include "EQUS.asm"
            include "../common/disk.asm"
ASM:        equ  ON


; Догрузка меток если нет необходимости
; компилить некоторые блоки
            if   ASM
            else
            include "LABELS.asm"
            endif


            org  #6000

; Процедура загрузки страниц
            include "LOADI2.asm"
; Процедура инициализации
            include "INITV.asm"

            ent

ZM8:        equ  $-ZM9


            disp #6000
ZM15:
; Не должны быть в странице
            include "SLOWPRO.asm"
; Управление полетом и функциями панели
            include "SETCONTR.asm"
; Генерация объектов
            include "OBJGENER.asm"
ZM14:       equ  $-ZM15

            ent
END2:

            org  #8C00

            if   ASM
; Таблицы
            include "3DTABS.asm"


ZM25:       equ  $-#8C00
            savebin "DATAS.C",#8C00,ZM25
            else
            incbin "DATAS.C"
            endif


; Основное тело игры
; математика
            include "BODY.asm"
; [glue] flight -> station launcher (not in the 1999 sources; see common/launcher.asm)
            include "../common/state.inc"
            include "../common/launcher.asm"
            LAUNCHER_ROUTINE LaunchStation,"STATIONFC",#6000,STATION_ENTRY,STATE_BUF,TIME,1,0,0


END1:
            org  #C000

            if   ASM
; Клиппирование
            include "CLIPMATR.asm"
; Рендеринг вывод полигона - обсчет
            include "3D-II.asm"
ZM23:       equ  $-#C000
            savebin "3DPART.C",#C000,ZM23
            else
            incbin "3DPART.C"
            endif

; Рендеринг общий расчет по матрице
            include "3D-I.asm"

; Интелект
; дополнительные процедуры
            include "BRAINDOP.asm"
; Основные процедуры
            include "BRAINPRO.asm"
END_:
            savebin "ACTION.C",#6000,$-#6000      ; main image (loaded to #6000 by the previous stage)


            if   ASM

MAKE_0:          equ  #C000
            org  MAKE_0

; Воксели
VXTAB:
            incbin "VOX.d"
; Спрайты анимаци
VSPR:
; Взрыв
            incbin "EXPLOSIO.v"
VSPR2:
; Телепорт
            incbin "HIPERJMP.v"

; Расчет матрицы пространства
            include "GMATRX.asm"

NEXTL1:

            endif


            savebin "VOXAL0.C",MAKE_0,$-MAKE_0
MAKE_1:          equ  NEXTL1
            org  MAKE_1


; Вывод воксспрайта
            include "VOXEL~37.asm"

END_S:


            if   ASM

            savebin "VOXAL.C",MAKE_1,$-MAKE_1
MAKE_2:          equ  #C000
            org  MAKE_2

; Таблица для расчета корней
KORN:
            incbin "KORNI.d"


LBE00:
            incbin "0E0200.d"
DOTB:
            ds   #100


; Компильнутая процедура эффекта гипер
; перехода
JL1:
            incbin "EFF.c"
JL2:        equ  $-JL1


; Шрифт
FONT:
            incbin "gen/FONT.f"   ; GENERATED from assets/gfx/panel_font.png


; Обработка звезд
; вывод хайд скрина
; вывод круга с заливкой
            include "STARHSUN.asm"


NEXTL2:

            endif


            savebin "CONTROL0.C",MAKE_2,$-MAKE_2
MAKE_3:          equ  NEXTL2
            org  MAKE_3


; Процедуры установки параметров среды
; в зависимости от статуса планетарной
; системы
; процедура вызова гипер прыжка
; процедура возврата на станцию
            include "SETHJRET.asm"

; Вывод индикаторов панели, радара и
; компосов
            include "PANEL.asm"


; Вывод сообщений в компьютер
            include "COMPUTE.asm"


; Объекты
            if   ASM
            savebin "CONTROL.C",MAKE_3,$-MAKE_3
MAKE_4:          equ  #C000
            org  MAKE_4
            include "gen/OBJECTS.inc"   ; GENERATED from assets/models/flight/*.txt
            include "gen/OBJECTS2.inc"
            include "gen/OBJECTSS.inc"
            endif


; Создание файла меток
            if   ASM
            ; makelab "LABELS"
            endif

            savebin "OBJECT3D.C",MAKE_4,$-MAKE_4

            ASSERT TIME == FLIGHT_STATE     ; common/state.inc: the station launcher copies the state record to this address
