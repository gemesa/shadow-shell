.section .note.GNU-stack, "", @progbits

.global main

.text

.att_syntax

format_string:
	.asciz "%d\n"

sum_:
	push %rbp
	mov  %rsp, %rbp
	mov  %edi, -20(%rbp)
	mov  %esi, -24(%rbp)
	mov  -20(%rbp), %eax
	mov  -24(%rbp), %edx
	add  %edx, %eax
	pop  %rbp
	ret

mul_:
	push %rbp
	mov  %rsp, %rbp
	mov  %edi, -20(%rbp)
	mov  %esi, -24(%rbp)
	mov  -20(%rbp), %eax
	mov  -24(%rbp), %edx
	imul %edx, %eax
	pop  %rbp
	ret

calc_:
	push %rbp
	mov  %rsp, %rbp
	push %rbx               # preserved register
	sub  $24, %rsp          # rsp needs to be 32 byte aligned (-8-24=-32)
	mov  %edi, -32(%rbp)
	mov  %esi, -28(%rbp)
	mov  -32(%rbp), %eax
	mov  -28(%rbp), %edx
	mov  %eax, %edi
	mov  %edx, %esi
	call sum
	mov  %eax, %ebx
	mov  -32(%rbp), %eax
	mov  -28(%rbp), %edx
	mov  %eax, %edi
	mov  %edx, %esi
	call mul
	add  %ebx, %eax
	mov  -8(%rbp), %rbx     # preserved register
	mov  %rbp, %rsp
	pop  %rbp
	ret

main_:
	push %rbp
	mov  $10, %edi
	mov  $11, %esi
	call sum
	lea  format_string(%rip), %rdi
	mov  %eax, %esi
	call printf
	mov  $10, %edi
	mov  $11, %esi
	call mul
	lea  format_string(%rip), %rdi
	mov  %eax, %esi
	call printf
	xor  %eax, %eax
	mov  $10, %edi
	mov  $11, %esi
	call calc
	lea  format_string(%rip), %rdi
	mov  %eax, %esi
	call printf
	pop  %rbp
	ret

.intel_syntax noprefix

sum:
	push rbp
	mov  rbp, rsp
	mov  [rbp-20], edi
	mov  [rbp-24], esi
	mov  eax, [rbp-20]
	mov  edx, [rbp-24]
	add  eax, edx
	pop  rbp
	ret

mul:
	push rbp
	mov  rbp, rsp
	mov  [rbp-20], edi
	mov  [rbp-24], esi
	mov  eax, [rbp-20]
	mov  edx, [rbp-24]
	imul eax, edx
	pop  rbp
	ret

calc:
	push rbp
	mov  rbp, rsp
	push rbx
	sub  rsp, 24
	mov  [rbp-32], edi
	mov  [rbp-28], esi
	mov  eax, [rbp-32]
	mov  edx, [rbp-28]
	mov  edi, eax
	mov  esi, edx
	call sum
	mov  ebx, eax
	mov  eax, [rbp-32]
	mov  edx, [rbp-28]
	mov  edi, eax
	mov  esi, edx
	call mul
	add  eax, ebx
	mov  rbx, [rbp-8]
	mov  rsp, rbp
	pop  rbp
	ret

main:
	push rbp
	mov  edi, 10
	mov  esi, 11
	call sum
	lea  rdi, [rip + format_string]
	mov  esi, eax
	call printf
	mov  edi, 10
	mov  esi, 11
	call mul
	lea  rdi, [rip + format_string]
	mov  esi, eax
	call printf
	xor  eax, eax
	mov  edi, 10
	mov  esi, 11
	call calc
	lea  rdi, [rip + format_string]
	mov  esi, eax
	call printf
	pop  rbp
	ret
