; Notepad++ ASM6502 NES highlight: https://github.com/vblank182/6502-npp-syntax

; Everdrive runs roms with header

; Code based on following resources:
; Blargg's "Absolute minimal example"
; http://forums.nesdev.com/viewtopic.php?t=4247
; ddribin's "Nerdy Nights ca65 remix lesson 03: background"
; https://bitbucket.org/ddribin/nerdy-nights/src/default/03-background/background.asm
; Detect console region
; http://forums.nesdev.com/viewtopic.php?p=163258#p163258

.include "nes_consts.h"
.include "registers.h"

.import DetectRegion	; console_region.s
.import TitleNMI	; title_nmi.s
.import TitleMain	; title_loop.s
.import mainLoopSleeping	; title_bss.s
.import SetTitlePalette	; title_pal.s
.import SetBackgrounds	; title_bgr.s
.import SetSprites	; title_spr.s
.import InitTitleState	; title_state.s
.import PlaySound	; title_snd.s
.import WarmupStart	; warmup.s

.export WarmupEnd

.segment "CODE"
_INT_Reset:
	jmp WarmupStart
	WarmupEnd:
	jsr DetectRegion
	jsr SetTitlePalette
	jsr SetBackgrounds
	jsr SetSprites
	jsr InitTitleState
		
	jsr PlaySound

	; Set PPU
	lda	#(PPUMASK_SPR_ON | PPUMASK_BGR_ON | PPUMASK_SPR_LEFT8_ON | PPUMASK_BGR_LEFT8_ON)
	sta	PPUMASK
	lda #PPUCTRL_NMI_ON	; NMI on
	sta PPUCTRL

	; Main loop synchronization with VBlank: https://wiki.nesdev.com/w/index.php/The_frame_and_NMIs
	; "Take Full Advantage of NMI" section		
	_loop_Main:
		inc mainLoopSleeping
		_loop_Sleep:
			lda mainLoopSleeping
			bne _loop_Sleep
		
		jsr TitleMain
		jmp _loop_Main
	
_INT_NMI:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha

	jsr TitleNMI
	
	lda #$00
	sta mainLoopSleeping
	
	pla            ; restore regs and exit
    tay
    pla
    tax
    pla
_INT_IRQ:
	rti
	
.segment "VECTORS"
    .word _INT_NMI, _INT_Reset, _INT_IRQ