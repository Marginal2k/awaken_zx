;==============================================================================
; OBJ - оконная система: объекты, окна, кнопки, линии, перемещение и размер
;
; Где живёт: основной образ STATIONF.C, после PNT и до DATAT/OBJECT.
;
; Объекты - 16-байтные записи из OBJECT.asm (тип: окно/кнопка/линия, статус, обработчик, процедура
; вывода). Здесь: ActivateObject/DeleteObject/ObjectToBuf (стол и буфер экрана), OutWindow/OutButton/
; OutLine (отрисовка), SetWindowPrint/SetLinePrint/SetButtonPrint (область печати), OutFrame и MoveSizeObject
; (перемещение и изменение размера рамкой), EraseObject/CloseObject, FindDeskObject/LastDeskObject,
; OpenObject (активирует или создаёт объект), WindowHandler1..3 и ButtonHandler (общие обработчики
; нажатий), SetBlackWindow/SetWhiteWindow (цвет окон). LXXX и L101..L01 - развёрнутые заполнители краёв.
; См. GAME_DESIGN 1.3, 8.3.
;==============================================================================

ActivateIfOnDesk   ; orig: Mactiv
; Активизация с проверкой присутствия на столе
; То же но еще и проверка на присутствие
; Объекта на столе
            push de
            push hl
            EXD
            ld   a,12
            call ObjFieldAddr
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            call FindDeskObject
            pop  hl
            pop  de
            ret  nz

ActivateObject   ; orig: Mactive
; Активизировать объект на столе или вписать новый
; Активизация объекта если он н столе
; Или его вписывание если его небыло
; de-номер объекта
; hl-адрес его шоу обработчика, только
; Для тех которых не было н столе
; retinhl- АДРЕС ЭТОГО ОБЪЕКТА
; Retfz-если он уже на столе и на верху
            push de
            push bc
            push hl
            ld   hl,(SurroundPtr+1)
.Mac2
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            dec  b
            jr   z,.Mac1
            inc  b
            inc  hl
            inc  bc
            ld   a,(bc)
            cp   e
            jp   nz,.Mac2
            inc  bc
            ld   a,(bc)
            cp   d
            jp   nz,.Mac2
            dec  bc
            dec  bc

; Стираем и сдвигаем стол
            push hl
            push de
            push bc
            ld   d,h
            ld   e,l
            DEC_DE 2
            ld   bc,OVLEN
            ldir
            pop  bc
            pop  de
            pop  hl
            DEC_HL 2

            xor  a
            inc  hl
            ld   e,(hl)
            inc  hl
            inc  a
            dec  e
            jp   nz,$-5
            dec  a
            ld   (hl),1
            inc  hl
            ld   (hl),1
            DEC_HL 2
            ld   (hl),b
            dec  hl
            ld   (hl),c
            ld   h,b
            ld   l,c
            pop  bc
            pop  bc
            pop  de
            ret
.Mac1
; Вписывание этого объекта,его небыло
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
            pop  bc
            pop  de
            xor  a
            inc  a
            ret


DeleteObject   ; orig: Delobj
; Удалить объект из буфера экрана
; Удаление объекта из буф.скрина
; de-number
            push hl
            ld   hl,Tabob
.Dj2
            ld   a,(hl)
            inc  l
            cp   e
            jr   z,.Dj1
            inc  l
            jp   nz,.Dj2
            pop  hl
            ret
.Dj1
            ld   a,(hl)
            cp   d
            jr   z,.Dj3
            inc  l
            jp   nz,.Dj2
            pop  hl
            ret
.Dj3
            ld   (hl),#FF
            pop  hl
            ret


ObjectToBuf   ; orig: Objtbuf
; Записать объект в буфер экрана
; Объект в буфер скрин
; Буфер нужен для определения положения
; Курсора - над каким объектом он
; bc-xy znak,de-sx,sy znak
; hl-number of obj
            push de
            push bc
            push de
            EXD
            call DeleteObject
            ld   hl,Tabob-1         ; Tabl of obra
; Botchikow
; 1-2- Number of obj.,if2=#ff that void
.Oj4
            INC_HL 2
            ld   a,(hl)
            inc  a
            jp   nz,.Oj4
            ld   (hl),d
            dec  hl
            ld   (hl),e
            ld   a,l
            rrca
            inc  a
            pop  de
            ex   af,af'
            ld   a,c
            and  a
            jp   p,.Jo1
            add  a,e
            ld   e,a
            ld   c,0
            jp   .Jo2
.Jo1
            add  a,e
            cp   #21
            jp   c,.Jo2
            sub  #20
            neg
            add  a,e
            ld   e,a
.Jo2
            ld   a,b
            and  a
            jp   p,.Jo3
            add  a,d
            ld   d,a
            ld   b,0
            jp   .Jo4
.Jo3
            add  a,d
            cp   #19
            jp   c,.Jo4
            sub  #18
            neg
            add  a,d
            ld   d,a
.Jo4
            call TakeIdentXY            ; Take adr ident
; UNDER CORDS inbc
            ld   b,d
            ld   a,32
            sub  e
            ld   e,a
            add  a,a
            ld   (.JJ11+1),a
            inc  e
            ld   d,0
            ex   af,af'

.JJ11
            jr   $+2
            rept 31
            ld   (hl),a
            inc  l
            endr
            ld   (hl),a
            add  hl,de
            djnz .JJ11
            pop  bc
            pop  de
            ret

CorrectCoords   ; orig: Corr
; Коррекция координат объекта
; Корректировка координат
; c-X,b-Y и высоты dи ширины e
; rethl-АДРЕС НА ЭКРАНЕ
; L'-реальная Y координата в знаках
; Для объекта
; Fc'-on если вылет справа
; FZ'-on если вылет слева
            ld   hl,#2C72           ; ld(hl),d:incl
            ld   (FLG1),hl
            ld   a,#71
            ld   (FLG2),a
            xor  a
            inc  a
            ex   af,af'
            ld   a,c
            and  a
            jp   p,.Dw1
            ld   a,e
            add  a,c
            jp   p,$+10
            xor  a
            ld   (FLG1),a
            ld   (FLG1+1),a
            ld   e,a
            ld   c,0
            ex   af,af'
            xor  a                  ; Вылет слева
            jr   .Dw2-1
.Dw1
            ld   a,c
            add  a,e
            cp   #1F
            jp   c,.Dw2
            sub  #1F
            cpl
            add  a,e
            jp   p,$+7
            xor  a
            ld   (FLG2),a
            ld   e,a
            ex   af,af'
            scf                     ; Вылет справа
            ex   af,af'
.Dw2
; makeY CORD inPIX
            ld   a,b
            bit  7,b
            jr   z,$+4
            ld   b,0
            exx
            dec  a
            ld   l,a
            exx
            ld   l,b
            rlc  l
            rlc  l
            rlc  l
            ld   h,high(TBXX)
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


OutLine   ; orig: Outlin
; Вывод линии
; hl-номер объекта
            push hl
            xor  a
            call ObjFieldAddr
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            call SetLinePrint

            ld   a,c
            and  a
            jp   p,.Oln4
            add  a,e
            ld   e,a
            ld   c,0
            jp   .Oln2
.Oln4
            add  a,e
            cp   #21
            jp   c,.Oln2
            sub  #20
            neg
            add  a,e
            ld   e,a
.Oln2
            ld   a,b
            and  a
            jp   p,.Oln3
            add  a,d
            ld   d,a
            ld   b,0
            jp   .Oln5
.Oln3
            add  a,d
            cp   #19
            jp   c,.Oln5
            sub  #18
            neg
            add  a,d
            ld   d,a
.Oln5
            ex   (sp),hl
.Objtl
            call ObjectToBuf
            pop  hl
            jp   ClearLine

Outln2
            push hl
            xor  a
            call ObjFieldAddr
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            call SetLinePrint

            ld   a,c
            and  a
            jp   p,.Ol4
            add  a,e
            ld   e,a
            ld   c,0
            jp   .Ol2
.Ol4
            add  a,e
            cp   #21
            jp   c,.Ol2
            sub  #20
            neg
            add  a,e
            ld   e,a
.Ol2
            ld   a,b
            and  a
            jp   p,.Ol3
            add  a,d
            ld   d,a
            ld   b,0
            jp   .Ol5
.Ol3
            add  a,d
            cp   #19
            jp   c,.Ol5
            sub  #18
            neg
            add  a,d
            ld   d,a
.Ol5
            pop  hl
            jp   ClearLine


SetLinePrint   ; orig: Slin
; Задать данные печати в линии
; Линия-окно без каких либо рамок
; bc-коорд.
; de-размеры
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
            ld   (WinBeginX+1),a
            ld   a,l
            ld   (WinBeginXHi+1),a
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
            ld   (WinBeginY+1),a
            ld   a,l
            ld   (WinBeginYHi+1),a
            ld   a,e
            rlca
            rlca
            rla
            ld   (WinEndX+1),a
            ld   a,d
            rlca
            rlca
            rla
            ld   (WinEndY+1),a
            pop  hl
            ret


; Window
; Рисование окна , с подпрограммами
; B'B,C'c-begin coords znak
; d,e-высота,длина znak
; a-status
Window
            push hl
            exx
            push de
            push hl
            exx
            halt
            call .WINDW
            exx
            pop  hl
            pop  de
            exx
            pop  hl
            ret

.WINDW
            rra
IW1013
            ld   hl,L101
            jr   nc,$+5
            ld   hl,L1011
            ld   (.Win3+1),hl

            dec  e
            dec  e
            dec  d
            dec  d
            dec  d
            call CorrectCoords
; Retl'-реальная координата Y объекта

            ld   a,30
            sub  e
            add  a,a
            ld   (JJ_1+1),a
            ld   b,d

            call NXTM
            ret  nc
            jp   m,.Win3
            call L000
            call LXXX
            call L111
            call LXXX
            call L101
            call LXXX
            xor  a

.Win3
            call L101
            jp   m,.Win24

            rept 5
            call LXXX
            endr
            call NXTT

.Win24
            call NXTM
            ret  nc
            jp   m,IW101
            rept 3
            call LXXX
            endr


IW1014
            call L101
            call LXXX
IW0002
            call L000
            call LXXX
            xor  a

IW101
            call L101               ; Либо L101 либо L1011
            jp   m,.Win25

            rept 3
            call LXXX
            endr
            call NXTT
.Win25

            ld   a,b
            and  a
            jr   z,.Win23

.Win2
            call NXTM
            ret  nc
            jp   m,.Win26
            rept 8
            call LXXX
            endr
            call NXTT
.Win26
            djnz .Win2

.Win23
            call NXTM
            ret  nc
            ret  m

IW000
            call L000
            call LXXX

IW1012
            call L101
            rept 4
            call LXXX
            endr

            call L101
            call LXXX
            call L111
            call LXXX
            call L000
            call LXXX
            ret


NXTM
; Вылет за экран снизу и сверху
; Если снизу то полный выход fc-off
; Иначе fc-on
            exx
            inc  l
            ld   a,l
            exx
            scf
            ret  m
            cp   24
            inc  a
            ret

; Переход на след. знкомест
NXTT
            ld   a,l
            add  a,32
            ld   l,a
            ld   a,0
            ret  c
            ld   a,h
            sub  8
            ld   h,a
            ret


; Рисование линии объекта по заданным
; Данным
; hl-адрес на экране
; d,e,c-данные заполнения краев и центра
LXXX
            ld   a,l
FLG1
            ld   (hl),d
            inc  l
JJ_1
            jr   $+2
            rept 30
            ld   (hl),e
            inc  l
            endr
FLG2
            ld   (hl),c
            ld   l,a
            inc  h
            ret


L101
            ex   af,af'
            ld   e,0
            ld   d,%01000000
            jr   nz,$+3
            ld   d,e
            ld   c,%00000010
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret
L1011
            ex   af,af'
            ld   e,#FF
            ld   d,%01011111
            jr   nz,$+3
            ld   d,e
            ld   c,%11111010
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret
L111
            ex   af,af'
            ld   e,#FF
            ld   d,%01111110
            jr   nz,$+3
            ld   d,e
            ld   c,%01111110
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret
L000
            ld   de,0
            ld   c,e
            ret
L1111
            ex   af,af'
            ld   e,#FF
            ld   d,%00111111
            jr   nz,$+3
            ld   d,e
            ld   c,%11111100
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret
L1010
            ex   af,af'
            ld   e,#FF
            ld   d,%00011111
            jr   nz,$+3
            ld   d,e
            ld   c,%11111000
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret
L1001
            ex   af,af'
            ld   e,0
            ld   d,%00100000
            jr   nz,$+3
            ld   d,e
            ld   c,%00000100
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret
L11
            ld   de,#FFFF
            ld   c,e
            ret
L01
            ex   af,af'
            ld   e,0
            ld   d,%01000000
            jr   nz,$+3
            ld   d,e
            ld   c,%00000010
            jr   nc,$+3
            ld   c,e
            ex   af,af'
            ret


SetWindowPrint   ; orig: Swin
; Задать данные печати в окне
; bc-коорд.,de-размеры
; c-X,b-Y,d-SY,e-SX
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
            ld   (WinBeginX+1),a
            ld   a,l
            ld   (WinBeginXHi+1),a
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
            ld   (WinBeginY+1),a
            ld   a,l
            ld   (WinBeginYHi+1),a
            ld   a,e
            rlca
            rlca
            rla
            sub  4
            ld   (WinEndX+1),a
            ld   a,d
            rlca
            rlca
            rla
            sub  11
            ld   (WinEndY+1),a
            pop  hl
            ret


OutWindow   ; orig: Outwin
; Вывод окна
; hl-номер объекта
            exx
            push bc
            exx
            push hl
            push de
            push bc
            push hl
            xor  a
            call ObjFieldAddr
; hl-vector of object (coord ,size and.
;..)
; Get coords
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
; Get size
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            call SetWindowPrint
            ex   (sp),hl
; Put obj to bufer screen
.Objtw
            call ObjectToBuf
            ex   (sp),hl
            inc  hl
            ld   a,(hl)
            push af
            call Window
            inc  hl
            ld   a,(hl)
            ld   hl,Wintxt
            call FindTextByIndex
            xor  a
            ld   (Mode+1),a
            call OutText
            pop  af
; Проверка есть ли у окна строка названия
            rra
            ld   a,0
            ld   l,a
            jr   nc,$+4
            add  a,8
            ld   h,a
            ld   (Cord),hl
            pop  hl
            pop  bc
            pop  de
            pop  hl
            exx
            pop  bc
            exx
            ret
.Obut
            push hl
            ld   hl,.Nth2
            ld   (Objtb+1),hl
            pop  hl
            call OutButton
            push hl
            ld   hl,ObjectToBuf
            ld   (Objtb+1),hl
            pop  hl
.Nth2
            ret


OutButton   ; orig: Outbut
; Вывод кнопки
; hl-номер объекта
; В векторе описано
; X,Y,sx,sy znak,txt,0
            push hl
            push de
            push bc
            push hl
            ld   a,1
            ld   (Mode+1),a
            xor  a
            call ObjFieldAddr
; Get coords
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
; Get size
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            call SetButtonPrint
            ex   (sp),hl
Objtb
            call ObjectToBuf
            ex   (sp),hl
            ld   a,(hl)             ; Status :down up
            and  %00011111
            inc  hl
            call Button
            ld   a,(hl)
            ld   hl,Buttxt
            call FindTextByIndex

            ld   a,#C9
            ld   (FLAGOT),a

.OB_2
            push hl
            ld   a,(hl)
            inc  hl
            cp   ET
            jp   z,.OB_1
            cp   CR
            jp   nz,$-9
            pop  de

            dec  hl
            EXD
            ld   b,0
            call MeasureTextZ
            ld   c,a
            ld   a,(WinEndX+1)
            sub  c
            jr   nc,$+3
            xor  a
            srl  a
            ld   (Cord),a
            call OutText
            jr   c,.OB_3
            jp   .OB_2
.OB_1
            pop  hl
            xor  a
            ld   (Cord),a
            call PrintText
.OB_3
            ld   a,#C3
            ld   (FLAGOT),a
            pop  hl
            pop  bc
            pop  de
            pop  hl
            ret


SetButtonPrint   ; orig: Sbut
; Задать данные печати в кнопке
; bc-коорд.,de-размеры
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
            ld   (WinBeginX+1),a
            ld   a,l
            ld   (WinBeginXHi+1),a
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
            ld   (WinBeginY+1),a
            ld   a,l
            ld   (WinBeginYHi+1),a
            ld   a,e
            rlca
            rlca
            rla
            sub  4
            ld   (WinEndX+1),a
            ld   a,d
            rlca
            rlca
            rla
            sub  11
            ld   (WinEndY+1),a
            pop  hl
            ret


Button
; Рисование кнопки
; bc-X,Y:de-sx,sy:a-status
            push hl
            call .BUTTN
            pop  hl
            ret

.BUTTN
            rra
            jp   nc,.Bt1

            dec  e
            dec  e
            dec  d
            call CorrectCoords
            ld   a,30
            sub  e
            add  a,a
            ld   (JJ_1+1),a
            ld   b,d


; Нажата
            call NXTM
            ret  nc
            jp   m,.But_1
            call L11
            call LXXX
            call L11
            call LXXX
            call L1010
            call LXXX
            xor  a

.But_1
            call L1001
            jp   m,.But_11

            rept 5
            call LXXX
            endr
            call NXTT
.But_11
            dec  b
            jr   z,.Bt22

.Bt21
            call NXTM
            ret  nc
            jp   m,.But_2
            rept 8
            call LXXX
            endr
            call NXTT
.But_2
            djnz .Bt21

.Bt22
            call NXTM
            ret  nc
            ret  m
            rept 5
            call LXXX
            endr

            call L1010
            call LXXX
            call L11
            call LXXX
            call L11
            call LXXX
            ret
.Bt1
; Отжата
            dec  e
            dec  e
            dec  d
            call CorrectCoords
            ld   a,30
            sub  e
            add  a,a
            ld   (JJ_1+1),a
            ld   b,d

            call NXTM
            ret  nc
            jp   m,.But_3
            call L11
            call LXXX
            call L1111
            call LXXX
            xor  a

.But_3
            call L01
            jp   m,.But_31

            rept 6
            call LXXX
            endr
            call NXTT

.But_31
            dec  b
            jr   z,.Bt12

.Bt11
            call NXTM
            ret  nc
            jp   m,.But_4
            rept 8
            call LXXX
            endr
            call NXTT
.But_4
            djnz .Bt11

.Bt12
            call NXTM
            ret  nc
            ret  m
            rept 6
            call LXXX
            endr

            call L1111
            call LXXX
            call L11
            call LXXX
            ret


OutFrame   ; orig: Outrm
; Рисование рамки для move, size
; bc-coords,de-size
            push bc
            push de
            exx
            push de
            ld   de,0
            exx
            ld   a,c
            and  a
            jp   p,.Orm1
            add  a,e
            ld   e,a
            exx
            ld   e,#FF
            exx
            ld   c,0
.Orm1
            ld   a,b
            and  a
            jp   p,.Orm2
            add  a,d
            ld   d,a
            exx
            ld   d,#FF
            exx
            ld   b,0
.Orm2
            ld   a,c
            add  a,e
            cp   #21
            jp   c,.Orm3
            sub  #20
            neg
            add  a,e
            ld   e,a
            exx
            ld   e,1
            exx
.Orm3
            ld   a,b
            add  a,d
            cp   #19
            jp   c,.Orm4
            sub  #18
            neg
            add  a,d
            ld   d,a
            exx
            ld   d,1
            exx
.Orm4
            ld   l,b
            rlc  l
            rlc  l
            rlc  l
            ld   h,high(TBXX)
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
            call p,.Horl
            exx
            ld   a,e
            exx
            and  a
            ld   a,%10000000
            ld   (.Vrl+1),a
            call p,.Verl
            ld   a,e
            dec  a
            add  a,l
            ld   l,a
            exx
            ld   a,e
            exx
            dec  a
            ld   a,%00000001
            ld   (.Vrl+1),a
            call nz,.Verl
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
            call nz,.Horl
            exx
            pop  de
            exx
            pop  de
            pop  bc
            ret
.Horl
            push hl
            ld   a,32
            sub  e
            add  a,a
            add  a,a
            ld   (.JJ21+1),a
.JJ21
            jr   $+2
            rept 31
            ld   a,(hl)
            cpl
            ld   (hl),a
            inc  l
            endr
            ld   a,(hl)
            cpl
            ld   (hl),a
            pop  hl
            ret
.Verl
            push hl
            ld   c,d
.Vrl
            ld   b,%10000000
            rept 8
            ld   a,b
            LDX_HL_A
            inc  h
            endr
            NEXTZNAK
            dec  c
            jp   nz,.Vrl+2
            pop  hl
            ret


ClearLine   ; orig: Clrlin
; Очистить строку на экране под текст
; Clear LINE on screen for txt
; bc-Y inPIX
; de-SIZE X
            push hl
            push bc
            ld   l,b
            sla  l
            sla  l
            sla  l
            ld   h,high(TBXX)
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
            ld   (.CN_1+1),a
            ld   a,(INVERSE)
            rra
            ld   a,#FF
            jr   nc,$+3
            inc  a
            ld   (.CN_1-1),a
.Onl2
            ld   c,8
.Onl1
            ld   b,l
            ld   a,0
.CN_1
            jr   $+2
            rept 32
            ld   (hl),a
            inc  l
            endr
            ld   l,b
            inc  h
            dec  c
            jp   nz,.Onl1
            NEXTZNAK
            dec  d
            jp   nz,.Onl2
            pop  bc
            pop  hl
            ret


ClearInWindow   ; orig: Clinwin
; Очистить внутренность окна
; Clean inside window
; Parametrs : BXW,BXH,EXW,BYW,BYH,EYW
; a-колич строк * 8
            push af
            ld   a,(WinEndX+1)
            ld   e,a
            ld   a,(WinBeginX+1)
            ld   c,a
            exx
            ld   a,(WinBeginXHi+1)
            ld   c,a
            exx
            and  a
            ld   a,c
            jp   p,.Sct23
            add  a,e
            add  a,8
            ld   e,a
            ld   c,0
            jp   .Sct24
.Sct23
            dec  a
            add  a,e
            jp   nc,.Sct24
            exx
            ld   c,1
            exx
            cpl
            add  a,e
            add  a,8
            ld   e,a
.Sct24
            pop  af
            add  a,5
            ld   d,a

            ld   a,(WinBeginY+1)
; Смещение по вертикали, чтоб не стирать
; Что то сверху
SCRLS
            add  a,0
            ld   b,a
            ld   a,(WinBeginYHi+1)
            and  a
            ld   a,b
            jp   p,.Sct231
            add  a,d
            ret  z
            cp   192
            ret  nc
            bit  7,b
            jr   z,.Sct241
            ld   b,0
            ld   d,a
            jp   .Sct241
.Sct231
            cp   192
            ret  nc
            add  a,d
            jr   c,.Sct25
            cp   192
            jr   c,.Sct241
.Sct25
            sub  #BF
            neg
            add  a,d
            ld   d,a
.Sct241
            ld   h,high(TBXX)
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
            jr   nz,.Sct0
            ld   a,e
            sub  1
            ret  c
            ld   e,a
.Sct0
            ld   a,30
            sub  e
            add  a,a
            ld   (.JJ01+1),a
            ld   (.JJ02+1),a
            ld   (.JJ03+1),a
            ld   e,7
            ld   b,%00000111
            exx
            inc  c
            exx
            jp   z,.Sct08
            ld   b,%11100000
            exx
            dec  c
            dec  c
            exx
            jp   z,.Sct07
.Sct09
            ld   c,l
            ld   a,(hl)
            and  b
            ld   (hl),a
            inc  l
            xor  a
.JJ01
            jr   $+2
            rept 30
            ld   (hl),a
            inc  l
            endr
            ld   a,(hl)
            and  #07
            ld   (hl),a
            ld   l,c
            inc  h
            ld   a,h
            and  e
            jp   nz,$+13
            NEXTZNAK
            dec  d
            jp   nz,.Sct09
            ret
.Sct08
            ld   c,l
            xor  a
.JJ02
            jr   $+2
            rept 30
            ld   (hl),a
            inc  l
            endr
            ld   a,(hl)
            and  b
            ld   (hl),a
            ld   l,c
            inc  h
            ld   a,h
            and  e
            jp   nz,$+13
            NEXTZNAK
            dec  d
            jp   nz,.Sct08
            ret
.Sct07
            ld   c,l
            ld   a,(hl)
            and  b
            ld   (hl),a
            inc  l
            xor  a
.JJ03
            jr   $+2
            rept 30
            ld   (hl),a
            inc  l
            endr
            ld   l,c
            inc  h
            ld   a,h
            and  e
            jp   nz,$+13
            NEXTZNAK
            dec  d
            jp   nz,.Sct07
            ret


EraseObject   ; orig: ERSOBJ
; Стереть объект (Z = стёрт)
; Вызов стирания объекта
; FZ-on объект стерт
; FZ-off курсор в др. области
; de-номер
            ld   a,(Mcoord+1)
            srl  a
            srl  a
            srl  a
            ld   c,a
            ld   a,(WinBeginY+1)
            srl  a
            srl  a
            srl  a
            cp   c
            ret  nz

CloseObject   ; orig: ERSOBJ2
; Закрыть объект
; Закрытие объекта
            call EraseObjectCore
            ret  z
            xor  a
            ld   (RepaintFlag+1),a
            ret

MoveSizeObject   ; orig: Movsiz
; Перемещение и изменение размера объекта
; Change size andmove object
            push ix
            push af
            push hl
            push de
            push bc
            ld   a,1
            jr   z,$+3
            inc  a
            ld   (CCFR1+1),a
            ld   (CCFR2+1),a

            call TakeIdent
            and  a
            jp   z,R_MS1
            dec  a
            rlca
            ld   l,a
            ld   h,high(Tabob)
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            inc  h
            jp   z,R_MS1            ; Void field
            dec  h
            xor  a
            call ObjFieldAddr
            push hl
            push bc
; Get cords
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
; Get size
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   a,(hl)
            and  %11000000
            jr   nz,$+6
; Если eto okho
            ld   a,3
            jr   .Moz
            cp   %01000000
            jr   nz,$+6
; Ето кнопка
            ld   a,2
            jr   .Moz
; Ето линия
            ld   a,1
.Moz
            ld   (Oz1+1),a
            ld   (Oz2-1),a
            ld   (Oz11+1),a
            ld   (Oz21-1),a
; Надо определить нижний правый край, на
; Экране или нет он
            ld   a,e
            add  a,c
            ld   l,a

            ld   a,b
            and  a
            jp   m,.Gs2              ; Объект сверху за экранм
            add  a,d
            ld   h,a

; Проверка если объект справа за экраном
; И если видимая левая часть составляет
; Менее 3 знакомест в длинну то переход
; В любом случае на перетаскивние
            ld   a,l
            cp   #20
            jr   c,$+7
            ld   a,#1D
            sub  c
            jr   c,.Gs2

; Для кнопок специально делаем так что бы
; Размеры можно было менять за край
            ld   a,(Oz1+1)
            cp   2
            ld   a,d
            jr   nz,$+4
            ld   a,1
            EXD
            ex   (sp),hl
; В нlсейчас коорд. курсора
            inc  l
            inc  h
; Сместии их к краю
            push hl
            dec  a
            jr   nz,$+7
; Если у объ. еденичная высота, то размер
; Менять только за правый край
            SUB_DE
            jr   $+4
            ld   a,h
            sub  d
            pop  hl
; Сравнили
            ex   (sp),hl
            EXD
            jp   z,.Gs21             ; Попали значит size

.Gs9
; Moving только за верхнюю линию
            ex   (sp),hl
            ld   a,h
            sub  b
            dec  a
            ex   (sp),hl
            jr   z,.Gs2
            pop  bc
            pop  hl
            jp   R_MS1
.Gs21
            ld   hl,(Mcoord)
            ld   a,l
            or   h
            and  #F8
            jp   nz,Gss             ; На смену размера
; Тоже на сдвиг потому что окно заперто
; В самый верх и лево

.Gs2
; MOVE
; Сдвиг рамки
; bc-cord,de-len high видимий части боко
; вИн

            ld   a,(SPBYTE+1)
            and  4
            jp   nz,R_MS3           ; Запрещ.движение

            call CursorRestoreSafe

            ld   hl,(Mcoord)

            ld   a,b
            sla  a
            sla  a
            sla  a
            sub  h
            neg
            ld   h,a
            ld   a,c
            sla  a
            sla  a
            sla  a
            sub  l
            neg
            ld   l,a
            push hl

Gs29

            ld   (Oco+1),bc
            ld   (Osz+1),de

            call OutFrame              ; outRAMKA
; For seek смещениесдвига
            ld   hl,#5080+#1000
            ld   (Mcoord),hl
            push bc
            push de
            push hl
.N_N1
            halt
            call ReadFireCancel
            and  a
            jr   z,.N_N2
            call CursorMoved
            jr   z,.N_N1
.N_N2
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
; СМЕЩЕНИЯ bhl
            pop  de
            pop  bc
            ld   a,c
            add  a,l
            ld   l,a
            jp   m,.Oo11             ; Не долет слева
            cp   #20
            jp   c,.Oo21
; Вылет справа
            sub  #1F
            neg
            add  a,l
            ld   l,a
; Уменьшили ширину
            jp   .Oo21
.Oo11
            dec  a
            add  a,e
            jp   p,.Oo21             ; BCE OK
; Недолетели поширине
            neg
            add  a,l
            ld   l,a
.Oo21
            ld   a,b
            add  a,h
            ld   h,a
            jp   m,.Oo1
            cp   24
            jp   c,.Oo2
; Вылет справа
            sub  23
            neg
            add  a,h
            ld   h,a
            jp   .Oo2
.Oo1
            dec  a
            add  a,d
            jp   p,.Oo2
; Недолет слева
            neg
            add  a,h
            ld   h,a
.Oo2
            ld   b,h
            ld   c,l
; Bbc-новыекоорд.

            halt
            push bc
            push de
Oco
            ld   bc,0
Osz
            ld   de,0
            call OutFrame
; Стерли ctapoe
            pop  de
            pop  bc

            call ReadFireCancel
CCFR1
            cp   1
            jp   z,Gs29
.Gs22
; Если кнопка отжата
            pop  hl

            ex   (sp),hl
            pop  hl
            ex   (sp),hl
; 3Апомнили
            ld   (hl),c
            inc  hl
            ld   (hl),b
; Ставимкурсор на середину объекта
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
; Выход с флагом выхода
            xor  a
            ld   (RepaintFlag+1),a
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  ix
            and  a
            scf
            ret
.R_MS2
            pop  bc
            pop  bc
            jr   R_MS
R_MS3
            pop  bc
            pop  bc
R_MS1
; Выход без флага выхода
            pop  bc
            pop  de
            pop  hl
            pop  af
            pop  ix
            and  a
            ret
Gss
; SIZE
SPBYTE
            ld   a,0
            and  2
            jr   nz,R_MS3           ; Запрещ.изм.размера

            call CursorRestoreSafe

            ld   hl,(Mcoord)
            push hl
Gss29

            ld   (Oco+1),bc
            ld   (Osz+1),de
            call OutFrame
            ld   hl,#5080+#1000
            ld   (Mcoord),hl
            push bc
            push de
            push hl
.N_N4
            halt
            call ReadFireCancel
            and  a
            jr   z,.N_N3
            call CursorMoved
            jr   z,.N_N4
.N_N3
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
            pop  de
            pop  bc
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
            jp   p,.Oz29
            neg
            add  a,l
            ld   l,a
            jp   .Oz31
.Oz29
            cp   #20
            jp   c,.Oz31
            sub  #1F
            neg
            add  a,l
            ld   l,a
.Oz31
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
            jp   p,.Oz28
            neg
            add  a,h
            ld   h,a
            jp   .Oz32
.Oz28
            cp   24
            jp   c,.Oz32
            sub  23
            neg
            add  a,h
            ld   h,a
.Oz32
            EXD
            push bc
            push de
            ld   bc,(Oco+1)
            ld   de,(Osz+1)
            halt
            call OutFrame
            pop  de
            pop  bc

            call ReadFireCancel
CCFR2
            cp   1
            jp   z,Gss29
.Gs23
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
            ld   a,l
            and  7
            or   e
            ld   l,a

            ld   a,b
            add  a,d
            dec  a
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


EraseObjectCore   ; orig: ERASOBJ
; Стирание объекта по номеру DE
; de-NUM
; FZ on если таково на столе нет
            push ix
            push hl
            push de
            push bc
            ld   ix,(SurroundPtr+1)
.E_2
            ld   l,(ix+0)
            ld   a,(ix+1)
            dec  a
            jr   z,.E_1
            inc  a
            ld   h,a
            inc  hl
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            inc  ix
            inc  ix
            SUB_DE
            jr   nz,.E_2
; Собственно стирание из списка объектов
; На столе
            push ix
            pop  de
            ld   h,d
            ld   l,e
            DEC_DE 2
            ld   bc,OVLEN
            ldir
            xor  a
            inc  a
.E_1
            pop  bc
            pop  de
            pop  hl
            pop  ix
            ret

LastDeskObject   ; orig: LASTOBJ
; Последний объект на столе
; Взять последний объект на столе
; rethl-ШОУ АДР. ЕГО
            ld   hl,(SurroundPtr+1)
.N_F02
            inc  hl
            ld   a,(hl)
            inc  hl
            dec  a
            jp   nz,.N_F02
            DEC_HL 3
            ld   a,(hl)
            dec  hl
            ld   l,(hl)
            ld   h,a
            ret


FindDeskObject   ; orig: FOBJ
; Поиск объекта на столе
; de-шоу адрес объекта
; FZ-off не найден
            push hl
            ld   hl,(SurroundPtr+1)
.N_F2
            inc  hl
            ld   a,(hl)
            dec  a
            jr   z,.N_F1
            inc  a
            cp   d
            inc  hl
            jr   nz,.N_F2
            DEC_HL 2
            ld   a,(hl)
            cp   e
            INC_HL 2
            jr   nz,.N_F2
            ld   a,#FF
.N_F1
            inc  a
            pop  hl
            ret


SetupCoords   ; orig: SETCRDS
; Установить сетапные координаты объектов
; Установка сетапных кооринат всем объек
; ТАМ
            ld   ix,Objvec
            ld   de,16
.H_12
            ld   a,(ix+0)
            cp   #80
            ret  z
            ld   a,(ix+8)
            ld   (ix+0),a
            ld   a,(ix+9)
            ld   (ix+1),a
            ld   a,(ix+10)
            ld   (ix+2),a
            ld   a,(ix+11)
            ld   (ix+3),a
            add  ix,de
            jp   .H_12


OpenObject   ; orig: NEWOBJ
; Открыть/активировать объект по шоу-адресу
; Дополнительный обработчик кнопок
; hl-шоу адрес объекта
; Активизирует или создает на столе
; Новый объект описываемый адресом
; Под которым конечно сразу идет:
; ldhl,НОМЕР ЕГО
; Так же идет проверка на продолжительное
; Нажатие огня или отмены, поэтому выход
;        lda,(KFC):anda:retm
            xor  a
            ld   (RepaintFlag+1),a
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            DEC_HL 2
            call ActivateObject

.SETSCRD
; Установка сетапных координат
            push hl
            push bc
            push ix
            ld   h,d
            ld   l,e
            xor  a
            call ObjFieldAddr
            push hl
            pop  ix
            ld   a,(ix+8)
            ld   (ix+0),a
            ld   a,(ix+9)
            ld   (ix+1),a
            ld   a,(ix+10)
            ld   (ix+2),a
            ld   a,(ix+11)
            ld   (ix+3),a
            pop  ix
            pop  bc
            pop  hl
            ret


WindowHandler3   ; orig: WINOBR3
; Обработчик окна: всегда ловит огонь и отмену
; Для тех которые должны всегда ловить
; Fire & cancel
            res  7,a

WindowHandler2   ; orig: WINOBR2
; Обработчик окна: сразу ловит огонь и отмену
; Для тех которые должны сразу ловить
; Fire & cancel
            ex   af,af'
            ld   a,#A7
            ld   (W_O9),a
            ex   af,af'
            jr   W_O10

WindowHandler1   ; orig: WINOBR1
; Обработчик окна: первое нажатие активирует, перемещение/размер
; Первое нажатие - активирующее
; Первый обработчик окон, изм. раз. перем
; Ещение.
; de-NUM,FC-ON MUST BE ret
            ex   af,af'
            ld   a,#37
            ld   (W_O9),a
            ex   af,af'
W_O10
            bit  7,a
            scf
            ret  nz

; Если кнопка нажата первый раз,т.е.
; Она не удерживалась до этого момента
; Прорисовть окно
            or   a
            push ix
            push de
            push af
            call Unclick
            call ActivateObject
            jp   z,Owl11
            ld   de,.O_Q1
            push de
            push hl
            jp   HideCursor
.O_Q1
            call ShowCursorBack
            pop  af
            pop  de
            pop  ix
            call nz,MoveSizeObject
            ret  c
W_O9
            scf
            ret
Owl11
            pop  af
            pop  de
            pop  ix
; Если нажат огонь то на перемещ/размер
            jp   nz,MoveSizeObject
            ret


ButtonHandler   ; orig: BUTOBR1
; Общий обработчик кнопок
; Обработчик кнопки один для всех
; de-num,a-kod key
; Fc-on выход должен быть без обработчика
            ld   (.UPROC+1),hl
            bit  7,a
            jr   nz,.B_B1
            or   a
            call z,MoveSizeObject
            ret  c
            and  a
            jr   nz,.B_B1
            xor  a
            ld   (RepaintFlag+1),a
            push de
; Разворачивание кнопки или сворачивание
; Только если отменой на нижнюю часть
; Кнопки,но не на край
            push de
            call ActivateObject
            pop  hl
            ADDHLHL 4
            EXD
            ld   ix,Objvec
            add  ix,de
            ld   a,(ix+2)
            cp   #10
            jr   c,.B_B2
.B_B3
; Сворачивание
            ld   a,(ix+8)
            ld   (ix+0),a
            ld   a,(ix+9)
            ld   (ix+1),a
            ld   a,(ix+10)
            ld   (ix+2),a
            ld   a,(ix+11)
            ld   (ix+3),a
            pop  de
            scf
            ret
.B_B2
            ld   a,(ix+3)
            cp   #08
            jr   nc,.B_B3
; Разворачивание
            ld   (ix+0),6
            ld   (ix+1),4
            ld   (ix+2),20
            ld   (ix+3),10
            pop  de
            scf
            ret

.B_B1
            call ActivateObject
            call CheckClickHandler
            jr   nz,.B_B4            ; Если кнопка нажата
            ld   hl,DoNothing
            ld   (UnclickHandler+1),hl
            call Unclick
; Разрешить анклик
            ld   a,#FF
            ld   (Unclick+1),a
            ld   (Rghl+1),de
            halt
            call Click

.B_B4
            ld   a,(KFC)
            rla
.UPROC
            ld   hl,0
            ld   (UnclickHandler+1),hl
            ret

SetBlackWindow   ; orig: BLACKW
; Подготовка вывода окошек черными
            ld   de,L1011
            jr   SetBlackWindowPage+3

SetBlackWindowPage   ; orig: BLACKWP
; Подготовка вывода чёрных окон (вариант)
            ld   de,L101
            ld   a,(INVERSE)
            rra
            jr   c,SetWhiteWindow
            ld   (IW1014+1),de
            ld   de,L1011
            ld   (IW000+1),de
            ld   (IW0002+1),de
            ld   (IW101+1),de
            ld   (IW1012+1),de
            ld   (IW1013+1),de
            ret

SetWhiteWindow   ; orig: WHITEW
; Подготовка вывода белых окон
; К выводу белых окошек
            ld   de,L101
            ld   (IW101+1),de
            ld   (IW1012+1),de
            ld   (IW1013+1),de
            ld   (IW1014+1),de
            ld   de,L000
            ld   (IW000+1),de
            ld   (IW0002+1),de
            ret
