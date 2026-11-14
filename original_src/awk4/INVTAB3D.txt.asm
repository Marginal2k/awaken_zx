;ИНВЕРТИРОВАНИЕ ТАБЛИЦЫ МАСОК ДЛЯ 3D
        ORG #8000
        LD HL,#9000
        LD B,#80
M1
        LD A,(HL):CPL:LD C,A:INC L
        LD A,(HL):CPL:AND C:LD (HL),A
        DEC L:INC H
        LD A,(HL):CPL:LD C,A:INC L
        LD A,(HL):CPL:AND C:LD (HL),A
        INC L:DEC H
        DJNZ M1
        RET
        ORG #9000
        INCB "D9000+"
