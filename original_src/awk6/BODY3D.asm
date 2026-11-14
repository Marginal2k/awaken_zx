■INITCLP
■OSHIP
■SETZET
■TSHIP
■SSHIND
■NSHIP_
■ISHIPI
■ISHIP
■SHIPI













INITCLP
 ИНИЦИАЛИЗАЦИЯ ПРЕДЕЛОВ КЛИППИРОВАНИЯ
■h-yh,l-xh;hl-YHXH
■d-yl,e-xl;de-YLXL

            ld   a,h:inc a:srl a
            ld   (MDY+1),a

            ld   a,l:inc a:srl a
            ld   (MDX+1),a

            ld   (YHXH+1),hl
            ld   (YLXL+1),de
            ld   a,l
            ld   l,e
            ld   e,a
            ld   (YHXL+1),hl
            ld   (YLXH+1),de
            ld   a,h
            ld   (YH1+1),a
            ld   (YH2+1),a
            ld   (YH3+1),a
            ld   (YH4+1),a
            ld   (YH5+1),a
            inc  a
            ld   (YH6+1),a
            ld   a,d
            ld   (YL1+1),a
            ld   (YL2+1),a
            ld   (YL3+1),a
            ld   (YL4+1),a
            ld   (YL5+1),a
            ld   a,e
            ld   (XH1+1),a
            ld   (XH2+1),a
            ld   (XH3+1),a
            ld   (XH4+1),a
            ld   (XH5+1),a
            ld   (XH6+1),a
            inc  a
            ld   (XH7+1),a
            ld   a,l
            ld   (XL1+1),a
            ld   (XL2+1),a
            ld   (XL3+1),a
            ld   (XL4+1),a
            ld   (XL5+1),a
            ld   (XL6+1),a
            ret




OSHIP
 ВЫВОД КОРАБЛЕЙ
 ЦИКЛ ВЫВОДА 3D
■a-T3D
            dec  a
            jr   nz,OSH1
            ld   a,8
            ld   (ALFA),a
            xor  a:ld (ALFA+2),a
            ld   a,(ALFA+1)
            add  a,2
            ld   (ALFA+1),a
            jr   OSH2
OSH1
            ld   a,(ALFA)
            add  a,1:ld (ALFA),a
            ld   a,(ALFA+1)
            add  a,2:ld (ALFA+1),a
            ld   a,(ALFA+2)
            add  a,3:ld (ALFA+2),a
OSH2
            call Ren3d
            ei
            call MERZ
            ret




SETZET
 ПРИРАЩАЕТ КООРД. ЗЕТ ДЛЯ ОКБЪЕКТА
■hl-СМЕЩЕНИЕ z
            ld   de,(ZET)
            add  hl,de
            ld   a,h:cp 2:ret c
            cp   #10:ret nc
            ld   (ZET),hl
            ret






 ВЫВОД ВСЕГО МЕНЮ КОРАБЛЕЙ
NSHIP_
■A'-КОЛ. ПУНКТОВ ПРОПУСТИТЬ
■a-T3D
■h-BT2 =0 ПОКУПКА, =1 ПРОДАЖА
            push hl,af
            ld   a,ET:ld (TD1),a
            ld   hl,#0800
            ld   (Cord),hl
            ld   hl,TSHIP
            call Outtxt

            ld   hl,#1800
            ld   (Cord),hl

■A'-ИНДЕКС С КОТОРОГО ВЫВОДИТЬ КОРАБЛИ В
 МЕНЮ, ЗАВ. ОТ УРОВНЯ

            pop  af
            dec  a
            ld   hl,NAMSH
            jrnz $+5
            ld   hl,NAMSK
            pop  af
            or   a:jrz I1
            push hl
            exa:ld c,a:exa:ld a,c
СМОТРИМ ЕСЛИ НОМЕР НА РОХЛЮ ТО ДАДИМ
ЕЙ ВЫВЕСТИСЬ
            cp   6
            jrnz $+7:ld a,CR:ld (TD1),a

            ld   a,c:inc a
            call FLIST1
            dec  hl:ld a,(hl)
            ld   (hl),ET
            EXD
            pop  hl
            exa
            ld   (FROMS+1),a
            call LIST1
            exa:ld (de),a
            jr   I2
I1
            exa
 ЗАПОМНИТЬ НОМЕР С КОТОРОГО ВСЕ КОРАБЛИ
            ld   (FROMS+1),a
            call LIST1
I2
            ld   a,(Cord+1):sub #18
            rrca
            rrca
            rrca
            and  #1F:inc a
            exa
            ret

ISHIPI
 ПОДСЧЕТ СТРОК
■a-T3D
            ld   hl,TISHIP
            dec  a:jrnz $+5
            ld   hl,TISKIM
            ld   a,(SHIPIND+1)
            ld   c,a
            ld   a,(FROMS+1):add a,c
            call FLIST
            call KOLLIN
            ret


ISHIP
 ПОДГОТОВКА ИНИЦИАЛИЗАЦИЯ ВЫВОДА КОРАБЛ
■h-yh,l-xh;hl-YHXH
■d-yl,e-xl;de-YLXL
■DE'-КООРД. ОКНА
■a-T3D-0-SHIPS, 1-SKIMMERS
            push af
            call INITCLP
            exx
            call MTBXX2
            pop  bc
SHIPIND     ld   a,0
 ПРИБАВИМ НОМЕР С КОТОРОГО ВЕСЬ СПИСОК
 ПОКАЗЫВАЕТ КОРАБЛИ
FROMS       add  a,0
            add  a,a
            add  a,a
            dec  b
            jr   nz,$+4
            add  a,28
            ld   (Indexx),a

            ret


SHIPI
 ВЫВОД ИНФО О КОРАБЛЕ
■a-T3D
■hl-НОМЕР СТРОКИ
            push hl
            ld   hl,TISHIP
            dec  a:jrnz $+5
            ld   hl,TISKIM
            ld   a,(SHIPIND+1)
            ld   c,a
            ld   a,(FROMS+1):add a,c
            call FLIST
            pop  de
            ld   bc,#0800
            call FROMLIN
            ret

