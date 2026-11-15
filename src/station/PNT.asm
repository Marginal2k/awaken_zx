;==============================================================================
; PNT - вывод текста: пропорциональный шрифт, форматирование, числа, сдвиг спрайтов
;
; Где живёт: основной образ STATIONF.C, после DOPPROC.
;
; PrintText (OTXT) - вывод текста с выравниванием по ширине окна; VirtualPrint - тот же проход без печати
; (считает Y); OutText - вывод до конца окна/экрана; PrintGlyph - один символ; S00..S07 (и S_0x, S0x_,
; S_0x_) - развёрнутые rept-процедуры вывода символа со сдвигом на 0-7 пикселей; PrintNumber*
; (десятичные числа); MeasureText/MeasureTextZ (ширина по таблице SZTB); TabStop1..5; PrintSpecialChar.
; Границы окна WinBeginX/Y, WinEndX/Y - самомодифицируемые операнды (задаются в OBJ.asm).
;==============================================================================

VirtualPrint   ; orig: VTXT
; Виртуальный вывод одной строки текста
; Не печатая, только меняя координату Y
; X=0,вернет в нlтекст с кот. печатать
; Днную строку.
; hl-TXT
; Fc-on - конец текста
            ld   a,(WinEndY+1)
            cp   14
            ret  c

            ld   a,#C3
            ld   (STOPP),a
            ld   de,PrintEnd
            ld   (STOPP+1),de
            ld   a,(WinEndX+1)
            ld   (.EW2+1),a
.L_T
.EW2
            ld   c,0
            ld   b,32
            ld   e,0
            push hl
            xor  a
.L_1
            ld   d,a
            call MeasureText
            add  a,SPLEN
            inc  hl
            inc  e
            add  a,d
            jr   c,.L_8
            cp   c
            jr   c,.L_1
            sub  SPLEN
            cp   c
            jr   nc,.L_8
            dec  e
            jr   nz,$+3
            inc  e
            inc  e
.L_8
            dec  e
            pop  hl
            jr   nz,.L_4
            call .L_2
            jr   .EVP

.L_4
; Расстановка координат X для слов и их
; Вывод
            ld   a,c
            sub  d
            ld   d,a
            dec  e
            jr   z,.L_51
; В "A" - сколько пикселей до конца окна
            ld   d,#FF

            inc  d
            sub  e
            jp   nc,$-2
.L_51
            inc  e
.L_5
            call .L_2
            jr   z,.EVP
            ld   a,(Cord)
            add  a,SPLEN            ; Ширина пробела
            add  a,d
            ld   (Cord),a
            dec  e
            jp   nz,.L_5
            call O_9
            and  a
.EVP
; Конец
            ld   a,#68
            ld   (STOPP),a
            ld   de,#2648
            ld   (STOPP+1),de
            ret
.L_2
; Вывод слова
; Fc-on конец текста
            ld   a,(hl)
            inc  hl
            cp   CR
            jr   z,.L_33
            cp   ET
            scf
            ret  z
            cp   32
            jr   z,.L_3
            RST___NOARG
            jr   c,.L_2
            and  a
            jr   z,.L_2
            cp   3
            jr   nz,.L_31
            dec  hl
            call O_9
.L_31
            xor  a
            ret
.L_3
            inc  a
            ret
.L_33
            xor  a
            inc  a
            ld   e,a
            ret


; ────────────────────

PrintText   ; orig: OTXT
; Вывод текста с форматированием
; hl-адрес текста
            ld   a,(WinEndY+1)
            cp   14
            ret  c
            ld   a,(WinEndX+1)
            ld   (.EW+1),a
.O_T
.EW
            ld   c,0
            ld   b,32
            ld   e,0
            push hl
            xor  a
.O_1
            ld   d,a
            call MeasureText
            add  a,SPLEN
            inc  hl
            inc  e
            add  a,d
            jr   c,.O_8
            cp   c
            jr   c,.O_1
            sub  SPLEN
            cp   c
            jr   nc,.O_8
            dec  e
            jr   nz,$+3
            inc  e
            inc  e
.O_8
            dec  e
            pop  hl
            jr   nz,.O_4
            call .O_2
            ret  z
            jp   .O_T

.O_4
; Расстановка координат X для слов и их
; Вывод
            ld   a,c
            sub  d
            ld   d,a
            dec  e
            jr   z,.O_51
; В "A" - сколько пикселей до конца окна
            ld   d,#FF

            inc  d
            sub  e
            jp   nc,$-2
.O_51
            inc  e
.O_5
            call .O_2
            ret  z
            ld   a,(Cord)
            add  a,SPLEN            ; Ширина пробела
            add  a,d
            ld   (Cord),a
            dec  e
            jp   nz,.O_5
            call O_9
            ret  c
            jp   .O_T
.O_2
; Вывод слова
            ld   a,(hl)
            inc  hl
            cp   CR
            jr   z,.O_33
            cp   ET
            ret  z
            cp   32
            jr   z,.O_3
            RST___NOARG
            jr   c,.O_2
            and  a
            jr   z,.O_2
            cp   3
            jr   nz,.O_31
            dec  hl
            call O_9
            ld   a,1
            dec  a
            ret  c
            inc  a
            ret
.O_33
            xor  a
            inc  a
            ld   e,a
            ret
.O_31
            xor  a
            ret
.O_3
            inc  a
            ret

; След. координата Y
O_9
            ld   a,(Cord+1)
            add  a,8
            ld   c,a
            ld   a,(WinEndY+1)
            ld   b,a
            ld   a,c
            cp   b
            ccf
            ret  c
            ld   (Cord+1),a
            xor  a
            ld   (Cord),a
            ret


WDW
; Вылет снизу окна
            and  a
            ld   a,2
            jp   PrintEnd+2
WRW
; Вылет справа окна
            and  a
            ld   a,3
            jp   PrintEnd+2
WRS
            and  a
            jp   m,PrintEnd            ; Недолет слева,
; Вылет справа экрана
            xor  a
            jp   PrintEnd+2
WRS2
            and  a
            jp   m,PrintEnd            ; Недолет cbep
; Вылет вниз экрана
            xor  a
            inc  a
            jp   PrintEnd+2
WDE
; Вылет вниз экрана
            ld   a,1
            jp   PrintEnd+2


; Описать метки font,tabas andtabxx
; Таблицамасок

; Print proporcionalx#18
; a-CODE
; (Cord+1)-X/Y inpix
; retFC-ON ifALLRIGHT
; Iffc-off that was outof window
; И с fc-off рег."а" говорит:
; 0-Вылет справа экрана
; 1-Вылет снизу экрана
; 2-Вылет снизу окна
; 3-Вылет справа окна

PrintGlyph   ; orig: Pntpro
; Вывод одного символа
            push de
            push bc
            push hl
            exx
            push de
            push bc
            push hl
            ex   af,af'
            push af
            ex   af,af'
            ld   l,a
            ld   e,a
            ld   d,high(SZTB)
            ld   h,0
            ADDHLHL 3
            ld   bc,Font
            add  hl,bc
            EXD
            ld   bc,(Cord)

            ld   a,b

WinEndY   ; orig: Eyw
; Нижняя граница окна (самомодиф.)
            cp   0   ; End of win -8+1-ramka
            jr   nc,WDW

            ld   a,(hl)
; NUM inhl= %0000XXXX
            add  a,c
            jr   c,WRW

WinEndX   ; orig: Exw
; Правая граница окна
            cp   0
            jp   nc,WRW

            ld   (Cord),a

WinBeginX   ; orig: Bxw
; Левая граница окна
            ld   a,0
            add  a,c
            ld   c,a

WinBeginXHi   ; orig: Bxh
; Старший байт левой границы
            ld   a,0
            adc  a,0
            jr   nz,WRS

; След.симв
            ld   a,c
            ex   af,af'

WinBeginY   ; orig: Byw
; Верхняя граница окна
            ld   a,0
            add  a,b
            ld   b,a

WinBeginYHi   ; orig: Byh
; Старший байт верхней границы
            ld   a,0
            adc  a,0
            jr   nz,WRS2

; Ху,след.строка
            ld   a,b
            cp   192-7
            jr   nc,WDE

STOPP
; #68,#48,#26
            ld   l,b
            ld   c,b
            ld   h,high(TBXX)
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ex   af,af'
            ld   l,a
            ex   af,af'
            or   (hl)
            ld   l,a
            ld   h,b

            ex   af,af'
            and  7
            add  a,a
            ld   b,a

            ld   a,l
            inc  a
            and  #1F
            jp   nz,$+4
            inc  b
            ld   a,b
            add  a,a
            add  a,a
            add  a,a
            ld   b,a
            ld   a,c
            and  7
            add  a,b
            exx
            add  a,a
            ld   l,a
            ld   h,high(Tabx)/2
            add  hl,hl
RETT
            ld   c,(hl)
            inc  l
            ld   b,(hl)
            inc  l
            and  a
            ld   ($+6),bc
            exx
            jp   0


S00
;  rept7: lda,(de):LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            LDX_HL_A
            exx
            jp   PrintEnd

S_00
;  rept7: lda,(de):LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S01
;  rept7: ldc,0:lda,(de):rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A
            exx
            jp   PrintEnd

S_01
;  rept7: ldc,0:lda,(de):rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S01_
;  rept7: lda,(de):rra:LDX_HL_A:ince:inch
            rept 7
            ld   a,(de)
            rra
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rra
            LDX_HL_A
            exx
            jp   PrintEnd

S_01_
;  rept7: lda,(de):rra:LDX_HL_A:ince:inch
            rept 7
            ld   a,(de)
            rra
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S02
;  rept7: ldc,0:lda,(de):rra:rrc:rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A
            exx
            jp   PrintEnd

S_02
;  rept7: ldc,0:lda,(de):rra:rrc:rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S02_
;  rept7: lda,(de):rra:srla:LDX_HL_A:ince:inch
            rept 7
            ld   a,(de)
            rra
            srl  a
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rra
            srl  a
            LDX_HL_A
            exx
            jp   PrintEnd

S_02_
;  rept7: lda,(de):rra:srla:LDX_HL_A:ince:inch
            rept 7
            ld   a,(de)
            rra
            srl  a
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT

S03
;  rept7: ldc,0:lda,(de):rra:rrc:rra:rrc:rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A
            exx
            jp   PrintEnd

S_03
;  rept7: ldc,0:lda,(de):rra:rrc:rra:rrc:rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT

S03_
;  rept7: lda,(de):rra:rra:rra:and#1F:LDX_HL_A:ince:inch
            rept 7
            ld   a,(de)
            rra
            rra
            rra
            and  #1F
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rra
            rra
            rra
            and  #1F
            LDX_HL_A
            exx
            jp   PrintEnd

S_03_
;  rept7: lda,(de):rra:rra:rra:and#1F:LDX_HL_A:ince:inch
            rept 7
            ld   a,(de)
            rra
            rra
            rra
            and  #1F
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S04
;  rept7: ldc,0:lda,(de):rra:rrc:rra:rrc:rra:rrc:rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A

            exx

PrintEnd   ; orig: Endpr
; Конец вывода (флаги окончания текста/окна)
            xor  a
            scf
            ex   af,af'
            pop  af
            ex   af,af'
            pop  hl
            pop  bc
            pop  de
            exx
            pop  hl
            pop  bc
            pop  de
            ret


S_04
;  rept7: ldc,0:lda,(de):rra:rrc:rra:rrc:rra:rrc:rra:rrc:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   c,0
            ld   a,(de)
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            rra
            rr   c
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT

S04_
;  rept7: lda,(de):rra:rra:rra:rra:and#0F:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rra
            rra
            rra
            rra
            and  #0F
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rra
            rra
            rra
            rra
            and  #0F
            LDX_HL_A
            exx
            jp   PrintEnd

S_04_
;  rept7: lda,(de):rra:rra:rra:rra:and#0F:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rra
            rra
            rra
            rra
            and  #0F
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S05
;  rept7: lda,(de):ldc,a:xora:rlc:rla:rlc:rla:rlc:rla:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            rl   c
            rla
            rl   c
            rla
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            rl   c
            rla
            rl   c
            rla
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A
            exx
            jp   PrintEnd

S_05
;  rept7: lda,(de):ldc,a:xora:rlc:rla:rlc:rla:rlc:rla:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            rl   c
            rla
            rl   c
            rla
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT

S05_
;  rept7: lda,(de):rlca:rlca:rlca:and#07:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rlca
            rlca
            rlca
            and  #07
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rlca
            rlca
            rlca
            and  #07
            LDX_HL_A
            exx
            jp   PrintEnd

S_05_
;  rept7: lda,(de):rlca:rlca:rlca:and#07:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rlca
            rlca
            rlca
            and  #07
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S06
;  rept7: lda,(de):ldc,a:xora:rlc:rla:rlc:rla:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            rl   c
            rla
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            rl   c
            rla
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A
            exx
            jp   PrintEnd

S_06
;  rept7: lda,(de):ldc,a:xora:rlc:rla:rlc:rla:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            rl   c
            rla
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT

S06_
;  rept7: lda,(de):rlca:rlca:and3:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rlca
            rlca
            and  3
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rlca
            rlca
            and  3
            LDX_HL_A
            exx
            jp   PrintEnd

S_06_
;  rept7: lda,(de):rlca:rlca:and3:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rlca
            rlca
            and  3
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


S07
;  rept7: lda,(de):ldc,a:xora:rlc:rla:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            LDX_HL_A
            inc  l
            ld   a,c
            LDX_HL_A
            exx
            jp   PrintEnd

S_07
;  rept7: lda,(de):ldc,a:xora:rlc:rla:LDX_HL_A:incl,e:lda,c:LDX_HL_A:decl:inch
            rept 7
            ld   a,(de)
            ld   c,a
            xor  a
            rl   c
            rla
            LDX_HL_A
            inc  l
            inc  e
            ld   a,c
            LDX_HL_A
            dec  l
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT

S07_
;  rept7: lda,(de):rlca:and1:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rlca
            and  1
            LDX_HL_A
            inc  e
            inc  h
            endr
            ld   a,(de)
            rlca
            and  1
            LDX_HL_A
            exx
            jp   PrintEnd

S_07_
;  rept7: lda,(de):rlca:and1:LDX_HL_A:ince,h
            rept 7
            ld   a,(de)
            rlca
            and  1
            LDX_HL_A
            inc  e
            inc  h
            endr
            NEXTZNAK
            exx
            jp   RETT


.Onum4
; bc-NUM
            push hl
            push de
            ld   hl,999
            SUB_BC
            jp   c,On99
            RST_ "0"
            jp   nc,One21
            jp   On99

PrintNumber2   ; orig: Onum2
; Вывод числа, 2 знака
; bc-number
            push hl
            push de
            ld   hl,9
            SUB_BC
            jp   c,.Om21
            RST_ "0"
            jp   nc,One21
.Om21
            call PrintNumber
One21
            pop  de
            pop  hl
            ret
.Onum3
; bc-number
            push hl
            push de
On99
            ld   hl,99
            SUB_BC
            jp   c,.Om1
            RST_ "0"
            jp   nc,.One1
            ld   hl,9
            SUB_BC
            jp   c,.Om1
            RST_ "0"
            jp   nc,.One1
.Om1
            call PrintNumber
.One1
            pop  de
            pop  hl
            ret

PrintNumberPad   ; orig: Onum5
; Вывод числа с ведущими нулями
; bc-number
; a-число выводимых нулей если они будут
; Перед числом
            push hl
            push de
            ex   af,af'
            push af
            ex   af,af'
            ld   hl,9999
            SUB_BC
            jp   c,.Om11
            dec  a
            jp   m,.Om5
            ex   af,af'
            RST_ "0"
            jp   nc,.One2
            ex   af,af'
.Om5
            ld   hl,999
            SUB_BC
            jp   c,.Om2
            dec  a
            jp   m,.Om2
            ex   af,af'
            RST_ "0"
            jp   nc,.One2
            ex   af,af'
.Om2
            ld   hl,99
            SUB_BC
            jp   c,.Om31
            dec  a
            jp   m,.Om31
            ex   af,af'
            RST_ "0"
            jp   nc,.One2
            ex   af,af'
.Om31
            ld   hl,9
            SUB_BC
            jp   c,.Om3
            dec  a
            jp   m,.Om3
            ex   af,af'
            RST_ "0"
            jp   nc,.One2
            ex   af,af'
.Om3
            call PrintNumber
.One2
            ex   af,af'
            pop  af
            ex   af,af'
            pop  de
            pop  hl
            ret
.Om11
            ex   af,af'
            ld   h,b
            ld   l,c
            ld   bc,20000
            xor  a
            add  a,"0"
            sbc  hl,bc
            inc  a
            jp   c,.Om4
            ld   bc,10000
            sbc  hl,bc
            inc  a
            jp   c,.Om4
            sbc  hl,bc
            inc  a
            jp   c,.Om4
            sbc  hl,bc
            inc  a
            jp   c,.Om4
            sbc  hl,bc
            inc  a
            jp   c,.Om4
            inc  a
            jp   .Om41
.Om4
            ld   bc,10000
            add  hl,bc
.Om41
            ld   b,h
            ld   c,l
            RST___NOARG
            jp   nc,.One2
            ex   af,af'
            ld   a,4
            jp   .Om5

PrintNumber   ; orig: ONUMB
; Вывод числа BC
; bc-number
            push hl
            push de
            ld   h,b
            ld   l,c
            ld   bc,1000
            xor  a
            dec  a
            inc  a
            sbc  hl,bc
            jr   nc,$-3
            add  hl,bc
            and  a
            ld   e,a
            jr   z,$+9
            add  a,"0"
            RST___NOARG
            jr   nc,.O_NB1

            ld   bc,100
            xor  a
            dec  a
            inc  a
            sbc  hl,bc
            jr   nc,$-3
            add  hl,bc
            inc  e
            dec  e
            jr   nz,$+6
            and  a
            ld   e,a
            jr   z,$+9
            add  a,"0"
            RST___NOARG
            jr   nc,.O_NB1

            ld   bc,10
            xor  a
            dec  a
            inc  a
            sbc  hl,bc
            jr   nc,$-3
            add  hl,bc
            inc  e
            dec  e
            jr   nz,$+5
            and  a
            jr   z,$+9
            add  a,"0"
            RST___NOARG
            jr   nc,.O_NB1
            ld   a,l
            add  a,"0"
            RST___NOARG
.O_NB1
            pop  de
            pop  hl
            ret


; ────────────────────
; Тоже входит в блок Outtxt
Tood5
            ld   a,(Mode+1)
            and  a
            jr   z,Tood4
            inc  hl

OutText   ; orig: Outtxt
; Вывод текста до конца окна или экрана
; hl-адрес текста
; retFC-OFF конец текста
; FC-ON конец окна или экрана
; CODES:ET-конец текста,CR-перевод строки
; 2,3,4,5,6-табуляция
; 1-код останавливающий вывод текста на
            ; ??? момент дописывания чего-нибудь
            ld   a,(hl)
            inc  hl
            cp   ET
            ret  z
            cp   CR
            jr   z,Tood
            cp   7
            jr   c,Tood3
            RST___NOARG
            jp   c,OutText           ; No incident
            dec  hl
            and  a
            jr   z,Tood5
            dec  a
            scf
            ret  z                  ; End scr
            dec  a
            scf
            ret  z                  ; End win

; Режимвыводатекста bokhe,<>0-сперен
; Ocom,=0-без переноса
Mode
            ld   a,0
            and  a
; С переноса
            jr   nz,Tood2
; Без переноса
Tood4
            ld   a,(hl)
            inc  hl
            cp   ET
            ret  z
            cp   CR
            jp   nz,$-7
            dec  hl
            jp   OutText
Tood
; CHANGE Y=Y+8,ifoutOF WIN THAN retnc
; ,Cord doesnt store
            ld   a,(Cord+1)
            add  a,8
            push bc
            ld   c,a
            ld   a,(WinEndY+1)
            ld   b,a
            ld   a,c
            cp   b
            pop  bc
            ccf
            ret  c
            ld   (Cord+1),a
            xor  a
            ld   (Cord),a
FLAGOT
            jp   OutText             ; #C3,#C9
Tood2
            ld   a,(Cord+1)
            add  a,8
            push bc
            ld   c,a
            ld   a,(WinEndY+1)
            ld   b,a
            ld   a,c
            cp   b
            pop  bc
            ccf
            ret  c
            ld   (Cord+1),a
            xor  a
            ld   (Cord),a
            jp   OutText
Tood3
; Табуляции
            dec  a
            or   a
            ret  z
            dec  a
            jr   nz,$+10

TabStop1   ; orig: CXTAB1
; Табуляция 1
            ld   a,0
            ld   (Cord),a
            jp   OutText
            dec  a
            jr   nz,$+10

TabStop2   ; orig: CXTAB2
; Табуляция 2
            ld   a,0
            ld   (Cord),a
            jp   OutText
            dec  a
            jr   nz,$+10

TabStop3   ; orig: CXTAB3
; Табуляция 3
            ld   a,0
            ld   (Cord),a
            jp   OutText
            dec  a
            jr   nz,$+10

TabStop4   ; orig: CXTAB4
; Табуляция 4
            ld   a,0
            ld   (Cord),a
            jp   OutText
            dec  a
            jr   nz,$+10

TabStop5   ; orig: CXTAB5
; Табуляция 5
            ld   a,0
            ld   (Cord),a
            jp   OutText

; ────────────────────

MeasureText   ; orig: Hlt
; Длина текста в пикселях до символа B
; Измеряем длинну текста/строки в пиксел.
; b-символ до которого измерять
; hl-текст
; Retina, если превышает 255, то выход
; С установленным в а 255
            push de
            push bc
            ld   c,0
            ld   d,high(SZTB)
.HlT2
            ld   a,(hl)
            cp   CR
            jr   z,.HlT1
            cp   ET
            jr   z,.HlT1
            cp   b
            jr   z,.HlT1
            ld   e,a
            ld   a,(de)
            add  a,c
            jr   c,.HlT3
            jr   z,.HlT3
            inc  hl
            ld   c,a
            jp   .HlT2
.HlT3
            ld   c,#FF
.HlT1
            ld   a,c
            pop  bc
            pop  de
            ret


; ────────────────────

MeasureTextZ   ; orig: Hltxt
; Длина строки текста в пикселях
; Измеряем длинну текста/строки в пиксел.
; hl-текст
; Retina, если превышает 255, то выход
; С установленным в а 255
            push hl
            push de
            push bc
            ld   c,0
            ld   d,high(SZTB)
.Hl2
            ld   a,(hl)
            cp   CR
            jr   z,.Hl1
            cp   ET
            jr   z,.Hl1
            cp   b
            jr   z,.Hl1
            ld   e,a
            inc  hl
            ld   a,(de)
            add  a,c
            jr   c,.Hl3
            jr   z,.Hl3
            ld   c,a
            jp   .Hl2
.Hl3
            ld   c,#FF
.Hl1
            ld   a,c
            pop  bc
            pop  de
            pop  hl
            ret


PrintSpecialChar   ; orig: SPECSYM
; Вывод спецсимволов (коды #20-#32)
; Вывод со спец символами
; a-КОД
; Спец символы с кода 20 по 32 включит.
            cp   #21
            jr   c,$+6
            RST___NOARG
            ret
            sub  30
            add  a,a
            add  a,a
            push hl
            push de
            ld   l,a
            ld   h,0
            ld   de,.SPECTB
            add  hl,de
            rept 3
            ld   a,(hl)
            inc  hl
            RST___NOARG
            endr
            ld   a,(hl)
            RST___NOARG
            pop  de
            pop  hl
            ret
.SPECTB
            db   "ENT "
            db   "SS  "
            db   "SP  "
