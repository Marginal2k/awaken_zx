; BLK6 -- restored from awk2/BLK6.C (3393 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;И3MEHЯEM KOOPДИHATЫ,3ABИ. ДBИЖEHИЯ
Precord
        LD (Stk1+1),SP
        LD L,(IX+Indi)
        LD H,L97
        LD SP,HL
        POP HL
        INC HL
        LD B,(HL)
        RES 7,B
        LD A,#06
        SUB B
        LD HL,200
        LD ($+4),A
        JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        LD A,Spacebd
        SUB H
        LD B,A
        LD A,IXL
        LD L,A
        LD A,IXH
        LD H,A
        LD SP,HL
Stpx_   LD HL,0
Stpx    LD DE,0
        AND A
        SBC HL,DE
        POP DE
        LD A,D
        CP #80
        JR Z,Stk1
        AND A
        ADC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JP NC,Exes
        PUSH HL
Stpy_   LD HL,0
Stpy    LD DE,0
        AND A
        SBC HL,DE
        INC SP
        INC SP
        POP DE
        AND A
        ADC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes
        PUSH HL
Stpz_   LD HL,0
Stpz    LD DE,0
        AND A
        SBC HL,DE
        INC SP
        INC SP
        POP DE
        AND A
        ADC HL,DE
        JP PE,Exes
        LD A,H
        JP P,$+4
        CPL
        CP B
        JR NC,Exes
        PUSH HL
Stk1    LD SP,0
        LD A,(Nostat+1)
        AND A
        RET Z
        LD D,#12
        CALL Findobj
        RET Z
;HAXOДИM CAMУЮ БOЛЬШУЮ KOOPДИHATУ CTAHЦ
;ИИ
        LD A,(IY+5)
        AND A
        JP P,$+4
        CPL
        LD B,A
        LD A,(IY+3)
        AND A
        JP P,$+4
        CPL
        LD C,A
        LD A,(IY+1)
        AND A
        JP P,$+4
        CPL
        CP C
        JR NC,$+3
        LD A,C
        CP B
        JR NC,$+3
        LD A,B
        CP Laungh
        JR C,Messt ;ДAЛEKO EЩE
        LD A,#80
        LD (Messt+1),A
        RET
Messt   LD A,0
        AND A
        RET P
        LD A,24 ;PEЖИM CTЫKOBKИ CO
;CTAHЦИEЙ
        LD (Messt+1),A
        JP Mesags
Exes
;ECЛИ KOPAБЛЬ 3A ГPAHИЦEЙ
        LD (IX+0),0
        LD (IX+1),#80
        LD SP,(Stk1+1)
        LD A,(IX+Type)
        CP #12
        RET NZ
;ECЛИ CTAHЦИЯ 3A ГPAHИЦEЙ
        XOR A
        LD (Statgen+1),A
        LD (Nostat+1),A
        LD (Nostat2+1),A
        LD IY,Carsb-Olen
        LD BC,Olen
Exe2
        CALL Findob
        RET Z
        LD A,(IY+Type)
        CP #12
        JR NZ,Exe2
        LD (IY+1),#80
        LD (IY),0
        JP Exe2



;----------------------
;ПOИCKOBИKИ ЧEГO TO
;----------------------

Findob
;HAЙTИ KAKOЙ HИБУДЬ OБЪEKT
;IY-VECTOR-OLEN
;BC-OLEN
;FZ-ON NOT FOUND
        ADD IY,BC
        LD A,(IY+1)
        CP #80
        RET NZ
        LD A,(IY+0)
        CP #80
        JP NZ,Findob
        RET
Fndpece
;HAЙTИ MИPHOГO
        CALL Rndl3
        LD A,L
Pwnpi   CP #A0
        LD A,Splayer
        INC A
        DEC A
        RET NC
        LD IY,Carsb-Olen
        LD BC,Olen
Fp2l
        CALL Findob
        RET Z
        LD E,(IY+Type)
        LD A,E
        AND A
        JR Z,Fp2l
        CP #12
        JR Z,$+6
        CP #10
        JR NC,Fp2l
        CALL Getindy
        INC E ;CБPOC FZ
        RET
Findall
;HAЙTИ ALL WITHOUT  UFOS
        LD IY,Carsb-Olen
        LD BC,Olen
Fp6l
        CALL Findob
        RET Z
        LD E,(IY+Type)
        LD A,E
        CP 6
        JR Z,Fp6l
        CP 7
        JR Z,Fp6l
        CALL Getindy
        INC E ;CБPOC FZ
        RET
Findufo
;HAЙTИ UFO
        LD IY,Carsb-Olen
        LD BC,Olen
Fp3l
        CALL Findob
        RET Z
        LD E,(IY+Type)
        LD A,E
        CP 6
        JR Z,$+6
        CP 7
        JR NZ,Fp3l
        CALL Getindy
        INC E
        RET
Fndprat
;HAЙTИ ПИPATA
        LD IY,Carsb-Olen
        LD BC,Olen
Fp2
        CALL Findob
        RET Z
        LD E,(IY+Type)
        LD A,E
        CP 5
        JR Z,$+5
        AND A
        JR NZ,Fp2
        CALL Getindy
        INC E
        RET
;---------------------------------


;testsubj
;;TECTИPOBAHИE ПEPCOHAЖA HA ПPEДMET EГO
;УЖE ИCЧE3HOBEHИЯ
;ИЛИ ECЛИ ЭTO ИГPOK
        LD A,(IX+Subj)
        INC A
        JR NZ,Ts1
        LD HL,+(Olen*Splayer)+Carsb
        JR Ts2
Ts1
        DEC A
        CALL Getadr
Ts2
        LD (Opone+2),HL
        INC L
        LD A,(HL)
        CP #80
        RET Z
        LD L,(IX+0)
        LD H,(IX+1)
        LD (Ddx+1),HL
        LD L,(IX+2)
        LD H,(IX+3)
        LD (Ddy+1),HL
        LD L,(IX+4)
        LD H,(IX+5)
        LD (Ddz+1),HL
        RET
Opone   LD IY,0
        LD A,(IX+Subj)
        CP Splayer
        JR NZ,Fg2
        LD BC,0
        LD (Tx+1),BC
        LD (Dx+1),BC
        LD (Dy+1),BC
        LD (Dz_+1),BC
        LD HL,#FFB0
        LD (Ty+1),HL
        LD DE,0-1
        LD (Tz+1),DE
        LD IY,Player
        AND A
        RET
Fg2
        LD A,(IY+(Px+1))
        CP #80
        SCF
        RET Z
        AND A
        LD L,(IY+0)
        LD H,(IY+1)
        LD (Dx+1),HL
        LD L,(IY+2)
        LD H,(IY+3)
        LD (Dy+1),HL
        LD L,(IY+4)
        LD H,(IY+5)
        LD (Dz_+1),HL
        LD C,(IY+Px)
        LD B,A
        LD (Tx+1),BC
        LD L,(IY+Py)
        LD H,(IY+(Py+1))
        LD (Ty+1),HL
        LD E,(IY+Pz)
        LD D,(IY+(Pz+1))
        LD (Tz+1),DE
        RET
Fireing
;OPГAHИ3AЦИЯ BЫCTPEЛA ПEPCOHAЖA B KOГO
;ЛИБO
;BЫBOД ЛУЧA, ИHИЦИAЛИ3. ДAHHЫX SUBJ & A
;CTN
        LD A,(IX+(Px+1))
        CP #80
        SCF
        RET Z
        LD B,A
        LD C,(IX+Px)
        LD L,(IX+Py)
        LD H,(IX+(Py+1))
        LD E,(IX+Pz)
        LD D,(IX+(Pz+1))
        EXX
        CALL Opone
        RET C
        LD A,R
Pwppi   CP #4A
        JR C,Fg1
        SET 0,(IY+Actn) ;FIRE
        PUSH HL
        PUSH IX
        POP HL
        CALL Getind
        POP HL
        LD (IY+Subj),A
Fg1
        LD A,D
        EXX
        AND D
        RET M
        PUSH HL
        LD HL,(Tx+1)
        AND A
        SBC HL,BC
        POP HL
        SCF
        RET PE
        PUSH HL
        LD HL,(Tz+1)
        AND A
        SBC HL,DE
        POP HL
        SCF
        RET PE
        PUSH HL
        PUSH DE
        LD DE,(Ty+1)
        AND A
        SBC HL,DE
        POP DE
        POP HL
        SCF
        RET PE
        PUSH IX
        CALL Outline
        POP IX
        AND A
        RET


Checkal
;ПPOBEPKИ HA BEPOЯTHOCTЬ ПOДБИPAHИЯ ГPУ
;3A, ФOPCAЖA, OБЛETA
;FC-ON LET GO GOSIMPLY
        CALL Rndk3
        LD A,L
        CP Vfrs ;BEPOЯTHOCTЬ ФOPCAЖA
        JR C,Fs3
        LD A,(IX+Mode)
        LD (IX+Omode),A
        LD (IX+Mode),19 ;FORSAGE
Fs3
        LD A,(IX+(Px+1))
        AND A
        JP P,$+4
        CPL
;MИHИM. PACT. ПO X,Y B ПУTИ ПPOЛETA, ДЛ
;Я OБЛETA
        CP Dlrazi
        RET NC
        LD A,(IX+(Py+1))
        AND A
        JP P,$+4
        CPL
        CP Dlrazi
        RET NC
        LD A,(IX+(Pz+1))
        AND A
        JP P,$+4
        CPL
        CP Dlraz ;ДAЛЬHOCTЬ OT ИГPO
;KA ДЛЯ OБЛETA
        RET NC
        LD A,(IX+Mode)
        LD (IX+Omode),A
        LD (IX+Mode),20 ;OБЛET
        LD (IX+Powor),Timeobl
        RET


Rnd
        EXX
        LD HL,Sdo
        JP Rndo
Rndw
        EXX
        LD HL,Sdw
        JP Rndo
Rndk1
        EXX
        LD HL,Sdk1
        JP Rndo
Rndk2
        EXX
        LD HL,Sdk2
        JP Rndo
Rndk3
        EXX
        LD HL,Sdk3
        JP Rndo
Rndt2
        EXX
        LD HL,Sdt2
        JP Rndo
Rndt1
        EXX
        LD HL,Sdt1
        JP Rndo
Rndl1
        EXX
        LD HL,Sdl1
        JP Rndo
Rndl2
        EXX
        LD HL,Sdl2
        JP Rndo
Rndl3
        EXX
        LD HL,Sdl3
        JP Rndo
Rndl4
        EXX
        LD HL,Sdl4
        JP Rndo
Rndl5
        EXX
        LD HL,Sdl5
        JP Rndo
Rndl7
        EXX
        LD HL,Sdl7
        JP Rndo
Rndl8
        EXX
        LD HL,Sdl8
        JP Rndo
Rndl9
        EXX
        LD HL,Sdl9
        JP Rndo
Sdw
;ГEHEPATOP KAKOГO ЛAHДШAФTA
        DB 7, 8, 0
Sdo
        DB 101, 0, 0
Sdl1
        DB 9, 0, 0
Sdl2
        DB 231, 0, 0
Sdl3
        DB 71, 1, 0
Sdl4
        DB 10, 0, 0
Sdl5
        DB 77, 1, 0
Sdl7
        DB 200, 0, 0
Sdl8
        DB 13, 0, 0
Sdl9
        DB 13, 3, 1
Sdt2
        DB 44, 0, 0
Sdt1
        DB 21, 0, 0
Sdk1
        DB 247, 0, 0
Sdk2
        DB 93, 0, 0
Sdk3
        DB 29, 0, 0
Rndo
;IN HL ADR OF SEED
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD A,(HL)
        PUSH HL
        LD E,A
        LD H,B
        LD L,C
        DEC HL
        ADD HL,HL
        ADC A,0
        ADD HL,HL
        ADC A,0
        ADD HL,HL
        ADC A,0
        ADD HL,HL
        ADC A,0
        ADD HL,HL
        ADC A,0
        ADD HL,HL
        ADC A,0
        EX DE,HL
        LD H,B
        LD L,C
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,DE
        ADC A,0
        ADD HL,BC
        ADC A,0
        ADD HL,BC
        ADC A,0
        ADD HL,BC
        ADC A,0
        LD D,H
        LD E,L
        LD L,H
        LD H,A ;0
        LD B,0
        LD C,E
        AND A
        SBC HL,BC
        SBC A,0
        EX DE,HL
        AND A
        SBC HL,DE
        SBC A,0
        DEC HL
        EX DE,HL
        POP HL
        LD (HL),A
        DEC HL
        LD (HL),D
        DEC HL
        LD (HL),E
        PUSH DE
        EXX
        POP HL
        RET
