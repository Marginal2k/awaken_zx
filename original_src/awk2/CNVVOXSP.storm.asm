;ПЕРЕКОДИРУЕТ СПРАЙТ ВОКСЕЛЬНЫЙ ИЗ
;ФОРМАТА #0Х В #ХХ
        ORG #6000
        LD DE,#8000
        LD BC,#0C00
M1
        LD A,(DE)
        LD L,A
.4      RLCA
        OR L
        LD (DE),A
        INC DE
        DEC BC
        LD A,B:OR C:JP NZ,M1
        RET
        ORG #8000
        INCB "CHAN1"

