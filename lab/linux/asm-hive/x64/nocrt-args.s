.global _start

.text

newline:
	.ascii "\n"

.intel_syntax noprefix

_start:
    mov r12, [rsp]			# argc
    lea r13, [rsp + 8]		# agrv[0]


print_args:
    test r12, r12
    jz exit

    mov rax, 1         		# syscall NR - write: 1
    mov rdi, 1         		# arg0 - unsigned int fd - stdout: 1
	mov rsi, [r13]			# write syscall: arg1 - const char *buf
    mov rdx, 0         		# arg2 - size_t count
    
find_strlen:
    cmp byte ptr [rsi + rdx], 0   # look for null terminator
    je print_arg
    inc rdx
    jmp find_strlen
    
print_arg:
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, offset newline
    mov rdx, 1
    syscall

    add r13, 8
    dec r12
    jmp print_args

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
