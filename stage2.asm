bits 16
org 0x7e00      ; This is where the bootloader will load us

start_stage2:
    mov si, stage2_msg  ; Address of our message
    mov ah, 0x0e        ; BIOS teletype function

print_loop_stage2:
    lodsb               ; Load character from [SI] into AL
    cmp al, 0           ; Check for null terminator
    je hang_stage2      ; If null, halt
    int 0x10            ; Print character
    jmp print_loop_stage2 ; Loop for next character

hang_stage2:
    jmp hang_stage2     ; Infinite loop to halt CPU

stage2_msg:
    db 'Welcome to Stage 2!', 0x0d, 0x0a, 0 ; Null-terminated string with newline