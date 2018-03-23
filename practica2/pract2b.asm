;************************************************************************** 
; SBM 2015. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
	GenerateMatrix db 1,0,0,0,1,1,0,0,1,0,0,1,0,1,0,0,1,0,0,1,1,0,0,0,1,1,1,1
	palabra db 1,0,1,1
	result db 7 dup (0)
	input db "Input: "
DATOS ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0 
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
call print
;MOV ES, DX
;MOV AX, WORD PTR palabra[0]
;MOV CX, WORD PTR palabra[2]
;mov ES:[bx], AX
;mov ES:[bx]+2, CX

; FIN DEL PROGRAMA 
MOV AX, 4C00H 
INT 21H 
INICIO ENDP
MULTMOD PROC
	mov bp, 0     ;indice de columna
bucle2: mov cx, 0 ;indice de multiplicacion
bucle1:	
		;multiplico el indice de multiplicacion por el n de elementos de una fila
		mov al, 7h
		mul cl 
		mov si, ax
		;obtengo el elemento de la matriz
		mov AL, GenerateMatrix[si][bp]
		;multiplico por el elemento de la palabra
		mov si, cx
		mov es, dx
		mul BYTE PTR ES:[BX][SI]+0
		;añado al resultado en el indice de columna
		add RESULT[bp], AL
		;aumento el indice de multiplicacion y comparo con 3
		inc cx
		cmp cx, 3h
		jnz bucle1
		;calcula el modulo 2
		mov al, RESULT[bp]
		mov si, 2h
		div si
		mov RESULT[bp], ah
		;aumento el indice de columna y comparo con 7
		inc bp
		cmp bp, 6h
		jnz bucle2
MULTMOD ENDP
PRINT PROC

MOV AX, offset input
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

PRINT ENDP
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 