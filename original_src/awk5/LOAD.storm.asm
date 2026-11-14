        ORG #8000
        DI
        CALL MAKEDRP

        LD A,(#5D16)
        OR 1
        LD (DSK+1),A
        LD C,#FF
        CALL TOREG
        LD IX,#2F65
        CALL TOTD
        LD IX,#2F59;WAIT
        CALL TOTD

        LD DE,#0101
        LD BC,#0040
M1
        PUSH BC
        EXX:LD HL,#9000:EXX:CALL LOAD
        CALL PAUS
        EXX:LD HL,#9100:EXX:CALL LOAD
        CALL PAUS
        EXX:LD HL,#9200:EXX:CALL LOAD
        CALL PAUS
        EXX:LD HL,#9300:EXX:CALL LOAD
        CALL PAUS
        EXX:LD HL,#9400:EXX:CALL LOAD
        CALL PAUS
        EXX:LD HL,#9500:EXX:CALL LOAD
        CALL PAUS

        PUSH DE
        CALL DROPSCR
        POP DE

        CALL MEAN

        POP BC
        DEC BC
        LD A,C
        OR B
        JP NZ,M1
        RET
PAUS
        LD BC,160
        DEC BC:LD A,C:OR B:JP NZ,$-3
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
        LD BC,#007F
        LD IX,#2090
        JR TOTD
RETS
        DI
        EXX
MEAN
        INC E
        LD A,E
        CP #11
        RET C
        INC D
        LD E,1
        BIT 0,D
        RET NZ
        EXX
        LD A,#58;STEP ON
        LD C,#1F
        CALL TOREG

        LD IX,#3EF5;WAIT
        CALL TOTD
        DI

        EXX
        RET
ODIN    DB 1
TOREG
        LD IX,#2A53
TOTD
        PUSH IX
        JP #3D2F
MAKEDRP
        LD BC,#10
        EXX
        LD DE,DS1
        LD A,95
MDS1
        EXA
        LD HL,DS0
        LD BC,DLEN
        EXX
        LD HL,(DS0+1)
        ADD HL,BC
        LD (DS0+1),HL
        LD HL,(DS01+1)
        INC H
        LD A,H
        AND 7
        JP NZ,$+14
        LD A,L
        ADD A,32
        LD L,A
        JP C,$+7
        LD A,H
        SUB 8
        LD H,A
        LD (DS01+1),HL
        EXX
        LDIR
        EXA
        DEC A
        JP NZ,MDS1
        LD HL,#9000
        LD (DS0+1),HL
        LD HL,#40D8
        LD (DS01+1),HL
        RET
DROPSCR
        LD (STK92+1),SP
DS0
        LD SP,#9000
        POP HL,DE,BC,AF
        EXX:EXA
        POP HL,DE,BC,AF
DS01    LD SP,#40D8
        PUSH AF,BC,DE,HL
        EXX:EXA
        PUSH AF,BC,DE,HL
DS1
DLEN    EQU 26

        DS 95*DLEN

STK92   LD SP,0
        RET
