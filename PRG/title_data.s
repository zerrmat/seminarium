.export _data_testSprite, _data_titlePalette, _data_titleNametable, _data_titleNametable2
.export _data_titlePushstartText

_data_testSprite:
	.byte $00, $01, $00, $00

_data_titlePalette:
	.incbin "Palettes/titlepalette.pal"

_data_titleNametable:
	.incbin "Nametables/titlescreen.nam"
	
_data_titleNametable2:
	.incbin "Nametables/titlescreen2.nam"
	
_data_titlePushstartText:
	.byte $1A, $1F, $1D, $12, $00, $1D, $1E, $0B, $1C, $1E, $00, $0C, $1F, $1E, $1E, $19, $18

.segment "TILES"
    .incbin "CHR/my.chr"