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

    # Create a blank image file
    if os.path.exists(disk_img_path):
        os.remove(disk_img_path)
    with open(disk_img_path, 'wb') as f:
        f.write(b'\x00' * 512 * 100) # 100 sectors

    # Write bootloader to sector 0
    with open(boot_bin_path, 'rb') as f:
        boot_sector = f.read()
    with open(disk_img_path, 'r+b') as f:
        f.seek(0)
        f.write(boot_sector)

    # Write kernel starting at sector 1
    with open(kernel_bin_path, 'rb') as f:
        kernel = f.read()
    with open(disk_img_path, 'r+b') as f:
        f.seek(512)
        f.write(kernel)

    # Create a file table at sector 20
    with open(disk_img_path, 'r+b') as f:
        f.seek(20 * 512)
        # Entry for hello.txt
        filename = b'hello.txt'
        filename += b'\x00' * (10 - len(filename))
        f.write(filename)
        f.write(b'\x15') # Sector 21
        f.write(b'\x00' * 5) # Reserved

    # Write hello.txt content to sector 21
    with open(disk_img_path, 'r+b') as f:
        f.seek(21 * 512)
        f.write(b'Hello from a file!\x00')

    print(f"Created {disk_img_path} with a stable filesystem.")

if __name__ == '__main__':
    create_image()