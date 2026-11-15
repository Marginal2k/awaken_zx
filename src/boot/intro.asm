; ------------------------------------------------------------------------------------------
; intro.asm - the intro animation of the demo v0.2 (file "INTRO   C", loaded to #6400, entry #6500).
;
; Source: disassembly of the 44-sector payload that the demo's BASIC loader AWAKEN.B read to #6400 (work/boot_payload.bin).
; It was NOT part of the 1999 developer sources.  Reassembled byte-exact (checked against the payload with -DDISK_ORIGINAL
; style; only the tail stub differs by design: it uses disk.asm and the real STATIONF length).
;
; What it does:  copies the tail stub to #5D3B, clears the screen, plays effects built from run-time generated code
; (unrolled LDI/POP blocks at #9100-#B3xx, buffers at #7E00-#8FFF, banks 4/6 at #C000), shows the "Awaken" logo,
; then loads STATIONF.C and starts the station.  SPACE skips the effects (RunFrames); there is no music.
; Effect routines are named by what they were seen to do; the maths of the individual effects was not analysed.
; Self-modified operands are labelled (e.g. L66D4 = operand of the instruction at L66D3).
; ------------------------------------------------------------------------------------------
            DEVICE ZXSPECTRUM48
            include "../common/disk.asm"
            include "../common/state.inc"
            IFNDEF STATION_SECTORS
STATION_SECTORS equ #C0                 ; build.py passes the real sector count of STATIONF.C (-DSTATION_SECTORS=n)
            ENDIF

            org  #6400
L6400:
            db   #FF,#FF,#FF,#FF,#FE,#FE,#FE,#FD,#FD,#FC,#FB,#FA,#FA,#F9,#F8,#F6
            db   #F5,#F4,#F3,#F1,#F0,#EE,#ED,#EB,#EA,#E8,#E6,#E4,#E2,#E0,#DE,#DC
            db   #DA,#D7,#D5,#D3,#D0,#CE,#CB,#C9,#C6,#C4,#C1,#BE,#BC,#B9,#B6,#B3
            db   #B0,#AD,#AA,#A7,#A5,#A2,#9E,#9B,#98,#95,#92,#8F,#8C,#89,#86,#83
L6440:
            db   #80,#7C,#79,#76,#73,#70,#6D,#6A,#67,#64,#61,#5D,#5A,#58,#55,#52
            db   #4F,#4C,#49,#46,#43,#41,#3E,#3B,#39,#36,#34,#31,#2F,#2C,#2A,#28
            db   #25,#23,#21,#1F,#1D,#1B,#19,#17,#15,#14,#12,#11,#0F,#0E,#0C,#0B
            db   #0A,#09,#07,#06,#05,#05,#04,#03,#02,#02,#01,#01,#01,#00,#00
L647F:
            db   #00,#00
L6481:
            ds   127
            di
            ld hl,TailStub
            ld de,#5d3b
            ld bc,#0100
            ldir
            ld sp,#5fff
            sub a
            out (#fe),a
            ld hl,OverlayArea
            ld de,#4000
            ld bc,#1b00
            ldir
            ld hl,Depacker
            ld de,OverlayArea
            ld bc,#1b00
            ldir
            ld c,#ff
            call FillScreen
            ld iy,#5c3a
            ld (IntroSP),sp
            call Page11
            ld hl,#c000
            ld de,#c001
            ld bc,#3fff
            ld (hl),l
            ldir
            ld hl,#6000
            ld de,#6001
            ld bc,#03ff
            ld (hl),l
            ldir
            ld hl,L8F93
            ld de,L8F94
            ld bc,#306c
            ld (hl),#00
            ldir
            ld a,#14
            call SetPage
            ld hl,#c000
            ld de,#c001
            ld bc,#12ff
            ld (hl),l
            ldir
            ld a,#16
            call SetPage
            ld hl,#c000
            ld de,#c001
            ld bc,#3fff
            ld (hl),l
            ldir
            call InitRowTabs
            call MakeBackdrop
            call InitStarTable
            ei
            call InitEffect2
            call RunEffect2
            call InitSprite
            call MakeWarpCode
            ld c,#00
            call FillScreen
            ld hl,#5800
            ld de,#5801
            ld bc,#01ff
            ld (hl),#88
            ldir
            ld bc,#012c
            ld hl,FrameFinal
            call RunFrames
; SPACE during the effects jumps here: straight to the tail stub (logo + loading of the station)
IntroSkip:  jp #5d3b
            db   #00
; saved SP (the effect code uses the stack as a data pointer)
IntroSP:
            db   #00,#00,#00
; ---- tail stub: copied to #5D3B (BASIC area) and run from there: depack the logo into the screen, mirror it to
;      the shadow screen, then load STATIONF.C to #6000 and enter it at #6300 ----
TailStub:   call OverlayArea
            ld a,#1f
            ld bc,#7ffd
            out (c),a
            ld hl,#d800
            ld de,#d801
            ld bc,#02ff
            ld (hl),l
            ldir
            ld hl,#4000
            ld de,#c000
            ld bc,#1b00
            ldir
            di
            ld sp,#5fff
            ld a,#3f
            ld i,a
            im 1
            ld a,#18
            ld bc,#7ffd
            out (c),a
            ld iy,#5c3a
            ; [glue] the demo did the same with raw TR-DOS calls and read 192 sectors; now via disk.asm and the real file length
            DISK_SETNAME TailName
            DISK_FIND
            ld a,c                      ; A = catalogue index of the file
            DISK_INFO                   ; -> (#5CEB) track/sector of the first sector
            ld hl,STATION_ENTRY
            push hl                     ; TR-DOS returns into the station entry
            ld hl,#6000
            ld de,(TRDOS_SECTOR)
            ld b,STATION_SECTORS
            DISK_RDSEC_TAIL
; file name for the TR-DOS find
TailName:   db   "STATIONFC"
; per-frame routine of the closing sequence (called by RunFrames)
FrameFinal: ld a,#16
            ld de,#ffff
            ld hl,L662C
            ld bc,#6632
            jp WarpFrame
L662C:
            db   #00,#80,#00,#00,#00,#00,#00,#80,#00,#00,#00,#00
InitStarTable:ld a,#6f
            ld hl,StarTab
            call BuildSprites
            ld de,L8000
            ld h,#a0
.L6645      ld l,#00
.L6647      ld a,(hl)
            srl a
            srl a
            ld (de),a
            inc l
            inc e
            ld a,(hl)
            ld (de),a
            inc l
            inc e
            jr nz,.L6647
            inc h
            inc d
            bit 6,d
            jr z,.L6645
            ld a,#16
            call SetPage
            jp ShowFrame
; 7 + 11 byte offsets used by BuildSprites (table of 7 and 11 columns)
StarTab:
            db   #14,#1C,#24,#2B,#31,#36,#3B,#00,#04,#08,#0B,#0E,#11,#13,#15,#16
            db   #17,#18,#19,#1A,#1B,#1B,#1C,#1D,#1D,#1E,#1E,#1F,#1F,#20,#20,#21
            db   #21,#21,#22,#22,#22,#23,#23,#23,#24,#24,#24,#25,#25,#25,#26,#26
            db   #26,#26,#27,#27,#27,#27,#28,#28,#28,#28,#28,#29,#29,#29,#29,#29
WarpFrame:  call WaitFrame
            push bc
            call SetPage
            ld a,(L66EC)
            add a,d
            and #3f
            ld (L66EC),a
            ld a,(L66ED)
            add a,e
            and #3f
            or #80
            ld (L66ED),a
            call SlopeInit
            sub #60
            add a,a
            ld (L66D4),a
            pop hl
            call SlopeInit
            add a,#50
            ld (L66D5),a
            ld d,#80
            exx
L66D3:      ld hl,#cd40
            call L66E2
            call WaitFrame
            call L66E2
            jp NextWarp
L66E2:      ld (L66F8),sp
            ld b,#10
L66E8:      ld sp,hl
            inc h
            exx
L66EB:      ld bc,#8000
            ld e,#c0
            jp L7E00
L66F3:      inc d
            exx
            djnz L66E8
L66F7:      ld sp,#3131
            ret
MakeWarpCode:ld de,L7E00
            ld hl,L6722
            ld bc,#4007
            call RepeatLdir
            ld de,L66F3
            call PokeJp
            ld ixl,#80
            call FadeCopy
            ld ixl,#80
            ld de,L80C0
            ld bc,#0100
            call MakeBlitCode
            jp BlitWait
L6722:      pop hl
            add hl,bc
            res 6,h
            ld a,(hl)
            ld (de),a
            inc e
FadeCopy:   ld a,#14
            call SetPage
            ld d,#80
            ld hl,#c000
.L6733      ld e,#00
            ld b,#40
.L6737      ld a,(hl)
            add a,ixl
            ld (de),a
            inc hl
            inc e
            djnz .L6737
            inc d
            bit 6,d
            jr z,.L6733
            ld h,#80
            ld d,h
.L6747      ld bc,#00c0
            ld l,b
            ld e,#40
            ldir
            inc h
            bit 6,h
            jr z,.L6747
            jp Page11
ShowFrame:  ld bc,#4000
            ld hl,L8000
            ld de,#c000
            ldir
            ret
BuildSprites:ld (L6786),hl
            ld (L678E),a
            call Page11
            ld hl,#0000
            ld (L6793),hl
            ld hl,#4000
            ld (L679E),hl
            ld hl,L8000
            ld bc,#7fff
            ld a,c
            call FillMem
            ld b,#3f
L6784:      push bc
L6785:      ld hl,#2121
            ld a,(hl)
            inc hl
            ld (L6786),hl
L678D:      ld iyl,a
            ld bc,#8000
L6792:      ld de,#0000
            inc e
            inc e
            inc e
            inc de
            ld (L6793),de
L679D:      ld hl,#4000
            dec h
            ld (L679E),hl
.L67A4      ld a,h
            ld (bc),a
            add hl,de
            inc c
            bit 7,c
            jp z,.L67A4
            ld bc,#6400
            ld ix,L6440
.L67B4      ld h,#80
            ld a,(bc)
            ld l,a
            srl l
            ld e,(hl)
            ld l,(ix+#00)
            srl l
            ld d,(hl)
            sla e
            set 7,d
            ld a,c
            ld (de),a
            inc e
            ld a,iyl
            ld (de),a
            inc ixl
            inc c
            jr nz,.L67B4
            pop bc
            djnz L6784
            ld ixl,#02
.L67D6      ld hl,L8100
.L67D9      inc l
            ld a,(hl)
            cp #ff
            jr nz,.L67E7
            inc h
            ld d,(hl)
            dec l
            ld e,(hl)
            dec h
            ld (hl),e
            inc l
            ld (hl),d
.L67E7      inc hl
            bit 7,h
            jr nz,.L67D9
            dec ixl
            jr nz,.L67D6
            ret
NextWarp:   ld a,#00
            add a,#80
            ld (L67F2),a
            ld hl,#0000
            jr nz,L67FF
L67FD:      ld h,#14
L67FF:      ld (L6839),hl
            call WaitFrame
            jr nz,.L6818
            ld hl,#6100
            call L6827
            ld hl,#60c0
            call L68A4
            ld hl,#6000
            jr L6827
.L6818      ld hl,#6000
            call L6827
            ld hl,#61c0
            call L68A4
            ld hl,#6100
L6827:      ld (L6831),hl
            ld (L68A1),sp
            ld a,#26
L6830:      ld sp,#3131
            pop hl
            pop de
            ld (L6831),sp
L6839:      nop
            nop
            ld sp,hl
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            pop hl
            ldi
            dec a
            jp nz,L6830
L68A0:      ld sp,#3131
            ret
L68A4:      ld (L692A),sp
            ld sp,hl
L68A9:      nop
            ds   127
L6929:      ld sp,#3131
            ret
MakeBlitCode:exx
            ld hl,L68A9
            ld d,ixl
            ld c,#08
.L6935      ld e,ixl
            ld b,#04
.L6939      ld (hl),#e1
            inc hl
            ld (hl),#22
            inc hl
            ld (hl),e
            inc hl
            ld (hl),d
            inc hl
            inc e
            inc e
            djnz .L6939
            inc d
            dec c
            jr nz,.L6935
            exx
            ld hl,#6000
            ld a,#26
            call PokeBlock
            ld de,#60c0
            ld hl,L6993
            ld b,h
            ld c,l
            call L6964
            ld de,#61c0
            ld b,h
            ld c,l
L6964:      ld ixh,#08
.L6967      ld ixl,#08
            ld a,(hl)
            inc hl
            and #0f
            ld iyl,a
            push bc
.L6971      ld a,(bc)
            inc bc
            and #f0
            or iyl
            ld (de),a
            inc e
            dec ixl
            jr nz,.L6971
            pop bc
            dec ixh
            jr nz,.L6967
            ret
BlitWait:   halt
            ld a,(L67F2)
            or a
            ld hl,#60c0
            jr z,.L6990
            ld hl,#61c0
.L6990      jp L68A4
L6993:
            db   #88,#88,#AA,#AA,#EE,#EE,#FF,#FF,#00,#22,#22,#AA,#AA,#BB,#BB,#FF
PokeBlock:  ld (hl),e
            inc l
            ld (hl),d
            inc h
            ld (hl),d
            dec l
            ld (hl),e
            dec h
            ex de,hl
            add hl,bc
            ex de,hl
            inc l
            inc l
            inc l
            inc l
            dec a
            jr nz,PokeBlock
            ret
InitRowTabs:ld hl,L647F
            ld de,L6481
.L69BC      ld a,(hl)
            ld (de),a
            dec l
            inc e
            jr nz,.L69BC
            ld hl,#6000
            ld de,#4000
            ld b,#10
.L69CA      inc l
            inc l
            ld (hl),e
            inc l
            ld (hl),d
            inc l
            inc l
            inc l
            ld (hl),e
            inc l
            ld a,d
            add a,#04
            ld (hl),a
            inc l
            ld a,e
            add a,#20
            ld e,a
            jr nc,.L69E3
            ld a,d
            add a,#08
            ld d,a
.L69E3      djnz .L69CA
            ld hl,#6000
            ld de,#6100
            ld b,#20
.L69ED      inc l
            inc l
            inc e
            inc e
            ld a,(hl)
            ld (de),a
            inc l
            inc e
            ld a,(hl)
            add a,#02
            ld (de),a
            inc l
            inc e
            djnz .L69ED
            ret
PokeJp:     ld (hl),#c3
            inc hl
            ld (hl),e
            inc hl
            ld (hl),d
            ret
            db   #36,#DD,#23,#36,#E9,#C9
; select RAM bank 1 at #C000, normal screen, ROM 48
Page11:     ld a,#11
; A = value for port #7FFD
SetPage:    ld bc,#7ffd
            out (c),a
            ret
; wait for the next frame interrupt
WaitFrame:  ei
            halt
            di
            ret
; HL = start, BC = length, A = value: fill with LDIR
FillMem:    ld d,h
            ld e,l
            inc de
            ld (hl),a
            ldir
            ret
; HL -> DE, BC bytes, repeated B times (A = B on entry), HL advanced by the caller
RepeatLdir: ld a,b
            ld b,#00
.L6A21      push hl
            push bc
            ldir
            pop bc
            pop hl
            dec a
            jr nz,.L6A21
            ex de,hl
            ret
SlopeInit:  ld (L6A47),sp
            di
            ld sp,hl
            pop bc
            pop hl
            pop de
            push de
            bit 7,b
            jr z,.L6A41
            ld a,e
            cpl
            ld e,a
            ld a,d
            cpl
            ld d,a
            inc de
.L6A41      add hl,de
            push hl
            add hl,bc
            push hl
            ld a,h
L6A46:      ld sp,#3131
            ei
            ret
; BC frames, HL = routine called every frame; SPACE (port #7FFE bit 0) aborts the whole intro (jp IntroSkip)
RunFrames:  ld (L6A5E),hl
L6A4E:      push bc
            push af
            ld bc,#7ffe
            in a,(c)
            cp #be
            jp z,IntroSkip
            pop af
            pop bc
            push bc
L6A5D:      call #cdcd
            pop bc
            dec bc
            ld a,b
            or c
            jr nz,L6A4E
            ei
; fill the pixel area #4000-#57FF with C (unrolled)
FillScreen: ld hl,#4000
            ld b,#80
.L6A6C      ld e,l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            inc l
            ld (hl),c
            ld l,e
            inc h
            ld a,h
            and #07
            jp nz,.L6ABE
            ld a,l
            add a,#20
            ld l,a
            jr c,.L6ABE
            ld a,h
            sub #08
            ld h,a
.L6ABE      djnz .L6A6C
            ret
InitSprite: call Page11
            ld de,#d000
            ld hl,L6B5A
            ld bc,#4019
            call RepeatLdir
            ld (hl),#c9
            ld ixh,#d8
            ld hl,#d800
            ld de,#0100
            ld c,#10
.L6ADD      push hl
            ld ixl,#40
            ld b,#60
.L6AE3      ld a,h
            cp #e8
            jr c,.L6AE9
            sub a
.L6AE9      cp #d8
            jr nc,.L6AEE
            sub a
.L6AEE      ld (ix+#00),a
            inc ixl
            add hl,de
            djnz .L6AE3
            inc ixh
            ld hl,#fffb
            add hl,de
            ex de,hl
            pop hl
            dec c
            jr nz,.L6ADD
            ld d,#da
            ld a,#20
.L6B05      ld e,#e0
            ld hl,ShadeTab
            ld bc,#0020
            ldir
            dec a
            jr nz,.L6B05
            ld (L67FE),a
            ld ixl,#00
            call FadeCopy
            ld hl,L8000
            push hl
            ld de,#c000
            ld bc,#0100
            ldir
            pop hl
.L6B28      ld l,#00
.L6B2A      ld a,(hl)
            inc h
            add a,(hl)
            inc l
            add a,(hl)
            dec h
            add a,(hl)
            dec l
            add a,#40
            ld (hl),a
            inc l
            bit 6,l
            jr z,.L6B2A
            ld e,l
            ld d,h
            ld bc,#00c0
            ld l,b
            ldir
            inc h
            bit 6,h
            jr z,.L6B28
            sub a
            ld (L6993),a
            ld ixl,#c0
            ld de,#d800
            ld bc,#0100
            call MakeBlitCode
            jp BlitWait
L6B5A:      add hl,bc
            ld e,h
            ld a,(de)
            exx
            add a,b
            ld l,a
            ld d,(hl)
            add a,c
            ld l,a
            ld a,(hl)
            ld (de),a
            inc d
            ld (de),a
            inc d
            ld (de),a
            inc d
            ld (de),a
            inc d
            ld (de),a
            inc d
            ld (de),a
            inc d
            ld (de),a
            inc e
            exx
; 32 bytes of #C7..#C1 (descending) copied into #DA00.. by InitSprite
ShadeTab:
            db   #C7,#C7,#C7,#C7,#C6,#C6,#C6,#C6,#C5,#C5,#C5,#C5,#C4,#C4,#C4,#C4
            db   #C4,#C3,#C3,#C3,#C3,#C3,#C2,#C2,#C2,#C2,#C2,#C1,#C1,#C1,#C1,#C1
            call WaitFrame
            call ScrollStep
            call InitScroll
RunUnrolled:ld de,#9300
            ld b,#98
L6BA1:      ld hl,#9400
            exx
L6BA5:      ld bc,#9500
L6BA8:      ld hl,#9600
L6BAB:      ld de,#9700
            call #9900
L6BB1:      ld hl,#2121
            ld (L6BBD),sp
            ld sp,hl
            jp #a800
L6BBC:      ld sp,#3131
            ld ixl,#0d
            ld hl,#ad00
            ld bc,#8000
            call L6BE3
            call WaitFrame
            call ScrollStep
            ld ixl,#19
            ld hl,#b380
            ld bc,#8340
L6BDA:      call L6BE3
            call ScrollStep
            jp NextWarp
L6BE3:      ld (L6BF3),sp
            ld sp,hl
            ld h,#93
L6BEA:      jp #9100
L6BED:      inc bc
            dec ixl
            jr nz,L6BEA
L6BF2:      ld sp,#3131
            ret
InitScroll: ld hl,ScrollParams
            call SlopeInit
            ld (L6BA2),a
            ld hl,L6C90
            call SlopeInit
            ld (L6BA6),a
            ld hl,L6C96
            call SlopeInit
            ld (L6BA9),a
L6C11:      ld hl,L6400
            inc l
            inc l
            inc l
            ld (L6C12),hl
            ld a,(hl)
            srl a
            ld (L6BAC),a
            ret
ScrollStep: ld a,#a1
            dec a
            jr nz,.L6C27
            inc a
.L6C27      ld (L6C22),a
            dec a
            jr z,L6C3E
L6C2D:      ld a,#00
            inc a
            bit 6,a
            jr z,.L6C35
            dec a
.L6C35      ld (L6C2E),a
            srl a
            add a,#27
            jr SetWaveBase
L6C3E:      ld a,#00
            inc a
            cp #28
            jr nz,.L6C46
            sub a
.L6C46      ld (L6C3F),a
            ld e,a
            ld d,#00
            ld hl,WaveTab
            add hl,de
            ld a,(hl)
            add a,#38
SetWaveBase:ld l,a
            ld h,#00
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            ld de,#f000
            add hl,de
            ld (L6BB2),hl
            ret
; scroll wave table (2 x 20 bytes, #00..#0F)
WaveTab:
            db   #0F,#0F,#0F,#0E,#0E,#0D,#0D,#0C,#0B,#0A,#0A,#08,#07,#05,#04,#03
            db   #02,#01,#00,#00,#00,#02,#03,#04,#05,#07,#08,#09,#0A,#0A,#0B,#0C
            db   #0D,#0D,#0E,#0E,#0F,#0F,#0F,#0F
; 3 x 6 bytes of parameters for InitScroll
ScrollParams:
            db   #80,#50,#00,#00,#30,#00
L6C90:
            db   #80,#40,#00,#00,#18,#00
L6C96:
            db   #80,#58,#00,#00,#38,#00
InitEffect2:ld a,#14
            call SetPage
            ld hl,#c000
            ld de,#ad00
            ld bc,#1300
            ldir
            call Page11
            ld de,#9100
            ld hl,TemplateA
            ld bc,#4006
            call RepeatLdir
            dec hl
            ld de,L6BED
            call PokeJp
            ld de,#9900
            ld hl,TemplateB
            ld bc,#000f
            call RepeatLdir
            dec hl
            dec hl
            ld (hl),#c9
            ld hl,#a800
            ld de,#c000
            ld c,#26
.L6CDA      ld b,#08
.L6CDC      ld (hl),#e1
            inc hl
            ld (hl),#22
            inc hl
            ld (hl),e
            inc hl
            ld (hl),d
            inc hl
            inc e
            inc e
            djnz .L6CDC
            ld e,#00
            inc d
            dec c
            jr nz,.L6CDA
            ld de,L6BBC
            call PokeJp
            ld hl,#9800
.L6CF9      ld a,l
            rrca
            rrca
            rrca
            rrca
            and #0f
            ld (hl),a
            inc l
            jr nz,.L6CF9
            ld h,#64
            ld de,#9400
            ld c,#09
            call ShrinkCopy
            ld c,#06
            call ShrinkCopy
            ld c,#08
            call ShrinkCopy
            ld c,#05
            call ShrinkCopy
            ld hl,#f000
            ld d,#b0
            ld c,#00
L6D24:      ld e,d
            ld b,#10
.L6D27      ld a,e
            cp #80
            jr c,.L6D2E
            ld a,#7f
.L6D2E      cp #70
            jr nc,.L6D34
            ld a,#70
.L6D34      sub #70
            srl a
            add a,#89
            ld (hl),a
            dec e
            inc hl
            djnz .L6D27
L6D3F:      ld a,#80
            add a,#80
            ld (L6D40),a
            jr nz,.L6D49
            dec d
.L6D49      dec c
            jr nz,L6D24
            ld ixl,#28
.L6D4F      call InitScroll
            dec ixl
            jr nz,.L6D4F
            ld a,#88
            ld (L6993),a
            ld ixl,#89
            ld de,L8000
            ld bc,#0040
            call MakeBlitCode
            jp BlitWait
ShrinkCopy: ld a,(hl)
            srl a
            srl a
            ld (de),a
            ld a,l
            add a,c
            ld l,a
            inc e
            jr nz,ShrinkCopy
            inc d
            ret
; code template copied to #9100 at run time (unrolled byte shuffler)
TemplateA:
            db   #D1,#6B,#5E,#1A,#02,#0C
; code template copied to #9900 at run time
TemplateB:
            db   #0A,#0C,#86,#2C,#EB,#86,#2C,#D9,#86,#2C,#4F,#0A,#12,#1C,#D9
MakeBackdrop:ld a,#2c
            ld iyl,#c0
            call BuildSprites
            ld de,L8000
            ld h,#ad
.L6D9A      ld l,#40
            ld bc,#0080
            ldir
            inc h
            dec a
            jr nz,.L6D9A
            ld a,#14
            call SetPage
            ld hl,L8000
            ld de,#c000
            ld bc,#1300
            ldir
            ret
RunEffect2: ei
            ld a,#c3
            ld (L6BDA),a
            ld a,#50
            call SetWaveBase
            sub a
            ld (L6BA2),a
            ld (L6BA6),a
            ld (L6BA9),a
            ld (L6BAC),a
            ld h,#64
            ld de,#9400
            ld c,#03
            call ShrinkCopy
            call ShrinkCopy
            ld c,#05
            call ShrinkCopy
            call ShrinkCopy
            call RunUnrolled
            ei
            ld hl,L80D0
            ld de,L8000
            ld ixl,#20
.L6DF0      ld bc,#0020
            push bc
            ldir
            pop bc
            add hl,bc
            push hl
            ld h,d
            ld l,e
            dec l
            ld b,#20
.L6DFE      ld a,(hl)
            sub #89
            ld (hl),a
            ld (de),a
            inc de
            dec l
            djnz .L6DFE
            pop hl
            dec ixl
            jr nz,.L6DF0
            ld hl,L87FF
            ld de,L8800
            ld bc,#0800
.L6E15      ld a,(hl)
            ld (de),a
            dec hl
            inc de
            dec bc
            ld a,b
            or c
            jr nz,.L6E15
            ld a,#14
            call SetPage
            ld hl,L8000
            ld de,#c000
            ld bc,#1000
            ldir
            jp Page11
L66D4 equ L66D3+1
L66D5 equ L66D3+2
L66EC equ L66EB+1
L66ED equ L66EB+2
L66F8 equ L66F7+1
L6786 equ L6785+1
L678E equ L678D+1
L6793 equ L6792+1
L679E equ L679D+1
L67F2 equ NextWarp+1
L67FE equ L67FD+1
L6831 equ L6830+1
L68A1 equ L68A0+1
L692A equ L6929+1
L6A47 equ L6A46+1
L6A5E equ L6A5D+1
L6BA2 equ L6BA1+1
L6BA6 equ L6BA5+1
L6BA9 equ L6BA8+1
L6BAC equ L6BAB+1
L6BB2 equ L6BB1+1
L6BBD equ L6BBC+1
L6BF3 equ L6BF2+1
L6C12 equ L6C11+1
L6C22 equ ScrollStep+1
L6C2E equ L6C2D+1
L6C3F equ L6C3E+1
L6D40 equ L6D3F+1

; (the data above #6E31 is the include below; labels inside it are offsets)
L7E00       equ OverlayArea+#7E00-#6E31
L8000       equ OverlayArea+#8000-#6E31
L80C0       equ OverlayArea+#80C0-#6E31
L80D0       equ OverlayArea+#80D0-#6E31
L8100       equ OverlayArea+#8100-#6E31
L87FF       equ OverlayArea+#87FF-#6E31
L8800       equ OverlayArea+#8800-#6E31
L8F93       equ Depacker+#8F93-#8931
L8F94       equ Depacker+#8F94-#8931
OverlayArea: incbin "gen/intro_logo.scr"       ; 6912 bytes = ZX screen
Depacker:   incbin "gen/intro_depack.bin"      ; GENERATED from assets/gfx/intro_closing.png: depacker + packed picture (original: 1743 bytes)
            savebin "INTRO.C",#6400,$-#6400
