;==============================================================================
; VXXX - экспериментальный воксельный спрайт (масштаб + прозрачность)
;
; Предшественник VSPRITE. ORG отсутствует: собирается по текущему адресу (в make_VXXX - #C000).
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

; Процедура вывода вокс. спрайта с
; С масштабированием и прозрачностью
; Порит рег. i

XEND            equ 64
YEND            equ 24

; Voxel
VOX
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

D3D2_
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

        pop  de
        ret
ED_
        ; Экстренный выход
        pop  hl
        ld   a,3
        or   a
        ret

D3D2
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
        call D3D2_
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
        call D3D2_
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
        sra  h
        rr   l
        sra  d
        rr   e
        sra  h
        rr   l
        sra  d
        rr   e
        call VOX
        ret

        org  (($+255)&#FF00)
VXTAB
        incbin "assets/VOX2.bin"
