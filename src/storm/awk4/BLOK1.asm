; BLOK1 -- restored from awk4/BLOK1.C (4509 bytes, plain-text STORM export)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)

Getadr
;ПOЛУЧEHИE AДPECA И3 ИHДEKCA
;A-INDEX
;RET HL-ADR
        LD H,A
        XOR A
        SRL H
        RRA
        SRL H
        RRA
        PUSH BC
        LD BC,Carsb
        LD L,A
        ADD HL,BC
        POP BC
        RET





Clc2d3d
;CALC 2D FROM 3D
;DE-Z,HL-Y,BC-X
;RET HL-X,DE-Y
;FZ=NZ-ERROR
        PUSH BC
        PUSH DE
;Z
        BIT 7,D
        JR Z,$+9
        LD A,E
        CPL
        LD E,A
        LD A,D
        CPL
        LD D,A
        INC DE
;Y
        CALL Fdiv
        POP DE
        JP C,Ld3
        BIT 7,D
        JR Z,$+9
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL

        LD BC,#30 ;MIDLE Y
        ADD HL,BC
        LD B,H
        LD C,L
;X
        POP HL
        PUSH BC

        PUSH DE
        BIT 7,D
        JR Z,$+9
        LD A,E
        CPL
        LD E,A
        LD A,D
        CPL
        LD D,A
        INC DE
        CALL Fdiv
        POP DE
        JP C,Ld3
        BIT 7,D
        JR Z,$+9
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL

        LD DE,#0080 ;MIDLE X
        ADD HL,DE
        POP DE
        XOR A
        RET
Ld3
        POP AF
        XOR A
        INC A
        RET





Getindy
;IY-ADR
        PUSH HL
        PUSH IY
        POP HL
        CALL Getind
        POP HL
        RET








Getind
;БEPET ИHДEKC OT AДPECA B CПИCKE OБЪEKT
;OB
;HL-ADR
;RET A-INDEX
        PUSH BC
        LD BC,0-Carsb
        ADD HL,BC
        POP BC
        LD A,H
        SLA L
        RLA
        SLA L
        RLA
        RET






Fline
;PИCOBAHИE ЛA3EPA ИГPOKA
;FC-ON-ЕСЛИ БЫЛ ВЫСТРЕЛ
        LD A,0
Pstli   ADD A,70
        LD ($-3),A
        RET NC
        XOR A
        LD HL,#38A9
        LD A,low(Ld1l)
        LD (L91+#4E),HL
        LD (Ldadd),A
        LD A,R
        LD C,A
        AND 1
        BIT 4,C
        JR Z,$+4
        NEG
        LD E,A
        LD A,(Pcord)
        ADD A,8
        ADD A,E
        LD E,A
        LD A,R
        LD C,A
        AND 1
        BIT 4,C
        JR Z,$+4
        NEG
        LD D,A
        LD A,(Pcord+1)
        ADD A,5
        ADD A,D
        LD D,A
        PUSH DE
        LD HL,#5F40
        CALL Drawl1
        LD HL,#5FC0
        POP DE
        CALL Drawl1
        SCF
        RET






Moveon
;MOVING SHIPS IN FRONT
;DE-SPEED
;IX-ВЕКТОР ОБЪЕКТА
;RET IN STPX_,STPY_,STPZ_
        PUSH IX
        LD A,(IX+Alfa)
        LD (Eyea_+1),A
        LD A,(IX+Beta)
        ADD A,#80
        LD (Eyeb_+1),A
        LD A,(IX+Gama)
        LD (Eyeg_+1),A
        PUSH DE
        CALL Shmtrx
        POP DE
Hm_13   LD A,0
        PUSH DE
        LD IX,$+7
        JP MULL
        POP DE
        LD (Stpx_+1),HL
Hm_23   LD A,0
        PUSH DE
        LD IX,$+7
        JP MULL
        POP DE
        LD (Stpy_+1),HL
Hm_33   LD A,0
        LD IX,$+7
        JP MULL
        LD (Stpz_+1),HL
        POP IX
        RET



        CCF
        RET
Fdiv
;HL=HL/DE
        LD A,L
        LD L,H
        LD H,0
        AND A
        SBC HL,DE
        JP NC,Fdiv-2
        ADD HL,DE
        RLA
        ADC HL,HL
        AND A
        SBC HL,DE
        JP NC,Fdiv-2
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        LD B,A
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        CPL
        LD L,A
        LD A,B
        CPL
        LD H,A
        OR A
        RET
