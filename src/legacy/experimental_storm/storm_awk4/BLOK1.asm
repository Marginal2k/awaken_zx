
Getadr:
;ПOЛУЧEHИE AДPECA И3 ИHДEKCA
;A-INDEX
;RET HL-ADR
            ld   h,a
            xor  a
            srl  h
            rra  
            srl  h
            rra  
            push bc
            ld   bc,Carsb
            ld   l,a
            add  hl,bc
            pop  bc
            ret  





Clc2d3d:
;CALC 2D FROM 3D
;DE-Z,HL-Y,BC-X
;RET HL-X,DE-Y
;FZ=NZ-ERROR
            push bc
            push de
;Z
            bit  7,d
            jr   z,$+9
            ld   a,e
            cpl  
            ld   e,a
            ld   a,d
            cpl  
            ld   d,a
            inc  de
;Y
            call Fdiv
            pop  de
            jp   c,Ld3
            bit  7,d
            jr   z,$+9
            ld   a,l
            cpl  
            ld   l,a
            ld   a,h
            cpl  
            ld   h,a
            inc  hl

            ld   bc,#30             ;MIDLE Y
            add  hl,bc
            ld   b,h
            ld   c,l
;X
            pop  hl
            push bc

            push de
            bit  7,d
            jr   z,$+9
            ld   a,e
            cpl  
            ld   e,a
            ld   a,d
            cpl  
            ld   d,a
            inc  de
            call Fdiv
            pop  de
            jp   c,Ld3
            bit  7,d
            jr   z,$+9
            ld   a,l
            cpl  
            ld   l,a
            ld   a,h
            cpl  
            ld   h,a
            inc  hl

            ld   de,#0080           ;MIDLE X
            add  hl,de
            pop  de
            xor  a
            ret  
Ld3:
            pop  af
            xor  a
            inc  a
            ret  





Getindy:
;IY-ADR
            push hl
            push iy
            pop  hl
            call Getind
            pop  hl
            ret  








Getind:
;БEPET ИHДEKC OT AДPECA B CПИCKE OБЪEKT
;OB
;HL-ADR
;RET A-INDEX
            push bc
            ld   bc,0-Carsb
            add  hl,bc
            pop  bc
            ld   a,h
            sla  l
            rla  
            sla  l
            rla  
            ret  






Fline:
;PИCOBAHИE ЛA3EPA ИГPOKA
;FC-ON-ЕСЛИ БЫЛ ВЫСТРЕЛ
            ld   a,0
Pstli:      add  a,70
            ld   ($-3),a
            ret  nc
            xor  a
            ld   hl,#38A9
            ld   a,low(Ld1l)
            ld   (L91+#4E),hl
            ld   (Ldadd),a
            ld   a,r
            ld   c,a
            and  1
            bit  4,c
            jr   z,$+4
            neg  
            ld   e,a
            ld   a,(Pcord)
            add  a,8
            add  a,e
            ld   e,a
            ld   a,r
            ld   c,a
            and  1
            bit  4,c
            jr   z,$+4
            neg  
            ld   d,a
            ld   a,(Pcord+1)
            add  a,5
            add  a,d
            ld   d,a
            push de
            ld   hl,#5F40
            call Drawl1
            ld   hl,#5FC0
            pop  de
            call Drawl1
            scf  
            ret  






Moveon:
;MOVING SHIPS IN FRONT
;DE-SPEED
;IX-ВЕКТОР ОБЪЕКТА
;RET IN STPX_,STPY_,STPZ_
            push ix
            ld   a,(ix+Alfa)
            ld   (Eyea_+1),a
            ld   a,(ix+Beta)
            add  a,#80
            ld   (Eyeb_+1),a
            ld   a,(ix+Gama)
            ld   (Eyeg_+1),a
            push de
            call Shmtrx
            pop  de
Hm_13:      ld   a,0
            push de
            ld   ix,$+7
            jp   MULL
            pop  de
            ld   (Stpx_+1),hl
Hm_23:      ld   a,0
            push de
            ld   ix,$+7
            jp   MULL
            pop  de
            ld   (Stpy_+1),hl
Hm_33:      ld   a,0
            ld   ix,$+7
            jp   MULL
            ld   (Stpz_+1),hl
            pop  ix
            ret  



            ccf  
            ret  
Fdiv:
;HL=HL/DE
            ld   a,l
            ld   l,h,h,0
            and  a
            sbc  hl,de
            jp   nc,Fdiv-2
            add  hl,de
            rla  
            adc  hl,hl
            and  a
            sbc  hl,de
            jp   nc,Fdiv-2
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            adc  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            ld   b,a
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            add  hl,hl
            sbc  hl,de
            jr   nc,$+3
            add  hl,de
            rla  
            cpl  
            ld   l,a
            ld   a,b
            cpl  
            ld   h,a
            or   a
            ret  

