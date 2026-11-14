■NWTEL
■NWVOS
■VOX
■DIVV
■D3D2_
■D3D2
















NWTEL
ИНИЦИАЛИЗАЦИЯ НОВОГО ТЕЛЕПОРТА
            ld   hl,VSPR2
            ld   de,#0080
            ld   (MASHT+3),a
            ld   a,12
            ld   (VLL2+3),a
            ld   a,12
            ld   (VLL1+3),a
КОЛ.ФРЕЙМОВ
            ld   a,#0D
            ld   (VLL3+1),a
            jp   $J1-3

NWVOS
ИНИЦИАЛИЗАЦИЯ НОВОГО ВЗРЫВА
■HL'-X,DE'-Y,BC'-Z
■A'-ВРЕМЯ ЖИЗНИ
■a-МАСШТАБ
 ЧТО БУДЕТ ЗАДАНО В ПРОЦЕДУРЕ
■hl-АДРЕС СПРАЙТОВ
■b-КОЛИЧЕСТВО ФРЕЙМОВ В АНИМАЦИИ
■de-РАЗМЕР В БАЙТАХ ОДНОГО ФРЕЙМА
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
$J1
            add  iy,bc
            ld   a,(iy+7)
            and  a
            retm
            jrnz $J1
            exx
            ld   (iy+0),l
            ld   (iy+1),h
            ld   (iy+2),e
            ld   (iy+3),d
            ld   (iy+4),c
            ld   (iy+5),b
            exa
            ld   (iy+7),a
            exx
MASHT       ld   (iy+6),0
ТЕКУЩИЙ АДРЕС ФРЕЙМА
            ld   (iy+8),l
            ld   (iy+9),h
АДРЕС НАЧАЛА АНИМАЦИИ
            ld   (iy+10),l
            ld   (iy+11),h
НОМЕР ТЕКУЩЕГО КАДРА, НУМЕРУЕМ С КОНЦА
ЗАДАЕМ НОМЕР ПОСЛЕДНЕГО = 1, ЧТО БЫ
ПЕРЕКЛЮЧИТЬСЯ НА ПЕРВЫЙ
            ld   (iy+12),1
VLL3        ld   a,0
КОЛИЧЕСТВО КАДРОВ
            ld   (iy+13),a
ДЛИННА КАДРА В БАЙТАХ
            ld   (iy+14),e
            ld   (iy+15),d
ДЛИННА ПО X
VLL1        ld   (iy+16),0
ВЫСОТА ПО Y
VLL2        ld   (iy+17),0
            ret


ПРОЦЕДУРА ВЫВОДА ВОКС. СПРАЙТА С
С МАСШТАБИРОВАНИЕМ И ПРОЗРАЧНОСТЬЮ
ПОРИТ РЕГ. i



■VOXEL
VOX
■DE'-ADR OF OBJ
■HL'-REAL SIZE SPRITE L-X,H-Y
■b-SIZE Y,c-SIZE X
■hl-X,de-Y
            ld   a,b
            or   a
            retz
            ld   a,c
            or   a
            retz
            xor  a
            ld   i,a
            ld   (VX+1),hl
            ld   (VY+1),de
            ld   yl,c;SZX
            ld   yh,b;SZY
            ld   e,b
            exx
            ld   bc,0
            exx
            ld   b,0
VX          ld   hl,0
            ld   a,h
            and  a
            jp   p,VX1
ЕСЛИ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СЛЕВА
            adc  hl,bc
            retm;ВЕСЬ СПРАЙТ ЗА ЭКРАНОМ
            retz;TOЖe
КЛИПИРУЕМ
            ld   a,l
            ld   hl,0;X=0
            ld   b,c
            ld   c,a;NEW LEN OF X
            sub  b
            ld   b,l
            neg
В "А" БУДЕТ СМЕЩЕНИЕ ПО ШИРИНЕ ДЛЯ
ИЗМЕНЕНИЯ АДРЕСА СПРАЙТА
            exx
            ld   i,a
            set  0,c;МЕТКА КЛИПИНГА СЛЕВА
            exx
            jp   VX2
VX1
            retnz;ЗА ЭКРАНОМ СПРАВА
            ld   a,l
            cp   Xend
            retnc;ТОЖЕ
VX2
            add  hl,bc
            ld   a,h
            or   a
            ld   a,l
            jrnz $+6
            cp   Xend+1
            jrc  VY;ВЕСЬ СПР НА ЭКРАНЕ ПО X
ПРАВАЯ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СПРАВА
КЛИПИРУЕМ
            sub  Xend
            sub  c
            neg
НОВАЯ ДЛИННА СПРАЙТА
            ld   c,a
ПРОВЕРКИ ПО У
VY          ld   hl,0
            ld   d,0
            ld   a,h
            and  a
            jp   p,VX3
ЕСЛИ СПРАЙТ ВЫХОДИТ СВЕРХУ ЗА ЭКРАН
            adc  hl,de
            retm;ВЫЛЕТ ПО У ВВЕРХУ ВСЕГО
СПРАЙТА
            retz;ТОЖЕ
            ld   a,l
            ld   hl,0;У=0
            ld   d,e
            ld   e,a;НОВАЯ ВЫСОТА СПРАЙТА
            sub  d
            ld   d,l
            neg
            exx
В "А" КОЛИЧЕСТВО СТРОК ПОДДВЕРГНУТЫХ
КЛИППИНГУ, КОТОРЫЕ НЕ ВИДИМЫ
            ld   b,a
            set  1,c;МАРКЕР КЛИПИНГА ПО У
            exx
            jp   VX4
VX3
            retnz;ВЕСЬ СПРАЙТ НИЖЕ СКРИНА
            ld   a,l
            cp   Yend
            retnc;ТОЖЕ
VX4
            add  hl,de
            ld   a,h
            or   a
            ld   a,l
            jrnz $+6
            cp   Yend+1
            jrc  VX5
СПРАЙТ ВЫШЕ ВЫСОТЫ СКРИНА ИЛИ ВЫЛЕЗ
СНИЗУ
            sub  Yend
            sub  e
            neg
            ld   e,a;НОВАЯ ВЫСОТА



VX5
ДЕЛАЕМ НУЖНЫЕ КООРДИНАТЫ ЕСЛИ БЫЛИ
КЛИППИНГИ
            exx
            ld   a,(VX+1)
            bit  0,c
            jrz  $+3
            xor  a
            bit  1,c
            exx
            ld   b,a;КООРДИНАТА Х СПРАЙТА ВЫВД
            ld   a,(VY+1)
            jrz  $+3
            xor  a
А-КООРД. У СПРАЙТА ДЛЯ ВЫВОДА
РАСЧ. АДР. НА ХАЙД СЛРИНЕ
            srl  a
            ld   l,d
            rr   l
            ld   h,a;hl=КООРД. ВЫВОДА У/2
            ld   xh,e;КОЛИЧЕСТВО СТРОК
КООРД. ВЫВОДА X ПОСЛЕ КЛИППИНГА
            ld   e,b

ЗАПОМНИМ КООРД. ВЫВОДА Х
            ld   a,e
            ld   (XX+1),a

            srl  e

ПОДГОТОВКА К ВЫВОДУ ВОКСЕЛЯ
ВО ВТОРОМ ПОЛУБАЙТЕ
            ld   a,#30;jrnc,
            jrnc $+6
            inc  c
            inc  c
            ld   a,#38;jrc,
            ld   (AW3),a


            add  hl,de
            set  7,h
            ex   de,hl
В de-АДР. В СКРИНЕ


            push de,bc


РАСЧИТЫВАЕМ КОЭФ. МАСШТАБИРОВАНИЯ ПО Х
            exx
            ld   a,l;РЕАЛЬНАЯ ШИРИНА СПРАЙТА
            exx
            ld   b,a;ЗАПОМНИЛИ
ИЗНАЧАЛЬНО ЗАДАННАЯ ВЫВОДИМАЯ ШИРИНА
            ld   e,yl
            call DIVV
КОЭФ.ПО X=256*РЕАЛ.ШИРИНА/ЗАДАННАЯ
            ex   de,hl
В "HL"-КОЭФ. МАСШТАБИРОВАНИЯ ПО X




КОЕФ. МАСШТАБИРОВАНИЯ ПО У
            exx
            ld   a,h;РЕАЛЬНАЯ ВЫСОТА
            exx
            ld   e,yh;ЗАДАННАЯ
            push hl
            call DIVV
            pop  hl
            ld   a,e
СТАР.БАЙТ КОЕФ.МАСШ.ПО У
            ld   xl,d
            exx
            ld   c,a
В "C" МЛАДШ. БАЙТ КОЕФ. МАСШТ. ПО У





            exx
ИЗНАЧАЛЬНАЯ ШИРИНА СПРАЙТА
НЕОБХОДИМО СДЕЛАТЬ ЕЕ КРАТНОЙ 2^n
Т.Е. ЕСЛИ ОНА = 20 ,ТО БУДЕТ 32
            ld   a,b
            cp   17
            jrnc $+6
            ld   a,16
            jr   $+4
            ld   a,32
            ld   b,a
            exx



В bКОЛИЧЕСТВО СТРОК КЛИПНУТЫХ СВЕРХУ
            ld   a,b
            and  a
            jrz  VX6

В xlСТАР.БАЙТ КОЕФ.МАСШ.ПО У

ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ
КЛИППИНГ ПО ВЫСОТЕ СПРАЙТА
С ВЕРХУ, РЕЗАЛСЯ С ВЕРХУ
            ld   hl,0
            ld   b,xl
В bcКОЕФ. МАСШТ. ПО У
            add  hl,bc
            dec  a
            jpnz $-2


            ld   a,h
            and  a
            jrz  VX6
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
VX6
            exx
            ld   a,i;КОЛ.КЛИПНУТЫХ ДАБЛ
ВОКСЕЛЕЙ ПО ШИРИНЕ
СЛЕВА
            and  a
            jrz  P1
ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ КЛИПИНГ
СЛЕВА ПО ШИРИНЕ
            ex   de,hl
ПРОСУММИРУЕМ КОЕФ. МАСШТ. ПО ШИРИНЕ
СТОЛЬКО РАЗ СКОЛЬКО НУЖНО КЛИПНУТЬ
ДАБЛ ВОКСЕЛЕЙ

            ld   hl,0
            exa
            xor  a
            exa
            exa
            add  hl,de
            adc  a,0
            exa
            dec  a
            jpnz $-6

            ld   a,h
            exx
            ld   l,a
            exa
            ld   h,a
            add  hl,de
            ex   de,hl
            exx
            ex   de,hl
P1
            ld   a,b
            pop  bc,de

ВЫВОД ВОКСЕЛЯ С МАСШТАБИРОВАНИЕМ
В c-КОЛИЧЕСТВО ВОКСЕЛЕЙ В СТРОКЕ
В de-АДРЕС НА СКРИНЕ
В xh-КОЛ. СТРОК
В hl-КОЕФ. СМЕЩЕНИЯ ПО Х
В C'-МЛАДШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
В xl-СТАРШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
В DE'-АДРЕС СПРАЙТА, #XX00
В a-РЕАЛЬНОЕ КОЛ. ВОКСЕЛЕЙ В СТРОКЕ
ПРИВЕДЕННОЕ К КРАТНОСТИ 2^n: 16 ИЛИ 32
В СПРАЙТА
VOXOUT
            ld   (STKV+1),sp

            ld   (VXLL+1),a;РЕАЛЬНАЯ ШИРИНА

            ld   sp,hl;КОЕФ. МАСШ. ПО Х
УМНОЖАЕМ СТАРШИЙ БАЙТ КОЕФ.
ПРОРЕЖИВАНИЯ НА РЕАЛЬНУЮ ДЛИННУ СТРОКИ
ЧТО БЫ ПОЛУЧИТЬ КОЕФ. ПРОРЕЖ. ПО У
КРАТНЫЙ ДЛИННЕ СТРОКИ
            ld   b,a
            ld   a,xl
            or   a
            jrz  P2
            ld   hl,0
            exa
            ld   a,c
            exa
            ld   c,b
            ld   b,0
            add  hl,bc
            dec  a
            jpnz $-2
            exa
            ld   c,a

            ld   a,l
            ld   xl,a
            ld   a,h
В a-СМЕЩЕНИЕ ДЛЯ СТ.БАЙТА АДРЕСА СПРАЙТ
P2
            ld   (WE1+1),a

РАСЧИТЫВАЕМ АДРЕС НАЧАЛА ВЫВОДА ВОКСЕЛЯ
В РАЗВЕРНУТОМ ЦИКЛЕ ПРОЦЕДУРЫ

ПОДГОТОВКА К ВЫВОДУ ОДНОГО ВОКСЕЛЯ
В ПЕРВОМ ПОЛУБЙТЕ
НАХОДИМ СЛЕД. КООРД. Х ПОСЛЕ СПРАЙТА
ЕСЛИ 0 БИТ ЕЕ =0 ТО ВЕСЬ ЗНАКОМЕСТ
В ВОКСЕЛЯХ
ИНАЧЕ ТОЛЬКО ОДИН ПЕРВЫЙ ПОЛУЗНАКОМЕСТ
ЗАПОЛНЯЕТСЯ
XX          ld   a,0
            add  a,c
            rra
            ld   a,#0F
            jrnc Q2
            ld   a,(AW3)
            cp   #38
            jrz  $+3
            inc  c
            xor  a
Q2
            ld   (AW1+1),a
            ld   (AW2+1),a

            srl  c
            ld   a,#20
            sub  c
            jpnc $+4
            xor  a
            ld   l,a
            ld   h,0
            ld   c,l
            ld   b,h
■84B

            ADDHLHL 2
            add  hl,bc
            ADDHLHL 2
            add  hl,bc
            ADDHLHL 2
            ld   bc,VXL4
            add  hl,bc
            ld   (VXL3+1),hl
AW3         jrnc Q1
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            ld   (hl),0
            dec  hl
Q1
            ld   (VXL2+1),hl
            ld   yl,e;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
            ld   c,e
            ld   b,d
            rra
            ld   h,VXTAB.h+3
            ld   a,#A9;res5,c
            jrc  $+8
            set  5,c
            ld   h,VXTAB.h
            ld   a,#E9;set5,c
            ld   (AW4+1),a
            ld   a,h
            ld   (AW5+1),a

            ld   d,#0F
            exx
            xor  a
            ld   b,e
Vxl3
В A'-СЧЕТЧИК СМЕЩЕНИЯ ПО СТРОКАМ
В xl-СТАРШИЙ БАЙТ ПРОРЕЖ. ПО У
КРАТЕН КОЛИЧЕСТВУ ВОКСЕЛЕЙ В СТРОКЕ
            exa
            ld   h,b
            ld   l,0


В sp-ПРОРЕЖ. ПО Х
В h-МЛАДШИЙ БАЙТ АДРЕСА СПРАЙТА
В l-ЕГО СЧЕТЧИК К УВЕЛИЧЕНИЮ
В d-СТАРШИЙ БАЙТ АДРЕСА СПРАЙТА
VXL2        jp   0

VXL4

            ld   e,h:add hl,sp
            ld   a,(de)
            and  #F0
            exx:ld l,a:exx
            ld   e,h:add hl,sp
            ld   a,(de)
            exx
            jrz  $+39;K1
            and  d
            jrz  $+32;K2
            or   l:ld l,a
            ld   a,(hl):ld (bc),a:inc h:set 6,c
            ld   a,(hl):ld (bc),a:inc h:res 5,c
            ld   a,(hl):ld (bc),a:inc h:res 6,c
            ld   a,(hl):ld (bc),a
            jp   $+46;K0
■K3
            res  5,c
            inc  h,h,h
            jp   $+38;K0
■K2
            ld   e,d:jp $+9;K4
■K1
            and  d
            jrz  $-13;K3
            ld   e,#F0
            ld   l,a
■K4
            ld   a,(bc):and e
            or   (hl):ld (bc),a:inc h:set 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:inc h:res 5,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:inc h:res 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a
■K0
            inc  c
            exx

■LEN 84b

            ld   e,h:add hl,sp
            ld   a,(de)
            and  #F0
            exx:ld l,a:exx
            ld   e,h:add hl,sp
            ld   a,(de)
            exx
            jrz  $+39
            and  d
            jrz  $+32
            or   l:ld l,a
            ld   a,(hl):ld (bc),a:dec h:set 6,c
            ld   a,(hl):ld (bc),a:dec h:set 5,c
            ld   a,(hl):ld (bc),a:dec h:res 6,c
            ld   a,(hl):ld (bc),a
            jp   $+46
            set  5,c
            dec  h,h,h
            jp   $+38
            ld   e,d:jp $+9
            and  d
            jrz  $-13
            ld   e,#F0
            ld   l,a
            ld   a,(bc):and e
            or   (hl):ld (bc),a:dec h:set 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:dec h:set 5,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:dec h:res 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a
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


            ld   e,h:add hl,sp
            ld   a,(de)
            and  #F0
            exx:ld l,a:exx
            ld   e,h:add hl,sp
            ld   a,(de)
            exx
            jrz  $+39
            and  d
            jrz  $+32
            or   l:ld l,a
            ld   a,(hl):ld (bc),a:inc h:set 6,c
            ld   a,(hl):ld (bc),a:inc h:res 5,c
            ld   a,(hl):ld (bc),a:inc h:res 6,c
            ld   a,(hl):ld (bc),a
            jp   $+46
            res  5,c
            inc  h,h,h
            jp   $+38
            ld   e,d:jp $+9
            and  d
            jrz  $-13
            ld   e,#F0
            ld   l,a
            ld   a,(bc):and e
            or   (hl):ld (bc),a:inc h:set 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:inc h:res 5,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:inc h:res 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a
            inc  c
            exx



■-LAST
            ld   e,h:add hl,sp
            ld   a,(de)
            and  #F0
            exx:ld l,a:exx
            ld   e,h:add hl,sp
            ld   a,(de)
            exx
            jrz  $+40
AW1         and  #0F
            jrz  $+32
            or   l:ld l,a
            ld   a,(hl):ld (bc),a:dec h:set 6,c
            ld   a,(hl):ld (bc),a:dec h:set 5,c
            ld   a,(hl):ld (bc),a:dec h:res 6,c
            ld   a,(hl):ld (bc),a
            jp   $+47
            set  5,c
            dec  h,h,h
            jp   $+39
            ld   e,d:jp $+10
AW2         and  #0F
            jrz  $-14
            ld   e,#F0
            ld   l,a
            ld   a,(bc):and e
            or   (hl):ld (bc),a:dec h:set 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:dec h:set 5,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a:dec h:res 6,c
            ld   a,(bc):and e
            or   (hl):ld (bc),a



■157 TAKTS ONE CYCLE

            ld   a,yl
            add  a,#80
            ld   c,a
            ld   yl,a
            jrnc $+3:inc b
AW4         set  5,c
AW5         ld   h,0
            exx
            exa
            add  a,c
            ld   l,a
            ld   a,b
            jrnc $+6
ДЛИННА СТРОКИ СПРАЙТА
VXLL        add  a,0
            jrc  V3
V4
            add  a,xl
            ld   b,a
            ld   a,d
WE1         adc  a,0
            ld   d,a
            ld   a,l
            dec  xh
            jpnz Vxl3
VXL3        ld   hl,0
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            ld   (hl),#F0

STKV        ld   sp,0
            ret
V3          inc  d
            jp   V4




DIVV
■de=a/e
            ld   l,a
            xor  a
            sli  l
            sli  l
            jrc  M1
            sli  l
            jrc  M1+7
            sli  l
            jrc  M1+(7*2)
            sli  l
            jrc  M1+(7*3)
            sli  l
            jrc  M1+(7*4)
            sli  l
            jrc  M1+(7*5)
            sli  l
            jp   M1+(7*6)
M1
     rept 7:rla:sbc a,e:jrnc $+3:add a,e:rl l:endr

            ld   c,l

     rept 8:add a,a:sbc a,e:jrnc $+3:add a,e:rl l:endr

            ld   a,l
            cpl
            ld   e,a
            ld   a,c
            cpl
            ld   d,a
            ret


D3D2_
РАСЧЕТ ИЗ 3D В 2D
■hl-X,de-z,bc-Y
■L'-ПОЛУ ВЫСОТА СПРАЙТА
■H'-ПОЛУ ШИРИНА СПРАЙТА

■ret
■hl-X
■de-Y

            push hl

            bit  7,d
            jpnz ED_

            exx
            ld   a,h
            exx
            ld   l,a
            rlca
            and  1
            neg
            ld   h,a
JmP1        jr   $
            ADDHLHL 9

            add  hl,bc
■DIV
            push de
            call FDIV
            pop  de
            jrc  ED_

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
JmP2        jr   $
            ADDHLHL 9

            add  hl,bc
■DIV

            call FDIV
            jrc  ED_

            or   a
            ld   bc,#80
            adc  hl,bc

            pop  de
            ret
ED_
 ЭКСТРЕННЫЙ ВЫХОД
            pop  hl
            ld   a,3
            or   a
            ret


D3D2
ПОИСК КООРД. ВЫВОДА СПРАЙТА И РАЗМЕРА
И ВЫВОД СПРАЙТА
■bc-z,de-Y,hl-X
■HL'-РЕАЛЬН. РАЗМЕРЫ
■DE'-АДРЕС СПРАЙТА
■a-МАСШТАБ
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
            retpe
            push de,hl
X_          ld   hl,0
Z_          ld   de,0
Y_          ld   bc,0
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
            jppo $J76
$J75
            pop  bc:ret
$J76
            SUB_BC
            jrz  $J75
            srl  h
            rr   l
            srl  h
            jrnz $J75
            rr   l
            ld   h,b
            ld   a,c
            ld   c,l
            ld   l,a
            ld   a,c
            exa
            ex   de,hl
            pop  bc
            SUB_BC
            retz
            srl  h
            rr   l
            srl  h
            retnz
            rr   l
            ld   a,h
            or   a
            retnz
            exa
            ld   h,b
            ld   b,l
            ld   l,c
            ld   c,a
            ex   de,hl

            sra  h:rr l:sra d:rr e
            sra  h:rr l:sra d:rr e

            exx
            srl  h:srl l
            exx

■DE'-ADR OF OBJ
■HL'-REAL SIZE SPRITE L-X,H-Y
■b-SIZE Y,c-SIZE X
■hl-X,de-Y

            jp VOX

