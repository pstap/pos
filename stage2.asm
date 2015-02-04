org 0x5000

bits 16

call    new_line
mov     si, load_success
call    print_string

%include "real_mode_print.asm"

load_success: db "Stage 2 Loaded Successfully", 0
