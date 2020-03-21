	ldy mainmenuScrollY
	beq skip_mainmenu_scroll
	
	dey
	sty mainmenuScrollY
	lda #MAINMENU_END_SCROLL_POS
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL
	jmp endNMI
skip_mainmenu_scroll:
	lda mainmenuFlags
	ora #MAINMENU_FLAG_ENDSCROLL
	sta mainmenuFlags
	jsr drawBlinkText
; fixScroll:
	lda mainmenuScrollY
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL