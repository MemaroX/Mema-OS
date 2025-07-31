bits 16
org 0x7c00

start:
    mov si, msg_boot
    call print_string

    ; Load kernel from disk
    mov ah, 0x02        ; BIOS read sector function
    mov al, 1           ; Read 1 sector
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Sector 2
    mov dh, 0           ; Head 0
    mov dl, 0x00        ; Drive 0 (Floppy)
    mov bx, 0x8000      ; Load address
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

gdt_start:
    ; Null descriptor
    dq 0x0

    ; Code segment descriptor
    dw 0xFFFF    ; Limit (low)
    dw 0x0000    ; Base (low)
    db 0x00      ; Base (middle)
    db 0x9A      ; Access byte
    db 0xCF      ; Granularity
    db 0x00      ; Base (high)

    ; Data segment descriptor
    dw 0xFFFF    ; Limit (low)
    dw 0x0000    ; Base (low)
    db 0x00      ; Base (middle)
    db 0x92      ; Access byte
    db 0xCF      ; Granularity
    db 0x00      ; Base (high)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

disk_error:
    mov si, msg_disk_error
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

msg_boot: db 'Bootloader active. Loading kernel...', 0x0d, 0x0a, 0
msg_disk_error: db 'Disk read error!', 0x0d, 0x0a, 0

times 510 - ($ - $$) db 0
dw 0xaa55