.section .note.GNU-stack, "", @progbits

.global main

.text

.att_syntax

format:
	.asciz "%d:%d\n"

array:
	.long 11, 22, 33, 44

main_:
	push %rbp
	mov  %rsp, %rbp
	sub  $16, %rsp
	movl $0, -4(%rbp) # index

loop_:
	lea  format(%rip), %rdi
	movl -4(%rbp), %esi
	lea array(%rip), %rdx      # get array base address relative to RIP
	lea (%rdx,%rsi,4), %rdx    # then do the indexed addressing
	mov  (%rdx), %rdx
	xor  %eax, %eax   # we dont pass any parameters in a vector register --> set %al to 0
	call printf
	cmpl $3, -4(%rbp) # array length is 4
	je   end
	addl $1, -4(%rbp)
	jmp  loop

end_:
	mov %rbp, %rsp
	pop %rbp
	xor %eax, %eax
	ret

.intel_syntax noprefix

main:
	push rbp
	mov  rbp, rsp
	sub  rsp, 16
	mov  dword ptr [rbp-4], 0

loop:
	lea  rdi, [rip+format]
	mov  esi, dword ptr [rbp-4]
	lea rdx, [rip + array]     # get array base address
	lea rdx, [rdx + rsi*4]     # tyhen do the indexed addressing
	mov  rdx, [rdx]
	xor  eax, eax
	call printf
	cmp  dword ptr [rbp-4], 3
	je   end
	add  dword ptr [rbp-4], 1
	jmp  loop

end:
	mov rsp, rbp
	pop rbp
	xor eax, eax
	ret
