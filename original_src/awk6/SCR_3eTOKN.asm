
■;ПPEOБPA3OBAHИeCTAHД.CKPИHA bHAБOP 3H
■AKOMECT
            org  #6000
            ld   hl,Scr
            ld   de,#C000
            exx
            ld   bc,#0300
M1
            exx

            rept 8:ld a,(hl):cpl:ld (de),a:inc h,de:endr
            ld   a,l
            add  a,1
            ld   l,a
            jr   c,$+6
            ld   a,h
            sub  8
            ld   h,a
            exx
            dec  bc
            ld   a,b
            or   c
            jp   nz,M1
            ld   hl,Scr+#1800
            ld   de,#D800
            ld   bc,#300
M2
            push bc
            ld   a,(hl)
            and  %00111000
            rrca:rrca:rrca
            ld   c,a
            ld   a,(hl)
            and  %00000111
            rlca:rlca:rlca
            or   c
            ld   c,a
            ld   a,(hl)
            and  #C0
            or   c
            ld   (de),a
            pop  bc
            inc  de,hl
            dec  bc
            ld   a,b:or c
            jrnz M2
            ret

            org  #8000
Scr
            insert "s1.C"


