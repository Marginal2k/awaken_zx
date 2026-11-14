; LOAD_plus -- restored from awk5/LOAD_2b.C (662 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
        ORG #8000
        LD BC,#7FFD
        LD A,#17
        OUT (C),A
        LD HL,#C000
        LD DE,#C001
        LD BC,#1800
        LD (HL),L
        LDIR
        LD (HL),%00000111
        LD BC,#02FF
        LDIR
        LD HL,#4000
        LD DE,#4001
        LD BC,#1800
        LD (HL),L
        LDIR
        LD (HL),%00000111
        LD BC,#02FF
        LDIR

        LD A,(#5D16)
        LD (DSK+1),A
        LD IX,#2F65
        CALL TOTD
        LD A,#58 ;STEP ON
        LD C,#1F
        CALL TOREG
        LD IX,#2F59 ;WAIT
        CALL TOTD

        LD DE,#0101
        LD BC,#000A
M1
        PUSH BC
        LD BC,#7FFD
PG      LD A,%00010111
        OUT (C),A
        XOR %00001010
        LD (PG+1),A
        EXX
        LD HL,#C000
        EXX
        CALL LOAD
        EXX
        LD HL,#C100
        EXX
        CALL LOAD
        EXX
        LD HL,#C200
        EXX
        CALL LOAD
        EXX
        LD HL,#C300
        EXX
        CALL LOAD
        EXX
        LD HL,#C400
        EXX
        CALL LOAD
        EXX
        LD HL,#C500
        EXX
        CALL LOAD
        EXX
        LD HL,#C600
        EXX
        CALL LOAD
        EXX
        LD HL,#C700
        EXX
        CALL LOAD
        EXX
        LD HL,#C020
        EXX
        CALL LOAD
        EXX
        LD HL,#C120
        EXX
        CALL LOAD
        EXX
        LD HL,#C220
        EXX
        CALL LOAD
        EXX
        LD HL,#C320
        EXX
        CALL LOAD
        EXX
        LD HL,#C420
        EXX
        CALL LOAD
        EXX
        LD HL,#C520
        EXX
        CALL LOAD
        EXX
        LD HL,#C620
        EXX
        CALL LOAD
        EXX
        LD HL,#C720
        EXX
        CALL LOAD


        POP BC
        DEC BC
        LD A,C
        OR B
        JP NZ,M1
        RET

LOAD
DSK     LD A,0
        AND %00101111
        LD C,A
        XOR A
        BIT 0,D
        JR NZ,$+4
        LD A,#10
        OR C
        LD C,#FF
        CALL TOREG
        LD A,E
        LD C,#5F
        CALL TOREG
        LD BC,RETS
        PUSH BC
        LD BC,ODIN
        PUSH BC
        EXX
        LD BC,#017F
        LD IX,#2090
        JR TOTD
RETS
        DI
        EXX
        INC E
        LD A,E
        CP #11
        RET C
        INC D
        LD E,1
        BIT 0,D
        RET NZ
        EXX
        LD A,#58 ;STEP ON
        LD C,#1F
        CALL TOREG
        LD IX,#2F59 ;WAIT
        CALL TOTD
        EXX
        RET
ODIN    DB 1
TOREG
        LD IX,#2A53
TOTD
        PUSH IX
        JP #3D2F
