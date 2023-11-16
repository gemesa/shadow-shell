.global _start

.text

message:
	.asciz "Hello\n"

.att_syntax

_start_:

	mov $1, %rax        # syscall NR - write: 1
	mov $1, %rdi        # arg0 - unsigned int fd - stdout: 1
	mov $message, %rsi  # arg1 - const char *buf
	mov $6, %rdx        # arg2 - size_t count
	syscall

	mov $60, %rax       # syscall NR - exit: 60
	xor %rdi, %rdi      # arg0 - int error_code
	syscall

.intel_syntax noprefix

_start:

	mov rax, 1
	mov rdi, 1
	lea rsi, [rip + message] # equivalent: mov rsi, offset message
	mov rdx, 6
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall
