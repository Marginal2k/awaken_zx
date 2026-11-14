■DHLP2_
■DHLP3_
■SETHIND
■DHLPL1


















DHLP2_
HLPIND      ld   a,0
            ld   hl,THELP
            call FLIST
            ld   de,0
            xor  a:ld (Cord),a
            ld   ix,LINES
D_H1
            ld   (ix+0),l
            ld   (ix+1),h:inc ix,ix
            ld   a,#08
            ld   (Cord+1),a
            push de
            call VTXT
            pop  de
            inc  de
            jp   nc,D_H1
            push de,ix
            ld   hl,1024
            SUB_DE
            add  hl,hl:ld b,h
            ld   c,l:pop hl
            ld   d,h
            ld   e,l
            ld   (hl),0
            inc  de:dec bc:ldir
            pop  de
            ret


DHLP3_
            ld   bc,#0800
            ld   (Cord),bc
            add  hl,hl
            ld   de,LINES
            add  hl,de
            ld   a,(hl):inc hl:ld h,(hl)
            ld   l,a
            or   h:ret z
            jp   OTXT


SETHIND
            ld   (HLPIND+1),a:ret



DHLPL1

■hl-ИНДЕКС ВЫВОДА
            EXD

 КОРД.Y НА САМУЮ ПЕРВУЮ СТРОКУ
            ld   hl,#0800
            ld   (Cord),hl

            ld   hl,THLPL
            ld   a,e
            call LIST1
            ld   a,(Cord+1)
            sub  8
            srl  a
            srl  a
            srl  a
            inc  a
            exa
            ld   a,8
            ld   (Cord+1),a
            ret

LINES
            ds   2048


THLPL
 ПУНКТЫ МЕНЮ ХЕЛПА
            db   CR,"Операционная среда"
            db   CR,"Использование карт"
            db   CR,"Оснащения"
            db   CR,"Товары"
            db   CR,"Новости"
            db   CR,"Абоненты"
            db   CR,"Корабли и Скиммеры"
            db   CR,"Контракты"
            db   ET

THELP
 ОПИСАНИЕ КАЖДОГО ПУНКТА ПО ПОРАДКУ
            db   ET
            insert "help.T"

