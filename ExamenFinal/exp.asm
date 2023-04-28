; Programa en ensamblador x86_64 que eleva una base a un exponente utilizando
; multiplicación cíclica.
; creador: Josue Maldonado
; fecha: 26/04/2023

extern	printf
extern	scanf
extern	atoi

SECTION .data
	msg:	db	"Ingrese la base y el exponente separados por un espacio: ", 0
	res:	db	"El resultado %f ^ %f es de: %f", 10, 0

SECTION .bss
	base:	resq	1
	exp:	resq	1
	result:	resq	1

SECTION .text

global main

main:
	push	rbp
	mov	rbp, rsp

	; Lee la base y el exponente desde la línea de comandos.
	mov	rdi, base
	mov	rsi, [rsp + 8]	
	call	atoi		
	mov	qword [base], rax

	mov	rdi, exp
	mov	rsi, [rsp + 16]	
	call	atoi	
	mov	qword [exp], rax

	; Calcula la potencia utilizando multiplicación cíclica.
	mov	qword [result], 1
	mov	qword rcx, [exp]
	mov	rax, [base]

mul_loop:
;------------multiplicacion ciclica de 2 numeros
	test	rcx, 1
	jz	shift_loop

	imul	rax, rax
	mov	qword [result], rax
	sub	rcx, 1

;----------Dezplazamiento binario
shift_loop:
	test	rcx, rcx
	jz	fin

	add	rcx, -1
	imul	rax, rax
	jmp	mul_loop

fin:
	; Imprime el resultado de la potencia.
	mov	rdi, res
	movq	xmm0, qword [base]	;1er, parametro de coma flotante base
	movq	xmm1, qword [exp]	;2o. parametro de coma flotante exponente
	movq	xmm2, qword [result]		;3er. parametro de coma flotante r
	mov	rax, 3

	call	printf

	pop	rbp
	mov	rax, 0
	ret

