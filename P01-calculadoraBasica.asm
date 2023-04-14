;Calculadora basica que recibe 2 parametros
;Autor: Josue Maldonado

%include        'stdio32.asm'

SECTION .data
        msgi1	db      'Ingrese N1: ', 0h
        msgi2    db      'Ingrese N2: ', 0h

	msg1	db  	'Suma: ', 0h
 	msg2	db  	'Resta: ', 0h
 	msg3	db  	'Multiplicacion: ', 0h
	msg4	db  	'Division: ', 0h
	msg5	db  	'  Residuo: ', 0h

SECTION .bss
	N1: resb    10	     ;Almacena 10 espacios de memoria
    	N2: resb    10	     ;Almacena 10 espacios de memoria



SECTION .text
        global  _start

_start:

        pop  	ecx
        pop  	ebx
        
;---------------Pedimos datos---------------------------
        ;Llamada a la función para solicitar la cadena de texto
        mov     ebx, msgi1
        mov     edx, 10
        mov     ecx, N1
        call    inputStr
        
        ;Llamada a la función para solicitar la cadena de texto
        mov     ebx, msgi2
        mov     edx, 10
        mov     ecx, N2
        call    inputStr
        
    	;Convertir la cadena de caracteres en un numero entero
    	mov     eax, N1
    	call    convertirNumero   ; convertir la cadena en un número entero sin signo de 32 bits
    	mov     ecx, eax   
    	
    	;Convertir la cadena de caracteres en un numero entero
    	mov     eax, N2
    	call    convertirNumero   ; convertir la cadena en un número entero sin signo de 32 bits
    	mov     edx, eax 
    	
;Suma
        mov     eax, msg1
        call    printStr
        mov     eax, ecx
        mov     ebx, edx
        add     eax, ebx
        call    iprintLn

;Resta
	mov     eax, msg2
        call    printStr
        mov     eax, ecx
        mov     ebx, edx
        sub     eax, ebx
        call    iprintLn

;Multipliacion
        mov     eax, msg3
        call    printStr
        mov     eax, ecx
        mov     ebx, edx
        mul     ebx
        call    iprintLn


;División
    ;Imprime en pantalla el mensaje para la división
    mov eax, msg4
    call printStr

    ;Realiza la división
    mov eax, ecx        ; Mueve el dividendo a eax
    xor edx, edx        ; Limpia el registro edx para el divisor
;    mov ebx, N2         ; Mueve el divisor a ebx (N2 en este caso)
    div ebx             ; Realiza la división eax / ebx
    call iprint

    ;Muestra el residuo
    mov eax, msg5
    call printStr
    mov eax, edx        ; Mueve el residuo a eax
    call iprintLn
    
;Fin programa
        call    exit
        ret
