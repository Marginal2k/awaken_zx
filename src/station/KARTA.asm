;==============================================================================
; KARTA - карта галактики: генерация звёздного поля, выбор звезды и планеты
;
; Где живёт: оверлей KARTA.C, ORG #C000, страница PGKRT (#11); первым в блоке (KARTA, DRAWLIN, CIRCMATH).
;
; Точки входа: DrawGalaxyMap (A = инверсия) выводит всё в окно карты; CenterMap/CenterMapAt;
; GenerateMapTiles (четыре карты 256x256 из ГСЧ по координатам тайла) и BuildVisibleStars (отсечение
; по окну, таблица DOTB); ChooseStar/FindPlanetAtCursor (звезда и планета под курсором); ChoosePlanet,
; AnimatePlanets, DrawPlanetSprite (окно системы с вращающимися планетами); FindStarInMemory/Route
; (память 10 звёзд и маршрут); GetSystemData (данные системы из семени, GAME_DESIGN 5.3);
; PrintPlanetName; MarkRouteLine. Спрайты планет и маркеров Spr* (в конце файла), PWAYS (ways.d).
; См. GAME_DESIGN 5.1-5.6.
;==============================================================================

DrawGalaxyMap   ; orig: KARTOUT
; Вывод всего на карту
; a-inverse
            ld   (DrawCircle+1),a

; Вывод круга

            ld   hl,(FUEL)
            ld   a,h
            and  a
            jr   nz,$+4
            ld   a,l
            rra
            ld   l,a
            add  a,a
            add  a,l
            ld   (RDH),a


            ld   de,(PLACE+2)
            ld   bc,(PLACE)
            ld   a,d
            ld   d,c
            ld   c,a
            ld   a,(EYEX)
            ld   l,a
            ld   a,(KCORD)
            ld   h,a
            and  a
            EXD
            sbc  hl,de
            ld   de,(MX1+1)
            ld   d,0
            SUB_DE

            ld   a,h
            ex   af,af'
            ld   a,h
            and  a
            jp   p,$+10
            NEGHL
            ld   a,l
            ld   (RDX),a
            ld   de,(RDH)
            ld   d,0
            SUB_DE
            jr   c,.NOC1
            ld   de,(MX1+1)
            ld   d,0
            SUB_DE
            jr   nc,.NOC
.NOC1
            ld   a,(EYEY)
            ld   l,a
            ld   a,(KCORD+1)
            ld   h,a
            SUB_BC
            ld   de,(MY1+1)
            ld   d,0
            add  hl,de


            ld   e,h
            ld   a,h
            and  a
            jp   p,$+10
            NEGHL
            ld   a,l
            ld   (RDY),a
            ld   bc,(RDH)
            ld   b,0
            SUB_BC
            jr   c,.NOC2
            ld   bc,(MY1+1)
            ld   b,0
            SUB_BC
            jr   nc,.NOC
.NOC2
            ex   af,af'
            ld   h,a
            xor  a
            rlc  e
            ccf
            rla
            rlc  h
            ccf
            rla
            ld   (RDS),a

            call DrawCircle
.NOC


; Вывод курсоров

            ld   de,(PLACE)
            ld   bc,(PLACE+2)
            ld   hl,SprCross
            call .KUROT
            ld   de,(WHERE)
            ld   bc,(WHERE+2)
            ld   hl,SprPlus
            call .KUROT
            ld   hl,(AWAYS)
            ld   e,(hl)
            inc  e
            jr   z,.K_J1
            dec  e
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            ld   hl,SprEmpty
            call .KUROT
.K_J1

; Буфер запомненных звезд
            ld   hl,MSTARS
; #Ff-пусто,#80-конец списка
.O_K2
            ld   e,(hl)
            inc  e
            jr   z,.O_K3
            dec  e
            jp   m,.O_K1
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            INC_HL 2
            push hl
            ld   hl,SprSquare
            call .KUROT
            pop  hl
            jp   .O_K2
.O_K3
            ld   bc,5
            add  hl,bc
            jp   .O_K2
.O_K1

; Буфер звезд где живут пиплы
            ld   ix,PSTARS
            ld   hl,ABONS           ; Описатель вкл.людей
; #Ff-конец списка
.O_K21
            ld   a,(hl)
            inc  hl
            and  a
            jr   z,.O_K31
            jp   m,.O_K11
            push hl
            ld   e,(ix+0)
            ld   d,(ix+1)
            ld   c,(ix+2)
            ld   b,(ix+3)
            ld   hl,SprTriangle
            call .KUROT
            pop  hl
.O_K31
            ld   bc,4
            add  ix,bc
            jp   .O_K21
.O_K11
; Буфер маршрутных звезд
            ld   hl,WAY
; #Ff-пусто,#80-конец списка
.O_K22
            ld   a,(hl)
            or   a
            jp   m,.O_K12
            ld   e,a
            inc  hl
            ld   d,(hl)
            inc  hl
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            INC_HL 2
            push hl
            ld   hl,SprMinus
            call .KUROT
            pop  hl
            jp   .O_K22
.O_K12

; Показать маршрут линии
            ld   hl,WAY
            ld   de,WAYMASK
; >=#80-Нет маршрута
            bit  7,(hl)
            call z,DrawLine
.O_K4


; Вывод карты
            halt

            ld   (.STK99+1),sp
            exx

; Коорд. глаз
; Т.е. верхнего левого края окна просмотра
; Карты в пикселях
            ld   de,(EYEX)

            ld   a,(BXKRT)
            ld   (.BXK1+1),a
            ld   (.BXK3+1),a
            dec  a
            neg
            ld   (.BXK4+1),a
            ld   (.BXK2+1),a

            ld   a,(BYKRT)
            ld   (.BYK1+1),a
            dec  a
            neg
            ld   (.BYK2+1),a

.BYK1
            ld   bc,#8070           ; c=Y-borders
            ld   sp,KR1-2
            pop  hl
.NDT3
            pop  hl
            ld   a,h
            sub  d
            jp   c,.NDT
            cp   c
            jp   nc,.NDT
            ex   af,af'
            ld   a,l
            sub  e
            jp   c,.NDT
.BXK1
            cp   #D0
            jp   nc,.NDT
            exx
            ld   b,a
            ex   af,af'

            PUTDOT

            exx
.NDT
            djnz .NDT3

            ld   b,#80
.NDT31
            pop  hl
            ld   a,h
            sub  d
            jp   c,.NDT4
            cp   c
            jp   nc,.NDT4
            ex   af,af'
            ld   a,e
            sub  l
            jp   c,.NDT4
.BXK2
            cp   #31
            jp   c,.NDT4
            exx
            neg
            ld   b,a
            ex   af,af'

            PUTDOT

            exx
.NDT4
            djnz .NDT31

.BYK2
            ld   bc,#8091
.NDT32
            pop  hl
            ld   a,d
            sub  h
            jp   c,.NDT41
            cp   c
            jp   c,.NDT41
            ex   af,af'
            ld   a,l
            sub  e
            jp   c,.NDT41
.BXK3
            cp   #D0
            jp   nc,.NDT41
            exx
            ld   b,a
            ex   af,af'
            neg

            PUTDOT

            exx
.NDT41
            djnz .NDT32

            ld   b,#80
.NDT33
            pop  hl
            ld   a,d
            sub  h
            jp   c,.NDT42
            cp   c
            jp   c,.NDT42
            ex   af,af'
            ld   a,e
            sub  l
            jp   c,.NDT42
.BXK4
            cp   #31
            jp   c,.NDT42
            exx
            neg
            ld   b,a
            ex   af,af'
            neg

            PUTDOT

            exx
.NDT42
            djnz .NDT33
.STK99
            ld   sp,0

            ret


.KUROT
; Вывод курсора с обрезанием по краям
; de-коорд. карты
; bc-коорд. в карте
; hl-адрес спрайта
            ld   a,b
            ld   b,e
            ld   e,a
; bc-big X,de- big Y
            push hl
            push de
            ld   hl,(KCORD)
            ld   de,(EYEX)
            ld   a,d
            ld   d,l
            ld   l,a
; de-big X,hl-big Y
            push hl
            ld   h,b
            ld   l,c
            SUB_DE
            DEC_HL 3
            EXD
            pop  bc
            pop  hl
            SUB_BC
            DEC_HL 3
            pop  bc

; hl-Y,de-X,bc-адрес спрайта
            ld   a,h
            or   d
            ret  nz                 ; Вылет
; Проверка на вылеты
            ld   a,(BXKRT)
            sub  8
            cp   e
            ret  c
            ret  z
            ld   a,(BYKRT)
            sub  7
            cp   l
            ret  c
            ret  z

            ld   h,high(TBXX2_)
            ld   d,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            ld   l,e
            add  a,(hl)
            ld   e,a

            ld   a,l
            and  7
            rept 4
            rlca
            endr
            ld   l,a
            ld   h,0
            add  hl,bc

            rept 6
            SPRO1
            endr

            ld   a,(de)
            xor  (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            xor  (hl)
            ld   (de),a
            ret


CenterMap   ; orig: CENTRE
; Центрировать карту на звезде
; de-коорд. карты
; hl-коорд. в карте
            ld   (WHERE),de
            ld   (WHERE+2),hl
            push hl
            push de
            call FindPlanetAtCursor
            pop  de
            pop  hl

CenterMapAt   ; orig: CENTRE2
; Центрирование по координатам
            ld   a,h
            ld   h,e
            ld   e,a
; hl-X,de-Y
            ld   a,(BXKRT)
            srl  a
            neg
            ld   b,#FF
            ld   c,a
            and  a
            adc  hl,bc
            jp   p,$+6
            ld   hl,0
            EXD
            ld   a,(BYKRT)
            srl  a
            neg
            ld   b,#FF
            ld   c,a
            and  a
            adc  hl,bc
            jp   p,$+6
            ld   hl,0
; hl-Y,de-X
            ld   a,l
            ld   l,d
            ld   d,a
; hl-KCORD
; de-PSX
            ld   (KCORD),hl
            ld   (EYEX),de
            ret


RAST
; a-1-ST CORD
; A'-2-ND CORD
            ld   e,a
            ld   d,a
            ld   b,8
            xor  a
            rr   e
            jr   nc,$+3
            add  a,d
            rra
            djnz $-6
            rr   e
            ld   h,a
            ld   l,e
            ex   af,af'
            ld   e,a
            ld   d,a
            ld   b,8
            xor  a
            rr   e
            jr   nc,$+3
            add  a,d
            rra
            djnz $-6
            rr   e
            ld   d,a
            add  hl,de
            ret


ChooseStar   ; orig: STARCH
; Выбор звезды
; Если переход на показ планеты то FZ-on
; FZ-off просто выбор звезды
; Fc-on-срочный выход без результата
; hl-коорд. окна в пикс
            push hl
            ld   hl,#FFFF
            ld   (.MINR+1),hl
            call BuildVisibleStars
            ld   bc,(Mcoord)
            pop  hl

            ld   a,b
            sub  h
            ld   b,a
            ret  c
            ld   a,(BYKRT)
            dec  a
            cp   b
            ret  c
            ld   a,c
            sub  l
            ld   c,a
            ret  c
            ld   a,(BXKRT)
            dec  a
            cp   c
            ret  c

            ld   hl,DOTB

; Получаем dx,dy
.SH31
            inc  h
            inc  l
            ld   a,(hl)
            and  a
            jp   z,.SH21
            dec  l
            dec  h
            ld   a,(hl)
            sub  c
            jp   p,$+5
            neg
            ex   af,af'
            inc  l
            ld   a,(hl)
            sub  b
            jp   p,$+5
            neg
            exx
            call RAST
.MINR
            ld   de,#FFFF
            SUB_DE
            jr   nc,.SH11
            add  hl,de
            ld   (.MINR+1),hl
            exx
            dec  l
            ld   (.ADMIN+1),hl
            inc  l
            exx
.SH11
            exx
            inc  l
            jp   .SH31
.SH21
.ADMIN
            ld   hl,0
            inc  h
            ld   a,(hl)
            inc  l
            ld   h,(hl)
            ld   l,a
; hl-dot adr inkart tabl
            ld   e,(hl)
            inc  l
            ld   d,(hl)
; de-koords. as arnd DATA1
            ld   (WHERE+2),de
            ld   de,(KCORD)
            ld   a,h
            cp   high(KR1)
            jr   z,.SH41
            inc  e
            cp   high(KR2)
            jr   z,.SH41
            dec  e
            inc  d
            cp   high(KR3)
            jr   z,.SH41
            inc  e
.SH41
            ld   (WHERE),de

FindPlanetAtCursor   ; orig: OPRPLAN
; Определение планеты на которую поставить
; Курсор
            ld   ix,MSTARS-5
            ld   bc,5
.AQ3
            ld   de,(WHERE+2)
.AQ1
            add  ix,bc
            ld   a,(ix+0)
            and  a
            jp   m,.AQ2
            ld   l,(ix+2)
            ld   h,(ix+3)
            SUB_DE
            jr   nz,.AQ1
            ld   l,a
            ld   h,(ix+1)
            ld   de,(WHERE)
            SUB_DE
            jr   nz,.AQ3
            ld   a,(ix+4)
            jr   .AQ4
.AQ2
            cp   #FF
            jp   z,.AQ1
            xor  a
.AQ4
            ld   (WPLANET),a
            ret


GenerateMapTiles   ; orig: GENKART
; Генерация четырёх карт (знакомест звёздного поля)
; Генерить четыре карты координаты верхней
; Левой карты из этих четырех генерируемых
            push de
            push hl
            push bc
            ld   de,(KCORD)
            exx
            ld   hl,KR1
            call .RNDI
            inc  e
            exx
            ld   hl,KR2
            call .RNDI
            inc  d
            exx
            ld   hl,KR4
            call .RNDI
            dec  e
            exx
            ld   hl,KR3
            call .RNDI
            pop  bc
            pop  hl
            pop  de
            ret


.RNDI
            exx
            push de
            ld   l,e
            ld   e,d
            ld   bc,#8237
            ld   h,0
            ld   d,h
            exx
.RNX
            exx
            add  hl,de
            ld   a,h
            xor  #0A
            ld   h,a
            push de
            ld   d,b
            ld   e,c
            add  hl,bc
            ld   b,h
            ld   c,l
            pop  hl
            ld   a,h
            exx
            ld   (hl),a
            inc  l
            exx
            ld   a,d
            exx
            ld   (hl),a
            inc  l
            jp   nz,.RNX
            exx
            pop  de
            ret


; Генерация таблицы поиска адреса по
; Координатам в окне карты и байт пиксели
; Для каждой позиции
; de-коорд. карты

MTBXX2_
            ld   a,e
            add  a,8
            ld   e,a
            ld   a,d
            add  a,#10
            ld   l,a

            GETADR

; de-адрес на экране
            and  #1F
            ex   af,af'
            ld   a,e
            and  %11100000
            ld   e,a

            ld   hl,TBXX2_
.MT1_2
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            NEXTLINEDE
            inc  l
            jr   nz,.MT1_2
            inc  h
            inc  h
            ld   a,#80
            ex   af,af'
.MT3_2
            ld   b,8
.MT2
            ld   (hl),a
            ex   af,af'
            inc  h
            ld   (hl),a
            rrca
            dec  h
            ex   af,af'
            inc  l
            djnz .MT2
            inc  a
            inc  l
            dec  l
            jr   nz,.MT3_2
            ret


BuildVisibleStars   ; orig: MBUFM
; Создание буфера видимых звезд
; 1:1=0 END
            halt
            ld   (.STK97+1),sp
            ld   hl,DOTB
            exx
            ld   de,(EYEX)          ; Psy,psx

            ld   a,(BXKRT)
            ld   (.BXK1_+1),a
            ld   (.BXK3_+1),a
            dec  a
            neg
            ld   (.BXK4_+1),a
            ld   (.BXK2_+1),a

            ld   a,(BYKRT)
            ld   (.BYK1_+1),a
            dec  a
            neg
            ld   (.BYK2_+1),a


.BYK1_
            ld   bc,#8170           ; Y-borders
            ld   sp,KR1
.NT
            djnz .NT3
            jr   .NT4-2
.NT3
            pop  hl
            ld   a,h
            sub  d
            jp   c,.NT
            cp   c
            jp   nc,.NT
            ex   af,af'
            ld   a,l
            sub  e
            jp   c,.NT
.BXK1_
            cp   #D0
            jp   nc,.NT
            exx
            ld   (hl),a
            inc  l
            ex   af,af'
            ld   (hl),a
            EXD
            ld   hl,0-2
            add  hl,sp
            EXD
            inc  h
            ld   (hl),d
            dec  l
            ld   (hl),e
            inc  l
            inc  l
            dec  h
            exx
            jp   .NT
            ld   b,#81
.NT4
            djnz .NT31
            jr   .NT41-3
.NT31
            pop  hl
            ld   a,h
            sub  d
            jp   c,.NT4
            cp   c
            jp   nc,.NT4
            ex   af,af'
            ld   a,e
            sub  l
            jp   c,.NT4
.BXK2_
            cp   #31
            jp   c,.NT4
            exx
            neg
            ld   (hl),a
            inc  l
            ex   af,af'
            ld   (hl),a
            EXD
            ld   hl,0-2
            add  hl,sp
            EXD
            inc  h
            ld   (hl),d
            dec  l
            ld   (hl),e
            inc  l
            inc  l
            dec  h
            exx
            jp   .NT4
.BYK2_
            ld   bc,#8191
.NT41
            djnz .NT32
            jr   .NT42-2
.NT32
            pop  hl
            ld   a,d
            sub  h
            jp   c,.NT41
            cp   c
            jp   c,.NT41
            ex   af,af'
            ld   a,l
            sub  e
            jp   c,.NT41
.BXK3_
            cp   #D0
            jp   nc,.NT41
            exx
            ld   (hl),a
            inc  l
            ex   af,af'
            neg
            ld   (hl),a
            EXD
            ld   hl,0-2
            add  hl,sp
            EXD
            inc  h
            ld   (hl),d
            dec  l
            ld   (hl),e
            inc  l
            inc  l
            dec  h
            exx
            jp   .NT41
            ld   b,#81
.NT42
            djnz .NT33
            exx
            inc  h
            inc  l
            ld   (hl),0
.STK97
            ld   sp,0
            ret
.NT33
            pop  hl
            ld   a,d
            sub  h
            jp   c,.NT42
            cp   c
            jp   c,.NT42
            ex   af,af'
            ld   a,e
            sub  l
            jp   c,.NT42
.BXK4_
            cp   #31
            jp   c,.NT42
            exx
            neg
            ld   (hl),a
            inc  l
            ex   af,af'
            neg
            ld   (hl),a
            EXD
            ld   hl,0-2
            add  hl,sp
            EXD
            inc  h
            ld   (hl),d
            dec  l
            ld   (hl),e
            inc  l
            inc  l
            dec  h
            exx
            jp   .NT42


ChoosePlanet   ; orig: PLANCH
; Выбор планеты в окне карты
; Выбрать планету в карте
; hl-коорд. окна
; a-кол. планет
; В wplanet возвр. номер

            ld   de,(Mcoord)
            ld   bc,#0404
            add  hl,bc
            ADDHLHL 3
            ld   bc,#0603
            add  hl,bc
            EXD
            SUB_DE
            EXD
            ld   hl,#FFFF
            ld   (.MINR2+1),hl

            ld   b,a

            ld   hl,(PW1+1)
            call .MINRA
            jr   nc,$+4
            ld   c,0
            dec  b
            jr   z,.PH0
            ld   hl,(PW2+1)
            call .MINRA
            jr   nc,$+4
            ld   c,1
            dec  b
            jr   z,.PH0
            ld   hl,(PW3+1)
            call .MINRA
            jr   nc,$+4
            ld   c,2
            dec  b
            jr   z,.PH0
            ld   hl,(PW4+1)
            call .MINRA
            jr   nc,$+4
            ld   c,3
            dec  b
            jr   z,.PH0
            ld   hl,(PW5+1)
            call .MINRA
            jr   nc,$+4
            ld   c,4
            dec  b
            jr   z,.PH0
            ld   hl,(PW6+1)
            call .MINRA
            jr   nc,$+4
            ld   c,5
.PH0
            ld   a,c
            ld   (WPLANET),a
            ret


.MINRA
; Найти ближ планету
            ld   a,(hl)
            inc  hl
            sub  e
            jp   p,$+5
            neg
            ex   af,af'
            ld   a,(hl)
            sub  d
            jp   p,$+5
            neg
            exx
            call RAST
.MINR2
            ld   de,#FFFF
            SUB_DE
            exx
            ret  nc
            exx
            add  hl,de
            ld   (.MINR2+1),hl
            scf
            exx
            ret


AnimatePlanets   ; orig: MOVPLAN
; Движение планет в окне
; a-кол. планет
; de-коорд. окна в знаках
            ld   (KOLP+1),a
            ex   af,af'
            ld   a,4
            add  a,e
            ld   l,a
            ld   a,4
            add  a,d
            ld   h,a
            ADDHLHL 3
            push hl
            EXD

            ld   l,d

            GETADR

            EXD
            inc  h
            inc  h
            inc  h
            inc  h

            ld   a,%00011100
            LDX_HL_A
            inc  h
            ld   a,%00111110
            LDX_HL_A
            inc  h
            ld   a,%00111110
            LDX_HL_A
            inc  h
            ld   a,%00111110
            LDX_HL_A
            inc  h
            NEXTZNAK
            ld   a,%00011100
            LDX_HL_A
            pop  hl
            ld   bc,#0603
            add  hl,bc
            ld   b,h
            ld   c,l


ADP1
            ld   hl,0
            call PlanetCursorKind
            ld   (ADP+1),hl
PW1
            ld   hl,PWAYS+138+40
            ld   a,(hl)
            cp   #80
            jr   nz,$+7
            ld   hl,PWAYS+138
            jr   $-8
            call DrawPlanetSprite
            ld   (PW1+1),hl
            ret  m

ADP2
            ld   hl,0
            call PlanetCursorKind
            ld   (ADP+1),hl
PW2
            ld   hl,PWAYS+57+28
            ld   a,(hl)
            cp   #80
            jr   nz,$+7
            ld   hl,PWAYS+57
            jr   $-8
            call DrawPlanetSprite
            ld   (PW2+1),hl
            ret  m

ADP3
            ld   hl,0
            call PlanetCursorKind
            ld   (ADP+1),hl
PW3
            ld   hl,PWAYS+12
            ld   a,(hl)
            cp   #80
            jr   nz,$+7
            ld   hl,PWAYS
            jr   $-8
            call DrawPlanetSprite
            ld   (PW3+1),hl
            ret  m

ADP4
            ld   hl,0
            call PlanetCursorKind
            ld   (ADP+1),hl
PW4
            ld   hl,PWAYS+243+60
            ld   a,(hl)
            cp   #80
            jr   nz,$+7
            ld   hl,PWAYS+243
            jr   $-8
            call DrawPlanetSprite
            ld   (PW4+1),hl
            ret  m

ADP5
            ld   hl,0
            call PlanetCursorKind
            ld   (ADP+1),hl
PW5
            ld   hl,PWAYS+372+100
            ld   a,(hl)
            cp   #80
            jr   nz,$+7
            ld   hl,PWAYS+372
            jr   $-8
            call DrawPlanetSprite
            ld   (PW5+1),hl
            ret  m

ADP6
            ld   hl,0
            call PlanetCursorKind
            ld   (ADP+1),hl
PW6
            ld   hl,PWAYS+525
            ld   a,(hl)
            cp   #80
            jr   nz,$+7
            ld   hl,PWAYS+525
            jr   $-8
            call DrawPlanetSprite
            ld   (PW6+1),hl
            ret


PlanetCursorKind   ; orig: WHO_
; Вид курсора мигающей планеты
; Опред. вида курсора если тот маргает
; Маргает только курсор текущей планеты
            ld   de,SprPlanetCursor
            SUB_DE
            add  hl,de
            ret  nz
            ld   a,%11001100
            rrca
            ld   ($-2),a
            ret  c
            ld   hl,SprPlanet
            ret


PlanetsSelectionKind   ; orig: WHO
; Определение типа выделения всех планет
; a-кол. планет
            ld   b,a
            ld   (KOLP+1),a
            call .WHO2
            ld   (ADP1+1),hl
            dec  b
            ret  z
            call .WHO2
            ld   (ADP2+1),hl
            dec  b
            ret  z
            call .WHO2
            ld   (ADP3+1),hl
            dec  b
            ret  z
            call .WHO2
            ld   (ADP4+1),hl
            dec  b
            ret  z
            call .WHO2
            ld   (ADP5+1),hl
            dec  b
            ret  z
            call .WHO2
            ld   (ADP6+1),hl
            ret

.WHO2
            ld   l,b
KOLP
            ld   a,0
            sub  l
            ld   hl,(WHERE+2)
            ld   de,(PLACE+2)
            SUB_DE
            jr   nz,.PW_
            ld   hl,(WHERE)
            ld   de,(PLACE)
            SUB_DE
            jr   nz,.PW_
            ld   l,a
            ld   a,(PLANET)
            cp   l
            ld   a,l
            jr   nz,.PW_
            ld   hl,SprPlanetHere
            ret
.PW_
            ld   l,a
            ld   a,(WPLANET)
            cp   l
; Выбор
            ld   a,l
            ld   hl,SprPlanetCursor
            ret  z
            ld   (.NP1+1),a

; На проверку далее
            push bc


            ld   ix,WAY-5
            ld   bc,5
.PW_3
            ld   de,(WHERE+2)
.PW_4
            add  ix,bc
            ld   a,(ix+0)
            or   a
            jp   m,.PW_2
            ld   l,(ix+2)
            ld   h,(ix+3)
            SUB_DE
            jr   nz,.PW_4
            ld   l,a
            ld   h,(ix+1)
            ld   de,(WHERE)
            SUB_DE
            jr   nz,.PW_3
.NP1
            ld   a,0
            cp   (ix+4)
            jr   nz,.PW_3
            ld   hl,SprPlanetRoute
            pop  bc
            ret
.PW_2
            ld   hl,SprPlanet
            pop  bc
            ret


DrawPlanetSprite   ; orig: PLOUT
; Вывод спрайта планеты или маркера ее
; a-X
; (HL+1)-Y
; A'-кол. планет
; c,b-коорд. центра
            inc  hl
            add  a,c
            ld   e,a
            ld   a,(hl)
            inc  hl
            ex   af,af'
            dec  a
            ret  m
            ex   af,af'
            add  a,b
            ld   d,a
            push hl

            ld   l,d

            GETADR

            ld   a,l
            and  7
            add  a,a
            ld   l,a
            add  a,a
            add  a,l
ADP
            ld   hl,0
            add  a,l
            ld   l,a
            ld   a,h
            adc  a,0
            ld   h,a
            EXD

            ld   a,(de)
            LDX_HL_A
            inc  l
            inc  de
            ld   a,(de)
            LDX_HL_A
            dec  l
            inc  de
            NEXTLINE
            ld   a,(de)
            LDX_HL_A
            inc  l
            inc  de
            ld   a,(de)
            LDX_HL_A
            dec  l
            inc  de
            NEXTLINE
            ld   a,(de)
            LDX_HL_A
            inc  l
            inc  de
            ld   a,(de)
            LDX_HL_A
            pop  hl
            xor  a
            ret


FindStarInRoute   ; orig: FSTAR2
; Поиск звезды (where)
; В буфере маршрута
; Fs-on не найдена
            ld   de,WAY
            jr   FindStarInMemory+3

FindStarInMemory   ; orig: FSTAR
; Поиск звезды (where)
; В буфере запоминаний
; Fs-on не найдена
            ld   de,MSTARS
.F_R2
            ld   a,(de)
            inc  a
            jr   z,.F_R1
            dec  a
            ret  m
            ld   l,a
            inc  de
            ld   a,(de)
            ld   h,a
            inc  de
            ld   bc,(WHERE)
            SUB_BC
            jr   nz,.F_R1+2
            ld   a,(de)
            ld   l,a
            inc  de
            ld   a,(de)
            ld   h,a
            ld   bc,(WHERE+2)
            SUB_BC
            jr   nz,.F_R1+3
            xor  a
            ret
.F_R1
            INC_DE 5
            jr   .F_R2

PrintPlanetNameHere   ; orig: PNTPLN
; Печать имени планеты текущей системы
            ld   hl,(WHERE)
            ld   de,(WHERE+2)

PrintPlanetName   ; orig: PNTPLAN
; Печать имени планеты
; a-номер с 0
; hl,de-данные системы
            ld   (RNDD1),hl
            ld   (RNDD2),de
            ld   c,a
            inc  a
            ld   b,a
            ld   a,l
            xor  d
            xor  e
            xor  h
            and  7
            dec  a
            jp   p,$+4
            xor  a
            jr   nz,$+8
            RST_ "-"
            ret

            call RNDD
            djnz $-3
            ld   b,a
            and  #0F
            add  a,128
            RST___NOARG
            RST_ "-"
            ld   a,b
            and  #F0
            rrca
            rrca
            rrca
            rrca
            inc  a
            add  a,c
            ld   c,a
            ld   b,0
            xor  a
            jp   PrintNumberPad


PaintMarkRow   ; orig: CHHS
; Закрасить строку для маркировки
; Красит строку для маркировки
; b-ширина окна
; hl-адрес на екране
            ld   a,31
            sub  b                  ; Ширина окна
            add  a,a
            add  a,a
            ld   (.JJ_88+1),a

            ld   b,8
.U_2
            ld   c,l
            rrc  e
            jr   c,$+7
            ld   a,%00011111
            LDX_HL_A
            inc  l

.JJ_88
            jr   $+2
            rept 31
            ld   a,(hl)
            cpl
            ld   (hl),a
            inc  l
            endr

            rrc  e
            jr   c,$+6
            ld   a,%11111000
            LDX_HL_A

            ld   l,c
            NEXTLINE
            dec  b
            jp   nz,.U_2
            ret


GetSystemData   ; orig: PINFO_
; Данные системы по номеру планеты
; Определение данных системы
; hl,de-данные системы
; a-номер планеты с 0
; ret:
; a-кол. планет
; l-уровень
; h-строй
; e-специализация
; d-номер государтсва
            push bc
            ex   af,af'
            ld   a,h
            xor  l
            xor  e
            xor  d
            and  7
            dec  a
            jp   p,$+4
            xor  a
            ex   af,af'
            ld   (RNDD1),hl
            ld   (RNDD2),de
            inc  a
            ld   b,a

            call FindStateAtMap
            push af
            cp   3
            ld   c,0
            jr   nz,$+3
            inc  c
            call RNDD
            djnz $-3
            pop  de

            cpl
            ld   e,a
; %Ssuuuutt
            and  %00111100
            rrca
            rrca
            inc  a
            ld   l,a
            ld   a,e
            rlca
            rlca
            and  3
            dec  c
            jr   nz,$+4
            ld   a,4
            ld   h,a
            ld   a,e
            and  3
            ld   e,a
            ex   af,af'
            pop  bc
            ret


MarkRouteLine   ; orig: MARKOL
; Определение и коректировка вектора
; Маски линии, количества узлов и номера
; Их опр. кол.

; Проверить адрес звезды с котор. будет
; Построение чтобы не было вылетов
; Или пустого места
            ld   hl,(AWAYS)
            ld   bc,0-5
            ld   a,(hl)
            inc  a
            jr   z,$+5
            jp   p,$+7
            add  hl,bc
            jp   $-8
            ld   de,WAY
            SUB_DE
            jr   nc,$+5
            EXD
            jr   $+3
            add  hl,de
            ld   (AWAYS),hl

            ld   hl,WAY
            ld   de,5
            ld   b,0
            ld   a,(hl)
            add  hl,de
            inc  a
            jp   m,$+8
            jr   z,$-6
            inc  b
            jr   $-9
            ld   a,(WAYMASK)
            and  %11110000
            or   b
            ld   (WAYMASK),a
            ld   a,b
            and  a
            ret  z
            ld   hl,WAYMASK+1
            xor  a
            ld   (hl),a
            inc  hl
            add  a,5
            djnz $-4
            ret

PWAYS
            incbin "ways.d"


; Просто планета

SprPlanet   ; orig: SPRP
; Спрайт: просто планета
            db   %00000000,0
            db   %01000000,0
            db   %00000000,0
            db   %00000000,0
            db   %00100000,0
            db   %00000000,0
            db   %00000000,0
            db   %00010000,0
            db   %00000000,0
            db   %00000000,0
            db   %00001000,0
            db   %00000000,0
            db   %00000000,0
            db   %00000100,0
            db   %00000000,0
            db   %00000000,0
            db   %00000010,0
            db   %00000000,0
            db   %00000000,%00000000
            db   %00000001,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%10000000
            db   %00000000,%00000000
; Пребывание на планете

SprPlanetHere   ; orig: SPRP2
; Спрайт: планета пребывания
            db   %10100000,0
            db   %01000000,0
            db   %10100000,0
            db   %01010000,0
            db   %00100000,0
            db   %01010000,0
            db   %00101000,0
            db   %00010000,0
            db   %00101000,0
            db   %00010100,0
            db   %00001000,0
            db   %00010100,0
            db   %00001010,0
            db   %00000100,0
            db   %00001010,0
            db   %00000101,0
            db   %00000010,0
            db   %00000101,0
            db   %00000010,%10000000
            db   %00000001,%00000000
            db   %00000010,%10000000
            db   %00000001,%01000000
            db   %00000000,%10000000
            db   %00000001,%01000000
; Маршрутная планета

SprPlanetRoute   ; orig: SPRP3
; Спрайт: маршрутная планета
            db   %11100000,0
            db   %10100000,0
            db   %11100000,0
            db   %01110000,0
            db   %01010000,0
            db   %01110000,0
            db   %00111000,0
            db   %00101000,0
            db   %00111000,0
            db   %00011100,0
            db   %00010100,0
            db   %00011100,0
            db   %00001110,0
            db   %00001010,0
            db   %00001110,0
            db   %00000111,0
            db   %00000101,0
            db   %00000111,0
            db   %00000011,%10000000
            db   %00000010,%10000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000001,%01000000
            db   %00000001,%11000000
; Выбор планеты

SprPlanetCursor   ; orig: SPRP4
; Спрайт: выбор планеты
            db   %01000000,0
            db   %11100000,0
            db   %01000000,0
            db   %00100000,0
            db   %01110000,0
            db   %00100000,0
            db   %00010000,0
            db   %00111000,0
            db   %00010000,0
            db   %00001000,0
            db   %00011100,0
            db   %00001000,0
            db   %00000100,0
            db   %00001110,0
            db   %00000100,0
            db   %00000010,0
            db   %00000111,0
            db   %00000010,0
            db   %00000001,%00000000
            db   %00000011,%10000000
            db   %00000001,%00000000
            db   %00000000,%10000000
            db   %00000001,%11000000
            db   %00000000,%10000000


SprPlus   ; orig: SPLUS
; Спрайт-маркер плюс
            db   %00010000,%00000000
            db   %00010000,%00000000
            db   %00000000,%00000000
            db   %11000110,%00000000
            db   %00000000,%00000000
            db   %00010000,%00000000
            db   %00010000,%00000000
            db   %00000000,%00000000
            db   %00001000,%00000000
            db   %00001000,%00000000
            db   %00000000,%00000000
            db   %01100011,%00000000
            db   %00000000,%00000000
            db   %00001000,%00000000
            db   %00001000,%00000000
            db   %00000000,%00000000
            db   %00000100,%00000000
            db   %00000100,%00000000
            db   %00000000,%00000000
            db   %00110001,%10000000
            db   %00000000,%00000000
            db   %00000100,%00000000
            db   %00000100,%00000000
            db   %00000000,%00000000
            db   %00000010,%00000000
            db   %00000010,%00000000
            db   %00000000,%00000000
            db   %00011000,%11000000
            db   %00000000,%00000000
            db   %00000010,%00000000
            db   %00000010,%00000000
            db   %00000000,%00000000
            db   %00000001,%00000000
            db   %00000001,%00000000
            db   %00000000,%00000000
            db   %00001100,%01100000
            db   %00000000,%00000000
            db   %00000001,%00000000
            db   %00000001,%00000000
            db   %00000000,%00000000
            db   %00000000,%10000000
            db   %00000000,%10000000
            db   %00000000,%00000000
            db   %00000110,%00110000
            db   %00000000,%00000000
            db   %00000000,%10000000
            db   %00000000,%10000000
            db   %00000000,%00000000
            db   %00000000,%01000000
            db   %00000000,%01000000
            db   %00000000,%00000000
            db   %00000011,%00011000
            db   %00000000,%00000000
            db   %00000000,%01000000
            db   %00000000,%01000000
            db   %00000000,%00000000
            db   %00000000,%00100000
            db   %00000000,%00100000
            db   %00000000,%00000000
            db   %00000001,%10001100
            db   %00000000,%00000000
            db   %00000000,%00100000
            db   %00000000,%00100000
            db   %00000000,%00000000

SprMinus   ; orig: SMINI
; Спрайт-маркер минус
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00111000,%00000000
            db   %00101000,%00000000
            db   %00111000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00011100,%00000000
            db   %00010100,%00000000
            db   %00011100,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00001110,%00000000
            db   %00001010,%00000000
            db   %00001110,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000111,%00000000
            db   %00000101,%00000000
            db   %00000111,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000011,%10000000
            db   %00000010,%10000000
            db   %00000011,%10000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000001,%11000000
            db   %00000001,%01000000
            db   %00000001,%11000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%11100000
            db   %00000000,%10100000
            db   %00000000,%11100000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%01110000
            db   %00000000,%01010000
            db   %00000000,%01110000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000

SprTriangle   ; orig: STREUG
; Спрайт-маркер треугольник
            db   %00010000,%00000000
            db   %00101000,%00000000
            db   %01000100,%00000000
            db   %10000010,%00000000
            db   %01000100,%00000000
            db   %00101000,%00000000
            db   %00010000,%00000000
            db   %00000000,%00000000
            db   %00001000,%00000000
            db   %00010100,%00000000
            db   %00100010,%00000000
            db   %01000001,%00000000
            db   %00100010,%00000000
            db   %00010100,%00000000
            db   %00001000,%00000000
            db   %00000000,%00000000
            db   %00000100,%00000000
            db   %00001010,%00000000
            db   %00010001,%00000000
            db   %00100000,%10000000
            db   %00010001,%00000000
            db   %00001010,%00000000
            db   %00000100,%00000000
            db   %00000000,%00000000
            db   %00000010,%00000000
            db   %00000101,%00000000
            db   %00001000,%10000000
            db   %00010000,%01000000
            db   %00001000,%10000000
            db   %00000101,%00000000
            db   %00000010,%00000000
            db   %00000000,%00000000
            db   %00000001,%00000000
            db   %00000010,%10000000
            db   %00000100,%01000000
            db   %00001000,%00100000
            db   %00000100,%01000000
            db   %00000010,%10000000
            db   %00000001,%00000000
            db   %00000000,%00000000
            db   %00000000,%10000000
            db   %00000001,%01000000
            db   %00000010,%00100000
            db   %00000100,%00010000
            db   %00000010,%00100000
            db   %00000001,%01000000
            db   %00000000,%10000000
            db   %00000000,%00000000
            db   %00000000,%01000000
            db   %00000000,%10100000
            db   %00000001,%00010000
            db   %00000010,%00001000
            db   %00000001,%00010000
            db   %00000000,%10100000
            db   %00000000,%01000000
            db   %00000000,%00000000
            db   %00000000,%00100000
            db   %00000000,%01010000
            db   %00000000,%10001000
            db   %00000001,%00000100
            db   %00000000,%10001000
            db   %00000000,%01010000
            db   %00000000,%00100000
            db   %00000000,%00000000

SprEmpty   ; orig: SNULL
; Спрайт-маркер пустой
            db   %00000000,%00000000
            db   %00111000,%00000000
            db   %01000100,%00000000
            db   %01000100,%00000000
            db   %01000100,%00000000
            db   %00111000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00011100,%00000000
            db   %00100010,%00000000
            db   %00100010,%00000000
            db   %00100010,%00000000
            db   %00011100,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00001110,%00000000
            db   %00010001,%00000000
            db   %00010001,%00000000
            db   %00010001,%00000000
            db   %00001110,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000111,%00000000
            db   %00001000,%10000000
            db   %00001000,%10000000
            db   %00001000,%10000000
            db   %00000111,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000011,%10000000
            db   %00000100,%01000000
            db   %00000100,%01000000
            db   %00000100,%01000000
            db   %00000011,%10000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000001,%11000000
            db   %00000010,%00100000
            db   %00000010,%00100000
            db   %00000010,%00100000
            db   %00000001,%11000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%11100000
            db   %00000001,%00010000
            db   %00000001,%00010000
            db   %00000001,%00010000
            db   %00000000,%11100000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%01110000
            db   %00000000,%10001000
            db   %00000000,%10001000
            db   %00000000,%10001000
            db   %00000000,%01110000
            db   %00000000,%00000000
            db   %00000000,%00000000

SprCross   ; orig: SKREST
; Спрайт-маркер крест
            db   %10000010,%00000000
            db   %01000100,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %01000100,%00000000
            db   %10000010,%00000000
            db   %00000000,%00000000
            db   %01000001,%00000000
            db   %00100010,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00100010,%00000000
            db   %01000001,%00000000
            db   %00000000,%00000000
            db   %00100000,%10000000
            db   %00010001,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00010001,%00000000
            db   %00100000,%10000000
            db   %00000000,%00000000
            db   %00010000,%01000000
            db   %00001000,%10000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00001000,%10000000
            db   %00010000,%01000000
            db   %00000000,%00000000
            db   %00001000,%00100000
            db   %00000100,%01000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000100,%01000000
            db   %00001000,%00100000
            db   %00000000,%00000000
            db   %00000100,%00010000
            db   %00000010,%00100000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000010,%00100000
            db   %00000100,%00010000
            db   %00000000,%00000000
            db   %00000010,%00001000
            db   %00000001,%00010000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000001,%00010000
            db   %00000010,%00001000
            db   %00000000,%00000000
            db   %00000001,%00000100
            db   %00000000,%10001000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%10001000
            db   %00000001,%00000100
            db   %00000000,%00000000


SprSquare   ; orig: SQUADR
; Спрайт-маркер квадрат
            db   %11000110,%00000000
            db   %10000010,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %10000010,%00000000
            db   %11000110,%00000000
            db   %00000000,%00000000
            db   %01100011,%00000000
            db   %01000001,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %01000001,%00000000
            db   %01100011,%00000000
            db   %00000000,%00000000
            db   %00110001,%10000000
            db   %00100000,%10000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00100000,%10000000
            db   %00110001,%10000000
            db   %00000000,%00000000
            db   %00011000,%11000000
            db   %00010000,%01000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00010000,%01000000
            db   %00011000,%11000000
            db   %00000000,%00000000
            db   %00001100,%01100000
            db   %00001000,%00100000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00001000,%00100000
            db   %00001100,%01100000
            db   %00000000,%00000000
            db   %00000110,%00110000
            db   %00000100,%00010000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000100,%00010000
            db   %00000110,%00110000
            db   %00000000,%00000000
            db   %00000011,%00011000
            db   %00000010,%00001000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000010,%00001000
            db   %00000011,%00011000
            db   %00000000,%00000000
            db   %00000001,%10001100
            db   %00000001,%00000100
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000000,%00000000
            db   %00000001,%00000100
            db   %00000001,%10001100
            db   %00000000,%00000000
