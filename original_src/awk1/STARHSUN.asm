■OHIDE
■GEND
■GALD
■STARS
■MOVESTARS
■CIRCLE
















ВЫВОД ХАЙД СКРИНА

И

РАБОТА СО ЗВЕЗДАМИ

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
LDC45       ld   (LDE4F+1),sp
LDC4B       ld   (LDE49+1),a

            HIDEM   #10,#20
            HIDEM   #30,#40
            HIDEM   #50,#60
            HIDEM   #70,#80
            HIDEM   #90,#A0
            HIDEM   #B0,#C0
            HIDEM   #D0,#E0

            ld   sp,hl
            ld   l,#F0
            pop  af,bc,de,ix
            exa
            exx
            pop  af,bc,de,iy
            ld   sp,hl
            inc  sp
            set  4,l
            push iy,de,bc,af
            exa
            exx
            push ix,de,bc,af
            ld   sp,hl
            ld   l,#00
            pop  af,bc,de,ix
            exa
            exx
            pop  af,bc,de,iy
            ld   sp,hl
            inc  sp
            push iy,de,bc,af
            ld   de,#F910
            add  hl,de
            exa
            exx
            push ix,de,bc,af
            inc  h
LDE49       ld   a,#00
            dec  a
            jpnz LDC4B
LDE4F       ld   sp,#0000
            ret




■--------------------------------------

РАБОТА СО ЗВЕЗДАМИ


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
ГЕНЕРАЦИЯ ВСЕХ ЗВЕЗД
            ld   hl,DOTB
            call GEND
            cp   XMIN
            jrnc $+4
            add  a,2*XMIN
            cp   XMAX
            jrc  $+4
            sub  2*XMIN
            exa
            call GEND
            and  127
            cp   YMIN
            jrnc $+4
            add  a,2*YMIN
            cp   YMAX
            jrc  $+4
            sub  #40

            ld   (hl),a
            inc  l
            exa
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jpc  GALD+3
            ret

■DOTS
STARS:
            ld   bc,DOTB
DOT1
            ld   h,TBXY.h
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
            jpc  DOT1
            ret
MOVESTARS:
            ld   hl,DOTB
            ld   a,(EYE_A)
            and  a
            jpz  NSKY
            jpm  PLX
            rla
            rla
■              rla
            inc  a
            inc  a
            ld   c,a
DT11
            ld   a,(hl)
            add  a,c
            jrc  $+6
            cp   YMAX
            jrc  DT1
            ld   a,r
            and  #7F
            cp   c
            jrc  $+5
            sub  c
            jr   $-4
            cp   YMAX-YMIN
            jrc  $+4
            ld   a,YMAX-YMIN
            add  a,YMIN-1
            ld   (hl),a
            call GEND
            inc  l
            cp   XMIN
            jrnc $+4
            add  a,XMIN
            cp   XMAX
            jrc  $+4
            sub  XMIN
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT11
            jp   NSKY
DT1
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT11
            jp   NSKY
PLX
            neg
            rla
            rla
■              rla
            ld   c,a
DT22
            ld   a,(hl)
            sub  c
            jrc  $+6
            cp   YMIN
            jrnc DT2
            ld   a,r
            and  #7F
            cp   c
            jrc  $+5
            sub  c
            jr   $-4
            cp   YMAX-YMIN
            jrc  $+4
            ld   a,YMAX-YMIN
            ld   b,a
            ld   a,YMAX;+1
            sub  b
            ld   (hl),a
            call GEND
            inc  l
            cp   XMIN
            jrnc $+4
            add  a,XMIN
            cp   XMAX
            jrc  $+4
            sub  XMIN
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT22
            jp   NSKY
DT2
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT22
NSKY
            ld   hl,DOTB+1
            ld   a,(EYE_B)
            and  a
            jpz  NSKZ
            jpp  PLY
            neg
            rla
            rla
■              rla
            ld   c,a
DT33
            ld   a,(hl)
            add  a,c
            jrc  $+6
            cp   XMAX
            jrc  DT3
            call GEND
            cp   c
            jrc  $+5
            sub  c
            jr   $-4
            cp   XMAX-XMIN
            jrc  $+4
            ld   a,XMAX-XMIN
            add  a,XMIN-1
            ld   (hl),a
            ld   a,r
            and  #7F
            dec  l
            cp   YMIN
            jrnc $+4
            add  a,YMIN
            cp   YMAX
            jrc  $+4
            sub  #40
            ld   (hl),a
            inc  l
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT33
            jp   NSKZ
DT3
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT33
            jp   NSKZ
PLY
            rla
            rla
■             rla
            inc  a
            inc  a

            ld   c,a
DT44
            ld   a,(hl)
            sub  c
            jrc  $+6
            cp   XMIN
            jrnc DT4
            call GEND
            cp   c
            jrc  $+5
            sub  c
            jr   $-4
            cp   XMAX-XMIN
            jrc  $+4
            ld   a,XMAX-XMIN
            sub  XMAX+1
            neg
            ld   (hl),a
            ld   a,r
            and  #7F
            dec  l
            cp   YMIN
            jrnc $+4
            add  a,YMIN
            cp   YMAX
            jrc  $+4
            sub  #40
            ld   (hl),a
            inc  l
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT44
            jp   NSKZ
DT4
            ld   (hl),a
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  DT44
NSKZ
            ld   a,(EYE_G)
            neg
            and  a
            retz
            ld   l,a
            jpp  $+5
            neg
            rla
            rla
■              rla
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
            jpp  $+6
            ld   hl,NZZK2
            ld   (CLU1+1),hl
            ld   (CLU2+1),hl
            ld   hl,DOTB
NAMO
            ld   a,(hl)
            sub  YMID
            exx
            ld   c,a
CS          ld   e,0
            xor  e
            exa
            ld   a,e
            and  a
            jpp  $+6
            neg
            ld   e,a
            ld   a,c
            and  a
            jpp  $+6
            neg
            ld   c,a
            xor  a
            rept 7:rr e:jrnc $+3:add a,c:rra:endr
            inc  a
            ld   e,a
            exa
            ld   d,0
            jpp  $+8
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
SS          ld   e,0
            xor  e
            exa
            ld   a,e
            and  a
            jpp  $+6
            neg
            ld   e,a
            ld   a,c
            and  a
            jpp  $+6
            neg
            ld   c,a
            xor  a
            rept 7:rr e:jrnc $+3:add a,c:rra:endr
            inc  a
            ld   e,a
            exa
            ld   d,0
            jpp  $+8
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
            jrnz FNZ
            ld   a,l
            cp   YMIN
            jrc  FNZ
            cp   YMAX
            jrc  FNNZ
FNZ
            exx
CLU1        call NZZK
            ld   (hl),d
            dec  l
            ld   (hl),e
            inc  l
            inc  l
            ld   a,l
            cp   AMO
            jpc  NAMO
            ret
FNNZ
            ld   (KOX+1),a
            exx
            ld   a,(hl)
            sub  XMID
            exx
            ld   c,a
CS2         ld   e,0
            xor  e
            exa
            ld   a,e
            and  a
            jpp  $+6
            neg
            ld   e,a
            ld   a,c
            and  a
            jpp  $+6
            neg
            ld   c,a
            xor  a
            rept 7:rr e:jrnc $+3:add a,c:rra:endr
            inc  a
            ld   e,a
            exa
            ld   d,0
            jpp  $+8
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
SS2         ld   e,0
            xor  e
            exa
            ld   a,e
            and  a
            jpp  $+6
            neg
            ld   e,a
            ld   a,c
            and  a
            jpp  $+6
            neg
            ld   c,a
            xor  a
            rept 7:rr e:jrnc $+3:add a,c:rra:endr
            inc  a
            ld   e,a
            exa
            ld   d,0
            jpp  $+8
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
            jrnz FNZ2
            ld   a,l
            cp   XMIN
            jrc  FNZ2
            cp   XMAX
            jrc  FNNZ2
FNZ2
            exx
CLU2        call NZZK
            ld   (hl),e
            inc  l
            ld   (hl),d
            inc  l
            ld   a,l
            cp   AMO
            jpc  NAMO
            ret
FNNZ2
            exx
KOX         ld   (hl),0
            inc  l
            ld   (hl),a
            inc  l
            ld   a,l
            cp   AMO
            jpc  NAMO
            ret

NZZK
            ld   a,0
            xor  1
            ld   (NZZK+1),a
FORC        ld   c,0
            jrnz NZZKL
            ld   a,r
            cp   c
            jrc  $+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jrc  $+4
            ld   a,YMAX-YMIN
            add  a,YMIN-1
            ld   e,a
            ld   a,r
            add  a,#80
            cp   XMAX
            jrc  $+4
            sub  XMIN
            ld   d,a
            ret
NZZKL
            ld   a,r
            cp   c
            jrc  $+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jrc  $+4
            ld   a,YMAX-YMIN
            sub  YMAX;+1
            neg
            ld   e,a
            ld   a,r
            cp   XMIN
            jrnc $+4
            add  a,XMIN
            ld   d,a
            ret
NZZK2
            ld   a,0
            xor  1
            ld   (NZZK2+1),a
FORC2       ld   c,0
            jrnz NZZKL2
            ld   a,r
            cp   c
            jrc  $+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jrc  $+4
            ld   a,YMAX-YMIN
            add  a,YMIN-1
            ld   e,a
            ld   a,r
            cp   XMIN
            jrnc $+4
            add  a,XMIN
            ld   d,a
            ret
NZZKL2
            ld   a,r
            cp   c
            jrc  $+6
            sub  c
            jp   $-4
            cp   YMAX-YMIN
            jrc  $+4
            ld   a,YMAX-YMIN
            sub  YMAX;+1
            neg
            ld   e,a
            ld   a,r
            add  a,#80
            cp   XMAX
            jrc  $+4
            sub  XMIN
            ld   d,a
            ret



L5E36       ld   l,d
            add  a,a
            jrz  $J9
            push hl
            add  a,a
            sub  #3E
            neg
            ld   ($J2+1),a
            ld   a,xl
$J2         jr   $
            rept #1F:dec l:ld (hl),a:endr
            pop  hl
$J9         ld   a,(L8628)
            and  a
            ret

$J52        db   0

CIRCLE:
            ld   (TEXTUR+2),de
            xor  a
            ld   ($J52 ),a
            call $J16
            and  a
            retz
■CIRCLE
            call $J17
            ret

$J19        exx
            ld   bc,#0003
            exx
            ld   a,($J52 )
            and  a
            jpnz $J3
            ld   a,(SUNZ+2)
            bit  7,a
            jpnz $J4
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
            jrnz $J5
            exx
            set  0,b
            exx
$J5         and  #7F
            ld   h,a
            call $J20
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
            jrnz $J6
            exx
            set  1,b
            exx
$J6         and  #7F
            ld   h,a
            call $J20
            ld   a,d
            ld   (L861A),a
            exx
            ld   a,b
            exx
            ld   (L861C),a
            ld   a,(SUNZ+2)
            and  a
            jrnz $J7
            ld   hl,#A000
            ld   de,(SUNZ)
            sbc  hl,de
            jrc  $J7
            ld   a,#FF
            jr   $J8
$J7         ld   hl,#A000
            ld   de,(SUNZ+1)
            SUB_DE
            jpc  $J4
            ld   a,(SUNZ+2)
            and  a
            jrz  $J10
            ld   b,a
            ld   a,(SUNZ+1)
            ld   c,a
            xor  a
            ld   e,#A0
$J12        sla  c
            rl   b
            jrc  $J11
            sla  e
            rla
            jr   $J12
$J11        scf
            rr   b
            call $J21
            ld   a,d
            jr   $J8
$J10        ld   a,(SUNZ+1)
            ld   b,a
            ld   a,#A0
            call $J22
            ld   a,d
$J8         jp   $J23
$J3         dec  a
            jrnz $J15
            ld   a,(SUNZ+2)
            bit  7,a
            jpz  $J4
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
            jrz  $J13
            and  #7F
            ld   h,a
            exx
            set  0,b
            exx
$J13        jp   $J5
$J15        dec  a
            jpnz $J14
            ld   a,(SUNX+2)
            bit  7,a
            jpz  $J4
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
            jrnz $J24
            exx
            set  0,b
            exx
$J24        and  #7F
            ld   h,a
            call $J20
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
            jrnz $J25
            exx
            set  1,b
            exx
$J25        and  #7F
            ld   h,a
            call $J20
            ld   a,d
            ld   (L861A),a
            exx
            ld   a,b
            exx
            ld   (L861C),a
            ld   a,(SUNX+2)
            and  a
            jrnz $J26
            ld   hl,#A000
            ld   de,(SUNX)
            sbc  hl,de
            jrc  $J26
            ld   a,#FF
            jr   $J27
$J26        ld   hl,#A000
            ld   de,(SUNX+1)
            SUB_DE
            jpc  $J4
            ld   a,(SUNX+2)
            and  a
            jrz  $J28
            ld   b,a
            ld   a,(SUNX+1)
            ld   c,a
            xor  a
            ld   e,#A0
$J29        sla  c
            rl   b
            jrc  $J30
            sla  e
            rla
            jp   $J29
$J30        scf
            rr   b
            call $J21
            ld   a,d
            jr   $J27
$J28        ld   a,(SUNX+1)
            ld   b,a
            ld   a,#A0
            call $J22
            ld   a,d
$J27        jp   $J23
$J14        ld   a,(SUNX+2)
            bit  7,a
            jpnz $J4
            ld   hl,(SUNX+1)
            EXD
            ld   hl,(SUNZ+1)
            ld   a,(SUNX)
            ld   b,a
            ld   a,(SUNZ)
            ld   c,a
            ld   a,h
            bit  7,a
            jrz  $J31
            exx
            set  0,b
            exx
$J31        jp   $J24
$J23        ld   (L861D),a
            ld   a,#01
            ret
$J32        ld   h,l
            ld   l,c
            ld   d,e
            ld   e,b
            jp   $J33
$J20        push hl
            exx
            dec  c
            exx
            SUB_DE
            jpc  $J34
            jpz  $J35
$J36        pop  hl
            ld   a,h
            and  a
            jrz  $J32
            ld   a,#08
$J37        sla  c
            adc  hl,hl
            jpc  $J38
            sla  b
            rl   e
            rl   d
            dec  a
            jrnz $J37
$J33        ld   a,#08
$J39        add  hl,hl
            jpc  $J38
            EXD
            add  hl,hl
            EXD
            dec  a
            jrnz $J39
            ld   a,#08
$J40        sla  h
            jpc  $J38
            sla  d
            dec  a
            jrnz $J40
            ret
$J35        push bc
            ld   a,c
            sub  b
            pop  bc
            jrc  $J34
            jrz  $J34
            jp   $J36
$J41        set  2,b
            jp   $J42
$J34        exx
            dec  c
            jrnz $J41
            set  3,b
$J42        inc  c
            exx
            pop  hl
            ld   a,#17
$J43        sla  c
            adc  hl,hl
            push af
            sla  b
            rl   e
            rl   d
            jrc  $J44
            pop  af
            dec  a
            jrnz $J43
            ret
$J38        sla  b
            rl   e
            rl   d
            push af
            scf
            rr   h
            rr   l
            pop  af
            jrc  $J45
            push hl
            SUB_DE
            jrnc $J46
            pop  hl
$J45        scf
            rr   d
            SUB_DE
            jr   $J47
$J46        pop  hl,af
$J4         xor  a
            ret
$J48        scf
            rr   h
            jr   $J49
$J44        pop  af
            jrc  $J48
            rr   h
$J49        scf
            rr   d
$J47        ld   a,h
            ld   b,d
$J22        ld   e,#00
$J21        ld   d,#FE
$J50        sla  e
            rla
            jrc  $J51
            cp   b
            jrnc $J51
            sla  d
            retnc
            jr   $J50
$J51        sub  b
            scf
            rl   d
            retnc
            jr   $J50


L861A       db   0
L861B       db   0
L861C       db   0
L861D       db   0
L861E       db   0
L861F       db   0
L8620       db   0
L8621       db   0
L8622       db   0
L8623       dw   0
L8625       dw   0
L8627       db   0
L8628       db   0
SEDETECT    db   0

L862B
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
L8643       push af
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
L865A       push af
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
L8672       push af
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
L8689       push af
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
L86A1       push af
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
L86B8       ld   c,a
            ld   a,(SEDETECT)
            and  a
            ld   a,c
            jp   L8A37
L86C4       ld   c,a
            ld   a,(SEDETECT)
            and  a
            ld   a,c
            jp   L8A4E
$J17        call LFB31
            cp   #09
            retc
            xor  a
            ld   (SEDETECT),a
            jp   L86E9
$J18        call LFB32
            cp   #09
            retc
            ld   a,#01
            ld   (SEDETECT),a
L86E9       call L86EE
            ret


L86EE       ld   bc,(L861A)
            ld   (L861E),bc
TEXTUR      ld   ix,0
            ld   de,(L861C)
            ld   a,MID
            bit  1,e
            jrnz L8702
            add  a,c
            add  a,c
L8702       sub  c
            ld   (L8620),a
            ld   a,MIDX
            bit  0,e
            jrz  L870E
            add  a,b
            add  a,b
L870E       sub  b
            ld   (L8621),a
            ld   a,c
            cp   MID
            bit  3,e
            exa
            ld   a,b
            cp   MIDX-8
            bit  2,e
            jrz  L872B
            jrnc L872C
            exa
            jrz  L8728
            jrnc L875E
            jr   L8736
L8728       retnc
            jr   L875E
L872B       retnc
L872C       exa
            jrz  L8733
            jrnc L878E
            jr   L874B
L8733       retnc
            jr   L878E
L8736       ld   a,b
            add  a,d
            jrc  L873F
            cp   MIDX-8
            jpc  L87C8
L873F       ld   a,d
            sub  b
            jrc  L8745
            cp   MIDX-8
L8745       jpc  L8898
            jp   L87FE
L874B       ld   a,b
            sub  MIDX-8
            ld   b,a
            ld   (L861F),a
            ld   a,d
            sub  b
            retc
            retz
            sub  #F0
            jpnc L87F4
            jp   L888E
L875E       ld   a,c
            sub  MID
            ld   c,a
            ld   (L861E),a
            ld   a,d
            sub  c
            retc
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
            jpc  L893F
            add  hl,de
            ld   a,MIDX-8
            add  a,b
            call L87BF
            sbc  hl,de
            jpnc L884A
            jp   L88C2
L878E       ld   a,b
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
            retc
            ld   a,b
            call L87BF
            sbc  hl,de
            retc
            add  hl,de
            ld   a,b
            add  a,#F8
            jrc  L87BC
            call L87BF
            sbc  hl,de
            jpnc L8840
L87BC       jp   L88B8
L87BF       push hl
            ld   h,LBE00.h
            ld   l,a
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            pop  hl
            ret
L87C8       call L87D4
            call L86A1
            call L87D4
            jp   L8689
L87D4       ld   bc,(L8620)
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
L87F4       ld   a,b
            add  a,MIDX-8
            ld   b,a
            ld   (L861F),a
            xor  a
            jr   L8802
L87FE       ld   a,MIDX+8
            add  a,b
            inc  a
L8802       exa
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
            callz L8672
            callnz L8643
            ld   a,(L8622)
            ld   b,a
            ld   a,(L8620)
            call L86C4
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            callz L865A
            callnz L862B
            ret
L8840       ld   a,b
            add  a,MIDX-8
            ld   b,a
            ld   (L861F),a
            xor  a
            jr   L884D
L884A       ld   a,b
            sub  MIDX-9
L884D       exa
            ld   de,(L861C)
            ld   a,MIDX-8
            add  a,b
            call L8ACD
            ld   (L8622),a
            sub  c
            ld   b,a
            bit  1,e
            jrz  L8877
            xor  a
            call L86C4
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            callz L865A
            callnz L862B
            ret
L8877       ld   a,BRX-1
            call L86B8
            call L8A16
            call L8A25
            ld   a,(L861C)
            bit  0,a
            callz L8672
            callnz L8643
            ret
L888E       ld   a,b
            add  a,MIDX-8
            ld   (L861F),a
            ld   b,a
            xor  a
            jr   L889B
L8898       ld   a,b
            sub  MIDX-9
L889B       exa
            bit  0,e
            jrz  L88AC
            call L8985
            call L862B
            call L8985
            jp   L8643
L88AC       call L89A1
            call L865A
            call L89A1
            jp   L8672
L88B8       ld   a,b
            add  a,MIDX-8
            ld   (L861F),a
            ld   b,a
            xor  a
            jr   L88C5
L88C2       ld   a,b
            sub  MIDX-9
L88C5       exa
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
            jrz  L8910
            ld   a,(L8622)
            cpl
            add  a,MIDX+1
            add  a,b
            ld   c,#00
            bit  1,e
            jrnz L88EE
            ld   c,BRX-1
L88EE       call L89D4
            ld   a,(SEDETECT)
            and  a
■FILLED
            ld   a,e
            and  #1F
            cp   #1F
            retz
            ld   a,e
            or   #1F
            ld   l,a
            ld   c,#FF;#00
            ld   a,(L861C)
            bit  1,a
            callnz L862B
            callz L8643
            ret
L8910       ld   a,(L8622)
            add  a,MIDX
            sub  b
            cp   #08
            retc
            ld   c,#00
            bit  1,e
            jrnz L8921
            ld   c,BRX-1
L8921       call L89EF
            ld   a,l
            and  #E0
            or   #01
            ld   e,a
            ld   a,(SEDETECT)
            and  a
■FILLED
            ld   b,0;#FF
            ld   a,(L861C)
            bit  1,a
            callnz L865A
            callz L8672
            ret
L893F       ld   de,(L861C)
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
            jrnz L895B
            ld   a,BRX-1
L895B       ld   (L8620),a
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
            callnz L8689
            callz L86A1
            ret
L8985       call L89C3
            ld   a,(L8620)
            ld   c,a
            ld   a,MIDX
            add  a,b
            sub  d
            call L89D4
            ld   a,(SEDETECT)
            and  a
■FILLED
            ld   a,e
            or   #1F
            ld   l,a
            ld   c,#FF
            ret
L89A1       call L89C3
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
■FILLED
            ld   b,0;#FF
            ret

■UNFILLED
L89C0       ld   b,#7F
            ret
L89C3       ld   bc,(L861E)
            ld   de,(L861C)
            ld   a,d
            neg
            exx
            ld   c,a
            ld   e,#00
            exx
            ret
L89D4
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
■FILLED
            ld   b,#FF
            inc  a
            srl  b
            dec  a
            jrnz $-3
            ld   a,b
            cpl
            ld   b,a
            ld   e,l
            ret
L89EF       push af
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
■FILLED
            ld   c,0;#FF
            sli  c
            dec  a
            jrnz $-3
            ld   a,(L8627)
            ld   b,a
            ret
L8A16       ld   bc,(L861E)
            ld   a,MIDX+8
            sub  b
            exx
            ld   c,a
            ld   a,(L8622)
            ld   e,a
            exx
            ret
L8A25       ld   a,(SEDETECT)
            and  a
■FILLED
            ld   a,l
            and  #E0
            or   #01
            ld   e,a
            ld   c,#FF;#00
            ld   b,0;#FF
            ret
■FILLED
L8A37       ld   hl,#FFE0;#257C
            ld   (L8A85+1),hl
            ld   hl,#3880
            jr   L8A63
■FILLED
L8A4E       ld   hl,#0020;#7C24
            ld   (L8A85+1),hl
            ld   hl,#308C
L8A63       ld   (L8A9E+1),hl
            push de,af
            ld   l,a
            ld   h,4
            ADDHLHL 5
            ld   de,#001F
            add  hl,de
            push bc
            dec  b
            inc  b
            jrz  L8A8D

L8A85       ld   de,#20

L8A76
            ld   c,l
            ld   a,xl
            rept #1E:dec l:ld (hl),a:endr
            ld   l,c
            add  hl,de
            ld   a,xl
            xor  xh
            ld   xl,a
            ld   a,h
L8A9E       cp   0
            jrnc L8A8D
L8A8B       djnz L8A76
L8A8D       pop  bc,af,de
            ret

L8ACD       push bc,de,hl,af
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
L8AE3       ld   hl,(L8625)
            add  a,b
            call L87BF
            sbc  hl,de
            jrnc L8AEF
            sub  b
L8AEF       srl  b
            jrnc L8AE3
            pop  hl,de,bc
            ret
■FILLED
L8AF7       ld   a,e
            sub  l
            jrnc L8B0D
            ld   a,(L8628)
            and  a
            jrnz L8B08
            ld   a,#7F
            cp   h
            jrc  L8B0F
            jr   L8B0D
L8B08       ld   a,#8B
            cp   h
            jrnc L8B0F
L8B0D       pop  af
            ret
L8B0F       ld   (L8623),sp
L8B13
            ld   a,c
            and  (hl)
            ld   d,a
            ld   a,c
            cpl
            and  xl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl
            and  xl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jrnc $+11
            inc  l
            ld   ($+7),a
            ld   a,xl
            ld   (hl),a
            ld   a,0
            call L5E36
            jrnz $+8
            call L8DEE
            jp   $+6
            call L8E08
            exx
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx
            jrnz L8B6D
            scf
            rr   b
            jrc  L8B72
L8B62       sli  c
            jrc  L8B7B
L8B66       exx
            add  hl,bc
            inc  c
L8B69       add  hl,bc
            bit  7,h
            exx
L8B6D       jpnz L8B13
            jr   L8B9C
L8B72       inc  e
            ld   a,l
            sub  e
            jrz  L8B84
            ld   b,#80;#7F
            jr   L8B62
L8B7B       dec  l
            ld   a,l
            sub  e
            jrz  L8B84
            ld   c,#01;#FE
            jr   L8B66
L8B84       ld   sp,(L8623)
            pop  af
            ret
L8B8A       inc  e
            ld   a,l
            sub  e
            jrz  L8B84
            ld   b,#80;#7F
            jr   L8BA0
L8B93       dec  l
            ld   a,l
            sub  e
            jrz  L8B84
            ld   c,#01;#FE
            jr   L8BA4
L8B9C
            scf
            rr   b
            jrc  L8B8A
L8BA0       sli  c
            jrc  L8B93
L8BA4       exx
            add  hl,bc
            inc  c
            jrz  L8B84
L8BA9       add  hl,bc
            bit  7,h
            exx
            jrz  L8B9C
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
            and  xl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl
            and  xl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jrnc L8BC6
            inc  l
            ld   ($+7),a
            ld   a,xl
            ld   (hl),a
            ld   a,0
L8BC6       ld   l,d
            sub  #11
            cpl
            ld   (L8BD3),a
            push de
            ld   e,xl
            ld   d,e
            push de
            pop  af,de
            ld   sp,hl
            jr   L8BE4
L8BD3       equ  $-#0001
            rept 16:push af:endr
L8BE4       ld   a,(L8628)
            and  a
            ld   sp,(L8623)
            jrnz L8BF3
            call L8DEE
            jr   L8B9C
L8BF3       call L8E08
            jr   L8B9C
■FILLED
L8BF8       ld   a,l
            and  #1F
            cp   #20
            jrnc L8C11
            ld   a,(L8628)
            and  a
            jrnz L8C0C
            ld   a,#7F
            cp   h
            jrc  L8C13
            jr   L8C11
L8C0C       ld   a,#8B
            cp   h
            jrnc L8C13
L8C11       pop  af
            ret
L8C13       ld   (L8623),sp
L8C17
            ld   a,c
            and  (hl)
            ld   d,a
            ld   a,c
            cpl
            and  xl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,d
            sub  e
            srl  a
            jrnc L8C24
            ld   ($+7),a
            ld   a,xl
            ld   (hl),a
            ld   a,0
L8C24       call L5E36
            jrnz L8C51
            call L8DEE
            jr   L8C54
L8C51       call L8E08
L8C54       exx
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx
            jrnz L8C6D
            sli  c
            jrc  L8C72
L8C61       exx
            add  hl,bc
            inc  c
            exa
            cp   c
            jrz  L8C7C
            exa
            add  hl,bc
            bit  7,h
            exx
L8C6D       jpnz L8C17
            jr   L8CA0
L8C72       dec  l
            ld   a,l
            sub  e
            inc  a
            jrz  L8C90
            ld   c,#01;#FE
            jr   L8C61
L8C7C       exa
            exx
            ld   a,l
            sub  e
            exx
            jrz  L8C90
            jp   L8B69
L8C86       exa
            exx
            ld   a,l
            sub  e
            exx
            jrz  L8C90
            jp   L8BA9
L8C90       ld   sp,(L8623)
            pop  af
            ret
L8C96       dec  l
            ld   a,l
            sub  e
            inc  a
            jrz  L8C90
            ld   c,#01;#FE
            jr   L8CA4
L8CA0       sli  c
            jrc  L8C96
L8CA4       exx
            add  hl,bc
            inc  c
            jrz  L8C90
            exa
            cp   c
            jrz  L8C86
            exa
            add  hl,bc
            bit  7,h
            exx
            jrz  L8CA0
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
            and  xl
            or   d
            ld   (hl),a
            ld   d,l
            ld   l,e
            ld   a,d
            sub  e
            srl  a
            jrnc L8CC6
            ld   ($+7),a
            ld   a,xl
            ld   (hl),a
            ld   a,0
L8CC6       ld   l,d
            sub  #11
            cpl
            ld   (L8CD3),a
            push de
            ld   e,xl
            ld   d,e
            push de
            pop  af,de
            ld   sp,hl
L8CD2       jr   L8CD2
L8CD3       equ  $-#0001
            rept 16:push af:endr
            ld   a,(L8628)
            and  a
            ld   sp,(L8623)
            jrnz L8CF3
            call L8DEE
            jr   L8CA0
L8CF3       call L8E08
            jr   L8CA0
■FILLED
L8CF8       ld   a,e
            and  #1F
            cp   #20
            jrnc L8D11
            ld   a,(L8628)
            and  a
            jrnz L8D0C
            ld   a,#7F
            cp   h
            jrc  L8D13
            jr   L8D11
L8D0C       ld   a,#8B
            cp   h
            jrnc L8D13
L8D11       pop  af
            ret
L8D13       ld   (L8623),sp
L8D17       ld   d,l
            ld   l,e
            ld   a,b
            and  (hl)
            ld   (hl),a
            ld   a,b
            cpl
            and  xl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jrnc L8D26
            inc  l
            ld   ($+7),a
            ld   a,xl
            ld   (hl),a
            ld   a,0
L8D26       call L5E36
            jr   L8D4C

L8D4C       jrnz L8D53
            call L8DEE
            jr   L8D56
L8D53       call L8E08
L8D56       exx
            add  hl,de
            inc  e
            add  hl,de
            bit  7,h
            exx
            jrnz L8D6F
            scf
            rr   b
            jrc  L8D74
L8D63       exx
            add  hl,bc
            inc  c
            exa
            cp   c
            jrz  L8D7D
            exa
            add  hl,bc
            bit  7,h
            exx
L8D6F       jpnz L8D17
            jr   L8D94
L8D74       inc  e
            ld   a,l
            sub  e
            jrz  L8D85
            ld   b,#80;#7F
            jr   L8D63
L8D7D       exa
            jp   L8B69
L8D81       exa
            jp   L8BA9
L8D85       ld   sp,(L8623)
            pop  af
            ret
L8D8B       inc  e
            ld   a,l
            sub  e
            jrz  L8D85
            ld   b,#80;#7F
            jr   L8D98
L8D94
            scf
            rr   b
            jrc  L8D8B
L8D98       exx
            add  hl,bc
            inc  c
            jrz  L8D85
            exa
            cp   c
            jrz  L8D81
            exa
            add  hl,bc
            bit  7,h
            exx
            jrz  L8D94
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
            and  xl
            or   (hl)
            ld   (hl),a
            ld   a,d
            sub  e
            dec  a
            srl  a
            jrnc L8DBC
            inc  l
            ld   ($+7),a
            ld   a,xl
            ld   (hl),a
            ld   a,0
L8DBC       ld   l,d
            sub  #11
            cpl
            ld   (L8DC9),a
            push de
            ld   e,xl
            ld   d,e
            push de
            pop  af,de
            ld   sp,hl
L8DC8       jr   L8DC8
L8DC9       equ  $-#0001
            rept 16:push af:endr
            ld   a,(L8628)
            and  a
            ld   sp,(L8623)
            jrnz L8DE9
            call L8DEE
            jr   L8D94
L8DE9       call L8E08
            jr   L8D94
L8DEE
            ld   a,xl
            xor  xh
            ld   xl,a
            ld   a,e
            sub  #20
            ld   e,a
            ld   a,l
            sub  #20
            ld   l,a
            retnc
            dec  h
            ld   a,#7F
            cp   h
            retnz
            pop  af
            ld   sp,(L8623)
            pop  af
            ret
L8E08
            ld   a,xl
            xor  xh
            ld   xl,a
            ld   a,e
            add  a,#20
            ld   e,a
            ld   a,l
            add  a,#20
            ld   l,a
            retnc
            inc  h
            ld   a,#8C
            cp   h
            retnz
            pop  af
            ld   sp,(L8623)
            pop  af
            ret

            db   #00,#00
TXTR        db   #00,#00



$J16        call $J19
            and  a
            retz
            push ix
            ld   ix,SUNZ
LD7CE       push iy
            ld   iy,SUNX-3
            call LFBE0
            callnz LFBE0
            callnz LFBE0
            pop  iy,ix
            ret
LED57
            db   0,0
            db   #81,#41,#42,#22,#23,#13,#14
LFAF7
            db   0,0
            db   #81,#C1,#C2,#E2,#E3,#F3,#F4

LA8FA
            ds   #20

LFB03       ld   e,a
            ld   d,#00
            ld   hl,LED57
            exa
            and  a
            jrz  $+5
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
LFB31       ld   a,#AF
LFB32       equ  $-1
            exa
            ld   a,($J52)
            cp   #04
            ld   a,(L861D)
            retnc
            cp   #09
            retnc
            cp   #02
            retc
            call LFB03
            ld   hl,(L861A)
            ld   a,(L861C)
            ld   b,a
            ld   a,#7F
            cp   h
            jrc  LFB6A
            add  a,h
            rrc  b
            jrc  $+4
            sub  h
            sub  h
            ld   c,a
            cp   #08
            jrnc $+3
            inc  d
            cp   #F8
            jrc  $+4
            inc  d
            inc  d
            ld   a,#48
            cp   l
            jrnc $+4
LFB6A       xor  a
            ret
            ld   a,MID
            add  a,l
            rrc  b
            jrnc $+4
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
LFB83       push af
            ld   a,yl
            xor  yh
            ld   yl,a
            ld   a,l
            sub  #20
            ld   l,a
            jrnc $+3
            dec  h
            ld   a,h
            cp   #60
            jrc  LFB98
            cp   #8C
            jrnc LFBC9
            cp   #80
            jrc  LFBC9
LFB98       push hl
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
            jrc  LFBBA
            dec  hl
            ld   ($+7),a
            cpl
            and  (hl)
            ld   (hl),a
            ld   a,0
            and  yl
            or   (hl)
            ld   (hl),a
            inc  hl
LFBBA       ld   a,d
            cpl
            and  (hl)
            ld   (hl),a
            ld   a,d
            and  yl
            or   (hl)
            ld   (hl),a
            rrc  b
            jrc  LFBC8
            inc  hl
            ld   a,e
            cpl
            and  (hl)
            ld   (hl),a
            ld   a,e
            and  yl
            or   (hl)
            ld   (hl),a
            dec  hl
LFBC8       pop  de
LFBC9       pop  af
            bit  7,d
            jrnz LFBD8
            inc  a
            inc  ix
            cp   e
            jrnz LFB83
            set  7,d
            dec  ix
LFBD8       dec  ix
            dec  a
            jrnz LFB83
            pop  ix
            ret
LFBE0       ld   de,#0003
            add  iy,de
            ld   a,(iy+#02)
            and  #7F
            ld   d,a
            ld   a,(ix+#02)
            and  #7F
            cp   #0A
            jrc  LFC00
            cp   d
            jrc  LFC03
            retnz
            ld   a,(ix+#01)
            cp   (iy+#01)
            jrc  LFC03
LFC00       or   #01
            ret
LFC03       xor  a
            ret


