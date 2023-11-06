.section .note.GNU-stack, "", @progbits

.global main

.text

main:
	push %rbp
	mov  %rsp, %rbp
	sub  $16, %rsp
	movl $0, -4(%rbp) # index

loop:
	mov  $format, %rdi
	movl -4(%rbp), %esi
	lea  array(, %rsi, 4), %rdx
	mov  (%rdx), %rdx
	call printf
	cmpl $3, -4(%rbp) # array length is 4
	je   end
	addl $1, -4(%rbp)
	jmp  loop

end:
	mov %rbp, %rsp
	pop %rbp
	xor %eax, %eax
	ret

format:
	.ascii "%d:%d\n"

array:
	.long 11, 22, 33, 44
