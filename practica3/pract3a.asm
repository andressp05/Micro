;************************************************************************** 
; SBM 2018. Practica 3 - Fichero 3A
; Funciones: comprobarNumeroSecreto y rellenarIntento
; Andres Salas Peña y Miguel Garcia Moya
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
	; Guardamos en la pila los registros que vamos a usar
	push bx si di

	;Sacamos los datos de la pila
	les bx, [bp + 6] ;numero secreto

	;Proceso comprobarNumeroSecreto
	mov si, 0 ;Primer contador
	BUCLE1:
		mov di, 0 ;Segundo contador
		mov al, es:[bx][si] ;Digito a comparar con los demas
		BUCLE2:	
			cmp si, di ;saltamos la comparacion con el mismo digito
			jz saltar
			cmp al, es:[bx][di] ;Comparacion con los demas digitos
			jz REPEATED ;si es repetido, acabamos el programa
			saltar:
			inc di ;incrementamos el valor del segundo contador
			cmp di, 4 ;si el segundo contador es 4 pasamos al siguiente digito
			jnz BUCLE2 ;si no seguimos con el mismo digito
		inc si ;caso de que se haya comparado un digito con todos los demas
		cmp si, 4 ;si si es 4 hemos acabado de comparar y salimos del bucle
		jnz BUCLE1
	mov ax, 0 ;Si llega aqui es que no hay ninguno repetido, devuelve 0
	jmp FIN
	REPEATED:
	mov ax, 1 ;Si llega aqui es que hay algun repetido , devuelve 1
	FIN:
	pop di si bx bp ;Sacamos todos los datos de la pila usados
	ret ;Volvemos al codigo principal de c
_comprobarNumeroSecreto ENDP

; rellenarIntento
; rellena el array de 4 posiciones intentoDigitos[] con el intento 
; misma idea que en la practica anterior
PUBLIC _rellenarIntento
_rellenarIntento PROC FAR
	;Proceso Far
	push bp 
	mov bp, sp
	;Guardamos en la pila los registros que vamos a usar
	push bx cx ax dx si di

	;Sacamos los datos de la pila
	les bx, [bp + 8] ;intentoDigitos
	mov si, [bp + 6] ;intento
	mov di, 10; divisor
	mov cx, 0 ;contador de divisiones
	;Proceso sacar dígitos
REPETIR:
	;Preparamos la division con sus valores	
	mov ax, si 
	mov dx, 0
	div di	
	push dx ;almacenamos en la pila el resto de la division 
	mov si, ax ; el cociente de la division sera el siguiente numero a dividir
	inc cx ;incrementamos el numero de divisiones realizadas
	cmp cx, 4h ;si ya hemos realizado las cuatro divisiones, termina de dividir
	jnz REPETIR ;si no, repetimos
	mov si, 0 ;usamos si como contador para guardar en la posicion correcta

;reordenacion sacando de pila los restos y el ultimo cociente 
BUCLEPOP:	
	pop dx ;sacamos el primero de los elementos de la pila
	mov es:[bx][si], DL ;lo almacenamos en el lugar que cogera el codigo ppal
	inc si ;incrementos el contador para guardar en la posicion correcta
	dec cx ;condicion de parada, si ya se han sacado los 4 elementos
	jnz BUCLEPOP ;continuamos sacando elementos
	;tras terminar de sacar elementos, sacamos todos los datos de la pila usados
	pop di si dx ax cx bx bp
	ret ;Volvemos al codigo principal de c
_rellenarIntento ENDP

; FIN DEL SEGMENTO DE CODIGO 
PRACT3A ENDS 
; FIN DEL PROGRAMA
END

