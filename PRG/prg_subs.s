.include "nes_consts.h"
.include "registers.h"

; title_zp.s
.importzp nametableLo, nametableHi, retAddrLo, retAddrHi

.import JOY1	; registers.s
.import buttons	; prg_bss.s

.export ReadController, SetBackground

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

; Arguments (stack):
; - High byte nametable address
; - Low byte nametable address
; - High byte nametable data address
; - Low byte nametable data address
SetBackground:
	pla 
	sta retAddrLo
	pla
	sta retAddrHi
	
	lda PPUSTATUS
	pla
	sta PPUADDR
	pla
	sta PPUADDR
	
	pla
	sta nametableHi
	pla
	sta nametableLo
	ldx #$00
	ldy #$00
	_loop_Outer:
		_loop_Inner:
			lda (nametableLo), y
			sta PPUDATA
			iny
			cpy #<NAMETABLE_LENGTH
			bne _loop_Inner
		
		inc nametableHi	
		inx
		cpx #>NAMETABLE_LENGTH
		bne _loop_Outer

	lda retAddrHi
	pha
	lda retAddrLo
	pha
	rts
	