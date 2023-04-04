;Programa para implementar funciones
;Autor Josue Maldonado

SECTION .data

;--------------------------------Convierte una cadena en un numero-------------
;Parametros:
;eax -> en esta direccion pasa la cadena que deseamos convertir
;Retorna
;eax -> Retorna el numero convertido
convertirNumero:
    push    ecx         ; guarda el puntero de pila

    mov     ecx, eax    ; mueve la dirección de la cadena a "ecx"
    xor     eax, eax    
    xor     ebx, ebx    
    xor     edx, edx    
    cmp     byte [ecx], 0 ; verifica si la cadena está vacía
    je      .ends         

    cmp     byte [ecx], '-' ; verifica si el número es negativo
    je      .negative
    jmp     .parses

.negative:
    inc     ecx          ; avanza la posición de la cadena
    cmp     byte [ecx], 0 ; verifica si la cadena está vacía
    je      .ends         

.parses:
    mov     bl, [ecx]    ; mueve el siguiente carácter a "bl"
    inc     ecx          ; avanza la posición de la cadena
    cmp     bl, '0'      ; verifica si el carácter es un número
    jb      .ends       
    cmp     bl, '9'
    ja      .ends
    sub     bl, '0'      ; convierte el carácter en un número
    mov     edx, eax     ; mueve el resultado actual a "edx"
    mov     eax, ebx     ; mueve el número convertido a "eax"
    imul    edx, 10      ; multiplica el resultado por 10
    add     eax, edx     ; agrega el resultado multiplicado al número convertido
    jmp     .parses

.ends:
    cmp     byte [ecx - 1], '-' ; verifica si numero es negativo
    jne     .not_negative
    neg     eax          ; si es negativo, cambia el signo del resultado
.not_negative:
    pop     ecx          ; restaura el puntero de pila
    ret                  ; retorna el resultado en "eax"


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



;--------------------Funcion para contar longitud de cadena-----------
;parametros
;eax: direccion de cadena 
strlen:
	push 	ebx		;guarda puntero de pila
	mov 	ebx, eax

siguiente:
	cmp 	byte[eax], 0	;verifica si la cadena esta vacia
	jz 	finConteo
	inc 	eax
	jmp 	siguiente

finConteo:
	sub 	eax, ebx
 	pop 	ebx		;restaura puntero de pila
 	ret			;retorna en eax la longitud de la cadena

;-------------------------Imprime la cadena-----------------
printStr:
 	push 	edx		;guarda punteros de pila
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

 	pop 	ebx		;retorna punteros de pila
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

putchar:
    	push   	edx
    	push   	ebx
    	push   	ecx
    	push   	eax
    	mov    	edx, 1
    	mov    	ecx, esp
    	mov    	ebx, 1
    	mov    	eax, 4
    	int    	80h
    	pop    	eax
    	pop    	ecx
    	pop    	ebx
    	pop    	edx
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



