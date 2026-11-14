■ADRXX00          ■NEXTLINE
■PREVLINE         ■PAGE
■ADDIXIX          ■ADDIYIY
■ADPHLDE          ■NEGHL
■NEGDE            ■NEGBC
■ABSHL            ■ABSDE
■ABSBC            ■CYCL1
■MULAB            ■MULAC
■MULAD            ■ADPAXH
■SBPAXH           ■DIVED
■SM1              ■SM2
■SM3              ■MESAG
■MVOX             ■HIDEM
■ADDHLHL          ■SUB_DE
■SUB_BC           ■ACPL_A
■EXD






МАКРОСЫ

ВЫРАВНИВАНИЕ АДРЕСА
ADRXX00     macro
            ds   (($-1).h).e-$+256
            endm

СЛЕДУЮЩАЯ ЛИНИЯ В СКРИНЕ
NEXTLINE    macro
            inc  h:ld a,h:and 7
            jp   nz,$+13
            ld   a,l:add a,32:ld l,a
            jr   c,$+6
            ld   a,h:sub 8:ld h,a
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
            else:ld a,MAIN:endif
            call Page
            endm

НЕ ОБРАБАТЫВАЕМАЯ КОМНДА addix,ix
ADDIXIX     macro
            db   #DD,#29
            endm

НЕ ОБРАБАТЫВАЕМАЯ КОМНДА addiy,iy
ADDIYIY     macro
            db   #FD,#29
            endm

ОПЕРАЦИЯ СЛОЖЕНИЯ hl,deС ПРОВЕРКОЙ
ФЛАГА ПЕРЕПОЛНЕНИЯ И КОРРЕКЦИЕЙ
ADPHLDE     macro
            adc  hl,de
            jp   po,$+14
            EXD
            ld   hl,0
            SUB_DE
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

ЦИКЛ РИСОВАНИЯ СТРОКИ ВОКССПРАЙТА
CYCL1       macro
            ld   e,h
            add  hl,sp
            ld   a,(de)
            exx
            ld   c,a
            ld   b,VXTAB.h
            ld   a,(bc)
            and  (hl)
            ld   (hl),a
            inc  b
            ld   a,e
            add  a,l
            ld   l,a
            ld   a,(bc)
            and  (hl)
            ld   (hl),a
            inc  b
            ld   a,e
            add  a,l
            ld   l,a
            ld   a,(bc)
            and  (hl)
            ld   (hl),a
            inc  b
            ld   a,e
            add  a,l
            ld   l,a
            ld   a,(bc)
            and  (hl)
            ld   (hl),a
            ld   a,l
            sub  d
            ld   l,a
            exx
            endm

УМНОЖЕНИЕ ЗНАКОВОЕ a=a*b
MULAB       macro
            sra  a
            ld   l,b
            sra  l
            sub  l
            ld   l,a
            add  a,b
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            endm

УМНОЖЕНИЕ ЗНАКОВОЕ a=a*c
MULAC       macro
            sra  a
            ld   l,c
            sra  l
            sub  l
            ld   l,a
            add  a,c
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            endm

УМНОЖЕНИЕ ЗНАКОВОЕ a=a*d
MULAD       macro
            sra  a
            ld   l,d
            sra  l
            sub  l
            ld   l,a
            add  a,d
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
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

ДЕЛЕНИЕ AE=e/d
DIVED       macro
            rept 8
            rl   e:rla:sub d
            jr   nc,$+3:add a,d
            endr
            endm

ДЛЯ
ДЕЛЕНИЕ БЫСТРОЕ ТОЧНОЕ ОПТИМИЗИРОВАННОЕ
ДЕЛИМ hl=hl/de
ЕДИНСТВЕННЫЙ ПАРАМЕТР ДОЛЖЕН БЫТЬ АДРЕС
ПРОЦЕДУРЫ ОБРАБОТКИ ПЕРЕПОЛНЕНИЯ
ПРИ ДЕЛЕНИИ НА 0 И Т.Д.
SM1         macro:ld c,a:ld a,l:ld l,h:ld h,c:endm
SM2         macro:adc hl,hl:rla:cp d:endm
SM3         macro:sli l:rl h:endm

ПЕЧАТЬ СООБЩЕНИЙ В ОЧЕРЕДИ КОМПУТЕРА
MESAG       macro
            push de
            ld   de,=1
            call MESAG_
            pop  de
            endm

MVOX        macro

            ld   e,h:add hl,sp
            ld   a,(de)
            and  #F0
            exx:ld l,a:exx
            ld   e,h:add hl,sp
            ld   a,(de)
            exx
            jr   z,$+39
            and  d
            jr   z,$+32
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
            jr   z,$-13
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

            ld   e,h:add hl,sp
            ld   a,(de)
            and  #F0
            exx:ld l,a:exx
            ld   e,h:add hl,sp
            ld   a,(de)
            exx
            jr   z,$+39
            and  d
            jr   z,$+32
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
            jr   z,$-13
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

            endm



HIDEM       macro
            ld   sp,hl
            ld   l,=1
            pop  af,bc,de,ix
            exa
            exx
            pop  af,bc,de,iy
            ld   sp,hl
            inc  sp
            set  4,l
            push iy,de,bc,af
            exa
            exx
            push ix,de,bc,af
            ld   sp,hl
            ld   l,=2
            pop  af,bc,de,ix
            exa
            exx
            pop  af,bc,de,iy
            ld   sp,hl
            inc  sp
            push iy,de,bc,af
            res  4,l
            inc  h
            exa
            exx
            push ix,de,bc,af
            endm

ADDHLHL     macro
            rept =1:add hl,hl:endr
            endm

SUB_DE      macro:or a:sbc hl,de:endm
SUB_BC      macro:or a:sbc hl,bc:endm

ACPL_A      macro:or a:jpp $+4:cpl:endm

EXD         macro:ex de,hl:endm

