.global main

.text

usage:
	.asciz "Usage: %s <shellcode_file>\n"

open:
	.asciz "open"

fstat:
	.asciz "fstat"

mmap:
	.asciz "mmap"

read:
	.asciz "read"

mprotect:
	.asciz "mprotect"

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

	call __errno_location
	mov r15, rax		# address of errno

	mov rax, 2 			# syscall NR - open: 2
	mov rdi, [r13 + 8]	# arg0 - const char *filename
	mov rsi, 0			# arg1 - int flags
	xor rdx, rdx		# arg2 - umode_t mode
	syscall

	test rax, rax
	js open_failure

	mov r14, rax		# fd

	sub rsp, 144		# size of stat struct, refer to struct stat in /usr/include/bits/struct_stat.h

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

	mov rax, 9			# syscall NR - mmap: 9
	xor rdi, rdi		# arg0 - void* addr
	mov rsi, [rsp + 48]	# arg1 - size_t len
	# https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
	# #define PROT_READ		0x1
	# #define PROT_WRITE	0x2
	mov rdx, 0x1		# arg2 - int prot
	or rdx, 0x2
	# or rdx, 0x4
	# https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
	# #define MAP_ANONYMOUS	0x20
	# https://github.com/torvalds/linux/blob/master/include/uapi/linux/mman.h
	# #define MAP_PRIVATE	0x02
	mov rcx, 0x20
	or rcx, 0x2
	mov r8, -1			# arg3 - int fd
	xor r9, r9			# arg4 - off_t offset
	syscall

	test rax, rax
	js mmap_failure

	mov r12, rax		# mmap addr
	mov rax, 0			# syscall NR - read: 0
	mov rdi, r14		# arg0 - unsigned int fd
	mov rsi, r12		# arg1 - char *buf
	mov rdx, [rsp + 48]	# arg2 - size_t count
	syscall

	test rax, rax
	js read_failure

	mov rdi, r14		# arg0 - unsigned int fd
	mov rax, 3 			# syscall NR - close: 3
	syscall

	mov rax, 10			# syscall NR - mprotect: 10
	mov rdi, r12		# arg0 - unsigned long start
	mov rsi, [rsp + 48]	# arg1 - size_t len
	# https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
	# #define PROT_READ		0x1
	# #define PROT_WRITE	0x2
	# #define PROT_EXEC		0x4	
	mov rdx, 0x1		# arg2 - unsigned long prot
	or rdx, 0x2
	or rdx, 0x4
	syscall

	test rax, rax
	js mprotect_failure

	mov rax, r12
	call rax

	# TODO
	# munmap

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
	neg rax
	mov [r15], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset open
	call perror
	jmp exit_failure

fstat_failure:
	neg rax
	mov [r15], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset fstat
	call perror
	jmp exit_failure

mmap_failure:
	neg rax
	mov [r15], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset mmap
	call perror
	jmp exit_failure

read_failure:
	neg rax
	mov [r15], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset read
	call perror
	jmp exit_failure

mprotect_failure:
	neg rax
	mov [r15], eax		# `errno` is a 32 bit int: https://man7.org/linux/man-pages/man3/errno.3.html
	mov rdi, offset mprotect
	call perror
	jmp exit_failure

exit_failure:
	mov rsp, rbp
	pop rbp
	mov eax, 1
	ret
