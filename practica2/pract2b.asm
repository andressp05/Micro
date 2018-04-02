;************************************************************************** 
; SBM 2018. ESTRUCTURA B?SICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andr?s Salas Pe?a y Miguel Garc?a Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
	;Matriz generatriz
	GenerateMatrix db 1,0,0,0,1,1,0,0,1,0,0,1,0,1,0,0,1,0,0,1,1,0,0,0,1,1,1,1
    ;Datos para impresion con sus fin de cadena adecuados
    input db "Input: $"
    palabra db 1,0,1,1
    fin1 db 13,10,'$'
    output db "Output: $"
    result db 7 dup (0)
    fin2 db 13,10,'$'
    computation db "Computation: "
    ;; Resultados iniciales que se modifican en el proceso print
    cabecera db 10,"      | P1 | P2 | D1 | P4 | D2 | D3 | D4"
    datospalabra db 10," WORD | ?  | ?  |  ",1," | ?  |  ",1," |  ",1," |  ",1
    datosparidad1 db 10, " P1   | ",1,"  |    |  ",1," |    |  ",1," |    |  ",1
    datosparidad2 db 10, " P2   |    | ",1,"  |  ",1," |    |    |  ",1," |  ",1
    datosparidad4 db 10, " P4   |    |    |    | ",1,"  |  ",1," |  ",1," |  ",1
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
MOV ES, DX
MOV AX, WORD PTR palabra[0]
MOV CX, WORD PTR palabra[2]
mov ES:[bx], AX
mov ES:[bx]+2, CX
call multmod
;ponemos los bits de paridad en la posicion correcta
mov bx, 0
mov al, result[bx] ;d1 en ax
mov bx, 2
xchg result[bx], al ;d1 en posicion 3, d3 en ax
mov bx, 5
xchg result[bx], al ;d3 en posicion 6, p2 en ax
mov bx, 1
xchg result[bx], al ;p2 en posicion 2, d2 en ax
mov bx, 4
xchg result[bx], al ;d2 en posicion 5, p1 en ax
mov bx, 0
mov result[bx], al ;p1 en posicion 1
mov bx, 3
mov al, result[bx] ;d4 en ax
mov bx, 6
xchg result[bx], al ;d4 en posicion 7, p3 en ax
mov bx, 3
mov result[bx], al ;p3 en posicion 4
call print

; FIN DEL PROGRAMA 
MOV AX, 4C00H 
INT 21H 
INICIO ENDP

;multiplicacion y modulo 2
MULTMOD PROC
mov es, dx
mov bp, 0     ;indice de columna
;bucle2 recorre columna a columna la matriz y calcula el modulo 2
bucle2: mov cx, 0;indice de multiplicacion
	;bucle1 recorre una columna de la matriz generatriz, lleva la suma de la columna
	bucle1: 
        ;obtengo el indice del elemento de la matriz
        mov al, 7h
        mul cl 
        mov si, ax
        ;obtengo el elemento de la matriz
        mov al, GenerateMatrix[si][bp]
        ;multiplico por el elemento de la palabra
        mov si, cx
        mul BYTE PTR ES:[BX][SI]
        ;anyado el resultado en el indice de columna
        add RESULT[bp], AL
        ;aumento el indice de multiplicacion y comparo con 3
        inc cx
        cmp cx, 4h; condicion parada bucle1
        jnz bucle1
        ;calcula el modulo 2
        mov al, RESULT[bp]
        mov dl, 2h
        div dl
        mov RESULT[bp], ah
        ;aumento el indice de columna y comparo con 7
        inc bp
        cmp bp, 7h ;condicion parada bucle2
        jnz bucle2
	;devolucion resultados
	mov dx, seg result
	mov ax, offset result
	ret
MULTMOD ENDP

;parseo impresion
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
bucleinput: MOV AL, palabra[bx]
			add AL, 30h
			mov palabra[bx], AL
			inc bx
			cmp bx, 4h
			jnz bucleinput
;no hace falta poner 13,10,'$' porque ya esta definido en el segmento de datos en fin1
MOV AX, offset palabra
MOV DX, seg palabra
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

;escribimos en las posiciones adecuadas de la matriz de computacion los resultados
MOV BX, 0
MOV AL, palabra[BX]
MOV BX, 20
MOV datospalabra[BX], AL
MOV BX, 1
MOV AL, palabra[BX]
MOV BX, 30
MOV datospalabra[BX], AL
MOV BX, 2
MOV AL, palabra[BX]
MOV BX, 35
MOV datospalabra[BX], AL
MOV BX, 3
MOV AL, palabra[BX]
MOV BX, 40
MOV datospalabra[BX], AL

MOV BX, 0
MOV AL, result[BX]
MOV BX, 9
MOV datosparidad1[BX], AL
MOV BX, 2
MOV AL, result[BX]
MOV BX, 20
MOV datosparidad1[BX], AL
MOV BX, 4
MOV AL, result[BX]
MOV BX, 30
MOV datosparidad1[BX], AL
MOV BX, 6
MOV AL, result[BX]
MOV BX, 40
MOV datosparidad1[BX], AL

MOV BX, 1
MOV AL, result[BX]
MOV BX, 14
MOV datosparidad2[BX], AL
MOV BX, 2
MOV AL, result[BX]
MOV BX, 20
MOV datosparidad2[BX], AL
MOV BX, 5
MOV AL, result[BX]
MOV BX, 35
MOV datosparidad2[BX], AL
MOV BX, 6
MOV AL, result[BX]
MOV BX, 40
MOV datosparidad2[BX], AL

MOV BX, 3
MOV AL, result[BX]
MOV BX, 24
MOV datosparidad4[BX], AL
MOV BX, 4
MOV AL, result[BX]
MOV BX, 30
MOV datosparidad4[BX], AL
MOV BX, 5
MOV AL, result[BX]
MOV BX, 35
MOV datosparidad4[BX], AL
MOV BX, 6
MOV AL, result[BX]
MOV BX, 40
MOV datosparidad4[BX], AL

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