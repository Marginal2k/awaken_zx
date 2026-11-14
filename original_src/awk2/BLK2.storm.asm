Newrokt
;ИHИЦИAЛИ3AЦИЯ PAKETЫ
;C-CУБЪEKT HA KOГO ATAKA
        LD A,C
        CALL Getadr
        INC L
        LD A,(HL)
        CP #80
        JR NZ,Rkn12
        LD HL,Eff13
        LD (Sfxa+1),HL
        LD A,8;ЦEЛЬ ПOTEPЯHA
        CALL Mesags
        AND A
        RET
Rkn12
        PUSH BC
        EXX
        LD HL,0
        LD D,H
        LD E,L
        LD BC,400
        CALL Record
        EXX
        POP BC
        LD A,1
        EX AF,AF
        CALL Aroks
        LD A,L
        CP Roks&L
        LD A,Minren
        JR Z,$+4
        LD A,Maxren
        LD B,Splayer
Rkn11
;INIT ROKET
;HL'-X,DE'-Y,BC'-Z
;C-SUBJECT
;A'-1-ROKET OF PLAYER,0-ROKET OF SOMEBO
;DY
;B-KTO ПУCTИЛ PAKETУ
        LD (Enrok+1),A
        LD HL,Carsb-Olen+1
        LD DE,Olen
        ADD HL,DE
        LD A,(HL)
        CP #80
        JR NZ,$-4
        DEC L
        LD A,(HL)
        CP #80
        RET Z
        XOR A
        LD D,H
        LD E,L

        PUSH HL
        POP IY
        EXX
        LD (IY+0),L
        LD (IY+1),H
        LD (IY+2),E
        LD (IY+3),D
        LD (IY+4),C
        LD (IY+5),B
        EXX
        LD A,L
        ADD A,6
        LD L,A
        LD (HL),Iroket
        INC L
        XOR A
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD (HL),8;MODE ROKET NAVOD
        INC L
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD (HL),B;KTO ПУCTИЛ PAKETУ
        INC L
        INC L
        LD (HL),C;SUBJECT ON MSPD
        INC L
        INC L
        EX AF,AF
        LD (HL),A;ПPИHAДЛEЖHOCTЬ
;PAKETЫ K ИГPOKУ <>0
;BMECTO LZS
        INC L
        LD (HL),#11;ROKETA
        INC L
Enrok   LD (HL),0;ЭHEPГИЯ
        LD A,L
        ADD A,Spt-Energy
        LD L,A
        LD (HL),2

;ПPEДУПP. TOГO B KOГO BЫCTPEЛИЛИ ЧTO ПO
; HEMУ PAKETA ИДET
        LD A,C
        CALL Getadr
        LD A,L
        ADD A,Actn
        LD L,A
        SET 1,(HL)
        DEC L
        EX DE,HL
        CALL Getind
        LD (DE),A;HOMEP PAKETЫ B CПИCKE
        SCF
        RET
Repanel
;BЫBOД ИHДИKATOPOB ПAHEЛИ , A TAK ЖE BP
;EMEHИ
        LD BC,#7FFD
        PUSH BC
        LD A,Pgnorm
        OUT A
        LD A,1
        LD (Fspeed+1),A
        LD (Ffire+1),A
        LD (Fshild+1),A
        LD (Fhigh+1),A
        LD (Ftempe+1),A
        LD (Ffuel+1),A
        CALL Datalin;ИHДИKATOPЫ
        POP BC
        LD A,Pgstar
        OUT A
        LD HL,(Time+2)
        LD DE,(Time)
        LD B,#FF
        JP Zerot1;BPEMЯ


Korni
;ПOДCЧET KOPHЯ
;DE-CЧEГO БPATЬ KOPEHЬ
;A-3HAЧEHИE
        PUSH BC
        LD BC,#7FFD
        LD A,Pgcontr
        OUT A
        CALL Korni2
        LD BC,#7FFD
        EX AF,AF
        LD A,Pgnorm
        OUT A
        EX AF,AF
        POP BC
        RET

Wayungl
;TOЧHOE OПPEДEЛEHИE ДBУX УГЛOB ПOBOPOTA
; OБЪEKTA HOCOM HA ДPУГOЙ
;ФOPMУЛЫ
;BETA=ARCTAG(AB/DZ)
;GAMA=ARCTAG(DY/DX)
;AB=SQRT(DX^2+DY^2)
;3HAK BETA 3ABИCИT OT 3HAKA DX

;PACЧET AB
;
;BXOДHЫE ДAHHЫE
;DE-X1,HL-X2,BC-Y1,HL'-Y2
;DE'-Z2,BC'-Z1
;RET
;B-BETA,C-GAMA

;MULL HLDE=HL*DE
        PUSH IX
        SRA H
        RR L
        SRA D
        RR E
        AND A
        SBC HL,DE
;HL-DX
        PUSH HL
        PUSH BC
        LD D,H
        LD E,L
        CALL Mull
        EX DE,HL
        POP BC
        EXX
        PUSH HL
        EXX
        POP HL
        SRA H
        RR L
        SRA B
        RR C
        AND A
        SBC HL,BC
;HL-DY
        PUSH HL
        PUSH DE
        LD D,H
        LD E,L
        CALL Mull
        POP DE
        ADD HL,DE
;HL-CTAPШAЯ ЧACTЬ OT AB^2=DX^2+DY^2
        EX DE,HL
        CALL Korni
        LD H,A
        LD L,0
        PUSH HL
        EXX
        EX DE,HL

        AND A
        SBC HL,BC

        PUSH HL
        EXX
        POP DE
;DE-DZ
        POP HL
        CALL Atagdiv
        POP HL,DE
;HL-DY,DE-DX
        PUSH AF
        CALL Atagdiv
        POP BC
        SUB #40
        NEG
        LD C,A

        LD A,#40
        SUB B
        ADD A,#80
        LD B,A

        POP IX
        RET


Onway
;HABEДEHИE HOCA OБЪEKTA HA ДP. OБЪEKT
;HL,BC,DE-X2,Y1,X1
;HL',BC',DE'-Y2,Z1,Z2
;X1,... - KOPД. OБЪEKTA KOTOPOГO HABOДЯT
;X2,... - HA KOTOPЫЙ HABOДЯT
        PUSH HL,DE,BC
        LD A,(IX+Subj)
        CALL Getadr
        PUSH HL
        POP IY
        LD A,(IY+1)
        CP #80
        JR Z,Nonw
        CALL Rastoy
        CP Minras;PACTOЯHИE ДЛЯ CB
;OPAЧИBAHИЯ
        JR C,Turnup
Nonw
        POP BC,DE,HL
Onway2
        CALL Wayungl
        LD A,(IX+Beta)
        LD D,A
        SUB B
        LD E,A
        CALL P,$+5
        NEG
        LD L,A
        CP 2
        JR C,Jlk1
        LD A,(IX+Spt)
        CP L
        JR C,Oy1
        JR Z,Oy1
        RRA
        JP $-6
Oy1
        BIT 7,E
        JR NZ,$+4
        NEG
        ADD A,D
        LD (IX+Beta),A
Jlk1
        LD A,(IX+Gama)
        LD D,A
        SUB C
        LD E,A
        CALL P,$+5
        NEG
        LD H,A
        CP (IX+Spt)
        RET C
        LD A,(IX+Spt)
        CP H
        JR Z,Oy2
        JR C,Oy2
        RRA
        JP $-6
Oy2
        BIT 7,E
        JR NZ,$+4
        NEG
        ADD A,D
        LD (IX+Gama),A
        RET

Turnup
        POP BC,DE,HL
        LD A,(IX+Mode)
        LD (IX+Pmode),A
        LD A,R
        AND #0F
        ADD A,5
        LD (IX+Powor),A
        LD (IX+Mode),17;TURNING OUT
        LD BC,#8080
        RET

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
        PUSH BC,DE
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

        LD BC,Yend+1/2;MIDLE Y
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

        LD DE,#0080;MIDLE X
        ADD HL,DE
        POP DE
        XOR A
        RET
Ld3
        POP AF
        XOR A
        INC A
        RET
Charco
;CHANGE ROKET ONE OF KORD
        AND A
        SBC HL,BC
        LD D,H
        LD E,L
        CALL P,$+10
        LD A,D
        CPL
        LD D,A
        LD A,L
        CPL
        LD E,A
        INC DE

Rokspd  EQU 180

        LD A,D
        CP 1
        LD A,Rokspd
        JR NC,Rsp1
        LD A,E
        SRL D
        RRA
        SRL D
        RRA
        SRL A
Rsp1
        LD E,A
        LD D,0
        BIT 7,H
        JR NZ,$+9
        LD A,D
        CPL
        LD D,A
        LD A,E
        CPL
        LD E,A
        INC DE
        ADD HL,DE
        LD A,H
        ADD HL,BC
        AND A
        CALL P,$+4
        CPL
        EXX
        OR C
        LD C,A
        EXX
        RET
Getindy
;IY-ADR
        PUSH HL,IY
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
Stabl
;TAБЛИЦA ИHДEKCИPOBAHИЯ CTATУCA ПPИ ПOП
;AДAHИИ B OПP. OБЪEKT
        DB #FA,10,15,18,9,#FA,#FA,#FA,6
        DS 7,0
Shut
;PEГИCTPAЦИЯ ПOПAДAHИЯ ИГPOKA B ПEPCOHA
;ЖA
        LD HL,0;AДPEC ПEPCOHAЖA
        LD A,L
        OR H
        RET Z;HE БЫЛO ПOПAДAHИЯ
        LD BC,Actn
        ADD HL,BC
        SET 0,(HL);BЫCTPEЛ ЛA3EPOM
        DEC HL
        LD C,(HL)
;B C HOMEP TOГO C KOTOPЫM ИMEЛ ДEЛO ПEP
;COHAЖ ДO ЭTOГO
        LD (HL),Splayer
        LD A,L
        ADD A,Type-Subj
        LD L,A
        LD B,(HL);TИП ПEPCOHAЖA
        LD HL,0
        LD (Shut+1),HL
;3BУK ПOПAДAHИЯ
        LD HL,Eff21
        LD (Sfxa+1),HL
        LD A,C
        CP Splayer
        RET Z;ECЛИ ПPEД. БЫЛ ИГPOK
Chstat_
        LD A,B
        CP #10
        RET NC;ECЛИ ЭTO ПPOCTO OБЪEKTЫ
        LD L,B
        LD H,0
        LD BC,Stabl
        ADD HL,BC
        LD C,(HL)
;;ПO TИПУ И3 TAБЛИЦЫ B3ЯЛИ MИHУC CTATУC
;OT ИГPOKA
Chstat
        LD A,(Statgen+1)
        AND A
        JR Z,$+10
        LD A,C
        AND A
        CALL M,$+6
        ADD A,10
        LD C,A
        LD A,(Status)
        LD B,A
        ADD A,C
        CALL PO,$+6
        SUB C
        LD A,#7F
        CALL P,$+4
        XOR A
        LD C,A
        LD A,B
        CP 32
        JR NC,$+4
        SET 5,C
        LD A,C
        LD (Status),A
        RET
Fline
;PИCOBAHИE ЛA3EPA ИГPOKA
        LD A,0
Pstli   ADD A,50
        LD ($-3),A
        RET NC
        LD A,(Peregrv+1)
        CP 2
        RET C
        SUB 2
        LD (Peregrv+1),A
        LD A,1
        LD (Ffire+1),A
        XOR A
        LD (Fll+1),A
        LD HL,Eff2
        LD (Sfxa+1),HL
        LD HL,#38A9
        LD A,Ld1l&L
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
        ADD A,6
        ADD A,D
        LD D,A
        PUSH DE
        LD HL,#5F40
        CALL Drawl1
        LD HL,#5FC0
        POP DE
        JP Drawl1
Neword
;HOBOE 3AДAHИE B 3ABИCИMOCTИ OT TИПA
        LD A,(IX+Type)
        SLA A
        LD L,A
        LD H,0
        LD BC,Intel
        ADD HL,BC
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        JP (HL)
Intel
        DW Pirat
        DW Trade
        DW Army_
        DW Polic
        DW Hunte
        DW Upira
        DW Uufo_
        DW Ufo__
        DW Otshe
.16     DW Nothing
Nothing
        RET
Upira
        LD (IX+Mode),1
        CALL Rnd
        LD A,H
        OR L
        RET NZ
        JP Topeace
Otshe
        LD (IX+Mode),18
        CALL Rnd
        LD A,H
        OR L
        RET NZ
        JP Topeace
Army_
        LD A,R
        CP #70
        LD (IX+Mode),2
        LD (IX+Subj),#FF
        RET C
Toufo
        CALL Findufo
        RET Z
        LD (IX+Subj),A
        RET
Ufo__
        LD A,R
        CP #70
        LD (IX+Mode),2
        LD (IX+Subj),#FF
        RET C
        CALL Findall
        RET Z
        LD (IX+Subj),A
        RET
Uufo_
        LD (IX+Mode),1
        CALL Rnd
        LD A,H
        OR L
        JP NZ,Topeace
        JP Toufo
Trade
        LD A,(IX+Omode)
        CP 13;BACKAS
        RET Z
        LD (IX+Mode),1
        CALL Rnd
        LD A,H
        OR L
        RET NZ
        JP Topeace
Hunte
        LD A,R
        CP #70
        LD (IX+Mode),2
        LD (IX+Subj),#FF
        RET C
        CALL Fndprat
        RET Z
        LD (IX+Subj),A
        RET
Polic
        LD A,R
Pwnpp   CP 6
        LD (IX+Mode),2
        LD (IX+Subj),#FF
        JR C,Polic2
        CALL Fndprat
        RET Z
        LD (IX+Subj),A
        RET
;ПPOBEPKA BAШEГO CTATУCA
Polic2
        LD A,(Status)
        CP 64;PO3ЫCKИBAEMЫЙ
        RET C
        PUSH AF
        CALL Rndl1
        POP AF
        CP L
        RET C
        LD A,H
        CP 3
        RET NC
        LD (IX+Subj),Splayer
        RET
Pirat
        LD A,R
Pwnpm   CP #70
        LD (IX+Mode),2
Topeace
        LD (IX+Subj),#FF
        RET C
        CALL Fndpece
        RET Z
        LD (IX+Subj),A
        RET
Datal_
        LD BC,#7FFD
        EX AF,AF
        LD A,Pgcontr
        OUT A
        EX AF,AF
        CALL Datal
        LD BC,#7FFD
        LD A,Pgnorm
        OUT A
        RET

Datalin
;BЫBOД ДAHHЫX O 3AЩИTE ЭHEPГИИ И ДP.ИHФ
;O B BИДE CTATУC ЛИHИИ
Fshild  LD A,0
        AND A
        JR Z,Ffuel
        LD A,(Shild)
        LD HL,#49A1
        CALL Datal_
        XOR A
        LD (Fshild+1),A

Ffuel   LD A,0
        AND A
        JR Z,Ffire
        CALL Afuel
        RRA
        LD HL,#49E1
        CALL Datal_

Ffire   LD A,0
        AND A
        JR Z,Ftempe
        LD A,(Peregrv+1)
        LD HL,#5121
        CALL Datal_
        XOR A
        LD (Ffire+1),A
Ftempe  LD A,0
        AND A
        JR Z,Fhigh
Tempe   LD A,0
        LD HL,#5181
        CALL Datal_
        XOR A
        LD (Ftempe+1),A
Fhigh   LD A,0
        AND A
        JR Z,$+14
High    LD A,0
        LD HL,#51C1
        CALL Datal_
        XOR A
        LD (Fhigh+1),A
Fspeed  LD A,0
        AND A
        JR Z,Fspd
        XOR A
        LD (Fspeed+1),A
        LD HL,(Speed)
        BIT 7,H
        JR Z,$+9
        LD A,H
        CPL
        LD H,A
        LD A,L
        CPL
        LD L,A
        INC HL
        LD A,H
        SRL A
        RR L
        SRL A
        RR L
        AND A
        JR Z,$+4
        LD L,46
        LD A,L
        CP 47
        JR C,$+4
        LD L,46
        LD A,L
        LD HL,#49B9
        CALL Datal_
Fspd
        RET

Moveon
;MOVING SHIPS IN FRONT
;DE-SPEED
;EYEA_,EYEB_,EYEG_-UNGELS
;RET IN STPX_,STPY_,STPZ_
        PUSH IX
        PUSH DE
        CALL Shmtrx
        POP DE
Hm_13   LD A,0
        PUSH DE
        LD IX,$+7
        JP Lc52c
        POP DE
        LD (Stpx_+1),HL
Hm_23   LD A,0
        PUSH DE
        LD IX,$+7
        JP Lc52c
        POP DE
        LD (Stpy_+1),HL
Hm_33   LD A,0
        LD IX,$+7
        JP Lc52c
        LD (Stpz_+1),HL
        POP IX
        RET
