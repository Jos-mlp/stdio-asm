;Programa para invertir la cadena de caracteres ingresada
;Autor: Carlitos

%include 'stdio32.asm'

SECTION .data
        msg1	db	'Ingrese texto: ', 0
        msg2    db      'frase invertida: ', 0
        msg3    db      'La cadena invertida es palindromo: ', 0
        msg4    db      'La cadena invertida no es palindromo: ', 0

SECTION .bss
        cadena		resb    50
        Invertida       resb    50
        cont            resb    2

SECTION .text
    	global _start

_start:
        ;Llamada a la función para solicitar la cadena de texto en stdio32
        mov     ebx, msg1
        mov     edx, 50
        mov     ecx, cadena
        call    inputStr
        
        
        mov     byte [cont], 0
        mov     esi, Invertida

Longitud:
        cmp     byte [ecx], 0
        je      invertirC
        inc     ecx
        inc     byte [cont]
        jmp     Longitud

invertirC:
        cmp     byte [cont], 0
        je      imprimir
        mov     al, [ecx-1]
        mov     [esi], al
        dec     byte [cont]
        dec     ecx
        inc     esi
        jmp     invertirC

imprimir:
        mov     eax, msg2
        call    printStr
        mov     eax, Invertida
        call    printStrln
        
        ; Comparamos las cadenas "cadena" e "Invertida"
        mov     ecx, cadena
        mov     edx, Invertida
        call    strcmp
        test    eax, eax
        jnz     noPalindromo  ; Si strcmp devuelve un número diferente de 0, no es palíndromo

        ; Si strcmp devuelve 0, entonces es palíndromo
        mov     eax, msg3
        call    printStrln
        jmp     salir

noPalindromo:
        mov     eax, msg4
        call    printStrln

salir:
        call    exit
