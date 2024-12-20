.section .note.GNU-stack, "", @progbits

.global main

.text

.att_syntax

message:
	.asciz "Hello\n"

main_:
	lea message(%rip), %rdi  # arg0 - const char *string
	call puts
	xor  %eax, %eax      # set return value to 0
	ret

.intel_syntax noprefix

main:
	lea rdi, [rip + message]
	call puts
	xor  eax, eax
	ret
