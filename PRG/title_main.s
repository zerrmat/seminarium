.include "title_consts.h"

; title_subs.s
.import updateFrameCounters, updateTimeCounters, updateTextBlinkFlag

; title_bss.s
.import mainLoopSleeping, titleFlags

.export title_main

title_main:
	; mainLoopStart:
	lda titleFlags
	and #TITLE_FLAG_ENDSCROLL
	bne handlePostScrollFrame
		jmp end_title_loop
	
	handlePostScrollFrame:
	jsr updateFrameCounters
	jsr updateTimeCounters
	jsr updateTextBlinkFlag
end_title_loop:
	rts

