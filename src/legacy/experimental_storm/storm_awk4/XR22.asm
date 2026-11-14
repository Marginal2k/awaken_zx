
;DRAW LINE FROM SOME CORDS
Drwlin:
            ld   hl,(L91+#2A)
            ld   de,(L91+#2C)
            and  a
            sbc  hl,de
            ret  z
            add  hl,de
;DRAW LINE CORDS IN HL,DE
;H,D-Y : L,E-X
Drawl1:
            ld   (Ldbbb),sp
            ld   sp,#0020
            ld   a,d
            sub  h
            jr   nc,Ldad8
            ex   de,hl
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
            ld   c,a
            ld   a,l
            srl  h
            rr   l
            srl  h
            rr   l
            scf  
            rr   h
            rr   l
            sub  e
            jr   c,Ldb59
            cp   d
            jr   c,Ldb2d
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            ex   af,af
;PUT INSIDE COMAND FOR THIS LINE
            ld   a,(L91+#4E)        ;COMAND 1
            ld   (Ldb0d),a
            ld   a,(L91+#4F)        ;COMAND 2
            ld   (Ldb10),a
            ld   a,(hl)
Ldb0d:      nop  
            rlc  c
Ldb10:      jr   c,Ldb1d
Ldb12:      ex   af,af
            sub  e
            jr   c,Ldb23
            ex   af,af
            djnz Ldb0d
            ld   (hl),a
            jp   Ldbba
Ldb1d:      ld   (hl),a
            dec  l
            ld   a,(hl)
            jp   Ldb12
Ldb23:      add  a,d
            ex   af,af
            ld   (hl),a
            add  hl,sp
            ld   a,(hl)
            djnz Ldb0d
            jp   Ldbba
Ldb2d:      ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            ex   af,af
            ld   a,(L91+#4E)
            ld   (Ldb40),a
            ld   a,(L91+#4F)
            ld   (Ldb4a),a
Ldb3f:      ld   a,(hl)
Ldb40:      nop  
            ld   (hl),a
            add  hl,sp
            ex   af,af
            sub  e
            jr   nc,Ldb4c
            add  a,d
            rlc  c
Ldb4a:      jr   c,Ldb52
Ldb4c:      ex   af,af
            djnz Ldb3f
            jp   Ldbba
Ldb52:      dec  l
            ex   af,af
            djnz Ldb3f
            jp   Ldbba
Ldb59:      neg  
            cp   d
            jr   c,Ldb91
            ld   e,d
            ld   d,a
            ld   b,a
            srl  a
            ex   af,af
            ld   a,(L91+#4E)
            ld   (Ldb71),a
            ld   a,(L91+#4F)
            ld   (Ldb74),a
            ld   a,(hl)
Ldb71:      nop  
            rrc  c
Ldb74:      jr   c,Ldb81
Ldb76:      ex   af,af
            sub  e
            jr   c,Ldb87
            ex   af,af
            djnz Ldb71
            ld   (hl),a
            jp   Ldbba
Ldb81:      ld   (hl),a
            inc  l
            ld   a,(hl)
            jp   Ldb76
Ldb87:      add  a,d
            ex   af,af
            ld   (hl),a
            add  hl,sp
            ld   a,(hl)
            djnz Ldb71
            jp   Ldbba
Ldb91:      ld   e,a
            ld   a,d
            ld   b,d
            srl  a
            ex   af,af
            ld   a,(L91+#4E)
            ld   (Ldba4),a
            ld   a,(L91+#4F)
            ld   (Ldbae),a
Ldba3:      ld   a,(hl)
Ldba4:      nop  
            ld   (hl),a
            add  hl,sp
            ex   af,af
            sub  e
            jr   nc,Ldbb0
            add  a,d
            rrc  c
Ldbae:      jr   c,Ldbb6
Ldbb0:      ex   af,af
            djnz Ldba3
            jp   Ldbba
Ldbb6:      inc  l
            ex   af,af
            djnz Ldba3
Ldbba:      ld   sp,#0000
Ldbbb:      equ  $-#0002
            ret  






;CALC VISIBLE MASK FOR POLYGON
Vsmask:
            push hl
            xor  a
            ex   af,af
            ld   hl,L9c*256+1
Adt:        ld   a,0
            sub  4
            ld   b,a
Ld814:      ld   c,#00
            ld   a,(hl)
            inc  l
            inc  l
            cp   #80
            jr   z,Ld85d
            jr   nc,Ld826
            and  a
            jp   nz,Ld82b
            jp   Ld82d
Ld826:      set  1,c
            jp   Ld82d
Ld82b:      set  0,c
Ld82d:      ld   a,(hl)
            and  a
            jp   m,Ld83f
            jp   nz,Ld844
            dec  l
            ld   a,(hl)
            inc  l
            cp   #60
            jr   nc,Ld844
            jp   Ld846
Ld83f:      set  3,c
            jp   Ld846
Ld844:      set  2,c
Ld846:      inc  l
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
            inc  l
            ld   a,l
            inc  l
            cp   b
            jp   nz,Ld814
            pop  hl
            ex   af,af
            ret  
Ld85d:      pop  hl
            xor  a
            ret  


;VISIBILITY POLYGON
;RET FS-M POLY VISIBLE
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
            inc  hl
            inc  hl
            ld   e,(hl)
            inc  hl
            inc  hl
            ld   a,(hl)
Lda62:      ld   h,L9c
            ld   l,d
            ld   (Lda7a),sp
            ld   sp,hl
            pop  bc
            exx  
            pop  bc
            exx  
            ld   l,e
            ld   sp,hl
            pop  de
            exx  
            pop  de
            exx  
            ld   l,a
            ld   sp,hl
            pop  hl
            exx  
            pop  hl
            ld   sp,#0000
Lda7a:      equ  $-#0002
            sbc  hl,bc
            ex   de,hl
            sbc  hl,bc
            push hl
            exx  
            sbc  hl,bc
            ex   de,hl
            sbc  hl,bc
            ex   (sp),hl
            exx  
            pop  hl
            call Mull
            push hl
            push de
            exx  
            call Mull
            ex   de,hl
            pop  bc
            sbc  hl,bc
            ex   de,hl
            pop  bc
            sbc  hl,bc
            pop  hl
            pop  bc
            ret  


