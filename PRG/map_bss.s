.segment "MAPBSS"
.export mapFlags, selectedLevel, levelBlinkFrameCounter

; Bits:
; 7 -
; 6 -
; 5 -
; 4 -
; 3 -
; 2 -
; 1 -
; 0 - Level blink: 1 red, 0 white
mapFlags:	.res 1

; Values:
; 0 - default
;
;
;
selectedLevel:	.res 1

levelBlinkFrameCounter:	.res 1
