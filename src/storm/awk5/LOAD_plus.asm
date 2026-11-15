;==============================================================================
; LOAD+ (awk5) - вариант LOAD, предварительно очищающий экраны
;
; ORG #8000.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

        include "HW.asm"

        org  #8000
        ld   bc,PORT_PAGE
        ld   a,#17
        out  (c),a
        ld   hl,#C000
        ld   de,#C001
        ld   bc,SCREEN_PIX_LEN
        ld   (hl),l
        ldir
        ld   (hl),%00000111
        ld   bc,SCREEN_ATTR_LEN-1
        ldir
        ld   hl,SCREEN
        ld   de,SCREEN+1
        ld   bc,SCREEN_PIX_LEN
        ld   (hl),l
        ldir
        ld   (hl),%00000111
        ld   bc,SCREEN_ATTR_LEN-1
        ldir

        ld   a,(TRDOS_DRIVE)
        ld   (DSK+1),a
        ld   ix,#2F65
        call TOTD
        ld   a,#58              ; Step on
        ld   c,FDC_COMMAND
        call TOREG
        ld   ix,#2F59           ; Wait
        call TOTD

        ld   de,#0101
        ld   bc,#000A
M1
        push bc
        ld   bc,PORT_PAGE
PG      ld   a,%00010111
        out  (c),a
        xor  %00001010
        ld   (PG+1),a
        exx
        ld   hl,#C000
        exx
        call LOAD
        exx
        ld   hl,#C100
        exx
        call LOAD
        exx
        ld   hl,#C200
        exx
        call LOAD
        exx
        ld   hl,#C300
        exx
        call LOAD
        exx
        ld   hl,#C400
        exx
        call LOAD
        exx
        ld   hl,#C500
        exx
        call LOAD
        exx
        ld   hl,#C600
        exx
        call LOAD
        exx
        ld   hl,#C700
        exx
        call LOAD
        exx
        ld   hl,#C020
        exx
        call LOAD
        exx
        ld   hl,#C120
        exx
        call LOAD
        exx
        ld   hl,#C220
        exx
        call LOAD
        exx
        ld   hl,#C320
        exx
        call LOAD
        exx
        ld   hl,#C420
        exx
        call LOAD
        exx
        ld   hl,#C520
        exx
        call LOAD
        exx
        ld   hl,#C620
        exx
        call LOAD
        exx
        ld   hl,#C720
        exx
        call LOAD

        pop  bc
        dec  bc
        ld   a,c
        or   b
        jp   nz,M1
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
        ld   bc,#017F
        ld   ix,#2090
        jr   TOTD
RETS
        di
        exx
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
        ld   ix,#2F59           ; Wait
        call TOTD
        exx
        ret
ODIN    db   1
TOREG
        ld   ix,#2A53
TOTD
        push ix
        jp   #3D2F
