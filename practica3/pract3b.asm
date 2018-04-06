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

	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov cx, [bp + 6] ;numSecreto
	mov si, 0

	;Proceso comprobarNumeroSecreto
	mov ax, [bx] ;Metemos el primer digito de intentoDigitos
	mov dx, [cx] ;Metemos el primer digito de numSecreto
	cmp ax, dx ;Comparamos los digitos
	jnz SEGUNDO 
	inc si ;Incrementamos contador si son iguales
SEGUNDO:
	;Hacemos lo mismo con el segundo dígito
	mov ax, [bx]+1
	mov dx, [cx]+1
	cmp ax, dx
	jnz TERCERO 
	inc si
TERCERO:
	;Hacemos lo mismo con el tercer dígito
	mov ax, [bx]+2
	mov dx, [cx]+2
	cmp ax, dx
	jnz CUARTO
	inc si 
CUARTO:
	;Hacemos lo mismo con el cuarto dígito
	mov ax, [bx]+3
	mov dx, [cx]+3
	cmp ax, dx
	jnz FIN
	inc si
FIN:	
	mov ax, si ;Retornamos el numero de Aciertos
	ret

_calcularAciertos ENDP

; calcularSemiAciertos
PUBLIC _calcularSemiAciertos
_calcularSemiAciertos PROC FAR

_calcularSemiAciertos ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3B ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END