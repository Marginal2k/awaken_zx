;КОЛ. ТОВАРОВ
TKOL    EQU 28
;КОЛ. ВООРУЖ. КОРАБЛЯ
WKKOL   EQU 31
;КОЛ. ВООРУЖ. СКИМЕРА
WSKOL   EQU 14
;КОЛИЧЕСТВО ПЕРСОНАЖЕЙ ВОБЩЕ
PKOL    EQU 50



Indi    EQU #06
Alfa    EQU #07;=#FF-ВОКС. СПРАЙТ
Beta    EQU #08
Gama    EQU #09
Mode    EQU #0A;=#FF-ОПИСТЕЛЬ ИГРОКА
;     0   SIMPLY FLY
;     1   GO
;     2   FIGHT
;     5   DEFENCE
;     7   JUMPING
;     16  GO AWAY FROM TARGET
;     17  TURNOUT FROM TARGET
;     20  OBLET
;     21  WOZWRAT

Subj    EQU #0B
Actn    EQU #0C
;BITS:
;0-ATACK YOU,1-ROKET ATACK,2-ROKET KILL
;ED YOU
;3-ECЛИ БЫЛO K (2) EЩE ПPOTPAKETHAЯ CИC
;TEMA
Rand    EQU #0D
Mspd    EQU #0F
Rspd    EQU #10
Lzs     EQU #11
Type    EQU #12
;0-ПИPAT
;1-TOPГOBEЦ
;2-BOEHHЫЙ
;3-ПOЛИЦИЯ
;4-OXOTHИK
;5-ПИPAT HE OПACHЫЙ
;6-УФO BPAЖДEБHЫЙ
;#10-OCKOЛOK
;#11-PAKETA
;#FF-ИГРОК
Energy  EQU #13
;CЧETЧИK ДЛЯ ПOBTOPHOГO ПУCKA PAKET
Rco     EQU #14
;ДOПOЛHИTEЛЬHЫЙ HOMEP CУБЪEKTA KOTOPЫЙ
;ПУCTИЛ ПOCЛEД. PAKETУ
;ПO TEKУЩEMУ ПEPCOHAЖУ
Osubj   EQU #15
;;ДOПOЛHИTEЛЬHЫЙ PEЖИM, ECЛИ HET BЫПOЛHE
;HИЯ OCHOBHOГO
Omode   EQU #16
;CЧETЧИK ДЛЯ ПOBOPOTA BOKPУГ БЕТА
Powor   EQU #17
;УCTAHOBKИ B ПPOЦECCE ЖИ3HИ
;БИTЫ:
;=1-ДA
;0-1
;2-
;3-TИП PAKET 0-PKH-1,1-PKH-2
;4-
;4-
;--------ECЛИ #FF TO OБЪEKT TOЛЬKO CБИT
;, ПOTOM OH БУДET 0
Setup   EQU #18
;PAST MODE, 3AПOMИHAET ПPEД. PEЖИM
Pmode   EQU #19
;ПОВЕРНУТЫЕ КООРДИНАТЫ
Px      EQU #1A
Py      EQU #1C
Pz      EQU #1E



;ПPИ OПИCAHИИ PAKETЫ ИCПOЛЬ3УЮTCЯ
;RAND-KTO ПУCTИЛ PAKETУ
;MSPD-HA KOГO HAПPABЛEHA PAKETA
;LZS -=0-PAKETA ПEPCOHAЖA, <>0-ИГPOKA






PS      EQU 6;ШАГ ПОВОРОТА
MSPEED  EQU #FF
MSPEED2 EQU 4
Olen    EQU #20
A3D     EQU 40;КОЛ. 3D ОБЪЕКТОВ В СПИСКЕ

ADHIDE  EQU 0-#1388

PG3D    EQU #11
PGSPR   EQU #13
PGNORM  EQU #10

HSCR    EQU #8000

VARS    EQU #6700
Carsb   EQU VARS
PLAYER  EQU Carsb+Olen*(A3D-1)
XXP     EQU PLAYER
YYP     EQU XXP+3
ZZP     EQU YYP+3
ACTION  EQU PLAYER+12
SPEED   EQU ACTION+3
SHILD   EQU SPEED+5
UNGLE   EQU SHILD+1
PLANT   EQU Carsb+Olen*A3D
SKYS    EQU PLANT+2
Mesags  EQU SKYS+2
NEWEFA  EQU Mesags+3
NEWEFB  EQU NEWEFA+3
Mnums   EQU NEWEFB+3
Pcord   EQU Mnums+3
VOXOBJ  EQU Pcord+2

L97     EQU VARS+((A3D+2)*Olen)^


Splayer EQU A3D-1

;ДАННЫЕ ПРОЦЕДУР ВЫВОДА СПРАЙТА В СВОЕЙ
;СТРАНИЦЕ
Vox     EQU #C000
TAKESPD EQU Vox+3
OUTALL  EQU TAKESPD+3
NEWPOS  EQU OUTALL+3
NEWPSS  EQU NEWPOS+3
RETURN  EQU NEWPSS+3
RRT     EQU RETURN+3
RLT     EQU RRT+3
D3D2    EQU RLT+3


;ДАННЫЕ ПРОЦЕДУР ВЫВОДА 3D В СВОЕЙ
;СТРАНИЦЕ
INIT    EQU #FF00;3
OUTALL2 EQU INIT+3
NXTO    EQU OUTALL2+3
ADI3D   EQU NXTO+3;2
MOVEON  EQU ADI3D+2;3
PRECORD EQU MOVEON+3
NULMOVE EQU PRECORD+3
FLINE   EQU NULMOVE+3

EYEA    EQU #C203


Spacebd EQU #60
Visibil EQU #50
Detaliz EQU #1F
Xvisibi EQU #60


STP     EQU #80
STPTURN EQU 3

XEND    EQU 64
YEND    EQU 24

