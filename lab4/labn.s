bits	64
section	.data

msg1:
	db	"Input x", 10, 0
msg2:
	db	"%lf", 0
msg3:
	db	"cos(%.10g)=%.10g", 10, 0
msg4:
	db	"mycos(%.10g)=%.10g", 10, 0
msg5:
	db	"Enter the number of members of the series", 10, 0
msg6:
	db	"Number of member: %lf --- Value: %lf", 10, 0
mode:
	db	"w", 0

section	.text
zero	dq	0.0
one	dq	1.0
minus	dq	-1.0
two	dq	2.0
mask	dq	7FFFFFFFFFFFFFFFh
mycos:
	movsd	xmm2, [minus]
	movsd	xmm3, [one]
	movsd	xmm4, [one]
	movsd	xmm5, [zero]
	movsd	xmm6, xmm15
	mulsd	xmm6, xmm15
	mulsd	xmm6, xmm2
	movsd	xmm7, [zero]
	movsd	xmm8, [one]
	movsd	xmm9, [two]
_loop:
	movsd	[rbp-x], xmm0;	
	movsd	[rbp-y], xmm1;
	mov	rdi, r12
	mov	rsi, msg6
	movsd	xmm0, xmm7
	movsd	xmm1, xmm4
	mov	rax, 2
	push	rcx
	movsd	[rbp-q], xmm2
	movsd	[rbp-filename], xmm3
	movsd	[rbp-fstruct], xmm4
	movsd	[rbp-fstruct1], xmm5
	movsd	[rbp-fstruct2], xmm6
	movsd	[rbp-fstruct3], xmm7
	movsd	[rbp-fstruct4], xmm8
	movsd	[rbp-fstruct5], xmm9
	call	fprintf
	pop	rcx
	movsd	xmm2, [rbp-q]
	movsd	xmm3, [rbp-filename]
	movsd	xmm4, [rbp-fstruct]
	movsd	xmm5, [rbp-fstruct1]
	movsd	xmm6, [rbp-fstruct2]
	movsd	xmm7, [rbp-fstruct3]
	movsd	xmm8, [rbp-fstruct4]
	movsd	xmm9, [rbp-fstruct5]

	movsd	xmm0, [rbp-x];
	movsd	xmm1, [rbp-y];
	


	addsd	xmm5, xmm4
	addsd	xmm7, xmm8
	
	movsd	xmm10, xmm9
	mulsd	xmm10, xmm7
	movsd	xmm11, xmm10
	subsd	xmm11, xmm8
	mulsd	xmm10, xmm11
	movsd	xmm12, xmm6
	divsd	xmm12, xmm10

	movsd	xmm3, xmm4
	mulsd	xmm4, xmm12

	movsd	xmm13, xmm4
	addsd	xmm13, xmm3

	movsd	xmm14, [mask]
	andpd	xmm13, xmm14

	ucomisd	xmm13, xmm1; ????? need abs

	ja 	_loop
	movsd	xmm0, xmm5
	ret
x	equ	8
y	equ	x+8
q	equ	y+8
filename	equ	q+8
fstruct		equ	filename+8
fstruct1	equ	fstruct+8
fstruct2	equ	fstruct1+8
fstruct3	equ	fstruct2+8
fstruct4	equ	fstruct3+8
fstruct5	equ	fstruct4+8
extern	printf
extern	scanf
extern	fopen
extern 	fclose
extern	fprintf
extern	cos ;
global	main
main:
	push	rbp
	mov	rbp, rsp

	sub	rsp, fstruct5
	and rsp, -16

	mov	rdi, [rsi+8]
	mov 	[rbp-filename], rdi
	mov	esi, mode
	call 	fopen
	mov	r12, rax
	
	mov	edi, msg1 ;;;;;;
	xor	eax, eax
	call	printf
	mov	edi, msg2
	lea	rsi, [rbp-x]
	xor	eax, eax
	call	scanf
	movsd	xmm0, [rbp-x]
	call	cos ;
	movsd	[rbp-y], xmm0
	mov	edi, msg3
	movsd	xmm0, [rbp-x]
	movsd	xmm1, [rbp-y]
	mov	eax, 2
	call	printf
	movsd	xmm0, [rbp-x]
	
	movsd	xmm15, xmm0 ;;;

	mov	edi, msg5
	xor 	eax, eax
	call	printf

	mov	edi, msg2
	lea	rsi, [rbp-x]; ????????
	xor	eax, eax
	call	scanf
	movsd	xmm1, [rbp-x]
	;movsd	xmm0, xmm15;;;;;;;;;;;; !!!!!!!!!!!!!!!!

	call	mycos

	movsd	[rbp-y], xmm0
	mov	edi, msg4
	movsd	xmm0, xmm15 ;;;
	movsd	xmm1, [rbp-y]
	mov	eax, 2
	call	printf


	mov	rdi, r12
	call	fclose	

	leave
	xor	eax, eax
	ret
