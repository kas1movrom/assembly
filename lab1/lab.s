bits 64
;	res = b*c + a/(d+e) - (d*d)/(b*e) + a*e
section .data
res:
	dq	0
c:
	dq	4000000000000000000
a:
	dd	80
b:
	dd	1000000
d:
	dw	12
e:
	db	7
section .text
global _start
_start:
	mov eax, dword[a] ; !	

	movzx rbx, word[d] ;
	movzx rsi, byte[e] ;
	add rbx, rsi;		ebx = d+e ; 
	test rbx, rbx ;
	jz division_by_zero
	div rbx;		eax = a/(d+e) ;
	mov rcx, rax ;
	mov eax, dword[a] ; !
	

	mul rsi;		eax = a*e ;

;	jc detect_overflow

;	shl rdx, 32
;	or rax, rdx
;	mov rcx, rcx

	add rcx, rax;		rcx = a/(d+e) + a*e
	jc detect_overflow
	mov eax, dword[b] ; !

	mul rsi;		eax = b*e ;

;	jc detect_overflow

;	shl rdx, 32
;	or rax, rdx

	test rax, rax
	jz division_by_zero
	mov rbx, rax;		rbx = b*e
	movzx rax, word[d] ;
	mul rax;		eax = d*d ;

;	mov rax, rax

	div rbx;		rax = (d*d)/(b*e)
	mov rsi, rax
	sub rcx, rsi;		rcx = a/(d+e) + a*e - (d*d)/(b*e)

;	jc detect_overflow

	mov eax, dword[b] ; !

;	mov rax, rax

	mov rbx, qword[c]
	mul rbx;		rax = b*c
	jc detect_overflow
	add rax, rcx;		rax = b*c + a/(d+e) + a*e - (d*d)/(b*e)
	jc detect_overflow
	mov [res], rax
	mov eax, 60
	mov edi, 0
	syscall

division_by_zero:
	mov eax, 60
	mov edi, 1
	syscall

detect_overflow:
	mov eax, 60
	mov edi, 2
	syscall
