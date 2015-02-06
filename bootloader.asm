;;
;; bootloader.asm
;; basic bootloader
;; Tasks:
;;      - loads "stage_2" to 0x0500 : 0x0000
;;      - jumps to 0x0500 : 0x0000 and starts execution
;;
 
org 0x7C00
bits 16

mov     si, splash
call    print_string
call    new_line

mov     [b_disk], dl

mov     al, dl
call    pprint_hex8

jmp     read_disk

;; read_disk
;; read stage 2 into memory, makes sure the disk is reset
read_disk:
    call    reset_disk
    mov     bx, 0x0500    ;; Read data to this offset
    mov     es, bx        ;; save base address in extra segment's register
    mov     bx, 0x0000    ;; save offset [es: bx]
    mov     ah, 0x02      ;; read disk to memory
    mov     dl, [b_disk]  ;; disk 0 (the first floppy)
    mov     ch, 0x00      ;; first track/cylinder
    mov     cl, 0x02      ;; read starting with second sector (byte #513)
    mov     dh, 0x00      ;; read head
    mov     al, 0x01      ;; read 1 sector
    int     0x13
    jc      read_disk
    jmp     0x0500: 0x0000

;; reset_disk
;; Reset the floppy controller to get ready to read files
reset_disk:
    mov     ah, 0x00      ;; Reset floppy controller
    mov     dl, [b_disk]  ;; Drive number (should be 0)
    int     0x13          ;; execute
    jc      reset_disk    ;; if failed, try again
    ret

%include "real_mode_print.asm"

;; Global variables
b_disk: db 0 ;; store the boot disk, make sure it dosen't get lost

;; Data section
splash: db "loading stage 2", 0

;; Pad rest of bootloader with 0s
times 510 - ($ - $$) db 0

;; Boot signature
db 0x55
db 0xAA
