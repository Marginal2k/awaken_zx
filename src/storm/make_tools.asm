; One-shot converter / generator programs of the author (each ORGs at #6000/#7000/#8000; they are not game code).
;   CNVVOXS3  voxel sprite  #0X -> #XX nibble format + cut out a 14x32 sprite   (input: assets/drv2.bin at #C000)
;   CNVVOXSP  same conversion for a 3072 byte sprite                            (input: assets/CHAN1.bin at #8000)
;   CNVVOXTB  de-interleaves the VOX table into the voxel line table           (input: assets/VOX.bin at #8000)
;   INVTAB3D  turns the texture table D9000+ into D9000 (verified byte exact by tools/verify_storm.py)
; They are assembled one after the other (each in its own MODULE, labels M1... repeat) to prove every source converts cleanly.
        DEVICE ZXSPECTRUM48
        MODULE cnvvoxs3
        INCLUDE "CNVVOXS3.asm"
        ENDMODULE
        MODULE cnvvoxsp
        INCLUDE "CNVVOXSP.asm"
        ENDMODULE
        MODULE cnvvoxtb
        INCLUDE "CNVVOXTB.asm"
        ENDMODULE
        MODULE invtab3d
        INCLUDE "INVTAB3D.asm"
        ENDMODULE
