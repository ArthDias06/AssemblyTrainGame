	.data
	.align 0
welcome:.asciz "-----------Vamos começar o Jogo-----------"
menu:   .asciz "\n\nComo jogar:\n1-Adiconar vagão no início\n2-Adiconar vagão no final\n3-Remover vagão por ID\n4-Listar trem\n5-Buscar vagão\n6-Sair\nDigite sua escolha: "
error:	.asciz "Erro ao processar input\nPressiona qualquer tecla para continuar "
goodbye:.asciz "-----------Obrigado por jogar!-----------"

	.text
	.align 2
	.globl main
main:
	addi a0, zero, 12 # Serão alocados 12 bytes(4 para cada campo)
	addi a7, zero, 9 #Alocação de memória na heap, criando a cabeça da lista ligada
	ecall
	add s0, zero, a0 #Passa o conteúdo de a0 para s0
	addi s1, zero, -1
	sw s1, 0(s0) #A cabeça começa com o ID -1, ela não poderá ser acessada pelo usuário
	sw s1, 4(s0) # O tipo da cabeça é -1 também
	addi s1, zero, 1
	sw s1, 8(s0) #ponteiro nulo no primeiro momento
	la a0, welcome
	addi a7, zero, 4 #imprime o valor de Welcome na tela
	ecall

game:   la a0, menu #Carrega o menu para o usuário
	addi a7, zero, 4
	ecall
	addi a7, zero, 5 #Lê input do usuário
	ecall
	addi t0, zero, 1
	blt a0, t0, errorM # Se input menor que 1 printa mensagem de erro
	beq a0, t0, case1
	addi t0, zero, 6
	bgt a0, t0, errorM#Se input maior que 1 printa mensagem de erro
	beq a0, t0, case6
	addi t0, zero, 2
	beq a0, t0, case2
	addi t0, zero, 3
	beq a0, t0, case3
	addi t0, zero, 4
	beq a0, t0, case4
	addi t0, zero, 5
	beq a0, t0, case5
#Adiciona vagão no início
case1:
#Adiciona vagão no final
case2:
#Remove vagão por ID
case3:
#Listar todos os vagões
case4:	
#Busca pelo ID
case5:	
#Encerra o programa
case6:	la a0, goodbye
	addi a7, zero, 4
	ecall
	addi a7, zero, 10
	ecall
	
errorM:	la a0, error#Imprime mensagem de erro
	addi a7, zero, 4
	ecall
	addi a7, zero, 12
	ecall
	j game