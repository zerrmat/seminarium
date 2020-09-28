.ifndef NES_CONSTS_H
NES_CONSTS_H = 1

PPUCTRL_NMI_ON 				= %10000000
PPUCTRL_BGR_PATTERNTABLE_1 	= %00010000
PPUCTRL_RENDERING_OFF 		= %00000000

PPUMASK_SPR_ON 			= %00010000
PPUMASK_BGR_ON 			= %00001000
PPUMASK_SPR_LEFT8_ON 	= %00000100
PPUMASK_BGR_LEFT8_ON 	= %00000010
PPUMASK_RENDERING_OFF 	= %00000000

NAMETABLE_LENGTH = $0400

NAMETABLE_0_ADDR = $2000
NAMETABLE_1_ADDR = $2800

BGR_PALETTE_PPU_ADDR = $3F00
SPR_PALETTE_PPU_ADDR = $3F10
PPU_PALETTES_SIZE = $20

MACHINEREGION_NTSC 	= $00
MACHINEREGION_PAL 	= $01
MACHINEREGION_DENDY = $02

.endif