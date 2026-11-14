;ADRXX00         ■ADDIXIX
;SUB_BC          ■SUB_DE
;INC_HL          ■INC_DE
;DEC_HL          ■DEC_DE
;NEXTLINE        ■NEXTZNAK
;NEXTLINEDE      ■PREVLINE
;PAGE            ■PAGES
;ADPHLDE         ■NEGHL
;NEGDE           ■NEGBC
;ABSHL           ■ABSDE
;ABSBC           ■ADPAXH
;SBPAXH          ■SM1
;SM2             ■SM3
;SPRO1           ■PUTDOT
;GETADR          ■LDX_HL_A
;ADDHLHL         ■EXD
;RST_





; МАКРОСЫ

; ВЫРАВНИВАНИЕ АДРЕСА
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


; СЛЕДУЮЩАЯ ЛИНИЯ В СКРИНЕ
            MACRO NEXTLINE
            inc  h
            ld   a,h
            and  7
            jp   nz,$+13
            NEXTZNAK
            ENDM

; СЛЕД.ЗНАКОМЕСТ
            MACRO NEXTZNAK
            ld   a,l
            add  a,32
            ld   l,a
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            ENDM

; СЛЕДУЮЩАЯ ЛИНИЯ В СКРИНЕ РЕГ. de
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

; ПРЕДЫДУЩАЯ ЛИНИЯ В СКРИНЕ
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

; ВЫЗОВ ПЕРЕКЛЮЧЕНИЯ СТРАНИЦЫ
            MACRO PAGE_ par1
            ld   a,par1
            call PG
            ENDM
            MACRO PAGE___NOARG
            ld   a,PGNORM
            call PG
            ENDM

            MACRO PAGES par1
            ld   a,par1
            call PGS
            ENDM
            MACRO PAGES__NOARG
            ld   a,PGNORM
            call PGS
            ENDM

; ОПЕРАЦИЯ СЛОЖЕНИЯ hl,deС ПРОВЕРКОЙ
; ФЛАГА ПЕРЕПОЛНЕНИЯ И КОРРЕКЦИЕЙ
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

; ИНВЕРСИЯ hl
            MACRO NEGHL
            ld   a,l
            cpl  
            ld   l,a
            ld   a,h
            cpl  
            ld   h,a
            inc  hl
            ENDM
; ИНВЕРСИЯ de
            MACRO NEGDE
            ld   a,e
            cpl  
            ld   e,a
            ld   a,d
            cpl  
            ld   d,a
            inc  de
            ENDM
; ИНВЕРСИЯ bc
            MACRO NEGBC
            ld   a,c
            cpl  
            ld   c,a
            ld   a,b
            cpl  
            ld   b,a
            inc  bc
            ENDM

; АБСОЛЮТНОЕ ЗНАЧЕНИЕ hl
            MACRO ABSHL
            bit  7,h
            jr   z,$+9
            NEGHL
            ENDM

; АБСОЛЮТНОЕ ЗНАЧЕНИЕ de
            MACRO ABSDE
            bit  7,d
            jr   z,$+9
            NEGDE
            ENDM

; АБСОЛЮТНОЕ ЗНАЧЕНИЕ bc
            MACRO ABSBC
            bit  7,b
            jr   z,$+9
            NEGBC
            ENDM


; СЛОЖЕНИЕ a=a+xhС УЧЕТОМ ПЕРЕПОНЕНИЯ
            MACRO ADPAXH
            add  a,ixh
            jp   po,$+9
            neg  
            jp   po,$+4
            dec  a
            ENDM

; ВЫЧИТАНИЕ a=a-xhС УЧЕТОМ ПЕРЕПОНЕНИЯ
            MACRO SBPAXH
            sub  ixh
            jp   po,$+9
            neg  
            jp   po,$+4
            dec  a
            ENDM


; ДЛЯ
; ДЕЛЕНИЕ БЫСТРОЕ ТОЧНОЕ ОПТИМИЗИРОВАННОЕ
; ДЕЛИМ hl=hl/de
; ЕДИНСТВЕННЫЙ ПАРАМЕТР ДОЛЖЕН БЫТЬ АДРЕС
; ПРОЦЕДУРЫ ОБРАБОТКИ ПЕРЕПОЛНЕНИЯ
; ПРИ ДЕЛЕНИИ НА 0 И Т.Д.
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

; РИСОВАТЬ ТОЧКУ НА ЭКРАНЕ
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

; ПОЛУЧИТЬ АДРЕС НА ЭКРАНЕ ИЗ КООРДИНАТ
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



; МАКРОС ДЛЯ ВЫВОДА ШРИФТА
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

; ПЕЧАТЬ СИМВОЛА
            MACRO RST_ par1
            ld   a,par1
            call Pntpro
            ENDM
            MACRO RST___NOARG
            call Pntpro
            ENDM

