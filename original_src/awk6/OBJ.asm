■Mactiv     ■Mactive
■Delobj     ■Objtbuf
■Corr       ■Outlin
■Slin       ■Window
■WINDW      ■Swin
■Outwin     ■Obut
■Outbut     ■Sbut
■Button     ■BUTTN
■Outrm      ■Clrlin
■Clinwin    ■ERSOBJ
■ERSOBJ2    ■Movsiz
■ERASOBJ    ■LASTOBJ
■FOBJ       ■SETCRDS
■NEWOBJ     ■SETSCRD
■WINOBR3    ■WINOBR2
■WINOBR1    ■BUTOBR1
■BLACKW     ■BLACKWP
■WHITEW




Mactiv
ТО ЖЕ НО ЕЩЕ И ПРОВЕРКА НА ПРИСУТСТВИЕ
ОБЪЕКТА НА СТОЛЕ
            push de,hl
            EXD:ld a,12:call TOOBJ
            ld   e,(hl):inc hl:ld d,(hl)
            call FOBJ
            pop  hl,de:ret nz
Mactive
АКТИВИЗАЦИЯ ОБЪЕКТА ЕСЛИ ОН Н СТОЛЕ
ИЛИ ЕГО ВПИСЫВАНИЕ ЕСЛИ ЕГО НЕБЫЛО
■de-НОМЕР ОБЪЕКТА
■hl-АДРЕС ЕГО ШОУ ОБРАБОТЧИКА, ТОЛЬКО
ДЛЯ ТЕХ КОТОРЫХ НЕ БЫЛО Н СТОЛЕ
■retinhl- АДРЕС ЭТОГО ОБЪЕКТА
■retFZ-ЕСЛИ ОН УЖЕ НА СТОЛЕ И НА ВЕРХУ
            push de,bc,hl
            ld   hl,(Adnsur+1)
Mac2
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            dec  b
            jr   z,Mac1
            inc  b
            inc  hl,bc
            ld   a,(bc)
            cp   e
            jp   nz,Mac2
            inc  bc
            ld   a,(bc)
            cp   d
            jp   nz,Mac2
            dec  bc,bc

СТИРАЕМ И СДВИГАЕМ СТОЛ
            push hl,de,bc
            ld   d,h
            ld   e,l:DEC_DE 2
            ld   bc,OVLEN:ldir
            pop  bc,de,hl
            DEC_HL 2

            xor  a
            inc  hl
            ld   e,(hl)
            inc  hl
            inc  a:dec e
            jp   nz,$-5
            dec  a
            ld   (hl),1:inc hl:ld (hl),1
            DEC_HL 2
            ld   (hl),b
            dec  hl
            ld   (hl),c
            ld   h,b
            ld   l,c
            pop  bc,bc,de
            ret
Mac1
ВПИСЫВАНИЕ ЭТОГО ОБЪЕКТА,ЕГО НЕБЫЛО
            pop  bc
            ld   (hl),b
            dec  hl
            ld   (hl),c
            INC_HL 2
            ld   (hl),1
            inc  hl
            ld   (hl),1
            ld   h,b
            ld   l,c
            pop  bc,de
            xor  a:inc a
            ret








Delobj
УДАЛЕНИЕ ОБЪЕКТА ИЗ БУФ.СКРИНА
■de-NUMBER
            push hl
            ld   hl,Tabob
Dj2
            ld   a,(hl):inc l:cp e:jr z,Dj1
            inc  l:jp nz,Dj2
            pop  hl:ret
Dj1
            ld   a,(hl):cp d:jr z,Dj3
            inc  l:jp nz,Dj2
            pop  hl:ret
Dj3
            ld   (hl),#FF:pop hl:ret








Objtbuf
ОБЪЕКТ В БУФЕР СКРИН
БУФЕР НУЖЕН ДЛЯ ОПРЕДЕЛЕНИЯ ПОЛОЖЕНИЯ
КУРСОРА - НАД КАКИМ ОБЪЕКТОМ ОН
■bc-XY ZNAK,de-SX,SY ZNAK
■hl-NUMBER OF OBJ
            push de,bc,de
            EXD
            call Delobj
            ld   hl,Tabob-1;TABL OF OBRA
■BOTCHIKOW
■1-2- NUMBER OF OBJ.,if2=#FF THAT VOID
Oj4
            INC_HL 2
            ld   a,(hl)
            inc  a
            jp   nz,Oj4
            ld   (hl),d
            dec  hl
            ld   (hl),e
            ld   a,l
            rrca
            inc  a
            pop  de
            exa
            ld   a,c
            and  a
            jp   p,Jo1
            add  a,e
            ld   e,a
            ld   c,0
            jp   Jo2
Jo1
            add  a,e
            cp   #21
            jp   c,Jo2
            sub  #20
            neg
            add  a,e
            ld   e,a
Jo2
            ld   a,b
            and  a
            jp   p,Jo3
            add  a,d
            ld   d,a
            ld   b,0
            jp   Jo4
Jo3
            add  a,d
            cp   #19
            jp   c,Jo4
            sub  #18
            neg
            add  a,d
            ld   d,a
Jo4
            call Tident2;TAKE ADR IDENT
■UNDER CORDS inbc
            ld   b,d
            ld   a,32:sub e
            ld   e,a
            add  a,a
            ld   (JJ11+1),a
            inc  e:ld d,0
            exa

JJ11        jr   $+2
            rept 31:ld (hl),a:inc l:endr
            ld   (hl),a
            add  hl,de
            djnz JJ11
            pop  bc,de
            ret
Corr
КОРРЕКТИРОВКА КООРДИНАТ
■c-X,b-Y И ВЫСОТЫ dИ ШИРИНЫ e
■rethl-АДРЕС НА ЭКРАНЕ
■L'-РЕАЛЬНАЯ Y КООРДИНАТА В ЗНАКАХ
ДЛЯ ОБЪЕКТА
■FC'-ON ЕСЛИ ВЫЛЕТ СПРАВА
■FZ'-ON ЕСЛИ ВЫЛЕТ СЛЕВА
            ld   hl,#2C72;ld(hl),d:incl
            ld   (FLG1),hl
            ld   a,#71
            ld   (FLG2),a
            xor  a:inc a:exa
            ld   a,c
            and  a
            jp   p,Dw1
            ld   a,e
            add  a,c
            jp   p,$+10
            xor  a:ld (FLG1),a
            ld   (FLG1+1),a
            ld   e,a
            ld   c,0
            exa:xor a;ВЫЛЕТ СЛЕВА
            jr   Dw2-1
Dw1
            ld   a,c
            add  a,e
            cp   #1F
            jp   c,Dw2
            sub  #1F
            cpl
            add  a,e
            jp   p,$+7
            xor  a:ld (FLG2),a
            ld   e,a
            exa:scf;ВЫЛЕТ СПРАВА
            exa
Dw2
■makeY CORD inPIX
            ld   a,b
            bit  7,b
            jr   z,$+4
            ld   b,0
            exx:dec a:ld l,a:exx
            ld   l,b
            rlc  l
            rlc  l
            rlc  l
            ld   h,TBXX.h
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            rlc  l
            rlc  l
            rlc  l
            or   (hl)
            ld   l,a
            ld   h,b
            ret







Outlin
ВЫВОД ЛИНИИ
■hl-НОМЕР ОБЪЕКТА
            push hl
            xor  a:call TOOBJ
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            call Slin

            ld   a,c
            and  a
            jp   p,Oln4
            add  a,e
            ld   e,a
            ld   c,0
            jp   Oln2
Oln4
            add  a,e
            cp   #21
            jp   c,Oln2
            sub  #20
            neg
            add  a,e
            ld   e,a
Oln2
            ld   a,b
            and  a
            jp   p,Oln3
            add  a,d
            ld   d,a
            ld   b,0
            jp   Oln5
Oln3
            add  a,d
            cp   #19
            jp   c,Oln5
            sub  #18
            neg
            add  a,d
            ld   d,a
Oln5
            ex   (sp),hl
Objtl       call Objtbuf
            pop  hl
            jp   Clrlin

Outln2
            push hl
            xor  a:call TOOBJ
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            call Slin

            ld   a,c
            and  a
            jp   p,Ol4
            add  a,e
            ld   e,a
            ld   c,0
            jp   Ol2
Ol4
            add  a,e
            cp   #21
            jp   c,Ol2
            sub  #20
            neg
            add  a,e
            ld   e,a
Ol2
            ld   a,b
            and  a
            jp   p,Ol3
            add  a,d
            ld   d,a
            ld   b,0
            jp   Ol5
Ol3
            add  a,d
            cp   #19
            jp   c,Ol5
            sub  #18
            neg
            add  a,d
            ld   d,a
Ol5
            pop  hl
            jp   Clrlin








Slin
ЗАДАТЬ ДАННЫЕ ПЕЧАТИ В ЛИНИИ
ЛИНИЯ-ОКНО БЕЗ КАКИХ ЛИБО РАМОК
■bc-КООРД.
■de-РАЗМЕРЫ
            push hl
            ld   hl,0
            ld   (Cord),hl
            ld   a,c
            and  a
            jp   p,$+5
            neg
            rlca
            rlca
            rla
            bit  7,c
            jp   z,$+6
            neg
            dec  l
            ld   (Bxw+1),a
            ld   a,l
            ld   (Bxh+1),a
            ld   l,0
            ld   a,b
            and  a
            jp   p,$+5
            neg
            rlca
            rlca
            rla
            bit  7,b
            jp   z,$+6
            neg
            dec  l
            ld   (Byw+1),a
            ld   a,l
            ld   (Byh+1),a
            ld   a,e
            rlca
            rlca
            rla
            ld   (Exw+1),a
            ld   a,d
            rlca
            rlca
            rla
            ld   (Eyw+1),a
            pop  hl
            ret











■WINDOW
РИСОВАНИЕ ОКНА , С ПОДПРОГРАММАМИ
■B'B,C'c-BEGIN COORDS ZNAK
■d,e-ВЫСОТА,ДЛИНА ZNAK
■a-STATUS
Window
            push hl:exx
            push de,hl:exx
            halt
            call WINDW
            exx:pop hl,de
            exx:pop hl
            ret

WINDW
            rra
IW1013      ld   hl,L101
            jr   nc,$+5
            ld   hl,L1011
            ld   (Win3+1),hl

            dec  e,e,d,d,d
            call Corr
■retL'-РЕАЛЬНАЯ КООРДИНАТА Y ОБЪЕКТА

            ld   a,30:sub e:add a,a
            ld   (JJ_1+1),a
            ld   b,d

            call NXTM:ret nc
            jp   m,Win3
            call L000
            call LXXX
            call L111
            call LXXX
            call L101
            call LXXX
            xor  a

Win3        call L101
            jp   m,Win24

            rept 5:call LXXX:endr
            call NXTT

Win24
            call NXTM:ret nc
            jp   m,IW101
            rept 3:call LXXX:endr


IW1014      call L101
            call LXXX
IW0002      call L000
            call LXXX
            xor  a

IW101       call L101;ЛИБО L101 ЛИБО L1011
            jp   m,Win25

            rept 3:call LXXX:endr
            call NXTT
Win25

            ld   a,b:and a:jr z,Win23

Win2
            call NXTM:ret nc
            jp   m,Win26
            rept 8:call LXXX:endr
            call NXTT
Win26
            djnz Win2

Win23
            call NXTM:ret nc
            ret  m

IW000       call L000
            call LXXX

IW1012      call L101
            rept 4:call LXXX:endr

            call L101:call LXXX
            call L111:call LXXX
            call L000:call LXXX
            ret





NXTM
ВЫЛЕТ ЗА ЭКРАН СНИЗУ И СВЕРХУ
ЕСЛИ СНИЗУ ТО ПОЛНЫЙ ВЫХОД FC-OFF
ИНАЧЕ FC-ON
            exx:inc l:ld a,l:exx:scf:ret m
            cp   24:inc a:ret

ПЕРЕХОД НА СЛЕД. ЗНКОМЕСТ
NXTT
            ld   a,l:add a,32:ld l,a
            ld   a,0:ret c
            ld   a,h:sub 8:ld h,a:ret








РИСОВАНИЕ ЛИНИИ ОБЪЕКТА ПО ЗАДАННЫМ
ДАННЫМ
■hl-АДРЕС НА ЭКРАНЕ
■d,e,c-ДАННЫЕ ЗАПОЛНЕНИЯ КРАЕВ И ЦЕНТРА
LXXX
            ld   a,l
FLG1        ld   (hl),d:inc l
JJ_1        jr   $+2
            rept 30:ld (hl),e:inc l:endr
FLG2        ld   (hl),c
            ld   l,a
            inc  h
            ret








L101
            exa:ld e,0
            ld   d,%01000000
            jr   nz,$+3:ld d,e
            ld   c,%00000010
            jr   nc,$+3:ld c,e:exa:ret
L1011
            exa:ld e,#FF
            ld   d,%01011111
            jr   nz,$+3:ld d,e
            ld   c,%11111010
            jr   nc,$+3:ld c,e:exa:ret
L111
            exa:ld e,#FF
            ld   d,%01111110
            jr   nz,$+3:ld d,e
            ld   c,%01111110
            jr   nc,$+3:ld c,e:exa:ret
L000
            ld   de,0
            ld   c,e:ret
L1111
            exa:ld e,#FF
            ld   d,%00111111
            jr   nz,$+3:ld d,e
            ld   c,%11111100
            jr   nc,$+3:ld c,e:exa:ret
L1010
            exa:ld e,#FF
            ld   d,%00011111
            jr   nz,$+3:ld d,e
            ld   c,%11111000
            jr   nc,$+3:ld c,e:exa:ret
L1001
            exa:ld e,0
            ld   d,%00100000
            jr   nz,$+3:ld d,e
            ld   c,%00000100
            jr   nc,$+3:ld c,e:exa:ret
L11
            ld   de,#FFFF
            ld   c,e:ret
L01
            exa:ld e,0
            ld   d,%01000000
            jr   nz,$+3:ld d,e
            ld   c,%00000010
            jr   nc,$+3:ld c,e:exa:ret









Swin
ЗАДАТЬ ДАННЫЕ ПЕЧАТИ В ОКНЕ
■bc-КООРД.,de-РАЗМЕРЫ
■c-X,b-Y,d-SY,e-SX
            push hl
            ld   hl,1
            ld   (Cord),hl
            dec  l
            ld   a,c
            and  a
            jp   p,$+5
            neg
            rlca
            rlca
            rla
            bit  7,c
            jp   z,$+6
            neg
            dec  l
            add  a,3
            ld   (Bxw+1),a
            ld   a,l
            ld   (Bxh+1),a
            ld   l,0
            ld   a,b
            and  a
            jp   p,$+5
            neg
            rlca
            rlca
            rla
            bit  7,b
            jp   z,$+6
            neg
            dec  l
            add  a,3
            ld   (Byw+1),a
            ld   a,l
            ld   (Byh+1),a
            ld   a,e
            rlca
            rlca
            rla
            sub  4
            ld   (Exw+1),a
            ld   a,d
            rlca
            rlca
            rla
            sub  11
            ld   (Eyw+1),a
            pop  hl
            ret






Outwin
ВЫВОД ОКНА
■hl-НОМЕР ОБЪЕКТА
            exx
            push bc
            exx
            push hl,de,bc,hl
            xor  a:call TOOBJ
■hl-VECTOR OF OBJECT (COORD ,SIZE and.
■..)
■GET COORDS
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
■GET SIZE
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            call Swin
            ex   (sp),hl
■PUT OBJ TO BUFER SCREEN
Objtw       call Objtbuf
            ex   (sp),hl
            inc  hl
            ld   a,(hl)
            push af:call Window
            inc  hl:ld a,(hl)
            ld   hl,Wintxt
            call FLIST
            xor  a
            ld   (Mode+1),a
            call Outtxt
            pop  af
ПРОВЕРКА ЕСТЬ ЛИ У ОКНА СТРОКА НАЗВАНИЯ
            rra
            ld   a,0
            ld   l,a
            jr   nc,$+4
            add  a,8
            ld   h,a
            ld   (Cord),hl
            pop  hl,bc,de,hl
            exx
            pop  bc
            exx
            ret
Obut
            push hl
            ld   hl,Nth2
            ld   (Objtb+1),hl
            pop  hl
            call Outbut
            push hl
            ld   hl,Objtbuf
            ld   (Objtb+1),hl
            pop  hl
Nth2
            ret










Outbut
ВЫВОД КНОПКИ
■hl-НОМЕР ОБЪЕКТА
В ВЕКТОРЕ ОПИСАНО
■X,Y,SX,SY ZNAK,TXT,0
            push hl,de,bc,hl
            ld   a,1
            ld   (Mode+1),a
            xor  a:call TOOBJ
■GET COORDS
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
■GET SIZE
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            call Sbut
            ex   (sp),hl
Objtb       call Objtbuf
            ex   (sp),hl
            ld   a,(hl);STATUS :DOWN UP
            and  %00011111
            inc  hl
            call Button
            ld   a,(hl)
            ld   hl,Buttxt
            call FLIST

            ld   a,#C9
            ld   (FLAGOT),a

OB_2
            push hl
            ld   a,(hl):inc hl
            cp   ET:jpz OB_1
            cp   CR:jpnz $-9
            pop  de

            dec  hl:EXD
            ld   b,0:call Hltxt
            ld   c,a
            ld   a,(Exw+1):sub c
            jr   nc,$+3:xor a:srl a
            ld   (Cord),a
            call Outtxt:jr c,OB_3
            jp   OB_2
OB_1
            pop  hl
            xor  a:ld (Cord),a
            call OTXT
OB_3
            ld   a,#C3
            ld   (FLAGOT),a
            pop  hl,bc,de,hl
            ret










Sbut
ЗАДАТЬ ДАННЫЕ ПЕЧАТИ В КНОПКЕ
■bc-КООРД.,de-РАЗМЕРЫ
            push hl
            ld   hl,0
            ld   (Cord),hl
            ld   a,c
            and  a
            jp   p,$+5
            neg
            rlca
            rlca
            rla
            bit  5+2,c
            jp   z,$+6
            neg
            dec  l
            add  a,3
            ld   (Bxw+1),a
            ld   a,l
            ld   (Bxh+1),a
            ld   l,0
            ld   a,b
            and  a
            jp   p,$+5
            neg
            rlca
            rlca
            rla
            bit  7,b
            jp   z,$+6
            neg
            dec  l
            add  a,4
            ld   (Byw+1),a
            ld   a,l
            ld   (Byh+1),a
            ld   a,e
            rlca
            rlca
            rla
            sub  4
            ld   (Exw+1),a
            ld   a,d
            rlca
            rlca
            rla
            sub  11
            ld   (Eyw+1),a
            pop  hl
            ret








Button
РИСОВАНИЕ КНОПКИ
■bc-X,Y:de-SX,SY:a-STATUS
            push hl
            call BUTTN
            pop  hl
            ret

BUTTN
            rra
            jp   nc,Bt1

            dec  e,e,d:call Corr
            ld   a,30:sub e:add a,a
            ld   (JJ_1+1),a
            ld   b,d


НАЖАТА
            call NXTM:ret nc
            jp   m,But_1
            call L11:call LXXX
            call L11:call LXXX
            call L1010:call LXXX
            xor  a

But_1
            call L1001
            jp   m,But_11

            rept 5:call LXXX:endr
            call NXTT
But_11
            dec  b:jr z,Bt22

Bt21
            call NXTM:ret nc
            jp   m,But_2
            rept 8:call LXXX:endr
            call NXTT
But_2
            djnz Bt21

Bt22
            call NXTM:ret nc:ret m
            rept 5:call LXXX:endr

            call L1010:call LXXX
            call L11:call LXXX
            call L11:call LXXX
            ret
Bt1
ОТЖАТА
            dec  e,e,d:call Corr
            ld   a,30:sub e:add a,a
            ld   (JJ_1+1),a
            ld   b,d

            call NXTM:ret nc
            jp   m,But_3
            call L11:call LXXX
            call L1111:call LXXX
            xor  a

But_3
            call L01
            jp   m,But_31

            rept 6:call LXXX:endr
            call NXTT

But_31
            dec  b:jr z,Bt12

Bt11
            call NXTM:ret nc
            jp   m,But_4
            rept 8:call LXXX:endr
            call NXTT
But_4
            djnz Bt11

Bt12
            call NXTM:ret nc:ret m
            rept 6:call LXXX:endr

            call L1111:call LXXX
            call L11:call LXXX
            ret









Outrm
РИСОВАНИЕ РАМКИ ДЛЯ MOVE, SIZE
■bc-COORDS,de-SIZE
            push bc,de
            exx
            push de
            ld   de,0
            exx
            ld   a,c
            and  a
            jp   p,Orm1
            add  a,e
            ld   e,a
            exx
            ld   e,#FF
            exx
            ld   c,0
Orm1
            ld   a,b
            and  a
            jp   p,Orm2
            add  a,d
            ld   d,a
            exx
            ld   d,#FF
            exx
            ld   b,0
Orm2
            ld   a,c
            add  a,e
            cp   #21
            jp   c,Orm3
            sub  #20
            neg
            add  a,e
            ld   e,a
            exx
            ld   e,1
            exx
Orm3
            ld   a,b
            add  a,d
            cp   #19
            jp   c,Orm4
            sub  #18
            neg
            add  a,d
            ld   d,a
            exx
            ld   d,1
            exx
Orm4
            ld   l,b
            rlc  l
            rlc  l
            rlc  l
            ld   h,TBXX.h
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            rlc  l
            rlc  l
            rlc  l
            or   (hl)
            ld   l,a
            ld   h,b
            exx
            ld   a,d
            exx
            and  a
            call p,Horl
            exx
            ld   a,e
            exx
            and  a
            ld   a,%10000000
            ld   (Vrl+1),a
            call p,Verl
            ld   a,e
            dec  a
            add  a,l
            ld   l,a
            exx
            ld   a,e
            exx
            dec  a
            ld   a,%00000001
            ld   (Vrl+1),a
            call nz,Verl
            ld   a,e
            dec  a
            neg
            add  a,l
            ld   l,a
            ld   a,d
            dec  a
            and  7
            rrca
            rrca
            rrca
            add  a,l
            ld   l,a
            push af
            ld   a,d
            dec  a
            or   7
            ld   b,a
            pop  af
            ld   a,b
            adc  a,0
            or   7
            add  a,h
            ld   h,a
            exx
            ld   a,d
            exx
            dec  a
            call nz,Horl
            exx
            pop  de
            exx
            pop  de,bc
            ret
Horl
            push hl
            ld   a,32:sub e
            add  a,a
            add  a,a
            ld   (JJ21+1),a
JJ21        jr   $+2
            rept 31:ld a,(hl):cpl:ld (hl),a:inc l:endr
            ld   a,(hl):cpl:ld (hl),a
            pop  hl
            ret
Verl
            push hl
            ld   c,d
Vrl         ld   b,%10000000
            rept 8:ld a,b:LDX_HL_A:inc h:endr
            NEXTZNAK
            dec  c:jp nz,Vrl+2
            pop  hl
            ret






Clrlin
■CLEAR LINE ON SCREEN FOR TXT
■bc-Y inPIX
■de-SIZE X
            push hl,bc
            ld   l,b
            sla  l
            sla  l
            sla  l
            ld   h,TBXX.h
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            sla  l
            sla  l
            sla  l
            or   (hl)
            ld   l,a
            ld   h,b
            ld   a,32
            sub  e
            add  a,a
            ld   (CN_1+1),a
            ld   a,(INVERSE)
            rra
            ld   a,#FF:jr nc,$+3:inc a
            ld   (CN_1-1),a
Onl2
            ld   c,8
Onl1
            ld   b,l
            ld   a,0
CN_1        jr   $+2
            rept 32:ld (hl),a:inc l:endr
            ld   l,b
            inc  h
            dec  c
            jp   nz,Onl1
            NEXTZNAK
            dec  d
            jp   nz,Onl2
            pop  bc,hl
            ret



Clinwin
■CLEAN INSIDE WINDOW
■PARAMETRS : BXW,BXH,EXW,BYW,BYH,EYW
■a-КОЛИЧ СТРОК * 8
            push af
            ld   a,(Exw+1)
            ld   e,a
            ld   a,(Bxw+1)
            ld   c,a
            exx
            ld   a,(Bxh+1)
            ld   c,a
            exx
            and  a
            ld   a,c
            jp   p,Sct23
            add  a,e
            add  a,8
            ld   e,a
            ld   c,0
            jp   Sct24
Sct23
            dec  a
            add  a,e
            jp   nc,Sct24
            exx
            ld   c,1
            exx
            cpl
            add  a,e
            add  a,8
            ld   e,a
Sct24
            pop  af
            add  a,5
            ld   d,a

            ld   a,(Byw+1)
СМЕЩЕНИЕ ПО ВЕРТИКАЛИ, ЧТОБ НЕ СТИРАТЬ
ЧТО ТО СВЕРХУ
SCRLS       add  a,0
            ld   b,a
            ld   a,(Byh+1)
            and  a
            ld   a,b
            jp   p,Sct231
            add  a,d
            ret  z
            cp   192
            ret  nc
            bit  7,b
            jr   z,Sct241
            ld   b,0
            ld   d,a
            jp   Sct241
Sct231
            cp   192
            ret  nc
            add  a,d
            jr   c,Sct25
            cp   192
            jr   c,Sct241
Sct25
            sub  #BF
            neg
            add  a,d
            ld   d,a
Sct241
            ld   h,TBXX.h
            ld   l,b
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            or   (hl)
            ld   l,a
            ld   h,b
            ld   b,e
            srl  e
            srl  e
            srl  e
            ld   a,e
            sub  1
            ret  c
            ld   e,a
            ld   a,b
            and  %00000111
            jr   nz,Sct0
            ld   a,e
            sub  1
            ret  c
            ld   e,a
Sct0
            ld   a,30
            sub  e
            add  a,a
            ld   (JJ01+1),a
            ld   (JJ02+1),a
            ld   (JJ03+1),a
            ld   e,7
            ld   b,%00000111
            exx:inc c:exx
            jp   z,Sct08:ld b,%11100000
            exx:dec c,c:exx
            jp   z,Sct07
Sct09
            ld   c,l
            ld   a,(hl):and b:ld (hl),a:inc l
            xor  a
JJ01        jr   $+2
            rept 30:ld (hl),a:inc l:endr
            ld   a,(hl):and #07:ld (hl),a
            ld   l,c
            inc  h:ld a,h:and e
            jp   nz,$+13
            NEXTZNAK
            dec  d
            jp   nz,Sct09
            ret
Sct08
            ld   c,l
            xor  a
JJ02        jr   $+2
            rept 30:ld (hl),a:inc l:endr
            ld   a,(hl):and b:ld (hl),a
            ld   l,c
            inc  h:ld a,h:and e
            jp   nz,$+13
            NEXTZNAK
            dec  d
            jp   nz,Sct08
            ret
Sct07
            ld   c,l
            ld   a,(hl):and b:ld (hl),a:inc l
            xor  a
JJ03        jr   $+2
            rept 30:ld (hl),a:inc l:endr
            ld   l,c
            inc  h:ld a,h:and e
            jp   nz,$+13
            NEXTZNAK
            dec  d
            jp   nz,Sct07
            ret





ERSOBJ
ВЫЗОВ СТИРАНИЯ ОБЪЕКТА
■FZ-ON ОБЪЕКТ СТЕРТ
■FZ-OFF КУРСОР В ДР. ОБЛАСТИ
■de-НОМЕР
            ld   a,(Mcoord+1)
            srl  a
            srl  a
            srl  a
            ld   c,a:ld a,(Byw+1)
            srl  a
            srl  a
            srl  a
            cp   c
            ret  nz
ERSOBJ2
ЗАКРЫТИЕ ОБЪЕКТА
            call ERASOBJ
            ret  z
            xor  a:ld (FORRP+1),a:ret

Movsiz
■CHANGE SIZE andMOVE OBJECT
            push ix,af,hl,de,bc
            ld   a,1
            jr   z,$+3
            inc  a
            ld   (CCFR1+1),a
            ld   (CCFR2+1),a

            call Tident
            and  a
            jp   z,R_MS1
            dec  a
            rlca
            ld   l,a
            ld   h,Tabob.h
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  h
            jp   z,R_MS1;VOID FIELD
            dec  h
            xor  a:call TOOBJ
            push hl,bc
■GET CORDS
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
■GET SIZE
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   a,(hl)
            and  %11000000
            jr   nz,$+6
■ECЛИ ETO OKHO
            ld   a,3
            jr   Moz
            cp   %01000000
            jr   nz,$+6
ЕТО КНОПКА
            ld   a,2
            jr   Moz
ЕТО ЛИНИЯ
            ld   a,1
Moz
            ld   (Oz1+1),a
            ld   (Oz2-1),a
            ld   (Oz11+1),a
            ld   (Oz21-1),a
НАДО ОПРЕДЕЛИТЬ НИЖНИЙ ПРАВЫЙ КРАЙ, НА
ЭКРАНЕ ИЛИ НЕТ ОН
            ld   a,e
            add  a,c
            ld   l,a

            ld   a,b
            and  a
            jp   m,Gs2;ОБЪЕКТ СВЕРХУ ЗА ЭКРАНМ
            add  a,d
            ld   h,a

ПРОВЕРКА ЕСЛИ ОБЪЕКТ СПРАВА ЗА ЭКРАНОМ
И ЕСЛИ ВИДИМАЯ ЛЕВАЯ ЧАСТЬ СОСТАВЛЯЕТ
МЕНЕЕ 3 ЗНАКОМЕСТ В ДЛИННУ ТО ПЕРЕХОД
В ЛЮБОМ СЛУЧАЕ НА ПЕРЕТАСКИВНИЕ
            ld   a,l:cp #20:jr c,$+7
            ld   a,#1D:sub c:jr c,Gs2

ДЛЯ КНОПОК СПЕЦИАЛЬНО ДЕЛАЕМ ТАК ЧТО БЫ
РАЗМЕРЫ МОЖНО БЫЛО МЕНЯТЬ ЗА КРАЙ
            ld   a,(Oz1+1)
            cp   2
            ld   a,d
            jr   nz,$+4
            ld   a,1
            EXD
            ex   (sp),hl
В hlСЕЙЧАС КООРД. КУРСОРА
            inc  l
            inc  h
СМЕСТИИ ИХ К КРАЮ
            push hl
            dec  a
            jr   nz,$+7
ЕСЛИ У ОБЪ. ЕДЕНИЧНАЯ ВЫСОТА, ТО РАЗМЕР
МЕНЯТЬ ТОЛЬКО ЗА ПРАВЫЙ КРАЙ
            SUB_DE
            jr   $+4
            ld   a,h:sub d
            pop  hl
■CPABHИЛИ
            ex   (sp),hl
            EXD
            jp   z,Gs21;ПOПaЛИ ЗНАЧИТ SIZE

Gs9
■MOVING ТОЛЬКО ЗА ВЕРХНЮЮ ЛИНИЮ
            ex   (sp),hl
            ld   a,h
            sub  b
            dec  a
            ex   (sp),hl
            jr   z,Gs2
            pop  bc,hl:jp R_MS1
Gs21
            ld   hl,(Mcoord)
            ld   a,l
            or   h
            and  #F8
            jp   nz,Gss;НА СМЕНУ РАЗМЕРА
ТОЖЕ НА СДВИГ ПОТОМУ ЧТО ОКНО ЗАПЕРТО
В САМЫЙ ВЕРХ И ЛЕВО

Gs2
■MOVE
■cДbИГ PAMKИ
■bc-CORD,de-LEN HIGH bИДИmИЙ ЧACTИ БOKO
■bИh

            ld   a,(SPBYTE+1)
            and  4
            jp   nz,R_MS3;ЗАПРЕЩ.ДВИЖЕНИЕ

            call WOST

            ld   hl,(Mcoord)

            ld   a,b
            sla  a
            sla  a
            sla  a
            sub  h:neg:ld h,a
            ld   a,c
            sla  a
            sla  a
            sla  a
            sub  l:neg:ld l,a
            push hl

Gs29

            ld   (Oco+1),bc
            ld   (Osz+1),de

            call Outrm;outRAMKA
■FOR SEEK CMEЩEHИecДbИГa
            ld   hl,#5080+#1000
            ld   (Mcoord),hl
            push bc,de,hl
N_N1
            halt
            call Tfire
            and  a:jr z,N_N2
            call TESTMOV
            jr   z,N_N1
N_N2
            pop  de
            ld   hl,(Mcoord)
            srl  h
            srl  d
            srl  l
            srl  e
            ld   a,h
            sub  d
            ld   h,a
            ld   a,l
            sub  e
            ld   l,a
■CMEЩEHИЯ bhl
            pop  de,bc
            ld   a,c
            add  a,l
            ld   l,a
            jp   m,Oo11;HE ДOЛET cЛEBA
            cp   #20
            jp   c,Oo21
■bЫЛET cПPABA
            sub  #1F
            neg
            add  a,l
            ld   l,a
УMEHЬШИЛИ ШИpИhУ
            jp   Oo21
Oo11
            dec  a
            add  a,e
            jp   p,Oo21;BCE OK
■HEДOЛETEЛИ ПOШИpИHE
            neg
            add  a,l
            ld   l,a
Oo21
            ld   a,b
            add  a,h
            ld   h,a
            jp   m,Oo1
            cp   24
            jp   c,Oo2
■bЫЛET cПPABA
            sub  23
            neg
            add  a,h
            ld   h,a
            jp   Oo2
Oo1
            dec  a
            add  a,d
            jp   p,Oo2
■HEДOЛET cЛEBA
            neg
            add  a,h
            ld   h,a
Oo2
            ld   b,h
            ld   c,l
■bbc-HOBЫeKOOPД.

            halt
            push bc,de
Oco         ld   bc,0
Osz         ld   de,0
            call Outrm
■CTEPЛИ CTAPOE
            pop  de,bc

            call Tfire
CCFR1       cp   1
            jp   z,Gs29
Gs22
■ECЛИ KHOПKA OTЖATA
            pop  hl

            ex   (sp),hl
            pop  hl
            ex   (sp),hl
■3AПOMHИЛИ
            ld   (hl),c
            inc  hl
            ld   (hl),b
■CTABИmKУPCOP HA CEPEДИhУ OБЪEKTA
            pop  de

            ld   a,e
            srl  a
            srl  a
            srl  a
            add  a,c
            jp   p,$+4
            xor  a
            cp   #20
            jr   c,$+4
            ld   a,#1F
            rlca
            rlca
            rlca
            ld   l,a
            ld   a,e
            and  7
            or   l
            ld   l,a

            ld   a,d
            srl  a
            srl  a
            srl  a
            add  a,b
            jp   p,$+4
            xor  a
            cp   #18
            jr   c,$+4
            ld   a,#17
            rlca
            rlca
            rlca
            ld   h,a
            ld   a,d
            and  7
            or   h
            ld   h,a

            ld   (Mcoord),hl
R_MS
ВЫХОД С ФЛАГОМ ВЫХОДА
            xor  a:ld (FORRP+1),a
            pop  bc,de,hl,af,ix
            and  a:scf
            ret
R_MS2
            pop  bc,bc:jr R_MS
R_MS3
            pop  bc,bc
R_MS1
ВЫХОД БЕЗ ФЛАГА ВЫХОДА
            pop  bc,de,hl,af,ix
            and  a
            ret
Gss
■SIZE
SPBYTE      ld   a,0
            and  2
            jr   nz,R_MS3;ЗАПРЕЩ.ИЗМ.РАЗМЕРА

            call WOST

            ld   hl,(Mcoord)
            push hl
Gss29

            ld   (Oco+1),bc
            ld   (Osz+1),de
            call Outrm
            ld   hl,#5080+#1000
            ld   (Mcoord),hl
            push bc,de,hl
N_N4
            halt
            call Tfire
            and  a:jr z,N_N3
            call TESTMOV
            jr   z,N_N4
N_N3
            pop  de
            ld   hl,(Mcoord)
            srl  h
            srl  d
            srl  l
            srl  e
            ld   a,h
            sub  d
            ld   h,a
            ld   a,l
            sub  e
            ld   l,a
            pop  de,bc
            ld   a,e
            add  a,l
            jp   p,$+5
            ld   l,e
            ld   a,l
            ld   l,a
            cp   #21
            jp   c,Oz11
            sub  #20
            neg
            add  a,l
            ld   l,a
            jp   Oz21
Oz11
            cp   3
            jp   nc,Oz21
            ld   l,3
Oz21
            ld   a,c
            dec  a
            add  a,l
            jp   p,Oz29
            neg
            add  a,l
            ld   l,a
            jp   Oz31
Oz29
            cp   #20
            jp   c,Oz31
            sub  #1F
            neg
            add  a,l
            ld   l,a
Oz31
            ld   a,d
            add  a,h
            jp   p,$+5
            ld   h,d
            ld   a,h
            ld   h,a
            cp   25
            jp   c,Oz1
            sub  24
            neg
            add  a,h
            ld   h,a
            jp   Oz2
Oz1
            cp   3
            jp   nc,Oz2
            ld   h,3
Oz2
            ld   a,b
            dec  a
            add  a,h
            jp   p,Oz28
            neg
            add  a,h
            ld   h,a
            jp   Oz32
Oz28
            cp   24
            jp   c,Oz32
            sub  23
            neg
            add  a,h
            ld   h,a
Oz32
            EXD
            push bc,de
            ld   bc,(Oco+1)
            ld   de,(Osz+1)
            halt
            call Outrm
            pop  de,bc

            call Tfire
CCFR2       cp   1
            jp   z,Gss29
Gs23
            pop  hl

            ex   (sp),hl
            pop  hl
            ex   (sp),hl

            INC_HL 2
            ld   a,(hl)
            ld   (hl),e
            inc  hl
            ld   (hl),d

            pop  hl
            sub  e
            neg
            ld   e,a
            ld   a,l
            srl  a
            srl  a
            srl  a
            add  a,e
            jp   p,$+4
            xor  a
            sla  a
            sla  a
            sla  a
            ld   e,a
            ld   a,l:and 7:or e:ld l,a

            ld   a,b:add a,d:dec a
            rlca
            rlca
            rlca
            ld   b,a
            ld   a,h
            and  7
            or   b
            ld   h,a

            ld   (Mcoord),hl
            jp   R_MS


ERASOBJ
■de-NUM
■FZ ON ЕСЛИ ТАКОВО НА СТОЛЕ НЕТ
            push ix,hl,de,bc
            ld   ix,(Adnsur+1)
E_2
            ld   l,(ix+0)
            ld   a,(ix+1)
            dec  a:jr z,E_1:inc a:ld h,a
            inc  hl
            ld   a,(hl):inc hl:ld h,(hl)
            ld   l,a
            inc  ix,ix
            SUB_DE
            jr   nz,E_2
СОБСТВЕННО СТИРАНИЕ ИЗ СПИСКА ОБЪЕКТОВ
НА СТОЛЕ
            push ix:pop de
            ld   h,d
            ld   l,e
            DEC_DE 2
            ld   bc,OVLEN
            ldir:xor a:inc a
E_1
            pop  bc,de,hl,ix
            ret

LASTOBJ
ВЗЯТЬ ПОСЛЕДНИЙ ОБЪЕКТ НА СТОЛЕ
■rethl-ШОУ АДР. ЕГО
            ld   hl,(Adnsur+1)
N_F02
            inc  hl:ld a,(hl):inc hl
            dec  a:jp nz,N_F02
            DEC_HL 3
            ld   a,(hl):dec hl:ld l,(hl)
            ld   h,a
            ret


FOBJ
ПОИСК ОБЪЕКТА НА СТОЛЕ
■de-ШОУ АДРЕС ОБЪЕКТА
■FZ-OFF НЕ НАЙДЕН
            push hl
            ld   hl,(Adnsur+1)
N_F2
            inc  hl
            ld   a,(hl)
            dec  a
            jr   z,N_F1
            inc  a
            cp   d
            inc  hl
            jr   nz,N_F2
            DEC_HL 2
            ld   a,(hl)
            cp   e
            INC_HL 2
            jr   nz,N_F2
            ld   a,#FF
N_F1
            inc  a
            pop  hl:ret


SETCRDS
УСТАНОВКА СЕТАПНЫХ КООРИНАТ ВСЕМ ОБЪЕК
ТАМ
            ld   ix,Objvec
            ld   de,16
H_12
            ld   a,(ix+0)
            cp   #80:ret z
            ld   a,(ix+8)
            ld   (ix+0),a
            ld   a,(ix+9)
            ld   (ix+1),a
            ld   a,(ix+10)
            ld   (ix+2),a
            ld   a,(ix+11)
            ld   (ix+3),a
            add  ix,de
            jp   H_12



NEWOBJ
ДОПОЛНИТЕЛЬНЫЙ ОБРАБОТЧИК КНОПОК
■hl-ШОУ АДРЕС ОБЪЕКТА
АКТИВИЗИРУЕТ ИЛИ СОЗДАЕТ НА СТОЛЕ
НОВЫЙ ОБЪЕКТ ОПИСЫВАЕМЫЙ АДРЕСОМ
ПОД КОТОРЫМ КОНЕЧНО СРАЗУ ИДЕТ:
■ldhl,НОМЕР ЕГО
ТАК ЖЕ ИДЕТ ПРОВЕРКА НА ПРОДОЛЖИТЕЛЬНОЕ
НАЖАТИЕ ОГНЯ ИЛИ ОТМЕНЫ, ПОЭТОМУ ВЫХОД
■        lda,(KFC):anda:retm
            xor  a:ld (FORRP+1),a
            inc  hl:ld e,(hl):inc hl
            ld   d,(hl):DEC_HL 2
            call Mactive

SETSCRD
УСТАНОВКА СЕТАПНЫХ КООРДИНАТ
            push hl,bc,ix
            ld   h,d
            ld   l,e
            xor  a:call TOOBJ
            push hl:pop ix
            ld   a,(ix+8)
            ld   (ix+0),a
            ld   a,(ix+9)
            ld   (ix+1),a
            ld   a,(ix+10)
            ld   (ix+2),a
            ld   a,(ix+11)
            ld   (ix+3),a
            pop  ix,bc,hl:ret




WINOBR3
ДЛЯ ТЕХ КОТОРЫЕ ДОЛЖНЫ ВСЕГДА ЛОВИТЬ
■FIRE & CANCEL
            res  7,a
WINOBR2
ДЛЯ ТЕХ КОТОРЫЕ ДОЛЖНЫ СРАЗУ ЛОВИТЬ
■FIRE & CANCEL
            exa:ld a,#A7
            ld   (W_O9),a:exa
            jr   W_O10
WINOBR1
ПЕРВОЕ НАЖАТИЕ - АКТИВИРУЮЩЕЕ
ПЕРВЫЙ ОБРАБОТЧИК ОКОН, ИЗМ. РАЗ. ПЕРЕМ
ЕЩЕНИЕ.
■de-NUM,FC-ON MUST BE ret
            exa:ld a,#37
            ld   (W_O9),a:exa
W_O10
            bit  7,a:scf:ret nz

ЕСЛИ КНОПКА НАЖАТА ПЕРВЫЙ РАЗ,Т.Е.
ОНА НЕ УДЕРЖИВАЛАСЬ ДО ЭТОГО МОМЕНТА
ПРОРИСОВТЬ ОКНО
            or   a
            push ix,de,af
            call Unclick
            call Mactive
            jp   z,Owl11
            ld   de,O_Q1
            push de,hl
            jp   HIDESCR
O_Q1
            call RETSCR
            pop  af,de,ix
            call nz,Movsiz:ret c
W_O9        scf:ret
Owl11
            pop  af,de,ix
ЕСЛИ НАЖАТ ОГОНЬ ТО НА ПЕРЕМЕЩ/РАЗМЕР
            jp   nz,Movsiz
            ret







BUTOBR1
ОБРАБОТЧИК КНОПКИ ОДИН ДЛЯ ВСЕХ
■de-NUM,a-KOD KEY
■FC-ON ВЫХОД ДОЛЖЕН БЫТЬ БЕЗ ОБРАБОТЧИКА
            ld   (UPROC+1),hl
            bit  7,a
            jr   nz,B_B1
            or   a
            call z,Movsiz
            ret  c
            and  a
            jr   nz,B_B1
            xor  a:ld (FORRP+1),a
            push de
РАЗВОРАЧИВАНИЕ КНОПКИ ИЛИ СВОРАЧИВАНИЕ
ТОЛЬКО ЕСЛИ ОТМЕНОЙ НА НИЖНЮЮ ЧАСТЬ
КНОПКИ,НО НЕ НА КРАЙ
            push de:call Mactive:pop hl
            ADDHLHL 4
            EXD
            ld   ix,Objvec
            add  ix,de
            ld   a,(ix+2):cp #10:jr c,B_B2
B_B3
СВОРАЧИВАНИЕ
            ld   a,(ix+8)
            ld   (ix+0),a
            ld   a,(ix+9)
            ld   (ix+1),a
            ld   a,(ix+10)
            ld   (ix+2),a
            ld   a,(ix+11)
            ld   (ix+3),a
            pop  de
            scf:ret
B_B2
            ld   a,(ix+3):cp #08:jr nc,B_B3
РАЗВОРАЧИВАНИЕ
            ld   (ix+0),6
            ld   (ix+1),4
            ld   (ix+2),20
            ld   (ix+3),10
            pop  de:scf:ret

B_B1
            call Mactive
            call Chccl
            jr   nz,B_B4;ЕСЛИ КНОПКА НАЖАТА
            ld   hl,RET_
            ld   (UNPROC+1),hl
            call Unclick
РАЗРЕШИТЬ АНКЛИК
            ld   a,#FF
            ld   (Unclick+1),a
            ld   (Rghl+1),de
            halt
            call Click

B_B4
            ld   a,(KFC):rla
UPROC       ld   hl,0
            ld   (UNPROC+1),hl
            ret

BLACKW
ПОДГОТОВКА ВЫВОДА ОКОШЕК ЧЕРНЫМИ
            ld   de,L1011
            jr   BLACKWP+3
BLACKWP
            ld   de,L101
            ld   a,(INVERSE):rra:jr c,WHITEW
            ld   (IW1014+1),de
            ld   de,L1011
            ld   (IW000+1),de
            ld   (IW0002+1),de
            ld   (IW101+1),de
            ld   (IW1012+1),de
            ld   (IW1013+1),de
            ret
WHITEW
К ВЫВОДУ БЕЛЫХ ОКОШЕК
            ld   de,L101
            ld   (IW101+1),de
            ld   (IW1012+1),de
            ld   (IW1013+1),de
            ld   (IW1014+1),de
            ld   de,L000
            ld   (IW000+1),de
            ld   (IW0002+1),de
            ret

