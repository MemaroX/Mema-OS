bits 16
org 0x7c00

start:
    mov si, msg_boot
    call print_string_16

    ; Critical: Disable PICs before switching mode
    mov al, 0xff
    out 0xa1, al
    out 0x21, al

    ; Reset disk system
    mov ah, 0x00
    mov dl, 0x00
    int 0x13

    ; Load kernel from disk
    mov ah, 0x02
    mov al, 8 ; Read 8 sectors to be safe
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x00
    mov bx, 0x8000
    int 0x13
    jc disk_error

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Switch to protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Far jump to kernel
    jmp 0x08:0x8000

disk_error:
    mov si, msg_disk_error
    call print_string_16
    jmp $

print_string_16:
    mov ah, 0x0e
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00
gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xCF
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

msg_boot: db 'Bootloader active...', 0x0d, 0x0a, 0
msg_disk_error: db 'Disk read error!', 0x0d, 0x0a, 0

times 510 - ($ - $$) db 0
dw 0xaa55
