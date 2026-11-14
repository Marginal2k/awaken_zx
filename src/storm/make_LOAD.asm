; awk5 LOAD: raw-FDC sprite/screen animation loader (STORM source, no compiled copy kept)
        DEVICE ZXSPECTRUM48
        INCLUDE "awk5/LOAD.asm"
MOD_END
        SAVEBIN "../../work/storm/out/LOAD.bin", #8000, MOD_END-#8000
