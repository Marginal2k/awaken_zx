; awk5 INVDISK: inverts (CPL) 159 sectors of a disk in place
        DEVICE ZXSPECTRUM48
        INCLUDE "awk5/INVDISK.asm"
MOD_END
        SAVEBIN "../../work/storm/out/INVDISK.bin", #7000, MOD_END-#7000
