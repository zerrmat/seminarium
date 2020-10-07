.include "registers.h"
.include "map_consts.h"
.include "nes_consts.h"

.import mapFlags, selectedLevel, levelBlinkFrameCounter	; map_bss.s	
.import UpdateFrameCounters, UpdateTimeCounters			; title_subs.s

.export MapMain

MapMain:
	jsr UpdateFrameCounters
	jsr UpdateTimeCounters
	jsr UpdateLevelBlink
	rts

ChangeBlink:
	lda mapFlags
	and #MAP_FLAGS_LEVEL_BLINK
	beq _BlinkUnselect
		;_BlinkSelect:
		lda mapFlags
		and #MAP_FLAGS_SET_BLINK_0
		sta mapFlags
		ldx #(OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR)
		jmp _DetermineChangeAddr
	_BlinkUnselect:
		lda mapFlags
		ora #MAP_FLAGS_SET_BLINK_1
		sta mapFlags
		ldx #(OAM_SPR_PAL_2 | OAM_SPR_FRONT_BGR)
	_DetermineChangeAddr:
		lda selectedLevel
		asl a
		asl a
		tay
		txa
		sta OAM + OAM_SPR_OFFSET_ATTRS, y	
	rts

UpdateLevelBlink:
	dec levelBlinkFrameCounter
	lda levelBlinkFrameCounter
	bne _OmitUpdate
		clc
		adc #MAP_LEVEL_SELECT_BLINK_FRAMES
		sta levelBlinkFrameCounter
		jsr ChangeBlink
		
	_OmitUpdate:
	rts
