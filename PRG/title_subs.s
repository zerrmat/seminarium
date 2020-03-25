.include "title_consts.h"
.include "nes_consts.h"
.include "registers.h"

; title_data.s
.import title_pushstart_text

; title_bss.s
.import machineRegion, frameCounter, secondsCounter, minutesCounter, hoursCounter
.import titleFlags, regionFixFrameCounter

.export updateFrameCounters, updateTimeCounters, updateTextBlinkFlag
.export drawBlinkText



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
	lda #TITLE_FLAG_TEXTBLINK
	and titleFlags
	bne clearTextBlinkFlag
; setTextBlinkFlag:
	inc titleFlags
	inc titleFlags
	jmp endUpdateTextBlinkFlag
clearTextBlinkFlag:
	lda #TITLE_FLAGS_NO_TEXTBLINK
	and titleFlags
	sta titleFlags
endUpdateTextBlinkFlag:
	rts 
	
drawBlinkText:
	lda #TITLE_FLAG_TEXTBLINK
	and titleFlags
	bne showBlinkText
; hideBlinkText:
	lda PPUSTATUS
	lda #>TITLE_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	lda #<TITLE_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	ldx #$00
hideBlinkTextLoop:
	lda #$00
	sta PPUDATA
	inx
	cpx #TITLE_PUSHSTART_NAMETABLE_LENGTH
	bne hideBlinkTextLoop
	jmp endBlinkText
showBlinkText:
	lda PPUSTATUS
	lda #>TITLE_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	lda #<TITLE_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	ldx #$00
showBlinkTextLoop:
	lda title_pushstart_text, x
	sta PPUDATA
	inx
	cpx #TITLE_PUSHSTART_NAMETABLE_LENGTH
	bne showBlinkTextLoop
endBlinkText:
	rts 