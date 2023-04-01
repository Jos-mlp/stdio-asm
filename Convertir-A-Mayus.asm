;Programa para convertir cadenas a mayúsculas
;Autor: Josue Maldonado

%include        'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese texto: ', 0h
        msg2    db      'Mayusculas: ', 0h

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

	
        ;Convertir la cadena a mayúsculas
        mov     eax, msg2
        call    printStr
        mov     eax, NewString
        push    eax

strUpcase:
        cmp     byte[eax],  0h
        jz      impresion
        cmp     byte[eax],  61h
        jl      NextC
        cmp     byte[eax],  7Ah
        jg      NextC
        xor     byte[eax],  20h
        jmp     NextC

NextC:
        inc     eax
        jmp     strUpcase

impresion:
        pop     eax
        call    printStrln
        call    exit
        ret

