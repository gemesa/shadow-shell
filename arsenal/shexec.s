.global main

.text

usage:
	.asciz "Usage: %s <shellcode_file>\n"

open:
	.asciz "open"

fstat:
	.asciz "fstat"

filesize_fmt:
    .asciz "file size: %ld bytes\n"

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

	test rax, rax
	js open_failure

	mov r14, rax		# fd

	sub rsp, 144		# size of fstat struct

	mov rax, 5			# syscall NR - fstat: 5
	mov rdi, r14		# arg0 - unsigned int fd
	mov rsi, rsp
	syscall

	test rax, rax
	js fstat_failure

    mov rax, [rsp + 48] # offset of st_size: 48 bytes

    mov rdi, offset filesize_fmt
    mov rsi, rax
    xor rax, rax        # clear rax before calling variadic function
    call printf

    add rsp, 144

	# TODO
	# 1. mmap
	# 2. read

	mov rdi, rax		# arg0 - unsigned int fd
	mov rax, 3 			# syscall NR - close: 3
	syscall

	# TODO
	# 1. mprotect
	# 2. execute shellcode
	# 3. munmap

	mov rsp, rbp
	pop rbp
	xor eax, eax
	ret

args_failure:
	mov rdi, offset usage
	mov rsi, [r13]
	xor rax, rax
	call printf
	jmp exit_failure

open_failure:
	push rax			# `errno` used later by `perror()`
	call __errno_location
	mov rsi, rax
	pop rax
	neg rax
	mov [rsi], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset open
	call perror
	jmp exit_failure

fstat_failure:
	push rax			# `errno` used later by `perror()`
	call __errno_location
	mov rsi, rax
	pop rax
	neg rax
	mov [rsi], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset fstat
	call perror
	jmp exit_failure

exit_failure:
	mov rsp, rbp
	pop rbp
	mov eax, 1
	ret
