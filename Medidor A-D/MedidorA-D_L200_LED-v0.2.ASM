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
	
CRISTAL_DYSPLAY
	MOVLW	.9
	MOVWF	CONT
	
	BCF	GPIO,GP1
	MOVLW	.213
	MOVWF	TMR0
	BCF	INTCON,T0IF
WAIT_104
	BTFSS	INTCON,T0IF
	GOTO	WAIT_104
	MOVLW	.208
	MOVWF	TMR0
	BCF	INTCON,T0IF
	DECFSZ	CONT
	GOTO	SELECIONA_BIT
	GOTO	FINAL_CODIGO
SELECIONA_BIT
	BTFSS	AUX,0
	GOTO	SETA_0
	GOTO	SETA_1
	
SETA_0
	NOP
	NOP
	BCF	GPIO,GP1
	RRF	AUX
	GOTO	WAIT_104

	
SETA_1
	NOP
	BSF	GPIO,GP1
	RRF	AUX
	GOTO	WAIT_104
	
FINAL_CODIGO
	NOP
	NOP
	NOP
	NOP
	BSF	GPIO,GP1
	BCF	INTCON,T0IF
	MOVLW	.157
	MOVWF	TMR0
WAIT_208
	BTFSS	INTCON,T0IF
	GOTO	WAIT_208
	NOP
	BSF	GPIO,GP1
	RETURN
	
	
	
	
	
	
	
	
	
	
	
CONVERSOR_AD
	BSF	ADCON0,GO
TESTE
	BTFSC	ADCON0,GO
	GOTO	TESTE
	RETURN
	
	
	
	
	
	
	
	
	
	
	
FUNCAO_LED
	CLRF	BIT3	    ;Mais Significativo
	CLRF	BIT2
	CLRF	BIT1	    ;Menos Significativo
;	MOVLW	.125
	MOVFW	ADRESH	    ;Instrução de recepção de variavel avaliada
	MOVWF	AUX	    ;Variavel auxiliar com valor avaliado
	MOVLW	B'00000000'
	MOVWF	CONT	    ;Contador dos Bits do BCD
	
FAIXA_SUPERIOR
	MOVLW	.250	    ;Valor de topo para saida padrão
	SUBWF	AUX,W
	BTFSC	STATUS,C
	GOTO	LED_PADRAO
	
TESTA_FAIXA
	MOVLW	.5	    ;Numero para avaliar faixas de iguais tamanhos
	SUBWF	AUX
	BTFSS	STATUS,C
	GOTO	LED_FIM
	INCF	CONT
	GOTO	TESTA_FAIXA	
	
LED_FIM
	RLF	CONT
LED_DECIMAL
	MOVLW	.10	    ;Numero para avaliar faixas de iguais tamanhos
	SUBWF	CONT
	BTFSS	STATUS,C
	GOTO	LED_SAIDA
	INCF	BIT2
	GOTO	LED_DECIMAL
	
LED_SAIDA
	CLRF	BIT3
	MOVLW	.10	    ;Numero para avaliar faixas de iguais tamanhos
	ADDWF	CONT
	MOVFW	CONT
	MOVWF	BIT1
	RETURN
	
LED_PADRAO
	;Resposta padrão do topo
	MOVLW	.1
	MOVWF	BIT3	    ;Mais Significativo
	CLRF	BIT2
	CLRF	BIT1	    ;Menos Significativo
	RETURN	


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000001' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010001'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	CALL	0x3FF
	MOVWF	OSCCAL
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000001'
	MOVWF	ADCON0
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BANK1
	MOVLW	B'00000000'
	MOVWF	OPTION_REG
	BANK0
	
	MOVLW	.144
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'T'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'a'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'n'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'q'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'u'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'e'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	.32
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'e'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	's'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	't'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	'a'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	MOVLW	':'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	
	
	
	CALL	CONVERSOR_AD
	CALL	FUNCAO_LED	
	MOVLW	'0'
	ADDWF	BIT3
	MOVFW	BIT3
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	
	MOVLW	'0'
	ADDWF	BIT2
	MOVFW	BIT2
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	
	MOVLW	'0'
	ADDWF	BIT1
	MOVFW	BIT1
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY
	
	MOVLW	'%'
	MOVWF	AUX
	CALL	CRISTAL_DYSPLAY

	
	BANK1
	MOVLW	B'00000111'
	MOVWF	OPTION_REG
	BANK0
	
	MOVLW	.0
	MOVWF	TMR0
	BCF	INTCON,T0IF
WAIT_65ms
	BTFSS	INTCON,T0IF
	GOTO	WAIT_65ms
	GOTO	MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
