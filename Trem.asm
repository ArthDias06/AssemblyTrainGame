	.data
	.align 0
Welcome:.asciz "-----------Vamos começar o Jogo-----------"
menu:   .asciz "\n\nComo jogar:\n1-Adiconar vagão no início\n2-Adiconar vagão no final\n3-Remover vagão por ID\n4-Listar trem\n5-Buscar vagão\n6-Sair\nDigite sua escolha: "
error:	.asciz "Erro ao processar input\nPressiona qualquer tecal para continuar "
goodbye:.asciz "-----------Obrigado por jogar!-----------"
	.align 1
option: .space 2

	.text
	.align 2
	.globl main
main:
	la a0, Welcome
	addi a7, zero, 4 #imprime o valor de Welcome na tela
	ecall
	addi t0, zero, 1
	addi t1, zero, 6
game:   la a0, menu
	addi a7, zero, 4
	ecall
	addi a7, zero, 5
	ecall
	blt a0, t0, errorM
	bgt a0, t1, errorM
	beq a0, t1, case6
case6:	la a0, goodbye
	addi a7, zero, 4
	ecall
	addi a7, zero, 10 #Encerra o programa
	ecall
errorM:	la a0, error
	addi a7, zero, 4
	ecall
	addi a7, zero, 12
	ecall
	j game