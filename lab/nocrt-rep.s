.global _start

.bss
.lcomm buffer, 100

.text

.att_syntax

message:
	.asciz "Hello\n"

_start_:
	movl $message, %esi # src
	movl $buffer, %edi  # dst
	movl $6, %ecx       # sizeof message
	rep  movsb

	mov $1, %rax        # syscall NR - write: 1
	mov $1, %rdi        # arg0 - unsigned int fd - stdout: 1
	mov $buffer, %rsi   # arg1 - const char *buf
	mov $6, %rdx        # arg2 - size_t count
	syscall

	mov $60, %rax       # syscall NR - exit: 60
	xor %rdi, %rdi      # arg0 - int error_code
	syscall

.intel_syntax noprefix

_start:
	mov esi, offset message
	mov edi, offset buffer
	mov ecx, 6
	rep movsb

	mov rax, 1
	mov rdi, 1
	mov rsi, offset buffer
	mov rdx, 6
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall
