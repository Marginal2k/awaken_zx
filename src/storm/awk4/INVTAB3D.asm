; INVTAB3D -- restored from awk4/INVTAB3D.C (349 bytes, plain-text STORM export)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;ИНВЕРТИРОВАНИЕ ТАБЛИЦЫ МАСОК ДЛЯ 3D
        ORG #8000
        LD HL,#9000
        LD B,#80
M1
        LD A,(HL)
        CPL
        LD C,A
        INC L
        LD A,(HL)
        CPL
        AND C
        LD (HL),A
        DEC L
        INC H
        LD A,(HL)
        CPL
        LD C,A
        INC L
        LD A,(HL)
        CPL
        AND C
        LD (HL),A
        INC L
        DEC H
        DJNZ M1
        RET
        ORG #9000
        INCBIN "assets/D9000_plus.bin"
