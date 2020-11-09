.segment "HEADER"
.byte "NES"		; Magic number for files which are meant to run in NES emulators
.byte $1A		; MS-DOS end-of-file byte
.byte 2			; 2 x 16 KB (32 KB) for code (PRG)
.byte 1 		; 1 x 8 KB (8 KB) for graphics (CHR)
.byte %00000000 ; mapper 0 (NROM) (highest 4 bits), vertical mirroring (8th bit)
.byte 0, 0
.byte 0, 0, 0, 0, 0, 0