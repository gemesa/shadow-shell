.global _start

.text

message:
	.ascii "Hello\n"

.att_syntax

_start_:
	lea  exit(%rip), %rax
	push %rax

	jmp print

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

	pop %rax
	jmp *%rax

.intel_syntax noprefix

_start:
	lea  rax, [ rip + exit]
	push rax

	jmp print

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

	pop rax
	jmp rax
