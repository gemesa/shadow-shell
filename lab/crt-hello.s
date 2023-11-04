.section .note.GNU-stack,"",@progbits

.global main

.text

main:
    mov $message, %rdi  ; arg0 - const char *string
    call puts
    xor %eax, %eax      ; set return value to 0
    ret

message:
    .ascii "Hello\n"
