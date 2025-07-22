import os

BOOT_SECTOR_SIZE = 512
BOOT_BIN_PATH = 'boot.bin'
MAGIC_NUMBER = b'\x55\xAA' # 0xAA55 in little-endian

def fix_size_and_magic():
    if not os.path.exists(BOOT_BIN_PATH):
        print(f"Error: {BOOT_BIN_PATH} not found.")
        return

    with open(BOOT_BIN_PATH, 'rb') as f:
        content = f.read()

    current_size = len(content)

    if current_size < BOOT_SECTOR_SIZE:
        # Pad with zeros
        padded_content = content + b'\x00' * (BOOT_SECTOR_SIZE - current_size)
        print(f"Padded {BOOT_BIN_PATH} from {current_size} to {BOOT_SECTOR_SIZE} bytes.")
    else:
        # Truncate
        padded_content = content[:BOOT_SECTOR_SIZE]
        print(f"Truncated {BOOT_BIN_PATH} from {current_size} to {BOOT_SECTOR_SIZE} bytes.")

    # Ensure magic number is at the end
    final_content = bytearray(padded_content)
    final_content[BOOT_SECTOR_SIZE - 2:] = MAGIC_NUMBER

    with open(BOOT_BIN_PATH, 'wb') as f:
        f.write(final_content)

if __name__ == '__main__':
    fix_size_and_magic()