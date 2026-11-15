;FRONTBACK


MOVEU:
            call TOUCH
            call ControlsHandler

CALCSTEP:   ld   a,(SM_13+1)
BFC1:       dw   0
            ld   de,(Speed)
            ld   ix,$+7
            jp   MULADE
            ld   (STPX+1),hl
            ld   a,(SM_23+1)
BFC2:       dw   0
            ld   de,(Speed)
            ld   ix,$+7
            jp   MULADE
            ld   (STPY+1),hl
            ld   a,(SM_33+1)
BFC3:       dw   0
            ld   de,(Speed)
            ld   ix,$+7
            jp   MULADE
            ld   (STPZ+1),hl
            ret


TOUCH:
CMODE:      ld   a,0
            and  a
            ret  z
            ld   (FSPEED+1),a
            ld   hl,(Speed)
            ABSHL
            ex   af,af'
            ld   bc,2
            SUB_BC
            ex   af,af'
            jr   z,$+9
            NEGHL
            ex   af,af'
            jr   nc,$+6
            ld   (Speed),hl
            ret
            xor  a
            ld   (CMODE+1),a
            ret
LM1:
            ld   a,1
            ld   (CMODE+1),a
            ld   hl,(STPX+1)
            NEGHL
            ld   (STPX+1),hl
            ld   hl,(STPZ+1)
            NEGHL
            ld   (STPZ+1),hl
            ld   hl,(STPY+1)
            NEGHL
            ld   (STPY+1),hl
            ld   hl,(Speed)
            NEGHL
            sra  h
            rr   l
            inc  hl
            ld   (Speed),hl
            ret


ControlsHandler:                ; orig: SETCONTROL - управление полётом: опрос клавиш

; Управление полетом
; вызов процедур обработки клавиш управлен
; перед входом флаг z(ON) говорит что
; счетчик ожидания перед нажатием др.
; Клавиши пуст, значит можно обработать
; если надо и эту кнопку


; Порты, маски клавиш управления
            ld   ix,SETGD+2
; Адреса процедур обработки клавиш
            ld   de,ADCON-2
            ld   l,KKEYS+1
            ld   c,#FE
.SCL1
            dec  l
            jr   z,JFLAG
            ld   b,(ix+0)
            inc  ix
            inc  ix
            inc  de
            inc  de
            in   a,(c)
            and  (ix-1)
            jr   nz,.SCL1
            push hl
            push de
            push bc
            push ix
            ld   a,(de)
            ld   l,a
            inc  de
            ld   a,(de)
            ld   h,a
            ld   a,(COUNTER+1)
            and  a
            ld   de,$+5
            push de
            jp   (hl)
            pop  ix
            pop  bc
            pop  de
            pop  hl
            jr   .SCL1

; Уберем треши если надо
JFLAG:      ld   a,0
            or   a
JFLAG2:     ld   c,0
            ld   (JFLAG2+1),a
            jr   nz,.JFG
            cp   c
            jr   nc,.JFG
            call KillTrash
            ld   hl,MXSPD
            ld   (SetMaxSpeed+1),hl
            ld   hl,MXSPD
            ld   (Speed),hl
            ld   a,1
            ld   (FSPEED+1),a
.JFG
            xor  a
            ld   (JFLAG+1),a


; Гашение поворотов
NOPWR2:
            ld   a,0
            or   a
            ld   a,0
            ld   (NOPWR2+1),a
            jr   nz,KL3

            ld   a,200
            ld   (RIF1+1),a
            ld   (LEF1+1),a
            ld   a,%10010010
            rrca
            ld   ($-2),a
            jr   nc,KL3
            ld   a,(EYE_B)
            and  a
            jr   z,KL3
            jp   p,.KL
            add  a,1
            jp   m,.KL2
            xor  a
            jp   .KL2
.KL
            sub  1
            jp   p,.KL2
            xor  a
.KL2
            ld   (EYE_B),a
KL3:
            ld   a,0
            or   a
            ld   a,0
            ld   (KL3+1),a
            jr   nz,KL6

            ld   a,200
            ld   (UPP1+1),a
            ld   (DWN1+1),a
            ld   a,%10010010
            rrca
            ld   ($-2),a
            jr   nc,KL6
            ld   a,(EYE_A)
            and  a
            jr   z,KL6
            jp   p,.KL4
            add  a,1
            jp   m,.KL5
            xor  a
            jp   .KL5
.KL4
            sub  1
            jp   p,.KL5
            xor  a
.KL5
            ld   (EYE_A),a
KL6:
            ld   a,0
            or   a
            ld   a,0
            ld   (KL6+1),a
            ret  nz
            ld   a,250
            ld   (LET1+1),a
            ld   (RIT1+1),a
            ld   a,%10010010
            rrca
            ld   ($-2),a
            ret  nc
            ld   a,(EYE_G)
            and  a
            ret  z
            jp   p,.KL7
            add  a,1
            jp   m,.KL8
            xor  a
            jp   .KL8
.KL7
            sub  1
            jp   p,.KL8
            xor  a
.KL8
            ld   (EYE_G),a
            ret


ADCON:
            dw   PitchUp                ;Вверх
            dw   PitchDown              ;Вниз
            dw   TurnLeft              ;Влево
            dw   TurnRight             ;Вправо
            dw   RollLeft              ;Влево крен
            dw   RollRight             ;Вправо крен
            dw   FireButton             ;Лазер
            dw   Throttle                ;Набор скорости
            dw   Brake             ;Сброс скорости
            dw   BORT               ;Бортовой компьютер
            dw   MissileGuidanceMode              ;Наведение ракеты
            dw   CancelTargets            ;Забыть наведения
            dw   LaunchMissile1             ;Пуск ракеты 1
            dw   LaunchMissile2             ;Пуск ракеты 2
            dw   LaunchMissile3             ;Пуск ракеты 3
            dw   PlayerAfterburner          ;Форсаж
            dw   FreeFlightControl        ;Система свободного полета
            dw   ToggleLight        ;Система подсветки
            dw   ReturnSystem          ;Система возврата
            dw   TargetLockToggle             ;Силовой лучь
            dw   AntiMissile            ;Противоракетная система
            dw   DropCargoKey             ;Сброс контейнера
            dw   DropMineKey           ;Сброс мины
            dw   HyperJump              ;Гипер прыжок, +CS к звезде
            dw   DROPDROID          ;Выпуск дроида
            dw   FrontBackView          ;Передний и задний вид


;---------------------------------------
; Блок обработки клавиш контроля


DROPDROID:
            ret

;-------------------------
; Блок обработки ракет

LaunchMissile1:                 ; orig: LAUNG1 - пуск ракеты 1
; Пуск ракеты 1
; если пауса еще не прощла
            ret  nz
            ld   a,(ROKETN1)
            call RTN1
; Если нет цели или нет ракет
            ret  z
            ld   a,(ROKETN1)
            ld   c,a
            ld   a,#FF
            ld   (ROKETN1),a
RTN2:
            ld   hl,EFF13
            ld   (SFXA+1),hl
            call NewMissile
; Если нет цели или
            ret  nc
            ld   hl,0-SUBJ+TYPE
            add  hl,de
            ld   b,(hl)
            call CHSTAT_
            call AROKS
            jp   RAIN

LaunchMissile2:                 ; orig: LAUNG2 - пуск ракеты 2
; Пуск ракеты 1
            ret  nz
            ld   a,(ROKETN2)
            call RTN1
            ret  z
            ld   a,(ROKETN2)
            ld   c,a
            ld   a,#FF
            ld   (ROKETN2),a
            jr   RTN2

LaunchMissile3:                 ; orig: LAUNG3 - пуск ракеты 3
; Пуск ракеты 1
            ret  nz
            ld   a,(ROKETN3)
            call RTN1
            ret  z
            ld   a,(ROKETN3)
            ld   c,a
            ld   a,#FF
            ld   (ROKETN3),a
            jr   RTN2

ShowNoTarget:                   ; orig: NOCELS - сообщение "нет цели"
; Вывод сообщения "нет цели"
            MESAG _NOTARGET
            ret
RTN1:
; Проверка на нетрокет и на нет цели
            inc  a
            jr   z,ShowNoTarget
            ld   a,5
            ld   (COUNTER+1),a
            call AROKS
            and  a
            ret  nz
            ld   a,#FF
            ld   (ROKETN3),a
            ld   (ROKETN2),a
            ld   (ROKETN1),a
            MESAG _NOROKET
            xor  a
            ret
RAIN:
; Пуск ракеты и вывод сообщений
            dec  (hl)
            ld   a,(TONN)
            dec  a
            ld   (TONN),a
; Ракета ушла
            MESAG _ROKETGO
; Осталось
            MESAG _HAVE
            call AROKS
            call PrintNumbersInOrder
; Ракет
            MESAG _ROKET
            ret
AROKS:
; Количество ракет
            ld   hl,ROKS+1
            ld   a,(hl)
            and  a
            ret  nz
            dec  hl
            ld   a,(hl)
            ret

; Конец блока обр. ракет
;----------------------------


HyperJump:                      ; orig: HIPER - вызов гиперпрыжка
; Вызов гипер прыжка
; проверка прыжка на систему нахождения
            ld   hl,(FUEL)
            ld   e,0
            ld   a,h
            and  a
            jr   nz,$+6
            ld   e,1
            ld   a,l
            rra
            and  a
            ret  z                  ;Нет топлива
            ld   c,a
            ld   hl,(DALNO)
            ld   a,h
            and  a
            ret  nz                 ;Далеко
            ld   a,c
            cp   l
            ret  c                  ;Мало топлива
            ld   a,l
            and  a
            jr   nz,.HR1
            ld   a,(GDIABLO)
            inc  a
; Если прыжок на тужу звезду
            ret  z
; Если есть дьявол
            ld   a,(PLANET)
            ld   b,a
            ld   a,(WPLANET)
            cp   b
; Если на тужу планету при дьяволе
            ret  z
; Одну тону надо истратить на тужу планету
            inc  l
.HR1
            ld   b,l
            call AFUEL
            ld   a,c
            sub  b
            dec  e
            jr   nz,$+3
            rlca
            ld   (hl),a

            MESAG _HIPER
            PAGE_ CONTR
            ld   b,0
            push bc
            call PRINT
            pop  bc
            djnz $-5

            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,#FF
            out  (c),a

            ld   hl,ZM18
            ld   de,ADHDP
            push de
            ld   bc,ZM20
            ldir
            ret


AntiMissile:                    ; orig: UNROKET - противоракетная система
; Противоракетная система
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   a,5
            ld   (COUNTER+1),a
            MESAG _ANTIROKET
            ld   hl,EFF19
            ld   (SFXA+1),hl
            ld   hl,CARSB-OLEN+1
            ld   de,OLEN
            jp   STU1
STU3:
            dec  l
            ld   a,(hl)
            cp   #80
            ret  z
            inc  l
STU1:
            add  hl,de
            ld   a,(hl)
            cp   #80
            jr   z,STU3
            ld   a,l
            add  a,TYPE-1
            ld   l,a
            ld   c,(hl)
            dec  l
            dec  l
            dec  l
            ld   b,(hl)
            sub  TYPE-1
            ld   l,a
            ld   a,c
            cp   T_ROKET
            jr   nz,STU1
            ld   a,b
            cp   SPLAYER
            jr   nz,STU1
            push ix
            dec  l
            push hl
            pop  ix

; Выстрел лазера
            set  0,(ix+ACTN)
; Прот.ракетная система
            set  3,(ix+ACTN)
; Рисование линии игрока к ракете
            ld   a,(ix+PX+1)
            cp   #80
            scf
            jr   z,.NOANTI
            ld   b,a
            ld   c,(ix+PX)
            ld   l,(ix+PY)
            ld   h,(ix+PY+1)
            ld   e,(ix+PZ)
            ld   d,(ix+PZ+1)
            exx
            ld   bc,3
            ld   (TX+1),bc
            ld   (DX+1),bc
            ld   (DY+1),bc
            ld   (DZ+1),bc
            ld   hl,#B0
            ld   (TY+1),hl
            ld   de,0-1
            ld   (TZ+1),de
            call FG1
.NOANTI
            pop  ix
            ret


CancelTargets:                  ; orig: CLRMARK - отмена захвата целей
; Отменить захват целей
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   a,7
            ld   (COUNTER+1),a
            ld   hl,EFF13
            ld   (SFXA+1),hl
            ld   a,#FF
            ld   (ROKETN1),a
            ld   (ROKETN2),a
            ld   (ROKETN3),a
            MESAG _TARGETOFF
            ret


MissileGuidanceMode:            ; orig: NAVOD - режим наведения ракеты
; Режим наведения ракеты
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   hl,EFF13
            ld   (SFXA+1),hl
            ld   a,7
            ld   (COUNTER+1),a
NAVOD_:
            ld   a,(FNAVOD+1)
            xor  1
            ld   (FNAVOD+1),a
            jr   nz,.ZM3
            MESAG _MODEOFF
            jr   .ZM2
.ZM3
            MESAG _MODEON
.ZM2
            MESAG _GETTARGET
            ret


FireButton:                     ; orig: FLINE2 - кнопка FIRE в разных режимах
; Кнопка FIRE в разных режимах
            ld   a,0
            and  a
            jp   z,DrawPlayerLaser
; Захват
            ld   a,(ROKETN1)
            or   a
            ret  m
            call ObjAddrFromIndex
            inc  l
            ld   a,(hl)
            cp   #80
            jr   z,$+11
            ld   a,l
            add  a,MODE-1
            ld   l,a
            ld   a,(hl)
            cp   C_FLYFREE
            jr   z,$+8
            ld   a,#FF
            ld   (ROKETN1),a
            ret
            ld   a,l
            add  a,RSPD-MODE
            ld   l,a
            ld   (hl),0
            sub  RSPD
            ld   l,a
            push hl
            ld   (STKL+1),sp
            ld   sp,hl
            pop  hl
            ld   e,0
            ld   bc,0-50
            ld   a,h
            ACPL_A
            and  a
            jr   nz,$+6
            ld   bc,0
            inc  e

            bit  7,h
            jr   nz,$+6
            add  hl,bc
            jp   $+5
            sbc  hl,bc
            push hl
            inc  sp
            inc  sp
            pop  hl
            ld   bc,0-50
            ld   a,h
            ACPL_A
            and  a
            jr   nz,$+6
            ld   bc,0
            inc  e
            bit  7,h
            jr   nz,$+6
            add  hl,bc
            jp   $+5
            sbc  hl,bc
            push hl
            inc  sp
            inc  sp
            pop  hl
            ld   bc,0-50
            ld   a,h
            ACPL_A
            and  a
            jr   nz,$+6
            ld   bc,0
            inc  e
            bit  7,h
            jr   nz,$+6
            add  hl,bc
            jp   $+5
            sbc  hl,bc
            push hl
STKL:       ld   sp,0
            pop  hl
            ld   a,e
            cp   3
            ret  nz
            ld   a,#FF
            ld   (ROKETN1),a
; Смотрим тонаж, вместим ли
; генерить какой груз был пойман
            push hl
            ld   a,l
            add  a,TYPE
            ld   l,a
            ld   a,(hl)
            cp   T_CARGO
            jr   z,.OKGRU            ;Контейнер
            cp   T_CHIP
; Черный метал если осколок
            ld   e,15
            jr   z,$+4
            ld   e,27               ;Артефакт
            ld   a,r
            and  7
            inc  a
            jr   .OKGRU2
.OKGRU
            ld   a,l
            add  a,TOWR-TYPE
            ld   l,a
            ld   e,(hl)
            add  a,LZS-TOWR
            ld   l,a
            ld   a,(hl)
.OKGRU2
            ld   d,0
            ld   hl,TNN
            add  hl,de

            ld   c,a
            ld   a,(TONN)
            ld   b,a
            ld   a,(hl)
            pop  hl
            and  #C0
            jr   nz,.TNN2
            ld   a,b
            add  a,c
            ld   b,a
            ld   a,(TONN+1)
            cp   b
            ret  c
.TNN2
            push hl
            ld   hl,TWRI
            add  hl,de
            EXD
            pop  hl
            ld   a,(de)
            add  a,c
            cp   201
            ret  nc
            ld   (de),a
            ld   a,b
            ld   (TONN),a
            ld   (hl),0
            inc  l
            ld   (hl),#80
            ld   a,l
            add  a,SETUP-1
            ld   l,a
            bit  4,(hl)
            jr   z,$+7
            ld   hl,ACTION
            set  2,(hl)
            ld   hl,EFF14
            ld   (SFXA+1),hl
            MESAG _TAKING
            ret


TNN:
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   #80                ;KG
            db   #80                ;G
            db   #80                ;KG
            db   0                  ;TN
            db   0                  ;TN
            db   0                  ;TN
            db   #40                ;CHEL
            db   #40                ;CHEL
            db   #40                ;CHEL
            db   #80                ;KG
            db   0                  ;TN


TargetLockToggle:               ; orig: ZAHWAT - вкл/выкл режим захвата цели
; Вкл/выкл режим захвата объекта
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   a,10
            ld   (COUNTER+1),a
            ld   a,(SSILUC)
            inc  a
            ret  z
            ld   hl,EFF13
            ld   (SFXA+1),hl
            ld   a,(FireButton+1)
            xor  1
            ld   (FireButton+1),a
            ld   a,#FF
            ld   (ROKETN1),a
            ld   (ROKETN2),a
            ld   (ROKETN3),a

            jr   z,.ZM4
            MESAG _MODEON
            jr   .ZM5
.ZM4
            MESAG _MODEOFF
.ZM5
            MESAG _POWERRAY
            jp   NAVOD_


ToggleLight:                    ; orig: TURNLIGHTER - переключение подсветки
; Переключение подсветки
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   a,10
            ld   (COUNTER+1),a
            ld   a,(SNAWEDEN)
            inc  a
            ret  z
            ld   a,(PODSWET+1)
            inc  a
            cp   4
            jr   c,$+4
            ld   a,1
            ld   (PODSWET+1),a
            ld   hl,EFF1
            ld   (SFXA+1),hl
            ret


PlayerAfterburner:              ; orig: JUMPDRIVE - форсаж двигателя игрока
; Форсаж двигателя
            ld   a,(CALCSTEP)
            cp   #C9
            ret  z
            ld   a,1
            ld   (JFLAG+1),a
; Проверяем близость других объектов
; если хоть один близко то отмен
            ld   hl,CARSB-OLEN+1
            ld   de,OLEN
            jr   $+9
            dec  l
            ld   a,(hl)
            inc  l
            cp   #80
            jr   z,FUEL_
.JJD1
            add  hl,de
            ld   a,(hl)
            cp   #80
            jr   z,$-11
            ACPL_A
            ld   c,a
            ld   a,l
            add  a,TYPE-1
            ld   l,a
            ld   b,(hl)
            sub  TYPE-1
            ld   l,a
            ld   a,b
            cp   T_STATION
            jr   z,.NXTJ
            cp   T_CHIP
            jr   nc,.JJD1
.NXTJ
            inc  l
            inc  l
            ld   a,(hl)
            ACPL_A
            or   c
            ld   c,a
            inc  l
            inc  l
            ld   a,(hl)
            ACPL_A
            or   c
            ld   c,a
            ld   a,l
            sub  4
            ld   l,a
            ld   a,c
; Мин. расстояние для джампа
            cp   JMIN
            jp   nc,.JJD1
            jp   KillTrash
AFUEL:
            ld   hl,FUEL
            ld   a,(hl)
            and  a
            ret  nz
            inc  hl
            ld   a,(hl)
            ret
FUEL_:
            call AFUEL
            ld   c,a
            dec  c
            jp   m,KillTrash
            ld   a,0
            inc  a
            ld   ($-2),a
            jr   nz,.JKL2
            ld   a,0
            inc  a
            and  7
            ld   ($-4),a
            jr   nz,.JKL2
            ld   (hl),c
            ld   a,(TONN)
            dec  a
            ld   (TONN),a
            ld   a,1
            ld   (FFUEL+1),a
.JKL2
            ld   a,#11
            rrca
            ld   ($-2),a
            jr   nc,$+11
            ld   a,#88
            rrca
            ld   ($-2),a
            call c,InitTrash
            ld   hl,#1000
            ld   (SetMaxSpeed+1),hl
            ld   b,#10
            push bc
            call GAZ_
            pop  bc
            djnz $-5
            ret


FreeFlightControl:              ; orig: FREECONTROL - свободный полёт
; Свободный плет
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   a,20
            ld   (COUNTER+1),a
            ld   a,(SSWPOL)
            inc  a
            ret  z
            ld   hl,(SetMaxSpeed+1)
            ld   bc,MXSPD
            SUB_BC
; Если в режиме джамп
            ret  nz
            ld   hl,EFF13
            ld   (SFXA+1),hl
            ld   a,(CALCSTEP)
            cp   #3A

            jr   z,.ZM6
            MESAG _MODEOFF
            ld   a,#3A
            jr   .ZM7
.ZM6
            MESAG _MODEON
            ld   a,#C9
.ZM7
            ld   (CALCSTEP),a
            MESAG _FREEFLY
            ret


DropCargoKey:                   ; orig: DROPCR - сброс груза
; Сброс груза
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   hl,EFF14
            ld   (SFXA+1),hl
            ld   a,20
            ld   (COUNTER+1),a
            ld   hl,TWRI-1
            ld   b,TKOL
            inc  hl
            ld   a,(hl)
            and  a
            jr   nz,.DC2
            djnz $-5
            MESAG _NOCARGO
            ret
.DC2
            ld   (hl),0
            ld   de,0-TWRI
            add  hl,de
;a-TONNS,l-NUMBER OF TOWAR
            ld   ix,PLAYER
            call SpawnCargo
            MESAG _DROPCARGO
            ret


DropMineKey:                    ; orig: DROPMINE - сброс мины
; Сброс мины
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   hl,EFF14
            ld   (SFXA+1),hl
            ld   a,20
            ld   (COUNTER+1),a
            ld   a,(MINA)
            and  a
            jr   z,.DM1
            dec  a
            ld   (MINA),a
            ld   a,1
            ld   l,#80
            ld   ix,PLAYER
            call SpawnCargo
            MESAG _DROPMINE
            ret
.DM1
            MESAG _NOMINE
            ret


ReturnSystem:                   ; orig: RETURNSYS - система возврата
; Система возврата
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   hl,EFF14
            ld   (SFXA+1),hl
            ld   a,20
            ld   (COUNTER+1),a
            ld   a,(SWOZWR)
            inc  a
            ret  z
            ld   a,#FF
            ld   (SWOZWR),a
            ld   hl,(PLACE)
            ld   (WHERE),hl
            ld   hl,(PLACE+2)
            ld   (WHERE+2),hl
            jp   HyperJump


FrontBackView:                  ; orig: FRONTBACK - задний/передний виды
; Задний передний виды
            ld   a,(COUNTER+1)
            and  a
            ret  nz
            ld   hl,EFF14
            ld   (SFXA+1),hl
            ld   a,20
            ld   (COUNTER+1),a
            call TurnMatrix
            call GenAllStars
            ld   a,(BFC1)
            and  a
            jr   z,.BK1
            ld   hl,0
            ld   (BFC1),hl
            ld   (BFC2),hl
            ld   (BFC3),hl
            MESAG _MODEON
            MESAG _FRONT
            ret
.BK1
            ld   hl,#44ED
            ld   (BFC1),hl
            ld   (BFC2),hl
            ld   (BFC3),hl
            MESAG _MODEON
            MESAG _BACK
            ret


Throttle:                       ; orig: GAZ - прибавить газ
            ld   a,(JFLAG2+1)
            or   a
            ret  nz
GAZ_:
            ld   a,(CALCSTEP)
            cp   #3A
            ret  nz
            ld   hl,(Speed)         ;SPEED
            ld   de,8
            add  hl,de
SetMaxSpeed:   ld   de,MXSPD  ; orig: MAXSPEED - максимальная скорость
            SUB_DE
            add  hl,de
            ret  p
            ld   (Speed),hl
            ld   a,1
            ld   (FSPEED+1),a
            ret


Brake:                          ; orig: TORMOZ - торможение
            ld   a,(CALCSTEP)
            cp   #3A
            ret  nz
            ld   a,(JFLAG2+1)
            and  a
            ret  nz
            ld   hl,(Speed)
            bit  7,h
            ld   de,8
            jr   z,$+5
            bit  4,l
            ret  z

            SUB_DE
            ld   (Speed),hl
            ld   a,1
            ld   (FSPEED+1),a
            ret


RollLeft:                       ; orig: LEFTT - поворот влево
            ld   a,1
            ld   (KL6+1),a
LET1:       ld   a,0
            add  a,94
            ld   (LET1+1),a
            ld   a,200
            ld   (RIT1+1),a
            ret  nc
            ld   a,(EYE_G)          ;UNGLE OF TURN
            sub  1
            jp   m,$+5
            ld   a,#FF
            cp   #100-MANE1
            ret  c
            ld   (EYE_G),a
            ret


RollRight:                      ; orig: RIGHTT - поворот вправо
            ld   a,1
            ld   (KL6+1),a
RIT1:       ld   a,0
            add  a,94
            ld   (RIT1+1),a
            ld   a,200
            ld   (LET1+1),a
            ret  nc
            ld   a,(EYE_G)
            add  a,1
            jp   p,$+5
            ld   a,1
            cp   MANE1+1
            ret  nc
            ld   (EYE_G),a
            ret


TurnLeft:                       ; orig: LEFTF - вращение влево
            ld   a,1
            ld   (NOPWR2+1),a
LEF1:       ld   a,0
            add  a,70
            ld   (LEF1+1),a
            ld   a,200
            ld   (RIF1+1),a
            ret  nc
            ld   a,(EYE_B)          ;UNGLE OF TURN
            sub  1
            jp   m,$+5
            ld   a,#FF
            cp   #100-MANE2
            ret  c
            ld   (EYE_B),a
            ret


TurnRight:                      ; orig: RIGHTF - вращение вправо
            ld   a,1
            ld   (NOPWR2+1),a
RIF1:       ld   a,0
            add  a,70
            ld   (RIF1+1),a
            ld   a,200
            ld   (LEF1+1),a
            ret  nc
            ld   a,(EYE_B)
            add  a,1
            jp   p,$+5
            ld   a,1
            cp   MANE2+1
            ret  nc
            ld   (EYE_B),a
            ret


PitchUp:                        ; orig: UPP - вверх
            ld   a,1
            ld   (KL3+1),a
UPP1:       ld   a,0
            add  a,72
            ld   (UPP1+1),a
            ld   a,200
            ld   (DWN1+1),a
            ret  nc
            ld   a,(EYE_A)          ;UNGLE OF TURN
            sub  1
            jp   m,$+5
            ld   a,#FF
            cp   #100-MANE2
            ret  c
            ld   (EYE_A),a
            ret


PitchDown:                      ; orig: DOWNN - вниз
            ld   a,1
            ld   (KL3+1),a
DWN1:       ld   a,0
            add  a,72
            ld   (DWN1+1),a
            ld   a,200
            ld   (UPP1+1),a
            ret  nc
            ld   a,(EYE_A)
            add  a,1
            jp   p,$+5
            ld   a,1
            cp   MANE2+1
            ret  nc
            ld   (EYE_A),a
            ret
