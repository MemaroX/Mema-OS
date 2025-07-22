import os

BOOT_SECTOR_SIZE = 512

def create_image():
    boot_bin_path = 'boot.bin'
    kernel_bin_path = 'kernel.bin'
    disk_img_path = 'os_image.img'

    if not os.path.exists(boot_bin_path):
        print(f"Error: {boot_bin_path} not found.")
        return
    if not os.path.exists(kernel_bin_path):
        print(f"Error: {kernel_bin_path} not found.")
        return

    with open(boot_bin_path, 'rb') as f:
        boot_sector = f.read()

    with open(kernel_bin_path, 'rb') as f:
        kernel_sector = f.read()

    # Ensure boot sector is 512 bytes
    if len(boot_sector) < BOOT_SECTOR_SIZE:
        boot_sector += b'\x00' * (BOOT_SECTOR_SIZE - len(boot_sector))
    elif len(boot_sector) > BOOT_SECTOR_SIZE:
        boot_sector = boot_sector[:BOOT_SECTOR_SIZE]

    # Add magic number to boot sector
    boot_sector = bytearray(boot_sector)
    boot_sector[BOOT_SECTOR_SIZE - 2:] = b'\x55\xAA'

    with open(disk_img_path, 'wb') as f:
        f.write(boot_sector)
        f.write(kernel_sector)

    print(f"Created {disk_img_path} with boot sector ({len(boot_sector)} bytes) and kernel ({len(kernel_sector)} bytes).")

if __name__ == '__main__':
    create_image()