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
.include "nes_consts.h"
.include "title_consts.h"
.include "registers.h"

; tmpppppppppppppppppppppppp
.importzp paletteLo, paletteHi	; prg_zp.s
.import _data_titlePalette		; title_data.s
.import _data_mapPalette, _data_mapLevelsPos		; map_data.s

.import TitleNMI						; title_nmi.s
.import TitleMain						; title_main.s
.import MapNMI
.import MapMain
.import titleScrollY, titleFlags		; title_bss.s
.import WarmupStart						; warmup.s
.import ReadController, SetFullPalette	; prg_subs.s
.import SetTitleBackgrounds				; title_subs.s
.import SetMapBackground				; map_subs.s
; map_bss.s
.import mapFlags, selectedLevel, levelBlinkFrameCounter
; prg_bss.s
.import programFlags, buttons, frameCounter, regionFixFrameCounter
.import secondsCounter, minutesCounter, hoursCounter
; init_subs.s
.import InitTitleState, SetSprites, PlaySound, DetectRegion

.export WarmupEnd

MAP_LEVELS_COUNT = $0C

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
	
	jsr InitTitleState
		
	jsr PlaySound

	; Set PPU
	lda	#(PPUMASK_SPR_ON | PPUMASK_BGR_ON | PPUMASK_SPR_LEFT8_ON | PPUMASK_BGR_LEFT8_ON)
	sta	PPUMASK
	lda #PPUCTRL_NMI_ON
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

		jsr ExecuteGameLoop
		jmp _loop_Main
	
_INT_NMI:
	php	; back up registers (important)
	pha
    txa
    pha
    tya
    pha

	; reset sprite data in PPU
	lda #<OAM
	sta OAMADDR
	lda #>OAM
	sta OAMDMA
	jsr ExecuteNMI
	
	lda programFlags
	and #PROGRAM_FLAGS_MAIN_LOOP_SET_ACTIVE
	sta programFlags
	
	pla            ; restore regs and exit
    tay
    pla
    tax
    pla
	plp
_INT_IRQ:
	rti

CheckModeChange:
	lda programFlags
	and #PROGRAM_FLAGS_IS_TITLE_MODE
	bne _SkipTitleModeChange
		;lda titleFlags
		;and #TITLE_FLAG_ENDSCROLL
		;beq _SkipTitleModeChange
			lda buttons
			and #BUTTONS_START
			beq _SkipTitleModeChange
				lda programFlags
				ora #PROGRAM_FLAGS_SET_MAP_MODE
				sta programFlags
				jsr SetMapBackground
				
				ldx #$00
				stx mapFlags
				stx selectedLevel
				stx frameCounter
				stx regionFixFrameCounter
				stx secondsCounter
				stx minutesCounter
				stx hoursCounter
				inx
				inx
				stx levelBlinkFrameCounter
				
				lda programFlags
				ora #%00000100
				sta programFlags
				
	_SkipTitleModeChange:	
	rts

ExecuteGameLoop:
	jsr ReadController
	jsr CheckModeChange
	
	lda programFlags
	and #PROGRAM_FLAGS_IS_TITLE_MODE
	bne @_Skip1	
		jsr TitleMain
		jmp @_End
		
	@_Skip1:
	; TODO: other modes
		jsr MapMain
	
	@_End:
	rts
	
ExecuteNMI:
	lda programFlags
	and #PROGRAM_FLAGS_IS_TITLE_MODE
	bne @_Skip1
		jsr TitleNMI
		jmp End
		
	@_Skip1:
		lda programFlags
		and #%00000100
		beq Ignore
		lda programFlags
		and #%11111011
		sta programFlags
		ldy #$00
		_loop_InitLevels:
			lda _data_mapLevelsPos, y
			sta OAM, y
			iny
			cpy #MAP_LEVELS_COUNT
			bne _loop_InitLevels
			
	; TODO: other modes
	Ignore:
		jsr MapNMI
	
	End:
	rts
	
.segment "VECTORS"
    .word _INT_NMI, _INT_Reset, _INT_IRQ	