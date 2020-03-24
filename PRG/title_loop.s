.include "title_bss.h"
.include "title_consts.h"
.include "title_subs.h"

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
