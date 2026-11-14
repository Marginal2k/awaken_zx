
REN3D:
            xor  a
            ld   (NUNU+1),a
            ld   hl,(EYE_A)
            ld   (EYEA),hl
            ld   a,(EYE_G)
            ld   (EYEG),a

; ПЕРЕНОС И КОРРЕКЦИЯ ЗНАЧЕНИЙ МАТРИЦЫ,
; ЕСЛИ СТАРШИЕ БАЙТЫ = #80 ТО ДЕЛАЕМ ИХ#81

; ВПРИНЦИПЕ МПОЖНО УДАЛИТЬ, Т.К. НЕТ ЗДЕСЬ
; ПРОЦЕДУРЫ РАСЧЕТА МАТРИЦЫ ОБЩЕГО ПРОСТРАНТВА

            ld   a,(LA11+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_11+1),a
            ld   a,(LA12+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_12+1),a
            ld   a,(LB13+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_13+1),a
            ld   a,(LA21+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_21+1),a
            ld   a,(LA22+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_22+1),a
            ld   a,(LB23+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_23+1),a
            ld   a,(LA31+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_31+1),a
            ld   a,(LA32+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_32+1),a
            ld   a,(LB33+1)
            cp   #80
            jr   nz,$+3
            inc  a
            ld   (SM_33+1),a

            ld   hl,#0001
            ld   (INDT1),hl
            ld   bc,OLEN            ;VECTOR LEN FOR CARS
            ld   hl,CARSB           ;VECTOR CARS
            ld   (END_1+1),sp
            jr   L9F04
L9EED:
            ld   a,l
            and  a
            jp   m,END_1
L9EFC:
            exx  
            add  hl,bc              ;NEXT VECTOR
L9F04:
            ld   sp,hl

; В ВЕКТОР+PX+1=#80 КАК МАРКИРОВКА ОБЪЕКТА
; БЕЗ ПРОСЧИТАННЫХ КООРДИНАТ В ПОВЕРНУТОМ
; ПРОСТРАНСТВЕ
            EXD
            ld   hl,PX+1
            add  hl,de
            ld   a,#80
            ld   (hl),a
            EXD
            exx  
            pop  hl                 ;X
            cp   h
            jr   z,L9EED            ;END
            ld   (OBJX),hl          ;STORE X
            ld   a,h
            and  a
            jp   p,$+5
            neg  
            cp   VISIBILITY
            jr   nc,L9EFC
            ld   (DX+1),hl
            pop  hl                 ;Y
            ld   (OBJY),hl
            ld   a,h
            and  a
            jp   p,$+5
            neg  
            cp   VISIBILITY
            jr   nc,L9EFC
            ld   (DY+1),hl
            pop  hl                 ;z
            ld   (OBJZ),hl
            ld   a,h
            and  a
            jp   p,$+5
            neg  
            cp   VISIBILITY
            jr   nc,L9EFC
            ld   (DZ+1),hl
            pop  hl                 ;UNGLE&INDEX
            ld   a,l                ;INDEX
            ld   (INDX),a           ;ind
            ld   a,h                ;UNGLE
            ld   (EYEA),a           ;ALFA
            pop  hl                 ;ANOTHER UNGLES
            ld   (EYEB),hl          ;b,G
            ld   a,(EYEG)
            ld   b,a
            ld   a,(EYEA)
            or   b
            ld   a,1
            jr   z,$+3
            xor  a
            ld   (SETS),a           ;aG TURN ON

; ПОВОРОТ
            ld   iy,$+7
            jp   CALCRCORD
; ЕСЛИ ПЕРЕПОЛНЕНИЕ
            jp   pe,L9EFC
; ПЕРЕНОСИМ ПРОСЧИТАННЫЕ КООРДИНАТЫ В
; ВЕКТОР ОБЪЕКТА ТЕМ САМЫМ СТИРАЯ МАРК
            exx  
            ld   a,l
            exx  
            ld   l,a
            exx  
            ld   a,h
            exx  
            ld   h,a
            ld   de,PZ+2
            add  hl,de
            ld   sp,hl
            ld   de,(TZ+1)
            push de
            ld   hl,(TY+1)
            push hl
            ld   b,h
            ld   hl,(TX+1)
            push hl
; ПРОВЕРКА ГРАНИЦ ВИДИМОСТИ ОБЪЕКТОВ И
; ДЕТАЛИЗАЦИИ
            ld   a,h
            and  a
            jp   p,$+5
            neg  
            ld   c,a
            ld   a,d
            and  a
            jp   p,$+5
            neg  
            ld   e,a
            ld   a,b
            and  a
            jp   p,$+5
            neg  
            cp   e
            jr   nc,$+3
            ld   a,e
            cp   c
            jr   nc,$+3
            ld   a,c
            srl  a
            sub  #0F
            jr   nc,NUNU2
            neg  
            jp   NUNU2+1
NUNU2:
            xor  a
            ld   c,a
NUNU:       ld   a,0
            cp   c
            jr   nc,$+3
            ld   a,c
            ld   (NUNU+1),a

            ld   a,d
            and  a
            jp   m,L9EFC
            cp   DETALIZ
            ld   a,(INDX)           ;ind
            jp   p,LA0BC
            add  a,#02
            ld   (INDX),a           ;ind
LA0BC:
            ld   sp,(END_1+1)
            call SIZEOBJ
            ld   a,6
            sub  h
            ld   (Jmp1+1),a
            ld   (Jmp2+1),a
            ld   (Jmp3+1),a
            ld   h,0
Jmp1:       jr   $
            ADDHLHL 5
; В hlСРЕДНИЙ РАЗМЕР
            push bc
            push hl
            srl  h
            rr   l
            ld   de,(DX+1)          ;DX
            bit  7,d
            jr   z,LA108
            adc  hl,de
            jp   LA10A
LA108:      sbc  hl,de
LA10A:      jp   m,LA121
            pop  hl
            push hl
            ld   de,(DZ+1)          ;DZ
            bit  7,d
            jr   z,LA11C
            adc  hl,de
            jp   LA11E
LA11C:      sbc  hl,de
LA11E:      jp   m,LA121
            pop  hl
            push hl
            ld   de,(DY+1)          ;DY
            bit  7,d
            jr   z,LA1C
            adc  hl,de
            jp   LA1E
LA1C:       sbc  hl,de
LA1E:
            call p,CRASH
LA121:      pop  de
            pop  bc

LA13A:      ld   hl,(TZ+1)
            and  a
            adc  hl,de
            jp   m,L9EFC


            ld   ixl,c
            ld   a,#48
            ld   h,MULTB
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
            ADDHLHL 5

            EXD
            ld   hl,(TZ+1)
            sra  h
            rr   l
            ld   bc,(TX+1)
            add  hl,bc
            sra  h
            rr   l
            and  a
            adc  hl,de
            jp   m,L9EFC
            SUB_BC
            jp   m,L9EFC

            ld   c,ixl
            ld   a,#42
            ld   h,MULTB
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
            ADDHLHL 5

            EXD
            ld   hl,(TZ+1)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   bc,(TY+1)
            add  hl,bc
            sra  h
            rr   l
            and  a
            adc  hl,de
            jp   m,L9EFC
            SUB_BC
            jp   m,L9EFC

LLLK:
; ВПИСЫВНИЕ ДАННЫХ ОБЪЕКТА В СПИСОК С
; СОРТИРОВКОЙ ПО ПРИБЛИЖЕНИЮ
            ld   bc,(TZ+1)
            ld   de,(DY+1)          ;DY
            ld   a,(INDT1)
            cp   #01
            jr   z,LA238
            ld   ixh,L9D
            ld   ixl,a
            ld   l,(ix+#0C)
            ld   h,(ix+#0D)
            sbc  hl,bc
            jp   m,LA238
LA1FF:      ld   iyh,L9D
LA202:      ld   a,(ix+#00)
            cp   #01
            jr   z,LA24E
            ld   iyl,a
            ld   l,(iy+#0C)
            ld   h,(iy+#0D)
            sbc  hl,bc
            jp   m,LA260
            ld   a,iyl
            ld   ixl,a
            jp   LA202
LA238:      ld   a,(INDT2)
            cp   #FC
            jp   z,END_1
            ld   l,a
            ld   h,L9D
            ld   a,(INDT1)
            ld   (hl),a
            ld   a,l
            ld   (INDT1),a
            jp   LA272
LA24E:      ld   a,(INDT2)
            cp   #FC
            jr   z,END_1
            ld   (ix+#00),a
            ld   l,a
            ld   h,L9D
            ld   (hl),#01
            jp   LA272
LA260:      ld   a,(INDT2)
            cp   #FC
            jr   z,END_1
            ld   l,a
            ld   h,L9D
            ld   a,(ix+#00)
            ld   (ix+#00),l
            ld   (hl),a
            ld   a,l
LA272:      add  a,#0E
            ld   (INDT2),a
            ld   l,a
            ld   sp,hl
            push bc
            ld   hl,(TY+1)
            push hl
            ld   hl,(TX+1)
            push hl
            ld   a,(EYEG)           ;GAMA
            push af
            inc  sp
            ld   hl,(EYEA)          ;ALFA/BETA
            push hl
            ld   hl,(SETS)
            push hl
            jp   L9EFC

END_1:      ld   sp,#0000

            ld   a,(INDT1)
            ld   h,L9D
            jp   LA33B


; ЦИКЛ ВЫВОДА ОБЪЕКТОВ
LA2D8:      push hl
            ld   (LA2FD+1),sp
            inc  l
            inc  l
            inc  l
            ld   sp,hl
            pop  hl
            ld   (SETS),hl          ;BITS/ind
            pop  hl
            ld   (EYEA),hl          ;ALFA/BETA
            dec  sp
            pop  af
            ld   (EYEG),a           ;GAMA
            pop  hl
            ld   (TX+1),hl          ;DX
            pop  de
            ld   (TY+1),de          ;DY
            pop  bc
            ld   (TZ+1),bc          ;DZ

LA2FD:      ld   sp,#0000

            call MATRX
            call PMATRX
            call RENOBJ

; МАСКА ВИДИМОСТИ ОБЪЕКТОВ
            call VSMASK
            jr   z,LA339
            ld   b,a
            cpl  
            and  #F0
            jr   nz,LA339
            ld   a,b
            and  #0F
            jr   nz,$+8
            call DRWPOL2
            jp   $+6
            call DRWPOL
LA339:      pop  hl
            ld   a,(hl)
LA33B:      cp   #01
            ret  z
            ld   l,a
            jp   LA2D8



; СТОЛКНОВЕНИЕ
CRASH:      ld   a,0
            and  a

            ret  

