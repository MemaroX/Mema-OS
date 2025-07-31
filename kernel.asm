bits 32
org 0x8000

start:
    ; Setup data segment
    mov ax, 0x10
    mov ds, ax

    ; Setup IDT
    lidt [idt_descriptor]

    ; Enable interrupts
    sti

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

keyboard_handler:
    in al, 0x60
    ; For now, just echo the scancode to the screen
    ; (This is not a real scancode to ASCII conversion)
    mov [edi], al
    inc edi
    mov byte [edi], 0x0f
    inc edi
    iret

idt_start:
    ; Keyboard interrupt
    dw keyboard_handler
    dw 0x08
    db 0
    db 0x8e
    dw 0

idt_end:

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

msg_kernel: db 'Kernel successfully loaded in 32-bit protected mode!', 0
