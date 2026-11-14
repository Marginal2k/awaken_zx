        ORG #6000
        LD HL,#8000
        LD DE,#C000
        LD BC,#0100
M1
        LD A,(HL):INC H
.3      INC D
        LD (DE),A
.3      DEC D
        LD A,(HL):INC H
        LD (DE),A
.2      INC D
        LD A,(HL):INC H
        LD (DE),A
        DEC D
        LD A,(HL)
        LD (DE),A
        DEC D
.3      DEC H
        INC L,E
        DEC BC
        LD A,B:OR C:JP NZ,M1
        RET
        ORG #8000
        INCB "VOX"
