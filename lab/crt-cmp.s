.section .note.GNU-stack, "", @progbits

.global main

.text

.att_syntax

format_string:
	.asciz "%d\n"

main_:
	push %rbp
	mov  $1, %edi
	mov  $2, %esi
	call min
	mov  $format_string, %edi
	mov  %eax, %esi
	call printf
	xor  %eax, %eax
	pop  %rbp
	ret

min_:
	push %rbp
	mov  %rsp, %rbp
	cmp  %esi, %edi # edi-esi = 1-2, eflags = [ CF PF AF SF IF ], if edi-esi = 2-1 --> eflags = [ IF ], if edi-esi = 1-1 --> eflags = [ PF ZF IF ]
	jb   below
	mov  %esi, %eax

below_:
	mov %edi, %eax

	mov %rbp, %rsp
	pop %rbp
	ret

.intel_syntax noprefix

main:
	push rbp
	mov  edi, 1
	mov  esi, 2
	call min
	mov  edi, offset format_string
	mov  esi, eax
	call printf
	xor  eax, eax
	pop  rbp
	ret

min:
	push rbp
	mov  rbp, rsp
	cmp  edi, esi
	jb   below
	mov  eax, esi

below:
	mov eax, edi

	mov rsp, rbp
	pop rbp
	ret
