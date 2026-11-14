
            org  #6000
            ld   hl,M1
            ld   de,M2
            ld   a,8
L3
            push hl
            exa
            ld   c,20
L2
            push de,hl
            ld   b,20
L1
            ld   a,(hl)
            rept 4
            rlc  (hl)
            endr
            or   (hl)
            ld   (de),a
            inc  hl,de
            djnz L1
            pop  hl,de

            ld   a,c

            ld   bc,64
            add  hl,bc

            ex   de,hl
            ld   bc,32
            add  hl,bc
            ex   de,hl

            ld   c,a
            dec  c
            jp   nz,L2
            pop  hl
            ld   bc,3072
            add  hl,bc
            exa
            dec  a
            jp   nz,L3
            ret

            org  #7000
M2

            org  #A000
M1
            insert "cv1.C"
            insert "cv2.C"
            insert "cv3.C"
            insert "cv4.C"
            insert "cv5.C"
            insert "cv6.C"
            insert "cv7.C"
            insert "cv8.C"

