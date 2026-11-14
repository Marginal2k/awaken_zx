; CNVVOXSP -- restored from awk2/CNVVOXSP.C (125 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;ПЕРЕКОДИРУЕТ СПРАЙТ ВОКСЕЛЬНЫЙ ИЗ
;ФОРМАТА #0Х В #ХХ
        ORG #6000
        LD DE,#8000
        LD BC,#0C00
M1
        LD A,(DE)
        LD L,A
        DUP 4
            RLCA
        EDUP
        OR L
        LD (DE),A
        INC DE
        DEC BC
        LD A,B
        OR C
        JP NZ,M1
        RET
        ORG #8000
        INCBIN "assets/CHAN1.bin"
