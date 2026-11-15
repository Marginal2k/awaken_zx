STEPX           equ 3
STEPY           equ 2
SZX             equ 5
SZY             equ 3

HSCR            equ #8000
XEND            equ 64
YEND            equ 24

        org  HSCR+((YEND/2)*#0100)
START
        di
        ; Пробный вывод воксель спрайта с масшта
        ; Бированием
        ld   hl,#4000
        ld   de,#4001
        ld   bc,#1800
        ld   (hl),l
        ldir
        ld   bc,#02FF
        ld   (hl),%00000111
        ldir
        ld   a,1
        out  (#FE),a

M2

        call CLER

        ld   de,TELE
        ld   hl,#3040
        exx
L1      ld   bc,#3040
X1      ld   hl,#01
Y1      ld   de,#00
        call Vox
        ei
        ld   a,0
        out  (#FE),a
        halt
        ld   a,2
        out  (#FE),a
        di
        call DROPH

        ld   hl,(L1+1)
        ;        Inc l:jr nz,$+3:inc l
        ;        Inc h:jr nz,$+3:inc h
        ld   (L1+1),hl

; INCL "CSIZE"  ; file CSIZE exists on no disk (not needed to assemble)
; INCL "CMOVE"  ; file CMOVE exists on no disk (not needed to assemble)

        xor  a
        in   a,(#FE)
        and  #1F
        cp   #1F
        jp   z,M2

        ld   a,#3F
        ld   i,a
        ei
        ret

; Voxel
Vox
        ; De'-adr of obj
        ; Hl'-real size sprite l-X,h-Y
        ; B-size Y,c-size X
        ; Hl-X,de-Y
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
        call Divv
        ; Коэф.по X=256*реал.ширина/заданная
        ex   de,hl
        ; В "hl"-коэф. масштабирования по X
        exx
        ld   a,h                ; Реальная высота
        exx
        ld   e,iyh              ; Заданная
        push hl
        ; Коеф. масштабирования по у
        call Divv
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
        ld   h,high(Vxtab)+3
        ld   a,#A9              ; Res 5,c
        jr   c,$+8
        set  5,c
        ld   h,high(Vxtab)
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

Divv
        ; De=a/e
        ld   l,a
        xor  a
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        adc  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        rl   l
        ld   c,l
        add  a,a
        sbc  a,e
        jr   nc,$+3
        add  a,e
        ld   h,a
        ld   a,l
        ld   l,h
        ld   h,0
        ld   d,h
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
        ld   e,a
        ld   a,c
        cpl
        ld   d,a
        ret

DROPH
        ld   hl,HSCR
        ld   de,#4000
        ld   bc,+(YEND/2)*#0100
M1
        ld   a,e
        dup  32
        ldi
        edup
        ret  po
        dec  de
        ld   e,a
        inc  d
        ld   a,d
        and  7
        jp   nz,$+13
        ld   a,e
        add  a,32
        ld   e,a
        jr   c,$+6
        ld   a,d
        sub  8
        ld   d,a
        jp   M1

CLER
        ld   (STK1+1),sp
        ld   sp,HSCR+((YEND/2)*#0100)
        ld   hl,#00
        ld   b,YEND/2
.M22
        dup  128
        push hl
        edup
        dec  b
        jp   nz,.M22
STK1    ld   sp,0
        ret

        ds   (((($-1)/256)*256)-$)+256
Vxtab
        incbin "assets/VOX2.bin"

TELE
        incbin "assets/CHAN1.bin"

END_
