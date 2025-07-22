bits 32             ; We are now in 32-bit protected mode

section .text

org 0x0
global _start
_start:
    ; Set up segment registers for protected mode
    mov ax, 0x10        ; Data segment selector (offset 0x10 in GDT)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000    ; Setup a stack (arbitrary address for now)

    ; Print a message using the new function
    mov esi, kernel_msg
    call print_string

    jmp $               ; Infinite loop to halt CPU

; --- print_string function ---
; Input: ESI = address of null-terminated string
; Output: None
print_string:
    pusha
    mov edi, 0xb8000    ; Video memory address
    mov ebx, 0x07       ; White on black attribute

.loop:
    lodsb               ; Load byte from [ESI] into AL, increment ESI
    cmp al, 0           ; Check for null terminator
    je .done

    cmp al, 0x0a        ; Newline character?
    je .newline

    cmp al, 0x0d        ; Carriage return character?
    je .carriage_return

    ; Print character
    mov ecx, [cursor_pos]
    mov byte [edi + ecx], al    ; Character
    mov byte [edi + ecx + 1], bl ; Attribute
    add dword [cursor_pos], 2   ; Advance cursor
    jmp .loop

.newline:
    mov eax, [cursor_pos]
    mov ebx, 160        ; 80 columns * 2 bytes/char
    xor edx, edx
    div ebx             ; EAX = current row, EDX = current column offset
    inc eax             ; Move to next row
    imul eax, 160       ; Calculate offset for next row
    mov [cursor_pos], eax
    jmp .loop

.carriage_return:
    mov eax, [cursor_pos]
    mov ebx, 160
    xor edx, edx
    div ebx             ; EAX = current row, EDX = current column offset
    imul eax, 160       ; Calculate offset for start of current row
    mov [cursor_pos], eax
    jmp .loop

.done:
    popa
    ret

section .data
kernel_msg:
    db 'Welcome to Kernel!', 0x0d, 0x0a, 0 ; Null-terminated string with newline
cursor_pos:
    dd 0                ; Global cursor position, initialized to 0