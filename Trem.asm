#Arthur de Castro Dias - 16855302
#Cleyton José - 16
#Felipe Gausmann Socolowski - 16
#Gabriel Carraro Salzedas - 16827905


#Descrição dos registradores usados
#s0 - Armazenamento do endereço da cabeça da lista
#s1 - registrador contendo o próximo ID
#s2 - Registrador usado na inserção no início
#s3 - Registrador usado para percorrer a lista
#s4 - Armazena o contador do vagão na listagem e na busca
#t0 - usado para armazenar valor a ser comparado(nas instruções bne e beq)
#t1 - Armazena o valor do tipo do vagão na busca
#t2 - Verifica o próximo nó para saber se ele foi escolhido para ser removido
#t3 - Armazena o valor do ID do próximo nó para saber se ele será removido e armazena o valor do nó próximo de t2 para passar para o s3
	.data
	.align 0
	
#Definição das strings usadas para melhora do ambiente
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
	# Serão alocados 12 bytes(4 para cada campo)
	addi a0, zero, 12
	#Alocação de memória na heap, criando a cabeça da lista ligada
	addi a7, zero, 9
	ecall
	#s0 aponta para a cabeça do trem
	add s0, zero, a0
	addi s1, zero, -1
	#A cabeça começa com o ID -1, ela não poderá ser acessada pelo usuário
	sw s1, 0(s0)
	# O tipo da cabeça é -1 também
	sw s1, 4(s0)
	addi s1, s1, 1
	#lista circular
	sw s0, 8(s0)
	#Início da UI do jogo
	la a0, welcome
	addi a7, zero, 4
	ecall

game:	#s3 servirá para percorrer a lista em diversas situações, sempre ao voltar ele volta a apontar para o nó cabeça
	add s3, zero, s0
	#Carrega o menu para o usuário
	la a0, menu
	addi a7, zero, 4
	ecall
	#Lê input do usuário
	addi a7, zero, 5
	ecall
	addi t0, zero, 1
	#Se input menor que 1 printa mensagem de erro
	blt a0, t0, errorM
	beq a0, t0, case1
	addi t0, zero, 6
	#Se input maior que 6 printa mensagem de erro
	bgt a0, t0, errorM
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
case1:	jal ra, setInfo
	#Tipo do novo item
	sw s2, 4(a0)
	#Agora o novo item aponta para o endereço que apontava s0
	lw t0, 8(s0)
	sw t0, 8(a0)
	#s0 aponta para o endereço do novo item
	sw a0, 8(s0)
	#Retorna para o menu do jogo
	j game

#Adiciona vagão no final
case2:
	lw s3, 8(s3) #Percorre a lista
	lw t0, 8(s3)
	#Verifica se a lista chegou no final
	bne s0, t0, case2
	#Vai ao case1 para coleta de informações e criação do nó
	jal ra, setInfo
	sw s2, 4(a0)
	sw a0, 8(s3)
	sw s0, 8(a0)
	#Retorno ao menu do jogo
	j game

#Remove vagão por ID
case3:
	la a0, idKill
	addi a7, zero, 4
	ecall
	#Lê valor do ID que será removido
	addi a7, zero, 5
	ecall
	#Se o ID for menor que 0 ele é inválido
	blt a0, zero, errorM
	#t2 aponta para o próximo nó
check:	lw t2, 8(s3)
	#t3 contém o ID do próximo nó
	lw t3, 0(t2)
	#Se o ID do próximo nó for igual ao ID ele remove
	beq t3, a0, remove
	#Se o ID for diferente s3 vai para o próximo nó
	lw s3, 8(s3)
	#Se s3 for igual a s0 ele deu uma volta completa na lista, então o ID não existe
	beq s3, s0, noID
	#Volta para checar o novo nó atingido
	j check
remove:	lw t3, 8(t2)
	#O nó atual aponta para o nó que t2 apontava
	sw t3, 8(s3)
	#t3 contém 0
	addi t3, zero, 0
	#t2 aponta para NULL
	sw t3, 8(t2)
	#Retorno ao menu do jogo
	j game

#Listar todos os vagões
case4:
	#Inicia o contador de vagões
	addi s4, zero, 1
	la a0, list
	addi a7, zero, 4
	ecall
listing:lw s3, 8(s3)
	#Se s0 = s3 ele deu uma volta e terminou a listagem
	beq s0, s3, print
	#Vai para a função de printar informações do vagão
	jal ra, putInfo
	#Aumento do contador do vagão
	addi s4, s4, 1
	#Retorna para a listagem
	j listing

#Busca pelo ID
case5:
	#Contador do número de vagão
	addi s4, zero, 0
	la a0, idSeek
	addi a7, zero, 4
	ecall
	addi a7, zero, 5
	ecall
	#Se o ID menor que 0 é inválido
	blt a0, zero, errorM
	#Percorre a lista
seek:	lw s3, 8(s3)
	beq s0, s3, noID
	#Aumento do contador do vagão
	addi s4, s4, 1
	lw t0, 0(s3)
	#Se o ID atual for diferente do procurado ele continua a procura
	bne t0, a0, seek
	#Se os IDs forem iguais ele mostra as informações
	la a0, found
	addi a7, zero, 4
	ecall
	jal ra, putInfo
	j print

#Encerra o programa
case6:	la a0, goodbye
	addi a7, zero, 4
	ecall
	#Término da execução
	addi a7, zero, 10
	ecall

#Função para criação do novo nó
setInfo:#Print do menu de tipos
	la a0, types
	addi a7, zero, 4
	ecall
	#Recebimento do input do usuário
	addi a7, zero, 5
	ecall
	addi t0, zero, 1
	#Se o input for menor que 1 dá erro
	blt a0, t0, errorM
	addi t0, zero, 4
	#Se o input for maior que 4 dá erro
	bgt a0, t0, errorM
	add s2, zero, a0
	addi a0, zero, 12
	#Alocação de memória do novo nó
	addi a7, zero, 9
	ecall
	#ID do novo item
	sw s1, 0(a0)
	#Aumento o contador do id
	addi s1, s1, 1
	jr ra

#Print das informações do vagão
putInfo:la a0, wagon
	addi a7, zero, 4
	ecall
	add a0, zero, s4
	addi a7, zero, 1
	ecall
	#Print do ID do vagão
	la a0, idPrint
	addi a7, zero, 4
	ecall
	lw a0, 0(s3)
	addi a7, zero, 1
	ecall
	#Print do tipo do vagão
	la a0, tyPrint
	addi a7, zero, 4
	ecall
	#Print do tipo por extenso
	#Print do tipo locomotiva
	lw t1, 4(s3)
	addi t0, zero, 1
	bne t0, t1, load
	la a0, locomot
	addi a7, zero, 4
	ecall
	jr ra
	#Print do tipo Carga
load:	addi t0, zero, 2
	bne t1, t0, person
	la a0, cargo
	addi a7, zero, 4
	ecall
	jr ra
	#Print do tipo passageiro
person:	addi t0, zero, 3
	bne t1, t0, gas
	la a0, passeng
	addi a7, zero, 4
	ecall
	jr ra
	#Print do tipo combustível
gas:	la a0, fuel
	addi a7, zero, 4
	ecall
	jr ra

#Imprime mensagem de erro
errorM:	la a0, error
	addi a7, zero, 4
	ecall
	j print

#Imprime mensagem caso ID pedido não exista
noID:	la a0, miss
	addi a7, zero, 4
	ecall
	j print

#Mensagem base para o usuário apertar uma tecla para continuar
print:	la a0, press
	addi a7, zero, 4
	ecall
	#Recebe um char do usuário para ele continuar a execução
	addi a7, zero, 12
	ecall
	j game
