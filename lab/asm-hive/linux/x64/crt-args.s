.section .note.GNU-stack, "", @progbits

.global main

.text

.intel_syntax noprefix

main:
	mov r12, rdi 		# argc
	mov r13, rsi 		# argv

print_args:
	test r12, r12
	jz done

	mov rdi, [r13]
	call puts

	add r13, 8
	sub r12, 1

	jmp print_args

done:
	xor  eax, eax
	ret
