;;
;; real_mode_print.asm
;; functions for printing in real mode
;; 
;; 

;; print_string
;; prints '0' terminated string pointed to by si
print_string:
    mov     al, [si]     ;; al holds character to print
    inc     si           ;; increment si to point to next character
    or      al, al       ;; check if 0
    jz      .end_print   ;; if 0 jump to .endPrint
    call    .print_char  ;; fall through to print char
    jmp     print_string ;; loop

    .print_char:
        mov     ah, 0x0E    ;; print char at current cursor position
        mov     bh, 0x00    ;; page number
        mov     bl, 0x08    ;; properties

        int     0x10        ;; returns nothing
        ret

    .end_print:
        ret
 
;; new_line
;; moves cursor to the next line, first column
new_line:
     pusha             ;; push registers to stack
 
     mov     ah, 0x03  ;; get cursor position
     mov     bh, 0x00  ;; page number
     int     0x10      ;; ch = start scan line, cl = end scan line, dh = row, dl = column
 
     mov     ah, 0x02  ;; set cursor position
     inc     dh        ;; Increment the row
     mov     dl, 0x00  ;; Set column to 0 (far left)
     int     0x10      ;; returns nothing
 
     popa              ;; pop registers from stack
 
     ret
