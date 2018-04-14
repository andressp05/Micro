;************************************************************************** 
; SBM 2018. Practica 3 - Fichero 3b
; Funciones: calcularAciertos y calcularSemiAciertos
; Andres Salas Peña y Miguel Garcia Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
PRACT3B SEGMENT BYTE PUBLIC 'CODE' 
ASSUME CS: PRACT3B

; calcularAciertos
; devuelve el numero de aciertos del intento
; un acierto es el mismo numero y misma posicion que el numero secreto
PUBLIC _calcularAciertos
_calcularAciertos PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	;Guardamos en la pila los registros que vamos a usar
	push bx cx si di

	;Sacamos los datos de la pila
	les di, [bp + 10] ;intentoDigitos
	mov si, [bp + 6] ;numSecreto
	mov cx, 0 ;Contador de aciertos

	mov bx, 0 ;Contador del bucle
	BUCLE:
		mov al, es:[si][bx] ;Digito del numero secreto
		cmp al, es:[di][bx] ;Digito del intento
		jnz NO_ACIERTO ;Comparamos, si no acierta salta
		inc cx ;incrementamos el contador de aciertos
		NO_ACIERTO:
		inc bx ;incrementamos el numero de digitos comparados
		cmp bx, 4 ;si ya hemos comparado los 4, finaliza el bucle
		jnz BUCLE
	
	;Retornamos el numero de Aciertos por ax	
	mov ax, cx 
	pop di si cx bx bp ;Sacamos todos los datos de la pila usados
	ret ;Volvemos al codigo principal de c
_calcularAciertos ENDP

; calcularSemiAciertos
; devuelve el numero de semiaciertos del intento
; un semiacierto es mismo numero pero distinta posicion que el numero secreto
PUBLIC _calcularSemiaciertos
_calcularSemiaciertos PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	;Guardamos en la pila los registros que vamos a usar
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
			jz saltar ;si son el mismo valor, saltamos al siguiente valor de bp
			cmp al, es:[di][bp] ;Comparacion con los demas digitos
			jz COINCIDENCIA ;detenemos el bucle e incrementamos los semiaciertos
			saltar:
			inc bp ;pasamos a la comparacion con el siguiente digito distinto
			cmp bp, 4 ;si es cuatro, hemos finalizado con el bucle interno
			jnz BUCLE2
			jmp NO_COINCIDENCIA ;fin bucle interno sin incrementar semiaciertos
			
		COINCIDENCIA:
		inc cx ;si hubo coincidencia incrementamos el numero de semiaciertos
		NO_COINCIDENCIA:
		inc si ;comparamos el siguiente digito con los demas
		cmp si, 4 ;si es 4, hemos finalizado
		jnz BUCLE1
		
	mov ax, cx ;Retornamos el numero de Aciertos
	pop di si cx bx bp ;sacamos todos los datos de la pila usados
	ret ;Volvemos al codigo principal de C
_calcularSemiaciertos ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3B ENDS 
; FIN DEL PROGRAMA
END