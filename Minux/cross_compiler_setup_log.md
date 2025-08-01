# Minux OS Development Log: Cross-Compiler Toolchain Setup

This document logs the steps taken to set up the cross-compiler toolchain (Binutils and GCC) for the Minux OS project.

## Phase 1.1: Setup the Cross-Compiler Toolchain

### Objective:
To build a cross-compiler (Binutils and GCC) targeting `x86_64-linux-gnu` to compile the Linux kernel and userspace components for Minux OS.

### Steps Taken:

1.  **Host Package Installation (WSL - Debian/Ubuntu):**
    - Verified and installed necessary host packages: `build-essential`, `bison`, `flex`, `libgmp-dev`, `libmpc-dev`, `libmpfr-dev`, `texinfo`, `wget`, `libelf-dev`, `bc`, `libssl-dev`.
    - Command used: `sudo apt install build-essential bison flex libgmp-dev libmpc-dev libmpfr-dev texinfo wget libelf-dev bc libssl-dev`

2.  **Environment Variable Configuration:**
    - Set `PREFIX` to `$HOME/opt/cross`.
    - Set `TARGET` to `x86_64-linux-gnu`.
    - Added `$PREFIX/bin` to `PATH` for persistent access to cross-compiler tools.
    - Commands used:
        ```bash
        export PREFIX="$HOME/opt/cross"
        export TARGET="x86_64-linux-gnu"
        export PATH="$PREFIX/bin:$PATH"
        echo 'export PATH="$HOME/opt/cross/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
        ```

3.  **Binutils Compilation (`binutils-2.40`):**
    - Cleaned up previous build attempts.
    - Downloaded and extracted Binutils source.
    - Configured with `--prefix=$PREFIX`, `--target=$TARGET`, and `--disable-werror`.
    - Compiled and installed Binutils.
    - Commands used:
        ```bash
        cd $HOME/opt/cross
        rm -rf build-binutils binutils-2.40
        wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.gz
        tar -xf binutils-2.40.tar.gz
        mkdir build-binutils
        cd build-binutils
        ../binutils-2.40/configure --prefix=$PREFIX --target=$TARGET --disable-werror
        make
        make install
        ```
    - **Verification:** Confirmed `x86_64-linux-gnu-as --version` (or similar) was accessible.

4.  **GCC Compilation (`gcc-13.2.0`):**
    - Cleaned up previous build attempts.
    - Downloaded and extracted GCC source.
    - Downloaded GCC prerequisites (`gmp`, `mpfr`, `mpc`).
    - Configured with `--prefix=$PREFIX`, `--target=$TARGET`, `--disable-nls`, `--enable-languages=c,c++`, `--without-headers`, and `--disable-multilib`.
    - Compiled and installed core GCC components (`all-gcc`, `all-target-libgcc`, `install-gcc`, `install-target-libgcc`).
    - Commands used:
        ```bash
        cd $HOME/opt/cross
        rm -rf build-gcc gcc-13.2.0
        wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz
        tar -xf gcc-13.2.0.tar.gz
        cd gcc-13.2.0
        ./contrib/download_prerequisites
        cd ..
        mkdir build-gcc
        cd build-gcc
        ../gcc-13.2.0/configure --prefix=$PREFIX --target=$TARGET --disable-nls --enable-languages=c,c++ --without-headers --disable-multilib
        make all-gcc
        make all-target-libgcc
        make install-gcc
        make install-target-libgcc
        ```
    - **Verification:** Confirmed `x86_64-linux-gnu-gcc --version` was accessible.

### Current Status:

The cross-compiler toolchain targeting `x86_64-linux-gnu` is now successfully built and installed. This completes Phase 1.1 of the Minux OS Development Roadmap.
