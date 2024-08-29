global _start

section .text

message:
	db "Hello", 0xa

_start:

	mov rax, 1
	mov rdi, 1
	mov rsi, message
	mov rdx, 6
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall
