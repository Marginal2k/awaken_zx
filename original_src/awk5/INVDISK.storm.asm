        ORG #7000

        LD C,1
        LD A,1
        CALL #3D13

        LD DE,#0100
        LD (#5CF4),DE

        LD B,159
M1
        PUSH BC
        LD DE,(#5CF4)
        PUSH DE
        LD BC,#8005
        LD HL,#8000
        PUSH HL
        CALL #3D13
        POP HL
        LD A,(HL)
        CPL
        LD (HL),A
        INC L
        JR NZ,$-4
        INC H
        JR NZ,$-7
        LD HL,#8000
        POP DE
        LD BC,#8006
        CALL #3D13
        POP BC
        DJNZ M1
        RET
