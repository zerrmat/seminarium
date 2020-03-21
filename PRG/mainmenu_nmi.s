	ldy mainmenuScrollY
	beq skip_mainmenu_scroll
	
	dey
	sty mainmenuScrollY
	lda #$00
	sta $2005
	sty $2005
	lda #%10000000
	sta $2000
	jmp endNMI
skip_mainmenu_scroll:
	lda mainmenuFlags
	ora #%00000001
	sta mainmenuFlags
; drawBlinkText:
	lda #%00000010
	and mainmenuFlags
	bne showBlinkText
; hideBlinkText:
	lda $2002
	lda #$21
	sta $2006
	lda #$07
	sta $2006
	ldx #$00
hideBlinkTextLoop:
	lda #$00
	sta $2007
	inx
	cpx #$11
	bne hideBlinkTextLoop
	jmp endBlinkText
showBlinkText:
	lda $2002
	lda #$21
	sta $2006
	lda #$07
	sta $2006
	ldx #$00
showBlinkTextLoop:
	lda mainmenu_pushstart_text, x
	sta $2007
	inx
	cpx #$11
	bne showBlinkTextLoop
endBlinkText:
; fixScroll:
	lda mainmenuScrollY
	sta $2005
	sty $2005
	lda #%10000000
	sta $2000