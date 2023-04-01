;Programa para convertir cadenas en minusculas
;Autor: Josue Maldonado Lepe

%include	'stdio32.asm'

SECTION .data
        msg1    db      'Ingrese texto: ', 0h
        msg2    db      'Minusculas: ', 0h

SECTION .bss
        NewString: resb    50	;Almacena 50 espacios enla memoria

SECTION .text
        global  _start

_start:
        ;Llamada a la función para solicitar la cadena de texto
        mov     ebx, msg1
        mov     edx, 50
        mov     ecx, NewString
        call    inputStr
        
        
        ;Convertir la cadena a minusculas
        mov     eax, msg2
        call    printStr
        mov     eax, NewString
        push    eax

strLowcase:
        cmp     byte[eax],  0h
        jz      impresion
        cmp     byte[eax],  41h
        jl      NextC
        cmp     byte[eax],  5Ah
        jg      NextC
        xor     byte[eax],  20h
        jmp     NextC

NextC:
        inc     eax
        jmp     strLowcase

impresion:
        pop     eax
        call    printStrln
        call    exit
        ret
