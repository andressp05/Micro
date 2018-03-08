;************************************************************************** 
; SBM 2015. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
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

;;INSTRUCCIONES DEL PROGRAMA
;; Reservamos 1 byte a contador
CONTADOR DB ?
;; Reservamos e inicializamos TOME a CAFE
TOME DW, 0CAFEH
;; Reservamos 100 bytes a TABLA100
TABLA100 DB, 100 dup (?)
;; Inicializamos una cadena para ERROR1 reservando memoria
ERROR1 DB, "Atencion: Entrada de datos incorrecta"

;; Movemos el sexto caracter de error a TABLA100
MOV AL, ERROR1[6]
MOV TABLA100[63H], AL
MOV AX, TOME
MOV WORD PTR TABLA100[23H], AX
MOV AX, TOME
MOV CONTADOR, AH
; MOV TABLA100, ERROR1[0006]
; MOV TABLA100[23], TOME 
; MOV CONTADOR, TOME[0001]

; FIN DEL PROGRAMA 
MOV AX, 4C00H 
INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 