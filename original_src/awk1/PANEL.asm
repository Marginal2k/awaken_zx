■COMPOS
■RADAR
■DATAL
■LIGHTER


















COMPOS
            ld   (STK08+1),sp
ЧИСТИМ ПОЛЕ КОМПАСА
            ld   hl,0
            ld   sp,#48B8
            push hl:dec sp
            push hl
            ld   sp,#49B8
            push hl:dec sp
            push hl
            ld   sp,#4AB8
            push hl:dec sp
            push hl
            ld   sp,#4BB8
            push hl:dec sp
            push hl
            ld   sp,#4CB8
            push hl:dec sp
            push hl
            ld   sp,#4DB8
            push hl:dec sp
            push hl
            ld   sp,#4EB8
            push hl:dec sp
            push hl
            ld   sp,#4FB8
            push hl:dec sp
            push hl
            ld   sp,#48D8
            push hl:dec sp
            push hl
            ld   sp,#49D8
            push hl:dec sp
            push hl
            ld   sp,#4AD8
            push hl:dec sp
            push hl
            ld   sp,#4BD8
            push hl:dec sp
            push hl
            ld   sp,#4CD8
            push hl:dec sp
            push hl
            ld   sp,#4DD8
            push hl:dec sp
            push hl
            ld   sp,#4ED8
            push hl:dec sp
            push hl
            ld   sp,#4FD8
            push hl:dec sp
            push hl
STK08       ld   sp,0
            ld   a,(NOSUN)
            dec  a
            jrz  ECOMP
ЕСЛИ ЗВЕЗДА ЕСТЬ В ПОЛЕ ВИДИМОСТИ
            ld   a,(STX)
■X-ЗВЕЗДЫ ПРЕОБРАЗОВАННАЯ К X НА КОМПАСЕ
            add  a,CMPX
            jppo $+5
            ld   a,CMPX-8
            cp   CMPX-8
            jrnc $+4
            ld   a,CMPX-8
            cp   CMPX+6
            jrc  $+4
            ld   a,CMPX+5
            ld   c,a
ТОЖЕ С Y
            ld   a,(STY)
            add  a,CMPY
            cp   CMPY-8
            jrnc $+4
            ld   a,CMPY-8
            cp   CMPY+6
            jrc  $+4
            ld   a,CMPY+5
            ld   b,a
ПО zОПРЕДЕЛИН СПРАЙТ ВЫВОДА
            ld   a,(STZ)
            and  a
            ld   de,VISUN
            jpp  $+6
            ld   de,UVISUN
            call MINISPRITE
ECOMP
ТОЖЕ С ПЛАНЕТОЙ
            ld   a,(ETX)
            ld   c,a
            ld   a,(ETY)
            or   c:ld c,a
            ld   a,(ETZ)
            or   c
            cp   #80
            retz

            ld   a,(ETX)
            add  a,CMPX
            jppo $+5
            ld   a,CMPX-8
            cp   CMPX-8
            jrnc $+4
            ld   a,CMPX-8
            cp   CMPX+6
            jrc  $+4
            ld   a,CMPX+5
            ld   c,a
            ld   a,(ETY)
            add  a,CMPY
            cp   CMPY-8
            jrnc $+4
            ld   a,CMPY-8
            cp   CMPY+6
            jrc  $+4
            ld   a,CMPY+5
            ld   b,a
            ld   a,(ETZ)
            and  a
            ld   de,VIEAR
            jpp  $+6
            ld   de,UVIEAR
            call MINISPRITE
            ld   a,(NOSTAT)
            and  a
            ret  nz
            ld   a,(TTX)
            add  a,CMPX+24
            jppo $+5
            ld   a,CMPX-8+24
            cp   CMPX-8+24
            jrnc $+4
            ld   a,CMPX-8+24
            cp   CMPX+6+24
            jrc  $+4
            ld   a,CMPX+5+24
            ld   c,a
            ld   a,(TTY)
            add  a,CMPY
            cp   CMPY-8
            jrnc $+4
            ld   a,CMPY-8
            cp   CMPY+6
            jrc  $+4
            ld   a,CMPY+5
            ld   b,a
            ld   a,(TTZ)
            and  a
            ld   de,VIEAR
            jpp  $+6
            ld   de,UVIEAR


MINISPRITE
ВЫВОД СПРАЙТА 3X3 6 BYTES
В deАДРЕС НАБОРА СПРАЙТОВ (СДВИНУТЫХ)
В bcКООРДИНАТЫ НА ЭКРАНЕ
            ld   a,b
            and  a
            rra
            scf
            rra
            and  a
            rra
            xor  b
            and  #F8
            xor  b
            ld   h,a
            ld   a,c
            rlca
            rlca
            rlca
            xor  b
            and  #C7
            xor  b
            rlca
            rlca
            ld   l,a
            ld   a,c
            and  7
            add  a,a
            ld   c,a
            add  a,a
            add  a,c
            add  a,e
            ld   e,a
            ld   a,d
            adc  a,0
            ld   d,a

            rept 2:ld a,(de):or (hl):ld (hl),a:inc de,l:ld a,(de):or (hl):ld (hl),a:inc de:dec l:NEXTLINE:endr

            ld   a,(de)
            or   (hl)
            ld   (hl),a
            inc  de
            inc  l
            ld   a,(de)
            or   (hl)
            ld   (hl),a
            ret
VISUN
            db   %01000000,%00000000
            db   %11100000,%00000000
            db   %01000000,%00000000
            db   %00100000,%00000000
            db   %01110000,%00000000
            db   %00100000,%00000000
            db   %00010000,%00000000
            db   %00111000,%00000000
            db   %00010000,%00000000
            db   %00001000,%00000000
            db   %00011100,%00000000
            db   %00001000,%00000000
            db   %00000100,%00000000
            db   %00001110,%00000000
            db   %00000100,%00000000
            db   %00000010,%00000000
            db   %00000111,%00000000
            db   %00000010,%00000000
            db   %00000001,%00000000
            db   %00000011,%10000000
            db   %00000001,%00000000
            db   %00000000,%10000000
            db   %00000001,%11000000
            db   %00000000,%10000000
UVISUN
            db   %10100000,%00000000
            db   %01000000,%00000000
            db   %10100000,%00000000
            db   %01010000,%00000000
            db   %00100000,%00000000
            db   %01010000,%00000000
            db   %00101000,%00000000
            db   %00010000,%00000000
            db   %00101000,%00000000
            db   %00010100,%00000000
            db   %00001000,%00000000
            db   %00010100,%00000000
            db   %00001010,%00000000
            db   %00000100,%00000000
            db   %00001010,%00000000
            db   %00000101,%00000000
            db   %00000010,%00000000
            db   %00000101,%00000000
            db   %00000010,%10000000
            db   %00000001,%00000000
            db   %00000010,%10000000
            db   %00000001,%01000000
            db   %00000000,%10000000
            db   %00000001,%01000000
VIEAR
            db   %11100000,%00000000
            db   %11100000,%00000000
            db   %11100000,%00000000
            db   %01110000,%00000000
            db   %01110000,%00000000
            db   %01110000,%00000000
            db   %00111000,%00000000
            db   %00111000,%00000000
            db   %00111000,%00000000
            db   %00011100,%00000000
            db   %00011100,%00000000
            db   %00011100,%00000000
            db   %00001110,%00000000
            db   %00001110,%00000000
            db   %00001110,%00000000
            db   %00000111,%00000000
            db   %00000111,%00000000
            db   %00000111,%00000000
            db   %00000011,%10000000
            db   %00000011,%10000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000001,%11000000
            db   %00000001,%11000000
UVIEAR
            db   %11100000,%00000000
            db   %10100000,%00000000
            db   %11100000,%00000000
            db   %01110000,%00000000
            db   %01010000,%00000000
            db   %01110000,%00000000
            db   %00111000,%00000000
            db   %00101000,%00000000
            db   %00111000,%00000000
            db   %00011100,%00000000
            db   %00010100,%00000000
            db   %00011100,%00000000
            db   %00001110,%00000000
            db   %00001010,%00000000
            db   %00001110,%00000000
            db   %00000111,%00000000
            db   %00000101,%00000000
            db   %00000111,%00000000
            db   %00000011,%10000000
            db   %00000010,%10000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000001,%01000000
            db   %00000001,%11000000


LNPA        equ  25

ADDES
            dw   EXP2-1
            dw   LNPA*1+1+EXP2
            dw   LNPA*2+1+EXP2
            dw   LNPA*3+1+EXP2
            dw   LNPA*4+1+EXP2
            dw   LNPA*5+1+EXP2
            dw   LNPA*6+1+EXP2
            dw   LNPA*7+1+EXP2
            dw   LNPA*8+1+EXP2
            dw   LNPA*9+1+EXP2
            dw   LNPA*10+1+EXP2
            dw   LNPA*11+1+EXP2
            dw   LNPA*12+1+EXP2
            dw   LNPA*13+1+EXP2
            dw   LNPA*14+1+EXP2
            dw   LNPA*15+1+EXP2



RADAR
            ld   ix,CARSB-OLEN
            ld   (STK4+1),sp
            ld   hl,(Speed)
            sra  h
            rr   l
            sra  h
            rr   l
            ld   a,l
            bit  7,l
            ld   b,1
            jrz  $+6
            ld   b,#FF
            neg
RDR_        ld   l,0
            add  a,l
            ld   (RDR_+1),a
            ld   c,0
            jpnc EXP3
            ld   c,b
EXP3        ld   a,0
            sub  c
            exx
            and  15
            ld   (EXP3+1),a
            ld   (EXP1+1),a
            rlca
            ld   l,a
            ld   h,0
            ld   b,h
            ld   sp,ADDES
            add  hl,sp
            ld   sp,hl
            ld   hl,#48A8+10
            ld   de,#5555
            ld   a,5
            exa
            ret
            exa
EXP2
            exa

            rept 7:ld c,#80:ld sp,hl:push bc,bc,bc,bc,bc:NEXTLINE:ld c,#00:ld sp,hl:push bc,bc,bc,bc,bc:NEXTLINE:endr

            ld   c,#80
            ld   sp,hl
            push bc,bc,bc,bc,bc
            NEXTLINE

            ld   sp,hl
            push de,de,de,de,de
            NEXTLINE

            exa
            dec  a
            jpnz EXP2
EXP1
            ld   a,0
            and  a
            jrz  STK4
            EXD
            ld   l,a
            ld   a,16
            sub  l
            rlca
            ld   l,a
            xor  a
            ld   h,a
            ld   (EXP1+1),a
            ld   sp,ADDES
            add  hl,sp
            ld   sp,hl
            ld   a,1
            ld   hl,#5555
            EXD
            exa
            ret

STK4        ld   sp,0
            ld   hl,#572C
            set  0,(hl)
            inc  l
            set  7,(hl)
            set  6,(hl)
            ld   hl,#504C
            set  0,(hl)
            inc  l
            set  7,(hl)
            set  6,(hl)
            inc  h
            dec  l
            set  0,(hl)
            inc  l
            set  7,(hl)
            set  6,(hl)
            jp   RDR1
RDR2
            ld   a,(ix+0)
            cp   #80
            ret  z
RDR1
            ld   de,OLEN
RDR11
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jrz  RDR2
            ld   a,(ix+TYPE)
            cp   #14;TPAШ
            jrz  RDR11
            cp   #15;CHAPЯД
            jrz  RDR11
            ld   a,(ix+PX+1)
            cp   #80
            jrz  RDR11
            ld   c,a
            and  a
            jpp  $+5
            neg
            cp   RADFAR
            jrnc RDR11
            ld   a,(ix+PY+1)
            ld   b,a
            and  a
            jpp  $+5
            neg
            cp   RADFAR
            jrnc RDR11
            ld   a,(ix+PZ+1)
            ld   e,a
            and  a
            jpp  $+5
            neg
            cp   RADFAR
            jrnc RDR1
            ld   a,e
            ld   e,c
            neg
            ld   c,a
            sra  c
            sra  c
            ld   a,c
            sra  c
            adc  a,c
            ld   c,a
            sra  e
            sra  e
            ld   a,e
            sra  e
            adc  a,e
            ld   e,a
            ld   a,#90;MID Y
            add  a,c
            cp   #90+#28-3
            jrnc RDR1
            cp   #90-#28+3
            jrc  RDR1
            ld   c,a
            ld   a,#68;MID X RADAR1
            add  a,e
            cp   #68+#28-3
            jrnc RDR1
            cp   #68-#28
            jrc  RDR1
            ld   e,a
            ld   a,c
            and  a
            rra
            scf
            rra
            and  a
            rra
            xor  c
            and  #F8
            xor  c
            exx
            ld   d,a
            exx
            ld   a,e
            rlca
            rlca
            rlca
            xor  c
            and  #C7
            xor  c
            rlca
            rlca
            exx
            ld   e,a
            exx
            ld   a,e
            exx
            and  7
            ld   c,a
            ld   b,0
            ld   hl,MPALKA
            add  hl,bc
            ld   c,(hl)
            exx
            ld   a,b
            exx
            sra  a
            sra  a
            jpz  MRAD2
            jpp  DOWNLINE
■UPLINE
            neg
            ld   b,a
            exx
            ld   a,c
            exx
            sub  b
            cp   #90-#28+3
            ccf
            jrc  $+13
            sub  #90-#28+3
            add  a,b
            jpm  MRAD2
            ld   b,a
            and  a
            jpz  MRAD2
            exa
UPL1
            ld   a,(de)
            or   c
            ld   (de),a
            ld   a,d
            dec  d
            and  7
            jpnz $+14
            ld   a,e
            sub  32
            ld   e,a
            jpc  $+7
            ld   a,d
            add  a,8
            ld   d,a
            djnz UPL1
            ld   a,d
            dec  d
            and  7
            jpnz $+14
            ld   a,e
            sub  32
            ld   e,a
            jpc  $+7
            ld   a,d
            add  a,8
            ld   d,a
            ld   a,d
            dec  d
            and  7
            jpnz $+13
            ld   a,e
            sub  32
            ld   e,a
            jrc  $+6
            ld   a,d
            add  a,8
            ld   d,a
            ld   a,d
            jp   MRAD
DOWNLINE
            ld   b,a
            exx
            ld   a,c
            exx
            add  a,b
            cp   #90+#28-3
            jrc  $+14
            sub  #90+#28-3
            sub  b
            neg
            ld   b,a
            and  a
            jrz  MRAD2
            jpm  MRAD2
            exa
UPL2
            ld   a,(de)
            or   c
            ld   (de),a
            inc  d
            ld   a,d
            and  7
            jpnz $+13
            ld   a,e
            add  a,32
            ld   e,a
            jrc  $+6
            ld   a,d
            sub  8
            ld   d,a
            djnz UPL2
MRAD
            exa
            jpnc RDR1
MRAD2
            exx
            ld   a,e
            and  7
            add  a,a
            ld   e,a
            add  a,a
            add  a,e
            exx
            ld   c,a
            ld   b,0
ЕСЛИ ЕСТЬ ПРИБОР ИДЕНТИФИКАЦИИ ЦЕЛЕЙ ТО
ВЗЯТЬ ТИП ИЗ ix+TYPE
            ld   a,(IDENTC)
            inc  a
            ld   a,(ix+TYPE)
            jrnz $+4
            ld   a,1
            sla  a
            add  a,MOTAB.b
            ld   l,a
            ld   a,MOTAB.h
            adc  a,0
            ld   h,a
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            add  hl,bc
            push hl
            ld   hl,MMASK
            add  hl,bc
            ld   b,(hl)
            inc  hl
            ld   c,(hl)
            pop  hl
            ld   a,(de)
            and  b
            or   (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            and  c
            or   (hl)
            ld   (de),a
            inc  hl
            dec  e
            inc  d
            ld   a,d
            and  7
            jpnz $+14
            ld   a,e
            add  a,32
            ld   e,a
            jpc  $+7
            ld   a,d
            sub  8
            ld   d,a
            ld   a,(de)
            and  b
            or   (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            and  c
            or   (hl)
            ld   (de),a
            inc  hl
            dec  e
            inc  d
            ld   a,d
            and  7
            jpnz $+14
            ld   a,e
            add  a,32
            ld   e,a
            jpc  $+7
            ld   a,d
            sub  8
            ld   d,a
            ld   a,(de)
            and  b
            or   (hl)
            ld   (de),a
            inc  hl
            inc  e
            ld   a,(de)
            and  c
            or   (hl)
            ld   (de),a
            jp   RDR1


MOTAB
            dw   MPIRAT
            dw   MTRADER
            dw   MARMY
            dw   MPOLICE
            dw   MHUNTER
            dw   MPIRAT
            dw   MUFO
            dw   MUFO
            dw   MOTSHEL
            dw   MMIKR
            rept 6:dw MTRADER:endr
            dw   MUNKNOWN
            dw   MROKET
            dw   MSTATION
            dw   MCARGO
MPALKA
            db   #80
            db   #40
            db   #20
            db   #10
            db   #08
            db   #04
            db   #02
            db   #01
MMASK
            db   %00011111,#FF,0,0,0,0
            db   %10001111,#FF,0,0,0,0
            db   %11000111,#FF,0,0,0,0
            db   %11100011,#FF,0,0,0,0
            db   %11110001,#FF,0,0,0,0
            db   %11111000,#FF,0,0,0,0
            db   %11111100,%01111111,0,0,0,0
            db   %11111110,%00111111,0,0,0,0
MCARGO
            db   %11100000,0
            db   %01000000,0
            db   %11100000,0
            db   %01110000,0
            db   %00100000,0
            db   %01110000,0
            db   %00111000,0
            db   %00010000,0
            db   %00111000,0
            db   %00011100,0
            db   %00001000,0
            db   %00011100,0
            db   %00001110,0
            db   %00000100,0
            db   %00001110,0
            db   %00000111,0
            db   %00000010,0
            db   %00000111,0
            db   %00000011,%10000000
            db   %00000001,%00000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000000,%10000000
            db   %00000001,%11000000
MROKET
            db   %01000000,0
            db   %01000000,0
            db   %11100000,0
            db   %00100000,0
            db   %00100000,0
            db   %01110000,0
            db   %00010000,0
            db   %00010000,0
            db   %00111000,0
            db   %00001000,0
            db   %00001000,0
            db   %00011100,0
            db   %00000100,0
            db   %00000100,0
            db   %00001110,0
            db   %00000010,0
            db   %00000010,0
            db   %00000111,0
            db   %00000001,%00000000
            db   %00000001,%00000000
            db   %00000011,%10000000
            db   %00000000,%10000000
            db   %00000000,%10000000
            db   %00000001,%11000000
MSTATION
            db   %11100000,0
            db   %10000000,0
            db   %11100000,0
            db   %01110000,0
            db   %01000000,0
            db   %01110000,0
            db   %00111000,0
            db   %00100000,0
            db   %00111000,0
            db   %00011100,0
            db   %00010000,0
            db   %00011100,0
            db   %00001110,0
            db   %00001000,0
            db   %00001110,0
            db   %00000111,0
            db   %00000100,0
            db   %00000111,0
            db   %00000011,%10000000
            db   %00000010,%00000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000001,%00000000
            db   %00000001,%11000000
MTRADER
            db   %11100000,0
            db   %11100000,0
            db   %11100000,0
            db   %01110000,0
            db   %01110000,0
            db   %01110000,0
            db   %00111000,0
            db   %00111000,0
            db   %00111000,0
            db   %00011100,0
            db   %00011100,0
            db   %00011100,0
            db   %00001110,0
            db   %00001110,0
            db   %00001110,0
            db   %00000111,0
            db   %00000111,0
            db   %00000111,0
            db   %00000011,%10000000
            db   %00000011,%10000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000001,%11000000
            db   %00000001,%11000000
MARMY
            db   %10000000,0
            db   %11000000,0
            db   %11100000,0
            db   %01000000,0
            db   %01100000,0
            db   %01110000,0
            db   %00100000,0
            db   %00110000,0
            db   %00111000,0
            db   %00010000,0
            db   %00011000,0
            db   %00011100,0
            db   %00001000,0
            db   %00001100,0
            db   %00001110,0
            db   %00000100,0
            db   %00000110,0
            db   %00000111,0
            db   %00000010,%00000000
            db   %00000011,%00000000
            db   %00000011,%10000000
            db   %00000001,%00000000
            db   %00000001,%10000000
            db   %00000001,%11000000
MMIKR
            db   %11100000,0
            db   %00000000,0
            db   %11100000,0
            db   %01110000,0
            db   %00000000,0
            db   %01110000,0
            db   %00111000,0
            db   %00000000,0
            db   %00111000,0
            db   %00011100,0
            db   %00000000,0
            db   %00011100,0
            db   %00001110,0
            db   %00000000,0
            db   %00001110,0
            db   %00000111,0
            db   %00000000,0
            db   %00000111,0
            db   %00000011,%10000000
            db   %00000000,%00000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000000,%00000000
            db   %00000001,%11000000
MOTSHEL
            db   %01100000,0
            db   %01100000,0
            db   %01100000,0
            db   %00110000,0
            db   %00110000,0
            db   %00110000,0
            db   %00011000,0
            db   %00011000,0
            db   %00011000,0
            db   %00001100,0
            db   %00001100,0
            db   %00001100,0
            db   %00000110,0
            db   %00000110,0
            db   %00000110,0
            db   %00000011,0
            db   %00000011,0
            db   %00000011,0
            db   %00000001,%10000000
            db   %00000001,%10000000
            db   %00000001,%10000000
            db   %00000000,%11000000
            db   %00000000,%11000000
            db   %00000000,%11000000
MHUNTER
            db   %11100000,0
            db   %10100000,0
            db   %11100000,0
            db   %01110000,0
            db   %01010000,0
            db   %01110000,0
            db   %00111000,0
            db   %00101000,0
            db   %00111000,0
            db   %00011100,0
            db   %00010100,0
            db   %00011100,0
            db   %00001110,0
            db   %00001010,0
            db   %00001110,0
            db   %00000111,0
            db   %00000101,0
            db   %00000111,0
            db   %00000011,%10000000
            db   %00000010,%10000000
            db   %00000011,%10000000
            db   %00000001,%11000000
            db   %00000001,%01000000
            db   %00000001,%11000000
MUFO
            db   %10100000,0
            db   %10100000,0
            db   %10100000,0
            db   %01010000,0
            db   %01010000,0
            db   %01010000,0
            db   %00101000,0
            db   %00101000,0
            db   %00101000,0
            db   %00010100,0
            db   %00010100,0
            db   %00010100,0
            db   %00001010,0
            db   %00001010,0
            db   %00001010,0
            db   %00000101,0
            db   %00000101,0
            db   %00000101,0
            db   %00000010,%10000000
            db   %00000010,%10000000
            db   %00000010,%10000000
            db   %00000001,%01000000
            db   %00000001,%01000000
            db   %00000001,%01000000
MUNKNOWN
            db   %00100000,0
            db   %01000000,0
            db   %10000000,0
            db   %00010000,0
            db   %00100000,0
            db   %01000000,0
            db   %00001000,0
            db   %00010000,0
            db   %00100000,0
            db   %00000100,0
            db   %00001000,0
            db   %00010000,0
            db   %00000010,0
            db   %00000100,0
            db   %00001000,0
            db   %00000001,0
            db   %00000010,0
            db   %00000100,0
            db   %00000000,%10000000
            db   %00000001,%00000000
            db   %00000010,%00000000
            db   %00000000,%01000000
            db   %00000000,%10000000
            db   %00000001,%00000000
MPIRAT
            db   %10100000,0
            db   %01000000,0
            db   %10100000,0
            db   %01010000,0
            db   %00100000,0
            db   %01010000,0
            db   %00101000,0
            db   %00010000,0
            db   %00101000,0
            db   %00010100,0
            db   %00001000,0
            db   %00010100,0
            db   %00001010,0
            db   %00000100,0
            db   %00001010,0
            db   %00000101,0
            db   %00000010,0
            db   %00000101,0
            db   %00000010,%10000000
            db   %00000001,%00000000
            db   %00000010,%10000000
            db   %00000001,%01000000
            db   %00000000,%10000000
            db   %00000001,%01000000
MPOLICE
            db   %01000000,0
            db   %11100000,0
            db   %01000000,0
            db   %00100000,0
            db   %01110000,0
            db   %00100000,0
            db   %00010000,0
            db   %00111000,0
            db   %00010000,0
            db   %00001000,0
            db   %00011100,0
            db   %00001000,0
            db   %00000100,0
            db   %00001110,0
            db   %00000100,0
            db   %00000010,0
            db   %00000111,0
            db   %00000010,0
            db   %00000001,%00000000
            db   %00000011,%10000000
            db   %00000001,%00000000
            db   %00000000,%10000000
            db   %00000001,%11000000
            db   %00000000,%10000000


ВЫВОД ЛИНИИ СТАТУСА ТИПА ЭНЕРГИЯ И Т.Д.
DATAL
В hl-АДРЕС НА ЭКРАНЕ
В a-ЗНАЧЕНИЕ
            ld   c,a
            and  a
ЕСЛИ РОВНО НУЛЮ ЗНАЧЕНИЕ
            jrz  $R1
            cpl
            and  7
            ld   a,c
            jrnz $+7
            add  a,8
            and  %11111000
            ld   c,a
            rrca
            rrca
            rrca
            and  7
            jrz  $R1
            ld   b,a
            ld   de,#05AA
            rept 5:ld (hl),e:inc h:endr
            ld   (hl),e
            ld   a,h
            sub  d
            ld   h,a
            inc  l
            djnz $-15
$R1
            ld   a,c
            exa
            ld   a,c
            and  7
            jrz  $R2
            ld   c,a
            ld   b,0
            EXD
            ld   hl,TABR
            add  hl,bc
            ld   a,(hl)
            rept 5:ld (de),a:inc d:endr
            ld   (de),a
            ld   a,d
            sub  5
            ld   d,a
            EXD
            inc  l
$R2
            exa
            ld   c,a
            and  7
            ld   a,c
            jrz  $+4
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
TABR
            db   %10000000
            db   %10000000
            db   %10100000
            db   %10100000
            db   %10101000
            db   %10101000
            db   %10101010

LIGHTER
            exa
            ld   a,(#8431)
            xor  #FE
            ld   (#8431),a
            ld   a,(#87F1)
            xor  #FE
            ld   (#87F1),a
            ld   a,(#842E)
            xor  #FE
            ld   (#842E),a
            ld   a,(#87EE)
            xor  #FE
            ld   (#87EE),a
            ld   hl,#844E
            ld   de,#8451
            ld   bc,#20
            exx
            ld   l,7
$R3
            exx
            ld   a,#80
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            ld   a,2
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            exx
            dec  l:jpnz $R3
            exx

            ld   hl,#870E
            ld   de,#8711

            exx
            ld   l,7
$R5
            exx
            ld   a,#80
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            ld   a,2
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            exx
            dec  l:jpnz $R5

            exa
            dec  a
            ret  z
            ld   hl,#8116

            ld   b,14
            ld   a,(hl)
            cpl
            ld   (hl),a
            dec  l
            djnz $-4

            ld   hl,#8129
            ld   de,#8136
            ld   bc,#20
            exx:ld l,#57
$R4
            exx
            ld   a,#80
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            ld   a,1
            xor  (hl)
            ld   (hl),a
            add  hl,bc
            EXD
            exx:dec l:jpnz $R4


ВЫВОД МАРКЕРОВ КОРАБЛЕЙ
            ld   de,OLEN
            ld   ix,CARSB-OLEN
            jp   $+9
$R8
            ld   a,(ix+0)
            cp   #80
            ret  z
$R6
            ld   de,OLEN
$R7
            add  ix,de
            ld   a,(ix+1)
            cp   #80
            jrz  $R8;ПУСТОЕ ПОЛЕ
            ld   a,(ix+TYPE)
            cp   #14;TRASH
            jrz  $R8
            ld   a,(ix+PX+1)
            cp   #80
ЕСЛИ НЕТ РАСЧЕТНЫХ КООРДИНАТ
            jrz  $R7
            ld   b,a
            ld   c,(ix+PX)
            ld   d,(ix+PZ+1)
            bit  7,d
ЕСЛИ ЗА ЭКРАНОМ СЗАДИ
            jrnz $R6
■ДОП. ПРОВЕРКА ПО X
■           and  a
■           jp   p,$+5
■           neg
■           cp   XVISIBILITY-#20
■           jrnc $R6;ДАЛЕКО ПО X
            ld   a,d
            cp   6
            jrc  $R6
            ld   e,(ix+PZ)
            ld   a,(ix+PY+1)
            ld   h,a
■           and  a
■           jp   p,$+5
■           neg
■           cp   XVISIBILITY-#20
■           jrnc $R6;ДАЛЕКО ПО Y
            ld   l,(ix+PY)
            call CALC2D3D
            jrnz $R6;ПЕРЕПОЛНЕНИЕ
            ld   a,h
            and  a
            jrnz $R6;ДАЛЕКО ПО X
            ld   a,d
            and  a
            jrnz $R6;ПО Y
            ld   a,l
■X НАЧАЛА ПОДСВЕТКИ
            sub  #50
            jrc  $R6
            cp   #5E;ДЛИННА ЕЕ
            jrnc $R6
            ld   a,e
■Y НАЧАЛА ПОДСВЕТКИ
            sub  #0E
            jrc  $R6
            cp   #4C;ВЫСОТА
            jrnc $R6
            ld   b,e
            ld   a,l
            sub  4
            ld   c,a
            and  7
            add  a,a
            add  a,a
            add  a,a
            add  a,a
            add  a,MASPR.b
            ld   e,a
            ld   a,MASPR.h
            adc  a,0
            ld   d,a
            ld   a,xl
            ld   l,a
            ld   a,xh
            ld   h,a
            push de
            ld   de,0-CARSB
            add  hl,de
            pop  de
            ld   a,h
            sla  l
            rla
            sla  l
            rla
            ld   l,a
            ld   a,(ROKETN1)
            cp   l
            jrz  $R9
            ld   a,(ROKETN2)
            cp   l
            jrz  $R9
            ld   a,(ROKETN3)
            cp   l
            jrnz $R10
$R9
            ld   a,e
            add  a,#80
            ld   e,a
            ld   a,d
            adc  a,0
            ld   d,a
$R10
            ld   a,c
            rrca
            rrca
            rrca
            and  %00011111
            ld   c,a
            ld   a,b
            sub  4
            rlca
            ld   l,a
            ld   h,8
            ADDHLHL 4
            ld   b,0
            add  hl,bc
            ld   bc,31
            rept 7:ld a,(de):xor (hl):ld (hl),a:inc de,l:ld a,(de):xor (hl):ld (hl),a:inc de:add hl,bc:endr
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            inc  de
            inc  l
            ld   a,(de)
            xor  (hl)
            ld   (hl),a
            jp   $R6
MASPR
            db   %11111111,%00000000
            db   %10000001,%00000000
            db   %10000001,%00000000
            db   %10000001,%00000000
            db   %10000001,%00000000
            db   %10000001,%00000000
            db   %10000001,%00000000
            db   %11111111,%00000000
            db   %01111111,%10000000
            db   %01000000,%10000000
            db   %01000000,%10000000
            db   %01000000,%10000000
            db   %01000000,%10000000
            db   %01000000,%10000000
            db   %01000000,%10000000
            db   %01111111,%10000000
            db   %00111111,%11000000
            db   %00100000,%01000000
            db   %00100000,%01000000
            db   %00100000,%01000000
            db   %00100000,%01000000
            db   %00100000,%01000000
            db   %00100000,%01000000
            db   %00111111,%11000000
            db   %00011111,%11100000
            db   %00010000,%00100000
            db   %00010000,%00100000
            db   %00010000,%00100000
            db   %00010000,%00100000
            db   %00010000,%00100000
            db   %00010000,%00100000
            db   %00011111,%11100000
            db   %00001111,%11110000
            db   %00001000,%00010000
            db   %00001000,%00010000
            db   %00001000,%00010000
            db   %00001000,%00010000
            db   %00001000,%00010000
            db   %00001000,%00010000
            db   %00001111,%11110000
            db   %00000111,%11111000
            db   %00000100,%00001000
            db   %00000100,%00001000
            db   %00000100,%00001000
            db   %00000100,%00001000
            db   %00000100,%00001000
            db   %00000100,%00001000
            db   %00000111,%11111000
            db   %00000011,%11111100
            db   %00000010,%00000100
            db   %00000010,%00000100
            db   %00000010,%00000100
            db   %00000010,%00000100
            db   %00000010,%00000100
            db   %00000010,%00000100
            db   %00000011,%11111100
            db   %00000001,%11111110
            db   %00000001,%00000010
            db   %00000001,%00000010
            db   %00000001,%00000010
            db   %00000001,%00000010
            db   %00000001,%00000010
            db   %00000001,%00000010
            db   %00000001,%11111110

            db   %00010000,%00000000
            db   %00101000,%00000000
            db   %01000100,%00000000
            db   %10000010,%00000000
            db   %01000100,%00000000
            db   %00101000,%00000000
            db   %00010000,%00000000
            db   %00000000,%00000000
            db   %00001000,%00000000
            db   %00010100,%00000000
            db   %00100010,%00000000
            db   %01000001,%00000000
            db   %00100010,%00000000
            db   %00010100,%00000000
            db   %00001000,%00000000
            db   %00000000,%00000000
            db   %00000100,%00000000
            db   %00001010,%00000000
            db   %00010001,%00000000
            db   %00100000,%10000000
            db   %00010001,%00000000
            db   %00001010,%00000000
            db   %00000100,%00000000
            db   %00000000,%00000000
            db   %00000010,%00000000
            db   %00000101,%00000000
            db   %00001000,%10000000
            db   %00010000,%01000000
            db   %00001000,%10000000
            db   %00000101,%00000000
            db   %00000010,%00000000
            db   %00000000,%00000000
            db   %00000001,%00000000
            db   %00000010,%10000000
            db   %00000100,%01000000
            db   %00001000,%00100000
            db   %00000100,%01000000
            db   %00000010,%10000000
            db   %00000001,%00000000
            db   %00000000,%00000000
            db   %00000000,%10000000
            db   %00000001,%01000000
            db   %00000010,%00100000
            db   %00000100,%00010000
            db   %00000010,%00100000
            db   %00000001,%01000000
            db   %00000000,%10000000
            db   %00000000,%00000000
            db   %00000000,%01000000
            db   %00000000,%10100000
            db   %00000001,%00010000
            db   %00000010,%00001000
            db   %00000001,%00010000
            db   %00000000,%10100000
            db   %00000000,%01000000
            db   %00000000,%00000000
            db   %00000000,%00100000
            db   %00000000,%01010000
            db   %00000000,%10001000
            db   %00000001,%00000100
            db   %00000000,%10001000
            db   %00000000,%01010000
            db   %00000000,%00100000
            db   %00000000,%00000000

