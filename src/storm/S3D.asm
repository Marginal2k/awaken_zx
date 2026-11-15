;==============================================================================
; S3D - 3D-движок объектов (станция/полёт/посадка)
;
; Страница #11 (PAGE_3D). Таблица переходов по #FF00: Init3d, OutAll3d, NextObject,
; ObjectIndexTab, Moveon, SetCoordsByMove, ClearMoves, Fline (в EQUS - ENG3D_*).
; Код и таблицы с #C000: D9000/D9200 (маски текстур, умножение, синус), корни (korni),
; затем XR2 (полигоны), XCLP (клиппинг), XR1 (цикл вида/объектов), BLOK1 (управление),
; OBJX (вершины и грани объектов: деревья, дом, Sturm/Istr/Turi/Trad).
; Промежутки выравнивания (ORG $^) содержат в исходном файле мусор памяти.
; Сборка: make_S3D.asm -> S3D.bin (16151 байт, совпадает с awk2/S3D.C).
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

        include "EQUS.asm"

        org  #FF00
        jp   Init3d             ; Инит 3d
        jp   OutAll3d           ; Вывод 3d
        jp   NextObject         ; Для выхода из вокселей
        dw   ObjectIndexTab     ; Таблица адресов объект
        jp   Moveon             ; Вычисл. прираш. измен
        jp   SetCoordsByMove    ; Изм. коорд. объектов
        jp   ClearMoves         ; Очист.приращения изм.
        jp   Fline              ; Рисовать лазер игрока

        org  #C000
L90k
        incbin "assets/D9000.bin"

Eye_a           equ #C200
Eye_b           equ #C201
Eye_g           equ #C202
Eyea            equ #C203
Eyeb            equ #C204
Eyeg            equ #C205

L91             equ #C221
L90             equ #C200

        ds   #0100

Multb           equ high($)
Sintb           equ Multb+1
        incbin "assets/D9200.bin"
L9c             equ high($)
        ds   #0100
L9d             equ high($)
        ds   #0100
L9e             equ high($)
        ds   #0100
; Таблица для подсечета корня
; Первый байт корень и3 "круглого" числа
; Втор. слово инвертнутое по 3наку число
; Как остаток
Korn
        incbin "assets/korni.bin"

        include "XR2.asm"

        org  (($+255)&#FF00)
L95
        db   low(Lceb1)
        db   low(Lcdf6)
        db   low(Lcdcd)
        db   0
        db   low(Lcda4)
        db   low(Lc903)
        db   low(Lc91d)
        db   0
        db   low(Lcd7b)
        db   low(Lc937)
        db   low(Lc951)
        db   0, 0, 2, 0, 1
        db   low(Lc96b)
        db   low(Lc902)
        db   low(Lc971)
        db   0
        db   low(Lc977)
        db   low(Lc912)
        db   low(Lc989)
        db   0
        db   low(Lc9a1)
        db   low(Lc9b3)
        db   low(Lc9ba)
        db   0, 0, 0, 0, 0
        db   low(Lc9cc)
        db   low(Lc9d2)
        db   low(Lc902)
        db   0
        db   low(Lc9d8)
        db   low(Lc9ea)
        db   low(Lc9fc)
        db   0
        db   low(Lca03)
        db   low(Lca15)
        db   low(Lc960)
        ds   21
        db   low(Lca2d)
        db   low(Lca33)
        db   low(Lca45)
        db   0
        db   low(Lc902)
        db   low(Lca57)
        db   low(Lc92c)
        db   0
        db   low(Lca5e)
        db   low(Lca64)
        db   low(Lca79)
        db   0, 0, 0, 0, 0
        db   low(Lca94)
        db   low(Lcab0)
        db   low(Lcab7)
        db   0
        db   low(Lcad6)
        db   low(Lc902)
        db   low(Lcae1)
        db   0
        db   low(Lcae7)
        db   low(Lcec8)
        db   low(Lcafc)
        db   0, 0, 0, #0A, #90
        db   low(Lcb15)
        db   low(Lcb31)
        db   low(Lcb46)
        db   0
        db   low(Lcb51)
        db   low(Lcec8)
        db   low(Lc902)
        db   0
        db   low(Lcb58)
        db   low(Lcb77)
        db   low(Lcb90)
        ds   21
        db   low(Lcb96)
        db   low(Lcb9c)
        db   low(Lcbae)
        db   0
        db   low(Lcbc0)
        db   low(Lcbc6)
        db   low(Lcbe1)
        db   0
        db   low(Lc902)
        db   low(Lc946)
        db   low(Lcbf6)
        db   0, #82, #72, #3C, #7F
        db   low(Lcbfd)
        db   low(Lcc19)
        db   low(Lcc24)
        db   0
        db   low(Lcc39)
        db   low(Lcc58)
        db   low(Lcc5e)
        db   0
        db   low(Lcc77)
        db   low(Lc902)
        db   low(Lcec8)
        db   #15, #0A, #1C, #1D, #A4
        db   low(Lcc7e)
        db   low(Lcc9a)
        db   low(Lccb9)
        db   0
        db   low(Lccc0)
        db   low(Lccd5)
        db   low(Lcec8)
        db   0
        db   low(Lccee)
        db   low(Lccf9)
        db   low(Lc902)

        org  (($+255)&#FF00)
L96
        db   high(Lceb1)
        db   high(Lcdf6)
        db   high(Lcdcd)
        db   0
        db   high(Lcda4)
        db   high(Lc903)
        db   high(Lc91d)
        db   0
        db   high(Lcd7b)
        db   high(Lc937)
        db   high(Lc951)
        db   0, 0, 0, 0, 0
        db   high(Lc96b)
        db   high(Lc902)
        db   high(Lc971)
        db   0
        db   high(Lc977)
        db   high(Lc912)
        db   high(Lc989)
        db   0
        db   high(Lc9a1)
        db   high(Lc9b3)
        db   high(Lc9ba)
        db   0, #55, 1, 0, 0
        db   high(Lc9cc)
        db   high(Lc9d2)
        db   high(Lc902)
        db   0
        db   high(Lc9d8)
        db   high(Lc9ea)
        db   high(Lc9fc)
        db   0
        db   high(Lca03)
        db   high(Lca15)
        db   high(Lc960)
        ds   21
        db   high(Lca2d)
        db   high(Lca33)
        db   high(Lca45)
        db   0
        db   high(Lc902)
        db   high(Lca57)
        db   high(Lc92c)
        db   0
        db   high(Lca5e)
        db   high(Lca64)
        db   high(Lca79)
        db   0, 0, 2, 0, 0
        db   high(Lca94)
        db   high(Lcab0)
        db   high(Lcab7)
        db   0
        db   high(Lcad6)
        db   high(Lc902)
        db   high(Lcae1)
        db   0
        db   high(Lcae7)
        db   high(Lcec8)
        db   high(Lcafc)
        db   0, 0, 0, 0, 0
        db   high(Lcb15)
        db   high(Lcb31)
        db   high(Lcb46)
        db   0
        db   high(Lcb51)
        db   high(Lcec8)
        db   high(Lc902)
        db   0
        db   high(Lcb58)
        db   high(Lcb77)
        db   high(Lcb90)
        ds   21
        db   high(Lcb96)
        db   high(Lcb9c)
        db   high(Lcbae)
        db   0
        db   high(Lcbc0)
        db   high(Lcbc6)
        db   high(Lcbe1)
        db   0
        db   high(Lc902)
        db   high(Lc946)
        db   high(Lcbf6)
        db   #20, #B2, 0, 0, #64
        db   high(Lcbfd)
        db   high(Lcc19)
        db   high(Lcc24)
        db   0
        db   high(Lcc39)
        db   high(Lcc58)
        db   high(Lcc5e)
        db   0
        db   high(Lcc77)
        db   high(Lc902)
        db   high(Lcec8)
        db   0, 0, 0, 0, 0
        db   high(Lcc7e)
        db   high(Lcc9a)
        db   high(Lccb9)
        db   0
        db   high(Lccc0)
        db   high(Lccd5)
        db   high(Lcec8)
        db   0
        db   high(Lccee)
        db   high(Lccf9)
        db   high(Lc902)
        db   0, 0, 0, 0, 0

; Всякие маски
Ld1l
        dw   #4080
        dw   #1020
        dw   #0408
        dw   #0102
        dw   #BF7F
        dw   #EFDF
        dw   #FBF7
        dw   #FEFD

Sets2   db   0
Sets    db   0
Indx    db   0
Objx    dw   0
Objy    dw   0
Objz    dw   0
Speed   dw   0

Indt1   db   0
Indt2   db   0

        include "XCLP.asm"
        include "XR1.asm"

OutAll3d                        ; orig: OUTAL2_
        ld   a,(Cmode+1)
        or   a
        jr   nz,.OO1
        ld   a,(SPEED)
        or   a
        ld   h,#00
        jp   p,$+4
        dec  h
        ld   l,a
        dup  6
        add  hl,hl
        edup
        ld   (Speed),hl
.OO1
        ld   a,(UNGLE)
        ld   c,a
        ld   a,(Eye_b)
        add  a,c
        ld   (Eye_b),a
        call MoveObjects
        call Render3d
        call MERZ
        ret

; Процедуры управления кораблем, определ
; Ение его
; Столкновений

MoveObjects                     ; orig: Moveu
        call Touch              ; Going through sta
        ; T objects
        jp   CalcSteps
Touch
Cmode   ld   a,0
        dec  a
        ret  m
        ld   (Cmode+1),a
        ret
Lm1
        ; Столкновение с объектом
        ld   a,(Cmode+1)
        or   a
        ret  nz
        ld   a,4
        ld   (Cmode+1),a
        ld   a,(SPEED)
        neg
        ld   (SPEED),a
        ld   hl,(Speed)
        call NEGHL
        ld   (Speed),hl
        ld   hl,(XPL+1)
        call NEGHL
        ld   (XPL+1),hl
        ld   hl,(YPL+1)
        call NEGHL
        ld   (YPL+1),hl
        ld   hl,(ZPL+1)
        call NEGHL
        ld   (ZPL+1),hl
        ret

NEGHL   ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ret

; Your turns
CalcSteps                       ; orig: Calcstp
        ld   a,(Sm_13+1)
        ld   de,(Speed)
        ld   ix,$+7
        jp   MulADE
        ld   (XPL+1),hl
        bit  7,h
        ld   de,(XXP)
        add  hl,de
        ld   (XXP),hl
        ld   a,(XXP+2)
        jr   z,$+6
        sbc  a,0
        jr   $+4
        adc  a,0
        ld   (XXP+1),a
        ld   a,(Sm_23+1)
        ld   de,(Speed)
        ld   ix,$+7
        jp   MulADE
        ld   (YPL+1),hl
        bit  7,h
        ld   de,(YYP)
        add  hl,de
        ld   (YYP),hl
        ld   a,(YYP+2)
        jr   z,$+6
        sbc  a,0
        jr   $+4
        adc  a,0
        ld   (YYP+1),a
        ld   a,(Sm_33+1)
        ld   de,(Speed)
        ld   ix,$+7
        jp   MulADE
        ld   (ZPL+1),hl
        bit  7,h
        ld   de,(ZZP)
        add  hl,de
        ld   (ZZP),hl
        ld   a,(ZZP+2)
        jr   z,$+6
        sbc  a,0
        jr   $+4
        adc  a,0
        ld   (ZZP+1),a
        ret

SquareRootTab                   ; orig: Korni
        ; De-старшая часть числа
        ; Ret a-MEAN
        ld   a,d
        and  a
        jr   z,Kor
        ld   l,a
        ld   h,high(Korn)
        ld   a,(hl)
        inc  h
        ld   c,a
        cpl
        ex   af,af
        ld   b,#FF
        inc  bc
        sla  c
        rl   b
        dec  bc
        ld   a,(hl)
        inc  h
        ld   h,(hl)
        ld   l,a
        ex   af,af
        add  hl,de
        dup  5
        add  hl,bc
        ret  nc
        dec  bc
        dec  bc
        inc  a
        edup
        add  hl,bc
        ret  nc
        inc  a
        ret
Kor
        ; Подсчет корня бе3 таблицы, для маленьк
        ; Их данных
        ; De-data <2116
        ; A-MEAN
        ex   de,hl
        ld   bc,0-1
        xor  a
        dup  14
        add  hl,bc
        ret  nc
        inc  a
        dec  bc
        dec  bc
        edup
        add  hl,bc
        ret  nc
        inc  a
        ret

VisibleLine                     ; orig: Vsline
        ; Check wisibility of line
        ; Cords of line in cordline bufer
        ld   hl,+(L9c*256)+1
        xor  a
        ex   af,af
        ld   b,10
Ld84    ld   c,#00
        ld   a,(hl)
        inc  l
        inc  l
        cp   #80
        jr   z,Ld85
        jr   nc,$+9
        and  a
        jp   nz,$+11
        jp   $+10
        set  1,c
        jp   $+5
        set  0,c
        ld   a,(hl)
        and  a
        jp   m,$+16
        jp   nz,$+18
        dec  l
        ld   a,(hl)
        inc  l
        cp   #60
        jr   nc,$+10
        jp   $+10
        set  3,c
        jp   $+5
        set  2,c
        inc  l
        ld   a,c
        rlca
        rlca
        rlca
        rlca
        xor  #F0
        or   c
        ld   (hl),a
        ex   af,af
        or   (hl)
        ex   af,af
Ld83    inc  l
        ld   a,l
        inc  l
        cp   b
        jp   nz,Ld84
        ex   af,af
        ret
Ld85    inc  l
        ld   (hl),c
        jp   Ld83

ShipMatrix                      ; orig: Shmtrx
; Calc SHIP matrix vector
Eyea_   ld   a,0
        ld   h,Sintb
        ld   l,a
        ld   b,(hl)             ; Sin a
        add  a,#40
        ld   l,a
        ld   c,(hl)             ; Cos a
Eyeb_   ld   a,0
        ld   l,a
        ld   a,(hl)             ; Sin b
        ld   ixl,a
        ld   a,l
        add  a,#40
        ld   l,a
        ld   a,(hl)             ; Cos b
        ld   iyl,a
Eyeg_   ld   a,0
        ld   l,a
        ld   a,(hl)             ; Sin G
        ld   d,a
        ld   a,l
        add  a,#40
        ld   l,a
        ld   e,(hl)             ; Cos G
        ld   h,Multb
        ld   a,ixl
        sra  a
        ld   l,e
        sra  l
        sub  l
        ld   l,a
        add  a,e
        ld   e,(hl)
        ld   l,a
        ld   a,(hl)
        sub  e
        ld   (Hm_13+1),a
        ld   a,iyl
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
        ld   ixh,a
        ld   a,ixl
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
        sub  ixh
        jp   po,$+9
        neg
        jp   po,$+4
        dec  a
        ld   (Hm_23+1),a
        ld   a,iyl
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
        ld   ixh,a              ; Cb*ca
        ld   a,ixl
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
        add  a,ixh
        jp   po,$+9
        neg
        jp   po,$+4
        dec  a
        ld   (Hm_33+1),a
        ret

; ------------------------
; Вывод линии b 3d пространстве
; ------------------------
DrawLine3d                      ; orig: Outline
        ; De-z1,hl-Y1,bc-X1
        ; De'-z2,hl'-y2,bc'-x2
        call Clc2d3d
        ret  nz
        ld   (L9c*256),hl
        ld   ((L9c*256)+2),de
        exx
        call Clc2d3d
        ret  nz
        ld   ((L9c*256)+5),hl
        ld   ((L9c*256)+7),de
        exx
        call VisibleLine
        ret  z
        ld   b,a
        cpl
        and  #F0
        ret  nz
        ld   a,b
        and  #0F
        ld   hl,LineMask
        jp   nz,DrawPolygon
        jp   DrawPolygonAlt     ; Draw poly.
LineMask                        ; orig: Masklin
        db   %10110010, 0, 5, 0

; И3меняем координаты,3ави. движения
SetCoordsByMove                 ; orig: Precord
        ld   (Stk1+1),sp
        ld   l,(ix+Indi)
        ld   h,high(L97)
        ld   sp,hl
        pop  hl
        inc  hl
        ld   b,(hl)
        bit  7,b
        jp   nz,Stk1
        res  7,b
        ld   a,#06
        sub  b
        ld   hl,100
        ld   ($+4),a
        jr   $
        dup  5
        add  hl,hl
        edup
        ld   a,Spacebd
        sub  h
        ld   b,a
        ld   a,ixl
        ld   l,a
        ld   a,ixh
        ld   h,a
        ld   sp,hl
Stpx_   ld   hl,0
        pop  de
        or   a
        adc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes

XPL     ld   de,0
        or   a
        sbc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes

        push hl
Stpy_   ld   hl,0
        inc  sp
        inc  sp
        pop  de
        or   a
        adc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes

YPL     ld   de,0
        or   a
        sbc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes

        push hl
Stpz_   ld   hl,0
        inc  sp
        inc  sp
        pop  de
        or   a
        adc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes

ZPL     ld   de,0
        or   a
        sbc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes

        push hl
Stk1    ld   sp,0
        ret
Exes
        ; Если объект за границей
        ld   (ix+0),0
        ld   (ix+1),#80
        ld   (ix+Setup),#FF
        ld   sp,(Stk1+1)
        ret

; Задание смещений в 0
ClearMoves                      ; orig: Nulmove
        ld   hl,0
        ld   (Stpx_+1),hl
        ld   (Stpy_+1),hl
        ld   (Stpz_+1),hl
        ret

        include "BLOK1.asm"

; Индексная таблица объектов
ObjectIndexTab                  ; orig: ADI3D_
        dw   ObjSturm
        dw   ObjSturm
        dw   ObjIstr
        dw   ObjIstr
        dw   ObjTuri
        dw   ObjTuri
        dw   ObjTrad
        dw   ObjTrad

        org  ObjectIndexTab+#80
        dw   ObjTree1
        dw   ObjTree1
        dw   ObjTree2
        dw   ObjTree2
        dw   ObjHouse1
        dw   ObjHouse1

; Данные объектов
ObjectData                      ; orig: Objcts
        include "OBJX.asm"

END_
