REN3D:

; НАЧИНАЕМ ВЫБОР ОБЪЕКТОВ КОТОРЫЕ ВИДИМЫ
RETPRI:     ld   a,0
            and  a
            jr   nz,.RTPR
; ЕСЛИ НАДО ВЕРНУТЬ ПРИЦЕЛ В ЦЕНТРАЛЬНОЕ
; ПОЛОЖЕНИЕ, ЗНАЧИТ НЕБЫЛО НАВЕДЕНИЯ
            ld   hl,(PCORD)
            ld   a,l
            sub  #77
            neg
            jr   z,$+9
            inc  l
            or   a
            jp   p,$+5
            dec  l
            dec  l
            ld   a,h
            sub  #2B
            neg
            jr   z,$+9
            inc  h
            or   a
            jp   p,$+5
            dec  h
            dec  h
            ld   (PCORD),hl
.RTPR
            xor  a
            ld   (RETPRI+1),a
            ld   (NUNU+1),a
            ld   hl,(EYE_A)
            ld   (EYEA),hl
            ld   a,(EYE_G)
            ld   (EYEG),a
            call CallMatrix             ;ПPOCЧET MATPИЦЫ OБЩeГO ПPOCTPAHCTBA
; ПЕРЕНОС И КОРРЕКЦИЯ ЗНАЧЕНИЙ МАТРИЦЫ,
; ЕСЛИ СТАРШИЕ БАЙТЫ = #80 ТО ДЕЛАЕМ ИХ#81
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

            ld   a,(NOSUN)
            cp   1
            call nz,DrawSun
            call DrawPlanet

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
            jr   nc,.NUNU2
            neg
            jp   .NUNU2+1
.NUNU2
            xor  a
            ld   c,a
            ld   a,(NUNU+1)
            cp   c
            jr   nc,$+3
            ld   a,c
            ld   (NUNU+1),a

            ld   a,d
            and  a
            jp   m,L9EFC
            cp   DETALIZ
            ld   a,(INDX)           ;ind
            jp   p,.LA0BC
            add  a,#02
            ld   (INDX),a           ;ind
.LA0BC
            ld   sp,(END_1+1)
            call ObjectSize
            ld   a,6
            sub  h
            ld   (Jmp1+1),a
            ld   (Jmp2+1),a
            ld   (Jmp3+1),a
            ld   h,0
Jmp1:       jr   $
            ADDHLHL 5
            ld   (MDSZ+1),hl
; В hlСРЕДНИЙ РАЗМЕР
            push bc
            push hl
            srl  h
            rr   l
            ld   de,(DX+1)          ;DX
            bit  7,d
            jr   z,.LA108
            adc  hl,de
            jp   .LA10A
.LA108      sbc  hl,de
.LA10A      jp   m,.LA121
            pop  hl
            push hl
            ld   de,(DZ+1)          ;DZ
            bit  7,d
            jr   z,.LA11C
            adc  hl,de
            jp   .LA11E
.LA11C      sbc  hl,de
.LA11E      jp   m,.LA121
            pop  hl
            push hl
            ld   de,(DY+1)          ;DY
            bit  7,d
            jr   z,.LA1C
            adc  hl,de
            jp   .LA1E
.LA1C       sbc  hl,de
.LA1E
            call p,CRASH
.LA121      pop  de
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


; ЕСЛИ МЫ В РЕЖИМЕ ФОРСАЖА ТО НИКАКИХ
; НАВЕДЕНИЙ
            ld   a,(JFLAG2+1)
            and  a
            jp   nz,LLLK

; РАСЧЕТ 2D КООРДИНАТ ОБЪЕКТА ЕСЛИ ОН В
; ПРИМЕРНОЙ ЗОНЕ ВИДИМОСТИ И ЕСЛИ НАДО
; РАСЧИТАТЬ ПОПАДАНИЕ ЛАЗЕРА ИГРОКА ИЛИ
; НАДО НАВЕСТИ ПРИЦЕЛ
            ld   a,(TX+2)
            and  a
            jp   p,$+5
            neg
            cp   #0A
            jp   nc,LLLK
            ld   a,(TY+2)
            and  a
            jp   p,$+5
            neg
            cp   #0A
            jp   nc,LLLK
; ОБЪЕКТ В ЗОНЕ
            ld   a,(FLL+1)
            ld   c,a
            ld   a,(RETPRI+1)
            and  c
            jp   nz,LLLK
            ld   de,(TZ+1)
MDSZ:       ld   hl,0

; РАЗМЕР ОБЪЕКТА ДЕЛИМ НА zКООРДИНАТУ
; ПОЛУЧИМ РЕАЛЬНЫЙ РАЗМЕР ПРИ ДАННОМ
; УДАЛЕНИИ
            call FastDivide
            jp   c,LLLK

            sra  h
            rr   l

; ЗАПОМНИЛИ ЕГО ПО МОДУЛЮ
            ld   (MDSZ2+1),hl
; XВ В 2D КООРДИНАТУ
            ld   de,(TZ+1)
            ld   hl,(TX+1)

            call FastDivide
            jp   c,LLLK
; СО ЗНАКОМ
            ld   (MDXX+1),hl

; ПО МОДУЛЮ
            ABSHL
            ld   (MDXX2+1),hl

; YВ В 2D
            ld   de,(TZ+1)
            ld   hl,(TY+1)

            call FastDivide
            jp   c,LLLK

            ld   d,h
            ld   e,l

            ABSHL

            ld   (MDYY+1),hl

FLL:        ld   a,1
            and  a
; ЕСЛИ ВЫСТРЕЛА НЕБЫЛО
            jp   nz,LLLK2
; ЕСЛИ НАДО СДЕЛАТЬ ПРОВЕРКУ ПО ПОПАДАНИЮ
; ЛАЗЕРА
            ld   a,(PCORD+1)
            sub  #2B
            neg
            ld   l,a
            ld   h,0
            jp   p,$+4
            dec  h
; СМЕШАЕМ КООРДИНАТЫ ОТНОСИТЕЛЬНО
; ПОЛОЖЕНИЯ КУРСОРА
            add  hl,de
            EXD
            ABSDE
; РАЗМЕР
MDSZ2:      ld   hl,0
            SUB_DE
; ЕСЛИ ЛАЗЕР ЗА ПРЕДЕЛАМИ РАЗМЕРА
            jp   c,LLLK2
MDXX:       ld   de,0
            ld   a,(PCORD)
            sub  #77
            neg
            ld   l,a
            ld   h,0
            jp   p,$+4
            dec  h
            add  hl,de
            EXD
            ABSDE
            ld   hl,(MDSZ2+1)
            SUB_DE
; ЕСЛИ ЗА ПРЕДЕЛАМИ ЛАЗЕР
            jp   c,LLLK2
; ЛАЗЕР В ЗОНЕ КОРАБЛЯ, РЕГИСТРИРУЕМ
; ПОПАДАНИЕ
            ld   a,1
            ld   (FLL+1),a
            exx
            ld   (PlayerHit+1),hl
            exx
LLLK2:
; НАВЕДЕНИЕ ПРИЦЕЛА
            ld   a,(RETPRI+1)
            and  a
; ЕСЛИ ОН НА ЧТО ТО НАВЕДЕН
            jp   nz,LLLK
MDXX2:      ld   bc,0
MDYY:       ld   de,0
            ld   a,b
            or   d
; ЕСЛИ КООРДИНАТЫ ЗА ПРЕДЕЛАМИ ГРАНИЦ
            jp   nz,LLLK
            ld   a,c
            cp   #10
            jp   nc,LLLK
            ld   a,e
            cp   #10
            jp   nc,LLLK

; ОБЪЕКТ В ПРЕДЕЛАХ ОПРЕДЕЛЕНИЯ ПОЛОЖЕНИЯ
; ДАДИМ ЗНАКИ МЛАДШИМ БАЙТАМ КООРДИНАТ
; СТАРШИЕ = 0
; И СМЕСТИМ МЛ. ОТНОСИТЕЛЬНО ЦЕНТРА ЭКРАНА
; ПО ПРИЦЕЛЬНЫМ КООРДИНАТАМ
            ld   a,(TX+2)
            and  a
            ld   a,c
            jp   p,$+5
            neg
            add  a,#77
            ld   c,a
            ld   a,(TY+2)
            and  a
            ld   a,e
            jp   p,$+5
            neg
            add  a,#2B
            ld   e,a

            ld   hl,(PCORD)
; КООРДИНАТЫ ПРОЦЕЛА
            ld   a,l
            sub  c
            neg
            inc  a
; ЕСЛИ = #FF, ЧТО БЫ НЕ ПРИБАВИТЬ #7F
            jr   z,$+3
            dec  a
            sra  a
; РАССТОЯНИЕ ДЕЛЕННОЕ НА 2
            add  a,l
            ld   l,a
            ld   a,h
            sub  e
            neg
            inc  a
            jr   z,$+3
            dec  a
            sra  a
            add  a,h
            ld   h,a
; В hlНОВЫЕ КООРДИНАТЫ ПРИЦЕЛА, БОЛЕЕ
; ПРИБЛИЖЕННЫЕ К ОБЪЕКТУ
            ld   (PCORD),hl
; ЗАЩЕЛКНЕМ НАЦЕЛИВАНИЕ ДЛЯ ДР. ОБЪЕКТОВ
            ld   a,1
            ld   (RETPRI+1),a

; РЕГИСТРИРУЕМ НАВЕДЕНИЕ РАКЕТЫ
            ld   a,(FNAVOD+1)
            and  a
            jr   z,LLLK
            xor  a
            ld   (FNAVOD+1),a
            ld   hl,EFF1
            ld   (SFXA+1),hl
            ld   de,ROKETN1
            ld   a,(de)
            inc  a
            jr   z,.CSA1
            ld   de,ROKETN2
            ld   a,(de)
            inc  a
            jr   z,.CSA1
            ld   de,ROKETN3
            ld   a,(de)
            inc  a
            jr   z,.CSA1
            ld   hl,EFF14
            ld   (SFXA+1),hl

            MESAG _ALLTARGET
            jp   LLLK
.CSA1
            exx
            ld   a,l
            ex   af,af'
            ld   a,h
            exx
            ld   h,a
            ex   af,af'
            ld   l,a
            ld   bc,0-CARSB
            add  hl,bc
            ld   a,h
            sla  l
            rla
            sla  l
            rla
;              sla    l
;              rla
            ld   (de),a


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
.LA202      ld   a,(ix+#00)
            cp   #01
            jr   z,LA24E
            ld   iyl,a
            ld   l,(iy+#0C)
            ld   h,(iy+#0D)
            sbc  hl,bc
            jp   m,LA260
            ld   a,iyl
            ld   ixl,a
            jp   .LA202
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

            call SFXA

            call MATRX
            call PMATRX
            call RENOBJ

; МАСКА ВИДИМОСТИ ОБЪЕКТОВ
            call VSMASK
            jr   z,.LA339
            ld   b,a
            cpl
            and  #F0
            jr   nz,.LA339
            ld   a,b
            and  #0F
            jr   nz,$+8
            call DRWPOL2
            jp   $+6
            call DRWPOL
.LA339      pop  hl
            ld   a,(hl)
LA33B:      cp   #01
            ret  z
            ld   l,a
            jp   LA2D8


; СТОЛКНОВЕНИЕ
CRASH:      ld   a,0
            and  a

            ret  nz


            exx
            push hl
            exx
            pop  ix
            ld   a,(ix+TYPE)
            cp   T_ROKET
            ret  z
            cp   T_TRASH
            ret  z
            cp   T_STATION
            jr   nz,.CRSH
; ОПРЕДЕЛЕНИЕ СТЫКОВКИ СО СТАНЦИЕЙ
            bit  4,(ix+SETUP)
            jr   z,.CRSH
; СТЫКОВОЧНЫЙ БЛОК
            ld   a,(ix+1)
            ACPL_A
            cp   CRSHST
            jr   nc,.CRSH
            ld   a,(ix+3)
            ACPL_A
            cp   CRSHST
            jr   nc,.CRSH
            ld   a,(ix+5)
            ACPL_A
            cp   CRSHST
; ЕСЛИ ВОЗВРАТ НА СТАНЦИЮ
            jp   c,RETST
.CRSH
            ld   hl,CRASH+1
            dec  (hl)
            call LM1
; ЕСЛИ СТОЛКНОВЕНИЕ ТО ГИБЕЛЬ И ВЗРЫВ
; ОПОНЕНТА
            ld   a,(ix+TYPE)
            cp   T_STATION
            ret  nz
            xor  a
            ld   (SHILD),a
            ret
