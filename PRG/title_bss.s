.segment "TITLEBSS"
.export titleScrollY, titleFlags

; bits:
; 7 - 
; 6 - 
; 5 - 
; 4 - 
; 3 -
; 2 -  
; 1 - 1: "Push start" text shown, 0: "Push start" text hidden
; 0 - 1: end of scrolling, 0: scroll in progress
titleFlags: .res 1

titleScrollY: .res 1
