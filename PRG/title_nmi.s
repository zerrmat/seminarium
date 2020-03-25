.include "title_consts.h"
.include "registers.h"
.include "nes_consts.h"

; title_subs.s
.import drawBlinkText

; title_bss.s
.import titleScrollY, titleFlags, mainLoopSleeping

; main.s
.export title_nmi

title_nmi:
	ldy titleScrollY
	beq skip_title_scroll
		dey
		sty titleScrollY
		lda #TITLE_END_SCROLL_POS
		sta PPUSCROLL
		sty PPUSCROLL
		lda #PPUCTRL_NMI_ON
		sta PPUCTRL
		jmp end_title_nmi
	
	skip_title_scroll:
	lda titleFlags
	ora #TITLE_FLAG_ENDSCROLL
	sta titleFlags
	jsr drawBlinkText
; fixScroll:
	lda titleScrollY
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL
end_title_nmi:
	rts
	