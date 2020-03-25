.include "registers.h"
.include "nes_consts.h"

; title_zp.s
.importzp nametable_lo, nametable_hi
.import title_nametable, title_nametable_2

.export set_backgrounds

set_backgrounds:
	lda PPUSTATUS
	lda #>NAMETABLE_0_ADDR
	sta PPUADDR
	lda #<NAMETABLE_0_ADDR
	sta PPUADDR
	
	lda #<(title_nametable)
	sta nametable_lo
	lda #>(title_nametable)
	sta nametable_hi
	ldx #$00
	ldy #$00
	outer_loop:
		inner_loop:
			lda (nametable_lo), y
			sta PPUDATA
			iny
			cpy #<NAMETABLE_LENGTH
			bne inner_loop
		
		inc nametable_hi	
		inx
		cpx #>NAMETABLE_LENGTH
		bne outer_loop
		
;;; second
	lda PPUSTATUS
	lda #>NAMETABLE_1_ADDR
	sta PPUADDR
	lda #<NAMETABLE_1_ADDR
	sta PPUADDR
	
	lda #<(title_nametable_2)
	sta nametable_lo
	lda #>(title_nametable_2)
	sta nametable_hi
	ldx #$00
	ldy #$00
	outer2_loop:
		inner2_loop:
			lda (nametable_lo), y
			sta PPUDATA
			iny
			cpy #<NAMETABLE_LENGTH
			bne inner2_loop
			
		inc nametable_hi	
		inx
		cpx #>NAMETABLE_LENGTH
		bne outer2_loop
	rts
	