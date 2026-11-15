■GMATRX
■MULS6
■COSTB2



















GMATRX:
■bЫЧИcЛEHИeTPEX MATPИЦ ПOBOPOTOB ДЛЯ BCEX OБЪEKTOB

■BOKPУГ "У"
            ld   a,(EYEG)
            and  a
            jpnz TLZ
            ld   hl,(LA11)
            ld   (LC11+1),hl
            ld   hl,(LA21)
            ld   (LC21+1),hl
            ld   hl,(LA31)
            ld   (LC31+1),hl
            ld   hl,(LA12)
            ld   (LB12+1),hl
            ld   hl,(LA22)
            ld   (LB22+1),hl
            ld   hl,(LA32)
            ld   (LB32+1),hl
            jp   TLX
TLZ
            ld   l,a
            ld   h,COSTB2.h
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            sub  #40
            ld   l,a
            ld   b,(hl)
            dec  h
            ld   c,(hl)
            ld   a,c
            cpl
            ld   l,a
            ld   a,b
            cpl
            ld   h,a
            inc  hl
            push de
            exx
            pop  bc
            ld   hl,(LA11)
            call MULS6
            push hl
            exx
            push bc
            exx
            pop  bc
            ld   hl,(LA12)
            call MULS6
            pop  de

            ADPHLDE   LC11

            exx
            push hl
            exx
            pop  bc
            ld   hl,(LA11)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LA12)
            call MULS6
            pop  de

            ADPHLDE   LB12

            exx
            push de
            exx
            pop  bc
            ld   hl,(LA21)
            call MULS6
            push hl
            exx
            push bc
            exx
            pop  bc
            ld   hl,(LA22)
            call MULS6
            pop  de

            ADPHLDE   LC21

            exx
            push hl
            exx
            pop  bc
            ld   hl,(LA21)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LA22)
            call MULS6
            pop  de

            ADPHLDE   LB22

            exx
            push de
            exx
            pop  bc
            ld   hl,(LA31)
            call MULS6
            push hl
            exx
            push bc
            exx
            pop  bc
            ld   hl,(LA32)
            call MULS6
            pop  de

            ADPHLDE   LC31

            exx
            push hl
            exx
            pop  bc
            ld   hl,(LA31)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LA32)
            call MULS6
            pop  de

            ADPHLDE   LB32


TLX
■BOKPУГ "X"
            ld   a,(EYEA)
            and  a
            jpnz TLX2
            ld   hl,(LB13)
            ld   (LC13+1),hl
            ld   hl,(LB23)
            ld   (LC23+1),hl
            ld   hl,(LB33)
            ld   (LC33+1),hl
            ld   hl,(LB12+1)
            ld   (LA12),hl
            ld   hl,(LB22+1)
            ld   (LA22),hl
            ld   hl,(LB32+1)
            ld   (LA32),hl
            jp   TLY
TLX2
            ld   l,a
            ld   h,COSTB2.h
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            sub  #40
            ld   l,a
            ld   b,(hl)
            dec  h
            ld   c,(hl)
            ld   a,c
            cpl
            ld   l,a
            ld   a,b
            cpl
            ld   h,a
            inc  hl
            push de
            exx
            pop  bc
LB12:       ld   hl,0
            call MULS6
            push hl
            exx
            push bc
            exx
            pop  bc
            ld   hl,(LB13)
            call MULS6
            pop  de

            ADPHLDE   LA12-1

            exx
            push hl
            exx
            pop  bc
            ld   hl,(LB12+1)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LB13)
            call MULS6
            pop  de

            ADPHLDE   LC13

            exx
            push de
            exx
            pop  bc
LB22:       ld   hl,0
            call MULS6
            push hl
            exx
            push bc
            exx
            pop  bc
            ld   hl,(LB23)
            call MULS6
            pop  de

            ADPHLDE   LA22-1

            exx
            push hl
            exx
            pop  bc
            ld   hl,(LB22+1)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LB23)
            call MULS6
            pop  de

            ADPHLDE   LC23

            exx
            push de
            exx
            pop  bc
LB32:       ld   hl,0
            call MULS6
            push hl
            exx
            push bc
            exx
            pop  bc
            ld   hl,(LB33)
            call MULS6
            pop  de

            ADPHLDE   LA32-1

            exx
            push hl
            exx
            pop  bc
            ld   hl,(LB32+1)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LB33)
            call MULS6
            pop  de

            ADPHLDE   LC33

TLY
■BOKPУГ "Y"
            ld   a,(EYEB)
            and  a
            jpnz TLY2
            ld   hl,(LC11+1)
            ld   (LA11),hl
            ld   hl,(LC21+1)
            ld   (LA21),hl
            ld   hl,(LC31+1)
            ld   (LA31),hl
            ld   hl,(LC13+1)
            ld   (LB13),hl
            ld   hl,(LC23+1)
            ld   (LB23),hl
            ld   hl,(LC33+1)
            ld   (LB33),hl
            ret
TLY2
            ld   l,a
            ld   h,COSTB2.h
            ld   e,(hl)
            inc  h
            ld   d,(hl)
            sub  #40
            ld   l,a
            ld   b,(hl)
            dec  h
            ld   c,(hl)
            ld   a,c
            cpl
            ld   l,a
            ld   a,b
            cpl
            ld   h,a
            inc  hl
            push de
            exx
            pop  bc
LC11:       ld   hl,0
            call MULS6
            push hl
            exx
            push hl
            exx
            pop  bc
LC13:       ld   hl,0
            call MULS6
            pop  de

            ADPHLDE   LA11-1

            exx
            push bc
            exx
            pop  bc
            ld   hl,(LC11+1)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LC13+1)
            call MULS6
            pop  de

            ADPHLDE   LB13-1

            exx
            push de
            exx
            pop  bc
LC21:       ld   hl,0
            call MULS6
            push hl
            exx
            push hl
            exx
            pop  bc
LC23:       ld   hl,0
            call MULS6
            pop  de

            ADPHLDE   LA21-1

            exx
            push bc
            exx
            pop  bc
            ld   hl,(LC21+1)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LC23+1)
            call MULS6
            pop  de

            ADPHLDE   LB23-1

            exx
            push de
            exx
            pop  bc
LC31:       ld   hl,0
            call MULS6
            push hl
            exx
            push hl
            exx
            pop  bc
LC33:       ld   hl,0
            call MULS6
            pop  de

            ADPHLDE   LA31-1

            exx
            push bc
            exx
            pop  bc
            ld   hl,(LC31+1)
            call MULS6
            push hl
            exx
            push de
            exx
            pop  bc
            ld   hl,(LC33+1)
            call MULS6
            pop  de

            ADPHLDE   LB33-1

            ret


MULS6
■hl=hl*bc(ТОЛЬКО СТАРШИЕ 14 БИТ)
            ld   a,b
            xor  h
            exa

            ABSHL

            ABSBC

            ld   a,c
            rla
            rl   b
            rla
            rl   b
            ld   (ANBY2+1),a
            EXD
            xor  a
            ld   c,a
            ld   h,c
            ld   l,c
 rept 7:rl b:jrnc $+4:add hl,de:adc a,c:add hl,hl:adc a,a:endr
            rl   b
            jrnc $+4
            add  hl,de
            adc  a,c
            add  hl,hl
            EXD:ld e,yl:ld d,yh:EXD
            ld   l,a
            ld   h,c
            adc  hl,hl
ANBY2       ld   a,0
 rept 6:rla:jrnc $+6:add iy,de:adc hl,bc:ADDIYIY:adc hl,hl:endr
            ld   a,yh
            add  a,a
            adc  hl,hl
            exa
            retp
            NEGHL
            ret

            ADRXX00
П 14-ТИ БИТНАЯ ТАБЛИЦА КОСИНУСОВ
COSTB2
            insert "CSTB.dat"

