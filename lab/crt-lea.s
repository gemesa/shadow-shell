.section .note.GNU-stack, "", @progbits

.global main

.text

main:
	mov $message, %edi
	call puts
	xor %eax, %eax
	ret

message:
	.ascii "TODO: implement this"
