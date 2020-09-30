.segment "TITLEBSS"
.export titleScrollY, titleFlags

titleScrollY: .res 1
; bits:
; 7 - 
; 6 - 
; 5 - 
; 4 - 
; 3 -
; 2 -  
; 1 - "Push Start" text: 1 shown, 0 hidden
; 0 - 1: end of scrolling, 0: scroll in progress
titleFlags: .res 1