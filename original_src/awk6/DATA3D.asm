
L90k
            insert "D9000.dat"

Eye_a       equ  #C200
Eye_b       equ  #C201
Eye_g       equ  #C202
La11        equ  #C20C-1
La12        equ  #C20E-1
Lb13        equ  #C210-1
La21        equ  #C212-1
La22        equ  #C214-1
Lb23        equ  #C216-1
La31        equ  #C218-1
La32        equ  #C21A-1
Lb33        equ  #C21C-1
Eyea        equ  #C21E
Eyeb        equ  #C21F
Eyeg        equ  #C220

L91         equ  #C221
L90         equ  #C200

            ds   #0100

Multb       equ  $.h
Sintb       equ  Multb+1
            insert "D9200.dat"
L9c         equ  $.h
            ds   #0100
L9d         equ  $.h
            ds   #0100
L9e         equ  $.h
            ds   #0100

TBXX2       ds   #0300

L95
            db   Lceb1.b
            db   Lcdf6.b
            db   Lcdcd.b
            db   0
            db   Lcda4.b
            db   Lc903.b
            db   Lc91d.b
            db   0
            db   Lcd7b.b
            db   Lc937.b
            db   Lc951.b
            db   0,0,2,0,1
            db   Lc96b.b
            db   Lc902.b
            db   Lc971.b
            db   0
            db   Lc977.b
            db   Lc912.b
            db   Lc989.b
            db   0
            db   Lc9a1.b
            db   Lc9b3.b
            db   Lc9ba.b
            db   0,0,0,0,0
            db   Lc9cc.b
            db   Lc9d2.b
            db   Lc902.b
            db   0
            db   Lc9d8.b
            db   Lc9ea.b
            db   Lc9fc.b
            db   0
            db   Lca03.b
            db   Lca15.b
            db   Lc960.b
            ds   21
            db   Lca2d.b
            db   Lca33.b
            db   Lca45.b
            db   0
            db   Lc902.b
            db   Lca57.b
            db   Lc92c.b
            db   0
            db   Lca5e.b
            db   Lca64.b
            db   Lca79.b
            db   0,0,0,0,0
            db   Lca94.b
            db   Lcab0.b
            db   Lcab7.b
            db   0
            db   Lcad6.b
            db   Lc902.b
            db   Lcae1.b
            db   0
            db   Lcae7.b
            db   Lcec8.b
            db   Lcafc.b
            db   0,0,0,#0A,#90
            db   Lcb15.b
            db   Lcb31.b
            db   Lcb46.b
            db   0
            db   Lcb51.b
            db   Lcec8.b
            db   Lc902.b
            db   0
            db   Lcb58.b
            db   Lcb77.b
            db   Lcb90.b
            ds   21
            db   Lcb96.b
            db   Lcb9c.b
            db   Lcbae.b
            db   0
            db   Lcbc0.b
            db   Lcbc6.b
            db   Lcbe1.b
            db   0
            db   Lc902.b
            db   Lc946.b
            db   Lcbf6.b
            db   0,#82,#72,#3C,#7F
            db   Lcbfd.b
            db   Lcc19.b
            db   Lcc24.b
            db   0
            db   Lcc39.b
            db   Lcc58.b
            db   Lcc5e.b
            db   0
            db   Lcc77.b
            db   Lc902.b
            db   Lcec8.b
            db   #15,#0A,#1C,#1D,#A4
            db   Lcc7e.b
            db   Lcc9a.b
            db   Lccb9.b
            db   0
            db   Lccc0.b
            db   Lccd5.b
            db   Lcec8.b
            db   0
            db   Lccee.b
            db   Lccf9.b
            db   Lc902.b


END11

            ADRXX00

L96
            db   Lceb1.h
            db   Lcdf6.h
            db   Lcdcd.h
            db   0
            db   Lcda4.h
            db   Lc903.h
            db   Lc91d.h
            db   0
            db   Lcd7b.h
            db   Lc937.h
            db   Lc951.h
            db   0,0,0,0,0
            db   Lc96b.h
            db   Lc902.h
            db   Lc971.h
            db   0
            db   Lc977.h
            db   Lc912.h
            db   Lc989.h
            db   0
            db   Lc9a1.h
            db   Lc9b3.h
            db   Lc9ba.h
            db   0,#55,1,0,0
            db   Lc9cc.h
            db   Lc9d2.h
            db   Lc902.h
            db   0
            db   Lc9d8.h
            db   Lc9ea.h
            db   Lc9fc.h
            db   0
            db   Lca03.h
            db   Lca15.h
            db   Lc960.h
            ds   21
            db   Lca2d.h
            db   Lca33.h
            db   Lca45.h
            db   0
            db   Lc902.h
            db   Lca57.h
            db   Lc92c.h
            db   0
            db   Lca5e.h
            db   Lca64.h
            db   Lca79.h
            db   0,0,2,0,0
            db   Lca94.h
            db   Lcab0.h
            db   Lcab7.h
            db   0
            db   Lcad6.h
            db   Lc902.h
            db   Lcae1.h
            db   0
            db   Lcae7.h
            db   Lcec8.h
            db   Lcafc.h
            db   0,0,0,0,0
            db   Lcb15.h
            db   Lcb31.h
            db   Lcb46.h
            db   0
            db   Lcb51.h
            db   Lcec8.h
            db   Lc902.h
            db   0
            db   Lcb58.h
            db   Lcb77.h
            db   Lcb90.h
            ds   21
            db   Lcb96.h
            db   Lcb9c.h
            db   Lcbae.h
            db   0
            db   Lcbc0.h
            db   Lcbc6.h
            db   Lcbe1.h
            db   0
            db   Lc902.h
            db   Lc946.h
            db   Lcbf6.h
            db   #20,#B2,0,0,#64
            db   Lcbfd.h
            db   Lcc19.h
            db   Lcc24.h
            db   0
            db   Lcc39.h
            db   Lcc58.h
            db   Lcc5e.h
            db   0
            db   Lcc77.h
            db   Lc902.h
            db   Lcec8.h
            db   0,0,0,0,0
            db   Lcc7e.h
            db   Lcc9a.h
            db   Lccb9.h
            db   0
            db   Lccc0.h
            db   Lccd5.h
            db   Lcec8.h
            db   0
            db   Lccee.h
            db   Lccf9.h
            db   Lc902.h
            db   0,0,0,0,0

Ld1l
            dw   #4080
            dw   #1020
            dw   #0408
            dw   #0102
            dw   #BF7F
            dw   #EFDF
            dw   #FBF7
            dw   #FEFD


Carsb
            dw   0,0
ZET         dw   1500
Indexx      db   0
ALFA        db   0,0,0
            ds   Olen-10
            dw   #8080
            ds   Olen-2




NAMSH
            db   CR,"Доминион",2,"64000"
            db   CR,"Софист",2,"44000"
            db   CR,"Мемфис",2,"40000"
            db   CR,"Фирс",2,"35000"
            db   CR,"Орсан",2,"34000"
            db   CR,"Барос",2,"27000"
TD1         db   ET
            db   "Карэн",2,"13000"
            db   ET


NAMSK
            db   CR,"Фервест",2,"30000"
            db   CR,"Кридан",2,"27000"
            db   CR,"Протос",2,"24000"
            db   CR,"Алгол",2,"18000"
            db   ET



TSHIP
 ПУНКТЫ МЕНЮ ХЕЛПА
 ХЕДЕР ДЛЯ ПОКУП.КОРАБЛЯ
 db "Модель",2
 db "Цена",CR
 db "                               ",ET



Sets        db   0
Indx        db   0
Objx        dw   0
Objy        dw   0
Objz        dw   0


Indt1       db   0
Indt2       db   0


            ADRXX00

L97         equ  $.h
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


