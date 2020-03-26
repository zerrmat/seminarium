.import JOY1	; registers.s
.import buttons	; prg_bss.s

.export ReadController

BUTTONS_COUNT = $08

ReadController:
	lda #$01
	sta JOY1
	lda #$00
	sta JOY1
	ldx #BUTTONS_COUNT
	_loop_ReadController:
		lda JOY1
		lsr a
		rol buttons
		dex
		bne _loop_ReadController
	rts
	