;==============================================================================
; HELP - меню и тексты справки (оверлей HELP.C)
;
; Где живёт: HELP.C, ORG #DB00, страница PGHLP (#17); MAKE_3 в station.asm.
;
; Что делает: HelpDrawList выводит список из HKOL пунктов (THLPL, меню из 8 глав), HelpDrawItem - текст
; главы (THELP = gen/help.tok), HelpSetIndex задаёт текущий пункт. Вызывается из OBR.asm (WHELP, WHELPL).
; Тексты генерируются из assets/text/help.txt. См. GAME_DESIGN 1.3.
;==============================================================================

HelpDrawList   ; orig: DHLP2_
; Вывод списка пунктов справки

HelpIndex   ; orig: HLPIND
; Индекс первого видимого пункта справки
            ld   a,0
            ld   hl,THELP
            call FindTextByIndex
            ld   de,0
            xor  a
            ld   (Cord),a
            ld   ix,LINES
.D_H1
            ld   (ix+0),l
            ld   (ix+1),h
            inc  ix
            inc  ix
            ld   a,#08
            ld   (Cord+1),a
            push de
            call VirtualPrint
            pop  de
            inc  de
            jp   nc,.D_H1
            push de
            push ix
            ld   hl,1024
            SUB_DE
            add  hl,hl
            ld   b,h
            ld   c,l
            pop  hl
            ld   d,h
            ld   e,l
            ld   (hl),0
            inc  de
            dec  bc
            ldir
            pop  de
            ret


HelpDrawItem   ; orig: DHLP3_
; Вывод описания пункта справки
            ld   bc,#0800
            ld   (Cord),bc
            add  hl,hl
            ld   de,LINES
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            or   h
            ret  z
            jp   PrintText


HelpSetIndex   ; orig: SETHIND
; Задать индекс пункта справки
            ld   (HelpIndex+1),a
            ret


HelpDrawLine   ; orig: DHLPL1
; Вывод строки справки

; hl-индекс вывода
            EXD

;  Корд.Y на самую первую строку
            ld   hl,#0800
            ld   (Cord),hl

            ld   hl,THLPL
            ld   a,e
            call PrintTextByIndex1
            ld   a,(Cord+1)
            sub  8
            srl  a
            srl  a
            srl  a
            inc  a
            ex   af,af'
            ld   a,8
            ld   (Cord+1),a
            ret

LINES
            ds   2048


THLPL:      include "gen/THLPL.inc"   ; GENERATED from assets/text/help.txt

THELP
;  Описание каждого пункта по порадку
            db   ET
            incbin "gen/help.tok"   ; GENERATED from assets/text/help.txt
