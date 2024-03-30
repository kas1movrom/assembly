bits 64

section .data
size	equ	1024
filename:
	times size	db	0
file_len	equ	$-filename
buffer:
	db	255
buf_len		equ	$-buffer

section .bss
fd:
	resq	1

section .text
global _start

_start:
	mov	rax, 0
	mov	rdi, 0
	mov	rsi, filename
	mov 	rdx, size
	syscall
	


	mov	rsi, filename
	add	rsi, rax
	mov	byte [rsi], 0

	mov 	rax, 2
	mov	rdi, filename
	mov	rsi, 0
	syscall
	mov	[fd], rax

_read_loop:
	mov	rax, 0
	mov	rdi, [fd]
	mov	rsi, buffer
	mov 	rdx, buf_len
	syscall

	test	rax, rax
	jle 	_close_file

	mov 	rax, 1
	mov	rdi, 1
	mov	rsi, buffer
	syscall

	jmp _read_loop

_close_file:
	mov	rax, 3
	mov	rdi, [fd]
	syscall
	jmp _end_programm

_end_programm:
	mov	rax, 60
	xor 	rdi, rdi
	syscall
