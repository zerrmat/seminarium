.include "title_consts.h"
.include "registers.h"
.include "nes_consts.h"

; title_subs.s
.import DrawBlinkText
; title_bss.s
.import titleScrollY, titleFlags

.export TitleNMI

TITLE_END_SCROLL_POS = $00

TitleNMI:
	ldy titleScrollY
	beq _SkipTitleScroll
		dey
		sty titleScrollY
		lda #TITLE_END_SCROLL_POS
		sta PPUSCROLL
		sty PPUSCROLL
		lda #PPUCTRL_NMI_ON
		sta PPUCTRL
		jmp _EndTitleNMI
	
	_SkipTitleScroll:
	lda titleFlags
	ora #TITLE_FLAG_ENDSCROLL
	sta titleFlags
	jsr DrawBlinkText
; fixScroll:
	lda titleScrollY
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL
_EndTitleNMI:
	rts
	