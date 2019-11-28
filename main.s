; Code based on following resources:
; Blargg's "Absolute minimal example"
; http://forums.nesdev.com/viewtopic.php?t=4247
; ddribin's "Nerdy Nights ca65 remix lesson 03: background"
; https://bitbucket.org/ddribin/nerdy-nights/src/default/03-background/background.asm
; Detect console region
; http://wiki.nesdev.com/w/index.php/Detect_TV_system

.segment "HEADER"
    .byte "NES"		; Magic number for files which are meant to run in NES emulators
	.byte $1A		; MS-DOS end-of-file byte
	.byte 2			; 2 x 16 KB (32 KB) for code (PRG)
	.byte 1 		; 1 x 8 KB (8 KB) for graphics (CHR)
	.byte %00000001 ; mapper 0 (highest 4 bits), vertical mirroring (8th bit)
.segment "VECTORS"
    .word nmi, reset, irq
.segment "STARTUP" ; avoids warning

.segment "ZEROPAGE"
machineRegion: .res 1

.segment "CODE"
reset:
	ldx #0
	ldy #0
	sei			; disable IRQs
	cld			; disable decimal mode
	ldx	#$40
	stx	$4017		; dsiable APU frame IRQ
	ldx	#$ff		; Set up stack
	txs			;  .
	inx			; now X = 0
	stx	$2000		; disable NMI
	stx	$2001		; disable rendering
	stx	$4010		; disable DMC IRQs

	;; first wait for vblank to make sure PPU is ready
vblankwait1:
	bit	$2002
	bpl	vblankwait1	; at this point, about 27384 cycles have passed

clear_memory:
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
	bne	clear_memory

	ldy #$00
	;; second wait for vblank, PPU is ready after this
vblankwait2:
	inx
	bne @noincy
	iny
@noincy:
	bit	$2002
	bpl	vblankwait2
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; now the machine setup is done
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;;; BUT because of a hardware oversight, we might have missed a vblank flag.
;;;  so we need to both check for 1Vbl and 2Vbl
;;; VBlank flag is modified each $9B0 cycles (in hex)
;;; NTSC NES: 1 VBlank - 29780 cycles / 12.005 -> $5DC or $F8C (Y:X)
;;; PAL NES:  1 VBlank - 33247 cycles / 12.005 -> $6FD or $10AD
;;; Dendy:    1 VBlank - 35464 cycles / 12.005 -> $7B6 or $1166

;;; Sadly, this code is cycle-dependent on code between vblankwait1 and vblankwait2

	tya
	cmp #$E		; value lower than two VBlanks NTSC
	bcc @nodiv2	; if 1Vb1 (VBlank not missed), jump
	clc			; otherwise code missed one VBlank (2Vb1 situation) so normalize it like it was 1Vb1
	adc #<-9			
@nodiv2:
	clc
	adc #<-5	; subtract value equal to high byte for NTSC cycle count
	cmp #3
	bcc @noclip3
	lda #3
@noclip3:
;;; Right now, A contains 0,1,2,3 for NTSC,PAL,Dendy,Bad
	sta machineRegion
	
clear_palette:	
	;; Need clear both palettes to $00. Needed for Nestopia. Not
	;; needed for FCEU* as they're already $00 on powerup.
	lda	$2002		; Read PPU status to reset PPU address
	lda	#$3f		; Set PPU address to BG palette RAM ($3F00)
	sta	$2006
	lda	#$00
	sta $2006

	ldx	#$20		; Loop $20 times (up to $3F20)
	lda	#$00		; Set each entry to $00
@loop:
	sta	$2007
	dex
	bne	@loop

	lda	#%10000000	; intensify blues
	sta	$2001
	
    lda #$01 ; play short tone
    sta $4015
    lda #$9F
    sta $4000
    lda #$22
    sta $4003
forever:
    jmp forever
	
nmi:
irq:
	rti
	
.segment "CHARS"
    ;.incbin "chr.bin" ; if you have one