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
#        /*************  Instructions template  **********
#            _____________________________________________
#            | OP  | RS  |  RD  |  RT  |  SHAMT  |  FUNCT |
#            |  6  |  5  |  5   |   5  |     5   |    6   |
#        R:  | OP  | RS  |  RD  |  RT  |  SHAMT  |  FUNCT |
#        I:  | OP  | RS  |  RT  |        ADDRES / IMM     |
#        J:  | OP  |           TARGET / ADDRESS           |
#        */   
#------------------------------------------------------------------------------------------------------------------------------------
#

        .data
fouttext:   .asciiz "testdataout.mif"      # filename for data output 
foutdata:   .asciiz "testtextout.mif"      # filename for text output
fin:    .asciiz "testin.asm"
buffer_data: .asciiz "DEPTH = 16384;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
buffer_text: .asciiz "DEPTH = 4096;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
s_undefined:    .asciiz "instrução não definida"
buffer:   .space  4
        .text


#########################################################################
  li    $v0, 13       # system call for open file
  la    $a0, fin      # input file name
  li    $a1, 0        # open for reading (flags are 0: read, 1: write)
  li    $a2, 0        # mode is ignored
  syscall             # open a file (file descriptor returned in $v0)
  move  $s5, $v0      # save the file descriptor for reading in $s5
#########################################################################
  li   $v0, 13       # system call for open file
  la   $a0, foutdata # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor for writing data in $s6
#########################################################################
  li   $v0, 13       # system call for open file
  la   $a0, fouttext # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s7, $v0      # save the file descriptor for writing text in $s6
########################################################################
main:
  jal readchar
  beq $v0, 46, parser
########################################################################
  parser:
    jal readchar
    beq $v0, 100, i_data
    beq $v0, 116, i_text
    beq $v0, 97, i_add
#########################################################################
    i_data: 
      #check if .data
      jal readchar
      bne $v0, 97, undefined
      jal readchar
      bne $v0, 116, undefined
      jal readchar
      bne $v0, 97, undefined
      jal readchar
      bne $v0, 10, undefined
      #write data header
      li   $v0, 15       # system call for write to file
      move $a0, $s6      # file descriptor for text stored in s6
      la   $a1, buffer_data # address of buffer from which to write
      li   $a2, 81       # hardcoded buffer length (size of buffer_data in decimal)
      syscall            # write to file
      j main
#########################################################################
    i_text: 
      #check if .text
      jal readchar
      bne $v0, 101, undefined
      jal readchar
      bne $v0, 120, undefined
      jal readchar
      bne $v0, 116, undefined
      jal readchar
      bne $v0, 10, undefined
      #write text header
      li   $v0, 15       # system call for write to file
      move $a0, $s7      # file descriptor for text stored in s7
      la   $a1, buffer_text # address of buffer from which to write
      li   $a2, 80       # hardcoded buffer length (size of buffer_data in decimal)
      syscall            # write to file
      j main
#########################################################################
    i_add:
      jal readchar
      bne $v0, 97, undefined
      jal readchar
      bne $v0, 97, undefined
      jal readchar
      bne $v0, 32, undefined #montar instrução na memória add $t1 $t2 $t3: opcode = 000000 (0) | t2: rs , t3: rt, t1: rd | shamt: 00000 | funct: 100000 (20) == 014b4820...?
      j main
#########################################################################

readchar:   
  li $v0,14 # prepara para ler caracter do arquivo
  move $a0,$s5  # aponta pro ponteiro no arquivo
  la $a1,buffer # salva em buffer 
  li $a2,1        # le um caracter
  syscall
  beq $v0, $0, loopend
  lb $v0,buffer # le um byte armazenado em buffer
#########################################################################
#  print:  
#    li $v0, 11    # prepara para escrever (printf)
#    move $a0, $t1 # escreve caracter no buffer
#    syscall         
#
  jr $ra  
#########################################################################
loopend: 
  li $v0, 1
  add $a0, $zero, $t1
  syscall
#########################################################################
close_file:
  close_fin:
    # Close the file 
    li   $v0, 16       # system call for close file
    move $a0, $s5      # file descriptor to close
    syscall            # close file
#########################################################################
  close_data:
    # Close the file 
    li   $v0, 16       # system call for close file
    move $a0, $s6      # file descriptor to close
    syscall            # close file
#########################################################################
  close_text:
    # Close the file 
    li   $v0, 16       # system call for close file
    move $a0, $s7      # file descriptor to close
    syscall            # close file
#########################################################################
end:
    #sai do programa
    li    $v0, 10
    syscall
#########################################################################
undefined:
  li    $v0, 4      # syscall 4, imprime string
  la    $a0, s_undefined  # le s_undefined
  syscall
  j end 
#########################################################################