bits 64

section .data
size 	equ	1024
filename:
	times size	db	0
str:
	times size	db	0

section .bss
fd		resq 1
buffer		resb 1
prev_char	resb 1
skip_char	resb 1 


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
	jl	_exit

;_read_loop:
;	mov	rax, 0
;	mov	rdi, [fd]
;	mov	rsi, str
;	mov	rdx, size
;	syscall
;
;	mov	r11, rax
;
;	test 	rax, rax
;	jle	_close_file
;
;	mov	rsi, str
;	mov	rdx, r11
;	syscall	
;
;	jmp _read_loop
;
;_error:
;	mov	rax, 60
;	mov	rdi, 1
;	syscall

;_close_file:
;	mov	rax, 60
;	xor 	rdi, rdi
;	syscall
	
	mov	byte[prev_char], 0
	mov	byte[buffer], 0

_read_loop:
	mov	rax, 0
	mov	rdi, [fd]
	mov	rsi, buffer
	mov	rdx, 1
	syscall

	test	rax, rax
	jle	_exit_and_close

	mov	al, byte[buffer]
	mov	byte[skip_char], 0

	cmp	al, byte[prev_char]
	je 	_set_skip_flag

	mov	byte[prev_char], al

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, buffer
	mov	rdx, 1
	syscall

_set_skip_flag:
	mov	byte[skip_char], 1
	jmp	_read_loop

_exit_and_close:
	mov	rax, 3
	mov	rdi, [fd]
	syscall
_exit:
	mov	rax, 60
	xor 	rdi, rdi
	syscall