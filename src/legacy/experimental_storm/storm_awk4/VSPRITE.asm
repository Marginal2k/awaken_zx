;ПРОЦЕДУРА ВЫВОДА ВОКС. СПРАЙТА С
;С МАСШТАБИРОВАНИЕМ И ПРОЗРАЧНОСТЬЮ
;ПОРИТ РЕГ. I

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


OUTALL_:
            call CLER
            call LAND
            call SKY
            call MOVING
            jp   NIGHT


;VOXEL
Vox_:
;DE'-ADR OF OBJ
;HL'-REAL SIZE SPRITE L-X,H-Y
;B-SIZE Y,C-SIZE X
;HL-X,DE-Y
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
            ld   LY,c               ;SZX
            ld   HY,b               ;SZY
            ld   e,b
            exx  
            ld   bc,0
            exx  
            ld   b,0
Vx:         ld   hl,0
            ld   a,h
            and  a
            jp   p,Vx1
;ЕСЛИ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СЛЕВА
            adc  hl,bc
            ret  m                  ;ВЕСЬ СПРАЙТ ЗА ЭКРАНОМ
            ret  z                  ;TOЖE
;КЛИПИРУЕМ
            ld   a,l
            ld   hl,0               ;X=0
            ld   b,c
            ld   c,a                ;NEW LEN OF X
            sub  b
            ld   b,l
            neg  
;В "А" БУДЕТ СМЕЩЕНИЕ ПО ШИРИНЕ ДЛЯ
;ИЗМЕНЕНИЯ АДРЕСА СПРАЙТА
            exx  
            ld   i,a
            set  0,c                ;МЕТКА КЛИПИНГА СЛЕВА
            exx  
            jp   Vx2
Vx1:
            ret  nz                 ;ЗА ЭКРНОМ СПРАВА
            ld   a,l
            cp   XEND
            ret  nc                 ;ТОЖЕ
Vx2:
            add  hl,bc
            ld   a,h
            or   a
            ld   a,l
            jr   nz,$+6
            cp   XEND+1
            jr   c,Vy               ;ВЕСЬ СПР НА ЭКРАНЕ ПО X
;ПРАВАЯ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СПРАВА
;КЛИПИРУЕМ
            sub  XEND
            sub  c
            neg  
;НОВАЯ ДЛИННА СПРАЙТА
            ld   c,a
;ПРОВЕРКИ ПО У
Vy:         ld   hl,0
            ld   d,0
            ld   a,h
            and  a
            jp   p,Vx3
;ЕСЛИ СПРАЙТ ВЫХОДИТ СВЕРХУ ЗА ЭКРАН
            adc  hl,de
            ret  m                  ;ВЫЛЕТ ПО У ВВЕРХУ ВСЕГО
;СПРАЙТА
            ret  z                  ;ТОЖЕ
            ld   a,l
            ld   hl,0               ;У=0
            ld   d,e
            ld   e,a                ;НОВАЯ ВЫСОТА СПРАЙТА
            sub  d
            ld   d,l
            neg  
            exx  
;В "А" КОЛИЧЕСТВО СТРОК ПОДДВЕРГНУТЫХ
;КЛИППИНГУ, КОТОРЫЕ НЕ ВИДИМЫ
            ld   b,a
            set  1,c                ;МАРКЕР КЛИПИНГА ПО У
            exx  
            jp   Vx4
Vx3:
            ret  nz                 ;ВЕСЬ СПРАЙТ НИЖЕ СКРИНА
            ld   a,l
            cp   YEND
            ret  nc                 ;ТОЖЕ
Vx4:
            add  hl,de
            ld   a,h
            or   a
            ld   a,l
            jr   nz,$+6
            cp   YEND+1
            jr   c,Vx5
;СПРАЙТ ВЫШЕ ВЫСОТЫ СКРАНА ИЛИ ВЫЛЕЗ
;СНИЗУ
            sub  YEND
            sub  e
            neg  
            ld   e,a                ;НОВАЯ ВЫСОТА
Vx5:
;ДЕЛАЕМ НУЖНЫЕ КООРДИНАТЫ ЕСЛИ БЫЛИ
;КЛИППИНГИ
            exx  
            ld   a,(Vx+1)
            bit  0,c
            jr   z,$+3
            xor  a
            bit  1,c
            exx  
            ld   b,a                ;КООРДИНАТА Х СПРАЙТА ВЫВД
            ld   a,(Vy+1)
            jr   z,$+3
            xor  a
;"А"-КООРД. У СПРАЙТА ДЛЯ ВЫВОДА
;РАСЧ. АДР. НА ХАЙД СЛРИНЕ
            srl  a
            ld   l,d
            rr   l
            ld   h,a                ;HL=КООРД. ВЫВОДА У/2
            ld   HX,e               ;КОЛИЧЕСТВО СТРОК
;КООРД. ВЫВОДА X ПОСЛЕ КЛИППИНГА
            ld   e,b

;ЗАПОМНИМ КООРД. ВЫВОДА Х
            ld   a,e
            ld   (XX+1),a

            srl  e

;ПОДГОТОВКА К ВЫВОДУ ВОКСЕЛЯ
;ВО ВТОРОМ ПОЛУБАЙТЕ
            ld   a,#30              ;JR NC,
            jr   nc,$+6
            inc  c
            inc  c
            ld   a,#38              ;JR C,
            ld   (AW3),a

            add  hl,de
            set  7,h
            ex   de,hl
;DE-АДР. В СКРИНЕ
            push de
            push bc
            exx  
            ld   a,l                ;РЕАЛЬНАЯ ШИРИНА СПРАЙТА
            exx  
            ld   b,a                ;ЗАПОМНИЛИ

;ИЗНАЧАЛЬНО ЗАДАННАЯ ВЫВОДИМАЯ ШИРИНА
            ld   e,LY
;РАСЧИТЫВАЕМ КОЭФ. МАСШТАБИРОВАНИЯ ПО Х
            call DIVV
;КОЭФ.ПО X=256*РЕАЛ.ШИРИНА/ЗАДАННАЯ
            ex   de,hl
;В "HL"-КОЭФ. МАСШТАБИРОВАНИЯ ПО X
            exx  
            ld   a,h                ;РЕАЛЬНАЯ ВЫСОТА
            exx  
            ld   e,HY               ;ЗАДАННАЯ
            push hl
;КОЕФ. МАСШТАБИРОВАНИЯ ПО У
            call DIVV
            pop  hl
            ld   a,e
            ld   LX,d               ;СТАР.БАЙТ КОЕФ.МАСШ.ПО У
            exx  
            ld   c,a
;В "C'" МЛАДШ. БАЙТ КОЕФ. МАСШТ. ПО У
            ld   a,b
            and  a
            jr   z,Vx6
;ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ
;КЛИППИНГ ПО ВЫСОТЕ СПРАЙТА
;С ВЕРХУ, РЕЗАЛСЯ С ВЕРХУ
            sla  b
            ld   hl,0
            ld   b,LX
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
Vx6:
            exx  
            ld   a,i                ;КОЛ.КЛИПНУТЫХ ДАБЛ
;ВОКСЕЛЕЙ ПО ШИРИНЕ
;СЛЕВА
            and  a
            jr   z,P1
;ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ КЛИПИНГ
;СЛЕВА ПО ШИРИНЕ
            ex   de,hl
;ПРОСУММИРУЕМ КОЕФ. МАСШТ. ПО ШИРИНЕ
;СТОЛЬКО РАЗ СКОЛЬКО НУЖНО КЛИПНУТЬ
;ДАБЛ ВОКСЕЛЕЙ

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
P1:
            ld   a,b
            pop  bc
            pop  de

;ВЫВОД ВОКСЕЛЯ С МАСШТАБИРОВАНИЕМ
;C-КОЛИЧЕСТВО ВОКСЕЛЕЙ В СТРОКЕ
;DE-АДРЕС НА СКРИНЕ
;HX-КОЛ. СТРОК
;HL-КОЕФ. СМЕЩЕНИЯ ПО Х
;C'-МЛАДШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
;LX-СТАРШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
;DE'-АДРЕС СПРАЙТА, #XX00
;A-РЕАЛЬНОЕ КОЛ. ВОКСЕЛЕЙ В СТРОКЕ
;СПРАЙТА
Voxout:
            ld   (Stkv+1),sp

            ld   (Vxll+1),a         ;РЕАЛЬНАЯ ШИРИНА

            ld   sp,hl              ;КОЕФ. МАСШ. ПО Х
;УМНОЖАЕМ СТАРШИЙ БАЙТ КОЕФ.
;ПРОРЕЖИВАНИЯ НА РЕАЛЬНУЮ ДЛИННУ СТРОКИ
;ЧТО БЫ ПОЛУЧИТЬ КОЕФ. ПРОРЕЖ. ПО У
;КРАТНЫЙ ДЛИННЕ СТРОКИ
            ld   b,a
            ld   a,LX
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

            ld   a,l,LX,a
            ld   a,h
;"А"-СМЕЩЕНИЕ ДЛЯ СТ.БАЙТА АДРЕСА СПРАЙТ
P2:
            ld   (WE1+1),a

;РАСЧИТЫВАЕМ АДРЕС НАЧАЛА ВЫВОДА ВОКСЕЛЯ
;В РАЗВЕРНУТОМ ЦИКЛЕ ПРОЦЕДУРЫ

;ПОДГОТОВКА К ВЫВОДУ ОДНОГО ВОКСЕЛЯ
;В ПЕРВОМ ПОЛУБЙТЕ
;НАХОДИМ СЛЕД. КООРД. Х ПОСЛЕ СПРАЙТА
;ЕСЛИ 0 БИТ ЕЕ =0 ТО ВЕСЬ ЗНАКОМЕСТ
;В ВОКСЕЛЯХ
;ИНАЧЕ ТОЛЬКО ОДИН ПЕРВЫЙ ПОЛУЗНАКОМЕСТ
;ЗАПОЛНЯЕТСЯ
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
;84b

.2:         add  hl,hl
            add  hl,bc
.2:         add  hl,hl
            add  hl,bc
.2:         add  hl,hl
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
            ld   LY,e               ;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
            ld   c,e,b,d
            rra  
            ld   h,high(VXTAB)+3
            ld   a,#A9              ;RES 5,C
            jr   c,$+8
            set  5,c
            ld   h,high(VXTAB)
            ld   a,#E9              ;SET 5,C
            ld   (AW4+1),a
            ld   a,h,(AW5+1),a

            ld   d,#0F
            exx  
            xor  a
            ld   b,e
Vxl3:
;A'-СЧЕТЧИК СМЕЩЕНИЯ ПО СТРОКАМ
;LX-СТАРШИЙ БАЙТ ПРОРЕЖ. ПО У,КРАТЕН КОЛ
;ВОКСЕЛЕЙ В СТРОКЕ
            ex   af,af'
            ld   h,b
            ld   l,0


;SP-ПРОРЕЖ. ПО Х
;H-МЛАДШИЙ БАЙТ АДРЕСА СПРАЙТА
;L-ЕГО СЧЕТЧИК К УВЕЛИЧЕНИЮ
;D-СТАРШИЙ БАЙТ АДРЕСА СПРАЙТА
VXL2:       jp   0

VXL4:
            include "VOXP.asm"


;157 TAKTS ONE CYCLE

            ld   a,LY
            add  a,#80
            ld   c,a
            ld   LY,a
            jr   nc,$+3
            inc  b
AW4:        set  5,c
AW5:        ld   h,0
            exx  
            ex   af,af
            add  a,c
            ld   l,a
            ld   a,b
            jr   nc,$+6
Vxll:       add  a,0                ;LEN OF STRING
            jr   c,V3
V4:
            add  a,LX
            ld   b,a
            ld   a,d
WE1:        adc  a,0
            ld   d,a
            ld   a,l
            dec  HX
            jp   nz,Vxl3
VXL3:       ld   hl,0
.4:         inc  hl
            ld   (hl),#F0

Stkv:       ld   sp,0
            ret  
V3:         inc  d
            jp   V4



LAND:
            ld   (Stkv_+1),sp
            ld   a,#20
            ld   (TYPE_+1),a



            ld   a,#30              ;JR NC
            ld   (COM2),a
            ld   a,#24              ;INC H
            ld   (COM1),a


            ld   b,#0B              ;КОЛ.ВОКС.СТРОК ЗЕМЛИ
            exx  

            ld   hl,(PLANT)
            ld   (ADSPR+1),hl


;HL-АДР. В СКРИНЕ
            ld   hl,#8680

VXL3_:
            ld   e,l                ;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
            ld   d,#80
            ld   b,high(VXTAB)
            set  5,l
            exx  

            ld   a,0
Vxl3_:
            ld   c,a
            ex   af,af'
;ТАБЛИЦА ПРОРЕЖ. ПО Х И ПО У
;ДЛЯ КАЖДОЙ ПОЗИЦИИ У
;ПЕРВЫЙ, ВТОРОЙ БАЙТЫ СМЕЩ. В АДР.СПРЙТА
;ТРЕТИЙ, ЧЕТВЕРТЫЙ БАЙТЫ ПРОРЕЖ. ПО X

            ld   a,c
            rlca 
TYPE_:      or   0                  ;0-ПОЧВА,#40-НЕБО
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
ADSPR:      ld   hl,0
            add  hl,de
            ex   de,hl

            ld   h,e
            ld   l,0


;SP-ПРОРЕЖ. ПО Х
;H-МЛАДШИЙ БАЙТ АДРЕСА СПРАЙТА

;L-ЕГО СЧЕТЧИК К УВЕЛИЧЕНИЮ
;D-СТАРШИЙ БАЙТ АДРЕСА СПРАЙТА
;C-СЧЕТЧИК СТРОК


VXL4_:
            include "VOXL.asm"

            ld   a,e
            add  a,d
            ld   l,a
            ld   e,a
COM2:       jr   nc,$+3             ;JR NC/C
COM1:       inc  h                  ;INC/DEC
            set  5,l
            exx  
            ex   af,af'
            inc  a
            dec  b
            jp   nz,Vxl3_
Stkv_:      ld   sp,0
            ret  






SKY:
            ld   (Stkv_+1),sp

            ld   a,#60,(TYPE_+1),a

            ld   a,#38              ;JR C
            ld   (COM2),a
            ld   a,#25              ;DEC H
            ld   (COM1),a

            ld   hl,(SKYS),(ADSPR+1),hl

            ld   b,#0A
            exx  

;DE-АДР. В СКРИНЕ
            ld   hl,#8480
            jp   VXL3_



NIGHT:
;ЗАТУХАНИЕ СПРАЙТОВ ДЛЯ СОЗДАНИЯ
;ЭФЕКТА  НОЧИ
            ld   hl,1
            dec  hl
            ld   (NIGHT+1),hl
            ld   a,l
            or   h
            ret  nz
            ld   hl,1000,(NIGHT+1),hl

            ld   hl,(SKYS),bc,#0C00
G1:
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
G2:
            ld   a,(hl)
            or   a
            jr   z,$+5
            sub  #11
            ld   (hl),a
            inc  hl
            dec  bc
            ld   a,b
            or   c
            jp   nz,G2
            ret  




RETURN_:
;ВОССТАНОВЛЕНИЕ РУЛЯ
            ld   a,%10101010
            rrca 
            ld   ($-2),a
            ret  nc
            ld   a,(UNGLE)
            or   a
            ret  z
            jp   p,RLT_
            jp   RRT_



RLT_:
            ld   a,(UNGLE)
            dec  a
            jp   p,$+7
            cp   0-STPTURN
            jr   c,$+5
            ld   (UNGLE),a
RP4:
            ld   l,a
            ld   bc,TSX
RP44:
            ld   a,(bc),e,a
            add  a,l
            and  #3F
            ld   d,a
            ld   a,e
            and  #C0
            or   d
            ld   (bc),a
            set  6,c
            ld   a,(bc),e,a
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
            jp   nz,RP44
            ret  



RRT_:
;ПОВОРОТ ВПРАВО ЭКРАНА
            ld   a,(UNGLE)
            inc  a
            jp   m,$+7
            cp   STPTURN+1
            jr   nc,$+5
            ld   (UNGLE),a
            jp   RP4




TAKSPD_:
;ВКЛЮЧИТЬ СКОРОСТЬ
            or   a
            ld   c,a
            ld   a,%10001000
            jp   m,RP0
            ld   a,%10001000
            jr   z,RP0
            dec  c
            ld   a,%10001000
            jr   z,RP0
            dec  c
            ld   a,%10101010
            jr   z,RP0
            ld   a,#FF
RP0:
            ld   (MDN+1),a
            ret  



MOVING:
            ld   a,(SPEED)
            or   a
            jp   z,NEBO2
            jp   p,MDN
;ПЕРЕМЕЩЕНИЕ ФОНА ОТ СЕБЯ
            ld   a,(MDN+1)
            rlca 
            ld   (MDN+1),a
            ret  nc
            ld   bc,TSX
            ld   de,#40
RP1:
            ld   a,(bc)
            ld   l,a
            inc  c
            ld   a,(bc)
            ld   h,a
            add  hl,de
            ld   a,h
            cp   #0B
            jr   nz,RP5
            ld   h,0
            ld   a,l
            sub  19
            and  #3F
            ld   l,a
RP5:
            ld   a,h
            ld   (bc),a
            dec  c
            ld   a,l
            ld   (bc),a
            inc  c
            inc  c
            ld   a,#18
            cp   c
            jp   nz,RP1
            jp   NEBO







MDN:
;ПЕРЕМЕЩЕНИЕ ФОНА К СЕБЕ
            ld   a,%10101010
            rrca 
            ld   ($-2),a
            jp   nc,NEBO
            ld   de,#FFC0
            ld   bc,TSX
RP2:
            ld   a,(bc)
            ld   l,a
            inc  c
            ld   a,(bc)
            ld   h,a
            add  hl,de
            jr   c,RP3
            ld   h,#0A
            ld   a,l
            add  a,19
            and  #3F
            or   #C0
            ld   l,a
RP3:
            ld   a,h
            ld   (bc),a
            dec  c
            ld   a,l
            ld   (bc),a
            inc  c
            inc  c
            ld   a,#18
            cp   c
            jp   nz,RP2
            jp   NEBO

NEBO2:
            ld   a,%10101010
            rlca 
            ld   ($-2),a
            ret  nc
NEBO:
            ld   a,%00100000
            rlca 
            ld   ($-2),a
            ret  nc
            ld   de,#FFC0
            ld   bc,TSXS
RP22:
            ld   a,(bc)
            ld   l,a
            inc  c
            ld   a,(bc)
            ld   h,a
            add  hl,de
            jr   c,RP32
            ld   h,#0A
            ld   a,l
            add  a,19
            and  #3F
            or   #C0
            ld   l,a
RP32:
            ld   a,h
            ld   (bc),a
            dec  c
            ld   a,l
            ld   (bc),a
            inc  c
            inc  c
            ld   a,#58
            cp   c
            jp   nz,RP22
            ret  





CLER:
            ld   (STK1+1),sp
            ld   sp,#8680
            ld   hl,#00
.192:       push hl
STK1:       ld   sp,0
            ret  


FINDY:
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
FINDX:
            exx  
            ld   a,d
            exx  
            ld   e,a
            exx  
            ld   a,l
            exx  
            call DIVV
            ret  

STORED:
            push bc
            exx  
            ld   a,b
            exx  
            ld   hl,0
            or   a
            jr   z,S1
            ld   bc,#40
            add  hl,bc
            dec  a
            jp   nz,$-2
S3:
            ld   a,h
            cp   #0A
            jr   c,S1
            sub  #0A
            ld   h,a
            jr   S3
S1:
            push hl
            call FINDX
            ex   de,hl
            push hl
            xor  a
.8:         add  hl,hl
            adc  a,a
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
;A-КОЛ. ВОКС. КОТОРЫЕ НУЖНО ПРОПУСТИТЬ
;НА ЭКРАНЕ
;НУЖНО КОЛ. ВОКСЕЛЕЙ КОТ. НУЖНО ПРОПУСТ.
;В СТРОКЕ
;X=A*D.E
            push hl
;HL=A*DE
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
NEWPSS_:
            ld   ix,TSXS
            jr   $+6
NEWPOS_:
;РАСЧЕТ ТАБЛИЦ ПРОРЕЖИВАНИЯ
            ld   ix,TSX
            ld   a,13
            ex   af,af'
            ld   bc,0
            exx  
            call FINDY
            ld   a,e
            ld   (MINY+1),a

;ПОИСК СЛЕД. ПОЗИЦИИ ВОКСЕЛЬ СТРОКИ ПО У
NP2:
            call FINDY
MINY:       ld   a,#00
            sub  e
            jr   nc,NP1
            ld   a,e
            ld   (MINY+1),a
S2:
            ex   af,af'
            dec  a
            ret  z
            ex   af,af'
            call STORED
            inc  ix
            inc  ix
NP1:
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



DIVV:
;DE=A/E
            ld   l,a
            xor  a
            sli  l
            sli  l
            jr   c,M1
            sli  l
            jr   c,M1+7
            sli  l
            jr   c,(M1+7)*2
            sli  l
            jr   c,(M1+7)*3
            sli  l
            jr   c,(M1+7)*4
            sli  l
            jr   c,(M1+7)*5
            sli  l
            jp   (M1+7)*6
M1:
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



DIVW:
;HL=HL/DE
            ld   a,l
            ld   l,0
            jr   DIV+3
DIV:
;HL=A/D.E
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



D3D2__:
;РАСЧЕТ ИЗ 3D В 2D
;HL-X,DE-Z,BC-Y
;L'-ПОЛУ ВЫСОТА СПРАЙТА
;H'-ПОЛУ ШИРИНА СПРАЙТА
;DE-Z
;BC-Y

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
Jmp1:       jr   $
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
;DIV
            ld   a,d
            or   a
            jp   z,PP0
            xor  a
            sli  l
            rl   h
            jr   c,PP1
            sli  l
            rl   h
            jr   c,PP1+6
            sli  l
            rl   h
            jr   c,(PP1+6)*2
            sli  l
            rl   h
            jr   c,(PP1+6)*3
            sli  l
            rl   h
            jr   c,(PP1+6)*4
            sli  l
            rl   h
            jr   c,(PP1+6)*5
            sli  l
            rl   h
            jr   c,(PP1+6)*6
            sli  l
            rl   h
            jr   c,(PP1+6)*7
            sli  l
            rl   h
            jr   c,(PP1+6)*8
            sli  l
            rl   h
            ld   b,l
            jr   c,(PP1+6)*9+1
            sli  l
            rl   h
            jr   c,(PP1+6)*10+1
            sli  l
            rl   h
            jr   c,(PP1+6)*11+1
            sli  l
            rl   h
            jr   c,(PP1+6)*12+1
            sli  l
            rl   h
            jr   c,(PP1+6)*13+1
            sli  l
            rl   h
            jr   c,(PP1+6)*14+1
            sli  l
            rl   h
            jp   c,(PP1+6)*15+1
;ZERO
            ld   b,a
            jp   PP9

PP1:
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
            jr   nc,(PP2+7)*2
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*3
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*4
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*5
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*6
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*7
            adc  hl,hl
            rla  
            ld   b,l
            cp   d
            jr   nc,(PP2+7)*8
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*9
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*10
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*11
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*12
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*13
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(PP2+7)*14
            adc  hl,hl
            rla  
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+63+7)*6



PP2:

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
            jp   (PP4+8)*2
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+8)*3
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+8)*4
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+8)*5
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+8)*6
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+8)*7
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+8)*8-1

            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   PP4+63+7
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+63+7)*2
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+63+7)*3
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+63+7)*4
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (PP4+63+7)*5


PP0:
            ld   a,l
            ld   l,h
            ld   h,0
            sbc  hl,de
            jp   nc,ED_
            add  hl,de
            rla  
            adc  hl,hl
PP3:
            sbc  hl,de
            jp   nc,ED_
            add  hl,de
            rla  
            adc  hl,hl
PP4:
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
PP9:
            ld   c,a
            ex   af,af'
            ld   hl,#30             ;MIDLE Y
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
Jmp2:       jr   $
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
;DIV
            ld   a,d
            or   a
            jp   z,O0
            xor  a
            sli  l
            rl   h
            jr   c,O1
            sli  l
            rl   h
            jr   c,O1+6
            sli  l
            rl   h
            jr   c,(O1+6)*2
            sli  l
            rl   h
            jr   c,(O1+6)*3
            sli  l
            rl   h
            jr   c,(O1+6)*4
            sli  l
            rl   h
            jr   c,(O1+6)*5
            sli  l
            rl   h
            jr   c,(O1+6)*6
            sli  l
            rl   h
            jr   c,(O1+6)*7
            sli  l
            rl   h
            jr   c,(O1+6)*8
            sli  l
            rl   h
            ld   b,l
            jr   c,(O1+6)*9+1
            sli  l
            rl   h
            jr   c,(O1+6)*10+1
            sli  l
            rl   h
            jr   c,(O1+6)*11+1
            sli  l
            rl   h
            jr   c,(O1+6)*12+1
            sli  l
            rl   h
            jr   c,(O1+6)*13+1
            sli  l
            rl   h
            jr   c,(O1+6)*14+1
            sli  l
            rl   h
            jp   c,(O1+6)*15+1
;ZERO
            ld   b,a
            jp   O9

O1:
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
            jr   nc,(O2+7)*2
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*3
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*4
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*5
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*6
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*7
            adc  hl,hl
            rla  
            ld   b,l
            cp   d
            jr   nc,(O2+7)*8
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*9
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*10
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*11
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*12
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*13
            adc  hl,hl
            rla  
            cp   d
            jr   nc,(O2+7)*14
            adc  hl,hl
            rla  
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+63+7)*6



O2:

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
            jp   (O4+8)*2
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+8)*3
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+8)*4
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+8)*5
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+8)*6
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+8)*7
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+8)*8-1

            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   O4+63+7
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+63+7)*2
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+63+7)*3
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+63+7)*4
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            jp   (O4+63+7)*5


O0:
            ld   a,l
            ld   l,h
            ld   h,0
            sbc  hl,de
            jp   nc,ED_
            add  hl,de
            rla  
            adc  hl,hl
O3:
            sbc  hl,de
            jp   nc,ED_
            add  hl,de
            rla  
            adc  hl,hl
O4:
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
O9:
            ld   c,a
            ex   af,af'
            ld   hl,#0080           ;MIDLE X
            jp   m,$+8
            sbc  hl,bc
            jp   $+4
            add  hl,bc
            pop  de
            ret  
ED_:
;ЭКСТРЕННЫЙ ВЫХОД
            pop  hl
            ld   a,3
            or   a
            ret  


D3D2_:
;ПОИСК КООРД. ВЫВОДА СПРАЙТА И РАЗМЕРА
;И ВЫВОД СПРАЙТА
;BC-Z,DE-Y,HL-X
;HL'-РЕАЛЬН. РАЗМЕРЫ
;DE'-АДРЕС СПРАЙТА
;A-МАСШТАБ
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
.2:         sra  h
            rr   l
.2:         sra  d
            rr   e
            call Vox
            ret  

            org  (($+255)/256*256)
VXTAB:
            incbin "assets/VOX2.C"



TSX:
;СМЕЩЕНИЯ В АДРЕСЕ СПРАЙТА ДЛЯ КАЖДОЙ
;ПОЗИЦИИ ВЫВОДА У ДЛЯ ПОЧВЫ
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
            dw   0,0,0,0

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
            dw   0,0,0,0

TSXS:
;СМЕЩЕНИЯ В АДРЕСЕ СПРАЙТА ДЛЯ КАЖДОЙ
;ПОЗИЦИИ ВЫВОДА У ДЛЯ НЕБА
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
            dw   0,0,0,0

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

END_:

