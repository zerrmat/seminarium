
; mainLoopStart:
	lda mainmenuFlags
	and #MAINMENU_FLAG_ENDSCROLL
	bne handlePostScrollFrame
	jmp endMainLoop
handlePostScrollFrame:
	jsr updateFrameCounters
	jsr updateTimeCounters
	jsr updateTextBlinkFlag