; Josue Manuel Maldonado Lepe
; Super Calculadora RPN
; Ingreso con parametros consola
%include 'stdio32.asm'

SECTION .data
    tamanoPila:     dd 0        
    pila: times 256 dd 0   
    msg1            db      'La expresion no valida', 0h
    msg2            db      'Resultado: ', 0h
    msg3            db      'salir', 0h
    msg4            db      'Saliendo del programa', 0h
    msg5            db      'Opcion no valida',0h
    msg6            db      'Ingreso por parametros ', 0h
    msg7            db      'Ingreso por archvo de texto', 0h
    msg8            db      'Ingresar expresion salir para finalizar: ', 0h
    msg9            db      'Caracter no valido: ', 0h
    msg10           db      'Utilice x en vez de *', 0h
    msg11           db      'La expresion invalida', 0h
    cadenaSalir     db      'salir', 0h
    cadenaRpn       db      'rpn', 0h

SECTION .bss                                    
    expresion:         resb        30  
    parametros      resw        500             

SECTION .text
global _start

%macro operacionPrevia 0
    cmp    ecx, 2
    jl     expresionInvalida

    dec    ecx
    mov    esi, [parametros + ecx * 4]
    dec    ecx
    mov    eax, [parametros + ecx * 4]
%endmacro

%macro operacionTerminada 0
    mov    [parametros + ecx * 4], eax
    inc    ecx
    jmp    endloop
%endmacro
        ;Se inicia el programa
        
        
_start:
inicio           
    ; Verificar si se pasaron argumentos
    mov    ebp, esp
    cmp    dword [ebp], 1
    je     ingresoManual
    xor    ecx, ecx      
    mov    ebx, 2 
;------------------------------------------------------------------------
;El primer modo es el que utiliza las operaciones por parametros
;-------------------------INICIO DE LA CALCULADORA RPN----------    
RPNconsola:

          
;--------------------CICLO DE COMPARACIONES-------------
main:
    mov    eax, [ebp + ebx * 4]

    
    cmp    byte [eax + 1], 0
    jnz    convertirNumero


    cmp    byte [eax], 43          ; "+"
    je     sumar
    cmp    byte [eax], 45          ; "-" 
    je     restar
    cmp    byte [eax], 47          ; "/"
    je     dividir          
    cmp    byte [eax], 120         ; "x"
    je     multiplicar        
    cmp    byte [eax], 48          ; "0"
    jl     fallo
    cmp    byte [eax], 57          ; "9"
    jg     fallo
    
;-------------ATOI-------------
;convertirAnumero
convertirNumero:
    
    xor    edi, edi
    call   atoi
    cmp    edi, 1
    je     numError

    mov    [parametros + ecx * 4], eax
    inc    ecx

endloop:
    inc    ebx

    cmp    ebx, [ebp]
    jle    main

    jmp    finalizado
    
;-------------------OPERACIONES DE LA CALCULADORA----------------
sumar:
    operacionPrevia
    add    eax, esi
    operacionTerminada

restar:
    operacionPrevia
    sub    eax, esi
    operacionTerminada

multiplicar:
    operacionPrevia
    imul   eax, esi
    operacionTerminada

dividir:
    operacionPrevia
    div    si
    operacionTerminada

numError:
    mov    eax, msg2
    call   printStr
    mov    eax, [ebp + ebx * 4]
    call   printStrln
    jmp    fin

fallo: 
   
    push   eax
    mov    eax, msg1
    call   printStr

    pop    esi
    mov    eax, [esi]
    call   putchar
    call   newline
    jmp    fin

expresionInvalida:
    mov    eax, msg3
    call   printStrln
    jmp    fin

finalizado:
    
    ;cmp    ecx, 1
    ;jne    expresionInvalida

    mov    eax,msg2
    call    printStrln
    
    
;-------------IMPRIMIR RESULTADO---------
    sub    ecx, 1
    mov    eax, [parametros + ecx * 4]
    mov    ebx,eax
    call   iprintLn
    push    ebx
    jmp	   fin
    
ingresoFinal:
    mov	   eax, msg4
    call   printStrln

fin:
    call   exit
            
;Esta se llega cuando el usuario solo escribe rpn sin ningun parametro
        ingresoManual:
            mov     ecx, 0
            mov     eax, msg7
            call    printStrln
            mov     eax, msg8
            call    printStrln
            mov     eax, 3
            mov     ebx, 0
            mov     ecx, expresion
            mov     edx, 20
            int     80h
            
        procesarExpresionRpn:           
            mov     esi, expresion       
            push    esi
            call    longitudCadena
            mov     ebx, eax    
            add     esp, 4
            mov     ecx, 0            
        inicio:
            cmp     ecx, ebx            
            jge     terminar
            mov     edx, 0
            mov     dl, [esi + ecx]      
            cmp     edx, '0'
            jl      compararSimbolo
            cmp     edx, '9'
            jg      error
            sub     edx, '0'
            mov     eax, edx            
            jmp     siguienteCaracter
;-----------------------------------------------------------------------
        compararSimbolo:
            push    ecx
            push    ebx
            call    extraerDePila
            mov     edi, eax            
            call    extraerDePila    
            pop     ebx
            pop     ecx          
            cmp     edx, 10
            je      terminar
            cmp     edx, '+'
            je      suma
            cmp     edx, '-'
            je      resta
            cmp     edx, '*'
            je      multiplicacion
            cmp     edx, '/'
            je      division
            jmp     error
        suma: 
            add     eax, edi
            jmp     siguienteCaracter
        resta:
            sub     eax, edi                 
            jmp     siguienteCaracter
        multiplicacion:    
            imul     eax, edi                
            jmp     siguienteCaracter
        division:          
            push    edx                     
            mov     edx, 0
            idiv    edi                    
            pop     edx
;-----------------------------------------------------------------------
        siguienteCaracter:
            push    eax
            push    ecx
            push    edx
            push    eax          
            call    ingresarAPila
            add     esp, 4
            pop     edx
            pop     ecx
            pop     eax
            inc     ecx
            jmp     inicio
        terminar:
            mov     eax, msg2
            call    printStr
            mov     eax, [pila]            
            call    iprintLn           
            jmp     ingresoManual
;-----------------------------------------------------------------------
        error:
            mov     eax, msg4
            call    printStrln
            call    exit
        ingresarAPila:
            enter   0, 0
            push    eax
            push     edx
            mov     eax, [tamanoPila]
            mov     edx, [ebp+8]
            mov     [pila + 4*eax], edx   
            inc     dword [tamanoPila]
            pop     edx
            pop     eax
            leave
            ret
        extraerDePila:
            enter   0, 0            
            dec     dword [tamanoPila]            
            mov     eax, [tamanoPila]
            mov     eax, [pila + 4*eax]     
            leave
            ret             
;-----------------------------------------------------------------------
        longitudCadena:
            enter   0, 0              
            mov     eax, 0            
            mov     ecx, [ebp+8]
        cicloLongitudCadena:
            cmp     byte [ecx], 0       
            je      terminarCiclo    
            inc     eax         
            inc     ecx         
            jmp     cicloLongitudCadena  
        terminarCiclo:
            leave
            ret
