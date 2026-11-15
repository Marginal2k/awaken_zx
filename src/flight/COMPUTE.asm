;INIMS            ■MNUMS
;MESAGS           ■PRINT
;PRINTNUM         ■SCROLL
;RST10            ■PRICEL
;TIMER            ■ZEROTIME
;ZEROUT           ■_SYSTEMREADY
;_SYSTEMOK        ■_MODEON
;_MODEOFF         ■_FREEFLY
;_GETTARGET       ■_FRONT
;_BACK            ■_LOSTTARGET
;_ALLTARGET       ■_HAVE
;_ROKET           ■_NOROKET
;_DESTROY         ■_GAMEOVER
;_NOTARGET        ■_POWERRAY
;_ROKETGO         ■_SYSTEMOFF
;_SYSTEMSOFF      ■_ANTIROKET
;_TARGETOFF       ■_TAKING
;_HIPER           ■_DOCKING
;_DROPCARGO       ■_DROPMINE
;_NOMINE          ■_NOCARGO


INIMS:
            ld   hl,0
            ld   (ADTT+1),hl
            ld   hl,TBUF-2
            ld   (ATBUF+1),hl
            inc  hl
            inc  hl
            ld   (FRBA+1),hl
            ld   ix,SCROLL+5-20
            ld   bc,20
            ld   hl,#5074
            ld   de,#5060
            ld   a,30
ZJ67:
            add  ix,bc
            ld   (ix+0),l
            ld   (ix+1),h
            ld   (ix+10),e
            ld   (ix+11),d
            ex   af,af'
            inc  h
            inc  d
            ld   a,h
            and  7
            cp   6
            jr   nz,ZJ70
            ld   a,l
            add  a,32
            ld   l,a
            ld   a,e
            add  a,32
            ld   e,a
            ld   h,#50
            ld   d,h
ZJ70:
            ex   af,af'
            dec  a
            jr   nz,ZJ67
            ret  
MNUMS:
;NUMBERS inORDER PRINT
;a-NUMBER
            ld   e,a
            ld   d,2
MESAGS:
;de-MESAG
            push hl
            push bc
            push af
FRBA:       ld   hl,TBUF
            ld   b,#10
ZJ66:
            ld   a,(hl)
            dec  a
            jr   z,ZJ64
            inc  a
            jr   z,ZJ65
            inc  hl
            inc  hl
            djnz ZJ66
ZJ69:
            pop  af
            pop  bc
            pop  hl
            ret  
ZJ65:
            ld   hl,TBUF
            djnz ZJ66
            jr   ZJ69
ZJ64:
            ld   (hl),d
            inc  hl
            ld   (hl),e
            inc  hl
            ld   (FRBA+1),hl
            jr   ZJ69

; ТАБЛИЦА АДРЕСОВ СООБЩЕНИЙ
; СТАРШ.БАЙТ,МЛАДШИЙ БАЙТ
; ЕСЛИ СТАР.=1 СВОБОДНОЕ ПОЛЕ
; ЕСЛИ =0 КОНЕЦ СПИСКА
; ЕСЛИ =2 ЗНАЧИТ ЧИСЛО 0-255
TBUF:       ds   #20,#0101
            dw   #0000

; ПЕЧАТЬ СООБЩЕНИЙ ИЗ БУФЕРА
PRINT:
;ED-END,CR-ПЕРЕВОД СТРОКИ
ADTT:       ld   hl,0
            ld   a,h
            or   l
            jr   nz,ZJ59
ATBUF:      ld   hl,0
            inc  hl
            inc  hl
ZJ68:
            ld   (ATBUF+1),hl
            ld   a,(hl)
            cp   2
            jr   c,ZJ60
            ld   (hl),1
            ld   d,a
            inc  hl
            ld   e,(hl)
            jr   nz,ZJ61
            ld   a,e
            call PRINTNUM
            ld   a,(CORD+1)
            inc  a
            ld   (CORD+1),a
            ret  
ZJ60:
            or   a
            ret  nz
            ld   hl,TBUF
            jp   ZJ68
ZJ61:
            EXD
ZJ59:
            ld   a,(hl)
            inc  hl
            ld   (ADTT+1),hl
            cp   ED
            jr   z,ZJ63
            cp   CR
            jr   z,ZJ58
            jp   RST10
ZJ63:
            ld   hl,0
            ld   (ADTT+1),hl
            ret  
ZJ58:
            xor  a
            ld   (CORD+1),a
            call SCROLL
            jp   ADTT


PRINTNUM:
;a-NUMBER
            cp   100
            jr   c,ZJ53
            ld   c,0
            ld   b,100
            sub  b
            inc  c
            sub  b
            jr   nc,$-2
            add  a,b
            ld   b,a
            ld   a,c
            add  a,"0"
            push bc
            call RST10
            pop  af
ZJ53:
            ld   b,a
            cp   10
            ld   c,0
            jr   c,ZJ54
            ld   b,10
            sub  b
            inc  c
            sub  b
            jp   nc,$-2
            add  a,b
            ld   b,a
ZJ54:
            ld   a,c
            add  a,"0"
            push bc
            call RST10
            pop  af
            add  a,"0"
            jp   RST10
SCROLL:
            ld   (STK5+1),sp

            rept 30
            ld   sp,#5134
            pop  hl
            pop  de
            pop  bc
            pop  af
            exx  
            pop  bc
            pop  de
            ld   sp,#5120
            push de
            push bc
            exx  
            push af
            push bc
            push de
            push hl
            endr

            ld   de,#0100
            ld   hl,0
            ld   sp,#5100
            push hl
            push hl
            push hl
            push hl
            push hl
            push hl
            ld   sp,#5200
            push de
            push hl
            push hl
            push hl
            push hl
            push hl
            ld   sp,#5300
            push hl
            push hl
            push hl
            push hl
            push hl
            push hl
            ld   sp,#5400
            push de
            push hl
            push hl
            push hl
            push hl
            push hl
            ld   sp,#5500
            push hl
            push hl
            push hl
            push hl
            push hl
            push hl
            ld   sp,#5600
            push de
            push hl
            push hl
            push hl
            push hl
            push hl
STK5:       ld   sp,0
            ret  

; ПЕЧАТЬ СИМВОЛА
RST10:
;a-CODE
            sub  32
            ld   l,a
            res  0,l
            ld   h,0
            ld   d,h
            ld   e,l
            add  hl,hl
            add  hl,de
            ld   bc,FONT
            add  hl,bc
            EXD
            ex   af,af'
CORD:       ld   c,0
            ld   a,c
            cp   #18
            jr   c,ZJ55
            push de
            call SCROLL
            pop  de
            ld   c,0                ;BEGIN X OF WIN FOR PR
ZJ55:
            ld   b,c
            ld   h,#50
            ld   a,#F4
            srl  b
            add  a,b
            ld   l,a
            inc  c
            ld   a,c
            ld   (CORD+1),a
ZJ56:
            bit  0,c
            ld   b,#F0
            jr   nz,$+4
            ld   b,#0F
            ex   af,af'
            rra  
            jr   nc,$+6
            ld   a,c
            xor  1
            ld   c,a
            bit  0,c
            ld   c,b
            jr   nz,ZJ57
            rept 5
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            rrca 
            rrca 
            rrca 
            rrca 
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            endr
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            rrca 
            rrca 
            rrca 
            rrca 
            and  c
            or   b
            ld   (hl),a
            ret  
ZJ57:
; ПЕЧАТЬ БЕЗ СДВИГА

            rept 5
            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            inc  h
            inc  de
            endr

            ld   a,c
            cpl  
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            ret  



PRICEL:
; РИСОВАНИЕ ПРИЦЕЛА В ДАННЫХ КООРДИНАТАХ
; ВЫВОД НА ТЕНЕВОЙНСКРИН
            ld   bc,(PCORD)         ;#2B77
            ld   h,b
            ld   a,c
            srl  h
            rra  
            srl  h
            rra  
            scf  
            rr   h
            rra  
            ld   l,a
            EXD
            ld   a,c
            and  7
            rla  
            rla  
            ld   l,a
            ld   h,0
            ld   bc,MPRICEL
            add  hl,bc
            EXD
            ld   bc,#0020
            inc  l
            rept 4
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            endr
            add  hl,bc
            dec  l
            inc  de
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            inc  l
            inc  de
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            inc  l
            inc  de
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            dec  de
            dec  de
            dec  de
            dec  l
            add  hl,bc
            rept 4
            add  hl,bc
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            endr
            ret  

MPRICEL:
; СПРАЙТ ПРИЦЕЛА
            db   %10000000
            db   %00011110,%00111100,%00000000
            db   %01000000
            db   %00001111,%00011110,%00000000
            db   %00100000
            db   %00000111,%10001111,%00000000
            db   %00010000
            db   %00000011,%11000111,%10000000
            db   %00001000
            db   %00000001,%11100011,%11000000
            db   %00000100
            db   %00000000,%11110001,%11100000
            db   %00000010
            db   %00000000,%01111000,%11110000
            db   %00000001
            db   %00000000,%00111100,%01111000




TIMER:
; ВЫВОД И ИЗМЕНЕНИЕ ВРЕМЕНИ НА ПРИБОРНУЮ
; ПАНЕЛЬ
            ld   a,%10000000
            rrca 
            ld   ($-2),a
            ret  nc

; СЧИТАЕМ ВРЕМЯ
            ld   bc,0
            ld   hl,(TIME+2)        ;#3418
            ld   a,l
            add  a,1
            daa  
            ld   l,a
            ld   a,h
            jr   nc,$+4
            set  0,b
            adc  a,c
            daa  
            ld   h,a
            ld   de,(TIME)          ;#0122
            ld   a,e
            jr   nc,$+4
            set  1,b
            adc  a,c
            daa  
            ld   e,a
            ld   a,d
            jr   nc,$+4
            set  2,b
            adc  a,c
            daa  
            ld   d,a
ZEROTIME:
            ld   (TIME+2),hl
            ld   (TIME),de
; ВЫВОД
ZEROUT:
            ld   a,l
            ld   c,#2F
            call PRNUM
            ld   a,l
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#2E
            call PRNUM
            bit  0,b
            ret  z
            ld   a,h
            ld   c,#2C
            call PRNUM
            ld   a,h
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#2B
            call PRNUM
            bit  1,b
            ret  z
            ld   a,e
            ld   c,#29
            call PRNUM
            ld   a,e
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#28
            call PRNUM
            bit  2,b
            ret  z
            ld   a,d
            ld   c,#27
            call PRNUM
            ld   a,d
            rrca 
            rrca 
            rrca 
            rrca 
            ld   c,#26
PRNUM:
; ПЕЧАТЬ ЧИСЛА В BCD ИЗ РЕГ. a
; П c-КООРДИНАТА X
            exx  
            and  #0F
            add  a,"0"-" "
            ld   l,a
            res  0,l
            ld   h,0
            ld   d,h
            ld   e,l
            add  hl,hl
            add  hl,de
            ld   de,FONT
            add  hl,de
            EXD
            ex   af,af'
            ld   h,#51
            exx  
            ld   a,c
            exx  
            ld   c,a
            srl  a
            ld   l,a
            inc  c
            call ZJ56
            exx  
            ret  


; СООБЩЕНИЯ БОРТОВОГО КОМПА



; Flight computer messages: GENERATED from assets/text/flight_messages.txt (tools/assets/gen_text.py), one include per message.
_SYSTEMREADY: include "gen/_SYSTEMREADY.inc"
_SYSTEMOK:    include "gen/_SYSTEMOK.inc"
_MODEON:      include "gen/_MODEON.inc"
_MODEOFF:     include "gen/_MODEOFF.inc"
_FREEFLY:     include "gen/_FREEFLY.inc"
_GETTARGET:   include "gen/_GETTARGET.inc"
_FRONT:       include "gen/_FRONT.inc"
_BACK:        include "gen/_BACK.inc"
_LOSTTARGET:  include "gen/_LOSTTARGET.inc"
_ALLTARGET:   include "gen/_ALLTARGET.inc"
_HAVE:        include "gen/_HAVE.inc"
_ROKET:       include "gen/_ROKET.inc"
_NOROKET:     include "gen/_NOROKET.inc"
_DESTROY:     include "gen/_DESTROY.inc"
_GAMEOVER:    include "gen/_GAMEOVER.inc"
_NOTARGET:    include "gen/_NOTARGET.inc"
_POWERRAY:    include "gen/_POWERRAY.inc"
_ROKETGO:     include "gen/_ROKETGO.inc"
_SYSTEMOFF:   include "gen/_SYSTEMOFF.inc"
_SYSTEMSOFF:  include "gen/_SYSTEMSOFF.inc"
_ANTIROKET:   include "gen/_ANTIROKET.inc"
_TARGETOFF:   include "gen/_TARGETOFF.inc"
_TAKING:      include "gen/_TAKING.inc"
_HIPER:       include "gen/_HIPER.inc"
_DOCKING:     include "gen/_DOCKING.inc"
_DROPCARGO:   include "gen/_DROPCARGO.inc"
_DROPMINE:    include "gen/_DROPMINE.inc"
_NOMINE:      include "gen/_NOMINE.inc"
_NOCARGO:     include "gen/_NOCARGO.inc"


