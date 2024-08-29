.section .text
.global _start

.intel_syntax noprefix

_start:
    mov rax, 1                   # syscall NR - write: 1
    mov rdi, 1                   # arg0 - unsigned int fd - stdout: 1
    lea rsi, [rip + message]     # arg1 - const char *buf
    mov rdx, 15                  # arg2 - size_t count
    syscall

    mov rax, 60                  # syscall NR - exit: 60
    xor rdi, rdi                 # arg0 - int error_code
    syscall

message: .asciz "Hello, World!\n"
