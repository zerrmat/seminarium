;; Set title palette
	lda	PPUSTATUS		; Read PPU status to reset PPU address
	lda	#>BGR_PALETTE_PPU_ADDR		; Set PPU address to BG palette RAM ($3F00)
	sta	PPUADDR
	lda	#<BGR_PALETTE_PPU_ADDR
	sta PPUADDR

	ldx	#$00		
@loop:
	lda title_palette, x
	sta	PPUDATA
	inx
	cpx #PPU_PALETTES_SIZE ; Loop $20 times (up to $3F20)
	bne	@loop