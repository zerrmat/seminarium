; Notepad++ ASM6502 NES highlight: https://github.com/vblank182/6502-npp-syntax

; Everdrive runs roms with header

; Code based on following resources:
; Blargg's "Absolute minimal example"
; http://forums.nesdev.com/viewtopic.php?t=4247
; ddribin's "Nerdy Nights ca65 remix lesson 03: background"
; https://bitbucket.org/ddribin/nerdy-nights/src/default/03-background/background.asm
; Detect console region
; http://forums.nesdev.com/viewtopic.php?p=163258#p163258

.segment "HEADER"
    .byte "NES"		; Magic number for files which are meant to run in NES emulators
	.byte $1A		; MS-DOS end-of-file byte
	.byte 2			; 2 x 16 KB (32 KB) for code (PRG)
	.byte 1 		; 1 x 8 KB (8 KB) for graphics (CHR)
	.byte %00000000 ; mapper 0 (highest 4 bits), vertical mirroring (8th bit)
.segment "VECTORS"
    .word nmi, reset, irq
.segment "STARTUP" ; avoids warning

.segment "ZEROPAGE"
nametable_lo: .res 1
nametable_hi: .res 1

.segment "BSS"
machineRegion: .res 1
mainmenuScrollY: .res 1
frameCounter: .res 1
regionFixFrameCounter: .res 1
secondsCounter: .res 1
minutesCounter: .res 1
hoursCounter: .res 1
mainmenuScrolled: .res 1
mainLoopSleeping: .res 1

.segment "CODE"
reset:
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

	ldy #0
	;; second wait for vblank, PPU is ready after this
vblankwait2:
	bit $2002
	bpl vblankwait2
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; now the machine setup is done
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;;; BUT because of a hardware oversight, we might have missed a vblank flag.
;;;  so we need to both check for 1Vbl and 2Vbl
;;; VBlank flag is modified each $9B0 cycles (in hex)
;;; NTSC NES: 29780 cycles / 12.005 -> $9B1 or $1362 (Y:X)
;;; PAL NES:  33247 cycles / 12.005 -> $AD2 or $15A3
;;; Dendy:    35464 cycles / 12.005 -> $B8B or $1715

;;; Original code: http://forums.nesdev.com/viewtopic.php?p=163258#p163258

vblankwait3:
	inx
	bne @noincy
	iny
@noincy:
	bit $2002
	bpl vblankwait3

	tya
	cmp #$C
	bcc @nodiv2
	lsr
@nodiv2:
	clc
	adc #<-9
	cmp #3
	bcc @noclip3
	lda #3
@noclip3:
;;; Right now, A contains 0, 1, 2, 3 for NTSC, PAL, Dendy, Bad
	sta machineRegion
	
	;; Set mainmenu palette
	lda	$2002		; Read PPU status to reset PPU address
	lda	#$3f		; Set PPU address to BG palette RAM ($3F00)
	sta	$2006
	lda	#$00
	sta $2006

	ldx	#$00		
@loop:
	lda mainmenu_palette, x
	sta	$2007
	inx
	cpx #$20 ; Loop $20 times (up to $3F20)
	bne	@loop
	
	jsr loadBackground
	
	jsr initSprites
	
	; Set RAM region $0200 as SPRRAM
	lda #$00
	sta $2003
	lda #$02
	sta $4014

	; Init state
	lda #$F0
	sta mainmenuScrollY

	; Set PPU
	lda	#%00011110	; BGR, SPR, show BGR and SPR in leftmost 8 pixels
	sta	$2001
	lda #%10000010	; NMI on
	sta $2000
	
	; Play short tone
    lda #$01
    sta $4015
    lda #$9F
    sta $4000
    lda #$22
    sta $4003

; Main loop synchronization with VBlank: https://wiki.nesdev.com/w/index.php/The_frame_and_NMIs
; "Take Full Advantage of NMI" section
forever:
    inc mainLoopSleeping
@loop:
	lda mainLoopSleeping
	bne @loop
; mainLoopStart:
	lda mainmenuScrolled
	and #%00000001
	bne handlePostScrollFrame
	jmp endForever
handlePostScrollFrame:
	inc frameCounter
; applySecondsFix:
	ldy machineRegion
	cpy #$00
	bne applyPALDendySecondsFix	; PAL and Dendy have 50 VBlanks per second
	jmp endHandlePostScrollFrame
applyPALDendySecondsFix:
	ldy regionFixFrameCounter
	iny
	sty regionFixFrameCounter
	cpy #$05
	bne endHandlePostScrollFrame
	ldy #$00
	sty regionFixFrameCounter
	inc frameCounter
endHandlePostScrollFrame:
; handleTimeCounters:
	lda frameCounter
	cmp #$3C
	bmi checkSeconds
	sec
	sbc #$3C
	sta frameCounter
	inc secondsCounter
checkSeconds:
	lda secondsCounter
	cmp #$3C
	bmi checkMinutes
	sec
	sbc #$3C
	sta secondsCounter
	inc minutesCounter
checkMinutes:
	lda minutesCounter
	cmp #$3C
	bmi endHandleTimeCounters
	sec
	sbc #$3C
	sta minutesCounter
	inc hoursCounter
endHandleTimeCounters:
endForever:
    jmp forever
	
nmi:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha
	
	ldy mainmenuScrollY
	beq skip_mainmenu_scroll
	
	dey
	sty mainmenuScrollY
	lda #$00
	sta $2005
	sty $2005
	lda #%10000000
	sta $2000
	jmp endNMI
skip_mainmenu_scroll:
	lda #%00000001
	sta mainmenuScrolled
endNMI:
	lda #$00
	sta mainLoopSleeping
	
	pla            ; restore regs and exit
    tay
    pla
    tax
    pla
irq:
	rti
	
initSprites:
	lda #$00
	sta $0200
	lda #$01
	sta $0201
	lda #%00000000
	sta $0202
	lda #$00
	sta $0203
	rts
	
loadBackground:
	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	
	lda #<(mainmenu_nametable)
	sta nametable_lo
	lda #>(mainmenu_nametable)
	sta nametable_hi
	ldx #$00
	ldy #$00
@outer_loop:
@inner_loop:
	lda (nametable_lo), y
	sta $2007
	iny
	cpy #$00
	bne @inner_loop
	
	inc nametable_hi	
	inx
	cpx #$04
	bne @outer_loop
;;; second
	lda $2002
	lda #$28
	sta $2006
	lda #$00
	sta $2006
	
	lda #<(mainmenu_nametable_2)
	sta nametable_lo
	lda #>(mainmenu_nametable_2)
	sta nametable_hi
	ldx #$00
	ldy #$00
@outer_loop2:
@inner_loop2:
	lda (nametable_lo), y
	sta $2007
	iny
	cpy #$00
	bne @inner_loop2
	
	inc nametable_hi	
	inx
	cpx #$04
	bne @outer_loop2
	rts

test_sprite:
	.byte $00, $01, $00, $00

mainmenu_palette:
	.incbin "Palettes/mainmenu_palette.pal"
	;.byte $21,$20,$10,$00,$21,$01,$21,$31,$21,$06,$16,$26,$21,$09,$19,$29	; BGR
	;.byte $21,$30,$10,$30,$21,$01,$21,$31,$21,$06,$16,$26,$21,$09,$19,$29	; SPR

mainmenu_nametable:
	.incbin "Nametables/mainmenu.nam"
	
mainmenu_nametable_2:
	.incbin "Nametables/mainmenu2.nam"

.segment "TILES"
    .incbin "CHR/my.chr" ; if you have one