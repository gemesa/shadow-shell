.global _start

.text

_start:
	call print

exit:
	mov $60, %rax       # syscall NR - exit: 60
	xor %rdi, %rdi      # arg0 - int error_code
	syscall

print:
	mov $1, %rax        # syscall NR - write: 1
	mov $1, %rdi        # arg0 - unsigned int fd - stdout: 1
	mov $message, %rsi  # arg1 - const char *buf
	mov $6, %rdx        # arg2 - size_t count
	syscall

	ret

message:
	.ascii "Hello\n"
