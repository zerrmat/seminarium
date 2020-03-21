; Notepad++ ASM6502 NES highlight: https://github.com/vblank182/6502-npp-syntax

; Everdrive runs roms with header

; Code based on following resources:
; Blargg's "Absolute minimal example"
; http://forums.nesdev.com/viewtopic.php?t=4247
; ddribin's "Nerdy Nights ca65 remix lesson 03: background"
; https://bitbucket.org/ddribin/nerdy-nights/src/default/03-background/background.asm
; Detect console region
; http://forums.nesdev.com/viewtopic.php?p=163258#p163258

.include "romheader.s"

.segment "STARTUP" ; avoids warning

.segment "VECTORS"
    .word nmi, reset, irq
	
.segment "ZEROPAGE"
.include "mainmenu_zp.inc"

.segment "BSS"
.include "mainmenu_bss.inc"

.segment "CODE"
.include "warmup.s"
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; now the machine setup is done
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
.include "consoleregion.s"

.include "mainmenu_pal.s"
.include "mainmenu_bgr.s"
.include "mainmenu_spr.s"
.include "mainmenu_state.s"
.include "mainmenu_snd.s"

	; Set PPU
	lda	#%00011110	; BGR, SPR, show BGR and SPR in leftmost 8 pixels
	sta	$2001
	lda #%10000010	; NMI on
	sta $2000

; Main loop synchronization with VBlank: https://wiki.nesdev.com/w/index.php/The_frame_and_NMIs
; "Take Full Advantage of NMI" section
forever:
    inc mainLoopSleeping
@loop:
	lda mainLoopSleeping
	bne @loop
.include "mainmenu_loop.s"
endMainLoop:
    jmp forever
	
nmi:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha
	
.include "mainmenu_nmi.s"
	
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
	
.include "mainmenu_subs.s"	
.include "mainmenu_data.inc"