bits 64

section .data
size 	equ	1024
filename:
	times size	db	0
str:
	times size	db	0

section .bss
fd	resq 1

section .text
global _start

_start:
	mov	rax, 0
	mov	rdi, 0
	mov	rsi, filename
	mov	rdx, size
	syscall

	dec	rax
	mov	r10, rax

 	mov	rax, 2
	mov	rdi, filename
	mov	byte [rdi + r10], 0
	mov	rsi, 0
	syscall
	mov	[fd], rax


	or	rax, rax
	jl	_error

_read_loop:
	mov	rax, 0
	mov	rdi, [fd]
	mov	rsi, str
	mov	rdx, size
	syscall

	mov	r11, rax

	test 	rax, rax
	jle	_close_file

	mov 	rax, 1
	mov	rdi, 1
	mov	rsi, str
	mov	rdx, r11
	syscall

	jmp _read_loop

_close_file:
	mov	rax, 60
_error:
	mov	rdi, 1
	xor 	rdi, rdi
	syscall
