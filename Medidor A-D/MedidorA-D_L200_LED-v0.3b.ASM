;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                     SETEMBRO DE 2022                            *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		AUX
		CONT
		BIT1
		BIT2
		BIT3
		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.
	
CHAMA_DISPLAY
	BANK1
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;Garante que o contador do TMR0 esteja em 1:1
	BANK0
	
	MOVLW	.9		;Numero de pulsos de 104us 
	MOVWF	CONT		;bit ligar + 8bits Informação
	
	;Porta para transmisão de informação 
	BCF	GPIO,GP1	;Seta 0 pra iniciar a transmisão
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
	
	MOVFW	ADRESH		;Variavel com valor da conversão
	MOVWF	AUX		;Variavel auxiliar recebe valor
	MOVLW	B'00000000'
	MOVWF	CONT		;Contador de faixa avaliada
	
	MOVLW	.250		;Valor de topo para saida padrão
	SUBWF	AUX,W		;Avalia o topo padrão sem alterar variavel auxiliar
	BTFSC	STATUS,C	
	GOTO	LED_PADRAO	;Desvia para Saida padrão
	
TESTA_FAIXA
	MOVLW	.3
	SUBWF	AUX
	BTFSS	STATUS,C	
	GOTO	LED_FIM	        ;Desvia para Resposta
	MOVLW	.4
	SUBWF	AUX
	BTFSS	STATUS,C
	GOTO	LED_FIM	        ;Desvia para Resposta
	INCF	CONT		;Incrementa contador da faixa
	INCF	AUX
	INCF	AUX
	GOTO	TESTA_FAIXA	;Retorna para avaliação
	
LED_FIM
	RLF	CONT		;Dobra valor da faixa
LED_DECIMAL
	MOVLW	.10		;Numero para avaliar faixas de iguais tamanhos
	SUBWF	CONT		;Avaliação d0 Bit2
	BTFSS	STATUS,C
	GOTO	LED_SAIDA	;Desvia para saida da função
	INCF	BIT2		;Incrementa contador do Bit2
	GOTO	LED_DECIMAL	;Retorna pra avaliação
	
LED_SAIDA
	CLRF	BIT3		;Limpa Bit3
	MOVLW	.10		;Acrescimo de 10 para retorno do valor do Bit 2
	ADDWF	CONT
	MOVFW	CONT
	MOVWF	BIT1		;Resposta do Bit1
	RETURN
	
LED_PADRAO			;Resposta padrão do topo
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
	MOVWF	TRISIO		    ;COMO SAÍDAS
	MOVLW	B'00010001'
	MOVWF	ANSEL		    ;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	    ;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		    ;DEFINE OPÇÕES DE INTERRUPÇÕES
	CALL	0x3FF
	MOVWF	OSCCAL		    ;RECUPERA O CLOCK PADRÃO E COLOCA NO ENDERECO 0x3FF
	BANK0			    ;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		    ;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000001'
	MOVWF	ADCON0		    ;DEFINE O MODO DE OPERAÇÃO DO COMVERSOR A-D
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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
