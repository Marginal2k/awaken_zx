;NWTEL
;NWVOS
;VOX
;MULABC
;DIVV
;D3D2_
;D3D2


NWTEL:
; ИНИЦИАЛИЗАЦИЯ НОВОГО ТЕЛЕПОРТА
            ld   hl,VSPR2
            ld   de,#00C0
            ld   (MASHT+3),a
            ld   a,12
            ld   (VLL2+3),a
            ld   a,12
            ld   (VLL1+3),a
; КОЛ.ФРЕЙМОВ
            ld   a,#0D
            ld   (VLL3+1),a
            jp   ZJ1-3

NWVOS:
; ИНИЦИАЛИЗАЦИЯ НОВОГО ВЗРЫВА
;HL'-X,DE'-Y,BC'-Z
;A'-ВРЕМЯ ЖИЗНИ
;a-МАСШТАБ
;  ЧТО БУДЕТ ЗАДАНО В ПРОЦЕДУРЕ
;hl-АДРЕС СПРАЙТОВ
;b-КОЛИЧЕСТВО ФРЕЙМОВ В АНИМАЦИИ
;de-РАЗМЕР В БАЙТАХ ОДНОГО ФРЕЙМА
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
; ВРЕМЯ ЖИЗНИ
            ld   (iy+7),a
            exx
MASHT:      ld   (iy+6),0
; ТЕКУЩИЙ АДРЕС ФРЕЙМА
            ld   (iy+8),l
            ld   (iy+9),h
; АДРЕС НАЧАЛА АНИМАЦИИ
            ld   (iy+10),l
            ld   (iy+11),h
; НОМЕР ТЕКУЩЕГО КАДРА, НУМЕРУЕМ С КОНЦА
; ЗАДАЕМ НОМЕР ПОСЛЕДНЕГО = 1, ЧТО БЫ
; ПЕРЕКЛЮЧИТЬСЯ НА ПЕРВЫЙ
            ld   (iy+12),1
VLL3:       ld   a,0
; КОЛИЧЕСТВО КАДРОВ
            ld   (iy+13),a
; ДЛИННА КАДРА В БАЙТАХ
            ld   (iy+14),e
            ld   (iy+15),d
; ДЛИННА ПО X
VLL1:       ld   (iy+16),0
; ВЫСОТА ПО Y
VLL2:       ld   (iy+17),0
            ret


; ПРОЦЕДУРА ВЫВОДА ВОКС. СПРАЙТА С
; С МАСШТАБИРОВАНИЕМ И ПРОЗРАЧНОСТЬЮ
; ПОРИТ РЕГ. i


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
            jp   p,VX1
; ЕСЛИ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СЛЕВА
            adc  hl,bc
            ret  m                  ;ВЕСЬ СПРАЙТ ЗА ЭКРАНОМ
            ret  z                  ;TOЖe
; КЛИПИРУЕМ
            ld   a,l
            ld   hl,0               ;X=0
            ld   b,c
            ld   c,a                ;NEW LEN OF X
            sub  b
            ld   b,l
            neg
; В "А" БУДЕТ СМЕЩЕНИЕ ПО ШИРИНЕ ДЛЯ
; ИЗМЕНЕНИЯ АДРЕСА СПРАЙТА
            exx
            ld   (DBV+1),a
            set  0,c                ;МЕТКА КЛИПИНГА СЛЕВА
            exx
            jp   VX2
VX1:
            ret  nz                 ;ЗА ЭКРАНОМ СПРАВА
            ld   a,l
            cp   Xend
            ret  nc                 ;ТОЖЕ
VX2:
            add  hl,bc
            ld   a,h
            or   a
            ld   a,l
            jr   nz,$+6
            cp   Xend+1
            jr   c,VY               ;ВЕСЬ СПР НА ЭКРАНЕ ПО X
; ПРАВАЯ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СПРАВА
; КЛИПИРУЕМ
            sub  Xend
            sub  c
            neg
; НОВАЯ ДЛИННА СПРАЙТА
            ld   c,a
; ПРОВЕРКИ ПО У
VY:         ld   hl,0
            ld   d,0
            ld   a,h
            and  a
            jp   p,VX3
; ЕСЛИ СПРАЙТ ВЫХОДИТ СВЕРХУ ЗА ЭКРАН
            adc  hl,de
            ret  m                  ;ВЫЛЕТ ПО У ВВЕРХУ ВСЕГО
; СПРАЙТА
            ret  z                  ;ТОЖЕ
            ld   a,l
            ld   hl,0               ;У=0
            ld   d,e
            ld   e,a                ;НОВАЯ ВЫСОТА СПРАЙТА
            sub  d
            ld   d,l
            neg
            exx
; В "А" КОЛИЧЕСТВО СТРОК ПОДДВЕРГНУТЫХ
; КЛИППИНГУ, КОТОРЫЕ НЕ ВИДИМЫ
            ld   b,a
            set  1,c                ;МАРКЕР КЛИПИНГА ПО У
            exx
            jp   VX4
VX3:
            ret  nz                 ;ВЕСЬ СПРАЙТ НИЖЕ СКРИНА
            ld   a,l
            cp   Yend
            ret  nc                 ;ТОЖЕ
VX4:
            add  hl,de
            ld   a,h
            or   a
            ld   a,l
            jr   nz,$+6
            cp   Yend+1
            jr   c,VX5
; СПРАЙТ ВЫШЕ ВЫСОТЫ СКРИНА ИЛИ ВЫЛЕЗ
; СНИЗУ
            sub  Yend
            sub  e
            neg
            ld   e,a                ;НОВАЯ ВЫСОТА


VX5:
; ДЕЛАЕМ НУЖНЫЕ КООРДИНАТЫ ЕСЛИ БЫЛИ
; КЛИППИНГИ
            exx
            ld   a,(VX+1)
            bit  0,c
            jr   z,$+3
            xor  a
            bit  1,c
            exx
            ld   b,a                ;КООРДИНАТА Х СПРАЙТА ВЫВД
            ld   a,(VY+1)
            jr   z,$+3
            xor  a
; А-КООРД. У СПРАЙТА ДЛЯ ВЫВОДА
; РАСЧ. АДР. НА ХАЙД СЛРИНЕ
            srl  a
            ld   l,d
            rr   l
            ld   h,a                ;hl=КООРД. ВЫВОДА У/2
            ld   ixh,e              ;КОЛИЧЕСТВО СТРОК
; КООРД. ВЫВОДА X ПОСЛЕ КЛИППИНГА
            ld   e,b

; ЗАПОМНИМ КООРД. ВЫВОДА Х
            ld   a,e
            ld   (XX+1),a

            srl  e

; ПОДГОТОВКА К ВЫВОДУ ВОКСЕЛЯ
; ВО ВТОРОМ ПОЛУБАЙТЕ
            ld   a,#30              ;jrnc,
            jr   nc,$+6
            inc  c
            inc  c
            ld   a,#38              ;jrc,
            ld   (AW3),a


            add  hl,de
            set  7,h
            EXD
; В de-АДР. В СКРИНЕ


            push de
            push bc


; РАСЧИТЫВАЕМ КОЭФ. МАСШТАБИРОВАНИЯ ПО Х
            exx
            ld   a,l                ;РЕАЛЬНАЯ ШИРИНА СПРАЙТА
            exx
            ld   b,a                ;ЗАПОМНИЛИ
; ИЗНАЧАЛЬНО ЗАДАННАЯ ВЫВОДИМАЯ ШИРИНА
            ld   e,iyl
            call DIVV
; КОЭФ.ПО X=256*РЕАЛ.ШИРИНА/ЗАДАННАЯ
            EXD
; В "HL"-КОЭФ. МАСШТАБИРОВАНИЯ ПО X


; КОЕФ. МАСШТАБИРОВАНИЯ ПО У
            exx
            ld   a,h                ;РЕАЛЬНАЯ ВЫСОТА
            exx
            ld   e,iyh              ;ЗАДАННАЯ
            push hl
            call DIVV
            pop  hl
            ld   a,e
; СТАР.БАЙТ КОЕФ.МАСШ.ПО У
            ld   ixl,d
            exx
            ld   c,a
; В "C" МЛАДШ. БАЙТ КОЕФ. МАСШТ. ПО У


            exx
; ИЗНАЧАЛЬНАЯ ШИРИНА СПРАЙТА
; НЕОБХОДИМО СДЕЛАТЬ ЕЕ КРАТНОЙ 2^n
; Т.Е. ЕСЛИ ОНА = 20 ,ТО БУДЕТ 32
            ld   a,b
            cp   17
            jr   nc,$+6
            ld   a,16
            jr   $+4
            ld   a,32
            ld   b,a
            exx


; В bКОЛИЧЕСТВО ВИДИМЫХ СТРОК КЛИПНУТЫХ
; СВЕРХУ
            ld   a,b
            and  a
            jr   z,VX6

; В xlСТАР.БАЙТ КОЕФ.МАСШ.ПО У

; ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ
; КЛИППИНГ ПО ВЫСОТЕ СПРАЙТА С ВЕРХУ,
; РЕЗАЛСЯ С ВЕРХУ
            ld   b,ixl
; hl=a*bc
; a КОЛ ВИДИМЫХ СТРОК КОТОРЫЕ НУЖНО
            ; ??? ПРОПУСТИТЬ СВЕРХУ
; bcКОЕФ. МАСШТАБИРОВАНИЯ ПО Y
; h БУДЕТ КОЛ СТРОК СПРАЙТА КОТОРЫЕ
            ; ??? НУЖНО БУДЕТ ПРОПУСТИТЬ
            call MULABC

            ld   a,h
            and  a
            jr   z,VX6
            ld   b,a
            exx
            ld   a,b
            exx

; УМНОЖИМ ДЛИННУ В БАЙТАХ СТРОКИ НА
; КОЛИЧЕСТВО СТРОК СПРАЙТА КОТОРЫЕ НАДО
; ПРОПУСТИТЬ И СЛОЖИТЬ ПОЛУЧЕННОЕ
; КОЛИЧЕСТВО БАЙТ С АДРЕСОМ СПРАЙТА, ЧТОБ
; НАЙТИ НОВЫЙ АДРЕС ДЛЯ НАЧАЛА ВЫВОДА
; deАДРЕС СПРАЙТА
; a ДЛИННА В БАЙТАХ СТРОКИ СПРАЙТА
; b КОЛ. СТРОК ПРОПУСТИТЬ
            push bc
            ld   c,a
            ld   a,b
            ld   b,0
            call MULABC
            pop  bc
            add  hl,de
            EXD
VX6:
            exx
DBV:        ld   a,0                ;КОЛ.КЛИПНУТЫХ ДАБЛ
; ВОКСЕЛЕЙ ПО ШИРИНЕ
; СЛЕВА
            and  a
            jr   z,P1
; ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ КЛИПИНГ
; СЛЕВА ПО ШИРИНЕ

            EXD

; ПРОСУММИРУЕМ КОЕФ. МАСШТ. ПО ШИРИНЕ
; СТОЛЬКО РАЗ СКОЛЬКО НУЖНО КЛИПНУТЬ
; ДАБЛ ВОКСЕЛЕЙ

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
P1:
            ld   a,b
            pop  bc
            pop  de

; ВЫВОД ВОКСЕЛЯ С МАСШТАБИРОВАНИЕМ
; c-КОЛИЧЕСТВО ВОКСЕЛЕЙ В СТРОКЕ
; de-АДРЕС НА СКРИНЕ
; xh-КОЛ. СТРОК
; hl-КОЕФ. СМЕЩЕНИЯ ПО Х
; C'-МЛАДШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
; xl-СТАРШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
; DE'-АДРЕС СПРАЙТА, #XX00
; a-РЕАЛЬНОЕ КОЛ. ВОКСЕЛЕЙ В СТРОКЕ
; ПРИВЕДЕННОЕ К КРАТНОСТИ 2^n: 16 ИЛИ 32
; В СПРАЙТА
VOXOUT:
            ld   (STKV+1),sp

            ld   (VXLL+1),a         ;РЕАЛЬНАЯ ШИРИНА

            ld   sp,hl              ;КОЕФ. МАСШ. ПО Х
; УМНОЖАЕМ СТАРШИЙ БАЙТ КОЕФ.
; ПРОРЕЖИВАНИЯ НА РЕАЛЬНУЮ ДЛИННУ СТРОКИ
; ЧТО БЫ ПОЛУЧИТЬ КОЕФ. ПРОРЕЖ. ПО У
; КРАТНЫЙ ДЛИННЕ СТРОКИ
            ld   b,a
            ld   a,ixl
            or   a
            jr   z,P2
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
; В a-СМЕЩЕНИЕ ДЛЯ СТ.БАЙТА АДРЕСА СПРАЙТ
P2:
            ld   (WE1+1),a

; РАСЧИТЫВАЕМ АДРЕС НАЧАЛА ВЫВОДА ВОКСЕЛЯ
; В РАЗВЕРНУТОМ ЦИКЛЕ ПРОЦЕДУРЫ

; ПОДГОТОВКА К ВЫВОДУ ОДНОГО ВОКСЕЛЯ
; В ПЕРВОМ ПОЛУБЙТЕ
; НАХОДИМ СЛЕД. КООРД. Х ПОСЛЕ СПРАЙТА
; ЕСЛИ 0 БИТ ЕЕ =0 ТО ВЕСЬ ЗНАКОМЕСТ
; В ВОКСЕЛЯХ
; ИНАЧЕ ТОЛЬКО ОДИН ПЕРВЫЙ ПОЛУЗНАКОМЕСТ
; ЗАПОЛНЯЕТСЯ
XX:         ld   a,0
            add  a,c
            rra
            ld   a,#0F
            jr   nc,Q2
            ld   a,(AW3)
            cp   #38
            jr   z,$+3
            inc  c
            xor  a
Q2:
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
AW3:        jr   nc,Q1
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            ld   (hl),0
            dec  hl
Q1:
            ld   (VXL2+1),hl
            ld   iyl,e              ;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
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

; spКОЕФ. ПРОРЕЖ. ПО X
; h МЛ.БАЙТ АДРЕСА СПРАЙТА
; l ДРОБЬ МЛ.БАЙТА АДРЕСА СПРАЙТА
; b МЛ.БАЙТ АДРЕСА СПРАЙТА
; d СТ.БАЙТ АДРЕСА СПРАЙТА
; A' ДРОБЬ СМЕЩЕНИЯ ПО СТРОКАМ
; xlСТ.БАЙТ ПРОРЕЖ. ПО Y
; c МЛ.БАЙТ ПРОРЕЖ. ПО Y
            ; ??? КРАТНО КОЛИЧЕСТВУ ВОКСЕЛЕЙ В СТРОКЕ
; BC'АДРЕС В СКРИНЕ
; H' СТ.БАЙТ АДРЕСА ГРАФИКИ ВОКСЕЛЕЙ
            ; ??? ЗАВИСИТ ОТ ЧЕТНОСТИ ПОЛОЖЕНИЯ
            ; ??? ПЕРВОГО ВЫВОДИМОГО ВОКСЕЛЯ В СТРОКЕ
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
; ДЛИННА СТРОКИ СПРАЙТА
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
            jr   c,M1
            sli  l
            jr   c,M1+7
            sli  l
            jr   c,M1+(7*2)
            sli  l
            jr   c,M1+(7*3)
            sli  l
            jr   c,M1+(7*4)
            sli  l
            jr   c,M1+(7*5)
            sli  l
            jp   M1+(7*6)
M1:
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
; РАСЧЕТ ИЗ 3D В 2D
;hl-X,de-z,bc-Y
;L'-ПОЛУ ВЫСОТА СПРАЙТА
;H'-ПОЛУ ШИРИНА СПРАЙТА

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
            call FDIV
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

            call FDIV
            jr   c,ED_

            or   a
            ld   bc,#80
            adc  hl,bc

            pop  de
            ret
ED_:
;  ЭКСТРЕННЫЙ ВЫХОД
            pop  hl
            ld   a,3
            or   a
            ret


D3D2:
; ПОИСК КООРД. ВЫВОДА СПРАЙТА И РАЗМЕРА
; И ВЫВОД СПРАЙТА
;bc-z,de-Y,hl-X
;HL'-РЕАЛЬН. РАЗМЕРЫ
;DE'-АДРЕС СПРАЙТА
;a-МАСШТАБ
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
