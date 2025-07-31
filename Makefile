# Makefile for Mema-OS

# Tools
NASM = nasm
GCC = gcc
MAKE = mingw32-make
QEMU = qemu-system-i386

# Files
BOOT_SRC = boot.asm
KERNEL_SRC = kernel.asm
BOOT_BIN = boot.bin
KERNEL_BIN = kernel.bin
OS_IMAGE = os_image.img

# Targets
.PHONY: all clean run

all: $(OS_IMAGE)

$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	python create_disk_image.py

$(BOOT_BIN): $(BOOT_SRC)
	$(NASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)

$(KERNEL_BIN): $(KERNEL_SRC)
	$(NASM) -f bin $(KERNEL_SRC) -o $(KERNEL_BIN)

clean:
	-del $(BOOT_BIN) $(KERNEL_BIN) $(OS_IMAGE)

run: $(OS_IMAGE)
	$(QEMU) -fda $(OS_IMAGE) -k en-us -serial file:qemu_log.txt
