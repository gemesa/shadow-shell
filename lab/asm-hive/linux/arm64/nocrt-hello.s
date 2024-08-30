.section .text

.global _start

_start:
    mov x0, #1              // arg0 - unsigned int fd - stdout: 1
    ldr x1, =hello_world    // arg1 - const char *buf
    mov x2, #14             // arg2 - size_t count
    mov x8, #64             // syscall NR - write: 64
    svc #0
    
    mov x0, #0              // arg0 - int error_code
    mov x8, #93             // syscall NR - exit: 93
    svc #0

hello_world: 
    .ascii "Hello, World!\n"
