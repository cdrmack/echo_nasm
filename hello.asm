section .data
msg	db	'hello, world!', 10, 0

section .text
	global _start

_start:
	mov	rax, 4		; write syscall
	mov	rdi, 1		; file descriptor of standard output
	mov	rsi, msg	; address of the message to write
	mov	rdx, 15		; message length
	syscall

	mov	rax, 1		; exit syscall
	mov	rdi, 0		; exit code 0
	syscall
