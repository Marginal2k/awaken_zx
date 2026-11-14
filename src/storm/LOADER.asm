; LOADER -- restored from awk2/LOADER.C (162 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
        JR LD1
FILE1
        DB "VSPRIT.CC"
FILE2
        DB "S3D.C   C"
LD1
;ЗАГР. СТРАНИЦЫ
        LD A,PGSPR
        CALL PG
        LD HL,FILE1
        LD DE,23773
        LD BC,9
        LDIR
        LD HL,#C000
        LD C,#0E
        LD A,3
        CALL #3D13
        LD A,PG3D
        CALL PG
        LD HL,FILE2
        LD DE,23773
        LD BC,9
        LDIR
        LD HL,#C000
        LD C,#0E
        LD A,3
        CALL #3D13
        LD A,PGNORM
        CALL PG
