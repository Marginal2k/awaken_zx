;DHLP2_
;DHLP3_
;SETHIND
;DHLPL1


















DHLP2_:
HLPIND:     ld   a,0
            ld   hl,THELP
            call FLIST
            ld   de,0
            xor  a
            ld   (Cord),a
            ld   ix,LINES
D_H1:
            ld   (ix+0),l
            ld   (ix+1),h
            inc  ix
            inc  ix
            ld   a,#08
            ld   (Cord+1),a
            push de
            call VTXT
            pop  de
            inc  de
            jp   nc,D_H1
            push de
            push ix
            ld   hl,1024
            SUB_DE
            add  hl,hl
            ld   b,h
            ld   c,l
            pop  hl
            ld   d,h
            ld   e,l
            ld   (hl),0
            inc  de
            dec  bc
            ldir 
            pop  de
            ret  


DHLP3_:
            ld   bc,#0800
            ld   (Cord),bc
            add  hl,hl
            ld   de,LINES
            add  hl,de
            ld   a,(hl)
            inc  hl
            ld   h,(hl)
            ld   l,a
            or   h
            ret  z
            jp   OTXT


SETHIND:
            ld   (HLPIND+1),a
            ret  



DHLPL1:

;hl-ИНДЕКС ВЫВОДА
            EXD

;  КОРД.Y НА САМУЮ ПЕРВУЮ СТРОКУ
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
            ex   af,af'
            ld   a,8
            ld   (Cord+1),a
            ret  

LINES:
            ds   2048


THLPL:
;  ПУНКТЫ МЕНЮ ХЕЛПА
            db   CR,142,175,165,224,160,230,168,174,173,173,160,239," ",225,224,165,164,160
            db   CR,136,225,175,174,171,236,167,174,162,160,173,168,165," ",170,160,224,226
            db   CR,142,225,173,160,233,165,173,168,239
            db   CR,146,174,162,160,224,235
            db   CR,141,174,162,174,225,226,168
            db   CR,128,161,174,173,165,173,226,235
            db   CR,138,174,224,160,161,171,168," ",168," ",145,170,168,172,172,165,224,235
            db   CR,138,174,173,226,224,160,170,226,235
            db   ET

THELP:
;  ОПИСАНИЕ КАЖДОГО ПУНКТА ПО ПОРАДКУ
            db   ET
            incbin "help.tok"

