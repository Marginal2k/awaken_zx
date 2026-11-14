; ------------------------------------------------------------------------------------------
; state.inc - memory contract between the station part (STATIONF) and the flight part (ACTION).
; Equates only (safe to include anywhere).
;
; The persistent game state is one 512-byte record that starts at the label TIME in both images
; (day/time, current place, ship, money, goods, fuel, ... - the same layout as the SAVEn.s slot
; files).  Station: DATA_M.asm (TIME = #983B), flight: 3DTABS.asm (TIME = #9BBD).  The record is
; handed over through the screen RAM #4000 because loading the other part overwrites #6000-#FFFF.
; ------------------------------------------------------------------------------------------
STATE_LEN       equ  #200               ; bytes of the state record (= size of a SAVEn.s file)
STATE_BUF       equ  #4000              ; hand-over buffer (screen RAM, survives the file load)
STATE_SLOT      equ  #5BFE              ; slot number 1..5 for a "load game" restart (launcher stub reads SAVEn into STATE_BUF)
STATE_FLAG      equ  #5BFF              ; 1 = the station was entered from the flight part (state valid at STATE_BUF)
STUB_ADDR       equ  #5B00              ; resident load stub (below the TR-DOS variables, above the screen attributes)
STUB_SP         equ  #5FFF              ; stack of the stub: must be above the BASIC workspace, else TR-DOS fails with "4 Out of memory"
FLIGHT_STATE    equ  #9BBD              ; address of TIME in the flight image (checked by an ASSERT in flight.asm)
FLIGHT_ENTRY    equ  #6000              ; flight part: LOADI2 (loads the page files, then starts the game)
STATION_ENTRY   equ  #6300              ; station part entry (BODYOCUR)
