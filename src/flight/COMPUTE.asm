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



_SYSTEMREADY:
            db   130,225,165," ",225,168,225,226,165,172,235," ",163,174,226,174,162,235,".",CR,ED

_SYSTEMOK:
            db   130,225,165," ",225,168,225,226,165,172,235," ",224,160,161,174,226,160,238,226,CR
            db   173,174,224,172,160,171,236,173,174,".",CR,ED

_MODEON:
            db   130,170,171,238,231,165,173," ",224,165,166,168,172,CR,ED

_MODEOFF:
            db   130,235,170,171,238,231,165,173," ",224,165,166,168,172,CR,ED

_FREEFLY:
            db   225,162,174,161,174,164,173,174,163,174," ",175,174,171,165,226,160,".",CR,ED

_GETTARGET:
            db   173,160,162,165,164,165,173,168,239," ",173,160," ",230,165,171,236,".",CR,ED

_FRONT:
            db   175,165,224,165,164,173,165,163,174," ",162,168,164,160,".",CR,ED

_BACK:
            db   167,160,164,173,165,163,174," ",162,168,164,160,".",CR,ED

_LOSTTARGET:
            db   150,165,171,236," ",175,174,226,165,224,239,173,160,".",CR,ED

_ALLTARGET:
            db   130,225,165," ",230,165,171,168," ",167,160,229,162,160,231,165,173,235,".",CR,ED

_HAVE:
            db   142,225,226,160,171,174,225,236," ",ED

_ROKET:
            db   " ",224,160,170,165,226,".",CR,ED

_NOROKET:
            db   144,160,170,165,226,235," ",168,225,231,165,224,175,160,173,235,".",CR,ED

_DESTROY:
            db   150,165,171,236," ",227,173,168,231,226,174,166,165,173,160,".",CR,ED

_GAMEOVER:
            db   138,174,224,160,161,171,236," ",227,173,168,231,226,174,166,165,173,".",CR
            db   138,174,173,165,230," ",168,163,224,235,".",CR,ED

_NOTARGET:
            db   150,165,171,236," ",173,165," ",167,160,229,162,160,231,165,173,160,".",CR,ED

_POWERRAY:
            db   225,168,171,174,162,174,163,174," ",171,227,231,160,".",CR,ED

_ROKETGO:
            db   144,160,170,165,226,160," ",227,232,171,160,".",CR,ED

_SYSTEMOFF:
            db   130,235,162,165,164,165,173,160," ",168,167," ",225,226,224,174,239,CR
            db   225,168,225,226,165,172,160,CR,ED

_SYSTEMSOFF:
            db   130,235,162,165,164,165,173,235," ",168,167," ",225,226,224,174,239,CR
            db   225,168,225,226,165,172,235,CR,ED

_ANTIROKET:
            db   143,224,174,226,168,162,174,224,160,170,165,226,173,160,239," ",225,168,225,226,165,172,160,CR
            db   160,170,226,168,162,168,224,174,162,160,173,160,".",CR,ED

_TARGETOFF:
            db   141,160,162,165,164,165,173,173,235,165," ",230,165,171,168," ",167,160,161,235,226,235,".",CR,ED

_TAKING:
            db   142,161,234,165,170,226," ",175,174,164,174,161,224,160,173,".",CR,ED

_HIPER:
            db   144,160,167,174,163,224,165,162," ",224,165,160,170,226,174,224,160,".",CR
            db   143,174,164,163,174,226,174,162,170,160," ",170," ",225,174,162,165,224,232,165,173,168,238,CR
            db   163,168,175,165,224," ",175,224,235,166,170,160,".",CR,ED

_DOCKING:
            db   138,174,224,160,161,171,236," ",162," ",167,174,173,165," ",225,226,235,170,174,162,170,168,CR
            db   225,174," ",225,226,160,173,230,168,165,169,".",CR
            db   147,172,165,173,236,232,168,226,236," ",225,170,174,224,174,225,226,236,".",CR,ED


_DROPCARGO:
            db   131,224,227,167," ",225,161,224,174,232,165,173,".",CR,ED

_DROPMINE:
            db   140,168,173,160," ",225,161,224,174,232,165,173,160,".",CR,ED

_NOMINE:
            db   141,165,226," ",172,168,173,".",CR,ED

_NOCARGO:
            db   141,165,226," ",163,224,227,167,160,".",CR,ED


