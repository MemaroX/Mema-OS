bits 32
org 0x8000

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax

    lidt [idt_descriptor]
    sti

    call clear_screen
    mov si, msg_welcome
    call print_string
    call print_newline
    mov si, msg_prompt
    call print_string

hang:
    jmp $

keyboard_handler:
    pusha
    in al, 0x60 

    cmp al, 0x80 
    jge .done

    movzx ebx, al
    mov al, [scancode_map + ebx]
    cmp al, 0
    je .done

    cmp al, 0x08 ; Backspace
    je .handle_backspace
    cmp al, 0x0d ; Enter
    je .handle_enter

    mov ebx, [buffer_pos]
    cmp ebx, 78 
    jge .done
    mov [command_buffer + ebx], al
    inc dword [buffer_pos]
    call print_char

.done:
    popa
    iret

.handle_backspace:
    mov ebx, [buffer_pos]
    cmp ebx, 0
    je .done 
    dec dword [buffer_pos]
    call print_backspace
    jmp .done

.handle_enter:
    call print_newline
    call process_command
    mov dword [buffer_pos], 0
    mov si, msg_prompt
    call print_string
    jmp .done

process_command:
    pusha
    mov ebx, [buffer_pos]
    mov byte [command_buffer + ebx], 0 
    mov si, command_buffer
    mov di, cmd_help
    call strcmp
    jc .is_help

    mov si, command_buffer
    mov di, cmd_cls
    call strcmp
    jc .is_cls

    mov si, msg_unknown_cmd
    call print_string
    jmp .end_process

.is_help:
    mov si, msg_help
    call print_string
    jmp .end_process

.is_cls:
    call clear_screen
    jmp .end_process

.end_process:
    call print_newline
    popa
    ret

strcmp:
    pusha
.loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .notequal
    cmp al, 0
    je .equal
    inc si
    inc di
    jmp .loop
.equal:
    stc
    jmp .end
.notequal:
    clc
.end:
    popa
    ret

print_char:
    pusha
    mov ebx, [cursor_pos]
    mov [VIDEO_MEMORY + ebx], al
    mov byte [VIDEO_MEMORY + ebx + 1], WHITE_ON_BLACK
    add dword [cursor_pos], 2
    popa
    ret

print_string:
    pusha
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    popa
    ret

print_newline:
    pusha
    mov eax, [cursor_pos]
    mov ebx, 160
    xor edx, edx
    div ebx
    inc eax
    mul ebx
    mov [cursor_pos], eax
    popa
    ret

print_backspace:
    pusha
    mov ebx, [cursor_pos]
    cmp ebx, 0
    je .done
    sub dword [cursor_pos], 2
    mov ebx, [cursor_pos]
    mov byte [VIDEO_MEMORY + ebx], ' '
.done:
    popa
    ret

clear_screen:
    pusha
    mov edi, VIDEO_MEMORY
    mov ecx, 2000
.loop:
    mov byte [edi], ' '
    mov byte [edi+1], WHITE_ON_BLACK
    add edi, 2
    loop .loop
    mov dword [cursor_pos], 0
    popa
    ret

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

idt_start:
    dw keyboard_handler, 0x08
    db 0, 0x8E
    dw 0
idt_end:

cursor_pos dd VIDEO_MEMORY
buffer_pos dd 0
command_buffer: times 80 db 0

msg_welcome: db 'Mema-OS v0.02 | Type "help" for commands.', 0
msg_prompt: db '> ', 0
msg_help: db 'Commands: help, cls', 0
msg_unknown_cmd: db 'Unknown command.', 0

cmd_help: db 'help', 0
cmd_cls: db 'cls', 0

scancode_map:
    db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0x08, 0
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0x0d, 0
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '''', '`', 0
    db '', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0
    db ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0