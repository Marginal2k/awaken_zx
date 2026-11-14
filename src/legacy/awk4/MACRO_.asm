;ADRXX00          ■NEXTLINE
;PREVLINE         ■PAGE
;ADDIXIX          ■ADDIYIY
;ADPHLDE          ■NEGHL
;NEGDE            ■NEGBC
;ABSHL            ■ABSDE
;ABSBC            ■CYCL1
;MULAB            ■MULAC
;MULAD            ■ADPAXH
;SBPAXH           ■DIVED
;SM1              ■SM2
;SM3              ■MESAG
;MVOX             ■HIDEM
;ADDHLHL          ■SUB_DE
;SUB_BC           ■ACPL_A
;EXD






; МАКРОСЫ

; ВЫРАВНИВАНИЕ АДРЕСА
            MACRO ADRXX00
            ds   (low((high(($-1))))*256)-$+256
            ENDM

; СЛЕДУЮЩАЯ ЛИНИЯ В СКРИНЕ
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
            call Page_
            ENDM
            MACRO PAGE___NOARG
            ld   a,MAIN
            call Page_
            ENDM

; НЕ ОБРАБАТЫВАЕМАЯ КОМНДА addix,ix
            MACRO ADDIXIX
            db   #DD,#29
            ENDM

; НЕ ОБРАБАТЫВАЕМАЯ КОМНДА addiy,iy
            MACRO ADDIYIY
            db   #FD,#29
            ENDM

; ОПЕРАЦИЯ СЛОЖЕНИЯ hl,deС ПРОВЕРКОЙ
; ФЛАГА ПЕРЕПОЛНЕНИЯ И КОРРЕКЦИЕЙ
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
            ld   a,h
            or   a
            jp   p,$+9
            cpl  
            ld   h,a
            ld   a,l
            cpl  
            ld   l,a
            inc  hl
            ENDM

; АБСОЛЮТНОЕ ЗНАЧЕНИЕ de
            MACRO ABSDE
            ld   a,d
            or   a
            jp   p,$+9
            cpl  
            ld   d,a
            ld   a,e
            cpl  
            ld   e,a
            inc  de
            ENDM

; АБСОЛЮТНОЕ ЗНАЧЕНИЕ bc
            MACRO ABSBC
            ld   a,b
            or   a
            jp   p,$+9
            cpl  
            ld   b,a
            ld   a,c
            cpl  
            ld   c,a
            inc  bc
            ENDM


; УМНОЖЕНИЕ ЗНАКОВОЕ a=a*b
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

; УМНОЖЕНИЕ ЗНАКОВОЕ a=a*c
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

; УМНОЖЕНИЕ ЗНАКОВОЕ a=a*d
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

; ДЕЛЕНИЕ AE=e/d
            MACRO DIVED
            rept 8
            rl   e
            rla  
            sub  d
            jr   nc,$+3
            add  a,d
            endr
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



            MACRO HIDEM
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):dech:pushde
;  ldd,(hl):dech:lde,(hl):pushde
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


