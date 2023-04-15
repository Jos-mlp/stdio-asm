; Calculadora RPN por parametros
; autor: Josue Maldonado

; Recibe parametros por consola
; Ejemplo: 
; ./calculadora 2 2 +
; ./calculadora 2 2 -
; ./calculadora 2 2 /
; ./calculadora 2 2 x


%include 'stdio32.asm'
SECTION .data
    msg1      db "Error con caracer", 0h	;Definimos cadenas
    msg2      db "Error con el  numero: ", 0h
    msg3      db "Expresion RPN No reconocida", 0h

    msgRes db 'RESULTADO:' , 0h
	

SECTION .bss
    userInput resw 500
    opt: resb    50 


SECTION .text
global _start

%macro preOp 0
    cmp    ecx, 2
    jl     .expresionInvalida

    dec    ecx
    mov    esi, [userInput + ecx * 4]
    dec    ecx
    mov    eax, [userInput + ecx * 4]
%endmacro

%macro postOp 0
    
    mov    [userInput + ecx * 4], eax
    inc    ecx
    jmp    .endloop
%endmacro

_start:

;-------------------------INICIO DE LA CALCULADORA RPN----------    
.inicio:

    mov    ebp, esp
    xor    ecx, ecx      
    mov    ebx, 2        
;--------------------CICLO DE COMPARACIONES-------------
.main:
    mov    eax, [ebp + ebx * 4]

    
    cmp    byte [eax + 1], 0
    jnz    .convertirNumero


    cmp    byte [eax], 43          ; "+"
    je     .suma
    cmp    byte [eax], 45          ; "-" 
    je     .resta
    cmp    byte [eax], 47          ; "/"
    je     .dividir          
    cmp    byte [eax], 120         ; "x"
    je     .multiplicar        
    cmp    byte [eax], 48          ; "0"
    jl     .fallo
    cmp    byte [eax], 57          ; "9"
    jg     .fallo
    
;-------------ATOI-------------
;convertirAnumero
.convertirNumero:
    
    xor    edi, edi
    call   atoi
    cmp    edi, 1
    je     .numError

    mov    [userInput + ecx * 4], eax
    inc    ecx

.endloop:
    inc    ebx

    cmp    ebx, [ebp]
    jle    .main

    jmp    .finalizado
    
;-------------------OPERACIONES DE LA CALCULADORA----------------
.suma:
    preOp
    add    eax, esi
    postOp

.resta:
    preOp
    sub    eax, esi
    postOp

.multiplicar:
    preOp
    imul   eax, esi
    postOp

.dividir:
    preOp
    div    si
    postOp

.numError:
    mov    eax, msg2
    call   printStr
    mov    eax, [ebp + ebx * 4]
    call   printStrln
    jmp    .fin

.fallo: 
   
    push   eax
    mov    eax, msg1
    call   printStr

    pop    esi
    mov    eax, [esi]
    call   putchar
    call   newline
    jmp    .fin

.expresionInvalida:
    mov    eax, msg3
    call   printStrln
    jmp    .fin

.finalizado:
    
    cmp    ecx, 1
    jne    .expresionInvalida

    mov    eax,msgRes
    call    printStrln
    
    
;-------------IMPRIMIR RESULTADO---------
    sub    ecx, 1
    mov    eax, [userInput + ecx * 4]
    mov    ebx,eax
    call   iprintLn
    push    ebx
    


.fin:
    call   exit
