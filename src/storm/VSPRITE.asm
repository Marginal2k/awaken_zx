; Процедура вывода вокс. спрайта с
; С масштабированием и прозрачностью
; Порит рег. i

        include "EQUS.asm"

        org  #C000
        jp   Vox_
        jp   TAKSPD_
        jp   OUTALL_
        jp   NEWPOS_
        jp   NEWPSS_
        jp   RETURN_
        jp   RRT_
        jp   RLT_
        jp   D3D2_

OUTALL_
        call CLER
        call LAND
        call SKY
        call MOVING
        jp   NIGHT

; Voxel
Vox_
        ; De'-adr of obj
        ; Hl'-real size sprite l-X,h-Y
        ; B-size Y,c-size X
        ; Hl-X,de-Y
        ld   a,b
        or   a
        ret  z
        ld   a,c
        or   a
        ret  z
        xor  a
        ld   i,a
        ld   (Vx+1),hl
        ld   (Vy+1),de
        ld   iyl,c              ; SZX
        ld   iyh,b              ; SZY
        ld   e,b
        exx
        ld   bc,0
        exx
        ld   b,0
Vx      ld   hl,0
        ld   a,h
        and  a
        jp   p,Vx1
        ; Если часть спрайта за экраном слева
        adc  hl,bc
        ret  m                  ; Весь спрайт за экраном
        ret  z                  ; Тоже
        ; Клипируем
        ld   a,l
        ld   hl,0               ; X=0
        ld   b,c
        ld   c,a                ; New LEN of X
        sub  b
        ld   b,l
        neg
        ; В "а" будет смещение по ширине для
        ; Изменения адреса спрайта
        exx
        ld   i,a
        set  0,c                ; Метка клипинга слева
        exx
        jp   Vx2
Vx1
        ret  nz                 ; За экрном справа
        ld   a,l
        cp   XEND
        ret  nc                 ; Тоже
Vx2
        add  hl,bc
        ld   a,h
        or   a
        ld   a,l
        jr   nz,$+6
        cp   XEND+1
        jr   c,Vy               ; Весь спр на экране по X
        ; Правая часть спрайта за экраном справа
        ; Клипируем
        sub  XEND
        sub  c
        neg
        ; Новая длинна спрайта
        ld   c,a
; Проверки по у
Vy      ld   hl,0
        ld   d,0
        ld   a,h
        and  a
        jp   p,Vx3
        ; Если спрайт выходит сверху за экран
        adc  hl,de
        ret  m                  ; Вылет по у вверху всего
        ; Спрайта
        ret  z                  ; Тоже
        ld   a,l
        ld   hl,0               ; У=0
        ld   d,e
        ld   e,a                ; Новая высота спрайта
        sub  d
        ld   d,l
        neg
        exx
        ; В "а" количество строк поддвергнутых
        ; Клиппингу, которые не видимы
        ld   b,a
        set  1,c                ; Маркер клипинга по у
        exx
        jp   Vx4
Vx3
        ret  nz                 ; Весь спрайт ниже скрина
        ld   a,l
        cp   YEND
        ret  nc                 ; Тоже
Vx4
        add  hl,de
        ld   a,h
        or   a
        ld   a,l
        jr   nz,$+6
        cp   YEND+1
        jr   c,Vx5
        ; Спрайт выше высоты скрана или вылез
        ; Снизу
        sub  YEND
        sub  e
        neg
        ld   e,a                ; Новая высота
Vx5
        ; Делаем нужные координаты если были
        ; Клиппинги
        exx
        ld   a,(Vx+1)
        bit  0,c
        jr   z,$+3
        xor  a
        bit  1,c
        exx
        ld   b,a                ; Координата х спрайта вывд
        ld   a,(Vy+1)
        jr   z,$+3
        xor  a
        ; "А"-коорд. у спрайта для вывода
        ; Расч. адр. на хайд слрине
        srl  a
        ld   l,d
        rr   l
        ld   h,a                ; Hl=коорд. вывода у/2
        ld   ixh,e              ; Количество строк
        ; Коорд. вывода X после клиппинга
        ld   e,b

        ; Запомним коорд. вывода х
        ld   a,e
        ld   (XX+1),a

        srl  e

        ; Подготовка к выводу вокселя
        ; Во втором полубайте
        ld   a,#30              ; Jr nc,
        jr   nc,$+6
        inc  c
        inc  c
        ld   a,#38              ; Jr c,
        ld   (AW3),a

        add  hl,de
        set  7,h
        ex   de,hl
        ; De-адр. в скрине
        push de
        push bc
        exx
        ld   a,l                ; Реальная ширина спрайта
        exx
        ld   b,a                ; Запомнили

        ; Изначально заданная выводимая ширина
        ld   e,iyl
        ; Расчитываем коэф. масштабирования по х
        call DIVV
        ; Коэф.по X=256*реал.ширина/заданная
        ex   de,hl
        ; В "hl"-коэф. масштабирования по X
        exx
        ld   a,h                ; Реальная высота
        exx
        ld   e,iyh              ; Заданная
        push hl
        ; Коеф. масштабирования по у
        call DIVV
        pop  hl
        ld   a,e
        ld   ixl,d              ; Стар.байт коеф.масш.по у
        exx
        ld   c,a
        ; В "c'" младш. байт коеф. масшт. по у
        ld   a,b
        and  a
        jr   z,Vx6
        ; Изменяем адрес спрайта если был
        ; Клиппинг по высоте спрайта
        ; С верху, резался с верху
        sla  b
        ld   hl,0
        ld   b,ixl
        add  hl,bc
        dec  a
        jp   nz,$-2
        ld   a,h
        and  a
        jr   z,Vx6
        ld   b,a
        exx
        ld   a,b
        exx
        ld   l,a
        ld   h,0
        ex   de,hl
        add  hl,de
        djnz $-1
        ex   de,hl
Vx6
        exx
        ld   a,i                ; Кол.клипнутых дабл
        ; Вокселей по ширине
        ; Слева
        and  a
        jr   z,P1
        ; Изменяем адрес спрайта если был клипинг
        ; Слева по ширине
        ex   de,hl
; Просуммируем коеф. масшт. по ширине
; Столько раз сколько нужно клипнуть
; Дабл вокселей

        ld   hl,0
        ex   af,af'
        xor  a
        ex   af,af'
        ex   af,af'
        add  hl,de
        adc  a,0
        ex   af,af'
        dec  a
        jp   nz,$-6

        ld   a,h
        exx
        ld   l,a
        ex   af,af'
        ld   h,a
        add  hl,de
        ex   de,hl
        exx
        ex   de,hl
P1
        ld   a,b
        pop  bc
        pop  de

; Вывод вокселя с масштабированием
; C-количество вокселей в строке
; De-адрес на скрине
; Hx-кол. строк
; Hl-коеф. смещения по х
; C'-младший байт прореживания по у
; Lx-старший байт прореживания по у
; De'-адрес спрайта, #xx00
; A-реальное кол. вокселей в строке
; Спрайта
Voxout
        ld   (Stkv+1),sp

        ld   (Vxll+1),a         ; Реальная ширина

        ld   sp,hl              ; Коеф. масш. по х
        ; Умножаем старший байт коеф.
        ; Прореживания на реальную длинну строки
        ; Что бы получить коеф. прореж. по у
        ; Кратный длинне строки
        ld   b,a
        ld   a,ixl
        or   a
        jr   z,P2
        ld   hl,0
        ex   af,af'
        ld   a,c
        ex   af,af'
        ld   c,b
        ld   b,0
        add  hl,bc
        dec  a
        jp   nz,$-2
        ex   af,af'
        ld   c,a

        ld   a,l
        ld   ixl,a
        ld   a,h
; "А"-смещение для ст.байта адреса спрайт
P2
        ld   (WE1+1),a

; Расчитываем адрес начала вывода вокселя
; В развернутом цикле процедуры

; Подготовка к выводу одного вокселя
; В первом полубйте
; Находим след. коорд. х после спрайта
; Если 0 бит ее =0 то весь знакомест
; В вокселях
; Иначе только один первый полузнакомест
; Заполняется
XX      ld   a,0
        add  a,c
        rra
        ld   a,#0F
        jr   nc,Q2
        ld   a,(AW3)
        cp   #38
        jr   z,$+3
        inc  c
        xor  a
Q2
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
; 84b

        dup  2
        add  hl,hl
        edup
        add  hl,bc
        dup  2
        add  hl,hl
        edup
        add  hl,bc
        dup  2
        add  hl,hl
        edup
        ld   bc,VXL4
        add  hl,bc
        ld   (VXL3+1),hl
AW3     jr   nc,Q1
        inc  hl
        inc  hl
        inc  hl
        inc  hl
        ld   (hl),0
        dec  hl
Q1
        ld   (VXL2+1),hl
        ld   iyl,e              ; Дублируем мл.байт адреса
        ld   c,e
        ld   b,d
        rra
        ld   h,high(VXTAB)+3
        ld   a,#A9              ; Res 5,c
        jr   c,$+8
        set  5,c
        ld   h,high(VXTAB)
        ld   a,#E9              ; Set 5,c
        ld   (AW4+1),a
        ld   a,h
        ld   (AW5+1),a

        ld   d,#0F
        exx
        xor  a
        ld   b,e
Vxl3
        ; A'-счетчик смещения по строкам
        ; Lx-старший байт прореж. по у,кратен кол
        ; Вокселей в строке
        ex   af,af'
        ld   h,b
        ld   l,0

; Sp-прореж. по х
; H-младший байт адреса спрайта
; L-его счетчик к увеличению
; D-старший байт адреса спрайта
VXL2    jp   0

VXL4
        include "VOXP.asm"

; 157 Takts one cycle

        ld   a,iyl
        add  a,#80
        ld   c,a
        ld   iyl,a
        jr   nc,$+3
        inc  b
AW4     set  5,c
AW5     ld   h,0
        exx
        ex   af,af
        add  a,c
        ld   l,a
        ld   a,b
        jr   nc,$+6
Vxll    add  a,0                ; LEN of string
        jr   c,V3
V4
        add  a,ixl
        ld   b,a
        ld   a,d
WE1     adc  a,0
        ld   d,a
        ld   a,l
        dec  ixh
        jp   nz,Vxl3
VXL3    ld   hl,0
        dup  4
        inc  hl
        edup
        ld   (hl),#F0

Stkv    ld   sp,0
        ret
V3      inc  d
        jp   V4

LAND
        ld   (Stkv_+1),sp
        ld   a,#20
        ld   (TYPE_+1),a

        ld   a,#30              ; Jr nc
        ld   (COM2),a
        ld   a,#24              ; Inc h
        ld   (COM1),a

        ld   b,#0B              ; Кол.вокс.строк земли
        exx

        ld   hl,(PLANT)
        ld   (ADSPR+1),hl

        ; Hl-адр. в скрине
        ld   hl,#8680

VXL3_
        ld   e,l                ; Дублируем мл.байт адреса
        ld   d,#80
        ld   b,high(VXTAB)
        set  5,l
        exx

        ld   a,0
Vxl3_
        ld   c,a
        ex   af,af'
; Таблица прореж. по х и по у
; Для каждой позиции у
; Первый, второй байты смещ. в адр.спрйта
; Третий, четвертый байты прореж. по X

        ld   a,c
        rlca
TYPE_   or   0                  ; 0-Почва,#40-небо
        ld   l,a
        ld   h,high(TSX)

        ld   e,(hl)
        inc  l
        ld   d,(hl)
        ex   de,hl
        ld   sp,hl
        ex   de,hl

        res  5,l

        ld   d,(hl)
        dec  l
        ld   e,(hl)
ADSPR   ld   hl,0
        add  hl,de
        ex   de,hl

        ld   h,e
        ld   l,0

; Sp-прореж. по х
; H-младший байт адреса спрайта

; L-его счетчик к увеличению
; D-старший байт адреса спрайта
; C-счетчик строк

VXL4_
        include "VOXL.asm"

        ld   a,e
        add  a,d
        ld   l,a
        ld   e,a
COM2    jr   nc,$+3             ; Jr nc/c
COM1    inc  h                  ; Inc/dec
        set  5,l
        exx
        ex   af,af'
        inc  a
        dec  b
        jp   nz,Vxl3_
Stkv_   ld   sp,0
        ret

SKY
        ld   (Stkv_+1),sp

        ld   a,#60
        ld   (TYPE_+1),a

        ld   a,#38              ; Jr c
        ld   (COM2),a
        ld   a,#25              ; Dec h
        ld   (COM1),a

        ld   hl,(SKYS)
        ld   (ADSPR+1),hl

        ld   b,#0A
        exx

        ; De-адр. в скрине
        ld   hl,#8480
        jp   VXL3_

NIGHT
        ; Затухание спрайтов для создания
        ; Эфекта  ночи
        ld   hl,1
        dec  hl
        ld   (NIGHT+1),hl
        ld   a,l
        or   h
        ret  nz
        ld   hl,1000
        ld   (NIGHT+1),hl

        ld   hl,(SKYS)
        ld   bc,#0C00
G1
        ld   a,(hl)
        or   a
        jr   z,$+5
        sub  #11
        ld   (hl),a
        inc  hl
        dec  bc
        ld   a,b
        or   c
        jp   nz,G1

        ld   a,%10101010
        rrca
        ld   ($-2),a
        ret  nc
        ld   hl,(PLANT)
        ld   bc,#0C00
.G2
        ld   a,(hl)
        or   a
        jr   z,$+5
        sub  #11
        ld   (hl),a
        inc  hl
        dec  bc
        ld   a,b
        or   c
        jp   nz,.G2
        ret

RETURN_
        ; Восстановление руля
        ld   a,%10101010
        rrca
        ld   ($-2),a
        ret  nc
        ld   a,(UNGLE)
        or   a
        ret  z
        jp   p,RLT_
        jp   RRT_

RLT_
        ld   a,(UNGLE)
        dec  a
        jp   p,$+7
        cp   0-MAX_TURN
        jr   c,$+5
        ld   (UNGLE),a
RP4
        ld   l,a
        ld   bc,TSX
.RP44
        ld   a,(bc)
        ld   e,a
        add  a,l
        and  #3F
        ld   d,a
        ld   a,e
        and  #C0
        or   d
        ld   (bc),a
        set  6,c
        ld   a,(bc)
        ld   e,a
        add  a,l
        and  #3F
        ld   d,a
        ld   a,e
        and  #C0
        or   d
        ld   (bc),a
        res  6,c
        inc  c
        inc  c

        ld   a,#18
        cp   c
        jp   nz,.RP44
        ret

RRT_
        ; Поворот вправо экрана
        ld   a,(UNGLE)
        inc  a
        jp   m,$+7
        cp   MAX_TURN+1
        jr   nc,$+5
        ld   (UNGLE),a
        jp   RP4

TAKSPD_
        ; Включить скорость
        or   a
        ld   c,a
        ld   a,%10001000
        jp   m,.RP0
        ld   a,%10001000
        jr   z,.RP0
        dec  c
        ld   a,%10001000
        jr   z,.RP0
        dec  c
        ld   a,%10101010
        jr   z,.RP0
        ld   a,#FF
.RP0
        ld   (MDN+1),a
        ret

MOVING
        ld   a,(SPEED)
        or   a
        jp   z,NEBO2
        jp   p,MDN
        ; Перемещение фона от себя
        ld   a,(MDN+1)
        rlca
        ld   (MDN+1),a
        ret  nc
        ld   bc,TSX
        ld   de,#40
.RP1
        ld   a,(bc)
        ld   l,a
        inc  c
        ld   a,(bc)
        ld   h,a
        add  hl,de
        ld   a,h
        cp   #0B
        jr   nz,.RP5
        ld   h,0
        ld   a,l
        sub  19
        and  #3F
        ld   l,a
.RP5
        ld   a,h
        ld   (bc),a
        dec  c
        ld   a,l
        ld   (bc),a
        inc  c
        inc  c
        ld   a,#18
        cp   c
        jp   nz,.RP1
        jp   NEBO

MDN
        ; Перемещение фона к себе
        ld   a,%10101010
        rrca
        ld   ($-2),a
        jp   nc,NEBO
        ld   de,#FFC0
        ld   bc,TSX
.RP2
        ld   a,(bc)
        ld   l,a
        inc  c
        ld   a,(bc)
        ld   h,a
        add  hl,de
        jr   c,.RP3
        ld   h,#0A
        ld   a,l
        add  a,19
        and  #3F
        or   #C0
        ld   l,a
.RP3
        ld   a,h
        ld   (bc),a
        dec  c
        ld   a,l
        ld   (bc),a
        inc  c
        inc  c
        ld   a,#18
        cp   c
        jp   nz,.RP2
        jp   NEBO

NEBO2
        ld   a,%10101010
        rlca
        ld   ($-2),a
        ret  nc
NEBO
        ld   a,%00100000
        rlca
        ld   ($-2),a
        ret  nc
        ld   de,#FFC0
        ld   bc,TSXS
.RP22
        ld   a,(bc)
        ld   l,a
        inc  c
        ld   a,(bc)
        ld   h,a
        add  hl,de
        jr   c,.RP32
        ld   h,#0A
        ld   a,l
        add  a,19
        and  #3F
        or   #C0
        ld   l,a
.RP32
        ld   a,h
        ld   (bc),a
        dec  c
        ld   a,l
        ld   (bc),a
        inc  c
        inc  c
        ld   a,#58
        cp   c
        jp   nz,.RP22
        ret

CLER
        ld   (STK1+1),sp
        ld   sp,#8680
        ld   hl,#00
        dup  192
        push hl
        edup
STK1    ld   sp,0
        ret

FINDY
        exx
        push de
        ld   a,h
        exx
        pop  de
        ld   l,a
        ld   h,0
        call DIVW
        ex   de,hl
        ret
FINDX
        exx
        ld   a,d
        exx
        ld   e,a
        exx
        ld   a,l
        exx
        call DIVV
        ret

STORED
        push bc
        exx
        ld   a,b
        exx
        ld   hl,0
        or   a
        jr   z,.S1
        ld   bc,#40
        add  hl,bc
        dec  a
        jp   nz,$-2
.S3
        ld   a,h
        cp   #0A
        jr   c,.S1
        sub  #0A
        ld   h,a
        jr   .S3
.S1
        push hl
        call FINDX
        ex   de,hl
        push hl
        xor  a
        dup  8
        add  hl,hl
        adc  a,a
        edup
        ld   d,a
        ld   e,h
        ld   a,#40
        call DIV
        ex   de,hl
        ld   (ix+#20),e
        ld   (ix+#21),d
        pop  bc
        pop  hl
        ld   a,#20
        sub  b
        ; A-кол. вокс. которые нужно пропустить
        ; На экране
        ; Нужно кол. вокселей кот. нужно пропуст.
        ; В строке
        ; X=a*d.e
        push hl
        ; Hl=a*de
        ld   c,#00
        ld   h,c
        ld   l,c
        add  a,a
        add  a,a
        jr   c,$+23
        add  a,a
        jr   c,$+26
        add  a,a
        jr   c,$+29
        add  a,a
        jr   c,$+32
        add  a,a
        jr   c,$+35
        add  a,a
        jr   c,$+38
        add  a,a
        jr   c,$+41
        jp   $+45
        add  hl,de
        adc  a,c
        add  hl,hl
        adc  a,a
        jr   nc,$+4
        add  hl,de
        adc  a,c
        add  hl,hl
        adc  a,a
        jr   nc,$+4
        add  hl,de
        adc  a,c
        add  hl,hl
        adc  a,a
        jr   nc,$+4
        add  hl,de
        adc  a,c
        add  hl,hl
        adc  a,a
        jr   nc,$+4
        add  hl,de
        adc  a,c
        add  hl,hl
        adc  a,a
        jr   nc,$+4
        add  hl,de
        adc  a,c
        add  hl,hl
        adc  a,a
        jr   nc,$+4
        add  hl,de
        adc  a,c
        ld   l,h
        ld   h,a
        pop  de
        ld   a,e
        and  #C0
        ld   h,a
        ld   a,e
        sub  l
        and  #3F
        or   h
        ld   e,a
        ld   (ix+#00),e
        ld   (ix+#01),d
        pop  bc
        ret
NEWPSS_
        ld   ix,TSXS
        jr   $+6
NEWPOS_
        ; Расчет таблиц прореживания
        ld   ix,TSX
        ld   a,13
        ex   af,af'
        ld   bc,0
        exx
        call FINDY
        ld   a,e
        ld   (MINY+1),a

; Поиск след. позиции воксель строки по у
NP2
        call FINDY
MINY    ld   a,#00
        sub  e
        jr   nc,NP1
        ld   a,e
        ld   (MINY+1),a
S2
        ex   af,af'
        dec  a
        ret  z
        ex   af,af'
        call STORED
        inc  ix
        inc  ix
NP1
        exx
        ld   a,c
        add  a,STP
        ld   c,a
        ld   a,b
        adc  a,0
        ld   b,a

        ld   a,e
        sub  STP
        ld   e,a
        ld   a,d
        sbc  a,0
        ld   d,a
        exx
        jp   nz,NP2
        ret

DIVV
        ; De=a/e
        ld   l,a
        xor  a
        sll  l
        sll  l
        jr   c,M1
        sll  l
        jr   c,M1+7
        sll  l
        jr   c,M1+(7*2)
        sll  l
        jr   c,M1+(7*3)
        sll  l
        jr   c,M1+(7*4)
        sll  l
        jr   c,M1+(7*5)
        sll  l
        jp   M1+(7*6)
M1
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        rla
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        ld   c,l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        ld   a,l
        cpl
        ld   e,a
        ld   a,c
        cpl
        ld   d,a
        ret

DIVW
        ; Hl=hl/de
        ld   a,l
        ld   l,0
        jr   DIV+3
DIV
        ; Hl=a/d.e
        ld   hl,0
        and  a
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        and  a
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        ld   b,a
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        cpl
        ld   l,a
        ld   a,b
        cpl
        ld   h,a
        ret

D3D2__
; Расчет из 3d в 2d
; Hl-X,de-z,bc-Y
; L'-полу высота спрайта
; H'-полу ширина спрайта
; De-z
; Bc-Y

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
Jmp1    jr   $
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl

        add  hl,hl

        and  a
        adc  hl,bc
        jp   p,$+10
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ex   af,af'
        ; DIV
        ld   a,d
        or   a
        jp   z,PP0
        xor  a
        sll  l
        rl   h
        jr   c,PP1
        sll  l
        rl   h
        jr   c,PP1+6
        sll  l
        rl   h
        jr   c,PP1+(6*2)
        sll  l
        rl   h
        jr   c,PP1+(6*3)
        sll  l
        rl   h
        jr   c,PP1+(6*4)
        sll  l
        rl   h
        jr   c,PP1+(6*5)
        sll  l
        rl   h
        jr   c,PP1+(6*6)
        sll  l
        rl   h
        jr   c,PP1+(6*7)
        sll  l
        rl   h
        jr   c,PP1+(6*8)
        sll  l
        rl   h
        ld   b,l
        jr   c,+(PP1+(6*9))+1
        sll  l
        rl   h
        jr   c,+(PP1+(6*10))+1
        sll  l
        rl   h
        jr   c,+(PP1+(6*11))+1
        sll  l
        rl   h
        jr   c,+(PP1+(6*12))+1
        sll  l
        rl   h
        jr   c,+(PP1+(6*13))+1
        sll  l
        rl   h
        jr   c,+(PP1+(6*14))+1
        sll  l
        rl   h
        jp   c,+(PP1+(6*15))+1
        ; Zero
        ld   b,a
        jp   PP9

PP1
        rla
        cp   d
        jr   nc,PP2
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+7
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*2)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*3)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*4)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*5)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*6)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*7)
        adc  hl,hl
        rla
        ld   b,l
        cp   d
        jr   nc,PP2+(7*8)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*9)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*10)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*11)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*12)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*13)
        adc  hl,hl
        rla
        cp   d
        jr   nc,PP2+(7*14)
        adc  hl,hl
        rla
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+63)+(7*6)

PP2

        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP3
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+8
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+(8*2)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+(8*3)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+(8*4)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+(8*5)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+(8*6)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   PP4+(8*7)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+(8*8))-1

        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+63)+7
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+63)+(7*2)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+63)+(7*3)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+63)+(7*4)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(PP4+63)+(7*5)

PP0
        ld   a,l
        ld   l,h
        ld   h,0
        sbc  hl,de
        jp   nc,ED_
        add  hl,de
        rla
        adc  hl,hl
PP3
        sbc  hl,de
        jp   nc,ED_
        add  hl,de
        rla
        adc  hl,hl
PP4
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        ld   b,a
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
PP9
        ld   c,a
        ex   af,af'
        ld   hl,#30             ; Midle Y
        jp   m,$+8
        sbc  hl,bc
        jp   $+4
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
Jmp2    jr   $
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl

        add  hl,hl

        and  a
        adc  hl,bc
        jp   p,$+10
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ex   af,af'
        ; DIV
        ld   a,d
        or   a
        jp   z,O0
        xor  a
        sll  l
        rl   h
        jr   c,O1
        sll  l
        rl   h
        jr   c,O1+6
        sll  l
        rl   h
        jr   c,O1+(6*2)
        sll  l
        rl   h
        jr   c,O1+(6*3)
        sll  l
        rl   h
        jr   c,O1+(6*4)
        sll  l
        rl   h
        jr   c,O1+(6*5)
        sll  l
        rl   h
        jr   c,O1+(6*6)
        sll  l
        rl   h
        jr   c,O1+(6*7)
        sll  l
        rl   h
        jr   c,O1+(6*8)
        sll  l
        rl   h
        ld   b,l
        jr   c,+(O1+(6*9))+1
        sll  l
        rl   h
        jr   c,+(O1+(6*10))+1
        sll  l
        rl   h
        jr   c,+(O1+(6*11))+1
        sll  l
        rl   h
        jr   c,+(O1+(6*12))+1
        sll  l
        rl   h
        jr   c,+(O1+(6*13))+1
        sll  l
        rl   h
        jr   c,+(O1+(6*14))+1
        sll  l
        rl   h
        jp   c,+(O1+(6*15))+1
        ; Zero
        ld   b,a
        jp   O9

O1
        rla
        cp   d
        jr   nc,O2
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+7
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*2)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*3)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*4)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*5)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*6)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*7)
        adc  hl,hl
        rla
        ld   b,l
        cp   d
        jr   nc,O2+(7*8)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*9)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*10)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*11)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*12)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*13)
        adc  hl,hl
        rla
        cp   d
        jr   nc,O2+(7*14)
        adc  hl,hl
        rla
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+63)+(7*6)

O2

        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O3
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+8
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+(8*2)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+(8*3)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+(8*4)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+(8*5)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+(8*6)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   O4+(8*7)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+(8*8))-1

        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+63)+7
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+63)+(7*2)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+63)+(7*3)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+63)+(7*4)
        ld   c,a
        ld   a,l
        ld   l,h
        ld   h,c
        jp   +(O4+63)+(7*5)

O0
        ld   a,l
        ld   l,h
        ld   h,0
        sbc  hl,de
        jp   nc,ED_
        add  hl,de
        rla
        adc  hl,hl
O3
        sbc  hl,de
        jp   nc,ED_
        add  hl,de
        rla
        adc  hl,hl
O4
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        adc  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        ld   b,a
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
        add  hl,hl
        sbc  hl,de
        jr   nc,$+3
        add  hl,de
        rla
O9
        ld   c,a
        ex   af,af'
        ld   hl,#0080           ; Midle X
        jp   m,$+8
        sbc  hl,bc
        jp   $+4
        add  hl,bc
        pop  de
        ret
ED_
        ; Экстренный выход
        pop  hl
        ld   a,3
        or   a
        ret

D3D2_
        ; Поиск коорд. вывода спрайта и размера
        ; И вывод спрайта
        ; Bc-z,de-Y,hl-X
        ; Hl'-реальн. размеры
        ; De'-адрес спрайта
        ; A-масштаб
        sub  6
        neg
        ld   (Jmp1+1),a
        ld   (Jmp2+1),a

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
        ld   a,l
        neg
        ld   l,a
        ld   a,h
        neg
        ld   h,a
        exx
        call D3D2__
        ret  pe
        push de
        push hl
X_      ld   hl,0
Z_      ld   de,0
Y_      ld   bc,0
        exx
        ld   a,l
        neg
        ld   l,a
        ld   a,h
        neg
        ld   h,a
        exx
        call D3D2__
        ret  pe
        pop  bc
        or   a
        sbc  hl,bc
        ret  z
        srl  h
        rr   l
        srl  h
        ret  nz
        rr   l
        ld   h,b
        ld   a,c
        ld   c,l
        ld   l,a
        ld   a,c
        ex   af,af'
        ex   de,hl
        pop  bc
        or   a
        sbc  hl,bc
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
        ex   de,hl
        dup  2
        sra  h
        rr   l
        edup
        dup  2
        sra  d
        rr   e
        edup
        call VOX_DRAW
        ret

        org  (($+255)&#FF00)
VXTAB
        incbin "assets/VOX2.bin"

TSX
        ; Смещения в адресе спрайта для каждой
        ; Позиции вывода у для почвы
        dw   #0140+#24
        dw   #0200+#0E
        dw   #0240+#23
        dw   #02C0+#30
        dw   #0340+#39
        dw   #03C0+#3F
        dw   #0480+#04
        dw   #04C0+#07
        dw   #0500+#0A
        dw   #0500+#0C
        dw   #0500+#0D
        dw   #0540+#0F
        dw   0, 0, 0, 0

        dw   #0400
        dw   #02AA
        dw   #01F8
        dw   #018C
        dw   #0142
        dw   #0110
        dw   #00E6
        dw   #00CE
        dw   #00B5
        dw   #00A6
        dw   #009A
        dw   #008C
        dw   0, 0, 0, 0

TSXS
        ; Смещения в адресе спрайта для каждой
        ; Позиции вывода у для неба
        dw   #0140+#24
        dw   #0200+#0E
        dw   #0240+#23
        dw   #02C0+#30
        dw   #0340+#39
        dw   #03C0+#3F
        dw   #0480+#04
        dw   #04C0+#07
        dw   #0500+#0A
        dw   #0500+#0C
        dw   #0500+#0D
        dw   #0540+#0F
        dw   0, 0, 0, 0

        dw   #0400
        dw   #02AA
        dw   #01F8
        dw   #018C
        dw   #0142
        dw   #0110
        dw   #00E6
        dw   #00CE
        dw   #00B5
        dw   #00A6
        dw   #009A
        dw   #008C

END_
