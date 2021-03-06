;************************************************************************** 
; SBM 2018. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301 -- Practica 4, Apartado C
;************************************************************************** 

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT
OFFSET_O DW 0 ; Vector original de la INT 70H
SEGMEN_O DW 0
CONT DB 0 ; Índice a la tabla de caracteres
DE_CODE DB 2 ;Codificar a 0, decodificar a 1, fin a 2
MSGINPUT DB "AYUDA EJECUCION",13,10
MSGINPUT2 DB "Codificar: code <CADENA>",13,10
MSGINPUT3 DB "Decodificar: decode <CADENA>",13,10
MSGINPU43 DB "Terminar la ejecucion: fin",13,10,"$"
USERINPUT DB 80 dup (?)
SALTOLINEA DB 13,10,'$'
DATOS ENDS
;**************************************************************************

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK"
DB 256 DUP (0) ;ejemplo de inicializacion, 256 bytes inicializados a 0 
PILA ENDS
;**************************************************************************

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: DATOS, SS: PILA 

;*****************************************
;* Programa principal *
;*****************************************
rtc proc far
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
MOV ES, AX
MOV AX, PILA
MOV SS, AX
MOV SP, 256 ; Carga el puntero de pila con el valor mas alto
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA
; Configuración inicial del teclado y RTC
CALL codificacion
; Comprueba que no se haya introducido 'fin'
CMP DE_CODE, 2H
JZ TERMINAR
; Se configura el rtc
CALL config_rtc
; Se inicia el RTC
CALL start_rtc

; Instala el vector de la INT 70H
CLI
MOV AX, 0
MOV ES, AX
; guarda los valores originales
MOV AX, word ptr ES:[70H*4]
MOV OFFSET_O, AX
MOV AX, word ptr ES:[70H*4 + 2]
MOV SEGMEN_O, AX
; Apunta a la RSI del RTC: serv70_int
MOV word ptr ES:[70H*4], offset serv70_int
MOV word ptr ES:[70H*4 + 2], seg serv70_int
STI

; El bucle principal espera que no queden caracteres para terminar
; para terminar
BUCLE:
CMP CONT, 0
JNZ bucle ; Quedan caracteres -> sigue esperando

; Desactiva la interrupción del RTC
CALL stop_rtc
CLI
; Repone vector de interrupción original del RTC
MOV AX, 0
MOV ES, AX
MOV AX, OFFSET_O
MOV word ptr ES:[70H*4], AX
MOV AX, SEGMEN_O
MOV word ptr ES:[70H*4 + 2], AX
STI

; Devuelve el control al DOS
TERMINAR:
MOV AX, 4C00H
INT 21H
rtc endp

; Realiza las comprobaciones para distinguir si codificar, decodificar o fin
CODIFICACION:
PUSH DS AX DX BX
; imprimir mensaje pidiendo cadena a codificar

; impresion para que el usuario sepa que introducir
MOV AX, offset msginput
MOV DX, seg msginput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

;introducir cadena a codificar
;interrupcion para esperar tecleo del usuario
MOV AH,0AH 
MOV DX,OFFSET userinput 
MOV userinput[0], 80 ; 80 caracteres maximo
INT 21H
; En caso de tener longitud menor que tres no es ni fin ni code ni decode
MOV BL, userinput[1]
MOV BH, 0
CMP BL, 3H
JL FINAL ;se salta a finalizar programa
;Comparacion del mensaje introducido por usuario con fin, code o decode
CMP userinput[2], 'f'
JNZ CODE_CMP
CMP userinput[3], 'i'
JNZ CODE_CMP
CMP userinput[4], 'n'
JZ FINAL ;salta a finalizar programa en caso de introducirse fin
CODE_CMP:
CMP userinput[1], 4h
JL FINAL
CMP userinput[2], 'c'
JNZ DECODE_CMP
CMP userinput[3], 'o'
JNZ DECODE_CMP
CMP userinput[4], 'd'
JNZ DECODE_CMP
CMP userinput[5], 'e'
JZ DO_CODE ;salta a codificar en caso de introducirse code
DECODE_CMP:
CMP userinput[1], 6H
JL FINAL
CMP userinput[2], 'd'
JNZ FINAL
CMP userinput[3], 'e'
JNZ FINAL
CMP userinput[4], 'c'
JNZ FINAL
CMP userinput[5], 'o'
JNZ FINAL
CMP userinput[6], 'd'
JNZ FINAL
CMP userinput[7], 'e'
JZ DO_DECODE ;salta a descodificar en caso de introducirse decode

;Imprime salto de linea y termina
FINAL:
MOV AX, offset SALTOLINEA
MOV DX, seg SALTOLINEA
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

POP BX DX AX DS
ret

;Se coloca SI y el contador en el lugar adecuado para codificar
DO_CODE:
MOV DE_CODE, 0H
MOV SI, 4+3 ;'code' + ' ' + n max de caracteres + n de caracteres leidos
SUB BL, 4
MOV CONT, BL
JMP FINAL

;Se coloca SI y el contador en el lugar adecuado para decodificar
DO_DECODE:
MOV DE_CODE, 1H
MOV SI, 6+3 ;'decode' + ' ' + n max de caracteres + n de caracteres leidos
SUB BL, 6
MOV CONT, BL
JMP FINAL

; ............................................
; . Funciones relacionadas con el RTC .
; ............................................

; Función que configura el RTC
config_rtc proc near
PUSH AX
CLI
; Activa interrupciones en IMRs de PICs
IN AL, 21H ; Lee IMR maestro
AND AL, 11111011b ; Pone a 0 bit 2 IMR maestro
OUT 21H, AL ; Escribe IMR maestro
IN AL, 0A1H ; Lee IMR esclavo
AND AL, 11111110b ; Pone a 0 bit 0 IMR esclavo
OUT 0A1H, AL ; Escribe IMR esclavo
; Configura la frecuencia del RTC
MOV AL, 0AH
OUT 70H, AL
MOV AL, 00101111b ; DV = 32768Hz, RS = 2Hz
OUT 71H, AL
STI
POP AX
RET
config_rtc endp

; Activa las interrupciones del RTC
start_rtc proc near
PUSH AX
CLI
; Activa interrupción PIE y desactiva las demás
MOV AL, 0BH
OUT 70H, AL
IN AL, 71H ; lee registro B
OR AL, 01000000b ; PIE = 1
AND AL, 01000111b ; SET = AIE = UIE = SQWE = 0
MOV AH, AL
MOV AL, 0BH
OUT 70H, AL
MOV AL, AH
OUT 71H, AL ; Escribe registro B
MOV AL, 0CH
OUT 70H, AL
IN AL, 71H ; Lee registro C: Pone a cero banderas
STI
POP AX
RET
start_rtc endp 

; Desactiva las interrupciones del RTC
stop_rtc proc near
PUSH AX
CLI
; Desactiva interrupción PIE
MOV AL, 0BH
OUT 70H, AL
IN AL, 71H ; Lee registro B
AND AL, 10111111b ; PIE = 0
MOV AH, AL
MOV AL, 0BH
OUT 70H, AL
MOV AL, AH
OUT 71H, AL ; Escribe registro B
MOV AL, 0CH
OUT 70H, AL
IN AL, 71H ; Lee registro C: Pone a cero banderas
STI
POP AX
RET
stop_rtc endp

;...............................................
;. Rutina de servicio de la interrupción 70H .
;...............................................
serv70_int proc far

STI
PUSH AX BX ES DS
MOV AX, DATOS
MOV DS, AX
; Comprueba que ha sido el RTC-PIE quien ha interrumpido
MOV AL, 0CH
OUT 70H, AL
IN AL, 71H ; lee registro C
AND AL, 01000000b ; PF = bit 6 de registro C
JNZ pi_int
JMP salir
pi_int: ; Interrupción periódica
; solo dos opciones si llega aqui, codifica o descodifica
MOV DL, userinput[SI]
CMP DE_CODE, 0H
JZ INT_CODIFICAR ; si es 0 DE_CODE codifica
JMP INT_DESCODIFICAR ; si es 1 DE_CODE descodifica

; Se imprime caracter a caracter con la interrupcion 21
IMPRIMIR:
MOV AH, 2H
INT 21H
DEC CONT
INC SI ;Pasa al siguiente caracter
JMP SALIR

; Llamada al proceso codificar e impresion del caracter
INT_CODIFICAR:
CALL CODIFICAR
JMP IMPRIMIR

; Llamada al proceso descodificar e impresion del caracter
INT_DESCODIFICAR:
CALL DESCODIFICAR
JMP IMPRIMIR

; Manda los EOIs u finaliza
SALIR:
MOV al, 20H ; EOI no específico
OUT 20H, al ; manda EOI al PIC maestro
OUT 0A0H, al ; manda EOI al PIC esclavo
POP DS ES BX AX
IRET
serv70_int endp

; Tarea de codificar caracter a caracter
CODIFICAR PROC
	CMP DL, BYTE PTR 41H ;mira si es menor que A
	JL FIN
	CMP DL, BYTE PTR 5AH ;mira si es mayor que Z
	JG FIN
	; su codificacion pasa la Z
	CMP DL, BYTE PTR 56H ;mira si hace loopback
	JL CODIF
	; restamos el numero de caracteres del diccionario
	SUB DL, BYTE PTR 1AH ;hace loopback
	CODIF:
		ADD DL, BYTE PTR 5 ;codifica caesar
	FIN:
		RET
CODIFICAR ENDP

; Tarea de descodificar caracter a caracter
DESCODIFICAR PROC
	CMP DL, BYTE PTR 41H ;mira si es menor que A
	JL DESFIN
	CMP DL, BYTE PTR 5AH ;mira si es mayor que Z
	JG DESFIN
	; su descodificacion pasa la A
	CMP DL, BYTE PTR 45H ;mira si hace loopback
	JG DESCODIF
	ADD DL, BYTE PTR 1AH ;hace loopback
	DESCODIF:
		SUB DL, BYTE PTR 5 ;descodifica caesar		
	DESFIN:
		RET
DESCODIFICAR ENDP
CODE ends
end rtc 