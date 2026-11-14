■CLINW      ■READKEY       ■TCODE
■TOCODE     ■TOPORT        ■SCROL
■DELMK      ■TESTM2        ■TESTM_
■TESTM      ■CHOOSE        ■DELCH
■MARKO      ■MARKo         ■LIST1
■LIST0      ■LIST          ■FLIST1
■FLIST      ■PLIN          ■STOREW
■RESTORW    ■PINFO2        ■PINFO
■RETSCR     ■HIDESCR       ■TESTSZ
■LINE2      ■HIDEP1 2 3 4 5 6 7
■AMPLAN     ■NATISNU       ■KOLLIN
■FROMLIN    ■OPENER        ■OPENER_L
■RND        ■RNDW          ■RNDD
■RNDK1      ■RNDK2         ■RNDK3
■RNDT2      ■RNDT1         ■NORT
■RANDTT     ■NUMSHIP       ■PINFOL
■PINFOL2    ■INWIN





ВЫВОД СПРАЙТА В ОКНЕ
■hl-СПРАЙТ 4Х4
INWIN
            push hl
            ld   a,(Byw+1):add a,#05:ld l,a
            ld   a,(Bxw+1):add a,#05:ld e,a
            ld   h,TBXX.h
            ld   d,(hl):inc h
            ld   a,(hl):inc h
            ld   l,e
            add  a,(hl)
            ld   e,a
            pop  hl
            ld   a,32
I_W1
            exa
            ld   a,e
            ldi:ldi:ldi:ldi
            ld   e,a
            NEXTLINEDE
            exa:dec a:jpnz I_W1
            ret

CLINW
 СТЕРЕТЬ В ОКНЕ ПО ЗНАКОМЕСТАМ РАСПОЛОЖЕ
 ННОЕ ОКНО
 ВСЕ ДАННЫЕ В Bxyw,Exyw
            ld   a,(Byw+1):add a,#0D:ld l,a
            ld   a,(Bxw+1):add a,#05:ld e,a
            ld   h,TBXX.h
            ld   d,(hl):inc h
            ld   a,(hl):inc h
            ld   l,e
            add  a,(hl)
            ld   e,a
            ld   a,(Exw+1)
            rra
            rra
            rra
            and  #1F
            sub  31
            neg
            add  a,a
            ld   c,a
            ld   b,0
            ld   hl,JJ7_7
            add  hl,bc

            ld   a,(Eyw+1)
            sub  #0D
            rra
            rra
            rra
            and  #1F
            ld   b,a

            ld   a,(INVERSE):rra
            ld   a,#FF:jr nc,$+3:inc a
            ld   (CW00+1),a

            ld   (STK9+1),sp
CW1
            ld   sp,STKO
CW00        ld   a,#FF
CW2
            rept 8:ld c,e:jp (hl):endr
            ld   a,e:add a,32:ld e,a:jr c,$+6
            ld   a,d:sub 8:ld d,a
            djnz CW1

STK9        ld   sp,0
            ret

JJ7_7
            rept 29:ld (de),a:inc e:endr
            ld   (de),a
            ld   e,c:inc d
            ret

            dw   0
STKO
            dw   CW2+2
            dw   CW2+4
            dw   CW2+6
            dw   CW2+8
            dw   CW2+10
            dw   CW2+12
            dw   CW2+14
            dw   CW2+16
            dw   CW2+18

READKEY
 ЧТЕНИЕ КОД КЛАВИШИ НЕ ВЫХОДИТ ПОКА НЕ
 НАЖТО ЧТО НИБУДЬ
            push bc,hl,de
            ld   b,10:halt:djnz $-1
            ld   bc,#7FFE
R_K1
            ld   e,#80
            in   a,(c)
            rept 5:rlc e:rrca:jr nc,R_K2:endr
            rrc  b:jr R_K1
R_K2
            ld   c,e
            call TCODE
            pop  de,hl,bc:ret

TCODE
■b-PORT,c-MASK
■reta-CODE
            ld   hl,TBKP-2
            INC_HL 2:ld a,(hl):cp b
            jr   nz,$-4
            inc  hl
            ld   a,(hl):dec hl:cp c
            jr   nz,$-10
            ld   bc,0-TBKP:add hl,bc
            ld   a,l:srl a:add a,29
            ret














TOCODE
 ПРЕОБР. ПОРТЫ В КОДЫ
■bc-КОДЫ,de-ПОРТЫ
            push hl
T_R2
            ld   a,(bc):and a:jr z,T_R1
            push bc
            ld   a,(de)
            cp   #7F
            jr   nc,T_R4
            add  a,"0"
            jr   T_R3
T_R4
            cp   #80:ld a,"N":jr z,T_R3
            ld   a,(de)
            cp   #81:ld a,"Y":jr z,T_R3
            ld   a,(de)
            ld   b,a:inc de
            ld   a,(de)
            ld   c,a:dec de
            call TCODE
T_R3
            INC_DE 2
            pop  bc
            ld   (bc),a:inc bc
            jr   T_R2
T_R1
            pop  hl
            ret















TOPORT
 ПРЕОБР. КОДЫ В ПОРТЫ И МАСКИ
■bc-КОДЫ,de-ПОРТЫ
            push hl
T_T2
            ld   a,(bc):and a:jr z,T_T1
            sub  29:add a,a
            add  a,TBKP.b:ld l,a
            ld   a,TBKP.h:adc a,0:ld h,a
            ld   a,(de)
            cp   #7F:jr c,T_T6:jr z,T_T4
            cp   #82:jr nc,T_T4
            ld   a,(bc)
            cp   "Y":ld a,#81:jr z,T_T5
            ld   a,(bc)
            cp   "N":ld a,#80:jr z,T_T5
T_T6
            ld   a,(bc)
            sub  "0"
T_T5
            ld   (de),a
            inc  de:jr T_T3
T_T4
            ld   a,(hl)
            ld   (de),a:inc de,hl
            ld   a,(hl)
            ld   (de),a
T_T3
            inc  de,bc
            jr   T_T2
T_T1
            pop  hl
            ret













Sct3
            pop  de
            ld   (Mcoord),de
            call OUTC
            ret


SCROL
■hl-ИНДЕКС В СПИСКЕ С КОТОРОГО ВИДИМ
 СПИСОК
■a-СМЕЩЕНИЕ, КОТ. НУЖНО ОТСТУПИТЬ
 ЧТО Б НЕ СТИРАТЬ
■rethl-ИНДЕКС
 НАДО ЗАДАТЬ АДРЕС В ПЕРЕМЕННОЙ PROOUT
 КОТ. ВЫХОДИТ НА ПРОЦЕДУРУ ВЫВОДА В ОКНЕ
 ВСЕГО ТЕКСТА
 ТАК ЖЕ НАДО ЗАДАТЬ EINDX = ЧИСЛУ СТРОК
            ld   (SCRLS+1),a
            ld   c,a

            push bc,hl
            PAGE  #17
            ld   hl,#5800
            ld   de,#D800
            ld   bc,#0300
            ldir
            PAGE
            pop  hl,bc

 ФЛАЖОК ЧТО ЕЩЕ НЕ БЫЛО ПЕРЕПЕЧАТКИ
 ЭКРАНА
            ld   a,(Eyw+1):sub c
            ret  c:ret z
            ld   (Amlin+1),a

            rra
            rra
            rra
            and  %00011111
            ld   c,a
            ld   de,(Mcoord)
            push de
            call WOST
Sct1
            call Tfire
            jr   z,Sct3
            ld   a,c
            and  a
            jr   z,Sct1
            ld   a,(Mcoord+1)
            ld   d,a
            ld   a,(Byw+1)
            ld   e,a
            ld   a,(Eyw+1)
            srl  a:add a,e:ld b,a
            ld   a,(SCRLS+1):srl a:add a,b
            cp   d
            jp   c,Sct2
■CAT UP, SCRL DOWN
            ld   a,l:or h
            jr   z,Sct1
            dec  hl
            jp   Sct28
Sct2
■CAT DOWN, SCRL UP
EINDX       ld   de,0
            EXD
            SUB_DE
            ld   b,0:sbc hl,bc
            EXD
            jr   z,Sct1:jr c,Sct1
            inc  hl
Sct28
            push bc,hl
 ПЕРЕПЕЧАТКА БЫЛА
            PAGE  #17
            ld   hl,#4000
            ld   de,#C000
            ld   bc,#1800
            ldir
            PAGE  #18

            halt

Amlin       ld   a,0
■KOЛИЧ CTPOK ДЛЯ CTИp* 8
            call Clinwin

            pop  hl:push hl

 ПРОЦЕДУРА ВЫВОДА В ОКНЕ ВСЕГО СПИСАК
 В ЗАВИСИМОСТИ ОТ ИНДЕКСА В hl
PROOUT      call 0
            pop  hl
            call RETSCR+3;БЕЗ ВЫВОД КУРСОРА
            pop  bc

            jp   Sct1















 УДАЛИТЬ ПОСЛЕДНЮЮ ПОМЕТКУ
■a-НОМЕР ЕЕ,ix-ВЕКТОР
DELMK
            inc  a:ret z:dec a
            push af
            call TESTM_
            call WOST
            pop  af:call DELCH:jp OUTC

TESTM2
 ПОЛУЧАЕМ Y КООРДИНАТУ
            ld   a,(Mcoord+1)
            ld   c,a
            ld   a,(ix+1)
            rlca
            rlca
            rlca
            and  #F8
 СМЕЩАЕМ К СТРОКАМ МЕНЮ
            add  a,e
            ld   b,a
            ret

TESTM_
 ТОЛЬКО ДЛЯ ОКОН СО СМЕННЫМ РАЗМЕРОМ
 ОПРЕДЕЛЯЕМ КОЛИЧЕСТВО ВИДИМЫХ ПУНКТОВ
■d-КОЛ.ПУНКТОВ ВСЕГО В СПИСКЕ
■ix-ВЕКТОР
            ld   a,(ix+3)
            rlca
            rlca
            rlca
            sub  e:sub 5
            and  #F8
            sla  d
            sla  d
            sla  d
            cp   d
            ret  nc
            ld   d,a
            ret


TESTM
■ix-ВЕКТОР
■e-СМЕЩЕНИЕ ПО ВЕРТИКАЛИ ОТ НАЧАЛА ОКНА
 И ДО НАЧАЛА МЕНЮ В ПИКСЕЛЯХ
■d-КОЛ.ПУНКТОВ*8
■ret:
■FC-ON ВЫЛЕТ КАКОЙ ТО
■c-НОМЕР ПУНКТА
            call TESTM2
            ld   a,c
            sub  b
            ret  c;СЛИШКОМ ВЫСОКО
            cp   d;КОЛ.ПУНКТОВ*ВЫСОТА
            ccf
            ret  c;СЛИШКОМ НИЗКО
            rrca
            rrca
            rrca
            and  #1F:ld c,a
            ret






CHOOSE
 ВЫВОД ПОМЕТКИ
■ix-ВЕКТОР ОКОШКА
■e-СМЕЩЕНИЕ ПО ВЕРТИКАЛИ ОТ НАЧАЛА ОКНА
 И ДО НАЧАЛА МЕНЮ В ПИКСЕЛЯХ
■d-КОЛ.ПУНКТОВ*8
■retd-НОМЕР ПУНКТА
            call TESTM:ret c:ld d,a:jr $+7
DELCH
 УДАЛЕНИЕ ПОМЕТКИ
■a-НОМЕР ПУНКТА
            ld   d,a:call TESTM2:ld a,d
            rlca
            rlca
            rlca
            add  a,b
            cp   192-8
            ret  nc;ВЫЛЕТ СНИЗУ
            ld   b,a
 В "D"-НОМЕР ПУНКТА
 В "B"-РЕАЛЬНАЯ КООРДИНАТА Y ПУНКТА


 АДРЕС НА ЭКРАНЕ
            ld   a,(ix+0);КООРД.X ОКНА
            and  a
            jp   p,$+4:xor a
            rlca
            rlca
            rlca
            ld   c,a

            ld   h,TBXX.h
            ld   l,b
            ld   b,(hl):inc h
            ld   a,(hl):inc h
            ld   l,c
            or   (hl)
            ld   l,a
            ld   h,b

            ld   b,(ix+2)
            ld   a,(ix+0):add a,b
            sub  #21
            jr   c,Q_2
            sub  b:cpl:dec a
            ld   e,%10101010
            jr   Q_1
Q_2
            ld   a,b:sub 2:ld e,0
            bit  7,(ix+0):jr z,Q_1:inc a
            add  a,(ix+0):ld e,%01010101
Q_1
            ld   b,a

            PAGES PGKRT
            call CHHS
            PAGES
            ret














MARKO
 МАРКИРУЕТ СТРОКУ И СТИРАЕТ СТАРЫЙ МАРК
 ТОЛЬКО ДЛЯ РАСТЯГИВАЕМЫХ ОКОН!!!!
■a-НОМЕР ПУНКТА
■d-КОЛ. ВИДИМЫХ ПУНКТОВ,Е-ВЕРХНЕЕ
■hl-ШОУ АДРЕС ОКНА
 СМЕЩЕНИЕ ДО ПЕРВОЙ СТРОКИ
■ix-ВЕКТОР
■retFZ-ON ЕСЛИ НЕ НАДО ЗАПОМИНАТЬ
 НОВЫЙ НОМЕР ПУНКТА
■reta-НОВЫЙ НОМЕР ПУНКТА
            push af
            push de:EXD:call LASTOBJ
            SUB_DE
            pop de
            jr   nz,MO1
            call TESTM_:call TESTM
            jr   nc,$+5
MO1         pop  af:xor a:ret
            pop  af:cp c:ret z
            call WOST
            inc  a:jr z,$+8:dec a
            push de
            call DELCH
            pop  de
            call CHOOSE
            call OUTC
            xor  a:inc a:ld a,d:ret


MARKo
 МАРКИРУЕТ СТРОКУ И СТИРАЕТ СТАРЫЙ МАРК
 ТОЛЬКО ДЛЯ НЕ РАСТЯГИВАЕМЫХ ОКОН!!!!
■a-НОМЕР ПУНКТА
■d-КОЛ. ВИДИМЫХ ПУНКТОВ,Е-ВЕРХНЕЕ
■hl-ШОУ АДРЕС ОКНА
 СМЕЩЕНИЕ ДО ПЕРВОЙ СТРОКИ
■ix-ВЕКТОР
■retFZ-ON ЕСЛИ НЕ НАДО ЗАПОМИНАТЬ
 НОВЫЙ НОМЕР ПУНКТА
■reta-НОВЫЙ НОМЕР ПУНКТА
            push af
            push de:EXD:call LASTOBJ
            SUB_DE
            pop de
            jr   nz,MO2
            call TESTM
            jr   nc,$+5
MO2         pop  af:xor a:ret
            pop  af:cp c:ret z
            call WOST
            inc  a:jr z,$+8:dec a
            push de
            call DELCH
            pop  de
            call CHOOSE
            call OUTC
            xor  a:inc a:ld a,d:ret








LIST1
 ВЫВОД ТЕКСТА ПО ИНДЕКСУ В aС 0
■hl-ВЕСЬ ТЕКСТ, РАЗД. 1
            call FLIST1:jp Outtxt

LIST0
            call FLIST:jp OTXT

LIST
 ВЫВОД ТЕКСТА ПО ИНДЕКСУ В aС 0
■hl-ВЕСЬ ТЕКСТ, РАЗД. 0
            call FLIST:jp Outtxt

FLIST1
            push af
            ld   a,CR:ld (RAZD+1),a
            pop  af
            call FLIST
            ld   a,ET:ld (RAZD+1),a
            ret
FLIST
 ПОИСК ТЕКСТА ПО ИНДЕКСУ
            push de,bc
            inc  a:ld e,a:ld b,#FF
RAZD        ld   a,ET
            cpir:dec e:jp nz,$-3
            pop  bc,de:ret


PLIN
 ВЫВОД ИНФО О ПЛНЕТЕ
■hl,de-ДАННЫЕ ГЕНЕРАЦИИ СИСТЕМЫ

            ld   a,h:cp 4
            jr   nz,U_1
 СТРОЙ НЕИЗВЕСТНЫЙ
            ld   a,4
U_3
            ld   hl,STROY:call LIST
            ld   a,(Cord+1):add a,8:ld h,a
            ld   l,#10
            ld   (Cord),hl
            RST_  "-"
            ld   a,(Cord+1):add a,8:ld h,a
            ld   l,#22
            ld   (Cord),hl
            RST_  "-"
            ret

U_1
 ПОЛУЧЕНИЕ ДАННЫХ О ПЛАНЕТЕ
 ЕСЛИ НЕОБИТАЕМАЯ ТО НИКАКИХ УРОВНЕЙ
            cp   3:jr z,U_3

            push hl

            ld   hl,STROY:call LIST
 ТИП
            ld   a,(Cord+1):add a,8:ld h,a
            ld   l,#12
            ld   (Cord),hl
            ld   a,e:ld hl,TYPE
            call LIST
 УРОВЕНЬ
            pop  bc
            ld   a,(Cord+1):add a,8:ld h,a
            ld   l,#22
            ld   (Cord),hl
            ld   b,0:xor a:call Onum5
            ret






STOREW
 ЗАПОМНИТЬ ДАННЫЕ ОКНА
            ld   a,(Bxw+1)
            ld   (BXW+1),a
            ld   a,(Byw+1)
            ld   (BYW+1),a
            ld   a,(Bxh+1)
            ld   (BXH+1),a
            ld   a,(Byh+1)
            ld   (BYH+1),a
            ld   a,(Exw+1)
            ld   (EXW+1),a
            ld   a,(Eyw+1)
            ld   (EYW+1),a
            ld   a,(Cord)
            ld   (_Cord+1),a
            ld   a,(Cord+1)
            ld   (_Cord2+1),a
            ld   a,(Mode+1)
            ld   (_Mode+1),a
            ret

RESTORW
 ВОССТАНОВИТЬ ДАННЫЕ ОКНА
BXW         ld   a,0
            ld   (Bxw+1),a
BYW         ld   a,0
            ld   (Byw+1),a
BXH         ld   a,0
            ld   (Bxh+1),a
BYH         ld   a,0
            ld   (Byh+1),a
EXW         ld   a,0
            ld   (Exw+1),a
EYW         ld   a,0
            ld   (Eyw+1),a
_Mode       ld   a,0
            ld   (Mode+1),a
_Cord       ld   a,0
            ld   (Cord),a
_Cord2      ld   a,0
            ld   (Cord+1),a
            ret



PINFO2
 ДАННЫЕ О ПЛАНЕТЕ НАХОЖДЕНИЯ
            ld   hl,(PLACE)
            ld   de,(PLACE+2)
            ld   a,(PLANET)
PINFO
 ДАЧА ИНФО О ПЛАНЕТЕ НА СИСТЕМЕ
■hl,de-ДАННЫЕ СИСТЕМЫ
■a-НОМЕР ПЛАНЕТЫ С 0
■ret
■a=0-В СИСТЕМЕ НЕТ ПЛАНЕТ
■a-КОЛ. ПЛАНЕТ
■l-УРОВЕНЬ 1-16
■h-СТРОЙ 0-4
■e-ТИП 0-3
            exa:PAGES PGKRT:exa
            call PINFO_
            exa:PAGES:exa
            ret

ДЛЯ ВЫЗОВА ИЗ СТРАНИЦЫ ЯЗЫКА
PINFOL2
            call PINFO2
            exa:PAGES PGLANG:exa
            ret
ДЛЯ ВЫЗОВА ИЗ СТРАНИЦЫ ЯЗЫКА
PINFOL
            call PINFO
            exa:PAGES PGLANG:exa
            ret




RETSCR
            call OUTC:PAGE:ret

HIDESCR
            push hl,de,bc
            ld   a,1
            ld   (FWOST+1),a
            PAGE  #17
            ld   hl,#4000
            ld   de,#C000
            ld   bc,#1B00
HS1
            rept 256:ldi:endr
            jp   pe,HS1
            call WOST
            pop  bc,de,hl
            PAGE  #18:ret







TESTSZ
■hl-НОМЕР ОБЪЕКТА
■retFC-OFF ЕСЛИ ВЫЛЕТ ОКНА
            xor  a:call TOOBJ
            ld   e,(hl):inc hl
            bit  7,e:ret nz
            ld   d,(hl):inc hl
            bit  7,d:ret nz
            ld   a,(hl):inc hl
            ld   h,(hl)
            ld   l,a
            ld   a,l:add a,e:cp 33:ret nc
            ld   a,h:add a,d:cp 25:ret nc
            ld   a,l:cp 4:ccf:ret nc
            ld   a,h:cp 4:ccf:ret








LINE2
            jp   $+3
            ret

LINE2_
            ld   hl,0
            ld   a,1:ld (Mode+1),a
            ld   a,(INVERSE):push af
            ld   a,#80:ld (INVERSE),a
            call Outln2
            pop  af
            ld   (INVERSE),a
            ld   a,3:ld (Cord),a
            ld   bc,(TIME)
            ld   a,b:and #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0":RST_
            ld   a,b:and #0F:add a,"0"
            RST_
            ld   a,c:and #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0":RST_
            ld   a,c:and #0F:add a,"0"
            RST_

            RST_  ":"

            ld   a,(TIME+2)
            ld   c,a
            and  #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0":RST_
            ld   a,c:and #0F:add a,"0"
            RST_

            RST_  ":"

            ld   a,(TIME+3)
            ld   c,a:and #F0
            rrca
            rrca
            rrca
            rrca
            add  a,"0":RST_
            ld   a,c:and #0F:add a,"0"
            RST_
            ret












HIDEP1
 СКРЫТЬ ВСЕ
            ld   hl,RET_
            ld   (ZADACHA+1),hl
            ld   a,1
            ld   (ACTIV+1),a
            rept 5:halt:endr
            ret
HIDEP2
 ЗАКРЫТЬ ОКНА
            ld   hl,RET_
            ld   (ZADACHA+1),hl
            ld   ix,Sur1
HP_2
            ld   h,(ix+1)
            dec  h:ret z:inc h
            ld   l,(ix+0)
            inc  hl:ld a,(hl):inc hl
            ld   h,(hl)
            ld   l,a
            push hl
            call TOOBJ4
            ld   a,(hl):and %11000000
            pop  de
            inc  ix,ix
            jr   z,$+8
            ld   a,(hl):cpl:and %01100000
            jr   nz,HP_2
            call ERSOBJ2:dec ix,ix
            jp   HP_2


HIDEP3
 ЗАПОМНИТЬ СРЕДУ
            ld   ix,Objvec
            ld   de,16
H_11
            ld   a,(ix+0)
            cp   #80:ret z
            ld   a,(ix+0)
            ld   (ix+8),a
            ld   a,(ix+1)
            ld   (ix+9),a
            ld   a,(ix+2)
            ld   (ix+10),a
            ld   a,(ix+3)
            ld   (ix+11),a
            add  ix,de
            jr   H_11
HIDEP4
 РАССТАВИТЬ
            jp   SETCRDS
HIDEP5
 УСТАНОВКИ СРЕДЫ
            ld   hl,WSETS_
            jp   NEWOBJ
HIDEP6
 УСТАНОВКИ ИГРЫ
            ld   hl,WSETG_
            jp   NEWOBJ
HIDEP7
 ВОССТАНОВИТЬСЯ
            ld   hl,WWOS_
            jp   NEWOBJ







AMPLAN
 КОЛИЧЕСТВО ПЛАНЕТ В СИСТЕМЕ
            ld   hl,(WHERE)
            ld   de,(WHERE+2)
            ld   a,h
            xor  l
            xor  e
            xor  d
            and  7:dec a
            ret  p:xor a:ret


NATISNU
■de-ТЕКУЩАЯ КНОПКА
■hl-ДРУГАЯ КНОПКА
            push de
            ld   e,l
            ld   d,h
            call TOOBJ4
            res  0,(hl)
            ld   h,d
            ld   l,e
            call WOST:call Outbut:call OUTC
            pop  hl
            ld   e,l
            ld   d,h
            call TOOBJ4
            set  0,(hl)
            ld   h,d
            ld   l,e
            call WOST:call Outbut:call OUTC
            ret






KOLLIN
 СЧИТАЕТ КОЛИЧЕСТВО СТРОК В ТЕКСТЕ
■hl-ТЕКСТ
■retde-КОЛ.
            ld   de,0
            xor  a:ld (Cord),a
D_I1
            ld   a,#08
            ld   (Cord+1),a
            push de
            call VTXT
            pop  de
            inc  de
            jp   nc,D_I1
            ret
FROMLIN
 ВЫВОД ТЕКСТА С НОМЕРА ЛИНИИ
■e-НОМЕР
■hl-ТЕКСТ
■bc-КООРД. ВЫВОДА
            ld   (Cord),bc
            ld   a,e:and a
            jp   z,OTXT
D_I2
            push de,bc
            call VTXT
            pop  bc,de
            ld   (Cord),bc
            ret  c
            dec  e:jp nz,D_I2
            jp   OTXT


OPENER
 ГОТОВИТ ОКНО ОШИБКИ И ВЫВОДИТ ЕГО
■a-НОМЕР ОШИБКИ С 0
            push af
            ld   (NERR+1),a
            ld   hl,WERR_
            call NEWOBJ
            pop  af:ret

OPENER_L
            push af
            PAGES PGNORM
            pop  af
            call OPENER
            PAGES PGLANG
            ret







────────────────────────────────────────

ГЕНЕРАТОРЫ
RND
            exx
            ld   hl,Sdo
            jp   RNDO
RNDW
            exx
            ld   hl,Sdw
            jp   RNDO
RNDK1
            exx
            ld   hl,Sdk1
            jp   RNDO
RNDK2
            exx
            ld   hl,Sdk2
            jp   RNDO
RNDK3
            exx
            ld   hl,Sdk3
            jp   RNDO
RNDT2
            exx
            ld   hl,Sdt2
            jp   RNDO
RNDT1
            exx
            ld   hl,Sdt1
            jp   RNDO
Sdw
            db   7,8,0
Sdo
            db   101,0,0
Sdt2
            db   44,0,0
Sdt1
            db   21,0,0
Sdk1
            db   247,0,0
Sdk2
            db   93,0,0
Sdk3
            db   29,0,0
RNDO
■inhlADR OF SEED
            ld   c,(hl)
            inc  hl
            ld   b,(hl)
            inc  hl
            ld   a,(hl)
            push hl
            ld   e,a
            ld   h,b
            ld   l,c
            dec  hl
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            add  hl,hl
            adc  a,0
            EXD
            ld   h,b
            ld   l,c
            ADDHLHL 3
            add  hl,de
            adc  a,0
            add  hl,bc
            adc  a,0
            add  hl,bc
            adc  a,0
            add  hl,bc
            adc  a,0
            ld   d,h
            ld   e,l
            ld   l,h
            ld   h,a;0
            ld   b,0
            ld   c,e
            SUB_BC
            sbc  a,0
            EXD
            SUB_DE
            sbc  a,0
            dec  hl
            EXD
            pop  hl
            ld   (hl),a
            dec  hl
            ld   (hl),d
            dec  hl
            ld   (hl),e
            push de
            exx
            pop  hl
            ret
















NORT
НЕТ ПЛАНЕТ ВСЮ ТАБЛИЦУ ЗАБИТЬ ПУСТЫМИ
ДАННЫМИ

            ld   hl,TWRS
            ld   de,TWRS+1
            ld   bc,TKOL*2-1
            ld   (hl),0:ldir:ret

RANDTT
ГЕНЕРИЛКА ТАБЛИЦЫ КОЛИЧ. ТОВАРОВ И ЦЕН
            call PINFO2
            jr   z,NORT

            ld   a,h
            cp   4:jr z,NORT
            ld   (PSTROY+1),a

            ld   a,e
            ld   (PTYPE+1),a

            ld   hl,(PLACE+2)
            ld   (Sdo),hl
            ld   a,(TIME+2)
            and  %11111100
            ld   c,a
            ld   a,(PLANET)
            xor  c
            ld   (Sdo+2),a
ТОВАРЫ ПРОПУСКАЯ АРТЕФАКТЫ, технологии и
уникумы
            ld   hl,SPECTO
            exx
            ld   ix,CENS2
            ld   hl,TWRS+1
            ld   b,TKOL-3
RTB1
            push hl
            exx:push hl:exx
            call RND
            exx:pop hl:exx
            ld   a,l
            and  #07
            bit  7,l
            jr   z,$+4
            neg
            add  a,(ix+0)
            ld   e,h
            pop  hl
            ld   d,a
            exx
PTYPE       ld   a,0
            cp   (hl)
            inc  hl
            ld   e,0
            jr   nz,$+4
            ld   e,8
            exx
            ld   a,d
            exx
            sub  e
            exx
            jr   z,$+4
            jr   nc,$+4
            ld   a,5
            ld   (hl),a
            dec  hl

            ld   a,(ix+1)
            and  a
            ld   d,#3F
            jr   z,RTB3
            dec  a
            jr   nz,RTB4
            ld   a,e
            and  %11000000
            ld   d,#BF
            jr   z,RTB3
            ld   d,#3F
            jr   RTB3
RTB4
            dec  a
            ld   d,#BF
            jr   z,RTB3
PSTROY      ld   a,0:and a
            jr   nz,RTB3
            set  7,e
            res  5,e
            res  4,e
RTB3
            ld   a,e
            and  d
            ld   c,a
            res  7,c
ZAPRET      and  #80
            ld   d,a
            ld   a,c
            exx
            add  a,e
            sub  10;ДЛЯ ТОГО что б БЫЛО
БОЛЬШЕ ПУСТЫХ СТРОЧЕК
            jr   nc,$+3
            xor  a
            exx
            or   d
            ld   d,a
            ld   a,(ZAPRET+1):xor #80
            and  (hl):or d
            ld   (hl),a
            inc  hl
ИЗМЕНЕНИЕ ЦЕНЫ ОТ КОЛИЧЕСТВА НА СТАНЦИИ
ПРЯМО ПРОПОРЦИОНАЛЬНО
            rra
            and  #3F
            cp   8:jrc $+4:ld a,8
            sub  (hl)
            jrc  $+4:ld a,#FB
            neg
            ld   (hl),a
            inc  hl,hl
            inc  ix,ix
            dec  b
            jp   nz,RTB1
            dec  hl
            ld   (hl),0:inc hl
            ld   a,(ix+0)
            ld   (hl),a:inc hl
            ld   (hl),0:inc hl
            ld   a,(ix+2)
            ld   (hl),a:inc hl
            ld   (hl),0:inc hl
            ld   a,(ix+4)
            ld   (hl),a
            ret





RNDD
            push bc
            ld   hl,(RNDD1)
            ld   de,(RNDD2)
            ld   c,h
            ld   b,l
            inc  hl
            inc  h
            add  hl,de
            ld   a,e
            adc  a,l
            ld   c,a
            add  hl,bc
            ld   a,l
            xor  c
            xor  #75
            ld   l,e
            ld   e,a
            ld   a,h
            xor  b
            xor  #A7
            ld   h,d
            ld   d,a
            ld   (RNDD1),hl
            ld   (RNDD2),de
            ld   a,d
            xor  e
            xor  h
            xor  l
            pop  bc
            ret

NUMSHIP
ПОЛУЧЕТ НОМЕР КОРАБЛЯ ИЛИ СКИМЕРА
ТЕКУЩГО ВЫБРАННОГО В СПИСКЕ
■bc-НОМЕР
            PAGES PG3D
            ld   bc,(SHIPIND+1)
            ld   a,(FROMS+1)
            add  a,c
            ld   c,a
            ld   b,0
            PAGES PGLANG
            ret

