; VOXEL -- restored from awk2/VOXEL.C (4798 bytes, STORM tokenized)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
; PATCHED vs the disk file (tools/storm_gen.py PATCH): INCL "CSIZE", INCL "CMOVE"
STEPX   EQU 3
STEPY   EQU 2
SZX     EQU 5
SZY     EQU 3

HSCR    EQU #8000
XEND    EQU 64
YEND    EQU 24



        ORG HSCR+((YEND/2)*#0100)
START
        DI
;ПРОБНЫЙ ВЫВОД ВОКСЕЛЬ СПРАЙТА С МАСШТА
;БИРОВАНИЕМ
        LD HL,#4000
        LD DE,#4001
        LD BC,#1800
        LD (HL),L
        LDIR
        LD BC,#02FF
        LD (HL),%00000111
        LDIR
        LD A,1
        OUT (#FE),A

M2

        CALL CLER


        LD DE,TELE
        LD HL,#3040
        EXX
L1      LD BC,#3040
X1      LD HL,#01
Y1      LD DE,#00
        CALL Vox
        EI
        LD A,0
        OUT (#FE),A
        HALT
        LD A,2
        OUT (#FE),A
        DI
        CALL DROPH

        LD HL,(L1+1)
;        INC L:JR NZ,$+3:INC L
;        INC H:JR NZ,$+3:INC H
        LD (L1+1),HL

;INCL "CSIZE"  ; file CSIZE exists on no disk (not needed to assemble)
;INCL "CMOVE"  ; file CMOVE exists on no disk (not needed to assemble)




        XOR A
        IN A,(#FE)
        AND #1F
        CP #1F
        JP Z,M2

        LD A,#3F
        LD I,A
        EI
        RET


;VOXEL
Vox
;DE'-ADR OF OBJ
;HL'-REAL SIZE SPRITE L-X,H-Y
;B-SIZE Y,C-SIZE X
;HL-X,DE-Y
        XOR A
        LD I,A
        LD (Vx+1),HL
        LD (Vy+1),DE
        LD IYL,C ;SZX
        LD IYH,B ;SZY
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
        RET M ;ВЕСЬ СПРАЙТ ЗА ЭКРАНОМ
        RET Z ;TOЖE
;КЛИПИРУЕМ
        LD A,L
        LD HL,0 ;X=0
        LD B,C
        LD C,A ;NEW LEN OF X
        SUB B
        LD B,L
        NEG
;В "А" БУДЕТ СМЕЩЕНИЕ ПО ШИРИНЕ ДЛЯ
;ИЗМЕНЕНИЯ АДРЕСА СПРАЙТА
        EXX
        LD I,A
        SET 0,C ;МЕТКА КЛИПИНГА СЛЕВА
        EXX
        JP Vx2
Vx1
        RET NZ ;ЗА ЭКРНОМ СПРАВА
        LD A,L
        CP XEND
        RET NC ;ТОЖЕ
Vx2
        ADD HL,BC
        LD A,H
        OR A
        LD A,L
        JR NZ,$+6
        CP XEND+1
        JR C,Vy ;ВЕСЬ СПР НА ЭКРАНЕ ПО X
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
        RET M ;ВЫЛЕТ ПО У ВВЕРХУ ВСЕГО
;СПРАЙТА
        RET Z ;ТОЖЕ
        LD A,L
        LD HL,0 ;У=0
        LD D,E
        LD E,A ;НОВАЯ ВЫСОТА СПРАЙТА
        SUB D
        LD D,L
        NEG
        EXX
;В "А" КОЛИЧЕСТВО СТРОК ПОДДВЕРГНУТЫХ
;КЛИППИНГУ, КОТОРЫЕ НЕ ВИДИМЫ
        LD B,A
        SET 1,C ;МАРКЕР КЛИПИНГА ПО У
        EXX
        JP Vx4
Vx3
        RET NZ ;ВЕСЬ СПРАЙТ НИЖЕ СКРИНА
        LD A,L
        CP YEND
        RET NC ;ТОЖЕ
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
        LD E,A ;НОВАЯ ВЫСОТА
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
        LD B,A ;КООРДИНАТА Х СПРАЙТА ВЫВД
        LD A,(Vy+1)
        JR Z,$+3
        XOR A
;"А"-КООРД. У СПРАЙТА ДЛЯ ВЫВОДА
;РАСЧ. АДР. НА ХАЙД СЛРИНЕ
        SRL A
        LD L,D
        RR L
        LD H,A ;HL=КООРД. ВЫВОДА У/2
        LD IXH,E ;КОЛИЧЕСТВО СТРОК
;КООРД. ВЫВОДА X ПОСЛЕ КЛИППИНГА
        LD E,B

;ЗАПОМНИМ КООРД. ВЫВОДА Х
        LD A,E
        LD (XX+1),A

        SRL E

;ПОДГОТОВКА К ВЫВОДУ ВОКСЕЛЯ
;ВО ВТОРОМ ПОЛУБАЙТЕ
        LD A,#30 ;JR NC,
        JR NC,$+6
        INC C
        INC C
        LD A,#38 ;JR C,
        LD (AW3),A

        ADD HL,DE
        SET 7,H
        EX DE,HL
;DE-АДР. В СКРИНЕ
        PUSH DE
        PUSH BC
        EXX
        LD A,L ;РЕАЛЬНАЯ ШИРИНА СПРАЙТА
        EXX
        LD B,A ;ЗАПОМНИЛИ

;ИЗНАЧАЛЬНО ЗАДАННАЯ ВЫВОДИМАЯ ШИРИНА
        LD E,IYL
;РАСЧИТЫВАЕМ КОЭФ. МАСШТАБИРОВАНИЯ ПО Х
        CALL Divv
;КОЭФ.ПО X=256*РЕАЛ.ШИРИНА/ЗАДАННАЯ
        EX DE,HL
;В "HL"-КОЭФ. МАСШТАБИРОВАНИЯ ПО X
        EXX
        LD A,H ;РЕАЛЬНАЯ ВЫСОТА
        EXX
        LD E,IYH ;ЗАДАННАЯ
        PUSH HL
;КОЕФ. МАСШТАБИРОВАНИЯ ПО У
        CALL Divv
        POP HL
        LD A,E
        LD IXL,D ;СТАР.БАЙТ КОЕФ.МАСШ.ПО У
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
        LD B,IXL
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
        LD A,I ;КОЛ.КЛИПНУТЫХ ДАБЛ
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
        EX AF,AF'
        XOR A
        EX AF,AF'
        EX AF,AF'
        ADD HL,DE
        ADC A,0
        EX AF,AF'
        DEC A
        JP NZ,$-6

        LD A,H
        EXX
        LD L,A
        EX AF,AF'
        LD H,A
        ADD HL,DE
        EX DE,HL
        EXX
        EX DE,HL
P1
        LD A,B
        POP BC
        POP DE

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

        LD (Vxll+1),A ;РЕАЛЬНАЯ ШИРИНА

        LD SP,HL ;КОЕФ. МАСШ. ПО Х
;УМНОЖАЕМ СТАРШИЙ БАЙТ КОЕФ.
;ПРОРЕЖИВАНИЯ НА РЕАЛЬНУЮ ДЛИННУ СТРОКИ
;ЧТО БЫ ПОЛУЧИТЬ КОЕФ. ПРОРЕЖ. ПО У
;КРАТНЫЙ ДЛИННЕ СТРОКИ
        LD B,A
        LD A,IXL
        OR A
        JR Z,P2
        LD HL,0
        EX AF,AF'
        LD A,C
        EX AF,AF'
        LD C,B
        LD B,0
        ADD HL,BC
        DEC A
        JP NZ,$-2
        EX AF,AF'
        LD C,A

        LD A,L
        LD IXL,A
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

        DUP 2
            ADD HL,HL
        EDUP
        ADD HL,BC
        DUP 2
            ADD HL,HL
        EDUP
        ADD HL,BC
        DUP 2
            ADD HL,HL
        EDUP
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
        LD IYL,E ;ДУБЛИРУЕМ МЛ.БАЙТ АДРЕСА
        LD C,E
        LD B,D
        RRA
        LD H,high(Vxtab)+3
        LD A,#A9 ;RES 5,C
        JR C,$+8
        SET 5,C
        LD H,high(Vxtab)
        LD A,#E9 ;SET 5,C
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
        EX AF,AF'
        LD H,B
        LD L,0


;SP-ПРОРЕЖ. ПО Х
;H-МЛАДШИЙ БАЙТ АДРЕСА СПРАЙТА
;L-ЕГО СЧЕТЧИК К УВЕЛИЧЕНИЮ
;D-СТАРШИЙ БАЙТ АДРЕСА СПРАЙТА
VXL2    JP 0

VXL4
        INCLUDE "VOXP.asm"


;157 TAKTS ONE CYCLE

        LD A,IYL
        ADD A,#80
        LD C,A
        LD IYL,A
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
Vxll    ADD A,0 ;LEN OF STRING
        JR C,V3
V4
        ADD A,IXL
        LD B,A
        LD A,D
WE1     ADC A,0
        LD D,A
        LD A,L
        DEC IXH
        JP NZ,Vxl3
VXL3    LD HL,0
        DUP 4
            INC HL
        EDUP
        LD (HL),#F0

Stkv    LD SP,0
        RET
V3      INC D
        JP V4




Divv
;DE=A/E
        LD L,A
        XOR A
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        ADC A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        RL L
        LD C,L
        ADD A,A
        SBC A,E
        JR NC,$+3
        ADD A,E
        LD H,A
        LD A,L
        LD L,H
        LD H,0
        LD D,H
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
        LD E,A
        LD A,C
        CPL
        LD D,A
        RET


DROPH
        LD HL,HSCR
        LD DE,#4000
        LD BC,+(YEND/2)*#0100
M1
        LD A,E
        DUP 32
            LDI
        EDUP
        RET PO
        DEC DE
        LD E,A
        INC D
        LD A,D
        AND 7
        JP NZ,$+13
        LD A,E
        ADD A,32
        LD E,A
        JR C,$+6
        LD A,D
        SUB 8
        LD D,A
        JP M1



CLER
        LD (STK1+1),SP
        LD SP,HSCR+((YEND/2)*#0100)
        LD HL,#00
        LD B,YEND/2
M22
        DUP 128
            PUSH HL
        EDUP
        DEC B
        JP NZ,M22
STK1    LD SP,0
        RET


        DS (((($-1)/256)*256)-$)+256
Vxtab
        INCBIN "assets/VOX2.bin"

TELE
        INCBIN "assets/CHAN1.bin"

END_
