;ПЕРЕКОДИРУЕТ СПРАЙТ ВОКСЕЛЬНЫЙ ИЗ
;ФОРМАТА #0Х В #ХХ
            org  #6000
            ld   de,#8000
            ld   bc,#0C00
M1:
            ld   a,(de)
            ld   l,a
            rlca 
            rlca 
            rlca 
            rlca 
            or   l
            ld   (de),a
            inc  de
            dec  bc
            ld   a,b
            or   c
            jp   nz,M1
            ret  
            org  #8000
            incbin "assets/awk2_CHAN1.C"

