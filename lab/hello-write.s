.global _start

.data
message:
    .ascii "Hello\n"

.text

_start:

    mov $1, %rax
    mov $1, %rdi
    mov $message, %rsi
    mov $6, %rdx
    syscall

    mov $60, %rax
    xor %rdi, %rdi
    syscall
