        include "HW.asm"

        org  #8000
        di
        call MAKEDRP

        ld   a,(TRDOS_DRIVE)
        or   1
        ld   (DSK+1),a
        ld   c,#FF
        call TOREG
        ld   ix,#2F65
        call TOTD
        ld   ix,#2F59           ; Wait
        call TOTD

        ld   de,#0101
        ld   bc,#0040
M1
        push bc
        exx
        ld   hl,#9000
        exx
        call LOAD
        call PAUS
        exx
        ld   hl,#9100
        exx
        call LOAD
        call PAUS
        exx
        ld   hl,#9200
        exx
        call LOAD
        call PAUS
        exx
        ld   hl,#9300
        exx
        call LOAD
        call PAUS
        exx
        ld   hl,#9400
        exx
        call LOAD
        call PAUS
        exx
        ld   hl,#9500
        exx
        call LOAD
        call PAUS

        push de
        call DROPSCR
        pop  de

        call MEAN

        pop  bc
        dec  bc
        ld   a,c
        or   b
        jp   nz,M1
        ret
PAUS
        ld   bc,160
        dec  bc
        ld   a,c
        or   b
        jp   nz,$-3
        ret
LOAD
DSK     ld   a,0
        and  %00101111
        ld   c,a
        xor  a
        bit  0,d
        jr   nz,$+4
        ld   a,#10
        or   c
        ld   c,#FF
        call TOREG
        ld   a,e
        ld   c,FDC_SECTOR
        call TOREG
        ld   bc,RETS
        push bc
        ld   bc,ODIN
        push bc
        exx
        ld   bc,#007F
        ld   ix,#2090
        jr   TOTD
RETS
        di
        exx
MEAN
        inc  e
        ld   a,e
        cp   #11
        ret  c
        inc  d
        ld   e,1
        bit  0,d
        ret  nz
        exx
        ld   a,#58              ; Step on
        ld   c,FDC_COMMAND
        call TOREG

        ld   ix,#3EF5           ; Wait
        call TOTD
        di

        exx
        ret
ODIN    db   1
TOREG
        ld   ix,#2A53
TOTD
        push ix
        jp   #3D2F
MAKEDRP
        ld   bc,#10
        exx
        ld   de,DS1
        ld   a,95
MDS1
        ex   af,af'
        ld   hl,DS0
        ld   bc,DLEN
        exx
        ld   hl,(DS0+1)
        add  hl,bc
        ld   (DS0+1),hl
        ld   hl,(DS01+1)
        inc  h
        ld   a,h
        and  7
        jp   nz,$+14
        ld   a,l
        add  a,32
        ld   l,a
        jp   c,$+7
        ld   a,h
        sub  8
        ld   h,a
        ld   (DS01+1),hl
        exx
        ldir
        ex   af,af'
        dec  a
        jp   nz,MDS1
        ld   hl,#9000
        ld   (DS0+1),hl
        ld   hl,#40D8
        ld   (DS01+1),hl
        ret
DROPSCR
        ld   (STK92+1),sp
DS0
        ld   sp,#9000
        pop  hl
        pop  de
        pop  bc
        pop  af
        exx
        ex   af,af'
        pop  hl
        pop  de
        pop  bc
        pop  af
DS01    ld   sp,#40D8
        push af
        push bc
        push de
        push hl
        exx
        ex   af,af'
        push af
        push bc
        push de
        push hl
DS1
DLEN            equ 26

        ds   95*DLEN

STK92   ld   sp,0
        ret
