
            jr   LD1
FILE1
            db   "KARTA   C"
FILE2
            db   "MUZ1    C"
FILE3
            db   "stscr   C"
FILE4
            db   "HELP    C"
FILE5
            db   "D3D     C"
FILE6
            db   "LANG    C"
SECTAB
 db 13,11,11,12,8,14,19,15,15,13,19,12,16,20,21,20
LD1
 ЗАГР. СТРАНИЦЫ
            ld   a,9:ld (#5D06),a
            PAGE  PGKRT
            ld   hl,FILE1
            ld   de,23773
            ld   bc,9:ldir
            ld   hl,#C000
            ld   c,#0E
            ld   a,3
            call #3D13
            PAGE  PGMUZ
            ld   hl,FILE2
            ld   de,23773
            ld   bc,9:ldir
            ld   hl,#DB00
            ld   c,#0E
            ld   a,3
            call #3D13
            call #DB00
            PAGE  PGHLP
            ld   hl,FILE4
            ld   de,23773
            ld   bc,9:ldir
            ld   hl,#DB00
            ld   c,#0E
            ld   a,3
            call #3D13
            PAGE  PG3D
            ld   hl,FILE5
            ld   de,23773
            ld   bc,9:ldir
            ld   hl,#C000
            ld   c,#0E
            ld   a,3
            call #3D13

 ОБЩАЯ ИНИЦИАЛИЗАЦИЯ
            xor  a
            ld   l,a
            ld   h,a
            ld   (Eye_a),hl
            ld   (Eye_g),a
            ld   (La12+1),hl
            ld   (La21+1),hl
            ld   (La31+1),hl
            ld   (La32+1),hl
            ld   (Lb13+1),hl
            ld   (Lb23+1),hl
            ld   hl,#7FFF
            ld   (La11+1),hl
            ld   (La22+1),hl
            ld   (Lb33+1),hl


            PAGE  PGLANG
            ld   hl,FILE6
            ld   de,23773
            ld   bc,9:ldir
            ld   hl,#C000
            ld   c,#0E
            ld   a,3
            call #3D13

            PAGE  PGBGD
            ld   hl,FILE3
            ld   de,23773
            ld   bc,9:ldir
            ld   c,#0A
            call #3D13
            ld   a,c
            ld   c,#08
            call #3D13
            ld   a,r
            and  #0F
            ld   c,a
            ld   l,a:ld h,0
            ld   de,SECTAB
            add  hl,de
            push hl
            inc  c
            EXD
            xor  a
_M2_
            dec  c
            jrz  _M_
            add  a,(hl)
            inc  hl
            jr   _M2_
_M_
            ld   de,(#5CEB)
            ld   c,a
            and  #0F
            add  a,e
            ld   e,a
            rrca:rrca:rrca:rrca
            and  #0F
            add  a,d
            ld   d,a
            ld   a,c
            rrca:rrca:rrca:rrca
            and  #0F
            add  a,d
            ld   d,a
            ld   a,e:and #0F:ld e,a
            pop  hl
            ld   b,(hl)
            ld   hl,#C000
            ld   c,5
            call #3D13
            ld   hl,#C000
            ld   de,#C000
            call DEPACK

ДЕЛАЕМ ЦВЕТ ДЛЯ ЧАСОВ
            ld   hl,#3838
            ld   (#DAFE),hl
            ld   (#DAFC),hl
            ld   (#DAFB),hl

            PAGE  PGNORM

