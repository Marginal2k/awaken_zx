;==============================================================================
; SLOWPRO - "медленные" процедуры полёта: ракеты, попадания, грузы, солнце, планета, звёзды
;
;
; Где живёт: блок disp #6000 (метка ZM15) внутри ACTION.C; не должен лежать в переключаемой странице.
; Содержит: вывод чисел (PrintNumScroll/PrintNumNoScroll), GameOver, NewMissile/InitMissile (пуск ракеты),
; RedrawPanel, мусор форсажа (InitTrash/KillTrash), AimAtObject (наведение носа), PlayerHit (попадание
; лазера игрока), ChangeStatus, DropCargo/SpawnCargo, NewOrder (задание по типу объекта),
; DrawDataLines, NewSun/MakeBlackHole/MoveSun, DrawSun/DrawPlanet, MoveShipsForward, GovernmentAt.
; Вызывается из BODY.asm (главный цикл START/CYCL) и из ИИ (BRAINPRO/BRAINDOP).
; GAME_DESIGN: 6.1, 6.3, 6.4.
;==============================================================================

PrintNumbersInOrder:            ; orig: MNUMS_ - вывод номеров по порядку
            ex   af,af'
            PAGE_ CONTR
            ex   af,af'
            call MNUMS
            PAGE___NOARG
            ret


PrintNumScroll:                 ; orig: PNUM - вывод числа в компе со скроллом
; Вывод числа в компе со скролом
; в a-число
            ex   af,af'
            PAGE_ CONTR
            ex   af,af'
            call PrintNumber
            call SCROLL

            ld   hl,(CORD)
            inc  hl
            ld   (hl),0
            PAGE___NOARG
            ret
PrintNumNoScroll:               ; orig: PNUM2 - вывод числа в компе без скролла
; Вывод числа в компе без скрола
; а-число
            ex   af,af'
            PAGE_ CONTR
            ex   af,af'
            call PrintNumber

            ld   hl,(CORD)
            inc  hl
            ld   a,(hl)
            inc  a
            ld   (hl),a
            PAGE___NOARG
            ret


MESAG_:
            push af
            push bc
            push hl
            PAGE_ CONTR
            call MESAGS
            PAGE___NOARG
            pop  hl
            pop  bc
            pop  af
            ret


GameOver:                       ; orig: GAMEOVER - конец игры (гибель)
; Аутро по гамоверу
            MESAG _GAMEOVER
            ld   hl,EFF0
            ld   (SFXB+1),hl
            ld   a,#3F
            ld   i,a
            ld   iy,#5C3A
            ld   b,100
.EBEG
            push bc
            ld   de,#8000
            ld   a,r
            ld   l,a
            ld   h,#05
            ld   bc,#0C00
            ldir
            ei
            halt
            di
            PAGE_ CONTR
            call OHIDE
            call PRINT
            PAGE___NOARG
            call SFXA
            pop  bc
            dec  b
            jp   nz,.EBEG2
            ld   b,1
            xor  a
            in   a,(PORT_ULA)
            and  #1F
            cp   #1F
            jr   z,.EBEG
            jp   EXIT
.EBEG2
            ld   a,1
            xor  a
            in   a,(PORT_ULA)
            and  #1F
            cp   #1F
            jr   .EBEG


NewMissile:                     ; orig: NEWROKET - создать ракету
; Инит ракеты
; в c-объект атаки
            ld   a,c
            call ObjAddrFromIndex
            inc  l
            ld   a,(hl)
            cp   #80
            jr   nz,.RKN12
            ld   hl,EFF13
            ld   (SFXA+1),hl
            MESAG _LOSTTARGET
            and  a
            ret
.RKN12
            push bc
            exx
            ld   hl,0
            ld   d,h
            ld   e,l
            ld   bc,400
            call ToShipCoords
            exx
            pop  bc
            ld   a,1
            ex   af,af'
            call AROKS
            ld   a,l
            cp   low(ROKS)
            ld   a,MINREN
            jr   z,$+4
            ld   a,MAXREN
            ld   b,SPLAYER
InitMissile:                    ; orig: RKN11 - инициализация ракеты
; Инит ракеты
;HL'-X,DE'-Y,BC'-Z
;c-SUBJECT
;A'-1-ROKET OF PLAYER,0-ROKET OF SOMEBODY
; в b-кто пустил ракету
            ld   (ENROK+3),a

            push bc
            call FindFreeSlot
            pop  bc
            ret  z

            exx
            ld   (iy+0),l
            ld   (iy+1),h
            ld   (iy+2),e
            ld   (iy+3),d
            ld   (iy+4),c
            ld   (iy+5),b
            exx

            xor  a
            ld   (iy+INDI),IROK
            ld   (iy+ALFA),a
            ld   (iy+BETA),a
            ld   (iy+GAMA),a
            ld   (iy+MODE),C_NAVODROKET
            ld   (iy+SUBJ),a
            ld   (iy+ACTN),a
; Кто пустил ракету
            ld   (iy+RAND),b
; Объект атаки
            ld   (iy+MSPD),c
            ex   af,af'
; Принадлежность ракеты к игроку <>0
            ld   (iy+LZS),a
            ld   (iy+TYPE),T_ROKET
ENROK:      ld   (iy+ENERGY),0
            ld   (iy+SPT),2

; Предупреждение объекта атаки о ракетном
; ударе
            ld   a,c
            call ObjAddrFromIndex
            ld   a,l
            add  a,ACTN
            ld   l,a
            set  1,(hl)
            dec  l
            EXD
            call ObjIndexFromIY
; Номер ракеты в списке
            ld   (de),a
            scf
            ret


RedrawPanel:                    ; orig: REPANEL - перерисовка индикаторов панели
; Вывод индикаторов панел
            PAGE___NOARG
            ld   a,1
            ld   (FSPEED+1),a
            ld   (FFIRE+1),a
            ld   (FSHILD+1),a
            ld   (FHIGH+1),a
            ld   (FTEMPE+1),a
            ld   (FFUEL+1),a
; Даталинии
            call DrawDataLines
            PAGE_ CONTR
            ld   hl,(TIME+2)
            ld   de,(TIME)
            ld   b,#FF
; Время
            jp   ZEROUT


KillTrash:                      ; orig: KILLTRASH - убрать весь мусор форсажа
; Убрть все треши
            ld   d,#14
            call FindObjectByType
            ret  z
            call DEATHY
            jr   KillTrash


InitTrash:                      ; orig: TRASHINI - инициализация мусора при ускорении
; Инит мусор при ускорении
            call FindFreeSlot
            ret  z
            call RNDL1
            xor  a
            rlc  h
            sbc  a,a
            rrc  h
            ld   d,a
            ld   e,h
            xor  a
            rlc  l
            sbc  a,a
            rrc  l
            ld   h,a
            ADDHLHL 2
            EXD
            ADDHLHL 2
            EXD
            bit  7,h
            jr   z,$+6
            res  2,h
            jr   $+4
            set  2,h
            bit  7,d
            jr   z,$+6
            res  2,d
            jr   $+4
            set  2,d
            ld   a,(BFC1)
            and  a
            ld   bc,30000
            jr   z,$+5
            ld   bc,0-30000
            call ToShipCoords
            ld   (iy+0),l
            ld   (iy+1),h
            ld   (iy+2),e
            ld   (iy+3),d
            ld   (iy+4),c
            ld   (iy+5),b
            ld   (iy+ALFA),12
            ld   (iy+BETA),29
            ld   (iy+GAMA),55
            ld   (iy+INDI),ITRASH
            ld   (iy+TYPE),T_TRASH
            ld   (iy+ENERGY),250
            ld   (iy+MODE),C_FLYFREE
            xor  a
            ld   (iy+SETUP),a
            ld   (iy+ACTN),a
            ld   (iy+FORSAG),a
            ld   (iy+SPT),2
            ld   (iy+RSPD),2
            ld   (iy+MSPD),2
            ret

RandomTurns:                    ; orig: RNDTURN - случайные повороты
; Случайные поворты
            call RND
            ld   a,h
            cp   #7F
            jr   nz,.JL14
            ld   a,l
            and  #7F
            cp   #10
            jr   c,.JL14
            and  #0F
            add  a,32
            ld   h,a
            ld   a,l
            and  #80
            or   h
            ld   (ix+POWOR),a
.JL14
            ld   a,(ix+POWOR)
            and  #7F
            dec  a
            ret  m
            ld   a,(ix+POWOR)
            dec  a
            ld   (ix+POWOR),a
            jp   p,$+9
            dec  (ix+GAMA)
            jp   $+6
            inc  (ix+GAMA)
            ld   a,(ix+GAMA)
            and  a
            jp   p,$+5
            neg
            cp   #40
            ret  c
            ld   a,(ix+POWOR)
            xor  #80
            ld   (ix+POWOR),a
            ret


AimAtObject:                    ; orig: ONWAY - наведение носа объекта на другой объект
; Наведение носа объекта на др. объект
;hl,bc,de-X2,Y1,X1
;HL',BC',DE'-Y2,Z1,Z2
;X1,... - координаты наводимого объекта
;X2,... - координаты объекта наведения
            push hl
            push de
            push bc
            ld   a,(ix+SUBJ)
            call ObjAddrFromIndexIY
            ld   a,(iy+1)
            cp   #80
            jr   z,.NONW
            call DistanceHigh
; Расстояние для сворачивания
            cp   MINRAS
            jr   c,TURNUP
.NONW
            pop  bc
            pop  de
            pop  hl
ONWAY2:
            call AimAngles
            ld   a,(ix+BETA)
            ld   d,a
            sub  b
            ld   e,a
            jp   p,$+5
            neg
            ld   l,a
            cp   2
            jr   c,.JLK1
            ld   a,(ix+SPT)
            cp   l
            jr   c,.OY1
            jr   z,.OY1
            rra
            jp   $-6
.OY1
            bit  7,e
            jr   nz,$+4
            neg
            add  a,d
            ld   (ix+BETA),a
.JLK1
            ld   a,(ix+GAMA)
            ld   d,a
            sub  c
            ld   e,a
            jp   p,$+5
            neg
            ld   h,a
            cp   (ix+SPT)
            ret  c
            ld   a,(ix+SPT)
            cp   h
            jr   z,.OY2
            jr   c,.OY2
            rra
            jp   $-6
.OY2
            bit  7,e
            jr   nz,$+4
            neg
            add  a,d
            ld   (ix+GAMA),a
            ret

TURNUP:
            pop  bc
            pop  de
            pop  hl
            ld   a,(ix+MODE)
            ld   (ix+PMODE),a
            ld   a,r
            and  #0F
            add  a,5
            ld   (ix+POWOR),a
            ld   (ix+MODE),C_TURNOUT
            ld   bc,#8080
            ret


CheckPolicePair:                ; orig: CHNPOL - не менее двух полицейских на нападающего
; Проверка на наличие не менее двух
; полицейских на нападающего
            ld   b,0
            ld   hl,CARSB-OLEN+1
            ld   de,OLEN
            jp   $+10
            dec  l
            ld   a,(hl)
            cp   #80
            jr   z,.ECN1
            inc  l
.ECN2
            add  hl,de
            ld   a,(hl)
            cp   #80
            jr   z,$-11
            ld   a,l
            ld   c,a
            add  a,TYPE-1
            ld   l,a
            ld   a,(hl)
            cp   T_POLICE
            ld   l,c
            jr   nz,.ECN2
            ld   a,l
            add  a,MODE-1
            ld   l,a
            ld   a,(hl)
            cp   C_FIGHT
            ld   l,c
            jr   nz,.ECN2
            ld   a,l
            add  a,SUBJ-1
            ld   l,a
            ld   a,(hl)
            cp   (ix+RAND)
            ld   l,c
            jr   nz,.ECN2
            inc  b
            ld   a,b
            cp   2
            jr   c,.ECN2
.ECN1
            ld   a,b
            cp   2
            ret


MoveMissiles:                   ; orig: CHARCO - изменение координат ракет
; Изменение координат ракет
            SUB_BC
            ld   d,h
            ld   e,l
            jp   p,$+10
            NEGDE

            ld   a,d
            cp   1
            ld   a,ROKSPD
            jr   nc,.RSP1
            ld   a,e
            srl  d
            rra
            srl  d
            rra
            srl  a
.RSP1
            ld   e,a
            ld   d,0
            bit  7,h
            jr   nz,$+9
            NEGDE
            add  hl,de
            ld   a,h
            add  hl,bc
            ACPL_A
            exx
            or   c
            ld   c,a
            exx
            ret

HitStatusTable:                 ; orig: STABL - таблица индексирования статуса при попадании
; Таблица индексирование статуса при
; попадании в опр. объект
            db   #FA,10,15,18,9,#FA,#FA,#FA,6
            ds   7,0

PlayerHit:                      ; orig: SHUT - регистрация попадания игрока в объект
; Регистрация попадания игрока в объект
;  адрес объекта
            ld   hl,0
            ld   a,l
            or   h
; Не было попадания
            ret  z
            ld   bc,ACTN
            add  hl,bc
; Выстрел лазером
            set  0,(hl)
            dec  hl
            ld   c,(hl)
; В сномер того с которым имел дело
; объект до этого
            ld   (hl),SPLAYER
            ld   a,l
            add  a,TYPE-SUBJ
            ld   l,a
; Тип объекта
            ld   b,(hl)
            ld   hl,0
            ld   (PlayerHit+1),hl
; Звук попадания
            ld   hl,EFF21
            ld   (SFXA+1),hl
            ld   a,c
            cp   SPLAYER
; Если предыдущий был игрок
            ret  z
CHSTAT_:
; Меняем статус
            ld   a,b
            cp   #10
; Если это просто объекты
            ret  nc
            ld   l,b
            ld   h,0
            ld   bc,HitStatusTable
            add  hl,bc
            ld   c,(hl)
; По типу из таблицы взяли индексирование
; статуса
ChangeStatus:                   ; orig: CHSTATUS - смена статуса игрока
            ld   a,(STATGEN)
            and  a
            jr   z,$+10
            ld   a,c
            and  a
            jp   m,$+6
            add  a,10
            ld   c,a
            ld   a,(STATUS)
            ld   b,a
            add  a,c
            jp   po,$+6
            sub  c
            ld   a,#7F
            jp   p,$+4
            xor  a
            ld   c,a
            ld   a,b
            cp   32
            jr   nc,$+4
            set  5,c
            ld   a,c
            ld   (STATUS),a
            ret


DrawPlayerLaser:                ; orig: FLINE - рисование лазера игрока
; Рисование лазера игрока
            ld   a,0
PSTLI:      add  a,50
            ld   ($-3),a
            ret  nc
            ld   a,(PEREGREV+1)
            cp   2
            ret  c
            sub  2
            ld   (PEREGREV+1),a
            ld   a,1
            ld   (FFIRE+1),a
            xor  a
            ld   (FLL+1),a
            ld   hl,EFF2
            ld   (SFXA+1),hl
            ld   hl,#38A9
            ld   a,low(MASKS)
            ld   (L91+#4E),hl
            ld   (LDADD),a
            ld   a,r
            ld   c,a
            and  1
            bit  4,c
            jr   z,$+4
            neg
            ld   e,a
            ld   a,(PCORD)
            add  a,8
            add  a,e
            ld   e,a
            ld   a,r
            ld   c,a
            and  1
            bit  4,c
            jr   z,$+4
            neg
            ld   d,a
            ld   a,(PCORD+1)
            add  a,6
            add  a,d
            ld   d,a
            push de
            ld   hl,#5F40
            call DRAWL1
            ld   hl,#5FC0
            pop  de
            jp   DRAWL1


DropCargo:                      ; orig: DROPCARGO - бросить груз
; Бросить груз
            ld   a,(ix+SETUP)
            ld   c,a
            and  3
            ret  z
            dec  a
            ld   b,a
            ld   a,c
            and  %11111100
            or   b
            ld   (ix+SETUP),a

            ld   a,r
            ld   h,a
            and  #1F
            cp   27
            jr   c,$+4
            sub  5
            ld   l,a                ;TYPE
            cp   %00000101
            jr   nc,$+4
            set  7,l
            ld   a,h
            and  %01110000
            rrca
            rrca
            rrca
            rrca
            inc  a                  ;TONS


SpawnCargo:                     ; orig: NEWCARGO - создать контейнер с грузом или мину
;a-TONNS,l(0-6 BITS)-TYPE OF TOWAR
;7 bitl- 1-MINA, 0-CARGO
            ld   b,l
            ex   af,af'
            call FindFreeSlot
            ret  z
            exx
            ld   l,(ix+0)
            ld   h,(ix+1)
            ld   de,200
            add  hl,de
            ld   (iy+0),l
            ld   (iy+1),h
            ld   l,(ix+2)
            ld   h,(ix+3)
            add  hl,de
            ld   (iy+2),l
            ld   (iy+3),h
            ld   l,(ix+4)
            ld   h,(ix+5)
            add  hl,de
            ld   (iy+4),l
            ld   (iy+5),h
            ld   (iy+INDI),ICRG
            ld   (iy+MODE),C_FLYFREE
            ld   (iy+SUBJ),#FF
            ld   (iy+ACTN),0
            ld   a,(ix+ALFA)
            ld   (iy+RAND),a
            ld   a,(ix+BETA)
            ld   (iy+RAND+1),a
            ld   a,(ix+GAMA)
            ld   (iy+MSPD),a

            ld   a,(ix+RSPD)
            sub  30
            jr   nc,$+3
            xor  a
            cp   70
            jr   c,$+4
            ld   a,69

            ld   (iy+RSPD),a
            ex   af,af'
            ld   (iy+LZS),a         ;TONNS
            ld   (iy+TYPE),T_CARGO
            ld   (iy+ENERGY),20
            exx
            bit  7,b
            ld   a,#10
            jr   nz,$+3
            xor  a
            ld   (iy+SETUP),a
            res  7,b
            ld   (iy+TOWR),b

; Заносим грузы в отд. буфер
            call ObjIndexFromHL
            ld   e,a
            ld   hl,CARGS-1
.NXTCA
            inc  hl
            ld   a,(hl)
            cp   #FE
            jr   c,.CHCA
            ret  z
            ld   (hl),e
            ret


.CHCA
; Проверка груза на существование
            exx
            call ObjAddrFromIndex
            inc  l
            ld   a,(hl)
            cp   #80
            exx
            jp   nz,.NXTCA
            ld   (hl),e
            ret

NewOrder:                       ; orig: NEWORD - новое задание в зависимости от типа
; Новое задание в зависимости от типа
            ld   a,(ix+TYPE)
            sla  a
            ld   l,a
            ld   h,0
            ld   bc,INTEL
            add  hl,bc
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            jp   (hl)
INTEL:
            dw   PIRAT
            dw   TRADE
            dw   ARMY_
            dw   POLIC
            dw   HUNTE
            dw   UPIRA
            dw   UUFO_
            dw   UFO__
            dw   OTSHE
            dw   MIKR_
            rept 16
            dw   NOTHING
            endr

NOTHING:
            ret
UPIRA:
            call TOSUBJ
            ret  nz
            ld   (ix+MODE),C_GOPLANET
            call RND
            ld   a,h
            or   l
            ret  nz
            jp   TOPEACE
OTSHE:
            call TOSUBJ
            ret  nz
            ld   (ix+MODE),C_GOASTER
            call RND
            ld   a,r
            and  h
            or   l
            ret  nz
            jp   TOPEACE
ARMY_:
            call TOSUBJ
            ret  nz
            ld   a,r
            cp   #70
            ld   (ix+MODE),C_FIGHT
            ld   (ix+SUBJ),#FF
            ret  c
TOUFO:
            call TOSUBJ
            ret  nz
            call FindUfo
            ret  z
            ld   (ix+SUBJ),a
            ret
UFO__:
            call TOSUBJ
            ret  nz
            ld   a,r
            cp   #70
            ld   (ix+MODE),C_FIGHT
            ld   (ix+SUBJ),#FF
            ret  c
            call FindAnyNotUfo
            ret  z
            ld   (ix+SUBJ),a
            ret
UUFO_:
            call TOSUBJ
            ret  nz
            ld   (ix+MODE),C_GOPLANET
            call RND
            ld   a,r
            and  h
            or   l
            jp   nz,TOPEACE
            jp   TOUFO

TRADE:
            call TOSUBJ
            ret  nz
            ld   (ix+MODE),C_GOPLANET
            call RND
            ld   a,r
            and  h
            or   l
            ret  nz
            call TOPEACE
            ret  z
            ld   (ix+TYPE),T_PIRAT
            ret

HUNTE:
            call TOSUBJ
            ret  nz
            ld   a,r
            cp   #70
            ld   (ix+MODE),C_FIGHT
            ld   (ix+SUBJ),#FF
            ret  c
            call FindPirate
            ret  z
            ld   (ix+SUBJ),a
            ret
MIKR_:
            ld   a,(ix+OMODE)
            cp   C_BACKTOASTER
            jr   nz,$+6
; Смена задания на подзадание
            ld   (ix+MODE),a
            ret
            ld   a,r
            cp   #70
            ld   (ix+MODE),C_GOPLANET
            ld   (ix+SUBJ),#FF
            ret
POLIC:
            call TOSUBJ
            ret  nz
            ld   a,r
PWNPP:      cp   6
            ld   (ix+MODE),C_FIGHT
            ld   (ix+SUBJ),#FF
            jr   c,.POLIC2
            call FindPirate
            ret  z
            ld   (ix+SUBJ),a
            ret

; Проверка статуса игрока
.POLIC2
            ld   a,(STATUS)
            cp   64                 ;Розыскиваемый
            ret  c
            push af
            call RNDL1
            pop  af
            cp   l
            ret  c
            ld   a,h
            cp   3
            ret  nc
            ld   (ix+SUBJ),SPLAYER
            ret
PIRAT:
            call TOSUBJ
            ret  nz
            ld   a,r
PWNPM:      cp   #70
            ld   (ix+MODE),C_FIGHT
TOPEACE:
            ld   (ix+SUBJ),#FF
            ret  c
            call FindPeaceful
            ret  z
            ld   (ix+SUBJ),a
            ld   (ix+MODE),C_FIGHT
            ret


TOSUBJ:
; Если есть субъект которого надо атаковать
; то вернуться к нему
            ld   a,(ix+OSUBJ)
            inc  a
            ret  z
            dec  a
            ld   (ix+SUBJ),a
            ld   (ix+MODE),C_FIGHT
            ret


DATAL_:
            ex   af,af'
            PAGE_ CONTR
            ex   af,af'
            call DATAL
            PAGE___NOARG
            ret

DrawDataLines:                  ; orig: DATALINES - вызов рисования даталиний
; Вызов рисования даталиний
FSHILD:     ld   a,0
            and  a
            jr   z,FFUEL
            ld   a,(SHILD)
            ld   hl,#49A1
            call DATAL_
            xor  a
            ld   (FSHILD+1),a

FFUEL:      ld   a,0
            and  a
            jr   z,FFIRE
            call AFUEL
            rra
            ld   hl,#49E1
            call DATAL_

FFIRE:      ld   a,0
            and  a
            jr   z,FTEMPE
            ld   a,(PEREGREV+1)
            ld   hl,#5121
            call DATAL_
            xor  a
            ld   (FFIRE+1),a
FTEMPE:     ld   a,0
            and  a
            jr   z,FHIGH
TEMPE:      ld   a,0
            ld   hl,#5181
            call DATAL_
            xor  a
            ld   (FTEMPE+1),a
FHIGH:      ld   a,0
            and  a
            jr   z,$+14
HIGH_:      ld   a,0
            ld   hl,#51C1
            call DATAL_
            xor  a
            ld   (FHIGH+1),a
FSPEED:     ld   a,0
            and  a
            jr   z,.FSPD
            xor  a
            ld   (FSPEED+1),a
            ld   hl,(Speed)
            ABSHL
            ld   a,h
            srl  a
            rr   l
            srl  a
            rr   l
            and  a
            jr   z,$+4
            ld   l,46
            ld   a,l
            cp   47
            jr   c,$+4
            ld   l,46
            ld   a,l
            ld   hl,#49B9
            call DATAL_
.FSPD
            ret


MVSTT:
            ld   hl,(SSX)
            ld   a,(SSX+2)
            ld   de,(STPX+1)
            bit  7,d
            ld   c,0
            jr   z,$+3
            dec  c
            SUB_DE
            ld   (SSX),hl
            sbc  a,c
            ret  pe
            ld   (SSX+2),a
            ld   hl,(SSY)
            ld   a,(SSY+2)
            ld   de,(STPY+1)
            bit  7,d
            ld   c,0
            jr   z,$+3
            dec  c
            SUB_DE
            ld   (SSY),hl
            sbc  a,c
            ret  pe
            ld   (SSY+2),a
            ld   hl,(SSZ)
            ld   de,(STPZ+1)
            ld   a,(SSZ+2)
            bit  7,d
            ld   c,0
            jr   z,$+3
            dec  c
            SUB_DE
            ld   (SSZ),hl
            sbc  a,c
            ret  pe
            ld   (SSZ+2),a
            ret


NewSun:                         ; orig: NWSUN - новое солнце
;NEW SUN
            ld   a,(NOSUN)
            cp   2
            ret  z
            ld   a,1
            ld   (NOSUN),a
            ld   hl,#1527
            ld   (SDL9),hl
            ld   a,#13
            ld   (SDL9+2),a
            ld   a,#FF
            ld   (GNUM+1),a

MakeBlackHole:                  ; orig: BLACKSUN - генерация чёрной дыры
; Генерация черной дыры
            call RNDL9
            ld   a,h
            cp   #87
            jp   nz,MVPLN
            ld   a,l
            cp   #46
            jp   nz,MVPLN
            ld   a,2
            ld   (NOSUN),a
            ld   hl,#6000
            ld   (SNX+1),hl
            ld   (SNY+1),hl
            ld   (SNZ+1),hl
            jp   MVPLN


BlackHoleControl:               ; orig: SUNB - управление чёрной дырой
; Управление черной дырой
            ld   hl,(SNX+1)
            ld   bc,0-#30
            add  hl,bc
            ld   (SNX+1),hl
            ld   hl,(SNZ+1)
            add  hl,bc
            ld   (SNZ+1),hl
            ld   hl,(SNY+1)
            add  hl,bc
            ld   (SNY+1),hl
            jp   SSUN


MoveSun:                        ; orig: MVSUN - управление звездой, изменение координат
; Управление звездой изменение ее
; координат
            ld   hl,#8000
            srl  h
            rr   l
            ld   ($-6),hl
            jp   nc,MVPLN
; Если можно менять
            rr   h
            ld   (MoveSun+1),hl
            ld   a,(NOSUN)
            dec  a
; Если на генерацию черной дыры
            jr   z,MakeBlackHole
            dec  a
; Если текущая звезда черная
            jr   z,BlackHoleControl
SSUN:
            ld   hl,(SNX)
            ld   a,(SNX+2)
            ld   de,(STPX+1)
            bit  7,d
            ld   c,0
            jr   z,$+3
            dec  c
            SUB_DE
            ld   (SNX),hl
            sbc  a,c
            jp   pe,NewSun
            ld   (SNX+2),a
            ld   hl,(SNY)
            ld   a,(SNY+2)
            ld   de,(STPY+1)
            bit  7,d
            ld   c,0
            jr   z,$+3
            dec  c
            SUB_DE
            ld   (SNY),hl
            sbc  a,c
            jp   pe,NewSun
            ld   (SNY+2),a
            ld   hl,(SNZ)
            ld   de,(STPZ+1)
            ld   a,(SNZ+2)
            bit  7,d
            ld   c,0
            jr   z,$+3
            dec  c
            SUB_DE
            ld   (SNZ),hl
            sbc  a,c
            jp   pe,NewSun
            ld   (SNZ+2),a
; Мерим расстояние для изменения
; температуры
            call NearestSunDistance
            ld   a,l
            and  a
; Слишком далеко
            jr   nz,.MSL1
            ld   hl,(SNX+1)
            bit  7,h
            ld   a,l
            jr   z,$+4
            neg
            ld   e,a
            ld   hl,(SNY+1)
            bit  7,h
            ld   a,l
            jr   z,$+4
            neg
            cp   e
            jr   c,$+3
            ld   e,a
            ld   hl,(SNZ+1)
            bit  7,h
            ld   a,l
            jr   z,$+4
            neg
            cp   e
            jr   c,$+3
            ld   e,a
; Меняем темпертуру
            ld   a,e
            neg
            srl  a
            cp   47
            jr   c,$+4
            ld   a,46
            ld   (TEMPE+1),a
            ld   a,1
            ld   (FTEMPE+1),a
; Подзарядка топлива
            ld   a,(SZAPRAW)
            inc  a
            ret  z
; Если оснащение заправки есть
            ld   a,#80
            rrca
            ld   ($-2),a
            jp   nc,MVPLN
            call AFUEL
            inc  a
            ld   c,a
            ld   de,(TONN)
            inc  e
            ld   a,d
            cp   e
            jr   c,.JKL1
            ld   (TONN),de
            ld   (hl),c
.JKL1
            ld   a,1
            ld   (FFUEL+1),a
            jp   MVPLN
.MSL1
; Если звезда вышла за пределы изменения
; температуры то ставим ее вегда 0
            ld   a,(TEMPE+1)
            and  a
            jr   z,$+9
            ld   (FTEMPE+1),a
            xor  a
            ld   (TEMPE+1),a
            ld   a,l
            cp   28
            jr   c,MSL3
            sub  27
GNUM_:      add  a,0
            jr   nc,$+4
            ld   a,#FF
            ld   (GNUM+1),a
MSL3:
            ld   a,l
            cp   #40
            jp   c,MVPLN
            ld   a,(NOSUN)
            cp   2
            jp   nz,NewSun

; Изменение координат планет
MVPLN:

KOLPLANET:  ld   a,0
            or   a
            ret  z

            push af

            ld   hl,(STPX+1)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   a,h
            or   l
            jr   nz,$+3
            inc  l
            ld   (ssX+1),hl
            ld   hl,(STPY+1)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   a,h
            or   l
            jr   nz,$+3
            inc  l
            ld   (ssY+1),hl
            ld   hl,(STPZ+1)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   a,h
            or   l
            jr   nz,$+3
            inc  l
            ld   (ssZ+1),hl

            pop  af

            ld   iy,PLANETES
KP:
            ex   af,af'
            ld   l,(iy)
            ld   h,(iy+1)
ssX:        ld   de,0
            bit  7,d
            ld   bc,0
            jr   z,$+3
            dec  bc
            SUB_DE
            ld   (iy),l
            ld   (iy+1),h
            ld   l,(iy+2)
            ld   h,(iy+3)
            sbc  hl,bc
            ld   (iy+2),l
            ld   (iy+3),h
            ld   l,(iy+4)
            ld   h,(iy+5)
ssY:        ld   de,0
            bit  7,d
            ld   bc,0
            jr   z,$+3
            dec  bc
            SUB_DE
            ld   (iy+4),l
            ld   (iy+5),h
            ld   l,(iy+6)
            ld   h,(iy+7)
            sbc  hl,bc
            ld   (iy+6),l
            ld   (iy+7),h
            ld   l,(iy+8)
            ld   h,(iy+9)
ssZ:        ld   de,0
            bit  7,d
            ld   bc,0
            jr   z,$+3
            dec  bc
            SUB_DE
            ld   (iy+8),l
            ld   (iy+9),h
            ld   l,(iy+10)
            ld   h,(iy+11)
            sbc  hl,bc
            ld   (iy+10),l
            ld   (iy+11),h
            ld   bc,12
            add  iy,bc
            ex   af,af'
            dec  a
            jp   nz,KP

; Изменение высоты к планете
KP2:
            call PlanetDistance
            ld   a,l
            and  a
            jr   nz,.MSL2
; Изменяем высоту
            ld   a,h
            neg
            srl  a
            cp   47
            jr   c,$+4
            ld   a,46
            ld   (HIGH_+1),a
            ld   a,1
            ld   (FHIGH+1),a
            ret
.MSL2
            ld   a,(HIGH_+1)
            and  a
            jr   z,$+9
            ld   (FHIGH+1),a
            xor  a
            ld   (HIGH_+1),a

            ld   a,(PLANET)
            cp   e
            ret  z
            ld   a,e
            ld   (PLANET),a
            PAGE_ CONTR
            jp   SETIT


; Проверка совпадения системы нахождения
; и системы перелета
;retFZ-ON если совпадают
SIMILARSYS:
            ld   hl,(PLACE)
            ld   de,(WHERE)
            SUB_DE
            ret  nz
            ld   hl,(PLACE+2)
            ld   de,(WHERE+2)
            SUB_DE
            ret


NearestSunDistance:             ; orig: FARSUN - наименьшее расстояние от игрока до солнца
; Возвращает в lнаименьшее расстояние от
; игрока до солнца
            ld   a,(SNX+2)
            ACPL_A
            ld   l,a
            ld   a,(SNY+2)
            ACPL_A
            cp   l
            jr   c,$+3
            ld   l,a
            ld   a,(SNZ+2)
            ACPL_A
            cp   l
            jr   c,$+3
            ld   l,a
            ret


PlanetDistance:                 ; orig: FAREAR - расстояние от игрока до ближайшей планеты
; Возвращает в lнаибольшее расстояние от
; игрока до ближайшей планеты в старшем
; байте
; в hвозвр. наименьшее раст. в младшем
; байте
; в евозвр. номер планеты к которой ближе
            ld   a,(KOLPLANET+1)
            or   a
            ld   l,#7F
            ret  z
            push iy
            ld   b,a
            ld   iy,PLANETES
            ld   de,12
FE3:
            call VISPLAN
            jr   c,FE2
FE1:
            add  iy,de
            djnz FE3
            ld   l,#7F
            pop  iy
            ret
FE2:
            ld   e,(iy+1)
            ld   d,(iy+2)
            bit  7,(iy+3)
            jr   z,$+8
            ld   a,d
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            ld   l,d
            ld   h,e
            ld   e,(iy+5)
            ld   d,(iy+6)
            bit  7,(iy+7)
            jr   z,$+8
            ld   a,d
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            ld   a,d
            cp   l
            jr   c,$+4
            ld   l,a
            ld   h,e
            ld   e,(iy+9)
            ld   d,(iy+10)
            bit  7,(iy+11)
            jr   z,$+8
            ld   a,d
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            ld   a,d
            cp   l
            jr   c,$+4
            ld   l,a
            ld   h,e
            ld   a,(KOLPLANET+1)
            sub  b
            ld   e,a
            pop  iy
            ret


; Процедура проверки видения планеты
; по координатам
;retFC-ON если видима
VISPLAN:
            ld   h,(iy+3)
            ld   l,(iy+2)
            bit  7,h
            jr   z,$+8
            ld   a,h
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            ld   a,h
            or   a
            ret  nz
            ld   a,l
            cp   FARPLAN
            ret  nc
            ld   h,(iy+7)
            ld   l,(iy+6)
            bit  7,h
            jr   z,$+8
            ld   a,h
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            ld   a,h
            or   a
            ret  nz
            ld   a,l
            cp   FARPLAN
            ret  nc
            ld   h,(iy+11)
            ld   l,(iy+10)
            bit  7,h
            jr   z,$+8
            ld   a,h
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            ld   a,h
            or   a
            ret  nz
            ld   a,l
            cp   FARPLAN
            ret


; Процедура подготовки вывода планеты
; и звезды
DrawSun:                        ; orig: OUTSUN - вывод солнца
            ld   hl,SNX
            ld   de,SUNX
            rept 9
            ldi
            endr
            ld   hl,(SUNX+1)
            ld   (DX+1),hl
            ld   hl,(SUNY+1)
            ld   (DY+1),hl
            ld   hl,(SUNZ+1)
            ld   (DZ+1),hl
            ld   (STK9+1),sp
            xor  a
            ld   (SUNX),a
            ld   (SUNY),a
            ld   (SUNZ),a
            ld   iy,$+7
            jp   CALCRCORD
STK9:       ld   sp,0
            ret  pe
            ld   hl,(TX+1)
            ld   a,h
            ld   (STX),a
            bit  7,h
            jr   z,$+11
            NEGHL
            set  7,h
            ld   (SUNX+1),hl
            ld   hl,(TY+1)
            ld   a,h
            ld   (STY),a
            cpl
            ld   h,a
            ld   a,l
            cpl
            ld   l,a
            inc  hl
            bit  7,h
            jr   z,$+11
            NEGHL
            set  7,h
            ld   (SUNY+1),hl
            ld   hl,(TZ+1)
            ld   a,h
            ld   (STZ),a
            bit  7,h
            jr   z,$+11
            NEGHL
            set  7,h
            ld   (SUNZ+1),hl
            ld   a,(NOSUN)
            cp   2
            ld   de,#0000
            jr   nz,$+4
            ld   e,#FF
            PAGE_ CONTR
            call CIRCLE
            PAGE___NOARG
            ret


; Вывод планеты и настройка координат
; компаса планеты на выбранную
DrawPlanet:                     ; orig: OUTEAR - вывод планеты
            ld   a,#80
            ld   (ETX),a
            ld   (ETY),a
            ld   (ETZ),a

            ld   a,(KOLPLANET+1)
            or   a
            ret  z
; Если есть планеты в системе
            ld   b,a
            call SIMILARSYS
            ld   a,(WPLANET)
            jr   z,$+4
            ld   a,#FE
            inc  a
            ld   c,a
            push iy
            ld   iy,PLANETES
            ld   de,12
OE2:
            call VISPLAN
            jr   nc,OE4
            push de
            push iy
            push bc
            call OE1
            call OE5
OE6:
            pop  bc
            pop  iy
            pop  de
            dec  c
            jr   nz,.OE7
; Настройка координат компаса на выбранную
; планету
            ld   a,(TX+2)
            ld   (ETX),a
            ld   a,(TY+2)
            ld   (ETY),a
            ld   a,(TZ+2)
            ld   (ETZ),a
.OE7
            add  iy,de
            djnz OE2
            pop  iy
            ret

OE4:
            push de
            push iy
            push bc
            ld   b,(iy+3)
            ld   h,(iy+2)
            ld   l,(iy+1)
            ld   a,(iy)
            rept 4
            sra  b
            rr   h
            rr   l
            rra
            endr
            ld   (SUNX),a
            ld   (SUNX+1),hl
            ld   b,(iy+7)
            ld   h,(iy+6)
            ld   l,(iy+5)
            ld   a,(iy+4)
            rept 4
            sra  b
            rr   h
            rr   l
            rra
            endr
            ld   (SUNY),a
            ld   (SUNY+1),hl
            ld   b,(iy+11)
            ld   h,(iy+10)
            ld   l,(iy+9)
            ld   a,(iy+8)
            rept 4
            sra  b
            rr   h
            rr   l
            rra
            endr
            ld   (SUNZ),a
            ld   (SUNZ+1),hl
            call OE3
            jp   OE6

; Пересчет координат круга планеты
OE1:
            push iy
            pop  hl
            ld   de,SUNX
            ldi
            ldi
            ldi
            inc  hl
            ldi
            ldi
            ldi
            inc  hl
            ldi
            ldi
            ldi
OE3:
            ld   hl,(SUNX+1)
            ld   (DX+1),hl
            ld   hl,(SUNY+1)
            ld   (DY+1),hl
            ld   hl,(SUNZ+1)
            ld   (DZ+1),hl
            ld   (STK10+1),sp
            xor  a
            ld   (SUNX),a
            ld   (SUNY),a
            ld   (SUNZ),a
            ld   iy,$+7
            jp   CALCRCORD
STK10:      ld   sp,0
            ret  pe

            ld   hl,(TX+1)
            bit  7,h
            jr   z,$+11
            NEGHL
            set  7,h
            ld   (SUNX+1),hl
            ld   hl,(TY+1)
            bit  7,h
            set  7,h
            jr   z,$+9
            NEGHL
            ld   (SUNY+1),hl
            ld   hl,(TZ+1)
            bit  7,h
            jr   z,$+11
            NEGHL
            set  7,h
            ld   (SUNZ+1),hl
            ret

; Вывод круга планеты
OE5:
            ld   de,#FFAA
            PAGE_ CONTR
            call CIRCLE
            PAGE___NOARG
            ret


; Настройка координат компаса на станцию
STATCOMPOS:
            ld   a,(NOSTAT)
            or   a
            ret  nz

            ld   hl,(SSX+1)
            ld   (DX+1),hl
            ld   hl,(SSY+1)
            ld   (DY+1),hl
            ld   hl,(SSZ+1)
            ld   (DZ+1),hl
            ld   (STK11+1),sp
            ld   iy,$+7
            jp   CALCRCORD
STK11:      ld   sp,0
            ret  pe
            ld   hl,(TX+1)
            ld   a,l
            sra  h
            rra
            sra  h
            rra
            ld   (TTX),a
            ld   hl,(TY+1)
            ld   a,l
            sra  h
            rra
            sra  h
            rra
            ld   (TTY),a
            ld   a,(TZ+2)
            ld   (TTZ),a
            ret


GenAllStars:                    ; orig: GGALD - генерация всех звёзд
; Генерить все звезды
            PAGE_ CONTR
            call GALD
            PAGE___NOARG
            ret

; Залет в станцию
RETST:
MTRK:       ld   de,0
            PAGE_ CONTR
            call ReturnToStation
            PAGE___NOARG
            ret

NewVoxelSprite:                 ; orig: NEWVSPR - занести в буфер данные о новом воксельном спрайте
; Занесение в буфер данных о новом
; вокснимации
;hl,de,bc-CORDS
;a-TIME,A'-MULTI
;HL'-ADR OF PROC. INIT
            ex   af,af'
            ld   e,a
            PAGE_ VOXAL
            ld   a,e
            ld   iy,VOXCOR-VLEN
            ld   de,$+5
            push de
            jp   (hl)
            PAGE___NOARG
            ret


MoveShipsForward:               ; orig: MOVEON - сдвиг кораблей по движению вперёд
;MOVING SHIPS inFRONT
;de-SPEED
;EYEA_,EYEB_,EYEG_-UNGELS
;retinSTPX_,STPY_,STPZ_
            push ix
            push de
            call ShipMatrix
            pop  de
HM_13:      ld   a,0
            push de
            ld   ix,$+7
            jp   MULADE
            pop  de
            ld   (STPX_+1),hl
HM_23:      ld   a,0
            push de
            ld   ix,$+7
            jp   MULADE
            pop  de
            ld   (STPY_+1),hl
HM_33:      ld   a,0
            ld   ix,$+7
            jp   MULADE
            ld   (STPZ_+1),hl
            pop  ix
            ret


; Вывод взрывов
EXPL:       ld   a,0
            and  a
; Нет ни одного взрыва
            ret  z
; Счетчик кадров взрывов один для всех
CEX:        ld   a,0
            dec  a
            jr   nz,.SV6
; Отключить проработку взрывов
            xor  a
            ld   (EXPL+1),a
.SV6
            ld   (CEX+1),a

; Буфер данных о вокс анимации
            ld   ix,VOXCOR-VLEN
CX22:
            ld   de,VLEN
.CX2
            add  ix,de
            ld   a,(ix+7)
            and  a
            ret  m                  ;Конец буфера
; Пустое место
            jr   z,.CX2
; Уменьшаем время
            dec  (ix+7)
; Координты сместили относительно движения
; глаз
            ld   l,(ix+4)
            ld   h,(ix+5)
            ld   (DZ+1),hl
            ld   bc,(STPZ+1)
            SUB_BC
            ld   (ix+4),l
            ld   (ix+5),h
            ld   l,(ix+0)
            ld   h,(ix+1)
            ld   (DX+1),hl
            ld   bc,(STPX+1)
            SUB_BC
            ld   (ix+0),l
            ld   (ix+1),h
            ld   l,(ix+2)
            ld   h,(ix+3)
            ld   (DY+1),hl
            ld   bc,(STPY+1)
            SUB_BC
            ld   (ix+2),l
            ld   (ix+3),h
            exx
            ld   e,(ix+8)
            ld   d,(ix+9)
; Адрес спрайта
            dec  (ix+12)
            jr   nz,$+17
            ld   a,(ix+13)
            ld   (ix+12),a
            ld   l,(ix+10)
            ld   h,(ix+11)
            jp   $+10
; Ширина в байтах кадра
            ld   l,(ix+14)
            ld   h,(ix+15)
            add  hl,de
; Запомнили адрес след. кадра
            ld   (ix+8),l
            ld   (ix+9),h
            exx
            ld   (STK7+1),sp
            ld   iy,$+7
; Преобразуем по матрице
            jp   CALCRCORD
STK7:       ld   sp,0
; Если переполнение
            jp   pe,CX22
            ld   bc,(TZ+1)
            bit  7,b
; За экраном
            jp   nz,CX22
            ld   a,b
            or   c
; Прямо на нас
            jp   z,CX22
            ld   hl,(TX+1)
            ld   de,(TY+1)
; Масштаб
            ld   a,(ix+6)
            ex   af,af'
            exx
; Размер исходного спрайта
            ld   l,(ix+16)          ;SIZE
            ld   h,(ix+17)
            ld   e,(ix+8)           ;Адрес
            ld   d,(ix+9)           ;Спрайта
            ld   a,l
            exx
            push bc
            srl  a
            ld   c,a
            ld   b,0
            SUB_BC
            push hl
            exx
            ld   a,h
            exx
            srl  a
            ld   c,a
            EXD
            SUB_BC
            EXD
            pop  hl
            pop  bc

            PAGE_ VOXAL
            ex   af,af'
            push ix
            call D3D2
            pop  ix
            PAGE___NOARG
            jp   CX22


GovernmentAt:                   ; orig: GOSTA - государство, в котором находится карта
; Определение государства в котором
; находится карта
; в hl-координаты карты
; возвр. в a-номер государтсвая
; номер 0-федерация галактик
; н     1-конфедерация первых
; н     2-содружество миров
; н     3-свободные земли
            ld   a,h
            cp   74
            jr   c,.NGF1
            cp   78
            jr   nc,.NGF1
            ld   a,l
            cp   54
            jr   c,.NGF1
            cp   58
            ld   a,0                ;Федерция
            ret  c
.NGF1
            ld   a,h
            cp   71
            jr   c,.NGF2
            cp   74
            jr   nc,.NGF2
            ld   a,l
            cp   52
            jr   c,.NGF2
            cp   56
            ld   a,1                ;Содр. миров
            ret  c
.NGF2
            ld   a,h
            cp   71
            ld   a,3
            ret  c
            ld   a,h
            cp   74
            ld   a,3
            ret  nc
            ld   a,l
            cp   56
            ld   a,3
            ret  c
            ld   a,l
            cp   59
            ld   a,2                ;Конфедерация
            ret  c
            ld   a,3                ;Свободные земли
            ret
