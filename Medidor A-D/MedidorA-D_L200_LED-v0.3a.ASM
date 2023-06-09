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
		AUX
		CONT
		BIT1
		BIT2
		BIT3
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
	
CHAMA_DISPLAY
	BANK1
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;Garante que o contador do TMR0 esteja em 1:1
	BANK0
	
	MOVLW	.9		;Numero de pulsos de 104us 
	MOVWF	CONT		;bit ligar + 8bits Informa��o
	
	;Porta para transmis�o de informa��o 
	BCF	GPIO,GP1	;Seta 0 pra iniciar a transmis�o
	MOVLW	.213
	MOVWF	TMR0		;Seta valor de contagem
	BCF	INTCON,T0IF	;Limpa Flag estouro do TMR0
WAIT_104
	BTFSS	INTCON,T0IF	;Verifica Flag de estouro TMR0
	GOTO	WAIT_104
	
	MOVLW	.208
	MOVWF	TMR0		;Recoloca valor de contagem
	BCF	INTCON,T0IF	;Limpa Flag estouro do TMR0
	DECFSZ	CONT		;Verifica se 9Bits foram escritos 
	GOTO	SELECIONA_BIT
	GOTO	FINAL_CODIGO
SELECIONA_BIT
	BTFSS	AUX,0		;Testa ultimo Bit da variavel 
	GOTO	SETA_0		
	GOTO	SETA_1
	
SETA_0
	NOP
	NOP
	BCF	GPIO,GP1	;Seta 0 para saida dos 8 bits de saida
	RRF	AUX		;Rotaciona proximo bit
	GOTO	WAIT_104	;Retorna para delay 104us
	
SETA_1
	NOP
	BSF	GPIO,GP1	;Seta 0 para saida dos 8 bits de saida
	RRF	AUX		;Rotaciona proximo bit
	GOTO	WAIT_104	;Retorna para delay 104us
	
FINAL_CODIGO
	NOP
	NOP
	NOP
	NOP
	BSF	GPIO,GP1	;Seta 1 para Carry e Stop
	BCF	INTCON,T0IF	;Limpa Flag estouro do TMR0
	MOVLW	.157
	MOVWF	TMR0		;Recoloca valor de contagem de 208us
WAIT_208
	BTFSS	INTCON,T0IF	;Verifica Flag de estouro TMR0
	GOTO	WAIT_208
	NOP
	BSF	GPIO,GP1	;Garante que saida esta em Stop
	RETURN
	
	
	
	
	
	
	
	
	
	
	
CONVERSOR_AD
	BSF	ADCON0,GO	;Liga conversor
ESPERA_CONVERSAO
	BTFSC	ADCON0,GO   
	GOTO	ESPERA_CONVERSAO
	RETURN
	
	
	
	
	
	
	
	
	
	
	
CODIFICADOR_LED
	CLRF	BIT3		;BIT Mais Significativo
	CLRF	BIT2
	CLRF	BIT1		;BIT Menos Significativo
	
	MOVFW	ADRESH		;Variavel com valor da convers�o
	MOVWF	AUX		;Variavel auxiliar recebe valor
	MOVLW	B'00000000'
	MOVWF	CONT		;Contador de faixa avaliada
	
	MOVLW	.250		;Valor de topo para saida padr�o
	SUBWF	AUX,W		;Avalia o topo padr�o sem alterar variavel auxiliar
	BTFSC	STATUS,C	
	GOTO	LED_PADRAO	;Desvia para Saida padr�o
	
TESTA_FAIXA
	MOVLW	.5		;Numero para avaliar faixas de iguais tamanhos
	SUBWF	AUX		;Avalia faixa da entrada
	BTFSS	STATUS,C
	GOTO	LED_FIM	        ;Desvia para Resposta
	INCF	CONT		;Incrementa contador da faixa
	GOTO	TESTA_FAIXA	;Retorna para avalia��o
	
LED_FIM
	RLF	CONT		;Dobra valor da faixa
LED_DECIMAL
	MOVLW	.10		;Numero para avaliar faixas de iguais tamanhos
	SUBWF	CONT		;Avalia��o d0 Bit2
	BTFSS	STATUS,C
	GOTO	LED_SAIDA	;Desvia para saida da fun��o
	INCF	BIT2		;Incrementa contador do Bit2
	GOTO	LED_DECIMAL	;Retorna pra avalia��o
	
LED_SAIDA
	CLRF	BIT3		;Limpa Bit3
	MOVLW	.10		;Acrescimo de 10 para retorno do valor do Bit 2
	ADDWF	CONT
	MOVFW	CONT
	MOVWF	BIT1		;Resposta do Bit1
	RETURN
	
LED_PADRAO			;Resposta padr�o do topo
	MOVLW	.1
	MOVWF	BIT3		;Mais Significativo
	CLRF	BIT2
	CLRF	BIT1		;Menos Significativo
	RETURN	


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			    ;ALTERA PARA O BANCO 1
	MOVLW	B'00000001'	    ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		    ;COMO SA�DAS
	MOVLW	B'00010001'
	MOVWF	ANSEL		    ;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	    ;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		    ;DEFINE OP��ES DE INTERRUP��ES
	CALL	0x3FF
	MOVWF	OSCCAL		    ;RECUPERA O CLOCK PADR�O E COLOCA NO ENDERECO 0x3FF
	BANK0			    ;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		    ;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00000001'
	MOVWF	ADCON0		    ;DEFINE O MODO DE OPERA��O DO COMVERSOR A-D
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	MOVLW	.193
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'T'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'a'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'n'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'q'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'u'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'e'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	.32
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'e'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	's'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	't'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'a'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	':'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	
	
RESCREVER
	MOVLW	.144
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	CALL	CONVERSOR_AD
	CALL	CODIFICADOR_LED	
	MOVLW	'0'
	ADDWF	BIT3
	MOVFW	BIT3
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'0'
	ADDWF	BIT2
	MOVFW	BIT2
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'0'
	ADDWF	BIT1
	MOVFW	BIT1
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	'%'
	MOVWF	AUX
	CALL	CHAMA_DISPLAY
	MOVLW	.160
	MOVWF	AUX
	CALL	CHAMA_DISPLAY

	
	
	BANK1
	MOVLW	B'00000110'
	MOVWF	OPTION_REG
	BANK0
	
	MOVLW	.0
	MOVWF	TMR0
	BCF	INTCON,T0IF
WAIT_32ms
	BTFSS	INTCON,T0IF
	GOTO	WAIT_32ms
	GOTO	RESCREVER

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
