.section .note.GNU-stack, "", @progbits

.global main

.text

usage:
	.asciz "Usage: %s <shellcode_file>\n"

open:
	.asciz "Opening %s ...\n"

open_failed:
	.asciz "Opening %s failed.\n"

close:
	.asciz "Closing %s ...\n"

.intel_syntax noprefix

main:
	mov r12, rdi 		# argc
	mov r13, rsi 		# argv

	cmp r12, 2
	jne args_failure

	mov rdi, offset open
	mov rsi, [r13 + 8]
	xor eax, eax
	call printf

	mov rax, 2 			# syscall NR - open: 2
	mov rdi, [r13 + 8]	# arg0 - const char *filename
	mov rsi, 0			# arg1 - int flags
	xor rdx, rdx		# arg2 - umode_t mode
	syscall

	test rax, rax
	js open_failure

	mov rdi, offset close
	mov rsi, [r13 + 8]
	xor eax, eax
	call printf

	# TODO
	# 1. fstat (get filesize)
	# 2. mmap
	# 3. read

	mov rdi, rax	# arg0 - unsigned int fd
	mov rax, 3 		# syscall NR - close: 3
	syscall

	# TODO
	# 1. mprotect
	# 2. execute shellcode
	# 3. munmap

	jmp exit_success

args_failure:
	mov rdi, offset usage
	mov rsi, [r13]
	jmp exit_failure

open_failure:
	mov rdi, offset open_failed
	mov rsi, [r13 + 8]
	jmp exit_failure

exit_failure:
	xor eax, eax
	call printf

	mov eax, 1
	ret

exit_success:
	xor eax, eax
	ret
