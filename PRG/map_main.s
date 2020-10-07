.include "registers.h"
.include "map_consts.h"
.include "nes_consts.h"
.include "prg_consts.h"

.import mapFlags, selectedLevel, levelBlinkFrameCounter	; map_bss.s	
.import buttons											; prg_bss.s
.import UpdateFrameCounters, UpdateTimeCounters			; title_subs.s

.export MapMain

MapMain:
	jsr UpdateFrameCounters
	jsr UpdateTimeCounters
	jsr CheckLevelChange
	jsr UpdateLevelBlink
	rts
	
CheckLevelChange:
	lda buttons
	cmp #BUTTONS_LEFT
	bne @_Check1
		; "deselect" actual level
		ldx #(OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR)
		lda selectedLevel
		asl a
		asl a
		tay
		txa
		sta OAM + OAM_SPR_OFFSET_ATTRS, y
		
		; select actual level
		dec selectedLevel
		lda #$00
		and #MAP_FLAGS_SET_BLINK_0
		sta mapFlags
		
		lda #$01
		sta levelBlinkFrameCounter
		; TODO: button cooldown
		jmp @_End
@_Check1:
	cmp #BUTTONS_RIGHT
	bne @_End
		; "deselect" actual level
		ldx #(OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR)
		lda selectedLevel
		asl a
		asl a
		tay
		txa
		sta OAM + OAM_SPR_OFFSET_ATTRS, y
		
		; select actual level
		inc selectedLevel
		lda #$00
		and #MAP_FLAGS_SET_BLINK_0
		sta mapFlags
		
		lda #$01
		sta levelBlinkFrameCounter
		; TODO: button cooldown
		jmp @_End
@_End:
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
