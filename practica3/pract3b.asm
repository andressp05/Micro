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
	push bx di si dx 

	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov di, [bp + 6] ;numSecreto
	mov si, 0

	;Proceso comprobarNumeroSecreto
	mov ax, es:[bx] ;Metemos el primer digito de intentoDigitos
	mov dx, [di] ;Metemos el primer digito de numSecreto
	cmp ax, dx ;Comparamos los digitos
	jnz SEGUNDO 
	inc si ;Incrementamos contador si son iguales
SEGUNDO:
	;Hacemos lo mismo con el segundo dígito
	mov ax, es:[bx]+1
	mov dx, [di]+1
	cmp ax, dx
	jnz TERCERO 
	inc si
TERCERO:
	;Hacemos lo mismo con el tercer dígito
	mov ax, es:[bx]+2
	mov dx, [di]+2
	cmp ax, dx
	jnz CUARTO
	inc si 
CUARTO:
	;Hacemos lo mismo con el cuarto dígito
	mov ax, es:[bx]+3
	mov dx, [di]+3
	cmp ax, dx
	jnz FIN
	inc si
FIN:	
	mov ax, si ;Retornamos el numero de Aciertos
	pop dx si di bx bp
	ret

_calcularAciertos ENDP

; calcularSemiAciertos
PUBLIC _calcularSemiaciertos
_calcularSemiaciertos PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	push bx di si dx
	
	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov di, [bp + 6] ;numSecreto
	mov si, 0

	;Proceso comprobarNumeroSecreto
	mov ax, es:[bx] ;Metemos el primer digito de intentoDigitos
	mov dx, [di]+1 ;Metemos el primer digito de numSecreto
	cmp ax, dx ;Comparamos los digitos
	jz COINCIDENCIA1
	cmp ax, [di]+2
	jz COINCIDENCIA1
	cmp ax, [di]+3
	jnz COMPARACION2 
COINCIDENCIA1:	
	inc si ;Incrementamos contador si son iguales
COMPARACION2:
	;Hacemos lo mismo con el segundo dígito
	mov ax, es:[bx]+1
	mov dx, [di]
	cmp ax, dx
	jz COINCIDENCIA2
	cmp ax, [di]+2
	jz COINCIDENCIA2
	cmp ax, [di]+3
	jnz COMPARACION3
COINCIDENCIA2:
	inc si
COMPARACION3:
	;Hacemos lo mismo con el tercer dígito
	mov ax, es:[bx]+2
	mov dx, [di]
	cmp ax, dx
	jz COINCIDENCIA3
	cmp ax, [di]+1
	jz COINCIDENCIA3
	cmp ax, [di]+3
	jnz COMPARACION4
COINCIDENCIA3:
	inc si 
COMPARACION4:
	;Hacemos lo mismo con el cuarto dígito
	mov ax, es:[bx]+3
	mov dx, [di]
	cmp ax, dx
	jz COINCIDENCIA4
	cmp ax, [di]+1
	jz COINCIDENCIA4
	cmp ax, [di]+2
	jnz FINAL
COINCIDENCIA4:
	inc si
FINAL:	
	mov ax, si ;Retornamos el numero de Aciertos
	pop dx si di bx bp
	ret
_calcularSemiaciertos ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3B ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END