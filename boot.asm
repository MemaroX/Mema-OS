[bits 16]           ; 16-bit real mode
[org 0x7c00]       ; Boot sector origin
mov ah, 0x0e       ; BIOS teletype function
mov al, 'H'        ; Character to print
int 0x10           ; BIOS interrupt
jmp $              ; Infinite loop
times 510-($-$$) db 0  ; Pad with zeros
dw 0xAA55          ; Boot signature