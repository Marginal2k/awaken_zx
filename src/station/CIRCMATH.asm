;==============================================================================
; CIRCMATH - окружность на карте, имена звёзд, государства, расстояния
;
; Где живёт: оверлей KARTA.C, ORG #C000, страница PGKRT (#11); собирается после KARTA и DRAWLIN.
;
; Содержит: DrawCircle (круг радиуса прыжка в окне карты с клиппированием по окну), Square, CircleHalfWidth
; (X = sqrt(r^2 - Y^2) по таблице квадратов/корней), NAME (имя звезды по координатам: греческое слово
; из NAMTAB), FindStateAtMap (государство по координатам карты), StarDistance (расстояние через таблицу
; KORNI.d), буферы KR1..KR4, DOTB, DOTCO, DOTCLP (поле звёзд, видимые точки; EQU после TBXX2_).
; Данные: 0E0200.d, KORNI.d (assets), NAMTAB.inc. См. GAME_DESIGN 5.1-5.3, 5.6.
;==============================================================================

; Файлы cyrcle & матнк


RDY         db   0
RDX         db   0
;  Знаки b0-X,b1-Y ,1-plus
;  Так же b2,b3=1,1
RDS         db   #0F
RDH         db   40                 ; Длинна полу стороны

RYX         db   0,0
CY          db   0
CX          db   0
VY          db   0
STK_L       dw   0
VAR1        dw   0
MASK        db   0
UPDWN       db   0

ADL         dw   #4000
ADH         dw   #5800

BRX         db   0
MIDX        db   0
MIDY        db   0
MIDX0       db   0
MIDX8       db   0


;-----------------

DrawCircle   ; orig: CIRCLE
; Вывод окружности/круга в окне карты
; a-inverse
            ld   a,0
            rra
            ld   a,#38
            jr   c,$+4
            ld   a,#30
            ld   (INV1),a
            ld   (INV2),a
            ld   (INV3),a
            ld   (INV4),a
            ld   a,(RDH)
            cp   #09
            ret  c

;  Клипинг и вывод
.CLIP
            ld   bc,(RDY)
            ld   (RYX),bc
;  Найдем реальные координаты
            ld   de,(RDS)
            ld   a,(MIDY)
            bit  1,e
            jr   nz,$+4
            add  a,c
            add  a,c
            sub  c
            ld   (CY),a             ; Y от края окна
            ld   a,(MIDX)
            bit  0,e
            jr   z,$+4
            add  a,b
            add  a,b
            sub  b
            ld   (CX),a             ; X от края окна
;  Проверка где лежит центр круга
;  Вылетел ли он слева или справа,
;  Снизу или сверху центра окна
            ld   a,c
MY1
            cp   0
            ex   af,af'
            ld   a,b
MX81
            cp   0
            jp   nc,CPOX            ; Справа или слева
;  Пока на экране
            ex   af,af'
            jp   nc,CPOY            ; Сверху или снизу
;  Лежит на экране
            ld   a,b
            add  a,d
            jr   c,L873F            ; Вылет по х один
MX82
            cp   0
            jp   c,VFULL            ; Полностью видим по X
;  Один вылет по х
L873F
            ld   a,d
            sub  b
            jp   c,VPOX             ; Один вылет по х
MX83
            cp   0
            jp   c,VPOX             ; Один вылет по х


;  Вылет по х оба края

            ld   a,(MIDX0)
            sub  b
            neg
            inc  a

VPOXX
            ex   af,af'
            ld   a,(MIDX8)
            add  a,b

; a- коорд. X правого края
;  Получим Y коорд. этого края
            call CircleHalfWidth
            ld   (VY),a
            ld   b,a
            ld   a,(CY)
            call SkipRowsUp
            call PCOUNT3            ; 1
            call ADLOW
            ld   a,(RDS)
            bit  0,a
            call z,OUTRU
            call nz,OUTLU
            ld   a,(VY)
            ld   b,a
            ld   a,(CY)
            call SkipRowsDown
            call PCOUNT3            ; 1
            call ADLOW
            ld   a,(RDS)
            bit  0,a
            call z,OUTRD
            call nz,OUTLD
            ret


;  Центр вылетел за окно по х
CPOX
            ex   af,af'
            jp   nc,CPOXY           ; А еще и по у
;  ПО Х
            ld   a,b
MX84
            sub  0
            ld   b,a
            ld   a,d
            sub  b
            ret  c
            ret  z                  ; Вообще не видим
LENS
            sub  #F0
            jp   nc,L87F4           ; Оч большой радиус
            ld   a,b
MX88
            add  a,0
            ld   (RYX+1),a
            ld   b,a
            xor  a
            jp   VPOX_

L87F4
            ld   a,b
MX86
            add  a,0
            ld   b,a
            ld   (RYX+1),a
            xor  a
            jp   VPOXX              ; Вылет по обои стороны


;  Центр вылетел за окно по у
CPOY
            ld   a,c
MY2
            sub  0
            ld   c,a
            ld   (RYX),a
            ld   a,d
            sub  c
            ret  c                  ; Не видим
            ld   a,d
            call Square
            ld   h,d
            ld   l,e
            ld   a,c
            call Square
            sbc  hl,de
            ld   a,(MIDX8)
            sub  b
            call Square
            sbc  hl,de
            jp   c,L893F
            add  hl,de
            ld   a,(MIDX8)
            add  a,b
            call Square
            sbc  hl,de
            jp   nc,L884A


            ld   a,b
MX93
            sub  0
            inc  a
L88C5
            ex   af,af'
            ld   de,(RDS)
            ld   a,c
            call CircleHalfWidth
            ld   (VY),a
            ld   a,c
            exx
            ld   e,a
            ld   a,(VY)
            neg
            ld   c,a
            exx
            bit  0,e
            jr   z,L8910
            ld   a,(VY)
            cpl
MX11
            add  a,0
            add  a,b
            ld   c,#00
            bit  1,e
            jr   nz,L88EE
BRX1
            ld   c,0
L88EE
            call TKAD1
            ld   a,e
            and  #E0
SH1
            or   #1E
            ld   l,a
            ld   c,#01
            ld   a,(RDS)
            bit  1,a
            call nz,OUTLD
            call z,OUTLU
            ret


L8910
            ld   a,(VY)
MX1
            add  a,0
            sub  b
;        cp#08
;        retc
            ld   c,#00
            bit  1,e
            jr   nz,L8921
BRX2
            ld   c,0
L8921
            call TKAD2
            ld   a,l
            and  #E0
SL1
            or   #01
            ld   e,a
            ld   b,#80
            ld   a,(RDS)
            bit  1,a
            call nz,OUTRD
            call z,OUTRU
            ret


L893F
            ld   de,(RDS)
            ld   a,c
            call CircleHalfWidth
            ld   (VY),a
            ld   a,c
            exx
            ld   e,a
            ld   a,(VY)
            neg
            ld   c,a
            exx
            xor  a
            bit  1,e
            jr   nz,.L895B
            ld   a,(BRX)
.L895B
            ld   (CY),a
            ld   c,a
            ld   a,(VY)
            ld   l,a
            ld   a,(CX)
            sub  l
            call TKAD1
            ld   a,(CY)
            ld   c,a
            ld   a,(VY)
            ld   l,a
            ld   a,(CX)
            add  a,l
            call TKAD2
            ld   a,(RDS)
            bit  1,a
            call nz,OUTFD
            call z,OUTFU
            ret


L884A
            ld   a,b
MX91
            sub  0
            inc  a
L884D
            ex   af,af'
            ld   de,(RDS)
            ld   a,(MIDX8)
            add  a,b
            call CircleHalfWidth
            ld   (VY),a
            sub  c
            ld   b,a
            bit  1,e
            jr   z,.L8877
            xor  a
            call SkipRowsDown
            call PCOUNT3            ; 1
            call ADLOW
            ld   a,(RDS)
            bit  0,a
            call z,OUTRD
            call nz,OUTLD
            ret


.L8877
            ld   a,(BRX)
            call SkipRowsUp
            call PCOUNT3            ; 1
            call ADLOW
            ld   a,(RDS)
            bit  0,a
            call z,OUTRU
            call nz,OUTLU
            ret


;  Центр вылетел по х и по у за окно
CPOXY
            ld   a,b
MX85
            sub  0
            ld   b,a
            ld   a,c
MY3
            sub  0
            ld   c,a
            ld   (RYX),bc
            ld   a,d
            call Square
            ld   h,d
            ld   l,e
            ld   a,c
            call Square
            sbc  hl,de
            ret  c                  ; Радиус меньше у
            ld   a,b
            call Square
            sbc  hl,de
            ret  c                  ; Радиус меньше х
            add  hl,de
            ld   a,b
LENS2
            add  a,#F8
            jr   c,.L87BC
            call Square
            sbc  hl,de
            jp   nc,L8840
.L87BC
            ld   a,b
MX89
            add  a,0
            ld   (RYX+1),a
            ld   b,a
            xor  a
            jp   L88C5


L8840
            ld   a,b
MX87
            add  a,0
            ld   b,a
            ld   (RYX+1),a
            xor  a
            jp   L884D


;  Полностью вивим
VFULL
            call .L87D4
            call OUTFU
            call .L87D4
            jp   OUTFD

.L87D4
            ld   bc,(CY)
            ld   de,(RDS)
            ld   a,d
            neg
            exx
            ld   c,a
            ld   e,#00
            exx
            ld   a,b
            sub  d
            call TKAD1
            ld   a,(CY)
            ld   c,a
            ld   a,(CX)
            add  a,d
            jp   TKAD2


;  Вылет по х с одной стороны
VPOX
            ld   a,b
MX92
            sub  0
VPOX_
            ex   af,af'
            bit  0,e
            jr   z,.L88AC
;  Справа
            call .ADRH
            call OUTLD              ; Down part
            call .ADRH
            jp   OUTLU              ; UP PART
;  Слева
.L88AC
            call ADRL
            call OUTRD
            call ADRL
            jp   OUTRU


.ADRH
            call PCOUNT2
            ld   a,(CY)
            ld   c,a
            ld   a,(MIDX)
            add  a,b
            sub  d                  ; Mx+X-radius
            call TKAD1
            ld   a,e
            and  #E0
SH2
            or   #1E
            ld   l,a
            ld   c,#01
            ret


ADRL
            call PCOUNT2
            ld   a,(CY)
            ld   c,a
            ld   a,(MIDX)
            add  a,d
            sub  b                  ; Mx+radius-X
            call TKAD2
            ld   a,l
            and  #E0
SL2
            or   #01
            ld   e,a
            ld   b,#80
            ret


PCOUNT2
            ld   bc,(RYX)
            ld   de,(RDS)
            ld   a,d
            neg
            exx
            ld   c,a
            ld   e,#00
            exx
            ret


.PCOUNT1
            ld   bc,(RYX)
            ld   a,(MIDX0)
            sub  b
            exx
            ld   c,a
            ld   a,(VY)
            ld   e,a
            exx
            ret


PCOUNT3
            ld   bc,(RYX)
            ld   a,(MIDX)
            add  a,b
            neg
            exx
            ld   c,a
            ld   a,(VY)
            ld   e,a
            exx
            ret


;  Вывод левой половины
OUTL
;  Проц. вывода, проверка адреса на вылет
            ld   a,(UPDWN)
            and  a
            jr   nz,.L9074

            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADL)
            SUB_DE
            ld   e,a
            pop  hl

            jr   nz,.L907B
            jr   .L9079
.L9074

            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADH)
            SUB_DE
            ld   e,a
            pop  hl

            jr   nz,.L907B

.L9079
            pop  af
            ret
.L907B
            ld   (STK_L),sp
.L907F
            ld   d,l
            ld   l,e
            ld   a,b
            LDX_HL_A
            ld   l,d
            ld   a,(UPDWN)
            and  a
            jr   nz,.L9090
            call LINUP
            jr   .L9093
.L9090
            call LINDOWN
.L9093
            exx
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx
            jr   nz,.L907F
            rrc  b
            jr   c,.L90B0
.L90A0
            exx
            add  hl,bc
            inc  c
            ex   af,af'
            cp   c
            jr   z,.L90B7
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx
            jr   nz,.L907F
            jr   .L90CC
.L90B0
            inc  e
            ld   a,l
            sub  e
            jr   c,.L90BF
            jr   .L90A0
.L90B7
            ex   af,af'
            jp   L914B
.L90BB
            ex   af,af'
            jp   L9191
.L90BF
            ld   sp,(STK_L)
            pop  af
            ret
.L90C5
            inc  e
            ld   a,l
            sub  e
            jr   c,.L90BF
            jr   .L90D6
.L90CC
            ld   d,l
            ld   l,e
            ld   a,b
            LDX_HL_A
            ld   l,d
            rrc  b
            jr   c,.L90C5
.L90D6
            exx
            add  hl,bc
            inc  c
            jr   z,.L90BF
            ex   af,af'
            cp   c
            jr   z,.L90BB
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx
            jr   z,.L90CC
            exx
            add  hl,de
            inc  e
            add  hl,de
            exx
            ld   a,(UPDWN)
            and  a
            jr   nz,.L90F6
            call LINUP
            jr   .L90CC
.L90F6
            call LINDOWN
            jr   .L90CC


;  Вывод полностью
;  Проц. вывода, проверка адреса на вылет
OUTFULL
            ld   a,e
            sub  l
            jr   nc,.L9111
            ld   a,(UPDWN)
            and  a
            jr   nz,.L910C

            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADL)
            SUB_DE
            ld   e,a
            pop  hl

            jr   nz,.L9113
            jr   .L9111
.L910C
            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADH)
            SUB_DE
            ld   e,a
            pop  hl

            jr   nz,.L9113
.L9111
            pop  af
            ret
.L9113
            ld   (STK_L),sp
L9117
            ld   a,c
            LDX_HL_A
            ld   d,l
            ld   l,e
            ld   a,b
            LDX_HL_A
            ld   l,d
            ld   a,(UPDWN)
            and  a
            jr   nz,.L912F
            call LINUP
            jr   .L9136
.L912F
            call LINDOWN
.L9136
            exx
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx
            jp   nz,L9117
            rrc  b
            jr   c,L9155
L9144
            rlc  c
            jr   c,L915D
L9148
            exx
            add  hl,bc
            inc  c
L914B
            add  hl,bc
            bit  7,h
            exx
            jp   nz,L9117
            jp   L917B
L9155
            inc  e
            ld   a,l
            sub  e
            jp   nz,L9144
            ld   sp,(STK_L)
            pop  af
            ret
L915D
            dec  l
            ld   a,l
            sub  e
            jp   nz,L9148
L9165
            ld   sp,(STK_L)
            pop  af
            ret


L916B
            inc  e
            ld   a,l
            sub  e
            jp   nz,L9188
            jr   L91AC
L9173
            dec  l
            ld   a,l
            sub  e
            jp   nz,L918C
            jr   L91C0
L917B
            ld   a,c
            LDX_HL_A
            ld   d,l
            ld   l,e
            ld   a,b
            LDX_HL_A
            ld   l,d
            rrc  b
            jr   c,L916B
L9188
            rlc  c
            jr   c,L9173
L918C
            exx
            add  hl,bc
            inc  c
            jr   z,L91D1
L9191
            add  hl,bc
            bit  7,h
            exx
            jr   z,L917B
            exx
            add  hl,de
            inc  e
            add  hl,de
            exx
            ld   a,(UPDWN)
            and  a
            jr   nz,.L91A7
            call LINUP
            jr   L917B
.L91A7
            call LINDOWN
            jr   L917B
L91AC
            ld   l,e
            ld   a,(hl)
            ld   b,#00
            and  a
            jr   z,L91CD
            ld   b,a
            ld   a,#FF
L91B6
            srl  b
INV1
            jr   c,.L91BD
            add  a,a
            jr   L91B6
.L91BD
            cpl
            LDX_HL_A
            jr   L91CE
L91C0
            ld   a,(hl)
            ld   b,0
            and  a
            jr   z,L91CD
            dec  b
L91C6
            add  a,a
INV2
            jr   c,L91CD
            srl  b
            jr   L91C6
L91CD
            ld   a,b
            cpl
            LDX_HL_A
L91CE
            jp   L9165

L91D1
            exx
            ld   a,(hl)
            and  a
            jr   z,L91E2
            ld   b,a
            ld   a,#FF
L91D9
            srl  b
INV3
            jr   c,L91E2
            add  a,a
            jr   L91D9
L91E2
            cpl
            LDX_HL_A
            ld   l,e
            ld   a,(hl)
            ld   b,#00
            and  a
            jr   z,L91F1
            dec  b
L91EA
            add  a,a
INV4
            jr   c,L91F1
            srl  b
            jr   L91EA
L91F1
            ld   a,b
            cpl
            LDX_HL_A
            jr   L91CE


;  Вывод правой половины
OUTR
            ld   a,(UPDWN)
            and  a
            jr   nz,.L9208
            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADL)
            SUB_DE
            ld   e,a
            pop  hl

            jr   nz,.L920F
            jr   .L920D
.L9208
            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADH)
            SUB_DE
            ld   e,a
            pop  hl

            jr   nz,.L920F
.L920D
            pop  af
            ret

.L920F
            ld   (STK_L),sp
.L9213
            ld   a,c
            LDX_HL_A
            ld   a,(UPDWN)
            and  a
            jr   nz,.L9221
            call LINUP
            jr   .L9224

.L9221
            call LINDOWN
.L9224
            exx
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx
            jr   nz,.L9213
            rlc  c
            jr   c,.L9241
.L9231
            exx
            add  hl,bc
            inc  c
            ex   af,af'
            cp   c
            jr   z,.L9249
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx
            jr   nz,.L9213
            jr   .L925F
.L9241
            dec  l
            ld   a,l
            sub  e
            inc  a
            jr   z,.L9251
            jr   .L9231
.L9249
            ex   af,af'
            jp   L914B
.L924D
            ex   af,af'
            jp   L9191
.L9251
            ld   sp,(STK_L)
            pop  af
            ret
.L9257
            dec  l
            ld   a,l
            sub  e
            inc  a
            jr   z,.L9251
            jr   .L9266
.L925F
            ld   a,c
            LDX_HL_A
            rlc  c
            jr   c,.L9257
.L9266
            exx
            add  hl,bc
            inc  c
            jr   z,.L9251
            ex   af,af'
            cp   c
            jr   z,.L924D
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx
            jr   z,.L925F
            exx
            add  hl,de
            inc  e
            add  hl,de
            exx
            ld   a,(UPDWN)
            and  a
            jr   nz,.L9286
            call LINUP
            jr   .L925F
.L9286
            call LINDOWN
            jr   .L925F


TKAD1
            ld   l,c
            ld   c,a

            ld   h,high(TBXX2_)
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            add  a,(hl)
            inc  h
            ld   l,a
            ld   h,b
            ld   a,c

            and  7
            ld   b,#01
            inc  a
            rrc  b
            dec  a
            jr   nz,$-3
            ld   e,l
            ret


TKAD2
            push af
            ld   a,b
            ld   (MASK),a
            pop  af
            ld   l,c
            ld   c,a

            ld   h,high(TBXX2_)
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            add  a,(hl)
            inc  h
            ld   l,a
            ld   h,b
            ld   a,c

            and  7
            sub  #08
            neg
            ld   c,#80
            rlc  c
            dec  a
            jr   nz,$-3
            ld   a,(MASK)
            ld   b,a
            ret

CircleHalfWidth   ; orig: TAKECRD
; X = sqrt(r^2 - Y^2) для окружности
;  Подсчет X=sqr(r^2-Y^2)
; d=r,a=Y
; reta=X
            push bc
            push de
            push hl
            push af
            ld   a,d
            call Square
            ld   h,d
            ld   l,e
            pop  af
            call Square
            sbc  hl,de
            ld   b,#80
            xor  a
            ld   (VAR1),hl
.L8AE3
            ld   hl,(VAR1)
            add  a,b
            call Square
            sbc  hl,de
            jr   nc,$+3
            sub  b
            srl  b
            jr   nc,.L8AE3
            pop  hl
            pop  de
            pop  bc
            ret


LINUP
            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADL)
            SUB_DE
            ld   e,a
            pop  hl

            jr   z,.E_O1
            ld   a,h
            dec  h
            and  7
            jp   nz,$+17
            ld   a,l
            sub  #20
            ld   l,a
            ld   a,e
            sub  #20
            ld   e,a
            jr   c,$+6
            ld   a,h
            add  a,8
            ld   h,a
            ret
.E_O1
            pop  af
            ld   sp,(STK_L)
            pop  af
            ret


LINDOWN
            inc  h
            ld   a,h
            and  7
            jp   nz,$+17
            ld   a,e
            add  a,32
            ld   e,a
            NEXTZNAK

            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   a,e
            ld   de,(ADH)
            SUB_DE
            ld   e,a
            pop  hl

            ret  nz

            pop  af
            ld   sp,(STK_L)
            pop  af
            ret


ADLOW
            ld   a,l
            and  #E0
SL3
            or   #01
            ld   e,a
            ld   c,#01
            ld   b,#80
            ret


SkipRowsUp   ; orig: MISLNUP
; Пропустить строки сверху
; a-Y
; b-кол. строк пропустить вверх
            ld   c,a
            ld   a,c
            push af
            push bc
            ld   l,a

            ld   h,high(TBXX2_)
            ld   b,(hl)
            inc  h
            ld   a,(hl)
SH3
            or   0
            ld   l,a
            ld   h,b

            pop  bc

            push bc
            dec  b
            inc  b
            jr   z,.L901C
.L9014
            ld   a,h
            dec  h
            and  7
            jr   z,.L902B
.L901A
            djnz .L9014
.L901C
            pop  bc
            pop  af
            ret
.L902B
            inc  h
            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   de,(ADL)
            SUB_DE
            pop  hl
            jr   z,.L901C

            dec  h
            ld   a,l
            sub  #20
            ld   l,a
            jr   c,$+6
            ld   a,h
            add  a,8
            ld   h,a

            djnz .L9014
            jr   .L901C


SkipRowsDown   ; orig: MISLNDN
; Пропустить строки снизу
; a-Y
; b-кол. строк пропустить вниз
            ld   c,a
            ld   a,c
            push af
            push bc
            ld   l,a

            ld   h,high(TBXX2_)
            ld   b,(hl)
            inc  h
            ld   a,(hl)
SH4
            or   0
            ld   l,a
            ld   h,b

            pop  bc

            push bc
            dec  b
            inc  b
            jr   z,.L904A


.L9042
            inc  h
            ld   a,h
            and  7
            jr   z,.L904D
.L9048
            djnz .L9042
.L904A
            pop  bc
            pop  af
            ret
.L904D
            NEXTZNAK

            push hl
            ld   a,l
            and  #E0
            ld   l,a
            ld   de,(ADH)
            SUB_DE
            pop  hl
            jr   z,.L904A

            djnz .L9042
            jr   .L904A


Square   ; orig: XQUAD
; Квадрат числа A: DE = A^2
;  Берем квадрат от "A"
; retinde= a^2
            push hl
            ld   h,high(LBE00)
            ld   l,a
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            pop  hl
            ret


KK_1
            exx
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx
            ld   a,#01
            ld   (UPDWN),a
            ret
KK_0
            exx
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx
            xor  a
            ld   (UPDWN),a
            ret


OUTLD
            push af
            call KK_1
            jp   OUTL


OUTLU
            push af
            call KK_0
            jp   OUTL


OUTRD
            push af
            call KK_1
            jp   OUTR


OUTRU
            push af
            call KK_0
            jp   OUTR


OUTFD
            push af
            call KK_1
            jp   OUTFULL


OUTFU
            push af
            call KK_0
            jp   OUTFULL


; ────────────────────────────────────────
NAME
;  Генерация имени системы
; hl,de-данные системы
;  В TNAME-имя 0-конец
            ld   a,e
            and  #0F
            exx
;  Делаем выбор из названий греческих букв
            ld   hl,NAMTAB
            call FindTextByIndex
            ld   de,TNAME
            ldi
            ld   a,(hl)
            cp   ET
            jr   nz,$-5
            ld   a,"-"
            ld   (de),a
            inc  de
            exx
            ld   a,e
            and  #F0
            ld   e,a
            ld   a,h
            and  #0F
            or   e
            exx
            call .NUMTXT
            ld   a,"/"
            ld   (de),a
            inc  de
            exx
            ld   a,h
            and  #F0
            ld   h,a
            ld   a,d
            and  #0F
            or   h
            exx
            call .NUMTXT
            ld   a,"-"
            ld   (de),a
            inc  de
            exx
            ld   a,d
            and  #F0
            rrca
            rrca
            rrca
            rrca
            add  a,128
            exx
            ld   (de),a
            inc  de
            ld   a,ET
            ld   (de),a
            ret

;  Перевод числа до 3 знаков в текст в de
;  Число в a
.NUMTXT
            ld   b,#FF
            inc  b
            sub  100
            jr   nc,$-3
            add  a,100
            ld   c,a
            ld   a,b
            or   a
            jr   z,$+6
            add  a,"0"
            ld   (de),a
            inc  de
            ld   a,c
            ld   b,#FF
            inc  b
            sub  10
            jr   nc,$-3
            add  a,10
            ld   c,a
            ld   a,b
            or   a
            jr   z,$+6
            add  a,"0"
            ld   (de),a
            inc  de
            ld   a,c
            add  a,"0"
            ld   (de),a
            inc  de
            ret


NAMTAB:     include "gen/NAMTAB.inc"   ; GENERATED from assets/text/star_names.txt


FindStateAtMap   ; orig: GOSTA
; Номер государства по координатам карты
;  Найти в каком гос. находится карта
; hl-коорд. карты
; Reta-номер государства
; 0-Галактич. федерация
; 1-Конф.первых
; 2-Содруж.миров
; 3-Свободн.земли
            ld   a,h
            cp   74
            jr   c,.NGF1
            cp   78
            jr   nc,.NGF1
            ld   a,l
            cp   54
            jr   c,.NGF1
            cp   58
            ld   a,0                ; Галакт. федер.
            ret  c
.NGF1
            ld   a,h
            cp   71
            jr   c,.NGF2
            cp   74
            jr   nc,.NGF2
            ld   a,l
            cp   52
            jr   c,.NGF2
            cp   56
            ld   a,1                ; Содр. миров
            ret  c
.NGF2
            ld   a,h
            cp   71
            ld   a,3
            ret  c
            ld   a,h
            cp   74
            ld   a,3
            ret  nc
            ld   a,l
            cp   56
            ld   a,3
            ret  c
            ld   a,l
            cp   59
            ld   a,2                ; Конф.первых
            ret  c
            ld   a,3
            ret


StarDistance   ; orig: FARER
; Расстояние от звезды
;  Измерение расстояния от звезды
;  В de,всдо звезды
;  В DE',BC'
; a-результат
; FZ-on тажа звезда
            push hl
            push ix
            push iy
            exx
            push hl
            exx
            ld   a,b
            ld   b,e
            ld   e,a
            exx
            ld   a,c
            exx
            ld   l,a
            exx
            ld   a,e
            exx
            ld   h,a
            SUB_BC
            jp   p,$+10
            NEGHL
            ld   b,h
            ld   c,l
; bc-DX
            exx
            ld   a,b
            exx
            ld   l,a
            exx
            ld   a,d
            exx
            ld   h,a
            SUB_DE
            jp   p,$+10
            NEGHL
; hl-DY
            ld   a,l
            or   h
            or   c
            or   b

            jr   z,.EXM1             ; Если нуль

            push bc
            ld   d,h
            ld   e,l
            call MUll
            pop  bc
            ld   a,l
            or   h
            jr   nz,.NOF
            push de
            ld   d,b
            ld   e,c
            ld   h,b
            ld   l,c
            call MUll
            ld   a,l
            or   h
            pop  hl
            jr   nz,.NOF
            add  hl,de
            jr   c,.NOF

            xor  a
            ld   a,h
            ex   af,af'
            ld   a,l
            ex   af,af'
            ld   de,9
            ld   hl,0
            call DIvv

            EXD
            call .KORNI
            or   a
            jr   nz,$+3
            inc  a
.EXM1
            exx
            pop  hl
            exx
            pop  iy
            pop  ix
            pop  hl
            ret
.NOF
            ld   a,#FF
            jr   .EXM1


.KORNI
; de-старшая часть числа
; reta-MEAN
            ld   a,d
            and  a
            jr   z,.Kor
            ld   l,a
            ld   h,high(Korn)
            ld   a,(hl)
            inc  h
            ld   c,a
            cpl
            ex   af,af'
            ld   b,#FF
            inc  bc
            sla  c
            rl   b
            dec  bc
            ld   a,(hl)
            inc  h
            ld   h,(hl)
            ld   l,a
            ex   af,af'
            add  hl,de
            rept 5
            add  hl,bc
            ret  nc
            dec  bc
            dec  bc
            inc  a
            endr
            add  hl,bc
            ret  nc
            inc  a
            ret


.Kor
;  Подсчет корня без таблицы, для маленьк
;  Их данных
; de-DATA <2116
; a-MEAN
            EXD
            ld   bc,0-1
            xor  a
            rept 14
            add  hl,bc
            ret  nc
            inc  a
            dec  bc
            dec  bc
            endr
            add  hl,bc
            ret  nc
            inc  a
            ret


            ADRXX00
LBE00
            incbin "0E0200.d"; #200

Korn
            incbin "KORNI.d" ; #300


TBXX2_      equ  $
KR1         equ  TBXX2_+#400
KR2         equ  KR1+#100
KR3         equ  KR2+#100
KR4         equ  KR3+#100
DOTB        equ  KR4+#100           ; 200
DOTCO       equ  DOTB+#200
DOTCLP      equ  DOTCO+#100

END_K       equ  DOTCLP+#100
