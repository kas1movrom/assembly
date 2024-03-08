bits 64

section .data
size:
	dd	10
array:
	dd	1, 2, 3, 4, 5, 6, 7, 8, 9, 10

section .text
global _start

_start:
	mov	ebx, array
	mov	ecx, [size]

	or 	ecx, ecx
	jle	_end

	mov 	eax, [rbx]

	xor 	edi, edi
	
	dec 	ecx
	jecxz	_result_action

_loop:
	inc	edi
	add 	r8d, [rbx+rdi*4]
	loop 	_loop

_result_action:
	mov	eax, r8d

_end:
	mov	eax, 60
	mov	edi, 1
	syscall
