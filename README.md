# Introduction

shadow-shell is a cyber lab designed for:

- learning AMD64 and ARM64 assembly
- analyzing shellcode
- exploring memory exploits
- supporting malware analysis

The repository contains two main parts:

- **arsenal**: command line tools to support malware analysis
- **lab**: experimental code snippets, some are documented while others are not

# How to build

## x64 codebase

```
$ make
```

## ARM64 codebase

I have an x64 PC so to build and run ARM64 binaries I use an ARM64v8 Docker container. (An alternative solution could be using an ARM64 cross-compiler and QEMU.)

```
$ sudo docker build -t my-arm64-dev-env .
$ sudo docker run --rm -it -v "$(pwd)":/workspace my-arm64-dev-env /bin/bash
# make arm
```

# Repository structure

```
arsenal/
├── linux/
│   ├── arm64/
│   │   ├── shexec.s: Linux ARM64 shellcode executor (mostly I combine it with `strace` to get a quick high-level understanding of the shellcode behavior via the syscalls)
│   │   ├── shcode_hello.s: Linux ARM64 shellcode which prints "Hello!"
│   │   └── shcode_shell.s: Linux ARM64 shellcode which opens a shell
│   │       example usage:
│   │       ```
│   │       # sudo docker build -t my-arm64-dev-env .
│   │       $ sudo docker run --rm -it -v "$(pwd)":/workspace my-arm64-dev-env /bin/bash
│   │       # make arm
│   │       # ./build/linux/arm64/shexec build/linux/arm64/shcode_hello.bin 
│   │       Hello!
│   │       # ./build/linux/arm64/shexec build/linux/arm64/shcode_shell.bin
│   │       # id
│   │       uid=0(root) gid=0(root) groups=0(root)
│   │       # exit
│   │       ```
│   ├── x64/
│   │   ├── shexec.s: Linux x64 shellcode executor
│   │   └── shcode_hello.s: Linux x64 shellcode which prints "Hello, World!"
│   │       example usage:
│   │       ```
│   │       $ make
│   │       $ msfvenom -p linux/x64/exec CMD='echo \"Hello, World!\"' -f raw -o shellcode.bin
│   │       $ ./build/linux/x64/shexec shellcode.bin                     
│   │       file size: 57 bytes
│   │       Hello, World!
│   │       $ ./build/linux/x64/shexec build/linux/x64/shcode_hello.bin
│   │       file size: 57 bytes
│   │       Hello, World!
│   │       ```
│   └── shexec.c: Linux shellcode executor used as reference while implementing shexec.s for different architectures
│       example usage:
│       ```
│       $ gcc -S arsenal/linux/shexec.c -o arsenal/linux/shexec_gcc.s
│        ```
└── windows/
    └── shexec.c: Windows shellcode executor used as reference while implementing shexec.s for different architectures
        example usage:
        ```
        $ x86_64-w64-mingw32-gcc -S arsenal/windows/shexec.c -o arsenal/windows/shexec_gcc.s
        ```
        ```
        $ make
        $ msfvenom -p windows/x64/messagebox -b \x00 -f raw -o win_shcode.bin
        $ wine build/windows/shexec.exe win_shcode.bin
        ```

```

# Prerequisites

```
$ sudo dnf install mingw64-gcc
$ sudo dnf install winetricks
$ rustup target add x86_64-pc-windows-gnu
$ sudo dnf install nasm
$ pip install frida-tools
$ sudo dnf install docker
$ sudo systemctl start docker
$ sudo systemctl enable docker

```

# My blog posts
- https://gemesa.dev/diving-into-shellcodes
- https://gemesa.dev/shattering-the-stack-0
- https://gemesa.dev/shattering-the-stack-1
- https://gemesa.dev/shattering-the-stack-2

# References

- https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md
- https://wiki.osdev.org/Calling_Conventions
- https://en.wikipedia.org/wiki/X86_calling_conventions
- https://www.felixcloutier.com/x86/
- https://www.ibm.com/docs/en/aix/7.1?topic=volumes-using-file-descriptors
- https://www.ibm.com/docs/en/i/7.5?topic=extensions-standard-c-library-functions-table-by-name
- https://cs.lmu.edu/~ray/notes/gasexamples/
- https://web.stanford.edu/class/cs107/guide/x86-64.html
- http://unixwiz.net/techtips/x86-jumps.html
- https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
- https://stackoverflow.com/questions/38335212/calling-printf-in-x86-64-using-gnu-assembler
- https://github.com/reg1reg1/Shellcode
- https://godbolt.org/
- https://dogbolt.org/
- https://nitesculucian.github.io/2018/07/24/msfvenom-cheat-sheet/
- https://ivanitlearning.wordpress.com/2018/10/14/shellcoding-with-msfvenom/
- https://security.stackexchange.com/questions/176495/executing-a-msfvenom-shellcode-in-c-program
- http://0xdabbad00.com/2012/12/07/dep-data-execution-prevention-explanation/
- https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc
- https://crates.io/crates/windows
- https://github.com/microsoft/windows-rs
- https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/System/Memory/fn.VirtualAlloc.html
- https://stackoverflow.com/questions/31492799/cross-compile-a-rust-application-from-linux-to-windows
- https://doc.rust-lang.org/core/ptr/fn.copy_nonoverlapping.html
- https://github.com/muhammet-mucahit/Security-Exercises
- https://lettieri.iet.unipi.it/hacking/aslr-pie.pdf
- https://reverseengineering.stackexchange.com/questions/19598/find-base-address-and-memory-size-of-program-debugged-in-gdb
- https://syscall.sh/
- https://developer.arm.com/documentation
- https://gist.github.com/luk6xff/9f8d2520530a823944355e59343eadc1
- https://www.exploit-db.com/exploits/47048
