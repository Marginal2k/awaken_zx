;COMPOS
;RADAR
;DATAL
;LIGHTER


DrawCompass:                    ; orig: COMPOS - компас (чистка и вывод)
            ld   (STK08+1),sp
; Чистим поле компаса
            ld   hl,0
            ld   sp,#48B8
            push hl
            dec  sp
            push hl
            ld   sp,#49B8
            push hl
            dec  sp
            push hl
            ld   sp,#4AB8
            push hl
            dec  sp
            push hl
            ld   sp,#4BB8
            push hl
            dec  sp
            push hl
            ld   sp,#4CB8
            push hl
            dec  sp
            push hl
            ld   sp,#4DB8
            push hl
            dec  sp
            push hl
            ld   sp,#4EB8
            push hl
            dec  sp
            push hl
            ld   sp,#4FB8
            push hl
            dec  sp
            push hl
            ld   sp,#48D8
            push hl
            dec  sp
            push hl
            ld   sp,#49D8
            push hl
            dec  sp
            push hl
            ld   sp,#4AD8
            push hl
            dec  sp
            push hl
            ld   sp,#4BD8
            push hl
            dec  sp
            push hl
            ld   sp,#4CD8
            push hl
            dec  sp
            push hl
            ld   sp,#4DD8
            push hl
            dec  sp
            push hl
            ld   sp,#4ED8
            push hl
            dec  sp
            push hl
            ld   sp,#4FD8
            push hl
            dec  sp
            push hl
STK08:      ld   sp,0
            ld   a,(NOSUN)
            dec  a
            jr   z,.ECOMP
; Если звезда есть в поле видимости
            ld   a,(STX)
;X-звезды преобразованная к X на компасе
            add  a,CMPX
            jp   po,$+5
            ld   a,CMPX-8
            cp   CMPX-8
            jr   nc,$+4
            ld   a,CMPX-8
            cp   CMPX+6
            jr   c,$+4
            ld   a,CMPX+5
            ld   c,a
; Тоже с Y
            ld   a,(STY)
            add  a,CMPY
            cp   CMPY-8
            jr   nc,$+4
            ld   a,CMPY-8
            cp   CMPY+6
            jr   c,$+4
            ld   a,CMPY+5
            ld   b,a
; По zопределин спрайт вывода
            ld   a,(STZ)
            and  a
            ld   de,VISUN
            jp   p,$+6
            ld   de,UVISUN
            call DrawMiniSprite
.ECOMP
; Тоже с планетой
            ld   a,(ETX)
            ld   c,a
            ld   a,(ETY)
            or   c
            ld   c,a
            ld   a,(ETZ)
            or   c
            cp   #80
            ret  z

            ld   a,(ETX)
            add  a,CMPX
            jp   po,$+5
            ld   a,CMPX-8
            cp   CMPX-8
            jr   nc,$+4
            ld   a,CMPX-8
            cp   CMPX+6
            jr   c,$+4
            ld   a,CMPX+5
            ld   c,a
            ld   a,(ETY)
            add  a,CMPY
            cp   CMPY-8
            jr   nc,$+4
            ld   a,CMPY-8
            cp   CMPY+6
            jr   c,$+4
            ld   a,CMPY+5
            ld   b,a
            ld   a,(ETZ)
            and  a
            ld   de,VIEAR
            jp   p,$+6
            ld   de,UVIEAR
            call DrawMiniSprite
            ld   a,(NOSTAT)
            and  a
            ret  nz
            ld   a,(TTX)
            add  a,CMPX+24
            jp   po,$+5
            ld   a,CMPX-8+24
            cp   CMPX-8+24
            jr   nc,$+4
            ld   a,CMPX-8+24
            cp   CMPX+6+24
            jr   c,$+4
            ld   a,CMPX+5+24
            ld   c,a
            ld   a,(TTY)
            add  a,CMPY
            cp   CMPY-8
            jr   nc,$+4
            ld   a,CMPY-8
            cp   CMPY+6
            jr   c,$+4
            ld   a,CMPY+5
            ld   b,a
            ld   a,(TTZ)
            and  a
            ld   de,VIEAR
            jp   p,$+6
            ld   de,UVIEAR


DrawMiniSprite:                 ; orig: MINISPRITE - вывод спрайта 3x3 (6 байт)
; Вывод спрайта 3X3 6 BYTES
; в dеадрес набора спрайтов (сдвинутых)
; в bскоординаты на экране
            ld   a,b
            and  a
            rra
            scf
            rra
            and  a
            rra
            xor  b
            and  #F8
            xor  b
            ld   h,a
            ld   a,c
            rlca
            rlca
            rlca
            xor  b
            and  #C7
            xor  b
            rlca
            rlca
            ld   l,a
            ld   a,c
            and  7
            add  a,a
            ld   c,a
            add  a,a
            add  a,c
            add  a,e
            ld   e,a
            ld   a,d
            adc  a,0
            ld   d,a

            rept 2
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            inc  de
            inc  l
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            inc  de
            dec  l
            NEXTLINE
            endr

            ld   a,(de)
            or   (hl)
            ld   (hl),a
            inc  de
            inc  l
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            ret
            include "gen/RADAR_COMPASS.inc"   ; GENERATED from assets/gfx/radar_sprites.png


LNPA:       equ  25

ADDES:
            dw   EXP2-1
            dw   LNPA*1+1+EXP2
            dw   LNPA*2+1+EXP2
            dw   LNPA*3+1+EXP2
            dw   LNPA*4+1+EXP2
            dw   LNPA*5+1+EXP2
            dw   LNPA*6+1+EXP2
            dw   LNPA*7+1+EXP2
            dw   LNPA*8+1+EXP2
            dw   LNPA*9+1+EXP2
            dw   LNPA*10+1+EXP2
            dw   LNPA*11+1+EXP2
            dw   LNPA*12+1+EXP2
            dw   LNPA*13+1+EXP2
            dw   LNPA*14+1+EXP2
            dw   LNPA*15+1+EXP2


DrawRadar:                      ; orig: RADAR - радар
            ld   ix,CARSB-OLEN
            ld   (STK4+1),sp
            ld   hl,(Speed)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   a,l
            bit  7,l
            ld   b,1
            jr   z,$+6
            ld   b,#FF
            neg
RDR_:       ld   l,0
            add  a,l
            ld   (RDR_+1),a
            ld   c,0
            jp   nc,EXP3
            ld   c,b
EXP3:       ld   a,0
            sub  c
            exx
            and  15
            ld   (EXP3+1),a
            ld   (EXP1+1),a
            rlca
            ld   l,a
            ld   h,0
            ld   b,h
            ld   sp,ADDES
            add  hl,sp
            ld   sp,hl
            ld   hl,#48A8+10
            ld   de,#5555
            ld   a,5
            ex   af,af'
            ret
            ex   af,af'
EXP2:
            ex   af,af'

            rept 7
            ld   c,#80
            ld   sp,hl
            push bc
            push bc
            push bc
            push bc
            push bc
            NEXTLINE
            ld   c,#00
            ld   sp,hl
            push bc
            push bc
            push bc
            push bc
            push bc
            NEXTLINE
            endr

            ld   c,#80
            ld   sp,hl
            push bc
            push bc
            push bc
            push bc
            push bc
            NEXTLINE

            ld   sp,hl
            push de
            push de
            push de
            push de
            push de
            NEXTLINE

            ex   af,af'
            dec  a
            jp   nz,EXP2
EXP1:
            ld   a,0
            and  a
            jr   z,STK4
            EXD
            ld   l,a
            ld   a,16
            sub  l
            rlca
            ld   l,a
            xor  a
            ld   h,a
            ld   (EXP1+1),a
            ld   sp,ADDES
            add  hl,sp
            ld   sp,hl
            ld   a,1
            ld   hl,#5555
            EXD
            ex   af,af'
            ret

STK4:       ld   sp,0
            ld   hl,#572C
            set  0,(hl)
            inc  l
            set  7,(hl)
            set  6,(hl)
            ld   hl,#504C
            set  0,(hl)
            inc  l
            set  7,(hl)
            set  6,(hl)
            inc  h
            dec  l
            set  0,(hl)
            inc  l
            set  7,(hl)
            set  6,(hl)
            jp   RDR1
RDR2:
            ld   a,(ix+0)
            cp   #80
            ret  z
RDR1:
            ld   de,OLEN
.RDR11
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jr   z,RDR2
            ld   a,(ix+TYPE)
            cp   #14                ;Траш
            jr   z,.RDR11
            cp   #15                ;Снаряд
            jr   z,.RDR11
            ld   a,(ix+PX+1)
            cp   #80
            jr   z,.RDR11
            ld   c,a
            and  a
            jp   p,$+5
            neg
            cp   RADFAR
            jr   nc,.RDR11
            ld   a,(ix+PY+1)
            ld   b,a
            and  a
            jp   p,$+5
            neg
            cp   RADFAR
            jr   nc,.RDR11
            ld   a,(ix+PZ+1)
            ld   e,a
            and  a
            jp   p,$+5
            neg
            cp   RADFAR
            jr   nc,RDR1
            ld   a,e
            ld   e,c
            neg
            ld   c,a
            sra  c
            sra  c
            ld   a,c
            sra  c
            adc  a,c
            ld   c,a
            sra  e
            sra  e
            ld   a,e
            sra  e
            adc  a,e
            ld   e,a
            ld   a,#90              ;MID Y
            add  a,c
            cp   #90+#28-3
            jr   nc,RDR1
            cp   #90-#28+3
            jr   c,RDR1
            ld   c,a
            ld   a,#68              ;MID X RADAR1
            add  a,e
            cp   #68+#28-3
            jr   nc,RDR1
            cp   #68-#28
            jr   c,RDR1
            ld   e,a
            ld   a,c
            and  a
            rra
            scf
            rra
            and  a
            rra
            xor  c
            and  #F8
            xor  c
            exx
            ld   d,a
            exx
            ld   a,e
            rlca
            rlca
            rlca
            xor  c
            and  #C7
            xor  c
            rlca
            rlca
            exx
            ld   e,a
            exx
            ld   a,e
            exx
            and  7
            ld   c,a
            ld   b,0
            ld   hl,MPALKA
            add  hl,bc
            ld   c,(hl)
            exx
            ld   a,b
            exx
            sra  a
            sra  a
            jp   z,.MRAD2
            jp   p,.DOWNLINE
;UPLINE
            neg
            ld   b,a
            exx
            ld   a,c
            exx
            sub  b
            cp   #90-#28+3
            ccf
            jr   c,$+13
            sub  #90-#28+3
            add  a,b
            jp   m,.MRAD2
            ld   b,a
            and  a
            jp   z,.MRAD2
            ex   af,af'
.UPL1
            ld   a,(de)
            or   c
            ld   (de),a
            ld   a,d
            dec  d
            and  7
            jp   nz,$+14
            ld   a,e
            sub  32
            ld   e,a
            jp   c,$+7
            ld   a,d
            add  a,8
            ld   d,a
            djnz .UPL1
            ld   a,d
            dec  d
            and  7
            jp   nz,$+14
            ld   a,e
            sub  32
            ld   e,a
            jp   c,$+7
            ld   a,d
            add  a,8
            ld   d,a
            ld   a,d
            dec  d
            and  7
            jp   nz,$+13
            ld   a,e
            sub  32
            ld   e,a
            jr   c,$+6
            ld   a,d
            add  a,8
            ld   d,a
            ld   a,d
            jp   .MRAD
.DOWNLINE
            ld   b,a
            exx
            ld   a,c
            exx
            add  a,b
            cp   #90+#28-3
            jr   c,$+14
            sub  #90+#28-3
            sub  b
            neg
            ld   b,a
            and  a
            jr   z,.MRAD2
            jp   m,.MRAD2
            ex   af,af'
.UPL2
            ld   a,(de)
            or   c
            ld   (de),a
            inc  d
            ld   a,d
            and  7
            jp   nz,$+13
            ld   a,e
            add  a,32
            ld   e,a
            jr   c,$+6
            ld   a,d
            sub  8
            ld   d,a
            djnz .UPL2
.MRAD
            ex   af,af'
            jp   nc,RDR1
.MRAD2
            exx
            ld   a,e
            and  7
            add  a,a
            ld   e,a
            add  a,a
            add  a,e
            exx
            ld   c,a
            ld   b,0
; Если есть прибор идентификации целей то
; взять тип из ix+TYPE
            ld   a,(IDENTC)
            inc  a
            ld   a,(ix+TYPE)
            jr   nz,$+4
            ld   a,1
            sla  a
            add  a,low(RadarMotionTable)
            ld   l,a
            ld   a,high(RadarMotionTable)
            adc  a,0
            ld   h,a
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            add  hl,bc
            push hl
            ld   hl,MMASK
            add  hl,bc
            ld   b,(hl)
            inc  hl
            ld   c,(hl)
            pop  hl
            ld   a,(de)
            and  b
            or   (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            and  c
            or   (hl)
            ld   (de),a
            inc  hl
            dec  e
            inc  d
            ld   a,d
            and  7
            jp   nz,$+14
            ld   a,e
            add  a,32
            ld   e,a
            jp   c,$+7
            ld   a,d
            sub  8
            ld   d,a
            ld   a,(de)
            and  b
            or   (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            and  c
            or   (hl)
            ld   (de),a
            inc  hl
            dec  e
            inc  d
            ld   a,d
            and  7
            jp   nz,$+14
            ld   a,e
            add  a,32
            ld   e,a
            jp   c,$+7
            ld   a,d
            sub  8
            ld   d,a
            ld   a,(de)
            and  b
            or   (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            and  c
            or   (hl)
            ld   (de),a
            jp   RDR1


RadarMotionTable:               ; orig: MOTAB - таблица радара
            dw   MPIRAT
            dw   MTRADER
            dw   MARMY
            dw   MPOLICE
            dw   MHUNTER
            dw   MPIRAT
            dw   MUFO
            dw   MUFO
            dw   MOTSHEL
            dw   MMIKR
            rept 6
            dw   MTRADER
            endr
            dw   MUNKNOWN
            dw   MROKET
            dw   MSTATION
            dw   MCARGO
MPALKA:
            db   #80
            db   #40
            db   #20
            db   #10
            db   #08
            db   #04
            db   #02
            db   #01
MMASK:
            db   %00011111,#FF,0,0,0,0
            db   %10001111,#FF,0,0,0,0
            db   %11000111,#FF,0,0,0,0
            db   %11100011,#FF,0,0,0,0
            db   %11110001,#FF,0,0,0,0
            db   %11111000,#FF,0,0,0,0
            db   %11111100,%01111111,0,0,0,0
            db   %11111110,%00111111,0,0,0,0
            include "gen/RADAR_BLIPS.inc"   ; GENERATED from assets/gfx/radar_sprites.png


; Вывод линии статуса типа энергия и т.д.
DATAL:
; В hl-адрес на экране
; в a-значение
            ld   c,a
            and  a
; Если ровно нулю значение
            jr   z,.ZR1
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
            jr   z,.ZR1
            ld   b,a
            ld   de,#05AA
            rept 5
            ld   (hl),e
            inc  h
            endr
            ld   (hl),e
            ld   a,h
            sub  d
            ld   h,a
            inc  l
            djnz $-15
.ZR1
            ld   a,c
            ex   af,af'
            ld   a,c
            and  7
            jr   z,.ZR2
            ld   c,a
            ld   b,0
            EXD
            ld   hl,TABR
            add  hl,bc
            ld   a,(hl)
            rept 5
            ld   (de),a
            inc  d
            endr
            ld   (de),a
            ld   a,d
            sub  5
            ld   d,a
            EXD
            inc  l
.ZR2
            ex   af,af'
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
TABR:
            db   %10000000
            db   %10000000
            db   %10100000
            db   %10100000
            db   %10101000
            db   %10101000
            db   %10101010

LIGHTER:
            ex   af,af'
            ld   a,(#8431)
            xor  #FE
            ld   (#8431),a
            ld   a,(#87F1)
            xor  #FE
            ld   (#87F1),a
            ld   a,(#842E)
            xor  #FE
            ld   (#842E),a
            ld   a,(#87EE)
            xor  #FE
            ld   (#87EE),a
            ld   hl,#844E
            ld   de,#8451
            ld   bc,#20
            exx
            ld   l,7
.ZR3
            exx
            ld   a,#80
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            ld   a,2
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            exx
            dec  l
            jp   nz,.ZR3
            exx

            ld   hl,#870E
            ld   de,#8711

            exx
            ld   l,7
.ZR5
            exx
            ld   a,#80
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            ld   a,2
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            exx
            dec  l
            jp   nz,.ZR5

            ex   af,af'
            dec  a
            ret  z
            ld   hl,#8116

            ld   b,14
            ld   a,(hl)
            cpl
            ld   (hl),a
            dec  l
            djnz $-4

            ld   hl,#8129
            ld   de,#8136
            ld   bc,#20
            exx
            ld   l,#57
.ZR4
            exx
            ld   a,#80
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            ld   a,1
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            exx
            dec  l
            jp   nz,.ZR4


; Вывод маркеров кораблей
            ld   de,OLEN
            ld   ix,CARSB-OLEN
            jp   $+9
.ZR8
            ld   a,(ix+0)
            cp   #80
            ret  z
.ZR6
            ld   de,OLEN
.ZR7
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jr   z,.ZR8              ;Пустое поле
            ld   a,(ix+TYPE)
            cp   #14                ;TRASH
            jr   z,.ZR8
            ld   a,(ix+PX+1)
            cp   #80
; Если нет расчетных координат
            jr   z,.ZR7
            ld   b,a
            ld   c,(ix+PX)
            ld   d,(ix+PZ+1)
            bit  7,d
; Если за экраном сзади
            jr   nz,.ZR6
;Доп. проверка по X
;           and  a
;           jp   p,$+5
;           neg
;           cp   XVISIBILITY-#20
;           jrnc $R6;далеко по X
            ld   a,d
            cp   6
            jr   c,.ZR6
            ld   e,(ix+PZ)
            ld   a,(ix+PY+1)
            ld   h,a
;           and  a
;           jp   p,$+5
;           neg
;           cp   XVISIBILITY-#20
;           jrnc $R6;далеко по Y
            ld   l,(ix+PY)
            call Project3Dto2D
            jr   nz,.ZR6             ;Переполнение
            ld   a,h
            and  a
            jr   nz,.ZR6             ;Далеко по X
            ld   a,d
            and  a
            jr   nz,.ZR6             ;ПО Y
            ld   a,l
;X начала подсветки
            sub  #50
            jr   c,.ZR6
            cp   #5E                ;Длинна ее
            jr   nc,.ZR6
            ld   a,e
;Y начала подсветки
            sub  #0E
            jr   c,.ZR6
            cp   #4C                ;Высота
            jr   nc,.ZR6
            ld   b,e
            ld   a,l
            sub  4
            ld   c,a
            and  7
            add  a,a
            add  a,a
            add  a,a
            add  a,a
            add  a,low(MASPR)
            ld   e,a
            ld   a,high(MASPR)
            adc  a,0
            ld   d,a
            ld   a,ixl
            ld   l,a
            ld   a,ixh
            ld   h,a
            push de
            ld   de,0-CARSB
            add  hl,de
            pop  de
            ld   a,h
            sla  l
            rla
            sla  l
            rla
            ld   l,a
            ld   a,(ROKETN1)
            cp   l
            jr   z,.ZR9
            ld   a,(ROKETN2)
            cp   l
            jr   z,.ZR9
            ld   a,(ROKETN3)
            cp   l
            jr   nz,.ZR10
.ZR9
            ld   a,e
            add  a,#80
            ld   e,a
            ld   a,d
            adc  a,0
            ld   d,a
.ZR10
            ld   a,c
            rrca
            rrca
            rrca
            and  %00011111
            ld   c,a
            ld   a,b
            sub  4
            rlca
            ld   l,a
            ld   h,8
            ADDHLHL 4
            ld   b,0
            add  hl,bc
            ld   bc,31
            rept 7
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            inc  de
            inc  l
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            inc  de
            add  hl,bc
            endr
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            inc  de
            inc  l
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            jp   .ZR6
            include "gen/RADAR_TARGET.inc"   ; GENERATED from assets/gfx/radar_sprites.png
