	; Play short tone
    lda #$01
    sta $4015
    lda #$8F
    sta $4000
    lda #$32
    sta $4003