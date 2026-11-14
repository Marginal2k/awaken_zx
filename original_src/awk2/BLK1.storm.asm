;ПPOЦEДУPЫ УПPABЛEHИЯ KOPAБЛEM, OПPEДEЛ
;EHИE EГO
;CTOЛKHOBEHИЙ

Moveu
        CALL Touch;GOING THROUGH STA
;T OBJECTS
        CALL Setcont;GET CONTROL
;SETTINGS
        JP Calcstp
Touch
Cmode   LD A,0
        AND A
        RET Z
        LD (Fspeed+1),A
        LD HL,(Speed)
        BIT 7,H
        EX AF,AF
        JR Z,$+9
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        LD BC,2
        AND A
        SBC HL,BC
        EX AF,AF
        JR Z,$+9
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EX AF,AF
        JR NC,$+6
        LD (Speed),HL
        RET
        XOR A
        LD (Cmode+1),A
        RET
Lm1
        LD A,1
        LD (Cmode+1),A
        LD HL,(Stpx+1)
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        LD (Stpx+1),HL
        LD HL,(Stpz+1)
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        LD (Stpz+1),HL
        LD HL,(Stpy+1)
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        LD (Stpy+1),HL
        LD HL,(Speed)
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        SRA H
        RR L
        INC HL
        LD (Speed),HL
        RET

Rain
        DEC (HL)
        LD A,(Tonn)
        DEC A
        LD (Tonn),A
        LD A,17;PAKETA УШЛA
        CALL Mesags
        LD A,10;OCTAЛOCЬ
        CALL Mesags
        CALL Aroks
        CALL Mnums
        LD A,11;PAKET
        JP Mesags
Nocels
        PUSH AF
        LD A,15;HE БЫЛO 3AXBAЧEHO
;HE OДHOЙ ЦEЛИ
        CALL Mesags
        POP AF
        RET
Aroks
        LD HL,Roks+1
        LD A,(HL)
        AND A
        RET NZ
        DEC HL
        LD A,(HL)
        RET

;ЧTEHИE KHOПOK УПPABЛEHИЯ И УПPABЛEHИE
Setcont
        LD IX,Lc5b6
;IX-БУФEP KHOПOK УПPABЛEHИЯ
        LD A,(Counter+1)
        AND A
        JP NZ,Blk11
        CALL Aroks
        AND A
        JR NZ,Rtn1
        LD A,(IX+3)
        CPL
        AND 7
        JP Z,Blk11
        LD A,#FF
        LD (Roketn3),A
        LD (Roketn2),A
        LD (Roketn1),A
        LD A,12;PAKET HET
        CALL Mesags
        JP Blk11
Rtn1
;ПPOBEPKA KHOПOK ПУCKA PAKET
        BIT 2,(IX+3);3
        JR NZ,Rkn21
        LD A,5
        LD (Counter+1),A
        LD A,(Roketn3)
        INC A
        CALL Z,Nocels
        JR Z,Rkn21
        LD HL,Eff13
        LD (Sfxa+1),HL
        DEC A
        LD H,A
        LD C,A
        LD A,#FF
        LD (Roketn3),A
        CALL Newrokt
        JP NC,Rkn21
        LD HL,0-Subj+Type
        ADD HL,DE
        LD B,(HL)
        CALL Chstat_
        CALL Aroks
        CALL Rain
Rkn21
        BIT 1,(IX+3);2
        JR NZ,Rkn31
        LD A,5
        LD (Counter+1),A
        LD A,(Roketn2)
        INC A
        CALL Z,Nocels
        JR Z,Rkn31
        LD HL,Eff13
        LD (Sfxa+1),HL
        DEC A
        LD H,A
        LD C,A
        LD A,#FF
        LD (Roketn2),A
        CALL Newrokt
        JP NC,Rkn31
        LD HL,0-Subj+Type
        ADD HL,DE
        LD B,(HL)
        CALL Chstat_
        CALL Aroks
        CALL Rain
Rkn31
        BIT 0,(IX+3);1
        JR NZ,Blk11
        LD A,5
        LD (Counter+1),A
        LD A,(Roketn1)
        INC A
        CALL Z,Nocels
        JR Z,Blk11
        LD HL,Eff13
        LD (Sfxa+1),HL
        DEC A
        LD H,A
        LD C,A
        LD A,#FF
        LD (Roketn1),A
        CALL Newrokt
        JP NC,Blk11
        LD HL,0-Subj+Type
        ADD HL,DE
        LD B,(HL)
        CALL Chstat_
        CALL Aroks
        CALL Rain
Blk11
        BIT 4,(IX+0);V
        BIT 3,(IX+0);C
        CALL Z,Clrmark
        BIT 0,(IX+2);Q
        CALL Z,Unroket
        BIT 0,(IX+5);P
        CALL Z,Towar
        BIT 1,(IX+5);O
        CALL Z,Karta
        BIT 2,(IX+5);I
        CALL Z,Missio
        BIT 4,(IX+1);G
        CALL Z,Hiper
        BIT 2,(IX+2);E
        CALL Z,Dropcr
        BIT 1,(IX+2);W
        CALL Z,Dropmin
        BIT 3,(IX+2);R
        CALL Z,Returns


        BIT 4,(IX+6);H;BKЛЮЧИTЬ PEЖИ
;M 3AXBATA ЦEЛИ
        CALL Z,Navod
        BIT 4,(IX+7);B;PEЖИM 3AXBATA
; OБЪEKTA K CEБE
        CALL Z,Zahwat
        BIT 1,(IX+#01);S
        CALL Z,Upp
        BIT 2,(IX+#00);X
        CALL Z,Downn
        BIT 3,(IX+#07);N
        CALL Z,Leftt
        BIT 2,(IX+#07);M
        CALL Z,Rightt
        BIT 2,(IX+#06);K
        CALL Z,Leftf
        BIT 1,(IX+#06);L
        CALL Z,Rightf
        BIT 0,(IX+1);A
        CALL Z,Fline2
        BIT 3,(IX+6);J
        CALL Z,Jumpdrv
        BIT 2,(IX+1);D
        CALL Z,Snarad
        BIT 3,(IX+1);F
        BIT 1,(IX+0);Z
        LD A,(Calcstp)
        CP #3A
        JR NZ,Nopwr
        LD A,(Jflag+1)
        AND A
        JR NZ,Nopwr
        BIT 0,(IX+#07);SP
        CALL Z,Gaz
        BIT 1,(IX+#07);SS
        CALL Z,Tormoz
Nopwr
;ГAШEHИE PA3ГOHOB ПOBOPOTOB И JAMПOB
Mxspd   EQU 150
        BIT 3,(IX+6);J
        JR Z,Nopwr2
        LD HL,(Maxspd+1)
        LD BC,Mxspd
        AND A
        SBC HL,BC
        JR Z,Nopwr2
        LD HL,Mxspd
        LD (Maxspd+1),HL
        LD HL,Mxspd
        LD (Speed),HL
        LD A,1
        LD (Fspeed+1),A
Nopwr2
        LD A,(IX+6);KL
        RRCA
        LD L,A
        AND L
        RRCA
        JR NC,Kl3
        LD A,200
        LD (Rif1+1),A
        LD (Lef1+1),A
        LD A,%10010010
        RRCA
        LD ($-2),A
        JR NC,Kl3
        LD A,(Eye_b)
        AND A
        JR Z,Kl3
        CALL P,Kl
        ADD A,1
        CALL M,Kl2
        XOR A
        JP Kl2
Kl
        SUB 1
        CALL P,Kl2
        XOR A
Kl2
        LD (Eye_b),A
Kl3
        LD A,(IX+1)
        RRCA
        LD C,A
        LD A,(IX+0)
        RRCA
        RRCA
        AND C
        RRCA
        JR NC,Kl6
        LD A,200
        LD (Upp1+1),A
        LD (Dwn1+1),A
        LD A,%10010010
        RRCA
        LD ($-2),A
        JR NC,Kl6
        LD A,(Eye_a)
        AND A
        JR Z,Kl6
        CALL P,Kl4
        ADD A,1
        CALL M,Kl5
        XOR A
        JP Kl5
Kl4
        SUB 1
        CALL P,Kl5
        XOR A
Kl5
        LD (Eye_a),A
Kl6
        LD A,(IX+7)
        RRCA
        RRCA
        LD L,A
        RRCA
        AND L
        RRCA
        RET NC
        LD A,250
        LD (Let1+1),A
        LD (Rit1+1),A
        LD A,%10010010
        RRCA
        LD ($-2),A
        RET NC
        LD A,(Eye_g)
        AND A
        RET Z
        CALL P,Kl7
        ADD A,1
        CALL M,Kl8
        XOR A
        JP Kl8
Kl7
        SUB 1
        CALL P,Kl8
        XOR A
Kl8
        LD (Eye_g),A
        RET


Unroket
;ПPOTИBOPAKETHAЯ CИCTEMA
        LD A,(Counter+1)
        AND A
        RET NZ
        LD A,5
        LD (Counter+1),A
        LD A,20;AKTИBИPOBAHA ПPOTИ
;BOPAKETHAЯ
        CALL Mesags
        LD HL,Eff19
        LD (Sfxa+1),HL
        LD HL,Carsb-Olen+1
        LD DE,Olen
        JP Stu1
Stu3
        DEC L
        LD A,(HL)
        CP #80
        RET Z
        INC L
Stu1
        ADD HL,DE
        LD A,(HL)
        CP #80
        JR Z,Stu3
        LD A,L
        ADD A,Type-1
        LD L,A
        LD C,(HL)
        DEC L
        DEC L
        DEC L
        LD B,(HL)
        SUB Type-1
        LD L,A
        LD A,C
        CP #11
        JR NZ,Stu1
        LD A,B
        CP Splayer
        JR NZ,Stu1
        PUSH IX
        DEC L
        PUSH HL
        POP IX
        SET 0,(IX+Actn);BЫCTPEЛ ЛA3EPA
        SET 3,(IX+Actn);HO ПPOTPAKET
;HOЙ CИCTEMЫ
;PИC.ЛИHИИ OT ИГPOKA K PAKETE
        LD A,(IX+Px+1)
        CP #80
        SCF
        JR Z,Noanti
        LD B,A
        LD C,(IX+Px)
        LD L,(IX+Py)
        LD H,(IX+Py+1)
        LD E,(IX+Pz)
        LD D,(IX+Pz+1)
        EXX
        LD BC,3
        LD (Tx+1),BC
        LD (Dx+1),BC
        LD (Dy+1),BC
        LD (Dz+1),BC
        LD HL,#B0
        LD (Ty+1),HL
        LD DE,0-1
        LD (Tz+1),DE
        CALL Fg1
Noanti
        POP IX
        RET
Clrmark
;OTMEHИTЬ 3AXBAT ЦEЛEЙ
        LD A,(Counter+1)
        AND A
        RET NZ
        LD A,7
        LD (Counter+1),A
        LD HL,Eff13
        LD (Sfxa+1),HL
        LD A,#FF
        LD (Roketn1),A
        LD (Roketn2),A
        LD (Roketn3),A
        LD A,21;ЦEЛИ CHЯTЫ
        JP Mesags
Navod
;PEЖИM HABEДEHИЯ PAKETЫ
        LD A,(Counter+1)
        AND A
        RET NZ
        LD HL,Eff13
        LD (Sfxa+1),HL
        LD A,7
        LD (Counter+1),A
        LD A,(Fnavod+1)
        XOR 1
        LD (Fnavod+1),A
        LD A,2;PEЖИM BKЛ
        JR NZ,$+4
        LD A,3;PEЖИM BЫKЛ
        CALL Mesags
        LD A,5;HABEДEHИЯ PAKET
        JP Mesags
Fline2
;KHOПKA FIRE
;B PA3HЫX PEЖИMAX
        JP Fline


Jumpdrv
;ФOPCИPOBKA ДBИГATEЛЯ
        LD A,(Calcstp)
        CP #C9
        RET Z
        LD A,1
        LD (Jflag+1),A
;ПPOBEPЯEM БЛИ3OCTЬ ДPУГИX OБЪEKTOB
;ECЛИ XOTЬ OДИH БЛИ3KO TO OTMEHA
        LD HL,Carsb-Olen+1
        LD DE,Olen
        JR $+9
        DEC L
        LD A,(HL)
        INC L
        CP #80
        JR Z,Fuel_
Jjd1
        ADD HL,DE
        LD A,(HL)
        CP #80
        JR Z,$-11
        AND A
        CALL P,$+4
        CPL
        LD C,A
        LD A,L
        ADD A,Type-1
        LD L,A
        LD B,(HL)
        SUB Type-1
        LD L,A
        LD A,B
        CP #12
        JR Z,Nxtj
        CP #10
        JR NC,Jjd1
Nxtj
        INC L
        INC L
        LD A,(HL)
        AND A
        CALL P,$+4
        CPL
        OR C
        LD C,A
        INC L
        INC L
        LD A,(HL)
        AND A
        CALL P,$+4
        CPL
        OR C
        LD C,A
        LD A,L
        SUB 4
        LD L,A
        LD A,C
        CP Jmin;MИH.PACTOЯHИE ДЛЯ ДЖAMПA
        JP NC,Jjd1
        SET 3,(IX+6);J
        RET
Afuel
        LD HL,Fuel
        LD A,(HL)
        AND A
        RET NZ
        INC HL
        LD A,(HL)
        RET
Fuel_
        CALL Afuel
        LD C,A
        DEC C
        SET 3,(IX+6);J
        RET M
        RES 3,(IX+6)
        LD A,0
        INC A
        LD ($-2),A
        JR NZ,Jkl2
        LD A,0
        INC A
        AND 7
        LD ($-4),A
        JR NZ,Jkl2
        LD (HL),C
        LD A,(Tonn)
        DEC A
        LD (Tonn),A
        LD A,1
        LD (Ffuel+1),A
Jkl2
        LD HL,(Maxspd+1)
        LD BC,64
        ADD HL,BC
        LD A,H
        AND %00011000
        CP %00011000
        RET Z
        LD (Maxspd+1),HL
        SET 0,(IX+7)
        CALL Gaz
        JP Gaz


Leftf
Lef1    LD A,0
        ADD A,70
        LD (Lef1+1),A
        LD A,200
        LD (Rif1+1),A
        RET NC
        LD A,(Eye_b);UNGLE OF TURN
        SUB 1
        CALL M,$+5
        LD A,#FF
        CP #0100-Mane2
        RET C
        LD (Eye_b),A
        RET
Rightf
Rif1    LD A,0
        ADD A,70
        LD (Rif1+1),A
        LD A,200
        LD (Lef1+1),A
        RET NC
        LD A,(Eye_b)
        ADD A,1
        CALL P,$+5
        LD A,1
        CP Mane2+1
        RET NC
        LD (Eye_b),A
        RET

;YOUR TURNS
Calcstp
        LD A,(Sm_13+1)
Bfc1    DW 0
        LD DE,(Speed)
        LD IX,$+7
        JP Lc52c
        LD (Stpx+1),HL
        LD A,(Sm_23+1)
Bfc2    DW 0
        LD DE,(Speed)
        LD IX,$+7
        JP Lc52c
        LD (Stpy+1),HL
        LD A,(Sm_33+1)
Bfc3    DW 0
        LD DE,(Speed)
        LD IX,$+7
        JP Lc52c
        LD (Stpz+1),HL
        RET


;BEGIN CONTROL PROCS
Readkey
        CALL Lc5a5;IN REN3D

        LD HL,Lc5b6
        XOR A
        LD B,8
Exk2
        LD D,#FF
        LD E,(HL)
_RR E:CCF:ADC A,0:CP 4:JR NC,Exk:RL D
_RR E:CCF:ADC A,0:CP 4:JR NC,Exk:RL D
_RR E:CCF:ADC A,0:CP 4:JR NC,Exk:RL D
_RR E:CCF:ADC A,0:CP 4:JR NC,Exk:RL D
_RR E:CCF:ADC A,0:CP 4:JR NC,Exk:RL D
        INC HL
        DJNZ Exk2
        RET
Exk
        LD A,(HL)
        OR D
        LD (HL),A
Exk4
        DJNZ Exk3
        RET
Exk3
        INC HL
        LD (HL),#FF
        JP Exk4

