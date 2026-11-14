;ПРОЦЕДУРА ВЫВОДА ВОКС. СПРАЙТА С
;С МАСШТАБИРОВАНИЕМ И ПРОЗРАЧНОСТЬЮ
;ПОРИТ РЕГ. I

        INCL "EQUS"





        ORG #C000
        JP Vox_
        JP TAKSPD_
        JP OUTALL_
        JP NEWPOS_
        JP NEWPSS_
        JP RETURN_
        JP RRT_
        JP RLT_
        JP D3D2_


OUTALL_
        CALL CLER
        CALL LAND
        CALL SKY
        CALL MOVING
        JP NIGHT


;VOXEL
Vox_
;DE'-ADR OF OBJ
;HL'-REAL SIZE SPRITE L-X,H-Y
;B-SIZE Y,C-SIZE X
;HL-X,DE-Y
        LD A,B:OR A:RET Z
        LD A,C:OR A:RET Z
        XOR A
        LD I,A
        LD (Vx+1),HL
        LD (Vy+1),DE
        LD LY,C;SZX
        LD HY,B;SZY
        LD E,B
        EXX
        LD BC,0
        EXX
        LD B,0
Vx      LD HL,0
        LD A,H
        AND A
        JP P,Vx1
;ЕСЛИ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СЛЕВА
        ADC HL,BC
        RET M;ВЕСЬ СПРАЙТ ЗА ЭКРАНОМ
        RET Z;TOЖE
;КЛИПИРУЕМ
        LD A,L
        LD HL,0;X=0
        LD B,C
        LD C,A;NEW LEN OF X
        SUB B
        LD B,L
        NEG
;В "А" БУДЕТ СМЕЩЕНИЕ ПО ШИРИНЕ ДЛЯ
;ИЗМЕНЕНИЯ АДРЕСА СПРАЙТА
        EXX
        LD I,A
        SET 0,C;МЕТКА КЛИПИНГА СЛЕВА
        EXX
        JP Vx2
Vx1
        RET NZ;ЗА ЭКРНОМ СПРАВА
        LD A,L
        CP XEND
        RET NC;ТОЖЕ
Vx2
        ADD HL,BC
        LD A,H:OR A
        LD A,L
        JR NZ,$+6
        CP XEND+1
        JR C,Vy;ВЕСЬ СПР НА ЭКРАНЕ ПО X
;ПРАВАЯ ЧАСТЬ СПРАЙТА ЗА ЭКРАНОМ СПРАВА
;КЛИПИРУЕМ
        SUB XEND
        SUB C
        NEG
;НОВАЯ ДЛИННА СПРАЙТА
        LD C,A
;ПРОВЕРКИ ПО У
Vy      LD HL,0
        LD D,0
        LD A,H
        AND A
        JP P,Vx3
;ЕСЛИ СПРАЙТ ВЫХОДИТ СВЕРХУ ЗА ЭКРАН
        ADC HL,DE
        RET M;ВЫЛЕТ ПО У ВВЕРХУ ВСЕГО
;СПРАЙТА
        RET Z;ТОЖЕ
        LD A,L
        LD HL,0;У=0
        LD D,E
        LD E,A;НОВАЯ ВЫСОТА СПРАЙТА
        SUB D
        LD D,L
        NEG
        EXX
;В "А" КОЛИЧЕСТВО СТРОК ПОДДВЕРГНУТЫХ
;КЛИППИНГУ, КОТОРЫЕ НЕ ВИДИМЫ
        LD B,A
        SET 1,C;МАРКЕР КЛИПИНГА ПО У
        EXX
        JP Vx4
Vx3
        RET NZ;ВЕСЬ СПРАЙТ НИЖЕ СКРИНА
        LD A,L
        CP YEND
        RET NC;ТОЖЕ
Vx4
        ADD HL,DE
        LD A,H:OR A
        LD A,L
        JR NZ,$+6
        CP YEND+1
        JR C,Vx5
;СПРАЙТ ВЫШЕ ВЫСОТЫ СКРАНА ИЛИ ВЫЛЕЗ
;СНИЗУ
        SUB YEND
        SUB E
        NEG
        LD E,A;НОВАЯ ВЫСОТА
Vx5
;ДЕЛАЕМ НУЖНЫЕ КООРДИНАТЫ ЕСЛИ БЫЛИ
;КЛИППИНГИ
        EXX
        LD A,(Vx+1)
        BIT 0,C
        JR Z,$+3
        XOR A
        BIT 1,C
        EXX
        LD B,A;КООРДИНАТА Х СПРАЙТА ВЫВД
        LD A,(Vy+1)
        JR Z,$+3
        XOR A
;"А"-КООРД. У СПРАЙТА ДЛЯ ВЫВОДА
;РАСЧ. АДР. НА ХАЙД СЛРИНЕ
        SRL A
        LD L,D
        RR L
        LD H,A;HL=КООРД. ВЫВОДА У/2
        LD HX,E;КОЛИЧЕСТВО СТРОК
;КООРД. ВЫВОДА X ПОСЛЕ КЛИППИНГА
        LD E,B

;ЗАПОМНИМ КООРД. ВЫВОДА Х
        LD A,E:LD (XX+1),A

        SRL E

;ПОДГОТОВКА К ВЫВОДУ ВОКСЕЛЯ
;ВО ВТОРОМ ПОЛУБАЙТЕ
        LD A,#30;JR NC,
        JR NC,$+6:INC C,C
        LD A,#38;JR C,
        LD (AW3),A

        ADD HL,DE
        SET 7,H
        EX DE,HL
;DE-АДР. В СКРИНЕ
        PUSH DE,BC
        EXX
        LD A,L;РЕАЛЬНАЯ ШИРИНА СПРАЙТА
        EXX
        LD B,A;ЗАПОМНИЛИ

;ИЗНАЧАЛЬНО ЗАДАННАЯ ВЫВОДИМАЯ ШИРИНА
        LD E,LY
;РАСЧИТЫВАЕМ КОЭФ. МАСШТАБИРОВАНИЯ ПО Х
        CALL DIVV
;КОЭФ.ПО X=256*РЕАЛ.ШИРИНА/ЗАДАННАЯ
        EX DE,HL
;В "HL"-КОЭФ. МАСШТАБИРОВАНИЯ ПО X
        EXX
        LD A,H;РЕАЛЬНАЯ ВЫСОТА
        EXX
        LD E,HY;ЗАДАННАЯ
        PUSH HL
;КОЕФ. МАСШТАБИРОВАНИЯ ПО У
        CALL DIVV
        POP HL
        LD A,E
        LD LX,D;СТАР.БАЙТ КОЕФ.МАСШ.ПО У
        EXX
        LD C,A
;В "C'" МЛАДШ. БАЙТ КОЕФ. МАСШТ. ПО У
        LD A,B
        AND A
        JR Z,Vx6
;ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ
;КЛИППИНГ ПО ВЫСОТЕ СПРАЙТА
;С ВЕРХУ, РЕЗАЛСЯ С ВЕРХУ
        SLA B
        LD HL,0
        LD B,LX
        ADD HL,BC:DEC A:JP NZ,$-2
        LD A,H
        AND A
        JR Z,Vx6
        LD B,A
        EXX
        LD A,B
        EXX
        LD L,A
        LD H,0
        EX DE,HL
        ADD HL,DE:DJNZ $-1
        EX DE,HL
Vx6
        EXX
        LD A,I;КОЛ.КЛИПНУТЫХ ДАБЛ
;ВОКСЕЛЕЙ ПО ШИРИНЕ
;СЛЕВА
        AND A
        JR Z,P1
;ИЗМЕНЯЕМ АДРЕС СПРАЙТА ЕСЛИ БЫЛ КЛИПИНГ
;СЛЕВА ПО ШИРИНЕ
        EX DE,HL
;ПРОСУММИРУЕМ КОЕФ. МАСШТ. ПО ШИРИНЕ
;СТОЛЬКО РАЗ СКОЛЬКО НУЖНО КЛИПНУТЬ
;ДАБЛ ВОКСЕЛЕЙ

        LD HL,0:EXA:XOR A:EXA
        EXA:ADD HL,DE:ADC A,0:EXA
        DEC A:JP NZ,$-6

        LD A,H
        EXX
        LD L,A
        EXA
        LD H,A
        ADD HL,DE:EX DE,HL
        EXX
        EX DE,HL
P1
        LD A,B
        POP BC,DE

;ВЫВОД ВОКСЕЛЯ С МАСШТАБИРОВАНИЕМ
;C-КОЛИЧЕСТВО ВОКСЕЛЕЙ В СТРОКЕ
;DE-АДРЕС НА СКРИНЕ
;HX-КОЛ. СТРОК
;HL-КОЕФ. СМЕЩЕНИЯ ПО Х
;C'-МЛАДШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
;LX-СТАРШИЙ БАЙТ ПРОРЕЖИВАНИЯ ПО У
;DE'-АДРЕС СПРАЙТА, #XX00
;A-РЕАЛЬНОЕ КОЛ. ВОКСЕЛЕЙ В СТРОКЕ
;СПРАЙТА
Voxout
        LD (Stkv+1),SP

        LD (Vxll+1),A;РЕАЛЬНАЯ ШИРИНА

        LD SP,HL;КОЕФ. МАСШ. ПО Х
;УМНОЖАЕМ СТАРШИЙ БАЙТ КОЕФ.
;ПРОРЕЖИВАНИЯ НА РЕАЛЬНУЮ ДЛИННУ СТРОКИ
;ЧТО БЫ ПОЛУЧИТЬ КОЕФ. ПРОРЕЖ. ПО У
;КРАТНЫЙ ДЛИННЕ СТРОКИ
        LD B,A
        LD A,LX
        OR A
        JR Z,P2
        LD HL,0
        EXA:LD A,C:EXA
        LD C,B
        LD B,0
        ADD HL,BC:DEC A:JP NZ,$-2
        EXA:LD C,A

        LD A,L,LX,A
        LD A,H
;"А"-СМЕЩЕНИЕ ДЛЯ СТ.БАЙТА АДРЕСА СПРАЙТ
P2
        LD (WE1+1),A

;РАСЧИТЫВАЕМ АДРЕС НАЧАЛА ВЫВОДА ВОКСЕЛЯ
;В РАЗВЕРНУТОМ ЦИКЛЕ ПРОЦЕДУРЫ

;ПОДГОТОВКА К ВЫВОДУ ОДНОГО ВОКСЕЛЯ
;В ПЕРВОМ ПОЛУБЙТЕ
;НАХОДИМ СЛЕД. КООРД. Х ПОСЛЕ СПРАЙТА
;ЕСЛИ 0 БИТ ЕЕ =0 ТО ВЕСЬ ЗНАКОМЕСТ
;В ВОКСЕЛЯХ
;ИНАЧЕ ТОЛЬКО ОДИН ПЕРВЫЙ ПОЛУЗНАКОМЕСТ
;ЗАПОЛНЯЕТСЯ
XX      LD A,0:ADD A,C:RRA
        LD A,#0F
        JR NC,Q2
        LD A,(AW3):CP #38:JR Z,$+3:INC C
        XOR A
Q2
        LD (AW1+1),A
        LD (AW2+1),A

        SRL C
        LD A,#20
        SUB C
        JP NC,$+4:XOR A
        LD L,A
        LD H,0
        LD C,L
        LD B,H
;84b

.2      ADD HL,HL
        ADD HL,BC
.2      ADD HL,HL
        ADD HL,BC
.2      ADD HL,HL
        LD BC,VXL4
        ADD HL,BC
        LD (VXL3+1),HL
AW3     JR NC,Q1
        INC HL,HL,HL,HL
        LD (HL),0
        DEC HL
Q1
        LD (VXL2+1),HL
        LD LY,E;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
        LD C,E,B,D
        RRA
        LD H,VXTAB[+3
        LD A,#A9;RES 5,C
        JR C,$+8:SET 5,C
        LD H,VXTAB[
        LD A,#E9;SET 5,C
        LD (AW4+1),A
        LD A,H,(AW5+1),A

        LD D,#0F
        EXX
        XOR A
        LD B,E
Vxl3
;A'-СЧЕТЧИК СМЕЩЕНИЯ ПО СТРОКАМ
;LX-СТАРШИЙ БАЙТ ПРОРЕЖ. ПО У,КРАТЕН КОЛ
;ВОКСЕЛЕЙ В СТРОКЕ
        EXA
        LD H,B
        LD L,0


;SP-ПРОРЕЖ. ПО Х
;H-МЛАДШИЙ БАЙТ АДРЕСА СПРАЙТА
;L-ЕГО СЧЕТЧИК К УВЕЛИЧЕНИЮ
;D-СТАРШИЙ БАЙТ АДРЕСА СПРАЙТА
VXL2    JP 0

VXL4
        INCL "VOXP"


;157 TAKTS ONE CYCLE

        LD A,LY
        ADD A,#80
        LD C,A
        LD LY,A
        JR NC,$+3:INC B
AW4     SET 5,C
AW5     LD H,0
        EXX
        EX AF,AF
        ADD A,C
        LD L,A
        LD A,B
        JR NC,$+6
Vxll    ADD A,0;LEN OF STRING
        JR C,V3
V4
        ADD A,LX
        LD B,A
        LD A,D
WE1     ADC A,0
        LD D,A
        LD A,L
        DEC HX
        JP NZ,Vxl3
VXL3    LD HL,0
.4      INC HL
        LD (HL),#F0

Stkv    LD SP,0
        RET
V3      INC D:JP V4



LAND
        LD (Stkv_+1),SP
        LD A,#20:LD (TYPE_+1),A



        LD A,#30;JR NC
        LD (COM2),A
        LD A,#24;INC H
        LD (COM1),A


        LD B,#0B;КОЛ.ВОКС.СТРОК ЗЕМЛИ
        EXX

        LD HL,(PLANT)
        LD (ADSPR+1),HL


;HL-АДР. В СКРИНЕ
        LD HL,#8680

VXL3_
        LD E,L;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
        LD D,#80
        LD B,VXTAB[
        SET 5,L
        EXX

        LD A,0
Vxl3_
        LD C,A
        EXA
;ТАБЛИЦА ПРОРЕЖ. ПО Х И ПО У
;ДЛЯ КАЖДОЙ ПОЗИЦИИ У
;ПЕРВЫЙ, ВТОРОЙ БАЙТЫ СМЕЩ. В АДР.СПРЙТА
;ТРЕТИЙ, ЧЕТВЕРТЫЙ БАЙТЫ ПРОРЕЖ. ПО X

        LD A,C
        RLCA
TYPE_   OR 0;0-ПОЧВА,#40-НЕБО
        LD L,A
        LD H,TSX[

        LD E,(HL):INC L:LD D,(HL)
        EX DE,HL
        LD SP,HL
        EX DE,HL

        RES 5,L

        LD D,(HL):DEC L:LD E,(HL)
ADSPR   LD HL,0:ADD HL,DE:EX DE,HL

        LD H,E
        LD L,0


;SP-ПРОРЕЖ. ПО Х
;H-МЛАДШИЙ БАЙТ АДРЕСА СПРАЙТА

;L-ЕГО СЧЕТЧИК К УВЕЛИЧЕНИЮ
;D-СТАРШИЙ БАЙТ АДРЕСА СПРАЙТА
;C-СЧЕТЧИК СТРОК


VXL4_
        INCL "VOXL"

        LD A,E
        ADD A,D
        LD L,A
        LD E,A
COM2    JR NC,$+3;JR NC/C
COM1    INC H;INC/DEC
        SET 5,L
        EXX
        EXA
        INC A
        DEC B
        JP NZ,Vxl3_
Stkv_   LD SP,0
        RET






SKY
        LD (Stkv_+1),SP

        LD A,#60,(TYPE_+1),A

        LD A,#38;JR C
        LD (COM2),A
        LD A,#25;DEC H
        LD (COM1),A

        LD HL,(SKYS),(ADSPR+1),HL

        LD B,#0A
        EXX

;DE-АДР. В СКРИНЕ
        LD HL,#8480
        JP VXL3_



NIGHT
;ЗАТУХАНИЕ СПРАЙТОВ ДЛЯ СОЗДАНИЯ
;ЭФЕКТА  НОЧИ
        LD HL,1
        DEC HL:LD (NIGHT+1),HL
        LD A,L:OR H:RET NZ
        LD HL,1000,(NIGHT+1),HL

        LD HL,(SKYS),BC,#0C00
G1
        LD A,(HL)
        OR A
        JR Z,$+5:SUB #11:LD (HL),A
        INC HL
        DEC BC
        LD A,B:OR C:JP NZ,G1

        LD A,%10101010:RRCA:LD ($-2),A
        RET NC
        LD HL,(PLANT)
        LD BC,#0C00
G2
        LD A,(HL)
        OR A
        JR Z,$+5:SUB #11:LD (HL),A
        INC HL
        DEC BC
        LD A,B:OR C:JP NZ,G2
        RET




RETURN_
;ВОССТАНОВЛЕНИЕ РУЛЯ
        LD A,%10101010:RRCA:LD ($-2),A
        RET NC
        LD A,(UNGLE)
        OR A:RET Z
        JP P,RLT_
        JP RRT_



RLT_
        LD A,(UNGLE)
        DEC A
        JP P,$+7:CP 0-STPTURN:JR C,$+5
        LD (UNGLE),A
RP4
        LD L,A
        LD BC,TSX
RP44
        LD A,(BC),E,A
        ADD A,L:AND #3F
        LD D,A:LD A,E:AND #C0:OR D
        LD (BC),A
        SET 6,C
        LD A,(BC),E,A
        ADD A,L:AND #3F
        LD D,A:LD A,E:AND #C0:OR D
        LD (BC),A
        RES 6,C
        INC C,C

        LD A,#18:CP C
        JP NZ,RP44
        RET



RRT_
;ПОВОРОТ ВПРАВО ЭКРАНА
        LD A,(UNGLE)
        INC A
        JP M,$+7:CP STPTURN+1:JR NC,$+5
        LD (UNGLE),A
        JP RP4




TAKSPD_
;ВКЛЮЧИТЬ СКОРОСТЬ
        OR A:LD C,A
        LD A,%10001000:JP M,RP0
        LD A,%10001000:JR Z,RP0
        DEC C
        LD A,%10001000:JR Z,RP0
        DEC C
        LD A,%10101010:JR Z,RP0
        LD A,#FF
RP0
        LD (MDN+1),A
        RET



MOVING
        LD A,(SPEED)
        OR A:JP Z,NEBO2
        JP P,MDN
;ПЕРЕМЕЩЕНИЕ ФОНА ОТ СЕБЯ
        LD A,(MDN+1):RLCA:LD (MDN+1),A
        RET NC
        LD BC,TSX
        LD DE,#40
RP1
        LD A,(BC)
        LD L,A:INC C
        LD A,(BC)
        LD H,A
        ADD HL,DE
        LD A,H:CP #0B
        JR NZ,RP5
        LD H,0
        LD A,L:SUB 19:AND #3F
        LD L,A
RP5
        LD A,H
        LD (BC),A:DEC C
        LD A,L
        LD (BC),A:INC C,C
        LD A,#18:CP C
        JP NZ,RP1
        JP NEBO







MDN
;ПЕРЕМЕЩЕНИЕ ФОНА К СЕБЕ
        LD A,%10101010:RRCA:LD ($-2),A
        JP NC,NEBO
        LD DE,#FFC0
        LD BC,TSX
RP2
        LD A,(BC)
        LD L,A:INC C
        LD A,(BC)
        LD H,A
        ADD HL,DE
        JR C,RP3
        LD H,#0A
        LD A,L:ADD A,19:AND #3F
        OR #C0:LD L,A
RP3
        LD A,H
        LD (BC),A:DEC C
        LD A,L
        LD (BC),A:INC C,C
        LD A,#18:CP C
        JP NZ,RP2
        JP NEBO

NEBO2
        LD A,%10101010:RLCA:LD ($-2),A
        RET NC
NEBO
        LD A,%00100000:RLCA:LD ($-2),A
        RET NC
        LD DE,#FFC0
        LD BC,TSXS
RP22
        LD A,(BC)
        LD L,A:INC C
        LD A,(BC)
        LD H,A
        ADD HL,DE
        JR C,RP32
        LD H,#0A
        LD A,L:ADD A,19:AND #3F
        OR #C0:LD L,A
RP32
        LD A,H
        LD (BC),A:DEC C
        LD A,L
        LD (BC),A:INC C,C
        LD A,#58:CP C
        JP NZ,RP22
        RET





CLER
        LD (STK1+1),SP
        LD SP,#8680
        LD HL,#00
.192    PUSH HL
STK1    LD SP,0
        RET


FINDY
        EXX:PUSH DE:LD A,H:EXX:POP DE
        LD L,A
        LD H,0
        CALL DIVW:EX DE,HL
        RET
FINDX
        EXX:LD A,D:EXX:LD E,A
        EXX:LD A,L:EXX
        CALL DIVV
        RET

STORED
        PUSH BC
        EXX:LD A,B:EXX
        LD HL,0
        OR A:JR Z,S1
        LD BC,#40
        ADD HL,BC:DEC A:JP NZ,$-2
S3
        LD A,H:CP #0A:JR C,S1
        SUB #0A:LD H,A
        JR S3
S1
        PUSH HL
        CALL FINDX
        EX DE,HL
        PUSH HL
        XOR A
.8      ADD HL,HL:ADC A,A
        LD D,A
        LD E,H
        LD A,#40
        CALL DIV
        EX DE,HL
        LD (IX+#20),E
        LD (IX+#21),D
        POP BC
        POP HL
        LD A,#20:SUB B
;A-КОЛ. ВОКС. КОТОРЫЕ НУЖНО ПРОПУСТИТЬ
;НА ЭКРАНЕ
;НУЖНО КОЛ. ВОКСЕЛЕЙ КОТ. НУЖНО ПРОПУСТ.
;В СТРОКЕ
;X=A*D.E
        PUSH HL
;HL=A*DE
        LD C,#00
        LD H,C
        LD L,C
        ADD A,A
        ADD A,A
        JR C,$+23
        ADD A,A
        JR C,$+26
        ADD A,A
        JR C,$+29
        ADD A,A
        JR C,$+32
        ADD A,A
        JR C,$+35
        ADD A,A
        JR C,$+38
        ADD A,A
        JR C,$+41
        JP $+45
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
        ADD HL,DE
        ADC A,C
        LD L,H
        LD H,A
        POP DE
        LD A,E:AND #C0:LD H,A
        LD A,E:SUB L:AND #3F:OR H:LD E,A
        LD (IX+#00),E
        LD (IX+#01),D
        POP BC
        RET
NEWPSS_
        LD IX,TSXS
        JR $+6
NEWPOS_
;РАСЧЕТ ТАБЛИЦ ПРОРЕЖИВАНИЯ
        LD IX,TSX
        LD A,13
        EXA
        LD BC,0
        EXX
        CALL FINDY
        LD A,E:LD (MINY+1),A

;ПОИСК СЛЕД. ПОЗИЦИИ ВОКСЕЛЬ СТРОКИ ПО У
NP2
        CALL FINDY
MINY    LD A,#00
        SUB E
        JR NC,NP1
        LD A,E
        LD (MINY+1),A
S2
        EXA:DEC A:RET Z:EXA
        CALL STORED:INC IX,IX
NP1
        EXX
        LD A,C:ADD A,STP:LD C,A
        LD A,B:ADC A,0:LD B,A

        LD A,E:SUB STP:LD E,A
        LD A,D:SBC A,0:LD D,A
        EXX
        JP NZ,NP2
        RET



DIVV
;DE=A/E
        LD L,A:XOR A
        SLI L
        SLI L:JR C,M1
        SLI L:JR C,M1+7
        SLI L:JR C,M1+7*2
        SLI L:JR C,M1+7*3
        SLI L:JR C,M1+7*4
        SLI L:JR C,M1+7*5
        SLI L:JP M1+7*6
M1
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        RLA:SBC A,E:JR NC,$+3
        ADD A,E:RL L
        LD C,L
        ADD A,A:SBC A,E:JR NC,$+3
        ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L:ADD A,A:SBC A,E
        JR NC,$+3:ADD A,E
        RL L
        LD A,L
        CPL
        LD E,A
        LD A,C
        CPL
        LD D,A
        RET



DIVW
;HL=HL/DE
        LD A,L
        LD L,0:JR DIV+3
DIV
;HL=A/D.E
        LD HL,0
        AND A
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        AND A
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        LD B,A
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        CPL
        LD L,A
        LD A,B
        CPL
        LD H,A
        RET



D3D2__
;РАСЧЕТ ИЗ 3D В 2D
;HL-X,DE-Z,BC-Y
;L'-ПОЛУ ВЫСОТА СПРАЙТА
;H'-ПОЛУ ШИРИНА СПРАЙТА
;DE-Z
;BC-Y

        PUSH HL

        BIT 7,D
        JP NZ,ED_


        EXX
        LD A,H
        EXX
        LD L,A
        RLCA
        AND 1
        NEG
        LD H,A
Jmp1    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL

        ADD HL,HL

        AND A
        ADC HL,BC
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EXA
;DIV
        LD A,D:OR A:JP Z,PP0
        XOR A
        SLI L:RL H:JR C,PP1
        SLI L:RL H:JR C,PP1+6
        SLI L:RL H:JR C,PP1+6*2
        SLI L:RL H:JR C,PP1+6*3
        SLI L:RL H:JR C,PP1+6*4
        SLI L:RL H:JR C,PP1+6*5
        SLI L:RL H:JR C,PP1+6*6
        SLI L:RL H:JR C,PP1+6*7
        SLI L:RL H:JR C,PP1+6*8
        SLI L:RL H:LD B,L:JR C,PP1+6*9+1
        SLI L:RL H:JR C,PP1+6*10+1
        SLI L:RL H:JR C,PP1+6*11+1
        SLI L:RL H:JR C,PP1+6*12+1
        SLI L:RL H:JR C,PP1+6*13+1
        SLI L:RL H:JR C,PP1+6*14+1
        SLI L:RL H:JP C,PP1+6*15+1
;ZERO
        LD B,A
        JP PP9

PP1
        RLA:CP D
        JR NC,PP2:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*2:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*3:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*4:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*5:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*6:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*7:ADC HL,HL
        RLA:LD B,L:CP D
        JR NC,PP2+7*8:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*9:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*10:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*11:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*12:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*13:ADC HL,HL
        RLA:CP D
        JR NC,PP2+7*14:ADC HL,HL
        RLA:LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+63+7*6



PP2

        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP3
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*2
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*3
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*4
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*5
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*6
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*7
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+8*8-1

        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+63+7
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+63+7*2
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+63+7*3
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+63+7*4
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP PP4+63+7*5


PP0
        LD A,L
        LD L,H
        LD H,0
        SBC HL,DE
        JP NC,ED_
        ADD HL,DE
        RLA
        ADC HL,HL
PP3
        SBC HL,DE
        JP NC,ED_
        ADD HL,DE
        RLA
        ADC HL,HL
PP4
        SBC HL,DE:JR NC,$+3:ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE:JR NC,$+3:ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE:JR NC,$+3:ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE:JR NC,$+3:ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        LD B,A
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
PP9
        LD C,A
        EXA
        LD HL,#30;MIDLE Y
        JP M,$+8
        SBC HL,BC
        JP $+4
        ADD HL,BC

        POP BC

        PUSH HL
        EXX
        LD A,L
        EXX
        LD L,A
        RLCA
        AND 1
        NEG
        LD H,A
Jmp2    JR $
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL
        ADD HL,HL

        ADD HL,HL

        AND A
        ADC HL,BC
        JP P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EXA
;DIV
        LD A,D:OR A:JP Z,O0
        XOR A
        SLI L:RL H:JR C,O1
        SLI L:RL H:JR C,O1+6
        SLI L:RL H:JR C,O1+6*2
        SLI L:RL H:JR C,O1+6*3
        SLI L:RL H:JR C,O1+6*4
        SLI L:RL H:JR C,O1+6*5
        SLI L:RL H:JR C,O1+6*6
        SLI L:RL H:JR C,O1+6*7
        SLI L:RL H:JR C,O1+6*8
        SLI L:RL H:LD B,L:JR C,O1+6*9+1
        SLI L:RL H:JR C,O1+6*10+1
        SLI L:RL H:JR C,O1+6*11+1
        SLI L:RL H:JR C,O1+6*12+1
        SLI L:RL H:JR C,O1+6*13+1
        SLI L:RL H:JR C,O1+6*14+1
        SLI L:RL H:JP C,O1+6*15+1
;ZERO
        LD B,A
        JP O9

O1
        RLA:CP D
        JR NC,O2:ADC HL,HL
        RLA:CP D
        JR NC,O2+7:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*2:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*3:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*4:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*5:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*6:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*7:ADC HL,HL
        RLA:LD B,L:CP D
        JR NC,O2+7*8:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*9:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*10:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*11:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*12:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*13:ADC HL,HL
        RLA:CP D
        JR NC,O2+7*14:ADC HL,HL
        RLA:LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+63+7*6



O2

        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O3
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*2
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*3
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*4
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*5
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*6
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*7
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+8*8-1

        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+63+7
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+63+7*2
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+63+7*3
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+63+7*4
        LD C,A
        LD A,L
        LD L,H
        LD H,C:JP O4+63+7*5


O0
        LD A,L
        LD L,H
        LD H,0
        SBC HL,DE
        JP NC,ED_
        ADD HL,DE
        RLA
        ADC HL,HL
O3
        SBC HL,DE
        JP NC,ED_
        ADD HL,DE
        RLA
        ADC HL,HL
O4
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        LD B,A
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADD HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
O9
        LD C,A
        EXA
        LD HL,#0080;MIDLE X
        JP M,$+8
        SBC HL,BC
        JP $+4
        ADD HL,BC
        POP DE
        RET
ED_
;ЭКСТРЕННЫЙ ВЫХОД
        POP HL
        LD A,3:OR A
        RET


D3D2_
;ПОИСК КООРД. ВЫВОДА СПРАЙТА И РАЗМЕРА
;И ВЫВОД СПРАЙТА
;BC-Z,DE-Y,HL-X
;HL'-РЕАЛЬН. РАЗМЕРЫ
;DE'-АДРЕС СПРАЙТА
;A-МАСШТАБ
        SUB 6
        NEG
        LD (Jmp1+1),A
        LD (Jmp2+1),A

        LD A,C
        LD C,E
        LD E,A
        LD A,B
        LD B,D
        LD D,A
        LD (X_+1),HL
        LD (Y_+1),BC
        LD (Z_+1),DE
        EXX
        LD A,L:NEG:LD L,A
        LD A,H:NEG:LD H,A
        EXX
        CALL D3D2__
        RET PE
        PUSH DE,HL
X_      LD HL,0
Z_      LD DE,0
Y_      LD BC,0
        EXX
        LD A,L:NEG:LD L,A
        LD A,H:NEG:LD H,A
        EXX
        CALL D3D2__
        RET PE
        POP BC
        OR A
        SBC HL,BC
        RET Z
        SRL H:RR L
        SRL H:RET NZ
        RR L
        LD H,B
        LD A,C
        LD C,L
        LD L,A
        LD A,C:EXA
        EX DE,HL
        POP BC
        OR A
        SBC HL,BC
        RET Z
        SRL H:RR L
        SRL H:RET NZ
        RR L
        LD A,H:OR A:RET NZ:EXA
        LD H,B
        LD B,L
        LD L,C
        LD C,A
        EX DE,HL
.2      SRA H:RR L
.2      SRA D:RR E
        CALL Vox
        RET

        ORG $^
VXTAB
        INCB "VOX2"



TSX
;СМЕЩЕНИЯ В АДРЕСЕ СПРАЙТА ДЛЯ КАЖДОЙ
;ПОЗИЦИИ ВЫВОДА У ДЛЯ ПОЧВЫ
        DW #0140+#24
        DW #0200+#0E
        DW #0240+#23
        DW #02C0+#30
        DW #0340+#39
        DW #03C0+#3F
        DW #0480+#04
        DW #04C0+#07
        DW #0500+#0A
        DW #0500+#0C
        DW #0500+#0D
        DW #0540+#0F
        DW 0,0,0,0

        DW #0400
        DW #02AA
        DW #01F8
        DW #018C
        DW #0142
        DW #0110
        DW #00E6
        DW #00CE
        DW #00B5
        DW #00A6
        DW #009A
        DW #008C
        DW 0,0,0,0

TSXS
;СМЕЩЕНИЯ В АДРЕСЕ СПРАЙТА ДЛЯ КАЖДОЙ
;ПОЗИЦИИ ВЫВОДА У ДЛЯ НЕБА
        DW #0140+#24
        DW #0200+#0E
        DW #0240+#23
        DW #02C0+#30
        DW #0340+#39
        DW #03C0+#3F
        DW #0480+#04
        DW #04C0+#07
        DW #0500+#0A
        DW #0500+#0C
        DW #0500+#0D
        DW #0540+#0F
        DW 0,0,0,0

        DW #0400
        DW #02AA
        DW #01F8
        DW #018C
        DW #0142
        DW #0110
        DW #00E6
        DW #00CE
        DW #00B5
        DW #00A6
        DW #009A
        DW #008C

END

