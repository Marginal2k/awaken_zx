;ПЛEЙEP CEMПЛEB
; NOTE2
; "sfx"-IS A LOOP, WHICH CONTAINS
; IS A ADDRESS OF THE SOUND EFFECT
;
Sfxa
        LD HL,0
        LD A,H
        OR A
        JR Z,Sfxb
        LD BC,#FFFD
        XOR A
        OUT (C),A
        LD B,#BF
        OUTI
        LD B,#FF
        LD A,1
        OUT (C),A
        LD B,#BF
        OUTI
        LD B,#FF
        LD A,7
        OUT (C),A
        IN A,(C)
        AND %11110110
        OR (HL)
        LD B,#BF
        OUT (C),A
        INC HL
        LD A,8
        LD B,#FF
        OUT (C),A
        LD B,#BF
        OUTI
        LD (Sfxa+1),HL
        LD A,(HL)
        OR A
        JR NZ,Sfxb
        LD (Sfxa+2),A
        LD B,#FF
        LD A,7
        OUT (C),A
        IN A,(C)
        OR %00001001
        LD B,#BF
        OUT (C),A
Sfxb
        LD HL,0
        LD A,H
        OR A
        JR Z,Sfxn
        LD BC,#FFFD
        LD A,2
        OUT (C),A
        LD B,#BF
        OUTI
        LD B,#FF
        LD A,3
        OUT (C),A
        LD B,#BF
        OUTI
        LD B,#FF
        LD A,7
        OUT (C),A
        IN A,(C)
        AND %11101101
        LD B,A
        LD A,(HL)
        RLCA
        OR B
        LD B,#BF
        OUT (C),A
        INC HL
        LD A,9
        LD B,#FF
        OUT (C),A
        LD B,#BF
        OUTI
        LD (Sfxb+1),HL
        LD A,(HL)
        OR A
        JR NZ,Sfxn
        LD (Sfxb+2),A
        LD B,#FF
        LD A,7
        OUT (C),A
        IN A,(C)
        OR %00010010
        LD B,#BF
        OUT (C),A
Sfxn
        LD C,#FD
        LD B,#FF
        LD A,5
        OUT A
        LD B,#BF
        LD A,#0C
        OUT A
        LD B,#FF
        LD A,7
        OUT A
        LD A,R
        CP #20
        JR C,$+4
        LD A,#20
        AND %00100000
        LD L,A
        IN A
        AND %11011011
        OR L
        LD B,#BF
        OUT A
        LD A,6
        LD B,#FF
        OUT A
        LD B,#BF
        LD A,5
        OUT A
        LD A,10
        LD B,#FF
        OUT A
        LD B,#BF
Nunu    LD A,0
        SRL A
        CP 4
        JR NC,$+4
        LD A,4
        OUT A
        RET
Roka
        DB 20,2,%00001000,11
        DB 1,1,%00001000,10
        DB 20,2,%00001000,9
        DB 1,1,%00001000,10
        DB 20,2,%00001000,11
        DB 1,1,%00001000,10,0
Eff13
        DB 20,0,%00000000,10
        DB 10,0,%00000000,9
        DB 20,0,%00000000,8
        DB 10,0,%00000000,7
        DB 20,0,%00000000,6
        DB 10,0,%00000000,5,0
Eff19
        DB 80,1,%00001000,8
        DB 70,1,%00001000,8
        DB 60,1,%00001000,8
        DB 80,1,%00001000,8
        DB 70,1,%00001000,9
        DB 60,1,%00001000,9
        DB 80,1,%00001000,9
        DB 70,1,%00001000,10
        DB 60,1,%00001000,10
        DB 80,1,%00001000,10
        DB 70,1,%00001000,11
        DB 60,1,%00001000,11
        DB 80,1,%00001000,11
        DB 70,1,%00001000,12
        DB 60,1,%00001000,13
        DB 70,1,%00001000,13,0
Eff1
        DB 40,0,%00000000,10
        DB 50,0,%00000000,9
        DB 40,0,%00000000,8
        DB 50,0,%00000000,7
        DB 40,0,%00000000,6
        DB 50,0,%00000000,5,0
Eff14
        DB 20,1,%00000000,10
        DB 10,1,%00000000,9
        DB 20,1,%00000000,8
        DB 10,1,%00000000,7
        DB 20,1,%00000000,6
        DB 10,1,%00000000,5,0
Eff2
;SHOOT1
        DB #10,1,%00001000,12
        DB #40,1,%00001000,11
        DB #70,1,%00001000,10
        DB #20,2,%00001000,9
        DB #E0,2,%00001000,8
        DB #20,3,%00001000,7,0

Eff0
;EXPLOSION
        DB #10,8,%00001000,15
        DB #10,8,%00001001,15
        DB #10,8,%00000000,15
        DB #80,8,%00000000,15
        DB #10,8,%00000001,15
        DB #80,7,%00001001,15
        DB #80,7,%00000001,15
        DB #80,5,%00000001,15
        DB #80,4,%00000000,14
        DB #80,3,%00000001,14
        DB 1,0,%00000001,14
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000000,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000000,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,13
        DB 1,0,%00000001,11
        DB 1,0,%00000001,11
        DB 1,0,%00000001,11
        DB 1,0,%00000001,11
        DB 1,0,%00000001,11
        DB 1,0,%00000001,11
        DB 1,0,%00000001,11
        DB 1,0,%00000001,12
        DB 1,0,%00000001,12
        DB 1,0,%00000001,12
        DB 1,0,%00000001,12
        DB 1,0,%00000001,12
        DB 1,0,%00000001,11
        DB 1,0,%00000001,10
        DB 1,0,%00000001,9
        DB 1,0,%00000001,8
        DB 1,0,%00000001,8
        DB 1,0,%00000001,8
        DB 1,0,%00000001,8
        DB 1,0,%00000001,7
        DB 1,0,%00000001,6
        DB 1,0,%00000001,5
        DB 1,0,%00000001,4
        DB 1,0,%00000001,3,0

Eff11
        DB 100,2,4,9
        DB 100,3,4,7
        DB 100,2,4,5
        DB 100,3,4,4
        DB 100,2,4,2
        DB 100,3,4,1,0

Eff21
        DB 200,1,32,12
        DB 2,0,0,11
        DB 50,0,0,12
        DB 50,0,4,7
        DB 50,0,4,1,0





Datal
;HL-ADR ON SCREEN
;A-MEAN
        LD C,A
        AND A
        JR Z,Dln1;ECЛИ BOOБЩE = 0
        CPL
        AND 7
        LD A,C
        JR NZ,$+7
        ADD A,8
        AND %11111000
        LD C,A
        RRCA
        RRCA
        RRCA
        AND 7
        JR Z,Dln1
        LD B,A
        LD DE,#05AA
.5      LD (HL),E:INC H
        LD (HL),E
        LD A,H
        SUB D
        LD H,A
        INC L
        DJNZ $-15
Dln1
        LD A,C
        EX AF,AF
        LD A,C
        AND 7
        JR Z,Dln2
        LD C,A
        LD B,0
        EX DE,HL
        LD HL,Tabr
        ADD HL,BC
        LD A,(HL)
.5      LD (DE),A:INC D
        LD (DE),A
        LD A,D
        SUB 5
        LD D,A
        EX DE,HL
        INC L
Dln2
        EX AF,AF
        LD C,A
        AND 7
        LD A,C
        JR Z,$+4
        ADD A,8
        RRCA
        RRCA
        RRCA
        AND 7
        SUB 6
        RET NC
        NEG
        LD B,A
        LD DE,#0005
        XOR A
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        INC H
        LD (HL),D
        LD A,H
        SUB E
        LD H,A
        INC L
        DJNZ $-15
        RET
Tabr
        DB %10000000
        DB %10000000
        DB %10100000
        DB %10100000
        DB %10101000
        DB %10101000
        DB %10101010


Repanel
;BЫBOД ИHДИKATOPOB ПAHEЛИ , A TAK ЖE BP
;EMEHИ
        LD A,1
        LD (Fspeed+1),A
        LD (Ffire+1),A
        LD (Fshild+1),A
        LD (Ffuel+1),A
        CALL Datalin;ИHДИKATOPЫ
        LD HL,(TIME+2)
        LD DE,(TIME)
        LD B,#FF
        JP Zerot1;BPEMЯ






Datalin
;BЫBOД ДAHHЫX O 3AЩИTE ЭHEPГИИ И ДP.ИHФ
;O B BИДE CTATУC ЛИHИИ
Fshild  LD A,0
        AND A
        JR Z,Ffuel
        LD A,(SHILD)
        LD HL,#49A1
        CALL Datal
        XOR A
        LD (Fshild+1),A

Ffuel   LD A,0
        AND A
        JR Z,Ffire
;
        RRA
        LD HL,#49E1
        CALL Datal

Ffire   LD A,0
        AND A
        JR Z,Fspeed
;        LD A,(Peregrv+1)
        LD HL,#5121
        CALL Datal
        XOR A
        LD (Ffire+1),A

        LD HL,#5181
        LD HL,#51C1

Fspeed  LD A,0
        AND A
        JR Z,Fspd
        XOR A
        LD (Fspeed+1),A
        LD HL,(SPEED)
.5      ADD HL,HL
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
        CALL Datal
Fspd
        RET




        ORG $^
PLANET_
        INCB "planet"
SKYS_
        INCB "CHAN6"
DRV1
        INCB "DRV1"
DRV2
        INCB "DRV2"
DOMA1
        INCB "DOMA1"




INTEL
;ИНТЕЛЕКТ ПОВЕДЕНИЯ КОРАБЛЕЙ
        LD IX,Carsb-Olen
        JR I2
I1
        LD A,(IX+0):CP #80:RET Z
I2
        LD DE,Olen
        ADD IX,DE
        LD A,(IX+1):CP #80:JR Z,I1
        LD A,(IX+Mode)
        RLCA
        LD L,A
        LD H,0,DE,MODES:ADD HL,DE
        LD A,(HL):INC HL:LD H,(HL)
        LD L,A
        LD DE,RET_:PUSH DE
        JP (HL)
RET_
        LD A,PG3D:CALL PG
        LD A,(IX+Rspd)
        OR A:JR Z,I4
        LD D,0,E,A
        CALL MOVEON
I3
        CALL PRECORD
        LD A,PGNORM:CALL PG
        JP I2
I4
        CALL NULMOVE
        JR I3



MODES
        DW FREEFLY
.10     DW NTH

FREEFLY
        RET

NTH
        RET







;ГЕНЕРИТЬ СКИММЕРЫ
GENS
        LD A,#01
        RRCA:LD ($-2),A:RET NZ
        LD A,R:CP 22:RET NC
        CALL FNDFREE
        RET Z
        PUSH HL:POP IX
        CALL RNDL1

        LD A,H:AND %11000000:OR #60
        LD (IX+Rspd),A

        RL H
        LD H,Spacebd-3
        LD A,0
        JR NC,$+5
        LD H,0-Spacebd+3
        INC A
        LD (IX+0),L
        LD (IX+1),H

        PUSH AF:CALL RNDL2:POP AF

        RL H
        LD H,Spacebd-3
        JR NC,$+6
        LD H,0-Spacebd+3
        ADD A,2
        LD (IX+4),L
        LD (IX+5),H


        PUSH AF

        CALL RNDK1
        AND 3
.2      RLCA
        LD (IX+Indi),A

        POP AF
        INC A
        LD H,A
        LD A,L:AND #3F
        DEC H:SET 7,A:JR Z,GS1
        DEC H:SET 6,A:JR Z,GS1
        DEC H:RES 7,A:JR Z,GS1
        RES 6,A
GS1
        LD (IX+Beta),A


        XOR A
        LD (IX+Alfa),A
        LD (IX+Gama),A

        LD (IX+Mode),0;SIMPLY FLY

        RET










;ГЕНЕРИТЬ ДЕРЕВЬЯ
GEND
        CALL RND
        LD IX,Carsb-Olen
        LD A,L:OR H
        OR #07
        AND #1F
        LD B,A

G1
        EXX

        LD BC,Olen
G3
        ADD IX,BC
        LD A,(IX+1):CP #80
        JR NZ,G3
        LD A,(IX+0):CP #80:RET Z

        CALL RNDT1
        LD A,H
        BIT 7,A:JR Z,$+6
        OR #40:JR $+4:AND #CF
        LD (IX+0),L
        LD (IX+1),A

        CALL RNDT2
        LD A,H
        BIT 7,H:JR Z,$+6
        OR #40:JR $+4:AND #CF
        LD (IX+4),L
        LD (IX+5),A

        LD HL,0
        LD (IX+2),L
        LD (IX+3),H

        CALL RND
        AND 3

        CP 3:JR NZ,$+3:DEC A

.2      RLCA
        OR #80
        LD (IX+Indi),A


;ВЗЯТЬ РЕАЛЬНЫЙ РАЗМЕР СПРАЙТА
        LD L,A,H,L97[
        LD E,(HL):INC HL:LD D,(HL)
        INC DE,DE
        EX DE,HL

        CALL TAKEW

        LD (IX+Alfa),E
        LD (IX+Beta),D

        LD (IX+Rspd),0
        LD (IX+Mode),0


        LD BC,Olen
        ADD IX,BC

        EXX
        DJNZ G1
        RET



FINDOBJ
;ПOИCK ПEPBOГO ПO TИПУ B D
;FZ-ON IF NOT FOUND
        LD IY,Carsb-Olen
        LD BC,Olen
Find2
        CALL Findob
        RET Z
        LD A,(IY+Type)
        CP D
        JP NZ,Find2
        INC A
        RET


FOBJ
;FIND OBJECT
;RET HL-OBJ AD+1
;FZ-ON NO IN BUF OBJS
;FZ-OFF FOUND
        LD HL,Carsb-Olen+1
        LD BC,Olen
        JR $+8
        DEC L
        LD A,(HL)
        CP #80
        RET Z
        INC L
        ADD HL,BC
        LD A,(HL)
        CP #80
        JR Z,$-10
        RET

FNDFREE
;FIND FREE SPACE
;RET FZ-ON IF NOT FOUND
        LD HL,Carsb-Olen+1
        LD DE,Olen
Hhh3
        ADD HL,DE
        LD A,(HL)
        CP #80
        JR NZ,$-4
        DEC L
        LD A,(HL)
        CP #80
        RET Z
        LD A,L
        ADD A,Setup
        LD L,A
        LD A,(HL)
        LD (HL),0
        INC A
        EX AF,AF
        LD A,L
        SUB Setup-1
        LD L,A
        EX AF,AF
        JR Z,Hhh3
        EX AF,AF
        DEC L
        EX AF,AF
        RET

RND
        LD HL,Sdo
        JP RNDo
RNDW
        LD HL,Sdw
        JP RNDo
RNDK1
        LD HL,Sdk1
        JP RNDo
RNDK2
        LD HL,Sdk2
        JP RNDo
RNDK3
        LD HL,Sdk3
        JP RNDo
RNDT2
        LD HL,Sdt2
        JP RNDo
RNDT1
        LD HL,Sdt1
        JP RNDo
RNDL1
        LD HL,Sdl1
        JP RNDo
RNDL2
        LD HL,Sdl2
        JP RNDo
RNDL3
        LD HL,Sdl3
        JP RNDo
Sdw
;ГEHEPATOP KAKOГO ЛAHДШAФTA
        DB 7,8,0
Sdo
        DB 101,2,30
Sdl1
        DB 9,0,30
Sdl2
        DB 231,70,30
Sdl3
        DB 71,1,3
Sdt2
        DB 44,0,0
Sdt1
        DB 21,1,12
Sdk1
        DB 247,33,0
Sdk2
        DB 93,4,65
Sdk3
        DB 29,1,12
RNDo
;IN HL ADR OF SEED
        PUSH BC,DE
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
        LD H,A;0
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
        XOR E,D
        EX DE,HL
        POP DE,BC
        RET



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


SERVICE
        CALL Servms
        CALL Servkj
        CALL Servqa

        LD A,(DIRECTZ)
        LD C,A
        LD A,(DIRECTZ+5):OR C
        JR Z,SV1
        LD A,PG3D:CALL PG
        CALL FLINE
;RET FC-ON ЕСЛИ БЫЛ ВЫСТРЕЛ
        EXA:LD A,PGNORM:CALL PG:EXA
SV1
        LD A,(DIRECTZ+2):OR A
        CALL NZ,ROLDN
        LD A,(DIRECTZ+1):OR A
        CALL NZ,ROLUP
        LD A,(DIRECTZ+4):OR A
        CALL NZ,ROLLT
        LD A,(DIRECTZ+3):OR A
        CALL NZ,ROLRT
        LD A,(DIRECTZ+4)
        LD C,A
        LD A,(DIRECTZ+3):OR C
        EXA:LD A,PGSPR:CALL PG:EXA
        CALL Z,RETURN
        LD A,PGNORM:CALL PG
        RET

;MOUSE DRIVER FROM ZX-FORMAT
DIRECTZ DB 0;FIRE
        DB 0;UP
        DB 0;DOWN
        DB 0;RIGHT
        DB 0;LEFT
        DB 0;CANCEL
        DB 0;MEDIUM

MCOORD  DW 0

;УCTAHABЛИBAЮTCЯ B 1 ECЛИ HAЖATO
Mports  DW 0;CORDS MЫXИ
Nondef  AND 3
        JR Z,Mdrv4
        CP 1
        JR Z,Nondef_
        XOR A
        LD (Mdrv3+2),A
        LD A,5
        LD (Mdrv2+2),A
Nondef_ LD HL,0
        LD (Mdrv1),HL
        POP IX
;MAIN
Servms
        LD A,0
        AND A
        RET NZ
        PUSH IX
        LD HL,DIRECTZ
        PUSH HL
        POP IX
        XOR A
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        INC HL
        LD (HL),A
        LD BC,#FADF
        IN A,(C)
        CPL
Mdrv1   JR Nondef
        RRA
Mdrv2   RL (IX+0)
        RRA
Mdrv3   RL (IX+5)
        RRA
        RL (IX+6)
Mdrv4
        LD DE,(Mports)
        LD BC,#FBDF
        IN A,(C)
        LD (Mports),A
        SUB E
        LD (MCOORD+1),A
        JR Z,Mdrv9
        JP P,Mdrv6
        LD (IX+4),1
        JR Mdrv9
Mdrv6
        LD (IX+3),1
Mdrv9   LD B,#FF
        IN A,(C)
        LD (Mports+1),A
        SUB D
        LD (MCOORD),A
        JR Z,Mdrv14
        NEG
        JP P,Mdrv11
        LD (IX+1),1
        JR Mdrv14
Mdrv11
        LD (IX+2),1
Mdrv14
        POP IX
        RET
Servkj
;SERVICE KEMPSTON JOYSTIC
        LD A,0;FLAG
        AND A
        RET NZ
        IN A,(#1F)
        JP Gomove

Servqa
;SERVICE QAOP SP
        LD E,0,C,#FE
        LD HL,(KUP)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 3,E
        LD HL,(KDOWN)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 2,E
        LD HL,(KLEFT)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 1,E
        LD HL,(KRIGHT)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 0,E
        LD HL,(KFIRE)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 4,E
        LD A,E
Gomove
;BЫ3OB ПPOЦ. И3MEHEHИЯ KOOPДИHATЫ B 3AB
;ИC
;MOCTИ OT HAЖATOЙ KHOПKИ

;И3MEHЯЮTCЯ ПEPEMEHHЫE COCTOЯHИЯ HAЖATИЯ
;KAKИX ЛИБO KЛABИШ LEFT,RIHGT,UP,DOWN,F
;IRE,CANCEL
        LD E,A
        XOR A
        LD D,A
        RRC E
        ADC A,A
        LD HL,DIRECTZ+3
        OR (HL)
        LD (HL),A
        XOR A
        RRC E
        ADC A,A
        LD HL,DIRECTZ+4
        OR (HL)
        LD (HL),A
        XOR A
        RRC E
        ADC A,A
        LD HL,DIRECTZ+2
        OR (HL)
        LD (HL),A
        XOR A
        RRC E
        ADC A,A
        LD HL,DIRECTZ+1
        OR (HL)
        LD (HL),A
        XOR A
        RRC E
        ADC A,A
        LD HL,DIRECTZ
        OR (HL)
        LD (HL),A
        RET


END



        ORG #6000
Font
        INCB "FONT"
        INCL "DATAM"
END0



