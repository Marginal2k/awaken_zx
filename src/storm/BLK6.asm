;==============================================================================
; BLK6 - SetCoordsByMove: изменение координат по движению, старая версия
;
; Фрагмент.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

; И3меняем координаты,3ави. движения
SetCoordsByMove                 ; orig: Precord
        ld   (Stk1+1),sp
        ld   l,(ix+Indi)
        ld   h,L97
        ld   sp,hl
        pop  hl
        inc  hl
        ld   b,(hl)
        res  7,b
        ld   a,#06
        sub  b
        ld   hl,200
        ld   ($+4),a
        jr   $
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,hl
        ld   a,Spacebd
        sub  h
        ld   b,a
        ld   a,ixl
        ld   l,a
        ld   a,ixh
        ld   h,a
        ld   sp,hl
Stpx_   ld   hl,0
Stpx    ld   de,0
        and  a
        sbc  hl,de
        pop  de
        ld   a,d
        cp   #80
        jr   z,Stk1
        and  a
        adc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jp   nc,Exes
        push hl
Stpy_   ld   hl,0
Stpy    ld   de,0
        and  a
        sbc  hl,de
        inc  sp
        inc  sp
        pop  de
        and  a
        adc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes
        push hl
Stpz_   ld   hl,0
Stpz    ld   de,0
        and  a
        sbc  hl,de
        inc  sp
        inc  sp
        pop  de
        and  a
        adc  hl,de
        jp   pe,Exes
        ld   a,h
        jp   p,$+4
        cpl
        cp   b
        jr   nc,Exes
        push hl
Stk1    ld   sp,0
        ld   a,(Nostat+1)
        and  a
        ret  z
        ld   d,#12
        call Findobj
        ret  z
        ; Находим самую большую координату станц
        ; Ии
        ld   a,(iy+5)
        and  a
        jp   p,$+4
        cpl
        ld   b,a
        ld   a,(iy+3)
        and  a
        jp   p,$+4
        cpl
        ld   c,a
        ld   a,(iy+1)
        and  a
        jp   p,$+4
        cpl
        cp   c
        jr   nc,$+3
        ld   a,c
        cp   b
        jr   nc,$+3
        ld   a,b
        cp   Laungh
        jr   c,Messt            ; Далеко еще
        ld   a,#80
        ld   (Messt+1),a
        ret
Messt   ld   a,0
        and  a
        ret  p
        ld   a,24               ; Режим стыковки со
        ; Станцией
        ld   (Messt+1),a
        jp   Mesags
Exes
        ; Если корабль 3a границей
        ld   (ix+0),0
        ld   (ix+1),#80
        ld   sp,(Stk1+1)
        ld   a,(ix+Type)
        cp   #12
        ret  nz
        ; Если станция 3a границей
        xor  a
        ld   (Statgen+1),a
        ld   (Nostat+1),a
        ld   (Nostat2+1),a
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
.Exe2
        call Findob
        ret  z
        ld   a,(iy+Type)
        cp   #12
        jr   nz,.Exe2
        ld   (iy+1),#80
        ld   (iy),0
        jp   .Exe2

; ----------------------
; Поисковики чего то
; ----------------------

Findob
        ; Найти какой нибудь объект
        ; Iy-vector-olen
        ; Bc-olen
        ; Fz-on not found
        add  iy,bc
        ld   a,(iy+1)
        cp   #80
        ret  nz
        ld   a,(iy+0)
        cp   #80
        jp   nz,Findob
        ret
Fndpece
        ; Найти мирного
        call Rndl3
        ld   a,l
Pwnpi   cp   #A0
        ld   a,PLAYER_INDEX
        inc  a
        dec  a
        ret  nc
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
.Fp2l
        call Findob
        ret  z
        ld   e,(iy+Type)
        ld   a,e
        and  a
        jr   z,.Fp2l
        cp   #12
        jr   z,$+6
        cp   #10
        jr   nc,.Fp2l
        call Getindy
        inc  e                  ; Сброс fz
        ret
Findall
        ; Найти all without  ufos
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
.Fp6l
        call Findob
        ret  z
        ld   e,(iy+Type)
        ld   a,e
        cp   6
        jr   z,.Fp6l
        cp   7
        jr   z,.Fp6l
        call Getindy
        inc  e                  ; Сброс fz
        ret
Findufo
        ; Найти ufo
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
.Fp3l
        call Findob
        ret  z
        ld   e,(iy+Type)
        ld   a,e
        cp   6
        jr   z,$+6
        cp   7
        jr   nz,.Fp3l
        call Getindy
        inc  e
        ret
Fndprat
        ; Найти пирата
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
.Fp2
        call Findob
        ret  z
        ld   e,(iy+Type)
        ld   a,e
        cp   5
        jr   z,$+5
        and  a
        jr   nz,.Fp2
        call Getindy
        inc  e
        ret
; ---------------------------------

        ; testsubj
        ; ;Тестирование персонажа на предмет его
        ; Уже исче3новения
        ; Или если это игрок
        ld   a,(ix+Subj)
        inc  a
        jr   nz,.Ts1
        ld   hl,+(OBJ_LEN*PLAYER_INDEX)+Carsb
        jr   .Ts2
.Ts1
        dec  a
        call Getadr
.Ts2
        ld   (Opone+2),hl
        inc  l
        ld   a,(hl)
        cp   #80
        ret  z
        ld   l,(ix+0)
        ld   h,(ix+1)
        ld   (Ddx+1),hl
        ld   l,(ix+2)
        ld   h,(ix+3)
        ld   (Ddy+1),hl
        ld   l,(ix+4)
        ld   h,(ix+5)
        ld   (Ddz+1),hl
        ret
Opone   ld   iy,0
        ld   a,(ix+Subj)
        cp   PLAYER_INDEX
        jr   nz,.Fg2
        ld   bc,0
        ld   (Tx+1),bc
        ld   (Dx+1),bc
        ld   (Dy+1),bc
        ld   (Dz_+1),bc
        ld   hl,#FFB0
        ld   (Ty+1),hl
        ld   de,0-1
        ld   (Tz+1),de
        ld   iy,Player
        and  a
        ret
.Fg2
        ld   a,(iy+(Px+1))
        cp   #80
        scf
        ret  z
        and  a
        ld   l,(iy+0)
        ld   h,(iy+1)
        ld   (Dx+1),hl
        ld   l,(iy+2)
        ld   h,(iy+3)
        ld   (Dy+1),hl
        ld   l,(iy+4)
        ld   h,(iy+5)
        ld   (Dz_+1),hl
        ld   c,(iy+Px)
        ld   b,a
        ld   (Tx+1),bc
        ld   l,(iy+Py)
        ld   h,(iy+(Py+1))
        ld   (Ty+1),hl
        ld   e,(iy+Pz)
        ld   d,(iy+(Pz+1))
        ld   (Tz+1),de
        ret
Fireing
        ; Органи3ация выстрела персонажа b кого
        ; Либо
        ; Вывод луча, инициали3. данных subj & a
        ; Ctn
        ld   a,(ix+(Px+1))
        cp   #80
        scf
        ret  z
        ld   b,a
        ld   c,(ix+Px)
        ld   l,(ix+Py)
        ld   h,(ix+(Py+1))
        ld   e,(ix+Pz)
        ld   d,(ix+(Pz+1))
        exx
        call Opone
        ret  c
        ld   a,r
Pwppi   cp   #4A
        jr   c,Fg1
        set  0,(iy+Actn)        ; Fire
        push hl
        push ix
        pop  hl
        call Getind
        pop  hl
        ld   (iy+Subj),a
Fg1
        ld   a,d
        exx
        and  d
        ret  m
        push hl
        ld   hl,(Tx+1)
        and  a
        sbc  hl,bc
        pop  hl
        scf
        ret  pe
        push hl
        ld   hl,(Tz+1)
        and  a
        sbc  hl,de
        pop  hl
        scf
        ret  pe
        push hl
        push de
        ld   de,(Ty+1)
        and  a
        sbc  hl,de
        pop  de
        pop  hl
        scf
        ret  pe
        push ix
        call DrawLine3d
        pop  ix
        and  a
        ret

Checkal
        ; Проверки на вероятность подбирания гру
        ; 3A, форсажа, облета
        ; Fc-on let go gosimply
        call Rndk3
        ld   a,l
        cp   Vfrs               ; Вероятность форсажа
        jr   c,.Fs3
        ld   a,(ix+Mode)
        ld   (ix+Omode),a
        ld   (ix+Mode),19       ; Forsage
.Fs3
        ld   a,(ix+(Px+1))
        and  a
        jp   p,$+4
        cpl
        ; Миним. раст. по X,Y b пути пролета, дл
        ; Я облета
        cp   Dlrazi
        ret  nc
        ld   a,(ix+(Py+1))
        and  a
        jp   p,$+4
        cpl
        cp   Dlrazi
        ret  nc
        ld   a,(ix+(Pz+1))
        and  a
        jp   p,$+4
        cpl
        cp   Dlraz              ; Дальность от игро
        ; Ка для облета
        ret  nc
        ld   a,(ix+Mode)
        ld   (ix+Omode),a
        ld   (ix+Mode),20       ; Облет
        ld   (ix+Powor),Timeobl
        ret

Rnd
        exx
        ld   hl,Sdo
        jp   Rndo
Rndw
        exx
        ld   hl,Sdw
        jp   Rndo
Rndk1
        exx
        ld   hl,Sdk1
        jp   Rndo
Rndk2
        exx
        ld   hl,Sdk2
        jp   Rndo
Rndk3
        exx
        ld   hl,Sdk3
        jp   Rndo
Rndt2
        exx
        ld   hl,Sdt2
        jp   Rndo
Rndt1
        exx
        ld   hl,Sdt1
        jp   Rndo
Rndl1
        exx
        ld   hl,Sdl1
        jp   Rndo
Rndl2
        exx
        ld   hl,Sdl2
        jp   Rndo
Rndl3
        exx
        ld   hl,Sdl3
        jp   Rndo
Rndl4
        exx
        ld   hl,Sdl4
        jp   Rndo
Rndl5
        exx
        ld   hl,Sdl5
        jp   Rndo
Rndl7
        exx
        ld   hl,Sdl7
        jp   Rndo
Rndl8
        exx
        ld   hl,Sdl8
        jp   Rndo
Rndl9
        exx
        ld   hl,Sdl9
        jp   Rndo
Sdw
        ; Генератор какого ландшафта
        db   7, 8, 0
Sdo
        db   101, 0, 0
Sdl1
        db   9, 0, 0
Sdl2
        db   231, 0, 0
Sdl3
        db   71, 1, 0
Sdl4
        db   10, 0, 0
Sdl5
        db   77, 1, 0
Sdl7
        db   200, 0, 0
Sdl8
        db   13, 0, 0
Sdl9
        db   13, 3, 1
Sdt2
        db   44, 0, 0
Sdt1
        db   21, 0, 0
Sdk1
        db   247, 0, 0
Sdk2
        db   93, 0, 0
Sdk3
        db   29, 0, 0
Rndo
        ; In hl adr of seed
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
        ld   h,a                ; 0
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
        push de
        exx
        pop  hl
        ret
