bits 64

section .data
size	equ	1024
enter_message:
	db	"Enter name of file with data: "
ent_len	equ	$-enter_message

section .text
global _start

_start:
	mov	eax, 1
	mov	edi, 1
	mov	esi, enter_message
	mov	edx, ent_len
	syscall
	mov 	eax, 60
	mov	edi, 1
	syscall
