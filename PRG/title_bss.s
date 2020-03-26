.segment "TITLEBSS"
.export machineRegion, titleScrollY, frameCounter, regionFixFrameCounter
.export secondsCounter, minutesCounter, hoursCounter, titleFlags
.export mainLoopSleeping

machineRegion: .res 1
titleScrollY: .res 1
frameCounter: .res 1
regionFixFrameCounter: .res 1
secondsCounter: .res 1
minutesCounter: .res 1
hoursCounter: .res 1
; bits:
; 7 - 
; 6 - 
; 5 - 
; 4 - 
; 3 -
; 2 -  
; 1 - "Push Start" text: 1 shown, 0 hidden
; 0 - end of scrolling
titleFlags: .res 1
mainLoopSleeping: .res 1
