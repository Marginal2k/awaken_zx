;==============================================================================
; EQUS - константы всего движка STORM
;
; Включается всеми модулями набора. Содержит: количество/тип товаров и оружия, смещения
; полей записи 3D-объекта (размер OBJ_LEN = #20; Indi, Alfa, Beta, Gama, Mode, Type,
; Energy, ... Px/Py/Pz), номера страниц PAGE_3D/PAGE_VOXEL/PAGE_NORMAL, карту переменных
; (VARS = #6700), адреса таблиц переходов страницы воксельного рендера (#C000, VOX_*) и
; страницы 3D-движка (#FF00, ENG3D_*).
;
; Исправление относительно дискового файла: DROP_CODE_ADDR (бывш. ADHIDE) = #10000-#1388
; (в оригинале 0-#1388, нужно 16-битное заворачивание).
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

        include "HW.asm"

; Кол. товаров
TKOL            equ 28
; Кол. вооруж. корабля
WKKOL           equ 31
; Кол. вооруж. скимера
WSKOL           equ 14
; Количество персонажей вобще
PKOL            equ 50

Indi            equ #06
Alfa            equ #07                 ; =#FF-вокс. спрайт
Beta            equ #08
Gama            equ #09
Mode            equ #0A                 ; =#FF-опистель игрока
;     0   Simply fly
;     1   Go
;     2   Fight
;     5   Defence
;     7   Jumping
;     16  Go away from target
;     17  Turnout from target
;     20  Oblet
;     21  Wozwrat

Subj            equ #0B
Actn            equ #0C
; Bits:
; 0-Atack you,1-roket atack,2-roket kill
; Ed you
; 3-Если было K (2) еще протракетная сис
; Тема
Rand            equ #0D
Mspd            equ #0F
Rspd            equ #10
Lzs             equ #11
Type            equ #12
; 0-Пират
; 1-Торговец
; 2-Военный
; 3-Полиция
; 4-Охотник
; 5-Пират не опасный
; 6-Уфо враждебный
; #10-Осколок
; #11-Ракета
; #FF-игрок
Energy          equ #13
; Счетчик для повторного пуска ракет
Rco             equ #14
; Дополнительный номер субъекта который
; Пустил послед. ракету
; По текущему персонажу
Osubj           equ #15
; ;Дополнительный режим, если нет выполне
; Ния основного
Omode           equ #16
; Счетчик для поворота вокруг бета
Powor           equ #17
; Установки b процессе жи3ни
; Биты:
; =1-Да
; 0-1
; 2-
; 3-Тип ракет 0-ркн-1,1-ркн-2
; 4-
; 4-
; --------Если #FF то объект только сбит
; , Потом он будет 0
Setup           equ #18
; Past mode, 3апоминает пред. режим
Pmode           equ #19
; Повернутые координаты
Px              equ #1A
Py              equ #1C
Pz              equ #1E

; При описании ракеты исполь3уются
; Rand-кто пустил ракету
; Mspd-на кого направлена ракета
; Lzs -=0-ракета персонажа, <>0-игрока

TURN_STEP       equ 6                   ; orig: PS. Шаг поворота
MSPEED          equ #FF
MSPEED2         equ 4
OBJ_LEN         equ #20                 ; orig: Olen
OBJ_COUNT       equ 40                  ; orig: A3D. Кол. 3d объектов в списке

DROP_CODE_ADDR  equ #10000-#1388        ; orig: ADHIDE

PAGE_3D         equ #11                 ; orig: PG3D
PAGE_VOXEL      equ #13                 ; orig: PGSPR
PAGE_NORMAL     equ #10                 ; orig: PGNORM

HIDDEN_SCREEN   equ #8000               ; orig: HSCR

VARS            equ #6700
Carsb           equ VARS
PLAYER          equ Carsb+(OBJ_LEN*(OBJ_COUNT-1))
XXP             equ PLAYER
YYP             equ XXP+3
ZZP             equ YYP+3
ACTION          equ PLAYER+12
SPEED           equ ACTION+3
SHILD           equ SPEED+5
UNGLE           equ SHILD+1
PLANT           equ Carsb+(OBJ_LEN*OBJ_COUNT)
SKYS            equ PLANT+2
Mesags          equ SKYS+2
NEWEFA          equ Mesags+3
NEWEFB          equ NEWEFA+3
Mnums           equ NEWEFB+3
Pcord           equ Mnums+3
VOXOBJ          equ Pcord+2

L97             equ VARS+((((OBJ_COUNT+2)*OBJ_LEN)+255)&#FF00)

PLAYER_INDEX    equ OBJ_COUNT-1         ; orig: Splayer

; Данные процедур вывода спрайта в своей
; Странице
VOX_DRAW        equ #C000               ; orig: Vox
VOX_TAKE_SPEED  equ VOX_DRAW+3          ; orig: TAKESPD
VOX_OUT_ALL     equ VOX_TAKE_SPEED+3    ; orig: OUTALL
VOX_NEW_POS     equ VOX_OUT_ALL+3       ; orig: NEWPOS
VOX_NEW_POS2    equ VOX_NEW_POS+3       ; orig: NEWPSS
VOX_RETURN      equ VOX_NEW_POS2+3      ; orig: RETURN
VOX_TURN_RIGHT  equ VOX_RETURN+3        ; orig: RRT
VOX_TURN_LEFT   equ VOX_TURN_RIGHT+3    ; orig: RLT
VOX_DRAW_3D2    equ VOX_TURN_LEFT+3     ; orig: D3D2

; Данные процедур вывода 3d в своей
; Странице
ENG3D_INIT      equ #FF00               ; orig: INIT. 3
ENG3D_OUT_ALL   equ ENG3D_INIT+3        ; orig: OUTALL2
ENG3D_NEXT_OBJECT equ ENG3D_OUT_ALL+3   ; orig: NXTO
ENG3D_OBJECT_INDEX equ ENG3D_NEXT_OBJECT+3  ; orig: ADI3D. 2
ENG3D_MOVE_ON   equ ENG3D_OBJECT_INDEX+2  ; orig: MOVEON. 3
ENG3D_PRECORD   equ ENG3D_MOVE_ON+3     ; orig: PRECORD
ENG3D_NULL_MOVE equ ENG3D_PRECORD+3     ; orig: NULMOVE
ENG3D_LINE      equ ENG3D_NULL_MOVE+3   ; orig: FLINE

EYEA            equ #C203

Spacebd         equ #60
Visibil         equ #50
Detaliz         equ #1F
Xvisibi         equ #60

STP             equ #80
MAX_TURN        equ 3                   ; orig: STPTURN

XEND            equ 64
YEND            equ 24
