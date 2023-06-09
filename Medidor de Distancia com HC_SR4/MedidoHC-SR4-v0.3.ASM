;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     SETEMBRO DE 2022                            *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David Jos� de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		ECHO_H
		ECHO_L
		AUX1
		AUX2
		;COLOQUE AQUI SUAS NOVAS VARI�VEIS
		;N�O ESQUE�A COMENT�RIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINI��O DE VARI�VEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN
	
	
LIGA_TRIG
	BSF	GPIO, GP5   ;Liga processo para ativar HC-SR4
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BCF	GPIO, GP5   ;Desliga depois de 10us para ativar HC-SR4
	RETURN
	
	
CONVERSAO   ;Fun��o para calcular em cm a distancia cujo calculo e (ECHO_H*4 + ECHO_H*2/5) + ECHO_L*/58.
	MOVFW	ECHO_H	    ;Calculo da parte mais significativa do retorno do tempo
	MOVWF	AUX1	    ;Salvando valor em Aux1
	MOVWF	AUX2	    ;Salvando valor em Aux2
	RLF	AUX2	    ;Multiplica por 2 Aux2
	RLF	AUX2	    ;Multiplica por 2 Aux2
	RLF	AUX1	    ;Multiplica por 2 Aux1
	
DIVISAO_5		    ;Divis�o por 5 Aux1
	MOVLW	.5
	SUBWF	AUX1
	BTFSC	STATUS,C
	GOTO	INC_AUX_5

	MOVFW	ECHO_L	    ;Calculo da parte menos significativa do retorno do tempo
	MOVWF	AUX1	    ;Salvando valor em Aux1
DIVISAO_58		    ;Divis�o por 58 Aux1
	MOVLW	.58
	SUBWF	AUX1
	BTFSC	STATUS,C
	GOTO	INC_AUX_58
	RETURN		    ;Final da Fun��o AUX2 tem valor em cm.

INC_AUX_58  ;Fun��o avaliadora de divis�o 58
	INCF	AUX2
	GOTO	DIVISAO_58
INC_AUX_5  ;Fun��o avaliadora de divis�o 5
	INCF	AUX2
	GOTO	DIVISAO_5

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00010000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000110'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	CALL	0X3FF		;RECUPERA CLOCK INTERNO
	MOVWF	OSCCAL		;DEFINE CLOCK INTERNO
	BANK0			
	;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN	;Configura��es Iniciais para ligamento do HC-SR4
	CALL	LIGA_TRIG	;Fun��o ligar sensor com 10us
	MOVLW	.0		
	MOVWF	TMR0		;Zerar Timer0
	MOVWF	TMR1L		;Zerar Timer1
	MOVWF	TMR1H		;Zerar Timer1
	MOVLW	B'00000001'
	MOVWF	T1CON		;Ligar Timer1
	BANK1
	BCF	PIE1,TMR1IE	;Limpando Flap de Estouro Timer1
	BCF	INTCON,T0IF	;Limpando Flap de Estouro Timer0
	BANK0

	
TESTA_GP4			;Fun��o trava at� Recebimento de faixa alta Gp4
	BTFSC	GPIO,GP4	
	GOTO	TESTA_GP4
	
	
	MOVLW	B'00000000'
	MOVWF	T1CON		;Desligar Timer1
	MOVFW	TMR1L
	MOVWF	ECHO_L		;Recupera Tempo-L
	MOVFW	TMR1H
	MOVWF	ECHO_H		;Recupera Tempo-H
	CALL	CONVERSAO	;Fun��o convers�o em cm.
	
	
	;Fun��o de ligar leds
	MOVLW	.40	;Liga Led2 a 40cm
	SUBWF	AUX2,W
	BTFSC	STATUS,C
	GOTO	LIGA_2
	GOTO	DESLIGA_2
LIGA_2
	BSF	GPIO, GP2
	GOTO	TESTE30
DESLIGA_2
	BCF	GPIO, GP2
	GOTO	TESTE30

TESTE30
	MOVLW	.30	;Liga Led1 a 30cm
	SUBWF	AUX2,W
	BTFSC	STATUS,C
	GOTO	LIGA_1
	GOTO	DESLIGA_1
LIGA_1
	BSF	GPIO, GP1
	GOTO	TESTE20
DESLIGA_1
	BCF	GPIO, GP1
	GOTO	TESTE20
	
TESTE20
	MOVLW	.20	;Liga Led0 a 20cm
	SUBWF	AUX2,W
	BTFSC	STATUS,C
	GOTO	LIGA_0
	GOTO	DESLIGA_0
LIGA_0
	BSF	GPIO, GP0
	GOTO	TRAVA_32ms
DESLIGA_0
	BCF	GPIO, GP0
	GOTO	TRAVA_32ms
	
	
TRAVA_32ms	;Espera 32ms para retornar a fun��o principal
	BTFSS	INTCON,T0IF
	GOTO	TRAVA_32ms
	GOTO	MAIN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
