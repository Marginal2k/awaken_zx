; BLK3 -- restored from awk2/BLK3.C (357 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
Datal
;HL-ADR ON SCREEN
;A-MEAN
        LD C,A
        AND A
        JR Z,Dln1 ;ECЛИ BOOБЩE = 0
        CPL
        AND 7
        LD A,C
        JR NZ,$+7
        ADD A,8
        AND %11111000
        LD C,A
        RRCA
        RRCA
        RRCA
        AND 7
        JR Z,Dln1
        LD B,A
        LD DE,#05AA
        DUP 5
            LD (HL),E
            INC H
        EDUP
        LD (HL),E
        LD A,H
        SUB D
        LD H,A
        INC L
        DJNZ $-15
Dln1
        LD A,C
        EX AF,AF
        LD A,C
        AND 7
        JR Z,Dln2
        LD C,A
        LD B,0
        EX DE,HL
        LD HL,Tabr
        ADD HL,BC
        LD A,(HL)
        DUP 5
            LD (DE),A
            INC D
        EDUP
        LD (DE),A
        LD A,D
        SUB 5
        LD D,A
        EX DE,HL
        INC L
Dln2
        EX AF,AF
        LD C,A
        AND 7
        LD A,C
        JR Z,$+4
        ADD A,8
        RRCA
        RRCA
        RRCA
        AND 7
        SUB 6
        RET NC
        NEG
        LD B,A
        LD DE,#0005
        XOR A
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        LD A,H
        SUB E
        LD H,A
        INC L
        DJNZ $-15
        RET
Tabr
        DB %10000000
        DB %10000000
        DB %10100000
        DB %10100000
        DB %10101000
        DB %10101000
        DB %10101010
