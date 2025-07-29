# Menari OS: A Hobby Operating System from Scratch

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`Menari OS` is a personal hobby operating system project, meticulously built from the ground up. This endeavor serves as a deep dive into the fundamental concepts of operating system development, pushing the boundaries of a graduation student's capabilities and understanding of low-level system architecture.

## Overview

This project is a journey into the heart of how computers work, starting from the very first instructions executed by the CPU. It aims to demystify the complexities of OS development by implementing core components like the bootloader and a minimal kernel. The process involved significant learning and problem-solving, transforming theoretical knowledge into practical, executable code.

## Features

-   **Bootloader:** A multi-stage boot sequence responsible for initializing the system and loading the kernel.
-   **Minimal Kernel:** A basic kernel demonstrating essential functionalities.
-   **Modular Design:** Components are separated into distinct modules (bootloader, stage2, kernel) for clarity and maintainability.
-   **Assembly Language Core:** Direct interaction with hardware through assembly programming.
-   **C Language Integration:** (In `0.2V` version) Exploration of C language for higher-level kernel development.

## Project Structure

```
Mema-OS/
├── boot.asm                # The initial 16-bit bootloader (Master Boot Record - MBR).
├── stage2.asm              # The second-stage bootloader, loaded by boot.asm.
├── kernel.asm              # The core kernel code (assembly version).
├── kernel.c                # A C language version of the kernel (used in 0.2V and for experimentation).
├── boot.bin                # Compiled binary of boot.asm.
├── stage2.bin              # Compiled binary of stage2.asm.
├── kernel.bin              # Compiled binary of kernel.asm.
├── create_disk_image.py    # Python script to combine bootloader, stage2, and kernel into a single disk image.
├── fix_boot_sector_size.py # Python script to ensure the boot sector is exactly 512 bytes.
├── os_image.img            # The final bootable disk image.
├── 0.2V/                   # Contains an alternative version or experimental build (e.g., using kernel.c).
│   ├── boot.asm
│   ├── boot.bin
│   └── kernel.c
├── .gitignore              # Specifies files and directories to be ignored by Git.
├── README.md               # This documentation file.
└── LICENSE                 # Project license.
```

## Technologies Used

-   **Assembly Language (NASM):** For low-level bootloader and kernel development, enabling direct hardware control.
-   **C Language:** For higher-level kernel functionalities and system programming (especially in the `0.2V` version).
-   **Python 3:** For utility scripts (image creation, boot sector fixing).
-   **QEMU:** A generic and open-source machine emulator and virtualizer, used for testing the OS image.

## Building the OS

To build Menari OS, you will need:

-   **NASM (Netwide Assembler):** For assembling the `.asm` files into `.bin` binaries.
-   **Python 3:** For running the utility scripts.

Follow these steps:

1.  **Assemble the Bootloader:**
    ```bash
    nasm -f bin boot.asm -o boot.bin
    ```

2.  **Assemble Stage 2 Bootloader:**
    ```bash
    nasm -f bin stage2.asm -o stage2.bin
    ```

3.  **Assemble the Kernel (Assembly Version):**
    ```bash
    nasm -f bin kernel.asm -o kernel.bin
    ```

4.  **Fix Boot Sector Size:**
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

## Challenges & Learnings

Developing an operating system from scratch presents numerous challenges, including:

-   **Low-Level Programming:** Direct interaction with CPU registers, memory addresses, and hardware interfaces.
-   **Boot Process Understanding:** Grasping the intricate steps from BIOS POST to kernel execution.
-   **Memory Management:** Handling memory segmentation and protection.
-   **Debugging:** Debugging at the assembly level without typical high-level tools.
-   **Toolchain Setup:** Configuring assemblers, compilers, and emulators.

This project provided invaluable insights into:

-   The fundamental architecture of computer systems.
-   The role of the operating system in managing hardware and software resources.
-   The complexities of low-level programming and system design.

## Contributing

Contributions are welcome! If you have suggestions for improvements, bug fixes, or new features, please feel free to:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/YourFeatureName`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Feat: Add YourFeature'`).
5.  Push to the branch (`git push origin feature/YourFeatureName`).
6.  Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

MemaroX - [Your GitHub Profile Link](https://github.com/MemaroX)