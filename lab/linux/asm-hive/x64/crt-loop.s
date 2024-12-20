.section .note.GNU-stack, "", @progbits

.global main

.text

.att_syntax

message:
	.asciz "iter"

main_:
	push %rbp
	mov  %rsp, %rbp
	movl $0, -4(%rbp)
	sub  $16, %rsp

loop_start_:
	lea message(%rip), %rdi
	call puts
	cmpl $9, -4(%rbp)
	je   loop_end
	addl $1, -4(%rbp)
	jmp  loop_start

loop_end_:
	mov %rbp, %rsp
	pop %rbp
	xor %eax, %eax
	ret

.intel_syntax noprefix

main:
	push rbp
	mov  rbp, rsp
	mov  dword ptr [rbp-4], 0
	sub  rsp, 16

loop_start:
	lea rdi, [rip + message]
	call puts
	cmp  dword ptr [rbp-4], 9
	je   loop_end
	add  dword ptr [rbp-4], 1
	jmp  loop_start

loop_end:
	mov rsp, rbp
	pop rbp
	xor eax, eax
	ret
