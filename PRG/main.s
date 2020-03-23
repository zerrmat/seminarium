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
	
.include "title_zp.h"
.include "title_zp.h"
.include "title_zp.h"
.include "title_zp.h"
.include "title_zp.h"

.segment "BSS"
.include "title_bss.inc"

.segment "CODE"
.include "warmup.s"
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; now the machine setup is done
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
.include "consoleregion.s"

.include "title_pal.s"
.include "title_bgr.s"
.include "title_spr.s"
.include "title_state.s"
.include "title_snd.s"

	; Set PPU
	lda	#(PPUMASK_SPR_ON | PPUMASK_BGR_ON | PPUMASK_SPR_LEFT8_ON | PPUMASK_BGR_LEFT8_ON)
	sta	PPUMASK
	lda #PPUCTRL_NMI_ON	; NMI on
	sta PPUCTRL

; Main loop synchronization with VBlank: https://wiki.nesdev.com/w/index.php/The_frame_and_NMIs
; "Take Full Advantage of NMI" section
forever:
    inc mainLoopSleeping
@loop:
	lda mainLoopSleeping
	bne @loop
.include "title_loop.s"
endMainLoop:
    jmp forever
	
nmi:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha
	
.include "title_nmi.s"
	
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
	
.include "title_subs.s"	
.include "title_data.inc"