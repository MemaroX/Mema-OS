# Menari OS

A simple hobby operating system project, built from scratch to understand the fundamentals of OS development.

## Features

*   **Bootloader:** Basic boot sequence to load the kernel.
*   **Kernel:** A minimal kernel demonstrating basic execution.
*   **Modular Design:** Separated bootloader, stage2, and kernel components.

## Project Structure

*   `boot.asm`: The initial bootloader, responsible for loading `stage2.bin`.
*   `stage2.asm`: The second-stage bootloader, responsible for loading `kernel.bin`.
*   `kernel.asm`: The core kernel code.
*   `boot.bin`: Compiled binary of `boot.asm`.
*   `stage2.bin`: Compiled binary of `stage2.asm`.
*   `kernel.bin`: Compiled binary of `kernel.bin`.
*   `create_disk_image.py`: Python script to combine the bootloader, stage2, and kernel into a single disk image (`os_image.img`).
*   `fix_boot_sector_size.py`: Python script to ensure the boot sector is exactly 512 bytes (crucial for bootloaders).
*   `os_image.img`: The final bootable disk image.
*   `.gitignore`: Specifies files and directories to be ignored by Git.
*   `README.md`: This documentation file.

## Building the OS

To build Menari OS, you will need:

*   **NASM (Netwide Assembler):** For assembling the `.asm` files into `.bin` binaries.
*   **Python 3:** For running the utility scripts.

Follow these steps:

1.  **Assemble the Bootloader:**
    ```bash
    nasm -f bin boot.asm -o boot.bin
    ```

2.  **Assemble Stage 2 Bootloader:**
    ```bash
    nasm -f bin stage2.asm -o stage2.bin
    ```

3.  **Assemble the Kernel:**
    ```bash
    nasm -f bin kernel.asm -o kernel.bin
    ```

4.  **Fix Boot Sector Size (if necessary):**
    Ensure `boot.bin` is exactly 512 bytes. This script will pad it with zeros if needed.
    ```bash
    python fix_boot_sector_size.py
    ```

5.  **Create the Disk Image:**
    This script combines `boot.bin`, `stage2.bin`, and `kernel.bin` into `os_image.img`.
    ```bash
    python create_disk_image.py
    ```

## Running the OS

You can run the generated `os_image.img` using a virtual machine emulator like QEMU.

```bash
qemu-system-i386 os_image.img
```

This command will launch QEMU and attempt to boot from `os_image.img`.

## Contributing

Contributions are welcome! If you'd like to contribute, please fork the repository and submit a pull request.

## License

[Specify your license here, e.g., MIT License]