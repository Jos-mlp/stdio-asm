;posicion x,y de texto en pantalla
;Autor: Josue Maldonado

%include 'stdio32.asm'

SECTION .data
    msg     db  'Arquitectura II!', 0h     ; define la cadena de caracteres a imprimir
    strFin  db  1Bh, '[40;1H', 0h          ; define la cadena de caracteres para mover el cursor al final de la pantalla

SECTION .text

global _start

_start:
    call clrScr       ; limpiar la pantalla

    mov ah, 10        ; establecer la posición Y del cursor 
    mov al, 0       ; establecer la posición X del cursor 
    call gotoxy      ; mover el cursor a la posición especificada

    mov eax, msg     ; cargar la dirección de la cadena de caracteres a imprimir
    call printStrln  ; imprimir la cadena de caracteres seguida de un salto de línea

    mov eax, strFin  ; cargar la dirección de la cadena de caracteres para mover el cursor al final de la pantalla
    call printStr    ; mover el cursor al final de la pantalla

    call exit        ; finalizar el programa



    
