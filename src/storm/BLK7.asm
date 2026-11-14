; BLK7 -- restored from awk2/BLK7.C (3902 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
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
        CP Yend+1
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

Findobj
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
Fobj
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
Fndfree
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
;3AДATЬ ДAHHЫE O B3PЫBE И OCKOЛKAX OБЪE
;KTA
;makeexplo
        LD L,(IX+Indi)
        LD H,L97
        LD A,(HL)
        INC L
        LD H,(HL)
        LD L,A
        INC HL
        LD A,(HL)
        AND 7
        EX AF,AF
        LD L,(IX+0)
        LD H,(IX+1)
        LD E,(IX+2)
        LD D,(IX+3)
        LD C,(IX+4)
        LD B,(IX+5)
        LD A,#10
        EXX
        LD HL,Nwvos
        CALL Newvspr
        LD A,1
        LD (Expl+1),A
        LD A,(Cex+1)
        CP #10
        JR NC,$+7
        LD A,#10
        LD (Cex+1),A
        LD A,(IX+Type)
        CP #10
        JP NC,Jj11
        LD HL,+(Carsb-Olen)+1
        LD A,3
Jj12
        EX AF,AF
        LD DE,Olen
        ADD HL,DE
        LD A,(HL)
        CP #80
        JP NZ,$-4
        DEC HL
        LD A,(HL)
        CP #80
        JP Z,Jj11
        LD D,IXH
        LD E,IXL
        EX DE,HL
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LD A,Ioskol
        LD (DE),A
        INC E
        INC E
        INC E
        INC E
        LD A,4
        LD (DE),A
        INC E
        INC E
        XOR A
        LD (DE),A
        INC E
        LD A,R
        LD C,A
        LD B,0
        LD A,(BC)
        LD (DE),A
        INC E
        INC BC
        LD A,(BC)
        LD (DE),A
        INC E
        INC E
        LD A,R
        RLCA
        OR #E0
        LD (DE),A ;SPEED
        INC E
        INC E
        LD A,#10
        LD (DE),A ;TYPE
        INC E
        LD (DE),A ;ENERGY
        INC E
        LD A,#FF
        LD (DE),A
        INC E
        LD (DE),A
        XOR A
        INC E
        LD (DE),A
        LD BC,+(0-Omode)+1
        EX DE,HL
        ADD HL,BC
        EX AF,AF
        DEC A
        JP NZ,Jj12
Jj11
        LD (IX+0),0
        LD (IX+1),#80
        LD (IX+Setup),#FF ;ECЛИ TOЛЬKO
;УБИЛИ
;EXPLOSION
        LD HL,Eff0
        LD (Sfxb+1),HL
        RET
Rastoy
;B3ЯTЬ PACTOЯHИE KPATHOE #100 OT OДHOГO
; OБЪEKTA B IX ДO ДP. B IY
;RET IN A
        LD E,(IX+0)
        LD D,(IX+1)
        LD L,(IY+0)
        LD H,(IY+1)
        AND A
        SBC HL,DE
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        PUSH HL
        LD E,(IX+2)
        LD D,(IX+3)
        LD L,(IY+2)
        LD H,(IY+3)
        AND A
        SBC HL,DE
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        PUSH HL
        LD E,(IX+4)
        LD D,(IX+5)
        LD L,(IY+4)
        LD H,(IY+5)
        AND A
        SBC HL,DE
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        POP DE
        LD A,H
        CP D
        JR NC,$+3
        LD A,D
        POP DE
        CP D
        RET NC
        LD A,D
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
        OUT (C),A
        LD B,#BF
        LD A,#0C
        OUT (C),A
        LD B,#FF
        LD A,7
        OUT (C),A
        LD A,R
        CP #20
        JR C,$+4
        LD A,#20
        AND %00100000
        LD L,A
        IN A,(C)
        AND %11011011
        OR L
        LD B,#BF
        OUT (C),A
        LD A,6
        LD B,#FF
        OUT (C),A
        LD B,#BF
        LD A,5
        OUT (C),A
        LD A,10
        LD B,#FF
        OUT (C),A
        LD B,#BF
Nunu    LD A,0
        SRL A
        CP 4
        JR NC,$+4
        LD A,4
        OUT (C),A
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
