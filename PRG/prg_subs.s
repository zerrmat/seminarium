.include "nes_consts.h"
.include "registers.h"

; prg_zp.s
.importzp nametableLo, nametableHi, retAddrLo, retAddrHi, paletteLo, paletteHi

.import JOY1	; registers.s
.import buttons	; prg_bss.s

.export ReadController, SetBackground, SetFullPalette

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
	pla 			; preserve return address
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

	lda retAddrHi	; "pop" return address
	pha
	lda retAddrLo
	pha
	rts
	
; Arguments (RAM): 
; - paletteLo - lower byte of palette data to write
; - paletteHi - higher byte of palette data to write
SetFullPalette:
	lda	PPUSTATUS				; Read PPU status to reset PPU address
	lda	#>BGR_PALETTE_PPU_ADDR	; Set PPU address to BG palette RAM ($3F00)
	sta	PPUADDR
	lda	#<BGR_PALETTE_PPU_ADDR
	sta PPUADDR

	ldy	#$00		
	_loop_Palette:
		lda (paletteLo), y
		sta	PPUDATA
		iny
		cpy #PPU_PALETTES_SIZE 	; Loop $20 times (up to $3F20)
		bne	_loop_Palette

	rts
	