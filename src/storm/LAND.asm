;==============================================================================
; LAND - посадка на планету: поверхность, небо, скиммеры, дома, деревья
;
; Главная программа прототипа. Загружается по #7C00 (RAM-страница PAGE_NORMAL), вход: START.
;
; Что делает: очищает экран, LOADER подгружает в страницы #13 (VSPRIT.C, воксельный
; рендер) и #11 (S3D.C, 3D-движок); BuildDropCode строит развёрнутый код быстрого
; вывода скрытого экрана (DropScreen, исполняется по DROP_CODE_ADDR через DISP);
; LandingInit создаёт 40 записей объектов (OBJ_COUNT x OBJ_LEN), GenerateSkimmers/
; GenerateTrees расставляют скиммеры и деревья. Главный цикл MainLoop: VOX_OUT_ALL
; (страница #13: фон, земля, небо, ночь) + ENG3D_OUT_ALL (страница #11: 3D-объекты) +
; UpdateAI (поведение) + прицел, AY-эффекты, панель и таймер. Выход - по клавише
; (полуряд #7F), перед выходом PAGE4/PAGE3 перегружаются через TR-DOS в страницы #14/#13.
;
; Карта памяти: #6000 шрифт+DATAM (END0), #6700 VARS (записи объектов и указатели),
; #7C00..END_ код, после END_ - выровненные по странице текстуры планеты
; (planet, CHAN6, DRV1, DRV2, DOMA1), #8000 HIDDEN_SCREEN (скрытый экран).
; Использует: EQUS (константы), LOADER, DATAM, assets/*.bin; вызывает страницы по таблицам VOX_* и ENG3D_*.
; Сборка: make_LAND.asm -> LAND.bin, LAND_data.bin. Готовой копии на дисках нет.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

        include "EQUS.asm"

; Поверхность планеты и небо

        org  #7C00
START
        ld   hl,SCREEN
        ld   de,SCREEN+1
        ld   bc,SCREEN_PIX_LEN
        ld   (hl),l
        ldir
        ld   bc,SCREEN_ATTR_LEN-1
        ld   (hl),%00000111
        ldir

        include "LOADER.asm"

        di

BuildDropCode                   ; orig: MAKEDRP
        ld   a,PAGE_VOXEL
        call SetPage
        ld   hl,DropModule
        ld   de,DROP_CODE_ADDR
        ld   bc,DropLineEnd-DropScreen
        ldir
        ex   de,hl
        ld   bc,191*DROP_LINE_LEN
        add  hl,bc
        ex   de,hl
        ld   bc,4
        ldir

        ld   bc,#0010
        exx
        ld   de,DropLineEnd
        ld   a,96
        ld   hl,DropLine
        ld   bc,DROP_LINE_LEN
        ex   af,af'
BuildDropLoop                   ; orig: MDS1
        exx
        ld   hl,(DropLine+1)
        add  hl,bc
        ld   (DropLine+1),hl
        ld   hl,(DropLineDst+1)
        add  hl,bc
        ld   (DropLineDst+1),hl
        exx
        push hl
        push bc
        ldir
        pop  bc
        pop  hl
        ex   af,af'
        dec  a
        jr   z,.MDS2
        ex   af,af'
        exx
        ld   hl,(DropLine+1)
        add  hl,bc
        ld   (DropLine+1),hl
        ld   hl,(DropLineDst+1)
        or   a
        sbc  hl,bc
        inc  h
        ld   a,h
        and  7
        jr   nz,$+12
        ld   a,l
        add  a,32
        ld   l,a
        jr   c,$+6
        ld   a,h
        sub  8
        ld   h,a
        ld   (DropLineDst+1),hl
        exx
        push hl
        push bc
        ldir
        pop  bc
        pop  hl
        jr   BuildDropLoop
.MDS2
        ld   hl,#8000
        ld   (DropLine+1),hl
        ld   hl,#4010
        ld   (DropLineDst+1),hl
        ld   a,PAGE_NORMAL
        call SetPage

        ld   hl,0
        ld   (Adtt+1),hl
        ld   hl,TextBuf
        ld   (Atbuf+1),hl
        ld   (Frba+1),hl
        inc  hl
        ld   de,TextBuf+2
        ld   bc,#20
        ld   (hl),1
        ldir
        ld   (hl),0
        ld   hl,KeyState
        ld   de,KeyState+1
        ld   bc,7
        ld   (hl),0
        ldir
        jp   LandingInit

DropModule                      ; orig: MODUL
        org  $
        disp DROP_CODE_ADDR
DropScreen                      ; orig: DROPSCR
        ld   ((DropSavedSp+1)+(191*DROP_LINE_LEN)),sp
DropLine                        ; orig: DS0
        ld   sp,#8000
        pop  hl
        pop  de
        pop  bc
        pop  af
        exx
        ex   af,af'
        pop  hl
        pop  de
        pop  bc
        pop  af
DropLineDst                     ; orig: DS01
        ld   sp,#4010
        push af
        push bc
        push de
        push hl
        exx
        ex   af,af'
        push af
        push bc
        push de
        push hl
DropLineEnd                     ; orig: DS1
DROP_LINE_LEN   equ DropLineEnd-DropLine  ; orig: DLEN

DropSavedSp                     ; orig: STK92
        ld   sp,0
        ret

        ent
        org  HIDDEN_SCREEN
; Defw
InitVarsImage                   ; orig: DEFW_
        ds   OBJ_LEN*(OBJ_COUNT-1)
        ds   OBJ_LEN
        dw   PLANET_
        dw   SKYS_
        db   #C3
        dw   MsgTable
        db   #C3
        dw   SetEffectA
        db   #C3
        dw   SetEffectB
        db   #C3
        dw   PrintOrdered
        dw   #2B7B
        db   #C3
        dw   DrawVoxelObject
INIT_VARS_LEN   equ $-HIDDEN_SCREEN     ; orig: DDLEN

        org  #8C00

LandingInit                     ; orig: DALEE
        ld   a,PAGE_3D
        call SetPage
        call ENG3D_INIT
        ld   a,PAGE_NORMAL
        call SetPage

        ld   hl,InitVarsImage
        ld   de,VARS
        ld   bc,INIT_VARS_LEN
        ldir

        ld   de,60*256          ; Z
        ld   (CamZ+1),de
        ld   a,4                ; X
        ld   (CamX+1),a
        ld   l,a
        ld   a,100              ; Y
        ld   (CamY+1),a
        ld   h,a
        call NewPosPaged
        ld   de,40*256          ; Z
        ld   l,4                ; X
        ld   h,80               ; Y
        call NewPos2Paged

E1

        ld   b,OBJ_COUNT-2
        ld   de,OBJ_LEN-1
        ld   hl,Carsb
.D1
        ld   (hl),0
        inc  l
        ld   (hl),#80
        add  hl,de
        djnz .D1
        ld   (hl),#80
        inc  l
        ld   (hl),#80

        call GenerateTrees

        ld   a,#FF
        ld   (PLAYER+Type),a
        ld   (PLAYER+Mode),a

        xor  a
        ld   (SPEED),a

MainLoop                        ; orig: M2

        ; Генерить скимеры
        call GenerateSkimmers

        ld   a,PAGE_VOXEL
        call SetPage
        call VOX_OUT_ALL

        ld   a,PAGE_3D
        call SetPage
        call ENG3D_OUT_ALL

        ld   a,PAGE_NORMAL
        call SetPage

        ; Интелект
        call UpdateAI

        call DrawSight
        call SfxChannelA
        call UpdateTimer

        call RedrawPanel

        ld   a,#7F
        in   a,(PORT_ULA)
        rrca
        push af
        call nc,CamUp
        pop  af
        rrca
        push af
        call nc,CamDown
        pop  af
        rrca
        push af
        call nc,CamRight
        pop  af
        rrca
        push af
        call nc,CamLeft
        pop  af
        rrca
        jp   nc,.EXIT

        call ServiceInput

        ld   a,PAGE_VOXEL
        call SetPage
        call DROP_CODE_ADDR
        ld   a,PAGE_NORMAL
        call SetPage

        jp   MainLoop

.EXIT
        im   1
        ld   a,#3F
        ld   i,a
        ld   iy,SYSVAR_IY

        ld   a,#14
        call SetPage
        ld   hl,FileNamePage4
        ld   de,23773
        ld   bc,9
        ldir
        xor  a
        ld   hl,#C000
        ld   c,#0E
        di
        call TRDOS_COMMAND
        ld   a,#13
        call SetPage
        ld   hl,FileNamePage3
        ld   de,23773
        ld   bc,9
        ldir
        xor  a
        ld   hl,#C000
        ld   c,#0E
        di
        call TRDOS_COMMAND

        ld   a,PAGE_NORMAL
        call SetPage
        ei
        ret

FileNamePage4                   ; orig: FILN4
        db   "PAGE4   C"
FileNamePage3                   ; orig: FILN3
        db   "PAGE3   C"

DrawVoxelObject                 ; orig: VOXOBJ_
        ; A-index
        ; Hl-X,de-Y,bc-z
        exx
        push ix
        push hl
        push de
        push bc
        ; Индекс
        and  #7C
        ld   l,a
        srl  l
        ld   h,0
        ld   de,VoxelObjTable
        add  hl,de
        ld   e,(hl)
        inc  l
        ld   d,(hl)

        ; Реальные размеры спрайта
        ld   hl,(EYEA)
        exx
        push hl
        or   #80
        ld   l,a
        ld   h,high(L97)
        ld   a,(hl)
        inc  l
        ld   h,(hl)
        ld   l,a
        inc  hl
        ; Multiply
        ld   a,(hl)
        pop  hl
        ex   af,af'
        ld   a,PAGE_VOXEL
        call SetPage
        ex   af,af'
        call VOX_DRAW_3D2
        ld   a,PAGE_3D
        call SetPage

        exx
        pop  bc
        pop  de
        pop  hl
        pop  ix
        exx
        jp   ENG3D_NEXT_OBJECT

CamLeft                         ; orig: LEFT
        ld   de,(CamZ+1)
        ld   a,(CamX+1)
        inc  a
        ld   l,a
        ld   (CamX+1),a
        ld   a,(CamY+1)
        ld   h,a
        jp   NewPosPaged

CamRight                        ; orig: RIGHT
        ld   de,(CamZ+1)
        ld   a,(CamX+1)
        dec  a
        ld   l,a
        ld   (CamX+1),a
        ld   a,(CamY+1)
        ld   h,a
        jp   NewPosPaged

NewPosPaged                     ; orig: NEWPOS_
        ld   a,PAGE_VOXEL
        call SetPage
        call VOX_NEW_POS
        ld   a,PAGE_NORMAL
        jp   SetPage
NewPos2Paged                    ; orig: NEWPSS_
        ld   a,PAGE_VOXEL
        call SetPage
        call VOX_NEW_POS2
        ld   a,PAGE_NORMAL
        jp   SetPage

CamUp                           ; orig: UP
CamZ                            ; orig: ZET
        ld   de,0
        ld   a,e
        add  a,#40
        ld   e,a
        ld   a,d
        adc  a,0
        cp   68
        ret  nc
        ld   d,a
        ld   (CamZ+1),de

;        Ld hl,(YPL)
;        Ld a,l:sub 6:ld l,a
;        Ld a,h:sbc a,0:ld h,a
;        Ld (YPL),hl

CamX                            ; orig: IKS
        ld   l,24
CamY                            ; orig: IGR
        ld   a,38
        add  a,4
        ld   h,a
        ld   (CamY+1),a
        jp   NewPosPaged

CamDown                         ; orig: DOWN
        ld   de,(CamZ+1)
        ld   a,e
        sub  #40
        ld   e,a
        ld   a,d
        sbc  a,0
        cp   57
        ret  c
        ld   d,a
        ld   (CamZ+1),de

;        Ld hl,(YPL)
;        Ld a,l:add a,6:ld l,a
;        Ld a,h:adc a,0:ld h,a
;       Ld (YPL),hl

        ld   a,(CamX+1)
        ld   l,a
        ld   a,(CamY+1)
        sub  4
        ld   h,a
        ld   (CamY+1),a
        jp   NewPosPaged

ROLLT
        ; Перемещение фона влево всего что есть
        ld   a,PAGE_VOXEL
        call SetPage
        call VOX_TURN_LEFT
        ld   a,PAGE_NORMAL
        jp   SetPage
ROLRT
        ; Перемещение фона вправо
        ld   a,PAGE_VOXEL
        call SetPage
        call VOX_TURN_RIGHT
        ld   a,PAGE_NORMAL
        jp   SetPage

ROLUP
        ld   a,%10001000
        rrca
        ld   ($-2),a
        ret  nc
        ld   a,(SPEED)
        inc  a
        jp   m,$+6
        cp   MSPEED2
        ret  nc
        ld   (SPEED),a
        call TakeSpeedPaged
        ret
ROLDN
        ld   a,(ROLUP+1)
        rlca
        ld   (ROLUP+1),a
        ret  nc
        ld   a,(SPEED)
        dec  a
        jp   p,$+6
        cp   MSPEED
        ret  c
        ld   (SPEED),a
        call TakeSpeedPaged
        ret

TakeSpeedPaged                  ; orig: TAKSPD
        ex   af,af'
        ld   a,PAGE_VOXEL
        call SetPage
        ex   af,af'
        call VOX_TAKE_SPEED
        ld   a,PAGE_NORMAL
        jp   SetPage

SetPage                         ; orig: PG
        push bc
        ld   bc,PORT_PAGE
        out  (c),a
        pop  bc
        ret

; Взять слово из адреса в hl
; В странице 3d
ReadWord3D                      ; orig: TAKEW
        ; Hl-адрес слова
        ; Ret de-слово
        ld   a,PAGE_3D
        call SetPage
        ld   e,(hl)
        inc  hl
        ld   d,(hl)
        ld   a,PAGE_NORMAL
        call SetPage
        ret

SetEffectA                      ; orig: NEWEFA_
; Задать эфект в канале а

        ret
SetEffectB                      ; orig: NEWEFB_
; Задать эфект в канале б

        ret
VoxelObjTable                   ; orig: VOXAD
        dw   DRV1
        dw   DRV2
        dw   DOMA1

MsgTable                        ; orig: Messags
        db   "AAAA", 0

PrintOrdered                    ; orig: Mnums_
        ; Numbers in ORDER print
        ; A-number
        ld   e,a
        ld   d,2
        jr   Frba
FindMessage                     ; orig: Mesag
        ; A-number of mesag
        ld   hl,MsgTable
        and  a
        jr   z,$+13
        ld   e,a
        ld   bc,#FFFF
        xor  a
        cpir
        dec  e
        jr   nz,$-3
        ex   de,hl
Frba    ld   hl,TextBuf
        ld   b,#10
.Mg3
        inc  hl
        ld   a,(hl)
        dec  a
        jr   z,.Mg2
        inc  a
        jr   z,.Mg11
        inc  hl
        djnz .Mg3
        ret
.Mg11
        ld   hl,TextBuf
        djnz .Mg3
        ret
.Mg2
        ld   (hl),d
        dec  hl
        ld   (hl),e
        inc  hl
        inc  hl
        ld   (Frba+1),hl
        ret
TextBuf                         ; orig: Tbuf
        ds   #20, #01
        dw   #0000

PrintText                       ; orig: Print
; Hl-txt,"@"-end
Adtt    ld   hl,0
        ld   a,h
        or   l
        jr   nz,Pnt3
Atbuf   ld   hl,0
        ld   e,(hl)
        inc  hl
        ld   a,(hl)
        cp   2
        jr   nz,.Prt1
        ld   (hl),1
        ld   a,e
        push hl
        push bc
        call PrintNumber
        pop  bc
        pop  hl
        ld   a,(CursorX+1)
        inc  a
        ld   (CursorX+1),a
        ld   a,1
.Prt1
        and  a
        jr   nz,.Prt3
        ld   hl,TextBuf
        ld   (Atbuf+1),hl
        ret
.Prt3
        inc  hl
        ld   (Atbuf+1),hl
        dec  a
        jr   nz,.Prt2
        ret
.Prt2
        inc  a
        ld   d,a
        dec  hl
        ld   (hl),1
        ex   de,hl
Pnt3
        ld   a,(hl)
        inc  hl
        ld   (Adtt+1),hl
        or   a
        jr   z,.Pnte
        cp   1
        jr   z,.Pnt1
        jp   PrintChar
.Pnte
        ld   hl,0
        ld   (Adtt+1),hl
        ret
.Pnt1
        inc  hl
        ld   (Adtt+1),hl
        xor  a
        ld   (CursorX+1),a
        jp   ScrollText
PrintNumber                     ; orig: Prntnum
        ; A-number
        cp   100
        jr   c,.Pnum1
        ld   c,0
        ld   b,100
        sub  b
        inc  c
        sub  b
        jr   nc,$-2
        add  a,b
        ld   b,a
        ld   a,c
        add  a,"0"
        push bc
        call PrintChar
        pop  af
.Pnum1
        ld   b,a
        cp   10
        ld   c,0
        jr   c,.Pnum2
        ld   b,10
        sub  b
        inc  c
        sub  b
        jp   nc,$-2
        add  a,b
        ld   b,a
.Pnum2
        ld   a,c
        add  a,"0"
        push bc
        call PrintChar
        pop  af
        add  a,"0"
        jp   PrintChar

ScrollText                      ; orig: Scroll
        ld   (ScrollSavedSp+1),sp
        ld   hl,0
        ld   sp,#5800
        dup  32
        push hl
        edup
        ld   sp,#5700
        dup  32
        push hl
        edup
        ld   sp,#5600
        dup  32
        push hl
        edup
        ld   sp,#5500
        dup  32
        push hl
        edup
        ld   sp,#5400
        dup  32
        push hl
        edup
        ld   sp,#5300
        dup  32
        push hl
        edup
        ld   sp,#5200
        dup  32
        push hl
        edup
        ld   sp,#5100
        dup  32
        push hl
        edup
ScrollSavedSp                   ; orig: Stk5
        ld   sp,0
        ret

PrintChar                       ; orig: Rst10
        ; A-code
        ld   bc,Font
        ld   l,a
        srl  l
        ld   h,0
        add  hl,hl
        add  hl,hl
        add  hl,hl
        add  hl,bc
        inc  hl
        ex   de,hl
        ex   af,af
CursorX                         ; orig: Cord
        ld   c,0
        ld   a,c
        cp   #18
        jr   c,.Rst1
        push de
        call ScrollText
        pop  de
        ld   c,0                ; BEGIN X of win for pr
.Rst1
        ld   b,c
        ld   h,#50
        ld   a,#F4
        srl  b
        add  a,b
        ld   l,a
        inc  c
        ld   a,c
        ld   (CursorX+1),a
Rst2
        bit  0,c
        ld   b,#F0
        jr   nz,$+4
        ld   b,#0F
        ex   af,af
        rra
        jr   nc,$+6
        ld   a,c
        xor  1
        ld   c,a
        bit  0,c
        ld   c,b
        jr   nz,.Rpr
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        dup  4
        rrca
        edup
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        dup  4
        rrca
        edup
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        dup  4
        rrca
        edup
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        dup  4
        rrca
        edup
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        dup  4
        rrca
        edup
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        dup  4
        rrca
        edup
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        rrca
        rrca
        rrca
        rrca
        and  c
        or   b
        ld   (hl),a
        ret
.Rpr
        ; Печать бе3 сдвига
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        inc  h
        inc  de
        ld   a,c
        cpl
        and  (hl)
        ld   b,a
        ld   a,(de)
        and  c
        or   b
        ld   (hl),a
        ret

DrawSight                       ; orig: Pricel
        ; Рисование прицела b данных координатах
        ; Вывод на теневой скрин
        ld   bc,(Pcord)         ; #2B77
        ld   h,b
        ld   a,c
        srl  h
        rra
        srl  h
        rra
        scf
        rr   h
        rra
        ld   l,a
        ex   de,hl
        ld   a,c
        and  7
        rla
        rla
        ld   l,a
        ld   h,0
        ld   bc,MoveSight
        add  hl,bc
        ex   de,hl
        ld   bc,#0020
        inc  l
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        add  hl,bc
        dec  l
        inc  de
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        inc  l
        inc  de
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        inc  l
        inc  de
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        dec  de
        dec  de
        dec  de
        dec  l
        add  hl,bc
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        add  hl,bc
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        ret

MoveSight                       ; orig: Mpricel
        ; Спрайт прицела
        db   %10000000
        db   %00011110, %00111100, %00000000
        db   %01000000
        db   %00001111, %00011110, %00000000
        db   %00100000
        db   %00000111, %10001111, %00000000
        db   %00010000
        db   %00000011, %11000111, %10000000
        db   %00001000
        db   %00000001, %11100011, %11000000
        db   %00000100
        db   %00000000, %11110001, %11100000
        db   %00000010
        db   %00000000, %01111000, %11110000
        db   %00000001
        db   %00000000, %00111100, %01111000

UpdateTimer                     ; orig: Timer
        ; Выводила времени на приб.панель,  так
        ; Же и3м. его
        ld   a,%10000000
        rrca
        ld   ($-2),a
        ret  nc                 ; Надо ждать до секунды

        ; Считаем время
        ld   bc,0
        ld   hl,(TIME+2)        ; #3418
        ld   a,l
        add  a,1
        daa
        ld   l,a
        ld   a,h
        jr   nc,$+4
        set  0,b
        adc  a,c
        daa
        ld   h,a
        ld   de,(TIME)          ; #0122
        ld   a,e
        jr   nc,$+4
        set  1,b
        adc  a,c
        daa
        ld   e,a
        ld   a,d
        jr   nc,$+4
        set  2,b
        adc  a,c
        daa
        ld   d,a
Zerotim
        ld   (TIME+2),hl
        ld   (TIME),de
; Вывод времени
Zerot1
        ld   a,l
        ld   c,#2F
        call Prnum
        ld   a,l
        rrca
        rrca
        rrca
        rrca
        ld   c,#2E
        call Prnum
        bit  0,b
        ret  z
        ld   a,h
        ld   c,#2C
        call Prnum
        ld   a,h
        rrca
        rrca
        rrca
        rrca
        ld   c,#2B
        call Prnum
        bit  1,b
        ret  z
        ld   a,e
        ld   c,#29
        call Prnum
        ld   a,e
        rrca
        rrca
        rrca
        rrca
        ld   c,#28
        call Prnum
        bit  2,b
        ret  z
        ld   a,d
        ld   c,#27
        call Prnum
        ld   a,d
        rrca
        rrca
        rrca
        rrca
        ld   c,#26
Prnum
        ; Печать числа b бцд и3 рег.a
        ; B коорд. b c-корд. X
        exx
        and  #0F
        add  a,"0"
        ld   l,a
        srl  l
        ld   h,0
        add  hl,hl
        add  hl,hl
        add  hl,hl
        ld   de,Font
        add  hl,de
        inc  hl
        ex   de,hl
        ex   af,af
        ld   b,#10              ; Y коорд.
        ld   a,b
        and  #18
        or   #40
        inc  a
        ld   h,a
        ld   a,b
        and  7
        or   a
        rra
        rra
        rra
        rra
        ld   l,a
        exx
        ld   a,c
        exx
        ld   c,a
        srl  a
        add  a,l
        ld   l,a
        inc  c
        call Rst2
        exx
        ret

; Плейер семплев
; Note2
; "Sfx"-is a loop, which contains
; Is a address of the sound effect
;
SfxChannelA                     ; orig: Sfxa
        ld   hl,0
        ld   a,h
        or   a
        jr   z,SfxChannelB
        ld   bc,PORT_AY_REG
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
        ld   (SfxChannelA+1),hl
        ld   a,(hl)
        or   a
        jr   nz,SfxChannelB
        ld   (SfxChannelA+2),a
        ld   b,#FF
        ld   a,7
        out  (c),a
        in   a,(c)
        or   %00001001
        ld   b,#BF
        out  (c),a
SfxChannelB                     ; orig: Sfxb
        ld   hl,0
        ld   a,h
        or   a
        jr   z,SfxNoise
        ld   bc,PORT_AY_REG
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
        ld   (SfxChannelB+1),hl
        ld   a,(hl)
        or   a
        jr   nz,SfxNoise
        ld   (SfxChannelB+2),a
        ld   b,#FF
        ld   a,7
        out  (c),a
        in   a,(c)
        or   %00010010
        ld   b,#BF
        out  (c),a
SfxNoise                        ; orig: Sfxn
        ld   c,#FD
        ld   b,#FF
        ld   a,5
        out  (c),a
        ld   b,#BF
        ld   a,#0C
        out  (c),a
        ld   b,#FF
        ld   a,7
        out  (c),a
        ld   a,r
        cp   #20
        jr   c,$+4
        ld   a,#20
        and  %00100000
        ld   l,a
        in   a,(c)
        and  %11011011
        or   l
        ld   b,#BF
        out  (c),a
        ld   a,6
        ld   b,#FF
        out  (c),a
        ld   b,#BF
        ld   a,5
        out  (c),a
        ld   a,10
        ld   b,#FF
        out  (c),a
        ld   b,#BF
Nunu    ld   a,0
        srl  a
        cp   4
        jr   nc,$+4
        ld   a,4
        out  (c),a
        ret
SfxRocket                       ; orig: Roka
        db   20, 2, %00001000, 11
        db   1, 1, %00001000, 10
        db   20, 2, %00001000, 9
        db   1, 1, %00001000, 10
        db   20, 2, %00001000, 11
        db   1, 1, %00001000, 10, 0
SfxEff13                        ; orig: Eff13
        db   20, 0, %00000000, 10
        db   10, 0, %00000000, 9
        db   20, 0, %00000000, 8
        db   10, 0, %00000000, 7
        db   20, 0, %00000000, 6
        db   10, 0, %00000000, 5, 0
SfxEff19                        ; orig: Eff19
        db   80, 1, %00001000, 8
        db   70, 1, %00001000, 8
        db   60, 1, %00001000, 8
        db   80, 1, %00001000, 8
        db   70, 1, %00001000, 9
        db   60, 1, %00001000, 9
        db   80, 1, %00001000, 9
        db   70, 1, %00001000, 10
        db   60, 1, %00001000, 10
        db   80, 1, %00001000, 10
        db   70, 1, %00001000, 11
        db   60, 1, %00001000, 11
        db   80, 1, %00001000, 11
        db   70, 1, %00001000, 12
        db   60, 1, %00001000, 13
        db   70, 1, %00001000, 13, 0
SfxEff1                         ; orig: Eff1
        db   40, 0, %00000000, 10
        db   50, 0, %00000000, 9
        db   40, 0, %00000000, 8
        db   50, 0, %00000000, 7
        db   40, 0, %00000000, 6
        db   50, 0, %00000000, 5, 0
SfxEff14                        ; orig: Eff14
        db   20, 1, %00000000, 10
        db   10, 1, %00000000, 9
        db   20, 1, %00000000, 8
        db   10, 1, %00000000, 7
        db   20, 1, %00000000, 6
        db   10, 1, %00000000, 5, 0
SfxEff2                         ; orig: Eff2
        ; Shoot1
        db   #10, 1, %00001000, 12
        db   #40, 1, %00001000, 11
        db   #70, 1, %00001000, 10
        db   #20, 2, %00001000, 9
        db   #E0, 2, %00001000, 8
        db   #20, 3, %00001000, 7, 0

SfxEff0                         ; orig: Eff0
        ; Explosion
        db   #10, 8, %00001000, 15
        db   #10, 8, %00001001, 15
        db   #10, 8, %00000000, 15
        db   #80, 8, %00000000, 15
        db   #10, 8, %00000001, 15
        db   #80, 7, %00001001, 15
        db   #80, 7, %00000001, 15
        db   #80, 5, %00000001, 15
        db   #80, 4, %00000000, 14
        db   #80, 3, %00000001, 14
        db   1, 0, %00000001, 14
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000000, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000000, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 13
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 12
        db   1, 0, %00000001, 11
        db   1, 0, %00000001, 10
        db   1, 0, %00000001, 9
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 8
        db   1, 0, %00000001, 7
        db   1, 0, %00000001, 6
        db   1, 0, %00000001, 5
        db   1, 0, %00000001, 4
        db   1, 0, %00000001, 3, 0

SfxEff11                        ; orig: Eff11
        db   100, 2, 4, 9
        db   100, 3, 4, 7
        db   100, 2, 4, 5
        db   100, 3, 4, 4
        db   100, 2, 4, 2
        db   100, 3, 4, 1, 0

SfxEff21                        ; orig: Eff21
        db   200, 1, 32, 12
        db   2, 0, 0, 11
        db   50, 0, 0, 12
        db   50, 0, 4, 7
        db   50, 0, 4, 1, 0

DrawGauge                       ; orig: Datal
        ; Hl-adr on screen
        ; A-MEAN
        ld   c,a
        and  a
        jr   z,Dln1             ; Если вообще = 0
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
        dup  5
        ld   (hl),e
        inc  h
        edup
        ld   (hl),e
        ld   a,h
        sub  d
        ld   h,a
        inc  l
        djnz $-15
Dln1
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
        dup  5
        ld   (de),a
        inc  d
        edup
        ld   (de),a
        ld   a,d
        sub  5
        ld   d,a
        ex   de,hl
        inc  l
Dln2
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
Tabr
        db   %10000000
        db   %10000000
        db   %10100000
        db   %10100000
        db   %10101000
        db   %10101000
        db   %10101010

RedrawPanel                     ; orig: Repanel
        ; Вывод индикаторов панели , a так же вр
        ; Емени
        ld   a,1
        ld   (DrawSpeed+1),a
        ld   (DrawFire+1),a
        ld   (DrawShield+1),a
        ld   (DrawFuel+1),a
        call DrawStatusLine     ; Индикаторы
        ld   hl,(TIME+2)
        ld   de,(TIME)
        ld   b,#FF
        jp   Zerot1             ; Время

DrawStatusLine                  ; orig: Datalin
; Вывод данных O 3ащите энергии и др.инф
; O b виде статус линии
DrawShield                      ; orig: Fshild
        ld   a,0
        and  a
        jr   z,DrawFuel
        ld   a,(SHILD)
        ld   hl,#49A1
        call DrawGauge
        xor  a
        ld   (DrawShield+1),a

DrawFuel                        ; orig: Ffuel
        ld   a,0
        and  a
        jr   z,DrawFire
        ;
        rra
        ld   hl,#49E1
        call DrawGauge

DrawFire                        ; orig: Ffire
        ld   a,0
        and  a
        jr   z,DrawSpeed
        ;        LD A,(Peregrv+1)
        ld   hl,#5121
        call DrawGauge
        xor  a
        ld   (DrawFire+1),a

        ld   hl,#5181
        ld   hl,#51C1

DrawSpeed                       ; orig: Fspeed
        ld   a,0
        and  a
        jr   z,Fspd
        xor  a
        ld   (DrawSpeed+1),a
        ld   hl,(SPEED)
        dup  5
        add  hl,hl
        edup
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
        call DrawGauge
Fspd
        ret

        org  (($+255)&#FF00)
PLANET_
        incbin "assets/planet.bin"
SKYS_
        incbin "assets/CHAN6.bin"
DRV1
        incbin "assets/DRV1.bin"
DRV2
        incbin "assets/DRV2_UC.bin"
DOMA1
        incbin "assets/DOMA1.bin"

UpdateAI                        ; orig: INTEL
        ; Интелект поведения кораблей
        ld   ix,Carsb-OBJ_LEN
        jr   I2
I1
        ld   a,(ix+0)
        cp   #80
        ret  z
I2
        ld   de,OBJ_LEN
        add  ix,de
        ld   a,(ix+1)
        cp   #80
        jr   z,I1
        ld   a,(ix+Mode)
        rlca
        ld   l,a
        ld   h,0
        ld   de,AiModeTable
        add  hl,de
        ld   a,(hl)
        inc  hl
        ld   h,(hl)
        ld   l,a
        ld   de,RET_
        push de
        jp   (hl)
RET_
        ld   a,PAGE_3D
        call SetPage
        ld   a,(ix+Rspd)
        or   a
        jr   z,.I4
        ld   d,0
        ld   e,a
        call ENG3D_MOVE_ON
.I3
        call ENG3D_PRECORD
        ld   a,PAGE_NORMAL
        call SetPage
        jp   I2
.I4
        call ENG3D_NULL_MOVE
        jr   .I3

AiModeTable                     ; orig: MODES
        dw   AiFreeFly
        dup  10
        dw   NTH
        edup

AiFreeFly                       ; orig: FREEFLY
        ret

NTH
        ret

; Генерить скиммеры
GenerateSkimmers                ; orig: GENS
        ld   a,#01
        rrca
        ld   ($-2),a
        ret  nz
        ld   a,r
        cp   22
        ret  nc
        call FindFreeObject
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
        ld   h,+(0-Spacebd)+3
        inc  a
        ld   (ix+0),l
        ld   (ix+1),h

        push af
        call RNDL2
        pop  af

        rl   h
        ld   h,Spacebd-3
        jr   nc,$+6
        ld   h,+(0-Spacebd)+3
        add  a,2
        ld   (ix+4),l
        ld   (ix+5),h

        push af

        call RNDK1
        and  3
        dup  2
        rlca
        edup
        ld   (ix+Indi),a

        pop  af
        inc  a
        ld   h,a
        ld   a,l
        and  #3F
        dec  h
        set  7,a
        jr   z,.GS1
        dec  h
        set  6,a
        jr   z,.GS1
        dec  h
        res  7,a
        jr   z,.GS1
        res  6,a
.GS1
        ld   (ix+Beta),a

        xor  a
        ld   (ix+Alfa),a
        ld   (ix+Gama),a

        ld   (ix+Mode),0        ; Simply fly

        ret

; Генерить деревья
GenerateTrees                   ; orig: GEND
        call RND
        ld   ix,Carsb-OBJ_LEN
        ld   a,l
        or   h
        or   #07
        and  #1F
        ld   b,a

G1
        exx

        ld   bc,OBJ_LEN
.G3
        add  ix,bc
        ld   a,(ix+1)
        cp   #80
        jr   nz,.G3
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

        dup  2
        rlca
        edup
        or   #80
        ld   (ix+Indi),a

        ; Взять реальный размер спрайта
        ld   l,a
        ld   h,high(L97)
        ld   e,(hl)
        inc  hl
        ld   d,(hl)
        inc  de
        inc  de
        ex   de,hl

        call ReadWord3D

        ld   (ix+Alfa),e
        ld   (ix+Beta),d

        ld   (ix+Rspd),0
        ld   (ix+Mode),0

        ld   bc,OBJ_LEN
        add  ix,bc

        exx
        djnz G1
        ret

FindObject                      ; orig: FINDOBJ
        ; Поиск первого по типу b d
        ; Fz-on if not found
        ld   iy,Carsb-OBJ_LEN
        ld   bc,OBJ_LEN
Find2
        call Findob
        ret  z
        ld   a,(iy+Type)
        cp   d
        jp   nz,Find2
        inc  a
        ret

FOBJ
        ; Find object
        ; Ret hl-obj ad+1
        ; Fz-on no in buf objs
        ; Fz-off found
        ld   hl,+(Carsb-OBJ_LEN)+1
        ld   bc,OBJ_LEN
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

FindFreeObject                  ; orig: FNDFREE
        ; Find free space
        ; Ret fz-on if not found
        ld   hl,+(Carsb-OBJ_LEN)+1
        ld   de,OBJ_LEN
Hhh3
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

RND
        ld   hl,Sdo
        jp   RNDo
RNDW
        ld   hl,Sdw
        jp   RNDo
RNDK1
        ld   hl,Sdk1
        jp   RNDo
RNDK2
        ld   hl,Sdk2
        jp   RNDo
RNDK3
        ld   hl,Sdk3
        jp   RNDo
RNDT2
        ld   hl,Sdt2
        jp   RNDo
RNDT1
        ld   hl,Sdt1
        jp   RNDo
RNDL1
        ld   hl,Sdl1
        jp   RNDo
RNDL2
        ld   hl,Sdl2
        jp   RNDo
RNDL3
        ld   hl,Sdl3
        jp   RNDo
Sdw
        ; Генератор какого ландшафта
        db   7, 8, 0
Sdo
        db   101, 2, 30
Sdl1
        db   9, 0, 30
Sdl2
        db   231, 70, 30
Sdl3
        db   71, 1, 3
Sdt2
        db   44, 0, 0
Sdt1
        db   21, 1, 12
Sdk1
        db   247, 33, 0
Sdk2
        db   93, 4, 65
Sdk3
        db   29, 1, 12
RNDo
        ; In hl adr of seed
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
        xor  e,d
        ex   de,hl
        pop  de
        pop  bc
        ret

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

ServiceInput                    ; orig: SERVICE
        call ReadMouse
        call Servkj
        call Servqa

        ld   a,(KeyState)
        ld   c,a
        ld   a,(KeyState+5)
        or   c
        jr   z,.SV1
        ld   a,PAGE_3D
        call SetPage
        call ENG3D_LINE
        ; Ret fc-on если был выстрел
        ex   af,af'
        ld   a,PAGE_NORMAL
        call SetPage
        ex   af,af'
.SV1
        ld   a,(KeyState+2)
        or   a
        call nz,ROLDN
        ld   a,(KeyState+1)
        or   a
        call nz,ROLUP
        ld   a,(KeyState+4)
        or   a
        call nz,ROLLT
        ld   a,(KeyState+3)
        or   a
        call nz,ROLRT
        ld   a,(KeyState+4)
        ld   c,a
        ld   a,(KeyState+3)
        or   c
        ex   af,af'
        ld   a,PAGE_VOXEL
        call SetPage
        ex   af,af'
        call z,VOX_RETURN
        ld   a,PAGE_NORMAL
        call SetPage
        ret

; MOUSE driver from zx-format
KeyState                        ; orig: DIRECTZ
        db   0                  ; Fire
        db   0                  ; UP
        db   0                  ; DOWN
        db   0                  ; RIGHT
        db   0                  ; LEFT
        db   0                  ; Cancel
        db   0                  ; Medium

MouseCoord                      ; orig: MCOORD
        dw   0

; Устанавливаются b 1 если нажато
MousePorts                      ; orig: Mports
        dw   0                  ; Cords мыхи
Nondef  and  3
        jr   z,Mdrv4
        cp   1
        jr   z,Nondef_
        xor  a
        ld   (Mdrv3+2),a
        ld   a,5
        ld   (Mdrv2+2),a
Nondef_ ld   hl,0
        ld   (Mdrv1),hl
        pop  ix
; Main
ReadMouse                       ; orig: Servms
        ld   a,0
        and  a
        ret  nz
        push ix
        ld   hl,KeyState
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
Mdrv1   jr   Nondef
        rra
Mdrv2   rl   (ix+0)
        rra
Mdrv3   rl   (ix+5)
        rra
        rl   (ix+6)
Mdrv4
        ld   de,(MousePorts)
        ld   bc,#FBDF
        in   a,(c)
        ld   (MousePorts),a
        sub  e
        ld   (MouseCoord+1),a
        jr   z,Mdrv9
        jp   p,Mdrv6
        ld   (ix+4),1
        jr   Mdrv9
Mdrv6
        ld   (ix+3),1
Mdrv9   ld   b,#FF
        in   a,(c)
        ld   (MousePorts+1),a
        sub  d
        ld   (MouseCoord),a
        jr   z,Mdrv14
        neg
        jp   p,Mdrv11
        ld   (ix+1),1
        jr   Mdrv14
Mdrv11
        ld   (ix+2),1
Mdrv14
        pop  ix
        ret
Servkj
        ; SERVICE kempston joystic
        ld   a,0                ; Flag
        and  a
        ret  nz
        in   a,(PORT_KEMPSTON)
        jp   Gomove

Servqa
        ; SERVICE qaop sp
        ld   e,0
        ld   c,#FE
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
Gomove
; Вы3ов проц. и3менения координаты b 3ав
; Ис
; Мости от нажатой кнопки

        ; И3меняются переменные состояния нажатия
        ; Каких либо клавиш LEFT,rihgt,UP,DOWN,F
        ; Ire,cancel
        ld   e,a
        xor  a
        ld   d,a
        rrc  e
        adc  a,a
        ld   hl,KeyState+3
        or   (hl)
        ld   (hl),a
        xor  a
        rrc  e
        adc  a,a
        ld   hl,KeyState+4
        or   (hl)
        ld   (hl),a
        xor  a
        rrc  e
        adc  a,a
        ld   hl,KeyState+2
        or   (hl)
        ld   (hl),a
        xor  a
        rrc  e
        adc  a,a
        ld   hl,KeyState+1
        or   (hl)
        ld   (hl),a
        xor  a
        rrc  e
        adc  a,a
        ld   hl,KeyState
        or   (hl)
        ld   (hl),a
        ret

END_

        org  #6000
Font
        incbin "assets/FONT.bin"
        include "DATAM.asm"
END0
