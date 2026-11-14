;ПЛEЙEP CEMПЛEB
; NOTE2
; "sfx"-IS A LOOP, WHICH CONTAINS
; IS A ADDRESS OF THE SOUND EFFECT
;
Sfxa:
            ld   hl,0
            ld   a,h
            or   a
            jr   z,Sfxb
            ld   bc,#FFFD
            xor  a
            out  (c),a
            ld   b,#BF
            outi 
            ld   b,#FF
            ld   a,1
            out  (c),a
            ld   b,#BF
            outi 
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            and  %11110110
            or   (hl)
            ld   b,#BF
            out  (c),a
            inc  hl
            ld   a,8
            ld   b,#FF
            out  (c),a
            ld   b,#BF
            outi 
            ld   (Sfxa+1),hl
            ld   a,(hl)
            or   a
            jr   nz,Sfxb
            ld   (Sfxa+2),a
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            or   %00001001
            ld   b,#BF
            out  (c),a
Sfxb:
            ld   hl,0
            ld   a,h
            or   a
            jr   z,Sfxn
            ld   bc,#FFFD
            ld   a,2
            out  (c),a
            ld   b,#BF
            outi 
            ld   b,#FF
            ld   a,3
            out  (c),a
            ld   b,#BF
            outi 
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            and  %11101101
            ld   b,a
            ld   a,(hl)
            rlca 
            or   b
            ld   b,#BF
            out  (c),a
            inc  hl
            ld   a,9
            ld   b,#FF
            out  (c),a
            ld   b,#BF
            outi 
            ld   (Sfxb+1),hl
            ld   a,(hl)
            or   a
            jr   nz,Sfxn
            ld   (Sfxb+2),a
            ld   b,#FF
            ld   a,7
            out  (c),a
            in   a,(c)
            or   %00010010
            ld   b,#BF
            out  (c),a
Sfxn:
            ld   c,#FD
            ld   b,#FF
            ld   a,5
            out  a
            ld   b,#BF
            ld   a,#0C
            out  a
            ld   b,#FF
            ld   a,7
            out  a
            ld   a,r
            cp   #20
            jr   c,$+4
            ld   a,#20
            and  %00100000
            ld   l,a
            in   a
            and  %11011011
            or   l
            ld   b,#BF
            out  a
            ld   a,6
            ld   b,#FF
            out  a
            ld   b,#BF
            ld   a,5
            out  a
            ld   a,10
            ld   b,#FF
            out  a
            ld   b,#BF
Nunu:       ld   a,0
            srl  a
            cp   4
            jr   nc,$+4
            ld   a,4
            out  a
            ret  
Roka:
            db   20,2,%00001000,11
            db   1,1,%00001000,10
            db   20,2,%00001000,9
            db   1,1,%00001000,10
            db   20,2,%00001000,11
            db   1,1,%00001000,10,0
Eff13:
            db   20,0,%00000000,10
            db   10,0,%00000000,9
            db   20,0,%00000000,8
            db   10,0,%00000000,7
            db   20,0,%00000000,6
            db   10,0,%00000000,5,0
Eff19:
            db   80,1,%00001000,8
            db   70,1,%00001000,8
            db   60,1,%00001000,8
            db   80,1,%00001000,8
            db   70,1,%00001000,9
            db   60,1,%00001000,9
            db   80,1,%00001000,9
            db   70,1,%00001000,10
            db   60,1,%00001000,10
            db   80,1,%00001000,10
            db   70,1,%00001000,11
            db   60,1,%00001000,11
            db   80,1,%00001000,11
            db   70,1,%00001000,12
            db   60,1,%00001000,13
            db   70,1,%00001000,13,0
Eff1:
            db   40,0,%00000000,10
            db   50,0,%00000000,9
            db   40,0,%00000000,8
            db   50,0,%00000000,7
            db   40,0,%00000000,6
            db   50,0,%00000000,5,0
Eff14:
            db   20,1,%00000000,10
            db   10,1,%00000000,9
            db   20,1,%00000000,8
            db   10,1,%00000000,7
            db   20,1,%00000000,6
            db   10,1,%00000000,5,0
Eff2:
;SHOOT1
            db   #10,1,%00001000,12
            db   #40,1,%00001000,11
            db   #70,1,%00001000,10
            db   #20,2,%00001000,9
            db   #E0,2,%00001000,8
            db   #20,3,%00001000,7,0

Eff0:
;EXPLOSION
            db   #10,8,%00001000,15
            db   #10,8,%00001001,15
            db   #10,8,%00000000,15
            db   #80,8,%00000000,15
            db   #10,8,%00000001,15
            db   #80,7,%00001001,15
            db   #80,7,%00000001,15
            db   #80,5,%00000001,15
            db   #80,4,%00000000,14
            db   #80,3,%00000001,14
            db   1,0,%00000001,14
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000000,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000000,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,13
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,11
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,12
            db   1,0,%00000001,11
            db   1,0,%00000001,10
            db   1,0,%00000001,9
            db   1,0,%00000001,8
            db   1,0,%00000001,8
            db   1,0,%00000001,8
            db   1,0,%00000001,8
            db   1,0,%00000001,7
            db   1,0,%00000001,6
            db   1,0,%00000001,5
            db   1,0,%00000001,4
            db   1,0,%00000001,3,0

Eff11:
            db   100,2,4,9
            db   100,3,4,7
            db   100,2,4,5
            db   100,3,4,4
            db   100,2,4,2
            db   100,3,4,1,0

Eff21:
            db   200,1,32,12
            db   2,0,0,11
            db   50,0,0,12
            db   50,0,4,7
            db   50,0,4,1,0





Datal:
;HL-ADR ON SCREEN
;A-MEAN
            ld   c,a
            and  a
            jr   z,Dln1             ;ECЛИ BOOБЩE = 0
            cpl  
            and  7
            ld   a,c
            jr   nz,$+7
            add  a,8
            and  %11111000
            ld   c,a
            rrca 
            rrca 
            rrca 
            and  7
            jr   z,Dln1
            ld   b,a
            ld   de,#05AA
.5:         ld   (hl),e
            inc  h
            ld   (hl),e
            ld   a,h
            sub  d
            ld   h,a
            inc  l
            djnz $-15
Dln1:
            ld   a,c
            ex   af,af
            ld   a,c
            and  7
            jr   z,Dln2
            ld   c,a
            ld   b,0
            ex   de,hl
            ld   hl,Tabr
            add  hl,bc
            ld   a,(hl)
.5:         ld   (de),a
            inc  d
            ld   (de),a
            ld   a,d
            sub  5
            ld   d,a
            ex   de,hl
            inc  l
Dln2:
            ex   af,af
            ld   c,a
            and  7
            ld   a,c
            jr   z,$+4
            add  a,8
            rrca 
            rrca 
            rrca 
            and  7
            sub  6
            ret  nc
            neg  
            ld   b,a
            ld   de,#0005
            xor  a
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            inc  h
            ld   (hl),d
            ld   a,h
            sub  e
            ld   h,a
            inc  l
            djnz $-15
            ret  
Tabr:
            db   %10000000
            db   %10000000
            db   %10100000
            db   %10100000
            db   %10101000
            db   %10101000
            db   %10101010


Repanel:
;BЫBOД ИHДИKATOPOB ПAHEЛИ , A TAK ЖE BP
;EMEHИ
            ld   a,1
            ld   (Fspeed+1),a
            ld   (Ffire+1),a
            ld   (Fshild+1),a
            ld   (Ffuel+1),a
            call Datalin            ;ИHДИKATOPЫ
            ld   hl,(TIME+2)
            ld   de,(TIME)
            ld   b,#FF
            jp   Zerot1             ;BPEMЯ






Datalin:
;BЫBOД ДAHHЫX O 3AЩИTE ЭHEPГИИ И ДP.ИHФ
;O B BИДE CTATУC ЛИHИИ
Fshild:     ld   a,0
            and  a
            jr   z,Ffuel
            ld   a,(SHILD)
            ld   hl,#49A1
            call Datal
            xor  a
            ld   (Fshild+1),a

Ffuel:      ld   a,0
            and  a
            jr   z,Ffire
;
            rra  
            ld   hl,#49E1
            call Datal

Ffire:      ld   a,0
            and  a
            jr   z,Fspeed
;        LD A,(Peregrv+1)
            ld   hl,#5121
            call Datal
            xor  a
            ld   (Ffire+1),a

            ld   hl,#5181
            ld   hl,#51C1

Fspeed:     ld   a,0
            and  a
            jr   z,Fspd
            xor  a
            ld   (Fspeed+1),a
            ld   hl,(SPEED)
.5:         add  hl,hl
            bit  7,h
            jr   z,$+9
            ld   a,h
            cpl  
            ld   h,a
            ld   a,l
            cpl  
            ld   l,a
            inc  hl
            ld   a,h
            srl  a
            rr   l
            srl  a
            rr   l
            and  a
            jr   z,$+4
            ld   l,46
            ld   a,l
            cp   47
            jr   c,$+4
            ld   l,46
            ld   a,l
            ld   hl,#49B9
            call Datal
Fspd:
            ret  




            org  (($+255)/256*256)
PLANET_:
            incbin "assets/planet.C"
SKYS_:
            incbin "assets/CHAN6.C"
DRV1:
            incbin "assets/DRV1~1.C"
DRV2:
            incbin "assets/DRV2~1.C"
DOMA1:
            incbin "assets/DOMA1~1.C"




INTEL:
;ИНТЕЛЕКТ ПОВЕДЕНИЯ КОРАБЛЕЙ
            ld   ix,Carsb-Olen
            jr   I2
I1:
            ld   a,(ix+0)
            cp   #80
            ret  z
I2:
            ld   de,Olen
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jr   z,I1
            ld   a,(ix+Mode)
            rlca 
            ld   l,a
            ld   h,0,de,MODES
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            ld   de,RET_
            push de
            jp   (hl)
RET_:
            ld   a,PG3D
            call PG
            ld   a,(ix+Rspd)
            or   a
            jr   z,I4
            ld   d,0,e,a
            call MOVEON
I3:
            call PRECORD
            ld   a,PGNORM
            call PG
            jp   I2
I4:
            call NULMOVE
            jr   I3



MODES:
            dw   FREEFLY
.10:        dw   NTH

FREEFLY:
            ret  

NTH:
            ret  







;ГЕНЕРИТЬ СКИММЕРЫ
GENS:
            ld   a,#01
            rrca 
            ld   ($-2),a
            ret  nz
            ld   a,r
            cp   22
            ret  nc
            call FNDFREE
            ret  z
            push hl
            pop  ix
            call RNDL1

            ld   a,h
            and  %11000000
            or   #60
            ld   (ix+Rspd),a

            rl   h
            ld   h,Spacebd-3
            ld   a,0
            jr   nc,$+5
            ld   h,0-Spacebd+3
            inc  a
            ld   (ix+0),l
            ld   (ix+1),h

            push af
            call RNDL2
            pop  af

            rl   h
            ld   h,Spacebd-3
            jr   nc,$+6
            ld   h,0-Spacebd+3
            add  a,2
            ld   (ix+4),l
            ld   (ix+5),h


            push af

            call RNDK1
            and  3
.2:         rlca 
            ld   (ix+Indi),a

            pop  af
            inc  a
            ld   h,a
            ld   a,l
            and  #3F
            dec  h
            set  7,a
            jr   z,GS1
            dec  h
            set  6,a
            jr   z,GS1
            dec  h
            res  7,a
            jr   z,GS1
            res  6,a
GS1:
            ld   (ix+Beta),a


            xor  a
            ld   (ix+Alfa),a
            ld   (ix+Gama),a

            ld   (ix+Mode),0        ;SIMPLY FLY

            ret  










;ГЕНЕРИТЬ ДЕРЕВЬЯ
GEND:
            call RND
            ld   ix,Carsb-Olen
            ld   a,l
            or   h
            or   #07
            and  #1F
            ld   b,a

G1:
            exx  

            ld   bc,Olen
G3:
            add  ix,bc
            ld   a,(ix+1)
            cp   #80
            jr   nz,G3
            ld   a,(ix+0)
            cp   #80
            ret  z

            call RNDT1
            ld   a,h
            bit  7,a
            jr   z,$+6
            or   #40
            jr   $+4
            and  #CF
            ld   (ix+0),l
            ld   (ix+1),a

            call RNDT2
            ld   a,h
            bit  7,h
            jr   z,$+6
            or   #40
            jr   $+4
            and  #CF
            ld   (ix+4),l
            ld   (ix+5),a

            ld   hl,0
            ld   (ix+2),l
            ld   (ix+3),h

            call RND
            and  3

            cp   3
            jr   nz,$+3
            dec  a

.2:         rlca 
            or   #80
            ld   (ix+Indi),a


;ВЗЯТЬ РЕАЛЬНЫЙ РАЗМЕР СПРАЙТА
            ld   l,a,h,high(L97)
            ld   e,(hl)
            inc  hl
            ld   d,(hl)
            inc  de
            inc  de
            ex   de,hl

            call TAKEW

            ld   (ix+Alfa),e
            ld   (ix+Beta),d

            ld   (ix+Rspd),0
            ld   (ix+Mode),0


            ld   bc,Olen
            add  ix,bc

            exx  
            djnz G1
            ret  



FINDOBJ:
;ПOИCK ПEPBOГO ПO TИПУ B D
;FZ-ON IF NOT FOUND
            ld   iy,Carsb-Olen
            ld   bc,Olen
Find2:
            call Findob
            ret  z
            ld   a,(iy+Type)
            cp   d
            jp   nz,Find2
            inc  a
            ret  


FOBJ:
;FIND OBJECT
;RET HL-OBJ AD+1
;FZ-ON NO IN BUF OBJS
;FZ-OFF FOUND
            ld   hl,Carsb-Olen+1
            ld   bc,Olen
            jr   $+8
            dec  l
            ld   a,(hl)
            cp   #80
            ret  z
            inc  l
            add  hl,bc
            ld   a,(hl)
            cp   #80
            jr   z,$-10
            ret  

FNDFREE:
;FIND FREE SPACE
;RET FZ-ON IF NOT FOUND
            ld   hl,Carsb-Olen+1
            ld   de,Olen
Hhh3:
            add  hl,de
            ld   a,(hl)
            cp   #80
            jr   nz,$-4
            dec  l
            ld   a,(hl)
            cp   #80
            ret  z
            ld   a,l
            add  a,Setup
            ld   l,a
            ld   a,(hl)
            ld   (hl),0
            inc  a
            ex   af,af
            ld   a,l
            sub  Setup-1
            ld   l,a
            ex   af,af
            jr   z,Hhh3
            ex   af,af
            dec  l
            ex   af,af
            ret  

RND:
            ld   hl,Sdo
            jp   RNDo
RNDW:
            ld   hl,Sdw
            jp   RNDo
RNDK1:
            ld   hl,Sdk1
            jp   RNDo
RNDK2:
            ld   hl,Sdk2
            jp   RNDo
RNDK3:
            ld   hl,Sdk3
            jp   RNDo
RNDT2:
            ld   hl,Sdt2
            jp   RNDo
RNDT1:
            ld   hl,Sdt1
            jp   RNDo
RNDL1:
            ld   hl,Sdl1
            jp   RNDo
RNDL2:
            ld   hl,Sdl2
            jp   RNDo
RNDL3:
            ld   hl,Sdl3
            jp   RNDo
Sdw:
;ГEHEPATOP KAKOГO ЛAHДШAФTA
            db   7,8,0
Sdo:
            db   101,2,30
Sdl1:
            db   9,0,30
Sdl2:
            db   231,70,30
Sdl3:
            db   71,1,3
Sdt2:
            db   44,0,0
Sdt1:
            db   21,1,12
Sdk1:
            db   247,33,0
Sdk2:
            db   93,4,65
Sdk3:
            db   29,1,12
RNDo:
;IN HL ADR OF SEED
            push bc
            push de
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   a,(hl)
            push hl
            ld   e,a
            ld   h,b
            ld   l,c
            dec  hl
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            ex   de,hl
            ld   h,b
            ld   l,c
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,de
            adc  a,0
            add  hl,bc
            adc  a,0
            add  hl,bc
            adc  a,0
            add  hl,bc
            adc  a,0
            ld   d,h
            ld   e,l
            ld   l,h
            ld   h,a                ;0
            ld   b,0
            ld   c,e
            and  a
            sbc  hl,bc
            sbc  a,0
            ex   de,hl
            and  a
            sbc  hl,de
            sbc  a,0
            dec  hl
            ex   de,hl
            pop  hl
            ld   (hl),a
            dec  hl
            ld   (hl),d
            dec  hl
            ld   (hl),e
            xor  e,d
            ex   de,hl
            pop  de
            pop  bc
            ret  



Findob:
;HAЙTИ KAKOЙ HИБУДЬ OБЪEKT
;IY-VECTOR-OLEN
;BC-OLEN
;FZ-ON NOT FOUND
            add  iy,bc
            ld   a,(iy+1)
            cp   #80
            ret  nz
            ld   a,(iy+0)
            cp   #80
            jp   nz,Findob
            ret  


SERVICE:
            call Servms
            call Servkj
            call Servqa

            ld   a,(DIRECTZ)
            ld   c,a
            ld   a,(DIRECTZ+5)
            or   c
            jr   z,SV1
            ld   a,PG3D
            call PG
            call FLINE
;RET FC-ON ЕСЛИ БЫЛ ВЫСТРЕЛ
            ex   af,af'
            ld   a,PGNORM
            call PG
            ex   af,af'
SV1:
            ld   a,(DIRECTZ+2)
            or   a
            call nz,ROLDN
            ld   a,(DIRECTZ+1)
            or   a
            call nz,ROLUP
            ld   a,(DIRECTZ+4)
            or   a
            call nz,ROLLT
            ld   a,(DIRECTZ+3)
            or   a
            call nz,ROLRT
            ld   a,(DIRECTZ+4)
            ld   c,a
            ld   a,(DIRECTZ+3)
            or   c
            ex   af,af'
            ld   a,PGSPR
            call PG
            ex   af,af'
            call z,RETURN
            ld   a,PGNORM
            call PG
            ret  

;MOUSE DRIVER FROM ZX-FORMAT
DIRECTZ:    db   0                  ;FIRE
            db   0                  ;UP
            db   0                  ;DOWN
            db   0                  ;RIGHT
            db   0                  ;LEFT
            db   0                  ;CANCEL
            db   0                  ;MEDIUM

MCOORD:     dw   0

;УCTAHABЛИBAЮTCЯ B 1 ECЛИ HAЖATO
Mports:     dw   0                  ;CORDS MЫXИ
Nondef:     and  3
            jr   z,Mdrv4
            cp   1
            jr   z,Nondef_
            xor  a
            ld   (Mdrv3+2),a
            ld   a,5
            ld   (Mdrv2+2),a
Nondef_:    ld   hl,0
            ld   (Mdrv1),hl
            pop  ix
;MAIN
Servms:
            ld   a,0
            and  a
            ret  nz
            push ix
            ld   hl,DIRECTZ
            push hl
            pop  ix
            xor  a
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            inc  hl
            ld   (hl),a
            ld   bc,#FADF
            in   a,(c)
            cpl  
Mdrv1:      jr   Nondef
            rra  
Mdrv2:      rl   (ix+0)
            rra  
Mdrv3:      rl   (ix+5)
            rra  
            rl   (ix+6)
Mdrv4:
            ld   de,(Mports)
            ld   bc,#FBDF
            in   a,(c)
            ld   (Mports),a
            sub  e
            ld   (MCOORD+1),a
            jr   z,Mdrv9
            jp   p,Mdrv6
            ld   (ix+4),1
            jr   Mdrv9
Mdrv6:
            ld   (ix+3),1
Mdrv9:      ld   b,#FF
            in   a,(c)
            ld   (Mports+1),a
            sub  d
            ld   (MCOORD),a
            jr   z,Mdrv14
            neg  
            jp   p,Mdrv11
            ld   (ix+1),1
            jr   Mdrv14
Mdrv11:
            ld   (ix+2),1
Mdrv14:
            pop  ix
            ret  
Servkj:
;SERVICE KEMPSTON JOYSTIC
            ld   a,0                ;FLAG
            and  a
            ret  nz
            in   a,(#1F)
            jp   Gomove

Servqa:
;SERVICE QAOP SP
            ld   e,0,c,#FE
            ld   hl,(KUP)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  3,e
            ld   hl,(KDOWN)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  2,e
            ld   hl,(KLEFT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  1,e
            ld   hl,(KRIGHT)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  0,e
            ld   hl,(KFIRE)
            ld   b,l
            in   a,(c)
            and  h
            jr   nz,$+4
            set  4,e
            ld   a,e
Gomove:
;BЫ3OB ПPOЦ. И3MEHEHИЯ KOOPДИHATЫ B 3AB
;ИC
;MOCTИ OT HAЖATOЙ KHOПKИ

;И3MEHЯЮTCЯ ПEPEMEHHЫE COCTOЯHИЯ HAЖATИЯ
;KAKИX ЛИБO KЛABИШ LEFT,RIHGT,UP,DOWN,F
;IRE,CANCEL
            ld   e,a
            xor  a
            ld   d,a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+3
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+4
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+2
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ+1
            or   (hl)
            ld   (hl),a
            xor  a
            rrc  e
            adc  a,a
            ld   hl,DIRECTZ
            or   (hl)
            ld   (hl),a
            ret  


END_:



            org  #6000
Font:
            incbin "assets/FONT.C"
            include "DATAM.asm"
END0:



