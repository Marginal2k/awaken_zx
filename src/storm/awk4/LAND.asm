; LAND -- restored from awk4/LAND.C (15557 bytes, plain-text STORM export)
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
