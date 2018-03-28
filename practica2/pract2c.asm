;************************************************************************** 
; SBM 2015. ESTRUCTURA B?SICA DE UN PROGRAMA EN ENSAMBLADOR 
; Andr?s Salas Pe?a y Miguel Garc?a Moya
; Pareja 02 Grupo 2301
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
    MSGINPUT DB "Introduzca numero del 1 al 15: "
    USERINPUT DW ?
    FIN DB 10,'$'
    PARCIAL DW ?
    RESULT DB 6 dup (?)
    CONTADOR DB 0
DATOS ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicializaci?n, 64 bytes inicializados a 0 
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
MOV AX, offset msginput
MOV DX, seg msginput
MOV DS, DX
MOV DX, AX
MOV AH, 9h
INT 21h
MOV AH,0AH 
MOV DX,OFFSET userinput 
MOV userinput[0], 6 
INT 21H
call Trad
mov ds, DX
mov dx, ax
mov ah, 9h
int 21h
MOV AX, 4C00H 
INT 21H 
INICIO ENDP

trad PROC
            mov cx, userinput[1]
            mov ax, userinput[2]
            mov bx, 10
            mov parcial, ax
REPETIR:    mov AX, parcial
            sub AX, 30H
            mov DX, 0
            div bx
            push DX ;RESTO 
            mov parcial,AX;Cociente
            inc CONTADOR
            cmp parcial, 0h
            jnz REPETIR
            mov bx, 0
BUCLEPOP:   pop DX
            mov RESULT[bx], DL
            inc bx
            dec CONTADOR
            jnz BUCLEPOP
            mov RESULT[bx], '$'
            mov AX, OFFSET RESULT
            mov DX, SEG RESULT
            ret
trad ENDP

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 