.include "registers.h"

.export set_sprites

set_sprites:
	lda #$00
	sta OAM
	lda #$01
	sta OAM + $01
	lda #%00000000
	sta OAM + $02
	lda #$00
	sta OAM + $03
	
	; Set RAM region $0200 as SPRRAM
	lda #<OAM
	sta OAMADDR
	lda #>OAM
	sta OAMDMA
	rts
	