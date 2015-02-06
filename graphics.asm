;;
;; graphics.asm
;; graphics mode functions
;;

set_640x200x16:
    pusha
    mov     ah, 0x00
    mov     al, 0x0E
    int     0x10
    popa
    ret

;;  (cx, dx) = Top left corner
;;  

;; rect[0] = begin column
;; rect[1] = begin row
;; rect[2] = end column
;; rect[3] = end row
rect: dw 0, 0, 0, 0
