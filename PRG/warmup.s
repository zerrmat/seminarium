.include "registers.h"

.import WarmupEnd	; main.s

.export WarmupStart

APU_FRAME_IRQ_OFF = %01000000

WarmupStart:
	sei						; disable IRQs
	cld						; disable decimal mode
	ldx	#APU_FRAME_IRQ_OFF
	stx	APU_FRAME			; disable APU frame IRQ
	ldx	#$ff				; Set up stack
	txs
	inx						; now X = 0
	stx	PPUCTRL				; disable NMI
	stx	PPUMASK				; disable rendering
	stx	DMC_FREQ			; disable DMC IRQs

	;; first wait for vblank to make sure PPU is ready
	_loop_VBlankWait1:
		bit	PPUSTATUS
		bpl	_loop_VBlankWait1	; at this point, about 27384 cycles (NTSC) have passed

	_ClearMemoryLoop:
		lda	#$00
		sta	$0000, x
		sta	$0100, x
		sta	$0200, x
		sta	$0300, x
		sta	$0400, x
		sta	$0500, x
		sta	$0600, x
		sta	$0700, x
		inx
		bne	_ClearMemoryLoop

	ldy #0
	;; second wait for vblank, PPU is ready after this
	_loop_VBlankWait2:
		bit PPUSTATUS
		bpl _loop_VBlankWait2	
	
	jmp WarmupEnd
	