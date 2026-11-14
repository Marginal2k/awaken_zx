; CNVVOXS3 -- restored from awk2/CNVVOXS3.C (180 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;ПЕРЕКОДИРУЕТ СПРАЙТ ВОКСЕЛЬНЫЙ ИЗ
;ФОРМАТА #0Х В #ХХ
;ПЛЮС ВЫРЕЗАЕТ СПРАЙТ РАЗМЕРОМ
        ORG #6000
        LD DE,#8000
        LD HL,#C000
        LD B,32
M2
        PUSH BC
        PUSH HL
        LD B,14
M1
        LD A,(HL)
        LD C,A
        DUP 4
            RLCA
        EDUP
        OR C
        LD (DE),A
        INC HL
        INC DE
        DJNZ M1
        POP HL
        LD BC,64
        ADD HL,BC
        POP BC
        DJNZ M2
        RET
        ORG #C000
        INCBIN "assets/drv2.bin"
