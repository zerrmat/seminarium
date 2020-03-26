.segment "BSS"
.export programFlags, buttons

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
