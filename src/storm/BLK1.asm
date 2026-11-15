; Процедуры управления кораблем, определ
; Ение его
; Столкновений

Moveu
        call Touch              ; Going through sta
        ; T objects
        call Setcont            ; Get control
        ; Settings
        jp   Calcstp
Touch
Cmode   ld   a,0
        and  a
        ret  z
        ld   (Fspeed+1),a
        ld   hl,(Speed)
        bit  7,h
        ex   af,af
        jr   z,$+9
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ld   bc,2
        and  a
        sbc  hl,bc
        ex   af,af
        jr   z,$+9
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ex   af,af
        jr   nc,$+6
        ld   (Speed),hl
        ret
        xor  a
        ld   (Cmode+1),a
        ret
Lm1
        ld   a,1
        ld   (Cmode+1),a
        ld   hl,(Stpx+1)
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ld   (Stpx+1),hl
        ld   hl,(Stpz+1)
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ld   (Stpz+1),hl
        ld   hl,(Stpy+1)
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        ld   (Stpy+1),hl
        ld   hl,(Speed)
        ld   a,l
        cpl
        ld   l,a
        ld   a,h
        cpl
        ld   h,a
        inc  hl
        sra  h
        rr   l
        inc  hl
        ld   (Speed),hl
        ret

Rain
        dec  (hl)
        ld   a,(Tonn)
        dec  a
        ld   (Tonn),a
        ld   a,17               ; Ракета ушла
        call Mesags
        ld   a,10               ; Осталось
        call Mesags
        call Aroks
        call Mnums
        ld   a,11               ; Paket
        jp   Mesags
Nocels
        push af
        ld   a,15               ; Не было 3ахвачено
        ; Не одной цели
        call Mesags
        pop  af
        ret
Aroks
        ld   hl,Roks+1
        ld   a,(hl)
        and  a
        ret  nz
        dec  hl
        ld   a,(hl)
        ret

; Чтение кнопок управления и управление
Setcont
        ld   ix,Lc5b6
        ; Ix-буфер кнопок управления
        ld   a,(Counter+1)
        and  a
        jp   nz,.Blk11
        call Aroks
        and  a
        jr   nz,.Rtn1
        ld   a,(ix+3)
        cpl
        and  7
        jp   z,.Blk11
        ld   a,#FF
        ld   (Roketn3),a
        ld   (Roketn2),a
        ld   (Roketn1),a
        ld   a,12               ; Paket het
        call Mesags
        jp   .Blk11
.Rtn1
        ; Проверка кнопок пуска ракет
        bit  2,(ix+3)           ; 3
        jr   nz,.Rkn21
        ld   a,5
        ld   (Counter+1),a
        ld   a,(Roketn3)
        inc  a
        call z,Nocels
        jr   z,.Rkn21
        ld   hl,Eff13
        ld   (Sfxa+1),hl
        dec  a
        ld   h,a
        ld   c,a
        ld   a,#FF
        ld   (Roketn3),a
        call Newrokt
        jp   nc,.Rkn21
        ld   hl,+(0-Subj)+Type
        add  hl,de
        ld   b,(hl)
        call Chstat_
        call Aroks
        call Rain
.Rkn21
        bit  1,(ix+3)           ; 2
        jr   nz,.Rkn31
        ld   a,5
        ld   (Counter+1),a
        ld   a,(Roketn2)
        inc  a
        call z,Nocels
        jr   z,.Rkn31
        ld   hl,Eff13
        ld   (Sfxa+1),hl
        dec  a
        ld   h,a
        ld   c,a
        ld   a,#FF
        ld   (Roketn2),a
        call Newrokt
        jp   nc,.Rkn31
        ld   hl,+(0-Subj)+Type
        add  hl,de
        ld   b,(hl)
        call Chstat_
        call Aroks
        call Rain
.Rkn31
        bit  0,(ix+3)           ; 1
        jr   nz,.Blk11
        ld   a,5
        ld   (Counter+1),a
        ld   a,(Roketn1)
        inc  a
        call z,Nocels
        jr   z,.Blk11
        ld   hl,Eff13
        ld   (Sfxa+1),hl
        dec  a
        ld   h,a
        ld   c,a
        ld   a,#FF
        ld   (Roketn1),a
        call Newrokt
        jp   nc,.Blk11
        ld   hl,+(0-Subj)+Type
        add  hl,de
        ld   b,(hl)
        call Chstat_
        call Aroks
        call Rain
.Blk11
        bit  4,(ix+0)           ; V
        bit  3,(ix+0)           ; C
        call z,Clrmark
        bit  0,(ix+2)           ; Q
        call z,Unroket
        bit  0,(ix+5)           ; P
        call z,Towar
        bit  1,(ix+5)           ; O
        call z,Karta
        bit  2,(ix+5)           ; I
        call z,Missio
        bit  4,(ix+1)           ; G
        call z,Hiper
        bit  2,(ix+2)           ; E
        call z,Dropcr
        bit  1,(ix+2)           ; W
        call z,Dropmin
        bit  3,(ix+2)           ; R
        call z,Returns

        bit  4,(ix+6)           ; H;включить режи
        ; M 3ахвата цели
        call z,Navod
        bit  4,(ix+7)           ; B;режим 3ахвата
        ; Объекта K себе
        call z,Zahwat
        bit  1,(ix+#01)         ; S
        call z,Upp
        bit  2,(ix+#00)         ; X
        call z,Downn
        bit  3,(ix+#07)         ; N
        call z,Leftt
        bit  2,(ix+#07)         ; M
        call z,Rightt
        bit  2,(ix+#06)         ; K
        call z,Leftf
        bit  1,(ix+#06)         ; L
        call z,Rightf
        bit  0,(ix+1)           ; A
        call z,Fline2
        bit  3,(ix+6)           ; J
        call z,Jumpdrv
        bit  2,(ix+1)           ; D
        call z,Snarad
        bit  3,(ix+1)           ; F
        bit  1,(ix+0)           ; Z
        ld   a,(Calcstp)
        cp   #3A
        jr   nz,.Nopwr
        ld   a,(Jflag+1)
        and  a
        jr   nz,.Nopwr
        bit  0,(ix+#07)         ; Sp
        call z,Gaz
        bit  1,(ix+#07)         ; Ss
        call z,Tormoz
.Nopwr
; Гашение ра3гонов поворотов и jампов
Mxspd           equ 150
        bit  3,(ix+6)           ; J
        jr   z,.Nopwr2
        ld   hl,(Maxspd+1)
        ld   bc,Mxspd
        and  a
        sbc  hl,bc
        jr   z,.Nopwr2
        ld   hl,Mxspd
        ld   (Maxspd+1),hl
        ld   hl,Mxspd
        ld   (Speed),hl
        ld   a,1
        ld   (Fspeed+1),a
.Nopwr2
        ld   a,(ix+6)           ; Kl
        rrca
        ld   l,a
        and  l
        rrca
        jr   nc,.Kl3
        ld   a,200
        ld   (Rif1+1),a
        ld   (Lef1+1),a
        ld   a,%10010010
        rrca
        ld   ($-2),a
        jr   nc,.Kl3
        ld   a,(Eye_b)
        and  a
        jr   z,.Kl3
        jp   p,.Kl
        add  a,1
        jp   m,.Kl2
        xor  a
        jp   .Kl2
.Kl
        sub  1
        jp   p,.Kl2
        xor  a
.Kl2
        ld   (Eye_b),a
.Kl3
        ld   a,(ix+1)
        rrca
        ld   c,a
        ld   a,(ix+0)
        rrca
        rrca
        and  c
        rrca
        jr   nc,.Kl6
        ld   a,200
        ld   (Upp1+1),a
        ld   (Dwn1+1),a
        ld   a,%10010010
        rrca
        ld   ($-2),a
        jr   nc,.Kl6
        ld   a,(Eye_a)
        and  a
        jr   z,.Kl6
        jp   p,.Kl4
        add  a,1
        jp   m,.Kl5
        xor  a
        jp   .Kl5
.Kl4
        sub  1
        jp   p,.Kl5
        xor  a
.Kl5
        ld   (Eye_a),a
.Kl6
        ld   a,(ix+7)
        rrca
        rrca
        ld   l,a
        rrca
        and  l
        rrca
        ret  nc
        ld   a,250
        ld   (Let1+1),a
        ld   (Rit1+1),a
        ld   a,%10010010
        rrca
        ld   ($-2),a
        ret  nc
        ld   a,(Eye_g)
        and  a
        ret  z
        jp   p,.Kl7
        add  a,1
        jp   m,.Kl8
        xor  a
        jp   .Kl8
.Kl7
        sub  1
        jp   p,.Kl8
        xor  a
.Kl8
        ld   (Eye_g),a
        ret

Unroket
        ; Противоракетная система
        ld   a,(Counter+1)
        and  a
        ret  nz
        ld   a,5
        ld   (Counter+1),a
        ld   a,20               ; Активирована проти
        ; Воракетная
        call Mesags
        ld   hl,Eff19
        ld   (Sfxa+1),hl
        ld   hl,+(Carsb-Olen)+1
        ld   de,Olen
        jp   .Stu1
.Stu3
        dec  l
        ld   a,(hl)
        cp   #80
        ret  z
        inc  l
.Stu1
        add  hl,de
        ld   a,(hl)
        cp   #80
        jr   z,.Stu3
        ld   a,l
        add  a,Type-1
        ld   l,a
        ld   c,(hl)
        dec  l
        dec  l
        dec  l
        ld   b,(hl)
        sub  Type-1
        ld   l,a
        ld   a,c
        cp   #11
        jr   nz,.Stu1
        ld   a,b
        cp   Splayer
        jr   nz,.Stu1
        push ix
        dec  l
        push hl
        pop  ix
        set  0,(ix+Actn)        ; Выстрел ла3ера
        set  3,(ix+Actn)        ; Но протракет
        ; Ной системы
        ; Рис.линии от игрока K ракете
        ld   a,(ix+(Px+1))
        cp   #80
        scf
        jr   z,.Noanti
        ld   b,a
        ld   c,(ix+Px)
        ld   l,(ix+Py)
        ld   h,(ix+(Py+1))
        ld   e,(ix+Pz)
        ld   d,(ix+(Pz+1))
        exx
        ld   bc,3
        ld   (Tx+1),bc
        ld   (Dx+1),bc
        ld   (Dy+1),bc
        ld   (Dz_+1),bc
        ld   hl,#B0
        ld   (Ty+1),hl
        ld   de,0-1
        ld   (Tz+1),de
        call Fg1
.Noanti
        pop  ix
        ret
Clrmark
        ; Отменить 3ахват целей
        ld   a,(Counter+1)
        and  a
        ret  nz
        ld   a,7
        ld   (Counter+1),a
        ld   hl,Eff13
        ld   (Sfxa+1),hl
        ld   a,#FF
        ld   (Roketn1),a
        ld   (Roketn2),a
        ld   (Roketn3),a
        ld   a,21               ; Цели сняты
        jp   Mesags
Navod
        ; Режим наведения ракеты
        ld   a,(Counter+1)
        and  a
        ret  nz
        ld   hl,Eff13
        ld   (Sfxa+1),hl
        ld   a,7
        ld   (Counter+1),a
        ld   a,(Fnavod+1)
        xor  1
        ld   (Fnavod+1),a
        ld   a,2                ; Режим вкл
        jr   nz,$+4
        ld   a,3                ; Режим выкл
        call Mesags
        ld   a,5                ; Наведения ракет
        jp   Mesags
Fline2
        ; Кнопка fire
        ; B ра3ных режимах
        jp   Fline

Jumpdrv
        ; Форсировка двигателя
        ld   a,(Calcstp)
        cp   #C9
        ret  z
        ld   a,1
        ld   (Jflag+1),a
        ; Проверяем бли3ость других объектов
        ; Если хоть один бли3ко то отмена
        ld   hl,+(Carsb-Olen)+1
        ld   de,Olen
        jr   $+9
        dec  l
        ld   a,(hl)
        inc  l
        cp   #80
        jr   z,Fuel_
.Jjd1
        add  hl,de
        ld   a,(hl)
        cp   #80
        jr   z,$-11
        and  a
        jp   p,$+4
        cpl
        ld   c,a
        ld   a,l
        add  a,Type-1
        ld   l,a
        ld   b,(hl)
        sub  Type-1
        ld   l,a
        ld   a,b
        cp   #12
        jr   z,.Nxtj
        cp   #10
        jr   nc,.Jjd1
.Nxtj
        inc  l
        inc  l
        ld   a,(hl)
        and  a
        jp   p,$+4
        cpl
        or   c
        ld   c,a
        inc  l
        inc  l
        ld   a,(hl)
        and  a
        jp   p,$+4
        cpl
        or   c
        ld   c,a
        ld   a,l
        sub  4
        ld   l,a
        ld   a,c
        cp   Jmin               ; Мин.растояние для джампа
        jp   nc,.Jjd1
        set  3,(ix+6)           ; J
        ret
Afuel
        ld   hl,Fuel
        ld   a,(hl)
        and  a
        ret  nz
        inc  hl
        ld   a,(hl)
        ret
Fuel_
        call Afuel
        ld   c,a
        dec  c
        set  3,(ix+6)           ; J
        ret  m
        res  3,(ix+6)
        ld   a,0
        inc  a
        ld   ($-2),a
        jr   nz,.Jkl2
        ld   a,0
        inc  a
        and  7
        ld   ($-4),a
        jr   nz,.Jkl2
        ld   (hl),c
        ld   a,(Tonn)
        dec  a
        ld   (Tonn),a
        ld   a,1
        ld   (Ffuel+1),a
.Jkl2
        ld   hl,(Maxspd+1)
        ld   bc,64
        add  hl,bc
        ld   a,h
        and  %00011000
        cp   %00011000
        ret  z
        ld   (Maxspd+1),hl
        set  0,(ix+7)
        call Gaz
        jp   Gaz

Leftf
Lef1    ld   a,0
        add  a,70
        ld   (Lef1+1),a
        ld   a,200
        ld   (Rif1+1),a
        ret  nc
        ld   a,(Eye_b)          ; UNGLE of turn
        sub  1
        jp   m,$+5
        ld   a,#FF
        cp   #0100-Mane2
        ret  c
        ld   (Eye_b),a
        ret
Rightf
Rif1    ld   a,0
        add  a,70
        ld   (Rif1+1),a
        ld   a,200
        ld   (Lef1+1),a
        ret  nc
        ld   a,(Eye_b)
        add  a,1
        jp   p,$+5
        ld   a,1
        cp   Mane2+1
        ret  nc
        ld   (Eye_b),a
        ret

; Your turns
Calcstp
        ld   a,(Sm_13+1)
Bfc1    dw   0
        ld   de,(Speed)
        ld   ix,$+7
        jp   Lc52c
        ld   (Stpx+1),hl
        ld   a,(Sm_23+1)
Bfc2    dw   0
        ld   de,(Speed)
        ld   ix,$+7
        jp   Lc52c
        ld   (Stpy+1),hl
        ld   a,(Sm_33+1)
Bfc3    dw   0
        ld   de,(Speed)
        ld   ix,$+7
        jp   Lc52c
        ld   (Stpz+1),hl
        ret

; BEGIN control procs
Readkey
        call Lc5a5              ; In ren3d

        ld   hl,Lc5b6
        xor  a
        ld   b,8
.Exk2
        ld   d,#FF
        ld   e,(hl)
        rr   e
        ccf
        adc  a,0
        cp   4
        jr   nc,.Exk
        rl   d
        rr   e
        ccf
        adc  a,0
        cp   4
        jr   nc,.Exk
        rl   d
        rr   e
        ccf
        adc  a,0
        cp   4
        jr   nc,.Exk
        rl   d
        rr   e
        ccf
        adc  a,0
        cp   4
        jr   nc,.Exk
        rl   d
        rr   e
        ccf
        adc  a,0
        cp   4
        jr   nc,.Exk
        rl   d
        inc  hl
        djnz .Exk2
        ret
.Exk
        ld   a,(hl)
        or   d
        ld   (hl),a
.Exk4
        djnz .Exk3
        ret
.Exk3
        inc  hl
        ld   (hl),#FF
        jp   .Exk4
