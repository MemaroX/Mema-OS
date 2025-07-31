bits 16
org 0x8000

start:
    ; Setup data segment
    mov ax, cs
    mov ds, ax

    mov si, msg_kernel
    call print_string

    jmp $

print_string:
    mov ah, 0x0e
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

msg_kernel: db 'Kernel successfully loaded and executing!', 0x0d, 0x0a, 0