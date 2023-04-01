;Programa para implementar funciones
;Autor Josue Maldonado

SECTION .data


;--------------------Función para solicitar una cadena de texto------------------
;Parámetros:
;   ebx: puntero a la cadena que se imprimirá en pantalla para solicitar la cadena de texto
;   ecx: puntero al espacio de memoria donde se almacenará la cadena ingresada
;   edx: longitud máxima de la cadena ingresada
inputStr:
    ;Guardamos los valores en pila
    push    ebx
    push    ecx
    push    edx
    
    
    mov     eax, ebx    ;Cargar en eax el puntero a la cadena a imprimir
    call    printStr    ;Imprimir la cadena

    mov     eax, 3      ;Llamada al sistema para leer de la entrada estándar
    mov     ebx, 0      ;Archivo descriptor para la entrada estándar
    mov     ecx, ecx 	;Puntero al espacio de memoria donde se almacenará la cadena
    mov     edx, 50	;Longitud máxima de la cadena a leer
    int     80h         ;Llamada al sistema para leer de la entrada estándar

    ;Restauramos valores en pila
    pop     edx
    pop     ecx
    pop     ebx
    ret                 ;Retornar al programa que llamó a la función



;--------------------Funcion para contar longitud de cadena----
strlen:
	push 	ebx
	mov 	ebx, eax

siguiente:
	cmp 	byte[eax], 0
	jz 	finConteo
	inc 	eax
	jmp 	siguiente

finConteo:
	sub 	eax, ebx
 	pop 	ebx
 	ret

;-------------------------Imprime la cadena-----------------
printStr:
 	push 	edx
 	push 	ecx
 	push 	ebx
 	push 	eax

 	call 	strlen
 	mov  	edx, eax
 	pop  	eax
 	mov 	ecx, eax
 	mov 	ebx, 1
 	mov 	eax, 4
 	int 	80h

 	pop 	ebx
 	pop 	ecx
 	pop 	edx
 	ret

;---------------------------------Imprime cadena con salto de linea-----------------------
printStrln:
 	call 	printStr

 	push 	eax
 	mov  	eax, 0Ah
 	push 	eax
 	mov 	eax, esp
 	call 	printStr
 	pop 	eax
 	pop 	eax
 	ret

;--------------------------------------Imprime numeros enteros-----------------------------
iprint:
    	push   	eax
    	push   	ecx
    	push   	edx
    	push   	esi
    	push   	edi

    	xor    	edi, edi
    	xor    	ecx, ecx
    	test   	eax, eax

.divide:
    	inc    	ecx
    	xor    	edx, edx
    	mov    	esi, 10
    	idiv   	esi
    	add    	edx, 48
    	push   	edx
    	cmp    	eax, 0
    	jnz    	.divide

  	cmp    	edi, 1

.print:
    	dec	ecx
    	mov    	eax, esp
    	call   	printStr
    	pop    	eax
    	cmp    	ecx, 0
    	jnz    	.print
    	jmp    	.end

.end:
    	pop    	edi
    	pop    	esi
    	pop    	edx
    	pop    	ecx
    	pop    	eax
    	ret


;-------------------------------------------Agrega un salto de linea----------------------
newline:
    	push   	eax
    	mov    	eax, 0ah
    	call   	putchar
    	pop    	eax
    	ret

;-----------------------------------Imprime enteros con salto de linea-------------
iprintLn:
    	call   	iprint
    	call   	newline
    	ret


	

;--------------Esta funcion se utiliza para finalizar el programa (endP)--------------------
exit:
 	mov 	ebx, 0
 	mov 	eax, 1
 	int 	80h



