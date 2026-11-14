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
            jpnz $+13
            ld   a,l:add a,32:ld l,a
            jrc  $+6
            ld   a,h:sub 8:ld h,a
            endm

ПРЕДЫДУЩАЯ ЛИНИЯ В СКРИНЕ
PREVLINE    macro
            ld   a,h:dec h:and 7
            jpnz $+13
            ld   a,l:sub 32:ld l,a
            jrc  $+6
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
            jppo $+14
            EXD
            ld   hl,0
            SUB_DE
            jppo $+4
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
            ld a,h:or a:jpp $+9
            cpl:ld h,a
            ld   a,l:cpl:ld l,a:inc hl
            endm

АБСОЛЮТНОЕ ЗНАЧЕНИЕ de
ABSDE       macro
            ld a,d:or a:jpp $+9
            cpl:ld d,a
            ld   a,e:cpl:ld e,a:inc de
            endm

АБСОЛЮТНОЕ ЗНАЧЕНИЕ bc
ABSBC       macro
            ld a,b:or a:jpp $+9
            cpl:ld b,a
            ld   a,c:cpl:ld c,a:inc bc
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
            jrnc $+3:add a,d
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



HIDEM       macro
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):dech:pushde
 ldd,(hl):dech:lde,(hl):pushde
            endm

ADDHLHL     macro
            rept =1:add hl,hl:endr
            endm

SUB_DE      macro:or a:sbc hl,de:endm
SUB_BC      macro:or a:sbc hl,bc:endm

ACPL_A      macro:or a:jpp $+4:cpl:endm

EXD         macro:ex de,hl:endm


