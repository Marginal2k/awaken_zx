■VTXT
■OTXT
■Pntpro
■Onum4
■Onum2
■Onum3
■Onum5
■ONUMB
■Outtxt
■Hlt
■Hltxt
■SPECSYM










VTXT
ВИРТУАЛЬНЫЙ ВЫВОД ОДНОЙ СТРОКИ ТЕКСТА
НЕ ПЕЧАТАЯ, ТОЛЬКО МЕНЯЯ КООРДИНАТУ Y
■X=0,ВЕРНЕТ В hlТЕКСТ С КОТ. ПЕЧАТАТЬ
ДННУЮ СТРОКУ.
■hl-TXT
■FC-ON - КОНЕЦ ТЕКСТА
            ld   a,(Eyw+1)
            cp   14:ret c

            ld   a,#C3
            ld   (STOPP),a
            ld   de,Endpr
            ld   (STOPP+1),de
            ld   a,(Exw+1)
            ld   (EW2+1),a
L_T
EW2         ld   c,0
            ld   b,32
            ld   e,0
            push hl
            xor  a
L_1
            ld   d,a
            call Hlt
            add  a,SPLEN
            inc  hl,e
            add  a,d
            jr   c,L_8
            cp   c
            jr   c,L_1
            sub  SPLEN:cp c
            jr   nc,L_8
            dec  e:jr nz,$+3:inc e,e
L_8
            dec  e
            pop  hl
            jr   nz,L_4
            call L_2
            jr   EVP

L_4
РАССТАНОВКА КООРДИНАТ X ДЛЯ СЛОВ И ИХ
ВЫВОД
            ld   a,c:sub d:ld d,a
            dec  e
            jr   z,L_51
В "A" - СКОЛЬКО ПИКСЕЛЕЙ ДО КОНЦА ОКНА
            ld   d,#FF

            inc  d:sub e
            jp   nc,$-2
L_51
            inc  e
L_5
            call L_2:jr z,EVP
            ld   a,(Cord)
            add  a,SPLEN;ШИРИНА ПРОБЕЛА
            add  a,d
            ld   (Cord),a
            dec  e
            jp   nz,L_5
            call O_9
            and  a
EVP
КОНЕЦ
            ld   a,#68
            ld   (STOPP),a
            ld   de,#2648
            ld   (STOPP+1),de
            ret
L_2
ВЫВОД СЛОВА
■FC-ON КОНЕЦ ТЕКСТА
            ld   a,(hl):inc hl
            cp   CR:jrz L_33
            cp   ET:scf:ret z
            cp   32
            jrz  L_3
            RST_
            jrc  L_2
            and  a
            jrz  L_2
            cp   3:jrnz L_31
            dec  hl
            call O_9
L_31
            xor  a:ret
L_3
            inc  a:ret
L_33        xor  a:inc a:ld e,a:ret






────────────────────
OTXT
ВЫВОД ТЕКСТА С ФОРМАТИРОВАНИЕМ
■hl-АДРЕС ТЕКСТА
            ld   a,(Eyw+1)
            cp   14:ret c
            ld   a,(Exw+1)
            ld   (EW+1),a
O_T
EW          ld   c,0
            ld   b,32
            ld   e,0
            push hl
            xor  a
O_1
            ld   d,a
            call Hlt
            add  a,SPLEN
            inc  hl,e
            add  a,d
            jr   c,O_8
            cp   c
            jr   c,O_1
            sub  SPLEN:cp c
            jr   nc,O_8
            dec  e:jr nz,$+3:inc e,e
O_8
            dec  e
            pop  hl
            jr   nz,O_4
            call O_2:ret z
            jp   O_T

O_4
РАССТАНОВКА КООРДИНАТ X ДЛЯ СЛОВ И ИХ
ВЫВОД
            ld   a,c:sub d:ld d,a
            dec  e
            jr   z,O_51
В "A" - СКОЛЬКО ПИКСЕЛЕЙ ДО КОНЦА ОКНА
            ld   d,#FF

            inc  d:sub e
            jp   nc,$-2
O_51
            inc  e
O_5
            call O_2:ret z
            ld   a,(Cord)
            add  a,SPLEN;ШИРИНА ПРОБЕЛА
            add  a,d
            ld   (Cord),a
            dec  e
            jp   nz,O_5
            call O_9:ret c
            jp   O_T
O_2
ВЫВОД СЛОВА
            ld   a,(hl):inc hl
            cp   CR:jrz O_33
            cp   ET:ret z
            cp   32
            jr   z,O_3
            RST_
            jr   c,O_2
            and  a
            jr   z,O_2
            cp   3:jr nz,O_31
            dec  hl
            call O_9:ld a,1:dec a:ret c
            inc  a
            ret
O_33
            xor  a:inc a:ld e,a:ret
O_31
            xor  a:ret
O_3
            inc  a:ret

СЛЕД. КООРДИНАТА Y
O_9
            ld   a,(Cord+1)
            add  a,8
            ld   c,a
            ld   a,(Eyw+1):ld b,a
            ld   a,c:cp b
            ccf:ret c
            ld   (Cord+1),a
            xor  a:ld (Cord),a:ret





WDW
ВЫЛЕТ СНИЗУ ОКНА
            and  a:ld a,2
            jp   Endpr+2
WRW
ВЫЛЕТ СПРАВА ОКНА
            and  a:ld a,3
            jp   Endpr+2
WRS
            and  a
            jp   m,Endpr;HEДOЛET cЛEBA,
ВЫЛЕТ СПРАВА ЭКРАНА
            xor  a
            jp   Endpr+2
WRS2
            and  a
            jp   m,Endpr;HEДOЛET CBEP
ВЫЛЕТ ВНИЗ ЭКРАНА
            xor  a:inc a
            jp   Endpr+2
WDE
ВЫЛЕТ ВНИЗ ЭКРАНА
            ld   a,1:jp Endpr+2


■OПИCATЬ METKИ FONT,TABAS andTABXX
■TAБЛИЦaMACOK

■PRINT PROPORCIONALX#18
■a-CODE
■(CORD+1)-X/Y inPIX
■retFC-ON ifALLRIGHT
■ifFC-OFF THAT WAS outOF WINDOW
И С FC-OFF РЕГ."А" ГОВОРИТ:
■0-ВЫЛЕТ СПРАВА ЭКРАНА
■1-ВЫЛЕТ СНИЗУ ЭКРАНА
■2-ВЫЛЕТ СНИЗУ ОКНА
■3-ВЫЛЕТ СПРАВА ОКНА

Pntpro
            push de,bc,hl
            exx
            push de,bc,hl
            exa
            push af
            exa
            ld   l,a
            ld   e,a
            ld   d,SZTB.h
            ld   h,0
            ADDHLHL 3
            ld   bc,Font
            add  hl,bc
            EXD
            ld   bc,(Cord)

            ld   a,b
Eyw         cp   0;END OF WIN -8+1-RAMKA
            jr   nc,WDW

            ld   a,(hl)
■NUM inhl= %0000XXXX
            add  a,c
            jr   c,WRW
Exw         cp   0
            jp   nc,WRW

            ld   (Cord),a

Bxw         ld   a,0
            add  a,c
            ld   c,a
Bxh         ld   a,0
            adc  a,0
            jr   nz,WRS

■cЛeД.CИMB
            ld   a,c
            exa
Byw         ld   a,0
            add  a,b
            ld   b,a
Byh         ld   a,0
            adc  a,0
            jr   nz,WRS2

■XУ,cЛeД.CTPOKA
            ld   a,b
            cp   192-7
            jr   nc,WDE

STOPP
■#68,#48,#26
            ld   l,b
            ld   c,b
            ld   h,TBXX.h
            ld   b,(hl)
            inc  h
            ld   a,(hl)
            inc  h
            exa
            ld   l,a
            exa
            or   (hl)
            ld   l,a
            ld   h,b

            exa
            and  7
            add  a,a
            ld   b,a

            ld   a,l:inc a:and #1F
            jp   nz,$+4
            inc  b
            ld   a,b
            add  a,a
            add  a,a
            add  a,a
            ld   b,a
            ld   a,c
            and  7
            add  a,b
            exx
            add  a,a
            ld   l,a
            ld   h,Tabx.h/2
            add  hl,hl
RETT
            ld   c,(hl):inc l
            ld   b,(hl):inc l
            and  a
            ld   ($+6),bc
            exx
            jp   0


S00
 rept 7:ld a,(de):LDX_HL_A:inc e,h:endr
            ld   a,(de):LDX_HL_A
            exx:jp Endpr

S_00
 rept 7:ld a,(de):LDX_HL_A:inc e,h:endr
            NEXTZNAK
            exx:jp RETT



S01
 rept 7:ld c,0:ld a,(de):rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   c,0:ld a,(de):rra:rr c
            LDX_HL_A:inc l
            ld   a,c:LDX_HL_A
            exx:jp Endpr

S_01
 rept 7:ld c,0:ld a,(de):rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT


S01_
 rept 7:ld a,(de):rra:LDX_HL_A:inc e:inc h:endr
            ld   a,(de):rra:LDX_HL_A
            exx:jp Endpr

S_01_
 rept 7:ld a,(de):rra:LDX_HL_A:inc e:inc h:endr
            NEXTZNAK
            exx:jp RETT


S02
 rept 7:ld c,0:ld a,(de):rra:rr c:rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   c,0:ld a,(de):rra:rr c:rra:rr c
            LDX_HL_A:inc l
            ld   a,c:LDX_HL_A
            exx:jp Endpr

S_02
 rept 7:ld c,0:ld a,(de):rra:rr c:rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT


S02_
 rept 7:ld a,(de):rra:srl a:LDX_HL_A:inc e:inc h:endr
            ld   a,(de):rra:srl a:LDX_HL_A
            exx:jp Endpr

S_02_
 rept 7:ld a,(de):rra:srl a:LDX_HL_A:inc e:inc h:endr
            NEXTZNAK
            exx:jp RETT

S03
 rept 7:ld c,0:ld a,(de):rra:rr c:rra:rr c:rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   c,0:ld a,(de):rra:rr c:rra:rr c
            rra:rr c:LDX_HL_A:inc l
            ld   a,c:LDX_HL_A
            exx:jp Endpr

S_03
 rept 7:ld c,0:ld a,(de):rra:rr c:rra:rr c:rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT

S03_
 rept 7:ld a,(de):rra:rra:rra:and #1F:LDX_HL_A:inc e:inc h:endr
            ld   a,(de):rra:rra:rra:and #1F:LDX_HL_A
            exx:jp Endpr

S_03_
 rept 7:ld a,(de):rra:rra:rra:and #1F:LDX_HL_A:inc e:inc h:endr
            NEXTZNAK
            exx:jp RETT



S04
 rept 7:ld c,0:ld a,(de):rra:rr c:rra:rr c:rra:rr c:rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   c,0:ld a,(de):rra:rr c:rra:rr c:rra
            rr   c:rra:rr c:LDX_HL_A:inc l
            ld   a,c:LDX_HL_A

            exx
Endpr
            xor  a:scf:exa:pop af:exa
            pop  hl,bc,de:exx:pop hl,bc,de
            ret


S_04
 rept 7:ld c,0:ld a,(de):rra:rr c:rra:rr c:rra:rr c:rra:rr c:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT

S04_
 rept 7:ld a,(de):rra:rra:rra:rra:and #0F:LDX_HL_A:inc e,h:endr
            ld   a,(de):rra:rra:rra:rra:and #0F
            LDX_HL_A
            exx:jp Endpr

S_04_
 rept 7:ld a,(de):rra:rra:rra:rra:and #0F:LDX_HL_A:inc e,h:endr
            NEXTZNAK
            exx:jp RETT



S05
 rept 7:ld a,(de):ld c,a:xor a:rl c:rla:rl c:rla:rl c:rla:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   a,(de):ld c,a:xor a:rl c:rla
            rl   c:rla:rl c:rla:LDX_HL_A
            inc  l:ld a,c:LDX_HL_A
            exx:jp Endpr

S_05
 rept 7:ld a,(de):ld c,a:xor a:rl c:rla:rl c:rla:rl c:rla:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT

S05_
 rept 7:ld a,(de):rlca:rlca:rlca:and #07:LDX_HL_A:inc e,h:endr
            ld   a,(de):rlca:rlca:rlca:and #07
            LDX_HL_A
            exx:jp Endpr

S_05_
 rept 7:ld a,(de):rlca:rlca:rlca:and #07:LDX_HL_A:inc e,h:endr
            NEXTZNAK
            exx:jp RETT


S06
 rept 7:ld a,(de):ld c,a:xor a:rl c:rla:rl c:rla:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   a,(de):ld c,a:xor a:rl c:rla
            rl   c:rla:LDX_HL_A
            inc  l:ld a,c:LDX_HL_A
            exx:jp Endpr

S_06
 rept 7:ld a,(de):ld c,a:xor a:rl c:rla:rl c:rla:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT

S06_
 rept 7:ld a,(de):rlca:rlca:and 3:LDX_HL_A:inc e,h:endr
            ld   a,(de):rlca:rlca:and 3
            LDX_HL_A
            exx:jp Endpr

S_06_
 rept 7:ld a,(de):rlca:rlca:and 3:LDX_HL_A:inc e,h:endr
            NEXTZNAK
            exx:jp RETT


S07
 rept 7:ld a,(de):ld c,a:xor a:rl c:rla:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            ld   a,(de):ld c,a:xor a:rl c:rla
            LDX_HL_A:inc l:ld a,c
            LDX_HL_A
            exx:jp Endpr

S_07
 rept 7:ld a,(de):ld c,a:xor a:rl c:rla:LDX_HL_A:inc l,e:ld a,c:LDX_HL_A:dec l:inc h:endr
            NEXTZNAK
            exx:jp RETT

S07_
 rept 7:ld a,(de):rlca:and 1:LDX_HL_A:inc e,h:endr
            ld   a,(de):rlca:and 1
            LDX_HL_A
            exx:jp Endpr

S_07_
 rept 7:ld a,(de):rlca:and 1:LDX_HL_A:inc e,h:endr
            NEXTZNAK
            exx:jp RETT




Onum4
■bc-NUM
            push hl,de
            ld   hl,999
            SUB_BC
            jp   c,On99
            RST_  "0"
            jp   nc,One21
            jp   On99
Onum2
■bc-NUMBER
            push hl,de
            ld   hl,9
            SUB_BC
            jp   c,Om21
            RST_  "0"
            jp   nc,One21
Om21
            call ONUMB
One21
            pop  de,hl
            ret
Onum3
■bc-NUMBER
            push hl,de
On99
            ld   hl,99
            SUB_BC
            jp   c,Om1
            RST_  "0"
            jp   nc,One1
            ld   hl,9
            SUB_BC
            jp   c,Om1
            RST_  "0"
            jp   nc,One1
Om1
            call ONUMB
One1
            pop  de,hl
            ret
Onum5
■bc-NUMBER
■a-ЧИСЛО ВЫВОДИМЫХ НУЛЕЙ ЕСЛИ ОНИ БУДУТ
ПЕРЕД ЧИСЛОМ
            push hl,de:exa:push af:exa
            ld   hl,9999
            SUB_BC
            jp   c,Om11
            dec  a:jp m,Om5
            exa
            RST_  "0"
            jp   nc,One2:exa
Om5
            ld   hl,999
            SUB_BC
            jp   c,Om2
            dec  a:jp m,Om2
            exa
            RST_  "0"
            jp   nc,One2:exa
Om2
            ld   hl,99
            SUB_BC
            jp   c,Om31
            dec  a:jp m,Om31
            exa
            RST_  "0"
            jp   nc,One2:exa
Om31
            ld   hl,9
            SUB_BC
            jp   c,Om3
            dec  a:jp m,Om3
            exa
            RST_  "0"
            jp   nc,One2:exa
Om3
            call ONUMB
One2
            exa:pop af:exa:pop de,hl
            ret
Om11
            exa
            ld   h,b
            ld   l,c
            ld   bc,20000
            xor  a:add a,"0"
            sbc  hl,bc
            inc  a
            jp   c,Om4
            ld   bc,10000
            sbc  hl,bc
            inc  a
            jp   c,Om4
            sbc  hl,bc
            inc  a
            jp   c,Om4
            sbc  hl,bc
            inc  a
            jp   c,Om4
            sbc  hl,bc
            inc  a
            jp   c,Om4
            inc  a
            jp   Om41
Om4
            ld   bc,10000
            add  hl,bc
Om41
            ld   b,h
            ld   c,l
            RST_
            jp   nc,One2
            exa:ld a,4
            jp   Om5
ONUMB
■bc-NUMBER
            push hl,de
            ld   h,b
            ld   l,c
            ld   bc,1000
            xor  a:dec a
            inc  a:sbc hl,bc:jr nc,$-3
            add  hl,bc
            and  a:ld e,a:jr z,$+9
            add  a,"0"
            RST_
            jr   nc,O_NB1

            ld   bc,100
            xor  a:dec a
            inc  a:sbc hl,bc:jr nc,$-3
            add  hl,bc
            inc  e:dec e:jr nz,$+6
            and  a:ld e,a:jr z,$+9
            add  a,"0"
            RST_
            jr   nc,O_NB1

            ld   bc,10
            xor  a:dec a
            inc  a:sbc hl,bc:jr nc,$-3
            add  hl,bc
            inc  e:dec e:jr nz,$+5
            and  a:jr z,$+9
            add  a,"0"
            RST_
            jr   nc,O_NB1
            ld   a,l:add a,"0"
            RST_
O_NB1
            pop  de,hl
            ret





────────────────────
ТОЖЕ ВХОДИТ В БЛОК Outtxt
Tood5
            ld   a,(Mode+1):and a
            jr   z,Tood4
            inc  hl
Outtxt
■hl-адрес текста
■retFC-OFF конец текста
■FC-ON конец окна или экрана
■CODES:ET-конец текста,CR-перевод строки
■2,3,4,5,6-табуляция
■1-код останавливающий вывод текста на
   момент дописывания чего-нибудь
            ld   a,(hl):inc hl
            cp   ET:ret z
            cp   CR:jrz Tood
            cp   7:jr c,Tood3
            RST_
            jp   c,Outtxt;NO INCIDENT
            dec  hl
            and  a:jr z,Tood5
            dec  a:scf:ret z;END SCR
            dec  a:scf:ret z;END WIN

■peЖИmbЫBOДaTEKCTA bOKHE,<>0-cПEPEH
■OCOM,=0-БE3 ПEPEHOCA
Mode        ld   a,0:and a
С ПЕРЕНОСА
            jr   nz,Tood2
БЕЗ ПЕРЕНОСА
Tood4
            ld   a,(hl):inc hl
            cp   ET:retz
            cp   CR:jpnz $-7
            dec  hl:jp Outtxt
Tood
■CHANGE Y=Y+8,ifoutOF WIN THAN retnc
■,CORD DOESNT STORE
            ld   a,(Cord+1)
            add  a,8
            push bc
            ld   c,a
            ld   a,(Eyw+1):ld b,a
            ld   a,c:cp b
            pop  bc
            ccf:ret c
            ld   (Cord+1),a
            xor  a:ld (Cord),a
FLAGOT      jp   Outtxt;#C3,#C9
Tood2
            ld   a,(Cord+1)
            add  a,8
            push bc
            ld   c,a
            ld   a,(Eyw+1):ld b,a
            ld   a,c:cp b
            pop  bc
            ccf:ret c
            ld   (Cord+1),a
            xor  a:ld (Cord),a
            jp   Outtxt
Tood3
ТАБУЛЯЦИИ
            dec  a
            or   a:retz
            dec  a
            jrnz $+10
CXTAB1      ld   a,0
            ld   (Cord),a
            jp   Outtxt
            dec  a
            jrnz $+10
CXTAB2      ld   a,0
            ld   (Cord),a
            jp   Outtxt
            dec  a
            jrnz $+10
CXTAB3      ld   a,0
            ld   (Cord),a
            jp   Outtxt
            dec  a
            jrnz $+10
CXTAB4      ld   a,0
            ld   (Cord),a
            jp   Outtxt
            dec  a
            jrnz $+10
CXTAB5      ld   a,0
            ld   (Cord),a
            jp   Outtxt

────────────────────
Hlt
ИЗМЕРЯЕМ ДЛИННУ ТЕКСТА/СТРОКИ В ПИКСЕЛ.
■b-СИМВОЛ ДО КОТОРОГО ИЗМЕРЯТЬ
■hl-ТЕКСТ
■retina, ЕСЛИ ПРЕВЫШАЕТ 255, ТО ВЫХОД
С УСТАНОВЛЕННЫМ В А 255
            push de,bc
            ld   c,0
            ld   d,SZTB.h
HlT2
            ld   a,(hl)
            cp   CR:jrz HlT1
            cp   ET:jrz HlT1
            cp   b
            jr   z,HlT1
            ld   e,a
            ld   a,(de)
            add  a,c
            jr   c,HlT3
            jr   z,HlT3
            inc  hl
            ld   c,a
            jp   HlT2
HlT3
            ld   c,#FF
HlT1
            ld   a,c
            pop  bc,de
            ret



────────────────────
Hltxt
ИЗМЕРЯЕМ ДЛИННУ ТЕКСТА/СТРОКИ В ПИКСЕЛ.
■hl-ТЕКСТ
■retina, ЕСЛИ ПРЕВЫШАЕТ 255, ТО ВЫХОД
С УСТАНОВЛЕННЫМ В А 255
            push hl,de,bc
            ld   c,0
            ld   d,SZTB.h
Hl2
            ld   a,(hl)
            cp   CR:jrz Hl1
            cp   ET:jrz Hl1
            cp   b
            jr   z,Hl1
            ld   e,a
            inc  hl
            ld   a,(de)
            add  a,c
            jr   c,Hl3
            jr   z,Hl3
            ld   c,a
            jp   Hl2
Hl3
            ld   c,#FF
Hl1
            ld   a,c
            pop  bc,de,hl
            ret











SPECSYM
ВЫВОД СО СПЕЦ СИМВОЛАМИ
■a-КОД
СПЕЦ СИМВОЛЫ С КОДА 20 ПО 32 ВКЛЮЧИТ.
            cp   #21
            jr   c,$+6
            RST_
            ret
            sub  30
            add  a,a
            add  a,a
            push hl,de
            ld   l,a
            ld   h,0
            ld   de,SPECTB
            add  hl,de
            rept 3:ld a,(hl):inc hl:RST_:endr
            ld   a,(hl):RST_
            pop  de,hl
            ret
SPECTB
            db   "ENT "
            db   "SS  "
            db   "SP  "

