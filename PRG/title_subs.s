.include "title_consts.h"
.include "nes_consts.h"
.include "registers.h"

; title_data.s
.import _data_titlePushstartText

; prg_bss.s
.import machineRegion, frameCounter, secondsCounter, minutesCounter
.import hoursCounter, regionFixFrameCounter

; title_bss.s
.import titleFlags

; title_data.s
.import _data_titleNametable, _data_titleNametable2

; prg_subs.s
.import SetBackground

.export UpdateFrameCounters, UpdateTimeCounters, UpdateTextBlinkFlag
.export DrawBlinkText, SetTitleBackgrounds

TITLE_FLAG_TEXTBLINK = %00000010
TITLE_FLAG_NO_TEXTBLINK = %11111101

TITLE_PUSHSTART_NAMETABLE_START = $2107
TITLE_PUSHSTART_NAMETABLE_DATA_LENGTH = $11

UpdateFrameCounters:
	inc frameCounter
; applySecondsFix:
	ldy machineRegion
	cpy #MACHINEREGION_NTSC
	bne _ApplyPALDendySecondsFix	; PAL and Dendy have 50 VBlanks per second
		jmp _EndUpdateFrameCounters
		
	_ApplyPALDendySecondsFix:
	ldy regionFixFrameCounter
	iny
	sty regionFixFrameCounter
	cpy #$05
	bne _EndUpdateFrameCounters
		ldy #$00
		sty regionFixFrameCounter
		inc frameCounter
		
	_EndUpdateFrameCounters:
	rts
	
UpdateTimeCounters:	
	lda frameCounter
	cmp #60
	bmi _CheckSeconds
		sec
		sbc #60
		sta frameCounter
		inc secondsCounter
		
	_CheckSeconds:
	lda secondsCounter
	cmp #60
	bmi _CheckMinutes
		sec
		sbc #60
		sta secondsCounter
		inc minutesCounter
		
	_CheckMinutes:
	lda minutesCounter
	cmp #60
	bmi _EndUpdateTimeCounters
		sec
		sbc #60
		sta minutesCounter
		inc hoursCounter
	
	_EndUpdateTimeCounters:
	rts 
	
UpdateTextBlinkFlag:
	lda frameCounter
	beq _HandleTextBlinkFlag
		jmp _EndUpdateTextBlinkFlag
	
	_HandleTextBlinkFlag:
	lda #TITLE_FLAG_TEXTBLINK
	and titleFlags
	bne _ClearTextBlinkFlag
		; setTextBlinkFlag:
		inc titleFlags
		inc titleFlags
		jmp _EndUpdateTextBlinkFlag
		
	_ClearTextBlinkFlag:
	lda #TITLE_FLAG_NO_TEXTBLINK
	and titleFlags
	sta titleFlags
	
	_EndUpdateTextBlinkFlag:
	rts 
	
DrawBlinkText:
	lda #TITLE_FLAG_TEXTBLINK
	and titleFlags
	bne _ShowBlinkText
		; hideBlinkText:
		lda PPUSTATUS
		lda #>TITLE_PUSHSTART_NAMETABLE_START
		sta PPUADDR
		lda #<TITLE_PUSHSTART_NAMETABLE_START
		sta PPUADDR
		ldx #$00
		_loop_HideBlinkText:
			lda #$00
			sta PPUDATA
			inx
			cpx #TITLE_PUSHSTART_NAMETABLE_DATA_LENGTH
			bne _loop_HideBlinkText
			
		jmp _EndBlinkText
		
	_ShowBlinkText:
	lda PPUSTATUS
	lda #>TITLE_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	lda #<TITLE_PUSHSTART_NAMETABLE_START
	sta PPUADDR
	ldx #$00
	_loop_ShowBlinkText:
		lda _data_titlePushstartText, x
		sta PPUDATA
		inx
		cpx #TITLE_PUSHSTART_NAMETABLE_DATA_LENGTH
		bne _loop_ShowBlinkText
		
	_EndBlinkText:
	rts 
	
SetTitleBackgrounds:
	lda #<(_data_titleNametable)
	pha 
	lda #>(_data_titleNametable)
	pha
	lda #<NAMETABLE_0_ADDR
	pha
	lda #>NAMETABLE_0_ADDR
	pha
	jsr SetBackground
	
	lda #<(_data_titleNametable2)
	pha 
	lda #>(_data_titleNametable2)
	pha
	lda #<NAMETABLE_1_ADDR
	pha
	lda #>NAMETABLE_1_ADDR
	pha
	jsr SetBackground
	rts
	