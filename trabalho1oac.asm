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
#incluindo todos os ajustes necessários.  
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
# instrução $registrador, #registrador, #registrador  #comentário
#tab  instr espaço regi espaço regi espaço regi tab   #coment
#coca:
# add $t0, $t0, $zero   #adiciona zero em $t0
#
#------------------------------------------------------------------------------------------------------------------------------------
#        /*************  Instructions template  **********
#            _____________________________________________
#            | OP  | RS  |  RD  |  RT  |  SHAMT  |  FUNCT |
#            |  6  |  5  |  5   |   5  |     5   |    6   |
#        R:  | OP  | RS  |  RD  |  RT  |  SHAMT  |  FUNCT |
#        I:  | OP  | RS  |  RT  |        ADDRES / IMM     |
#        J:  | OP  |           TARGET / ADDRESS           |
#        */   

        .data
fout:   .asciiz "testout.mif"      # filename for output
fin:    .asciiz "testin.asm"
buffer_data: .asciiz "DEPTH = 16384;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
buffer_text: .asciiz "DEPTH = 4096;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
buffer:   .space  4
        .text

######################################################################### 
  li    $v0, 13       # system call for open file
  la    $a0, fin      # input file name
  li    $a1, 0        # open for reading (flags are 0: read, 1: write)
  li    $a2, 0        # mode is ignored
  syscall             # open a file (file descriptor returned in $v0)
  move  $s5, $v0      # save the file descriptor in $s5
######################################################################### 
readchar:   li $v0,14 # prepara para ler caracter do arquivo
            move $a0,$s5  # aponta pro começo do arquivo
            la $a1,buffer # salva em buffer? para armazenar mais tarde?
            li $a2,1      # le um caracter
            syscall
            beq $v0, $0, loopend
#########################################################################            
            lb $t1,buffer # armazena um byte em buffer?
            beq $t1, 32, quebrainstrucao #se t1 for um espaço vai pra quebra instrução
            li $v0, 11    # prepara para escrever (printf)
            move $a0, $t1 # escreve caracter no buffer
            syscall         
            j readchar
loopend: 
            li $v0, 1
            add $a0, $zero, $t1
            syscall
            
quebrainstrucao:
      

      
