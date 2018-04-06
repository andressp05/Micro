;************************************************************************** 
; SBM 2018. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO
PRACT3A SEGMENT BYTE PUBLIC 'CODE'
ASSUME CS: PRACT3A

; comprobarNumeroSecreto
; suponemos que la entrada es un array de cuatro posiciones
; devuelve 1 si contiene algún dígito repetido, 0 en caso contrario
PUBLIC _comprobarNumeroSecreto
_comprobarNumeroSecreto PROC FAR
	;Proceso Far
	push bp
	mov bp, sp

	;Sacamos los datos de la pila
	les bx, [bp + 6]

	;Proceso comprobarNumeroSecreto
	mov ax, [bx] ;Metemos el primer numero en AX
	cmp ax, [bx]+1 ;Lo comparamos con el segundo
	jz REPEATED ;Salta si el primero y el segundo son iguales
	cmp ax, [bx]+2 ;Mismo proceso
	jz REPEATED
	cmp ax, [bx]+3
	jz REPEATED
	mov ax, [bx]+1 ;Metemos el segundo numero
	cmp ax, [bx]+2
	jz REPEATED
	cmp ax, [bx]+3
	jz REPEATED
	mov ax, [bx]+2 ;Metemos el tercero
	cmp ax, [bx]+3
	jz REPEATED
	mov ax, 0 ;Si llega aquí es que no hay ninguno repetido
	ret

;Devolver 1
REPEATED:
	mov ax, 1
	ret
_comprobarNumeroSecreto ENDP

; rellenarIntento
PUBLIC _rellenarIntento
_rellenarIntento PROC FAR
	;Proceso Far
	push bp
	mov bp, sp

	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov cx, [bp + 6] ;intento
	mov di, 10; divisor
	;Proceso sacar dígitos
REPETIR:	
	mov AX, CX
	mov DX, 0
	div di	
	push DX ;resto div 
	mov CX,AX;cociente div
	inc SI
	cmp SI, 4h ;fin divisiones
	jnz REPETIR
	mov CX, 0
;reordenacion sacando de pila los restos y el ultimo cociente 
BUCLEPOP:	
	pop DX
	mov [bx][si], DL
	inc bx
	dec SI ;condicion de parada
	jnz BUCLEPOP
	mov DH, [bx]
	mov DL, [bx]+1
	mov AH, [bx]+2
	mov AH, [bx]+3
	ret
_rellenarIntento ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3A ENDS 
; FIN DEL PROGRAMA
END
