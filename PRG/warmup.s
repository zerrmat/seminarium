.include "registers.h"

APU_FRAME_IRQ_OFF = %01000000

.import warmup_end

.export warmup_start

warmup_start:
	sei			; disable IRQs
	cld			; disable decimal mode
	ldx	#APU_FRAME_IRQ_OFF
	stx	APU_FRAME	; dsiable APU frame IRQ
	ldx	#$ff		; Set up stack
	txs			;  .
	inx			; now X = 0
	stx	PPUCTRL		; disable NMI
	stx	PPUMASK		; disable rendering
	stx	DMC_FREQ	; disable DMC IRQs

	;; first wait for vblank to make sure PPU is ready
	vblankwait1_loop:
		bit	PPUSTATUS
		bpl	vblankwait1_loop	; at this point, about 27384 cycles have passed

	clear_memory_loop:
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
		bne	clear_memory_loop

	ldy #0
	;; second wait for vblank, PPU is ready after this
	vblankwait2_loop:
		bit PPUSTATUS
		bpl vblankwait2_loop	
	
	jmp warmup_end
	