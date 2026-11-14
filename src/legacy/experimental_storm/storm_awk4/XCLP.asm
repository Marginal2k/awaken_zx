;ПPOЦEДУPЫ KЛИППИPOBAHИЯ
Clip:       xor  a
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
Lc8b2:      ld   hl,(L91+#1B)
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
            ex   de,hl
            ld   de,Lc8f9
            push de
            jp   (hl)
Lc8f9:      pop  bc
            djnz Lc8b2
            pop  hl
            ld   a,(L91+#0A)
            cp   #06
Lc902:      ret  
Lc903:      call Lcd1e
Lc906:      call Lcd5c
Lc909:      call Lce87
            jp   m,Lcda7
            call Lcdf9
Lc912:      ld   hl,L91+#2E
            bit  0,(hl)
            jp   nz,Lce40
            set  0,(hl)
            ret  
Lc91d:      call Lcd1e
Lc920:      call Lcd3d
Lc923:      call Lce73
            jp   m,Lcdd0
            call Lcda7
Lc92c:      ld   hl,L91+#2E
            bit  1,(hl)
            jp   nz,Lce35
            set  1,(hl)
            ret  
Lc937:      call Lccff
Lc93a:      call Lcd5c
Lc93d:      call Lce5f
            jp   m,Lcdf9
            call Lcd7e
Lc946:      ld   hl,L91+#2E
            bit  2,(hl)
            jp   nz,Lce2a
            set  2,(hl)
            ret  
Lc951:      call Lccff
Lc954:      call Lcd3d
Lc957:      call Lce4b
            jp   m,Lcd7e
            call Lcdd0
Lc960:      ld   hl,L91+#2E
            bit  3,(hl)
            jp   nz,Lce1f
            set  3,(hl)
            ret  
Lc96b:      call Lcdf6
            jp   Lceb1
Lc971:      call Lcdf6
            jp   Lcdcd
Lc977:      call Lcd5c
Lc97a:      call Lcd1e
            call Lce87
            jp   p,Lce40
            call Lcdf9
            jp   Lcda7
Lc989:      call Lcd5c
Lc98c:      call Lcd1e
            call Lce87
            jp   m,Lc99b
            call Lce40
            jp   Lc92c
Lc99b:      call Lcdf9
            jp   Lc920
Lc9a1:      call Lcd5c
Lc9a4:      call Lccff
            call Lce5f
            jp   m,Lcec8
            call Lcdf9
            jp   Lcd7e
Lc9b3:      call Lce9b
            jp   m,Lcec8
            ret  
Lc9ba:      call Lcd5c
Lc9bd:      call Lccff
            call Lce5f
            jp   m,Lcec8
            call Lcdf9
            jp   Lc954
Lc9cc:      call Lcdcd
            jp   Lceb1
Lc9d2:      call Lcdcd
            jp   Lcdf6
Lc9d8:      call Lcd3d
Lc9db:      call Lcd1e
            call Lce73
            jp   m,Lcec8
            call Lcdd0
            jp   Lcda7
Lc9ea:      call Lcd3d
Lc9ed:      call Lcd1e
            call Lce73
            jp   m,Lcec8
            call Lcdd0
            jp   Lc906
Lc9fc:      call Lce9b
            jp   p,Lcec8
            ret  
Lca03:      call Lcd3d
Lca06:      call Lccff
            call Lce4b
            jp   p,Lce1f
            call Lcdd0
            jp   Lcd7e
Lca15:      call Lcd3d
Lca18:      call Lccff
            call Lce4b
            jp   m,Lca27
            call Lce1f
            jp   Lc946
Lca27:      call Lcdd0
            jp   Lc93a
Lca2d:      call Lcda4
            jp   Lceb1
Lca33:      call Lcd1e
Lca36:      call Lcd5c
            call Lce87
            jp   m,Lcec8
            call Lcda7
            jp   Lcdf9
Lca45:      call Lcd1e
Lca48:      call Lcd3d
            call Lce73
            jp   p,Lce35
            call Lcda7
            jp   Lcdd0
Lca57:      call Lcea6
            jp   m,Lcec8
            ret  
Lca5e:      call Lcda4
            jp   Lcd7b
Lca64:      call Lcd1e
Lca67:      call Lcd5c
            call Lce87
            jp   m,Lcec8
            call Lcda7
            call Lccff
            jp   Lc93d
Lca79:      call Lcd1e
Lca7c:      call Lcd3d
            call Lce73
            jp   m,Lca8b
            call Lce35
            jp   Lc960
Lca8b:      call Lcda7
            call Lccff
            jp   Lc957
Lca94:      call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lcc13
            ld   hl,L91+#2E
            bit  0,(hl)
            set  0,(hl)
            call nz,Lce40
Lcaaa:      call Lcda7
            jp   Lceb1
Lcab0:      call Lce9b
            jp   p,Lcec8
            ret  
Lcab7:      call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lcad0
            ld   hl,L91+#2E
            bit  0,(hl)
            set  0,(hl)
            call nz,Lce40
            jp   Lca48
Lcad0:      call Lcdf9
            jp   Lcdcd
Lcad6:      ld   hl,L91+#2E
            bit  0,(hl)
            jp   nz,Lce40
            set  0,(hl)
            ret  
Lcae1:      call Lcad6
            jp   Lc92c
Lcae7:      call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lc9a4
            call Lcad6
            call Lcda7
            jp   Lcd7b
Lcafc:      call Lcd1e
            call Lcd5c
            call Lce87
            jp   m,Lc9bd
            ld   hl,L91+#2E
            bit  0,(hl)
            set  0,(hl)
            call nz,Lce40
            jp   Lca7c
Lcb15:      call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lcaaa
            ld   hl,L91+#2E
            bit  1,(hl)
            set  1,(hl)
            call nz,Lce35
Lcb2b:      call Lcdd0
            jp   Lceb1
Lcb31:      call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lca36
            call Lcb46
            call Lcdd0
            jp   Lcdf6
Lcb46:      ld   hl,L91+#2E
            bit  1,(hl)
            jp   nz,Lce35
            set  1,(hl)
            ret  
Lcb51:      call Lcea6
            jp   p,Lcec8
            ret  
Lcb58:      call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lcb71
            ld   hl,L91+#2E
            bit  1,(hl)
            set  1,(hl)
            call nz,Lce35
            jp   Lca06
Lcb71:      call Lcda7
            jp   Lcd7b
Lcb77:      call Lcd1e
            call Lcd3d
            call Lce73
            jp   m,Lca67
            ld   hl,L91+#2E
            bit  1,(hl)
            set  1,(hl)
            call nz,Lce35
            jp   Lca18
Lcb90:      call Lcb46
            jp   Lc960
Lcb96:      call Lcd7b
            jp   Lceb1
Lcb9c:      call Lccff
Lcb9f:      call Lcd5c
            call Lce5f
            jp   p,Lce2a
            call Lcd7e
            jp   Lcdf9
Lcbae:      call Lccff
Lcbb1:      call Lcd3d
            call Lce4b
            jp   m,Lcec8
            call Lcd7e
            jp   Lcdd0
Lcbc0:      call Lcd7b
            jp   Lcda4
Lcbc6:      call Lccff
Lcbc9:      call Lcd5c
            call Lce5f
            jp   m,Lcbd8
            call Lce2a
            jp   Lc912
Lcbd8:      call Lcd7e
            call Lcd1e
            jp   Lc909
Lcbe1:      call Lccff
Lcbe4:      call Lcd3d
            call Lce4b
            jp   m,Lcec8
            call Lcd7e
            call Lcd1e
            jp   Lc923
Lcbf6:      call Lcea6
            jp   p,Lcec8
            ret  
Lcbfd:      call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcc94
            ld   hl,L91+#2E
            bit  2,(hl)
            set  2,(hl)
            call nz,Lce2a
Lcc13:      call Lcdf9
            jp   Lceb1
Lcc19:      ld   hl,L91+#2E
            bit  2,(hl)
            jp   nz,Lce2a
            set  2,(hl)
            ret  
Lcc24:      call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcbb1
            call Lcc19
            call Lcdf9
            jp   Lcdcd
Lcc39:      call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcc52
            ld   hl,L91+#2E
            bit  2,(hl)
            set  2,(hl)
            call nz,Lce2a
            jp   Lc97a
Lcc52:      call Lcd7e
            jp   Lcda4
Lcc58:      call Lcc19
            jp   Lc912
Lcc5e:      call Lccff
            call Lcd5c
            call Lce5f
            jp   m,Lcbe4
            ld   hl,L91+#2E
            bit  2,(hl)
            set  2,(hl)
            call nz,Lce2a
            jp   Lc98c
Lcc77:      call Lcea6
            jp   m,Lcec8
            ret  
Lcc7e:      call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lcb2b
            ld   hl,L91+#2E
            bit  3,(hl)
            set  3,(hl)
            call nz,Lce1f
Lcc94:      call Lcd7e
            jp   Lceb1
Lcc9a:      call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lccb3
            ld   hl,L91+#2E
            bit  3,(hl)
            set  3,(hl)
            call nz,Lce1f
            jp   Lcb9f
Lccb3:      call Lcdd0
            jp   Lcdf6
Lccb9:      call Lce9b
            jp   m,Lcec8
            ret  
Lccc0:      call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lc9db
            call Lccee
            call Lcd7e
            jp   Lcda4
Lccd5:      call Lccff
            call Lcd3d
            call Lce4b
            jp   m,Lc9ed
            ld   hl,L91+#2E
            bit  3,(hl)
            set  3,(hl)
            call nz,Lce1f
            jp   Lcbc9
Lccee:      ld   hl,L91+#2E
            bit  3,(hl)
            jp   nz,Lce1f
            set  3,(hl)
            ret  
Lccf9:      call Lccee
            jp   Lc946
Lccff:      ld   bc,(L91+#1B)
            ld   hl,(L91+#0B)
            and  a
            sbc  hl,bc
            ex   de,hl
            ld   bc,#0000
            ld   hl,(L91+#0D)
            and  a
            sbc  hl,bc
            call Lcef2
            ld   (L90+#DC),de
            ld   (L90+#DE),hl
            ret  
Lcd1e:      ld   bc,(L91+#1B)
            ld   hl,(L91+#0B)
            and  a
            sbc  hl,bc
            ex   de,hl
            ld   bc,#005F
            ld   hl,(L91+#0D)
            and  a
            sbc  hl,bc
            call Lcef2
            ld   (L90+#EA),de
            ld   (L90+#EC),hl
            ret  
Lcd3d:
            ld   bc,#0000
            ld   hl,(L91+#0B)
            and  a
            sbc  hl,bc
            ex   de,hl
            ld   bc,(L91+#1D)
            ld   hl,(L91+#0D)
            and  a
            sbc  hl,bc
            call Lcef2
            ld   (L90+#EE),de
            ld   (L90+#FA),hl
            ret  
Lcd5c:
            ld   bc,#00FF
            ld   hl,(L91+#0B)
            and  a
            sbc  hl,bc
            ex   de,hl
            ld   bc,(L91+#1D)
            ld   hl,(L91+#0D)
            and  a
            sbc  hl,bc
            call Lcef2
            ld   (L90+#FC),de
            ld   (L90+#FE),hl
            ret  
Lcd7b:      call Lccff
Lcd7e:      ld   a,(L90+#DC)
            ex   af,af
            ld   a,(L90+#DD)
            ld   hl,(L91+#1D)
            ld   de,(L91+#0D)
            and  a
            sbc  hl,de
            ex   de,hl
            ld   hl,(L90+#DE)
            call Ld086
            ld   de,(L91+#0B)
            add  hl,de
            ld   a,h
            and  a
            jr   z,O_1+2
            jp   p,O_1
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            xor  a
            ld   (hl),a
            inc  l
            ld   (hl),a
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
O_1:
            ld   l,#FF
            ld   e,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),e
            inc  l
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Lcda4:      call Lcd1e
Lcda7:      ld   a,(L90+#EA)
            ex   af,af
            ld   a,(L90+#EB)
            ld   hl,(L91+#1D)
            ld   de,(L91+#0D)
            and  a
            sbc  hl,de
            ex   de,hl
            ld   hl,(L90+#EC)
            call Ld086
            ld   de,(L91+#0B)
            add  hl,de
            ld   a,h
            and  a
            jr   z,O_2+2
            jp   p,O_2
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),0
            inc  l
            ld   (hl),#5F
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
O_2:
            ld   l,#FF
            ld   e,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),e
            inc  l
            ld   (hl),#5F
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Lcdcd:      call Lcd3d
Lcdd0:      ld   a,(L90+#EE)
            ex   af,af
            ld   a,(L90+#EF)
            ld   hl,(L91+#1B)
            ld   de,(L91+#0B)
            and  a
            sbc  hl,de
            ex   de,hl
            ld   hl,(L90+#FA)
            call Ld086
            ld   de,(L91+#0D)
            add  hl,de
            ld   a,h
            and  a
            jp   m,Io1
            ld   a,l
            and  a
            jp   p,Io2
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),0
            inc  l
            ld   (hl),#5F
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Io1:
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            xor  a
            ld   (hl),a
            inc  l
            ld   (hl),a
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Io2:
            ld   d,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),0
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Lcdf6:      call Lcd5c
Lcdf9:      ld   a,(L90+#FC)
            ex   af,af
            ld   a,(L90+#FD)
            ld   hl,(L91+#1B)
            ld   de,(L91+#0B)
            and  a
            sbc  hl,de
            ex   de,hl
            ld   hl,(L90+#FE)
            call Ld086
            ld   de,(L91+#0D)
            add  hl,de
            ld   a,h
            and  a
            jp   m,Io4
            ld   a,l
            and  a
            jp   p,Io3
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),#FF
            inc  l
            ld   (hl),#5F
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Io4:
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),#FF
            inc  l
            ld   (hl),0
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Io3:
            ld   d,l
            ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),#FF
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Lce1f:      ld   a,(L91+#2F)
            and  a
            ret  nz
            ld   de,#0000
            jp   Lceb9
Lce2a:      ld   a,(L91+#2F)
            and  a
            ret  nz
            ld   de,#00FF
            jp   Lceb9
Lce35:      ld   a,(L91+#2F)
            and  a
            ret  nz
            ld   de,#5F00
            jp   Lceb9
Lce40:      ld   a,(L91+#2F)
            and  a
            ret  nz
            ld   de,#5FFF
            jp   Lceb9
Lce4b:      and  a
            ld   hl,(L90+#DC)
            ld   bc,(L90+#EE)
            sbc  hl,bc
            ld   hl,(L90+#DE)
            ld   bc,(L90+#FA)
            sbc  hl,bc
            ret  
Lce5f:      and  a
            ld   hl,(L90+#DC)
            ld   bc,(L90+#FC)
            sbc  hl,bc
            ld   hl,(L90+#DE)
            ld   bc,(L90+#FE)
            sbc  hl,bc
            ret  
Lce73:      and  a
            ld   hl,(L90+#EA)
            ld   bc,(L90+#EE)
            sbc  hl,bc
            ld   hl,(L90+#EC)
            ld   bc,(L90+#FA)
            sbc  hl,bc
            ret  
Lce87:      and  a
            ld   hl,(L90+#EA)
            ld   bc,(L90+#FC)
            sbc  hl,bc
            ld   hl,(L90+#EC)
            ld   bc,(L90+#FE)
            sbc  hl,bc
            ret  
Lce9b:      ld   hl,(L91+#1B)
            ld   de,(L91+#0B)
            and  a
            sbc  hl,de
            ret  
Lcea6:      ld   hl,(L91+#1D)
            ld   de,(L91+#0D)
            and  a
            sbc  hl,de
            ret  
Lceb1:      ld   a,(L91+#1B)
            ld   e,a
            ld   a,(L91+#1D)
            ld   d,a
Lceb9:      ld   a,(L91+#0A)
            ld   l,a
            ld   h,L9e
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            ld   (L91+#0A),a
            ret  
Lcec8:      pop  af
            pop  bc
            pop  hl
            ld   c,b
            dec  c
            ld   b,#00
            add  hl,bc
            scf  
            ret  




;KBAДPAT. HLDE=HL^2
Lcef0:      ld   d,h
            ld   e,l
;УMHOЖEHИE HLDE=HL*DE
Mull:
Lcef2:      ld   a,h
            xor  d
            push af
            bit  7,d
            jr   z,$+9
            ld   a,e
            cpl  
            ld   e,a
            ld   a,d
            cpl  
            ld   d,a
            inc  de
            bit  7,h
            jr   z,$+9
            ld   a,l
            cpl  
            ld   l,a
            ld   a,h
            cpl  
            ld   h,a
            inc  hl
            ex   de,hl
            ld   a,d
            and  a
            jp   z,Lcfda
            ld   a,h
            and  a
            jp   z,Lcfdf
            ld   bc,#0000
            ld   ix,#0000
            add  hl,hl
            add  hl,hl
            jp   c,Lcf2a
            add  hl,hl
            jp   c,Lcf34
            add  hl,hl
            jp   c,Lcf3e
            add  hl,hl
            jp   c,Lcf48
            add  hl,hl
            jp   c,Lcf52
            add  hl,hl
            jp   c,Lcf5c
            add  hl,hl
            jp   Lcf66
Lcf2a:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
Lcf34:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
Lcf3e:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
Lcf48:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
Lcf52:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
Lcf5c:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
Lcf66:      add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            add  ix,ix
            adc  hl,hl
            jr   nc,$+6
            add  ix,de
            adc  hl,bc
            ld   d,HX
            ld   e,LX
Lcfbe:      pop  af
            ret  p
            ld   b,h
            ld   c,l
            ld   hl,#0000
            sbc  hl,de
            ex   de,hl
            ld   hl,#0000
            sbc  hl,bc
            ret  
Lcfda:      ld   a,h
            and  a
            jr   z,Ld030
            ex   de,hl
Lcfdf:      ld   a,l
            ld   l,h
            ld   c,h
            add  a,a
            jr   c,Lcffd
            add  a,a
            jr   c,Ld003
            add  a,a
            jr   c,Ld009
            add  a,a
            jr   c,Ld00f
            add  a,a
            jr   c,Ld015
            add  a,a
            jr   c,Ld01b
            add  a,a
            jr   c,Ld021
            add  a,a
            jr   c,Ld027
            jp   Ld029
Lcffd:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld003:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld009:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld00f:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld015:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld01b:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld021:      add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
Ld027:      add  hl,de
            adc  a,c
Ld029:
            ex   de,hl
            ld   l,a
            ld   h,#00
            jp   Lcfbe
Ld030:      rr   e
            jr   c,Ld053
            rr   e
            jr   c,Ld059
            rr   e
            jr   c,Ld05f
            rr   e
            jr   c,Ld065
            rr   e
            jr   c,Ld06b
            rr   e
            jr   c,Ld071
            rr   e
            jr   c,Ld077
            rr   e
            jr   c,Ld07d
            jp   Ld081
Ld053:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld059:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld05f:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld065:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld06b:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld071:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld077:      add  a,l
            rra  
            rr   e
            jr   nc,$+3
Ld07d:      add  a,l
            rra  
            rr   e
Ld081:      ld   d,a
            ld   l,h
            jp   Lcfbe
;ДEЛEHИE HL=HL/DE
Ld086:      ld   LX,#00
            jp   p,Ld098
            ex   de,hl
            ld   b,h
            ld   c,l
            ld   hl,#0000
            and  a
            sbc  hl,bc
            ex   de,hl
            inc  LX
Ld098:      bit  7,h
            jr   z,Ld0aa
            ex   af,af
            cpl  
            ex   af,af
            cpl  
            ld   b,h
            ld   c,l
            ld   hl,#0000
            scf  
            sbc  hl,bc
            inc  LX
Ld0aa:      rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            ex   af,af
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            dec  LX
            jr   nz,$+6
            ld   l,a
            ex   af,af
            ld   h,a
            ret  
            cpl  
            ld   l,a
            ex   af,af
            cpl  
            ld   h,a
            ret  





;LINES CLIPPING
CLIPLIN:
            ld   a,#01
            ld   (L91+#2F),a
            ld   a,(L91+#0F)
            cp   #F0
            jr   nz,Ld16e
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
Ld16e:      xor  a
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
            ex   de,hl
            ld   de,Ld18d
            push de
            push de
            push de
            jp   (hl)
Ld18d:      ld   a,(L91+#0A)
            pop  de
            pop  de
            cp   #04
            ret  

