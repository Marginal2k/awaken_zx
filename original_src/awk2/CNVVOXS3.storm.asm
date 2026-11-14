;ПЕРЕКОДИРУЕТ СПРАЙТ ВОКСЕЛЬНЫЙ ИЗ
;ФОРМАТА #0Х В #ХХ
;ПЛЮС ВЫРЕЗАЕТ СПРАЙТ РАЗМЕРОМ
        ORG #6000
        LD DE,#8000
        LD HL,#C000
        LD B,32
M2
        PUSH BC,HL
        LD B,14
M1
        LD A,(HL)
        LD C,A
.4      RLCA
        OR C
        LD (DE),A
        INC HL,DE
        DJNZ M1
        POP HL
        LD BC,64
        ADD HL,BC
        POP BC
        DJNZ M2
        RET
        ORG #C000
        INCB "drv2"

