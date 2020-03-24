.include "title_consts.h"
.include "title_bss.h"
.include "registers.h"
.include "title_subs.h"
.include "nes_consts.h"

.export nmi

nmi:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha
	
	ldy titleScrollY
	beq skip_title_scroll
	
	dey
	sty titleScrollY
	lda #TITLE_END_SCROLL_POS
	sta PPUSCROLL
	sty PPUSCROLL
	lda #PPUCTRL_NMI_ON
	sta PPUCTRL
	jmp endNMI
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
	
endNMI:
	lda #$00
	sta mainLoopSleeping
	
	pla            ; restore regs and exit
    tay
    pla
    tax
    pla
	rti
	