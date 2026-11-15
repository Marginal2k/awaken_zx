;$M18
;NDATA
;RETSTT
;RETSTAT
;RNDD
;CLRBUFS
;SETIT
;SETT
;VERTAB
;STROYTAB
;LEVLTAB
;PINFO


ZM18:
            disp ADHDP
ZM19:
            push ix
            ld   (STK77+1),sp
            ld   a,FREE
            ld   bc,#7FFD
            out  (c),a
            exx
            ld   hl,#8C00
            ld   de,#C000
            ld   bc,#C000-#8C00
            ldir
            exx
            ld   a,CONTR
            out  (c),a
            exx
            ld   hl,JL1
            ld   bc,JL2
            ld   de,#8000
            push bc
            push de
            ldir
            ld   de,#E000
            ld   hl,#6000
            ld   bc,#2000
            ldir
            pop  hl
            pop  bc
            ld   de,#6400
            push de
            ldir
            pop  hl
            ld   d,h
            ld   e,l
            call DEHRUST
            ld   sp,#6000
            call #6500
            di
            ld   bc,#7FFD
            ld   a,FREE
            out  (c),a
            exx
            ld   hl,#C000
            ld   de,#8C00
            ld   bc,#C000-#8C00
            ldir
            exx
            ld   a,MAIN
            out  (c),a
            exx
            call CLRHD
            exx
            ld   a,CONTR
            out  (c),a
            push bc
            call OHIDE
            ld   hl,#E000
            ld   de,#6000
            ld   bc,#2000
            ldir

TS_CON:     ld   de,0
SL_CON:     ld   b,0
            ld   hl,#C000
            push hl
            call LOAD_
            pop  hl
            ld   d,h
            ld   e,l
            call DEHRUST
            pop  bc
STK77:      ld   sp,0
            ld   a,CONTR
            out  (c),a
            call ClearBuffers
            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,%11011011
            out  (c),a
            pop  ix
            di
            ret
LOAD_:
            ld   a,d
            srl  a
            ld   c,#7F
            call TOREG_
            ld   ix,#2F55
            call TOTD_
            push de
            push bc
            exx
            pop  bc
            pop  de
.LOD1_
            ld   a,(DSK)
            and  %00101111
            ld   c,a
            xor  a
            bit  0,d
            jr   nz,$+4
            ld   a,#10
            or   c
            ld   c,#FF
            call TOREG_
            ld   a,d
            srl  a
            ld   c,#3F
            call TOREG_
            ld   a,e
            ld   c,#5F
            call TOREG_
            exx
.RETL_
            push hl
            ld   a,#80
            ld   c,#1F
            call TOREG_
            ld   c,#7F
            ld   ix,#3FE5
            call TOTD_
            exx
            ld   a,d
            exx
            srl  a
            ld   d,a
            ld   a,1
            ld   (#5CD8),a
            ld   ix,#2740
            call TOTD_
            ld   a,(#5CCD)
            and  #7F
            pop  hl
            jr   nz,.RETL_
            inc  h
            exx
            inc  e
            ld   a,e
            cp   #11
            jr   c,.LOD2_
            inc  d
            ld   e,1
            bit  0,d
            jr   nz,.LOD2_
            exx
            ld   a,#58              ;STEP ON
            ld   c,#1F
            call TOREG_
            ld   ix,#2F59           ;WAIT
            call TOTD_
            exx
.LOD2_
            dec  b
            jp   nz,.LOD1_
            ret
TOREG_:
            ld   ix,#2A53
TOTD_:
            push ix
            jp   TRDOS_EXIT
ZM20:       equ  $-ZM19


            ent


; ДАННЫЕ ПЛАНЕТЫ
; В hl,de: lda,l:xorh,d,e
; БИТЫ 7,6-СТРОЙ; 5,4-ЭКОНОМИКА;
; БИТЫ 0-3 УРОВЕНЬ

; ДАННЫЕ ПО СИСТЕМЕ
; БИТЫ 4,3,2-КОЛИЧЕСТВО ПЛАНЕТ

; ДЕМОКРАТИЯ
; ДИКТАТУРА
; АНАРХИЯ
; НЕОБИТАЕМАЯ
; НЕИЗВЕСТНЫЙ ЕСЛИ ЗА ЗОНОЙ ГОСУДАРСТВ

; АГРОКУЛЬТУРНАЯ
; КУЛЬТУРНАЯ
; ТЕХНОЛОГИЧЕСКАЯ
; ОБЩАЯ

; ФЕДЕРАЦИЯ ГАЛАКТИК
; КОНФЕДЕРАЦИЯ ПЕРВЫХ
; СОДРУЖЕТВО МИРОВ
; СВОБОДНЫЕ ЗЕМЛИ


            include "gen/NDATA.inc"   ; GENERATED from assets/data/newgame_flight.csv


RETSTT:
; ВОЗВРАЩЕНИЕ НА СТАНЦИЮ С ОБНУЛЕНИЕМ ВСЕХ ДАННЫХ
            exx
            ld   hl,NDATA
            ld   de,TIME
            ld   bc,#200
            ldir
            exx
ReturnToStation:                ; orig: RETSTAT - возврат на станцию
; ВОЗВРАТ НА СТАНЦИЮ
;de-MTRK
            exx
            ld   sp,#6000
            ld   hl,#5800
            ld   de,#5801
            ld   bc,#2FF
            ld   (hl),l
            ldir
            ld   hl,RSTT
            ld   de,#4200
            push de
            ld   bc,LNRSTT
            ldir
            ret
RSTT:
            disp #4200
RSTT2:
            ld   bc,#FFFD
            ld   a,7
            out  (c),a
            ld   b,#BF
            ld   a,#FF
            out  (c),a
            ld   bc,#7FFD
            ld   a,#17
            out  (c),a
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#1AFF
            ld   (hl),l
            ldir

            ld   hl,TIME
            ld   de,STATE_BUF
            ld   bc,STATE_LEN
            ldir

; [glue] original: raw FDC track reads of the station image from the track in MTRK (protected loader),
; then a RET into it.  Replaced by an ordinary TR-DOS file load of STATIONF; the state record stays in
; STATE_BUF (screen RAM) and the station copies it into its own data at start (STATE_FLAG=1).
            ld   bc,#7FFD
            ld   a,#10
            out  (c),a
            im   1
            ld   a,#3F
            ld   i,a
            ld   iy,#5C3A
            ld   sp,STUB_SP
            ld   a,9
            ld   (TRDOS_DRIVE),a
            ei
            DISK_LOAD RSTT_NAME,#6000
            di
            ld   a,1
            ld   (STATE_FLAG),a
            ld   sp,#6000
            jp   STATION_ENTRY
RSTT_NAME:  db   "STATIONFC"
LNRSTT:     equ  $-RSTT2

            ent


RNDD:
            push bc
            ld   hl,(RNDD1)
            ld   de,(RNDD2)
            ld   c,h
            ld   b,l
            inc  hl
            inc  h
            add  hl,de
            ld   a,e
            adc  a,l
            ld   c,a
            add  hl,bc
            ld   a,l
            xor  c
            xor  #75
            ld   l,e
            ld   e,a
            ld   a,h
            xor  b
            xor  #A7
            ld   h,d
            ld   d,a
            ld   (RNDD1),hl
            ld   (RNDD2),de
            ld   a,d
            xor  e
            xor  h
            xor  l
            pop  bc
            ret


ClearBuffers:                   ; orig: CLRBUFS - чистка буферов спрайтов и объектов
; ЧИСТИТЬ ВСЕ БУФЕРЫ СПРАЙТОВ И ОБЪЕКТОВ
            ld   a,(GDIABLO)
            inc  a
; ГДЕ БУДЕТ СОЛНЦЕ, БЛИЗКО ЕСЛИ ЕСТЬ
; ДЬЯВОЛ ИЛИ ДАЛЕКО
            ld   bc,#0200
            jr   z,$+4
            ld   b,17               ;ECTЬ
            ld   hl,0
            ld   (SNZ+1),bc
            ld   (SNX+1),hl
            ld   (SNY+1),hl

            ld   hl,MODELSTAR
            jr   z,$+5
            ld   hl,MODELPLANET
            ld   de,PLANETES
            ld   bc,72
            ldir

            ld   iy,CARSB-OLEN
            ld   de,OLEN
.GJ1
            add  iy,de
            ld   a,(iy)
            cp   #80
            jr   nz,$+7
            cp   (iy+1)
            jr   z,.GJ3
            ld   (iy),0
            ld   (iy+1),#80
            ld   (iy+SETUP),#FF
            jr   .GJ1
.GJ3

            ld   ix,VOXCOR-VLEN
            ld   de,VLEN
.GJ11
            add  ix,de
            ld   a,(ix+7)
            and  a
            jp   m,$+9
            ld   (ix+7),0
            jr   .GJ11

            ld   hl,(WHERE)
            ld   (PLACE),hl
            EXD
            ld   hl,(WHERE+2)
            ld   (PLACE+2),hl
            ld   a,(WPLANET)
            ld   (PLANET),a
; УЗНАЕМ КОЛ. ПЛАНЕТ В СИСТЕМЕ
            ld   a,l
            xor  h
            xor  e
            xor  d
            and  7
            ld   c,a
            jr   nz,$+4
            ld   c,#C9
            ld   a,c
            ld   (PWOPK+1),a
SETIT:
            call SETT
            jp   SETTING

SETT:
; ИНИЦИИРУЕТ ТАБЛИЦУ ВЕРОЯТНОСТЕЙ И МОЩНО-
; СТЕЙ В ЗАВИСИМОСТИ ОТ ТИПА ПЛАНЕТЫ
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
            call PlanetInfo
            ld   (KOLPLANET+1),a
            or   a
            jr   nz,$+4
            ld   h,3
            ld   a,h
            rlca
            rlca
            rlca
            rlca
            ld   e,a
            ld   d,0
            ld   c,l
            dec  c
            push de
            ld   hl,STROYTAB
            add  hl,de
            EXD
            push bc
            ld   hl,LEVLTAB+1
            ld   ix,PLANDICTAT
            ld   a,15
.STIT1
            ex   af,af'
            ld   a,(hl)
            and  a
            jp   p,.STIT2
            neg
            dec  a
            jr   z,.STIT3
            ld   b,a
            xor  a
            sub  c
            djnz $-1
            jr   .STIT3
.STIT2
            dec  a
            jr   z,.STIT3
            ld   b,a
            xor  a
            add  a,c
            djnz $-1
.STIT3
            inc  hl
            ld   b,(hl)
            rr   b
            jr   c,$+6
            sra  a
            jr   $-6
            dec  hl
            dec  hl
            add  a,(hl)
            EXD
            add  a,(hl)
            EXD
            ld   (ix+0),a
            inc  de
            inc  ix
            inc  hl
            inc  hl
            inc  hl
            inc  hl
            ex   af,af'
            dec  a
            jp   nz,.STIT1
            exx
            pop  bc
            exx
            pop  de
            ld   hl,VERTAB
            add  hl,de
            EXD
            ld   hl,VARPS
            ld   bc,6
            ld   a,(de)
            ld   (hl),a
            add  hl,bc
            inc  de
            exx
            ld   b,8
            exx
            ld   a,(de)
            exx
            add  a,c
            exx
            ld   (hl),a
            add  hl,bc
            inc  de
            exx
            djnz $-9
            ret


PlanetInfo:                     ; orig: PINFO - информация о планете системы
;  ДАЧА ИНФО О ПЛАНЕТЕ НА СИСТЕМЕ
;hl,de-ДАННЫЕ СИСТЕМЫ
;a-НОМЕР ПЛАНЕТЫ С 0
;ret
;a=0-В СИСТЕМЕ НЕТ ПЛАНЕТ
;a-КОЛ. ПЛАНЕТ
;l-УРОВЕНЬ 1-16
;h-СТРОЙ 0-4
;e-ТИП 0-3
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

            call GovernmentAt
            ld   c,a
            ld   a,c
            cp   3
            ld   c,0
            jr   nz,$+3
            inc  c

            call RNDD
            djnz $-3
            cpl
            ld   e,a
;%SSUUUUTT
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


            include "gen/VERTAB.inc"   ; GENERATED from assets/data/spawn_types.csv

            include "gen/STROYTAB.inc"   ; GENERATED from assets/data/spawn_government.csv

            include "gen/LEVLTAB.inc"   ; GENERATED from assets/data/spawn_level.csv


MODELSTAR:
            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#00

            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF
            db   #00,#00,#80,#FF

            db   #00,#00,#80,#00
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF

            db   #00,#00,#80,#FF
            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF


MODELPLANET:
            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#04,#00

            db   #00,#00,#00,#00
            db   #00,#00,#00,#00
            db   #00,#00,#04,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#00
            db   #00,#00,#84,#FF

            db   #00,#00,#00,#00
            db   #00,#00,#80,#FF
            db   #00,#00,#84,#FF

            db   #00,#00,#80,#00
            db   #00,#00,#00,#00
            db   #00,#00,#84,#FF

            db   #00,#00,#80,#FF
            db   #00,#00,#00,#00
            db   #00,#00,#84,#FF
