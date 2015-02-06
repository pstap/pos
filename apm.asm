;
; apm.asm
; Advanced Power Management
; enable it if supported
;

;; check APM version
;; hangs if not present
check_apm:
    mov     ah, 0x53
    mov     al, 0x00
    xor     bx, bx
    int     0x15
    jc      apm_not_found
    jmp     apm_found

apm_not_found:
    call    new_line
    mov     si, msg_apm_not_found
    call    print_string
    jmp     $

apm_error:
    call    new_line
    mov     si, msg_apm_error
    call    print_string

apm_found:
    call    new_line
    mov     si, msg_apm_found
    call    print_string
    mov     ah, 0x53
    mov     al, 0x01
    xor     bx, bx
    int     0x15
    jc      apm_error
    jmp     enable_power_management

;; enable power management for all devices
enable_power_management:
    mov     ah, 0x53
    mov     al, 0x08
    mov     bx, 0x0001
    mov     cx, 0x0001
    int     0x15
    jc      apm_error
    jmp     main



;; APM shutdown all devices
shut_down:
    mov     ah, 0x53
    mov     al, 0x07
    mov     bx, 0x0001
    mov     cx, 0x03 ; off
    int     0x15
    jc      apm_error

check            : db "Checking hardward support for APM", 0
msg_apm_found    : db "APM available on system ", 1, 0
msg_apm_not_found: db "Error, APM not supported", 0
msg_apm_success  : db "APM enabled", 0
msg_apm_error    : db "Unspecified APM error", 0
prompt           : db "Press any key to shut down", 0
setting_video_mode: db "Setting video mode", 0
video_mode_set    : db  "Video mode set", 0
