;; Set mainmenu palette
	lda	$2002		; Read PPU status to reset PPU address
	lda	#$3f		; Set PPU address to BG palette RAM ($3F00)
	sta	$2006
	lda	#$00
	sta $2006

	ldx	#$00		
@loop:
	lda mainmenu_palette, x
	sta	$2007
	inx
	cpx #$20 ; Loop $20 times (up to $3F20)
	bne	@loop