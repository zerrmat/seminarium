	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	
	lda #<(mainmenu_nametable)
	sta nametable_lo
	lda #>(mainmenu_nametable)
	sta nametable_hi
	ldx #$00
	ldy #$00
@outer_loop:
@inner_loop:
	lda (nametable_lo), y
	sta $2007
	iny
	cpy #$00
	bne @inner_loop
	
	inc nametable_hi	
	inx
	cpx #$04
	bne @outer_loop
;;; second
	lda $2002
	lda #$28
	sta $2006
	lda #$00
	sta $2006
	
	lda #<(mainmenu_nametable_2)
	sta nametable_lo
	lda #>(mainmenu_nametable_2)
	sta nametable_hi
	ldx #$00
	ldy #$00
@outer_loop2:
@inner_loop2:
	lda (nametable_lo), y
	sta $2007
	iny
	cpy #$00
	bne @inner_loop2
	
	inc nametable_hi	
	inx
	cpx #$04
	bne @outer_loop2