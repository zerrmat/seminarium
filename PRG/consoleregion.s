;;; BUT because of a hardware oversight, we might have missed a vblank flag.
;;;  so we need to both check for 1Vbl and 2Vbl
;;; VBlank flag is modified each $9B0 cycles (in hex)
;;; NTSC NES: 29780 cycles / 12.005 -> $9B1 or $1362 (Y:X)
;;; PAL NES:  33247 cycles / 12.005 -> $AD2 or $15A3
;;; Dendy:    35464 cycles / 12.005 -> $B8B or $1715

;;; Original code: http://forums.nesdev.com/viewtopic.php?p=163258#p163258

vblankwait3:
	inx
	bne @noincy
	iny
@noincy:
	bit PPUSTATUS
	bpl vblankwait3

	tya
	cmp #$C
	bcc @nodiv2
	lsr
@nodiv2:
	clc
	adc #<-9
	cmp #3
	bcc @noclip3
	lda #3
@noclip3:
;;; Right now, A contains 0, 1, 2, 3 for NTSC, PAL, Dendy, Bad
	sta machineRegion