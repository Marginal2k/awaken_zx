;==============================================================================
; VOXEL~37 - вывод воксельных спрайтов (взрывы, телепорт, корабли-спрайты)
;
;
; Где живёт: страница VOXAL (#13), образ VOXAL.C, сегмент после GMATRX.
; VOX: проекция вокселя в экранные координаты, MASHT - масштабирование, NWTEL/NWVOS - создание спрайтов,
; MULABC/DIVV - арифметика. Данные спрайтов: EXPLOSIO.v, HIPERJMP.v. GAME_DESIGN 2.3.
;==============================================================================

NWTEL:
; Инициализация нового телепорта
            ld   hl,VSPR2
            ld   de,#00C0
            ld   (MASHT+3),a
            ld   a,12
            ld   (VLL2+3),a
            ld   a,12
            ld   (VLL1+3),a
; Кол.фреймов
            ld   a,#0D
            ld   (VLL3+1),a
            jp   ZJ1-3

NWVOS:
; Инициализация нового взрыва
;HL'-X,DE'-Y,BC'-Z
;A'-время жизни
;a-масштаб
;  что будет задано в процедуре
;hl-адрес спрайтов
;b-количество фреймов в анимации
;de-размер в байтах одного фрейма
            ld   hl,VSPR
            ld   de,#280
            ld   (MASHT+3),a
            ld   a,20
            ld   (VLL2+3),a
            ld   a,20
            ld   (VLL1+3),a
            ld   a,#08
            ld   (VLL3+1),a
            ld   bc,VLEN
ZJ1:
            add  iy,bc
            ld   a,(iy+7)
            and  a
            ret  m
            jr   nz,ZJ1
            exx
            ld   (iy+0),l
            ld   (iy+1),h
            ld   (iy+2),e
            ld   (iy+3),d
            ld   (iy+4),c
            ld   (iy+5),b
            ex   af,af'
; Время жизни
            ld   (iy+7),a
            exx
MASHT:      ld   (iy+6),0
; Текущий адрес фрейма
            ld   (iy+8),l
            ld   (iy+9),h
; Адрес начала анимации
            ld   (iy+10),l
            ld   (iy+11),h
; Номер текущего кадра, нумеруем с конца
; задаем номер последнего = 1, что бы
; переключиться на первый
            ld   (iy+12),1
VLL3:       ld   a,0
; Количество кадров
            ld   (iy+13),a
; Длинна кадра в байтах
            ld   (iy+14),e
            ld   (iy+15),d
; Длинна по X
VLL1:       ld   (iy+16),0
; Высота по Y
VLL2:       ld   (iy+17),0
            ret


; Процедура вывода вокс. спрайта с
; с масштабированием и прозрачностью
; порит рег. i


;VOXEL
VOX:
;DE'-ADR OF OBJ
;HL'-REAL SIZE SPRITE L-X,H-Y
;b-SIZE Y,c-SIZE X
;hl-X,de-Y
            ld   a,b
            or   a
            ret  z
            ld   a,c
            or   a
            ret  z
            xor  a
            ld   (DBV+1),a
            ld   (VX+1),hl
            ld   (VY+1),de
            ld   iyl,c              ;SZX
            ld   iyh,b              ;SZY
            ld   e,b
            exx
            ld   bc,0
            exx
            ld   b,0
VX:         ld   hl,0
            ld   a,h
            and  a
            jp   p,.VX1
; Если часть спрайта за экраном слева
            adc  hl,bc
            ret  m                  ;Весь спрайт за экраном
            ret  z                  ;ТОЖе
; Клипируем
            ld   a,l
            ld   hl,0               ;X=0
            ld   b,c
            ld   c,a                ;NEW LEN OF X
            sub  b
            ld   b,l
            neg
; В "а" будет смещение по ширине для
; изменения адреса спрайта
            exx
            ld   (DBV+1),a
            set  0,c                ;Метка клипинга слева
            exx
            jp   .VX2
.VX1
            ret  nz                 ;За экраном справа
            ld   a,l
            cp   Xend
            ret  nc                 ;Тоже
.VX2
            add  hl,bc
            ld   a,h
            or   a
            ld   a,l
            jr   nz,$+6
            cp   Xend+1
            jr   c,VY               ;Весь спр на экране по X
; Правая часть спрайта за экраном справа
; клипируем
            sub  Xend
            sub  c
            neg
; Новая длинна спрайта
            ld   c,a
; Проверки по у
VY:         ld   hl,0
            ld   d,0
            ld   a,h
            and  a
            jp   p,.VX3
; Если спрайт выходит сверху за экран
            adc  hl,de
            ret  m                  ;Вылет по у вверху всего
; Спрайта
            ret  z                  ;Тоже
            ld   a,l
            ld   hl,0               ;У=0
            ld   d,e
            ld   e,a                ;Новая высота спрайта
            sub  d
            ld   d,l
            neg
            exx
; В "а" количество строк поддвергнутых
; клиппингу, которые не видимы
            ld   b,a
            set  1,c                ;Маркер клипинга по у
            exx
            jp   .VX4
.VX3
            ret  nz                 ;Весь спрайт ниже скрина
            ld   a,l
            cp   Yend
            ret  nc                 ;Тоже
.VX4
            add  hl,de
            ld   a,h
            or   a
            ld   a,l
            jr   nz,$+6
            cp   Yend+1
            jr   c,.VX5
; Спрайт выше высоты скрина или вылез
; снизу
            sub  Yend
            sub  e
            neg
            ld   e,a                ;Новая высота


.VX5
; Делаем нужные координаты если были
; клиппинги
            exx
            ld   a,(VX+1)
            bit  0,c
            jr   z,$+3
            xor  a
            bit  1,c
            exx
            ld   b,a                ;Координата х спрайта вывд
            ld   a,(VY+1)
            jr   z,$+3
            xor  a
; А-коорд. у спрайта для вывода
; расч. адр. на хайд слрине
            srl  a
            ld   l,d
            rr   l
            ld   h,a                ;hl=коорд. вывода у/2
            ld   ixh,e              ;Количество строк
; Коорд. вывода X после клиппинга
            ld   e,b

; Запомним коорд. вывода х
            ld   a,e
            ld   (XX+1),a

            srl  e

; Подготовка к выводу вокселя
; во втором полубайте
            ld   a,#30              ;jrnc,
            jr   nc,$+6
            inc  c
            inc  c
            ld   a,#38              ;jrc,
            ld   (AW3),a


            add  hl,de
            set  7,h
            EXD
; В de-адр. в скрине


            push de
            push bc


; Расчитываем коэф. масштабирования по х
            exx
            ld   a,l                ;Реальная ширина спрайта
            exx
            ld   b,a                ;Запомнили
; Изначально заданная выводимая ширина
            ld   e,iyl
            call DIVV
; Коэф.по X=256*реал.ширина/заданная
            EXD
; В "HL"-коэф. масштабирования по X


; Коеф. масштабирования по у
            exx
            ld   a,h                ;Реальная высота
            exx
            ld   e,iyh              ;Заданная
            push hl
            call DIVV
            pop  hl
            ld   a,e
; Стар.байт коеф.масш.по у
            ld   ixl,d
            exx
            ld   c,a
; В "C" младш. байт коеф. масшт. по у


            exx
; Изначальная ширина спрайта
; необходимо сделать ее кратной 2^n
; т.е. если она = 20 ,то будет 32
            ld   a,b
            cp   17
            jr   nc,$+6
            ld   a,16
            jr   $+4
            ld   a,32
            ld   b,a
            exx


; В bколичество видимых строк клипнутых
; сверху
            ld   a,b
            and  a
            jr   z,.VX6

; В хlстар.байт коеф.масш.по у

; Изменяем адрес спрайта если был
; клиппинг по высоте спрайта с верху,
; резался с верху
            ld   b,ixl
; hl=a*bc
; a кол видимых строк которые нужно
            ; ??? пропустить сверху
; bскоеф. масштабирования по Y
; h будет кол строк спрайта которые
            ; ??? нужно будет пропустить
            call MULABC

            ld   a,h
            and  a
            jr   z,.VX6
            ld   b,a
            exx
            ld   a,b
            exx

; Умножим длинну в байтах строки на
; количество строк спрайта которые надо
; пропустить и сложить полученное
; количество байт с адресом спрайта, чтоб
; найти новый адрес для начала вывода
; dеадрес спрайта
; a длинна в байтах строки спрайта
; b кол. строк пропустить
            push bc
            ld   c,a
            ld   a,b
            ld   b,0
            call MULABC
            pop  bc
            add  hl,de
            EXD
.VX6
            exx
DBV:        ld   a,0                ;Кол.клипнутых дабл
; Вокселей по ширине
; слева
            and  a
            jr   z,.P1
; Изменяем адрес спрайта если был клипинг
; слева по ширине

            EXD

; Просуммируем коеф. масшт. по ширине
; столько раз сколько нужно клипнуть
; дабл вокселей

            ld   hl,0
            rla
            ld   c,a
            xor  a
            rept 6
            rl   c
            jr   nc,$+5
            add  hl,de
            adc  a,0
            add  hl,hl
            rla
            endr
            rl   c
            jr   nc,$+5
            add  hl,de
            adc  a,0

            ex   af,af'

            ld   a,h
            exx
            ld   l,a
            ex   af,af'
            ld   h,a
            add  hl,de
            EXD
            exx
            EXD
.P1
            ld   a,b
            pop  bc
            pop  de

; Вывод вокселя с масштабированием
; c-количество вокселей в строке
; de-адрес на скрине
; xh-кол. строк
; hl-коеф. смещения по х
; C'-младший байт прореживания по у
; xl-старший байт прореживания по у
; DE'-адрес спрайта, #XX00
; a-реальное кол. вокселей в строке
; приведенное к кратности 2^n: 16 или 32
; в спрайта
VOXOUT:
            ld   (STKV+1),sp

            ld   (VXLL+1),a         ;Реальная ширина

            ld   sp,hl              ;Коеф. масш. по х
; Умножаем старший байт коеф.
; Прореживания на реальную длинну строки
; что бы получить коеф. прореж. по у
; кратный длинне строки
            ld   b,a
            ld   a,ixl
            or   a
            jr   z,.P2
            ex   af,af'
            ld   a,c
            ex   af,af'
            ld   c,b
            ld   b,0

            ld   hl,0
            rla
            rept 6
            rla
            jr   nc,$+3
            add  hl,bc
            add  hl,hl
            endr
            rla
            jr   nc,$+3
            add  hl,bc

            ex   af,af'
            ld   c,a

            ld   a,l
            ld   ixl,a
            ld   a,h
; В a-смещение для ст.байта адреса спрайт
.P2
            ld   (WE1+1),a

; Расчитываем адрес начала вывода вокселя
; в развернутом цикле процедуры

; Подготовка к выводу одного вокселя
; в первом полубйте
; находим след. коорд. х после спрайта
; если 0 бит ее =0 то весь знакомест
; в вокселях
; иначе только один первый полузнакомест
; заполняется
XX:         ld   a,0
            add  a,c
            rra
            ld   a,#0F
            jr   nc,.Q2
            ld   a,(AW3)
            cp   #38
            jr   z,$+3
            inc  c
            xor  a
.Q2
            ld   (AW1+1),a
            ld   (AW2+1),a

            srl  c
            ld   a,#20
            sub  c
            jp   nc,$+4
            xor  a
            ld   l,a
            ld   h,0
            ld   c,l
            ld   b,h
;84B

            ADDHLHL 2
            add  hl,bc
            ADDHLHL 2
            add  hl,bc
            ADDHLHL 2
            ld   bc,VXL4
            add  hl,bc
            ld   (VXL3+1),hl
AW3:        jr   nc,.Q1
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            ld   (hl),0
            dec  hl
.Q1
            ld   (VXL2+1),hl
            ld   iyl,e              ;Дублируем мл.байт адреса
            ld   c,e
            ld   b,d
            rra
            ld   h,high(VXTAB)+3
            ld   a,#A9              ;res5,c
            jr   c,$+8
            set  5,c
            ld   h,high(VXTAB)
            ld   a,#E9              ;set5,c

            ld   (AW4+1),a
            ld   a,h
            ld   (AW5+1),a

            ld   d,#0F
            exx
            xor  a
            ld   b,e
Vxl3:
            ex   af,af'
            ld   h,b
            ld   l,0

; sркоеф. прореж. по X
; h мл.байт адреса спрайта
; l дробь мл.байта адреса спрайта
; b мл.байт адреса спрайта
; d ст.байт адреса спрайта
; A' дробь смещения по строкам
; хlст.байт прореж. по Y
; c мл.байт прореж. по Y
            ; ??? кратно количеству вокселей в строке
; BC'адрес в скрине
; H' ст.байт адреса графики вокселей
            ; ??? зависит от четности положения
            ; ??? первого выводимого вокселя в строке
; D' #0F

VXL2:       jp   0

VXL4:

            ld   e,h
            add  hl,sp
            ld   a,(de)
            and  #F0
            exx
            ld   l,a
            exx
            ld   e,h
            add  hl,sp
            ld   a,(de)
            exx
            jr   z,$+39             ;K1
            and  d
            jr   z,$+32             ;K2
            or   l
            ld   l,a
            ld   a,(hl)
            ld   (bc),a
            inc  h
            set  6,c
            ld   a,(hl)
            ld   (bc),a
            inc  h
            res  5,c
            ld   a,(hl)
            ld   (bc),a
            inc  h
            res  6,c
            ld   a,(hl)
            ld   (bc),a
            jp   $+46               ;K0
;K3
            res  5,c
            inc  h
            inc  h
            inc  h
            jp   $+38               ;K0
;K2
            ld   e,d
            jp   $+9                ;K4
;K1
            and  d
            jr   z,$-13             ;K3
            ld   e,#F0
            ld   l,a
;K4
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  h
            set  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  h
            res  5,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  h
            res  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
;K0
            inc  c
            exx

;LEN 84b

            ld   e,h
            add  hl,sp
            ld   a,(de)
            and  #F0
            exx
            ld   l,a
            exx
            ld   e,h
            add  hl,sp
            ld   a,(de)
            exx
            jr   z,$+39
            and  d
            jr   z,$+32
            or   l
            ld   l,a
            ld   a,(hl)
            ld   (bc),a
            dec  h
            set  6,c
            ld   a,(hl)
            ld   (bc),a
            dec  h
            set  5,c
            ld   a,(hl)
            ld   (bc),a
            dec  h
            res  6,c
            ld   a,(hl)
            ld   (bc),a
            jp   $+46
            set  5,c
            dec  h
            dec  h
            dec  h
            jp   $+38
            ld   e,d
            jp   $+9
            and  d
            jr   z,$-13
            ld   e,#F0
            ld   l,a
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            dec  h
            set  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            dec  h
            set  5,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            dec  h
            res  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  c
            exx


            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX
            MVOX


            ld   e,h
            add  hl,sp
            ld   a,(de)
            and  #F0
            exx
            ld   l,a
            exx
            ld   e,h
            add  hl,sp
            ld   a,(de)
            exx
            jr   z,$+39
            and  d
            jr   z,$+32
            or   l
            ld   l,a
            ld   a,(hl)
            ld   (bc),a
            inc  h
            set  6,c
            ld   a,(hl)
            ld   (bc),a
            inc  h
            res  5,c
            ld   a,(hl)
            ld   (bc),a
            inc  h
            res  6,c
            ld   a,(hl)
            ld   (bc),a
            jp   $+46
            res  5,c
            inc  h
            inc  h
            inc  h
            jp   $+38
            ld   e,d
            jp   $+9
            and  d
            jr   z,$-13
            ld   e,#F0
            ld   l,a
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  h
            set  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  h
            res  5,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  h
            res  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            inc  c
            exx


;-LAST
            ld   e,h
            add  hl,sp
            ld   a,(de)
            and  #F0
            exx
            ld   l,a
            exx
            ld   e,h
            add  hl,sp
            ld   a,(de)
            exx
            jr   z,$+40
AW1:        and  #0F
            jr   z,$+32
            or   l
            ld   l,a
            ld   a,(hl)
            ld   (bc),a
            dec  h
            set  6,c
            ld   a,(hl)
            ld   (bc),a
            dec  h
            set  5,c
            ld   a,(hl)
            ld   (bc),a
            dec  h
            res  6,c
            ld   a,(hl)
            ld   (bc),a
            jp   $+47
            set  5,c
            dec  h
            dec  h
            dec  h
            jp   $+39
            ld   e,d
            jp   $+10
AW2:        and  #0F
            jr   z,$-14
            ld   e,#F0
            ld   l,a
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            dec  h
            set  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            dec  h
            set  5,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a
            dec  h
            res  6,c
            ld   a,(bc)
            and  e
            or   (hl)
            ld   (bc),a


;157 TAKTS ONE CYCLE

            ld   a,iyl
            add  a,#80
            ld   c,a
            ld   iyl,a
            jr   nc,$+3
            inc  b
AW4:        set  5,c
AW5:        ld   h,0
            exx
            ex   af,af'
            add  a,c
            ld   l,a
            ld   a,b
            jr   nc,V4
; Длинна строки спрайта
VXLL:       add  a,0
            jr   c,V3

V4:
            add  a,ixl
            ld   b,a
            ld   a,d
WE1:        adc  a,0
            ld   d,a
            ld   a,l
            dec  ixh
            jp   nz,Vxl3
VXL3:       ld   hl,0
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            ld   (hl),#F0

STKV:       ld   sp,0
            ret
V3:         inc  d
            jp   V4


MULABC:
; hl=a*bc
; a= (0-127) (UNSIGNED)
; bc(UNSIGNED)
            ld   hl,0
            rla
            rept 6
            rla
            jr   nc,$+3
            add  hl,bc
            add  hl,hl
            endr
            rla
            ret  nc
            add  hl,bc
            ret


DIVV:
;de=a/e
            ld   l,a
            xor  a
            sli  l
            sli  l
            jr   c,.M1
            sli  l
            jr   c,.M1+7
            sli  l
            jr   c,.M1+(7*2)
            sli  l
            jr   c,.M1+(7*3)
            sli  l
            jr   c,.M1+(7*4)
            sli  l
            jr   c,.M1+(7*5)
            sli  l
            jp   .M1+(7*6)
.M1
            rept 7
            rla
            sbc  a,e
            jr   nc,$+3
            add  a,e
            rl   l
            endr

            ld   c,l

            rept 8
            add  a,a
            sbc  a,e
            jr   nc,$+3
            add  a,e
            rl   l
            endr

            ld   a,l
            cpl
            ld   e,a
            ld   a,c
            cpl
            ld   d,a
            ret


D3D2_:
; Расчет из 3D в 2D
;hl-X,de-z,bc-Y
;L'-полу высота спрайта
;H'-полу ширина спрайта

;ret
;hl-X
;de-Y

            push hl

            bit  7,d
            jp   nz,ED_

            exx
            ld   a,h
            exx
            ld   l,a
            rlca
            and  1
            neg
            ld   h,a
JmP1:       jr   $
            ADDHLHL 9

            add  hl,bc
;DIV
            push de
            call FastDivide
            pop  de
            jr   c,ED_

            ld   bc,#30
            add  hl,bc

            pop  bc

            push hl
            exx
            ld   a,l
            exx
            ld   l,a
            rlca
            and  1
            neg
            ld   h,a
JmP2:       jr   $
            ADDHLHL 9

            add  hl,bc
;DIV

            call FastDivide
            jr   c,ED_

            or   a
            ld   bc,#80
            adc  hl,bc

            pop  de
            ret
ED_:
;  Экстренный выход
            pop  hl
            ld   a,3
            or   a
            ret


D3D2:
; Поиск коорд. вывода спрайта и размера
; и вывод спрайта
;bc-z,de-Y,hl-X
;HL'-реальн. размеры
;DE'-адрес спрайта
;a-масштаб
            sub  6
            neg
            ld   (JmP1+1),a
            ld   (JmP2+1),a

            ld   a,c
            ld   c,e
            ld   e,a
            ld   a,b
            ld   b,d
            ld   d,a
            ld   (X_+1),hl
            ld   (Y_+1),bc
            ld   (Z_+1),de
            exx
            add  hl,hl
            ld   a,l
            neg
            ld   l,a
            ld   a,h
            neg
            ld   h,a
            exx
            call D3D2_
            ret  pe
            push de
            push hl
X_:         ld   hl,0
Z_:         ld   de,0
Y_:         ld   bc,0
            exx
            ld   a,l
            neg
            ld   l,a
            ld   a,h
            neg
            ld   h,a
            exx
            call D3D2_
            pop  bc
            jp   po,ZJ76
ZJ75:
            pop  bc
            ret
ZJ76:
            SUB_BC
            jr   z,ZJ75
            srl  h
            rr   l
            srl  h
            jr   nz,ZJ75
            rr   l
            ld   h,b
            ld   a,c
            ld   c,l
            ld   l,a
            ld   a,c
            ex   af,af'
            EXD
            pop  bc
            SUB_BC
            ret  z
            srl  h
            rr   l
            srl  h
            ret  nz
            rr   l
            ld   a,h
            or   a
            ret  nz
            ex   af,af'
            ld   h,b
            ld   b,l
            ld   l,c
            ld   c,a
            EXD

            sra  h
            rr   l
            sra  d
            rr   e
            sra  h
            rr   l
            sra  d
            rr   e

            exx
            srl  h
            srl  l
            exx

;DE'-ADR OF OBJ
;HL'-REAL SIZE SPRITE L-X,H-Y
;b-SIZE Y,c-SIZE X
;hl-X,de-Y

            jp   VOX
