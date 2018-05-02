;************************************************************************** 
; SBM 2018. ESTRUCTURA BASICA DE UN PROGRAMA EN ENSAMBLADOR
; Andres Salas Peña y Miguel Garcia Moya
; Pareja 02 Grupo 2301 -- Practica 4, Apartado A
;************************************************************************** 

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE
ORG 256

INICIO: JMP INSTALADOR

;Inicializacion Mensajes a Imprimir
infoinput DB "Grupo 2301 Andres y Miguel",13,10
tutorial DB 13,10,"AYUDA EJECUCION: ",13,10
ayudainstalar DB "Instalar Driver: PRACT4A.COM /I",13,10
ayudadesintalar DB "Desinstalar Driver: PRACT4A.COM /D",13,10
ayudainfo DB "Informacion Generica: PRACT4A.COM",13,10
ejecucion DB "Con driver instalado: PRACT4B.EXE",13,10,"$"
instalado DB "Driver instalado",13,10,"$"
desinstalado DB "Driver desinstalado",13,10,"$"
yadesinstalado DB "Driver ya desinstalado",13,10,"$"

; Rutina de servicio a la interrupcion
RSI PROC FAR
	; Salva registros modificados
	PUSH BX SI
	; Instrucciones de la rutina
	CMP AH, 0H ;Comprueba que accedemos nosotros
	JZ DET
	CMP AH, 11H ;Salta a codificar
	JZ CO
	CMP AH, 12H ;Salta a descodificar
	JZ DE
	JMP FI
DET:
	MOV AX, 1234H ;Usado para comprobar que nosotros accedemos
	JMP FI
; Llamada a codificar
CO: 
	CALL CODIFICAR
	JMP FI
; Llamada a descodificar
DE: 
	CALL DESCODIFICAR
; Recupera registros modificados
FI:
	POP SI BX
	IRET
RSI ENDP

; Funcion que codifica segun Caesar teniendo en cuenta solo mayusculas
; el resto de valores los deja como estan
CODIFICAR PROC
	; Los dos primeros bytes indican el tamanyo de la entrada
	MOV BX, 2 ;Nos situamos en el primer valor de la cadena a codificar (en rsi)
	MOV SI, DX
	COD_BUCLE:
		CMP DS:[SI][BX], BYTE PTR '$' ;mira si es fin de cadena
		jz COD_FIN
		CMP DS:[SI][BX], BYTE PTR 41H ;mira si es menor que A
		JL COD_ITERADOR
		CMP DS:[SI][BX], BYTE PTR 5AH ;mira si es mayor que Z
		JG COD_ITERADOR
		; su codificacion pasa la Z
		CMP DS:[SI][BX], BYTE PTR 56H ;mira si hace loopback
		JL CODIF
		; restamos el numero de caracteres del diccionario
		SUB DS:[SI][BX], BYTE PTR 1AH ;hace loopback 
	CODIF:
		ADD DS:[SI][BX], BYTE PTR 5 ;codifica caesar
	COD_ITERADOR:
		INC BX ;siguiente caracter
		JMP COD_BUCLE 		
	COD_FIN:
		RET
CODIFICAR ENDP

; Funcion que descodifica segun Caesar teniendo en cuenta solo mayusculas
; el resto de valores los deja como estan
DESCODIFICAR PROC
	; Los dos primeros bytes indican el tamanyo de la entrada
	MOV BX, 2 ;Nos situamos en el primer valor de la cadena a codificar (en rsi)
	MOV SI, DX
	DES_BUCLE:
		CMP DS:[SI][BX], BYTE PTR '$' ;mira si es fin de cadena
		jz DES_FIN
		CMP DS:[SI][BX], BYTE PTR 41H ;mira si es menor que A
		JL DES_ITERADOR
		CMP DS:[SI][BX], BYTE PTR 5AH ;mira si es mayor que Z
		JG DES_ITERADOR
		; su descodificacion pasa la A
		CMP DS:[SI][BX], BYTE PTR 45H ;mira si hace loopback
		JG DESCODIF
		ADD DS:[SI][BX], BYTE PTR 1AH ;hace loopback
	DESCODIF:
		SUB DS:[SI][BX], BYTE PTR 5 ;descodifica caesar
	DES_ITERADOR:
		INC BX
		JMP DES_BUCLE ;siguiente caracter		
	DES_FIN:
		RET
DESCODIFICAR ENDP

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INSTALADOR PROC
	CMP DS:[80H], BYTE PTR 3 ; Si no es 3, muestra mensaje informacion
	JNZ INFO
	CMP DS:[83H], BYTE PTR 'I' ; Si es 3 y el tercer caracter es I, instalar
	JZ INSTALAR
	CMP DS:[83H], BYTE PTR 'D'	; Si es 3 y el tercer caracter es D, desinstalar
	JZ DESINSTALAR
	JMP INFO ;Si es 3 y no es ni I ni D, muestra ayuda		
	
	; Instalacion de la interrupcion 60h
	INSTALAR:
		MOV AX, 0
		MOV ES, AX
		MOV AX, OFFSET RSI ;Se coloca en RSI
		MOV BX, CS
		CLI
		MOV ES:[60H*4], AX  ; Instala el driver
		MOV ES:[60H*4+2], BX
		STI
		; Impresion por pantalla de instalado
		MOV DX, offset instalado
		MOV AH, 9h
		INT 21h	
		MOV DX, OFFSET INSTALADOR
		INT 27H  ; Acaba y deja residente PSP, variables y rutina rsi. 
	
	; Desinstalacion de la interrupcion 60h
	DESINSTALAR:
		MOV CX, 0
		MOV DS, CX ; Segmento de vectores de interrupcion
		CMP DS:[60H*4], WORD PTR 0H
		JZ YA_DESINSTALADO
		CMP DS:[60H*4+2], WORD PTR 0H
		JZ YA_DESINSTALADO
		MOV ES, DS:[60H*4+2] ; Lee segmento de RSI
		MOV BX, ES:[2CH] ; Lee segmento de entorno del PSP de RSI
		MOV AH, 49H
		INT 21H ; Libera segmento de RSI
		MOV ES, BX
		INT 21H ; Libera segmento de las variables de entorno de RSI
		; Pone a 0 el vector de interrupcion 60h
		CLI
		MOV DS:[60H*4], CX
		MOV DS:[60H*4+2], CX
		STI
		; Impresion por pantalla de desinstalado
		MOV DX, offset desinstalado
		MOV CX, CS
		MOV DS, CX
		MOV AH, 9h
		INT 21h	
	
	; Finalizacion del programa
	SALIR:
		MOV AX, 4C00H 
		INT 21H 	
	
	; Mensaje si ya esta desinstalado
	YA_DESINSTALADO:
		MOV DX, offset yadesinstalado
		MOV CX, CS
		MOV DS, CX
		MOV AH, 9h
		INT 21h	
		JMP SALIR

	; Comprobacion estado de instalacion del driver
	INFO:
		MOV AX, 0
		MOV ES, AX
		CMP ES:[60H*4], WORD PTR 0H
		JZ NOINSTALADO
		CMP ES:[60H*4+2], WORD PTR 0H
		JZ NOINSTALADO
		MOV AH, 0
		INT 60H
		CMP AX, 1234H
		JNZ NOINSTALADO

	; Mensaje Driver Instalado
	HECHO:
		MOV DX, offset instalado
		MOV AH, 9h
		INT 21h	
		JMP ESCRIBIR_INFO

	; Mensaje Driver Desinstalado
	NOINSTALADO:
		MOV DX, offset desinstalado
		MOV AH, 9h
		INT 21h	
	
	; Mensaje Ayuda Ejecucion
	ESCRIBIR_INFO:
		MOV DX, offset infoinput
		MOV AH, 9h
		INT 21h	
		JMP SALIR		
INSTALADOR ENDP
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 