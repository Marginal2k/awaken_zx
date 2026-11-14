
            org  #6000
            ld   hl,M1
            ld   de,M2
            ld   a,8
L3:
            push hl
            ex   af,af'
            ld   c,20
L2:
            push de
            push hl
            ld   b,20
L1:
            ld   a,(hl)
            rept 4
            rlc  (hl)
            endr
            or   (hl)
            ld   (de),a
            inc  hl
            inc  de
            djnz L1
            pop  hl
            pop  de

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
            ex   af,af'
            dec  a
            jp   nz,L3
            ret  

            org  #7000
M2:

            org  #A000
M1:
            incbin "awk2_cv1.C"
            incbin "awk2_cv2.C"
            incbin "awk2_cv3.C"
            incbin "awk2_cv4.C"
            incbin "awk2_cv5.C"
            incbin "awk2_cv6.C"
            incbin "awk2_cv7.C"
            incbin "awk2_cv8.C"

