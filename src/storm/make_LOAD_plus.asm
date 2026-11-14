; awk5 LOAD+ : variant of LOAD (clears screens first)
        DEVICE ZXSPECTRUM48
        INCLUDE "awk5/LOAD_plus.asm"
MOD_END
        SAVEBIN "../../work/storm/out/LOAD_plus.bin", #8000, MOD_END-#8000
