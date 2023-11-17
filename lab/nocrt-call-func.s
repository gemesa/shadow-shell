.global _start

.text

.att_syntax

message:
	.asciz "Hello\n"

_start_:
	call print

exit_:
	mov $60, %rax       # syscall NR - exit: 60
	xor %rdi, %rdi      # arg0 - int error_code
	syscall

print_:
	mov $1, %rax        # syscall NR - write: 1
	mov $1, %rdi        # arg0 - unsigned int fd - stdout: 1
	mov $message, %rsi  # arg1 - const char *buf
	mov $6, %rdx        # arg2 - size_t count
	syscall

	ret

.intel_syntax noprefix

_start:
	call print

exit:
	mov rax, 60
	xor rdi, rdi
	syscall

print:
	mov rax, 1
	mov rdi, 1
	mov rsi, offset message
	mov rdx, 6
	syscall

	ret
