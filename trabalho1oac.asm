#Afonso Dias - 14/0055771 Guilherme Andreuce - 14/0141961
#------------------------------------------------------------------------------------------------------------------------------------
#
#Desenvolver uma aplicação que realize a partir de uma entrada um arquivo texto ASCII com o 
#código-fonte elaborado por instruções assembly MIPS (arquivos com a extensão “.asm�?), em que este seja 
#capaz de gerar um código objeto montado em Hexadecimal em arquivo de texto ASCII, no formato MIF 
#(Memory Inicialization File) de uma listagem de instruções pré-definidas e disponíveis no Requisito 2, e 
#contidas especificamente nas áreas .text e .data do arquivo de entrada (.asm) fornecido pelo usuário da 
#aplicação. Deverá ser gerado na saída um arquivo, também em codificação ASCII, com o mesmo nome do 
#arquivo de entrada, com a extensão “.mif�? (um arquivo para a área .data e outro para a área .text).
#Reforçando que a aplicação deverá comtemplar como argumento de entrada, além de todo o leque de 
#registradores inteiros da CPU MIPS, incluindo as máscaras atribuídas aos registradores, bem como permitir a 
#entrada no campo imediato de números inteiro e/ou decimais, ambos inteiros e sinalizados.
#Deve ser observado que arquivos MIF (extensão “.mif�?) possuem formatação e organização dos dados próprios
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
buffer_data_init: .asciiz "DEPTH = 16384;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
buffer_text_init: .asciiz "DEPTH = 4096;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
buffer_data_end:  .asciiz "\nEND;"
buffer_text_end:  .asciiz "\nEND;"
buffer_data_address:  .space  8
buffer_text_address:  .space  8
s_divisor:  .asciiz " : "
s_finalizador:  .asciiz ";"

s_undefined:    .asciiz "instrução não definida"
#
s_zero: .asciiz "00000"
s_at:   .asciiz "00001"
s_v0:   .asciiz "00010"
s_v1:   .asciiz "00011" 
s_a0:   .asciiz "00100"
s_a1:   .asciiz "00101"
s_a2:   .asciiz "00110"
s_a3:   .asciiz "00111"
s_t0:   .asciiz "01000"
s_t1:   .asciiz "01001"
s_t2:   .asciiz "01010"
s_t3:   .asciiz "01011"
s_t4:   .asciiz "01100"
s_t5:   .asciiz "01101"
s_t6:   .asciiz "01110"
s_t7:   .asciiz "01111"
s_s0:   .asciiz "10000"
s_s1:   .asciiz "10001"
s_s2:   .asciiz "10010"
s_s3:   .asciiz "10011"
s_s4:   .asciiz "10100"
s_s5:   .asciiz "10101"
s_s6:   .asciiz "10110"
s_s7:   .asciiz "10111"
s_t8:   .asciiz "11000"
s_t9:   .asciiz "11001"
s_k0:   .asciiz "11010"
s_k1:   .asciiz "11011"
s_gp:   .asciiz "11100"
s_sp:   .asciiz "11101"
s_fp:   .asciiz "11110"
s_ra:   .asciiz "11111"
s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav: .asciiz "000000"
s_opcode_lw: .asciiz "100011"
s_opcode_sw: .asciiz "101011"
s_opcode_j:  .asciiz "000010"
s_opcode_jal:  .asciiz "000011"
s_opcode_bne:  .asciiz "000100"
s_opcode_beq:  .asciiz "000101"
s_opcode_lui:  .asciiz "001111"
s_opcode_addi: .asciiz "001000"
s_opcode_andi: .asciiz "001100"
s_opcode_ori:   .asciiz "001101"
s_opcode_xori:  .asciiz "001110"
s_opcode_bgez:  .asciiz "000001"
s_shamttipor: .asciiz "000000"
s_function_add: .asciiz "100000"
s_function_sub: .asciiz "100010"
s_function_and:  .asciiz "100100"
s_function_or:  .asciiz "100101"
s_function_nor:  .asciiz "100111"
s_function_xor:  .asciiz "100110" 
s_function_jr:  .asciiz "001000"
s_function_slt:  .asciiz "101010"
s_function_addu:  .asciiz "100001"
s_function_subu:  .asciiz "100011"
s_function_sll:  .asciiz "000000"
s_function_srl:  .asciiz  "000010"
s_function_mult:  .asciiz "011000"
s_function_div:  .asciiz "011010"
s_function_mfhi:  .asciiz "010000"
s_function_mflo:  .asciiz "010010"
s_function_srav:  .asciiz "000111"
#instruções tipo i e j não tem function
#
s_converter:  .space 32
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
  jal readchar       #le primeiro caracter
  bne $v0, 46, undefined #se o caracter não for um '.' vai para o switch de instrução
########################################################################
  parser:
    jal readchar    #le caracter
    beq $v0, 10, parser   #se caracter for 'enter', continua caminhando no arquivo
    beq $v0, 32, parser   #se caracter for 'espaço', continua caminhando no arquivo
    beq $v0, 100, i_data  #se caracter for um 'd' vai pra função de escrita do .data 
    beq $v0, 116, i_text  #se caracter for um 't' vai pra função de escrita do .text
    beq $v0, 97, i_a    #se caracter for um 'a' vai pra função de verificacao comecando por 'a'
    beq $v0, 115, i_s   #se caracter for um 's' vai pra função de verificacao comecando por 's'
    beq $v0, 120, i_xor    #se caracter for um 'x' vai para função de escrita do xor, xori
#########################################################################
  i_a:
    jal readchar  #le caracter
    beq $v0, 100, i_add  #se o proximo caracter for 'd', manda pro i_add para verificar se eh add, addi ou addiu
    #beq $v0, 110, i_and  #se o proximo caracter for 'n', manda pro i_and para verificar se eh and ou andi
    j undefined
#########################################################################
  i_s:
    jal readchar  #le caracter
    beq $v0, 117, i_sub  #se o proximo caracter for 'u', manda pro i_sub para verificar se eh sub ou subu
    #beq $v0, 119, i_sw  #se o proximo caracter for 'w', manda pro i_sw
    #beq $v0, 108, i_sll  #se o proximo caracter for 'l', manda pro i_sll para verificar se eh sll ou slt
    #beq $v0, 114, i_srl  #se o proximo caracter for 'r', manda pro i_srl para verificar se eh srl ou srav
    j undefined
#########################################################################
    i_data: 
      #check if .data
      jal readchar   #le caracter
      bne $v0, 97, undefined  #se o proximo caracter não for 'a', instrução não definida.
      jal readchar   #le caracter
      bne $v0, 116, undefined #se o proximo caracter não for 't', instrução não definida.
      jal readchar   #le caracter
      bne $v0, 97, undefined  #se o proximo caracter não for 'a', instrução não definida.
      jal readchar   #le caracter
      bne $v0, 10, undefined  #se o proximo caracter não for 'enter', instrução não definida.
      #write data header
      li   $v0, 15       # system call for write to file
      move $a0, $s6      # file descriptor for text stored in s6
      la   $a1, buffer_data_init # address of buffer from which to write
      li   $a2, 81       # hardcoded buffer length (size of buffer_data_init in decimal)
      syscall            # write to file

      j main
#########################################################################
    i_text: 
      #check if .text
      jal readchar   #le caracter
      bne $v0, 101, undefined  #se o proximo caracter não for 'e', instrução não definida.
      jal readchar   #le caracter
      bne $v0, 120, undefined  #se o proximo caracter não for 'x', instrução não definida.
      jal readchar   #le caracter
      bne $v0, 116, undefined  #se o proximo caracter não for 't', instrução não definida.
      jal readchar   #le caracter
      bne $v0, 10, undefined  #se o proximo caracter não for 'enter', instrução não definida.
      #write text header
      li   $v0, 15       # system call for write to file
      move $a0, $s7      # file descriptor for text stored in s7
      la   $a1, buffer_text_init # address of buffer from which to write
      li   $a2, 80       # hardcoded buffer length (size of buffer_data_init in decimal)
      syscall            # write to file
      beq $v0, 10, parser #se o proximo caracter for 'enter', volta pra função leitura de caracter até achar próxima instrução.
      j main
#########################################################################
    i_add:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 100, undefined  #se o proximo caracter não for 'd', instrução não definida.
      jal readchar  #le caracter
      beq $v0, 117, i_addu  #se o proximo caracter for 'u', funçao de escrita do addu 
      beq $v0, 105, i_addi  #se o proximo caracter for 'i', funçao de escrita do addi
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $s5, s_function_add #coloca o function do add em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      #j concatenastring
#########################################################################
    i_addu:
      jal readchar #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $s5, s_function_addu #coloca o function do addu em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      #j concatenastring
#########################################################################
    i_addi:
      jal readchar #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar #le caracter
      bne $v0, 36, undefined #se o proximo caracter não for um '$', instrução não definida.
      jal readchar #le caracter
      bne $v0, 10, undefined #se o proximo caracter não for um 'enter', instrução não definida  
      j parser  #volta pra função leitura de caracter até achar próxima instrução.
#########################################################################
    i_sub:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 098, undefined  #se o proximo caracter não for 'b', instrução não definida.
      jal readchar  #le caracter
      beq $v0, 117, i_subu  #se o proximo caracter for 'u', funçao de escrita do subu 
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $s5, s_function_sub #coloca o function do sub em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      #j concatenastring
#########################################################################
    i_subu:
      jal readchar #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $s5, s_function_subu #coloca o function do subu em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.   
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      #j concatenastring
#########################################################################
    i_xor:
      jal readchar  #le caracter
      bne $v0, 111, undefined  #se o proximo caracter não for 'o', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 114, undefined  #se o proximo caracter não for 'r', instrução não definida.
      jal readchar  #le caracter
      #beq $v0, 105, i_xori  #se o proximo caracter for 'i', funçao de escrita do addi
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida. 
#########################################################################
    pegaregistrador:
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      beq $v0, 116, i_registradort  #se caracter = t, funcao que monta registrador tipo t
      beq $v0, 115, i_registradors_sp  #se caracter = s, funcao que monta registrador tipo s/sp
      beq $v0, 97, i_registradora  #se caracter = a, funcao que monta registrador tipo a
      beq $v0, 118, i_registradorv   #se caracter = v, funcao que monta registrador tipo v
      beq $v0, 122, i_registradorzero  #se caracter = z, funcao que monta registrador tipo zero
      beq $v0, 48, i_registradorzero  #se caracter = '0', funcao que monta registrador tipo zero
      beq $v0, 107, i_registradork   #se caracter = k, funcao que monta registrador tipo k
      beq $v0, 103, i_registradorgp  #se caracter = g, funcao que monta registrador tipo gp
      beq $v0, 102, i_registradorfp  #se caracter = fp, funcao que monta registrador tipo fp
      beq $v0, 114, i_registradorra  #se caracter = ra, funcao que monta registrador tipo ra
      jr $ra  #volta pra função leitura de caracter até achar próxima instrução.
##########################################################################      
    i_registradort:
      jal readchar #le caracter
      beq $v0, 48, i_tnumero0  #se t0, funcao que coloca string t0 no endereço s3 (rd)
      beq $v0, 49, i_tnumero1  #se t1, funcao que coloca string t1 no endereço s3 (rd)
      beq $v0, 50, i_tnumero2  #se t2, funcao que coloca string t2 no endereço s3 (rd)
      beq $v0, 51, i_tnumero3  #se t3, funcao que coloca string t3 no endereço s3 (rd)
      beq $v0, 52, i_tnumero4  #se t4, funcao que coloca string t4 no endereço s3 (rd)
      beq $v0, 53, i_tnumero5  #se t5, funcao que coloca string t5 no endereço s3 (rd)
      beq $v0, 54, i_tnumero6  #se t6, funcao que coloca string t6 no endereço s3 (rd)
      beq $v0, 55, i_tnumero7  #se t7, funcao que coloca string t7 no endereço s3 (rd)
      beq $v0, 56, i_tnumero8  #se t8, funcao que coloca string t8 no endereço s3 (rd)
      beq $v0, 57, i_tnumero9  #se t9, funcao que coloca string t9 no endereço s3 (rd)
      j undefined      

    i_tnumero0:
      beq $t0, 0, i_tnumero0rd
      beq $t0, 1, i_tnumero0rs
      beq $t0, 2, i_tnumero0rt
      j undefined
      i_tnumero0rd:
      la $s3, s_t0  #coloca string t0 em s3 (rd)
      j i_tnumero0continue
      i_tnumero0rs:
      la $s1, s_t0  #coloca string t0 em s3 (rs)
      j i_tnumero0continue
      i_tnumero0rt:
      la $s2, s_t0  #coloca string t0 em s3 (rt)
      j i_tnumero0continue
    i_tnumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero1:
      beq $t0, 0, i_tnumero1rd
      beq $t0, 1, i_tnumero1rs
      beq $t0, 2, i_tnumero1rt
      j undefined
      i_tnumero1rd:
      la $s3, s_t1  #coloca string t1 em s3 (rd)
      j i_tnumero1continue
      i_tnumero1rs:
      la $s1, s_t1  #coloca string t1 em s3 (rs)
      j i_tnumero1continue
      i_tnumero1rt:
      la $s2, s_t1  #coloca string t1 em s3 (rt)
      j i_tnumero1continue
    i_tnumero1continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero2:

      beq $t0, 0, i_tnumero2rd
      beq $t0, 1, i_tnumero2rs
      beq $t0, 2, i_tnumero2rt
      j undefined
      i_tnumero2rd:
      la $s3, s_t2  #coloca string t2 em s3 (rd)
      j i_tnumero2continue
      i_tnumero2rs:
      la $s1, s_t2  #coloca string t2 em s3 (rs)
      j i_tnumero2continue
      i_tnumero2rt:
      la $s2, s_t2  #coloca string t2 em s3 (rt)
      j i_tnumero2continue
    i_tnumero2continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero3:
      la $s3, s_t3  #coloca string t3 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_tnumero4:
      la $s3, s_t4  #coloca string t4 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_tnumero5:
      la $s3, s_t5  #coloca string t5 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_tnumero6:
      la $s3, s_t6  #coloca string t6 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_tnumero7:
      la $s3, s_t7  #coloca string t7 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_tnumero8:
      la $s3, s_t8  #coloca string t8 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_tnumero9:
      la $s3, s_t9  #coloca string t9 em s3 (rd)
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    
    i_registradors_sp:
      jal readchar #le caracter
      beq $v0, 112, i_registradorsp
      beq $v0, 48, i_snumero0  #se s0, funcao que coloca string s0 no endereço s3 (rd)
      beq $v0, 49, i_snumero1  #se s3 (rd), funcao que coloca string s3 (rd) no endereço s3 (rd)
      beq $v0, 50, i_snumero2  #se s2, funcao que coloca string s2 no endereço s3 (rd)
      beq $v0, 51, i_snumero3  #se s3, funcao que coloca string s3 no endereço s3 (rd)
      beq $v0, 52, i_snumero4  #se s4, funcao que coloca string s4 no endereço s3 (rd)
      beq $v0, 53, i_snumero5  #se s5, funcao que coloca string s5 no endereço s3 (rd)
      beq $v0, 54, i_snumero6  #se s6, funcao que coloca string s6 no endereço s3 (rd)
      beq $v0, 55, i_snumero7  #se s7, funcao que coloca string s7 no endereço s3 (rd)
      j undefined
    i_snumero0:
      la $s3, s_s0  #coloca string s0 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 
    i_snumero1:
      la $s3, s_s3  #coloca string s3 (rd) em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_snumero2:
      la $s3, s_s2  #coloca string s2 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_snumero3:
      la $s3, s_s3  #coloca string s3 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_snumero4:
      la $s3, s_s4  #coloca string s4 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_snumero5:
      la $s3, s_s5  #coloca string s5 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_snumero6:
      la $s3, s_s6  #coloca string s6 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_snumero7:
      la $s3, s_s7  #coloca string s7 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_registradorsp:
      la $s3, s_sp #coloca string sp em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra

    i_registradora:
      jal readchar #le caracter
      beq $v0, 48, i_anumero0  #se a0, funcao que coloca string a0 no endereço s3 (rd)
      beq $v0, 49, i_anumero1  #se a1, funcao que coloca string a1 no endereço s3 (rd)
      beq $v0, 50, i_anumero2  #se a2, funcao que coloca string a2 no endereço s3 (rd)
      beq $v0, 51, i_anumero3  #se a3, funcao que coloca string a3 no endereço s3 (rd)
      j undefined

    i_anumero0:
      la $s3, s_a0  #coloca string a0 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 
    i_anumero1:
      la $s3, s_a1  #coloca string a1 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_anumero2:
      la $s3, s_a2  #coloca string a2 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra
    i_anumero3:
      la $s3, s_a3  #coloca string a3 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra         

    i_registradorv:
      jal readchar #le caracter
      beq $v0, 48, i_vnumero0  #se v0, funcao que coloca string v0 no endereço s3 (rd)
      beq $v0, 49, i_vnumero1  #se v1, funcao que coloca string v1 no endereço s3 (rd)
      j undefined

    i_vnumero0:
      la $s3, s_a0  #coloca string v0 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 
    i_vnumero1:
      la $s3, s_a1  #coloca string v1 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra  

    i_registradorzero:
      jal readchar #le caracter
      beq $v0, 32, i_znumero
      bne $v0, 101, undefined  #se v0 != e
      jal readchar #le caracter
      bne $v0, 114, undefined
      jal readchar #le caracter
      beq $v0, 111, i_znumero #se 'zero', funcao que coloca string zero no endereço s3 (rd)

    i_znumero:
      la $s3, s_zero
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra  

    i_registradork:
      jal readchar #le caracter
      beq $v0, 48, i_knumero0  #se k0, funcao que coloca string k0 no endereço s3 (rd)
      beq $v0, 49, i_knumero1  #se k1, funcao que coloca string k1 no endereço s3 (rd)
      j undefined

    i_knumero0:
      la $s3, s_k0  #coloca string k0 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 
    i_knumero1:
      la $s3, s_k1  #coloca string k1 em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 

    i_registradorgp:
      jal readchar #le caracter
      beq $v0, 112, i_gpnumero #se gp, funcao que coloca string gp, no endereço s3 (rd)
      j undefined

    i_gpnumero:
      la $s3, s_gp  #coloca string gp em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 

    i_registradorfp:
      jal readchar #le caracter
      beq $v0, 112, i_fpnumero #se fp, funcao que coloca string fp, no endereço s3 (rd)
      j undefined

    i_fpnumero:
      la $s3, s_fp  #coloca string fp em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra     

    i_registradorra:
      jal readchar #le caracter
      beq $v0, 97, i_ranumero #se ra, funcao que coloca string ra, no endereço s3 (rd)
      j undefined

    i_ranumero:
      la $s3, s_fp  #coloca string ra em s3 (rd)
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      jr $ra 
#########################################################################    
# Concatenate string
# Ideia: concatenar as strings respectivas dos tipos R em seus campos. Converter string para hexa usando shift de bits. Escrever for para dar update no endereço de 4 em 4 em hexa. Em seguida adicionar código convertido de string pra hexa ao lado.
# Copy first string to result buffer
#la $a0, str1
#la $a1, result
#jal strcopier
#nop

# Concatenate second string on result buffer
#la $a0, str2
#or $a1, $v0, $zero
#jal strcopier
#nop
#j finish
#nop

# String copier function
#strcopier:
#or $t0, $a0, $zero # Source
#or $t1, $a1, $zero # Destination

#loop:
#lb $t2, 0($t0)
#beq $t2, $zero, end
#addiu $t0, $t0, 1
#sb $t2, 0($t1)
#addiu $t1, $t1, 1
#b loop
#nop

#end:
#or $v0, $t1, $zero # Return last position on result buffer
#jr $ra
#nop

#finish:
#j finish
#nop
#########################################################################
readchar:   
  li $v0,14 # prepara para ler caracter do arquivo
  move $a0,$s5  # aponta pro ponteiro no arquivo
  la $a1,buffer # salva em buffer 
  li $a2,1        # le um caracter
  syscall
  beq $v0, $0, loopend  #se eof, fim leitura
  lb $v0,buffer # le um byte armazenado em buffer
#########################################################################
#  print:  
#    li $v0, 11    # prepara para escrever (printf)
#    move $a0, $t1 # escreve caracter no buffer
#    syscall         
loopend: #fim leitura/print
#  li $v0, 1 
#  add $a0, $zero, $t1
#  syscall
  jr $ra  
#########################################################################
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
