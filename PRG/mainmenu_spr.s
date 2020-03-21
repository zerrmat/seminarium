	lda #$00
	sta $0200
	lda #$01
	sta $0201
	lda #%00000000
	sta $0202
	lda #$00
	sta $0203
	
	; Set RAM region $0200 as SPRRAM
	lda #$00
	sta $2003
	lda #$02
	sta $4014