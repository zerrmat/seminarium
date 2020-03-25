.include "title_consts.h"

; title_subs.s
.import updateFrameCounters, updateTimeCounters, updateTextBlinkFlag

; title_bss.s
.import mainLoopSleeping, titleFlags

forever:
    inc mainLoopSleeping
@loop:
	lda mainLoopSleeping
	bne @loop
	; mainLoopStart:
	lda titleFlags
	and #TITLE_FLAG_ENDSCROLL
	bne handlePostScrollFrame
	jmp endMainLoop
handlePostScrollFrame:
	jsr updateFrameCounters
	jsr updateTimeCounters
	jsr updateTextBlinkFlag
endMainLoop:
    jmp forever
