;************************************************************************** 
; SBM 2018. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
PRACT3B SEGMENT BYTE PUBLIC 'CODE' 
ASSUME CS: PRACT3B
; calcularAciertos
PUBLIC _calcularAciertos
_calcularAciertos PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	push bx cx si di

	;Sacamos los datos de la pila
	les di, [bp + 10] ;intentoDigitos
	mov si, [bp + 6] ;numSecreto
	mov cx, 0 ;Contador de aciertos

	mov bx, 0 ;Contador del bucle
	BUCLE:
		mov al, es:[si][bx] ;Digito del numero secreto
		cmp al, es:[di][bx] ;Digito del intento
		jnz NO_ACIERTO 
		inc cx ;incrementamos el contador de aciertos
		NO_ACIERTO:
		inc bx
		cmp bx, 4
		jnz BUCLE
		
	mov ax, cx ;Retornamos el numero de Aciertos
	pop di si cx bx bp
	ret

_calcularAciertos ENDP

; calcularSemiAciertos
PUBLIC _calcularSemiaciertos
_calcularSemiaciertos PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	push bx cx si di
	
	;Sacamos los datos de la pila
	les bx, [bp + 10] ;intentoDigitos
	mov di, [bp + 6] ;numSecreto
	mov cx, 0 ;Contador de semiaciertos

	mov si, 0 ;Primer contador
	BUCLE1:
		mov bp, 0 ;Segundo contador
		mov al, es:[bx][si] ;Digito a comparar con los demas
		BUCLE2:	
			cmp si, bp ;evitamos contar aciertos como semiaciertos
			jz saltar
			cmp al, es:[di][bp] ;Demas digitos
			jz COINCIDENCIA ;detenemos el bucle e incrementamos el contador de semiaciertos
			saltar:
			inc bp
			cmp bp, 4
			jnz BUCLE2
			jmp NO_COINCIDENCIA ;acaba el bucle: no incrementamos el contador de semiaciertos
			
		COINCIDENCIA:
		inc cx
		NO_COINCIDENCIA:
		inc si
		cmp si, 4
		jnz BUCLE1
		
	mov ax, cx ;Retornamos el numero de Aciertos
	pop di si cx bx bp
	ret
_calcularSemiaciertos ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3B ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END