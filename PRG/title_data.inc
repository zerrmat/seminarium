test_sprite:
	.byte $00, $01, $00, $00

title_palette:
	.incbin "Palettes/title_palette.pal"
	;.byte $21,$20,$10,$00,$21,$01,$21,$31,$21,$06,$16,$26,$21,$09,$19,$29	; BGR
	;.byte $21,$30,$10,$30,$21,$01,$21,$31,$21,$06,$16,$26,$21,$09,$19,$29	; SPR

title_nametable:
	.incbin "Nametables/titlescreen.nam"
	
title_nametable_2:
	.incbin "Nametables/titlescreen2.nam"
	
title_pushstart_text:
	.byte $1A, $1F, $1D, $12, $00, $1D, $1E, $0B, $1C, $1E, $00, $0C, $1F, $1E, $1E, $19, $18

.segment "TILES"
    .incbin "CHR/my.chr"