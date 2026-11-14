■INIMS            ■MNUMS
■MESAGS           ■PRINT
■PRINTNUM         ■SCROLL
■RST10            ■PRICEL
■TIMER            ■ZEROTIME
■ZEROUT           ■_SYSTEMREADY
■_SYSTEMOK        ■_MODEON
■_MODEOFF         ■_FREEFLY
■_GETTARGET       ■_FRONT
■_BACK            ■_LOSTTARGET
■_ALLTARGET       ■_HAVE
■_ROKET           ■_NOROKET
■_DESTROY         ■_GAMEOVER
■_NOTARGET        ■_POWERRAY
■_ROKETGO         ■_SYSTEMOFF
■_SYSTEMSOFF      ■_ANTIROKET
■_TARGETOFF       ■_TAKING
■_HIPER           ■_DOCKING
■_DROPCARGO       ■_DROPMINE
■_NOMINE          ■_NOCARGO


INIMS
            ld   hl,0
            ld   (ADTT+1),hl
            ld   hl,TBUF-2
            ld   (ATBUF+1),hl
            inc  hl,hl
            ld   (FRBA+1),hl
            ld   ix,SCROLL+5-20
            ld   bc,20
            ld   hl,#5074
            ld   de,#5060
            ld   a,30
$J67
            add  ix,bc
            ld   (ix+0),l
            ld   (ix+1),h
            ld   (ix+10),e
            ld   (ix+11),d
            exa
            inc  h,d
            ld   a,h
            and  7
            cp   6
            jrnz $J70
            ld   a,l
            add  a,32
            ld   l,a
            ld   a,e
            add  a,32
            ld   e,a
            ld   h,#50
            ld   d,h
$J70
            exa
            dec  a
            jrnz $J67
            ret
MNUMS
■NUMBERS inORDER PRINT
■a-NUMBER
            ld   e,a
            ld   d,2
MESAGS
■de-MESAG
            push hl,bc,af
FRBA        ld   hl,TBUF
            ld   b,#10
$J66
            ld   a,(hl)
            dec  a
            jrz  $J64
            inc  a
            jrz  $J65
            inc  hl,hl
            djnz $J66
$J69
            pop  af,bc,hl
            ret
$J65
            ld   hl,TBUF
            djnz $J66
            jr   $J69
$J64
            ld   (hl),d
            inc  hl
            ld   (hl),e
            inc  hl
            ld   (FRBA+1),hl
            jr   $J69

ТАБЛИЦА АДРЕСОВ СООБЩЕНИЙ
СТАРШ.БАЙТ,МЛАДШИЙ БАЙТ
ЕСЛИ СТАР.=1 СВОБОДНОЕ ПОЛЕ
ЕСЛИ =0 КОНЕЦ СПИСКА
ЕСЛИ =2 ЗНАЧИТ ЧИСЛО 0-255
TBUF        ds   #20,#0101
            dw   #0000

ПЕЧАТЬ СООБЩЕНИЙ ИЗ БУФЕРА
PRINT
■ED-END,CR-ПЕРЕВОД СТРОКИ
ADTT        ld   hl,0
            ld   a,h
            or   l
            jrnz $J59
ATBUF       ld   hl,0
            inc  hl,hl
$J68
            ld   (ATBUF+1),hl
            ld   a,(hl)
            cp   2
            jrc  $J60
            ld   (hl),1
            ld   d,a
            inc  hl
            ld   e,(hl)
            jrnz $J61
            ld   a,e
            call PRINTNUM
            ld   a,(CORD+1)
            inc  a
            ld   (CORD+1),a
            ret
$J60
            or   a
            retnz
            ld   hl,TBUF
            jp   $J68
$J61
            EXD
$J59
            ld   a,(hl)
            inc  hl
            ld   (ADTT+1),hl
            cp   ED
            jrz  $J63
            cp   CR
            jrz  $J58
            jp   RST10
$J63
            ld   hl,0
            ld   (ADTT+1),hl
            ret
$J58
            xor  a
            ld   (CORD+1),a
            call SCROLL
            jp   ADTT


PRINTNUM
■a-NUMBER
            cp   100
            jrc  $J53
            ld   c,0
            ld   b,100
            sub  b
            inc  c
            sub  b
            jrnc $-2
            add  a,b
            ld   b,a
            ld   a,c
            add  a,"0"
            push bc
            call RST10
            pop  af
$J53
            ld   b,a
            cp   10
            ld   c,0
            jrc  $J54
            ld   b,10
            sub  b
            inc  c
            sub  b
            jpnc $-2
            add  a,b
            ld   b,a
$J54
            ld   a,c
            add  a,"0"
            push bc
            call RST10
            pop  af
            add  a,"0"
            jp   RST10
SCROLL
            ld   (STK5+1),sp

            rept 30:ld sp,#5134:pop hl,de,bc,af:exx:pop bc,de:ld sp,#5120:push de,bc:exx:push af,bc,de,hl:endr

            ld   de,#0100
            ld   hl,0
            ld   sp,#5100
            push hl,hl,hl,hl,hl,hl
            ld   sp,#5200
            push de,hl,hl,hl,hl,hl
            ld   sp,#5300
            push hl,hl,hl,hl,hl,hl
            ld   sp,#5400
            push de,hl,hl,hl,hl,hl
            ld   sp,#5500
            push hl,hl,hl,hl,hl,hl
            ld   sp,#5600
            push de,hl,hl,hl,hl,hl
STK5        ld   sp,0
            ret

ПЕЧАТЬ СИМВОЛА
RST10
■a-CODE
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
            exa
CORD        ld   c,0
            ld   a,c
            cp   #18
            jrc  $J55
            push de
            call SCROLL
            pop  de
            ld   c,0;BEGIN X OF WIN FOR PR
$J55
            ld   b,c
            ld   h,#50
            ld   a,#F4
            srl  b
            add  a,b
            ld   l,a
            inc  c
            ld   a,c
            ld   (CORD+1),a
$J56
            bit  0,c
            ld   b,#F0
            jrnz $+4
            ld   b,#0F
            exa
            rra
            jrnc $+6
            ld   a,c
            xor  1
            ld   c,a
            bit  0,c
            ld   c,b
            jrnz $J57
            rept 5:ld a,c:cpl:and (hl):ld b,a:ld a,(de):rrca:rrca:rrca:rrca:and c:or b:ld (hl),a:inc h,de:endr
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
$J57
ПЕЧАТЬ БЕЗ СДВИГА

            rept 5:ld a,c:cpl:and (hl):ld b,a:ld a,(de):and c:or b:ld (hl),a:inc h,de:endr

            ld   a,c
            cpl
            and  (hl)
            ld   b,a
            ld   a,(de)
            and  c
            or   b
            ld   (hl),a
            ret



PRICEL
РИСОВАНИЕ ПРИЦЕЛА В ДАННЫХ КООРДИНАТАХ
ВЫВОД НА ТЕНЕВОЙНСКРИН
            ld   bc,(PCORD);#2B77
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
            rept 4:ld a,(de):xor (hl):ld (hl),a:add hl,bc:endr
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
            rept 4:add hl,bc:ld a,(de):xor (hl):ld (hl),a:endr
            ret

MPRICEL
СПРАЙТ ПРИЦЕЛА
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




TIMER
ВЫВОД И ИЗМЕНЕНИЕ ВРЕМЕНИ НА ПРИБОРНУЮ
ПАНЕЛЬ
            ld   a,%10000000
            rrca
            ld   ($-2),a
            retnc

СЧИТАЕМ ВРЕМЯ
            ld   bc,0
            ld   hl,(TIME+2);#3418
            ld   a,l
            add  a,1
            daa
            ld   l,a
            ld   a,h
            jrnc $+4
            set  0,b
            adc  a,c
            daa
            ld   h,a
            ld   de,(TIME);#0122
            ld   a,e
            jrnc $+4
            set  1,b
            adc  a,c
            daa
            ld   e,a
            ld   a,d
            jrnc $+4
            set  2,b
            adc  a,c
            daa
            ld   d,a
ZEROTIME
            ld   (TIME+2),hl
            ld   (TIME),de
ВЫВОД
ZEROUT
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
            retz
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
            retz
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
            retz
            ld   a,d
            ld   c,#27
            call PRNUM
            ld   a,d
            rrca
            rrca
            rrca
            rrca
            ld   c,#26
PRNUM
ПЕЧАТЬ ЧИСЛА В BCD ИЗ РЕГ. a
П c-КООРДИНАТА X
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
            exa
            ld   h,#51
            exx
            ld   a,c
            exx
            ld   c,a
            srl  a
            ld   l,a
            inc  c
            call $J56
            exx
            ret


СООБЩЕНИЯ БОРТОВОГО КОМПА



_SYSTEMREADY
            db   "Все системы готовы.",CR,ED

_SYSTEMOK
            db   "Все системы работают",CR
            db   "нормально.",CR,ED

_MODEON
            db   "Включен режим",CR,ED

_MODEOFF
            db   "Выключен режим",CR,ED

_FREEFLY
            db   "свободного полета.",CR,ED

_GETTARGET
            db   "наведения на цель.",CR,ED

_FRONT
            db   "переднего вида.",CR,ED

_BACK
            db   "заднего вида.",CR,ED

_LOSTTARGET
            db   "Цель потеряна.",CR,ED

_ALLTARGET
            db   "Все цели захвачены.",CR,ED

_HAVE
            db   "Осталось ",ED

_ROKET
            db   " ракет.",CR,ED

_NOROKET
            db   "Ракеты исчерпаны.",CR,ED

_DESTROY
            db   "Цель уничтожена.",CR,ED

_GAMEOVER
            db   "Корабль уничтожен.",CR
            db   "Конец игры.",CR,ED

_NOTARGET
            db   "Цель не захвачена.",CR,ED

_POWERRAY
            db   "силового луча.",CR,ED

_ROKETGO
            db   "Ракета ушла.",CR,ED

_SYSTEMOFF
            db   "Выведена из строя",CR
            db   "система",CR,ED

_SYSTEMSOFF
            db   "Выведены из строя",CR
            db   "системы",CR,ED

_ANTIROKET
            db   "Противоракетная система",CR
            db   "активирована.",CR,ED

_TARGETOFF
            db   "Наведенные цели забыты.",CR,ED

_TAKING
            db   "Объект подобран.",CR,ED

_HIPER
            db   "Разогрев реактора.",CR
            db   "Подготовка к совершению",CR
            db   "гипер прыжка.",CR,ED

_DOCKING
            db   "Корабль в зоне стыковки",CR
            db   "со станцией.",CR
            db   "Уменьшить скорость.",CR,ED


_DROPCARGO
            db   "Груз сброшен.",CR,ED

_DROPMINE
            db   "Мина сброшена.",CR,ED

_NOMINE
            db   "Нет мин.",CR,ED

_NOCARGO
            db   "Нет груза.",CR,ED


