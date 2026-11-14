■$M18
■NDATA
■RETSTT
■RETSTAT
■RNDD
■CLRBUFS
■SETIT
■SETT
■VERTAB
■STROYTAB
■LEVLTAB
■PINFO










$M18
            phase ADHDP
$M19
            push ix
            ld   (STK77+1),sp
            ld   a,FREE
            ld   bc,#7FFD
            out  (c),a
            exx
            ld   hl,#8C00
            ld   de,#C000
            ld   bc,#C000-#8C00
            ldir
            exx
            ld   a,CONTR
            out  (c),a
            exx
            ld   hl,JL1
            ld   bc,JL2
            ld   de,#8000
            push bc,de
            ldir
            ld   de,#E000
            ld   hl,#6000
            ld   bc,#2000
            ldir
            pop  hl,bc
            ld   de,#6400
            push de
            ldir
            pop  hl
            ld   d,h
            ld   e,l
            call DEHRUST
            ld   sp,#6000
            call #6500
            di
            ld   bc,#7FFD
            ld   a,FREE
            out  (c),a
            exx
            ld   hl,#C000
            ld   de,#8C00
            ld   bc,#C000-#8C00
            ldir
            exx
            ld   a,MAIN
            out  (c),a
            exx
            call CLRHD
            exx
            ld   a,CONTR
            out  (c),a
            push bc
            call OHIDE
            ld   hl,#E000
            ld   de,#6000
            ld   bc,#2000
            ldir

TS_CON      ld   de,0
SL_CON      ld   b,0
            ld   hl,#C000
            push hl
            call LOAD_
            pop  hl
            ld   d,h
            ld   e,l
            call DEHRUST
            pop  bc
STK77       ld   sp,0
            ld   a,CONTR
            out  (c),a
            call CLRBUFS
            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,%11011011
            out  (c),a
            pop  ix
            di
            ret
LOAD_
            ld   a,d
            srl  a
            ld   c,#7F
            call TOREG_
            ld   ix,#2F55
            call TOTD_
            push de,bc
            exx
            pop  bc,de
LOD1_
            ld   a,(DSK)
            and  %00101111
            ld   c,a
            xor  a
            bit  0,d
            jrnz $+4
            ld   a,#10
            or   c
            ld   c,#FF
            call TOREG_
            ld   a,d
            srl  a
            ld   c,#3F
            call TOREG_
            ld   a,e
            ld   c,#5F
            call TOREG_
            exx
RETL_
            push hl
            ld   a,#80
            ld   c,#1F
            call TOREG_
            ld   c,#7F
            ld   ix,#3FE5
            call TOTD_
            exx
            ld   a,d
            exx
            srl  a
            ld   d,a
            ld   a,1
            ld   (#5CD8),a
            ld   ix,#2740
            call TOTD_
            ld   a,(#5CCD)
            and  #7F
            pop  hl
            jrnz RETL_
            inc  h
            exx
            inc  e
            ld   a,e
            cp   #11
            jrc  LOD2_
            inc  d
            ld   e,1
            bit  0,d
            jrnz LOD2_
            exx
            ld   a,#58;STEP ON
            ld   c,#1F
            call TOREG_
            ld   ix,#2F59;WAIT
            call TOTD_
            exx
LOD2_
            dec  b
            jpnz LOD1_
            ret
TOREG_
            ld   ix,#2A53
TOTD_
            push ix
            jp   #3D2F
$M20        equ  $-$M19


            unphase


ДАННЫЕ ПЛАНЕТЫ
В hl,de: lda,l:xorh,d,e
БИТЫ 7,6-СТРОЙ; 5,4-ЭКОНОМИКА;
БИТЫ 0-3 УРОВЕНЬ

ДАННЫЕ ПО СИСТЕМЕ
БИТЫ 4,3,2-КОЛИЧЕСТВО ПЛАНЕТ

ДЕМОКРАТИЯ
ДИКТАТУРА
АНАРХИЯ
НЕОБИТАЕМАЯ
НЕИЗВЕСТНЫЙ ЕСЛИ ЗА ЗОНОЙ ГОСУДАРСТВ

АГРОКУЛЬТУРНАЯ
КУЛЬТУРНАЯ
ТЕХНОЛОГИЧЕСКАЯ
ОБЩАЯ

ФЕДЕРАЦИЯ ГАЛАКТИК
КОНФЕДЕРАЦИЯ ПЕРВЫХ
СОДРУЖЕТВО МИРОВ
СВОБОДНЫЕ ЗЕМЛИ






NDATA
            dw   #0122
            db   #10,#10
            dw   #4B38
            dw   #4AF3

            dw   #4B38;KAPTЫ
            dw   #4AF3;bKAPTE

            db   1

            db   1

            db   #FF
            db   #FF

            db   0

            dw   40000
            db   0,0


            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0

            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF

            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0

            db   0
            db   0
            db   0
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   #FF
            db   0

            db   0
            db   0,0
            dw   0,0
            db   0

            db   #FF
            ds   15
            db   #FF
            ds   15
            db   #FF
            ds   15
            db   #FF
            ds   15

            db   0,0

            dw   0

            db   2
            db   1
            db   1
            db   3
            db   1
            db   1
            db   2
            db   3
            db   2
            db   1
            db   1
            db   1
            db   1
            db   1
            db   1
            db   1
            db   #FF


RETSTT
ВОЗВРАЩЕНИЕ НА СТАНЦИЮ С ОБНУЛЕНИЕМ ВСЕХ ДАННЫХ
            exx
            ld   hl,NDATA
            ld   de,TIME
            ld   bc,#200
            ldir
            exx
RETSTAT
ВОЗВРАТ НА СТАНЦИЮ
■de-MTRK
            exx
            ld   sp,#6000
            ld   hl,#5800
            ld   de,#5801
            ld   bc,#2FF
            ld   (hl),l
            ldir
            ld   hl,RSTT
            ld   de,#4200
            push de
            ld   bc,LNRSTT
            ldir
            ret
RSTT
            phase #4200
RSTT2
            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,#FF
            out  (c),a
            ld   bc,#7FFD
            ld   a,#17
            out  (c),a
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#1AFF
            ld   (hl),l
            ldir

            ld   hl,TIME
            ld   de,#4000
            ld   bc,#200
            ldir

            ld   bc,#7FFD
            ld   a,#18
            out  (c),a

            exx
            ld   (#5CF7),de
            ld   (TRK+1),de
            ld   iy,#5C3A
            ld   b,LNSTAT
            ld   hl,#6A00
            push hl
            call LOAD
            ld   hl,(TRK+1)
            ld   (#5CF4),hl
            ret
LOAD
            ld   a,b
            exx
            ld   c,a
            and  #F0
            rrca
            rrca
            rrca
            rrca
            ld   h,a
            ld   a,c
            and  #0F
            rlca
            rlca
            rlca
            rlca
            ld   l,a
TRK         ld   bc,0
            rlc  c
            rlc  c
            rlc  c
            rlc  c
            add  hl,bc
            rrc  l
            rrc  l
            rrc  l
            rrc  l
            ld   (TRK+1),hl
            exx
            inc  e
            ld   a,d
            srl  a
            ld   c,#7F
            call TOREG
            ld   ix,#2F55
            call TOTD
            push de,bc
            exx
            pop  bc,de
LOD1
            ld   a,(DSK)
            and  %00101111
            ld   c,a
            xor  a
            bit  0,d
            jrnz $+4
            ld   a,#10
            or   c
            ld   c,#FF
            call TOREG
            ld   a,d
            srl  a
            ld   c,#3F
            call TOREG
            ld   a,e
            ld   c,#5F
            call TOREG
            exx
RETL
            push hl
            ld   a,#80
            ld   c,#1F
            call TOREG
            ld   c,#7F
            ld   ix,#3FE5
            call TOTD
            exx
            ld   a,d
            exx
            srl  a
            ld   d,a
            ld   a,1
            ld   (#5CD8),a
            ld   ix,#2740
            call TOTD
            ld   a,(#5CCD)
            and  #7F
            pop  hl
            jrnz RETL
            inc  h
            exx
            inc  e
            ld   a,e
            cp   #11
            jrc  LOD2
            inc  d
            ld   e,1
            bit  0,d
            jrnz LOD2
            exx
            ld   a,#58;STEP ON
            ld   c,#1F
            call TOREG
            ld   ix,#2F59;WAIT
            call TOTD
            exx
LOD2
            dec  b
            jpnz LOD1
            ret
TOREG
            ld   ix,#2A53
TOTD
            push ix
            jp   #3D2F
LNRSTT      equ  $-RSTT2

            unphase





RNDD
            push bc
            ld   hl,(RNDD1)
            ld   de,(RNDD2)
            ld   c,h
            ld   b,l
            inc  hl
            inc  h
            add  hl,de
            ld   a,e
            adc  a,l
            ld   c,a
            add  hl,bc
            ld   a,l
            xor  c
            xor  #75
            ld   l,e
            ld   e,a
            ld   a,h
            xor  b
            xor  #A7
            ld   h,d
            ld   d,a
            ld   (RNDD1),hl
            ld   (RNDD2),de
            ld   a,d
            xor  e
            xor  h
            xor  l
            pop  bc
            ret




CLRBUFS
ЧИСТИТЬ ВСЕ БУФЕРЫ СПРАЙТОВ И ОБЪЕКТОВ
            ld   a,(GDIABLO)
            inc  a
ГДЕ БУДЕТ СОЛНЦЕ, БЛИЗКО ЕСЛИ ЕСТЬ
ДЬЯВОЛ ИЛИ ДАЛЕКО
            ld   bc,#0200
            jrz  $+4
            ld   b,17;ECTЬ
            ld   hl,0
            ld   (SNZ+1),bc
            ld   (SNX+1),hl
            ld   (SNY+1),hl

            ld   hl,MODELSTAR
            jrz  $+5
            ld   hl,MODELPLANET
            ld   de,PLANETES
            ld   bc,72
            ldir

            ld   iy,CARSB-OLEN
            ld   de,OLEN
GJ1
            add  iy,de
            ld   a,(iy)
            cp   #80
            jrnz $+7
            cp   (iy+1)
            jrz  GJ3
            ld   (iy),0
            ld   (iy+1),#80
            ld   (iy+SETUP),#FF
            jr   GJ1
GJ3

            ld   ix,VOXCOR-VLEN
            ld   de,VLEN
GJ11
            add  ix,de
            ld   a,(ix+7)
            and  a
            jp   m,$+9
            ld   (ix+7),0
            jr   GJ11

            ld   hl,(WHERE)
            ld   (PLACE),hl
            EXD
            ld   hl,(WHERE+2)
            ld   (PLACE+2),hl
            ld   a,(WPLANET)
            ld   (PLANET),a
УЗНАЕМ КОЛ. ПЛАНЕТ В СИСТЕМЕ
            ld   a,l
            xor  h
            xor  e
            xor  d
            and  7
            ld   c,a
            jrnz $+4:ld c,#C9
            ld   a,c
            ld   (PWOPK+1),a
SETIT
            call SETT
            jp   SETTING

SETT
ИНИЦИИРУЕТ ТАБЛИЦУ ВЕРОЯТНОСТЕЙ И МОЩНО-
СТЕЙ В ЗАВИСИМОСТИ ОТ ТИПА ПЛАНЕТЫ
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            call PINFO
            ld   (KOLPLANET+1),a
            or   a:jrnz $+4:ld h,3
            ld   a,h
            rlca:rlca:rlca:rlca
            ld   e,a:ld d,0
            ld   c,l:dec c
            push de
            ld   hl,STROYTAB
            add  hl,de
            EXD
            push bc
            ld   hl,LEVLTAB+1
            ld   ix,PLANDICTAT
            ld   a,15
STIT1
            exa
            ld   a,(hl)
            and  a
            jp   p,STIT2
            neg
            dec  a
            jrz  STIT3
            ld   b,a
            xor  a
            sub  c
            djnz $-1
            jr   STIT3
STIT2
            dec  a
            jrz  STIT3
            ld   b,a
            xor  a
            add  a,c
            djnz $-1
STIT3
            inc  hl
            ld   b,(hl)
            rr   b
            jrc  $+6
            sra  a
            jr   $-6
            dec  hl
            dec  hl
            add  a,(hl)
            EXD
            add  a,(hl)
            EXD
            ld   (ix+0),a
            inc  de
            inc  ix
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            exa
            dec  a
            jpnz STIT1
            exx
            pop  bc
            exx
            pop  de
            ld   hl,VERTAB
            add  hl,de
            EXD
            ld   hl,VARPS
            ld   bc,6
            ld   a,(de)
            ld   (hl),a
            add  hl,bc
            inc  de
            exx
            ld   b,8
            exx
            ld   a,(de)
            exx
            add  a,c
            exx
            ld   (hl),a
            add  hl,bc
            inc  de
            exx
            djnz $-9
            ret


PINFO
 ДАЧА ИНФО О ПЛАНЕТЕ НА СИСТЕМЕ
■hl,de-ДАННЫЕ СИСТЕМЫ
■a-НОМЕР ПЛАНЕТЫ С 0
■ret
■a=0-В СИСТЕМЕ НЕТ ПЛАНЕТ
■a-КОЛ. ПЛАНЕТ
■l-УРОВЕНЬ 1-16
■h-СТРОЙ 0-4
■e-ТИП 0-3
            push bc
            exa
            ld   a,h:xor l
            xor  e
            xor  d:and 7:dec a
            jp   p,$+4:xor a
            exa
            ld   (RNDD1),hl
            ld   (RNDD2),de
            inc  a:ld b,a

            call GOSTA:ld c,a
            ld   a,c
            cp   3:ld c,0:jr nz,$+3:inc c

            call RNDD:djnz $-3
            cpl
            ld   e,a
■%SSUUUUTT
            and  %00111100
            rrca
            rrca
            inc  a
            ld   l,a
            ld   a,e
            rlca
            rlca
            and  3
            dec  c:jr nz,$+4:ld a,4
            ld   h,a
            ld   a,e
            and  3
            ld   e,a
            exa
            pop  bc
            ret



VERTAB
ТАБЛИЦА ВЕРОЯТНОСТЕЙ ПО СТРОЯМ ДЛЯ
ВИДОВ СУБЪЕКТОВ

ДЕМОКРАТИЯ
ПИРАТЫ
            db   4
МИРНЫЕ
            db   40
ПОЛИЦИЯ
            db   70
ВОЕННЫЕ
            db   80
ЛЕГИОНЕРЫ
            db   90
ПИРАТ2
            db   94
УФО
            db   95
УФО2
            db   96
ОТШЕЛЬНИК
            db   100
            ds   7

ДИКТАТ
ПИРАТЫ
            db   10
МИРНЫЕ
            db   40
ПОИЦИЯ
            db   70
ВОЕННЫЕ
            db   100
ЛЕГИОНЕРЫ
            db   110
ПИРАТ2
            db   112
УФО
            db   113
УФО2
            db   116
ОТШЕЛЬНИК
            db   121
            ds   7


АНАРХИЯ
ПИРАТЫ
            db   20
МИРНЫЕ
            db   24
ПОЛИЦИЯ
            db   27
ВОЕННЫЕ
            db   36
ЛЕГИОНЕРЫ
            db   47
ПИРАТ2
            db   60
УФО
            db   62
УФО2
            db   68
ОТШЕЛЬНИК
            db   72
            ds   7

НЕЗАСЕЛЕННАЯ
ПИРАТЫ
            db   1
МИРНЫЕ
            db   2
ПОЛИЦИЯ
            db   3
ВОЕННЫЕ
            db   10
ЛЕГИОНЕРЫ
            db   12
ПИРАТ2
            db   16
УФО
            db   28
УФО2
            db   40
ОТШЕЛЬНИК
            db   60
            ds   7

НЕИЗВЕСТНАЯ
ПИРАТЫ
            db   1
МИРНЫЕ
            db   2
ПОЛИЦИЯ
            db   3
ВОЕННЫЕ
            db   4
ЛЕГИОНЕРЫ
            db   5
ПИРАТ2
            db   6
УФО
            db   7
УФО2
            db   8
ОТШЕЛЬНИК
            db   9



STROYTAB
ТАБЛИЦА СМЕЩЕНИЙ ДЛЯ ЗНАЧЕНИЙ ГЛАВНОЙ
ТАБЛИЦЫ В ЗАВИСИМОСТИ ОТ СТРОЯ

ДЕМОКРАТИЯ
            db   0
            db   #FF
            db   #FF
            db   0,0,0
            db   #FF
            db   5
            db   6
            db   #FE
            db   #F0
            db   #F6
            db   10
            db   10
            db   0
            db   0;VOID
ДИКТАТ
            db   0
            db   0
            db   0
            db   0,0,0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0
            db   0;VOID
АНАРХИЯ
            db   0
            db   1
            db   2
            db   0,0,0
            db   1
            db   #F5
            db   #FA
            db   #FD
            db   #EE
            db   10
            db   #FA
            db   #FA
            db   0
            db   0;VOID
НЕОБИТАЕМАЯ
            db   0
            db   #FF
            db   #FF
            db   0,0,0
            db   26
            db   5
            db   6
            db   #FE
            db   #F0
            db   #F6
            db   10
            db   10
            db   0

LEVLTAB
ТАБЛИЦА СТАНДАРТОВ
СОДЕРЖИТ СТАНДАРТЫ, МНОЖИТЕЛИ И ДЕЛИТЕЛИ
КРАТНЫЕ 2 ПО УРОВНЮ РАЗВИТИЯ
            db   20,1,1
            db   3,2,8
            db   23,2,8
            db   78,1,1
            db   70,1,1
            db   60,1,1
            db   229,#FE,4
            db   70,#FE,4
            db   220,#FE,4
            db   78,#FE,4
            db   14,#FE,4
            db   240,#FE,2
            db   50,2,1
            db   150,2,1
            db   55,2,1



MODELSTAR
            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#00

            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF
            db   #00,#00,#80,#FF

            db   #00,#00,#80,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#80,#FF
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF


MODELPLANET
            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#04,#00

            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#04,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#00
            db   #00,#00,#84,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF
            db   #00,#00,#84,#FF

            db   #00,#00,#80,#00
            db   #00,#00,#00,#00
            db   #00,#00,#84,#FF

            db   #00,#00,#80,#FF
            db   #00,#00,#00,#00
            db   #00,#00,#84,#FF


