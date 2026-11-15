;==============================================================================
; INVTAB3D - превращает таблицу масок D9000+ в D9000
;
; ORG #8000, данные #9000. Алгоритм проверен побайтно (verify_storm.py inv).
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

        ; Инвертирование таблицы масок для 3d
        org  #8000
        ld   hl,#9000
        ld   b,#80
M1
        ld   a,(hl)
        cpl
        ld   c,a
        inc  l
        ld   a,(hl)
        cpl
        and  c
        ld   (hl),a
        dec  l
        inc  h
        ld   a,(hl)
        cpl
        ld   c,a
        inc  l
        ld   a,(hl)
        cpl
        and  c
        ld   (hl),a
        inc  l
        dec  h
        djnz M1
        ret
        org  #9000
        incbin "assets/D9000_plus.bin"
