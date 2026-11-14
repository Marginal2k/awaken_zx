; ------------------------------------------------------------------------------------------
; disk.asm - the ONLY place that talks to TR-DOS (Beta Disk interface).  The rest of the game
; uses the macros below.  Original code called the TR-DOS entry #3D13 directly from LOADI2
; (flight), LOADER (station) and the demo's STATIONF launcher.
;
; TR-DOS "DOS function" call:  C = function, file name (8 chars + type, 9 bytes) at #5CDD
;   C=#0A find file in catalogue      C=#08 read catalogue entry -> (#5CEB) start sector/track
;   C=#05 read sectors  (HL=dest, DE=track/sector, B=count)
;   C=#0E load file     (HL=dest, A=3)   -> file is loaded to HL, name in #5CDD
; ------------------------------------------------------------------------------------------
TRDOS_CALL      equ  #3D13              ; TR-DOS DOS-function entry
TRDOS_EXIT      equ  #3D2F              ; TR-DOS: return to BASIC / reset DOS
TRDOS_FNAME     equ  23773              ; #5CDD  file name of the current operation
TRDOS_SECTOR    equ  #5CEB              ; track/sector of a file found by DISK_INFO
TRDOS_SECCNT     equ  #5CEA              ; sector count of the file found by DISK_INFO
TRDOS_DRIVE     equ  23814              ; #5D06  current drive (9 = ?, see LOADI2/LOADER)

            ; copy the 9-byte file name stored at NAME into the TR-DOS name buffer
            MACRO DISK_SETNAME name
            ld   hl,name
            ld   de,TRDOS_FNAME
            ld   bc,9
            ldir
            ENDM

            ; load the file whose name is in the buffer to HL (HL must be set by the caller)
            MACRO DISK_READ
            IFNDEF DISK_ORIGINAL            ; -DDISK_ORIGINAL reproduces the 1999 binaries byte-exactly (stale DE)
            ld   de,#FFFF                   ; length cap: DE is a LENGTH limit (a stale DE capped files at 92 sectors) - FFFF = whole file
            ENDIF
            ld   c,#0E
            ld   a,3
            call TRDOS_CALL
            ENDM

            ; DISK_LOAD name,addr : load file `name` (9-byte string label) to `addr`
            MACRO DISK_LOAD name,addr
            DISK_SETNAME name
            ld   hl,addr
            DISK_READ
            ENDM

            MACRO DISK_FIND                 ; find file in catalogue
            ld   c,#0A
            call TRDOS_CALL
            ENDM

            MACRO DISK_INFO                 ; read catalogue entry of found file (A=file number in C)
            ld   c,#08
            call TRDOS_CALL
            ENDM

            MACRO DISK_RDSEC                ; read B sectors from DE (track/sector) to HL
            ld   c,5
            call TRDOS_CALL
            ENDM

            MACRO DISK_RDSEC_TAIL           ; same as DISK_RDSEC but a tail jump: TR-DOS returns to the address on the stack
            ld   c,5
            jp   TRDOS_CALL
            ENDM

            MACRO DISK_EXIT
            jp   TRDOS_EXIT
            ENDM

; NOTE: this file holds macros and equates only (it is included before the includer's ORG).
; Any data a loader needs (e.g. the stscr SECTAB) must be placed by the includer.

; ------------------------------------------------------------------------------------------
; Save-game slots: 512-byte state records in the TR-DOS files "SAVE0   s" .. "SAVE5   s" (2 sectors each,
; created by build.py; a slot is overwritten IN PLACE with a raw sector write, the catalogue never changes).
;
;   DISK_SLOT_SAVE_ROUTINE  emits  DiskSlotSave:  A = slot 0..5, HL = 512-byte record
;        -> carry set = file not found.  BC,DE,HL,IX,IY and the alternate set (except AF') are preserved, A and
;        the flags are not; ends in IM 2 with I as before, EI.  TR-DOS is called like by the other users: IM 1,
;        I=#3F, drive 9, interrupts on (motor wait); the caller's SP is kept (the station's stack lives at #5FFx,
;        a stack switch to #5FFF would be overwritten by TR-DOS).
;   DISK_SLOT_READ slotnum_addr,dst   (inline, for the launcher stub which runs with SP=#5FFF and a dead game)
;        reads the slot whose number is the byte at slotnum_addr into dst; slot file missing -> dst untouched.
; ------------------------------------------------------------------------------------------
SLOT_SECTORS    equ  2
            MACRO DISK_SLOT_READ slotaddr,dst
            ld   a,(slotaddr)
            add  a,"0"
            ld   (.slotf+4),a
            DISK_SETNAME .slotf
            DISK_FIND
            ld   a,c
            inc  a
            jr   z,.slotend             ; C=#FF: not in the catalogue
            dec  a
            DISK_INFO                   ; -> track/sector of the file in (#5CEB)
            ld   hl,dst
            ld   de,(TRDOS_SECTOR)
            ld   b,SLOT_SECTORS
            DISK_RDSEC
            jr   .slotend
.slotf:     db   "SAVE0   s"
.slotend:
            ENDM

            MACRO DISK_SLOT_SAVE_ROUTINE
DiskSlotSave:
            add  a,"0"
            ld   (.slotf+4),a
            push bc
            push de
            push hl
            push ix
            push iy
            exx
            push bc
            push de
            push hl
            exx
            ld   (.buf+1),hl
            ld   a,i
            ld   (.i+1),a
            di
            im   1
            ld   a,#3F
            ld   i,a
            ld   iy,#5C3A
            ld   a,9
            ld   (TRDOS_DRIVE),a
            ei
            DISK_SETNAME .slotf
            DISK_FIND
            ld   a,c
            inc  a
            jr   z,.fail
            dec  a
            DISK_INFO
.buf:       ld   hl,0
            ld   de,(TRDOS_SECTOR)
            ld   b,SLOT_SECTORS
            ld   c,6                    ; TR-DOS function 6: write sectors
            call TRDOS_CALL
            xor  a                      ; carry clear
            jr   .done
.fail:      scf
.done:      ex   af,af'                 ; keep the carry through the register restore
            di
.i:         ld   a,0
            ld   i,a
            im   2
            exx
            pop  hl
            pop  de
            pop  bc
            exx
            pop  iy
            pop  ix
            pop  hl
            pop  de
            pop  bc
            ex   af,af'
            ei
            ret
.slotf:     db   "SAVE0   s"
            ENDM
