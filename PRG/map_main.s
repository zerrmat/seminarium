.include "registers.h"
.include "map_consts.h"
.include "nes_consts.h"

.import mapFlags, selectedLevel, levelBlinkFrameCounter	; map_bss.s	
; title_subs.s
.import UpdateFrameCounters, UpdateTimeCounters

.export MapMain

LEVEL_BLINK_FRAMES = 60
PAL_ADDR = $3F16

MapMain:
	jsr UpdateFrameCounters
	jsr UpdateTimeCounters
	
	inc levelBlinkFrameCounter
	lda levelBlinkFrameCounter
	cmp #LEVEL_BLINK_FRAMES
	bmi _Next
		sec
		sbc #LEVEL_BLINK_FRAMES
		sta levelBlinkFrameCounter
		
		lda mapFlags
		and #MAP_FLAGS_LEVEL_BLINK
		bne _Blink1
			;_Blink0:
			lda mapFlags
			ora #MAP_FLAGS_SET_BLINK_1
			sta mapFlags
			ldx #(OAM_SPR_PAL_2 | OAM_SPR_FRONT_BGR)
			jmp _EndBlinkUpdate
		_Blink1:
			lda mapFlags
			and #MAP_FLAGS_SET_BLINK_0
			sta mapFlags
			ldx #(OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR)
		_EndBlinkUpdate:
		lda selectedLevel
		asl a
		asl a
		tay
		txa
		sta $0202, y
		; lda PPUSTATUS
		; lda #>PAL_ADDR
		; sta PPUADDR
		; lda #<PAL_ADDR
		; sta PPUADDR
		; lda mapFlags
		; and #MAP_FLAGS_LEVEL_BLINK
		; bne _Blink1
			; ;_Blink0:
			; ldx #$16
			; lda mapFlags
			; ora #MAP_FLAGS_SET_BLINK_1
			; sta mapFlags
			; jmp _EndBlinkUpdate
		; _Blink1:
			; ldx #$30
			; lda mapFlags
			; and #MAP_FLAGS_SET_BLINK_0
			; sta mapFlags
		; _EndBlinkUpdate:
			; stx PPUDATA
			; lda #$00
			; sta PPUSCROLL
			; sta PPUSCROLL
			; lda #(PPUCTRL_NMI_ON | PPUCTRL_BGR_PATTERNTABLE_1)
			; sta PPUCTRL
			
		
	_Next:
	rts
