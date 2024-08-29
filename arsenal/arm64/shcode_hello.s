.section .text

.global _start

_start:
    mov  x1, #0x6548            // "eH"
    movk x1, #0x6c6c, lsl #16   // "lleH"
    movk x1, #0x216f, lsl #32   // "!olleH"
    movk x1, #0x000a, lsl #48   // "\n!olleH"
    str  x1, [sp, #-8]!

    mov  x0, #1                 // arg0 - unsigned int fd - stdout: 1
    mov  x1, sp                 // arg1 - const char *buf
    mov  x2, #7                 // arg2 - size_t count
    mov  x8, #64                // syscall NR - write: 64
    svc  #0
    
    mov  x0, #0                 // arg0 - int error_code
    mov  x8, #93                // syscall NR - exit: 93
    svc  #0
