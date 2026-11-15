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

PS              equ 6                   ; Шаг поворота
MSPEED          equ #FF
MSPEED2         equ 4
Olen            equ #20
A3D             equ 40                  ; Кол. 3d объектов в списке

ADHIDE          equ #10000-#1388

PG3D            equ #11
PGSPR           equ #13
PGNORM          equ #10

HSCR            equ #8000

VARS            equ #6700
Carsb           equ VARS
PLAYER          equ Carsb+(Olen*(A3D-1))
XXP             equ PLAYER
YYP             equ XXP+3
ZZP             equ YYP+3
ACTION          equ PLAYER+12
SPEED           equ ACTION+3
SHILD           equ SPEED+5
UNGLE           equ SHILD+1
PLANT           equ Carsb+(Olen*A3D)
SKYS            equ PLANT+2
Mesags          equ SKYS+2
NEWEFA          equ Mesags+3
NEWEFB          equ NEWEFA+3
Mnums           equ NEWEFB+3
Pcord           equ Mnums+3
VOXOBJ          equ Pcord+2

L97             equ VARS+((((A3D+2)*Olen)+255)&#FF00)

Splayer         equ A3D-1

; Данные процедур вывода спрайта в своей
; Странице
Vox             equ #C000
TAKESPD         equ Vox+3
OUTALL          equ TAKESPD+3
NEWPOS          equ OUTALL+3
NEWPSS          equ NEWPOS+3
RETURN          equ NEWPSS+3
RRT             equ RETURN+3
RLT             equ RRT+3
D3D2            equ RLT+3

; Данные процедур вывода 3d в своей
; Странице
INIT            equ #FF00               ; 3
OUTALL2         equ INIT+3
NXTO            equ OUTALL2+3
ADI3D           equ NXTO+3              ; 2
MOVEON          equ ADI3D+2             ; 3
PRECORD         equ MOVEON+3
NULMOVE         equ PRECORD+3
FLINE           equ NULMOVE+3

EYEA            equ #C203

Spacebd         equ #60
Visibil         equ #50
Detaliz         equ #1F
Xvisibi         equ #60

STP             equ #80
STPTURN         equ 3

XEND            equ 64
YEND            equ 24
