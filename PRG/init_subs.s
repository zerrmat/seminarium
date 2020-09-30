.include "registers.h"
.include "nes_consts.h"
.include "title_consts.h"

.import machineRegion	; prg_bss.s
.import titleScrollY	; title_bss.s
; title_data.s
.import _data_titlePalette, _data_titleNametable, _data_titleNametable2

.export InitTitleState, SetSprites, PlaySound, DetectRegion

TITLE_START_SCROLL_POS = $F0
TEST_SPR_TILE_NO = $01

InitTitleState:
	lda #TITLE_START_SCROLL_POS
	sta titleScrollY

SetSprites:
	;lda #$00
	;sta OAM + OAM_SPR_OFFSET_X
	;lda #TEST_SPR_TILE_NO
	;sta OAM + OAM_SPR_OFFSET_TILE
	;lda #(OAM_SPR_PAL_0 | OAM_SPR_FRONT_BGR)
	;sta OAM + OAM_SPR_OFFSET_ATTRS
	;lda #$00
	;sta OAM + OAM_SPR_OFFSET_Y
	
	; Set RAM region $0200 as SPRRAM
	;lda #<OAM
	;sta OAMADDR
	;lda #>OAM
	;sta OAMDMA
	rts

PlaySound:
	; Play short tone
    lda #$01
    sta SND_CHN
    lda #$8F
    sta SQ1_VOL
    lda #$32
    sta SQ1_HI
	rts

;;; BUT because of a hardware oversight, we might have missed a vblank flag.
;;;  so we need to both check for 1Vbl and 2Vbl
;;; VBlank flag is modified each $9B0 cycles (in hex)
;;; NTSC NES: 29780 cycles / 12.005 -> $9B1 or $1362 (Y:X)
;;; PAL NES:  33247 cycles / 12.005 -> $AD2 or $15A3
;;; Dendy:    35464 cycles / 12.005 -> $B8B or $1715

;;; Original code: http://forums.nesdev.com/viewtopic.php?p=163258#p163258

DetectRegion:
	_loop_VBlankWait3:
		inx
		bne _NoIncY
			iny
		
		_NoIncY:
		bit PPUSTATUS
		bpl _loop_VBlankWait3
	
	tya
	cmp #$C
	bcc _NoDiv2
		lsr
		
	_NoDiv2:
	clc
	adc #<-9
	cmp #3
	bcc _NoClip3
		lda #3

	_NoClip3:
;;; Right now, A contains 0, 1, 2, 3 for NTSC, PAL, Dendy, Unknown
	sta machineRegion
	rts
	