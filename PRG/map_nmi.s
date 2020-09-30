.include "nes_consts.h"
.include "registers.h"

.importzp paletteLo, paletteHi	; prg_zp.s
.import _data_mapLevelsPos		; map_data.s
.import SetFullPalette			; prg_subs.s

.export MapNMI

MapNMI:
	lda #<OAM
	sta OAMADDR
	lda #>OAM
	sta OAMDMA	
	rts
	