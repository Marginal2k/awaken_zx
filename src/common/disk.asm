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

            MACRO DISK_EXIT
            jp   TRDOS_EXIT
            ENDM

; NOTE: this file holds macros and equates only (it is included before the includer's ORG).
; Any data a loader needs (e.g. the stscr SECTAB) must be placed by the includer.
