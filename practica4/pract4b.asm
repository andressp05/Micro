;************************************************************************** 
; SBM 2018. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andrés Salas Peña y Miguel García Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
MSGINPUT DB "Introduzca cadena a (des)codificar: ",13,10,"$"
USERINPUT DB 80 dup (?)
SALTOLINEA DB 13,10,'$'
CODIFICADO DB "Cadena codificada: ",13,10,"$"
DESCODIFICADO DB "Cadena descodificada: ",13,10,"$"
DATOS ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0 
PILA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO EXTRA 
EXTRA SEGMENT 
EXTRA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA 
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INICIO PROC 
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS 
MOV DS, AX 
MOV AX, PILA 
MOV SS, AX 
MOV AX, EXTRA 
MOV ES, AX 
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 
; FIN DE LAS INICIALIZACIONES 
; COMIENZO DEL PROGRAMA 
; impresion para que el usuario sepa que introducir
MOV AX, offset msginput
MOV DX, seg msginput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

;interrupcion para esperar tecleo del usuario
MOV AH,0AH 
MOV DX,OFFSET userinput 
MOV userinput[0], 80 ; 80 caracteres maximo
INT 21H
MOV BL, userinput[1]
MOV BH, 0
MOV userinput[BX+2], '$'

MOV AX, offset SALTOLINEA
MOV DX, seg SALTOLINEA
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

MOV AX, offset CODIFICADO
MOV DX, seg CODIFICADO
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

MOV AX, offset userinput
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 11h
INT 60H

MOV AX, offset userinput[2]
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

MOV AX, offset SALTOLINEA
MOV DX, seg SALTOLINEA
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

MOV AX, offset DESCODIFICADO
MOV DX, seg DESCODIFICADO
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h

MOV AX, offset userinput
MOV DX, seg userinput
MOV DS, DX
MOV DX, AX
MOV AH, 12h
INT 60H

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