	ldy titleScrollY
	beq skip_title_scroll
	
	dey
	sty titleScrollY
	lda #TITLE_END_SCROLL_POS
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL
	jmp endNMI
skip_title_scroll:
	lda titleFlags
	ora #TITLE_FLAG_ENDSCROLL
	sta titleFlags
	jsr drawBlinkText
; fixScroll:
	lda titleScrollY
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL