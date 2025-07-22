
bits 16         ; Tell the assembler we're in 16-bit real mode
org 0x7c00      ; The BIOS loads us at this memory address

start:
    mov si, hello_msg   ; Put the address of our message into the SI register
    mov ah, 0x0e        ; Set the AH register to 0x0e, the BIOS teletype function

print_loop:
    lodsb               ; Load the character from [SI] into AL, and increment SI
    cmp al, 0           ; Compare the character with 0 (the null terminator)
    je load_kernel      ; If it's 0, jump to load kernel
    int 0x10            ; Otherwise, call BIOS video interrupt to print the character
    jmp print_loop      ; Repeat for the next character

load_kernel:
    ; Load Kernel from disk (in real mode)
    ; For simplicity, we'll assume the kernel is 1 sector long and starts at sector 2
    ; and load it to 0x100000 (1MB)
    mov ah, 0x02        ; BIOS read sector function
    mov al, 0x01        ; Read 1 sector
    mov ch, 0x00        ; Cylinder 0
    mov cl, 0x02        ; Sector 2 (Kernel starts after boot sector)
    mov dh, 0x00        ; Head 0
    mov dl, 0x00        ; Drive 0 (floppy)
    mov bx, 0x1000      ; Load to address 0x1000:0x0000 (1MB)
    mov es, bx
    mov bx, 0x0000
    int 0x13            ; Call BIOS disk interrupt

    jc disk_error       ; If carry flag is set, there was a disk error

    ; --- Enable A20 Line ---
    ; This is a common way to enable A20 using BIOS interrupt 0x15
    mov ax, 0x2401
    int 0x15
    jc a20_error

    ; --- Setup GDT ---
    lgdt [gdt_descriptor]

    ; --- Switch to Protected Mode ---
    cli                 ; Disable interrupts
    mov eax, cr0
    or eax, 0x1         ; Set PE (Protected Enable) bit
    mov cr0, eax

    ; --- Far Jump to Protected Mode Code ---
    jmp dword 0x08:protected_mode_start

a20_error:
    mov si, a20_error_msg
    mov ah, 0x0e
print_a20_error_loop:
    lodsb
    cmp al, 0
    je hang_error
    int 0x10
    jmp print_a20_error_loop

disk_error:
    mov si, disk_error_msg
    mov ah, 0x0e
print_disk_error_loop:
    lodsb
    cmp al, 0
    je hang_error
    int 0x10
    jmp print_disk_error_loop

hang_error:
    jmp hang_error

; --- GDT Definition ---
gdt_start:
null_descriptor:
    dq 0

; Code Segment Descriptor
code_descriptor:
    dw 0xFFFF           ; Limit (low)
    dw 0x0000           ; Base (low)
    db 0x00             ; Base (middle)
    db 10011010b        ; Access byte (Present, Ring 0, Code, Executable, Read/Write)
    db 11001111b        ; Flags (4KB granularity, 32-bit) & Limit (high)
    db 0x00             ; Base (high)

; Data Segment Descriptor
data_descriptor:
    dw 0xFFFF           ; Limit (low)
    dw 0x0000           ; Base (low)
    db 0x00             ; Base (middle)
    db 10010010b        ; Access byte (Present, Ring 0, Data, Read/Write)
    db 11001111b        ; Flags (4KB granularity, 32-bit) & Limit (high)
    db 0x00             ; Base (high)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Limit
    dd gdt_start               ; Base Address

; --- Protected Mode Entry Point ---
bits 32
protected_mode_start:
    ; Reload segment registers with protected mode selectors
    mov ax, 0x10        ; Data segment selector (offset 0x10 in GDT)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000    ; Setup a stack (arbitrary address for now)

    ; Jump to Kernel
    jmp 0x08:0x100000   ; Jump to code segment (0x08) at 1MB

hello_msg:
    db 'Bootloader: Loading Kernel...', 0x0d, 0x0a, 0
a20_error_msg:
    db 'A20 Error!', 0
disk_error_msg:
    db 'Disk Error!', 0
