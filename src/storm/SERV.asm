; SERV -- restored from awk2/SERV.C (1417 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;MOUSE DRIVER FROM ZX-FORMAT
Directz DB 0 ;FIRE
        DB 0 ;UP
        DB 0 ;DOWN
        DB 0 ;RIGHT
        DB 0 ;LEFT
        DB 0 ;CANCEL
        DB 0 ;MEDIUM
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
        LD HL,Directz
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
Mdrv4   LD HL,(Mcoord)
        LD DE,(Mports)
        LD BC,#FBDF
        IN A,(C)
        LD (Mports),A
        SUB E
        JR Z,Mdrv9
        JP P,Mdrv6
        LD (IX+4),1
Zcm3    ADD A,A
        ADD A,L
        JR C,Mdrv5
        XOR A
Mdrv5   LD L,A
        JR Mdrv9
Mdrv6
Zcm4    ADD A,A
        ADD A,L
        LD (IX+3),1
        JR C,Mdrv7
        CP #FE
        JR C,Mdrv8
Mdrv7   LD A,#FE
Mdrv8   LD L,A
Mdrv9   LD B,#FF
        IN A,(C)
        LD (Mports+1),A
        SUB D
        JR Z,Mdrv14
        NEG
        JP P,Mdrv11
        LD (IX+1),1
Zcm1    ADD A,A
        ADD A,H
        JR C,Mdrv10
        XOR A
Mdrv10  LD H,A
        JR Mdrv14
Mdrv11
Zcm2    ADD A,A
        ADD A,H
        LD (IX+2),1
        JR C,Mdrv12
        CP #BF
        JR C,Mdrv13
Mdrv12  LD A,#BF
Mdrv13  LD H,A
Mdrv14  LD (Mcoord),HL
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
        SET 3,E ;UP
        LD HL,(KDOWN)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 2,E ;DOWN
        LD HL,(KLEFT)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 1,E ;LEFT
        LD HL,(KRIGHT)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 0,E ;RIGHT
        LD HL,(KFIRE)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 4,E ;FIRE
        LD HL,(KCANCEL)
        LD B,L
        IN A,(C)
        AND H
        JR NZ,$+4
        SET 5,E ;CANCEL
        LD A,E
Gomove
;BЫ3OB ПPOЦ. И3MEHEHИЯ KOOPДИHATЫ B 3AB
;ИC
;MOCTИ OT HAЖATOЙ KHOПKИ

;И3MEHЯЮTCЯ ПEPEMEHHЫE COCTOЯHИЯ HAЖATИЯ
;KAKИX ЛИБO KЛABИШ LEFT,RIHGT,UP,DOWN,F
;IRE,CANCEL
        LD E,A
        LD HL,Directj
        XOR A
        LD D,A
        RRC E
        ADC A,A
        OR (HL)
        LD (HL),A
        INC HL
        XOR A
        RRC E
        ADC A,A
        OR (HL)
        LD (HL),A
        INC HL
        XOR A
        RRC E
        ADC A,A
        OR (HL)
        LD (HL),A
        INC HL
        XOR A
        RRC E
        ADC A,A
        OR (HL)
        LD (HL),A
        INC HL
        XOR A
        RRC E
        ADC A,A
        OR (HL)
        LD (HL),A
        INC HL
        XOR A
        RRC E
        ADC A,A
        OR (HL)
        LD (HL),A

Cler
;ЦБPOCИTЬ COCTOЯHИЯ ПPEДЫДУЩEГO ДEЙCTBИЯ
        LD HL,Directj
        XOR A
        DUP 5
            LD (HL),A
            INC HL
        EDUP
        LD (HL),A
        RET
Directj
        DB 0 ;RIGHT
        DB 0 ;LEFT
        DB 0 ;DOWN
        DB 0 ;UP
        DB 0 ;FIRE
        DB 0 ;CANCEL
