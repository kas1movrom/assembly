bits 64

section .data
size	equ	1024
buffer	db	255
buf_len	equ	$-buffer
enter_message:
	db	"Enter name of file with data: "
ent_len	equ	$-enter_message
file_name:
	times size	db	0

section .bss
fd	resq 1

section .text
global _start

_start:
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, enter_message
	mov	rdx, ent_len
	syscall

	xor 	rax, rax
	xor	rdi, rdi
	mov	rsi, file_name
	mov	rdx, size
	syscall

	or	rax, rax
	jl	m6
	je	m5

	mov	rax, 2
	mov	rdi, file_name
	mov	rsi, 0
	syscall

	cmp	rax, -1
	je	m6
	
	mov	[fd], rax

_read_loop:
	mov	rax, 0
	mov	rdi, [fd]
	mov	rsi, buffer
	mov	rdx, buf_len
	syscall

	test	rax, rax
	jle _close_file
	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, buffer
	mov	rdx, buf_len
	syscall

	jmp _read_loop

_close_file:
	mov	rax, 3
	mov	rdi, [fd]
	syscall
m5:
	xor	rdi, rdi
	jmp	m7
m6:
	mov	rdi, 1
m7:
	mov	rax, 60
	syscall

