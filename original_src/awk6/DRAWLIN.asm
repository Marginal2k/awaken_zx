■INIt
■OUTLINE
■DrwLin
■VsLINE
■ClipLin
■MUll
■DIvv















■MID_Y   equ#38
■MID_x   equ#80
■MID_x8  equMID_x-8
■MID_x0  equMID_x+8
■BR_x    equ#70-1



INIt
 ИНИЦИАЛИЗАЦИЯ ПРЕДЕЛОВ КЛИППИРОВАНИЯ
■h-yh,l-xh;hl-YHxH
■d-yl,e-xl;de-YLxL

            ld   (yHxH+1),hl
            ld   (yLxL+1),de
            ld   a,l
            ld   l,e
            ld   e,a
            ld   (yHxL+1),hl
            ld   (yLxH+1),de
            ld   a,h
            ld   (yH1+1),a
            ld   (yH2+1),a
            ld   (yH3+1),a
            ld   (yH4+1),a
            ld   (yH5+1),a
            inc  a:ld (yH6+1),a
            ld   a,d:ld (yL1+1),a
            ld   (yL2+1),a
            ld   (yL3+1),a
            ld   (yL4+1),a
            ld   (yL5+1),a
            ld   a,e:ld (xH1+1),a
            ld   (xH2+1),a
            ld   (xH3+1),a
            ld   (xH4+1),a
            ld   (xH5+1),a
            ld   (xH6+1),a
            inc  a:ld (xH7+1),a
            ld   a,l:ld (xL1+1),a
            ld   (xL2+1),a
            ld   (xL3+1),a
            ld   (xL4+1),a
            ld   (xL5+1),a
            ld   (xL6+1),a






 ИНИЦИАЛИЗАЦИЯ РИСОВАНИЯ КРУГА И ЕГО
 КЛИПИНГА
■h-yh,l-xh;hl-yHxH

            inc  h:ld a,h:dec a
            ld   (BRX),a
            ld   (BRX1+1),a
            ld   (BRX2+1),a


            ld   a,e:inc a
            ld   (LENS+1),a
            ld   (LENS2+1),a
            or   a:rra

            ld   (MX1+1),a
            ld   (MIDX),a

            ld   (MX81+1),a
            ld   (MX82+1),a
            ld   (MX83+1),a
            ld   (MX84+1),a
            ld   (MX85+1),a
            ld   (MX86+1),a
            ld   (MX87+1),a
            ld   (MX88+1),a
            ld   (MX89+1),a
            ld   (MIDX8),a

            ld   (MIDX0),a

■        inca
            ld   (MX11+1),a

            sub  2
            ld   (MX91+1),a
            ld   (MX92+1),a
            ld   (MX93+1),a


            ld   a,h:rra
            ld   (MIDY),a
            ld   (MY1+1),a
            ld   (MY2+1),a
            ld   (MY3+1),a

            ld   c,e

            ld   l,h
            ld   h,TBXX2_.h
            ld   d,(hl):inc h:ld e,(hl)
            ld   (ADH),de

            ld   hl,TBXX2_
            ld   d,(hl):inc h:ld e,(hl):inc h
            ld   l,0;8
            ld   (ADL),de

            ld   a,(hl)
            ld   (SL1+1),a
            ld   (SL2+1),a
            ld   (SL3+1),a

            ld   l,c
            ld   a,(hl);:deca
            ld   (SH1+1),a
            ld   (SH2+1),a
            ld   (SH3+1),a
            ld   (SH4+1),a

            ret





OUTLINE
■hl-ВЕКТОР КООРДИНАТ
■de-ВЕКТОР МАСКИ


 РИСОВАНИЕ ЛИНИИ С КЛИПИРОВАНИЕМ
■hl-ВЕКТОР
■1:1 - КОЛИЧЕСТВО УЗЛОВ БИТЫ 0-3
■1:1 - МАСКА ПОСЛЕ and#30 БИТЫ 4-5
■      =#00 - andМСАКА
■      =#10 - orМАСКА
■      - ИНАЧЕ xorМАСКА
■3..:1 - НОМЕРА УЗЛОВ

 В БУФЕРЕ DOTCO
 ХРАНИМ КООРДИНАТЫ ТОЧЕК ПО ПОРЯДКОВЫМ
 НОМЕРАМ, СНАЧАЛА НУЛЕВОЙ УЗЕЛ И Т.Д.
 ПО 2 (ДВА) БАЙТА НА КООРДИНАТУ И МАСКУ
■X(2),y(2),MASK(1)

 В БУФЕРЕ DOTCLP БУДУТ НАХОДИТЬСЯ КООРД.
 КЛИПИРОВАННОЙ ЛИНИИИ. x(1),y(1)

 ВЕКТОР КООРДИНАТ
■1:2 - x,y КАРТЫ
■2:2 - x,y В КАРТЕ

 ПРЕОБРАЗОВАНИЕ ДАННЫХ О ЗВЕЗДЕ В
 КООРДИНАТЫ

■hl-ВЕКТОР КООРДИНАТ
■de-ВЕКТОР МАСКИ
            ld   a,(de)
            and  #0F
            ret  z:dec a:ret z:inc a
            push de
            ld   de,DOTCO
L_
            exa
            INC_HL 2
            ld   a,(EYEX)
            ld   c,a
            ld   a,(hl):sub c
            ld   (de),a:inc de:DEC_HL 2
            ld   a,(KCORD)
            ld   c,a
            ld   a,(hl):sbc a,c
            ld   (de),a:inc de:INC_HL 3

            ld   a,(EYEY)
            ld   c,a
            ld   a,(hl):sub c
            ld   (de),a:inc de:DEC_HL 2
            ld   a,(KCORD+1)
            ld   c,a
            ld   a,(hl)
            sbc  a,c
            ld   (de),a:INC_DE 2:INC_HL 4

            exa
            dec  a
            jp   nz,L_

            pop  hl

            exx
            call VsLINE
            ret  z
            ld   b,a
            cpl
            and  #F0
            ret  nz
            exx

            ld   a,(hl)
ld8b2       and  #0F
            ld   b,a
            dec  b
            ld   a,(hl)
            inc  hl
            and  #30
            jr   z,ld8d2;andMASK
            cp   #10
            jr   z,ld8da;orMASK
■xorMASK
■COMAND xorc:jrc,
            ld   de,#38A9
            ld   a,ld1l.b
            jp   ld8df
■COMAND andc:jrnc,
ld8d2       ld   de,#30A1
            ld   a,ld1l.b+8
            jp   ld8df
■COMAND orc:jrc,
ld8da       ld   de,#38B1
            ld   a,ld1l.b
ld8df       ld   (COM1),de
            ld   (ldadd),a
            ld   xh,DOTCO.h
            ld   a,(hl)
            ld   xl,a
            inc  hl
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (x1),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (y1),de
            ld   a,(ix+#04)
            ld   (MK1),a
ld907       ld   a,(hl)
            ld   xl,a
            inc  hl
            push bc
            push hl
            ld   hl,(x1)
            ld   (x2),hl
            ld   hl,(y1)
            ld   (y2),hl
            ld   a,(MK1)
            ld   (MK2),a
            ld   b,a
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (x1),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (y1),de
            and  a
            ld   a,(ix+#04)
            ld   (MK1),a
            jr   z,ld967
            and  a
            jr   z,ld967
            or   b
            ld   b,a
            cpl
            and  #F0
            jr   nz,ld967
            ld   a,b
            and  #0F
            jr   nz,ld96e
            ld   a,(x2)
            ld   (Cx2),a
            ld   a,(y2)
            ld   (Cy2),a
            ld   a,(x1)
            ld   (Cx1),a
            ld   a,(y1)
            ld   (Cy1),a
ld964       call DrwLin
ld967       pop  hl
            pop  bc
            djnz ld907
            ret
ld96e       ld   hl,(x2)
            ld   (xC2),hl
            ld   hl,(y2)
            ld   (yC2),hl
            ld   a,(MK2)
            ld   (MC2),a
            ld   hl,(x1)
            ld   (xC1),hl
            ld   hl,(y1)
            ld   (yC1),hl
            ld   a,(MK1)
            ld   (MC1),a
            push ix
            call ClipLin
            pop  ix
            jr   nz,ld967
            ld   hl,DOTCLP
            ld   a,(hl)
            inc  l
            ld   (Cx2),a
            ld   a,(hl)
            inc  l
            ld   (Cy2),a
            ld   a,(hl)
            inc  l
            ld   (Cx1),a
            ld   a,(hl)
            ld   (Cy1),a
            jp   ld964







DrwLin
            ld   hl,(Cx2)
            ld   de,(Cx1)
            SUB_DE
            ret  z
            add  hl,de
■DRAW LINE CORDS inhl,de
■h,d-y : l,e-x
;DrawL1
            ld   a,d
            sub  h
            jr   nc,ldad8
            EXD
            neg
ldad8       ld   d,a
            ld   a,l
            and  #07
            add  a,0
ldadd       equ  $-#0001
            ld   c,a
            ld   a,ld1l.h
            adc  a,0
            ld   b,a
            ld   a,(bc)

 ПОЛУЧАЕМ АДРЕС НА ЭКРАНЕ В ОКНЕ
            exa
            ld   c,l
            ld   l,h
            ld   h,TBXX2_.h
            ld   b,(hl):inc h
            ld   a,(hl):inc h:ld l,c
            add  a,(hl):ld l,a
            ld   h,b
            ld   a,c:exa:ld c,a:exa

            sub  e
            jr   c,ldb59
            cp   d
            jr   c,ldb2d
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            exa
■PUT INSIDE COMAND FOR THIS LINE
            ld   a,(COM1);COMAND 1
            ld   (ldb0d),a
            ld   a,(COM1+1);COMAND 2
            ld   (ldb10),a
            ld   a,(hl)
ldb0d       nop
            rlc  c
ldb10       jr   c,ldb1d
ldb12       exa
            sub  e
            jr   c,ldb23
            exa
            djnz ldb0d
            ld   (hl),a
            ret
ldb1d       ld   (hl),a
            dec  l
            ld   a,(hl)
            jp   ldb12
ldb23       add  a,d
            exa
            ld   (hl),a

            NEXTLINE

            ld   a,(hl)
            djnz ldb0d
            ret
ldb2d       ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            exa
            ld   a,(COM1)
            ld   (ldb40),a
            ld   a,(COM1+1)
            ld   (ldb4a),a
ldb3f       ld   a,(hl)
ldb40       nop
            ld   (hl),a

            NEXTLINE

            exa
            sub  e
            jr   nc,ldb4c
            add  a,d
            rlc  c
ldb4a       jr   c,ldb52
ldb4c       exa
            djnz ldb3f
            ret
ldb52       dec  l
            exa
            djnz ldb3f
            ret
ldb59       neg
            cp   d
            jr   c,ldb91
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            exa
            ld   a,(COM1)
            ld   (ldb71),a
            ld   a,(COM1+1)
            ld   (ldb74),a
            ld   a,(hl)
ldb71       nop
            rrc  c
ldb74       jr   c,ldb81
ldb76       exa
            sub  e
            jr   c,ldb87
            exa
            djnz ldb71
            ld   (hl),a
            ret
ldb81       ld   (hl),a
            inc  l
            ld   a,(hl)
            jp   ldb76
ldb87       add  a,d
            exa
            ld   (hl),a

            NEXTLINE

            ld   a,(hl)
            djnz ldb71
            ret
ldb91       ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            exa
            ld   a,(COM1)
            ld   (ldba4),a
            ld   a,(COM1+1)
            ld   (ldbae),a
ldba3       ld   a,(hl)
ldba4       nop
            ld   (hl),a

            NEXTLINE

            exa
            sub  e
            jr   nc,ldbb0
            add  a,d
            rrc  c
ldbae       jr   c,ldbb6
ldbb0       exa
            djnz ldba3
            ret
ldbb6       inc  l
            exa
            djnz ldba3
            ret




■bcЯKИeMACKИ
            ds   $-1/16*16-$+16
ld1l
            dw   #4080
            dw   #1020
            dw   #0408
            dw   #0102
            dw   #BF7F
            dw   #EFDF
            dw   #FBF7
            dw   #FEFD


VsLINE
■CHECK WISIBILITy OF LINE
            ld   hl,DOTCO+1
            xor  a
            exa

            exx:ld a,(hl):exx
            and  #0F:ld b,a:add a,a
            add  a,a
            add  a,b
            ld   b,a

LD84        ld   c,0
            ld   a,(hl)
            and  a
            jp   m,V_1
            jp   nz,V_2
            dec  l
            ld   a,(hl)
            inc  l
xH7         cp   #FF;+1
            jr   nc,V_2
            jp   V_3
V_1
            set  1,c
            jp   V_3
V_2
            set  0,c
V_3
            inc  l,l
            ld   a,(hl)
            and  a
            jp   m,V_4
            jp   nz,V_5
            dec  l
            ld   a,(hl)
            inc  l
yH6         cp   #FF;+1
            jr   nc,V_5
            jp   V_6
V_4
            set  3,c
            jp   V_6
V_5
            set  2,c
V_6
            inc  l
            ld   a,c
            rlca
            rlca
            rlca
            rlca
            xor  #F0
            or   c
            ld   (hl),a
            exa
            or   (hl)
            exa
LD83        inc  l
            ld   a,l
            inc  l
            cp   b
            jp   nz,LD84
            exa
            ret




■LINES CLIPPING
ClipLin
            ld   a,#01
            ld   (SET2),a
            ld   a,(MC2)
            cp   #F0
            jr   nz,ld16e
            ld   b,a
            ld   a,(MC1)
            ld   (MC2),a
            ld   a,b
            ld   (MC1),a
            ld   hl,(xC2)
            ld   de,(xC1)
            ld   (xC1),hl
            ld   (xC2),de
            ld   hl,(yC2)
            ld   de,(yC1)
            ld   (yC1),hl
            ld   (yC2),de
ld16e       xor  a
            ld   (SET3),a
            ld   a,(MC2)
            cpl
            and  #F0
            ld   l,a
            ld   a,(MC1)
            and  #0F
            or   l
            ld   l,a
            ld   h,l95.h
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            EXD
            ld   de,ld18d
            push de
            push de
            push de
            jp   (hl)
ld18d       ld   a,(SET3)
            pop  de
            pop  de
            cp   #04
            ret


 ПРОЦЕДУРЫ КЛИППИРОВАНИЯ
lc902       ret
lc903       call lcd1e
lc906       call lcd5c
lc909       call lce87
            jp   m,lcda7
            call lcdf9
lc912       ld   hl,SET1
            bit  0,(hl)
            jp   nz,lce40
            set  0,(hl)
            ret
lc91d       call lcd1e
lc920       call lcd3d
lc923       call lce73
            jp   m,lcdd0
            call lcda7
lc92c       ld   hl,SET1
            bit  1,(hl)
            jp   nz,lce35
            set  1,(hl)
            ret
lc937       call lccff
lc93a       call lcd5c
lc93d       call lce5f
            jp   m,lcdf9
            call lcd7e
lc946       ld   hl,SET1
            bit  2,(hl)
            jp   nz,lce2a
            set  2,(hl)
            ret
lc951       call lccff
lc954       call lcd3d
lc957       call lce4b
            jp   m,lcd7e
            call lcdd0
lc960       ld   hl,SET1
            bit  3,(hl)
            jp   nz,lce1f
            set  3,(hl)
            ret
lc96b       call lcdf6
            jp   lceb1
lc971       call lcdf6
            jp   lcdcd
lc977       call lcd5c
lc97a       call lcd1e
            call lce87
            jp   p,lce40
            call lcdf9
            jp   lcda7
lc989       call lcd5c
lc98c       call lcd1e
            call lce87
            jp   m,lc99b
            call lce40
            jp   lc92c
lc99b       call lcdf9
            jp   lc920
lc9a1       call lcd5c
lc9a4       call lccff
            call lce5f
            jp   m,lcec8
            call lcdf9
            jp   lcd7e
lc9b3       call lce9b
            jp   m,lcec8
            ret
lc9ba       call lcd5c
lc9bd       call lccff
            call lce5f
            jp   m,lcec8
            call lcdf9
            jp   lc954
lc9cc       call lcdcd
            jp   lceb1
lc9d2       call lcdcd
            jp   lcdf6
lc9d8       call lcd3d
lc9db       call lcd1e
            call lce73
            jp   m,lcec8
            call lcdd0
            jp   lcda7
lc9ea       call lcd3d
lc9ed       call lcd1e
            call lce73
            jp   m,lcec8
            call lcdd0
            jp   lc906
lc9fc       call lce9b
            jp   p,lcec8
            ret
lca03       call lcd3d
lca06       call lccff
            call lce4b
            jp   p,lce1f
            call lcdd0
            jp   lcd7e
lca15       call lcd3d
lca18       call lccff
            call lce4b
            jp   m,lca27
            call lce1f
            jp   lc946
lca27       call lcdd0
            jp   lc93a
lca2d       call lcda4
            jp   lceb1
lca33       call lcd1e
lca36       call lcd5c
            call lce87
            jp   m,lcec8
            call lcda7
            jp   lcdf9
lca45       call lcd1e
lca48       call lcd3d
            call lce73
            jp   p,lce35
            call lcda7
            jp   lcdd0
lca57       call lcea6
            jp   m,lcec8
            ret
lca5e       call lcda4
            jp   lcd7b
lca64       call lcd1e
lca67       call lcd5c
            call lce87
            jp   m,lcec8
            call lcda7
            call lccff
            jp   lc93d
lca79       call lcd1e
lca7c       call lcd3d
            call lce73
            jp   m,lca8b
            call lce35
            jp   lc960
lca8b       call lcda7
            call lccff
            jp   lc957
lca94       call lcd1e
            call lcd5c
            call lce87
            jp   m,lcc13
            ld   hl,SET1
            bit  0,(hl)
            set  0,(hl)
            call nz,lce40
lcaaa       call lcda7
            jp   lceb1
lcab0       call lce9b
            jp   p,lcec8
            ret
lcab7       call lcd1e
            call lcd5c
            call lce87
            jp   m,lcad0
            ld   hl,SET1
            bit  0,(hl)
            set  0,(hl)
            call nz,lce40
            jp   lca48
lcad0       call lcdf9
            jp   lcdcd
lcad6       ld   hl,SET1
            bit  0,(hl)
            jp   nz,lce40
            set  0,(hl)
            ret
lcae1       call lcad6
            jp   lc92c
lcae7       call lcd1e
            call lcd5c
            call lce87
            jp   m,lc9a4
            call lcad6
            call lcda7
            jp   lcd7b
lcafc       call lcd1e
            call lcd5c
            call lce87
            jp   m,lc9bd
            ld   hl,SET1
            bit  0,(hl)
            set  0,(hl)
            call nz,lce40
            jp   lca7c
lcb15       call lcd1e
            call lcd3d
            call lce73
            jp   m,lcaaa
            ld   hl,SET1
            bit  1,(hl)
            set  1,(hl)
            call nz,lce35
lcb2b       call lcdd0
            jp   lceb1
lcb31       call lcd1e
            call lcd3d
            call lce73
            jp   m,lca36
            call lcb46
            call lcdd0
            jp   lcdf6
lcb46       ld   hl,SET1
            bit  1,(hl)
            jp   nz,lce35
            set  1,(hl)
            ret
lcb51       call lcea6
            jp   p,lcec8
            ret
lcb58       call lcd1e
            call lcd3d
            call lce73
            jp   m,lcb71
            ld   hl,SET1
            bit  1,(hl)
            set  1,(hl)
            call nz,lce35
            jp   lca06
lcb71       call lcda7
            jp   lcd7b
lcb77       call lcd1e
            call lcd3d
            call lce73
            jp   m,lca67
            ld   hl,SET1
            bit  1,(hl)
            set  1,(hl)
            call nz,lce35
            jp   lca18
lcb90       call lcb46
            jp   lc960
lcb96       call lcd7b
            jp   lceb1
lcb9c       call lccff
lcb9f       call lcd5c
            call lce5f
            jp   p,lce2a
            call lcd7e
            jp   lcdf9
lcbae       call lccff
lcbb1       call lcd3d
            call lce4b
            jp   m,lcec8
            call lcd7e
            jp   lcdd0
lcbc0       call lcd7b
            jp   lcda4
lcbc6       call lccff
lcbc9       call lcd5c
            call lce5f
            jp   m,lcbd8
            call lce2a
            jp   lc912
lcbd8       call lcd7e
            call lcd1e
            jp   lc909
lcbe1       call lccff
lcbe4       call lcd3d
            call lce4b
            jp   m,lcec8
            call lcd7e
            call lcd1e
            jp   lc923
lcbf6       call lcea6
            jp   p,lcec8
            ret
lcbfd       call lccff
            call lcd5c
            call lce5f
            jp   m,lcc94
            ld   hl,SET1
            bit  2,(hl)
            set  2,(hl)
            call nz,lce2a
lcc13       call lcdf9
            jp   lceb1
lcc19       ld   hl,SET1
            bit  2,(hl)
            jp   nz,lce2a
            set  2,(hl)
            ret
lcc24       call lccff
            call lcd5c
            call lce5f
            jp   m,lcbb1
            call lcc19
            call lcdf9
            jp   lcdcd
lcc39       call lccff
            call lcd5c
            call lce5f
            jp   m,lcc52
            ld   hl,SET1
            bit  2,(hl)
            set  2,(hl)
            call nz,lce2a
            jp   lc97a
lcc52       call lcd7e
            jp   lcda4
lcc58       call lcc19
            jp   lc912
lcc5e       call lccff
            call lcd5c
            call lce5f
            jp   m,lcbe4
            ld   hl,SET1
            bit  2,(hl)
            set  2,(hl)
            call nz,lce2a
            jp   lc98c
lcc77       call lcea6
            jp   m,lcec8
            ret
lcc7e       call lccff
            call lcd3d
            call lce4b
            jp   m,lcb2b
            ld   hl,SET1
            bit  3,(hl)
            set  3,(hl)
            call nz,lce1f
lcc94       call lcd7e
            jp   lceb1
lcc9a       call lccff
            call lcd3d
            call lce4b
            jp   m,lccb3
            ld   hl,SET1
            bit  3,(hl)
            set  3,(hl)
            call nz,lce1f
            jp   lcb9f
lccb3       call lcdd0
            jp   lcdf6
lccb9       call lce9b
            jp   m,lcec8
            ret
lccc0       call lccff
            call lcd3d
            call lce4b
            jp   m,lc9db
            call lccee
            call lcd7e
            jp   lcda4
lccd5       call lccff
            call lcd3d
            call lce4b
            jp   m,lc9ed
            ld   hl,SET1
            bit  3,(hl)
            set  3,(hl)
            call nz,lce1f
            jp   lcbc9
lccee       ld   hl,SET1
            bit  3,(hl)
            jp   nz,lce1f
            set  3,(hl)
            ret
lccf9       call lccee
            jp   lc946
lccff       ld   bc,(xC1)
            ld   hl,(xC2)
            SUB_BC
            EXD
yL1         ld   bc,0
            ld   hl,(yC2)
            SUB_BC
            call MUll
            ld   (xy1),de
            ld   (xy1+2),hl
            ret
lcd1e       ld   bc,(xC1)
            ld   hl,(xC2)
            SUB_BC
            EXD
yH1         ld   bc,#FF
            ld   hl,(yC2)
            SUB_BC
            call MUll
            ld   (xy2),de
            ld   (xy2+2),hl
            ret
lcd3d
xL1         ld   bc,0
            ld   hl,(xC2)
            SUB_BC
            EXD
            ld   bc,(yC1)
            ld   hl,(yC2)
            SUB_BC
            call MUll
            ld   (xy3),de
            ld   (xy3+2),hl
            ret
lcd5c
xH1         ld   bc,#00FF
            ld   hl,(xC2)
            SUB_BC
            EXD
            ld   bc,(yC1)
            ld   hl,(yC2)
            SUB_BC
            call MUll
            ld   (xy4),de
            ld   (xy4+2),hl
            ret
lcd7b       call lccff
lcd7e       ld   a,(xy1)
            exa
            ld   a,(xy1+1)
            ld   hl,(yC1)
            ld   de,(yC2)
            SUB_DE
            EXD
            ld   hl,(xy1+2)
            call DIvv
            ld   de,(xC2)
            add  hl,de
            ld   a,h
            and  a
            jr   z,$+24
            jp   p,$+20
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xL2         ld   (hl),0
            inc  l
yL2         ld   (hl),0
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
xH2         ld   l,#FF
            ld   e,l
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
            ld   (hl),e
            inc  l
yL3         ld   (hl),0
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
lcda4       call lcd1e
lcda7       ld   a,(xy2)
            exa
            ld   a,(xy2+1)
            ld   hl,(yC1)
            ld   de,(yC2)
            SUB_DE
            EXD
            ld   hl,(xy2+2)
            call DIvv
            ld   de,(xC2)
            add  hl,de
            ld   a,h
            and  a
            jr   z,$+24
            jp   p,$+20
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xL3         ld   (hl),0
            inc  l
yH2         ld   (hl),#FF
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
xH3         ld   l,#FF
            ld   e,l
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
            ld   (hl),e
            inc  l
yH3         ld   (hl),#FF
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
lcdcd       call lcd3d
lcdd0       ld   a,(xy3)
            exa
            ld   a,(xy3+1)
            ld   hl,(xC1)
            ld   de,(xC2)
            SUB_DE
            EXD
            ld   hl,(xy3+2)
            call DIvv
            ld   de,(yC2)
            add  hl,de
            ld   a,h
            and  a
            jp   m,IO1
            ld   a,l
            cp   192
            jp   c,IO2
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xL4         ld   (hl),0
            inc  l
yH4         ld   (hl),#FF
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
IO1
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xL5         ld   (hl),0
            inc  l
yL4         ld   (hl),0
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
IO2
            ld   d,l
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xL6         ld   (hl),0
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
lcdf6       call lcd5c
lcdf9       ld   a,(xy4)
            exa
            ld   a,(xy4+1)
            ld   hl,(xC1)
            ld   de,(xC2)
            SUB_DE
            EXD
            ld   hl,(xy4+2)
            call DIvv
            ld   de,(yC2)
            add  hl,de
            ld   a,h
            and  a
            jp   m,IO4
            ld   a,l
            cp   192
            jp   c,IO3
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xH4         ld   (hl),#FF
            inc  l
yH5         ld   (hl),#FF
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
IO4
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xH5         ld   (hl),#FF
            inc  l
yL5         ld   (hl),0
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
IO3
            ld   d,l
            ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
xH6         ld   (hl),#FF
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
lce1f       ld   a,(SET2)
            and  a
            ret  nz
yLxL        ld   de,0
            jp   lceb9
lce2a       ld   a,(SET2)
            and  a
            ret  nz
yLxH        ld   de,#00FF
            jp   lceb9
lce35       ld   a,(SET2)
            and  a
            ret  nz
yHxL        ld   de,#FF00
            jp   lceb9
lce40       ld   a,(SET2)
            and  a
            ret  nz
yHxH        ld   de,#FFFF
            jp   lceb9
lce4b
            ld   hl,(xy1)
            ld   bc,(xy3)
            SUB_BC
            ld   hl,(xy1+2)
            ld   bc,(xy3+2)
            sbc  hl,bc
            ret
lce5f
            ld   hl,(xy1)
            ld   bc,(xy4)
            SUB_BC
            ld   hl,(xy1+2)
            ld   bc,(xy4+2)
            sbc  hl,bc
            ret
lce73
            ld   hl,(xy2)
            ld   bc,(xy3)
            SUB_BC
            ld   hl,(xy2+2)
            ld   bc,(xy3+2)
            sbc  hl,bc
            ret
lce87
            ld   hl,(xy2)
            ld   bc,(xy4)
            SUB_BC
            ld   hl,(xy2+2)
            ld   bc,(xy4+2)
            sbc  hl,bc
            ret
lce9b       ld   hl,(xC1)
            ld   de,(xC2)
            SUB_DE
            ret
lcea6       ld   hl,(yC1)
            ld   de,(yC2)
            SUB_DE
            ret
lceb1       ld   a,(xC1)
            ld   e,a
            ld   a,(yC1)
            ld   d,a
lceb9       ld   a,(SET3)
            ld   l,a
            ld   h,DOTCLP.h
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (SET3),a
            ret
lcec8       pop  af
            pop  bc
            pop  hl
            ld   c,b
            dec  c
            ld   b,0
            add  hl,bc
            scf
            ret






 УMHOЖEHИeHLDE=hl*de
MUll        ld   a,h
            xor  d
            push af
            ABSDE
            ABSHL
            EXD
            ld   a,d
            and  a
            jp   z,lcfda
            ld   a,h
            and  a
            jp   z,lcfdf
            ld   bc,0
            ld   ix,0
            ADDHLHL 2
            jp   c,lcf2a
            add  hl,hl
            jp   c,lcf34
            add  hl,hl
            jp   c,lcf3e
            add  hl,hl
            jp   c,lcf48
            add  hl,hl
            jp   c,lcf52
            add  hl,hl
            jp   c,lcf5c
            add  hl,hl
            jp   lcf66
lcf2a       add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
lcf34       add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
lcf3e       add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
lcf48       add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
lcf52       add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
lcf5c       add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
lcf66
            rept 8:add ix,de:adc hl,bc:ADDIXIX:adc hl,hl:jrnc $+6:endr

            add  ix,de
            adc  hl,bc
            ld   d,xh
            ld   e,xl
lcfbe       pop  af
            ret  p
            ld   b,h
            ld   c,l
            ld   hl,0
            sbc  hl,de
            EXD
            ld   hl,0
            sbc  hl,bc
            ret
lcfda       ld   a,h
            and  a
            jr   z,ld030
            EXD
lcfdf       ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jr   c,lcffd
            add  a,a
            jr   c,ld003
            add  a,a
            jr   c,ld009
            add  a,a
            jr   c,ld00f
            add  a,a
            jr   c,ld015
            add  a,a
            jr   c,ld01b
            add  a,a
            jr   c,ld021
            add  a,a
            jr   c,ld027
            jp   ld029
lcffd       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld003       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld009       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld00f       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld015       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld01b       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld021       add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
ld027       add  hl,de
            adc  a,c
ld029
            EXD
            ld   l,a
            ld   h,0
            jp   lcfbe
ld030       rr   e
            jr   c,ld053
            rr   e
            jr   c,ld059
            rr   e
            jr   c,ld05f
            rr   e
            jr   c,ld065
            rr   e
            jr   c,ld06b
            rr   e
            jr   c,ld071
            rr   e
            jr   c,ld077
            rr   e
            jr   c,ld07d
            jp   ld081
ld053       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld059       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld05f       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld065       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld06b       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld071       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld077       add  a,l
            rra
            rr   e
            jr   nc,$+3
ld07d       add  a,l
            rra
            rr   e
ld081       ld   d,a
            ld   l,h
            jp   lcfbe

 ДeЛEHИehl=hl/de
DIvv        ld   xl,0
            jp   p,ld098
            EXD
            ld   b,h
            ld   c,l
            ld   hl,0
            SUB_BC
            EXD
            inc  xl
ld098       bit  7,h
            jr   z,ld0aa
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
ld0aa
            rept 8:rla:adc hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr

            rla
            exa
            rept 8:rla:adc hl,hl:sbc hl,de:jrnc $+3:add hl,de:endr

            rla
            dec  xl
            jr   nz,$+6
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




            ADRXX00

l95
            db   lceb1.b
            db   lcdf6.b
            db   lcdcd.b
            db   0
            db   lcda4.b
            db   lc903.b
            db   lc91d.b
            db   0
            db   lcd7b.b
            db   lc937.b
            db   lc951.b
x1          dw   0
y1          dw   0
MK1         db   0
            db   lc96b.b
            db   lc902.b
            db   lc971.b
            db   0
            db   lc977.b
            db   lc912.b
            db   lc989.b
            db   0
            db   lc9a1.b
            db   lc9b3.b
            db   lc9ba.b
x2          dw   0
y2          dw   0
MK2         db   0
            db   lc9cc.b
            db   lc9d2.b
            db   lc902.b
            db   0
            db   lc9d8.b
            db   lc9ea.b
            db   lc9fc.b
            db   0
            db   lca03.b
            db   lca15.b
            db   lc960.b

Cx2         db   0
Cy2         db   0
Cx1         db   0
Cy1         db   0
xC2         dw   0
yC2         dw   0
MC2         db   0
xC1         dw   0
yC1         dw   0
MC1         db   0
SET1        db   0
SET2        db   0
SET3        db   0
COM1        dw   0

            dw   0
            db   lca2d.b
            db   lca33.b
            db   lca45.b
            db   0
            db   lc902.b
            db   lca57.b
            db   lc92c.b
            db   0
            db   lca5e.b
            db   lca64.b
            db   lca79.b
            db   0,0,0,0,0
            db   lca94.b
            db   lcab0.b
            db   lcab7.b
            db   0
            db   lcad6.b
            db   lc902.b
            db   lcae1.b
            db   0
            db   lcae7.b
            db   lcec8.b
            db   lcafc.b
            db   0,0,0,0,0
            db   lcb15.b
            db   lcb31.b
            db   lcb46.b
            db   0
            db   lcb51.b
            db   lcec8.b
            db   lc902.b
            db   0
            db   lcb58.b
            db   lcb77.b
            db   lcb90.b

xy1         dw   0,0
xy2         dw   0,0
xy3         dw   0,0
xy4         dw   0,0

            ds   5
            db   lcb96.b
            db   lcb9c.b
            db   lcbae.b
            db   0
            db   lcbc0.b
            db   lcbc6.b
            db   lcbe1.b
            db   0
            db   lc902.b
            db   lc946.b
            db   lcbf6.b
            db   0,0,0,0,0
            db   lcbfd.b
            db   lcc19.b
            db   lcc24.b
            db   0
            db   lcc39.b
            db   lcc58.b
            db   lcc5e.b
            db   0
            db   lcc77.b
            db   lc902.b
            db   lcec8.b
            db   0,0,0,0,0
            db   lcc7e.b
            db   lcc9a.b
            db   lccb9.b
            db   0
            db   lccc0.b
            db   lccd5.b
            db   lcec8.b
            db   0
            db   lccee.b
            db   lccf9.b
            db   lc902.b

            ADRXX00

l96
            db   lceb1.h
            db   lcdf6.h
            db   lcdcd.h
            db   0
            db   lcda4.h
            db   lc903.h
            db   lc91d.h
            db   0
            db   lcd7b.h
            db   lc937.h
            db   lc951.h
            db   0,0,0,0,0
            db   lc96b.h
            db   lc902.h
            db   lc971.h
            db   0
            db   lc977.h
            db   lc912.h
            db   lc989.h
            db   0
            db   lc9a1.h
            db   lc9b3.h
            db   lc9ba.h
            db   0,0,0,0,0
            db   lc9cc.h
            db   lc9d2.h
            db   lc902.h
            db   0
            db   lc9d8.h
            db   lc9ea.h
            db   lc9fc.h
            db   0
            db   lca03.h
            db   lca15.h
            db   lc960.h
            ds   21
            db   lca2d.h
            db   lca33.h
            db   lca45.h
            db   0
            db   lc902.h
            db   lca57.h
            db   lc92c.h
            db   0
            db   lca5e.h
            db   lca64.h
            db   lca79.h
            db   0,0,0,0,0
            db   lca94.h
            db   lcab0.h
            db   lcab7.h
            db   0
            db   lcad6.h
            db   lc902.h
            db   lcae1.h
            db   0
            db   lcae7.h
            db   lcec8.h
            db   lcafc.h
            db   0,0,0,0,0
            db   lcb15.h
            db   lcb31.h
            db   lcb46.h
            db   0
            db   lcb51.h
            db   lcec8.h
            db   lc902.h
            db   0
            db   lcb58.h
            db   lcb77.h
            db   lcb90.h
            ds   21
            db   lcb96.h
            db   lcb9c.h
            db   lcbae.h
            db   0
            db   lcbc0.h
            db   lcbc6.h
            db   lcbe1.h
            db   0
            db   lc902.h
            db   lc946.h
            db   lcbf6.h
            db   0,0,0,0,0
            db   lcbfd.h
            db   lcc19.h
            db   lcc24.h
            db   0
            db   lcc39.h
            db   lcc58.h
            db   lcc5e.h
            db   0
            db   lcc77.h
            db   lc902.h
            db   lcec8.h
            db   0,0,0,0,0
            db   lcc7e.h
            db   lcc9a.h
            db   lccb9.h
            db   0
            db   lccc0.h
            db   lccd5.h
            db   lcec8.h
            db   0
            db   lccee.h
            db   lccf9.h
            db   lc902.h

