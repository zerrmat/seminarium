.segment "BSS"
.export programFlags, buttons, machineRegion, frameCounter
.export regionFixFrameCounter, secondsCounter, minutesCounter, hoursCounter

; bits:
; 7 -
; 6 -
; 5 -
; 4 -
; 3 -
; 2 - 
; 1 - Program mode: 0 title mode, 1 map mode
; 0 - Main program loop and NMI synchronization: 1 main loop sleeps, 0 main loop is active
programFlags: .res 1
; bits:
; 7 - A
; 6 - B
; 5 - Select
; 4 - Start
; 3 - Up
; 2 - Down
; 1 - Left
; 0 - Right
buttons: .res 1
; bits:
; 7 - 
; 6 -
; 5 -
; 4 - 
; 3 -
; 2 -
; 1 and 0 - 00: NTSC, 01: PAL, 10: Dendy, 11: Unknown
machineRegion: .res 1
frameCounter: .res 1
regionFixFrameCounter: .res 1
secondsCounter: .res 1
minutesCounter: .res 1
hoursCounter: .res 1
