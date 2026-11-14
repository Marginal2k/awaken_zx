; XR2 -- restored from awk2/XR2~1.C (10427 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;HAЧAЛO ПPOЦEДУP BЫBOДA ПЛOCKOCTИ
;MUST BE ONLY FROM #XX00
Lc5
;TEXTURES: TEXTURE, XOR MASK
        DW #0000
        DW #AA88
        DW #FFAA
        DW #55EE
        DW #00FF


MERZ
        LD A,(P00stur)
        XOR %00110000
;ЧETЫPEX УГOЛЬHЫE
        LD (P00stur),A
        LD (P00trd),A
        LD (P00turi),A
;TPEX УГOЛЬHЫE
        LD A,(P00istr)
        XOR %00110000
        LD (P00istr),A
        LD (P01istr),A
        RET

;ОБЩАЯ ИНИЦИАЛИЗАЦИЯ
INIT_
        XOR A
        LD L,A
        LD H,A
        LD (Eye_a),HL
        LD (Eye_g),A
        LD HL,ADI3D_
        LD DE,L97
        LD BC,#0100
        LDIR
        RET



        ORG (($)&#FF00)+#C0
E2
        DUP 31
            LD (BC),A
            INC C
        EDUP
MSK     XOR #00
        EX AF,AF'
        LD A,IYL
        LD L,A
        LD A,(BC)
        AND (HL)
        INC L
        OR (HL)
        LD (BC),A
Lc608   INC H
        RES 1,H
        EXX
        ADD IX,BC
        JR C,JJJ1
JJJ2
        LD A,L
Lc616   SUB #00
        JR NC,$+6
Lc61a   ADD A,#00
        ADD IX,SP
        LD L,A
        ADD IY,DE
        LD A,H
Lc622   SUB #00
        JR NC,$+6
Lc626   ADD A,#00
        ADD IY,SP
        LD H,A
        EXX


        LD A,D
BORD    CP #00
JUMP    JR NC,Lc66b


NXTE
        INC D
        LD A,IXL
        LD L,A
        LD A,IXH
        LD C,A
        SUB IYH
        JR NC,Lc654
        ADD A,A
        LD ($+11),A
        LD A,(BC)
        AND (HL)
        INC L
        OR (HL)
        LD (BC),A
        INC C
        EX AF,AF'
        JP Lc5

Lc654
        JR NZ,VB1
        LD A,(HL)
        LD E,IYL
        LD L,E
        OR (HL)
        INC L
        LD E,A
        CPL
        AND (HL)
        LD L,A
        LD A,(BC)
        AND E
        OR L
        LD (BC),A
VB1
        EX AF,AF'
MSK2    XOR #00
        EX AF,AF'
        JP Lc608

JJJ1    EXX
        INC B
        EXX
        JP JJJ2

Lc66b
JMP1    EQU ($-JUMP)-2
        LD SP,#0000
        POP HL
        RET

Lc66e
JMP3    EQU ($-JUMP)-2
        JP Lc6c0



;------------
Lc6b9   LD A,(Lc6cc)
        LD L,A
        JP Lc67f
Lc671
JMP2    EQU ($-JUMP)-2
        LD L,D
        PUSH HL

        LD HL,#0000
Lc675   EQU $-#0002
        DEC L
        LD E,(HL)
        INC L
Lc67b   DEC L
        JR Z,Lc6b9
        DEC L
Lc67f   LD A,(HL)
        SUB D
        JR Z,Lc67b
        JR C,Lc67b
        LD (Lc675),HL
        LD D,A
        LD (Lc61a+1),A
        SRL A
        EXX
        LD L,A
        EXX
        LD A,(HL)
        LD (Lc632+1),A
        DEC L
        LD A,(HL)
        SUB E
        JP C,Lc76a
        CP D
        JP C,Lc763
        LD E,A
        XOR A

        DUP 8
            RL E
            RLA
            SUB D
            JR NC,$+3
            ADD A,D
        EDUP
        RL E

        AND A
        JR Z,Lc75e
        SUB D
        NEG
        LD (Lc616+1),A
        LD A,E
        NEG
        SRL A
        EXX
        LD C,#00
        RR C
        RRA
        RR C
        RRA
        RR C
        ADD A,#20
        LD B,A
        EXX
        POP HL
        LD D,L
        LD A,D
        JP Lc635

Lc75e
        LD (Lc616+1),A
        LD A,E
        CPL
        RRA
        EXX
        LD C,#00
        RR C
        SRA A
        RR C
        SRA A
        RR C
        ADD A,#20
        LD B,A
        EXX
        POP HL
        LD D,L
        LD A,D
        JP Lc635

Lc763   SUB D
        NEG
        LD (Lc616+1),A
        EXX
        LD C,#20
        LD B,C
        EXX
        POP HL
        LD D,L
        LD A,D
        JP Lc635

Lc76a   NEG
        CP D
        JR C,Lc7b1
        LD E,A
        XOR A

        DUP 8
            RL E
            RLA
            SUB D
            JR NC,$+3
            ADD A,D
        EDUP
        RL E

        LD (Lc616+1),A
        LD A,E
        INC A
        SCF
        RRA
        EXX
        LD C,#00
        RR C
        SRA A
        RR C
        SRA A
        RR C
        ADD A,#20
        LD B,A
        EXX
        POP HL
        LD D,L
        LD A,D

Lc635   LD L,#00
        CP L
        JP C,NXTE2
        LD A,L
        LD (BORD+1),A
        LD A,JMP3
        LD (JUMP+1),A
        LD A,D
        JP BORD ;Lc635

Lc7b1
        LD (Lc616+1),A
        EXX
        LD C,#00
        LD B,#20
        EXX
        POP HL
        LD D,L
        LD A,D
        JP Lc635



;-----------
Lc70b   LD L,#01
        JP Lc6d1
Lc6c0
        LD L,D
        PUSH HL
        LD HL,#0000
Lc6c4   EQU $-#0002
        DEC L
        LD E,(HL)
        INC L
Lc6ca   LD A,L
        CP #00
Lc6cc   EQU $-#0001
        JR Z,Lc70b
        INC L
        INC L
Lc6d1   LD A,(HL)
        SUB D
        JR Z,Lc6ca
        JR C,Lc6ca
        LD (Lc6c4),HL
        LD D,A
        LD (Lc626+1),A
        SRL A
        EXX
        LD H,A
        EXX
        LD A,(HL)
        LD (Lc635+1),A
        DEC L
        LD A,(HL)
        SUB E
        JP C,Lc76al
        CP D
        JP C,Lc763l
        LD E,A
        XOR A

        DUP 8
            RL E
            RLA
            SUB D
            JR NC,$+3
            ADD A,D
        EDUP
        RL E

        AND A
        JR Z,Lc625l
        SUB D
        NEG
        LD (Lc622+1),A
        LD A,E
        NEG
        SRL A
        EXX
        LD E,#00
        RR E
        RRA
        RR E
        RRA
        RR E
        ADD A,#20
        LD D,A
        EXX
        POP HL
        LD D,L
        JP NXTE2

Lc625l
        LD (Lc622+1),A
        LD A,E
        CPL
        RRA
        EXX
        LD E,#00
        RR E
        SRA A
        RR E
        SRA A
        RR E
        ADD A,#20
        LD D,A
        EXX
        POP HL
        LD D,L
        JP NXTE2

Lc763l  SUB D
        NEG
        LD (Lc622+1),A
        EXX
        LD E,#20
        LD D,E
        EXX
        POP HL
        LD D,L
        JP NXTE2

Lc76al  NEG
        CP D
        JP C,Lc7b1l
        LD E,A
        XOR A

        DUP 8
            RL E
            RLA
            SUB D
            JR NC,$+3
            ADD A,D
        EDUP
        LD (Lc622+1),A

        LD A,E
        RLA
        INC A
        SCF
        RRA
        EXX
        LD E,#00
        RR E
        SRA A
        RR E
        SRA A
        RR E
        ADD A,#20
        LD D,A
        EXX
        POP HL
        LD D,L

NXTE2
Lc62d   LD L,#00
Lc632   LD E,#00
        LD A,E
        CP L
        JR C,NXTE3
        LD A,(Lc635+1)
        CP L
        JR C,NXTE4
        LD A,L
        LD (BORD+1),A
        LD A,JMP1
        LD (JUMP+1),A
        JP NXTE
NXTE3
        LD A,(Lc635+1)
        CP E
        JR C,NXTE4
        LD A,E
        LD (BORD+1),A
        LD A,JMP2
        LD (JUMP+1),A
        JP NXTE
NXTE4
        LD (BORD+1),A
        LD A,JMP3
        LD (JUMP+1),A
        JP NXTE

Lc7b1l
        LD (Lc622+1),A
        EXX
        LD E,#00
        LD D,#20
        EXX
        POP HL
        LD D,L
        JP NXTE2








Lc7b4   EX AF,AF'
        LD L,A
        EX AF,AF'
        INC L
        JP Lc7f7
Lc7bb   LD L,#01
        JP Lc807


LLC     POP HL
        RET

Polygon
        PUSH HL
        LD A,(L91+#0A)
        LD B,A
        DEC A
        LD (Lc6cc),A
        EX AF,AF'
        SRL B
;ПОИСК МИН. И МАКС. ПО У УЗЛА
;RET
;E,D-МАКС, МИН
;C-МЛ.БАЙТ АДРЕСА МИН УЗЛА
        LD HL,+(low(L9e)*256)+1
        LD DE,#FF00
Lc7d2
        LD A,(HL)
        CP D
        JP NC,$+5
        LD D,A
        LD C,L
        CP E
        JP C,$+4
        LD E,A
        INC L
        INC L
        DJNZ Lc7d2
        LD A,E
        CP D
        JR Z,LLC
        LD (Lc62d+1),A
        LD A,D
        LD (Lc632+1),A
        LD (Lc635+1),A
        LD B,D
        LD L,C
Lc7f3   LD E,L
        DEC L
        JR Z,Lc7b4
Lc7f7   DEC L
        CP (HL)
        JR Z,Lc7f3
        LD L,E
        LD (Lc675),HL
        LD L,C
Lc800   LD E,L
        EX AF,AF'
        CP L
        JR Z,Lc7bb
        INC L
        INC L
Lc807   EX AF,AF'
        CP (HL)
        JR Z,Lc800
        LD L,E
        LD (Lc6c4),HL
        LD A,(L91+#1A)
        ADD A,A
        LD C,A
        LD H,high(Lc5)
        LD L,A
        LD A,(HL)
        EX AF,AF'
        INC L
        LD A,(HL)
        LD (MSK+1),A
        LD (MSK2+1),A
        LD HL,(Lc675)
        DEC L
        LD E,(HL)
        XOR A
        SRL B
        RR E
        RRA
        SRL B
        RR E
        RRA
        SCF
        RR B
        RR E
        RRA
        ADD A,C
        LD IXL,A
        LD IXH,E
        LD HL,(Lc6c4)
        DEC L
        LD E,(HL)
        XOR A
        SRL D
        RR E
        RRA
        SRL D
        RR E
        RRA
        SCF
        RR D
        RR E
        RRA
        ADD A,C
        ADD A,#10
        LD IYL,A
        LD IYH,E
        LD H,high(L90k)
        LD (Lc66b+1),SP

        LD A,(Lc62d+1)
        LD E,A
        LD A,(Lc632+1)
        LD D,A
        CP E
        JP NC,Lc66b
        LD (BORD+1),A
        LD A,JMP2
        LD (JUMP+1),A

        LD A,D
        LD SP,#FFE0
        JP BORD


RETT
        EXX
        LD HL,0
        ADD HL,SP
        LD A,L
        LD (Adt+1),A
        EXX
Stkc    LD SP,0
        RET


;RENDER OBJ 2
Renobj2
        LD A,(Eye_b)
        LD B,A
        LD A,(Eyeb)
        SUB B
        LD B,A
        ADD A,#40
        LD H,Sintb
        LD L,A
        LD A,(HL) ;COS
        LD (Om1_11+1),A
        LD (Om2_11+1),A
        LD L,B
        LD A,(HL) ;SIN
        LD (Om1_13+1),A
        LD (Om2_13+1),A
        LD A,(Indx)
        LD L,A
        LD H,high(L97)
        LD A,(HL)
        INC L
        LD H,(HL)
        LD L,A
        INC HL
;MAKE JUMP FOR MULTIPLY
        LD B,(HL)
        RES 7,B
        LD A,#06
        SUB B
        LD (Jmp4+1),A
        LD (Jmp5+1),A
        LD (Jmp6+1),A

        INC HL

        LD (Stkc+1),SP

        LD SP,+(low(L9c)*256)+4

Ld534   LD A,(HL)
        INC HL
        OR A
        JR Z,RETT
        LD IXL,A
        LD B,(HL)
        INC HL
        LD C,(HL)
        INC HL
        LD D,(HL)
        INC HL

        LD (STORHL+1),HL

;REND FROM THIS DOT
;B,C,D-X,Y,Z
;LX-COLOR AND AMOUNT DOTS
        LD H,Multb
Om1_11  LD A,0
        SRA A
        LD L,B
        SRA L
        SUB L
        LD L,A
        ADD A,B
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
        EX AF,AF'
Om1_13  LD A,0
        SRA A
        LD L,D
        SRA L
        SUB L
        LD L,A
        ADD A,D
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
        LD L,B
        LD B,A
Om2_13  LD A,0
        NEG
        SRA A
        SRA L
        LD E,L
        SUB L
        LD L,A
        ADD A,E
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
        LD IXH,A
Om2_11  LD A,0
        SRA A
        LD L,D
        SRA L
        SUB L
        LD L,A
        ADD A,D
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
        LD IYH,A

;RENDER ITSSELF FROM DOT


        LD L,C
        LD H,B
        EX AF,AF'
        LD B,A

        ADD A,H
        LD H,A
        LD D,L
        LD (Xb0+1),HL
        EX AF,AF'

        RLC B
        RLC C

        LD A,H
        SUB B
        LD H,A
        LD (Xb1+1),HL

        LD A,L
        SUB C
        LD L,A
        LD (Xb2+1),HL


        EX AF,AF'
        LD H,A
        LD (Xb3+1),HL


;NEG
        NEG
        LD H,A
        LD E,H
        LD (Xb5+1),HL

        LD A,H
        ADD A,B
        LD H,A
        LD (Xb4+1),HL

        LD L,D
        LD (Xb7+1),HL

        LD H,E
        LD (Xb6+1),HL


        LD B,IXL
        LD A,IYH
        LD D,IXH
        ADD A,D
        LD IXH,A
        RLC D
        SUB D
        LD IYH,A
        LD IYL,A
        ADD A,D
        LD IXL,A
        NEG
        LD (Zb5+1),A
        ADD A,D
        LD (Zb4+1),A
        LD (Zb6+1),A
        SUB D
        LD (Zb7+1),A

Xb0     LD DE,0
        LD A,IXH
        BIT 0,B
        LD HL,$+6
        JP NZ,Calcd ;TAKE 1ST SET DOT
Xb1     LD DE,0
        LD A,IYH
        BIT 1,B
        LD HL,$+6
        JP NZ,Calcd ;REND OF Z
Xb2     LD DE,0
        LD A,IYL
        BIT 3,B
        LD HL,$+6
        JP NZ,Calcd ;REND OF X
        BIT 2,B
Xb3     LD DE,0
        LD A,IXL
        LD HL,$+6
        JP NZ,Calcd ;REND OF Z BACK
Xb4     LD DE,0
Zb6     LD A,0
        BIT 6,B
        LD HL,$+6
        JP NZ,Calcd ;REND OF Y
Xb5     LD DE,0
Zb7     LD A,0
        BIT 7,B
        LD HL,$+6
        JP NZ,Calcd ;REND OF Z
Xb6     LD DE,0
Zb5     LD A,0
        BIT 5,B
        LD HL,$+6
        JP NZ,Calcd ;REND OF X BACK
Xb7     LD DE,0
Zb4     LD A,0
        BIT 4,B
        LD HL,$+6
        JP NZ,Calcd ;NOT REND OF ZBACK

STORHL  LD HL,0
        JP Ld534



;CALCULATION DOTS FROM SETTING BITS MASK
;И ПEPEBOД 3D CORDS IN 2D CORDS
Calcd
        EXX
Tz      LD DE,0
        LD L,A
        RLCA
        AND 1
        NEG
        LD H,A
Jmp4    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        AND A
        ADC HL,DE

        JP M,Ld73d

        EX DE,HL
        EXX
        LD A,E
        EXX
        LD L,A
        RLCA
        AND 1
        NEG
        LD H,A
Ty      LD BC,0
Jmp5    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        AND A
        ADC HL,BC
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EX AF,AF'
;DIV
        LD A,D
        OR A
        JP Z,PP0
        XOR A
        SLL L
        RL H
        JR C,PP1
        SLL L
        RL H
        JR C,PP1+6
        SLL L
        RL H
        JR C,PP1+(6*2)
        SLL L
        RL H
        JR C,PP1+(6*3)
        SLL L
        RL H
        JR C,PP1+(6*4)
        SLL L
        RL H
        JR C,PP1+(6*5)
        SLL L
        RL H
        JR C,PP1+(6*6)
        SLL L
        RL H
        JR C,PP1+(6*7)
        SLL L
        RL H
        JR C,PP1+(6*8)
        SLL L
        RL H
        LD B,L
        JR C,+(PP1+(6*9))+1
        SLL L
        RL H
        JR C,+(PP1+(6*10))+1
        SLL L
        RL H
        JR C,+(PP1+(6*11))+1
        SLL L
        RL H
        JR C,+(PP1+(6*12))+1
        SLL L
        RL H
        JR C,+(PP1+(6*13))+1
        SLL L
        RL H
        JR C,+(PP1+(6*14))+1
        SLL L
        RL H
        JP C,+(PP1+(6*15))+1
;ZERO
        LD B,A
        JP PP9

PP1
        RLA
        CP D
        JR NC,PP2
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+7
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*2)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*3)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*4)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*5)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*6)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*7)
        ADC HL,HL
        RLA
        LD B,L
        CP D
        JR NC,PP2+(7*8)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*9)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*10)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*11)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*12)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*13)
        ADC HL,HL
        RLA
        CP D
        JR NC,PP2+(7*14)
        ADC HL,HL
        RLA
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+63)+(7*6)



PP2

        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP3
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+8
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+(8*2)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+(8*3)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+(8*4)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+(8*5)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+(8*6)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP PP4+(8*7)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+(8*8))-1

        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+63)+7
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+63)+(7*2)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+63)+(7*3)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+63)+(7*4)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(PP4+63)+(7*5)


PP0
        LD A,L
        LD L,H
        LD H,0
        SBC HL,DE
        JP NC,Ld73d
        ADD HL,DE
        RLA
        ADC HL,HL
PP3
        SBC HL,DE
        JP NC,Ld73d
        ADD HL,DE
        RLA
        ADC HL,HL
PP4
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
        ADD HL,HL
        LD B,A
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
PP9

        LD C,A
        EX AF,AF'
        LD HL,#30 ;MIDLE Y
        JP M,$+8
        SBC HL,BC
        JP $+4
        ADD HL,BC

        PUSH HL
        EXX
        LD A,D
        EXX
        LD L,A
        RLCA
        AND 1
        NEG
        LD H,A
Tx      LD BC,0
Jmp6    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        AND A
        ADC HL,BC
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EX AF,AF'
;DIV
        LD A,D
        OR A
        JP Z,O0
        XOR A
        SLL L
        RL H
        JR C,O1
        SLL L
        RL H
        JR C,O1+6
        SLL L
        RL H
        JR C,O1+(6*2)
        SLL L
        RL H
        JR C,O1+(6*3)
        SLL L
        RL H
        JR C,O1+(6*4)
        SLL L
        RL H
        JR C,O1+(6*5)
        SLL L
        RL H
        JR C,O1+(6*6)
        SLL L
        RL H
        JR C,O1+(6*7)
        SLL L
        RL H
        JR C,O1+(6*8)
        SLL L
        RL H
        LD B,L
        JR C,+(O1+(6*9))+1
        SLL L
        RL H
        JR C,+(O1+(6*10))+1
        SLL L
        RL H
        JR C,+(O1+(6*11))+1
        SLL L
        RL H
        JR C,+(O1+(6*12))+1
        SLL L
        RL H
        JR C,+(O1+(6*13))+1
        SLL L
        RL H
        JR C,+(O1+(6*14))+1
        SLL L
        RL H
        JP C,+(O1+(6*15))+1
;ZERO
        LD B,A
        JP O9

O1
        RLA
        CP D
        JR NC,O2
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+7
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*2)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*3)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*4)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*5)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*6)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*7)
        ADC HL,HL
        RLA
        LD B,L
        CP D
        JR NC,O2+(7*8)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*9)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*10)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*11)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*12)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*13)
        ADC HL,HL
        RLA
        CP D
        JR NC,O2+(7*14)
        ADC HL,HL
        RLA
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+63)+(7*6)



O2

        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O3
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+8
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+(8*2)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+(8*3)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+(8*4)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+(8*5)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+(8*6)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP O4+(8*7)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+(8*8))-1

        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+63)+7
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+63)+(7*2)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+63)+(7*3)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+63)+(7*4)
        LD C,A
        LD A,L
        LD L,H
        LD H,C
        JP +(O4+63)+(7*5)


O0
        LD A,L
        LD L,H
        LD H,0
        SBC HL,DE
        JP NC,Ld73c
        ADD HL,DE
        RLA
        ADC HL,HL
O3
        SBC HL,DE
        JP NC,Ld73c
        ADD HL,DE
        RLA
        ADC HL,HL
O4
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
        ADD HL,HL
        LD B,A
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
O9
        LD C,A
        EX AF,AF'
        LD HL,#0080 ;MIDLE X
        JP M,$+13
        SBC HL,BC
        PUSH HL
        LD HL,9
        ADD HL,SP
        LD SP,HL
        EXX
        JP (HL)
        ADD HL,BC
        PUSH HL
        LD HL,9
        ADD HL,SP
        LD SP,HL
        EXX
        JP (HL)

;ECЛИ BCЯKИE ПEPEПOЛHEHИЯ
Ld73d
        PUSH DE
        LD D,#80
        PUSH DE
        LD HL,9
        ADD HL,SP
        LD SP,HL
        EXX
        JP (HL)
Ld73c
        LD D,#80
        PUSH DE
        LD HL,9
        ADD HL,SP
        LD SP,HL
        EXX
        JP (HL)











;DRAW POLY
Drwpol
        LD A,(HL)
        AND A
        RET Z
        JP M,Ld8b2
        AND #0F
        LD B,A
        CALL Vspoly
        JP P,Ld8a5
        XOR A ;MAY BE VISIBLE POLY
        LD (L91+#5A),A
        CALL Lda9f
        JR C,Ld8aa
        CPL
        AND #F0
        JR NZ,Ld8aa
        LD A,(HL)
        INC HL
        DUP 4
            RRCA
        EDUP
        AND #07
        LD (L91+#1A),A
        LD A,C
        AND #0F
        JR NZ,Ld89a
        LD DE,+(low(L9e)*256)
        LD A,B
        ADD A,A
        LD (L91+#0A),A
        LD B,L9c
        RRCA
        EX AF,AF
        LD C,(HL)
        INC HL
        LD A,(BC)
        LD (DE),A
        INC E
        INC C
        INC C
        LD A,(BC)
        LD (DE),A
        INC E
        EX AF,AF
        DEC A
        JP NZ,$-13
        CALL Polygon
        JP Drwpol
Ld89a   CALL Clip
        CALL NC,Polygon
        JP Drwpol
Ld8a5   LD A,#01 ;UNVISIBLE POLY
        LD (L91+#5A),A
Ld8aa   INC B
        LD C,B
        LD B,#00
        ADD HL,BC
        JP Drwpol



;LINE DRAWING
Ld8b2   AND #0F
        LD B,A
        BIT 6,(HL)
        JR Z,Ld8bf ;ALWAYS VISIBLE
        LD A,(L91+#5A)
        AND A
        JR NZ,Ld8aa ;LAST POLY WAS
;UNVISIBLE
;IF LAST POLY VIS THAT LINES VIS TOO
Ld8bf   DEC B
        LD A,(HL)
        INC HL
        AND #30
        JR Z,Ld8d2 ;AND MASK
        CP #10
        JR Z,Ld8da ;OR MASK
;XOR MASK
;COMAND XOR C:JR C,
        LD DE,#38A9
        LD A,low(Ld1l)
        JP Ld8df
;COMAND AND C:JR NC,
Ld8d2   LD DE,#30A1
        LD A,low(Ld1l)+8
        JP Ld8df
;COMAND OR C :JR C,
Ld8da   LD DE,#38B1
        LD A,low(Ld1l)
Ld8df   LD (L91+#4E),DE
        LD (Ldadd),A
        LD IXH,L9c
        LD A,(HL)
        LD IXL,A
        INC HL
        LD E,(IX+#00)
        LD D,(IX+#01)
        LD (L91+#3E),DE
        LD E,(IX+#02)
        LD D,(IX+#03)
        LD (L91+#4A),DE
        LD A,(IX+#04)
        LD (L91+#4D),A
Ld907   LD A,(HL)
        LD IXL,A
        INC HL
        PUSH BC
        PUSH HL
        LD HL,(L91+#3E)
        LD (L91+#3A),HL
        LD HL,(L91+#4A)
        LD (L91+#3C),HL
        LD A,(L91+#4D)
        LD (L91+#4C),A
        LD B,A
        LD E,(IX+#00)
        LD D,(IX+#01)
        LD (L91+#3E),DE
        LD E,(IX+#02)
        LD D,(IX+#03)
        LD (L91+#4A),DE
        AND A
        LD A,(IX+#04)
        LD (L91+#4D),A
        JR Z,Ld967
        AND A
        JR Z,Ld967
        OR B
        LD B,A
        CPL
        AND #F0
        JR NZ,Ld967
        LD A,B
        AND #0F
        JR NZ,Ld96e
        LD A,(L91+#3A)
        LD (L91+#2A),A
        LD A,(L91+#3C)
        LD (L91+#2B),A
        LD A,(L91+#3E)
        LD (L91+#2C),A
        LD A,(L91+#4A)
        LD (L91+#2D),A
Ld964   CALL Drwlin ;LDABE
Ld967   POP HL
        POP BC
        DJNZ Ld907
        JP Drwpol
Ld96e   LD HL,(L91+#3A)
        LD (L91+#0B),HL
        LD HL,(L91+#3C)
        LD (L91+#0D),HL
        LD A,(L91+#4C)
        LD (L91+#0F),A
        LD HL,(L91+#3E)
        LD (L91+#1B),HL
        LD HL,(L91+#4A)
        LD (L91+#1D),HL
        LD A,(L91+#4D)
        LD (L91+#1F),A
        PUSH IX
        CALL CLIPLIN
        POP IX
        JR NZ,Ld967
        LD HL,L9e*256
        LD A,(HL)
        INC L
        LD (L91+#2A),A
        LD A,(HL)
        INC L
        LD (L91+#2B),A
        LD A,(HL)
        INC L
        LD (L91+#2C),A
        LD A,(HL)
        LD (L91+#2D),A
        JP Ld964




Drwpol2
        LD A,(HL)
        AND A
        RET Z
        JP M,Ld9ea
        AND #0F
        LD B,A
        CALL Vspoly
        JP P,Ld9dd
        XOR A
        LD (L91+#5A),A
        LD A,(HL)
        INC HL
        DUP 4
            RRCA
        EDUP
        AND #07
        LD (L91+#1A),A
        LD DE,+(low(L9e)*256)
        LD A,B
        ADD A,A
        LD (L91+#0A),A
        LD B,L9c
        RRCA
        EX AF,AF
        LD C,(HL)
        INC HL
        LD A,(BC)
        LD (DE),A
        INC E
        INC C
        INC C
        LD A,(BC)
        LD (DE),A
        INC E
        EX AF,AF
        DEC A
        JP NZ,$-13
        CALL Polygon
        JP Drwpol2
Ld9dd   LD A,#01
        LD (L91+#5A),A
Ld9e2   INC B
        LD C,B
        LD B,#00
        ADD HL,BC
        JP Drwpol2
Ld9ea   AND #0F
        LD B,A
        BIT 6,(HL)
        JR Z,Ld9f7
        LD A,(L91+#5A)
        AND A
        JR NZ,Ld9e2
Ld9f7   DEC B
        LD A,(HL)
        INC HL
        AND #30
        JR Z,Lda0a
        CP #10
        JR Z,Lda12
        LD DE,#38A9
        LD A,low(Ld1l)
        JP Lda17
Lda0a   LD DE,#30A1
        LD A,low(Ld1l)+8
        JP Lda17
Lda12   LD DE,#38B1
        LD A,low(Ld1l)
Lda17   LD (L91+#4E),DE
        LD (Ldadd),A
        LD D,L9c
        LD E,(HL)
        INC HL
        LD A,(DE)
        LD (L91+#2C),A
        INC E
        INC E
        LD A,(DE)
        LD (L91+#2D),A
Lda2c   LD D,L9c
        LD E,(HL)
        INC HL
        PUSH BC
        PUSH HL
        LD HL,(L91+#2C)
        LD (L91+#2A),HL
        LD A,(DE)
        LD (L91+#2C),A
        INC E
        INC E
        LD A,(DE)
        LD (L91+#2D),A
        CALL Drwlin ;LDABE
        POP HL
        POP BC
        DJNZ Lda2c
        JP Drwpol2
Lda9f   LD IXL,B
        PUSH HL
        EX DE,HL
        INC DE
        LD H,L9c
        LD C,#00
Ldaa8   LD A,(DE)
        INC DE
        ADD A,#04
        LD L,A
        LD A,(HL)
        AND A
        JR Z,Ldab9
        OR C
        LD C,A
        DJNZ Ldaa8
        POP HL
        LD B,IXL
        RET
Ldab9   SCF
        POP HL
        LD B,IXL
        RET



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
