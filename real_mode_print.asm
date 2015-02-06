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

;; print_string_new_line
;; calls print string and then 'new_line' right after
print_string_new_line:
    call    print_string
    call    new_line
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

;; print_hex8
;; Print hex value of byte in AL in hex
print_hex8:
    pusha
    mov     si, hex_chars      ;; si points to hex_chars
    and     ax, 0x0F           ;; clear upper byte of AX
    add     si, ax             ;; adjust si to point to correct char
    mov     al, [si]           ;; move character pointed to by si into al

    mov             ah, 0x0E   ;; print char at current cursor position
    mov             bh, 0x00   ;; page number
    mov             bl, 0x08   ;; properties

    int             0x10       ;; returns nothing
    popa
    ret

;; print_hex16
;; prints word stored in AL in hex
print_hex16:
    push    ax
    push    ax          ;; store ax on the stack
    shr     ax, 0x04    ;; push the top of AH down to AL
    call    print_hex8  ;; print the higher byte
    pop     ax          ;; original lower AL now in AL
    call    print_hex8  ;; print the lower byte
    pop     ax
    ret

;; pprint_hex8
;; Pretty print byte in AL in hex
;; includes "0x" prefix
pprint_hex8:
    pusha
    mov     si, hex_prefix
    call    print_string
    popa
    call    print_hex8
    ret

;; pprint_hex16
;; Pretty print byte in AX in hex
;; includes "0x" prefix
pprint_hex16:
    pusha
    mov     si, hex_prefix
    call    print_string
    popa
    call    print_hex16
    ret

hex_prefix: db "0x", 0
hex_chars: db "0123456789ABCDEF"
