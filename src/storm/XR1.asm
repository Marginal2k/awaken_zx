MULL
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
RET_    jp   (ix)

Calcrc
; Повернуть координатную систему по матр
; Ице sm_xy
; Iy-RETURN adr
; Портит sp
; Начальные 3нач. коорд. b dx,dy,dz
; Конечные b тх,ту,tz
Dx      ld   de,0
Sm_11   ld   a,0
        ld   ix,$+7
        jp   MULL

        ld   sp,hl
Dy      ld   de,0
Sm_21   ld   a,0
        ld   ix,$+7
        jp   MULL

        adc  hl,sp
        jp   pe,Exet1
        ld   sp,hl
Dz_     ld   de,0
Sm_31   ld   a,0
        ld   ix,$+7
        jp   MULL

        adc  hl,sp
        jp   pe,Exet1
        ld   (Tx+1),hl
        ld   de,(Dx+1)          ; Dx
Sm_12   ld   a,0
        ld   ix,$+7
        jp   MULL

        ld   sp,hl
        ld   de,(Dy+1)          ; Dy
Sm_22   ld   a,0
        ld   ix,$+7
        jp   MULL

        adc  hl,sp
        jp   pe,Exet1
        ld   sp,hl
        ld   de,(Dz_+1)         ; Dz
Sm_32   ld   a,0
        ld   ix,$+7
        jp   MULL

        adc  hl,sp
        jp   pe,Exet1
        ld   (Ty+1),hl
        ld   de,(Dx+1)          ; Dx
Sm_13   ld   a,0
        ld   ix,$+7
        jp   MULL

        ld   sp,hl
        ld   de,(Dy+1)          ; Dy
Sm_23   ld   a,0
        ld   ix,$+7
        jp   MULL

        adc  hl,sp
        jp   pe,Exet1
        ld   sp,hl
        ld   de,(Dz_+1)         ; Dz
Sm_33   ld   a,0
        ld   ix,$+7
        jp   MULL

        adc  hl,sp
        jp   pe,Exet1
        ld   (Tz+1),hl
Exet1
        jp   (iy)

; Render all 3d and draw
Ren3d
; BEGIN at choosing object that is visib
; Le

        ld   hl,(Eye_a)         ; Eye a,b
        ld   (Eyea),hl          ; Alfa beta
        ld   a,(Eye_g)          ; Eye G
        ld   (Eyeg),a           ; Gama

        call Matrx

        ld   hl,#01
        ld   (Indt1),hl
        ld   bc,OBJ_LEN         ; Vector LEN for cars
        ld   hl,Carsb           ; Vector cars
        ld   (La294),sp
        jr   L9f04
L9eed
        ld   a,l
        and  a
        jp   m,La293            ; If cars were rendered
L9efc
        exx
        add  hl,bc              ; Next vector
L9f04
        ld   sp,hl

        ; B vecadr+рх+1=#80 как маркировка объек
        ; Та бе3 просчитанных
        ; Координат b повернутом пространстве.
        ex   de,hl
        ld   hl,Px+1
        add  hl,de
        ld   a,#80
        ld   (hl),a
        ex   de,hl
        exx
        pop  hl                 ; X
        cp   h
        jr   z,L9eed            ; End of vector tab
        ld   (Objx),hl          ; Store X

        ld   a,h
        and  a
        jp   p,$+4
        cpl
        cp   Visibil            ; Limit visibilety
        jr   nc,L9efc           ; Unvisible

        ld   (Dx+1),hl          ; Store dx
        pop  hl                 ; Y
        ld   (Objy),hl          ; Y obj

        ld   a,h
        and  a
        jp   p,$+4
        cpl
        cp   Visibil            ; Limit visibilety
        jr   nc,L9efc           ; Unvisible

        ld   (Dy+1),hl          ; Dy
        pop  hl                 ; Z

        ld   (Objz),hl          ; Z obj

        ld   a,h
        and  a
        jp   p,$+4
        cpl
        cp   Visibil            ; Limit visibilety
        jr   nc,L9efc           ; Unvisible

        ld   (Dz_+1),hl         ; Dz
        pop  hl                 ; UNGLE&index
        ld   a,l                ; Index
        ld   (Indx),a           ; Ind
        ld   a,h                ; UNGLE
        ld   (Eyea),a           ; Alfa
        pop  hl                 ; For cars another ungles
        ld   (Eyeb),hl          ; Beta gama

        ld   iy,$+7
        jp   Calcrc             ; Ord;поворот
        jp   pe,L9efc           ; Переполнение,выход

        ; Переносим просчитанные коорд. b вектор
        ; Объкта тем самым
        ; Стирая маркировку
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
        cp   Xvisibi            ; Visibility of X
        jp   nc,L9efc

        ld   a,d
        or   a
        jp   m,L9efc
        cp   Detaliz            ; Border for details
        ld   a,(Indx)           ; Ind
        jp   p,La0bc
        add  a,#02
        ld   (Indx),a           ; Ind
La0bc

        ld   h,high(L97)
        ld   a,(Indx)           ; Ind
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
Jmp1    jr   $
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl
        ; In hl-midle size obj
        ld   sp,(La294)

        push bc
        push hl
        ld   de,(Dx+1)          ; Dx
        bit  7,d
        jr   z,La108
        adc  hl,de
        jp   La10a
La108   sbc  hl,de
La10a   jp   m,La121
        pop  hl
        push hl
        ld   de,(Dz_+1)         ; Dz
        bit  7,d
        jr   z,La11c
        adc  hl,de
        jp   La11e
La11c   sbc  hl,de
La11e   jp   m,La121
        pop  hl
        push hl
        ld   a,(Indx)
        xor  #80
        jp   p,La121
        dup  2
        srl  h
        rr   l
        edup
        ld   de,(Dy+1)          ; Dy
        bit  7,d
        jr   z,La1c
        adc  hl,de
        jp   La121
La1c    sbc  hl,de
La121
        call p,Lm1

        pop  de
        pop  bc

La13a   ld   hl,(Tz+1)
        or   a
        adc  hl,de
        jp   m,L9efc

        ; -
        ld   hl,(Tz+1)
        or   a
        sbc  hl,de
        ld   a,h
        ex   af,af'
; -

        ld   ixl,c
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
Jmp2    jr   $
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

        ; -
        and  a
        sbc  hl,de
        and  a
        sbc  hl,de
        ex   af,af'
        or   h
        add  hl,bc
        or   h
        ex   af,af'
; -

        ld   c,ixl
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
Jmp3    jr   $
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

        ; -
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
La1c7
        set  2,(hl)
La1c9
; -

        ; Вписывание данных объекта b список c c
        ; Ортировкой по
        ; Приближению
        ld   bc,(Tz+1)
        ld   de,(Dy+1)          ; Dy
        ld   a,(Indt1)
        cp   #01
        jr   z,La238
        ld   ixh,L9d
        ld   ixl,a
        ;        Ld a,(Sets)
        ;        Or (ix+#01)
        ;        Jp m,La1f4
        ld   l,(ix+#0C)
        ld   h,(ix+#0D)
        sbc  hl,bc
        jp   m,La238
;        JP La1ff
; La1f4   ld l,(ix+#0C)
;        Ld h,(ix+#0D)
;        Sbc hl,de
;        Jp m,La238
La1ff   ld   iyh,L9d
La202   ld   a,(ix+#00)
        cp   #01
        jr   z,La24e
        ld   iyl,a
        ;        Ld a,(Sets)
        ;        Or (iy+#01)
        ;        Jp m,La226
        ld   l,(iy+#0C)
        ld   h,(iy+#0D)
        sbc  hl,bc
        jp   m,La260
        ld   a,iyl
        ld   ixl,a
        jp   La202
; La226   ld l,(iy+#0C)
;        Ld h,(iy+#0D)
;        Sbc hl,de
;        Jp m,La260
;        Ld a,ly
;        Ld lx,a
;        Jp La202
La238   ld   a,(Indt2)
        cp   #FC
        jp   z,La293
        ld   l,a
        ld   h,L9d
        ld   a,(Indt1)
        ld   (hl),a
        ld   a,l
        ld   (Indt1),a
        jp   La272
La24e   ld   a,(Indt2)
        cp   #FC
        jr   z,La293
        ld   (ix+#00),a
        ld   l,a
        ld   h,L9d
        ld   (hl),#01
        jp   La272
La260   ld   a,(Indt2)
        cp   #FC
        jr   z,La293
        ld   l,a
        ld   h,L9d
        ld   a,(ix+#00)
        ld   (ix+#00),l
        ld   (hl),a
        ld   a,l
La272   add  a,#0E
        ld   (Indt2),a
        ld   l,a
        ld   sp,hl
        ;        Push de
        push bc
        ld   hl,(Ty+1)
        push hl
        ld   hl,(Tx+1)
        push hl
        ld   a,(Eyeg)           ; Gama
        push af
        inc  sp
        ld   hl,(Eyea)          ; Alfa/beta
        push hl
        ld   hl,(Sets)
        push hl
        jp   L9efc
; Calls clipping and drawing objects and
; Horizont
La293   ld   sp,#0000
La294           equ $-#0002

        ld   a,(Indt1)
        ld   h,L9d
        jp   La33b

; Cycle of drawing objects
La2d8   push hl
        ld   (La2fd),sp
        inc  l
        inc  l
        inc  l
        ld   sp,hl
        pop  hl
        ld   (Sets),hl          ; Bits/ind
        pop  hl
        ld   (Eyea),hl          ; Alfa/beta
        dec  sp
        pop  af
        ld   (Eyeg),a           ; Gama
        pop  hl
        ld   (Tx+1),hl          ; Dx
        pop  de
        ld   (Ty+1),de          ; Dy
        pop  bc
        ld   (Tz+1),bc          ; Dz

;        Pop hl
;        Ld (Dy+1),hl

        ld   sp,#0000
La2fd           equ $-#0002

        ld   a,(Sets+1)         ; Index
        or   a
        jp   m,VOXOBJ

        call Renobj2

        ld   a,(Sets)
        bit  2,a
        jr   z,La326
        call Drwpol2            ; Draw poly.
        jp   NXTO_

La326   call Vsmask
        jr   z,NXTO_
        ld   b,a
        cpl
        and  #F0
        jr   nz,NXTO_
        ld   a,b
        and  #0F
        jr   nz,$+8
        call Drwpol2            ; Draw poly.
        jp   $+6
        call Drwpol             ; Draw polygon
NXTO_   pop  hl
        ld   a,(hl)
La33b   cp   #01
        ret  z
        ld   l,a
        jp   La2d8

; Матрица отдельного объекта
Matrx
        ld   a,(Eyeb)           ; Beta
        ld   b,a
        add  a,#40
        ld   h,Sintb
        ld   l,a
        ld   a,(hl)             ; Cos
        ld   (Sm_11+1),a        ; Cos b
        ld   (Sm_33+1),a        ; Cos b
        ld   l,b
        ld   a,(hl)             ; Sin
        ld   (Sm_13+1),a        ; Sin b
        neg
        ld   (Sm_31+1),a        ; -Sin b
        xor  a
        ld   (Sm_12+1),a
        ld   (Sm_21+1),a
        ld   (Sm_23+1),a
        ld   (Sm_32+1),a
        ld   a,#7F
        ld   (Sm_22+1),a
        ret
