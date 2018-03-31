;************************************************************************** 
; SBM 2018. ESTRUCTURA B?SICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andr?s Salas Pe?a y Miguel Garc?a Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
    MSGINPUT DB "Introduzca numero del 1 al 15: "
    USERINPUT DB ?
    FIN DB 10,'$'
    PARCIAL DB ?
	GenerateMatrix db 1,1,1,0,0,0,0,1,0,0,1,1,0,0,0,1,0,1,0,1,0,1,1,0,1,0,0,1
	inputseg dw ?
	input db "Input: $"
	DATO DB 4 dup (0)
	fin1 db 13,10,'$'
	output db "Output: $"
	RESULT DB 7 dup (?)
    fin2 db 13,10,'$'
    computation db "Computation: "
    cabecera db 10,"      | P1 | P2 | D1 | P4 | D2 | D3 | D4"
    datospalabra db 10," WORD | ?  | ?  | !! | ?  | !! | !! | !!"
    datosparidad1 db 10, " P1   | !! |    | !! |    | !! |    | !!"
    datosparidad2 db 10, " P2   |    | !! | !! |    |    | !! | !!"
    datosparidad4 db 10, " P4   |    |    |    | !! | !! | !! | !!"
    fin3 db 10,'$'
DATOS ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicializaci?n, 64 bytes inicializados a 0 
PILA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO EXTRA 
EXTRA SEGMENT 
EXTRA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA 
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INICIO PROC 
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS 
MOV DS, AX 
MOV AX, PILA 
MOV SS, AX 
MOV AX, EXTRA 
MOV ES, AX 
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 
; FIN DE LAS INICIALIZACIONES 
; COMIENZO DEL PROGRAMA 
MOV AX, offset msginput
MOV DX, seg msginput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

MOV AH,0AH 
MOV DX,OFFSET userinput 
MOV userinput[0], 6 ; 6 caracteres maximo
INT 21H

mov bx, 0
cmp userinput[1], 1 ; compruebo si se ha introducido 1 caracter o 2
jz uno

;suma la cifra de unidades
mov bl, userinput[3] 
sub bl, 30h
;tomo la cifra de decenas
mov cl, userinput[2] 
sub cx, 30h
;multiplico la cifra de decenas por 10
mov ah, 0
mov al, 10
mul cl
;anyado la cifra de decenas por 10 a la cifra de unidades para obtener el numero total
add bx, ax
jmp seguir

; si no hay cifra de decenas la cifra de unidades es la primera
uno: mov bl, userinput[2]
	sub bl, 30h
	
seguir:
call obtenerVector ;construye el vector binario a partir del numero obtenido
mov dx, seg dato
mov bx, offset dato
call multmod
call print

MOV AX, 4C00H 
INT 21H 
INICIO ENDP

obtenerVector PROC
			mov PARCIAL, BL
			mov cl, 2  ; Base 2: binario
			mov bx, 3 ;Asegura que los restos se guarden en orden ascendente de significatividad
REPETIR:	mov AL, PARCIAL
			mov ah, 0
			div cl
			mov DATO[bx], AH ;Resto
			mov PARCIAL,AL ;Cociente
			DEC BX
			cmp PARCIAL, 0h
			jnz REPETIR
			mov AX, OFFSET DATO
			mov DX, SEG DATO
			ret
obtenerVector ENDP

MULTMOD PROC
	mov inputseg, dx
    mov bp, 0     ;indice de columna
bucle2: mov cx, 0 ;indice de multiplicacion
bucle1: 
        ;obtengo el indice del elemento de la matriz
        mov al, 7h
        mul cl 
        mov si, ax
        ;obtengo el elemento de la matriz
        mov AL, GenerateMatrix[si][bp]
        ;multiplico por el elemento de la palabra
        mov si, cx
        mov es, dx
        mul BYTE PTR ES:[BX][SI]+0
        ;a?ado al resultado en el indice de columna
        add RESULT[bp], AL
        ;aumento el indice de multiplicacion y comparo si es menor que 4
        inc cx
        cmp cx, 4h
        jnz bucle1
        ;calcula el modulo 2
        mov al, RESULT[bp]
        mov dl, 2h
        div dl
		mov dx, inputseg
        mov RESULT[bp], ah
        ;aumento el indice de columna y comparo si es menor que 7
        inc bp
        cmp bp, 7h
        jnz bucle2
	mov dx, seg result
	mov ax, offset result
	ret
MULTMOD ENDP

PRINT PROC

; imprimo la cadena de input
MOV AX, offset input
MOV DX, seg input
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; imprimo el input
mov bx, 0
bucleinput: MOV AL, dato[bx]
			add AL, 30h
			mov dato[bx], AL
			inc bx
			cmp bx, 4h
			jnz bucleinput
;no hace falta poner 13,10,'$' porque ya esta definido en el segmento de datos en fin1
MOV AX, offset dato
MOV DX, seg dato
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; imprimo la cadena de output
MOV AX, offset output
MOV DX, seg output
MOV DS, DX
MOV DX, AX
MOV AH, 9h
int 21H

; imprimo el output
mov bx, 0
bucleoutput: MOV AL, result[bx]
			add AL, 30h
			mov result[bx], AL
			inc bx
			cmp bx, 7h
			jnz bucleoutput
;no hace falta poner 13,10,'$' porque ya esta definido en el segmento de datos en fin2
MOV AX, offset result
MOV DX, seg result
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; imprimo la cadena de computacion
MOV AX, offset computation
MOV DX, seg computation
MOV DS, DX
MOV DX, AX
MOV AH, 9h
int 21H
ret

PRINT ENDP

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 