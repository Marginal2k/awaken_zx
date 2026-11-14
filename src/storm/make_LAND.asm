; Build of LAND (planet surface + sky).  No compiled binary of LAND survives on the disks (LAND.C on awk2 is the source).
; Memory map produced by the source:
;   #7C00..END_  : main program (START #7C00; DROPSCR module runs at ADHIDE; #8000 and #8C00 blocks)
;   #6000..END0  : FONT + DATAM (mission / trade tables)
;   after END_   : page aligned planet textures (planet, CHAN6, DRV1, DRV2, DOMA1)
        DEVICE ZXSPECTRUM48
        INCLUDE "LAND.asm"
        SAVEBIN "../../work/storm/out/LAND.bin", #7C00, END_-#7C00
        SAVEBIN "../../work/storm/out/LAND_data.bin", #6000, END0-#6000
