;Polygon
;DIV
;MULE
;MULB
;MULC
;MULD
;Pmatrx
;Renobj2
;Rendot
;Renobj
;Rendot2
;Rendi
;Drwpol
;Drwpol2
;Drwlin
;Vsmask
;Vspoly





Lc5:
            dw   #00FF
            dw   #AA77
            dw   #FF55
            dw   #5511
            dw   #0000




            ds   (low((high($)))*256)+#C0-$

            rept 31
            ld   (bc),a
            inc  c
            endr

            ex   af,af'
            ld   e,iyl
            EXD
            ld   a,(bc)
            and  (hl)
            inc  l
            or   (hl)
            ld   (bc),a
Lc608:      inc  h
            res  1,h

            ex   af,af'
Lc60d:      xor  #00
            ex   af,af'

            exx  
            add  ix,bc

            exx  
            inc  b
            jp   nc,$+13
            ld   a,c
            add  a,32
            ld   c,a
            jr   c,$+6
            ld   a,b
            sub  8
            ld   b,a
            exx  

            ld   a,l
Lc616:      sub  #00
            jr   nc,$+6
Lc61a:      add  a,#00
            add  ix,sp
            ld   l,a
            add  iy,de
            ld   a,h
Lc622:      sub  #00
            jr   nc,$+6
Lc626:      add  a,#00
            add  iy,sp
            ld   h,a
            exx  


Cntpl:      ld   a,0
Lc62d:      cp   #00
            jr   nc,Lc66b           ;z
Lc632:      cp   #00
            jr   nc,Lc671           ;z
Lc635:      cp   #00
            jr   nc,Lc66e           ;z
            inc  a
            ld   (Cntpl+1),a
Lc639:
            ld   a,ixl
            ld   l,a
            ld   a,ixh
            and  #1F
            ld   e,a
            ld   a,c
            and  #E0
            or   e
PUZ2:       add  a,0
            ld   c,a
            ld   a,ixh
            sub  iyh
            jr   nc,Lc654
            add  a,a
            ld   e,a
            ld   a,(bc)
            and  (hl)
            inc  l
            or   (hl)
            ld   (bc),a
            inc  c
            EXD
            ex   af,af'
            jp   (hl)
Lc654:
            jr   nz,Lc608
            ld   a,(hl)
            ld   e,iyl
            ld   l,e
            or   (hl)
            inc  l
            ld   e,a
            cpl  
            and  (hl)
            ld   l,a
            ld   a,(bc)
            and  e
            or   l
            ld   (bc),a
            jp   Lc608


Lc66b:
Lc867:      ld   sp,0
Lc86a:      pop  hl
            ret  
Lc66e:      jp   Lc6c0
Lc6b9:      ld   a,(Lc6cc)
            ld   l,a
            jp   Lc67f
Lc671:

            ld   l,d
            push af
            push hl
            ld   hl,0
Lc675:      equ  $-#0002
            dec  l
            ld   e,(hl)
            inc  l
            ld   d,a
Lc67b:      dec  l
            jr   z,Lc6b9
            dec  l
Lc67f:      ld   a,(hl)
            sub  d
            jr   z,Lc67b
            jr   c,Lc67b
            ld   (Lc675),hl
            ld   d,a
            ld   (Lc61a+1),a
            srl  a
            exx  
            ld   l,a
            exx  
            ld   a,(hl)
            ld   (Lc632+1),a
            dec  l
            ld   a,(hl)
            sub  e
            jp   c,Lc76a
            cp   d
            jp   c,Lc763
            ld   e,a
            xor  a

            call DIV
            rl   e

            and  a
            jr   z,Lc75e
            sub  d
            neg  
            ld   (Lc616+1),a
            ld   a,e
            neg  
            srl  a
            exx  
            ld   c,#00
            rr   c
            rra  
            rr   c
            rra  
            rr   c
            add  a,#20
            ld   b,a
            exx  
            pop  hl
            pop  af
            ld   d,l
            jp   Lc635
Lc75e:
            ld   (Lc616+1),a
            ld   a,e
            cpl  
            rra  
            exx  
            ld   c,#00
            rr   c
            sra  a
            rr   c
            sra  a
            rr   c
            add  a,#20
            ld   b,a
            exx  
            pop  hl
            pop  af
            ld   d,l
            jp   Lc635
Lc763:      sub  d
            neg  
            ld   (Lc616+1),a
            exx  
            ld   c,#20
            ld   b,c
            exx  
            pop  hl
            pop  af
            ld   d,l
            jp   Lc635
Lc76a:      neg  
            cp   d
            jr   c,Lc7b1
            ld   e,a
            xor  a

            call DIV
            rl   e

            ld   (Lc616+1),a
            ld   a,e
            inc  a
            scf  
            rra  
            exx  
            ld   c,#00
            rr   c
            sra  a
            rr   c
            sra  a
            rr   c
            add  a,#20
            ld   b,a
            exx  
            pop  hl
            pop  af
            ld   d,l
            jp   Lc635
Lc7b1:
            ld   (Lc616+1),a
            exx  
            ld   c,#00
            ld   b,#20
            exx  
            pop  hl
            pop  af
            ld   d,l
            jp   Lc635
Lc70b:      ld   l,#01
            jp   Lc6d1
Lc6c0:
            ld   l,d
            push hl
            ld   d,a
            inc  a
            ld   (Cntpl+1),a
            ld   hl,0
Lc6c4:      equ  $-#0002
            dec  l
            ld   e,(hl)
            inc  l
Lc6ca:      ld   a,l
            cp   #00
Lc6cc:      equ  $-#0001
            jr   z,Lc70b
            inc  l
            inc  l
Lc6d1:      ld   a,(hl)
            sub  d
            jr   z,Lc6ca
            jr   c,Lc6ca
            ld   (Lc6c4),hl
            ld   d,a
            ld   (Lc626+1),a
            srl  a
            exx  
            ld   h,a
            exx  
            ld   a,(hl)
            ld   (Lc635+1),a
            dec  l
            ld   a,(hl)
            sub  e
            jp   c,Lc76al
            cp   d
            jp   c,Lc763l
            ld   e,a
            xor  a

            call DIV
            rl   e

            and  a
            jr   z,Lc625l
            sub  d
            neg  
            ld   (Lc622+1),a
            ld   a,e
            neg  
            srl  a
            exx  
            ld   e,#00
            rr   e
            rra  
            rr   e
            rra  
            rr   e
            add  a,#20
            ld   d,a
            exx  
            pop  hl
            ld   d,l
            jp   Lc639
Lc625l:
            ld   (Lc622+1),a
            ld   a,e
            cpl  
            rra  
            exx  
            ld   e,#00
            rr   e
            sra  a
            rr   e
            sra  a
            rr   e
            add  a,#20
            ld   d,a
            exx  
            pop  hl
            ld   d,l
            jp   Lc639
Lc763l:     sub  d
            neg  
            ld   (Lc622+1),a
            exx  
            ld   e,#20
            ld   d,e
            exx  
            pop  hl
            ld   d,l
            jp   Lc639
Lc76al:     neg  
            cp   d
            jr   c,Lc7b1l
            ld   e,a
            xor  a

            call DIV
            ld   (Lc622+1),a

            ld   a,e
            rla  
            inc  a
            scf  
            rra  
            exx  
            ld   e,#00
            rr   e
            sra  a
            rr   e
            sra  a
            rr   e
            add  a,#20
            ld   d,a
            exx  
            pop  hl
            ld   d,l
            jp   Lc639
Lc7b1l:
            ld   (Lc622+1),a
            exx  
            ld   e,#00
            ld   d,#20
            exx  
            pop  hl
            ld   d,l
            jp   Lc639

Lc7b4:      ex   af,af'
            ld   l,a
            ex   af,af'
            inc  l
            jp   Lc7f7
Lc7bb:      ld   l,#01
            jp   Lc807





Polygon:
            push hl
            ld   a,(L91+#0A)
            ld   b,a
            dec  a
            ld   (Lc6cc),a
            ex   af,af'
            srl  b
            ld   hl,(low(L9e)*256)+1
            ld   de,#FF00
Lc7d2:      ld   a,(hl)
            cp   d
            jp   nc,Lc7d9
            ld   d,a
            ld   c,l
Lc7d9:      cp   e
            jp   c,Lc7de
            ld   e,a
Lc7de:      inc  l
            inc  l
            djnz Lc7d2
            ld   a,e
            cp   d
            jp   z,Lc86a
            ld   (Lc62d+1),a
            ld   a,d
            ld   (Lc632+1),a
            ld   (Lc635+1),a
            ld   b,d
            ld   l,c
Lc7f3:      ld   e,l
            dec  l
            jr   z,Lc7b4
Lc7f7:      dec  l
            cp   (hl)
            jr   z,Lc7f3
            ld   l,e
            ld   (Lc675),hl
            ld   l,c
Lc800:      ld   e,l
            ex   af,af'
            cp   l
            jr   z,Lc7bb
            inc  l
            inc  l
Lc807:      ex   af,af'
            cp   (hl)
            jr   z,Lc800
            ld   l,e
            ld   (Lc6c4),hl
            ld   a,(L91+#1A)
            add  a,a
            ld   c,a
            ld   h,high(Lc5)
            ld   l,a
            ld   a,(hl)
            ex   af,af'
            inc  l
            ld   a,(hl)
            ld   (Lc60d+1),a
            ld   hl,(Lc675)
            dec  l
            ld   e,(hl)

            ld   h,high(TBXX2)+2
            ld   l,0
            ld   a,(hl)
            ld   l,b
            ld   (PUZ2+1),a
            ld   h,high(TBXX2)


            xor  a
            srl  b
            rr   e
            rra  
            srl  b
            rr   e
            rra  
            scf  
            rr   b
            rr   e
            rra  

            add  a,c
            ld   ixl,a
            ld   ixh,e

            ld   b,(hl)
            inc  h
            ld   a,(hl)
            ld   (PUZ+1),a

            ld   hl,(Lc6c4)
            dec  l
            ld   e,(hl)
            xor  a
            srl  d
            rr   e
            rra  
            srl  d
            rr   e
            rra  
            scf  
            rr   d
            rr   e
            rra  
            add  a,c
            add  a,#10
            ld   iyl,a
            ld   iyh,e

            ld   a,ixh
            and  #1F
PUZ:        or   0
            ld   c,a
            ld   a,(PUZ2+1)
            add  a,c
            ld   c,a

            ld   d,high(Lc5)
            ld   h,high(L90k)
            ld   a,(Lc632+1)
            ld   (Lc867+1),sp
            ld   sp,#FFE0
            jp   Lc62d


DIV:
            rept 8
            rl   e
            rla  
            sub  d
            jr   nc,$+3
            add  a,d
            endr
            ret  


MULE:       sra  a
            ld   l,e
            sra  l
            sub  l
            ld   l,a
            add  a,e
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ret  
MULB:       sra  a
            ld   l,b
            sra  l
            sub  l
            ld   l,a
            add  a,b
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ret  
MULC:       sra  a
            ld   l,c
            sra  l
            sub  l
            ld   l,a
            add  a,c
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ret  
MULD:       sra  a
            ld   l,d
            sra  l
            sub  l
            ld   l,a
            add  a,d
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ret  



Pmatrx:
            ld   h,Multb
            ld   iy,Sets
            bit  0,(iy+#00)
            jr   z,$+10             ;ifALFA GAMA TURN ON
            ld   a,(Eyeb)
            and  #3F
            jp   z,Ld43c
Gm_11:      ld   b,0
Gm_21:      ld   c,0
Gm_31:      ld   d,0
Sm_11:      ld   a,0

            call MULB

            ld   ixh,a
            bit  0,(iy+#00)
            jr   nz,Ld2c5
Sm_21:      ld   a,0

            call MULC

            ADPAXH
            ld   ixh,a
Ld2c5:
Sm_31:      ld   a,0

            call MULD

            ADPAXH
            ld   (Om_11+1),a
Sm_12:      ld   a,0

            call MULB

            ld   ixh,a
            bit  0,(iy+#00)
            jr   nz,Ld2ee
Sm_22:      ld   a,0

            call MULC

            ADPAXH
            ld   ixh,a
Ld2ee:
Sm_32:      ld   a,0

            call MULD

            ADPAXH
            ld   (Om_21+1),a
Sm_13:      ld   a,0

            call MULB

            ld   ixh,a
            bit  0,(iy+#00)
            jr   nz,Ld317
Sm_23:      ld   a,0

            call MULC

            ADPAXH
            ld   ixh,a
Ld317:
Sm_33:      ld   a,0

            call MULD

            ADPAXH
            ld   (Om_31+1),a

Gm_13:      ld   b,0
Gm_23:      ld   c,0
Gm_33:      ld   d,0

            ld   a,(Sm_11+1)

            call MULB

            ld   ixh,a
            bit  0,(iy+#00)
            jr   nz,Ld34c
            ld   a,(Sm_21+1)

            call MULC

            ADPAXH
            ld   ixh,a
Ld34c:      ld   a,(Sm_31+1)

            call MULD

            ADPAXH
            ld   (Om_13+1),a
            ld   a,(Sm_12+1)

            call MULB

            ld   ixh,a
            bit  0,(iy+#00)
            jr   nz,Ld375
            ld   a,(Sm_22+1)
            call MULC
            ADPAXH
            ld   ixh,a
Ld375:      ld   a,(Sm_32+1)
            call MULD
            ADPAXH
            ld   (Om_23+1),a
            ld   a,(Sm_13+1)
            call MULB
            ld   ixh,a
            bit  0,(iy+#00)
            jr   nz,Ld39e
            ld   a,(Sm_23+1)
            call MULC
            ADPAXH
            ld   ixh,a
Ld39e:      ld   a,(Sm_33+1)
            call MULD
            ADPAXH
            ld   (Om_33+1),a
            bit  0,(iy+#00)
            jp   nz,Ld429

Gm_12:      ld   b,0
Gm_22:      ld   c,0
Gm_32:      ld   d,0

            ld   a,(Sm_11+1)
            call MULB
            ld   ixh,a
            ld   a,(Sm_21+1)
            call MULC
            ADPAXH
            ld   ixh,a
            ld   a,(Sm_31+1)
            call MULD
            ADPAXH
            ld   (Om_12+1),a
            ld   a,(Sm_12+1)
            call MULB
            ld   ixh,a
            ld   a,(Sm_22+1)
            call MULC
            ADPAXH
            ld   ixh,a
            ld   a,(Sm_32+1)
            call MULD
            ADPAXH
            ld   (Om_22+1),a
            ld   a,(Sm_13+1)
            call MULB
            ld   ixh,a
            ld   a,(Sm_23+1)
            call MULC
            ADPAXH
            ld   ixh,a
            ld   a,(Sm_33+1)
            call MULD
            ADPAXH
            ld   (Om_32+1),a
            ret  
Ld429:
            ld   a,(Sm_21+1)
            ld   (Om_12+1),a
            ld   a,(Sm_22+1)
            ld   (Om_22+1),a
            ld   a,(Sm_23+1)
            ld   (Om_32+1),a
            ret  
Ld43c:
            ld   a,(Sm_21+1)
            ld   (Om_12+1),a
            ld   a,(Sm_22+1)
            ld   (Om_22+1),a
            ld   a,(Sm_23+1)
            ld   (Om_32+1),a
            ld   a,(Eyeb)
            and  a
            jr   z,Ld485
            jp   p,Ld4aa
            jp   po,Ld4d5
            ld   a,(Sm_31+1)
            ld   (Om_11+1),a
            ld   a,(Sm_32+1)
            ld   (Om_21+1),a
            ld   a,(Sm_33+1)
            ld   (Om_31+1),a
            ld   a,(Sm_11+1)
            neg  
            ld   (Om_13+1),a
            ld   a,(Sm_12+1)
            neg  
            ld   (Om_23+1),a
            ld   a,(Sm_13+1)
            neg  
            ld   (Om_33+1),a
            ret  
Ld485:      ld   a,(Sm_11+1)
            ld   (Om_11+1),a
            ld   a,(Sm_12+1)
            ld   (Om_21+1),a
            ld   a,(Sm_13+1)
            ld   (Om_31+1),a
            ld   a,(Sm_31+1)
            ld   (Om_13+1),a
            ld   a,(Sm_32+1)
            ld   (Om_23+1),a
            ld   a,(Sm_33+1)
            ld   (Om_33+1),a
            ret  
Ld4aa:      ld   a,(Sm_31+1)
            neg  
            ld   (Om_11+1),a
            ld   a,(Sm_32+1)
            neg  
            ld   (Om_21+1),a
            ld   a,(Sm_33+1)
            neg  
            ld   (Om_31+1),a
            ld   a,(Sm_11+1)
            ld   (Om_13+1),a
            ld   a,(Sm_12+1)
            ld   (Om_23+1),a
            ld   a,(Sm_13+1)
            ld   (Om_33+1),a
            ret  
Ld4d5:      ld   a,(Sm_11+1)
            neg  
            ld   (Om_11+1),a
            ld   a,(Sm_12+1)
            neg  
            ld   (Om_21+1),a
            ld   a,(Sm_13+1)
            neg  
            ld   (Om_31+1),a
            ld   a,(Sm_31+1)
            neg  
            ld   (Om_13+1),a
            ld   a,(Sm_32+1)
            neg  
            ld   (Om_23+1),a
            ld   a,(Sm_33+1)
            neg  
            ld   (Om_33+1),a
            ret  








Renobj2:
            ld   a,(Eye_b)
            ld   b,a
            ld   a,(Eyeb)
            sub  b
            ld   b,a
            add  a,#40
            ld   h,Sintb
            ld   l,a
            ld   a,(hl)             ;COS
            ld   (Om1_11+1),a
            ld   (Om2_11+1),a
            ld   l,b
            ld   a,(hl)             ;SIN
            ld   (Om1_13+1),a
            ld   (Om2_13+1),a
            ld   a,(Indx)
            ld   l,a
            ld   h,L97
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            ld   a,4
            ld   (Adt+1),a
            inc  hl
            call Ld756
            inc  hl
Ld534:      ld   a,(hl)
            inc  hl
            and  a
            ret  z
            ld   ixl,a
            ld   b,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push hl
            call Rendot             ;RENDR DOTS
            pop  hl
            jp   Ld534








Rendot:
            ld   h,Multb
Om1_11:     ld   a,0
            call MULB
            ld   (Mvx1+1),a
Om1_13:     ld   a,0
            call MULD
            ld   (Mvx3+1),a
Om2_13:     ld   a,0
            neg  
            call MULB
            ld   (Mvz1+1),a
Om2_11:     ld   a,0
            call MULD
            ld   (Mvz3+1),a
            ld   a,c
            ld   (Mvy2+1),a
            xor  a
            ld   (Mvx2+1),a
            ld   (Mvy1+1),a
            ld   (Mvy3+1),a
            ld   (Mvz2+1),a
            jp   Rendi






Renobj:
            ld   a,(Indx)
            ld   l,a
            ld   h,L97
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
            ld   a,4
            ld   (Adt+1),a
            inc  hl
            call Ld756
            inc  hl
Ld597:      ld   a,(hl)
            inc  hl
            and  a
            ret  z
            ld   ixl,a
            ld   b,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   d,(hl)
            inc  hl
            push hl
            call Rendot2
            pop  hl
            jp   Ld597









Rendot2:
            ld   h,Multb
Om_11:      ld   a,0
            call MULB
            ld   (Mvx1+1),a
Om_12:      ld   a,0
            call MULC
            ld   (Mvx2+1),a
Om_13:      ld   a,0
            call MULD
            ld   (Mvx3+1),a
Om_21:      ld   a,0
            call MULB
            ld   (Mvy1+1),a
Om_22:      ld   a,0
            call MULC
            ld   (Mvy2+1),a
Om_23:      ld   a,0
            call MULD
            ld   (Mvy3+1),a
Om_31:      ld   a,0
            call MULB
            ld   (Mvz1+1),a
Om_32:      ld   a,0
            call MULC
            ld   (Mvz2+1),a
Om_33:      ld   a,0
            call MULD
            ld   (Mvz3+1),a



Rendi:
            ld   (Stkc+1),sp
Adt:        ld   sp,low(L9c)*256

Mvy1:       ld   bc,0
Mvx1:       equ  $-2
Mvy2:       ld   de,0
Mvx2:       equ  $-2
Mvy3:       ld   hl,0
Mvx3:       equ  $-2
            add  hl,bc
            add  hl,de
            ld   (Xb0+1),hl
            rlc  b
            rlc  c
            rlc  d
            rlc  e
            SUB_BC
            ld   (Xb1+1),hl
            SUB_DE
            ld   (Xb3+1),hl
            add  hl,bc
            ld   (Xb2+1),hl
            ld   a,l
            neg  
            ld   l,a
            ld   a,h
            neg  
            ld   h,a
            ld   (Xb5+1),hl
            add  hl,bc
            ld   (Xb4+1),hl
            SUB_DE
            ld   (Xb6+1),hl
            SUB_BC
            ld   (Xb7+1),hl
            ld   b,ixl
Mvz3:       ld   a,0
Mvz2:       ld   de,0
Mvz1:       equ  $-2
            add  a,d
            add  a,e
            ld   ixh,a
            rlc  d
            rlc  e
            sub  d
            ld   iyh,a
            sub  e
            ld   iyl,a
            add  a,d
            ld   ixl,a
            neg  
            ld   (Ctl+1),a
            add  a,d
            ld   (Zb4+1),a
            sub  e
            ld   (Zb6+1),a
            sub  d
            ld   (Zb7+1),a
Xb0:        ld   de,0
            ld   a,b
            cp   #01
            jr   z,Ld62f            ;SIMPYL GET DOT
            cp   #81
            jr   nz,Ld633
            ld   a,ixh
            ld   hl,$+6
            jp   Calcd
            ld   a,ixh
            neg  
            ld   ixh,a
            ld   a,d
            neg  
            ld   d,a
            ld   a,e
            neg  
            ld   e,a
Ld62f:
            ld   a,ixh
            ld   hl,Endc
            jp   Calcd
Ld633:
            ld   a,ixh
            bit  0,b
            ld   hl,$+6
            jp   nz,Calcd           ;TAKE 1ST setDOT
Xb1:        ld   de,0
            ld   a,iyh
            bit  1,b
            ld   hl,$+6
            jp   nz,Calcd           ;REND OF z
Xb3:        ld   de,0
            ld   a,iyl
            bit  3,b
            ld   hl,$+6
            jp   nz,Calcd           ;REND OF X
            bit  2,b
Xb2:        ld   de,0
            ld   a,ixl
            ld   hl,$+6
            jp   nz,Calcd           ;REND OF zBACK
Xb6:        ld   de,0
Zb6:        ld   a,0
            bit  6,b
            ld   hl,$+6
            jp   nz,Calcd           ;REND OF Y
Xb7:        ld   de,0
Zb7:        ld   a,0
            bit  7,b
            ld   hl,$+6
            jp   nz,Calcd           ;REND OF z
Xb5:        ld   de,0
Ctl:        ld   a,0
            bit  5,b
            ld   hl,$+6
            jp   nz,Calcd           ;REND OF X BACK
Xb4:        ld   de,0
Zb4:        ld   a,0
            bit  4,b
            ld   hl,$+6
            jp   nz,Calcd           ;NOT REND OF ZBACK
Endc:
            ld   hl,0
            add  hl,sp
            ld   a,l
            ld   (Adt+1),a
Stkc:       ld   sp,0
            ret  

Calcd:
            exx  
Tz:         ld   de,0
            ld   l,a
            rlca 
            and  1
            neg  
            ld   h,a
Jmp4:       jr   $
            ADDHLHL 5
            and  a
            adc  hl,de

            jp   m,Ld73d

            EXD
            exx  
            ld   a,e
            exx  
            ld   l,a
            rlca 
            and  1
            neg  
            ld   h,a
Ty:         ld   bc,0
Jmp5:       jr   $
            ADDHLHL 5
            and  a
            adc  hl,bc
            jp   p,$+10
            NEGHL
            ex   af,af'
;DIV
            ld   a,l
            ld   l,h
            ld   h,#00
            SUB_DE
            jp   nc,Ld73d
            add  hl,de
            rla  
            adc  hl,hl
            and  a
            sbc  hl,de
            jp   nc,Ld73d
            rept 7
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            endr
            add  hl,de
            rla  
            ld   b,a
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            rept 7
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            endr
            add  hl,de
            rla  
            cpl  
            ld   l,a
            ld   a,b
            cpl  
            ld   h,a
            ex   af,af'
            jp   p,$+10
            NEGHL
MDY:        ld   bc,0               ;MIDLE Y
            add  hl,bc
            push hl
            exx  
            ld   a,d
            exx  
            ld   l,a
            rlca 
            and  1
            neg  
            ld   h,a
Tx:         ld   bc,0
Jmp6:       jr   $
            ADDHLHL 5
            and  a
            adc  hl,bc
            jp   p,$+10
            NEGHL
            ex   af,af'
;DIV
            ld   a,l
            ld   l,h
            ld   h,#00
            SUB_DE
            jp   nc,Ld73c
            add  hl,de
            rla  
            adc  hl,hl
            and  a
            sbc  hl,de
            jp   nc,Ld73c
            rept 7
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            endr
            add  hl,de
            rla  
            ld   b,a
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            rept 7
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            endr
            add  hl,de
            rla  
            cpl  
            ld   l,a
            ld   a,b
            cpl  
            ld   h,a
            ex   af,af'
            jp   p,$+10
            NEGHL
MDX:        ld   de,0               ;MIDLE X
            add  hl,de

            ld   (Jji+1),hl

            ld   hl,0-3
            add  hl,sp
            ld   b,(hl)
            dec  hl
            ld   c,(hl)
            ld   (Jji2+2),hl

Jji:        ld   hl,0

            push hl
            ld   hl,9
            add  hl,sp
            ld   sp,hl

Jji2:       ld   (0),bc

            exx  
            jp   (hl)
Ld73d:
            push de
            ld   d,#80
            push de
            ld   hl,9
            add  hl,sp
            ld   sp,hl
            exx  
            jp   (hl)
Ld73c:
            ld   d,#80
            push de
            ld   hl,9
            add  hl,sp
            ld   sp,hl
            exx  
            jp   (hl)


Ld756:
            ld   b,(hl)
            res  7,b
            ld   a,#06
            sub  b
            ld   (Jmp4+1),a
            ld   (Jmp5+1),a
            ld   (Jmp6+1),a
            ret  



Drwpol:
            ld   a,(hl)
            and  a
            ret  z
            jp   m,Ld8b2
            and  #0F
            ld   b,a
            call Vspoly
            jp   p,Ld8a5
            xor  a                  ;MAY BE VISIBLE POYL
            ld   (L91+#5A),a
            call Lda9f
            jr   c,Ld8aa
            cpl  
            and  #F0
            jr   nz,Ld8aa
            ld   a,(hl)
            inc  hl
            rrca 
            rrca 
            rrca 
            rrca 
            and  #07
            ld   (L91+#1A),a
            ld   a,c
            and  #0F
            jr   nz,Ld89a
            ld   de,low(L9e)*256
            ld   a,b
            add  a,a
            ld   (L91+#0A),a
            ld   b,L9c
            rrca 
            ex   af,af'
            ld   c,(hl)
            inc  hl
            ld   a,(bc)
            ld   (de),a
            inc  e
            inc  c
            inc  c
            ld   a,(bc)
            ld   (de),a
            inc  e
            ex   af,af'
            dec  a
            jp   nz,$-13
            call Polygon
            jp   Drwpol
Ld89a:      call Clip
            call nc,Polygon
            jp   Drwpol
Ld8a5:      ld   a,#01
            ld   (L91+#5A),a
Ld8aa:      inc  b
            ld   c,b
            ld   b,#00
            add  hl,bc
            jp   Drwpol



Ld8b2:      and  #0F
            ld   b,a
            bit  6,(hl)
            jr   z,Ld8bf
            ld   a,(L91+#5A)
            and  a
            jr   nz,Ld8aa
Ld8bf:      dec  b
            ld   a,(hl)
            inc  hl
            and  #30
            jr   z,Ld8d2            ;andMASK
            cp   #10
            jr   z,Ld8da            ;orMASK
;xorMASK
;COMAND xorc:jrc,
            ld   de,#38A9
            ld   a,low(Ld1l)
            jp   Ld8df
;COMAND andc:jrnc,
Ld8d2:      ld   de,#30A1
            ld   a,low(Ld1l)+8
            jp   Ld8df
;COMAND orc:jrc,
Ld8da:      ld   de,#38B1
            ld   a,low(Ld1l)
Ld8df:      ld   (L91+#4E),de
            ld   (Ldadd),a
            ld   ixh,L9c
            ld   a,(hl)
            ld   ixl,a
            inc  hl
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (L91+#3E),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (L91+#4A),de
            ld   a,(ix+#04)
            ld   (L91+#4D),a
Ld907:      ld   a,(hl)
            ld   ixl,a
            inc  hl
            push bc
            push hl
            ld   hl,(L91+#3E)
            ld   (L91+#3A),hl
            ld   hl,(L91+#4A)
            ld   (L91+#3C),hl
            ld   a,(L91+#4D)
            ld   (L91+#4C),a
            ld   b,a
            ld   e,(ix+#00)
            ld   d,(ix+#01)
            ld   (L91+#3E),de
            ld   e,(ix+#02)
            ld   d,(ix+#03)
            ld   (L91+#4A),de
            and  a
            ld   a,(ix+#04)
            ld   (L91+#4D),a
            jr   z,Ld967
            and  a
            jr   z,Ld967
            or   b
            ld   b,a
            cpl  
            and  #F0
            jr   nz,Ld967
            ld   a,b
            and  #0F
            jr   nz,Ld96e
            ld   a,(L91+#3A)
            ld   (L91+#2A),a
            ld   a,(L91+#3C)
            ld   (L91+#2B),a
            ld   a,(L91+#3E)
            ld   (L91+#2C),a
            ld   a,(L91+#4A)
            ld   (L91+#2D),a
Ld964:      call Drwlin             ;LDABE
Ld967:      pop  hl
            pop  bc
            djnz Ld907
            jp   Drwpol
Ld96e:      ld   hl,(L91+#3A)
            ld   (L91+#0B),hl
            ld   hl,(L91+#3C)
            ld   (L91+#0D),hl
            ld   a,(L91+#4C)
            ld   (L91+#0F),a
            ld   hl,(L91+#3E)
            ld   (L91+#1B),hl
            ld   hl,(L91+#4A)
            ld   (L91+#1D),hl
            ld   a,(L91+#4D)
            ld   (L91+#1F),a
            push ix
            call CLIPLIN
            pop  ix
            jr   nz,Ld967
            ld   hl,low(L9e)*256
            ld   a,(hl)
            inc  l
            ld   (L91+#2A),a
            ld   a,(hl)
            inc  l
            ld   (L91+#2B),a
            ld   a,(hl)
            inc  l
            ld   (L91+#2C),a
            ld   a,(hl)
            ld   (L91+#2D),a
            jp   Ld964




Drwpol2:
            ld   a,(hl)
            and  a
            ret  z
            jp   m,Ld9ea
            and  #0F
            ld   b,a
            call Vspoly
            jp   p,Ld9dd
            xor  a
            ld   (L91+#5A),a
            ld   a,(hl)
            inc  hl
            rrca 
            rrca 
            rrca 
            rrca 
            and  #07
            ld   (L91+#1A),a
            ld   de,low(L9e)*256
            ld   a,b
            add  a,a
            ld   (L91+#0A),a
            ld   b,L9c
            rrca 
            ex   af,af'
            ld   c,(hl)
            inc  hl
            ld   a,(bc)
            ld   (de),a
            inc  e
            inc  c
            inc  c
            ld   a,(bc)
            ld   (de),a
            inc  e
            ex   af,af'
            dec  a
            jp   nz,$-13
            call Polygon
            jp   Drwpol2
Ld9dd:      ld   a,#01
            ld   (L91+#5A),a
Ld9e2:      inc  b
            ld   c,b
            ld   b,#00
            add  hl,bc
            jp   Drwpol2
Ld9ea:      and  #0F
            ld   b,a
            bit  6,(hl)
            jr   z,Ld9f7
            ld   a,(L91+#5A)
            and  a
            jr   nz,Ld9e2
Ld9f7:      dec  b
            ld   a,(hl)
            inc  hl
            and  #30
            jr   z,Lda0a
            cp   #10
            jr   z,Lda12
            ld   de,#38A9
            ld   a,low(Ld1l)
            jp   Lda17
Lda0a:      ld   de,#30A1
            ld   a,low(Ld1l)+8
            jp   Lda17
Lda12:      ld   de,#38B1
            ld   a,low(Ld1l)
Lda17:      ld   (L91+#4E),de
            ld   (Ldadd),a
            ld   d,L9c
            ld   e,(hl)
            inc  hl
            ld   a,(de)
            ld   (L91+#2C),a
            inc  e
            inc  e
            ld   a,(de)
            ld   (L91+#2D),a
Lda2c:      ld   d,L9c
            ld   e,(hl)
            inc  hl
            push bc
            push hl
            ld   hl,(L91+#2C)
            ld   (L91+#2A),hl
            ld   a,(de)
            ld   (L91+#2C),a
            inc  e
            inc  e
            ld   a,(de)
            ld   (L91+#2D),a
            call Drwlin             ;LDABE
            pop  hl
            pop  bc
            djnz Lda2c
            jp   Drwpol2
Lda9f:      ld   ixl,b
            push hl
            EXD
            inc  de
            ld   h,L9c
            ld   c,#00
Ldaa8:      ld   a,(de)
            inc  de
            add  a,#04
            ld   l,a
            ld   a,(hl)
            and  a
            jr   z,Ldab9
            or   c
            ld   c,a
            djnz Ldaa8
            pop  hl
            ld   b,ixl
            ret  
Ldab9:      scf  
            pop  hl
            ld   b,ixl
            ret  



Drwlin:
            ld   hl,(L91+#2A)
            ld   de,(L91+#2C)
            SUB_DE
            ret  z
            add  hl,de
;h,d-Y : l,e-X
Drawl1:
            ld   a,d
            sub  h
            jr   nc,Ldad8
            EXD
            neg  
Ldad8:      ld   d,a
            ld   a,l
            and  #07
            add  a,#00
Ldadd:      equ  $-#0001
            ld   c,a
            ld   a,high(Ld1l)
            adc  a,#00
            ld   b,a
            ld   a,(bc)

            ex   af,af'
            ld   c,l
            ld   l,h
            ld   h,high(TBXX2)
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,c
            add  a,(hl)
            ld   l,a
            ld   h,b
            ld   a,c
            ex   af,af'
            ld   c,a
            ex   af,af'

            sub  e
            jr   c,Ldb59
            cp   d
            jr   c,Ldb2d
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            ex   af,af'
            ld   a,(L91+#4E)        ;COMAND 1
            ld   (Ldb0d),a
            ld   a,(L91+#4F)        ;COMAND 2
            ld   (Ldb10),a
            ld   a,(hl)
Ldb0d:      nop  
            rlc  c
Ldb10:      jr   c,Ldb1d
Ldb12:      ex   af,af'
            sub  e
            jr   c,Ldb23
            ex   af,af'
            djnz Ldb0d
            ld   (hl),a
            ret  
Ldb1d:      ld   (hl),a
            dec  l
            ld   a,(hl)
            jp   Ldb12
Ldb23:      add  a,d
            ex   af,af'
            ld   (hl),a

            NEXTLINE

            ld   a,(hl)
            djnz Ldb0d
            ret  
Ldb2d:      ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            ex   af,af'
            ld   a,(L91+#4E)
            ld   (Ldb40),a
            ld   a,(L91+#4F)
            ld   (Ldb4a),a
Ldb3f:      ld   a,(hl)
Ldb40:      nop  
            ld   (hl),a

            NEXTLINE

            ex   af,af'
            sub  e
            jr   nc,Ldb4c
            add  a,d
            rlc  c
Ldb4a:      jr   c,Ldb52
Ldb4c:      ex   af,af'
            djnz Ldb3f
            ret  
Ldb52:      dec  l
            ex   af,af'
            djnz Ldb3f
            ret  
Ldb59:      neg  
            cp   d
            jr   c,Ldb91
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            ex   af,af'
            ld   a,(L91+#4E)
            ld   (Ldb71),a
            ld   a,(L91+#4F)
            ld   (Ldb74),a
            ld   a,(hl)
Ldb71:      nop  
            rrc  c
Ldb74:      jr   c,Ldb81
Ldb76:      ex   af,af'
            sub  e
            jr   c,Ldb87
            ex   af,af'
            djnz Ldb71
            ld   (hl),a
            ret  
Ldb81:      ld   (hl),a
            inc  l
            ld   a,(hl)
            jp   Ldb76
Ldb87:      add  a,d
            ex   af,af'
            ld   (hl),a

            NEXTLINE

            ld   a,(hl)
            djnz Ldb71
            ret  
Ldb91:      ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            ex   af,af'
            ld   a,(L91+#4E)
            ld   (Ldba4),a
            ld   a,(L91+#4F)
            ld   (Ldbae),a
Ldba3:      ld   a,(hl)
Ldba4:      nop  
            ld   (hl),a

            NEXTLINE

            ex   af,af'
            sub  e
            jr   nc,Ldbb0
            add  a,d
            rrc  c
Ldbae:      jr   c,Ldbb6
Ldbb0:      ex   af,af'
            djnz Ldba3
            ret  
Ldbb6:      inc  l
            ex   af,af'
            djnz Ldba3
            ret  





Vsmask:
            push hl
            xor  a
            ex   af,af'
            ld   hl,(low(L9c)*256)+1
            ld   a,(Adt+1)
            sub  4
            ld   b,a

LD814:      ld   c,#00
            ld   a,(hl)
            cp   #80
            jr   z,Ld85d
            and  a
            jp   m,V1
            jp   nz,V2
            dec  l
            ld   a,(hl)
            inc  l
XH7:        cp   #FF                ;+1
            jr   nc,V2
            jp   V3
V1:
            set  1,c
            jp   V3
V2:
            set  0,c
V3:
            inc  l
            inc  l
            ld   a,(hl)
            and  a
            jp   m,V4
            jp   nz,V5
            dec  l
            ld   a,(hl)
            inc  l
YH6:        cp   #FF                ;+1
            jr   nc,V5
            jp   V6
V4:
            set  3,c
            jp   V6
V5:
            set  2,c
V6:
            inc  l
            ld   a,c
            rlca 
            rlca 
            rlca 
            rlca 
            xor  #F0
            or   c
            ld   (hl),a
            ex   af,af'
            or   (hl)
            ex   af,af'
            inc  l
            ld   a,l
            inc  l
            cp   b
            jp   nz,LD814
            pop  hl
            ex   af,af'
            ret  
Ld85d:      pop  hl
            xor  a
            ret  







Vspoly:
            push bc
            push hl
            inc  hl
            cp   #05
            jr   nc,Lda5b
            ld   d,(hl)
            inc  hl
            ld   e,(hl)
            inc  hl
            ld   a,(hl)
            jp   Lda62
Lda5b:      ld   d,(hl)
            INC_HL 2
            ld   e,(hl)
            INC_HL 2
            ld   a,(hl)
Lda62:      ld   h,L9c
            ld   l,d
            ex   af,af'
            ld   c,(hl)
            inc  l
            ld   b,(hl)
            inc  l
            ld   a,(hl)
            inc  l
            exx  
            ld   c,a
            exx  
            ld   a,(hl)
            exx  
            ld   b,a
            exx  
            ld   l,e
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   a,(hl)
            inc  l
            exx  
            ld   e,a
            exx  
            ld   a,(hl)
            exx  
            ld   d,a
            exx  
            ex   af,af'
            ld   l,a
            push de
            ld   e,(hl)
            inc  l
            ld   d,(hl)
            inc  l
            ld   a,(hl)
            inc  l
            exx  
            ld   l,a
            exx  
            ld   a,(hl)
            exx  
            ld   h,a
            exx  
            EXD
            pop  de
            exx  
            sbc  hl,bc
            EXD
            sbc  hl,bc
            push hl
            exx  
            sbc  hl,bc
            EXD
            sbc  hl,bc
            ex   (sp),hl
            exx  
            pop  hl
            call Mull
            push hl
            push de
            exx  
            call Mull
            EXD
            pop  bc
            sbc  hl,bc
            EXD
            pop  bc
            sbc  hl,bc
            pop  hl
            pop  bc
            ret  


