;************************************************************************** 
; SBM 2015. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados 
DATOS ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0 
PILA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO EXTRA 
EXTRA SEGMENT 
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES) 
EXTRA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA 
ORG 256

INICIO: JMP MAIN

RSI PROC FAR
PUSH BX SI
CMP AH, 11H
JZ CO
CMP AH, 12H
JZ DE
JMP FI

CO: CALL CODIFICAR
JMP FI
DE: CALL DESCODIFICAR

FI:
POP SI BX
IRET
RSI ENDP


CODIFICAR PROC
MOV BX, 2
MOV SI, DX
BUCLE:
	CMP DS:[SI][BX], '$' ;mira si es fin de cadena
	jz FIN
	CMP DS:[SI][BX], 41H ;mira si es menor que A
	JL PASO
	CMP DS:[SI][BX], 5AH ;mira si es mayor que Z
	JG PASO
	CMP DS:[SI][BX], 56H ;mira si hace loopback
	JL CODIF
	SUB DS:[SI][BX], 1AH ;hace loopback
CODIF:
	ADD DS:[SI][BX], 5 ;codifica caesar
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
	CMP DS:[SI][BX], '$' ;mira si es fin de cadena
	jz DESFIN
	CMP DS:[SI][BX], 41H ;mira si es menor que A
	JL DESPASO
	CMP DS:[SI][BX], 5AH ;mira si es mayor que Z
	JG DESPASO
	CMP DS:[SI][BX], 45H ;mira si hace loopback
	JG DESCODIF
	ADD DS:[SI][BX], 1AH ;hace loopback
DESCODIF:
	SUB DS:[SI][BX], 5 ;descodifica caesar
DESPASO:
	INC BX
	JMP DESBUCLE ;siguiente caracter
	
DESFIN:
	RET
DESCODIFICAR ENDP

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
MAIN PROC
	CMP [80H], 3 ;SI ES 0, ENTONCES NO ES 3. SI NO ES NI 0 NI 3 CONSIDERO ERROR
	JNZ INFO
	CMP [83H], 'I'
	JZ INSTALAR
	CMP [83H], 'D'
	JZ DESINSTALAR
	JMP SALIR
	
INSTALAR:
	MOV AX, 0
	MOV ES, AX
	MOV AX, OFFSET RSI
	MOV BX, CS
	CLI
	MOV ES:[60H*4], AX
	MOV ES:[60H-4+2], BX
	STI
	MOV DX, OFFSET INSTALADOR
	INT 27H
	
DESINSTALAR:
;WHATEVER
	
	SALIR:
	MOV AX, 4C00H 
	INT 21H 
	
INFO:
	;IMprimir informcion y blabla
	
MAIN ENDP
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 