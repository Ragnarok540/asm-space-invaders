;ASM SPACE INVADERS
NAME "NAVE2"
ORG 100H

.STACK

.DATA

NAVE    DB 11,11,11,11,11,11,11,11,11,14,11,14,11,11,11,11,11,11,11,11,11
        DB 11,11,11,11,07,11,11,11,07,07,11,07,07,11,11,11,07,11,11,11,11
        DB 11,11,11,07,11,11,11,07,04,07,11,07,01,07,11,11,11,07,11,11,11
        DB 11,11,07,11,11,11,07,04,04,07,11,07,01,01,07,11,11,11,07,11,11
        DB 11,07,11,11,11,11,07,04,04,07,11,07,01,01,07,11,11,11,11,07,11
        DB 07,11,11,11,11,11,07,04,04,07,11,07,01,01,07,11,11,11,11,11,07
        DB 07,07,07,07,07,07,07,04,04,07,07,07,01,01,07,07,07,07,07,07,07
        DB 07,01,01,01,01,01,07,04,04,0H,14,0H,01,01,07,04,04,04,04,04,07
        DB 07,07,07,07,07,07,11,07,14,14,14,14,14,07,11,07,07,07,07,07,07
        DB 07,11,11,11,11,11,11,11,07,07,07,07,07,11,11,11,11,11,11,11,07
        DB 11,07,11,11,11,11,11,11,04,11,11,11,01,11,11,11,11,11,11,07,11
        DB 11,11,07,11,11,11,11,11,04,11,11,11,01,11,11,11,11,11,07,11,11
        DB 11,11,11,07,11,11,11,11,11,11,11,11,11,11,11,11,11,07,11,11,11
        DB 11,11,11,11,07,11,11,11,11,11,11,11,11,11,11,11,07,11,11,11,11

BALA    DB 00,11,00
        DB 00,11,00
        DB 00,11,00
        DB 07,11,07 
               
POSNAVE DD 25000
POSBALA DD 0

.CODE

        MOV  AX, @DATA
        MOV  DS, AX
        MOV  AX, 0A006H
        MOV  ES, AX
        MOV  AX, 13H
        INT  10H
                
ESPERA: CALL MOBALA
        CALL PINTAR
        MOV  AH, 01H
        INT  16H 
        JZ   ESPERA
        MOV  AH, 0
        INT  16H        
        CMP  AL, 61H
        JE   IZQ
        CMP  AL, 64H
        JE   DER
        CMP  AL, 77H
        JE   ARR
        CMP  AL, 73H
        JE   ABA
        CMP  AL, 71H
        JE   SALIR
        CMP  AL, 65H
        JE   FIRE                    

ARR:    SUB  POSNAVE, 3200         
        JMP  ESPERA
    
ABA:    ADD  POSNAVE, 3200          
        JMP  ESPERA             

IZQ:    SUB  POSNAVE, 10          
        JMP  ESPERA  
                      
DER:    ADD  POSNAVE, 10   
        JMP  ESPERA

MOBALA: CMP  POSBALA, 0
        JE   SAA
        SUB  POSBALA, 3200
        CMP  POSBALA, 3200
        JC   INICIAR
SAA:    RET
        
INICIAR:MOV  POSBALA, 0
        RET

;PINTAR FONDO, NAVE Y BALA
PINTAR: CALL FONDO
        CALL PNAVE       
        CMP  POSBALA, 0
        JE   SALP
        CALL PBALA
SALP:   RET
        
;DISPARAR LA BALA        
FIRE:   MOV  BX, 14
        ADD  BX, POSNAVE
        SUB  BX, 5
        MOV  POSBALA, BX
        JMP  ESPERA        
        
;PINTAR LA BALA
PBALA:  XOR  DI, DI
        XOR  CX, CX
        MOV  CX, 3
        MOV  DX, 4
        LEA  SI, BALA 
        MOV  DI, POSBALA
DIB:    CLD
        PUSH CX
        REP  MOVSB 
        POP  CX
        MOV  AX, 320 
        SUB  AX, CX
        ADD  DI, AX
        DEC  DX
        JNZ  DIB
        RET

;PINTAR LA NAVE       
PNAVE:  XOR  DI, DI
        XOR  CX, CX
        MOV  CX, 21
        MOV  DX, 14
        LEA  SI, NAVE 
        MOV  DI, POSNAVE
DIN:    CLD
        PUSH CX
        REP  MOVSB 
        POP  CX
        MOV  AX, 320 
        SUB  AX, CX
        ADD  DI, AX
        DEC  DX
        JNZ  DIN
        RET 

;PINTAR FONDO
FONDO:  MOV  AL, 11
        MOV  CX, 0
        MOV  DX, 0
        MOV  AH, 0CH
CICLO:  INT  10H
        INC  CX
        CMP  CX, 32000
        JE   SALIDA
        JMP  CICLO	
SALIDA: MOV  AL, 10
CICLO2: INT  10H
        INC  CX
        CMP  CX, 64000
        JE   SAL2
        JMP  CICLO2
SAL2:   RET
        
;RETARDO        
DELAY   PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV  CX, 07FFH
ETI:    MOV  AX, 0FFFFH
NIC:    DEC  AX
        CMP  AX, 0H
        JNZ  NIC
        LOOP ETI 
        POP  DX
        POP  CX
        POP  BX
        POP  AX
        RET
        RET
DELAY   ENDP

SALIR:  MOV  AX, 0
        INT  16H
        RET
        HLT
        END
