#Arthur de Castro Dias - 16855302
#Cleyton José - 16
#Felipe Gausmann Socolowski - 16
#Gabriel Carraro Salzedas - 16827905


#Descrição dos registradosres usados
#s0 - Armazenamento do endereço da cabeça da lista
#s1 - registrador contendo o próximo ID
#s2 - Registrador usado na inserção no início
#s3 - Registrador usado para percorrer a lista
#s4 - Armazena o contador do vagão na listagem e na busca
#s5 - flag para saber se o novo vagão entra no início ou no fim e para saber se o tipo do vagão deve retornar para a busca ou para a listagem
#t0 - usado para armazenar valor a ser comparado(nas instruções bne e beq)
#t1 - Armazena o valor do tipo do vagão na busca
#t2 - Verifica o próximo nó para saber se ele foi escolhido para ser removido
#t3 - Armazena o valor do ID do próximo nó para saber se ele será removido e armazena o valor do nó próximo de t2 para passar para o s3
	.data
	.align 0
welcome:.asciz "-----------Vamos começar o Jogo-----------"
menu:   .asciz "\n\nComo jogar:\n1-Adiconar vagão no início\n2-Adiconar vagão no final\n3-Remover vagão por ID\n4-Listar trem\n5-Buscar vagão\n6-Sair\nDigite sua escolha: "
error:	.asciz "\nErro ao processar input"
press:	.asciz "\nPressiona qualquer tecla para continuar: "
miss:	.asciz "\nID não encontrado!"
types:	.asciz "\n1-Locomotiva\n2-Carga\n3-Passageiro\n4-Combustível\nDigite o tipo do vagão: "
idSeek:	.asciz "\nDigite o ID desejado para a procura: "
idKill:	.asciz "\nDigite o ID desejado para a remoção: "
goodbye:.asciz "\n-----------Obrigado por jogar!-----------"
found:	.asciz "\n-----------Encontrado------------"
cargo:	.asciz "Carga"
fuel:	.asciz "Combustível"
passeng:.asciz "Passageiro"
locomot:.asciz "Locomotiva"
list:	.asciz "\n-----------Listando-----------"
idPrint:.asciz "\nID do vagão: "
tyPrint:.asciz "\nTipo do vagão: "
wagon:	.asciz "\n\nVagão "

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
	addi t0, zero, 1
	beq s5, t0, return
	sw s2, 4(a0)#Tipo do novo item
	lw t0, 8(s0) #Agora o novo item aponta para o endereço que aponta s0
	sw t0, 8(a0)
	sw a0, 8(s0) #s0 aponta para o endereço do novo item
	j game
#Adiciona vagão no final
case2:
	lw s3, 8(s3)
	lw t0, 8(s3)
	bne s0, t0, case2
	addi s5, zero, 1
	j case1
return:	addi s5, zero, 0 #Sempre que ele voltar para listing precisa resetar para não continuar listando caso a busca ou a inserção no início seja chamada após essa instrução
	sw s2, 4(a0)
	sw a0, 8(s3)
	sw s0, 8(a0)
	j game
#Remove vagão por ID
case3:
	la a0, idKill
	addi a7, zero, 4
	ecall
	addi a7, zero, 5
	ecall
	blt a0, zero, errorM
check:	lw t2, 8(s3)
	lw t3, 0(t2)
	beq t3, a0, remove
	lw s3, 8(s3)
	beq s3, s0, noID
	j check
remove:	lw t3, 8(t2)
	sw t3, 8(s3)
	addi t3, zero, 0
	sw t3, 8(t2)
	j game
	
#Listar todos os vagões
case4:
	addi s4, zero, 1
	la a0, list
	addi a7, zero, 4
	ecall
listing:addi s5, zero, 0
	lw s3, 8(s3)
	beq s0, s3, print
	la a0, wagon
	addi a7, zero, 4
	ecall
	add a0, zero, s4
	addi a7, zero, 1
	ecall
	addi s4, s4, 1
	la a0, idPrint
	addi a7, zero, 4
	ecall
	lw a0, 0(s3)
	addi a7, zero, 1
	ecall
	la a0, tyPrint
	addi a7, zero, 4
	ecall
	addi s5, zero, 1
	j type
#Busca pelo ID
case5:
	addi s4, zero, 0
	la a0, idSeek
	addi a7, zero, 4
	ecall
	addi a7, zero, 5
	ecall
	blt a0, zero, errorM
seek:	lw s3, 8(s3)
	beq s0, s3, noID
	addi s4, s4, 1
	lw t0, 0(s3)
	bne t0, a0, seek
	la a0, found
	addi a7, zero, 4
	ecall
	la a0, wagon
	addi a7, zero, 4
	ecall
	add a0, zero, s4
	addi a7, zero, 1
	ecall
	la a0, tyPrint
	addi a7, zero, 4
	ecall
type:	lw t1, 4(s3)
	addi t0, zero, 1
	bne t0, t1, load
	la a0, locomot
	addi a7, zero, 4
	ecall
	addi t0, zero, 1
	beq t0, s5, listing
	j print
load:	addi t0, zero, 2
	bne t1, t0, person
	la a0, cargo
	addi a7, zero, 4
	ecall
	addi t0, zero, 1
	beq t0, s5, listing
	j print
person:	addi t0, zero, 3
	bne t1, t0, gas
	la a0, passeng
	addi a7, zero, 4
	ecall
	addi t0, zero, 1
	beq t0, s5, listing
	j print
gas:	la a0, fuel
	addi a7, zero, 4
	ecall
	addi t0, zero, 1
	beq t0, s5, listing
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
