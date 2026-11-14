
;КОЛ. ТОВАРОВ
TKOL:       equ  28
;КОЛ. ВООРУЖ. КОРАБЛЯ
WKKOL:      equ  31
;КОЛ. ВООРУЖ. СКИМЕРА
WSKOL:      equ  14
;КОЛИЧЕСТВО ПЕРСОНАЖЕЙ ВОБЩЕ
PKOL:       equ  50



Indi:       equ  #06
Alfa:       equ  #07                ;=#FF-ВОКС. СПРАЙТ
Beta:       equ  #08
Gama:       equ  #09
Mode:       equ  #0A                ;=#FF-ОПИСТЕЛЬ ИГРОКА
;     0   SIMPLY FLY
;     1   GO
;     2   FIGHT
;     5   DEFENCE
;     7   JUMPING
;     16  GO AWAY FROM TARGET
;     17  TURNOUT FROM TARGET
;     20  OBLET
;     21  WOZWRAT

Subj:       equ  #0B
Actn:       equ  #0C
;BITS:
;0-ATACK YOU,1-ROKET ATACK,2-ROKET KILL
;ED YOU
;3-ECЛИ БЫЛO K (2) EЩE ПPOTPAKETHAЯ CИC
;TEMA
Rand:       equ  #0D
Mspd:       equ  #0F
Rspd:       equ  #10
Lzs:        equ  #11
Type:       equ  #12
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
Energy:     equ  #13
;CЧETЧИK ДЛЯ ПOBTOPHOГO ПУCKA PAKET
Rco:        equ  #14
;ДOПOЛHИTEЛЬHЫЙ HOMEP CУБЪEKTA KOTOPЫЙ
;ПУCTИЛ ПOCЛEД. PAKETУ
;ПO TEKУЩEMУ ПEPCOHAЖУ
Osubj:      equ  #15
;;ДOПOЛHИTEЛЬHЫЙ PEЖИM, ECЛИ HET BЫПOЛHE
;HИЯ OCHOBHOГO
Omode:      equ  #16
;CЧETЧИK ДЛЯ ПOBOPOTA BOKPУГ БЕТА
Powor:      equ  #17
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
Setup:      equ  #18
;PAST MODE, 3AПOMИHAET ПPEД. PEЖИM
Pmode:      equ  #19
;ПОВЕРНУТЫЕ КООРДИНАТЫ
Px:         equ  #1A
Py:         equ  #1C
Pz:         equ  #1E



;ПPИ OПИCAHИИ PAKETЫ ИCПOЛЬ3УЮTCЯ
;RAND-KTO ПУCTИЛ PAKETУ
;MSPD-HA KOГO HAПPABЛEHA PAKETA
;LZS -=0-PAKETA ПEPCOHAЖA, <>0-ИГPOKA






PS:         equ  6                  ;ШАГ ПОВОРОТА
MSPEED:     equ  #FF
MSPEED2:    equ  4
Olen:       equ  #20
A3D:        equ  40                 ;КОЛ. 3D ОБЪЕКТОВ В СПИСКЕ

ADHIDE:     equ  0-#1388

PG3D:       equ  #11
PGSPR:      equ  #13
PGNORM:     equ  #10

HSCR:       equ  #8000

VARS:       equ  #6700
Carsb:      equ  VARS
PLAYER:     equ  (Carsb+Olen)*(A3D-1)
XXP:        equ  PLAYER
YYP:        equ  XXP+3
ZZP:        equ  YYP+3
ACTION:     equ  PLAYER+12
SPEED:      equ  ACTION+3
SHILD:      equ  SPEED+5
UNGLE:      equ  SHILD+1
PLANT:      equ  (Carsb+Olen)*A3D
SKYS:       equ  PLANT+2
Mesags:     equ  SKYS+2
NEWEFA:     equ  Mesags+3
NEWEFB:     equ  NEWEFA+3
Mnums:      equ  NEWEFB+3
Pcord:      equ  Mnums+3
VOXOBJ:     equ  Pcord+2

L97:        equ  VARS+((((A3D+2)*Olen)+255)/256*256)


Splayer:    equ  A3D-1

;ДАННЫЕ ПРОЦЕДУР ВЫВОДА СПРАЙТА В СВОЕЙ
;СТРАНИЦЕ
Vox:        equ  #C000
TAKESPD:    equ  Vox+3
OUTALL:     equ  TAKESPD+3
NEWPOS:     equ  OUTALL+3
NEWPSS:     equ  NEWPOS+3
RETURN:     equ  NEWPSS+3
RRT:        equ  RETURN+3
RLT:        equ  RRT+3
D3D2:       equ  RLT+3


;ДАННЫЕ ПРОЦЕДУР ВЫВОДА 3D В СВОЕЙ
;СТРАНИЦЕ
INIT:       equ  #FF00              ;3
OUTALL2:    equ  INIT+3
NXTO:       equ  OUTALL2+3
ADI3D:      equ  NXTO+3             ;2
MOVEON:     equ  ADI3D+2            ;3
PRECORD:    equ  MOVEON+3
NULMOVE:    equ  PRECORD+3
FLINE:      equ  NULMOVE+3

EYEA:       equ  #C203


Spacebd:    equ  #60
Visibil:    equ  #50
Detaliz:    equ  #1F
Xvisibi:    equ  #60


STP:        equ  #80
STPTURN:    equ  3

XEND:       equ  64
YEND:       equ  24

