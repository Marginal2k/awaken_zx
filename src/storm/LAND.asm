; LAND -- restored from awk2/LAND.C (11518 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
        INCLUDE "EQUS.asm"



;ПОВЕРХНОСТЬ ПЛАНЕТЫ И НЕБО


        ORG #7C00
START
        LD HL,#4000
        LD DE,#4001
        LD BC,#1800
        LD (HL),L
        LDIR
        LD BC,#02FF
        LD (HL),%00000111
        LDIR

        INCLUDE "LOADER.asm"

        DI

MAKEDRP
        LD A,PGSPR
        CALL PG
        LD HL,MODUL
        LD DE,ADHIDE
        LD BC,DS1-DROPSCR
        LDIR
        EX DE,HL
        LD BC,191*DLEN
        ADD HL,BC
        EX DE,HL
        LD BC,4
        LDIR

        LD BC,#0010
        EXX
        LD DE,DS1
        LD A,96
        LD HL,DS0
        LD BC,DLEN
        EX AF,AF'
MDS1
        EXX
        LD HL,(DS0+1)
        ADD HL,BC
        LD (DS0+1),HL
        LD HL,(DS01+1)
        ADD HL,BC
        LD (DS01+1),HL
        EXX
        PUSH HL
        PUSH BC
        LDIR
        POP BC
        POP HL
        EX AF,AF'
        DEC A
        JR Z,MDS2
        EX AF,AF'
        EXX
        LD HL,(DS0+1)
        ADD HL,BC
        LD (DS0+1),HL
        LD HL,(DS01+1)
        OR A
        SBC HL,BC
        INC H
        LD A,H
        AND 7
        JR NZ,$+12
        LD A,L
        ADD A,32
        LD L,A
        JR C,$+6
        LD A,H
        SUB 8
        LD H,A
        LD (DS01+1),HL
        EXX
        PUSH HL
        PUSH BC
        LDIR
        POP BC
        POP HL
        JR MDS1
MDS2
        LD HL,#8000
        LD (DS0+1),HL
        LD HL,#4010
        LD (DS01+1),HL
        LD A,PGNORM
        CALL PG




        LD HL,0
        LD (Adtt+1),HL
        LD HL,Tbuf
        LD (Atbuf+1),HL
        LD (Frba+1),HL
        INC HL
        LD DE,Tbuf+2
        LD BC,#20
        LD (HL),1
        LDIR
        LD (HL),0
        LD HL,DIRECTZ
        LD DE,DIRECTZ+1
        LD BC,7
        LD (HL),0
        LDIR
        JP DALEE

MODUL
        ORG $
        DISP ADHIDE
DROPSCR
        LD ((STK92+1)+(191*DLEN)),SP
DS0
        LD SP,#8000
        POP HL
        POP DE
        POP BC
        POP AF
        EXX
        EX AF,AF'
        POP HL
        POP DE
        POP BC
        POP AF
DS01    LD SP,#4010
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
        EXX
        EX AF,AF'
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
DS1
DLEN    EQU DS1-DS0

STK92   LD SP,0
        RET



        ENT
        ORG HSCR
;DEFW
DEFW_
        DS Olen*(A3D-1)
        DS Olen
        DW PLANET_
        DW SKYS_
        DB #C3
        DW Messags
        DB #C3
        DW NEWEFA_
        DB #C3
        DW NEWEFB_
        DB #C3
        DW Mnums_
        DW #2B7B
        DB #C3
        DW VOXOBJ_
DDLEN   EQU $-HSCR

        ORG #8C00

DALEE
        LD A,PG3D
        CALL PG
        CALL INIT
        LD A,PGNORM
        CALL PG

        LD HL,DEFW_
        LD DE,VARS
        LD BC,DDLEN
        LDIR


        LD DE,60*256 ;Z
        LD (ZET+1),DE
        LD A,4 ;X
        LD (IKS+1),A
        LD L,A
        LD A,100 ;Y
        LD (IGR+1),A
        LD H,A
        CALL NEWPOS_
        LD DE,40*256 ;Z
        LD L,4 ;X
        LD H,80 ;Y
        CALL NEWPSS_


E1

        LD B,A3D-2
        LD DE,Olen-1
        LD HL,Carsb
D1
        LD (HL),0
        INC L
        LD (HL),#80
        ADD HL,DE
        DJNZ D1
        LD (HL),#80
        INC L
        LD (HL),#80



        CALL GEND


        LD A,#FF
        LD (PLAYER+Type),A
        LD (PLAYER+Mode),A

        XOR A
        LD (SPEED),A


M2

;ГЕНЕРИТЬ СКИМЕРЫ
        CALL GENS



        LD A,PGSPR
        CALL PG
        CALL OUTALL

        LD A,PG3D
        CALL PG
        CALL OUTALL2


        LD A,PGNORM
        CALL PG

;ИНТЕЛЕКТ
        CALL INTEL

        CALL Pricel
        CALL Sfxa
        CALL Timer


        CALL Repanel

        LD A,#7F
        IN A,(#FE)
        RRCA
        PUSH AF
        CALL NC,UP
        POP AF
        RRCA
        PUSH AF
        CALL NC,DOWN
        POP AF
        RRCA
        PUSH AF
        CALL NC,RIGHT
        POP AF
        RRCA
        PUSH AF
        CALL NC,LEFT
        POP AF
        RRCA
        JP NC,EXIT

        CALL SERVICE

        LD A,PGSPR
        CALL PG
        CALL ADHIDE
        LD A,PGNORM
        CALL PG

        JP M2


EXIT
        IM 1
        LD A,#3F
        LD I,A
        LD IY,#5C3A

        LD A,#14
        CALL PG
        LD HL,FILN4
        LD DE,23773
        LD BC,9
        LDIR
        XOR A
        LD HL,#C000
        LD C,#0E
        DI
        CALL #3D13
        LD A,#13
        CALL PG
        LD HL,FILN3
        LD DE,23773
        LD BC,9
        LDIR
        XOR A
        LD HL,#C000
        LD C,#0E
        DI
        CALL #3D13

        LD A,PGNORM
        CALL PG
        EI
        RET

FILN4   DB "PAGE4   C"
FILN3   DB "PAGE3   C"




VOXOBJ_
;A-INDEX
;HL-X,DE-Y,BC-Z
        EXX
        PUSH IX
        PUSH HL
        PUSH DE
        PUSH BC
;ИНДЕКС
        AND #7C
        LD L,A
        SRL L
        LD H,0
        LD DE,VOXAD
        ADD HL,DE
        LD E,(HL)
        INC L
        LD D,(HL)

;РЕАЛЬНЫЕ РАЗМЕРЫ СПРАЙТА
        LD HL,(EYEA)
        EXX
        PUSH HL
        OR #80
        LD L,A
        LD H,high(L97)
        LD A,(HL)
        INC L
        LD H,(HL)
        LD L,A
        INC HL
;MULTIPLY
        LD A,(HL)
        POP HL
        EX AF,AF'
        LD A,PGSPR
        CALL PG
        EX AF,AF'
        CALL D3D2
        LD A,PG3D
        CALL PG

        EXX
        POP BC
        POP DE
        POP HL
        POP IX
        EXX
        JP NXTO

LEFT
        LD DE,(ZET+1)
        LD A,(IKS+1)
        INC A
        LD L,A
        LD (IKS+1),A
        LD A,(IGR+1)
        LD H,A
        JP NEWPOS_


RIGHT
        LD DE,(ZET+1)
        LD A,(IKS+1)
        DEC A
        LD L,A
        LD (IKS+1),A
        LD A,(IGR+1)
        LD H,A
        JP NEWPOS_

NEWPOS_
        LD A,PGSPR
        CALL PG
        CALL NEWPOS
        LD A,PGNORM
        JP PG
NEWPSS_
        LD A,PGSPR
        CALL PG
        CALL NEWPSS
        LD A,PGNORM
        JP PG


UP
ZET     LD DE,0
        LD A,E
        ADD A,#40
        LD E,A
        LD A,D
        ADC A,0
        CP 68
        RET NC
        LD D,A
        LD (ZET+1),DE

;        LD HL,(YPL)
;        LD A,L:SUB 6:LD L,A
;        LD A,H:SBC A,0:LD H,A
;        LD (YPL),HL

IKS     LD L,24
IGR     LD A,38
        ADD A,4
        LD H,A
        LD (IGR+1),A
        JP NEWPOS_

DOWN
        LD DE,(ZET+1)
        LD A,E
        SUB #40
        LD E,A
        LD A,D
        SBC A,0
        CP 57
        RET C
        LD D,A
        LD (ZET+1),DE

;        LD HL,(YPL)
;        LD A,L:ADD A,6:LD L,A
;        LD A,H:ADC A,0:LD H,A
;       LD (YPL),HL

        LD A,(IKS+1)
        LD L,A
        LD A,(IGR+1)
        SUB 4
        LD H,A
        LD (IGR+1),A
        JP NEWPOS_


ROLLT
;ПЕРЕМЕЩЕНИЕ ФОНА ВЛЕВО ВСЕГО ЧТО ЕСТЬ
        LD A,PGSPR
        CALL PG
        CALL RLT
        LD A,PGNORM
        JP PG
ROLRT
;ПЕРЕМЕЩЕНИЕ ФОНА ВПРАВО
        LD A,PGSPR
        CALL PG
        CALL RRT
        LD A,PGNORM
        JP PG

ROLUP
        LD A,%10001000
        RRCA
        LD ($-2),A
        RET NC
        LD A,(SPEED)
        INC A
        JP M,$+6
        CP MSPEED2
        RET NC
        LD (SPEED),A
        CALL TAKSPD
        RET
ROLDN
        LD A,(ROLUP+1)
        RLCA
        LD (ROLUP+1),A
        RET NC
        LD A,(SPEED)
        DEC A
        JP P,$+6
        CP MSPEED
        RET C
        LD (SPEED),A
        CALL TAKSPD
        RET

TAKSPD
        EX AF,AF'
        LD A,PGSPR
        CALL PG
        EX AF,AF'
        CALL TAKESPD
        LD A,PGNORM
        JP PG


PG
        PUSH BC
        LD BC,#7FFD
        OUT A
        POP BC
        RET


;ВЗЯТЬ СЛОВО ИЗ АДРЕСА В HL
;В СТРАНИЦЕ 3D
TAKEW
;HL-АДРЕС СЛОВА
;RET DE-СЛОВО
        LD A,PG3D
        CALL PG
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD A,PGNORM
        CALL PG
        RET

NEWEFA_
;ЗАДАТЬ ЭФЕКТ В КАНАЛЕ А

        RET
NEWEFB_
;ЗАДАТЬ ЭФЕКТ В КАНАЛЕ Б

        RET
VOXAD
        DW DRV1
        DW DRV2
        DW DOMA1








Messags
        DB "AAAA", 0




Mnums_
;NUMBERS IN ORDER PRINT
;A-NUMBER
        LD E,A
        LD D,2
        JR Frba
Mesag
;A-NUMBER OF MESAG
        LD HL,Messags
        AND A
        JR Z,$+13
        LD E,A
        LD BC,#FFFF
        XOR A
        CPIR
        DEC E
        JR NZ,$-3
        EX DE,HL
Frba    LD HL,Tbuf
        LD B,#10
Mg3
        INC HL
        LD A,(HL)
        DEC A
        JR Z,Mg2
        INC A
        JR Z,Mg11
        INC HL
        DJNZ Mg3
        RET
Mg11
        LD HL,Tbuf
        DJNZ Mg3
        RET
Mg2
        LD (HL),D
        DEC HL
        LD (HL),E
        INC HL
        INC HL
        LD (Frba+1),HL
        RET
Tbuf    DS #20, #01
        DW #0000

Print
;HL-TXT,"@"-END
Adtt    LD HL,0
        LD A,H
        OR L
        JR NZ,Pnt3
Atbuf   LD HL,0
        LD E,(HL)
        INC HL
        LD A,(HL)
        CP 2
        JR NZ,Prt1
        LD (HL),1
        LD A,E
        PUSH HL
        PUSH BC
        CALL Prntnum
        POP BC
        POP HL
        LD A,(Cord+1)
        INC A
        LD (Cord+1),A
        LD A,1
Prt1
        AND A
        JR NZ,Prt3
        LD HL,Tbuf
        LD (Atbuf+1),HL
        RET
Prt3
        INC HL
        LD (Atbuf+1),HL
        DEC A
        JR NZ,Prt2
        RET
Prt2
        INC A
        LD D,A
        DEC HL
        LD (HL),1
        EX DE,HL
Pnt3
        LD A,(HL)
        INC HL
        LD (Adtt+1),HL
        OR A
        JR Z,Pnte
        CP 1
        JR Z,Pnt1
        JP Rst10
Pnte
        LD HL,0
        LD (Adtt+1),HL
        RET
Pnt1
        INC HL
        LD (Adtt+1),HL
        XOR A
        LD (Cord+1),A
        JP Scroll
Prntnum
;A-NUMBER
        CP 100
        JR C,Pnum1
        LD C,0
        LD B,100
        SUB B
        INC C
        SUB B
        JR NC,$-2
        ADD A,B
        LD B,A
        LD A,C
        ADD A,"0"
        PUSH BC
        CALL Rst10
        POP AF
Pnum1
        LD B,A
        CP 10
        LD C,0
        JR C,Pnum2
        LD B,10
        SUB B
        INC C
        SUB B
        JP NC,$-2
        ADD A,B
        LD B,A
Pnum2
        LD A,C
        ADD A,"0"
        PUSH BC
        CALL Rst10
        POP AF
        ADD A,"0"
        JP Rst10

Scroll
        LD (Stk5+1),SP
        LD HL,0
        LD SP,#5800
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5700
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5600
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5500
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5400
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5300
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5200
        DUP 32
            PUSH HL
        EDUP
        LD SP,#5100
        DUP 32
            PUSH HL
        EDUP
Stk5    LD SP,0
        RET

Rst10
;A-CODE
        LD BC,Font
        LD L,A
        SRL L
        LD H,0
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,BC
        INC HL
        EX DE,HL
        EX AF,AF
Cord    LD C,0
        LD A,C
        CP #18
        JR C,Rst1
        PUSH DE
        CALL Scroll
        POP DE
        LD C,0 ;BEGIN X OF WIN FOR PR
Rst1
        LD B,C
        LD H,#50
        LD A,#F4
        SRL B
        ADD A,B
        LD L,A
        INC C
        LD A,C
        LD (Cord+1),A
Rst2
        BIT 0,C
        LD B,#F0
        JR NZ,$+4
        LD B,#0F
        EX AF,AF
        RRA
        JR NC,$+6
        LD A,C
        XOR 1
        LD C,A
        BIT 0,C
        LD C,B
        JR NZ,Rpr
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        DUP 4
            RRCA
        EDUP
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        DUP 4
            RRCA
        EDUP
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        DUP 4
            RRCA
        EDUP
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        DUP 4
            RRCA
        EDUP
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        DUP 4
            RRCA
        EDUP
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        DUP 4
            RRCA
        EDUP
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        RRCA
        RRCA
        RRCA
        RRCA
        AND C
        OR B
        LD (HL),A
        RET
Rpr
;ПEЧATЬ БE3 CДBИГA
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        INC H
        INC DE
        LD A,C
        CPL
        AND (HL)
        LD B,A
        LD A,(DE)
        AND C
        OR B
        LD (HL),A
        RET

Pricel
;PИCOBAHИE ПPИЦEЛA B ДAHHЫX KOOPДИHATAX
;BЫBOД HA TEHEBOЙ CKPИH
        LD BC,(Pcord) ;#2B77
        LD H,B
        LD A,C
        SRL H
        RRA
        SRL H
        RRA
        SCF
        RR H
        RRA
        LD L,A
        EX DE,HL
        LD A,C
        AND 7
        RLA
        RLA
        LD L,A
        LD H,0
        LD BC,Mpricel
        ADD HL,BC
        EX DE,HL
        LD BC,#0020
        INC L
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        ADD HL,BC
        DEC L
        INC DE
        LD A,(DE)
        OR (HL)
        LD (HL),A
        INC L
        INC DE
        LD A,(DE)
        OR (HL)
        LD (HL),A
        INC L
        INC DE
        LD A,(DE)
        OR (HL)
        LD (HL),A
        DEC DE
        DEC DE
        DEC DE
        DEC L
        ADD HL,BC
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        ADD HL,BC
        LD A,(DE)
        OR (HL)
        LD (HL),A
        RET

Mpricel
;CПPAЙT ПPИЦEЛA
        DB %10000000
        DB %00011110, %00111100, %00000000
        DB %01000000
        DB %00001111, %00011110, %00000000
        DB %00100000
        DB %00000111, %10001111, %00000000
        DB %00010000
        DB %00000011, %11000111, %10000000
        DB %00001000
        DB %00000001, %11100011, %11000000
        DB %00000100
        DB %00000000, %11110001, %11100000
        DB %00000010
        DB %00000000, %01111000, %11110000
        DB %00000001
        DB %00000000, %00111100, %01111000

Timer
;BЫBOДИЛA BPEMEHИ HA ПPИБ.ПAHEЛЬ,  TAK
;ЖE И3M. EГO
        LD A,%10000000
        RRCA
        LD ($-2),A
        RET NC ;HAДO ЖДATЬ ДO CEKУHДЫ

;CЧИTAEM BPEMЯ
        LD BC,0
        LD HL,(TIME+2) ;#3418
        LD A,L
        ADD A,1
        DAA
        LD L,A
        LD A,H
        JR NC,$+4
        SET 0,B
        ADC A,C
        DAA
        LD H,A
        LD DE,(TIME) ;#0122
        LD A,E
        JR NC,$+4
        SET 1,B
        ADC A,C
        DAA
        LD E,A
        LD A,D
        JR NC,$+4
        SET 2,B
        ADC A,C
        DAA
        LD D,A
Zerotim
        LD (TIME+2),HL
        LD (TIME),DE
;BЫBOД BPEMEHИ
Zerot1
        LD A,L
        LD C,#2F
        CALL Prnum
        LD A,L
        RRCA
        RRCA
        RRCA
        RRCA
        LD C,#2E
        CALL Prnum
        BIT 0,B
        RET Z
        LD A,H
        LD C,#2C
        CALL Prnum
        LD A,H
        RRCA
        RRCA
        RRCA
        RRCA
        LD C,#2B
        CALL Prnum
        BIT 1,B
        RET Z
        LD A,E
        LD C,#29
        CALL Prnum
        LD A,E
        RRCA
        RRCA
        RRCA
        RRCA
        LD C,#28
        CALL Prnum
        BIT 2,B
        RET Z
        LD A,D
        LD C,#27
        CALL Prnum
        LD A,D
        RRCA
        RRCA
        RRCA
        RRCA
        LD C,#26
Prnum
;ПEЧATЬ ЧИCЛA B БЦД И3 PEГ.A
;B KOOPД. B C-KOPД. X
        EXX
        AND #0F
        ADD A,"0"
        LD L,A
        SRL L
        LD H,0
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        LD DE,Font
        ADD HL,DE
        INC HL
        EX DE,HL
        EX AF,AF
        LD B,#10 ;Y KOOPД.
        LD A,B
        AND #18
        OR #40
        INC A
        LD H,A
        LD A,B
        AND 7
        OR A
        RRA
        RRA
        RRA
        RRA
        LD L,A
        EXX
        LD A,C
        EXX
        LD C,A
        SRL A
        ADD A,L
        LD L,A
        INC C
        CALL Rst2
        EXX
        RET


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
        DB 20, 2, %00001000, 11
        DB 1, 1, %00001000, 10
        DB 20, 2, %00001000, 9
        DB 1, 1, %00001000, 10
        DB 20, 2, %00001000, 11
        DB 1, 1, %00001000, 10, 0
Eff13
        DB 20, 0, %00000000, 10
        DB 10, 0, %00000000, 9
        DB 20, 0, %00000000, 8
        DB 10, 0, %00000000, 7
        DB 20, 0, %00000000, 6
        DB 10, 0, %00000000, 5, 0
Eff19
        DB 80, 1, %00001000, 8
        DB 70, 1, %00001000, 8
        DB 60, 1, %00001000, 8
        DB 80, 1, %00001000, 8
        DB 70, 1, %00001000, 9
        DB 60, 1, %00001000, 9
        DB 80, 1, %00001000, 9
        DB 70, 1, %00001000, 10
        DB 60, 1, %00001000, 10
        DB 80, 1, %00001000, 10
        DB 70, 1, %00001000, 11
        DB 60, 1, %00001000, 11
        DB 80, 1, %00001000, 11
        DB 70, 1, %00001000, 12
        DB 60, 1, %00001000, 13
        DB 70, 1, %00001000, 13, 0
Eff1
        DB 40, 0, %00000000, 10
        DB 50, 0, %00000000, 9
        DB 40, 0, %00000000, 8
        DB 50, 0, %00000000, 7
        DB 40, 0, %00000000, 6
        DB 50, 0, %00000000, 5, 0
Eff14
        DB 20, 1, %00000000, 10
        DB 10, 1, %00000000, 9
        DB 20, 1, %00000000, 8
        DB 10, 1, %00000000, 7
        DB 20, 1, %00000000, 6
        DB 10, 1, %00000000, 5, 0
Eff2
;SHOOT1
        DB #10, 1, %00001000, 12
        DB #40, 1, %00001000, 11
        DB #70, 1, %00001000, 10
        DB #20, 2, %00001000, 9
        DB #E0, 2, %00001000, 8
        DB #20, 3, %00001000, 7, 0

Eff0
;EXPLOSION
        DB #10, 8, %00001000, 15
        DB #10, 8, %00001001, 15
        DB #10, 8, %00000000, 15
        DB #80, 8, %00000000, 15
        DB #10, 8, %00000001, 15
        DB #80, 7, %00001001, 15
        DB #80, 7, %00000001, 15
        DB #80, 5, %00000001, 15
        DB #80, 4, %00000000, 14
        DB #80, 3, %00000001, 14
        DB 1, 0, %00000001, 14
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000000, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000000, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 13
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 12
        DB 1, 0, %00000001, 12
        DB 1, 0, %00000001, 12
        DB 1, 0, %00000001, 12
        DB 1, 0, %00000001, 12
        DB 1, 0, %00000001, 11
        DB 1, 0, %00000001, 10
        DB 1, 0, %00000001, 9
        DB 1, 0, %00000001, 8
        DB 1, 0, %00000001, 8
        DB 1, 0, %00000001, 8
        DB 1, 0, %00000001, 8
        DB 1, 0, %00000001, 7
        DB 1, 0, %00000001, 6
        DB 1, 0, %00000001, 5
        DB 1, 0, %00000001, 4
        DB 1, 0, %00000001, 3, 0

Eff11
        DB 100, 2, 4, 9
        DB 100, 3, 4, 7
        DB 100, 2, 4, 5
        DB 100, 3, 4, 4
        DB 100, 2, 4, 2
        DB 100, 3, 4, 1, 0

Eff21
        DB 200, 1, 32, 12
        DB 2, 0, 0, 11
        DB 50, 0, 0, 12
        DB 50, 0, 4, 7
        DB 50, 0, 4, 1, 0





Datal
;HL-ADR ON SCREEN
;A-MEAN
        LD C,A
        AND A
        JR Z,Dln1 ;ECЛИ BOOБЩE = 0
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
        DUP 5
            LD (HL),E
            INC H
        EDUP
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
        DUP 5
            LD (DE),A
            INC D
        EDUP
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
        CALL Datalin ;ИHДИKATOPЫ
        LD HL,(TIME+2)
        LD DE,(TIME)
        LD B,#FF
        JP Zerot1 ;BPEMЯ






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
        DUP 5
            ADD HL,HL
        EDUP
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




        ORG (($+255)&#FF00)
PLANET_
        INCBIN "assets/planet.bin"
SKYS_
        INCBIN "assets/CHAN6.bin"
DRV1
        INCBIN "assets/DRV1_lc.bin"
DRV2
        INCBIN "assets/DRV2_lc.bin"
DOMA1
        INCBIN "assets/DOMA1_lc.bin"




INTEL
;ИНТЕЛЕКТ ПОВЕДЕНИЯ КОРАБЛЕЙ
        LD IX,Carsb-Olen
        JR I2
I1
        LD A,(IX+0)
        CP #80
        RET Z
I2
        LD DE,Olen
        ADD IX,DE
        LD A,(IX+1)
        CP #80
        JR Z,I1
        LD A,(IX+Mode)
        RLCA
        LD L,A
        LD H,0
        LD DE,MODES
        ADD HL,DE
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        LD DE,RET_
        PUSH DE
        JP (HL)
RET_
        LD A,PG3D
        CALL PG
        LD A,(IX+Rspd)
        OR A
        JR Z,I4
        LD D,0
        LD E,A
        CALL MOVEON
I3
        CALL PRECORD
        LD A,PGNORM
        CALL PG
        JP I2
I4
        CALL NULMOVE
        JR I3



MODES
        DW FREEFLY
        DUP 10
            DW NTH
        EDUP

FREEFLY
        RET

NTH
        RET







;ГЕНЕРИТЬ СКИММЕРЫ
GENS
        LD A,#01
        RRCA
        LD ($-2),A
        RET NZ
        LD A,R
        CP 22
        RET NC
        CALL FNDFREE
        RET Z
        PUSH HL
        POP IX
        CALL RNDL1

        LD A,H
        AND %11000000
        OR #60
        LD (IX+Rspd),A

        RL H
        LD H,Spacebd-3
        LD A,0
        JR NC,$+5
        LD H,+(0-Spacebd)+3
        INC A
        LD (IX+0),L
        LD (IX+1),H

        PUSH AF
        CALL RNDL2
        POP AF

        RL H
        LD H,Spacebd-3
        JR NC,$+6
        LD H,+(0-Spacebd)+3
        ADD A,2
        LD (IX+4),L
        LD (IX+5),H


        PUSH AF

        CALL RNDK1
        AND 3
        DUP 2
            RLCA
        EDUP
        LD (IX+Indi),A

        POP AF
        INC A
        LD H,A
        LD A,L
        AND #3F
        DEC H
        SET 7,A
        JR Z,GS1
        DEC H
        SET 6,A
        JR Z,GS1
        DEC H
        RES 7,A
        JR Z,GS1
        RES 6,A
GS1
        LD (IX+Beta),A


        XOR A
        LD (IX+Alfa),A
        LD (IX+Gama),A

        LD (IX+Mode),0 ;SIMPLY FLY

        RET










;ГЕНЕРИТЬ ДЕРЕВЬЯ
GEND
        CALL RND
        LD IX,Carsb-Olen
        LD A,L
        OR H
        OR #07
        AND #1F
        LD B,A

G1
        EXX

        LD BC,Olen
G3
        ADD IX,BC
        LD A,(IX+1)
        CP #80
        JR NZ,G3
        LD A,(IX+0)
        CP #80
        RET Z

        CALL RNDT1
        LD A,H
        BIT 7,A
        JR Z,$+6
        OR #40
        JR $+4
        AND #CF
        LD (IX+0),L
        LD (IX+1),A

        CALL RNDT2
        LD A,H
        BIT 7,H
        JR Z,$+6
        OR #40
        JR $+4
        AND #CF
        LD (IX+4),L
        LD (IX+5),A

        LD HL,0
        LD (IX+2),L
        LD (IX+3),H

        CALL RND
        AND 3

        CP 3
        JR NZ,$+3
        DEC A

        DUP 2
            RLCA
        EDUP
        OR #80
        LD (IX+Indi),A


;ВЗЯТЬ РЕАЛЬНЫЙ РАЗМЕР СПРАЙТА
        LD L,A
        LD H,high(L97)
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC DE
        INC DE
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
        LD HL,+(Carsb-Olen)+1
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
        LD HL,+(Carsb-Olen)+1
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
        DB 7, 8, 0
Sdo
        DB 101, 2, 30
Sdl1
        DB 9, 0, 30
Sdl2
        DB 231, 70, 30
Sdl3
        DB 71, 1, 3
Sdt2
        DB 44, 0, 0
Sdt1
        DB 21, 1, 12
Sdk1
        DB 247, 33, 0
Sdk2
        DB 93, 4, 65
Sdk3
        DB 29, 1, 12
RNDo
;IN HL ADR OF SEED
        PUSH BC
        PUSH DE
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
        XOR E,D
        EX DE,HL
        POP DE
        POP BC
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
        LD A,(DIRECTZ+5)
        OR C
        JR Z,SV1
        LD A,PG3D
        CALL PG
        CALL FLINE
;RET FC-ON ЕСЛИ БЫЛ ВЫСТРЕЛ
        EX AF,AF'
        LD A,PGNORM
        CALL PG
        EX AF,AF'
SV1
        LD A,(DIRECTZ+2)
        OR A
        CALL NZ,ROLDN
        LD A,(DIRECTZ+1)
        OR A
        CALL NZ,ROLUP
        LD A,(DIRECTZ+4)
        OR A
        CALL NZ,ROLLT
        LD A,(DIRECTZ+3)
        OR A
        CALL NZ,ROLRT
        LD A,(DIRECTZ+4)
        LD C,A
        LD A,(DIRECTZ+3)
        OR C
        EX AF,AF'
        LD A,PGSPR
        CALL PG
        EX AF,AF'
        CALL Z,RETURN
        LD A,PGNORM
        CALL PG
        RET

;MOUSE DRIVER FROM ZX-FORMAT
DIRECTZ DB 0 ;FIRE
        DB 0 ;UP
        DB 0 ;DOWN
        DB 0 ;RIGHT
        DB 0 ;LEFT
        DB 0 ;CANCEL
        DB 0 ;MEDIUM

MCOORD  DW 0

;УCTAHABЛИBAЮTCЯ B 1 ECЛИ HAЖATO
Mports  DW 0 ;CORDS MЫXИ
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
        LD A,0 ;FLAG
        AND A
        RET NZ
        IN A,(#1F)
        JP Gomove

Servqa
;SERVICE QAOP SP
        LD E,0
        LD C,#FE
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


END_



        ORG #6000
Font
        INCBIN "assets/FONT.bin"
        INCLUDE "DATAM.asm"
END0
