	.data
	.align 0
welcome:.asciz "-----------Vamos começar o Jogo-----------"
menu:   .asciz "\n\nComo jogar:\n1-Adiconar vagão no início\n2-Adiconar vagão no final\n3-Remover vagão por ID\n4-Listar trem\n5-Buscar vagão\n6-Sair\nDigite sua escolha: "
error:	.asciz "\nErro ao processar input"
press:	.asciz "\nPressiona qualquer tecla para continuar: "
miss:	.asciz "\nID não encontrado!"
types:	.asciz "\n1-Locomotiva\n2-Carga\n3-Passageiro\n4-Combustível\nDigite o tipo do vagão: "
idSeek:	.asciz "\nDigite o ID desejado para a procura: "
goodbye:.asciz "-----------Obrigado por jogar!-----------"
found:	.asciz "\n-----------Encontrado------------\nTipo: "
cargo:	.asciz "Carga"
fuel:	.asciz "Combustível"
passeng:.asciz "Passageiro"
locomot:.asciz "Locomotiva"

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
	addi s1, s1, 1
	sw s0, 8(s0) #lista circular
	la a0, welcome
	addi a7, zero, 4 #imprime o valor de Welcome na tela
	ecall

game:   add s3, zero, s0
	la a0, menu #Carrega o menu para o usuário
	addi a7, zero, 4
	ecall
	addi a7, zero, 5 #Lê input do usuário
	ecall
	addi t0, zero, 1
	blt a0, t0, errorM #Se input menor que 1 printa mensagem de erro
	beq a0, t0, case1
	addi t0, zero, 6
	bgt a0, t0, errorM #Se input maior que 1 printa mensagem de erro
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
	la a0, types#Print do menu
	addi a7, zero, 4
	ecall
	addi a7, zero, 5#Recebimento do input do usuário
	ecall
	addi t0, zero, 1
	blt a0, t0, errorM
	addi t0, zero, 4
	bgt a0, t0, errorM
	add s2, zero, a0
	addi a0, zero, 12#Alocação da memória
	addi a7, zero, 9
	ecall
	sw s1, 0(a0)#ID do novo item
	addi s1, s1, 1 #Aumento o contador do id
	sw s2, 4(a0)#Tipo do novo item
	lw t0, 8(s0) #Agora o novo item aponta para o endereço que aponta s0
	sw t0, 8(a0)
	sw a0, 8(s0) #s0 aponta para o endereço do novo item
	j game
#Adiciona vagão no final
case2:
	
#Remove vagão por ID
case3:
	
#Listar todos os vagões
case4:

#Busca pelo ID
case5:
	la a0, idSeek
	addi a7, zero, 4
	ecall
	addi a7, zero, 5
	ecall
	blt a0, zero, errorM
seek:	lw s3, 8(s3)
	beq s0, s3, noID
	lw t0, 0(s3)
	bne t0, a0, seek
	la a0, found
	addi a7, zero, 4
	ecall
	lw s4, 4(s3)
	addi t1, zero, 1
	bne t1, s4, load
	la a0, locomot
	addi a7, zero, 4
	ecall
	j print
load:	addi t1, zero, 2
	bne s4, t1, person
	la a0, cargo
	addi a7, zero, 4
	ecall
	j print
person:	addi t1, zero, 3
	bne s4, t1, gas
	la a0, passeng
	addi a7, zero, 4
	ecall
	j print
gas:	la a0, fuel
	addi a7, zero, 4
	ecall
	j print

#Encerra o programa
case6:	la a0, goodbye
	addi a7, zero, 4
	ecall
	addi a7, zero, 10
	ecall
	
errorM:	la a0, error#Imprime mensagem de erro
	addi a7, zero, 4
	ecall
	j print

noID:	la a0, miss
	addi a7, zero, 4
	ecall
	la a0, press
	addi a7, zero, 4
	ecall
	addi a7, zero, 12
	ecall
	j game
	
print:	la a0, press
	addi a7, zero, 4
	ecall
	addi a7, zero, 12
	ecall
	j game
