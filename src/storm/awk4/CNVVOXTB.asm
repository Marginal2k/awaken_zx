; CNVVOXTB -- restored from awk4/CNVVOXTB.C (479 bytes, plain-text STORM export)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;ПРЕОБРАЗОВАНИЕ ФОРМАТА ХРАНЕНИЯ
;ВОКСЕЛЕЙ
        ORG #6000
        LD HL,#8000
        LD DE,#C000
        LD BC,#0100
M1
        LD A,(HL)
        INC H
        DUP 3
            INC D
        EDUP
        LD (DE),A
        DUP 3
            DEC D
        EDUP
        LD A,(HL)
        INC H
        LD (DE),A
        DUP 2
            INC D
        EDUP
        LD A,(HL)
        INC H
        LD (DE),A
        DEC D
        LD A,(HL)
        LD (DE),A
        DEC D
        DUP 3
            DEC H
        EDUP
        INC L
        INC E
        DEC BC
        LD A,B
        OR C
        JP NZ,M1
        RET
        ORG #8000
        INCBIN "VOX.bin"
