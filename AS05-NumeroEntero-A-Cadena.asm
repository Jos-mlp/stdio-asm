;Programa para convertir numeros a cadenas
;Autor: Josue Maldonado

%include        'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese un numero: ', 0h
        msg2    db      'cadena: ', 0h

SECTION .bss

NewString: resb    50      ;Almacena 50 espacios de memoria
Cadena: resb 50   	   ; reserva 11 bytes de memoria para almacenar la cadena resultante

SECTION .text
        global  _start

_start:
    ;Llamada a la función para solicitar la cadena de texto
    mov     ebx, msg1
    mov     edx, 50
    mov     ecx, NewString
    call    inputStr

    ;Convertir la cadena de caracteres en un numero entero
    mov     eax, NewString    
    call    convertirNumero   ; convertir la cadena en un número entero sin signo de 32 bits
    mov     ebx, eax          

    ;Convertir numero entero en cadena de caracteres
    mov     eax, ebx
    mov	    edx, Cadena
    call    convertirCadena   ; convertir la cadena en un número entero sin signo de 32 bits
    mov     ebx, eax    
    
    
    ; Imprimir la cadena en pantalla
    mov     eax, msg2
    call    printStr
    mov     eax, ebx
    call    printStr

    ;Finaliza el programa
    call    exit
