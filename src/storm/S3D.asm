; S3D -- restored from awk2/S3D.C (5269 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
        INCLUDE "EQUS.asm"



        ORG #FF00
        JP INIT_ ;ИНИТ 3D
        JP OUTAL2_ ;ВЫВОД 3D
        JP NXTO_ ;ДЛЯ ВЫХОДА ИЗ ВОКСЕЛЕЙ
        DW ADI3D_ ;ТАБЛИЦА АДРЕСОВ ОБЪЕКТ
        JP Moveon ;ВЫЧИСЛ. ПРИРАШ. ИЗМЕН
        JP Precord ;ИЗМ. КООРД. ОБЪЕКТОВ
        JP Nulmove ;ОЧИСТ.ПРИРАЩЕНИЯ ИЗМ.
        JP Fline ;РИСОВАТЬ ЛАЗЕР ИГРОКА


        ORG #C000
L90k
        INCBIN "assets/D9000.bin"

Eye_a   EQU #C200
Eye_b   EQU #C201
Eye_g   EQU #C202
Eyea    EQU #C203
Eyeb    EQU #C204
Eyeg    EQU #C205

L91     EQU #C221
L90     EQU #C200

        DS #0100

Multb   EQU high($)
Sintb   EQU Multb+1
        INCBIN "assets/D9200.bin"
L9c     EQU high($)
        DS #0100
L9d     EQU high($)
        DS #0100
L9e     EQU high($)
        DS #0100
;TAБЛИЦA ДЛЯ ПOДCEЧETA KOPHЯ
;ПEPBЫЙ БAЙT KOPEHЬ И3 "kpУГЛoГo" ЧИCЛA
;BTOP. CЛOBO ИHBEPTHУTOE ПO 3HAKУ ЧИCЛO
; KAK OCTATOK
Korn
        INCBIN "assets/korni.bin"


        INCLUDE "XR2.asm"


        ORG (($+255)&#FF00)
L95
        DB low(Lceb1)
        DB low(Lcdf6)
        DB low(Lcdcd)
        DB 0
        DB low(Lcda4)
        DB low(Lc903)
        DB low(Lc91d)
        DB 0
        DB low(Lcd7b)
        DB low(Lc937)
        DB low(Lc951)
        DB 0, 0, 2, 0, 1
        DB low(Lc96b)
        DB low(Lc902)
        DB low(Lc971)
        DB 0
        DB low(Lc977)
        DB low(Lc912)
        DB low(Lc989)
        DB 0
        DB low(Lc9a1)
        DB low(Lc9b3)
        DB low(Lc9ba)
        DB 0, 0, 0, 0, 0
        DB low(Lc9cc)
        DB low(Lc9d2)
        DB low(Lc902)
        DB 0
        DB low(Lc9d8)
        DB low(Lc9ea)
        DB low(Lc9fc)
        DB 0
        DB low(Lca03)
        DB low(Lca15)
        DB low(Lc960)
        DS 21
        DB low(Lca2d)
        DB low(Lca33)
        DB low(Lca45)
        DB 0
        DB low(Lc902)
        DB low(Lca57)
        DB low(Lc92c)
        DB 0
        DB low(Lca5e)
        DB low(Lca64)
        DB low(Lca79)
        DB 0, 0, 0, 0, 0
        DB low(Lca94)
        DB low(Lcab0)
        DB low(Lcab7)
        DB 0
        DB low(Lcad6)
        DB low(Lc902)
        DB low(Lcae1)
        DB 0
        DB low(Lcae7)
        DB low(Lcec8)
        DB low(Lcafc)
        DB 0, 0, 0, #0A, #90
        DB low(Lcb15)
        DB low(Lcb31)
        DB low(Lcb46)
        DB 0
        DB low(Lcb51)
        DB low(Lcec8)
        DB low(Lc902)
        DB 0
        DB low(Lcb58)
        DB low(Lcb77)
        DB low(Lcb90)
        DS 21
        DB low(Lcb96)
        DB low(Lcb9c)
        DB low(Lcbae)
        DB 0
        DB low(Lcbc0)
        DB low(Lcbc6)
        DB low(Lcbe1)
        DB 0
        DB low(Lc902)
        DB low(Lc946)
        DB low(Lcbf6)
        DB 0, #82, #72, #3C, #7F
        DB low(Lcbfd)
        DB low(Lcc19)
        DB low(Lcc24)
        DB 0
        DB low(Lcc39)
        DB low(Lcc58)
        DB low(Lcc5e)
        DB 0
        DB low(Lcc77)
        DB low(Lc902)
        DB low(Lcec8)
        DB #15, #0A, #1C, #1D, #A4
        DB low(Lcc7e)
        DB low(Lcc9a)
        DB low(Lccb9)
        DB 0
        DB low(Lccc0)
        DB low(Lccd5)
        DB low(Lcec8)
        DB 0
        DB low(Lccee)
        DB low(Lccf9)
        DB low(Lc902)

        ORG (($+255)&#FF00)
L96
        DB high(Lceb1)
        DB high(Lcdf6)
        DB high(Lcdcd)
        DB 0
        DB high(Lcda4)
        DB high(Lc903)
        DB high(Lc91d)
        DB 0
        DB high(Lcd7b)
        DB high(Lc937)
        DB high(Lc951)
        DB 0, 0, 0, 0, 0
        DB high(Lc96b)
        DB high(Lc902)
        DB high(Lc971)
        DB 0
        DB high(Lc977)
        DB high(Lc912)
        DB high(Lc989)
        DB 0
        DB high(Lc9a1)
        DB high(Lc9b3)
        DB high(Lc9ba)
        DB 0, #55, 1, 0, 0
        DB high(Lc9cc)
        DB high(Lc9d2)
        DB high(Lc902)
        DB 0
        DB high(Lc9d8)
        DB high(Lc9ea)
        DB high(Lc9fc)
        DB 0
        DB high(Lca03)
        DB high(Lca15)
        DB high(Lc960)
        DS 21
        DB high(Lca2d)
        DB high(Lca33)
        DB high(Lca45)
        DB 0
        DB high(Lc902)
        DB high(Lca57)
        DB high(Lc92c)
        DB 0
        DB high(Lca5e)
        DB high(Lca64)
        DB high(Lca79)
        DB 0, 0, 2, 0, 0
        DB high(Lca94)
        DB high(Lcab0)
        DB high(Lcab7)
        DB 0
        DB high(Lcad6)
        DB high(Lc902)
        DB high(Lcae1)
        DB 0
        DB high(Lcae7)
        DB high(Lcec8)
        DB high(Lcafc)
        DB 0, 0, 0, 0, 0
        DB high(Lcb15)
        DB high(Lcb31)
        DB high(Lcb46)
        DB 0
        DB high(Lcb51)
        DB high(Lcec8)
        DB high(Lc902)
        DB 0
        DB high(Lcb58)
        DB high(Lcb77)
        DB high(Lcb90)
        DS 21
        DB high(Lcb96)
        DB high(Lcb9c)
        DB high(Lcbae)
        DB 0
        DB high(Lcbc0)
        DB high(Lcbc6)
        DB high(Lcbe1)
        DB 0
        DB high(Lc902)
        DB high(Lc946)
        DB high(Lcbf6)
        DB #20, #B2, 0, 0, #64
        DB high(Lcbfd)
        DB high(Lcc19)
        DB high(Lcc24)
        DB 0
        DB high(Lcc39)
        DB high(Lcc58)
        DB high(Lcc5e)
        DB 0
        DB high(Lcc77)
        DB high(Lc902)
        DB high(Lcec8)
        DB 0, 0, 0, 0, 0
        DB high(Lcc7e)
        DB high(Lcc9a)
        DB high(Lccb9)
        DB 0
        DB high(Lccc0)
        DB high(Lccd5)
        DB high(Lcec8)
        DB 0
        DB high(Lccee)
        DB high(Lccf9)
        DB high(Lc902)
        DB 0, 0, 0, 0, 0

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






        INCLUDE "XCLP.asm"
        INCLUDE "XR1.asm"


OUTAL2_
        LD A,(Cmode+1)
        OR A
        JR NZ,OO1
        LD A,(SPEED)
        OR A
        LD H,#00
        JP P,$+4
        DEC H
        LD L,A
        DUP 6
            ADD HL,HL
        EDUP
        LD (Speed),HL
OO1
        LD A,(UNGLE)
        LD C,A
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
        CALL Touch ;GOING THROUGH STA
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
        LD A,(Cmode+1)
        OR A
        RET NZ
        LD A,4
        LD (Cmode+1),A
        LD A,(SPEED)
        NEG
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

NEGHL   LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        RET




;YOUR TURNS
Calcstp
        LD A,(Sm_13+1)
        LD DE,(Speed)
        LD IX,$+7
        JP MULL
        LD (XPL+1),HL
        BIT 7,H
        LD DE,(XXP)
        ADD HL,DE
        LD (XXP),HL
        LD A,(XXP+2)
        JR Z,$+6
        SBC A,0
        JR $+4
        ADC A,0
        LD (XXP+1),A
        LD A,(Sm_23+1)
        LD DE,(Speed)
        LD IX,$+7
        JP MULL
        LD (YPL+1),HL
        BIT 7,H
        LD DE,(YYP)
        ADD HL,DE
        LD (YYP),HL
        LD A,(YYP+2)
        JR Z,$+6
        SBC A,0
        JR $+4
        ADC A,0
        LD (YYP+1),A
        LD A,(Sm_33+1)
        LD DE,(Speed)
        LD IX,$+7
        JP MULL
        LD (ZPL+1),HL
        BIT 7,H
        LD DE,(ZZP)
        ADD HL,DE
        LD (ZZP),HL
        LD A,(ZZP+2)
        JR Z,$+6
        SBC A,0
        JR $+4
        ADC A,0
        LD (ZZP+1),A
        RET






Korni
;DE-CTAPШAЯ ЧACTЬ ЧИCЛA
;RET A-MEAN
        LD A,D
        AND A
        JR Z,Kor
        LD L,A
        LD H,high(Korn)
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
        DUP 5
            ADD HL,BC
            RET NC
            DEC BC
            DEC BC
            INC A
        EDUP
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
        DUP 14
            ADD HL,BC
            RET NC
            INC A
            DEC BC
            DEC BC
        EDUP
        ADD HL,BC
        RET NC
        INC A
        RET





Vsline
;CHECK WISIBILITY OF LINE
;CORDS OF LINE IN CORDLINE BUFER
        LD HL,+(L9c*256)+1
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
        JP M,$+16
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
        LD B,(HL) ;SIN A
        ADD A,#40
        LD L,A
        LD C,(HL) ;COS A
Eyeb_   LD A,0
        LD L,A
        LD A,(HL) ;SIN B
        LD IXL,A
        LD A,L
        ADD A,#40
        LD L,A
        LD A,(HL) ;COS B
        LD IYL,A
Eyeg_   LD A,0
        LD L,A
        LD A,(HL) ;SIN G
        LD D,A
        LD A,L
        ADD A,#40
        LD L,A
        LD E,(HL) ;COS G
        LD H,Multb
        LD A,IXL
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
        LD A,IYL
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
        LD IXH,A
        LD A,IXL
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
        SUB IXH
        JP PO,$+9
        NEG
        JP PO,$+4
        DEC A
        LD (Hm_23+1),A
        LD A,IYL
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
        LD IXH,A ;CB*CA
        LD A,IXL
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
        ADD A,IXH
        JP PO,$+9
        NEG
        JP PO,$+4
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
        LD ((L9c*256)+2),DE
        EXX
        CALL Clc2d3d
        RET NZ
        LD ((L9c*256)+5),HL
        LD ((L9c*256)+7),DE
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
        JP Drwpol2 ;DRAW POLY.
Masklin
        DB %10110010, 0, 5, 0







;И3MEHЯEM KOOPДИHATЫ,3ABИ. ДBИЖEHИЯ
Precord
        LD (Stk1+1),SP
        LD L,(IX+Indi)
        LD H,high(L97)
        LD SP,HL
        POP HL
        INC HL
        LD B,(HL)
        BIT 7,B
        JP NZ,Stk1
        RES 7,B
        LD A,#06
        SUB B
        LD HL,100
        LD ($+4),A
        JR $
        DUP 5
            ADD HL,HL
        EDUP
        LD A,Spacebd
        SUB H
        LD B,A
        LD A,IXL
        LD L,A
        LD A,IXH
        LD H,A
        LD SP,HL
Stpx_   LD HL,0
        POP DE
        OR A
        ADC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes

XPL     LD DE,0
        OR A
        SBC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes

        PUSH HL
Stpy_   LD HL,0
        INC SP
        INC SP
        POP DE
        OR A
        ADC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes

YPL     LD DE,0
        OR A
        SBC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes

        PUSH HL
Stpz_   LD HL,0
        INC SP
        INC SP
        POP DE
        OR A
        ADC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes

ZPL     LD DE,0
        OR A
        SBC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
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

        INCLUDE "BLOK1.asm"


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
        INCLUDE "OBJX.asm"

END_
