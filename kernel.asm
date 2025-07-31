bits 32
org 0x8000

start:
    ; Setup data segment
    mov ax, 0x10
    mov ds, ax

    mov esi, msg_kernel
    mov edi, 0xb8000
    mov ah, 0x0f

print_loop:
    lodsb
    cmp al, 0
    je hang
    mov [edi], al
    inc edi
    mov [edi], ah
    inc edi
    jmp print_loop

hang:
    jmp $

msg_kernel: db 'Kernel successfully loaded in 32-bit protected mode!', 0
