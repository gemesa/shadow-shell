.section .note.GNU-stack,"",@progbits

.global main

.text

main:
    mov $message, %rdi
    call puts
    xor %eax, %eax
    ret

message:
    .ascii "Hello\n"
