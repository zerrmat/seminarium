.segment "BSS"
.export programFlags

; bits:
; 7 -
; 6 -
; 5 -
; 4 -
; 3 -
; 2 -
; 1 - 
; 0 - Main program loop and NMI synchronization: 1 main loop sleeps, 0 main loop is active
programFlags: .res 1
