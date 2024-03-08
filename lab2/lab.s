bits 64

section .data
matrix_size:
	db	2, 4
gold_number:
	dd	125
matrix:
	dd	12, 10, 11, -9, 5, 7, 6, 8

;%macro q_product 1
;	mov	r11, %1
;	mul r11
;%endmacro


;%macro ASCENDING 0
;	%define	DIRECTION 1
;%endmacro

;%macro DESCENDING 0
;	%define DIRECTION -1
;%endmacro

;%define ASCENDING

section .text
global _start

_start:
; r15d = i
; r14d = step
; r13d = j = rows_counter
; r12d = cols * 4

; r10d = cols
; r9d = rows
; r8d = matrix

	mov	r8d, matrix
	movzx	r9d, byte[matrix_size]
	movzx	r10d, byte[matrix_size+1]
	movzx	eax, byte[matrix_size+1]
	mov	r13d, 4
	mul	r13d;			eax = cols*4
;	mul	dword[double_word]
;	q_product 4
	mov	r12d, eax;		r12d = cols*4	

	test	r9d, r9d
	jz	_empty_matrix
	test 	r10d, r10d
	jz 	_empty_matrix

	xor 	r13d, r13d

_outer_loop:
	cmp	r9d, r13d;		rows ? j
	jz	_sort_end

	mov	r14d, r10d;		step = array.size
	dec	r14d;			--step

_inner_loop:
	cmp	r14d, 1;		step ? 1
	jl	_inc_outer_counter
	
	xor	r15d, r15d;		i = 0	

_sort_loop:
	mov	esi, r15d;		esi = i
	add	esi, r14d;		esi = i+step
	cmp	esi, r10d;		i+step?array.size

	jnl	_next_step		
		
	mov	rax, r13
	mul	r12;			
	mov	rsp, rax;		rsp = j*cols*4
	mov	rax, r15
	mov	rbp, 4
	mul	rbp
;	mul	qword[double_word]
;	q_product 4
	mov	rbp, rax;		rbp = 4*i
	add	rsp, rbp;		rsp = j*cols*4 + 4*i
	mov	rax, 4
	mul	r14;			rax = 4*step
;	mul 	qword[double_word]
;	q_product 4
	mov	rbp, rsp
	add	rbp, rax;		rbp = j*cols*4 + 4*i + 4*step
	

	mov	esi, [r8+rsp];		esi = arr[i]			rsp????
	mov	edi, [r8+rbp];		edi = arr[i+step]		rbp????
	

	%ifdef ASCENDING
		cmp	esi, edi;		arr[i] ? arr[i+step]
	%else
		cmp	edi, esi
	%endif
	


	jng 	_inc_sort_counter

	mov	[r8+rsp], edi
	mov	[r8+rbp], esi;		swap		

_inc_sort_counter:
	inc	r15d;			i++
	loop	_sort_loop
	
_next_step:
	mov	eax, r14d;		eax = step
	mov	edx, 100;		edx = 100
	mul	edx;			eax = step*100
;	mul	dword[factor]
;	q_product 100
	div	dword[gold_number];	eax = step/1.25
	mov	r14d, eax;		r14d = step		
	loop	_inner_loop	

_inc_outer_counter:
	inc	r13d;			j++
	loop	_outer_loop

_sort_end:
	mov	eax, 60
	mov	edi, 0
	syscall

_empty_matrix:
	mov	eax, 60
	mov	edi, 1
	syscall
