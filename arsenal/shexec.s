.global main

.text

usage:
	.asciz "Usage: %s <shellcode_file>\n"

open_msg:
	.asciz "open"

fstat_msg:
	.asciz "fstat"

mmap_msg:
	.asciz "mmap"

read_msg:
	.asciz "read"

mprotect_msg:
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

	xor rax, rax        # clear rax before calling variadic function
	mov rdi, [r13 + 8]	# arg0 - const char *filename
	mov rsi, 0			# arg1 - int flags
	call open

	cmp eax, -1
	je open_failure

	mov r14, rax		# fd

	sub rsp, 144		# size of stat struct, refer to struct stat in /usr/include/bits/struct_stat.h

	mov rdi, r14		# arg0 - int fd
	mov rsi, rsp		# agr1 - struct stat *buf
	call fstat

	test rax, rax
	js fstat_failure

    mov rax, [rsp + 48] # offset of st_size: 48 bytes

    mov rdi, offset filesize_fmt
    mov rsi, rax
    xor rax, rax        # clear rax before calling variadic function
    call printf

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
	call mmap

	test rax, rax
	js mmap_failure

	mov r12, rax		# mmap addr
	mov rdi, r14		# arg0 - int fd
	mov rsi, r12		# arg1 - char *buf
	mov rdx, [rsp + 48]	# arg2 - size_t nbytes
	call read

	test rax, rax
	js read_failure

	mov rdi, r14		# arg0 - int fd
	call close

	mov rdi, r12		# arg0 - void* addr
	mov rsi, [rsp + 48]	# arg1 - size_t len
	# https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/mman-common.h
	# #define PROT_READ		0x1
	# #define PROT_WRITE	0x2
	# #define PROT_EXEC		0x4	
	mov rdx, 0x1		# arg2 - int prot
	or rdx, 0x2
	or rdx, 0x4
	call mprotect

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
	mov rdi, offset open_msg
	call perror
	jmp exit_failure

fstat_failure:
	mov rdi, offset fstat_msg
	call perror
	jmp exit_failure

mmap_failure:
	mov rdi, offset mmap_msg
	call perror
	jmp exit_failure

read_failure:
	mov rdi, offset read_msg
	call perror
	jmp exit_failure

mprotect_failure:
	mov rdi, offset mprotect_msg
	call perror
	jmp exit_failure

exit_failure:
	mov rsp, rbp
	pop rbp
	mov eax, 1
	ret
