.section .text
.global _start

.intel_syntax noprefix

_start:
    # execve("/bin/sh", NULL, NULL)
    mov rax, 0x0068732F6E69622F # "/bin/sh\0" in little-endian
    push rax
    mov rdi, rsp                # args[0] = pointer to "/bin/sh\0"
    xor rsi, rsi                # args[1] = NULL
    xor rdx, rdx                # args[2] = NULL
    mov rax, 59                 # syscall NR - execve:59
    syscall
