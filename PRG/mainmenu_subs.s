updateFrameCounters:
	inc frameCounter
; applySecondsFix:
	ldy machineRegion
	cpy #$00
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
	cmp #$3C
	bmi checkSeconds
	sec
	sbc #$3C
	sta frameCounter
	inc secondsCounter
checkSeconds:
	lda secondsCounter
	cmp #$3C
	bmi checkMinutes
	sec
	sbc #$3C
	sta secondsCounter
	inc minutesCounter
checkMinutes:
	lda minutesCounter
	cmp #$3C
	bmi endUpdateTimeCounters
	sec
	sbc #$3C
	sta minutesCounter
	inc hoursCounter
endUpdateTimeCounters:
	rts 
	
updateTextBlinkFlag:
	lda frameCounter
	beq handleTextBlinkFlag
	jmp endUpdateTextBlinkFlag
handleTextBlinkFlag:
	lda #%00000010
	and mainmenuFlags
	bne clearTextBlinkFlag
; setTextBlinkFlag:
	inc mainmenuFlags
	inc mainmenuFlags
	jmp endUpdateTextBlinkFlag
clearTextBlinkFlag:
	lda #%11111101
	and mainmenuFlags
	sta mainmenuFlags
endUpdateTextBlinkFlag:
	rts 