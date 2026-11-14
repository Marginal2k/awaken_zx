
 ПpoГPAMA ПEPEБPOCKИ ПpoГPAMMЫ ПOДГpУ3KИ
            xor  a
            out  (#FE),a
            ld   bc,#7FFD
            ld   a,#17
            out  (c),a
            exx
            ld   hl,#C000
            ld   de,#C001
            ld   bc,#1AFF
            ld   (hl),l
            ldir
            exx
            ld   a,#18
            out  (c),a
            ld   hl,#4000
            ld   de,#4001
            ld   bc,#1800
            ld   (hl),l
            ldir
            ld   (hl),#38
            ld   bc,#180
            ldir
            ld   (hl),7
            ld   bc,#17F
            ldir
            ld   hl,$M9
            ld   de,#4200
            push de
            ld   bc,$M8
            ldir
            ret

$M9
            phase #4200
$M10
            ld   sp,#C000
            push hl
            ld   de,#6000
            ld   bc,$M14
            ldir
            PAGE    FREE+8
            ld   a,9
            ld   (23814),a
            ld   hl,$M22
            ld   de,23773
            ld   bc,9
            ldir
            ld   hl,#C000
            push hl
            ld   a,3
            ld   c,#0E
            call #3D13
            pop  hl
            ld   d,h
            ld   e,l
            call DEHRUST
            PAGE  VOXAL+8
            ld   hl,$M27
            ld   de,23773
            ld   bc,9
            ldir
            call RDFILE

            ld   hl,$M11
            ld   de,23773
            ld   bc,9
            ldir
            ld   hl,NEXTL1
            push hl
            ld   a,3
            ld   c,#0E
            call #3D13
            pop  hl
■               ld     d,h
■               ld     e,l
■               call   DEHRUST

            PAGE  CONTR+8
            ld   hl,$M28
            call RRFILE
            ld   (TS_CON+1),hl
            ld   (SL_CON+1),a
            call RDFILE
            ld   hl,$M12
            call RRFILE
            ld   hl,NEXTL2
            call RDFILE+3

            PAGE  OBJ3D+8
            ld   hl,$M29
            ld   de,23773
            ld   bc,9
            ldir
            call RDFILE

            PAGE  MAIN+8

            call INITV1
            call GEN2X
            call GENLOG2
            call GENTBXY
            PAGE  CONTR+8
            call INIMS
            jp   START


RRFILE
            ld   de,23773
            ld   bc,9
            ldir
            ld   c,#0A
            call #3D13
            ld   a,c
            ld   c,#08
            call #3D13
            ld   hl,(#5CEB)
            inc  l
            ld   a,(#5CEA)
            ret
RDFILE
            ld   hl,#C000
            ld   a,3
            ld   c,#0E
            jp   #3D13
$M11
            db   "VOXAL   C"
$M27
            db   "VOXAL0  C"
$M12
            db   "CONTROL C"
$M28
            db   "CONTROL0C"
$M22
            db   "PANEL   C"
$M29
            db   "OBJECT3DC"

