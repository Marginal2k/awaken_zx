;==============================================================================
; BLK3 - вывод индикаторов (DrawGauge), содержится в LAND
;
; Фрагмент.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

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
