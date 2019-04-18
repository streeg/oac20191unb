#Afonso - xx/xxxxxxx Guilherme Andreuce - 14/0141961
#------------------------------------------------------------------------------------------------------------------------------------
#
#Desenvolver uma aplicação que realize a partir de uma entrada um arquivo texto ASCII com o 
#código-fonte elaborado por instruções assembly MIPS (arquivos com a extensão “.asm”), em que este seja 
#capaz de gerar um código objeto montado em Hexadecimal em arquivo de texto ASCII, no formato MIF 
#(Memory Inicialization File) de uma listagem de instruções pré-definidas e disponíveis no Requisito 2, e 
#contidas especificamente nas áreas .text e .data do arquivo de entrada (.asm) fornecido pelo usuário da 
#aplicação. Deverá ser gerado na saída um arquivo, também em codificação ASCII, com o mesmo nome do 
#arquivo de entrada, com a extensão “.mif” (um arquivo para a área .data e outro para a área .text).
#Reforçando que a aplicação deverá comtemplar como argumento de entrada, além de todo o leque de 
#registradores inteiros da CPU MIPS, incluindo as máscaras atribuídas aos registradores, bem como permitir a 
#entrada no campo imediato de números inteiro e/ou decimais, ambos inteiros e sinalizados.
#Deve ser observado que arquivos MIF (extensão “.mif”) possuem formatação e organização dos dados próprios
#em  áreas  e  setores  específicos do  arquivo  ASCII  gerado (mais  info.: 
#https://wiki.sj.ifsc.edu.br/wiki/index.php/Inicializa%C3%A7%C3%A3o_de_mem%C3%B3ria_com_arquivos_.MIF_e_.HEX.  
#No  moodle desta atividade de  laboratório são  disponibilizados  3(três)  arquivos  de  exemplo, 
#sendo um o arquivo  fonte  (.asm) e dois arquivos de saídas esperados  (.mif), para  fins de verificação e  testes 
#durante o desenvolvimento. Observem o modo de endereçamento, incluindo a informação do cabeçalho, sendo
#responsabilidade dos desenvolvedores o tratamento dos endereços gerados (observando o padrão MIPS),
#incluindo todos os ajustes	necessários.	
#
#------------------------------------------------------------------------------------------------------------------------------------ 
#
#A listagem de instruções a serem compiladas e montadas pela aplicação desenvolvida são:
#
# lw $t0, OFFSET($s3)
# add/sub/and/or/nor/xor $t0, $s2, $t0
# sw $t0, OFFSET($s3)
# j LABEL
# jr $t0
# jal LABEL
# beq/bne $t1, $zero, 0xXXXXX
# slt $t1, $t2, $t3
# lui $t1, 0xXXXX
# addu/subu $t1, $t2, $t3
# sll/srl $t2, $t3, 10
# addi/andi/ori/xori $t2, $t3, -10
# mult $t1, $t2
# div $t1, $t2
# li $t1, XX (incluindo na forma de pseudoinstrução)
# mfhi/mflo $t1
# bgez $t1, LABEL
# clo $t1, $t2
# srav $t1, $t2, $t3
#
#------------------------------------------------------------------------------------------------------------------------------------ 
#
#label: 
#	instrução $registrador, #registrador, #registrador 	#comentário
#tab 	instr espaço regi espaço regi espaço regi tab 	#coment
#coca:
#	add $t0, $t0, $zero		#adiciona zero em $t0
#
#------------------------------------------------------------------------------------------------------------------------------------
#        /*************  Instructions template  **********
            _____________________________________________
#            | OP  | RS  |  RD  |  RT  |  SHAMT  |  FUNCT |
#            |  6  |  5  |  5   |   5  |     5   |    6   |
#        R:  | OP  | RS  |  RD  |  RT  |  SHAMT  |  FUNCT |
#        I:  | OP  | RS  |  RT  |        ADDRES / IMM     |
#        J:  | OP  |           TARGET / ADDRESS           |
#        */   

.data
entrada_asm: .asciiz "example_saida.asm"
buffer: .space 1024


.text


# Open file for reading

li   $v0, 13          # system call for open file
la   $a0, entrada_asm      # input file name
li   $a1, 0           # flag for reading
li   $a2, 0           # mode is ignored
syscall               # open a file 
move $s0, $v0         # save the file descriptor  


# reading from file just opened

li   $v0, 14        # system call for reading from file
move $a0, $s0       # file descriptor 
la   $a1, buffer    # address of buffer from which to read
li   $a2,  11       # hardcoded buffer length
syscall             # read from file

# Printing File Content
li  $v0, 4          # system Call for PRINT STRING
la  $a0, buffer     # buffer contains the values
syscall             # print int

li $v0, 10      # Finish the Program
syscall