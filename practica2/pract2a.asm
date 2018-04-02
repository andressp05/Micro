;************************************************************************** 
; SBM 2018. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT
CONTADOR DB 0
PARCIAL DW ?
RESULT DB 6 DUP (?) 
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
mov bx, 1234
call printASCII
;interrupcion imprimir
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h
;fin programa interrupcion
MOV AX, 4C00H 
INT 21H

INICIO ENDP 

;impresion ASCII
printASCII PROC
			mov PARCIAL, BX
			mov cx, 10  ;divisor
REPETIR:	mov AX, PARCIAL
			mov DX, 0
			div cx
			add DX, 30H; se añade 30h para caracter ASCII
			push DX ;resto div 
			mov PARCIAL,AX ;cociente div
			inc CONTADOR
			cmp PARCIAL, 0h ;fin divisiones
			jnz REPETIR
			mov bx, 0
;reordenacion sacando de pila los restos y el ultimo cociente 
BUCLEPOP:	pop DX
			mov RESULT[bx], DL
			inc bx
			dec CONTADOR ;condicion de parada
			jnz BUCLEPOP
			mov RESULT[bx], '$'	;caracter fin de cadena
			;preparacion impresion
			mov AX, OFFSET RESULT
			mov DX, SEG RESULT
			ret
printASCII ENDP

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 