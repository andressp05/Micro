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
; devuelve 1124 si contiene algún dígito repetido, 0 en caso contrario
PUBLIC _comprobarNumeroSecreto
_comprobarNumeroSecreto PROC FAR
	;Proceso Far
	push bp
	mov bp, sp
	push bx

	;Sacamos los datos de la pila
	les bx, [bp + 6]

	;Proceso comprobarNumeroSecreto
	mov al, es:[bx] ;Metemos el primer numero en AX
	cmp al, es:[bx]+1 ;Lo comparamos con el segundo
	jz REPEATED ;Salta si el primero y el segundo son iguales
	cmp al, es:[bx]+2 ;Mismo proceso
	jz REPEATED
	cmp al, es:[bx]+3
	jz REPEATED
	mov al, es:[bx]+1 ;Metemos el segundo numero
	cmp al, es:[bx]+2
	jz REPEATED
	cmp al, es:[bx]+3
	jz REPEATED
	mov al, es:[bx]+2 ;Metemos el tercero
	cmp al, es:[bx]+3
	jz REPEATED
	mov ax, 0 ;Si llega aquí es que no hay ninguno repetido
	pop bx bp
	ret

;Devolver 1
REPEATED:
	mov ax, 1
	pop bx bp
	ret
_comprobarNumeroSecreto ENDP

; rellenarIntento
PUBLIC _rellenarIntento
_rellenarIntento PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	push bx cx di ax dx si
	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov cx, [bp + 6] ;intento
	mov di, 10; divisor
	mov si, 0
	;Proceso sacar dígitos
REPETIR:	
	mov ax, cx
	mov dx, 0
	div di	
	push dx ;resto div 
	mov cx,ax;cociente div
	inc si
	cmp si, 4h ;fin divisiones
	jnz REPETIR
	dec bx ;como si es 4 esto hace que [bx][si] sea como si SI fuera 3
;reordenacion sacando de pila los restos y el ultimo cociente 
BUCLEPOP:	
	pop dx
	mov es:[bx][si], DL
	dec si ;condicion de parada
	jnz BUCLEPOP
	pop si dx ax di cx bx bp
	ret
_rellenarIntento ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3A ENDS 
; FIN DEL PROGRAMA
END

