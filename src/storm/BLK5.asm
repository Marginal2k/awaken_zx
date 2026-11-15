;==============================================================================
; BLK5 - целочисленный корень (IntSqrt), содержится в S3D
;
; Таблица выровнена по странице. Фрагмент.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

SquareRootTab                   ; orig: Korni
        ; De-старшая часть числа
        ; Ret a-MEAN
        ld   a,d
        and  a
        jr   z,Kor
        ld   l,a
        ld   h,high(Korn)
        ld   a,(hl)
        inc  h
        ld   c,a
        cpl
        ex   af,af
        ld   b,#FF
        inc  bc
        sla  c
        rl   b
        dec  bc
        ld   a,(hl)
        inc  h
        ld   h,(hl)
        ld   l,a
        ex   af,af
        add  hl,de
        dup  5
        add  hl,bc
        ret  nc
        dec  bc
        dec  bc
        inc  a
        edup
        add  hl,bc
        ret  nc
        inc  a
        ret
Kor
        ; Подсчет корня бе3 таблицы, для маленьк
        ; Их данных
        ; De-data <2116
        ; A-MEAN
        ex   de,hl
        ld   bc,0-1
        xor  a
        dup  14
        add  hl,bc
        ret  nc
        inc  a
        dec  bc
        dec  bc
        edup
        add  hl,bc
        ret  nc
        inc  a
        ret

        org  (($+255)&#FF00)
; Таблица для подсечета корня
; Первый байт корень и3 "круглого" числа
; Втор. слово инвертнутое по 3наку число
; Как остаток
Korn
        incbin "assets/korni.bin"
