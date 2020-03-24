.include "registers.h"

	; Play short tone
    lda #$01
    sta SND_CHN
    lda #$8F
    sta SQ1_VOL
    lda #$32
    sta SQ1_HI