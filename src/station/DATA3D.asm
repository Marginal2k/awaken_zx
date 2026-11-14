
L90k:
            incbin "D9000.d"

Eye_a:      equ  #C200
Eye_b:      equ  #C201
Eye_g:      equ  #C202
La11:       equ  #C20C-1
La12:       equ  #C20E-1
Lb13:       equ  #C210-1
La21:       equ  #C212-1
La22:       equ  #C214-1
Lb23:       equ  #C216-1
La31:       equ  #C218-1
La32:       equ  #C21A-1
Lb33:       equ  #C21C-1
Eyea:       equ  #C21E
Eyeb:       equ  #C21F
Eyeg:       equ  #C220

L91:        equ  #C221
L90:        equ  #C200

            ds   #0100

Multb:      equ  high($)
Sintb:      equ  Multb+1
            incbin "station_D9200.d"
L9c:        equ  high($)
            ds   #0100
L9d:        equ  high($)
            ds   #0100
L9e:        equ  high($)
            ds   #0100

TBXX2:      ds   #0300

L95:
            db   low(Lceb1)
            db   low(Lcdf6)
            db   low(Lcdcd)
            db   0
            db   low(Lcda4)
            db   low(Lc903)
            db   low(Lc91d)
            db   0
            db   low(Lcd7b)
            db   low(Lc937)
            db   low(Lc951)
            db   0,0,2,0,1
            db   low(Lc96b)
            db   low(Lc902)
            db   low(Lc971)
            db   0
            db   low(Lc977)
            db   low(Lc912)
            db   low(Lc989)
            db   0
            db   low(Lc9a1)
            db   low(Lc9b3)
            db   low(Lc9ba)
            db   0,0,0,0,0
            db   low(Lc9cc)
            db   low(Lc9d2)
            db   low(Lc902)
            db   0
            db   low(Lc9d8)
            db   low(Lc9ea)
            db   low(Lc9fc)
            db   0
            db   low(Lca03)
            db   low(Lca15)
            db   low(Lc960)
            ds   21
            db   low(Lca2d)
            db   low(Lca33)
            db   low(Lca45)
            db   0
            db   low(Lc902)
            db   low(Lca57)
            db   low(Lc92c)
            db   0
            db   low(Lca5e)
            db   low(Lca64)
            db   low(Lca79)
            db   0,0,0,0,0
            db   low(Lca94)
            db   low(Lcab0)
            db   low(Lcab7)
            db   0
            db   low(Lcad6)
            db   low(Lc902)
            db   low(Lcae1)
            db   0
            db   low(Lcae7)
            db   low(Lcec8)
            db   low(Lcafc)
            db   0,0,0,#0A,#90
            db   low(Lcb15)
            db   low(Lcb31)
            db   low(Lcb46)
            db   0
            db   low(Lcb51)
            db   low(Lcec8)
            db   low(Lc902)
            db   0
            db   low(Lcb58)
            db   low(Lcb77)
            db   low(Lcb90)
            ds   21
            db   low(Lcb96)
            db   low(Lcb9c)
            db   low(Lcbae)
            db   0
            db   low(Lcbc0)
            db   low(Lcbc6)
            db   low(Lcbe1)
            db   0
            db   low(Lc902)
            db   low(Lc946)
            db   low(Lcbf6)
            db   0,#82,#72,#3C,#7F
            db   low(Lcbfd)
            db   low(Lcc19)
            db   low(Lcc24)
            db   0
            db   low(Lcc39)
            db   low(Lcc58)
            db   low(Lcc5e)
            db   0
            db   low(Lcc77)
            db   low(Lc902)
            db   low(Lcec8)
            db   #15,#0A,#1C,#1D,#A4
            db   low(Lcc7e)
            db   low(Lcc9a)
            db   low(Lccb9)
            db   0
            db   low(Lccc0)
            db   low(Lccd5)
            db   low(Lcec8)
            db   0
            db   low(Lccee)
            db   low(Lccf9)
            db   low(Lc902)


END11:

            ADRXX00

L96:
            db   high(Lceb1)
            db   high(Lcdf6)
            db   high(Lcdcd)
            db   0
            db   high(Lcda4)
            db   high(Lc903)
            db   high(Lc91d)
            db   0
            db   high(Lcd7b)
            db   high(Lc937)
            db   high(Lc951)
            db   0,0,0,0,0
            db   high(Lc96b)
            db   high(Lc902)
            db   high(Lc971)
            db   0
            db   high(Lc977)
            db   high(Lc912)
            db   high(Lc989)
            db   0
            db   high(Lc9a1)
            db   high(Lc9b3)
            db   high(Lc9ba)
            db   0,#55,1,0,0
            db   high(Lc9cc)
            db   high(Lc9d2)
            db   high(Lc902)
            db   0
            db   high(Lc9d8)
            db   high(Lc9ea)
            db   high(Lc9fc)
            db   0
            db   high(Lca03)
            db   high(Lca15)
            db   high(Lc960)
            ds   21
            db   high(Lca2d)
            db   high(Lca33)
            db   high(Lca45)
            db   0
            db   high(Lc902)
            db   high(Lca57)
            db   high(Lc92c)
            db   0
            db   high(Lca5e)
            db   high(Lca64)
            db   high(Lca79)
            db   0,0,2,0,0
            db   high(Lca94)
            db   high(Lcab0)
            db   high(Lcab7)
            db   0
            db   high(Lcad6)
            db   high(Lc902)
            db   high(Lcae1)
            db   0
            db   high(Lcae7)
            db   high(Lcec8)
            db   high(Lcafc)
            db   0,0,0,0,0
            db   high(Lcb15)
            db   high(Lcb31)
            db   high(Lcb46)
            db   0
            db   high(Lcb51)
            db   high(Lcec8)
            db   high(Lc902)
            db   0
            db   high(Lcb58)
            db   high(Lcb77)
            db   high(Lcb90)
            ds   21
            db   high(Lcb96)
            db   high(Lcb9c)
            db   high(Lcbae)
            db   0
            db   high(Lcbc0)
            db   high(Lcbc6)
            db   high(Lcbe1)
            db   0
            db   high(Lc902)
            db   high(Lc946)
            db   high(Lcbf6)
            db   #20,#B2,0,0,#64
            db   high(Lcbfd)
            db   high(Lcc19)
            db   high(Lcc24)
            db   0
            db   high(Lcc39)
            db   high(Lcc58)
            db   high(Lcc5e)
            db   0
            db   high(Lcc77)
            db   high(Lc902)
            db   high(Lcec8)
            db   0,0,0,0,0
            db   high(Lcc7e)
            db   high(Lcc9a)
            db   high(Lccb9)
            db   0
            db   high(Lccc0)
            db   high(Lccd5)
            db   high(Lcec8)
            db   0
            db   high(Lccee)
            db   high(Lccf9)
            db   high(Lc902)
            db   0,0,0,0,0

Ld1l:
            dw   #4080
            dw   #1020
            dw   #0408
            dw   #0102
            dw   #BF7F
            dw   #EFDF
            dw   #FBF7
            dw   #FEFD


Carsb:
            dw   0,0
ZET:        dw   1500
Indexx:     db   0
ALFA:       db   0,0,0
            ds   Olen-10
            dw   #8080
            ds   Olen-2




NAMSH:
            db   CR,132,174,172,168,173,168,174,173,2,"64000"
            db   CR,145,174,228,168,225,226,2,"44000"
            db   CR,140,165,172,228,168,225,2,"40000"
            db   CR,148,168,224,225,2,"35000"
            db   CR,142,224,225,160,173,2,"34000"
            db   CR,129,160,224,174,225,2,"27000"
TD1:        db   ET
            db   138,160,224,237,173,2,"13000"
            db   ET


NAMSK:
            db   CR,148,165,224,162,165,225,226,2,"30000"
            db   CR,138,224,168,164,160,173,2,"27000"
            db   CR,143,224,174,226,174,225,2,"24000"
            db   CR,128,171,163,174,171,2,"18000"
            db   ET



TSHIP:
;  ПУНКТЫ МЕНЮ ХЕЛПА
;  ХЕДЕР ДЛЯ ПОКУП.КОРАБЛЯ
;  db"Модель",2
;  db"Цена",CR
;  db"                               ",ET



Sets:       db   0
Indx:       db   0
Objx:       dw   0
Objy:       dw   0
Objz:       dw   0


Indt1:      db   0
Indt2:      db   0


            ADRXX00

L97:        equ  high($)
            dw   Pushkad,Pushkad
            dw   Klopd,Klopd
            dw   Kryld,Kryld
            dw   Treugd,Treugd
            dw   Kobrad,Kobrad
            dw   Wognd,Wognd
            dw   Pushkad,Pushkad
            dw   Istr,Istr
            dw   Sturm,Sturm
            dw   Turi,Turi
            dw   Trad,Trad


