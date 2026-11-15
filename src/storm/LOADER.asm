        jr   LD1
FILE1
        db   "VSPRIT.CC"
FILE2
        db   "S3D.C   C"
LD1
        ; Загр. страницы
        ld   a,PAGE_VOXEL
        call PG
        ld   hl,FILE1
        ld   de,23773
        ld   bc,9
        ldir
        ld   hl,#C000
        ld   c,#0E
        ld   a,3
        call TRDOS_COMMAND
        ld   a,PAGE_3D
        call PG
        ld   hl,FILE2
        ld   de,23773
        ld   bc,9
        ldir
        ld   hl,#C000
        ld   c,#0E
        ld   a,3
        call TRDOS_COMMAND
        ld   a,PAGE_NORMAL
        call PG
