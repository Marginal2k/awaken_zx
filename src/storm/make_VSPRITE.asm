; Build of VSPRIT.C (voxel sprite / planet-surface renderer page, #C000)
        DEVICE ZXSPECTRUM48
        IFDEF FILL
        ORG #C000
        DS #4000,FILL
        ENDIF
        INCLUDE "VSPRITE.asm"
        SAVEBIN "../../work/storm/out/VSPRITE.bin", #C000, END_-#C000
