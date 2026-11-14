; Build of S3D.C (station 3D / voxel object engine page, loaded at #C000 of RAM page #11)
; STORM compiled straight into memory; the saved file is the memory span #C000..#FF17.
; Gap bytes between blocks (alignment padding after ORG $^) are uninitialised memory in the original file.
        DEVICE ZXSPECTRUM48
        IFDEF FILL
        ORG #C000
        DS #4000,FILL
        ENDIF
        INCLUDE "S3D.asm"
        SAVEBIN "../../work/storm/out/S3D.bin", #C000, #FF17-#C000
