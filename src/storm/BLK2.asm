;==============================================================================
; BLK2 - ракеты (Newrokt), старая раздельная версия движка
;
; Инициализация и полёт ракет. Фрагмент без полного набора меток.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

Newrokt
        ; Инициали3ация ракеты
        ; C-субъект на кого атака
        ld   a,c
        call Getadr
        inc  l
        ld   a,(hl)
        cp   #80
        jr   nz,.Rkn12
        ld   hl,SfxEff13
        ld   (SfxChannelA+1),hl
        ld   a,8                ; Цель потеряна
        call Mesags
        and  a
        ret
.Rkn12
        push bc
        exx
        ld   hl,0
        ld   d,h
        ld   e,l
        ld   bc,400
        call Record
        exx
        pop  bc
        ld   a,1
        ex   af,af
        call Aroks
        ld   a,l
        cp   Roks&L_
        ld   a,Minren
        jr   z,$+4
        ld   a,Maxren
        ld   b,PLAYER_INDEX
Rkn11
        ; INIT roket
        ; Hl'-X,de'-Y,bc'-z
        ; C-subject
        ; A'-1-roket of PLAYER,0-roket of somebo
        ; Dy
        ; B-кто пустил ракету
        ld   (Enrok+1),a
        ld   hl,+(Carsb-OBJ_LEN)+1
        ld   de,OBJ_LEN
        add  hl,de
        ld   a,(hl)
        cp   #80
        jr   nz,$-4
        dec  l
        ld   a,(hl)
        cp   #80
        ret  z
        xor  a
        ld   d,h
        ld   e,l

        push hl
        pop  iy
        exx
        ld   (iy+0),l
        ld   (iy+1),h
        ld   (iy+2),e
        ld   (iy+3),d
        ld   (iy+4),c
        ld   (iy+5),b
        exx
        ld   a,l
        add  a,6
        ld   l,a
        ld   (hl),Iroket
        inc  l
        xor  a
        ld   (hl),a
        inc  l
        ld   (hl),a
        inc  l
        ld   (hl),a
        inc  l
        ld   (hl),8             ; Mode roket navod
        inc  l
        ld   (hl),a
        inc  l
        ld   (hl),a
        inc  l
        ld   (hl),b             ; Кто пустил ракету
        inc  l
        inc  l
        ld   (hl),c             ; Subject on mspd
        inc  l
        inc  l
        ex   af,af
        ld   (hl),a             ; Принадлежность
        ; Ракеты K игроку <>0
        ; Вместо lzs
        inc  l
        ld   (hl),#11           ; Roketa
        inc  l
Enrok   ld   (hl),0             ; Энергия
        ld   a,l
        add  a,Spt-Energy
        ld   l,a
        ld   (hl),2

        ; Предупр. того b кого выстрелили что по
        ; Нему ракета идет
        ld   a,c
        call Getadr
        ld   a,l
        add  a,Actn
        ld   l,a
        set  1,(hl)
        dec  l
        ex   de,hl
        call Getind
        ld   (de),a             ; Номер ракеты b списке
        scf
        ret
RedrawPanel                     ; orig: Repanel
        ; Вывод индикаторов панели , a так же вр
        ; Емени
        ld   bc,PORT_PAGE
        push bc
        ld   a,Pgnorm
        out  (c),a
        ld   a,1
        ld   (DrawSpeed+1),a
        ld   (DrawFire+1),a
        ld   (DrawShield+1),a
        ld   (Fhigh+1),a
        ld   (Ftempe+1),a
        ld   (DrawFuel+1),a
        call DrawStatusLine     ; Индикаторы
        pop  bc
        ld   a,Pgstar
        out  (c),a
        ld   hl,(Time+2)
        ld   de,(Time)
        ld   b,#FF
        jp   Zerot1             ; Время

Korni
        ; Подсчет корня
        ; De-счего брать корень
        ; A-3начение
        push bc
        ld   bc,PORT_PAGE
        ld   a,Pgcontr
        out  (c),a
        call Korni2
        ld   bc,PORT_PAGE
        ex   af,af
        ld   a,Pgnorm
        out  (c),a
        ex   af,af
        pop  bc
        ret

Wayungl
; Точное определение двух углов поворота
; Объекта носом на другой
; Формулы
; Вета=arctag(ав/dz)
; Gama=arctag(dy/dx)
; Ав=sqrt(dx^2+dy^2)
; 3Нак вета 3ависит от 3нака dx

; Расчет ав
;
; Входные данные
; De-X1,hl-x2,bc-Y1,hl'-y2
; De'-z2,bc'-z1
; Ret
; B-beta,c-gama

        ; MULL hlde=hl*de
        push ix
        sra  h
        rr   l
        sra  d
        rr   e
        and  a
        sbc  hl,de
        ; Hl-dx
        push hl
        push bc
        ld   d,h
        ld   e,l
        call Mull
        ex   de,hl
        pop  bc
        exx
        push hl
        exx
        pop  hl
        sra  h
        rr   l
        sra  b
        rr   c
        and  a
        sbc  hl,bc
        ; Hl-dy
        push hl
        push de
        ld   d,h
        ld   e,l
        call Mull
        pop  de
        add  hl,de
        ; Hl-старшая часть от ав^2=dx^2+dy^2
        ex   de,hl
        call Korni
        ld   h,a
        ld   l,0
        push hl
        exx
        ex   de,hl

        and  a
        sbc  hl,bc

        push hl
        exx
        pop  de
        ; De-dz
        pop  hl
        call Atagdiv
        pop  hl
        pop  de
        ; Hl-dy,de-dx
        push af
        call Atagdiv
        pop  bc
        sub  #40
        neg
        ld   c,a

        ld   a,#40
        sub  b
        add  a,#80
        ld   b,a

        pop  ix
        ret

Onway
        ; Наведение носа объекта на др. объект
        ; Hl,bc,de-x2,Y1,X1
        ; Hl',bc',de'-y2,z1,z2
        ; X1,... - корд. объекта которого наводят
        ; X2,... - на который наводят
        push hl
        push de
        push bc
        ld   a,(ix+Subj)
        call Getadr
        push hl
        pop  iy
        ld   a,(iy+1)
        cp   #80
        jr   z,.Nonw
        call Rastoy
        cp   Minras             ; Растояние для св
        ; Орачивания
        jr   c,Turnup
.Nonw
        pop  bc
        pop  de
        pop  hl
Onway2
        call Wayungl
        ld   a,(ix+Beta)
        ld   d,a
        sub  b
        ld   e,a
        jp   p,$+5
        neg
        ld   l,a
        cp   2
        jr   c,.Jlk1
        ld   a,(ix+Spt)
        cp   l
        jr   c,.Oy1
        jr   z,.Oy1
        rra
        jp   $-6
.Oy1
        bit  7,e
        jr   nz,$+4
        neg
        add  a,d
        ld   (ix+Beta),a
.Jlk1
        ld   a,(ix+Gama)
        ld   d,a
        sub  c
        ld   e,a
        jp   p,$+5
        neg
        ld   h,a
        cp   (ix+Spt)
        ret  c
        ld   a,(ix+Spt)
        cp   h
        jr   z,.Oy2
        jr   c,.Oy2
        rra
        jp   $-6
.Oy2
        bit  7,e
        jr   nz,$+4
        neg
        add  a,d
        ld   (ix+Gama),a
        ret

Turnup
        pop  bc
        pop  de
        pop  hl
        ld   a,(ix+Mode)
        ld   (ix+Pmode),a
        ld   a,r
        and  #0F
        add  a,5
        ld   (ix+Powor),a
        ld   (ix+Mode),17       ; Turning out
        ld   bc,#8080
        ret

Getadr
        ; Получение адреса и3 индекса
        ; A-index
        ; Ret hl-adr
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
Clc2d3d
        ; Calc 2d from 3d
        ; De-z,hl-Y,bc-X
        ; Ret hl-X,de-Y
        ; Fz=nz-error
        push bc
        push de
        ; Z
        bit  7,d
        jr   z,$+9
        ld   a,e
        cpl
        ld   e,a
        ld   a,d
        cpl
        ld   d,a
        inc  de
        ; Y
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

        ld   bc,Yend+(1/2)      ; Midle Y
        add  hl,bc
        ld   b,h
        ld   c,l
        ; X
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

        ld   de,#0080           ; Midle X
        add  hl,de
        pop  de
        xor  a
        ret
Ld3
        pop  af
        xor  a
        inc  a
        ret
Charco
        ; Change roket one of kord
        and  a
        sbc  hl,bc
        ld   d,h
        ld   e,l
        jp   p,$+10
        ld   a,d
        cpl
        ld   d,a
        ld   a,l
        cpl
        ld   e,a
        inc  de

Rokspd          equ 180

        ld   a,d
        cp   1
        ld   a,Rokspd
        jr   nc,.Rsp1
        ld   a,e
        srl  d
        rra
        srl  d
        rra
        srl  a
.Rsp1
        ld   e,a
        ld   d,0
        bit  7,h
        jr   nz,$+9
        ld   a,d
        cpl
        ld   d,a
        ld   a,e
        cpl
        ld   e,a
        inc  de
        add  hl,de
        ld   a,h
        add  hl,bc
        and  a
        jp   p,$+4
        cpl
        exx
        or   c
        ld   c,a
        exx
        ret
Getindy
        ; Iy-adr
        push hl
        push iy
        pop  hl
        call Getind
        pop  hl
        ret
Getind
        ; Берет индекс от адреса b списке объект
        ; Ов
        ; Hl-adr
        ; Ret a-index
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
Stabl
        ; Таблица индексирования статуса при поп
        ; Адании b опр. объект
        db   #FA, 10, 15, 18, 9, #FA, #FA, #FA, 6
        ds   7, 0
Shut
        ; Регистрация попадания игрока b персона
        ; Жа
        ld   hl,0               ; Адрес персонажа
        ld   a,l
        or   h
        ret  z                  ; Не было попадания
        ld   bc,Actn
        add  hl,bc
        set  0,(hl)             ; Выстрел ла3ером
        dec  hl
        ld   c,(hl)
        ; B c номер того c которым имел дело пер
        ; Сонаж до этого
        ld   (hl),PLAYER_INDEX
        ld   a,l
        add  a,Type-Subj
        ld   l,a
        ld   b,(hl)             ; Тип персонажа
        ld   hl,0
        ld   (Shut+1),hl
        ; 3Вук попадания
        ld   hl,SfxEff21
        ld   (SfxChannelA+1),hl
        ld   a,c
        cp   PLAYER_INDEX
        ret  z                  ; Если пред. был игрок
Chstat_
        ld   a,b
        cp   #10
        ret  nc                 ; Если это просто объекты
        ld   l,b
        ld   h,0
        ld   bc,Stabl
        add  hl,bc
        ld   c,(hl)
; ;По типу и3 таблицы в3яли минус статус
; От игрока
Chstat
        ld   a,(Statgen+1)
        and  a
        jr   z,$+10
        ld   a,c
        and  a
        jp   m,$+6
        add  a,10
        ld   c,a
        ld   a,(Status)
        ld   b,a
        add  a,c
        jp   po,$+6
        sub  c
        ld   a,#7F
        jp   p,$+4
        xor  a
        ld   c,a
        ld   a,b
        cp   32
        jr   nc,$+4
        set  5,c
        ld   a,c
        ld   (Status),a
        ret
Fline
        ; Рисование ла3ера игрока
        ld   a,0
Pstli   add  a,50
        ld   ($-3),a
        ret  nc
        ld   a,(Peregrv+1)
        cp   2
        ret  c
        sub  2
        ld   (Peregrv+1),a
        ld   a,1
        ld   (DrawFire+1),a
        xor  a
        ld   (Fll+1),a
        ld   hl,SfxEff2
        ld   (SfxChannelA+1),hl
        ld   hl,#38A9
        ld   a,Ld1l&L_
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
        add  a,6
        add  a,d
        ld   d,a
        push de
        ld   hl,#5F40
        call Drawl1
        ld   hl,#5FC0
        pop  de
        jp   Drawl1
Neword
        ; Новое 3адание b 3ависимости от типа
        ld   a,(ix+Type)
        sla  a
        ld   l,a
        ld   h,0
        ld   bc,Intel
        add  hl,bc
        ld   a,(hl)
        inc  hl
        ld   h,(hl)
        ld   l,a
        jp   (hl)
Intel
        dw   Pirat
        dw   Trade
        dw   Army_
        dw   Polic
        dw   Hunte
        dw   Upira
        dw   Uufo_
        dw   Ufo__
        dw   Otshe
        dup  16
        dw   Nothing
        edup
Nothing
        ret
Upira
        ld   (ix+Mode),1
        call Rnd
        ld   a,h
        or   l
        ret  nz
        jp   Topeace
Otshe
        ld   (ix+Mode),18
        call Rnd
        ld   a,h
        or   l
        ret  nz
        jp   Topeace
Army_
        ld   a,r
        cp   #70
        ld   (ix+Mode),2
        ld   (ix+Subj),#FF
        ret  c
Toufo
        call Findufo
        ret  z
        ld   (ix+Subj),a
        ret
Ufo__
        ld   a,r
        cp   #70
        ld   (ix+Mode),2
        ld   (ix+Subj),#FF
        ret  c
        call Findall
        ret  z
        ld   (ix+Subj),a
        ret
Uufo_
        ld   (ix+Mode),1
        call Rnd
        ld   a,h
        or   l
        jp   nz,Topeace
        jp   Toufo
Trade
        ld   a,(ix+Omode)
        cp   13                 ; Backas
        ret  z
        ld   (ix+Mode),1
        call Rnd
        ld   a,h
        or   l
        ret  nz
        jp   Topeace
Hunte
        ld   a,r
        cp   #70
        ld   (ix+Mode),2
        ld   (ix+Subj),#FF
        ret  c
        call Fndprat
        ret  z
        ld   (ix+Subj),a
        ret
Polic
        ld   a,r
Pwnpp   cp   6
        ld   (ix+Mode),2
        ld   (ix+Subj),#FF
        jr   c,.Polic2
        call Fndprat
        ret  z
        ld   (ix+Subj),a
        ret
; Проверка вашего статуса
.Polic2
        ld   a,(Status)
        cp   64                 ; Ро3ыскиваемый
        ret  c
        push af
        call Rndl1
        pop  af
        cp   l
        ret  c
        ld   a,h
        cp   3
        ret  nc
        ld   (ix+Subj),PLAYER_INDEX
        ret
Pirat
        ld   a,r
Pwnpm   cp   #70
        ld   (ix+Mode),2
Topeace
        ld   (ix+Subj),#FF
        ret  c
        call Fndpece
        ret  z
        ld   (ix+Subj),a
        ret
Datal_
        ld   bc,PORT_PAGE
        ex   af,af
        ld   a,Pgcontr
        out  (c),a
        ex   af,af
        call DrawGauge
        ld   bc,PORT_PAGE
        ld   a,Pgnorm
        out  (c),a
        ret

DrawStatusLine                  ; orig: Datalin
; Вывод данных O 3ащите энергии и др.инф
; O b виде статус линии
DrawShield                      ; orig: Fshild
        ld   a,0
        and  a
        jr   z,DrawFuel
        ld   a,(Shild)
        ld   hl,#49A1
        call Datal_
        xor  a
        ld   (DrawShield+1),a

DrawFuel                        ; orig: Ffuel
        ld   a,0
        and  a
        jr   z,DrawFire
        call Afuel
        rra
        ld   hl,#49E1
        call Datal_

DrawFire                        ; orig: Ffire
        ld   a,0
        and  a
        jr   z,Ftempe
        ld   a,(Peregrv+1)
        ld   hl,#5121
        call Datal_
        xor  a
        ld   (DrawFire+1),a
Ftempe  ld   a,0
        and  a
        jr   z,Fhigh
Tempe   ld   a,0
        ld   hl,#5181
        call Datal_
        xor  a
        ld   (Ftempe+1),a
Fhigh   ld   a,0
        and  a
        jr   z,$+14
High_   ld   a,0
        ld   hl,#51C1
        call Datal_
        xor  a
        ld   (Fhigh+1),a
DrawSpeed                       ; orig: Fspeed
        ld   a,0
        and  a
        jr   z,Fspd
        xor  a
        ld   (DrawSpeed+1),a
        ld   hl,(Speed)
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
        call Datal_
Fspd
        ret

Moveon
        ; MOVING ships in front
        ; De-SPEED
        ; Eyea_,eyeb_,eyeg_-ungels
        ; Ret in stpx_,stpy_,stpz_
        push ix
        push de
        call Shmtrx
        pop  de
Hm_13   ld   a,0
        push de
        ld   ix,$+7
        jp   Lc52c
        pop  de
        ld   (Stpx_+1),hl
Hm_23   ld   a,0
        push de
        ld   ix,$+7
        jp   Lc52c
        pop  de
        ld   (Stpy_+1),hl
Hm_33   ld   a,0
        ld   ix,$+7
        jp   Lc52c
        ld   (Stpz_+1),hl
        pop  ix
        ret
