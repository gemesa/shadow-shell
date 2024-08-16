.section .note.GNU-stack, "", @progbits

.global main

.text

usage:
	.asciz "Usage: %s <shellcode_file>\n"

open:
	.asciz "open"

.intel_syntax noprefix

main:
	push rbp
	mov rbp, rsp
	mov r12, rdi 		# argc
	mov r13, rsi 		# argv

	cmp r12, 2
	jne args_failure

	mov rax, 2 			# syscall NR - open: 2
	mov rdi, [r13 + 8]	# arg0 - const char *filename
	mov rsi, 0			# arg1 - int flags
	xor rdx, rdx		# arg2 - umode_t mode
	syscall

	push rax
	test rax, rax
	js open_failure

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
	xor rax, rax
	call printf
	jmp exit_failure

open_failure:
	call __errno_location
	mov rsi, rax
	pop rax
	neg rax
	mov [rsi], eax
	mov rdi, offset open
	call perror
	jmp exit_failure

exit_failure:
	mov rsp, rbp
	pop rbp
	mov eax, 1
	ret

exit_success:
	mov rsp, rbp
	pop rbp
	xor eax, eax
	ret
