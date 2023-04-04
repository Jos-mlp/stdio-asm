;Programa para convertir cadenas de valor a numero
;Autor: Josue Maldonado

%include        'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese un numero: ', 0h
        msg2    db      'numero: ', 0h

SECTION .bss

NewString: resb    50      ;Almacena 50 espacios de memoria

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

    ; Imprimir el número en pantalla
    mov     eax, msg2
    call    printStr
    mov     eax, ebx
    call    iprint

    ;Finaliza el programa
    call    exit
