;;
;; stage2.asm
;; basically the kernel
;;


org 0x5000

bits 16

main:


;; Gets a key
;; Returns: nothing
get_key:
    pusha
    mov     ah, 0x00
    int     0x16
    popa
    ret

%include "real_mode_print.asm"

load_success:   db "Stage 2 Loaded Successfully", 0
video_mode_msg: db "Setting video mode to 640x200x16",0
