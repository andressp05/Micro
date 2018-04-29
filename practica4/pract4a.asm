;************************************************************************** 
; SBM 2018. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE
ORG 256

INICIO: JMP INSTALADOR

infoinput DB "Grupo 2301 Andres y Miguel",13,10
tutorial DB 13,10,"AYUDA EJECUCION: ",13,10
ayudainstalar DB "Instalar Driver: PRACT4A.COM /I",13,10
ayudadesintalar DB "Desinstalar Driver: PRACT4A.COM /D",13,10
ayudainfo DB "Informacion Generica: PRACT4A.COM",13,10
ejecucion DB "Con driver instalado: PRACT4B.EXE",13,10,"$"
instalado DB "Driver instalado",13,10,"$"
desinstalado DB "Driver desinstalado",13,10,"$"
	
RSI PROC FAR
	PUSH BX SI
	CMP AH, 0H
	JZ DET
	CMP AH, 11H
	JZ CO
	CMP AH, 12H
	JZ DE
	JMP FI
DET:
	MOV AX, 1234H
	JMP FI
CO: 
	CALL CODIFICAR
	JMP FI
DE: 
	CALL DESCODIFICAR
FI:
	POP SI BX
	IRET
RSI ENDP


CODIFICAR PROC
	MOV BX, 2
	MOV SI, DX
	BUCLE:
		CMP DS:[SI][BX], BYTE PTR '$' ;mira si es fin de cadena
		jz FIN
		CMP DS:[SI][BX], BYTE PTR 41H ;mira si es menor que A
		JL PASO
		CMP DS:[SI][BX], BYTE PTR 5AH ;mira si es mayor que Z
		JG PASO
		CMP DS:[SI][BX], BYTE PTR 56H ;mira si hace loopback
		JL CODIF
		SUB DS:[SI][BX], BYTE PTR 1AH ;hace loopback
	CODIF:
		ADD DS:[SI][BX], BYTE PTR 5 ;codifica caesar
	PASO:
		INC BX
		JMP BUCLE ;siguiente caracter
		
	FIN:
		RET
CODIFICAR ENDP

DESCODIFICAR PROC
	MOV BX, 2
	MOV SI, DX
	DESBUCLE:
		CMP DS:[SI][BX], BYTE PTR '$' ;mira si es fin de cadena
		jz DESFIN
		CMP DS:[SI][BX], BYTE PTR 41H ;mira si es menor que A
		JL DESPASO
		CMP DS:[SI][BX], BYTE PTR 5AH ;mira si es mayor que Z
		JG DESPASO
		CMP DS:[SI][BX], BYTE PTR 45H ;mira si hace loopback
		JG DESCODIF
		ADD DS:[SI][BX], BYTE PTR 1AH ;hace loopback
	DESCODIF:
		SUB DS:[SI][BX], BYTE PTR 5 ;descodifica caesar
	DESPASO:
		INC BX
		JMP DESBUCLE ;siguiente caracter		
	DESFIN:
		RET
DESCODIFICAR ENDP

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INSTALADOR PROC
	CMP DS:[80H], BYTE PTR 3 ;SI ES 0, ENTONCES NO ES 3. SI NO ES NI 0 NI 3 CONSIDERO ERROR
	JNZ INFO
	CMP DS:[83H], BYTE PTR 'I'
	JZ INSTALAR
	CMP DS:[83H], BYTE PTR 'D'	
	JZ DESINSTALAR
	JMP SALIR		
	INSTALAR:
		MOV AX, 0
		MOV ES, AX
		MOV AX, OFFSET RSI
		MOV BX, CS
		CLI
		MOV ES:[60H*4], AX
		MOV ES:[60H*4+2], BX
		STI
		MOV DX, offset instalado
		MOV AH, 9h
		INT 21h	
		MOV DX, OFFSET INSTALADOR
		INT 27H
	DESINSTALAR:
		MOV CX, 0
		MOV DS, CX
		MOV ES, DS:[60H*4+2]
		MOV BX, ES:[2CH]
		MOV AH, 49H
		INT 21H
		MOV ES, BX
		INT 21H
		CLI
		MOV DS:[60H*4], CX
		MOV DS:[60H*4+2], CX
		STI

		MOV DX, offset desinstalado
		MOV CX, CS
		MOV DS, CX
		MOV AH, 9h
		INT 21h	
	SALIR:
		MOV AX, 4C00H 
		INT 21H 	
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
	HECHO:
		MOV DX, offset instalado
		MOV AH, 9h
		INT 21h	
		JMP ESCRIBIR_INFO
	NOINSTALADO:
		MOV DX, offset desinstalado
		MOV AH, 9h
		INT 21h	
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