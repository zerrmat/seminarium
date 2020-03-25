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

.import detect_region	; console_region.s
.import title_nmi	; title_nmi.s
.import title_main	; title_loop.s
.import mainLoopSleeping	; title_bss.s
.import set_title_palette	; title_pal.s
.import set_backgrounds	; title_bgr.s
.import set_sprites	; title_spr.s
.import init_title_state	; title_state.s
.import play_sound	; title_snd.s
.import warmup_start	; warmup.s

.export warmup_end

.segment "CODE"
INT_reset:
	jmp warmup_start
	warmup_end:
	jsr detect_region
	jsr set_title_palette
	jsr set_backgrounds
	jsr set_sprites
	jsr init_title_state
		
	jsr play_sound

	; Set PPU
	lda	#(PPUMASK_SPR_ON | PPUMASK_BGR_ON | PPUMASK_SPR_LEFT8_ON | PPUMASK_BGR_LEFT8_ON)
	sta	PPUMASK
	lda #PPUCTRL_NMI_ON	; NMI on
	sta PPUCTRL

	; Main loop synchronization with VBlank: https://wiki.nesdev.com/w/index.php/The_frame_and_NMIs
	; "Take Full Advantage of NMI" section		
	main_loop:
		inc mainLoopSleeping
		sleep_loop:
			lda mainLoopSleeping
			bne sleep_loop
		
		jsr title_main
		jmp main_loop
	
INT_nmi:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha

	jsr title_nmi
	
	lda #$00
	sta mainLoopSleeping
	
	pla            ; restore regs and exit
    tay
    pla
    tax
    pla
	rti
INT_irq:
	rti
	
.segment "VECTORS"
    .word INT_nmi, INT_reset, INT_irq