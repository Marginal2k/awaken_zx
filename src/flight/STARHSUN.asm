;OHIDE
;GEND
;GALD
;STARS
;MOVESTARS
;CIRCLE
















; ВЫВОД ХАЙД СКРИНА

; И

; РАБОТА СО ЗВЕЗДАМИ

OHIDE:
            ld   hl,#400F
            exx  
            ld   hl,#8000
            ld   a,#08
            call LDC45
            exx  
            ld   h,#48
            exx  
            ld   a,4
LDC45:      ld   (LDE4F+1),sp
LDC4B:      ld   (LDE49+1),a

            HIDEM #10,#20
            HIDEM #30,#40
            HIDEM #50,#60
            HIDEM #70,#80
            HIDEM #90,#A0
            HIDEM #B0,#C0
            HIDEM #D0,#E0

            ld   sp,hl
            ld   l,#F0
            pop  af
            pop  bc
            pop  de
            pop  ix
            ex   af,af'
            exx  
            pop  af
            pop  bc
            pop  de
            pop  iy
            ld   sp,hl
            inc  sp
            set  4,l
            push iy
            push de
            push bc
            push af
            ex   af,af'
            exx  
            push ix
            push de
            push bc
            push af
            ld   sp,hl
            ld   l,#00
            pop  af
            pop  bc
            pop  de
            pop  ix
            ex   af,af'
            exx  
            pop  af
            pop  bc
            pop  de
            pop  iy
            ld   sp,hl
            inc  sp
            push iy
            push de
            push bc
            push af
            ld   de,#F910
            add  hl,de
            ex   af,af'
            exx  
            push ix
            push de
            push bc
            push af
            inc  h
LDE49:      ld   a,#00
            dec  a
            jp   nz,LDC4B
LDE4F:      ld   sp,#0000
            ret  




;--------------------------------------

; РАБОТА СО ЗВЕЗДАМИ


GEND:
            exx  
            ld   bc,0
            ld   h,b
            ld   l,c
            ld   d,h
            ld   e,l
            dec  hl
            ADDHLHL 2
            EXD
            ld   h,b
            ld   l,c
            add  hl,hl
            add  hl,de
            add  hl,bc
            ld   d,h
            ld   e,l
            ld   l,h
            ld   h,0
            ld   b,h
            ld   c,e
            SUB_BC
            EXD
            SUB_DE
            dec  hl
            ld   (GEND+2),hl
            ld   a,l
            exx  
            ret  


GALD:
; ГЕНЕРАЦИЯ ВСЕХ ЗВЕЗД
            ld   hl,DOTB
            call GEND
            cp   XMIN
            jr   nc,$+4
            add  a,2*XMIN
            cp   XMAX
            jr   c,$+4
            sub  2*XMIN
            ex   af,af'
            call GEND
            and  127
            cp   YMIN
            jr   nc,$+4
            add  a,2*YMIN
            cp   YMAX
            jr   c,$+4
            sub  #40

            ld   (hl),a
            inc  l
            ex   af,af'
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jp   c,GALD+3
            ret  

;DOTS
STARS:
            ld   bc,DOTB
DOT1:
            ld   h,high(TBXY)
            ld   a,(bc)
            ld   l,a
            inc  c
            ld   a,(bc)
            inc  c
            ld   e,a
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            add  a,(hl)
            ld   e,a
            inc  h
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            ld   a,c
            cp   AMO
            jp   c,DOT1
            ret  
MOVESTARS:
            ld   hl,DOTB
            ld   a,(EYE_A)
            and  a
            jp   z,NSKY
            jp   m,PLX
            rla  
            rla  
;              rla
            inc  a
            inc  a
            ld   c,a
DT11:
            ld   a,(hl)
            add  a,c
            jr   c,$+6
            cp   YMAX
            jr   c,DT1
            ld   a,r
            and  #7F
            cp   c
            jr   c,$+5
            sub  c
            jr   $-4
            cp   YMAX-YMIN
            jr   c,$+4
            ld   a,YMAX-YMIN
            add  a,YMIN-1
            ld   (hl),a
            call GEND
            inc  l
            cp   XMIN
            jr   nc,$+4
            add  a,XMIN
            cp   XMAX
            jr   c,$+4
            sub  XMIN
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT11
            jp   NSKY
DT1:
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT11
            jp   NSKY
PLX:
            neg  
            rla  
            rla  
;              rla
            ld   c,a
DT22:
            ld   a,(hl)
            sub  c
            jr   c,$+6
            cp   YMIN
            jr   nc,DT2
            ld   a,r
            and  #7F
            cp   c
            jr   c,$+5
            sub  c
            jr   $-4
            cp   YMAX-YMIN
            jr   c,$+4
            ld   a,YMAX-YMIN
            ld   b,a
            ld   a,YMAX             ;+1
            sub  b
            ld   (hl),a
            call GEND
            inc  l
            cp   XMIN
            jr   nc,$+4
            add  a,XMIN
            cp   XMAX
            jr   c,$+4
            sub  XMIN
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT22
            jp   NSKY
DT2:
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT22
NSKY:
            ld   hl,DOTB+1
            ld   a,(EYE_B)
            and  a
            jp   z,NSKZ
            jp   p,PLY
            neg  
            rla  
            rla  
;              rla
            ld   c,a
DT33:
            ld   a,(hl)
            add  a,c
            jr   c,$+6
            cp   XMAX
            jr   c,DT3
            call GEND
            cp   c
            jr   c,$+5
            sub  c
            jr   $-4
            cp   XMAX-XMIN
            jr   c,$+4
            ld   a,XMAX-XMIN
            add  a,XMIN-1
            ld   (hl),a
            ld   a,r
            and  #7F
            dec  l
            cp   YMIN
            jr   nc,$+4
            add  a,YMIN
            cp   YMAX
            jr   c,$+4
            sub  #40
            ld   (hl),a
            inc  l
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT33
            jp   NSKZ
DT3:
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT33
            jp   NSKZ
PLY:
            rla  
            rla  
;             rla
            inc  a
            inc  a

            ld   c,a
DT44:
            ld   a,(hl)
            sub  c
            jr   c,$+6
            cp   XMIN
            jr   nc,DT4
            call GEND
            cp   c
            jr   c,$+5
            sub  c
            jr   $-4
            cp   XMAX-XMIN
            jr   c,$+4
            ld   a,XMAX-XMIN
            sub  XMAX+1
            neg  
            ld   (hl),a
            ld   a,r
            and  #7F
            dec  l
            cp   YMIN
            jr   nc,$+4
            add  a,YMIN
            cp   YMAX
            jr   c,$+4
            sub  #40
            ld   (hl),a
            inc  l
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT44
            jp   NSKZ
DT4:
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,DT44
NSKZ:
            ld   a,(EYE_G)
            neg  
            and  a
            ret  z
            ld   l,a
            jp   p,$+5
            neg  
            rla  
            rla  
;              rla
            ld   (FORC+1),a
            ld   (FORC2+1),a
            ld   h,SINTB
            ld   a,(hl)
            ld   (SS+1),a
            neg  
            ld   (SS2+1),a
            ld   a,l
            add  a,#40
            ld   l,a
            ld   a,(hl)
            ld   (CS+1),a
            ld   (CS2+1),a
            ld   a,l
            sub  #40
            ld   hl,NZZK
            jp   p,$+6
            ld   hl,NZZK2
            ld   (CLU1+1),hl
            ld   (CLU2+1),hl
            ld   hl,DOTB
NAMO:
            ld   a,(hl)
            sub  YMID
            exx  
            ld   c,a
CS:         ld   e,0
            xor  e
            ex   af,af'
            ld   a,e
            and  a
            jp   p,$+6
            neg  
            ld   e,a
            ld   a,c
            and  a
            jp   p,$+6
            neg  
            ld   c,a
            xor  a
            rept 7
            rr   e
            jr   nc,$+3
            add  a,c
            rra  
            endr
            inc  a
            ld   e,a
            ex   af,af'
            ld   d,0
            jp   p,$+8
            dec  d
            ld   a,e
            cpl  
            ld   e,a
            inc  de
            EXD
            exx  
            inc  l
            ld   a,(hl)
            sub  XMID
            exx  
            ld   c,a
SS:         ld   e,0
            xor  e
            ex   af,af'
            ld   a,e
            and  a
            jp   p,$+6
            neg  
            ld   e,a
            ld   a,c
            and  a
            jp   p,$+6
            neg  
            ld   c,a
            xor  a
            rept 7
            rr   e
            jr   nc,$+3
            add  a,c
            rra  
            endr
            inc  a
            ld   e,a
            ex   af,af'
            ld   d,0
            jp   p,$+8
            dec  d
            ld   a,e
            cpl  
            ld   e,a
            inc  de
            add  hl,de
            ld   bc,YMID
            add  hl,bc
            ld   a,h
            and  a
            jr   nz,FNZ
            ld   a,l
            cp   YMIN
            jr   c,FNZ
            cp   YMAX
            jr   c,FNNZ
FNZ:
            exx  
CLU1:       call NZZK
            ld   (hl),d
            dec  l
            ld   (hl),e
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jp   c,NAMO
            ret  
FNNZ:
            ld   (KOX+1),a
            exx  
            ld   a,(hl)
            sub  XMID
            exx  
            ld   c,a
CS2:        ld   e,0
            xor  e
            ex   af,af'
            ld   a,e
            and  a
            jp   p,$+6
            neg  
            ld   e,a
            ld   a,c
            and  a
            jp   p,$+6
            neg  
            ld   c,a
            xor  a
            rept 7
            rr   e
            jr   nc,$+3
            add  a,c
            rra  
            endr
            inc  a
            ld   e,a
            ex   af,af'
            ld   d,0
            jp   p,$+8
            dec  d
            ld   a,e
            cpl  
            ld   e,a
            inc  de
            EXD
            exx  
            dec  l
            ld   a,(hl)
            sub  YMID
            exx  
            ld   c,a
SS2:        ld   e,0
            xor  e
            ex   af,af'
            ld   a,e
            and  a
            jp   p,$+6
            neg  
            ld   e,a
            ld   a,c
            and  a
            jp   p,$+6
            neg  
            ld   c,a
            xor  a
            rept 7
            rr   e
            jr   nc,$+3
            add  a,c
            rra  
            endr
            inc  a
            ld   e,a
            ex   af,af'
            ld   d,0
            jp   p,$+8
            dec  d
            ld   a,e
            cpl  
            ld   e,a
            inc  de
            add  hl,de
            ld   bc,XMID
            add  hl,bc
            ld   a,h
            and  a
            jr   nz,FNZ2
            ld   a,l
            cp   XMIN
            jr   c,FNZ2
            cp   XMAX
            jr   c,FNNZ2
FNZ2:
            exx  
CLU2:       call NZZK
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            cp   AMO
            jp   c,NAMO
            ret  
FNNZ2:
            exx  
KOX:        ld   (hl),0
            inc  l
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jp   c,NAMO
            ret  

NZZK:
            ld   a,0
            xor  1
            ld   (NZZK+1),a
FORC:       ld   c,0
            jr   nz,NZZKL
            ld   a,r
            cp   c
            jr   c,$+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jr   c,$+4
            ld   a,YMAX-YMIN
            add  a,YMIN-1
            ld   e,a
            ld   a,r
            add  a,#80
            cp   XMAX
            jr   c,$+4
            sub  XMIN
            ld   d,a
            ret  
NZZKL:
            ld   a,r
            cp   c
            jr   c,$+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jr   c,$+4
            ld   a,YMAX-YMIN
            sub  YMAX               ;+1
            neg  
            ld   e,a
            ld   a,r
            cp   XMIN
            jr   nc,$+4
            add  a,XMIN
            ld   d,a
            ret  
NZZK2:
            ld   a,0
            xor  1
            ld   (NZZK2+1),a
FORC2:      ld   c,0
            jr   nz,NZZKL2
            ld   a,r
            cp   c
            jr   c,$+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jr   c,$+4
            ld   a,YMAX-YMIN
            add  a,YMIN-1
            ld   e,a
            ld   a,r
            cp   XMIN
            jr   nc,$+4
            add  a,XMIN
            ld   d,a
            ret  
NZZKL2:
            ld   a,r
            cp   c
            jr   c,$+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jr   c,$+4
            ld   a,YMAX-YMIN
            sub  YMAX               ;+1
            neg  
            ld   e,a
            ld   a,r
            add  a,#80
            cp   XMAX
            jr   c,$+4
            sub  XMIN
            ld   d,a
            ret  



L5E36:      ld   l,d
            add  a,a
            jr   z,ZJ9
            push hl
            add  a,a
            sub  #3E
            neg  
            ld   (ZJ2+1),a
            ld   a,ixl
ZJ2:        jr   $
            rept #1F
            dec  l
            ld   (hl),a
            endr
            pop  hl
ZJ9:        ld   a,(L8628)
            and  a
            ret  

ZJ52:       db   0

CIRCLE:
            ld   (TEXTUR+2),de
            xor  a
            ld   (ZJ52),a
            call ZJ16
            and  a
            ret  z
;CIRCLE
            call ZJ17
            ret  

ZJ19:       exx  
            ld   bc,#0003
            exx  
            ld   a,(ZJ52)
            and  a
            jp   nz,ZJ3
            ld   a,(SUNZ+2)
            bit  7,a
            jp   nz,ZJ4
            and  #7F
            ld   (SUNZ+2),a
            ld   hl,(SUNZ+1)
            EXD
            ld   hl,(SUNX+1)
            ld   a,(SUNZ)
            ld   b,a
            ld   a,(SUNX)
            ld   c,a
            ld   a,h
            bit  7,a
            jr   nz,ZJ5
            exx  
            set  0,b
            exx  
ZJ5:        and  #7F
            ld   h,a
            call ZJ20
            ld   a,d
            ld   (L861B),a
            ld   hl,(SUNZ+1)
            EXD
            ld   hl,(SUNY+1)
            ld   a,(SUNZ)
            ld   b,a
            ld   a,(SUNY)
            ld   c,a
            ld   a,h
            bit  7,a
            jr   nz,ZJ6
            exx  
            set  1,b
            exx  
ZJ6:        and  #7F
            ld   h,a
            call ZJ20
            ld   a,d
            ld   (L861A),a
            exx  
            ld   a,b
            exx  
            ld   (L861C),a
            ld   a,(SUNZ+2)
            and  a
            jr   nz,ZJ7
            ld   hl,#A000
            ld   de,(SUNZ)
            sbc  hl,de
            jr   c,ZJ7
            ld   a,#FF
            jr   ZJ8
ZJ7:        ld   hl,#A000
            ld   de,(SUNZ+1)
            SUB_DE
            jp   c,ZJ4
            ld   a,(SUNZ+2)
            and  a
            jr   z,ZJ10
            ld   b,a
            ld   a,(SUNZ+1)
            ld   c,a
            xor  a
            ld   e,#A0
ZJ12:       sla  c
            rl   b
            jr   c,ZJ11
            sla  e
            rla  
            jr   ZJ12
ZJ11:       scf  
            rr   b
            call ZJ21
            ld   a,d
            jr   ZJ8
ZJ10:       ld   a,(SUNZ+1)
            ld   b,a
            ld   a,#A0
            call ZJ22
            ld   a,d
ZJ8:        jp   ZJ23
ZJ3:        dec  a
            jr   nz,ZJ15
            ld   a,(SUNZ+2)
            bit  7,a
            jp   z,ZJ4
            and  #7F
            ld   (SUNZ+2),a
            ld   hl,(SUNZ+1)
            EXD
            ld   hl,(SUNX+1)
            ld   a,(SUNZ)
            ld   b,a
            ld   a,(SUNX)
            ld   c,a
            ld   a,h
            bit  7,a
            jr   z,ZJ13
            and  #7F
            ld   h,a
            exx  
            set  0,b
            exx  
ZJ13:       jp   ZJ5
ZJ15:       dec  a
            jp   nz,ZJ14
            ld   a,(SUNX+2)
            bit  7,a
            jp   z,ZJ4
            and  #7F
            ld   (SUNX+2),a
            ld   hl,(SUNX+1)
            EXD
            ld   hl,(SUNZ+1)
            ld   a,(SUNX)
            ld   b,a
            ld   a,(SUNZ)
            ld   c,a
            ld   a,h
            bit  7,a
            jr   nz,ZJ24
            exx  
            set  0,b
            exx  
ZJ24:       and  #7F
            ld   h,a
            call ZJ20
            ld   a,d
            ld   (L861B),a
            ld   hl,(SUNX+1)
            EXD
            ld   hl,(SUNY+1)
            ld   a,(SUNX)
            ld   b,a
            ld   a,(SUNY)
            ld   c,a
            ld   a,h
            bit  7,a
            jr   nz,ZJ25
            exx  
            set  1,b
            exx  
ZJ25:       and  #7F
            ld   h,a
            call ZJ20
            ld   a,d
            ld   (L861A),a
            exx  
            ld   a,b
            exx  
            ld   (L861C),a
            ld   a,(SUNX+2)
            and  a
            jr   nz,ZJ26
            ld   hl,#A000
            ld   de,(SUNX)
            sbc  hl,de
            jr   c,ZJ26
            ld   a,#FF
            jr   ZJ27
ZJ26:       ld   hl,#A000
            ld   de,(SUNX+1)
            SUB_DE
            jp   c,ZJ4
            ld   a,(SUNX+2)
            and  a
            jr   z,ZJ28
            ld   b,a
            ld   a,(SUNX+1)
            ld   c,a
            xor  a
            ld   e,#A0
ZJ29:       sla  c
            rl   b
            jr   c,ZJ30
            sla  e
            rla  
            jp   ZJ29
ZJ30:       scf  
            rr   b
            call ZJ21
            ld   a,d
            jr   ZJ27
ZJ28:       ld   a,(SUNX+1)
            ld   b,a
            ld   a,#A0
            call ZJ22
            ld   a,d
ZJ27:       jp   ZJ23
ZJ14:       ld   a,(SUNX+2)
            bit  7,a
            jp   nz,ZJ4
            ld   hl,(SUNX+1)
            EXD
            ld   hl,(SUNZ+1)
            ld   a,(SUNX)
            ld   b,a
            ld   a,(SUNZ)
            ld   c,a
            ld   a,h
            bit  7,a
            jr   z,ZJ31
            exx  
            set  0,b
            exx  
ZJ31:       jp   ZJ24
ZJ23:       ld   (L861D),a
            ld   a,#01
            ret  
ZJ32:       ld   h,l
            ld   l,c
            ld   d,e
            ld   e,b
            jp   ZJ33
ZJ20:       push hl
            exx  
            dec  c
            exx  
            SUB_DE
            jp   c,ZJ34
            jp   z,ZJ35
ZJ36:       pop  hl
            ld   a,h
            and  a
            jr   z,ZJ32
            ld   a,#08
ZJ37:       sla  c
            adc  hl,hl
            jp   c,ZJ38
            sla  b
            rl   e
            rl   d
            dec  a
            jr   nz,ZJ37
ZJ33:       ld   a,#08
ZJ39:       add  hl,hl
            jp   c,ZJ38
            EXD
            add  hl,hl
            EXD
            dec  a
            jr   nz,ZJ39
            ld   a,#08
ZJ40:       sla  h
            jp   c,ZJ38
            sla  d
            dec  a
            jr   nz,ZJ40
            ret  
ZJ35:       push bc
            ld   a,c
            sub  b
            pop  bc
            jr   c,ZJ34
            jr   z,ZJ34
            jp   ZJ36
ZJ41:       set  2,b
            jp   ZJ42
ZJ34:       exx  
            dec  c
            jr   nz,ZJ41
            set  3,b
ZJ42:       inc  c
            exx  
            pop  hl
            ld   a,#17
ZJ43:       sla  c
            adc  hl,hl
            push af
            sla  b
            rl   e
            rl   d
            jr   c,ZJ44
            pop  af
            dec  a
            jr   nz,ZJ43
            ret  
ZJ38:       sla  b
            rl   e
            rl   d
            push af
            scf  
            rr   h
            rr   l
            pop  af
            jr   c,ZJ45
            push hl
            SUB_DE
            jr   nc,ZJ46
            pop  hl
ZJ45:       scf  
            rr   d
            SUB_DE
            jr   ZJ47
ZJ46:       pop  hl
            pop  af
ZJ4:        xor  a
            ret  
ZJ48:       scf  
            rr   h
            jr   ZJ49
ZJ44:       pop  af
            jr   c,ZJ48
            rr   h
ZJ49:       scf  
            rr   d
ZJ47:       ld   a,h
            ld   b,d
ZJ22:       ld   e,#00
ZJ21:       ld   d,#FE
ZJ50:       sla  e
            rla  
            jr   c,ZJ51
            cp   b
            jr   nc,ZJ51
            sla  d
            ret  nc
            jr   ZJ50
ZJ51:       sub  b
            scf  
            rl   d
            ret  nc
            jr   ZJ50


L861A:      db   0
L861B:      db   0
L861C:      db   0
L861D:      db   0
L861E:      db   0
L861F:      db   0
L8620:      db   0
L8621:      db   0
L8622:      db   0
L8623:      dw   0
L8625:      dw   0
L8627:      db   0
L8628:      db   0
SEDETECT:   db   0

L862B:
            push af
            exx  
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx  
            ld   a,#01
            ld   (L8628),a
            ld   a,(SEDETECT)
            and  a
            jp   L8CF8
L8643:      push af
            exx  
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx  
            xor  a
            ld   (L8628),a
            ld   a,(SEDETECT)
            and  a
            jp   L8CF8
L865A:      push af
            exx  
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx  
            ld   a,#01
            ld   (L8628),a
            ld   a,(SEDETECT)
            and  a
            jp   L8BF8
L8672:      push af
            exx  
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx  
            xor  a
            ld   (L8628),a
            ld   a,(SEDETECT)
            and  a
            jp   L8BF8
L8689:      push af
            exx  
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx  
            ld   a,#01
            ld   (L8628),a
            ld   a,(SEDETECT)
            and  a
            jp   L8AF7
L86A1:      push af
            exx  
            ld   hl,#0000
            ld   d,h
            ld   b,#FF
            exx  
            xor  a
            ld   (L8628),a
            ld   a,(SEDETECT)
            and  a
            jp   L8AF7
L86B8:      ld   c,a
            ld   a,(SEDETECT)
            and  a
            ld   a,c
            jp   L8A37
L86C4:      ld   c,a
            ld   a,(SEDETECT)
            and  a
            ld   a,c
            jp   L8A4E
ZJ17:       call LFB31
            cp   #09
            ret  c
            xor  a
            ld   (SEDETECT),a
            jp   L86E9
ZJ18:       call LFB32
            cp   #09
            ret  c
            ld   a,#01
            ld   (SEDETECT),a
L86E9:      call L86EE
            ret  


L86EE:      ld   bc,(L861A)
            ld   (L861E),bc
TEXTUR:     ld   ix,0
            ld   de,(L861C)
            ld   a,MID
            bit  1,e
            jr   nz,L8702
            add  a,c
            add  a,c
L8702:      sub  c
            ld   (L8620),a
            ld   a,MIDX
            bit  0,e
            jr   z,L870E
            add  a,b
            add  a,b
L870E:      sub  b
            ld   (L8621),a
            ld   a,c
            cp   MID
            bit  3,e
            ex   af,af'
            ld   a,b
            cp   MIDX-8
            bit  2,e
            jr   z,L872B
            jr   nc,L872C
            ex   af,af'
            jr   z,L8728
            jr   nc,L875E
            jr   L8736
L8728:      ret  nc
            jr   L875E
L872B:      ret  nc
L872C:      ex   af,af'
            jr   z,L8733
            jr   nc,L878E
            jr   L874B
L8733:      ret  nc
            jr   L878E
L8736:      ld   a,b
            add  a,d
            jr   c,L873F
            cp   MIDX-8
            jp   c,L87C8
L873F:      ld   a,d
            sub  b
            jr   c,L8745
            cp   MIDX-8
L8745:      jp   c,L8898
            jp   L87FE
L874B:      ld   a,b
            sub  MIDX-8
            ld   b,a
            ld   (L861F),a
            ld   a,d
            sub  b
            ret  c
            ret  z
            sub  #F0
            jp   nc,L87F4
            jp   L888E
L875E:      ld   a,c
            sub  MID
            ld   c,a
            ld   (L861E),a
            ld   a,d
            sub  c
            ret  c
            ld   a,d
            call L87BF
            ld   h,d
            ld   l,e
            ld   a,c
            call L87BF
            sbc  hl,de
            ld   a,MIDX-8
            sub  b
            call L87BF
            sbc  hl,de
            jp   c,L893F
            add  hl,de
            ld   a,MIDX-8
            add  a,b
            call L87BF
            sbc  hl,de
            jp   nc,L884A
            jp   L88C2
L878E:      ld   a,b
            sub  MIDX-8
            ld   b,a
            ld   a,c
            sub  MID
            ld   c,a
            ld   (L861E),bc
            ld   a,d
            call L87BF
            ld   h,d
            ld   l,e
            ld   a,c
            call L87BF
            sbc  hl,de
            ret  c
            ld   a,b
            call L87BF
            sbc  hl,de
            ret  c
            add  hl,de
            ld   a,b
            add  a,#F8
            jr   c,L87BC
            call L87BF
            sbc  hl,de
            jp   nc,L8840
L87BC:      jp   L88B8
L87BF:      push hl
            ld   h,high(LBE00)
            ld   l,a
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            pop  hl
            ret  
L87C8:      call L87D4
            call L86A1
            call L87D4
            jp   L8689
L87D4:      ld   bc,(L8620)
            ld   de,(L861C)
            ld   a,d
            neg  
            exx  
            ld   c,a
            ld   e,#00
            exx  
            ld   a,b
            sub  d
            call L89D4
            ld   a,(L8620)
            ld   c,a
            ld   a,(L8621)
            add  a,d
            jp   L89EF
L87F4:      ld   a,b
            add  a,MIDX-8
            ld   b,a
            ld   (L861F),a
            xor  a
            jr   L8802
L87FE:      ld   a,MIDX+8
            add  a,b
            inc  a
L8802:      ex   af,af'
            ld   a,MIDX-8
            add  a,b
            call L8ACD
            ld   (L8622),a
            ld   b,a
            ld   a,(L8620)
            call L86B8
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            call z,L8672
            call nz,L8643
            ld   a,(L8622)
            ld   b,a
            ld   a,(L8620)
            call L86C4
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            call z,L865A
            call nz,L862B
            ret  
L8840:      ld   a,b
            add  a,MIDX-8
            ld   b,a
            ld   (L861F),a
            xor  a
            jr   L884D
L884A:      ld   a,b
            sub  MIDX-9
L884D:      ex   af,af'
            ld   de,(L861C)
            ld   a,MIDX-8
            add  a,b
            call L8ACD
            ld   (L8622),a
            sub  c
            ld   b,a
            bit  1,e
            jr   z,L8877
            xor  a
            call L86C4
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            call z,L865A
            call nz,L862B
            ret  
L8877:      ld   a,BRX-1
            call L86B8
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            call z,L8672
            call nz,L8643
            ret  
L888E:      ld   a,b
            add  a,MIDX-8
            ld   (L861F),a
            ld   b,a
            xor  a
            jr   L889B
L8898:      ld   a,b
            sub  MIDX-9
L889B:      ex   af,af'
            bit  0,e
            jr   z,L88AC
            call L8985
            call L862B
            call L8985
            jp   L8643
L88AC:      call L89A1
            call L865A
            call L89A1
            jp   L8672
L88B8:      ld   a,b
            add  a,MIDX-8
            ld   (L861F),a
            ld   b,a
            xor  a
            jr   L88C5
L88C2:      ld   a,b
            sub  MIDX-9
L88C5:      ex   af,af'
            ld   de,(L861C)
            ld   a,c
            call L8ACD
            ld   (L8622),a
            ld   a,c
            exx  
            ld   e,a
            ld   a,(L8622)
            neg  
            ld   c,a
            exx  
            bit  0,e
            jr   z,L8910
            ld   a,(L8622)
            cpl  
            add  a,MIDX+1
            add  a,b
            ld   c,#00
            bit  1,e
            jr   nz,L88EE
            ld   c,BRX-1
L88EE:      call L89D4
            ld   a,(SEDETECT)
            and  a
;FILLED
            ld   a,e
            and  #1F
            cp   #1F
            ret  z
            ld   a,e
            or   #1F
            ld   l,a
            ld   c,#FF              ;#00
            ld   a,(L861C)
            bit  1,a
            call nz,L862B
            call z,L8643
            ret  
L8910:      ld   a,(L8622)
            add  a,MIDX
            sub  b
            cp   #08
            ret  c
            ld   c,#00
            bit  1,e
            jr   nz,L8921
            ld   c,BRX-1
L8921:      call L89EF
            ld   a,l
            and  #E0
            or   #01
            ld   e,a
            ld   a,(SEDETECT)
            and  a
;FILLED
            ld   b,0                ;#FF
            ld   a,(L861C)
            bit  1,a
            call nz,L865A
            call z,L8672
            ret  
L893F:      ld   de,(L861C)
            ld   a,c
            call L8ACD
            ld   (L8622),a
            ld   a,c
            exx  
            ld   e,a
            ld   a,(L8622)
            neg  
            ld   c,a
            exx  
            xor  a
            bit  1,e
            jr   nz,L895B
            ld   a,BRX-1
L895B:      ld   (L8620),a
            ld   c,a
            ld   a,(L8622)
            ld   l,a
            ld   a,(L8621)
            sub  l
            call L89D4
            ld   a,(L8620)
            ld   c,a
            ld   a,(L8622)
            ld   l,a
            ld   a,(L8621)
            add  a,l
            call L89EF
            ld   a,(L861C)
            bit  1,a
            call nz,L8689
            call z,L86A1
            ret  
L8985:      call L89C3
            ld   a,(L8620)
            ld   c,a
            ld   a,MIDX
            add  a,b
            sub  d
            call L89D4
            ld   a,(SEDETECT)
            and  a
;FILLED
            ld   a,e
            or   #1F
            ld   l,a
            ld   c,#FF
            ret  
L89A1:      call L89C3
            ld   a,(L8620)
            ld   c,a
            ld   a,MIDX
            add  a,d
            sub  b
            call L89EF
            ld   a,l
            and  #E0
            or   #01
            ld   e,a
            ld   b,a
            ld   a,(SEDETECT)
            and  a
            ld   a,b
;FILLED
            ld   b,0                ;#FF
            ret  

;UNFILLED
L89C0:      ld   b,#7F
            ret  
L89C3:      ld   bc,(L861E)
            ld   de,(L861C)
            ld   a,d
            neg  
            exx  
            ld   c,a
            ld   e,#00
            exx  
            ret  
L89D4:
            ld   l,c
            ld   c,a
            ld   h,4
            ADDHLHL 5
            srl  c
            srl  c
            srl  c
            ld   b,0
            add  hl,bc
            and  7
            ld   b,a
            ld   a,(SEDETECT)
            and  a
            ld   a,b
;FILLED
            ld   b,#FF
            inc  a
            srl  b
            dec  a
            jr   nz,$-3
            ld   a,b
            cpl  
            ld   b,a
            ld   e,l
            ret  
L89EF:      push af
            ld   a,b
            ld   (L8627),a
            pop  af
            ld   l,c
            ld   c,a
            ld   h,4
            ADDHLHL 5
            srl  c
            srl  c
            srl  c
            ld   b,0
            add  hl,bc
            and  7
            sub  #08
            neg  
            ld   c,a
            ld   a,(SEDETECT)
            and  a
            ld   a,c
;FILLED
            ld   c,0                ;#FF
            sli  c
            dec  a
            jr   nz,$-3
            ld   a,(L8627)
            ld   b,a
            ret  
L8A16:      ld   bc,(L861E)
            ld   a,MIDX+8
            sub  b
            exx  
            ld   c,a
            ld   a,(L8622)
            ld   e,a
            exx  
            ret  
L8A25:      ld   a,(SEDETECT)
            and  a
;FILLED
            ld   a,l
            and  #E0
            or   #01
            ld   e,a
            ld   c,#FF              ;#00
            ld   b,0                ;#FF
            ret  
;FILLED
L8A37:      ld   hl,#FFE0           ;#257C
            ld   (L8A85+1),hl
            ld   hl,#3880
            jr   L8A63
;FILLED
L8A4E:      ld   hl,#0020           ;#7C24
            ld   (L8A85+1),hl
            ld   hl,#308C
L8A63:      ld   (L8A9E+1),hl
            push de
            push af
            ld   l,a
            ld   h,4
            ADDHLHL 5
            ld   de,#001F
            add  hl,de
            push bc
            dec  b
            inc  b
            jr   z,L8A8D

L8A85:      ld   de,#20

L8A76:
            ld   c,l
            ld   a,ixl
            rept #1E
            dec  l
            ld   (hl),a
            endr
            ld   l,c
            add  hl,de
            ld   a,ixl
            xor  ixh
            ld   ixl,a
            ld   a,h
L8A9E:      cp   0
            jr   nc,L8A8D
L8A8B:      djnz L8A76
L8A8D:      pop  bc
            pop  af
            pop  de
            ret  

L8ACD:      push bc
            push de
            push hl
            push af
            ld   a,d
            call L87BF
            ld   h,d
            ld   l,e
            pop  af
            call L87BF
            sbc  hl,de
            ld   b,#80
            xor  a
            ld   (L8625),hl
L8AE3:      ld   hl,(L8625)
            add  a,b
            call L87BF
            sbc  hl,de
            jr   nc,L8AEF
            sub  b
L8AEF:      srl  b
            jr   nc,L8AE3
            pop  hl
            pop  de
            pop  bc
            ret  
;FILLED
L8AF7:      ld   a,e
            sub  l
            jr   nc,L8B0D
            ld   a,(L8628)
            and  a
            jr   nz,L8B08
            ld   a,#7F
            cp   h
            jr   c,L8B0F
            jr   L8B0D
L8B08:      ld   a,#8B
            cp   h
            jr   nc,L8B0F
L8B0D:      pop  af
            ret  
L8B0F:      ld   (L8623),sp
L8B13:
            ld   a,c
            and  (hl)
            ld   d,a
            ld   a,c
            cpl  
            and  ixl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl  
            and  ixl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jr   nc,$+11
            inc  l
            ld   ($+7),a
            ld   a,ixl
            ld   (hl),a
            ld   a,0
            call L5E36
            jr   nz,$+8
            call L8DEE
            jp   $+6
            call L8E08
            exx  
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx  
            jr   nz,L8B6D
            scf  
            rr   b
            jr   c,L8B72
L8B62:      sli  c
            jr   c,L8B7B
L8B66:      exx  
            add  hl,bc
            inc  c
L8B69:      add  hl,bc
            bit  7,h
            exx  
L8B6D:      jp   nz,L8B13
            jr   L8B9C
L8B72:      inc  e
            ld   a,l
            sub  e
            jr   z,L8B84
            ld   b,#80              ;#7F
            jr   L8B62
L8B7B:      dec  l
            ld   a,l
            sub  e
            jr   z,L8B84
            ld   c,#01              ;#FE
            jr   L8B66
L8B84:      ld   sp,(L8623)
            pop  af
            ret  
L8B8A:      inc  e
            ld   a,l
            sub  e
            jr   z,L8B84
            ld   b,#80              ;#7F
            jr   L8BA0
L8B93:      dec  l
            ld   a,l
            sub  e
            jr   z,L8B84
            ld   c,#01              ;#FE
            jr   L8BA4
L8B9C:
            scf  
            rr   b
            jr   c,L8B8A
L8BA0:      sli  c
            jr   c,L8B93
L8BA4:      exx  
            add  hl,bc
            inc  c
            jr   z,L8B84
L8BA9:      add  hl,bc
            bit  7,h
            exx  
            jr   z,L8B9C
            exx  
            add  hl,de
            inc  e
            add  hl,de
            exx  
            ld   a,c
            and  (hl)
            ld   d,a
            ld   a,c
            cpl  
            and  ixl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl  
            and  ixl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jr   nc,L8BC6
            inc  l
            ld   ($+7),a
            ld   a,ixl
            ld   (hl),a
            ld   a,0
L8BC6:      ld   l,d
            sub  #11
            cpl  
            ld   (L8BD3),a
            push de
            ld   e,ixl
            ld   d,e
            push de
            pop  af
            pop  de
            ld   sp,hl
            jr   L8BE4
L8BD3:      equ  $-#0001
            rept 16
            push af
            endr
L8BE4:      ld   a,(L8628)
            and  a
            ld   sp,(L8623)
            jr   nz,L8BF3
            call L8DEE
            jr   L8B9C
L8BF3:      call L8E08
            jr   L8B9C
;FILLED
L8BF8:      ld   a,l
            and  #1F
            cp   #20
            jr   nc,L8C11
            ld   a,(L8628)
            and  a
            jr   nz,L8C0C
            ld   a,#7F
            cp   h
            jr   c,L8C13
            jr   L8C11
L8C0C:      ld   a,#8B
            cp   h
            jr   nc,L8C13
L8C11:      pop  af
            ret  
L8C13:      ld   (L8623),sp
L8C17:
            ld   a,c
            and  (hl)
            ld   d,a
            ld   a,c
            cpl  
            and  ixl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,d
            sub  e
            srl  a
            jr   nc,L8C24
            ld   ($+7),a
            ld   a,ixl
            ld   (hl),a
            ld   a,0
L8C24:      call L5E36
            jr   nz,L8C51
            call L8DEE
            jr   L8C54
L8C51:      call L8E08
L8C54:      exx  
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx  
            jr   nz,L8C6D
            sli  c
            jr   c,L8C72
L8C61:      exx  
            add  hl,bc
            inc  c
            ex   af,af'
            cp   c
            jr   z,L8C7C
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx  
L8C6D:      jp   nz,L8C17
            jr   L8CA0
L8C72:      dec  l
            ld   a,l
            sub  e
            inc  a
            jr   z,L8C90
            ld   c,#01              ;#FE
            jr   L8C61
L8C7C:      ex   af,af'
            exx  
            ld   a,l
            sub  e
            exx  
            jr   z,L8C90
            jp   L8B69
L8C86:      ex   af,af'
            exx  
            ld   a,l
            sub  e
            exx  
            jr   z,L8C90
            jp   L8BA9
L8C90:      ld   sp,(L8623)
            pop  af
            ret  
L8C96:      dec  l
            ld   a,l
            sub  e
            inc  a
            jr   z,L8C90
            ld   c,#01              ;#FE
            jr   L8CA4
L8CA0:      sli  c
            jr   c,L8C96
L8CA4:      exx  
            add  hl,bc
            inc  c
            jr   z,L8C90
            ex   af,af'
            cp   c
            jr   z,L8C86
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx  
            jr   z,L8CA0
            exx  
            add  hl,de
            inc  e
            add  hl,de
            exx  
            ld   a,c
            and  (hl)
            ld   d,a
            ld   a,c
            cpl  
            and  ixl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,d
            sub  e
            srl  a
            jr   nc,L8CC6
            ld   ($+7),a
            ld   a,ixl
            ld   (hl),a
            ld   a,0
L8CC6:      ld   l,d
            sub  #11
            cpl  
            ld   (L8CD3),a
            push de
            ld   e,ixl
            ld   d,e
            push de
            pop  af
            pop  de
            ld   sp,hl
L8CD2:      jr   L8CD2
L8CD3:      equ  $-#0001
            rept 16
            push af
            endr
            ld   a,(L8628)
            and  a
            ld   sp,(L8623)
            jr   nz,L8CF3
            call L8DEE
            jr   L8CA0
L8CF3:      call L8E08
            jr   L8CA0
;FILLED
L8CF8:      ld   a,e
            and  #1F
            cp   #20
            jr   nc,L8D11
            ld   a,(L8628)
            and  a
            jr   nz,L8D0C
            ld   a,#7F
            cp   h
            jr   c,L8D13
            jr   L8D11
L8D0C:      ld   a,#8B
            cp   h
            jr   nc,L8D13
L8D11:      pop  af
            ret  
L8D13:      ld   (L8623),sp
L8D17:      ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl  
            and  ixl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jr   nc,L8D26
            inc  l
            ld   ($+7),a
            ld   a,ixl
            ld   (hl),a
            ld   a,0
L8D26:      call L5E36
            jr   L8D4C

L8D4C:      jr   nz,L8D53
            call L8DEE
            jr   L8D56
L8D53:      call L8E08
L8D56:      exx  
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx  
            jr   nz,L8D6F
            scf  
            rr   b
            jr   c,L8D74
L8D63:      exx  
            add  hl,bc
            inc  c
            ex   af,af'
            cp   c
            jr   z,L8D7D
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx  
L8D6F:      jp   nz,L8D17
            jr   L8D94
L8D74:      inc  e
            ld   a,l
            sub  e
            jr   z,L8D85
            ld   b,#80              ;#7F
            jr   L8D63
L8D7D:      ex   af,af'
            jp   L8B69
L8D81:      ex   af,af'
            jp   L8BA9
L8D85:      ld   sp,(L8623)
            pop  af
            ret  
L8D8B:      inc  e
            ld   a,l
            sub  e
            jr   z,L8D85
            ld   b,#80              ;#7F
            jr   L8D98
L8D94:
            scf  
            rr   b
            jr   c,L8D8B
L8D98:      exx  
            add  hl,bc
            inc  c
            jr   z,L8D85
            ex   af,af'
            cp   c
            jr   z,L8D81
            ex   af,af'
            add  hl,bc
            bit  7,h
            exx  
            jr   z,L8D94
            exx  
            add  hl,de
            inc  e
            add  hl,de
            exx  
            ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl  
            and  ixl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jr   nc,L8DBC
            inc  l
            ld   ($+7),a
            ld   a,ixl
            ld   (hl),a
            ld   a,0
L8DBC:      ld   l,d
            sub  #11
            cpl  
            ld   (L8DC9),a
            push de
            ld   e,ixl
            ld   d,e
            push de
            pop  af
            pop  de
            ld   sp,hl
L8DC8:      jr   L8DC8
L8DC9:      equ  $-#0001
            rept 16
            push af
            endr
            ld   a,(L8628)
            and  a
            ld   sp,(L8623)
            jr   nz,L8DE9
            call L8DEE
            jr   L8D94
L8DE9:      call L8E08
            jr   L8D94
L8DEE:
            ld   a,ixl
            xor  ixh
            ld   ixl,a
            ld   a,e
            sub  #20
            ld   e,a
            ld   a,l
            sub  #20
            ld   l,a
            ret  nc
            dec  h
            ld   a,#7F
            cp   h
            ret  nz
            pop  af
            ld   sp,(L8623)
            pop  af
            ret  
L8E08:
            ld   a,ixl
            xor  ixh
            ld   ixl,a
            ld   a,e
            add  a,#20
            ld   e,a
            ld   a,l
            add  a,#20
            ld   l,a
            ret  nc
            inc  h
            ld   a,#8C
            cp   h
            ret  nz
            pop  af
            ld   sp,(L8623)
            pop  af
            ret  

            db   #00,#00
TXTR:       db   #00,#00



ZJ16:       call ZJ19
            and  a
            ret  z
            push ix
            ld   ix,SUNZ
LD7CE:      push iy
            ld   iy,SUNX-3
            call LFBE0
            call nz,LFBE0
            call nz,LFBE0
            pop  iy
            pop  ix
            ret  
LED57:
            db   0,0
            db   #81,#41,#42,#22,#23,#13,#14
LFAF7:
            db   0,0
            db   #81,#C1,#C2,#E2,#E3,#F3,#F4

LA8FA:
            ds   #20

LFB03:      ld   e,a
            ld   d,#00
            ld   hl,LED57
            ex   af,af'
            and  a
            jr   z,$+5
            ld   hl,LFAF7
            add  hl,de
            ld   a,(hl)
            and  #07
            ld   b,a
            ld   a,(hl)
            and  #F8
            ld   hl,LA8FA
            ld   (hl),a
            inc  hl
            sra  a
            djnz $-4
            ld   b,e
            ld   (hl),a
            inc  hl
            djnz $-2
            ld   hl,LFAF7
            add  hl,de
            ld   a,(hl)
            and  #F8
            ld   (LA8FA),a
            ret  
LFB31:      ld   a,#AF
LFB32:      equ  $-1
            ex   af,af'
            ld   a,(ZJ52)
            cp   #04
            ld   a,(L861D)
            ret  nc
            cp   #09
            ret  nc
            cp   #02
            ret  c
            call LFB03
            ld   hl,(L861A)
            ld   a,(L861C)
            ld   b,a
            ld   a,#7F
            cp   h
            jr   c,LFB6A
            add  a,h
            rrc  b
            jr   c,$+4
            sub  h
            sub  h
            ld   c,a
            cp   #08
            jr   nc,$+3
            inc  d
            cp   #F8
            jr   c,$+4
            inc  d
            inc  d
            ld   a,#48
            cp   l
            jr   nc,$+4
LFB6A:      xor  a
            ret  
            ld   a,MID
            add  a,l
            rrc  b
            jr   nc,$+4
            sub  l
            sub  l
            add  a,e
            ld   l,a
            ld   a,c
            ld   h,4
            ADDHLHL 5
            srl  c
            srl  c
            srl  c
            ld   b,0
            add  hl,bc
            and  7
            ld   c,a
            push ix
            ld   ix,LA8FA
            ld   iy,(TEXTUR+2)
            xor  a
LFB83:      push af
            ld   a,iyl
            xor  iyh
            ld   iyl,a
            ld   a,l
            sub  #20
            ld   l,a
            jr   nc,$+3
            dec  h
            ld   a,h
            cp   #60
            jr   c,LFB98
            cp   #8C
            jr   nc,LFBC9
            cp   #80
            jr   c,LFBC9
LFB98:      push hl
            ld   a,(ix+#00)
            ld   b,#08
            rlca 
            rr   h
            djnz $-3
            add  a,a
            ld   l,a
            ld   a,#08
            sub  c
            ld   b,a
            xor  a
            add  hl,hl
            rla  
            djnz $-2
            ld   b,d
            EXD
            ex   (sp),hl
            rrc  b
            jr   c,LFBBA
            dec  hl
            ld   ($+7),a
            cpl  
            and  (hl)
            ld   (hl),a
            ld   a,0
            and  iyl
            or   (hl)
            ld   (hl),a
            inc  hl
LFBBA:      ld   a,d
            cpl  
            and  (hl)
            ld   (hl),a
            ld   a,d
            and  iyl
            or   (hl)
            ld   (hl),a
            rrc  b
            jr   c,LFBC8
            inc  hl
            ld   a,e
            cpl  
            and  (hl)
            ld   (hl),a
            ld   a,e
            and  iyl
            or   (hl)
            ld   (hl),a
            dec  hl
LFBC8:      pop  de
LFBC9:      pop  af
            bit  7,d
            jr   nz,LFBD8
            inc  a
            inc  ix
            cp   e
            jr   nz,LFB83
            set  7,d
            dec  ix
LFBD8:      dec  ix
            dec  a
            jr   nz,LFB83
            pop  ix
            ret  
LFBE0:      ld   de,#0003
            add  iy,de
            ld   a,(iy+#02)
            and  #7F
            ld   d,a
            ld   a,(ix+#02)
            and  #7F
            cp   #0A
            jr   c,LFC00
            cp   d
            jr   c,LFC03
            ret  nz
            ld   a,(ix+#01)
            cp   (iy+#01)
            jr   c,LFC03
LFC00:      or   #01
            ret  
LFC03:      xor  a
            ret  


