.section .note.GNU-stack, "", @progbits

.global main

.text

sum:
	push %rbp
	mov  %rsp, %rbp
	mov  %edi, -20(%rbp)
	mov  %esi, -24(%rbp)
	mov  -20(%rbp), %eax
	mov  -24(%rbp), %edx
	add  %edx, %eax
	pop  %rbp
	ret

mul:
	push %rbp
	mov  %rsp, %rbp
	mov  %edi, -20(%rbp)
	mov  %esi, -24(%rbp)
	mov  -20(%rbp), %eax
	mov  -24(%rbp), %edx
	imul %edx, %eax
	pop  %rbp
	ret

calc:
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

main:
	push %rbp
	mov  $10, %edi
	mov  $11, %esi
	call sum
	mov  $format_string, %edi
	mov  %eax, %esi
	call printf
	mov  $10, %edi
	mov  $11, %esi
	call mul
	mov  $format_string, %edi
	mov  %eax, %esi
	call printf
	xor  %eax, %eax
	mov  $10, %edi
	mov  $11, %esi
	call calc
	mov  $format_string, %edi
	mov  %eax, %esi
	call printf
	pop  %rbp
	ret

format_string:
	.asciz "%d\n"
