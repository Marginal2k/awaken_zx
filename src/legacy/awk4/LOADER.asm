            jr   LD1
FILE1:
            db   "VSPRIT  C"
FILE2:
            db   "S3D     C"
LD1:
;ЗАГР. СТРАНИЦЫ
            ld   a,PGSPR
            call PG
            ld   hl,FILE1
            ld   de,23773
            ld   bc,9
            ldir 
            ld   hl,#C000
            ld   c,#0E
            ld   a,3
            call #3D13
            ld   a,PG3D
            call PG
            ld   hl,FILE2
            ld   de,23773
            ld   bc,9
            ldir 
            ld   hl,#C000
            ld   c,#0E
            ld   a,3
            call #3D13
            ld   a,PGNORM
            call PG

