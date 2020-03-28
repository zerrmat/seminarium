.include "registers.h"
.include "nes_consts.h"

.import _data_mapNametable	; map_data.s
.import SetBackground	; prg_subs.s

.export SetMapBackground

SetMapBackground:
	lda #PPUCTRL_RENDERING_OFF
	sta PPUCTRL
	lda #PPUMASK_RENDERING_OFF
	sta PPUMASK
	
	lda #<(_data_mapNametable)
	pha
	lda #>(_data_mapNametable)
	pha
	lda #<NAMETABLE_0_ADDR
	pha
	lda #>NAMETABLE_0_ADDR
	pha
	jsr SetBackground
	
	lda	#(PPUMASK_SPR_ON | PPUMASK_BGR_ON | PPUMASK_SPR_LEFT8_ON | PPUMASK_BGR_LEFT8_ON)
	sta	PPUMASK
	lda #PPUCTRL_NMI_ON	; NMI on
	sta PPUCTRL
	rts
	