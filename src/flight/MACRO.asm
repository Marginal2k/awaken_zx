;EXD


; Макросы

; Выравнивание адреса
            MACRO ADRXX00
            ds   (low((high(($-1))))*256)-$+256
            ENDM

; Следующая линия в скрине
            MACRO NEXTLINE
            inc  h
            ld   a,h
            and  7
            jp   nz,$+13
            ld   a,l
            add  a,32
            ld   l,a
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            ENDM

; Предыдущая линия в скрине
            MACRO PREVLINE
            ld   a,h
            dec  h
            and  7
            jp   nz,$+13
            ld   a,l
            sub  32
            ld   l,a
            jr   c,$+6
            ld   a,h
            add  a,8
            ld   h,a
            ENDM

; Вызов переключения страницы
            MACRO PAGE_ par1
            ld   a,par1
            call Page_
            ENDM
            MACRO PAGE___NOARG
            ld   a,MAIN
            call Page_
            ENDM

; Не обрабатываемая комнда addix,ix
            MACRO ADDIXIX
            db   #DD,#29
            ENDM

; Не обрабатываемая комнда addiy,iy
            MACRO ADDIYIY
            db   #FD,#29
            ENDM

; Операция сложения hl,dес проверкой
; флага переполнения и коррекцией
            MACRO ADPHLDE par1
            adc  hl,de
            jp   po,$+14
            EXD
            ld   hl,0
            SUB_DE
            jp   po,$+4
            dec  hl
            ld   (par1+1),hl
            ENDM

; Инверсия hl
            MACRO NEGHL
            ld   a,l
            cpl
            ld   l,a
            ld   a,h
            cpl
            ld   h,a
            inc  hl
            ENDM
; Инверсия de
            MACRO NEGDE
            ld   a,e
            cpl
            ld   e,a
            ld   a,d
            cpl
            ld   d,a
            inc  de
            ENDM
; Инверсия bc
            MACRO NEGBC
            ld   a,c
            cpl
            ld   c,a
            ld   a,b
            cpl
            ld   b,a
            inc  bc
            ENDM

; Абсолютное значение hl
            MACRO ABSHL
            bit  7,h
            jr   z,$+9
            NEGHL
            ENDM

; Абсолютное значение de
            MACRO ABSDE
            bit  7,d
            jr   z,$+9
            NEGDE
            ENDM

; Абсолютное значение bc
            MACRO ABSBC
            bit  7,b
            jr   z,$+9
            NEGBC
            ENDM

; Цикл рисования строки воксспрайта
            MACRO CYCL1
            ld   e,h
            add  hl,sp
            ld   a,(de)
            exx
            ld   c,a
            ld   b,high(VXTAB)
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
            ENDM

; Умножение знаковое a=a*b
            MACRO MULAB
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
            ENDM

; Умножение знаковое a=a*c
            MACRO MULAC
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
            ENDM

; Умножение знаковое a=a*d
            MACRO MULAD
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
            ENDM

; Сложение a=a+хhс учетом перепонения
            MACRO ADPAXH
            add  a,ixh
            jp   po,$+9
            neg
            jp   po,$+4
            dec  a
            ENDM

; Вычитание a=a-хhс учетом перепонения
            MACRO SBPAXH
            sub  ixh
            jp   po,$+9
            neg
            jp   po,$+4
            dec  a
            ENDM

; Деление AE=e/d
            MACRO DIVED
            rept 8
            rl   e
            rla
            sub  d
            jr   nc,$+3
            add  a,d
            endr
            ENDM

; Для
; деление быстрое точное оптимизированное
; делим hl=hl/de
; единственный параметр должен быть адрес
; процедуры обработки переполнения
; при делении на 0 и т.д.
            MACRO SM1
            ld   c,a
            ld   a,l
            ld   l,h
            ld   h,c
            ENDM
            MACRO SM2
            adc  hl,hl
            rla
            cp   d
            ENDM
            MACRO SM3
            sli  l
            rl   h
            ENDM

; Печать сообщений в очереди компутера
            MACRO MESAG par1
            push de
            ld   de,par1
            call MESAG_
            pop  de
            ENDM

            MACRO MVOX

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

            ENDM


            MACRO HIDEM par1,par2
            ld   sp,hl
            ld   l,par1
            pop  af
            pop  bc
            pop  de
            pop  ix
            ex   af,af'
            exx
            pop  af
            pop  bc
            pop  de
            pop  iy
            ld   sp,hl
            inc  sp
            set  4,l
            push iy
            push de
            push bc
            push af
            ex   af,af'
            exx
            push ix
            push de
            push bc
            push af
            ld   sp,hl
            ld   l,par2
            pop  af
            pop  bc
            pop  de
            pop  ix
            ex   af,af'
            exx
            pop  af
            pop  bc
            pop  de
            pop  iy
            ld   sp,hl
            inc  sp
            push iy
            push de
            push bc
            push af
            res  4,l
            inc  h
            ex   af,af'
            exx
            push ix
            push de
            push bc
            push af
            ENDM

            MACRO ADDHLHL par1
            rept par1
            add  hl,hl
            endr
            ENDM

            MACRO SUB_DE
            or   a
            sbc  hl,de
            ENDM
            MACRO SUB_BC
            or   a
            sbc  hl,bc
            ENDM

            MACRO ACPL_A
            or   a
            jp   p,$+4
            cpl
            ENDM

            MACRO EXD
            ex   de,hl
            ENDM
