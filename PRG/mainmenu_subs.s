updateFrameCounters:
	inc frameCounter
; applySecondsFix:
	ldy machineRegion
	cpy #MACHINEREGION_NTSC
	bne applyPALDendySecondsFix	; PAL and Dendy have 50 VBlanks per second
	jmp endUpdateFrameCounters
applyPALDendySecondsFix:
	ldy regionFixFrameCounter
	iny
	sty regionFixFrameCounter
	cpy #$05
	bne endUpdateFrameCounters
	ldy #$00
	sty regionFixFrameCounter
	inc frameCounter
endUpdateFrameCounters:
	rts
	
updateTimeCounters:	
	lda frameCounter
	cmp #60
	bmi checkSeconds
	sec
	sbc #60
	sta frameCounter
	inc secondsCounter
checkSeconds:
	lda secondsCounter
	cmp #60
	bmi checkMinutes
	sec
	sbc #60
	sta secondsCounter
	inc minutesCounter
checkMinutes:
	lda minutesCounter
	cmp #60
	bmi endUpdateTimeCounters
	sec
	sbc #60
	sta minutesCounter
	inc hoursCounter
endUpdateTimeCounters:
	rts 
	
updateTextBlinkFlag:
	lda frameCounter
	beq handleTextBlinkFlag
	jmp endUpdateTextBlinkFlag
handleTextBlinkFlag:
	lda #MAINMENU_FLAG_TEXTBLINK
	and mainmenuFlags
	bne clearTextBlinkFlag
; setTextBlinkFlag:
	inc mainmenuFlags
	inc mainmenuFlags
	jmp endUpdateTextBlinkFlag
clearTextBlinkFlag:
	lda #MAINMENU_FLAGS_NO_TEXTBLINK
	and mainmenuFlags
	sta mainmenuFlags
endUpdateTextBlinkFlag:
	rts 
	
drawBlinkText:
	lda #MAINMENU_FLAG_TEXTBLINK
	and mainmenuFlags
	bne showBlinkText
; hideBlinkText:
	lda PPUSTATUS
	lda #>MAINMENU_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	lda #<MAINMENU_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	ldx #$00
hideBlinkTextLoop:
	lda #$00
	sta PPUDATA
	inx
	cpx #MAINMENU_PUSHSTART_NAMETABLE_LENGTH
	bne hideBlinkTextLoop
	jmp endBlinkText
showBlinkText:
	lda PPUSTATUS
	lda #>MAINMENU_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	lda #<MAINMENU_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	ldx #$00
showBlinkTextLoop:
	lda mainmenu_pushstart_text, x
	sta PPUDATA
	inx
	cpx #MAINMENU_PUSHSTART_NAMETABLE_LENGTH
	bne showBlinkTextLoop
endBlinkText:
	rts 