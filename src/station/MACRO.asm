;==============================================================================
; MACRO - макросы станции
;
; Подключается всеми модулями после EQUS. Группы: выравнивание (ADRXX00), 16-битные операции (SUB_BC,
; SUB_DE, INC_HL, DEC_HL, ADDHLHL, EXD, NEGHL, ABSHL...), переходы по страницам (PAGE_, PAGES, PAGE___NOARG,
; PAGES__NOARG), сдвиг/выбор адреса экрана (NEXTLINE, NEXTLINEDE, NEXTZNAK, PUTDOT, GETADR, LDX_HL_A).
; Имена макросов оставлены оригинальными: их использует весь код.
;==============================================================================

; Макросы

; Выравнивание адреса
            MACRO ADRXX00
            ds   (low((high(($-1))))*256)-$+256
            ENDM

            MACRO ADDIXIX
            db   #DD,#29
            ENDM

            MACRO SUB_BC
            or   a
            sbc  hl,bc
            ENDM
            MACRO SUB_DE
            or   a
            sbc  hl,de
            ENDM
            MACRO INC_HL par1
            rept par1
            inc  hl
            endr
            ENDM
            MACRO INC_DE par1
            rept par1
            inc  de
            endr
            ENDM
            MACRO DEC_HL par1
            rept par1
            dec  hl
            endr
            ENDM
            MACRO DEC_DE par1
            rept par1
            dec  de
            endr
            ENDM


; Следующая линия в скрине
            MACRO NEXTLINE
            inc  h
            ld   a,h
            and  7
            jp   nz,$+13
            NEXTZNAK
            ENDM

; След.знакомест
            MACRO NEXTZNAK
            ld   a,l
            add  a,32
            ld   l,a
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            ENDM

; Следующая линия в скрине рег. de
            MACRO NEXTLINEDE
            inc  d
            ld   a,d
            and  7
            jp   nz,$+13
            ld   a,e
            add  a,32
            ld   e,a
            jr   c,$+6
            ld   a,d
            sub  8
            ld   d,a
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
            call SetPage
            ENDM
            MACRO PAGE___NOARG
            ld   a,PGNORM
            call SetPage
            ENDM

            MACRO PAGES par1
            ld   a,par1
            call SetBank
            ENDM
            MACRO PAGES__NOARG
            ld   a,PGNORM
            call SetBank
            ENDM

; Операция сложения hl,dес проверкой
; Флага переполнения и коррекцией
            MACRO ADPHLDE par1
            adc  hl,de
            jp   po,$+14
            EXD
            ld   hl,0
            and  a
            sbc  hl,de
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


; Сложение a=a+хнс учетом перепонения
            MACRO ADPAXH
            add  a,ixh
            jp   po,$+9
            neg
            jp   po,$+4
            dec  a
            ENDM

; Вычитание a=a-хнс учетом перепонения
            MACRO SBPAXH
            sub  ixh
            jp   po,$+9
            neg
            jp   po,$+4
            dec  a
            ENDM


; ДЛЯ
; Деление быстрое точное оптимизированное
; Делим hl=hl/de
; Единственный параметр должен быть адрес
; Процедуры обработки переполнения
; При делении на 0 и т.д.
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


            MACRO SPRO1
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            inc  hl
            dec  e
            NEXTLINEDE
            ENDM

; Рисовать точку на экране
; В a,b- Y,X
            MACRO PUTDOT
            ld   l,a
            ld   h,high(TBXX2_)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,b
            add  a,(hl)
            ld   e,a
            inc  h
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            ENDM

; Получить адрес на экране из координат
; В l,e-Y,X
            MACRO GETADR
            ld   h,high(TBXX)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            or   (hl)
            ld   e,a
            ENDM


; Макрос для вывода шрифта
            MACRO LDX_HL_A
            xor  (hl)
            ld   (hl),a
            ENDM


            MACRO ADDHLHL par1
            rept par1
            add  hl,hl
            endr
            ENDM

            MACRO EXD
            ex   de,hl
            ENDM

; Печать символа
            MACRO RST_ par1
            ld   a,par1
            call PrintGlyph
            ENDM
            MACRO RST___NOARG
            call PrintGlyph
            ENDM
