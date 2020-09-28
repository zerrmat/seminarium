; Notepad++ ASM6502 NES highlight: https://github.com/vblank182/6502-npp-syntax

; Everdrive runs roms with header

; Code based on following resources:
; Blargg's "Absolute minimal example"
; http://forums.nesdev.com/viewtopic.php?t=4247
; ddribin's "Nerdy Nights ca65 remix lesson 03: background"
; https://bitbucket.org/ddribin/nerdy-nights/src/default/03-background/background.asm
; Detect console region
; http://forums.nesdev.com/viewtopic.php?p=163258#p163258

.include "prg_consts.h"
; NAMETABLE_0_ADDR, NAMETABLE_1_ADDR
.include "nes_consts.h"
.include "title_consts.h"
.include "registers.h"

.import TitleNMI	; title_nmi.s
.import TitleMain	; title_loop.s
; title_bss.s
.import programFlags, buttons, titleScrollY, titleFlags
; init_subs.s
.import SetTitlePalette, SetSprites, InitTitleState, PlaySound, DetectRegion
.import WarmupStart	; warmup.s
.import ReadController, SetFullPalette	; prg_subs.s
.import SetTitleBackgrounds	; title_subs.s
.import SetMapBackground	; map_subs.s

; tmpppppppppppppppppppppppp
.importzp paletteLo, paletteHi
.import _data_titlePalette	; title_data.s

.export WarmupEnd

.segment "CODE"
_INT_Reset:
	jmp WarmupStart
	WarmupEnd:
	jsr DetectRegion
	
	lda #<(_data_titlePalette)
	sta paletteLo
	lda #>(_data_titlePalette)
	sta paletteHi
	jsr SetFullPalette
	
	jsr SetTitleBackgrounds
	
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
		lda programFlags
		ora #PROGRAM_FLAGS_MAIN_LOOP_SET_SLEEP
		sta programFlags
		_loop_Sleep:
			lda programFlags
			and #PROGRAM_FLAGS_MAIN_LOOP_IS_ACTIVE
			bne _loop_Sleep
		
		jsr ReadController
		jsr CheckTitleStartButton

		jsr ExecuteGameLoop
		jmp _loop_Main
	
_INT_NMI:
	pha         ; back up registers (important)
    txa
    pha
    tya
    pha

	jsr ExecuteNMI
	
	lda programFlags
	and #PROGRAM_FLAGS_MAIN_LOOP_SET_ACTIVE
	sta programFlags
	
	pla            ; restore regs and exit
    tay
    pla
    tax
    pla
_INT_IRQ:
	rti

CheckTitleStartButton:
	lda titleFlags
	and #TITLE_FLAG_ENDSCROLL
	beq _SkipProgramModeChange
		lda programFlags
		and #PROGRAM_FLAGS_IS_TITLE_MODE
		bne _SkipProgramModeChange
			lda buttons
			and #BUTTONS_START
			beq _SkipProgramModeChange
				lda programFlags
				ora #PROGRAM_FLAGS_SET_MAP_MODE
				sta programFlags
				; set new background
				jsr SetMapBackground
				
	_SkipProgramModeChange:	
	rts

ExecuteGameLoop:
	lda programFlags
	and #PROGRAM_FLAGS_IS_TITLE_MODE
	bne @_Skip
		jsr TitleMain
		
	@_Skip:
	rts
	
ExecuteNMI:
	lda programFlags
	and #PROGRAM_FLAGS_IS_TITLE_MODE
	bne @_Skip
		jsr TitleNMI
	
	@_Skip:
	rts
	
.segment "VECTORS"
    .word _INT_NMI, _INT_Reset, _INT_IRQ	