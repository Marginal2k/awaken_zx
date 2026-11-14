■ADRXX00         ■ADDIXIX
■SUB_BC          ■SUB_DE
■INC_HL          ■INC_DE
■DEC_HL          ■DEC_DE
■NEXTLINE        ■NEXTZNAK
■NEXTLINEDE      ■PREVLINE
■PAGE            ■PAGES
■ADPHLDE         ■NEGHL
■NEGDE           ■NEGBC
■ABSHL           ■ABSDE
■ABSBC           ■ADPAXH
■SBPAXH          ■SM1
■SM2             ■SM3
■SPRO1           ■PUTDOT
■GETADR          ■LDX_HL_A
■ADDHLHL         ■EXD
■RST_





МАКРОСЫ

ВЫРАВНИВАНИЕ АДРЕСА
ADRXX00     macro
            ds   (($-1).h).e-$+256
            endm

ADDIXIX     macro
            db   #DD,#29
            endm

SUB_BC      macro:or a:sbc hl,bc:endm
SUB_DE      macro:or a:sbc hl,de:endm
INC_HL      macro:rept =1:inc hl:endr:endm
INC_DE      macro:rept =1:inc de:endr:endm
DEC_HL      macro:rept =1:dec hl:endr:endm
DEC_DE      macro:rept =1:dec de:endr:endm


СЛЕДУЮЩАЯ ЛИНИЯ В СКРИНЕ
NEXTLINE    macro
            inc  h:ld a,h:and 7
            jp   nz,$+13
            NEXTZNAK
            endm

СЛЕД.ЗНАКОМЕСТ
NEXTZNAK    macro
            ld   a,l:add a,32:ld l,a
            jr   c,$+6
            ld   a,h:sub 8:ld h,a
            endm

СЛЕДУЮЩАЯ ЛИНИЯ В СКРИНЕ РЕГ. de
NEXTLINEDE  macro
            inc  d:ld a,d:and 7
            jp   nz,$+13
            ld   a,e:add a,32:ld e,a
            jr   c,$+6
            ld   a,d:sub 8:ld d,a
            endm

ПРЕДЫДУЩАЯ ЛИНИЯ В СКРИНЕ
PREVLINE    macro
            ld   a,h:dec h:and 7
            jp   nz,$+13
            ld   a,l:sub 32:ld l,a
            jr   c,$+6
            ld   a,h:add a,8:ld h,a
            endm

ВЫЗОВ ПЕРЕКЛЮЧЕНИЯ СТРАНИЦЫ
PAGE        macro
            ifp:ld a,=1
            else:ld a,PGNORM:endif
            call PG
            endm

PAGES       macro
            ifp:ld a,=1
            else:ld a,PGNORM:endif
            call PGS
            endm

ОПЕРАЦИЯ СЛОЖЕНИЯ hl,deС ПРОВЕРКОЙ
ФЛАГА ПЕРЕПОЛНЕНИЯ И КОРРЕКЦИЕЙ
ADPHLDE     macro
            adc  hl,de
            jp   po,$+14
            EXD
            ld   hl,0
            and  a
            sbc  hl,de
            jp   po,$+4
            dec  hl
            ld   (=1+1),hl
            endm

ИНВЕРСИЯ hl
NEGHL       macro
            ld   a,l:cpl:ld l,a
            ld   a,h:cpl:ld h,a:inc hl
            endm
ИНВЕРСИЯ de
NEGDE       macro
            ld   a,e:cpl:ld e,a
            ld   a,d:cpl:ld d,a:inc de
            endm
ИНВЕРСИЯ bc
NEGBC       macro
            ld   a,c:cpl:ld c,a
            ld   a,b:cpl:ld b,a:inc bc
            endm

АБСОЛЮТНОЕ ЗНАЧЕНИЕ hl
ABSHL       macro
            bit  7,h:jr z,$+9
            NEGHL
            endm

АБСОЛЮТНОЕ ЗНАЧЕНИЕ de
ABSDE       macro
            bit  7,d:jr z,$+9
            NEGDE
            endm

АБСОЛЮТНОЕ ЗНАЧЕНИЕ bc
ABSBC       macro
            bit  7,b:jr z,$+9
            NEGBC
            endm


СЛОЖЕНИЕ a=a+xhС УЧЕТОМ ПЕРЕПОНЕНИЯ
ADPAXH      macro
            add  a,xh
            jppo $+9
            neg
            jppo $+4
            dec  a
            endm

ВЫЧИТАНИЕ a=a-xhС УЧЕТОМ ПЕРЕПОНЕНИЯ
SBPAXH      macro
            sub  xh
            jppo $+9
            neg
            jppo $+4
            dec  a
            endm


ДЛЯ
ДЕЛЕНИЕ БЫСТРОЕ ТОЧНОЕ ОПТИМИЗИРОВАННОЕ
ДЕЛИМ hl=hl/de
ЕДИНСТВЕННЫЙ ПАРАМЕТР ДОЛЖЕН БЫТЬ АДРЕС
ПРОЦЕДУРЫ ОБРАБОТКИ ПЕРЕПОЛНЕНИЯ
ПРИ ДЕЛЕНИИ НА 0 И Т.Д.
SM1         macro
            ld   c,a:ld a,l:ld l,h:ld h,c:endm
SM2         macro
            adc  hl,hl:rla:cp d:endm
SM3         macro
            sli  l:rl h:endm


SPRO1       macro
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            inc  hl,e
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            inc  hl
            dec  e
            NEXTLINEDE
            endm

РИСОВАТЬ ТОЧКУ НА ЭКРАНЕ
В a,b- Y,X
PUTDOT      macro
            ld   l,a
            ld   h,TBXX2_.h
            ld   d,(hl):inc h:ld a,(hl)
            inc  h:ld l,b:add a,(hl)
            ld   e,a:inc h
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            endm

ПОЛУЧИТЬ АДРЕС НА ЭКРАНЕ ИЗ КООРДИНАТ
В l,e-Y,X
GETADR      macro
            ld   h,TBXX.h
            ld   d,(hl)
            inc  h:ld a,(hl)
            inc  h:ld l,e
            or   (hl):ld e,a
            endm



МАКРОС ДЛЯ ВЫВОДА ШРИФТА
LDX_HL_A    macro:xor (hl):ld (hl),a:endm


ADDHLHL     macro
            rept =1:add hl,hl:endr
            endm

EXD         macro:ex de,hl:endm

ПЕЧАТЬ СИМВОЛА
RST_        macro
            ifp
            ld   a,=1
            endif
            call Pntpro
            endm

