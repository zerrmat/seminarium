
; mainLoopStart:
	lda mainmenuFlags
	and #%00000001
	bne handlePostScrollFrame
	jmp endMainLoop
handlePostScrollFrame:
	jsr updateFrameCounters
	jsr updateTimeCounters
	jsr updateTextBlinkFlag