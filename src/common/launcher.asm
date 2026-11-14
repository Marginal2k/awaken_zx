; ------------------------------------------------------------------------------------------
; launcher.asm - hand-over between the station part and the flight part (all disk access
; through disk.asm).  NOT part of the 1999 sources: the original glue was only present in the
; demo v0.2 images (STATIONF #8170..#81B3, ACTION #7440..#745F); this is a clean re-write that
; keeps its idea: a small resident stub loads the other part and copies the state record.
;
;   LAUNCHER_ROUTINE routine_name, file_label, load_addr, entry_addr, state_dst, state_src_label
;     emits   routine_name: [music off, IM 1] -> copy the state record from state_src_label to
;     STATE_BUF -> copy the stub to STUB_ADDR -> jp STUB_ADDR.
;     The stub (assembled for STUB_ADDR) loads the file, copies STATE_BUF to state_dst and jumps.
;   `file_label` points to the 9-byte TR-DOS name (e.g. "ACTION  C").
; ------------------------------------------------------------------------------------------
            MACRO LAUNCHER_ROUTINE rname, fname, laddr, entry, sdst, ssrc, flagv, musicoff
rname:
            di
            IF musicoff
            ld   bc,#7FFD
            ld   a,#13                  ; page with the music player (station PGMUZ)
            out  (c),a
            call #DB08                  ; music off
            ENDIF
            ld   bc,#7FFD
            ld   a,#10                  ; bank 0 at #C000, normal screen, ROM 48
            out  (c),a
            im   1
            ld   a,#3F
            ld   i,a
            ld   iy,#5C3A
            xor  a
            out  (#FE),a                ; black border
            ld   hl,ssrc
            ld   de,STATE_BUF
            ld   bc,STATE_LEN
            ldir
            ld   hl,.stub_src
            ld   de,STUB_ADDR
            ld   bc,.stub_end-.stub_src
            ldir
            jp   STUB_ADDR
.stub_src:
            DISP STUB_ADDR
            ld   sp,STUB_SP
            ld   a,9
            ld   (TRDOS_DRIVE),a
            ei                          ; TR-DOS waits for the drive motor with the frame counter: needs interrupts (IM 1)
            DISK_LOAD .fn,laddr
            di
            ld   hl,STATE_BUF
            ld   de,sdst
            ld   bc,STATE_LEN
            ldir
            ld   a,flagv
            ld   (STATE_FLAG),a
            ld   sp,#6000
            jp   entry
.fn:      db   fname
            ENT
.stub_end:
            ENDM
