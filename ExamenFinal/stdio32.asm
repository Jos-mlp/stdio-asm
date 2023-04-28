;Programa para implementar funciones
;Autor Josue Maldonado

SECTION .data
        clrscrStr       db      1Bh, '[2J', 1Bh, '[3J', 0h
        posYX   db  1Bh, '[', ' ;', 'H', 0h     ; define la variable para almacenar la posición YX del cursor

;-----------------------Funcion para limpiar la pantalla------------
;ClearScreen
clrScr:
        mov	eax, clrscrStr
        call 	printStr
        ret

;-------------------------COnvierte un numero en una cadena-------------------
convertirCadena:
    push    ebp
    mov     ebp, esp

    mov     eax, eax     ; mueve el número a convertir en eax
    mov     ebx, 10            ; establece la base decimal

    mov     edi, edx          ; guarda la dirección de la cadena en edi
    xor     edx, edx           ; establece edx en cero para el ciclo

.ciclo:
    xor     ebx, ebx           ; establece ebx en cero para el ciclo
    div     ebx                ; divide eax por ebx y almacena el residuo en edx
    add     dl, '0'            ; convierte el valor de la cifra en un caracter ASCII
    mov     [edi], dl          ; mueve el caracter a la cadena
    inc     edi                ; incrementa la dirección de la cadena
    cmp     eax, 0             ; compara eax con cero para ver si ha terminado el ciclo
    jne     .ciclo             ; si eax no es cero, repite el ciclo

    xor     byte [edi], byte 0 ; agrega el terminador nulo a la cadena
    mov     eax, ecx           ; devuelve la dirección de la cadena

    pop     ebp
    ret



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


;--------------------Funcion para solicitar datos (2)----------
; Esta función solicita datos de entrada al usuario a través del teclado y los almacena en una variable de texto.
; Parámetros:
;   Entrada: Registro eax contiene la variable de texto donde se almacenarán los datos de entrada
;            Registro ebx contiene la longitud de la cadena para limitar la cantidad de caracteres a leer
;   Salida: Los datos de entrada del usuario se almacenan en la variable de texto especificada en eax
 input:
    push edx
    push ecx
    
    mov  edx,ebx         ;edx=ebx longitud de cadena
    push ebx
    mov  ecx,eax         ;ecx=variable=texto
    mov  ebx,0           ;entrada por teclado
    mov  eax,3           ;servicio SYS READ opcode 3
    int  80h
    
    pop ebx
	pop ecx
	pop edx
	
	ret
	

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

;-------------------------Imprime la cadena---------------------------------
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



;--------------------------función gotoxy-------------------------------
; Parámetros:
;   - ah: Posición X del cursor 
;   - al: Posición Y del cursor 
gotoxy:
    push    eax     ; Guardar el valor de registro 
    push    edx     
    push    ecx     
    push    ebx     

    mov bh,         ah    ; Mover el valor de AH a BH (posición X del cursor)
    mov bl,         al    ; Mover el valor de AL a BL (posición Y del cursor)
    mov esi,        10    
    mov ecx,        posYX ; Cargar la dirección de memoria de la variable posYX en el registro ECX (donde se almacena la posición YX del cursor)

    xor eax,        eax   ; Limpiar el registro EAX (ponerlo a cero)
    xor edx,        edx  
    mov al,         bh    
    idiv esi               
    add eax,        48    
    add edx,        48    
    mov byte [ecx + 2], al ; Guardar el valor de AL en la tercera posición de la variable posYX 
    mov byte [ecx + 3], dl ; Guardar el valor de DL (residuo de la división) en la cuarta posición de la variable posYX 

    
    mov eax, posYX    ; Imprime la cadena posYX
    call    printStr  

    pop     ebx     ; Restaurar el valor de registro desde la pila
    pop     ecx     
    pop     edx     
    pop     eax     
    ret               ; Retornar de la función gotoxy
    
    	
;------------------------------Funcion atoi--------------------------------------------------
; Esta función convierte una cadena de caracteres en entero.
;Parámetros:
;   Entrada: Registro eax contiene un puntero a la cadena de caracteres
;   Salida: Registro eax contiene el valor numérico entero representado por la cadena de caracteres
atoi:
    push   ecx
    push   esi
    push   ebx

    mov    esi, eax  ; move string pointer to esi as eax will be used for math
    mov    eax, 0
    mov    ecx, 0

    xor    edi, edi  ; negative flag and error flag

    cmp    byte [esi], 45   ; "-"
    je     .negative

.multiplyLoop:
    xor    ebx, ebx
    mov    bl, [esi + ecx]

    cmp    bl, 10
    je     .terminar
    cmp    bl, 0
    jz     .terminar
    cmp    bl, 48     ; "0"
    jl     .error
    cmp    bl, 57     ; "9"
    jg     .error

    sub    bl, 48
    add    eax, ebx
    mov    ebx, 10
    mul    ebx
    inc    ecx
    jmp    .multiplyLoop

.negative:
    inc    ecx
    mov    edi, 1     ; make sign negative
    jmp    .multiplyLoop


.negar:
    neg    eax
    mov    edi, 0     ; because edi is both negative and error, make sure to clear it
    jmp    .fin

.error:
    mov    edi, 1
    jmp    .fin

.terminar:
    mov    ebx, 10
    div    ebx
    cmp    edi, 1
    je     .negar

.fin:
    pop    ebx
    pop    esi
    pop    ecx
    ret
 
 ;-----------------------------FUncion para comparar 2 cadenas-----------------------------
; Función que compara dos cadenas de caracteres
; Entradas:
;   ecx: puntero a la primera cadena
;   edx: puntero a la segunda cadena
; Salida:
;   eax: 0 si las cadenas son iguales, otro valor si son diferentes

strcmp:
        push    ebx
        push    esi
        push    edi

        mov     esi, ecx    ; puntero a la primera cadena
        mov     edi, edx    ; puntero a la segunda cadena

ciclo:
        mov     al, [esi]   ; caracter actual de la primera cadena
        mov     bl, [edi]   ; caracter actual de la segunda cadena
        cmp     al, bl
        jne     fin_cmp     ; si son diferentes, salimos de la función

        cmp     al, 0       ; si el caracter es 0, salimos de la función
        je      fin_cmp

        inc     esi         ; avanzamos en la primera cadena
        inc     edi         ; avanzamos en la segunda cadena
        jmp     ciclo       ; repetimos el ciclo

fin_cmp:
        mov     eax, 0      ; suponemos que las cadenas son iguales
        mov     al, [esi]   ; si la primera cadena terminó antes que la segunda, son diferentes
        cmp     al, [edi]
        jne     fin         ; si son diferentes, salimos de la función
        mov     al, [edi]   ; si la segunda cadena terminó antes que la primera, son diferentes
        cmp     al, [esi]
        jne     fin

        xor     eax, eax    ; las cadenas son iguales

fin:
        pop     edi
        pop     esi
        pop     ebx
        ret
;--------------Esta funcion se utiliza para finalizar el programa (endP)--------------------
exit:
 	mov 	ebx, 0
 	mov 	eax, 1
 	int 	80h



