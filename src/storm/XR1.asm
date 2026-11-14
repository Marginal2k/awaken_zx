; XR1 -- restored from awk2/XR1.C (4272 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
MULL
        LD L,A
        XOR D
        EX AF,AF
        BIT 7,D
        JR Z,$+9
        LD A,E
        CPL
        LD E,A
        LD A,D
        CPL
        LD D,A
        INC DE
        LD A,L
        AND A
        JP P,$+5
        NEG
        LD C,#00
        LD H,C
        LD L,C
        ADD A,A
        ADD A,A
        JR C,$+23
        ADD A,A
        JR C,$+26
        ADD A,A
        JR C,$+29
        ADD A,A
        JR C,$+32
        ADD A,A
        JR C,$+35
        ADD A,A
        JR C,$+38
        ADD A,A
        JR C,$+41
        JP $+45
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        LD L,H
        LD H,A
        EX AF,AF
        JP P,RET_
        EX DE,HL
        LD HL,#00
        SBC HL,DE
RET_    JP (IX)



Calcrc
;ПOBEPHУTЬ KOOPДИHATHУЮ CИCTEMУ ПO MATP
;ИЦE SM_XY
;IY-RETURN ADR
;ПOPTИT SP
;HAЧAЛЬHЫE 3HAЧ. KOOPД. B DX,DY,DZ
;KOHEЧHЫE B TX,TY,TZ
Dx      LD DE,0
Sm_11   LD A,0
        LD IX,$+7
        JP MULL

        LD SP,HL
Dy      LD DE,0
Sm_21   LD A,0
        LD IX,$+7
        JP MULL

        ADC HL,SP
        JP PE,Exet1
        LD SP,HL
Dz_     LD DE,0
Sm_31   LD A,0
        LD IX,$+7
        JP MULL

        ADC HL,SP
        JP PE,Exet1
        LD (Tx+1),HL
        LD DE,(Dx+1) ;DX
Sm_12   LD A,0
        LD IX,$+7
        JP MULL

        LD SP,HL
        LD DE,(Dy+1) ;DY
Sm_22   LD A,0
        LD IX,$+7
        JP MULL

        ADC HL,SP
        JP PE,Exet1
        LD SP,HL
        LD DE,(Dz_+1) ;DZ
Sm_32   LD A,0
        LD IX,$+7
        JP MULL

        ADC HL,SP
        JP PE,Exet1
        LD (Ty+1),HL
        LD DE,(Dx+1) ;DX
Sm_13   LD A,0
        LD IX,$+7
        JP MULL

        LD SP,HL
        LD DE,(Dy+1) ;DY
Sm_23   LD A,0
        LD IX,$+7
        JP MULL

        ADC HL,SP
        JP PE,Exet1
        LD SP,HL
        LD DE,(Dz_+1) ;DZ
Sm_33   LD A,0
        LD IX,$+7
        JP MULL

        ADC HL,SP
        JP PE,Exet1
        LD (Tz+1),HL
Exet1
        JP (IY)






;RENDER ALL 3D AND DRAW
Ren3d
;BEGIN AT CHOOSING OBJECT THAT IS VISIB
;LE

        LD HL,(Eye_a) ;EYE A,B
        LD (Eyea),HL ;ALFA BETA
        LD A,(Eye_g) ;EYE G
        LD (Eyeg),A ;GAMA

        CALL Matrx

        LD HL,#01
        LD (Indt1),HL
        LD BC,Olen ;VECTOR LEN FOR CARS
        LD HL,Carsb ;VECTOR CARS
        LD (La294),SP
        JR L9f04
L9eed
        LD A,L
        AND A
        JP M,La293 ;IF CARS WERE RENDERED
L9efc
        EXX
        ADD HL,BC ;NEXT VECTOR
L9f04
        LD SP,HL

;B VECADR+PX+1=#80 KAK MAPKИPOBKA OБЪEK
;TA БE3 ПPOCЧИTAHHЫX
;KOOPДИHAT B ПOBEPHУTOM ПPOCTPAHCTBE.
        EX DE,HL
        LD HL,Px+1
        ADD HL,DE
        LD A,#80
        LD (HL),A
        EX DE,HL
        EXX
        POP HL ;X
        CP H
        JR Z,L9eed ;END OF VECTOR TAB
        LD (Objx),HL ;STORE X

        LD A,H
        AND A
        JP P,$+4
        CPL
        CP Visibil ;LIMIT VISIBILETY
        JR NC,L9efc ;UNVISIBLE

        LD (Dx+1),HL ;STORE DX
        POP HL ;Y
        LD (Objy),HL ;Y OBJ

        LD A,H
        AND A
        JP P,$+4
        CPL
        CP Visibil ;LIMIT VISIBILETY
        JR NC,L9efc ;UNVISIBLE

        LD (Dy+1),HL ;DY
        POP HL ;Z

        LD (Objz),HL ;Z OBJ

        LD A,H
        AND A
        JP P,$+4
        CPL
        CP Visibil ;LIMIT VISIBILETY
        JR NC,L9efc ;UNVISIBLE

        LD (Dz_+1),HL ;DZ
        POP HL ;UNGLE&INDEX
        LD A,L ;INDEX
        LD (Indx),A ;IND
        LD A,H ;UNGLE
        LD (Eyea),A ;ALFA
        POP HL ;FOR CARS ANOTHER UNGLES
        LD (Eyeb),HL ;BETA GAMA

        LD IY,$+7
        JP Calcrc ;ord;ПOBOPOT
        JP PE,L9efc ;ПEPEПOЛHEHИE,BЫXOД


;ПEPEHOCИM ПPOCЧИTAHHЫE KOOPД. B BEKTOP
; OБЪKTA TEM CAMЫM
;CTИPAЯ MAPKИPOBKУ
        EXX
        LD A,L
        EXX
        LD L,A
        EXX
        LD A,H
        EXX
        LD H,A
        LD DE,Pz+2
        ADD HL,DE
        LD SP,HL
        LD DE,(Tz+1)
        PUSH DE
        LD HL,(Ty+1)
        PUSH HL
        LD HL,(Tx+1)
        PUSH HL


        LD A,H
        OR A
        JP P,$+4
        CPL
        CP Xvisibi ;VISIBILITY OF X
        JP NC,L9efc

        LD A,D
        OR A
        JP M,L9efc
        CP Detaliz ;BORDER FOR DETAILS
        LD A,(Indx) ;IND
        JP P,La0bc
        ADD A,#02
        LD (Indx),A ;IND
La0bc

        LD H,high(L97)
        LD A,(Indx) ;IND
        LD L,A
        LD SP,HL
        POP HL
        LD SP,HL
        POP BC
        LD A,6
        SUB B
        LD (Jmp1+1),A
        LD (Jmp2+1),A
        LD (Jmp3+1),A
        LD L,C
        LD H,0
Jmp1    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
;IN HL-MIDLE SIZE OBJ
        LD SP,(La294)


        PUSH BC
        PUSH HL
        LD DE,(Dx+1) ;DX
        BIT 7,D
        JR Z,La108
        ADC HL,DE
        JP La10a
La108   SBC HL,DE
La10a   JP M,La121
        POP HL
        PUSH HL
        LD DE,(Dz_+1) ;DZ
        BIT 7,D
        JR Z,La11c
        ADC HL,DE
        JP La11e
La11c   SBC HL,DE
La11e   JP M,La121
        POP HL
        PUSH HL
        LD A,(Indx)
        XOR #80
        JP P,La121
        DUP 2
            SRL H
            RR L
        EDUP
        LD DE,(Dy+1) ;DY
        BIT 7,D
        JR Z,La1c
        ADC HL,DE
        JP La121
La1c    SBC HL,DE
La121
        CALL P,Lm1

        POP DE
        POP BC


La13a   LD HL,(Tz+1)
        OR A
        ADC HL,DE
        JP M,L9efc


;-
        LD HL,(Tz+1)
        OR A
        SBC HL,DE
        LD A,H
        EX AF,AF'
;-

        LD IXL,C
        LD A,#48
        LD H,Multb
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
        LD L,A
        LD H,#00
Jmp2    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        EX DE,HL
        LD HL,(Tz+1)
        SRA H
        RR L
        LD BC,(Tx+1)
        ADD HL,BC
        SRA H
        RR L
        AND A
        ADC HL,DE
        JP M,L9efc
        AND A
        SBC HL,BC
        JP M,L9efc

;-
        AND A
        SBC HL,DE
        AND A
        SBC HL,DE
        EX AF,AF'
        OR H
        ADD HL,BC
        OR H
        EX AF,AF'
;-

        LD C,IXL
        LD A,#42
        LD H,Multb
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
        LD L,A
        LD H,#00
Jmp3    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        EX DE,HL
        LD HL,(Tz+1)
        SRA H
        RR L
        SRA H
        RR L
        LD BC,(Ty+1)
        ADD HL,BC
        SRA H
        RR L
        AND A
        ADC HL,DE
        JP M,L9efc
        AND A
        SBC HL,BC
        JP M,L9efc

;-
        AND A
        SBC HL,DE
        AND A
        SBC HL,DE
        EX AF,AF'
        OR H
        ADD HL,BC
        OR H
        LD HL,Sets
        JP P,La1c7
        RES 2,(HL)
        JP La1c9
La1c7
        SET 2,(HL)
La1c9
;-




;BПИCЫBAHИE ДAHHЫX OБЪEKTA B CПИCOK C C
;OPTИPOBKOЙ ПO
;ПPИБЛИЖEHИЮ
        LD BC,(Tz+1)
        LD DE,(Dy+1) ;DY
        LD A,(Indt1)
        CP #01
        JR Z,La238
        LD IXH,L9d
        LD IXL,A
;        LD A,(Sets)
;        OR (IX+#01)
;        JP M,La1f4
        LD L,(IX+#0C)
        LD H,(IX+#0D)
        SBC HL,BC
        JP M,La238
;        JP La1ff
;La1f4   LD L,(IX+#0C)
;        LD H,(IX+#0D)
;        SBC HL,DE
;        JP M,La238
La1ff   LD IYH,L9d
La202   LD A,(IX+#00)
        CP #01
        JR Z,La24e
        LD IYL,A
;        LD A,(Sets)
;        OR (IY+#01)
;        JP M,La226
        LD L,(IY+#0C)
        LD H,(IY+#0D)
        SBC HL,BC
        JP M,La260
        LD A,IYL
        LD IXL,A
        JP La202
;La226   LD L,(IY+#0C)
;        LD H,(IY+#0D)
;        SBC HL,DE
;        JP M,La260
;        LD A,LY
;        LD LX,A
;        JP La202
La238   LD A,(Indt2)
        CP #FC
        JP Z,La293
        LD L,A
        LD H,L9d
        LD A,(Indt1)
        LD (HL),A
        LD A,L
        LD (Indt1),A
        JP La272
La24e   LD A,(Indt2)
        CP #FC
        JR Z,La293
        LD (IX+#00),A
        LD L,A
        LD H,L9d
        LD (HL),#01
        JP La272
La260   LD A,(Indt2)
        CP #FC
        JR Z,La293
        LD L,A
        LD H,L9d
        LD A,(IX+#00)
        LD (IX+#00),L
        LD (HL),A
        LD A,L
La272   ADD A,#0E
        LD (Indt2),A
        LD L,A
        LD SP,HL
;        PUSH DE
        PUSH BC
        LD HL,(Ty+1)
        PUSH HL
        LD HL,(Tx+1)
        PUSH HL
        LD A,(Eyeg) ;GAMA
        PUSH AF
        INC SP
        LD HL,(Eyea) ;ALFA/BETA
        PUSH HL
        LD HL,(Sets)
        PUSH HL
        JP L9efc
;CALLS CLIPPING AND DRAWING OBJECTS AND
; HORIZONT
La293   LD SP,#0000
La294   EQU $-#0002

        LD A,(Indt1)
        LD H,L9d
        JP La33b





;CYCLE OF DRAWING OBJECTS
La2d8   PUSH HL
        LD (La2fd),SP
        INC L
        INC L
        INC L
        LD SP,HL
        POP HL
        LD (Sets),HL ;BITS/IND
        POP HL
        LD (Eyea),HL ;ALFA/BETA
        DEC SP
        POP AF
        LD (Eyeg),A ;GAMA
        POP HL
        LD (Tx+1),HL ;DX
        POP DE
        LD (Ty+1),DE ;DY
        POP BC
        LD (Tz+1),BC ;DZ

;        POP HL
;        LD (Dy+1),HL

        LD SP,#0000
La2fd   EQU $-#0002

        LD A,(Sets+1) ;INDEX
        OR A
        JP M,VOXOBJ

        CALL Renobj2

        LD A,(Sets)
        BIT 2,A
        JR Z,La326
        CALL Drwpol2 ;DRAW POLY.
        JP NXTO_

La326   CALL Vsmask
        JR Z,NXTO_
        LD B,A
        CPL
        AND #F0
        JR NZ,NXTO_
        LD A,B
        AND #0F
        JR NZ,$+8
        CALL Drwpol2 ;DRAW POLY.
        JP $+6
        CALL Drwpol ;DRAW POLYGON
NXTO_   POP HL
        LD A,(HL)
La33b   CP #01
        RET Z
        LD L,A
        JP La2d8







;MATPИЦA OTДEЛЬHOГO OБЪEKTA
Matrx
        LD A,(Eyeb) ;BETA
        LD B,A
        ADD A,#40
        LD H,Sintb
        LD L,A
        LD A,(HL) ;COS
        LD (Sm_11+1),A ;COS B
        LD (Sm_33+1),A ;COS B
        LD L,B
        LD A,(HL) ;SIN
        LD (Sm_13+1),A ;SIN B
        NEG
        LD (Sm_31+1),A ;-SIN B
        XOR A
        LD (Sm_12+1),A
        LD (Sm_21+1),A
        LD (Sm_23+1),A
        LD (Sm_32+1),A
        LD A,#7F
        LD (Sm_22+1),A
        RET
