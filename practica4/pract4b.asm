;************************************************************************** 
; SBM 2018. ESTRUCTURA BASICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andres Salas Peña y Miguel Garcia Moya
; Pareja 02 Grupo 2301 -- Practica 4, Apartado B
;************************************************************************** 

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
MSGINPUT DB "Introduzca cadena a codificar y descodificar: ",13,10,"$"
USERINPUT DB 80 dup (?)
SALTOLINEA DB 13,10,'$'
CODIFICADO DB "Cadena codificada: ",13,10,"$"
DESCODIFICADO DB "Cadena descodificada: ",13,10,"$"
DATOS ENDS 
;************************************************************************** 

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicializacion, 64 bytes inicializados a 0 
PILA ENDS 
;************************************************************************** 

;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE, DS: DATOS, SS: PILA 
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INICIO PROC 
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS 
MOV DS, AX 
MOV AX, PILA 
MOV SS, AX
MOV SP, 64 ; Carga el puntero de pila con el valor mas alto
; FIN DE LAS INICIALIZACIONES 
; COMIENZO DEL PROGRAMA 
; impresion para que el usuario sepa que introducir
MOV AX, offset msginput
MOV DX, seg msginput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; Interrupcion espera escritura de teclado
MOV AH,0AH 
MOV DX,OFFSET userinput 
MOV userinput[0], 80 ; 80 caracteres escritos como maximo
INT 21H
MOV BL, userinput[1]
MOV BH, 0
MOV userinput[BX+2], '$' ; Anyadimos un final de cadena a lo escrito

; Impresion Salto de Linea
MOV AX, offset SALTOLINEA
MOV DX, seg SALTOLINEA
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; Impresion Mensaje Codificacion
MOV AX, offset CODIFICADO
MOV DX, seg CODIFICADO
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; Llamada al driver para codificar
MOV AX, offset userinput
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 11h
INT 60H

; Impresion Codificacion
MOV AX, offset userinput[2]
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; Impresion Salto de Linea
MOV AX, offset SALTOLINEA
MOV DX, seg SALTOLINEA
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; Impresion Mensaje Descodificacion
MOV AX, offset DESCODIFICADO
MOV DX, seg DESCODIFICADO
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; Llamada al driver para descodificar
MOV AX, offset userinput
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 12h
INT 60H

; Impresion Descodificacion
MOV AX, offset userinput[2]
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

; FIN DEL PROGRAMA 
MOV AX, 4C00H 
INT 21H 
INICIO ENDP 

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 