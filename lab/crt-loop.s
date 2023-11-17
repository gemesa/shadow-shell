.section .note.GNU-stack, "", @progbits

.global main

.text

main:
	push %rbp
	mov  %rsp, %rbp
	movl $0, -4(%rbp)
	sub  $16, %rsp

loop_start:
	mov  $message, %edi
	call puts
	cmpl $9, -4(%rbp)
	je   loop_end
	addl $1, -4(%rbp)
	jmp  loop_start

loop_end:
	mov %rbp, %rsp
	pop %rbp
	xor %eax, %eax
	ret

message:
	.asciz "iter\0"
