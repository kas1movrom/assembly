bits 64

section .data
matrix_size:
	db	2, 3
matrix:
	dd	1, 2, 3, 4, 5, 6

section .text
global _start

_start:
	mov 	r8d, matrix
	movzx	r9d, byte[matrix_size]
	movzx	r10d, byte[matrix_size + 1]

	xor 	edi, edi

_outer_loop:
	cmp 	r9d, edi
	jz 	_iteration_end

	xor 	esi, esi

_inner_loop:
	mov 	rax, rdi
	mov 	rbp, 12
	mul 	rbp
	mov	r11, rax
	mov	rax, rsi
	mov 	rbp, 4
	mul	rbp
	add	r11, rax
	add	r12d, [r8 + r11]

	inc	esi

	cmp	r10d, esi
	jnz	_inner_loop

	inc 	edi
	loop	_outer_loop

_iteration_end:
	mov 	eax, 60
	mov 	edi, 1
	syscall
