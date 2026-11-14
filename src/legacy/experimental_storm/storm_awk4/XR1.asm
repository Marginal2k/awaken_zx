
MULL:
            ld   l,a
            xor  d
            ex   af,af
            bit  7,d
            jr   z,$+9
            ld   a,e
            cpl  
            ld   e,a
            ld   a,d
            cpl  
            ld   d,a
            inc  de
            ld   a,l
            and  a
            jp   p,$+5
            neg  
            ld   c,#00
            ld   h,c
            ld   l,c
            add  a,a
            add  a,a
            jr   c,$+23
            add  a,a
            jr   c,$+26
            add  a,a
            jr   c,$+29
            add  a,a
            jr   c,$+32
            add  a,a
            jr   c,$+35
            add  a,a
            jr   c,$+38
            add  a,a
            jr   c,$+41
            jp   $+45
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            jr   nc,$+4
            add  hl,de
            adc  a,c
            add  hl,hl
            adc  a,a
            ld   l,h
            ld   h,a
            ex   af,af
            jp   p,RET_
            ex   de,hl
            ld   hl,#00
            sbc  hl,de
RET_:       jp   (ix)



Calcrc:
;ПOBEPHУTЬ KOOPДИHATHУЮ CИCTEMУ ПO MATP
;ИЦE SM_XY
;IY-RETURN ADR
;ПOPTИT SP
;HAЧAЛЬHЫE 3HAЧ. KOOPД. B DX,DY,DZ
;KOHEЧHЫE B TX,TY,TZ
Dx:         ld   de,0
Sm_11:      ld   a,0
            ld   ix,$+7
            jp   MULL

            ld   sp,hl
Dy:         ld   de,0
Sm_21:      ld   a,0
            ld   ix,$+7
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   sp,hl
Dz:         ld   de,0
Sm_31:      ld   a,0
            ld   ix,$+7
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   (Tx+1),hl
            ld   de,(Dx+1)          ;DX
Sm_12:      ld   a,0
            ld   ix,$+7
            jp   MULL

            ld   sp,hl
            ld   de,(Dy+1)          ;DY
Sm_22:      ld   a,0
            ld   ix,$+7
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   sp,hl
            ld   de,(Dz+1)          ;DZ
Sm_32:      ld   a,0
            ld   ix,$+7
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   (Ty+1),hl
            ld   de,(Dx+1)          ;DX
Sm_13:      ld   a,0
            ld   ix,$+7
            jp   MULL

            ld   sp,hl
            ld   de,(Dy+1)          ;DY
Sm_23:      ld   a,0
            ld   ix,$+7
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   sp,hl
            ld   de,(Dz+1)          ;DZ
Sm_33:      ld   a,0
            ld   ix,$+7
            jp   MULL

            adc  hl,sp
            jp   pe,Exet1
            ld   (Tz+1),hl
Exet1:
            jp   (iy)






;RENDER ALL 3D AND DRAW
Ren3d:
;BEGIN AT CHOOSING OBJECT THAT IS VISIB
;LE

            ld   hl,(Eye_a)         ;EYE A,B
            ld   (Eyea),hl          ;ALFA BETA
            ld   a,(Eye_g)          ;EYE G
            ld   (Eyeg),a           ;GAMA

            call Matrx

            ld   hl,#01
            ld   (Indt1),hl
            ld   bc,Olen            ;VECTOR LEN FOR CARS
            ld   hl,Carsb           ;VECTOR CARS
            ld   (La294),sp
            jr   L9f04
L9eed:
            ld   a,l
            and  a
            jp   m,La293            ;IF CARS WERE RENDERED
L9efc:
            exx  
            add  hl,bc              ;NEXT VECTOR
L9f04:
            ld   sp,hl

;B VECADR+PX+1=#80 KAK MAPKИPOBKA OБЪEK
;TA БE3 ПPOCЧИTAHHЫX
;KOOPДИHAT B ПOBEPHУTOM ПPOCTPAHCTBE.
            ex   de,hl
            ld   hl,Px+1
            add  hl,de
            ld   a,#80
            ld   (hl),a
            ex   de,hl
            exx  
            pop  hl                 ;X
            cp   h
            jr   z,L9eed            ;END OF VECTOR TAB
            ld   (Objx),hl          ;STORE X

            ld   a,h
            and  a
            jp   p,$+4
            cpl  
            cp   Visibil            ;LIMIT VISIBILETY
            jr   nc,L9efc           ;UNVISIBLE

            ld   (Dx+1),hl          ;STORE DX
            pop  hl                 ;Y
            ld   (Objy),hl          ;Y OBJ

            ld   a,h
            and  a
            jp   p,$+4
            cpl  
            cp   Visibil            ;LIMIT VISIBILETY
            jr   nc,L9efc           ;UNVISIBLE

            ld   (Dy+1),hl          ;DY
            pop  hl                 ;Z

            ld   (Objz),hl          ;Z OBJ

            ld   a,h
            and  a
            jp   p,$+4
            cpl  
            cp   Visibil            ;LIMIT VISIBILETY
            jr   nc,L9efc           ;UNVISIBLE

            ld   (Dz+1),hl          ;DZ
            pop  hl                 ;UNGLE&INDEX
            ld   a,l                ;INDEX
            ld   (Indx),a           ;IND
            ld   a,h                ;UNGLE
            ld   (Eyea),a           ;ALFA
            pop  hl                 ;FOR CARS ANOTHER UNGLES
            ld   (Eyeb),hl          ;BETA GAMA

            ld   iy,$+7
            jp   Calcrc             ;ord;ПOBOPOT
            jp   pe,L9efc           ;ПEPEПOЛHEHИE,BЫXOД


;ПEPEHOCИM ПPOCЧИTAHHЫE KOOPД. B BEKTOP
; OБЪKTA TEM CAMЫM
;CTИPAЯ MAPKИPOBKУ
            exx  
            ld   a,l
            exx  
            ld   l,a
            exx  
            ld   a,h
            exx  
            ld   h,a
            ld   de,Pz+2
            add  hl,de
            ld   sp,hl
            ld   de,(Tz+1)
            push de
            ld   hl,(Ty+1)
            push hl
            ld   hl,(Tx+1)
            push hl


            ld   a,h
            or   a
            jp   p,$+4
            cpl  
            cp   Xvisibi            ;VISIBILITY OF X
            jp   nc,L9efc

            ld   a,d
            or   a
            jp   m,L9efc
            cp   Detaliz            ;BORDER FOR DETAILS
            ld   a,(Indx)           ;IND
            jp   p,La0bc
            add  a,#02
            ld   (Indx),a           ;IND
La0bc:

            ld   h,high(L97)
            ld   a,(Indx)           ;IND
            ld   l,a
            ld   sp,hl
            pop  hl
            ld   sp,hl
            pop  bc
            ld   a,6
            sub  b
            ld   (Jmp1+1),a
            ld   (Jmp2+1),a
            ld   (Jmp3+1),a
            ld   l,c
            ld   h,0
Jmp1:       jr   $
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
;IN HL-MIDLE SIZE OBJ
            ld   sp,(La294)


            push bc
            push hl
            ld   de,(Dx+1)          ;DX
            bit  7,d
            jr   z,La108
            adc  hl,de
            jp   La10a
La108:      sbc  hl,de
La10a:      jp   m,La121
            pop  hl
            push hl
            ld   de,(Dz+1)          ;DZ
            bit  7,d
            jr   z,La11c
            adc  hl,de
            jp   La11e
La11c:      sbc  hl,de
La11e:      jp   m,La121
            pop  hl
            push hl
            ld   a,(Indx)
            xor  #80
            jp   p,La121
.2:         srl  h
            rr   l
            ld   de,(Dy+1)          ;DY
            bit  7,d
            jr   z,La1c
            adc  hl,de
            jp   La121
La1c:       sbc  hl,de
La121:
            call p,Lm1

            pop  de
            pop  bc


La13a:      ld   hl,(Tz+1)
            or   a
            adc  hl,de
            jp   m,L9efc


;-
            ld   hl,(Tz+1)
            or   a
            sbc  hl,de
            ld   a,h
            ex   af,af'
;-

            ld   LX,c
            ld   a,#48
            ld   h,Multb
            sra  a
            ld   l,c
            sra  l
            sub  l
            ld   l,a
            add  a,c
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ld   l,a
            ld   h,#00
Jmp2:       jr   $
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
            ex   de,hl
            ld   hl,(Tz+1)
            sra  h
            rr   l
            ld   bc,(Tx+1)
            add  hl,bc
            sra  h
            rr   l
            and  a
            adc  hl,de
            jp   m,L9efc
            and  a
            sbc  hl,bc
            jp   m,L9efc

;-
            and  a
            sbc  hl,de
            and  a
            sbc  hl,de
            ex   af,af'
            or   h
            add  hl,bc
            or   h
            ex   af,af'
;-

            ld   c,LX
            ld   a,#42
            ld   h,Multb
            sra  a
            ld   l,c
            sra  l
            sub  l
            ld   l,a
            add  a,c
            ld   e,(hl)
            ld   l,a
            ld   a,(hl)
            sub  e
            ld   l,a
            ld   h,#00
Jmp3:       jr   $
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
            add  hl,hl
            ex   de,hl
            ld   hl,(Tz+1)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   bc,(Ty+1)
            add  hl,bc
            sra  h
            rr   l
            and  a
            adc  hl,de
            jp   m,L9efc
            and  a
            sbc  hl,bc
            jp   m,L9efc

;-
            and  a
            sbc  hl,de
            and  a
            sbc  hl,de
            ex   af,af'
            or   h
            add  hl,bc
            or   h
            ld   hl,Sets
            jp   p,La1c7
            res  2,(hl)
            jp   La1c9
La1c7:
            set  2,(hl)
La1c9:
;-




;BПИCЫBAHИE ДAHHЫX OБЪEKTA B CПИCOK C C
;OPTИPOBKOЙ ПO
;ПPИБЛИЖEHИЮ
            ld   bc,(Tz+1)
            ld   de,(Dy+1)          ;DY
            ld   a,(Indt1)
            cp   #01
            jr   z,La238
            ld   HX,L9d
            ld   LX,a
;        LD A,(Sets)
;        OR (IX+#01)
;        JP M,La1f4
            ld   l,(ix+#0C)
            ld   h,(ix+#0D)
            sbc  hl,bc
            jp   m,La238
;        JP La1ff
;La1f4   LD L,(IX+#0C)
;        LD H,(IX+#0D)
;        SBC HL,DE
;        JP M,La238
La1ff:      ld   HY,L9d
La202:      ld   a,(ix+#00)
            cp   #01
            jr   z,La24e
            ld   LY,a
;        LD A,(Sets)
;        OR (IY+#01)
;        JP M,La226
            ld   l,(iy+#0C)
            ld   h,(iy+#0D)
            sbc  hl,bc
            jp   m,La260
            ld   a,LY
            ld   LX,a
            jp   La202
;La226   LD L,(IY+#0C)
;        LD H,(IY+#0D)
;        SBC HL,DE
;        JP M,La260
;        LD A,LY
;        LD LX,A
;        JP La202
La238:      ld   a,(Indt2)
            cp   #FC
            jp   z,La293
            ld   l,a
            ld   h,L9d
            ld   a,(Indt1)
            ld   (hl),a
            ld   a,l
            ld   (Indt1),a
            jp   La272
La24e:      ld   a,(Indt2)
            cp   #FC
            jr   z,La293
            ld   (ix+#00),a
            ld   l,a
            ld   h,L9d
            ld   (hl),#01
            jp   La272
La260:      ld   a,(Indt2)
            cp   #FC
            jr   z,La293
            ld   l,a
            ld   h,L9d
            ld   a,(ix+#00)
            ld   (ix+#00),l
            ld   (hl),a
            ld   a,l
La272:      add  a,#0E
            ld   (Indt2),a
            ld   l,a
            ld   sp,hl
;        PUSH DE
            push bc
            ld   hl,(Ty+1)
            push hl
            ld   hl,(Tx+1)
            push hl
            ld   a,(Eyeg)           ;GAMA
            push af
            inc  sp
            ld   hl,(Eyea)          ;ALFA/BETA
            push hl
            ld   hl,(Sets)
            push hl
            jp   L9efc
;CALLS CLIPPING AND DRAWING OBJECTS AND
; HORIZONT
La293:      ld   sp,#0000
La294:      equ  $-#0002

            ld   a,(Indt1)
            ld   h,L9d
            jp   La33b





;CYCLE OF DRAWING OBJECTS
La2d8:      push hl
            ld   (La2fd),sp
            inc  l
            inc  l
            inc  l
            ld   sp,hl
            pop  hl
            ld   (Sets),hl          ;BITS/IND
            pop  hl
            ld   (Eyea),hl          ;ALFA/BETA
            dec  sp
            pop  af
            ld   (Eyeg),a           ;GAMA
            pop  hl
            ld   (Tx+1),hl          ;DX
            pop  de
            ld   (Ty+1),de          ;DY
            pop  bc
            ld   (Tz+1),bc          ;DZ

;        POP HL
;        LD (Dy+1),HL

            ld   sp,#0000
La2fd:      equ  $-#0002

            ld   a,(Sets+1)         ;INDEX
            or   a
            jp   m,VOXOBJ

            call Renobj2

            ld   a,(Sets)
            bit  2,a
            jr   z,La326
            call Drwpol2            ;DRAW POLY.
            jp   NXTO_

La326:      call Vsmask
            jr   z,NXTO_
            ld   b,a
            cpl  
            and  #F0
            jr   nz,NXTO_
            ld   a,b
            and  #0F
            jr   nz,$+8
            call Drwpol2            ;DRAW POLY.
            jp   $+6
            call Drwpol             ;DRAW POLYGON
NXTO_:      pop  hl
            ld   a,(hl)
La33b:      cp   #01
            ret  z
            ld   l,a
            jp   La2d8







;MATPИЦA OTДEЛЬHOГO OБЪEKTA
Matrx:
            ld   a,(Eyeb)           ;BETA
            ld   b,a
            add  a,#40
            ld   h,Sintb
            ld   l,a
            ld   a,(hl)             ;COS
            ld   (Sm_11+1),a        ;COS B
            ld   (Sm_33+1),a        ;COS B
            ld   l,b
            ld   a,(hl)             ;SIN
            ld   (Sm_13+1),a        ;SIN B
            neg  
            ld   (Sm_31+1),a        ;-SIN B
            xor  a
            ld   (Sm_12+1),a
            ld   (Sm_21+1),a
            ld   (Sm_23+1),a
            ld   (Sm_32+1),a
            ld   a,#7F
            ld   (Sm_22+1),a
            ret  

