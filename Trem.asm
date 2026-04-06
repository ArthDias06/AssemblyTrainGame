#Arthur de Castro Dias - 16855302
#Cleyton José Rodrigues Macedo - 16821725
#Felipe Gausmann Socolowski - 16812461
#Gabriel Carraro Salzedas - 16827905


#Descrição dos registradores usados
#s0 - Armazenamento do endereço da cabeça da lista
#t0 - usado para armazenar valor a ser comparado(nas instruções bne e beq), auxilia na troca de ponteiros entre nas inserções,aponta para o próximo nó na remoção
#t1 - Armazena o valor do contador do vagão, armazena o ID do próximo nó na remoção
#t2 - Percorre a lista encadeada
#a0 - Parâmetro de retorno da função setInfo
#a1, a2, a3 - Parâmetros de chamada da função putInfo
	.data
	.align 0

#Definição das strings usadas para melhora do ambiente
welcome:.asciz "\n-----------Vamos começar o Jogo-----------"
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
sucRem:	.asciz "\nVagão remvoido com sucesso!"
sucAdd:	.asciz "\nVagão de ID: "
sucAdd2:.asciz "adicionado com sucesso!"
	.align 2
idCount:.word 0

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
	addi t0, zero, -1
	#A cabeça começa com o ID -1, ela não poderá ser acessada pelo usuário
	sw t0, 0(s0)
	# O tipo da cabeça é -1 também
	sw t0, 4(s0)
	#lista circular
	sw s0, 8(s0)
	#Início da UI do jogo
	la a0, welcome
	addi a7, zero, 4
	ecall

game:	#Carrega o menu para o usuário
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
	#Agora o novo item aponta para o endereço que apontava s0
	lw t0, 8(s0)
	sw t0, 8(a0)
	#s0 aponta para o endereço do novo item
	sw a0, 8(s0)
	#Retorna para o menu do jogo
	j print

#Adiciona vagão no final
case2:
	#t2 percorre a lista
	add t2, zero, s0
runList:#Percorre a lista
	lw t2, 8(t2)
	lw t0, 8(t2)
	#Verifica se a lista chegou no final
	bne s0, t0, runList
	#Vai ao setInfo para coleta de informações e criação do nó
	jal ra, setInfo
	#Ajuste dos ponteiros
	sw a0, 8(t2)
	sw s0, 8(a0)
	#Retorno ao menu do jogo
	j print

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
	#t2 percorre a lista
	add t2, zero, s0
	#t0 aponta para o próximo nó
check:	lw t0, 8(t2)
	#t1 contém o ID do próximo nó
	lw t1, 0(t0)
	#Se o ID do próximo nó for igual ao ID ele remove
	beq t1, a0, remove
	#Se o ID for diferente s3 vai para o próximo nó
	lw t2, 8(t2)
	#Se s3 for igual a s0 ele deu uma volta completa na lista, então o ID não existe
	beq t2, s0, noID
	#Volta para checar o novo nó atingido
	j check
remove:	lw t1, 8(t0)
	#O nó atual aponta para o nó que t2 apontava
	sw t1, 8(t2)
	#t2 aponta para NULL
	sw zero, 8(t0)
	#Mostra mensagem de sucesso de remoção
	la a0, sucRem
	addi a7, zero, 4
	ecall
	j print

#Listar todos os vagões
case4:
	la a0, list
	addi a7, zero, 4
	ecall
	#t0 serve como contador do número de vagões
	addi t1, zero, 0
	#t2 percorre a lista
	add t2, zero, s0
listing:lw t2, 8(t2)
	#Se s0 = t2 ele deu uma volta e terminou a listagem
	beq s0, t2, print
	#Aumento do contador do vagão
	addi t1, t1, 1
	#Definição dos parâmetros para a função
	add a1, zero, t1
	lw a2, 0(t2)
	lw a3, 4(t2)
	#Vai para a função de printar informações do vagão
	jal ra, putInfo
	#Retorna para a listagem
	j listing

#Busca pelo ID
case5:
	la a0, idSeek
	addi a7, zero, 4
	ecall
	addi a7, zero, 5
	ecall
	#Se o ID menor que 0 é inválido
	blt a0, zero, errorM
	#t1 é o contador de vagões
	addi t1, zero, 0
	#t2 percorre a lista
	add t2, zero, s0
	#Percorre a lista
seek:	lw t2, 8(t2)
	#Se iD não encontrado dá um erro
	beq s0, t2, noID
	#Aumento do contador do vagão
	addi t1, t1, 1
	lw t0, 0(t2)
	#Se o ID atual for diferente do procurado ele continua a procura
	bne t0, a0, seek
	add a1, zero, t1
	la a0, found
	addi a7, zero, 4
	ecall
	#Parâmetros da função
	lw a2, 0(t2)
	lw a3, 4(t2)
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
	#Passa o tipo de a0 para a1 para não perder durante a alocação
	add a1, zero, a0
	addi a0, zero, 12
	#Alocação de memória do novo nó
	addi a7, zero, 9
	ecall
	la t0, idCount
	#Pega o valor de idCount
	lw t1, 0(t0)
	#ID do novo item
	sw t1, 0(a0)
	#print de mensagem de sucesso de inserção
	la a0, sucAdd
	addi, a7, zero, 4
	ecall
	#print do ID do novo vagão
	add a0, zero, t1
	addi a7, zero, 1
	ecall
	la a0, sucAdd2
	addi a7, zero, 4
	ecall
	#Aumento o contador do id
	addi t1, t1, 1
	#Guarda o vaor do item
	sw t1, 0(t0)
	#Tipo do novo item
	sw a1, 4(a0)
	jr ra

#Print das informações do vagão
putInfo:#Print do número do vagão
	la a0, wagon
	addi a7, zero, 4
	ecall
	add a0, zero, a1
	addi a7, zero, 1
	ecall
	#Print do ID do vagão
	la a0, idPrint
	addi a7, zero, 4
	ecall
	add a0, zero, a2
	addi a7, zero, 1
	ecall
	#Print do tipo do vagão
	la a0, tyPrint
	addi a7, zero, 4
	ecall
	#Print do tipo por extenso
	#Print do tipo locomotiva
	addi t0, zero, 1
	bne t0, a3, load
	la a0, locomot
	addi a7, zero, 4
	ecall
	jr ra
	#Print do tipo Carga
load:	addi t0, zero, 2
	bne a3, t0, person
	la a0, cargo
	addi a7, zero, 4
	ecall
	jr ra
	#Print do tipo passageiro
person:	addi t0, zero, 3
	bne a3, t0, gas
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