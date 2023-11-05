.section .note.GNU-stack, "", @progbits

.global main

.text

main:
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

min:
	push %rbp
	mov  %rsp, %rbp
	cmp  %esi, %edi # edi-esi = 1-2, eflags = [ CF PF AF SF IF ], if edi-esi = 2-1 --> eflags = [ IF ], if edi-esi = 1-1 --> eflags = [ PF ZF IF ]
	jb   below
	mov  %esi, %eax

below:
	mov %edi, %eax

	mov %rbp, %rsp
	pop %rbp
	ret

format_string:
	.ascii "%d\n"
