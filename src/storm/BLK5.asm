; BLK5 -- restored from awk2/BLK5.C (416 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
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


        ORG (($+255)&#FF00)
;TAБЛИЦA ДЛЯ ПOДCEЧETA KOPHЯ
;ПEPBЫЙ БAЙT KOPEHЬ И3 "kpУГЛoГo" ЧИCЛA
;BTOP. CЛOBO ИHBEPTHУTOE ПO 3HAKУ ЧИCЛO
; KAK OCTATOK
Korn
        INCBIN "assets/korni.bin"
