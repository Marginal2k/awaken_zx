
            xor  a
            out  (#FE),a
            di
            ld   hl,#4000
            ld   de,#4001
            ld   bc,#1800
            ld   (hl),l
            ldir
            ld   (hl),#38
            ld   bc,#180
            ldir
            ld   (hl),7
            ld   bc,#17F
            ldir
            ld   sp,#8400

            PAGE

            call INITV1
            call GEN2X
            call GENLOG2
            call GENTBXY
            call MAKE3DTABS
            call GENEXPT
            jp   START

ИНИЦИАЛИЗАЦИЯ ПЕРЕМЕННЫХ
INITV1
            ret



СОЗДАНИЕ ТАБЛИЦЫ ДЛЯ ВЫВОДА 3D ПОЛИГОНА
ДЛЯ КАЖДОЙ ПОЗИЦИИ ПИКСЕЛЯ ЧЕРЕЗ КАЖДЫЕ

ПЕРВЫЙ БАЙТ ПЕРВОГО СЕГМЕНТА МАСКА ФОНА ДЛЯ ЛЕВОГО КРАЯ ПОЛИГОНА
■-/- БАЙТ ВТОРОГО СЕГМЕНТА ЗАЛИВКА УЖЕ ПО МАСКЕ
■-/- БАЙТ ДЕСЯТОГО СЕГМЕНТА МАСКА ФОНА --//--
■-/- БАЙТ ОДИНАДЦАТОГО СЕГМЕНТА ЗАЛИВКА ПО МАСКЕ ДРУГАЯ
■-/- БАЙТ ДВАДЦАТОГО СЕГМЕНТА МАСКА ФОНА ДЛЯ ПРАВОГО КРАЯ ПОЛИГОНА
■-/- БАЙТ ДВАДЦАТЬ ПЕРВОГО СЕГМЕНТА ЗАЛИВКА УЖЕ ПО МАСКЕ
■-/- БАЙТ ТРИДЦАТОГО СЕГМЕНТА МАСКА ФОНА --//--
■-/- БАЙТ ТРИДЦАТЬ ПЕРВОГО СЕГМЕНТА ЗАЛИВКА ПО МАСКЕ ДРУГАЯ
■-/- БАЙТ ТРЕТЬЕГО И Т.Д. СЕГМЕНТОВ ДЛЯ ДРУГИХ ЧЕТЫРЕХ ВИДОВ ЗАЛИВОК
ВОТОРОЙ БАЙТ И Т.Д. -/- СЕГМЕНТОВ ТОЖЕ НО ДЛЯ УЖЕ СДВИНУТЫХ ВПРАВО МАСОК

MAKE3DTABS
            ld   ix,L90
            ld   bc,#FF80
MS1
            ld   hl,LC5
            ld   yl,5
MS3
            ld   d,(hl):inc l;ЗАЛИВКА
            ld   a,(hl):inc l;КСОР МАСКА
            xor  d:ld e,a;ДР.ЗАЛИВКА

            ld   a,b:cpl
            ld   (ix),a:inc xh
            ld   a,d:and b
            ld   (ix),a
            ld   a,xh:add a,9:ld xh,a

            ld   a,b:cpl
            ld   (ix),a:inc xh
            ld   a,e:and b
            ld   (ix),a
            ld   a,xh:add a,9:ld xh,a

            ld   a,c:cpl
            ld   (ix),a:inc xh
            ld   a,d:and c
            ld   (ix),a
            ld   a,xh:add a,9:ld xh,a

            ld   a,c:cpl
            ld   (ix),a:inc xh
            ld   a,e:and c
            ld   (ix),a
            ld   a,xh:sub 29:ld xh,a
            dec  yl
            jrnz MS3

            ld   a,xh:sub 10:ld xh,a
            srl  b:jrnz $+3:dec b
            sra  c:jrnc $+4:ld c,#80
            inc  xl
            jrnz MS1

            ld   hl,LL90
            ld   a,l
            rrca:rrca:rrca:and #1F
            add  a,#83
            ld   (hl),a:inc l
            jrnz $-10
            ld   hl,LL91
            ld   a,l
            rrca:rrca:rrca:rrca:and 7
            ld   (hl),a:inc l
            jrnz $-9
            ld   de,MASKS
            ld   hl,_MASKS
            ld   bc,#10
            ldir
            ret

_MASKS
            dw   #4080
            dw   #1020
            dw   #0408
            dw   #0102
            dw   #BF7F
            dw   #EFDF
            dw   #FBF7
            dw   #FEFD



ТАБЛИЦА ЗНАЧЕНИЙ А,А*2,А*4,А*8,А*16,А*32
А<256, ПО 2 БАЙТА НА ЗНАЧЕНИЕ
GENEXPT
            ld   b,6
            ld   de,EXPT
GE1
            ld   a,e:ld l,a
            rlca:and 1:neg:ld h,a
            ld   a,b:dec b:jrz $+5
            add  hl,hl
            djnz $-1
            ld   b,a
            ld   a,l
            ld   (de),a:inc d
            ld   a,h
            ld   (de),a:dec d
            inc  e
            jrnz GE1
            inc  d,d
            djnz GE1
            ret

■GEN TABLE Y.B=2^(X/256)-1 ,X=(0;1)
GEN2X       ld   ix,TB2X
            ld   hl,0
GN2X        ld   a,h;ROUNDING
            bit  7,l
            jrz  $+3
            inc  a
            ld   (ix),a
            xor  a
            exx
            ld   l,a
            ld   h,a
            ld   e,a
            ld   bc,#00B2;(2^1/256)*#10000
            exx
            ld   bc,#1801
GN2X1       rr   c
            rr   h
            rr   l
            exx
            jrnc GN2X2
            add  hl,bc
            adc  a,1
GN2X2       rra
            rr   h
            rr   l
            exx
            djnz GN2X1
            ld   a,c
            rra
            exx
            ld   h,l
            ld   l,a
            inc  xl
            jrnz GN2X
            ret
■GEN TABLE Y.W=LOG2(X) ,X=(1,255)
GENLOG2     ld   hl,TBLOG2
            xor  a
            ld   e,a
            ld   d,a
            ld   (hl),a
            inc  h
            ld   (hl),#F0
            dec  h
            inc  l
GNLG1       ld   (hl),d
            inc  h
            ld   (hl),a
            dec  h
            exa
            push hl,de
            ld   de,#74E9
            ld   c,l
            srl  c
            rr   d
            xor  a
            ld   hl,#B8AA
            exx
            ld   h,a
            ld   l,a
            ld   b,#10
GNLG2       exx
            add  hl,hl
            adc  a,a
            sbc  hl,de
            sbc  a,c
            jrnc GNLG3
            add  hl,de
            adc  a,c
GNLG3       exx
            ccf
            rl   l
            rl   h
            djnz GNLG2
            pop  de
            exa
            add  hl,de
            adc  a,b
            ex   de,hl
            pop  hl
            inc  l
            jrnz GNLG1
            ret
GENTBXY
ГЕНЕРИМ ТАБЛИЦУ ПЕРЕВОД КООРДИНАТ В
АДРЕС С #8000
            ld   hl,TBXY
            ld   de,#8000
            ld   bc,32
MT1
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            ex   de,hl
            add  hl,bc
            ex   de,hl
            inc  l
            jrnz MT1
            inc  h
            inc  h
            ld   a,#80
            exa
            xor  a
MT3
            ld   b,8
MT2
            ld   (hl),a
            exa
            inc  h
            ld   (hl),a
            rrca
            dec  h
            exa
            inc  l
            djnz MT2
            inc  a
            cp   32
            jrc  MT3
            ret




