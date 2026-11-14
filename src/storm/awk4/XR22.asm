; XR22 -- restored from awk4/XR22.C (4788 bytes, plain-text STORM export)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)

;DRAW LINE FROM SOME CORDS
Drwlin
        LD HL,(L91+#2A)
        LD DE,(L91+#2C)
        AND A
        SBC HL,DE
        RET Z
        ADD HL,DE
;DRAW LINE CORDS IN HL,DE
;H,D-Y : L,E-X
Drawl1
        LD (Ldbbb),SP
        LD SP,#0020
        LD A,D
        SUB H
        JR NC,Ldad8
        EX DE,HL
        NEG
Ldad8   LD D,A
        LD A,L
        AND #07
        ADD A,#00
Ldadd   EQU $-#0001
        LD C,A
        LD A,high(Ld1l)
        ADC A,#00
        LD B,A
        LD A,(BC)
        LD C,A
        LD A,L
        SRL H
        RR L
        SRL H
        RR L
        SCF
        RR H
        RR L
        SUB E
        JR C,Ldb59
        CP D
        JR C,Ldb2d
        LD E,D
        LD D,A
        LD B,A
        SRL A
        EX AF,AF
;PUT INSIDE COMAND FOR THIS LINE
        LD A,(L91+#4E) ;COMAND 1
        LD (Ldb0d),A
        LD A,(L91+#4F) ;COMAND 2
        LD (Ldb10),A
        LD A,(HL)
Ldb0d   NOP
        RLC C
Ldb10   JR C,Ldb1d
Ldb12   EX AF,AF
        SUB E
        JR C,Ldb23
        EX AF,AF
        DJNZ Ldb0d
        LD (HL),A
        JP Ldbba
Ldb1d   LD (HL),A
        DEC L
        LD A,(HL)
        JP Ldb12
Ldb23   ADD A,D
        EX AF,AF
        LD (HL),A
        ADD HL,SP
        LD A,(HL)
        DJNZ Ldb0d
        JP Ldbba
Ldb2d   LD E,A
        LD A,D
        LD B,D
        SRL A
        EX AF,AF
        LD A,(L91+#4E)
        LD (Ldb40),A
        LD A,(L91+#4F)
        LD (Ldb4a),A
Ldb3f   LD A,(HL)
Ldb40   NOP
        LD (HL),A
        ADD HL,SP
        EX AF,AF
        SUB E
        JR NC,Ldb4c
        ADD A,D
        RLC C
Ldb4a   JR C,Ldb52
Ldb4c   EX AF,AF
        DJNZ Ldb3f
        JP Ldbba
Ldb52   DEC L
        EX AF,AF
        DJNZ Ldb3f
        JP Ldbba
Ldb59   NEG
        CP D
        JR C,Ldb91
        LD E,D
        LD D,A
        LD B,A
        SRL A
        EX AF,AF
        LD A,(L91+#4E)
        LD (Ldb71),A
        LD A,(L91+#4F)
        LD (Ldb74),A
        LD A,(HL)
Ldb71   NOP
        RRC C
Ldb74   JR C,Ldb81
Ldb76   EX AF,AF
        SUB E
        JR C,Ldb87
        EX AF,AF
        DJNZ Ldb71
        LD (HL),A
        JP Ldbba
Ldb81   LD (HL),A
        INC L
        LD A,(HL)
        JP Ldb76
Ldb87   ADD A,D
        EX AF,AF
        LD (HL),A
        ADD HL,SP
        LD A,(HL)
        DJNZ Ldb71
        JP Ldbba
Ldb91   LD E,A
        LD A,D
        LD B,D
        SRL A
        EX AF,AF
        LD A,(L91+#4E)
        LD (Ldba4),A
        LD A,(L91+#4F)
        LD (Ldbae),A
Ldba3   LD A,(HL)
Ldba4   NOP
        LD (HL),A
        ADD HL,SP
        EX AF,AF
        SUB E
        JR NC,Ldbb0
        ADD A,D
        RRC C
Ldbae   JR C,Ldbb6
Ldbb0   EX AF,AF
        DJNZ Ldba3
        JP Ldbba
Ldbb6   INC L
        EX AF,AF
        DJNZ Ldba3
Ldbba   LD SP,#0000
Ldbbb   EQU $-#0002
        RET






;CALC VISIBLE MASK FOR POLYGON
Vsmask
        PUSH HL
        XOR A
        EX AF,AF
        LD HL,+(L9c*256)+1
Adt     LD A,0
        SUB 4
        LD B,A
Ld814   LD C,#00
        LD A,(HL)
        INC L
        INC L
        CP #80
        JR Z,Ld85d
        JR NC,Ld826
        AND A
        JP NZ,Ld82b
        JP Ld82d
Ld826   SET 1,C
        JP Ld82d
Ld82b   SET 0,C
Ld82d   LD A,(HL)
        AND A
        JP M,Ld83f
        JP NZ,Ld844
        DEC L
        LD A,(HL)
        INC L
        CP #60
        JR NC,Ld844
        JP Ld846
Ld83f   SET 3,C
        JP Ld846
Ld844   SET 2,C
Ld846   INC L
        LD A,C
        RLCA
        RLCA
        RLCA
        RLCA
        XOR #F0
        OR C
        LD (HL),A
        EX AF,AF
        OR (HL)
        EX AF,AF
        INC L
        LD A,L
        INC L
        CP B
        JP NZ,Ld814
        POP HL
        EX AF,AF
        RET
Ld85d   POP HL
        XOR A
        RET


;VISIBILITY POLYGON
;RET FS-M POLY VISIBLE
Vspoly
        PUSH BC
        PUSH HL
        INC HL
        CP #05
        JR NC,Lda5b
        LD D,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD A,(HL)
        JP Lda62
Lda5b   LD D,(HL)
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        INC HL
        LD A,(HL)
Lda62   LD H,L9c
        LD L,D
        LD (Lda7a),SP
        LD SP,HL
        POP BC
        EXX
        POP BC
        EXX
        LD L,E
        LD SP,HL
        POP DE
        EXX
        POP DE
        EXX
        LD L,A
        LD SP,HL
        POP HL
        EXX
        POP HL
        LD SP,#0000
Lda7a   EQU $-#0002
        SBC HL,BC
        EX DE,HL
        SBC HL,BC
        PUSH HL
        EXX
        SBC HL,BC
        EX DE,HL
        SBC HL,BC
        EX (SP),HL
        EXX
        POP HL
        CALL Mull
        PUSH HL
        PUSH DE
        EXX
        CALL Mull
        EX DE,HL
        POP BC
        SBC HL,BC
        EX DE,HL
        POP BC
        SBC HL,BC
        POP HL
        POP BC
        RET
