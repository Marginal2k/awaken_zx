■CLIP
■CLIPLINE
■MATRX
■PMATRX
■MULL
■DIVHLDE
















CLIP:
КЛИППИРОВАИНЕ ПЛОСКОСТИ
■ b-КОЛИЧЕСТВО УЗЛОВ
■ hl-ВЕКТОР НОМЕРОВ УЗЛОВ
            xor  a
            ld   (F_POL_LIN),a
            ld   (LOW_CORDS_BUF),a
            ld   (F_ACTING),a
            push hl
            ld   a,b
            dec  a
            add  a,l
            ld   l,a
            ld   a,h
            adc  a,0
            ld   h,a
            ld   l,(hl)
            ld   h,L9C
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (_X1),de
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (_Y1),de
            ld   a,(hl)
            ld   (_F1),a
X8B2        ld   hl,(_X1)
            ld   (_X0),hl
            ld   hl,(_Y1)
            ld   (_Y0),hl
            ld   a,(_F1)
            ld   (_F0),a
            pop  hl
            ld   a,(hl)
            inc  hl
            push hl
            push bc
            ld   l,a
            ld   h,L9C
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (_X1),de
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (_Y1),de
            ld   a,(hl)
            ld   (_F1),a
            ld   a,(_F0)
            cpl
            and  #F0
            ld   l,a
            ld   a,(_F1)
            and  #0F
            or   l
            ld   l,a
            ld   h,L95.h
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            EXD
            ld   de,$+5
            push de
            jp   (hl)
            pop  bc
            djnz X8B2
            pop  hl
            ld   a,(LOW_CORDS_BUF)
            cp   #06
X902        ret
X903        call DXaY
X906        call aXDY
X909        call aY_aX
            jpm  C_XY_DXaY+3
            call C_XY_aXDY+3
X912        ld   hl,F_ACTING
            bit  0,(hl)
            jpnz SET_XaYa
            set  0,(hl)
            ret
X91D        call DXaY
X920        call iXDY
X923        call aY_iX
            jpm  C_XY_iXDY+3
            call C_XY_DXaY+3
X92C        ld   hl,F_ACTING
            bit  1,(hl)
            jpnz SET_XiYa
            set  1,(hl)
            ret
X937        call DXiY
X93A        call aXDY
X93D        call iY_aX
            jpm  C_XY_aXDY+3
            call C_XY_DXiY+3
X946        ld   hl,F_ACTING
            bit  2,(hl)
            jpnz SET_XaYi
            set  2,(hl)
            ret
X951        call DXiY
X954        call iXDY
X957        call iY_iX
            jpm  C_XY_DXiY+3
            call C_XY_iXDY+3
X960        ld   hl,F_ACTING
            bit  3,(hl)
            jpnz SET_XiYi
            set  3,(hl)
            ret
X96B        call C_XY_aXDY
            jp   STOR_Y1_X1
X971        call C_XY_aXDY
            jp   C_XY_iXDY
X977        call aXDY
X97A        call DXaY
            call aY_aX
            jpp  SET_XaYa
            call C_XY_aXDY+3
            jp   C_XY_DXaY+3
X989        call aXDY
X98C        call DXaY
            call aY_aX
            jpm  X99B
            call SET_XaYa
            jp   X92C
X99B        call C_XY_aXDY+3
            jp   X920
X9A1        call aXDY
X9A4        call DXiY
            call iY_aX
            jpm  _BREAK
            call C_XY_aXDY+3
            jp   C_XY_DXiY+3
X9B3        call X1_X0
            jpm  _BREAK
            ret
X9BA        call aXDY
X9BD        call DXiY
            call iY_aX
            jpm  _BREAK
            call C_XY_aXDY+3
            jp   X954
X9CC        call C_XY_iXDY
            jp   STOR_Y1_X1
X9D2        call C_XY_iXDY
            jp   C_XY_aXDY
X9D8        call iXDY
X9DB        call DXaY
            call aY_iX
            jpm  _BREAK
            call C_XY_iXDY+3
            jp   C_XY_DXaY+3
X9EA        call iXDY
X9ED        call DXaY
            call aY_iX
            jpm  _BREAK
            call C_XY_iXDY+3
            jp   X906
X9FC        call X1_X0
            jpp  _BREAK
            ret
XA03        call iXDY
XA06        call DXiY
            call iY_iX
            jpp  SET_XiYi
            call C_XY_iXDY+3
            jp   C_XY_DXiY+3
XA15        call iXDY
XA18        call DXiY
            call iY_iX
            jpm  XA27
            call SET_XiYi
            jp   X946
XA27        call C_XY_iXDY+3
            jp   X93A
XA2D        call C_XY_DXaY
            jp   STOR_Y1_X1
XA33        call DXaY
XA36        call aXDY
            call aY_aX
            jpm  _BREAK
            call C_XY_DXaY+3
            jp   C_XY_aXDY+3
XA45        call DXaY
XA48        call iXDY
            call aY_iX
            jpp  SET_XiYa
            call C_XY_DXaY+3
            jp   C_XY_iXDY+3
XA57        call Y1_Y0
            jpm  _BREAK
            ret
XA5E        call C_XY_DXaY
            jp   C_XY_DXiY
XA64        call DXaY
XA67        call aXDY
            call aY_aX
            jpm  _BREAK
            call C_XY_DXaY+3
            call DXiY
            jp   X93D
XA79        call DXaY
XA7C        call iXDY
            call aY_iX
            jpm  XA8B
            call SET_XiYa
            jp   X960
XA8B        call C_XY_DXaY+3
            call DXiY
            jp   X957
XA94        call DXaY
            call aXDY
            call aY_aX
            jpm  XC13
            ld   hl,F_ACTING
            bit  0,(hl)
            set  0,(hl)
            call nz,SET_XaYa
XAAA        call C_XY_DXaY+3
            jp   STOR_Y1_X1
XAB0        call X1_X0
            jpp  _BREAK
            ret
XAB7        call DXaY
            call aXDY
            call aY_aX
            jpm  XAD0
            ld   hl,F_ACTING
            bit  0,(hl)
            set  0,(hl)
            call nz,SET_XaYa
            jp   XA48
XAD0        call C_XY_aXDY+3
            jp   C_XY_iXDY
XAD6        ld   hl,F_ACTING
            bit  0,(hl)
            jpnz SET_XaYa
            set  0,(hl)
            ret
XAE1        call XAD6
            jp   X92C
XAE7        call DXaY
            call aXDY
            call aY_aX
            jpm  X9A4
            call XAD6
            call C_XY_DXaY+3
            jp   C_XY_DXiY
XAFC        call DXaY
            call aXDY
            call aY_aX
            jpm  X9BD
            ld   hl,F_ACTING
            bit  0,(hl)
            set  0,(hl)
            call nz,SET_XaYa
            jp   XA7C
XB15        call DXaY
            call iXDY
            call aY_iX
            jpm  XAAA
            ld   hl,F_ACTING
            bit  1,(hl)
            set  1,(hl)
            call nz,SET_XiYa
XB2B        call C_XY_iXDY+3
            jp   STOR_Y1_X1
XB31        call DXaY
            call iXDY
            call aY_iX
            jpm  XA36
            call XB46
            call C_XY_iXDY+3
            jp   C_XY_aXDY
XB46        ld   hl,F_ACTING
            bit  1,(hl)
            jpnz SET_XiYa
            set  1,(hl)
            ret
XB51        call Y1_Y0
            jpp  _BREAK
            ret
XB58        call DXaY
            call iXDY
            call aY_iX
            jpm  XB71
            ld   hl,F_ACTING
            bit  1,(hl)
            set  1,(hl)
            call nz,SET_XiYa
            jp   XA06
XB71        call C_XY_DXaY+3
            jp   C_XY_DXiY
XB77        call DXaY
            call iXDY
            call aY_iX
            jpm  XA67
            ld   hl,F_ACTING
            bit  1,(hl)
            set  1,(hl)
            call nz,SET_XiYa
            jp   XA18
XB90        call XB46
            jp   X960
XB96        call C_XY_DXiY
            jp   STOR_Y1_X1
XB9C        call DXiY
XB9F        call aXDY
            call iY_aX
            jpp  SET_XaYi
            call C_XY_DXiY+3
            jp   C_XY_aXDY+3
XBAE        call DXiY
XBB1        call iXDY
            call iY_iX
            jpm  _BREAK
            call C_XY_DXiY+3
            jp   C_XY_iXDY+3
XBC0        call C_XY_DXiY
            jp   C_XY_DXaY
XBC6        call DXiY
XBC9        call aXDY
            call iY_aX
            jpm  XBD8
            call SET_XaYi
            jp   X912
XBD8        call C_XY_DXiY+3
            call DXaY
            jp   X909
XBE1        call DXiY
XBE4        call iXDY
            call iY_iX
            jpm  _BREAK
            call C_XY_DXiY+3
            call DXaY
            jp   X923
XBF6        call Y1_Y0
            jpp  _BREAK
            ret
XBFD        call DXiY
            call aXDY
            call iY_aX
            jpm  XC94
            ld   hl,F_ACTING
            bit  2,(hl)
            set  2,(hl)
            call nz,SET_XaYi
XC13        call C_XY_aXDY+3
            jp   STOR_Y1_X1
XC19        ld   hl,F_ACTING
            bit  2,(hl)
            jpnz SET_XaYi
            set  2,(hl)
            ret
XC24        call DXiY
            call aXDY
            call iY_aX
            jpm  XBB1
            call XC19
            call C_XY_aXDY+3
            jp   C_XY_iXDY
XC39        call DXiY
            call aXDY
            call iY_aX
            jpm  XC52
            ld   hl,F_ACTING
            bit  2,(hl)
            set  2,(hl)
            call nz,SET_XaYi
            jp   X97A
XC52        call C_XY_DXiY+3
            jp   C_XY_DXaY
XC58        call XC19
            jp   X912
XC5E        call DXiY
            call aXDY
            call iY_aX
            jpm  XBE4
            ld   hl,F_ACTING
            bit  2,(hl)
            set  2,(hl)
            call nz,SET_XaYi
            jp   X98C
XC77        call Y1_Y0
            jpm  _BREAK
            ret
XC7E        call DXiY
            call iXDY
            call iY_iX
            jpm  XB2B
            ld   hl,F_ACTING
            bit  3,(hl)
            set  3,(hl)
            call nz,SET_XiYi
XC94        call C_XY_DXiY+3
            jp   STOR_Y1_X1
XC9A        call DXiY
            call iXDY
            call iY_iX
            jpm  XCB3
            ld   hl,F_ACTING
            bit  3,(hl)
            set  3,(hl)
            call nz,SET_XiYi
            jp   XB9F
XCB3        call C_XY_iXDY+3
            jp   C_XY_aXDY
XCB9        call X1_X0
            jpm  _BREAK
            ret
XCC0        call DXiY
            call iXDY
            call iY_iX
            jpm  X9DB
            call XCEE
            call C_XY_DXiY+3
            jp   C_XY_DXaY
XCD5        call DXiY
            call iXDY
            call iY_iX
            jpm  X9ED
            ld   hl,F_ACTING
            bit  3,(hl)
            set  3,(hl)
            call nz,SET_XiYi
            jp   XBC9
XCEE        ld   hl,F_ACTING
            bit  3,(hl)
            jpnz SET_XiYi
            set  3,(hl)
            ret
XCF9        call XCEE
            jp   X946

;DX*(MIN-Y0)
DXiY        ld   bc,(_X1)
            ld   hl,(_X0)
            SUB_BC
            EXD
            ld   bc,0
            ld   hl,(_Y0)
            SUB_BC
            call MULL
            ld   (_DXiY),de
            ld   (_DXiY+2),hl
            ret
;DX*(MAX-Y0)
DXaY        ld   bc,(_X1)
            ld   hl,(_X0)
            SUB_BC
            EXD
            ld   bc,YEND
            ld   hl,(_Y0)
            SUB_BC
            call MULL
            ld   (_DXaY),de
            ld   (_DXaY+2),hl
            ret
;(MIN-X0)*DY
iXDY        ld   bc,0
            ld   hl,(_X0)
            SUB_BC
            EXD
            ld   bc,(_Y1)
            ld   hl,(_Y0)
            SUB_BC
            call MULL
            ld   (_iXDY),de
            ld   (_iXDY+2),hl
            ret
;(MAX-X0)*DY
aXDY        ld   bc,#00FF
            ld   hl,(_X0)
            SUB_BC
            EXD
            ld   bc,(_Y1)
            ld   hl,(_Y0)
            SUB_BC
            call MULL
            ld   (_aXDY),de
            ld   (_aXDY+2),hl
            ret

C_XY_DXiY   call DXiY
            ld   a,(_DXiY)
            exa
            ld   a,(_DXiY+1)
            ld   hl,(_Y1)
            ld   de,(_Y0)
            SUB_DE
            EXD
            ld   hl,(_DXiY+2)
            call DIVHLDE
            ld   de,(_X0)
            add  hl,de
            ld   a,h
            and  a
            jrz  $+23
            jpp  $+19
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            xor  a
            ld   (hl),a
            inc  l
            ld   (hl),a
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
            ld   l,#FF
            ld   e,l
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),e
            inc  l
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
C_XY_DXaY   call DXaY
            ld   a,(_DXaY)
            exa
            ld   a,(_DXaY+1)
            ld   hl,(_Y1)
            ld   de,(_Y0)
            SUB_DE
            EXD
            ld   hl,(_DXaY+2)
            call DIVHLDE
            ld   de,(_X0)
            add  hl,de
            ld   a,h
            and  a
            jrz  $+24
            jpp  $+20
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),0
            inc  l
            ld   (hl),YEND
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
            ld   l,#FF
            ld   e,l
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),e
            inc  l
            ld   (hl),YEND
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
C_XY_iXDY   call iXDY
            ld   a,(_iXDY)
            exa
            ld   a,(_iXDY+1)
            ld   hl,(_X1)
            ld   de,(_X0)
            SUB_DE
            EXD
            ld   hl,(_iXDY+2)
            call DIVHLDE
            ld   de,(_Y0)
            add  hl,de
            ld   a,h
            and  a
            jpm  IO1
            ld   a,l
            and  a
            jpp  IO2
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),0
            inc  l
            ld   (hl),YEND
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
IO1
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            xor  a
            ld   (hl),a
            inc  l
            ld   (hl),a
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
IO2
            ld   d,l
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),0
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
C_XY_aXDY   call aXDY
            ld   a,(_aXDY)
            exa
            ld   a,(_aXDY+1)
            ld   hl,(_X1)
            ld   de,(_X0)
            SUB_DE
            EXD
            ld   hl,(_aXDY+2)
            call DIVHLDE
            ld   de,(_Y0)
            add  hl,de
            ld   a,h
            and  a
            jpm  IO4
            ld   a,l
            and  a
            jpp  IO3
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),#FF
            inc  l
            ld   (hl),YEND
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
IO4
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),#FF
            inc  l
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
IO3
            ld   d,l
            ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),#FF
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
SET_XiYi    ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,0
            jp   STOR_YX_DE
SET_XaYi    ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,#00FF
            jp   STOR_YX_DE
SET_XiYa    ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,YEND.e
            jp   STOR_YX_DE
SET_XaYa    ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,YEND.e+#FF
            jp   STOR_YX_DE
iY_iX
            ld   hl,(_DXiY)
            ld   bc,(_iXDY)
            SUB_BC
            ld   hl,(_DXiY+2)
            ld   bc,(_iXDY+2)
            sbc  hl,bc
            ret
iY_aX
            ld   hl,(_DXiY)
            ld   bc,(_aXDY)
            SUB_BC
            ld   hl,(_DXiY+2)
            ld   bc,(_aXDY+2)
            sbc  hl,bc
            ret
aY_iX
            ld   hl,(_DXaY)
            ld   bc,(_iXDY)
            SUB_BC
            ld   hl,(_DXaY+2)
            ld   bc,(_iXDY+2)
            sbc  hl,bc
            ret
aY_aX
            ld   hl,(_DXaY)
            ld   bc,(_aXDY)
            SUB_BC
            ld   hl,(_DXaY+2)
            ld   bc,(_aXDY+2)
            sbc  hl,bc
            ret
X1_X0       ld   hl,(_X1)
            ld   de,(_X0)
            SUB_DE
            ret
Y1_Y0       ld   hl,(_Y1)
            ld   de,(_Y0)
            SUB_DE
            ret
STOR_Y1_X1  ld   a,(_X1)
            ld   e,a
            ld   a,(_Y1)
            ld   d,a
STOR_YX_DE  ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
_BREAK      pop  af,bc,hl
            ld   c,b
            dec  c
            ld   b,0
            add  hl,bc
            scf
            ret



УМНОЖЕНИЕ HLDE=hl*de
MULL:
            ld   a,h
            xor  d
            exa
            ABSHL
            ld   a,d
            or   a
            jpp  $+11
            cpl
            ld   d,a
            ld   a,e
            cpl
            ld   e,a
            inc  de
            ld   a,d
            or   a
            jpz  XFDA
            ld   a,h
            and  a
            jpz  XFDF
            cp   d
            jrc  $+4:EXD:ld a,h
            ld   b,l
            ld   hl,0:ld c,l
            rlca
            rla:jrc $+21
            rla:jrc $+24
            rla:jrc $+27
            rla:jrc $+30
            rla:jrc $+33
            rla:jrc $+36
            rla:jp $+39
            add  hl,de:adc a,c
 rept 6:add hl,hl:rla:jrnc $+4:add hl,de:adc a,c:endr
            ld   c,a:ld a,b
            ld   b,c:ld c,0
 rept 8:add hl,hl:rla:jrnc $+4:add hl,de:adc a,c:endr
            ld   e,a:ld d,b
            EXD
XFBE        exa
            ret  p
            ld   b,h
            ld   c,l
            ld   hl,0
            sbc  hl,de
            EXD
            ld   hl,0
            sbc  hl,bc
            ret

XFDA        ld   a,h
            and  a
            jrz  LD030
            EXD
XFDF        ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jrc  $+26
            add  a,a
            jrc  $+29
            add  a,a
            jrc  $+32
            add  a,a
            jrc  $+35
            add  a,a
            jrc  $+38
            add  a,a
            jrc  $+41
            add  a,a
            jrc  $+44
            add  a,a
            jrc  $+47
            jp   $+47
            rept 7:add hl,de:adc a,c:add hl,hl:adc a,a:jrnc $+4:endr
            add  hl,de
            adc  a,c
            EXD
            ld   l,a
            ld   h,0
            jp   XFBE

LD030
            ld   a,l
            cp   e
            jrc  $+4:ld a,e:ld e,l
            ld   l,h
            sla  a
            jrc  $+31
            rla
            jrc  $+63
            rla
            jrc  $+91
            rla
            jrc  $+115
            rla
            jpc  $+135
            rla
            jpc  $+150
            rla
            jpc  $+161
            rla
            jpc  XFBE
            ld   e,a
            jp   XFBE

            ld   h,a
 rept 7:add hl,de:add hl,hl:jrnc $+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE

            ld   h,a
 rept 6:add hl,de:add hl,hl:jrnc $+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE

            ld   h,a
 rept 5:add hl,de:add hl,hl:jrnc $+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE

            ld   h,a
 rept 4:add hl,de:add hl,hl:jrnc $+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE

            ld   h,a
 rept 3:add hl,de:add hl,hl:jrnc $+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE

            ld   h,a
 rept 2:add hl,de:add hl,hl:jrnc $+3:endr
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE

            ld   h,a
            add  hl,de
            add  hl,hl
            jrnc $+3
            add  hl,de
            EXD
            ld   l,h
            jp   XFBE


ДЕЛЕНИЕ hl=hl/de
DIVHLDE     ld   xl,0
            jpp  LD098
            EXD
            ld   b,h
            ld   c,l
            ld   hl,0
            SUB_BC
            EXD
            inc  xl
LD098       bit  7,h
            jrz  LD0AA
            exa
            cpl
            exa
            cpl
            ld   b,h
            ld   c,l
            ld   hl,0
            scf
            sbc  hl,bc
            inc  xl
LD0AA

            rept 8:rla:adc hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr

            rla
            exa

            rept 8:rla:adc hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr

            rla
            dec  xl
            jrnz $+6
            ld   l,a
            exa
            ld   h,a
            ret
            cpl
            ld   l,a
            exa
            cpl
            ld   h,a
            ret



CLIPLINE:
            ld   a,#01
            ld   (F_POL_LIN),a
            ld   a,(_F0)
            cp   #F0
            jrnz LD16E
            ld   b,a
            ld   a,(_F1)
            ld   (_F0),a
            ld   a,b
            ld   (_F1),a
            ld   hl,(_X0)
            ld   de,(_X1)
            ld   (_X1),hl
            ld   (_X0),de
            ld   hl,(_Y0)
            ld   de,(_Y1)
            ld   (_Y1),hl
            ld   (_Y0),de
LD16E       xor  a
            ld   (LOW_CORDS_BUF),a
            ld   a,(_F0)
            cpl
            and  #F0
            ld   l,a
            ld   a,(_F1)
            and  #0F
            or   l
            ld   l,a
            ld   h,L95.h
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            EXD
            ld   de,$+7
            push de
            push de
            push de
            jp   (hl)
            ld   a,(LOW_CORDS_BUF)
            pop  de
            pop  de
            cp   #04
            ret



МАТРИЦА ОТДЕЛЬНОГО ОБЪЕКТА
MATRX:
            ld   hl,SETS
            bit  0,(hl)
            jr   z,LD1D8;ifALFA GAMA TURN ON
            ld   a,(EYEB);BETA
            ld   b,a
            add  a,#40
            ld   h,SINTB
            ld   l,a
            ld   a,(hl);COS
            ld   (GM_11+1),a;COS b
            ld   (GM_33+1),a;COS b
            ld   l,b
            ld   a,(hl);SIN
            ld   (GM_13+1),a;SIN b
            neg
            ld   (GM_31+1),a;-SIN b
            xor  a
            ld   (GM_12+1),a
            ld   (GM_21+1),a
            ld   (GM_23+1),a
            ld   (GM_32+1),a
            ld   a,#7F
            ld   (GM_22+1),a
            ret
LD1D8
            ld   a,(EYEA)
            ld   h,SINTB
            ld   l,a
            ld   b,(hl)
            add  a,#40
            ld   l,a
            ld   c,(hl)
            ld   a,(EYEB)
            ld   l,a
            ld   a,(hl)
            ld   xl,a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)
            ld   yl,a
            ld   a,(EYEG)
            ld   l,a
            ld   a,(hl)
            ld   d,a
            neg
            ld   (GM_12+1),a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl);COS G
            ld   yh,a
            ld   h,MULTB
            ld   e,yl
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
            ld   (GM_11+1),a
            ld   a,xl
            ld   e,yh
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
            ld   (GM_13+1),a
            ld   a,xl
            MULAB
            ld   xh,a
            ld   a,yl
            MULAC
            MULAD
            ADPAXH
            ld   (GM_21+1),a
            ld   a,yh
            MULAC
            ld   (GM_22+1),a
            ld   a,yl
            MULAB
            ld   xh,a
            ld   a,xl
            MULAC
            MULAD
            SBPAXH
            ld   (GM_23+1),a
            ld   a,xl
            MULAC
            ld   xh,a
            ld   a,yl
            MULAB
            MULAD
            SBPAXH
            ld   (GM_31+1),a
            ld   a,yh
            MULAB
            ld   (GM_32+1),a
            ld   a,yl
            MULAC
            ld   xh,a
            ld   a,xl
            MULAB
            MULAD
            ADPAXH
            ld   (GM_33+1),a
            ret




PMATRX:
ПЕРЕМНОЖЕНИЕ МАТРИЦЫ ОБЪЕКТА С МАТРИЦЕЙ
ПРОСТРАНСТВА
            ld   h,MULTB
            ld   iy,SETS
            bit  0,(iy+0)
            jrz  $+10;ifALFA GAMA TURN ON
            ld   a,(EYEB)
            and  #3F
            jpz  LD43C
GM_11:      ld   b,0
GM_21:      ld   c,0
GM_31:      ld   d,0
SM_11:      ld   a,0

            MULAB

            ld   xh,a
            bit  0,(iy+0)
            jrnz LD2C5
SM_21:      ld   a,0

            MULAC
            ADPAXH

            ld   xh,a
LD2C5
SM_31:      ld   a,0

            MULAD
            ADPAXH

            ld   (OM_11+1),a
SM_12:      ld   a,0

            MULAB

            ld   xh,a
            bit  0,(iy+0)
            jrnz LD2EE
SM_22:      ld   a,0

            MULAC
            ADPAXH

            ld   xh,a
LD2EE
SM_32:      ld   a,0

            MULAD
            ADPAXH

            ld   (OM_21+1),a
SM_13:      ld   a,0

            MULAB

            ld   xh,a
            bit  0,(iy+0)
            jrnz LD317
SM_23:      ld   a,0

            MULAC
            ADPAXH

            ld   xh,a
LD317
SM_33:      ld   a,0

            MULAD
            ADPAXH

            ld   (OM_31+1),a

GM_13:      ld   b,0
GM_23:      ld   c,0
GM_33:      ld   d,0

            ld   a,(SM_11+1)

            MULAB

            ld   xh,a
            bit  0,(iy+0)
            jrnz LD34C
            ld   a,(SM_21+1)

            MULAC
            ADPAXH

            ld   xh,a
LD34C       ld   a,(SM_31+1)

            MULAD
            ADPAXH

            ld   (OM_13+1),a
            ld   a,(SM_12+1)

            MULAB

            ld   xh,a
            bit  0,(iy+0)
            jrnz LD375
            ld   a,(SM_22+1)

            MULAC
            ADPAXH

            ld   xh,a
LD375       ld   a,(SM_32+1)

            MULAD
            ADPAXH

            ld   (OM_23+1),a
            ld   a,(SM_13+1)

            MULAB

            ld   xh,a
            bit  0,(iy+0)
            jrnz LD39E
            ld   a,(SM_23+1)

            MULAC
            ADPAXH

            ld   xh,a
LD39E       ld   a,(SM_33+1)

            MULAD
            ADPAXH

            ld   (OM_33+1),a
            bit  0,(iy+0)
            jpnz LD429

GM_12:      ld   b,0
GM_22:      ld   c,0
GM_32:      ld   d,0

            ld   a,(SM_11+1)

            MULAB

            ld   xh,a
            ld   a,(SM_21+1)

            MULAC
            ADPAXH

            ld   xh,a
            ld   a,(SM_31+1)

            MULAD
            ADPAXH

            ld   (OM_12+1),a
            ld   a,(SM_12+1)

            MULAB

            ld   xh,a
            ld   a,(SM_22+1)

            MULAC
            ADPAXH

            ld   xh,a
            ld   a,(SM_32+1)

            MULAD
            ADPAXH

            ld   (OM_22+1),a
            ld   a,(SM_13+1)

            MULAB

            ld   xh,a
            ld   a,(SM_23+1)

            MULAC
            ADPAXH

            ld   xh,a
            ld   a,(SM_33+1)

            MULAD
            ADPAXH

            ld   (OM_32+1),a
            ret
LD429
            ld   a,(SM_21+1)
            ld   (OM_12+1),a
            ld   a,(SM_22+1)
            ld   (OM_22+1),a
            ld   a,(SM_23+1)
            ld   (OM_32+1),a
            ret
LD43C
            ld   a,(SM_21+1)
            ld   (OM_12+1),a
            ld   a,(SM_22+1)
            ld   (OM_22+1),a
            ld   a,(SM_23+1)
            ld   (OM_32+1),a
            ld   a,(EYEB)
            and  a
            jrz  LD485
            jpp  LD4AA
            jppo LD4D5
            ld   a,(SM_31+1)
            ld   (OM_11+1),a
            ld   a,(SM_32+1)
            ld   (OM_21+1),a
            ld   a,(SM_33+1)
            ld   (OM_31+1),a
            ld   a,(SM_11+1)
            neg
            ld   (OM_13+1),a
            ld   a,(SM_12+1)
            neg
            ld   (OM_23+1),a
            ld   a,(SM_13+1)
            neg
            ld   (OM_33+1),a
            ret
LD485       ld   a,(SM_11+1)
            ld   (OM_11+1),a
            ld   a,(SM_12+1)
            ld   (OM_21+1),a
            ld   a,(SM_13+1)
            ld   (OM_31+1),a
            ld   a,(SM_31+1)
            ld   (OM_13+1),a
            ld   a,(SM_32+1)
            ld   (OM_23+1),a
            ld   a,(SM_33+1)
            ld   (OM_33+1),a
            ret
LD4AA       ld   a,(SM_31+1)
            neg
            ld   (OM_11+1),a
            ld   a,(SM_32+1)
            neg
            ld   (OM_21+1),a
            ld   a,(SM_33+1)
            neg
            ld   (OM_31+1),a
            ld   a,(SM_11+1)
            ld   (OM_13+1),a
            ld   a,(SM_12+1)
            ld   (OM_23+1),a
            ld   a,(SM_13+1)
            ld   (OM_33+1),a
            ret
LD4D5       ld   a,(SM_11+1)
            neg
            ld   (OM_11+1),a
            ld   a,(SM_12+1)
            neg
            ld   (OM_21+1),a
            ld   a,(SM_13+1)
            neg
            ld   (OM_31+1),a
            ld   a,(SM_31+1)
            neg
            ld   (OM_13+1),a
            ld   a,(SM_32+1)
            neg
            ld   (OM_23+1),a
            ld   a,(SM_33+1)
            neg
            ld   (OM_33+1),a
            ret



            ADRXX00
L95:
            db   STOR_Y1_X1.b
            db   C_XY_aXDY.b
            db   C_XY_iXDY.b
F_POL_LIN   db   0
            db   C_XY_DXaY.b
            db   X903.b
            db   X91D.b
F_ACTING    db   0
            db   C_XY_DXiY.b
            db   X937.b
            db   X951.b
_X0         dw   0
_Y0         dw   0
_F0         db   0
            db   X96B.b
            db   X902.b
            db   X971.b
F_VISI      db   0
            db   X977.b
            db   X912.b
            db   X989.b
_LF0        db   0
            db   X9A1.b
            db   X9B3.b
            db   X9BA.b
_X1         dw   0
_Y1         dw   0
_F1         db   0
            db   X9CC.b
            db   X9D2.b
            db   X902.b
_LF1        db   0
            db   X9D8.b
            db   X9EA.b
            db   X9FC.b
            db   0
            db   XA03.b
            db   XA15.b
            db   X960.b
_aXDY       dw   0,0
_iXDY       dw   0,0
_DXaY       dw   0,0
_DXiY       dw   0,0
L_FROM      dw   0
L_TO        dw   0
            db   0
            db   XA2D.b
            db   XA33.b
            db   XA45.b
            db   0
            db   X902.b
            db   XA57.b
            db   X92C.b
            db   0
            db   XA5E.b
            db   XA64.b
            db   XA79.b
COML1       db   0
COML2       db   0
_LX0        dw   0
            db   0
            db   XA94.b
            db   XAB0.b
            db   XAB7.b
            db   0
            db   XAD6.b
            db   X902.b
            db   XAE1.b
            db   0
            db   XAE7.b
            db   _BREAK.b
            db   XAFC.b
_LY0        dw   0
_LX1        dw   0
            db   0
            db   XB15.b
            db   XB31.b
            db   XB46.b
            db   0
            db   XB51.b
            db   _BREAK.b
            db   X902.b
            db   0
            db   XB58.b
            db   XB77.b
            db   XB90.b
            ds   21
            db   XB96.b
            db   XB9C.b
            db   XBAE.b
            db   0
            db   XBC0.b
            db   XBC6.b
            db   XBE1.b
            db   0
            db   X902.b
            db   X946.b
            db   XBF6.b
_LY1        dw   0
            db   0,0,0
            db   XBFD.b
            db   XC19.b
            db   XC24.b
            db   0
            db   XC39.b
            db   XC58.b
            db   XC5E.b
            db   0
            db   XC77.b
            db   X902.b
            db   _BREAK.b
            db   0,0,0,0,0
            db   XC7E.b
            db   XC9A.b
            db   XCB9.b
            db   0
            db   XCC0.b
            db   XCD5.b
            db   _BREAK.b
            db   0
            db   XCEE.b
            db   XCF9.b
            db   X902.b


            ADRXX00
            db   STOR_Y1_X1.h
            db   C_XY_aXDY.h
            db   C_XY_iXDY.h
            db   0
            db   C_XY_DXaY.h
            db   X903.h
            db   X91D.h
            db   0
            db   C_XY_DXiY.h
            db   X937.h
            db   X951.h
            db   0,0,0,0,0
            db   X96B.h
            db   X902.h
            db   X971.h
            db   0
            db   X977.h
            db   X912.h
            db   X989.h
            db   0
            db   X9A1.h
            db   X9B3.h
            db   X9BA.h
            db   0,0,0,0,0
            db   X9CC.h
            db   X9D2.h
            db   X902.h
            db   0
            db   X9D8.h
            db   X9EA.h
            db   X9FC.h
            db   0
            db   XA03.h
            db   XA15.h
            db   X960.h
            ds   21
            db   XA2D.h
            db   XA33.h
            db   XA45.h
            db   0
            db   X902.h
            db   XA57.h
            db   X92C.h
            db   0
            db   XA5E.h
            db   XA64.h
            db   XA79.h
            db   0,0,0,0,0
            db   XA94.h
            db   XAB0.h
            db   XAB7.h
            db   0
            db   XAD6.h
            db   X902.h
            db   XAE1.h
            db   0
            db   XAE7.h
            db   _BREAK.h
            db   XAFC.h
            db   0,0,0,0,0
            db   XB15.h
            db   XB31.h
            db   XB46.h
            db   0
            db   XB51.h
            db   _BREAK.h
            db   X902.h
            db   0
            db   XB58.h
            db   XB77.h
            db   XB90.h
            ds   21
            db   XB96.h
            db   XB9C.h
            db   XBAE.h
            db   0
            db   XBC0.h
            db   XBC6.h
            db   XBE1.h
            db   0
            db   X902.h
            db   X946.h
            db   XBF6.h
            db   0,0,0,0,0
            db   XBFD.h
            db   XC19.h
            db   XC24.h
            db   0
            db   XC39.h
            db   XC58.h
            db   XC5E.h
            db   0
            db   XC77.h
            db   X902.h
            db   _BREAK.h
            db   0,0,0,0,0
            db   XC7E.h
            db   XC9A.h
            db   XCB9.h
            db   0
            db   XCC0.h
            db   XCD5.h
            db   _BREAK.h
            db   0
            db   XCEE.h
            db   XCF9.h
            db   X902.h
            db   0,0,0,0,0



