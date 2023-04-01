;Programa para convertir cadenas a mayúsculas
;Autor: Josue Maldonado

%include        'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese texto: ', 0h
        msg2    db      'Texto Ingresado: ', 0h

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

	
        ;Imprime la cadena que ingreso el usuario
        mov     eax, msg2
        call    printStr
        mov     eax, NewString
        call	printStr


	;Finaliza el programa
	call    exit


