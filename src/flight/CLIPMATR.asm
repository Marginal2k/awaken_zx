;CLIP
;CLIPLINE
;MATRX
;PMATRX
;MULL
;DIVHLDE


CLIP:
; КЛИППИРОВАИНЕ ПЛОСКОСТИ
; b-КОЛИЧЕСТВО УЗЛОВ
; hl-ВЕКТОР НОМЕРОВ УЗЛОВ
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
.X8B2       ld   hl,(_X1)
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
            ld   h,high(L95)
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            EXD
            ld   de,$+5
            push de
            jp   (hl)
            pop  bc
            djnz .X8B2
            pop  hl
            ld   a,(LOW_CORDS_BUF)
            cp   #06
X902:       ret
X903:       call DXaY
X906:       call aXDY
X909:       call aY_aX
            jp   m,C_XY_DXaY+3
            call C_XY_aXDY+3
X912:       ld   hl,F_ACTING
            bit  0,(hl)
            jp   nz,SET_XaYa
            set  0,(hl)
            ret
X91D:       call DXaY
X920:       call iXDY
X923:       call aY_iX
            jp   m,C_XY_iXDY+3
            call C_XY_DXaY+3
X92C:       ld   hl,F_ACTING
            bit  1,(hl)
            jp   nz,SET_XiYa
            set  1,(hl)
            ret
X937:       call DXiY
X93A:       call aXDY
X93D:       call iY_aX
            jp   m,C_XY_aXDY+3
            call C_XY_DXiY+3
X946:       ld   hl,F_ACTING
            bit  2,(hl)
            jp   nz,SET_XaYi
            set  2,(hl)
            ret
X951:       call DXiY
X954:       call iXDY
X957:       call iY_iX
            jp   m,C_XY_DXiY+3
            call C_XY_iXDY+3
X960:       ld   hl,F_ACTING
            bit  3,(hl)
            jp   nz,SET_XiYi
            set  3,(hl)
            ret
X96B:       call C_XY_aXDY
            jp   STOR_Y1_X1
X971:       call C_XY_aXDY
            jp   C_XY_iXDY
X977:       call aXDY
X97A:       call DXaY
            call aY_aX
            jp   p,SET_XaYa
            call C_XY_aXDY+3
            jp   C_XY_DXaY+3
X989:       call aXDY
X98C:       call DXaY
            call aY_aX
            jp   m,.X99B
            call SET_XaYa
            jp   X92C
.X99B       call C_XY_aXDY+3
            jp   X920
X9A1:       call aXDY
X9A4:       call DXiY
            call iY_aX
            jp   m,_BREAK
            call C_XY_aXDY+3
            jp   C_XY_DXiY+3
X9B3:       call X1_X0
            jp   m,_BREAK
            ret
X9BA:       call aXDY
X9BD:       call DXiY
            call iY_aX
            jp   m,_BREAK
            call C_XY_aXDY+3
            jp   X954
X9CC:       call C_XY_iXDY
            jp   STOR_Y1_X1
X9D2:       call C_XY_iXDY
            jp   C_XY_aXDY
X9D8:       call iXDY
X9DB:       call DXaY
            call aY_iX
            jp   m,_BREAK
            call C_XY_iXDY+3
            jp   C_XY_DXaY+3
X9EA:       call iXDY
X9ED:       call DXaY
            call aY_iX
            jp   m,_BREAK
            call C_XY_iXDY+3
            jp   X906
X9FC:       call X1_X0
            jp   p,_BREAK
            ret
XA03:       call iXDY
XA06:       call DXiY
            call iY_iX
            jp   p,SET_XiYi
            call C_XY_iXDY+3
            jp   C_XY_DXiY+3
XA15:       call iXDY
XA18:       call DXiY
            call iY_iX
            jp   m,.XA27
            call SET_XiYi
            jp   X946
.XA27       call C_XY_iXDY+3
            jp   X93A
XA2D:       call C_XY_DXaY
            jp   STOR_Y1_X1
XA33:       call DXaY
XA36:       call aXDY
            call aY_aX
            jp   m,_BREAK
            call C_XY_DXaY+3
            jp   C_XY_aXDY+3
XA45:       call DXaY
XA48:       call iXDY
            call aY_iX
            jp   p,SET_XiYa
            call C_XY_DXaY+3
            jp   C_XY_iXDY+3
XA57:       call Y1_Y0
            jp   m,_BREAK
            ret
XA5E:       call C_XY_DXaY
            jp   C_XY_DXiY
XA64:       call DXaY
XA67:       call aXDY
            call aY_aX
            jp   m,_BREAK
            call C_XY_DXaY+3
            call DXiY
            jp   X93D
XA79:       call DXaY
XA7C:       call iXDY
            call aY_iX
            jp   m,.XA8B
            call SET_XiYa
            jp   X960
.XA8B       call C_XY_DXaY+3
            call DXiY
            jp   X957
XA94:       call DXaY
            call aXDY
            call aY_aX
            jp   m,XC13
            ld   hl,F_ACTING
            bit  0,(hl)
            set  0,(hl)
            call nz,SET_XaYa
XAAA:       call C_XY_DXaY+3
            jp   STOR_Y1_X1
XAB0:       call X1_X0
            jp   p,_BREAK
            ret
XAB7:       call DXaY
            call aXDY
            call aY_aX
            jp   m,.XAD0
            ld   hl,F_ACTING
            bit  0,(hl)
            set  0,(hl)
            call nz,SET_XaYa
            jp   XA48
.XAD0       call C_XY_aXDY+3
            jp   C_XY_iXDY
XAD6:       ld   hl,F_ACTING
            bit  0,(hl)
            jp   nz,SET_XaYa
            set  0,(hl)
            ret
XAE1:       call XAD6
            jp   X92C
XAE7:       call DXaY
            call aXDY
            call aY_aX
            jp   m,X9A4
            call XAD6
            call C_XY_DXaY+3
            jp   C_XY_DXiY
XAFC:       call DXaY
            call aXDY
            call aY_aX
            jp   m,X9BD
            ld   hl,F_ACTING
            bit  0,(hl)
            set  0,(hl)
            call nz,SET_XaYa
            jp   XA7C
XB15:       call DXaY
            call iXDY
            call aY_iX
            jp   m,XAAA
            ld   hl,F_ACTING
            bit  1,(hl)
            set  1,(hl)
            call nz,SET_XiYa
XB2B:       call C_XY_iXDY+3
            jp   STOR_Y1_X1
XB31:       call DXaY
            call iXDY
            call aY_iX
            jp   m,XA36
            call XB46
            call C_XY_iXDY+3
            jp   C_XY_aXDY
XB46:       ld   hl,F_ACTING
            bit  1,(hl)
            jp   nz,SET_XiYa
            set  1,(hl)
            ret
XB51:       call Y1_Y0
            jp   p,_BREAK
            ret
XB58:       call DXaY
            call iXDY
            call aY_iX
            jp   m,.XB71
            ld   hl,F_ACTING
            bit  1,(hl)
            set  1,(hl)
            call nz,SET_XiYa
            jp   XA06
.XB71       call C_XY_DXaY+3
            jp   C_XY_DXiY
XB77:       call DXaY
            call iXDY
            call aY_iX
            jp   m,XA67
            ld   hl,F_ACTING
            bit  1,(hl)
            set  1,(hl)
            call nz,SET_XiYa
            jp   XA18
XB90:       call XB46
            jp   X960
XB96:       call C_XY_DXiY
            jp   STOR_Y1_X1
XB9C:       call DXiY
XB9F:       call aXDY
            call iY_aX
            jp   p,SET_XaYi
            call C_XY_DXiY+3
            jp   C_XY_aXDY+3
XBAE:       call DXiY
XBB1:       call iXDY
            call iY_iX
            jp   m,_BREAK
            call C_XY_DXiY+3
            jp   C_XY_iXDY+3
XBC0:       call C_XY_DXiY
            jp   C_XY_DXaY
XBC6:       call DXiY
XBC9:       call aXDY
            call iY_aX
            jp   m,.XBD8
            call SET_XaYi
            jp   X912
.XBD8       call C_XY_DXiY+3
            call DXaY
            jp   X909
XBE1:       call DXiY
XBE4:       call iXDY
            call iY_iX
            jp   m,_BREAK
            call C_XY_DXiY+3
            call DXaY
            jp   X923
XBF6:       call Y1_Y0
            jp   p,_BREAK
            ret
XBFD:       call DXiY
            call aXDY
            call iY_aX
            jp   m,XC94
            ld   hl,F_ACTING
            bit  2,(hl)
            set  2,(hl)
            call nz,SET_XaYi
XC13:       call C_XY_aXDY+3
            jp   STOR_Y1_X1
XC19:       ld   hl,F_ACTING
            bit  2,(hl)
            jp   nz,SET_XaYi
            set  2,(hl)
            ret
XC24:       call DXiY
            call aXDY
            call iY_aX
            jp   m,XBB1
            call XC19
            call C_XY_aXDY+3
            jp   C_XY_iXDY
XC39:       call DXiY
            call aXDY
            call iY_aX
            jp   m,.XC52
            ld   hl,F_ACTING
            bit  2,(hl)
            set  2,(hl)
            call nz,SET_XaYi
            jp   X97A
.XC52       call C_XY_DXiY+3
            jp   C_XY_DXaY
XC58:       call XC19
            jp   X912
XC5E:       call DXiY
            call aXDY
            call iY_aX
            jp   m,XBE4
            ld   hl,F_ACTING
            bit  2,(hl)
            set  2,(hl)
            call nz,SET_XaYi
            jp   X98C
XC77:       call Y1_Y0
            jp   m,_BREAK
            ret
XC7E:       call DXiY
            call iXDY
            call iY_iX
            jp   m,XB2B
            ld   hl,F_ACTING
            bit  3,(hl)
            set  3,(hl)
            call nz,SET_XiYi
XC94:       call C_XY_DXiY+3
            jp   STOR_Y1_X1
XC9A:       call DXiY
            call iXDY
            call iY_iX
            jp   m,.XCB3
            ld   hl,F_ACTING
            bit  3,(hl)
            set  3,(hl)
            call nz,SET_XiYi
            jp   XB9F
.XCB3       call C_XY_iXDY+3
            jp   C_XY_aXDY
XCB9:       call X1_X0
            jp   m,_BREAK
            ret
XCC0:       call DXiY
            call iXDY
            call iY_iX
            jp   m,X9DB
            call XCEE
            call C_XY_DXiY+3
            jp   C_XY_DXaY
XCD5:       call DXiY
            call iXDY
            call iY_iX
            jp   m,X9ED
            ld   hl,F_ACTING
            bit  3,(hl)
            set  3,(hl)
            call nz,SET_XiYi
            jp   XBC9
XCEE:       ld   hl,F_ACTING
            bit  3,(hl)
            jp   nz,SET_XiYi
            set  3,(hl)
            ret
XCF9:       call XCEE
            jp   X946

;DX*(MIN-Y0)
DXiY:       ld   bc,(_X1)
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
DXaY:       ld   bc,(_X1)
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
iXDY:       ld   bc,0
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
aXDY:       ld   bc,#00FF
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

C_XY_DXiY:  call DXiY
            ld   a,(_DXiY)
            ex   af,af'
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
            jr   z,$+23
            jp   p,$+19
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
C_XY_DXaY:  call DXaY
            ld   a,(_DXaY)
            ex   af,af'
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
            jr   z,$+24
            jp   p,$+20
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
C_XY_iXDY:  call iXDY
            ld   a,(_iXDY)
            ex   af,af'
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
            jp   m,.IO1
            ld   a,l
            and  a
            jp   p,.IO2
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
.IO1
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
.IO2
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
C_XY_aXDY:  call aXDY
            ld   a,(_aXDY)
            ex   af,af'
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
            jp   m,.IO4
            ld   a,l
            and  a
            jp   p,.IO3
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
.IO4
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
.IO3
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
SET_XiYi:   ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,0
            jp   STOR_YX_DE
SET_XaYi:   ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,#00FF
            jp   STOR_YX_DE
SET_XiYa:   ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,low(YEND)*256
            jp   STOR_YX_DE
SET_XaYa:   ld   a,(F_POL_LIN)
            and  a
            ret  nz
            ld   de,(low(YEND)*256)+#FF
            jp   STOR_YX_DE
iY_iX:
            ld   hl,(_DXiY)
            ld   bc,(_iXDY)
            SUB_BC
            ld   hl,(_DXiY+2)
            ld   bc,(_iXDY+2)
            sbc  hl,bc
            ret
iY_aX:
            ld   hl,(_DXiY)
            ld   bc,(_aXDY)
            SUB_BC
            ld   hl,(_DXiY+2)
            ld   bc,(_aXDY+2)
            sbc  hl,bc
            ret
aY_iX:
            ld   hl,(_DXaY)
            ld   bc,(_iXDY)
            SUB_BC
            ld   hl,(_DXaY+2)
            ld   bc,(_iXDY+2)
            sbc  hl,bc
            ret
aY_aX:
            ld   hl,(_DXaY)
            ld   bc,(_aXDY)
            SUB_BC
            ld   hl,(_DXaY+2)
            ld   bc,(_aXDY+2)
            sbc  hl,bc
            ret
X1_X0:      ld   hl,(_X1)
            ld   de,(_X0)
            SUB_DE
            ret
Y1_Y0:      ld   hl,(_Y1)
            ld   de,(_Y0)
            SUB_DE
            ret
STOR_Y1_X1: ld   a,(_X1)
            ld   e,a
            ld   a,(_Y1)
            ld   d,a
STOR_YX_DE: ld   a,(LOW_CORDS_BUF)
            ld   l,a
            ld   h,L9E
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (LOW_CORDS_BUF),a
            ret
_BREAK:     pop  af
            pop  bc
            pop  hl
            ld   c,b
            dec  c
            ld   b,0
            add  hl,bc
            scf
            ret


; УМНОЖЕНИЕ HLDE=hl*de
MULL:
            ld   a,h
            xor  d
            push af
            ABSDE
            ABSHL
            EXD
            ld   a,d
            and  a
            jp   z,XFDA
            ld   a,h
            and  a
            jp   z,XFDF
            ld   bc,0
            ld   ix,0
            ADDHLHL 2
            jp   c,$+27
            add  hl,hl
            jp   c,$+33
            add  hl,hl
            jp   c,$+39
            add  hl,hl
            jp   c,$+45
            add  hl,hl
            jp   c,$+51
            add  hl,hl
            jp   c,$+57
            add  hl,hl
            jp   $+63

            add  ix,de
            adc  hl,bc

            rept 14
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            endr

            ld   d,ixh
            ld   e,ixl
XFBE:       pop  af
            ret  p
            ld   b,h
            ld   c,l
            ld   hl,0
            sbc  hl,de
            EXD
            ld   hl,0
            sbc  hl,bc
            ret
XFDA:       ld   a,h
            and  a
            jr   z,LD030
            EXD
XFDF:       ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jr   c,$+26
            add  a,a
            jr   c,$+29
            add  a,a
            jr   c,$+32
            add  a,a
            jr   c,$+35
            add  a,a
            jr   c,$+38
            add  a,a
            jr   c,$+41
            add  a,a
            jr   c,$+44
            add  a,a
            jr   c,$+47
            jp   $+47
            rept 7
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            endr
            add  hl,de
            adc  a,c
            EXD
            ld   l,a
            ld   h,0
            jp   XFBE
LD030:      rr   e
            jr   c,$+33
            rr   e
            jr   c,$+35
            rr   e
            jr   c,$+37
            rr   e
            jr   c,$+39
            rr   e
            jr   c,$+41
            rr   e
            jr   c,$+43
            rr   e
            jr   c,$+45
            rr   e
            jr   c,$+47
            jp   $+49
            rept 7
            add  a,l
            rra
            rr   e
            jr   nc,$+3
            endr
            add  a,l
            rra
            rr   e
            ld   d,a
            ld   l,h
            jp   XFBE

; ДЕЛЕНИЕ hl=hl/de
DIVHLDE:    ld   ixl,0
            jp   p,.LD098
            EXD
            ld   b,h
            ld   c,l
            ld   hl,0
            SUB_BC
            EXD
            inc  ixl
.LD098      bit  7,h
            jr   z,.LD0AA
            ex   af,af'
            cpl
            ex   af,af'
            cpl
            ld   b,h
            ld   c,l
            ld   hl,0
            scf
            sbc  hl,bc
            inc  ixl
.LD0AA

            rept 8
            rla
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            endr

            rla
            ex   af,af'

            rept 8
            rla
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            endr

            rla
            dec  ixl
            jr   nz,$+6
            ld   l,a
            ex   af,af'
            ld   h,a
            ret
            cpl
            ld   l,a
            ex   af,af'
            cpl
            ld   h,a
            ret


CLIPLINE:
            ld   a,#01
            ld   (F_POL_LIN),a
            ld   a,(_F0)
            cp   #F0
            jr   nz,.LD16E
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
.LD16E      xor  a
            ld   (LOW_CORDS_BUF),a
            ld   a,(_F0)
            cpl
            and  #F0
            ld   l,a
            ld   a,(_F1)
            and  #0F
            or   l
            ld   l,a
            ld   h,high(L95)
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


; МАТРИЦА ОТДЕЛЬНОГО ОБЪЕКТА
MATRX:
            ld   hl,SETS
            bit  0,(hl)
            jr   z,.LD1D8            ;ifALFA GAMA TURN ON
            ld   a,(EYEB)           ;BETA
            ld   b,a
            add  a,#40
            ld   h,SINTB
            ld   l,a
            ld   a,(hl)             ;COS
            ld   (GM_11+1),a        ;COS b
            ld   (GM_33+1),a        ;COS b
            ld   l,b
            ld   a,(hl)             ;SIN
            ld   (GM_13+1),a        ;SIN b
            neg
            ld   (GM_31+1),a        ;-SIN b
            xor  a
            ld   (GM_12+1),a
            ld   (GM_21+1),a
            ld   (GM_23+1),a
            ld   (GM_32+1),a
            ld   a,#7F
            ld   (GM_22+1),a
            ret
.LD1D8
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
            ld   ixl,a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)
            ld   iyl,a
            ld   a,(EYEG)
            ld   l,a
            ld   a,(hl)
            ld   d,a
            neg
            ld   (GM_12+1),a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)             ;COS G
            ld   iyh,a
            ld   h,MULTB
            ld   e,iyl
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
            ld   a,ixl
            ld   e,iyh
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
            ld   a,ixl
            MULAB
            ld   ixh,a
            ld   a,iyl
            MULAC
            MULAD
            ADPAXH
            ld   (GM_21+1),a
            ld   a,iyh
            MULAC
            ld   (GM_22+1),a
            ld   a,iyl
            MULAB
            ld   ixh,a
            ld   a,ixl
            MULAC
            MULAD
            SBPAXH
            ld   (GM_23+1),a
            ld   a,ixl
            MULAC
            ld   ixh,a
            ld   a,iyl
            MULAB
            MULAD
            SBPAXH
            ld   (GM_31+1),a
            ld   a,iyh
            MULAB
            ld   (GM_32+1),a
            ld   a,iyl
            MULAC
            ld   ixh,a
            ld   a,ixl
            MULAB
            MULAD
            ADPAXH
            ld   (GM_33+1),a
            ret


PMATRX:
; ПЕРЕМНОЖЕНИЕ МАТРИЦЫ ОБЪЕКТА С МАТРИЦЕЙ
; ПРОСТРАНСТВА
            ld   h,MULTB
            ld   iy,SETS
            bit  0,(iy+0)
            jr   z,$+10             ;ifALFA GAMA TURN ON
            ld   a,(EYEB)
            and  #3F
            jp   z,LD43C
GM_11:      ld   b,0
GM_21:      ld   c,0
GM_31:      ld   d,0
SM_11:      ld   a,0

            MULAB

            ld   ixh,a
            bit  0,(iy+0)
            jr   nz,LD2C5
SM_21:      ld   a,0

            MULAC
            ADPAXH

            ld   ixh,a
LD2C5:
SM_31:      ld   a,0

            MULAD
            ADPAXH

            ld   (OM_11+1),a
SM_12:      ld   a,0

            MULAB

            ld   ixh,a
            bit  0,(iy+0)
            jr   nz,LD2EE
SM_22:      ld   a,0

            MULAC
            ADPAXH

            ld   ixh,a
LD2EE:
SM_32:      ld   a,0

            MULAD
            ADPAXH

            ld   (OM_21+1),a
SM_13:      ld   a,0

            MULAB

            ld   ixh,a
            bit  0,(iy+0)
            jr   nz,LD317
SM_23:      ld   a,0

            MULAC
            ADPAXH

            ld   ixh,a
LD317:
SM_33:      ld   a,0

            MULAD
            ADPAXH

            ld   (OM_31+1),a

GM_13:      ld   b,0
GM_23:      ld   c,0
GM_33:      ld   d,0

            ld   a,(SM_11+1)

            MULAB

            ld   ixh,a
            bit  0,(iy+0)
            jr   nz,.LD34C
            ld   a,(SM_21+1)

            MULAC
            ADPAXH

            ld   ixh,a
.LD34C      ld   a,(SM_31+1)

            MULAD
            ADPAXH

            ld   (OM_13+1),a
            ld   a,(SM_12+1)

            MULAB

            ld   ixh,a
            bit  0,(iy+0)
            jr   nz,.LD375
            ld   a,(SM_22+1)

            MULAC
            ADPAXH

            ld   ixh,a
.LD375      ld   a,(SM_32+1)

            MULAD
            ADPAXH

            ld   (OM_23+1),a
            ld   a,(SM_13+1)

            MULAB

            ld   ixh,a
            bit  0,(iy+0)
            jr   nz,.LD39E
            ld   a,(SM_23+1)

            MULAC
            ADPAXH

            ld   ixh,a
.LD39E      ld   a,(SM_33+1)

            MULAD
            ADPAXH

            ld   (OM_33+1),a
            bit  0,(iy+0)
            jp   nz,LD429

GM_12:      ld   b,0
GM_22:      ld   c,0
GM_32:      ld   d,0

            ld   a,(SM_11+1)

            MULAB

            ld   ixh,a
            ld   a,(SM_21+1)

            MULAC
            ADPAXH

            ld   ixh,a
            ld   a,(SM_31+1)

            MULAD
            ADPAXH

            ld   (OM_12+1),a
            ld   a,(SM_12+1)

            MULAB

            ld   ixh,a
            ld   a,(SM_22+1)

            MULAC
            ADPAXH

            ld   ixh,a
            ld   a,(SM_32+1)

            MULAD
            ADPAXH

            ld   (OM_22+1),a
            ld   a,(SM_13+1)

            MULAB

            ld   ixh,a
            ld   a,(SM_23+1)

            MULAC
            ADPAXH

            ld   ixh,a
            ld   a,(SM_33+1)

            MULAD
            ADPAXH

            ld   (OM_32+1),a
            ret
LD429:
            ld   a,(SM_21+1)
            ld   (OM_12+1),a
            ld   a,(SM_22+1)
            ld   (OM_22+1),a
            ld   a,(SM_23+1)
            ld   (OM_32+1),a
            ret
LD43C:
            ld   a,(SM_21+1)
            ld   (OM_12+1),a
            ld   a,(SM_22+1)
            ld   (OM_22+1),a
            ld   a,(SM_23+1)
            ld   (OM_32+1),a
            ld   a,(EYEB)
            and  a
            jr   z,.LD485
            jp   p,.LD4AA
            jp   po,.LD4D5
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
.LD485      ld   a,(SM_11+1)
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
.LD4AA      ld   a,(SM_31+1)
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
.LD4D5      ld   a,(SM_11+1)
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
            db   low(STOR_Y1_X1)
            db   low(C_XY_aXDY)
            db   low(C_XY_iXDY)
F_POL_LIN:  db   0
            db   low(C_XY_DXaY)
            db   low(X903)
            db   low(X91D)
F_ACTING:   db   0
            db   low(C_XY_DXiY)
            db   low(X937)
            db   low(X951)
_X0:        dw   0
_Y0:        dw   0
_F0:        db   0
            db   low(X96B)
            db   low(X902)
            db   low(X971)
            db   0
            db   low(X977)
            db   low(X912)
            db   low(X989)
            db   0
            db   low(X9A1)
            db   low(X9B3)
            db   low(X9BA)
_X1:        dw   0
_Y1:        dw   0
_F1:        db   0
            db   low(X9CC)
            db   low(X9D2)
            db   low(X902)
            db   0
            db   low(X9D8)
            db   low(X9EA)
            db   low(X9FC)
            db   0
            db   low(XA03)
            db   low(XA15)
            db   low(X960)
_aXDY:      dw   0,0
_iXDY:      dw   0,0
_DXaY:      dw   0,0
_DXiY:      dw   0,0
            ds   5
            db   low(XA2D)
            db   low(XA33)
            db   low(XA45)
            db   0
            db   low(X902)
            db   low(XA57)
            db   low(X92C)
            db   0
            db   low(XA5E)
            db   low(XA64)
            db   low(XA79)
            db   0,0,0,0,0
            db   low(XA94)
            db   low(XAB0)
            db   low(XAB7)
            db   0
            db   low(XAD6)
            db   low(X902)
            db   low(XAE1)
            db   0
            db   low(XAE7)
            db   low(_BREAK)
            db   low(XAFC)
            db   0,0,0,0,0
            db   low(XB15)
            db   low(XB31)
            db   low(XB46)
            db   0
            db   low(XB51)
            db   low(_BREAK)
            db   low(X902)
            db   0
            db   low(XB58)
            db   low(XB77)
            db   low(XB90)
            ds   21
            db   low(XB96)
            db   low(XB9C)
            db   low(XBAE)
            db   0
            db   low(XBC0)
            db   low(XBC6)
            db   low(XBE1)
            db   0
            db   low(X902)
            db   low(X946)
            db   low(XBF6)
            db   0,0,0,0,0
            db   low(XBFD)
            db   low(XC19)
            db   low(XC24)
            db   0
            db   low(XC39)
            db   low(XC58)
            db   low(XC5E)
            db   0
            db   low(XC77)
            db   low(X902)
            db   low(_BREAK)
            db   0,0,0,0,0
            db   low(XC7E)
            db   low(XC9A)
            db   low(XCB9)
            db   0
            db   low(XCC0)
            db   low(XCD5)
            db   low(_BREAK)
            db   0
            db   low(XCEE)
            db   low(XCF9)
            db   low(X902)


            ADRXX00
            db   high(STOR_Y1_X1)
            db   high(C_XY_aXDY)
            db   high(C_XY_iXDY)
            db   0
            db   high(C_XY_DXaY)
            db   high(X903)
            db   high(X91D)
            db   0
            db   high(C_XY_DXiY)
            db   high(X937)
            db   high(X951)
            db   0,0,0,0,0
            db   high(X96B)
            db   high(X902)
            db   high(X971)
            db   0
            db   high(X977)
            db   high(X912)
            db   high(X989)
            db   0
            db   high(X9A1)
            db   high(X9B3)
            db   high(X9BA)
            db   0,0,0,0,0
            db   high(X9CC)
            db   high(X9D2)
            db   high(X902)
            db   0
            db   high(X9D8)
            db   high(X9EA)
            db   high(X9FC)
            db   0
            db   high(XA03)
            db   high(XA15)
            db   high(X960)
            ds   21
            db   high(XA2D)
            db   high(XA33)
            db   high(XA45)
            db   0
            db   high(X902)
            db   high(XA57)
            db   high(X92C)
            db   0
            db   high(XA5E)
            db   high(XA64)
            db   high(XA79)
            db   0,0,0,0,0
            db   high(XA94)
            db   high(XAB0)
            db   high(XAB7)
            db   0
            db   high(XAD6)
            db   high(X902)
            db   high(XAE1)
            db   0
            db   high(XAE7)
            db   high(_BREAK)
            db   high(XAFC)
            db   0,0,0,0,0
            db   high(XB15)
            db   high(XB31)
            db   high(XB46)
            db   0
            db   high(XB51)
            db   high(_BREAK)
            db   high(X902)
            db   0
            db   high(XB58)
            db   high(XB77)
            db   high(XB90)
            ds   21
            db   high(XB96)
            db   high(XB9C)
            db   high(XBAE)
            db   0
            db   high(XBC0)
            db   high(XBC6)
            db   high(XBE1)
            db   0
            db   high(X902)
            db   high(X946)
            db   high(XBF6)
            db   0,0,0,0,0
            db   high(XBFD)
            db   high(XC19)
            db   high(XC24)
            db   0
            db   high(XC39)
            db   high(XC58)
            db   high(XC5E)
            db   0
            db   high(XC77)
            db   high(X902)
            db   high(_BREAK)
            db   0,0,0,0,0
            db   high(XC7E)
            db   high(XC9A)
            db   high(XCB9)
            db   0
            db   high(XCC0)
            db   high(XCD5)
            db   high(_BREAK)
            db   0
            db   high(XCEE)
            db   high(XCF9)
            db   high(X902)
            db   0,0,0,0,0
