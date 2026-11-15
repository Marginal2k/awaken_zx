START:
            di

            PAGE_ FREE+8
            ld   hl,#C000
            ld   de,#4000
            ld   bc,#1B00
            ldir
            PAGE___NOARG

; УСТАНОВКА ИНДИКАТОРОВ И ВРЕМЕНИ ПАНЕЛИ
            call REPANEL
            PAGE_ CONTR
; СГЕНЕРИТЬ ТАБЛИЦЫ ВЕРОЯТНОСТЕЙ ДЛЯ
; ДАННОГО СТОЯ И УРОВНЯ ТЕКУЩЕЙ ПЛАНЕТЫ
            call SETIT

; ИНИЦИЯЛИЗАЦИЯ ВСЕХ ЗВЕЗД
            call GGALD

; БОРТКОМПУТЕР СООБГАЕТ
            MESAG _SYSTEMREADY

;              call   SYSSTATUS
            call CYCL
            jr   $-3
CYCL:

; СЧЕТЧИК ДЛЯ ЗАДЕРЖКИ ПЕРЕД ВЫБОРОМ
; ОЧЕРЕДНОЙ ОПЦИИ ПАНЕЛИ
COUNTER:    ld   a,0
            dec  a
            jp   m,$+6
            ld   (COUNTER+1),a
; ГЕНЕРАЦИЯ КОРАБЛЕЙ И ОБЪЕКТОВ
            call GENSHIPS
; ОЧИСТИТЬ ХАЙД
            call CLRHD
            PAGE_ CONTR
; ВЫВОД ЗВЕЗД
            call STARS
; ЧАСЫ
            call TIMER

            PAGE___NOARG
; РАСЧЕТЫ И ВЫВОД 3D
            call REN3D
            call STATCOMPOS

            ld   a,1
            ld   (FLL+1),a
; ЕСЛИ ВЫСОТА КРИТИЧНА ТО КОНЕЦ
            ld   a,(HIGH_+1)
            cp   46

;            jpnc GAMEOVER

; ЕСЛИ ТЕМПЕРАТУРА КРИТИЧНА
            ld   a,(TEMPE+1)
            cp   46

;            jpnc GAMEOVER

; ЕСЛИ ИГРОК СТОЛКНУЛСЯ С КЕМ ЛИБО
            ld   a,(CRASH+1)        ;nz-CRASH
            and  a
            jr   z,IIO31
            xor  a
            ld   (CRASH+1),a
            ld   a,(SHILD)
            sub  40

;            jpc  GAMEOVER

            ld   (SHILD),a

            ld   a,2
            ld   (FSHILD+1),a
IIO31:
; ВОССТАНОВЛЕНИЕ ТЕМПЕРАТУРЫ ЛАЗЕРА ИГРОКА
            ld   a,0
PSRLI:      add  a,20
            ld   ($-3),a
            jr   nc,IIO32
PEREGREV:   ld   a,0
            cp   46
            jr   nc,IIO32
            inc  a
            ld   (PEREGREV+1),a
            ld   (FFIRE+1),a
IIO32:
; ИНТЕЛЕКТ
            call SHIPINTELEGENT
            xor  a
            ld   (PLAYER+1),a

; ИЗМЕНЕНИЕ КООРДИНАТ СТАНЦИИ
            call MVSTT
; ИЗМЕНЕНИЕ КООРДИНАТ ЗВЕЗДЫ И ПЛАНЕТЫ
            call MVSUN
; ОБРАБОТЧИК ВОКС. АНИМАЦИИ
            call EXPL
; ИЗМЕНЕНИЕ КООРДИНАТ И ПРИРАЩЕНИЙ
            call MOVEU
            PAGE_ CONTR
; ИЗМЕНЕНИЕ КООРДИНАТ ЗВЕЗД
            call MOVESTARS
            PAGE___NOARG
; РЕГИСТРАЦИЯ ПОПАДАНИЯ ЛАЗЕР ИГРОКА
            call SHUT


; ПРОВЕРКИ ПОПАДАНИЯ ЛАЗЕРОМ, РАКЕТОЙ
; И Т.Д.

            ld   a,(ACTION)
            ld   c,a
            bit  0,c
            jr   z,IIO1
; ПОПАДАНИЕ ЛАЗЕРОМ
            xor  a
            ld   (ACTION),a
            ld   hl,EFF11
            ld   (SFXA+1),hl

            ld   a,(SHILD)
PMLPI:      sub  1

;            jpc  GAMEOVER

            ld   (SHILD),a

            ld   a,1
            ld   (FSHILD+1),a
IIO1:
            bit  1,c
            jr   z,IIO3
; ПУСК РАКЕТЫ ПО ИГРОКУ
            ld   a,%10000000
            rrca
            ld   ($-2),a
            ld   a,%00000101
            jr   nc,IIO4
            ld   hl,ROKA
            ld   (SFXB+1),hl
            ld   a,%00110101
IIO4:
            ld   (#5A1C),a
            xor  a
            ld   (ACTION),a
            jp   IIO3+5
IIO3:
            ld   a,%00000101
            ld   (#5A1C),a
            bit  2,c
            jr   z,IIO5
; ПОПАДАНИЕ РАКЕТОЙ
            xor  a
            ld   (ACTION),a
            ld   a,(SHILD)
            sub  40

;            jpc  GAMEOVER

            ld   (SHILD),a

            ld   a,1
            ld   (FSHILD+1),a
IIO5:
; ВОССТАНОВЛЕНИЕ ЭНЕРГИИ ИГРОКА
            ld   a,0
PSRZI:      add  a,80
            ld   ($-3),a
            jr   nc,IIO2
            ld   a,(SHILD)
            cp   46
            jr   nc,IIO2
            inc  a
            ld   (SHILD),a
            ld   a,1
            ld   (FSHILD+1),a
IIO2:
; ЗВУКИ
            call SFXA

; МЕРЦАНИЯ ДВИГАТЕЛЕЙ
            PAGE_ OBJ3D

; ВОСЕМЬ
            ld   a,(P02Kd18)
            xor  %01100000
            ld   (P02Kd18),a


; ЧЕТЫРЕХ УГОЛЬНЫЕ
            ld   a,(P00SH1)
            xor  %01100000
            ld   (P00SH1),a
            ld   (P00SH1D),a
            ld   (P00SH2),a
            ld   (P00SH2D),a
            ld   (P00UFO1),a
            ld   (P01UFO1),a
            ld   (P00Kd1),a
            ld   (P00Kd2),a
            ld   (P00KN03grz1),a
            ld   (P00Kd3),a
            ld   (P00Kd4),a
            ld   (P00Kd6),a
            ld   (P00KN07krs1),a
            ld   (P00Kd7),a
            ld   (P00KN08grz2),a
            ld   (P00Kd8),a
            ld   (P00Kd9),a
            ld   (P00KN11grz3),a
            ld   (P02Kd11),a
            ld   (P00Kd13),a
            ld   (P02Kd15),a
            ld   (P00Kd16),a
            ld   (P00Kd17),a
            ld   (P00KN18UFo4),a
            ld   (P00Kd18),a
            ld   (P01Kd18),a
            ld   (P00Kd20),a
            ld   (P00Kd22),a
            ld   (P00Kd23),a
            ld   (P00Kd26),a
            ld   (P01Kd26),a
            ld   (P00Kd27),a
            ld   (P00Kd28),a
            ld   (P00Kd29),a
            ld   (P00KN30grz4),a
            ld   (P02Kd30),a
            ld   (P00KN31grz5),a
            ld   (P00Kd31),a
            ld   (P00micKd1),a
            ld   (P00micKd2),a
            ld   (P00REM_DR),a
            ld   (P00ufo_K),a
            ld   (P00UfoRD),a
            ld   (P01UfoRD),a
            ld   (P02UfoRD),a
            ld   (P03UfoRD),a

; ТРЕХ
            ld   a,(P00RD2)
            xor  %01100000
            ld   (P00RD2),a
            ld   (P01RD2),a
            ld   (P02RD2),a
            ld   (P03RD2),a
            ld   (P04RD2),a
            ld   (P05RD2),a
            ld   (P06RD2),a
            ld   (P07RD2),a
            ld   (P00Kd5),a
            ld   (P01Kd5),a
            ld   (P00Kd10),a
            ld   (P01Kd10),a
            ld   (P00Kd11),a
            ld   (P01Kd11),a
            ld   (P00Kd12),a
            ld   (P01Kd12),a
            ld   (P02Kd12),a
            ld   (P00Kd14),a
            ld   (P01Kd14),a
            ld   (P00Kd15),a
            ld   (P01Kd15),a
            ld   (P00Kd19),a
            ld   (P01Kd19),a
            ld   (P00Kd21),a
            ld   (P01Kd21),a
            ld   (P00Kd24),a
            ld   (P01Kd24),a
            ld   (P00Kd25),a
            ld   (P01Kd25),a
            ld   (P00Kd30),a
            ld   (P01Kd30),a
            ld   (P00Kib_K),a
            ld   (P01Kib_K),a

            PAGE___NOARG

; СТАТУС ИНДИКАТОРЫ ЭНЕРГИИ И Т.Д.
            call DATALINES
; ИНДИКАЦИЯ РЕЖИМА НАВЕДЕНИЯ РАКЕТ ИГРОКА
FNAVOD:     ld   a,0
            and  a
            ld   a,%00010101
            jr   nz,$+4
            ld   a,%00000101
            ld   (#5A1A),a


; ПОДСВЕТКА
PODSWET:
            ld   a,0
            dec  a
            ex   af,af'
            PAGE_ CONTR
            ex   af,af'
            call nz,LIGHTER

            call PRINT
            call PRICEL
; ВЫВОД ТЕНЕВОГО СКРИНА

            call OHIDE

; ПЕЧАТЬ В КОМПУТЕРЕ
            call PRINT
            call PRINT
            call PRINT
            call COMPOS
; РАДАР
            call RADAR
            PAGE___NOARG


            ret


; ПРОВЕРКА ВЫХОДА В АСМ
;-------------
EXIT:

;              PAGE    VOXAL
;              ld     de,(MTRK+1)
;              ld     a,(DRIVE+1)
;              jp     RETSTT

            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,#FF
            out  (c),a
            ld   a,#3F
            ld   i,a
; [glue] original: include "RETASM.asm" (restore the ZASM assembler); the game goes back to the station
            jp   LaunchStation
;           include "RETASM.asm"


SIZEOBJ:
; aИНДЕКС ОБЪЕКТА
            ld   l,a
            ld   h,L97
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            PAGE_ OBJ3D
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            PAGE___NOARG
            ret


; ПЕРЕБРОС ДАННЫХ ОБЪЕКТА В БУФЕР
REMOVEOBJ:
; lИНДЕКС ОБЪЕКТА
            ld   h,L97
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            PAGE_ OBJ3D
            ld   de,OBJBUF
            ldi
            ldi
ZJ72:
            ld   a,(hl)
            or   a
            jr   z,ZJ71
            ldi
            ldi
            ldi
            ldi
            jp   ZJ72
ZJ71:
            ldi
ZJ73:
            ld   a,(hl)
            and  #0F
            jr   z,ZJ74
            inc  a
            ld   c,a
            ld   b,0
            ldir
            jp   ZJ73
ZJ74:
            ldi
            PAGE___NOARG
            ret


Page_:
; ПЕРЕКЛЮЧЕНИЕ СТРАНИЦ
; А-КОД
            push bc
            ld   bc,#7FFD
            out  (c),a
            pop  bc
            ret


; ДЕПАКЕР
DEHRUST:
;hl-АДР. ЧТО ДЕПАКИТЬ
;de-АДР. КУДА ДЕПАКИТЬ
            push de
            push hl
            inc  hl
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            dec  bc
            EXD
            add  hl,bc
            EXD
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            dec  bc
            pop  hl
            add  hl,bc
            sbc  hl,de
            add  hl,de
            jr   c,$+4
            ld   d,h
            ld   e,l
            lddr
            EXD
            pop  de
            ld   c,#0C
            add  hl,bc
            push hl
            pop  ix
            ld   a,#03
            dec  hl
            ld   b,(hl)
            dec  hl
            ld   c,(hl)
            push bc
            dec  a
            jr   nz,$-6
            ld   b,a
            exx
            ld   d,#BF
            ld   c,#10
            call LL4115
LL4036:     ld   a,(ix+#00)
            inc  ix
            exx
LL403C:     ld   (de),a
            inc  de
LL403E:     exx
LL403F:     add  hl,hl
            djnz $+5
            call LL4115
            jr   c,LL4036
            ld   e,#01
LL4049:     ld   a,#80
            add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,$-7
            cp   #03
            jr   c,$+7
            add  a,e
            ld   e,a
            xor  c
            jr   nz,LL4049
            add  a,e
            cp   #04
            jr   z,LL40C4
            adc  a,#FF
            cp   #02
            exx
LL4067:     ld   c,a
LL4068:     exx
            ld   a,#BF
            jr   c,LL4082
LL406D:     add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,LL406D
            jr   z,LL407D
            inc  a
            add  a,d
            jr   nc,LL4084
            sub  d
LL407D:     inc  a
            jr   nz,LL408D
            ld   a,#EF
LL4082:     rrca
            cp   a
LL4084:     add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,LL4084
LL408D:     exx
            ld   h,#FF
            jr   z,LL409B
            ld   h,a
            inc  a
            ld   a,(ix+#00)
            inc  ix
            jr   z,LL40A6
LL409B:     ld   l,a
            add  hl,de
            ldir
LL409F:     jr   LL403E
LL40A1:     exx
            rrc  d
            jr   LL403F
LL40A6:     cp   #E0
            jr   c,LL409B
            rlca
            xor  c
            inc  a
            jr   z,LL40A1
            sub  #10
LL40B1:     ld   l,a
            ld   c,a
            ld   h,#FF
            add  hl,de
            ldi
            ld   a,(ix+#00)
            inc  ix
            ld   (de),a
            inc  hl
            inc  de
            ld   a,(hl)
            jp   LL403C
LL40C4:     ld   a,#80
LL40C6:     add  hl,hl
            djnz $+5
            call LL4115
            adc  a,a
            jr   nz,LL40F3
            jr   c,LL40C6
            ld   a,#FC
            jr   LL40F6
LL40D5:     ld   b,a
            ld   c,(ix+#00)
            inc  ix
            ccf
            jr   LL4068
LL40DE:     cp   #0F
            jr   c,LL40D5
            jr   nz,LL4067
            ld   b,#03
            EXD
LL40E7:     pop  de
            ld   (hl),e
            inc  hl
            ld   (hl),d
            inc  hl
            djnz LL40E7
            ld   hl,#2758
            exx
            ret
LL40F3:     sbc  a,a
            ld   a,#EF
LL40F6:     add  hl,hl
            djnz $+5
            call LL4115
            rla
            jr   c,LL40F6
            exx
            jr   nz,LL40B1
            bit  7,a
            jr   z,LL40DE
            sub  #EA
            add  a,a
            ld   b,a
            ld   a,(ix+#00)
            inc  ix
            ld   (de),a
            inc  de
            djnz $-7
            jr   LL409F
LL4115:     ld   b,c
            ld   l,(ix+#00)
            inc  ix
            ld   h,(ix+#00)
            inc  ix
            ret


; ЗАДАНИЕ ПАРАМЕТРОВ СРЕДЫ В ЗАВИСИМОСТИ
; ОТ СТАТУСА СИСТЕМЫ
SETTING:
            PAGE___NOARG
            call SETVARS
            ld   hl,0
            ld   (SFXA+1),hl
            ld   (SFXB+1),hl
            xor  a
            ld   (STATGEN),a
            ld   (NOSTAT),a
            ret

; ЗАДАТЬ ПЕРЕМЕННЫЕ ВЕРОЯТНОСТЕЙ И ДР.
SETVARS:
            ld   hl,PLANDICTAT
            ld   a,(hl)
            ld   (PMLI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PMLPI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PMLPL+1),a
            inc  hl
            ld   a,(hl)
            ld   (PSRZI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PSTLI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PSRLI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PWPKO+1),a
            ld   (GNUM_+1),a
            inc  hl
            ld   a,(hl)
            ld   (PWNPM+1),a
            inc  hl
            ld   a,(hl)
            ld   (PWNPI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PWPPI+1),a
            inc  hl
            ld   a,(hl)
            ld   (PWNPP+1),a
            inc  hl
            ld   a,(hl)
            ld   (PWPR+1),a
            inc  hl
            ld   a,(hl)
            ld   (PSUEK+1),a
            inc  hl
            ld   a,(hl)
            ld   (PMUEK+1),a
            inc  hl
            ld   a,(hl)
            ld   (PSSK+1),a
            ret

BORT:
; ПЕРЕХОД И ЗАГРУЗКА БОРТ КОМПА


            ret


;------------------------------------
; МАТЕМАТИКА


RECORD:
; ПРЕОБРАЗОВАНИЕ КООРДИНАТ ПО ОБРАТНОЙ
; МАТРИЦЕ ПРОСТРАНСТВА
;hl-X,de-Y,bc-z
;ret
;hl-X,de-Y,bc-z
            push ix
            push iy
            ld   (DX+1),hl
            ld   (DY+1),de
            ld   (DZ+1),bc
            call PEREWOROT
            ld   ($+12),sp
            ld   iy,$+7
            jp   CALCRCORD
            ld   sp,0
            call PEREWOROT
            ld   hl,(TX+1)
            ld   de,(TY+1)
            ld   bc,(TZ+1)
            pop  iy
            pop  ix
            ret

PEREWOROT:
; СДЕЛАТЬ МАТРИЦУ ОБРАТНОЙ
            ld   hl,(SM_12+1)
            ld   de,(SM_21+1)
            ld   (SM_21+1),hl
            ld   (SM_12+1),de
            ld   hl,(SM_13+1)
            ld   de,(SM_31+1)
            ld   (SM_31+1),hl
            ld   (SM_13+1),de
            ld   hl,(SM_23+1)
            ld   de,(SM_32+1)
            ld   (SM_32+1),hl
            ld   (SM_23+1),de
            ret


KORNI_:
; ПОДСЧЕТ КОРНЯ
;de-ЗНААЕНИЕ ПОД КОРНЕМ
;a-РЕЗУЛЬТАТ
            push bc
            PAGE_ CONTR
            call KORNI
            ex   af,af'
            PAGE___NOARG
            ex   af,af'
            pop  bc
            ret


WAYUNGLE:
; ТОЧНОЕ ОПРЕДЛЕНИЕ ДВУХ УГЛОВ ПОВОРОТА
; ОБЪКЕТА НОСОМ НА ДРУГОЙ

; ФОРМУЛЫ
;BETA=ARCTAG(AB/DZ)
;GAMA=ARCTAG(DY/DX)
;AB=SQRT(DX^2+DY^2)
; ЗНАК BETA ЗАВИСИТ ОТ ЗНАКА DX

; РАСЧЕТ AB

; ВХОДНЫЕ ДАННЫЕ
;de-X1,hl-X2,bc-Y1,HL'-Y2
;DE'-Z2,BC'-Z1
;ret
;b-BETA,c-GAMA

;MULL HLDE=hl*de
            push ix
            sra  h
            rr   l
            sra  d
            rr   e
            SUB_DE
;hl-DX
            push hl
            push bc
            ld   d,h
            ld   e,l
            call MULL
            EXD
            pop  bc
            exx
            push hl
            exx
            pop  hl
            sra  h
            rr   l
            sra  b
            rr   c
            SUB_BC
;hl-DY
            push hl
            push de
            ld   d,h
            ld   e,l
            call MULL
            pop  de
            add  hl,de
;hl-СТАРШАЯ ЧАСТЬ ОТ AB^2=DX^2+DY^2
            EXD
            call KORNI_
            ld   h,a
            ld   l,0
            push hl
            exx
            EXD

            sra  h
            rr   l
            sra  b
            rr   c

            SUB_BC

            push hl
            exx
            pop  de
;de-DZ
            pop  hl
            call ATAGDIV
            or   a
            jp   p,$+5
            neg

            pop  hl
            pop  de
;hl-DY,de-DX
            add  a,#80
            push af
            call ATAGDIV
            pop  bc
            ld   c,a

            pop  ix
            ret
MMATRX:
; ВЫЗОВ РАСЧЕТА МАТРИЦЫ ПРОСТРАНСТВА
            PAGE_ VOXAL
            call GMATRX
            PAGE___NOARG
            ret

CALC2D3D:
; ИЗ 3D В 2D
;de-z,hl-Y,bc-X
;rethl-X,de-Y
;FZ=nz-ERROR
            push bc
            push de
;z
            ABSDE
;Y
            call FDIV
            pop  de
            jp   c,LD3
            bit  7,d
            jr   z,$+9
            NEGHL

            ld   bc,(YEND+1)/2      ;MIDLE Y
            add  hl,bc
            ld   b,h
            ld   c,l
;X
            pop  hl
            push bc

            push de
            ABSDE
            call FDIV
            pop  de
            jp   c,LD3
            bit  7,d
            jr   z,$+9
            NEGHL

            ld   de,#0080           ;MIDLE X
            add  hl,de
            pop  de
            xor  a
            ret
LD3:
            pop  af
            xor  a
            inc  a
            ret


CALCUNGLE:
; ВЫЧИСЛИМ УГОЛ МЕЖДУ ДВУМЯ ОБЪЕКТАМИ ПО
; ЛЮБОЙ ИЗ ПЛОСКОСТЕЙ
;de-X1,hl-X2,bc-Y1,HL'-Y2

; ДЕЛАЕМ DX,DY
            SUB_DE
            EXD
            exx
            ld   a,l
            ex   af,af'
            ld   a,h
            exx
            ld   h,a
            ex   af,af'
            ld   l,a
            SUB_BC
;z

ATAGDIV:
; РАСЧЕТ ATAG(HL/de)
;retina
            ld   a,d
            xor  h
            push af
            push de
            ABSDE
            call FDIV
            pop  bc
            jr   c,CUG1
            ABSHL
            ld   a,l
            rept 4
            srl  h
            rra
            endr
            ld   l,a
            ld   a,h
            and  a
            jp   nz,CUG1
            pop  af
            ld   h,high(ATAGTAB)
            ld   a,(hl)
            jp   p,$+11
            add  a,#40
            bit  7,b
            ret  nz
            add  a,#80
            ret
            bit  7,b
            ret  z
            add  a,#80
            ret

CUG1:
            pop  af
            ld   a,#40
            ret  p
            ld   a,#C0
            ret

FDIV:
;FAST DIVISING
;h.L(SIGN)=hl(SIGN)/de(UNSIGN)
; ЕСЛИ FC-ON ТО АВАРИЙНЫЙ ВЫХОД ПЕРЕПОЛНЕН

            ld   bc,0
            EXD
            inc  h
            dec  h
            jr   z,FDV1
            rept 6
            inc  b
            sra  h
            jr   z,FDV1-2
            rr   l
            endr
            inc  b
            sra  h

            rr   l
FDV1:       ld   h,high(TBLOG2)
            ld   a,(hl)
            inc  h
            ld   h,(hl)
            ld   l,a
            add  hl,bc
            EXD
            ld   a,h
            rla
            jr   nc,FDV2
            NEGHL
            scf
FDV2:       ex   af,af'
            ld   bc,#0800
            inc  h
            dec  h
            jr   z,FDV3

            rept 6
            inc  b
            sra  h
            jr   z,FDV3-2
            rr   l
            endr

            inc  b
            sra  h
            rr   l
FDV3:       ld   h,high(TBLOG2)
            ld   a,(hl)
            inc  h
            ld   h,(hl)
            ld   l,a
            add  hl,bc
            SUB_DE
            jp   m,FDV4
            ld   a,h
            ld   b,a
            ld   h,high(TB2X)
            ld   l,(hl)
            ld   h,1
            sub  8
            jr   nc,FDV5
            ld   a,7
            sub  b
            ld   ($+4),a
            jr   nz,$
            ADDHLHL 7
            ld   l,h
            ld   h,0
            jp   FDV7
FDV4:
            ld   hl,0
            and  a
            ret
FDV5:       ld   a,#0F
            sub  b
            ret  c
            ld   ($+4),a
            jr   nz,$
            ADDHLHL 7
FDV7:       ex   af,af'
            jr   nc,$+9
            NEGHL
            and  a
            ret


; ПОВЕРНУТЬ КООРДИНАТНУЮ СИСТЕМУ ПО
; МАТРИЦЕ SM_XY
;iy-RETURN ADR
; ПОРТИТ sp
; НАЧАЛЬНЫЕ ЗНАЧЕНИЯ КООРДИНАТ В DX,DY,DZ
; КОНЕЧНЫЕ В TX,TY,TZ
CALCRCORD:
            ld   (RIX+2),ix
DX:         ld   de,0
            ld   a,(SM_11+1)
            ld   ix,$+7
            jp   MULADE
            ld   sp,hl
DY:         ld   de,0
            ld   a,(SM_21+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   sp,hl
DZ:         ld   de,0
            ld   a,(SM_31+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   (TX+1),hl
            ld   de,(DX+1)          ;DX
            ld   a,(SM_12+1)
            ld   ix,$+7
            jp   MULADE
            ld   sp,hl
            ld   de,(DY+1)          ;DY
            ld   a,(SM_22+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   sp,hl
            ld   de,(DZ+1)          ;DZ
            ld   a,(SM_32+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   (TY+1),hl
            ld   de,(DX+1)          ;DX
            ld   a,(SM_13+1)
            ld   ix,$+7
            jp   MULADE
            ld   sp,hl
            ld   de,(DY+1)          ;DY
            ld   a,(SM_23+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   sp,hl
            ld   de,(DZ+1)          ;DZ
            ld   a,(SM_33+1)
            ld   ix,$+7
            jp   MULADE
            adc  hl,sp
            jp   pe,EXET1
            ld   (TZ+1),hl
EXET1:
RIX:        ld   ix,0
            jp   (iy)


TURNMATR:
; ПРЕОБРЗОВАНИЕ МАТРИЦЫ ПРОСТРАНСТВА
; В ОБРАТНУЮ
            ld   de,(LB13)
            ld   hl,0
            SUB_DE
            ld   (LB13),hl
            ld   de,(LB23)
            ld   hl,0
            SUB_DE
            ld   (LB23),hl
            ld   de,(LB33)
            ld   hl,0
            SUB_DE
            ld   (LB33),hl
            ld   de,(LA11)
            ld   hl,0
            SUB_DE
            ld   (LA11),hl
            ld   de,(LA21)
            ld   hl,0
            SUB_DE
            ld   (LA21),hl
            ld   de,(LA31)
            ld   hl,0
            SUB_DE
            ld   (LA31),hl
            ret
SHMTRX:
;CALC SHIP MATRIX VECTOR
EYEA_:      ld   a,0
            ld   h,SINTB
            ld   l,a
            ld   b,(hl)
            add  a,#40
            ld   l,a
            ld   c,(hl)
EYEB_:      ld   a,0
            ld   l,a
            ld   a,(hl)
            ld   ixl,a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)
            ld   iyl,a
EYEG_:      ld   a,0
            ld   l,a
            ld   a,(hl)
            ld   d,a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   e,(hl)
            ld   h,MULTB
            ld   a,ixl
            sra  a
            ld   l,e
            sra  l
            sub  l
            ld   l,a
            add  a,e
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ld   (HM_13+1),a
            ld   a,iyl
            MULAB
            ld   ixh,a
            ld   a,ixl
            MULAC
            MULAD
            SBPAXH
            ld   (HM_23+1),a
            ld   a,iyl
            MULAC
            ld   ixh,a
            ld   a,ixl
            MULAB
            MULAD
            ADPAXH
            ld   (HM_33+1),a
            ret

KORNI:
; ДАННЫЕ de
; ЗНАЧЕНИЕ a
            ld   a,d
            and  a
            jr   z,KOR
            ld   l,a
            ld   h,high(KORN)
            ld   a,(hl)
            inc  h
            ld   c,a
            cpl
            ex   af,af'
            ld   b,#FF
            inc  bc
            sla  c
            rl   b
            dec  bc
            ld   a,(hl)
            inc  h
            ld   h,(hl)
            ld   l,a
            ex   af,af'
            add  hl,de
            rept 5
            add  hl,bc
            ret  nc
            dec  bc
            dec  bc
            inc  a
            endr
            add  hl,bc
            ret  nc
            inc  a
            ret
KOR:
; ПОДСЧЕТ КОРНЯ БЕЗ ТАБЛИЦЫ, ДЛЯ МАЛЕНЬКИХ
; ЧИСЕЛ
; ДАННЫЕ de<2116
; ЗНАЧЕНИЕ a
            EXD
            ld   bc,0-1
            xor  a
            rept 14
            add  hl,bc
            ret  nc
            inc  a
            dec  bc
            dec  bc
            endr
            add  hl,bc
            ret  nc
            inc  a
            ret
; ТАБЛИЦА ДЛЯ ПОДСЧЕТА КОРНЯ
; ПЕРВЫЙ БАЙТ КОРЕНЬ ИЗ "КРУГЛОГО" ЧИСЛА
; ВТОРОЕ СЛОВО ИНВЕРСНОЕ ПО ЗНАКУ ЧИСЛО
; КАК ОСТАТОК
