.include "nes_consts.h"

.export _data_mapNametable, _data_mapPalette, _data_mapLevelsPos

_data_mapNametable:
	.incbin "Nametables/mapscreen.nam"

_data_mapPalette:
	.incbin "Palettes/mappalette.pal"
	
_data_mapLevelsPos:
	.byte $30, $41, (OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR), $A0
	.byte $40, $41, (OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR), $B0
	.byte $40, $41, (OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR), $C0
	.byte $50, $41, (OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR), $90
	.byte $60, $41, (OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR), $90
	.byte $70, $41, (OAM_SPR_PAL_1 | OAM_SPR_FRONT_BGR), $90	