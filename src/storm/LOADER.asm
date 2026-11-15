;==============================================================================
; LOADER - загрузка страниц движка через TR-DOS (включается в LAND)
;
; Загружает VSPRIT.C в страницу #13 и S3D.C в страницу #11 вызовом TR-DOS (#3D13).
; Имена файлов FILE1/FILE2 лежат в начале фрагмента.
;
; Часть набора STORM (прототип Awaken 1997/98), не входит в основную игру. Подробности: docs/STORM.md,
; таблица переименований меток: docs/STORM_LABELS.md. Собирается sjasmplus (см. make_*.asm).
;==============================================================================

        jr   LD1
FILE1
        db   "VSPRIT.CC"
FILE2
        db   "S3D.C   C"
LD1
        ; Загр. страницы
        ld   a,PAGE_VOXEL
        call SetPage
        ld   hl,FILE1
        ld   de,23773
        ld   bc,9
        ldir
        ld   hl,#C000
        ld   c,#0E
        ld   a,3
        call TRDOS_COMMAND
        ld   a,PAGE_3D
        call SetPage
        ld   hl,FILE2
        ld   de,23773
        ld   bc,9
        ldir
        ld   hl,#C000
        ld   c,#0E
        ld   a,3
        call TRDOS_COMMAND
        ld   a,PAGE_NORMAL
        call SetPage
