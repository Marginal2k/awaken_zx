L90:        equ  #5B00
MASKS:      equ  #8460


■#A000
ТАБЛИЦА ПРЕОБРАЗОВАНИЯ
■(RRA:rra:rra:and#1F)
LL90        ds   #100
ТАБЛИЦА ПРЕОБРАЗОВАНИЯ
■(RRCA:rrca:rrca:rrca:and#07)
LL91        ds   #100

EXPT        ds   #200*6

L9C:        equ  $.h
            ds   #100

L9D:        equ  $.h
            ds   #100

L9E:        equ  $.h
            ds   #100


ТАБЛИЦА ЛОГАРИФМОВ
TBLOG2:
            ds   #200


ТАБЛИЦА КВАДРАТОВ
TB2X:
            ds   #100


TBXY:
            ds   #400


ТАБЛИЦА УМНОЖЕНИЯ
MULTB:      equ  $.h

ТАБЛИЦА СИНУСА
SINTB:      equ  MULTB+1
            insert "D9200.dat"

;ТАБЛИЦА АРКТАНГЕНСОВ
;ATAGTAB:
;            insert"ATAGTAB.dat"

БУФЕР 3D ОБЪЕКТА
OBJBUF:     ds   #100

            ds   #3E
            rept #30:dw PEHO2,PEHO1:endr
_JMP1       dw   JMP1
            ds   #3E
            rept #30:dw PEHO1,PEHO2:endr
            dw   JMP1
            ds   #3E
            rept #30:dw PEHO2,PEHO1:endr
_JMP2       dw   JMP2
            ds   #3E
            rept #30:dw PEHO1,PEHO2:endr
            dw   JMP2
            ds   #3E
            rept #30:dw PEHO2,PEHO1:endr
_JMP3       dw   JMP3
            ds   #3E
            rept #30:dw PEHO1,PEHO2:endr
            dw   JMP3



ВНУТРЕННИЕ ПЕРЕМЕННЫЕ

LA11:       dw   #7FFF
LA12:       dw   0
LB13:       dw   0
LA21:       dw   0
LA22:       dw   #7FFF
LB23:       dw   0
LA31:       dw   0
LA32:       dw   0
LB33:       dw   #7FFF
EYEA:       db   0
EYEB:       db   0
EYEG:       db   0
RNDD1:      dw   0
RNDD2:      dw   0


SETS:       db   0
INDX:       db   0
OBJX:       dw   0
OBJY:       dw   0
OBJZ:       dw   0
EYE_A:      db   0
EYE_B:      db   0
EYE_G:      db   0
EYE_X:      dw   0
EYE_Y:      dw   0
EYE_Z:      dw   0
STPA:       db   0
STPB:       db   0
STPG:       db   0

INDT1:      db   0
INDT2:      db   0

LOW_CORDS_BUF:    db 0


────────────────────────────────────────

            ADRXX00
ИНДЕКСНАЯ ТАБЛИЦА ОБЪЕКТОВ
СОДЕРЖИТ АДРЕСА ОБЪЕКТОВ
НЕДЕТАЛИЗИРОВАННЫХ И ДЕТАЛИЗИРОВАННЫХ
И ПРИДАЕТ ИНДЕКСЫ В ПОРЯДКЕ ВОЗРСТАНИЯ
L97:        equ  $.h

ПОЛИЦИЯ В КОСМОСЕ
IPOL1:      equ  $.b
            dw   Kd1
            dw   Kd1



────────────────────────────────────────



            ADRXX00
БУФЕР ОПИСАТЕЛЬ ПОЛОЖЕНИЯ И СОСТОЯНИЯ
ОБЪЕКТОВ В КОСМОСЕ, НА 25 ОБЪЕКТОВМ !
CARSB:
            dw   0,0,1000
            db   0
ALFA        db   0
BETA        db   0
GAMA        db   -8

            ds 100,#8080



