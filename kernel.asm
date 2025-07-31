bits 32
org 0x8000

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

PIC1_COMMAND equ 0x20
PIC1_DATA    equ 0x21
PIC2_COMMAND equ 0xA0
PIC2_DATA    equ 0xA1

start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    call remap_pic
    call setup_idt
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
    jge .key_release

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
    jmp .done

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

.key_release:
    ; Do nothing for now

.done:
    mov al, 0x20
    out 0x20, al
    popa
    iret

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

    mov si, command_buffer
    mov di, cmd_reboot
    call strcmp
    jc .is_reboot

    mov si, command_buffer
    mov di, cmd_about
    call strcmp
    jc .is_about

    mov si, command_buffer
    mov di, cmd_panic
    call strcmp
    jc .is_panic

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

.is_reboot:
    mov si, msg_reboot
    call print_string
    ; Reboot by jumping to the reset vector
    jmp 0xFFFF:0x0000

.is_about:
    mov si, msg_about
    call print_string
    jmp .end_process

.is_panic:
    mov si, msg_panic
    call print_string
    ud2 ; Undefined instruction to trigger a panic

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
    cmp ebx, 2
    jl .done
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

remap_pic:
    mov al, 0x11
    out PIC1_COMMAND, al
    out PIC2_COMMAND, al

    mov al, 0x20
    out PIC1_DATA, al
    mov al, 0x28
    out PIC2_DATA, al

    mov al, 0x04
    out PIC1_DATA, al
    mov al, 0x02
    out PIC2_DATA, al

    mov al, 0x01
    out PIC1_DATA, al
    out PIC2_DATA, al

    mov al, 0x0
    out PIC1_DATA, al
    out PIC2_DATA, al
    ret

setup_idt:
    mov edi, idt_start
    mov ecx, 256
.init_idt_loop:
    mov dword [edi], 0
    mov dword [edi+4], 0
    add edi, 8
    loop .init_idt_loop

    mov eax, keyboard_handler
    mov ebx, 0x21 * 8 ; INT 0x21 (IRQ 1 - keyboard)
    mov [idt_start + ebx], ax
    mov word [idt_start + ebx + 2], 0x08
    mov byte [idt_start + ebx + 4], 0
    mov byte [idt_start + ebx + 5], 0x8E
    shr eax, 16
    mov [idt_start + ebx + 6], ax

    lidt [idt_descriptor]
    ret

idt_descriptor:
    dw 256 * 8 - 1
    dd idt_start

idt_start: times 256 * 8 db 0

cursor_pos dd 0
buffer_pos dd 0
command_buffer: times 80 db 0

msg_welcome: db 'Mema-OS v0.05 | System Stable', 0
msg_prompt: db '> ', 0
msg_help: db 'Commands: help, cls', 0
msg_unknown_cmd: db 'Unknown command.', 0

cmd_help: db 'help', 0
cmd_cls: db 'cls', 0
cmd_reboot: db 'reboot', 0
cmd_about: db 'about', 0
cmd_panic: db 'panic', 0

msg_reboot: db 'Rebooting...', 0
msg_about: db 'Mema-OS v0.06', 0
msg_panic: db 'Kernel panic!', 0

scancode_map:
    db 0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0x08, 0
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0x0d, 0
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '''', '`', 0
    db '\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0
    db ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
