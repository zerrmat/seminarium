.include "registers.h"
.include "nes_consts.h"

.importzp paletteLo, paletteHi					; prg_zp.s
.import _data_mapNametable, _data_mapPalette	; map_data.s
.import SetBackground, SetFullPalette			; prg_subs.s

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
	
	lda #<(_data_mapPalette)
	sta paletteLo
	lda #>(_data_mapPalette)
	sta paletteHi
	jsr SetFullPalette
	
	lda	#(PPUMASK_SPR_ON | PPUMASK_BGR_ON | PPUMASK_SPR_LEFT8_ON | PPUMASK_BGR_LEFT8_ON)
	sta	PPUMASK
	lda #(PPUCTRL_NMI_ON | PPUCTRL_BGR_PATTERNTABLE_1)
	sta PPUCTRL
	lda #0
	sta PPUSCROLL
	sta PPUSCROLL
	rts
	