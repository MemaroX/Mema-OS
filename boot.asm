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

    ; Jump to kernel
    jmp 0x8000

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