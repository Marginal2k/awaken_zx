;  Програма переброски программы подгру3ки
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
            ld   hl,ZM9
            ld   de,#4200
            push de
            ld   bc,ZM8
            ldir
            ret

ZM9:
            disp #4200
ZM10:
            ld   sp,#C000
            push hl
            ld   de,#6000
            ld   bc,ZM14
            ldir
            PAGE_ FREE+8
            ld   a,9
            ld   (TRDOS_DRIVE),a
                        DISK_SETNAME ZM22
            ld   hl,#C000
            push hl
            DISK_READ
            pop  hl
            ld   d,h
            ld   e,l
            call DEHRUST
            PAGE_ VOXAL+8
                        DISK_SETNAME ZM27
            call RDFILE

                        DISK_SETNAME ZM11
            ld   hl,NEXTL1
            push hl
            DISK_READ
            pop  hl
;               ld     d,h
;               ld     e,l
;               call   DEHRUST

            PAGE_ CONTR+8
            ld   hl,ZM28
            call RRFILE
            ld   (TS_CON+1),hl
            ld   (SL_CON+1),a
            call RDFILE
            ld   hl,ZM12
            call RRFILE
            ld   hl,NEXTL2
            call RDFILE+3

            PAGE_ OBJ3D+8
                        DISK_SETNAME ZM29
            call RDFILE

            PAGE_ MAIN+8

            call INITV1
            call GEN2X
            call GENLOG2
            call GENTBXY
            PAGE_ CONTR+8
            call INIMS
            IFDEF TEST_RETURN
            jp   RETST                  ; test build only: immediately return to the station (build.py --test-return)
            ENDIF
            jp   START


RRFILE:
            ld   de,TRDOS_FNAME
            ld   bc,9
            ldir
            DISK_FIND
            ld   a,c
            DISK_INFO
            ld   hl,(TRDOS_SECTOR)
            inc  l
            ld   a,(TRDOS_SECCNT)
            ret
RDFILE:
            ld   hl,#C000
            ld   a,3
            ld   c,#0E
            jp   TRDOS_CALL
ZM11:
            db   "VOXAL   C"
ZM27:
            db   "VOXAL0  C"
ZM12:
            db   "CONTROL C"
ZM28:
            db   "CONTROL0C"
ZM22:
            db   "PANEL   C"
ZM29:
            db   "OBJECT3DC"
