.global main

.text

usage:
    .string "Usage: %s <shellcode_file>\n"

open_msg:
    .string "open"

fstat_msg:
    .string "fstat"

mmap_msg:
    .string "mmap"

read_msg:
    .string "read"

mprotect_msg:
    .string "mprotect"

filesize_fmt:
    .string "file size: %ld bytes\n"

.align 2
main:
    stp fp, lr, [sp, #-16]!

    cmp x0, #2                  // argc
    b.ne args_failure

    ldr x0, [x1, #8]            // arg0 - const char *filename: argv[1]
    mov x1, xzr                 // arg1 - int flags
    bl open

    cmp w0, #-1
    b.eq open_failure

    mov x20, x0                 // fd
    
    sub sp, sp, #128            // size of fstat struct
    mov x0, x20                 // arg0 - int fd
    mov x1, sp                  // arg1 - struct stat *buf
    bl fstat

    cmp w0, #-1
    b.eq fstat_failure

    adr x0, filesize_fmt
    ldr x1, [sp, #48]           // offset of st_size: 48 bytes
    bl printf

    mov x0, xzr                 // arg0 - void* addr
    ldr x1, [sp, #48]           // arg1 - size_t len
    // https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
    // #define PROT_READ     0x1
    // #define PROT_WRITE    0x2
    mov x2, #0x3                // arg2 - int prot
    // https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
    // #define MAP_ANONYMOUS  0x20
    // https://github.com/torvalds/linux/blob/master/include/uapi/linux/mman.h
    // #define MAP_PRIVATE    0x02
    mov x3, #0x22               // arg3 - int flags
    mov x4, #-1                 // arg4 - int fd
    mov x5, xzr                 // arg5 - off_t offset
    bl mmap

    cmp w0, #-1
    b.eq mmap_failure

    mov x21, x0                 // mmap addr

    mov x0, x20                 // arg0 - int fd
    mov x1, x21                 // arg1 - char *buf
    ldr x2, [sp, #48]           // arg2 - size_t nbytes
    bl read

    ldr x1, [sp, #48]
    cmp w0, w1
    b.ne read_failure

    mov x0, x20                 // arg0 - int fd
    bl close

    mov x0, x21                 // arg0 - void* addr
    ldr x1, [sp, #48]           // arg1 - size_t len
    // https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
    // #define PROT_READ     0x1
    // #define PROT_WRITE    0x2
    // #define PROT_EXEC     0x4    
    mov x2, #0x7                // arg2 - int prot
    bl mprotect

    cmp w0, #-1
    b.eq mprotect_failure

    mov x0, x21
    blr x0

    // TODO
    // munmap

    b exit_success

exit_success:
    ldp fp, lr, [sp], #16

    mov  x0, #0                 // arg0 - int error_code
    mov  x8, #93                // syscall NR - exit: 93
    svc  #0

args_failure:
    adr x0, usage
    ldr x1, [x1, #0]            // argv[0]
    bl printf
    b exit_failure

open_failure:
    adr x0, open_msg
    bl perror
    b exit_failure

fstat_failure:
    adr x0, fstat_msg
    bl perror
    b exit_failure

mmap_failure:
    adr x0, mmap_msg
    bl perror
    b exit_failure

read_failure:
    adr x0, read_msg
    bl perror
    b exit_failure

mprotect_failure:
    adr x0, mprotect_msg
    bl perror
    b exit_failure

exit_failure:
    ldp fp, lr, [sp], #16

    mov  x0, #1                 // arg0 - int error_code
    mov  x8, #93                // syscall NR - exit: 93
    svc  #0
