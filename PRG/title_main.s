.include "title_consts.h"

; title_subs.s
.import UpdateFrameCounters, UpdateTimeCounters, UpdateTextBlinkFlag

; title_bss.s
.import titleFlags

.export TitleMain

TitleMain:
	; mainLoopStart:
	lda titleFlags
	and #TITLE_FLAG_ENDSCROLL
	bne _HandlePostScrollFrame
		jmp _EndTitleMain
	
	_HandlePostScrollFrame:
	jsr UpdateFrameCounters
	jsr UpdateTimeCounters
	jsr UpdateTextBlinkFlag
_EndTitleMain:
	rts
