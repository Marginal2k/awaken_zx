;ПРОЦЕДУРА ВЫВОДА ВОКС. СПРАЙТА С
;С МАСШТАБИРОВАНИЕМ И ПРОЗРАЧНОСТЬЮ
;ПОРИТ РЕГ. I

XEND    EQU 64
YEND    EQU 24


;VOXEL
VOX
;DE'-ADR OF OBJ
;HL'-REAL SIZE SPRITE L-X,H-Y
;B-SIZE Y,C-SIZE X
;HL-X,DE-Y
        LD A,B
        OR A
        RET Z
        LD A,C
        OR A
        RET Z
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
        CALL P,Vx1
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
        CALL P,Vx3
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
        LD A,H
        OR A
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
        LD A,E
        LD (XX+1),A

        SRL E

;ПОДГОТОВКА К ВЫВОДУ ВОКСЕЛЯ
;ВО ВТОРОМ ПОЛУБАЙТЕ
        LD A,#30;JR NC,
        JR NC,$+6
        INC C
        INC C
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
        ADD HL,BC
        DEC A
        JP NZ,$-2
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
        ADD HL,DE
        DJNZ $-1
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

        LD HL,0
        EXA
        XOR A
        EXA
        EXA
        ADD HL,DE
        ADC A,0
        EXA
        DEC A
        JP NZ,$-6

        LD A,H
        EXX
        LD L,A
        EXA
        LD H,A
        ADD HL,DE
        EX DE,HL
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
        EXA
        LD A,C
        EXA
        LD C,B,B,0
        ADD HL,BC
        DEC A
        JP NZ,$-2
        EXA
        LD C,A

        LD A,L
        LD LX,A
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
XX      LD A,0
        ADD A,C
        RRA
        LD A,#0F
        JR NC,Q2
        LD A,(AW3)
        CP #38
        JR Z,$+3
        INC C
        XOR A
Q2
        LD (AW1+1),A
        LD (AW2+1),A

        SRL C
        LD A,#20
        SUB C
        JP NC,$+4
        XOR A
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
        INC HL
        INC HL
        INC HL
        INC HL
        LD (HL),0
        DEC HL
Q1
        LD (VXL2+1),HL
        LD LY,E;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
        LD C,E
        LD B,D
        RRA
        LD H,VXTAB[+3
        LD A,#A9;RES 5,C
        JR C,$+8
        SET 5,C
        LD H,VXTAB[
        LD A,#E9;SET 5,C
        LD (AW4+1),A
        LD A,H
        LD (AW5+1),A

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
        JR NC,$+3
        INC B
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
V3      INC D
        JP V4




DIVV
;DE=A/E
        LD L,A
        XOR A
        SLI L
        SLI L
        JR C,M1
        SLI L
        JR C,M1+7
        SLI L
        JR C,M1+(7*2)
        SLI L
        JR C,M1+(7*3)
        SLI L
        JR C,M1+(7*4)
        SLI L
        JR C,M1+(7*5)
        SLI L
        JP M1+(7*6)
M1
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        RLA
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        LD C,L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        LD A,L
        CPL
        LD E,A
        LD A,C
        CPL
        LD D,A
        RET


D3D2_
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
        CALL P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EXA
;DIV






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
        CALL P,$+10
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EXA
;DIV






        POP DE
        RET
ED_
;ЭКСТРЕННЫЙ ВЫХОД
        POP HL
        LD A,3:OR A
        RET


D3D2
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
        LD A,L
        NEG
        LD L,A
        LD A,H
        NEG
        LD H,A
        EXX
        CALL D3D2_
        RET PE
        PUSH DE,HL
X_      LD HL,0
Z_      LD DE,0
Y_      LD BC,0
        EXX
        LD A,L
        NEG
        LD L,A
        LD A,H
        NEG
        LD H,A
        EXX
        CALL D3D2_
        RET PE
        POP BC
        OR A
        SBC HL,BC
        RET Z
        SRL H
        RR L
        SRL H
        RET NZ
        RR L
        LD H,B
        LD A,C
        LD C,L
        LD L,A
        LD A,C
        EXA
        EX DE,HL
        POP BC
        OR A
        SBC HL,BC
        RET Z
        SRL H
        RR L
        SRL H
        RET NZ
        RR L
        LD A,H
        OR A
        RET NZ
        EXA
        LD H,B
        LD B,L
        LD L,C
        LD C,A
        EX DE,HL
        SRA H
        RR L
        SRA D
        RR E
        SRA H
        RR L
        SRA D
        RR E
        CALL VOX
        RET

        ORG $^
VXTAB
        INCB "VOX2"

