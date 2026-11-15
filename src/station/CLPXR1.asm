;==============================================================================
; CLPXR1 - клиппирование линий и многоугольников для 3D (оверлей D3D)
;
; Где живёт: оверлей D3D.C, ORG #C000, страница PG3D (#14); после XR2 и BODY3D.
;
; Что делает: Cohen-Sutherland-подобное отсечение линий окном (Clip и цепочка Lc9xx/Lcxxx, границы
; XL/XH/YL/YH патчатся InitClip3D), вспомогательные проверки точек; результат - вершины для
; DrawPolygon (XR2). Тот же алгоритм, что DRAWLIN.asm (там для карты), но с адресами в оверлее D3D.
; Имена вида Lc9xx - автоматические имена дизассемблера (адрес в исходной раскладке #C000).
;==============================================================================

Clip
            xor  a
            ld   (L91+#2F),a
            ld   (L91+#0A),a
            ld   (L91+#2E),a
            push hl
            ld   a,b
            dec  a
            add  a,l
            ld   l,a
            ld   a,h
            adc  a,#00
            ld   h,a
            ld   l,(hl)
            ld   h,L9c
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (L91+#1B),de
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (L91+#1D),de
            ld   a,(hl)
            ld   (L91+#1F),a
.Lc8b2
            ld   hl,(L91+#1B)
            ld   (L91+#0B),hl
            ld   hl,(L91+#1D)
            ld   (L91+#0D),hl
            ld   a,(L91+#1F)
            ld   (L91+#0F),a
            pop  hl
            ld   a,(hl)
            inc  hl
            push hl
            push bc
            ld   l,a
            ld   h,L9c
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (L91+#1B),de
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (L91+#1D),de
            ld   a,(hl)
            ld   (L91+#1F),a
            ld   a,(L91+#0F)
            cpl
            and  #F0
            ld   l,a
            ld   a,(L91+#1F)
            and  #0F
            or   l
            ld   l,a
            ld   h,high(L95)
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            EXD
            ld   de,.Lc8f9
            push de
            jp   (hl)
.Lc8f9
            pop  bc
            djnz .Lc8b2
            pop  hl
            ld   a,(L91+#0A)
            cp   #06
Lc902
            ret
Lc903
            call Lcd1e
Lc906
            call Lcd5c
Lc909
            call Lce87
            jp   m,Lcda7
            call Lcdf9
Lc912
            ld   hl,L91+#2E
            bit  0,(hl)
            jp   nz,Lce40
            set  0,(hl)
            ret
Lc91d
            call Lcd1e
Lc920
            call Lcd3d
Lc923
            call Lce73
            jp   m,Lcdd0
            call Lcda7
Lc92c
            ld   hl,L91+#2E
            bit  1,(hl)
            jp   nz,Lce35
            set  1,(hl)
            ret
Lc937
            call Lccff
Lc93a
            call Lcd5c
Lc93d
            call Lce5f
            jp   m,Lcdf9
            call Lcd7e
Lc946
            ld   hl,L91+#2E
            bit  2,(hl)
            jp   nz,Lce2a
            set  2,(hl)
            ret
Lc951
            call Lccff
Lc954
            call Lcd3d
Lc957
            call Lce4b
            jp   m,Lcd7e
            call Lcdd0
Lc960
            ld   hl,L91+#2E
            bit  3,(hl)
            jp   nz,Lce1f
            set  3,(hl)
            ret
Lc96b
            call Lcdf6
            jp   Lceb1
Lc971
            call Lcdf6
            jp   Lcdcd
Lc977
            call Lcd5c
Lc97a
            call Lcd1e
            call Lce87
            jp   p,Lce40
            call Lcdf9
            jp   Lcda7
Lc989
            call Lcd5c
Lc98c
            call Lcd1e
            call Lce87
            jp   m,.Lc99b
            call Lce40
            jp   Lc92c
.Lc99b
            call Lcdf9
            jp   Lc920
Lc9a1
            call Lcd5c
Lc9a4
            call Lccff
            call Lce5f
            jp   m,Lcec8
            call Lcdf9
            jp   Lcd7e
Lc9b3
            call Lce9b
            jp   m,Lcec8
            ret
Lc9ba
            call Lcd5c
Lc9bd
            call Lccff
            call Lce5f
            jp   m,Lcec8
            call Lcdf9
            jp   Lc954
Lc9cc
            call Lcdcd
            jp   Lceb1
Lc9d2
            call Lcdcd
            jp   Lcdf6
Lc9d8
            call Lcd3d
Lc9db
            call Lcd1e
            call Lce73
            jp   m,Lcec8
            call Lcdd0
            jp   Lcda7
Lc9ea
            call Lcd3d
Lc9ed
            call Lcd1e
            call Lce73
            jp   m,Lcec8
            call Lcdd0
            jp   Lc906
Lc9fc
            call Lce9b
            jp   p,Lcec8
            ret
Lca03
            call Lcd3d
Lca06
            call Lccff
            call Lce4b
            jp   p,Lce1f
            call Lcdd0
            jp   Lcd7e
Lca15
            call Lcd3d
Lca18
            call Lccff
            call Lce4b
            jp   m,.Lca27
            call Lce1f
            jp   Lc946
.Lca27
            call Lcdd0
            jp   Lc93a
Lca2d
            call Lcda4
            jp   Lceb1
Lca33
            call Lcd1e
Lca36
            call Lcd5c
            call Lce87
            jp   m,Lcec8
            call Lcda7
            jp   Lcdf9
Lca45
            call Lcd1e
Lca48
            call Lcd3d
            call Lce73
            jp   p,Lce35
            call Lcda7
            jp   Lcdd0
Lca57
            call Lcea6
            jp   m,Lcec8
            ret
Lca5e
            call Lcda4
            jp   Lcd7b
Lca64
            call Lcd1e
Lca67
            call Lcd5c
            call Lce87
            jp   m,Lcec8
            call Lcda7
            call Lccff
            jp   Lc93d
Lca79
            call Lcd1e
Lca7c
            call Lcd3d
            call Lce73
            jp   m,.Lca8b
            call Lce35
            jp   Lc960
.Lca8b
            call Lcda7
            call Lccff
            jp   Lc957
Lca94
            call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lcc13
            ld   hl,L91+#2E
            bit  0,(hl)
            set  0,(hl)
            call nz,Lce40
Lcaaa
            call Lcda7
            jp   Lceb1
Lcab0
            call Lce9b
            jp   p,Lcec8
            ret
Lcab7
            call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,.Lcad0
            ld   hl,L91+#2E
            bit  0,(hl)
            set  0,(hl)
            call nz,Lce40
            jp   Lca48
.Lcad0
            call Lcdf9
            jp   Lcdcd
Lcad6
            ld   hl,L91+#2E
            bit  0,(hl)
            jp   nz,Lce40
            set  0,(hl)
            ret
Lcae1
            call Lcad6
            jp   Lc92c
Lcae7
            call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lc9a4
            call Lcad6
            call Lcda7
            jp   Lcd7b
Lcafc
            call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lc9bd
            ld   hl,L91+#2E
            bit  0,(hl)
            set  0,(hl)
            call nz,Lce40
            jp   Lca7c
Lcb15
            call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lcaaa
            ld   hl,L91+#2E
            bit  1,(hl)
            set  1,(hl)
            call nz,Lce35
Lcb2b
            call Lcdd0
            jp   Lceb1
Lcb31
            call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lca36
            call Lcb46
            call Lcdd0
            jp   Lcdf6
Lcb46
            ld   hl,L91+#2E
            bit  1,(hl)
            jp   nz,Lce35
            set  1,(hl)
            ret
Lcb51
            call Lcea6
            jp   p,Lcec8
            ret
Lcb58
            call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,.Lcb71
            ld   hl,L91+#2E
            bit  1,(hl)
            set  1,(hl)
            call nz,Lce35
            jp   Lca06
.Lcb71
            call Lcda7
            jp   Lcd7b
Lcb77
            call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lca67
            ld   hl,L91+#2E
            bit  1,(hl)
            set  1,(hl)
            call nz,Lce35
            jp   Lca18
Lcb90
            call Lcb46
            jp   Lc960
Lcb96
            call Lcd7b
            jp   Lceb1
Lcb9c
            call Lccff
Lcb9f
            call Lcd5c
            call Lce5f
            jp   p,Lce2a
            call Lcd7e
            jp   Lcdf9
Lcbae
            call Lccff
Lcbb1
            call Lcd3d
            call Lce4b
            jp   m,Lcec8
            call Lcd7e
            jp   Lcdd0
Lcbc0
            call Lcd7b
            jp   Lcda4
Lcbc6
            call Lccff
Lcbc9
            call Lcd5c
            call Lce5f
            jp   m,.Lcbd8
            call Lce2a
            jp   Lc912
.Lcbd8
            call Lcd7e
            call Lcd1e
            jp   Lc909
Lcbe1
            call Lccff
Lcbe4
            call Lcd3d
            call Lce4b
            jp   m,Lcec8
            call Lcd7e
            call Lcd1e
            jp   Lc923
Lcbf6
            call Lcea6
            jp   p,Lcec8
            ret
Lcbfd
            call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcc94
            ld   hl,L91+#2E
            bit  2,(hl)
            set  2,(hl)
            call nz,Lce2a
Lcc13
            call Lcdf9
            jp   Lceb1
Lcc19
            ld   hl,L91+#2E
            bit  2,(hl)
            jp   nz,Lce2a
            set  2,(hl)
            ret
Lcc24
            call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcbb1
            call Lcc19
            call Lcdf9
            jp   Lcdcd
Lcc39
            call Lccff
            call Lcd5c
            call Lce5f
            jp   m,.Lcc52
            ld   hl,L91+#2E
            bit  2,(hl)
            set  2,(hl)
            call nz,Lce2a
            jp   Lc97a
.Lcc52
            call Lcd7e
            jp   Lcda4
Lcc58
            call Lcc19
            jp   Lc912
Lcc5e
            call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcbe4
            ld   hl,L91+#2E
            bit  2,(hl)
            set  2,(hl)
            call nz,Lce2a
            jp   Lc98c
Lcc77
            call Lcea6
            jp   m,Lcec8
            ret
Lcc7e
            call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lcb2b
            ld   hl,L91+#2E
            bit  3,(hl)
            set  3,(hl)
            call nz,Lce1f
Lcc94
            call Lcd7e
            jp   Lceb1
Lcc9a
            call Lccff
            call Lcd3d
            call Lce4b
            jp   m,.Lccb3
            ld   hl,L91+#2E
            bit  3,(hl)
            set  3,(hl)
            call nz,Lce1f
            jp   Lcb9f
.Lccb3
            call Lcdd0
            jp   Lcdf6
Lccb9
            call Lce9b
            jp   m,Lcec8
            ret
Lccc0
            call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lc9db
            call Lccee
            call Lcd7e
            jp   Lcda4
Lccd5
            call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lc9ed
            ld   hl,L91+#2E
            bit  3,(hl)
            set  3,(hl)
            call nz,Lce1f
            jp   Lcbc9
Lccee
            ld   hl,L91+#2E
            bit  3,(hl)
            jp   nz,Lce1f
            set  3,(hl)
            ret
Lccf9
            call Lccee
            jp   Lc946
Lccff
            ld   bc,(L91+#1B)
            ld   hl,(L91+#0B)
            SUB_BC
            EXD
YL1
            ld   bc,#0000
            ld   hl,(L91+#0D)
            SUB_BC
            call Lcef2
            ld   (L90+#DC),de
            ld   (L90+#DE),hl
            ret
Lcd1e
            ld   bc,(L91+#1B)
            ld   hl,(L91+#0B)
            SUB_BC
            EXD
YH1
            ld   bc,0
            ld   hl,(L91+#0D)
            SUB_BC
            call Lcef2
            ld   (L90+#EA),de
            ld   (L90+#EC),hl
            ret
Lcd3d
XL1
            ld   bc,#0000
            ld   hl,(L91+#0B)
            SUB_BC
            EXD
            ld   bc,(L91+#1D)
            ld   hl,(L91+#0D)
            SUB_BC
            call Lcef2
            ld   (L90+#EE),de
            ld   (L90+#FA),hl
            ret
Lcd5c
XH1
            ld   bc,#00FF
            ld   hl,(L91+#0B)
            SUB_BC
            EXD
            ld   bc,(L91+#1D)
            ld   hl,(L91+#0D)
            SUB_BC
            call Lcef2
            ld   (L90+#FC),de
            ld   (L90+#FE),hl
            ret
Lcd7b
            call Lccff
Lcd7e
            ld   a,(L90+#DC)
            ex   af,af'
            ld   a,(L90+#DD)
            ld   hl,(L91+#1D)
            ld   de,(L91+#0D)
            SUB_DE
            EXD
            ld   hl,(L90+#DE)
            call Ld086
            ld   de,(L91+#0B)
            add  hl,de
            ld   a,h
            and  a
            jr   z,O_1_+2
            jp   p,O_1_
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XL2
            ld   (hl),0
            inc  l
YL2
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
O_1_
XH2
            ld   l,#FF
            ld   e,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),e
            inc  l
YL3
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Lcda4
            call Lcd1e
Lcda7
            ld   a,(L90+#EA)
            ex   af,af'
            ld   a,(L90+#EB)
            ld   hl,(L91+#1D)
            ld   de,(L91+#0D)
            SUB_DE
            EXD
            ld   hl,(L90+#EC)
            call Ld086
            ld   de,(L91+#0B)
            add  hl,de
            ld   a,h
            and  a
            jr   z,O_2_+2
            jp   p,O_2_
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XL3
            ld   (hl),0
            inc  l
YH2
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
O_2_
XH3
            ld   l,#FF
            ld   e,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),e
            inc  l
YH3
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Lcdcd
            call Lcd3d
Lcdd0
            ld   a,(L90+#EE)
            ex   af,af'
            ld   a,(L90+#EF)
            ld   hl,(L91+#1B)
            ld   de,(L91+#0B)
            SUB_DE
            EXD
            ld   hl,(L90+#FA)
            call Ld086
            ld   de,(L91+#0D)
            add  hl,de
            ld   a,h
            and  a
            jp   m,Io1
            ld   a,l
            cp   192
            jr   c,Io2
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XL4
            ld   (hl),0
            inc  l
YH4
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Io1
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XL5
            ld   (hl),0
            inc  l
YL4
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Io2
            ld   d,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XL6
            ld   (hl),0
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Lcdf6
            call Lcd5c
Lcdf9
            ld   a,(L90+#FC)
            ex   af,af'
            ld   a,(L90+#FD)
            ld   hl,(L91+#1B)
            ld   de,(L91+#0B)
            SUB_DE
            EXD
            ld   hl,(L90+#FE)
            call Ld086
            ld   de,(L91+#0D)
            add  hl,de
            ld   a,h
            and  a
            jp   m,Io4
            ld   a,l
            cp   192
            jr   c,Io3
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XH4
            ld   (hl),#FF
            inc  l
YH5
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Io4
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XH5
            ld   (hl),#FF
            inc  l
YL5
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Io3
            ld   d,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
XH6
            ld   (hl),#FF
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Lce1f
            ld   a,(L91+#2F)
            and  a
            ret  nz
YLXL
            ld   de,#0000
            jp   Lceb9
Lce2a
            ld   a,(L91+#2F)
            and  a
            ret  nz
YLXH
            ld   de,#00FF
            jp   Lceb9
Lce35
            ld   a,(L91+#2F)
            and  a
            ret  nz
YHXL
            ld   de,0
            jp   Lceb9
Lce40
            ld   a,(L91+#2F)
            and  a
            ret  nz
YHXH
            ld   de,0
            jp   Lceb9
Lce4b
            ld   hl,(L90+#DC)
            ld   bc,(L90+#EE)
            SUB_BC
            ld   hl,(L90+#DE)
            ld   bc,(L90+#FA)
            sbc  hl,bc
            ret
Lce5f
            ld   hl,(L90+#DC)
            ld   bc,(L90+#FC)
            SUB_BC
            ld   hl,(L90+#DE)
            ld   bc,(L90+#FE)
            sbc  hl,bc
            ret
Lce73
            ld   hl,(L90+#EA)
            ld   bc,(L90+#EE)
            SUB_BC
            ld   hl,(L90+#EC)
            ld   bc,(L90+#FA)
            sbc  hl,bc
            ret
Lce87
            ld   hl,(L90+#EA)
            ld   bc,(L90+#FC)
            SUB_BC
            ld   hl,(L90+#EC)
            ld   bc,(L90+#FE)
            sbc  hl,bc
            ret
Lce9b
            ld   hl,(L91+#1B)
            ld   de,(L91+#0B)
            SUB_DE
            ret
Lcea6
            ld   hl,(L91+#1D)
            ld   de,(L91+#0D)
            SUB_DE
            ret
Lceb1
            ld   a,(L91+#1B)
            ld   e,a
            ld   a,(L91+#1D)
            ld   d,a
Lceb9
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret
Lcec8
            pop  af
            pop  bc
            pop  hl
            ld   c,b
            dec  c
            ld   b,#00
            add  hl,bc
            scf
            ret


; Квадрат. hlde=hl^2
.Lcef0
            ld   d,h
            ld   e,l
;  Умножениенldе=hl*de
Mull
Lcef2
            ld   a,h
            xor  d
            push af
            ABSHL
            ABSDE
            EXD
            ld   a,d
            and  a
            jp   z,.Lcfda
            ld   a,h
            and  a
            jp   z,.Lcfdf
            ld   bc,#0000
            ld   ix,#0000
            ADDHLHL 2
            jp   c,.Lcf2a
            add  hl,hl
            jp   c,.Lcf34
            add  hl,hl
            jp   c,.Lcf3e
            add  hl,hl
            jp   c,.Lcf48
            add  hl,hl
            jp   c,.Lcf52
            add  hl,hl
            jp   c,.Lcf5c
            add  hl,hl
            jp   .Lcf66
.Lcf2a
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
.Lcf34
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
.Lcf3e
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
.Lcf48
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
.Lcf52
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
.Lcf5c
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
.Lcf66
            rept 8
            add  ix,de
            adc  hl,bc
            ADDIXIX
            adc  hl,hl
            jr   nc,$+6
            endr
            add  ix,de
            adc  hl,bc
            ld   d,ixh
            ld   e,ixl
.Lcfbe
            pop  af
            ret  p
            ld   b,h
            ld   c,l
            ld   hl,#0000
            sbc  hl,de
            EXD
            ld   hl,#0000
            sbc  hl,bc
            ret
.Lcfda
            ld   a,h
            and  a
            jr   z,.Ld030
            EXD
.Lcfdf
            ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jr   c,.Lcffd
            add  a,a
            jr   c,.Ld003
            add  a,a
            jr   c,.Ld009
            add  a,a
            jr   c,.Ld00f
            add  a,a
            jr   c,.Ld015
            add  a,a
            jr   c,.Ld01b
            add  a,a
            jr   c,.Ld021
            add  a,a
            jr   c,.Ld027
            jp   .Ld029
.Lcffd
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld003
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld009
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld00f
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld015
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld01b
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld021
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
.Ld027
            add  hl,de
            adc  a,c
.Ld029
            EXD
            ld   l,a
            ld   h,#00
            jp   .Lcfbe
.Ld030
            rr   e
            jr   c,.Ld053
            rr   e
            jr   c,.Ld059
            rr   e
            jr   c,.Ld05f
            rr   e
            jr   c,.Ld065
            rr   e
            jr   c,.Ld06b
            rr   e
            jr   c,.Ld071
            rr   e
            jr   c,.Ld077
            rr   e
            jr   c,.Ld07d
            jp   .Ld081
.Ld053
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld059
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld05f
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld065
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld06b
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld071
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld077
            add  a,l
            rra
            rr   e
            jr   nc,$+3
.Ld07d
            add  a,l
            rra
            rr   e
.Ld081
            ld   d,a
            ld   l,h
            jp   .Lcfbe
;  Делениенl=hl/de
Ld086
            ld   ixl,#00
            jp   p,.Ld098
            EXD
            ld   b,h
            ld   c,l
            ld   hl,#0000
            SUB_BC
            EXD
            inc  ixl
.Ld098
            bit  7,h
            jr   z,.Ld0aa
            ex   af,af'
            cpl
            ex   af,af'
            cpl
            ld   b,h
            ld   c,l
            ld   hl,#0000
            scf
            sbc  hl,bc
            inc  ixl
.Ld0aa

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


; LINES clipping
CLIPLIN
            ld   a,#01
            ld   (L91+#2F),a
            ld   a,(L91+#0F)
            cp   #F0
            jr   nz,.Ld16e
            ld   b,a
            ld   a,(L91+#1F)
            ld   (L91+#0F),a
            ld   a,b
            ld   (L91+#1F),a
            ld   hl,(L91+#0B)
            ld   de,(L91+#1B)
            ld   (L91+#1B),hl
            ld   (L91+#0B),de
            ld   hl,(L91+#0D)
            ld   de,(L91+#1D)
            ld   (L91+#1D),hl
            ld   (L91+#0D),de
.Ld16e
            xor  a
            ld   (L91+#0A),a
            ld   a,(L91+#0F)
            cpl
            and  #F0
            ld   l,a
            ld   a,(L91+#1F)
            and  #0F
            or   l
            ld   l,a
            ld   h,high(L95)
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            EXD
            ld   de,.Ld18d
            push de
            push de
            push de
            jp   (hl)
.Ld18d
            ld   a,(L91+#0A)
            pop  de
            pop  de
            cp   #04
            ret


MULL
            ld   (.RET__+1),de
            exx
            ld   l,a
            xor  d
            ex   af,af'
            ABSDE
            ld   a,l
            and  a
            jp   p,$+5
            neg
            ld   c,#00
            ld   h,c
            ld   l,c
            add  a,a
            add  a,a
            jr   c,$+23
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
            jp   $+45

            rept 6
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            endr

            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            ld   l,h
            ld   h,a
            ex   af,af'
            jp   p,.RET__
            EXD
            ld   hl,#0000
            sbc  hl,de
.RET__
            jp   0


Calcrc
;  Повернуть координатную систему по матр
;  Ицеsм_xy
; iy-return adr
;  Портит sp
; Начальныезнач. коорд. bdx,dy,dz
; Конечныевтх,ty,tz
Dx
            ld   de,0
            ld   a,(Sm_11+1)

            exx
            ld   de,$+6
            jp   MULL


            ld   sp,hl
Dy
            ld   de,0
            ld   a,(Sm_21+1)

            exx
            ld   de,$+6
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   sp,hl
Dz
            ld   de,0
            ld   a,(Sm_31+1)

            exx
            ld   de,$+6
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   (Tx+1),hl
            ld   de,(Dx+1)          ; DX
            ld   a,(Sm_12+1)

            exx
            ld   de,$+6
            jp   MULL

            ld   sp,hl
            ld   de,(Dy+1)          ; DY
            ld   a,(Sm_22+1)

            exx
            ld   de,$+6
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   sp,hl
            ld   de,(Dz+1)          ; DZ
            ld   a,(Sm_32+1)

            exx
            ld   de,$+6
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   (Ty+1),hl
            ld   de,(Dx+1)          ; DX
            ld   a,(Sm_13+1)        ; SB*CG

            exx
            ld   de,$+6
            jp   MULL

            ld   sp,hl
            ld   de,(Dy+1)          ; DY
            ld   a,(Sm_23+1)

            exx
            ld   de,$+6
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   sp,hl
            ld   de,(Dz+1)          ; DZ
            ld   a,(Sm_33+1)

            exx
            ld   de,$+6
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   (Tz+1),hl
Exet1
            jp   (iy)


Ren3d

            ld   hl,(Eye_a)
            ld   (Eyea),hl
            ld   a,(Eye_g)
            ld   (Eyeg),a

            ld   a,(La11+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_11+1),a
            ld   a,(La12+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_12+1),a
            ld   a,(Lb13+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_13+1),a
            ld   a,(La21+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_21+1),a
            ld   a,(La22+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_22+1),a
            ld   a,(Lb23+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_23+1),a
            ld   a,(La31+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_31+1),a
            ld   a,(La32+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_32+1),a
            ld   a,(Lb33+2)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (Sm_33+1),a

            ld   hl,#0001
            ld   (Indt1),hl
            ld   bc,Olen
            ld   hl,Carsb
            ld   (La294),sp
            jr   .L9f04
.L9eed
            ld   a,l
            and  a
            jp   m,.La293
.L9efc
            exx
            add  hl,bc
.L9f04
            ld   sp,hl
            ld   a,#80
            exx
            pop  hl                 ; X
            cp   h
            jr   z,.L9eed
            ld   (Objx),hl
            ld   a,h
            and  a
            jp   p,$+5
            neg
            cp   Visibil
            jr   nc,.L9efc
            ld   (Dx+1),hl
            pop  hl                 ; Y
            ld   (Objy),hl
            ld   a,h
            and  a
            jp   p,$+5
            neg
            cp   Visibil
            jr   nc,.L9efc
            ld   (Dy+1),hl
            pop  hl                 ; z
            ld   (Objz),hl
            ld   a,h
            and  a
            jp   p,$+5
            neg
            cp   Visibil
            jr   nc,.L9efc
            ld   (Dz+1),hl
            pop  hl
            ld   a,l
            ld   (Indx),a
            ld   a,h
            ld   (Eyea),a
            pop  hl
            ld   (Eyeb),hl
            ld   a,(Eyeg)
            ld   b,a
            ld   a,(Eyea)
            or   b
            ld   a,1
            jr   z,$+3
            xor  a
            ld   (Sets),a

            ld   iy,$+7
            jp   Calcrc
            jp   pe,.L9efc


            ld   de,(Tz+1)
            ld   hl,(Tx+1)

            ld   a,h
            and  a
            jp   p,$+4
            cpl
            cp   Xvisibi
            jp   nc,.L9efc

            ld   a,d
            and  a
            jp   m,.L9efc
            cp   Detaliz
            ld   a,(Indx)
            jp   p,.La0bc
            add  a,#02
            ld   (Indx),a
.La0bc

            ld   h,L97
            ld   a,(Indx)
            ld   l,a
            ld   sp,hl
            pop  hl
            ld   sp,hl
            pop  bc
            ld   a,b
            and  #80
            ld   hl,Sets
            or   (hl)
            ld   (hl),a
            res  7,b
            ld   a,6
            sub  b
            ld   (.Jmp1+1),a
            ld   (.Jmp2+1),a
            ld   (.Jmp3+1),a
            ld   l,c
            ld   h,0
.Jmp1
            jr   $
            ADDHLHL 5
            ld   sp,(La294)
            push bc
            push hl
            srl  h
            rr   l
            ld   de,(Dx+1)          ; DX
            bit  7,d
            jr   z,.La108
            adc  hl,de
            jp   .La10a
.La108
            sbc  hl,de
.La10a
            jp   m,.La121
            pop  hl
            push hl
            ld   de,(Dz+1)          ; DZ
            bit  7,d
            jr   z,.La11c
            adc  hl,de
            jp   .La11e
.La11c
            sbc  hl,de
.La11e
            jp   m,.La121
            pop  hl
            push hl
            ld   de,(Dy+1)          ; DY
            bit  7,d
            jr   z,.La1c
            adc  hl,de
            jp   .La1e
.La1c
            sbc  hl,de
.La1e
.La121
            pop  de
            pop  bc

.La13a
            ld   hl,(Tz+1)
            and  a
            adc  hl,de
            jp   m,.L9efc

            ld   ixl,c
            ld   a,#48
            ld   h,Multb
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
            ld   l,a
            ld   h,#00
.Jmp2
            jr   $
            ADDHLHL 5
            EXD
            ld   hl,(Tz+1)
            sra  h
            rr   l
            ld   bc,(Tx+1)
            add  hl,bc
            sra  h
            rr   l
            and  a
            adc  hl,de
            jp   m,.L9efc
            SUB_BC
            jp   m,.L9efc

            ld   c,ixl
            ld   a,#42
            ld   h,Multb
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
            ld   l,a
            ld   h,#00
.Jmp3
            jr   $
            ADDHLHL 5
            EXD
            ld   hl,(Tz+1)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   bc,(Ty+1)
            add  hl,bc
            sra  h
            rr   l
            and  a
            adc  hl,de
            jp   m,.L9efc
            SUB_BC
            jp   m,.L9efc


.Lllk
            ld   bc,(Tz+1)
            ld   de,(Dy+1)          ; DY
            ld   a,(Indt1)
            cp   #01
            jr   z,.La238
            ld   ixh,L9d
            ld   ixl,a
            ld   a,(Sets)
            or   (ix+#01)
            jp   m,.La1f4
            ld   l,(ix+#0A)
            ld   h,(ix+#0B)
            sbc  hl,bc
            jp   m,.La238
            jp   .La1ff
.La1f4
            ld   l,(ix+#0C)
            ld   h,(ix+#0D)
            sbc  hl,de
            jp   m,.La238
.La1ff
            ld   iyh,L9d
.La202
            ld   a,(ix+#00)
            cp   #01
            jr   z,.La24e
            ld   iyl,a
            ld   a,(Sets)
            or   (iy+#01)
            jp   m,.La226
            ld   l,(iy+#0A)
            ld   h,(iy+#0B)
            sbc  hl,bc
            jp   m,.La260
            ld   a,iyl
            ld   ixl,a
            jp   .La202
.La226
            ld   l,(iy+#0C)
            ld   h,(iy+#0D)
            sbc  hl,de
            jp   m,.La260
            ld   a,iyl
            ld   ixl,a
            jp   .La202
.La238
            ld   a,(Indt2)
            cp   #FC
            jp   z,.La293
            ld   l,a
            ld   h,L9d
            ld   a,(Indt1)
            ld   (hl),a
            ld   a,l
            ld   (Indt1),a
            jp   .La272
.La24e
            ld   a,(Indt2)
            cp   #FC
            jr   z,.La293
            ld   (ix+#00),a
            ld   l,a
            ld   h,L9d
            ld   (hl),#01
            jp   .La272
.La260
            ld   a,(Indt2)
            cp   #FC
            jr   z,.La293
            ld   l,a
            ld   h,L9d
            ld   a,(ix+#00)
            ld   (ix+#00),l
            ld   (hl),a
            ld   a,l
.La272
            add  a,#0E
            ld   (Indt2),a
            ld   l,a
            ld   sp,hl
            push de
            push bc
            ld   hl,(Ty+1)
            push hl
            ld   hl,(Tx+1)
            push hl
            ld   a,(Eyeg)           ; GAMA
            push af
            inc  sp
            ld   hl,(Eyea)          ; ALFA/BETA
            push hl
            ld   hl,(Sets)
            push hl
            jp   .L9efc
.La293
            ld   sp,#0000
La294       equ  $-#0002

            ld   a,(Indt1)
            ld   h,L9d
            jp   .La33b


.La2d8
            push hl
            inc  l
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (Sets),de          ; BITS/ind
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (Eyea),de          ; ALFA/BETA
            ld   a,(hl)
            inc  l
            ld   (Eyeg),a           ; GAMA
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (Tx+1),de          ; DX
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (Ty+1),de          ; DY
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (Tz+1),de          ; DZ
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   (Dy+1),de

            ld   hl,Sets
            call .Matrx
            call Pmatrx
            call RenderObject
            call Vsmask
            jr   z,.La339
            ld   b,a
            cpl
            and  #F0
            jr   nz,.La339
            ld   a,b
            and  #0F
            jr   nz,$+8
            call Drwpol2
            jp   $+6
            call Drwpol
.La339
            pop  hl
            ld   a,(hl)
.La33b
            cp   #01
            ret  z
            ld   l,a
            jp   .La2d8


.Matrx
            ld   hl,Sets
            bit  0,(hl)
            jr   z,.Ld1d8
            ld   a,(Eyeb)
            ld   b,a
            add  a,#40
            ld   h,Sintb
            ld   l,a
            ld   a,(hl)
            ld   (Gm_11+1),a
            ld   (Gm_33+1),a
            ld   l,b
            ld   a,(hl)
            ld   (Gm_13+1),a
            neg
            ld   (Gm_31+1),a
            xor  a
            ld   (Gm_12+1),a
            ld   (Gm_21+1),a
            ld   (Gm_23+1),a
            ld   (Gm_32+1),a
            ld   a,#7F
            ld   (Gm_22+1),a
            ret
.Ld1d8
            ld   a,(Eyea)
            ld   h,Sintb
            ld   l,a
            ld   b,(hl)
            add  a,#40
            ld   l,a
            ld   c,(hl)
            ld   a,(Eyeb)
            ld   l,a
            ld   a,(hl)
            ld   ixl,a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)
            ld   iyl,a
            ld   a,(Eyeg)
            ld   l,a
            ld   a,(hl)
            ld   d,a
            neg
            ld   (Gm_12+1),a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)
            ld   iyh,a
            ld   h,Multb
            ld   e,iyl

            call MULE

            ld   (Gm_11+1),a
            ld   a,ixl
            ld   e,iyh

            call MULE

            ld   (Gm_13+1),a
            ld   a,ixl

            call MULB

            ld   ixh,a
            ld   a,iyl

            call MULC

            call MULD

            ADPAXH
            ld   (Gm_21+1),a
            ld   a,iyh

            call MULC

            ld   (Gm_22+1),a
            ld   a,iyl

            call MULB

            ld   ixh,a
            ld   a,ixl

            call MULC

            call MULD

            SBPAXH
            ld   (Gm_23+1),a
            ld   a,ixl

            call MULC

            ld   ixh,a
            ld   a,iyl

            call MULB

            call MULD

            SBPAXH
            ld   (Gm_31+1),a
            ld   a,iyh

            call MULB

            ld   (Gm_32+1),a
            ld   a,iyl

            call MULC

            ld   ixh,a
            ld   a,ixl

            call MULB

            call MULD

            ADPAXH
            ld   (Gm_33+1),a
            ret
