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
	push bx si di

	;Sacamos los datos de la pila
	les bx, [bp + 6]

	;Proceso comprobarNumeroSecreto
	mov si, 0 ;Primer contador
	BUCLE1:
		mov di, 0 ;Segundo contador
		mov al, es:[bx][si] ;Digito a comparar con los demas
		BUCLE2:	
			cmp si, di ;saltamos la comparacion con el mismo
			jz saltar
			cmp al, es:[bx][di] ;Demas digitos
			jz REPEATED ;repetido
			saltar:
			inc di
			cmp di, 4
			jnz BUCLE2
		inc si
		cmp si, 4
		jnz BUCLE1
	mov ax, 0 ;Si llega aquí es que no hay ninguno repetido
	jmp FIN
	REPEATED:
	mov ax, 1 ;Devuelve 1
	FIN:
	pop di si bx bp
	ret
_comprobarNumeroSecreto ENDP

; rellenarIntento
PUBLIC _rellenarIntento
_rellenarIntento PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	push bx cx ax dx si di
	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov si, [bp + 6] ;intento
	mov di, 10; divisor
	mov cx, 0
	;Proceso sacar dígitos
REPETIR:	
	mov ax, si
	mov dx, 0
	div di	
	push dx ;resto div 
	mov si, ax;cociente div
	inc cx
	cmp cx, 4h ;fin divisiones
	jnz REPETIR
	mov si, 0
;reordenacion sacando de pila los restos y el ultimo cociente 
BUCLEPOP:	
	pop dx
	mov es:[bx][si], DL
	inc si
	dec cx ;condicion de parada
	jnz BUCLEPOP
	pop di si dx ax cx bx bp
	ret
_rellenarIntento ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3A ENDS 
; FIN DEL PROGRAMA
END

