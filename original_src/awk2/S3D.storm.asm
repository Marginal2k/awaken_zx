        INCL "EQUS"



        ORG #FF00
        JP INIT_;ИНИТ 3D
        JP OUTAL2_;ВЫВОД 3D
        JP NXTO_;ДЛЯ ВЫХОДА ИЗ ВОКСЕЛЕЙ
        DW ADI3D_;ТАБЛИЦА АДРЕСОВ ОБЪЕКТ
        JP Moveon;ВЫЧИСЛ. ПРИРАШ. ИЗМЕН
        JP Precord;ИЗМ. КООРД. ОБЪЕКТОВ
        JP Nulmove;ОЧИСТ.ПРИРАЩЕНИЯ ИЗМ.
        JP Fline;РИСОВАТЬ ЛАЗЕР ИГРОКА


        ORG #C000
L90k
        INCB "D9000"

Eye_a   EQU #C200
Eye_b   EQU #C201
Eye_g   EQU #C202
Eyea    EQU #C203
Eyeb    EQU #C204
Eyeg    EQU #C205

L91     EQU #C221
L90     EQU #C200

        DS #0100

Multb   EQU $[
Sintb   EQU Multb+1
        INCB "D9200"
L9c     EQU $[
        DS #0100
L9d     EQU $[
        DS #0100
L9e     EQU $[
        DS #0100
;TAБЛИЦA ДЛЯ ПOДCEЧETA KOPHЯ
;ПEPBЫЙ БAЙT KOPEHЬ И3 "kpУГЛoГo" ЧИCЛA
;BTOP. CЛOBO ИHBEPTHУTOE ПO 3HAKУ ЧИCЛO
; KAK OCTATOK
Korn
        INCB "korni"


        INCL "XR2"


        ORG $^
L95
        DB Lceb1]
        DB Lcdf6]
        DB Lcdcd]
        DB 0
        DB Lcda4]
        DB Lc903]
        DB Lc91d]
        DB 0
        DB Lcd7b]
        DB Lc937]
        DB Lc951]
        DB 0,0,2,0,1
        DB Lc96b]
        DB Lc902]
        DB Lc971]
        DB 0
        DB Lc977]
        DB Lc912]
        DB Lc989]
        DB 0
        DB Lc9a1]
        DB Lc9b3]
        DB Lc9ba]
        DB 0,0,0,0,0
        DB Lc9cc]
        DB Lc9d2]
        DB Lc902]
        DB 0
        DB Lc9d8]
        DB Lc9ea]
        DB Lc9fc]
        DB 0
        DB Lca03]
        DB Lca15]
        DB Lc960]
        DS 21
        DB Lca2d]
        DB Lca33]
        DB Lca45]
        DB 0
        DB Lc902]
        DB Lca57]
        DB Lc92c]
        DB 0
        DB Lca5e]
        DB Lca64]
        DB Lca79]
        DB 0,0,0,0,0
        DB Lca94]
        DB Lcab0]
        DB Lcab7]
        DB 0
        DB Lcad6]
        DB Lc902]
        DB Lcae1]
        DB 0
        DB Lcae7]
        DB Lcec8]
        DB Lcafc]
        DB 0,0,0,#0A,#90
        DB Lcb15]
        DB Lcb31]
        DB Lcb46]
        DB 0
        DB Lcb51]
        DB Lcec8]
        DB Lc902]
        DB 0
        DB Lcb58]
        DB Lcb77]
        DB Lcb90]
        DS 21
        DB Lcb96]
        DB Lcb9c]
        DB Lcbae]
        DB 0
        DB Lcbc0]
        DB Lcbc6]
        DB Lcbe1]
        DB 0
        DB Lc902]
        DB Lc946]
        DB Lcbf6]
        DB 0,#82,#72,#3C,#7F
        DB Lcbfd]
        DB Lcc19]
        DB Lcc24]
        DB 0
        DB Lcc39]
        DB Lcc58]
        DB Lcc5e]
        DB 0
        DB Lcc77]
        DB Lc902]
        DB Lcec8]
        DB #15,#0A,#1C,#1D,#A4
        DB Lcc7e]
        DB Lcc9a]
        DB Lccb9]
        DB 0
        DB Lccc0]
        DB Lccd5]
        DB Lcec8]
        DB 0
        DB Lccee]
        DB Lccf9]
        DB Lc902]

        ORG $^
L96
        DB Lceb1[
        DB Lcdf6[
        DB Lcdcd[
        DB 0
        DB Lcda4[
        DB Lc903[
        DB Lc91d[
        DB 0
        DB Lcd7b[
        DB Lc937[
        DB Lc951[
        DB 0,0,0,0,0
        DB Lc96b[
        DB Lc902[
        DB Lc971[
        DB 0
        DB Lc977[
        DB Lc912[
        DB Lc989[
        DB 0
        DB Lc9a1[
        DB Lc9b3[
        DB Lc9ba[
        DB 0,#55,1,0,0
        DB Lc9cc[
        DB Lc9d2[
        DB Lc902[
        DB 0
        DB Lc9d8[
        DB Lc9ea[
        DB Lc9fc[
        DB 0
        DB Lca03[
        DB Lca15[
        DB Lc960[
        DS 21
        DB Lca2d[
        DB Lca33[
        DB Lca45[
        DB 0
        DB Lc902[
        DB Lca57[
        DB Lc92c[
        DB 0
        DB Lca5e[
        DB Lca64[
        DB Lca79[
        DB 0,0,2,0,0
        DB Lca94[
        DB Lcab0[
        DB Lcab7[
        DB 0
        DB Lcad6[
        DB Lc902[
        DB Lcae1[
        DB 0
        DB Lcae7[
        DB Lcec8[
        DB Lcafc[
        DB 0,0,0,0,0
        DB Lcb15[
        DB Lcb31[
        DB Lcb46[
        DB 0
        DB Lcb51[
        DB Lcec8[
        DB Lc902[
        DB 0
        DB Lcb58[
        DB Lcb77[
        DB Lcb90[
        DS 21
        DB Lcb96[
        DB Lcb9c[
        DB Lcbae[
        DB 0
        DB Lcbc0[
        DB Lcbc6[
        DB Lcbe1[
        DB 0
        DB Lc902[
        DB Lc946[
        DB Lcbf6[
        DB #20,#B2,0,0,#64
        DB Lcbfd[
        DB Lcc19[
        DB Lcc24[
        DB 0
        DB Lcc39[
        DB Lcc58[
        DB Lcc5e[
        DB 0
        DB Lcc77[
        DB Lc902[
        DB Lcec8[
        DB 0,0,0,0,0
        DB Lcc7e[
        DB Lcc9a[
        DB Lccb9[
        DB 0
        DB Lccc0[
        DB Lccd5[
        DB Lcec8[
        DB 0
        DB Lccee[
        DB Lccf9[
        DB Lc902[
        DB 0,0,0,0,0

;BCЯKИE MACKИ
Ld1l
        DW #4080
        DW #1020
        DW #0408
        DW #0102
        DW #BF7F
        DW #EFDF
        DW #FBF7
        DW #FEFD




Sets2   DB 0
Sets    DB 0
Indx    DB 0
Objx    DW 0
Objy    DW 0
Objz    DW 0
Speed   DW 0

Indt1   DB 0
Indt2   DB 0






        INCL "XCLP"
        INCL "XR1"


OUTAL2_
        LD A,(Cmode+1):OR A
        JR NZ,OO1
        LD A,(SPEED)
        OR A:LD H,#00:CALL P,$+4:DEC H
        LD L,A
.6      ADD HL,HL
        LD (Speed),HL
OO1
        LD A,(UNGLE):LD C,A
        LD A,(Eye_b)
        ADD A,C
        LD (Eye_b),A
        CALL Moveu
        CALL Ren3d
        CALL MERZ
        RET



;ПPOЦEДУPЫ УПPABЛEHИЯ KOPAБЛEM, OПPEДEЛ
;EHИE EГO
;CTOЛKHOBEHИЙ

Moveu
        CALL Touch;GOING THROUGH STA
;T OBJECTS
        JP Calcstp
Touch
Cmode   LD A,0
        DEC A
        RET M
        LD (Cmode+1),A
        RET
Lm1
;СТОЛКНОВЕНИЕ С ОБЪЕКТОМ
        LD A,(Cmode+1):OR A:RET NZ
        LD A,4
        LD (Cmode+1),A
        LD A,(SPEED):NEG
        LD (SPEED),A
        LD HL,(Speed)
        CALL NEGHL
        LD (Speed),HL
        LD HL,(XPL+1)
        CALL NEGHL
        LD (XPL+1),HL
        LD HL,(YPL+1)
        CALL NEGHL
        LD (YPL+1),HL
        LD HL,(ZPL+1)
        CALL NEGHL
        LD (ZPL+1),HL
        RET

NEGHL   LD A,L:CPL:LD L,A
        LD A,H:CPL:LD H,A:INC HL:RET




;YOUR TURNS
Calcstp
        LD A,(Sm_13+1)
        LD DE,(Speed)
        LD IX,$+7
        JP MULL
        LD (XPL+1),HL
        BIT 7,H
        LD DE,(XXP):ADD HL,DE
        LD (XXP),HL
        LD A,(XXP+2)
        JR Z,$+6:SBC A,0
        JR $+4:ADC A,0
        LD (XXP+1),A
        LD A,(Sm_23+1)
        LD DE,(Speed)
        LD IX,$+7
        JP MULL
        LD (YPL+1),HL
        BIT 7,H
        LD DE,(YYP):ADD HL,DE
        LD (YYP),HL
        LD A,(YYP+2)
        JR Z,$+6:SBC A,0
        JR $+4:ADC A,0
        LD (YYP+1),A
        LD A,(Sm_33+1)
        LD DE,(Speed)
        LD IX,$+7
        JP MULL
        LD (ZPL+1),HL
        BIT 7,H
        LD DE,(ZZP):ADD HL,DE
        LD (ZZP),HL
        LD A,(ZZP+2)
        JR Z,$+6:SBC A,0
        JR $+4:ADC A,0
        LD (ZZP+1),A
        RET






Korni
;DE-CTAPШAЯ ЧACTЬ ЧИCЛA
;RET A-MEAN
        LD A,D
        AND A
        JR Z,Kor
        LD L,A
        LD H,Korn[
        LD A,(HL)
        INC H
        LD C,A
        CPL
        EX AF,AF
        LD B,#FF
        INC BC
        SLA C
        RL B
        DEC BC
        LD A,(HL)
        INC H
        LD H,(HL)
        LD L,A
        EX AF,AF
        ADD HL,DE
.5      ADD HL,BC:RET NC:DEC BC,BC:INC A
        ADD HL,BC
        RET NC
        INC A
        RET
Kor
;ПOДCЧET KOPHЯ БE3 TAБЛИЦЫ, ДЛЯ MAЛEHЬK
;ИX ДAHHЫX
;DE-DATA <2116
;A-MEAN
        EX DE,HL
        LD BC,0-1
        XOR A
.14     ADD HL,BC:RET NC:INC A:DEC BC,BC
        ADD HL,BC
        RET NC
        INC A
        RET





Vsline
;CHECK WISIBILITY OF LINE
;CORDS OF LINE IN CORDLINE BUFER
        LD HL,L9c*256+1
        XOR A
        EX AF,AF
        LD B,10
Ld84    LD C,#00
        LD A,(HL)
        INC L
        INC L
        CP #80
        JR Z,Ld85
        JR NC,$+9
        AND A
        JP NZ,$+11
        JP $+10
        SET 1,C
        JP $+5
        SET 0,C
        LD A,(HL)
        AND A
        CALL M,$+16
        JP NZ,$+18
        DEC L
        LD A,(HL)
        INC L
        CP #60
        JR NC,$+10
        JP $+10
        SET 3,C
        JP $+5
        SET 2,C
        INC L
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
Ld83    INC L
        LD A,L
        INC L
        CP B
        JP NZ,Ld84
        EX AF,AF
        RET
Ld85    INC L
        LD (HL),C
        JP Ld83





Shmtrx
;CALC SHIP MATRIX VECTOR
Eyea_   LD A,0
        LD H,Sintb
        LD L,A
        LD B,(HL);SIN A
        ADD A,#40
        LD L,A
        LD C,(HL);COS A
Eyeb_   LD A,0
        LD L,A
        LD A,(HL);SIN B
        LD LX,A
        LD A,L
        ADD A,#40
        LD L,A
        LD A,(HL);COS B
        LD LY,A
Eyeg_   LD A,0
        LD L,A
        LD A,(HL);SIN G
        LD D,A
        LD A,L
        ADD A,#40
        LD L,A
        LD E,(HL);COS G
        LD H,Multb
        LD A,LX
        SRA A
        LD L,E
        SRA L
        SUB L
        LD L,A
        ADD A,E
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
        LD (Hm_13+1),A
        LD A,LY
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
        LD HX,A
        LD A,LX
        SRA A
        LD L,C
        SRA L
        SUB L
        LD L,A
        ADD A,C
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
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
        SUB HX
        CALL PO,$+9
        NEG
        CALL PO,$+4
        DEC A
        LD (Hm_23+1),A
        LD A,LY
        SRA A
        LD L,C
        SRA L
        SUB L
        LD L,A
        ADD A,C
        LD E,(HL)
        LD L,A
        LD A,(HL)
        SUB E
        LD HX,A;CB*CA
        LD A,LX
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
        ADD A,HX
        CALL PO,$+9
        NEG
        CALL PO,$+4
        DEC A
        LD (Hm_33+1),A
        RET






;------------------------
;BЫBOД ЛИHИИ B 3D ПPOCTPAHCTBE
;------------------------
Outline
;DE-Z1,HL-Y1,BC-X1
;DE'-Z2,HL'-Y2,BC'-X2
        CALL Clc2d3d
        RET NZ
        LD (L9c*256),HL
        LD (L9c*256+2),DE
        EXX
        CALL Clc2d3d
        RET NZ
        LD (L9c*256+5),HL
        LD (L9c*256+7),DE
        EXX
        CALL Vsline
        RET Z
        LD B,A
        CPL
        AND #F0
        RET NZ
        LD A,B
        AND #0F
        LD HL,Masklin
        JP NZ,Drwpol
        JP Drwpol2;DRAW POLY.
Masklin
        DB %10110010,0,5,0







;И3MEHЯEM KOOPДИHATЫ,3ABИ. ДBИЖEHИЯ
Precord
        LD (Stk1+1),SP
        LD L,(IX+Indi)
        LD H,L97[
        LD SP,HL
        POP HL
        INC HL
        LD B,(HL):BIT 7,B:JP NZ,Stk1
        RES 7,B
        LD A,#06
        SUB B
        LD HL,100
        LD ($+4),A
        JR $
.5      ADD HL,HL
        LD A,Spacebd
        SUB H
        LD B,A
        LD A,LX
        LD L,A
        LD A,HX
        LD H,A
        LD SP,HL
Stpx_   LD HL,0
        POP DE
        OR A
        ADC HL,DE
        CALL PE,Exes
        LD A,H:CALL P,$+4:CPL:CP B
        JR NC,Exes

XPL     LD DE,0
        OR A:SBC HL,DE
        CALL PE,Exes
        LD A,H:CALL P,$+4:CPL:CP B
        JR NC,Exes

        PUSH HL
Stpy_   LD HL,0
        INC SP
        INC SP
        POP DE
        OR A
        ADC HL,DE
        CALL PE,Exes
        LD A,H:CALL P,$+4:CPL:CP B
        JR NC,Exes

YPL     LD DE,0
        OR A:SBC HL,DE
        CALL PE,Exes
        LD A,H:CALL P,$+4:CPL:CP B
        JR NC,Exes

        PUSH HL
Stpz_   LD HL,0
        INC SP
        INC SP
        POP DE
        OR A
        ADC HL,DE
        CALL PE,Exes
        LD A,H:CALL P,$+4:CPL:CP B
        JR NC,Exes

ZPL     LD DE,0
        OR A:SBC HL,DE
        CALL PE,Exes
        LD A,H:CALL P,$+4:CPL:CP B
        JR NC,Exes

        PUSH HL
Stk1    LD SP,0
        RET
Exes
;ЕСЛИ ОБЪЕКТ ЗА ГРАНИЦЕЙ
        LD (IX+0),0
        LD (IX+1),#80
        LD (IX+Setup),#FF
        LD SP,(Stk1+1)
        RET

;ЗАДАНИЕ СМЕЩЕНИЙ В 0
Nulmove
        LD HL,0
        LD (Stpx_+1),HL
        LD (Stpy_+1),HL
        LD (Stpz_+1),HL
        RET

        INCL "BLOK1"


;ИHДEKCHAЯ TAБЛИЦA OБЪEKTOB
ADI3D_
        DW Sturm
        DW Sturm
        DW Istr
        DW Istr
        DW Turi
        DW Turi
        DW Trad
        DW Trad

        ORG ADI3D_+#80
        DW DREVO1
        DW DREVO1
        DW DREVO2
        DW DREVO2
        DW DOM1
        DW DOM1


;ДAHHЫE OБЪEKTOB
Objcts
        INCL "OBJX"

END

