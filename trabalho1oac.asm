#Afonso Dias - 14/0055771 Guilherme Andreuce - 14/0141961
#------------------------------------------------------------------------------------------------------------------------------------
#
#Desenvolver uma aplicação que realize a partir de uma entrada um arquivo texto ASCII com o
#código-fonte elaborado por instruções assembly MIPS (arquivos com a extensão “.asm��?), em que este seja
#capaz de gerar um código objeto montado em Hexadecimal em arquivo de texto ASCII, no formato MIF
#(Memory Inicialization File) de uma listagem de instruções pré-definidas e disponíveis no Requisito 2, e
#contidas especificamente nas áreas .text e .data do arquivo de entrada (.asm) fornecido pelo usuário da
#aplicação. Deverá ser gerado na saída um arquivo, também em codificação ASCII, com o mesmo nome do
#arquivo de entrada, com a extensão “.mif��? (um arquivo para a área .data e outro para a área .text).
#Reforçando que a aplicação deverá comtemplar como argumento de entrada, além de todo o leque de
#registradores inteiros da CPU MIPS, incluindo as máscaras atribuídas aos registradores, bem como permitir a
#entrada no campo imediato de números inteiro e/ou decimais, ambos inteiros e sinalizados.
#Deve ser observado que arquivos MIF (extensão “.mif��?) possuem formatação e organização dos dados próprios
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
#            | OP  | RS  |  RT  |  RD  |  SHAMT  |  FUNCT |
#            |  6  |  5  |  5   |   5  |     5   |    6   |
#        R:  | OP  | RS  |  RT  |  RD  |  SHAMT  |  FUNCT |
#        I:  | OP  | RS  |  RT  |        ADDRES / IMM     |
#        J:  | OP  |           TARGET / ADDRESS           |
#        */
#------------------------------------------------------------------------------------------------------------------------------------
#
#https://stackoverflow.com/questions/30770508/how-to-represent-mips-instruction-as-its-hex-representation link para fazer jumps 

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
s_espacodoispontosespaco:  .asciiz " : "
s_quebralinha:  .asciiz "\n"

msgerrodigito: .asciiz "The string does not contain valid digits."
s_undefined:    .asciiz "instrução não definida"
#
s_tohex0: .asciiz "0"
s_tohex1: .asciiz "1"
s_tohex2: .asciiz "2"
s_tohex3: .asciiz "3"
s_tohex4: .asciiz "4"
s_tohex5: .asciiz "5"
s_tohex6: .asciiz "6"
s_tohex7: .asciiz "7"
s_tohex8: .asciiz "8"
s_tohex9: .asciiz "9"
s_tohexA: .asciiz "a"
s_tohexB: .asciiz "b"
s_tohexC: .asciiz "c"
s_tohexD: .asciiz "d"
s_tohexE: .asciiz "e"
s_tohexF: .asciiz "f"
s_zero_0_em_bin: .asciiz "00000"
s_at_1_em_bin:   .asciiz "00001"
s_v0_2_em_bin:   .asciiz "00010"
s_v1_3_em_bin:   .asciiz "00011"
s_a0_4_em_bin:   .asciiz "00100"
s_a1_5_em_bin:   .asciiz "00101"
s_a2_6_em_bin:   .asciiz "00110"
s_a3_7_em_bin_6_em_bin:   .asciiz "00111"
s_t0_8_em_bin:   .asciiz "01000"
s_t1_9_em_bin:   .asciiz "01001"
s_t2_10_em_bin:   .asciiz "01010"
s_t3_11_em_bin:   .asciiz "01011"
s_t4_12_em_bin:   .asciiz "01100"
s_t5_13_em_bin:   .asciiz "01101"
s_t6_14_em_bin:   .asciiz "01110"
s_t7_15_em_bin:   .asciiz "01111"
s_s0_16_em_bin:   .asciiz "10000"
s_s1_17_em_bin:   .asciiz "10001"
s_s2_18_em_bin:   .asciiz "10010"
s_s3_19_em_bin:   .asciiz "10011"
s_s4_20_em_bin:   .asciiz "10100"
s_s5_21_em_bin:   .asciiz "10101"
s_s6_22_em_bin:   .asciiz "10110"
s_s7_23_em_bin:   .asciiz "10111"
s_t8_24_em_bin:   .asciiz "11000"
s_t9_25_em_bin:   .asciiz "11001"
s_k0_26_em_bin:   .asciiz "11010"
s_k1_27_em_bin:   .asciiz "11011"
s_gp_28_em_bin:   .asciiz "11100"
s_sp_29_em_bin:   .asciiz "11101"
s_fp_30_em_bin:   .asciiz "11110"
s_ra_31_em_bin:   .asciiz "11111"
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
s_opcode_clo:   .asciiz "011100"
s_shamttipor: .asciiz "00000"
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
s_function_clo:   .asciiz "100001"
#instruções tipo i e j não tem function
#
#concatenacao de string
s_converted:  .space 32
s_constroi1: .space 32
s_constroi2: .space 32
s_constroi3: .space 32
s_constroi4: .space 32
#
#conversao binario hexa
s_hex0: .asciiz "0"
s_hex1: .asciiz "1"
s_hex2: .asciiz "2"
s_hex3: .asciiz "3"
s_hex4: .asciiz "4"
s_hex5: .asciiz "5"
s_hex6: .asciiz "6"
s_hex7: .asciiz "7"
s_hex8: .asciiz "8"
s_hex9: .asciiz "9"
s_hexA: .asciiz "A"
s_hexB: .asciiz "B"
s_hexC: .asciiz "C"
s_hexD: .asciiz "D"
s_hexE: .asciiz "E"
s_hexF: .asciiz "F"
#conversao caracter numero hexa
s_chex0: .asciiz "0000"
s_chex1: .asciiz "0001"
s_chex2: .asciiz "0010"
s_chex3: .asciiz "0011"
s_chex4: .asciiz "0100"
s_chex5: .asciiz "0101"
s_chex6: .asciiz "0110"
s_chex7: .asciiz "0111"
s_chex8: .asciiz "1000"
s_chex9: .asciiz "1001"
s_chexA: .asciiz "1010"
s_chexB: .asciiz "1011"
s_chexC: .asciiz "1100"
s_chexD: .asciiz "1101"
s_chexE: .asciiz "1110"
s_chexF: .asciiz "1111"
hexa: .space 8
# 
buffer:   .space  4
buffer_caracter_decimal: .space 16
buffer_decimal_salvo: .space 32
buffer_decimal_data_salvo: .space 32
s_debug_de_pobre: .asciiz "passei aqui"
bufferarmazenanibble: .space 32
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
  la   $a0, fouttext # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor for writing data in $s6
#########################################################################
  li   $v0, 13       # system call for open file
  la   $a0, foutdata # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s7, $v0      # save the file descriptor for writing text in $s6
################################################################################################################################################
main:
  jal readchar       #le primeiro caracter
  bne $v0, 46, undefined #se o caracter não for um '.' não vai para o switch de instrução
########################################################################
  parser:
    jal readchar    #le caracter
    beq $v0, 10, parser   #se caracter for 'enter', continua caminhando no arquivo
    beq $v0, 32, parser   #se caracter for 'espaço', continua caminhando no arquivo
    beq $v0, 100, i_d  #se caracter for um 'd' vai pra função verificacao comecando por d
    beq $v0, 116, i_text  #se caracter for um 't' vai pra função de escrita do .text
    beq $v0, 97, i_a    #se caracter for um 'a' vai pra função de verificacao comecando por 'a'
    beq $v0, 115, i_s   #se caracter for um 's' vai pra função de verificacao comecando por 's'
    beq $v0, 120, i_xor    #se caracter for um 'x' vai para função de escrita do xor, xori
    beq $v0, 111, i_or    #se caracter for um 'o' vai para função de escrita do or, ori
    beq $v0, 110, i_nor  #se caracter for um 'n' vai para funcao de escrita do nor
    beq $v0, 106, i_j  #se caracter for um 'j' vai para funcao de verificao comecando por 'j'
    beq $v0, 109, i_m  #se caracter for um 'm' vai para funcao de verificao comecando por 'm' 
    beq $v0, 99, i_clo
    beq $v0, 36, parser    
#########################################################################
  i_a:
    jal readchar  #le caracter
    beq $v0, 100, i_add  #se o proximo caracter for 'd', manda pro i_add para verificar se eh add, addi ou addiu
    beq $v0, 110, i_and  #se o proximo caracter for 'n', manda pro i_and para verificar se eh and ou andi
    j undefined
#########################################################################
  i_d:
    jal readchar  #le caracter
    beq $v0, 97, i_data  #se o proximo caracter for 'a', manda pro i_data para verificar se eh .data
    beq $v0, 105, i_div  #se o proximo caracter for 'i', manda pro i_div
    j undefined    
#########################################################################
  i_m:
    jal readchar  #le caracter
    beq $v0, 117, i_mult  #se o proximo caracter for 'u', manda pro i_mult
    beq $v0, 102, i_mfhi  #se o proximo caracter for 'f', manda pro i_mfhi para verificar se eh and mfhi ou mflo
    j undefined    
#########################################################################
  i_j:
    jal readchar  #le caracter
    beq $v0, 114, i_jr  #se o proximo caracter for 'd', manda pro i_jr
    #beq $v0, 97, i_jal  #se o proximo caracter for 'a', manda pro i_jal
    #beq $v0, 32, i_jump  #se o proximo caracter for 'espaço', manda pro i_jump

    j undefined
#########################################################################
  i_s:
    jal readchar  #le caracter
    beq $v0, 117, i_sub  #se o proximo caracter for 'u', manda pro i_sub para verificar se eh sub ou subu
    #beq $v0, 119, i_sw  #se o proximo caracter for 'w', manda pro i_sw
    beq $v0, 108, i_sll  #se o proximo caracter for 'l', manda pro i_sll para verificar se eh sll ou slt
    beq $v0, 114, i_srl  #se o proximo caracter for 'r', manda pro i_srl para verificar se eh srl ou srav
    j undefined
#########################################################################
    i_data:
      #check if .data
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
      move $t8, $zero    # contador endereço
      addi $t8, $t8, 0x00400000 #contador endereço
      loopatewordoutext:
      jal readchar #le caracter
      bne $v0, 46, loopatewordoutext #se o caracter não for um '.', le caracter #le .data até achar .word. Se não achar, data = vazia e proximo . é text.
      jal readchar #le caracter
      beq $v0, 116, i_text #verifica se é .text
      bne $v0, 119, undefined #se não for w, instrucao nao definida
      jal readchar #le caracter
      bne $v0, 111, undefined #se não for o, instrucao nao definida
      jal readchar #le caracter
      bne $v0, 114, undefined #se não for r, instrucao nao definida
      jal readchar #le caracter
      bne $v0, 100, undefined #se não for d, instrucao nao definida
      jal readchar #le caracter
      bne $v0, 32, undefined #se não for espaço, instrucao nao definida
      #j parser
      loopescreveword:
      jal escrevearquivodata
      jal readchar
      beq $v0, 44, escrevearquivodata
      bne $v0, 10, loopescreveword
      j loopatewordoutext 
##################################################################################################################################################
escrevearquivodata:
      addi $sp, $sp, -4
      sw $ra, 0($sp)
      jal armazenanibbledata
      jal espacodoispontosespacodata
      jal i_vetordecaracteresparadecimal
      jal converte_pra_decimal
      move $t0, $0
      move $t1, $0
      move $t2, $0
      move $t3, $0
      move $t4, $0
      move $t5, $0
      move $t6, $0
      la $t3, buffer_decimal_salvo
      lw $t2, 1($t3)
      la $t3, buffer_decimal_data_salvo
      jal armazenaimediatodata
      jal quebralinhadata
      addi $t8, $t8, 4
      j gobackcaller      
##################################################################################################################################################
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
      move $t8, $zero    # contador endereço
      addi $t8, $t8, 0x00400000 #contador endereço
      beq $v0, 10, parser #se o proximo caracter for 'enter', volta pra função leitura de caracter até achar próxima instrução.
      j parser
##################################################################################################################################################
    i_clo:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 108, undefined  #se o proximo caracter não for 'l', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 111, undefined  #se o proximo caracter não for 'o', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      la $s0, s_opcode_clo  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_clo #coloca o function do add em t9
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
      la $s2, s_zero_0_em_bin
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
##################################################################################################################################################
    
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
      jal readchar #le caracter
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_add #coloca o function do add em t9
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#######################################################################################################################
    i_addu:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_addu #coloca o function do addu em s5
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
       jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser 
#########################################################################
    i_addi:
      move $t0, $zero #contador de registrador (0 registrador rd
      addi $t0, $t0, 1  #incrementa contador
      jal readchar #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar #le caracter
      bne $v0, 36, undefined #se o proximo caracter não for um '$', instrução não definida.
      la $s0, s_opcode_addi  #coloca opcode add em s0
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
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal i_vetordecaracteresparadecimal
      jal converte_pra_decimal
      addi $t8, $t8, 3
      la $s3, buffer_decimal_salvo($t8)
      j debug_de_pobre

#########################################################################################################################      
    i_and:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 100, undefined  #se o proximo caracter não for 'd', instrução não definida.
      jal readchar  #le caracter
      #beq $v0, 105, i_andi  #se o proximo caracter for 'i', funçao de escrita do addi
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_and #coloca o function do add em t9
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
##################################################################################################################################################
    i_or:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 114, undefined  #se o proximo caracter não for 'r', instrução não definida.
      jal readchar  #le caracter
      #beq $v0, 105, i_ori  #se o proximo caracter for 'i', funçao de escrita do addi
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_or #coloca o function do add em t9
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
##################################################################################################################################################
    i_nor:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 111, undefined  #se o proximo caracter não for 'o', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 114, undefined  #se o proximo caracter não for 'r', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_nor #coloca o function do add em t9
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
###################################################################################################################################################
    i_sub:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 98, undefined  #se o proximo caracter não for 'b', instrução não definida.
      jal readchar  #le caracter
      beq $v0, 117, i_subu  #se o proximo caracter for 'u', funçao de escrita do subu
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_sub #coloca o function do sub em s5
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_subu:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_subu #coloca o function do subu em s5
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_xor:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar  #le caracter
      bne $v0, 111, undefined  #se o proximo caracter não for 'o', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 114, undefined  #se o proximo caracter não for 'r', instrução não definida.
      jal readchar  #le caracter
      #beq $v0, 105, i_xori  #se o proximo caracter for 'i', funçao de escrita do addi
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_xor #coloca o function do subu em s5
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_mult:
      move $t0, $zero #contador de registrador (0 registrador rd)
      addi $t0, $t0, 1  #incrementa contado
      jal readchar  #le caracter
      bne $v0, 108, undefined  #se o proximo caracter não for 'l', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 116, undefined  #se o proximo caracter não for 't', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_mult #coloca o function do subu em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      la $s3, s_zero_0_em_bin
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_div:
      move $t0, $zero #contador de registrador (0 registrador rd)
      addi $t0, $t0, 1  #incrementa contador
      jal readchar  #le caracter
      bne $v0, 118, undefined  #se o proximo caracter não for 'v', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_div #coloca o function do div em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      la $s3, s_zero_0_em_bin
      jal readchar
      addi $t0, $t0, 1  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser                  
##################################################################################################################################################
    i_jr:
      move $t0, $zero #contador de registrador (0 registrador rd)
      addi $t0, $t0, 1  #incrementa contador
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_jr #coloca o function do add em t9
      la $s3, s_zero_0_em_bin
      la $s2, s_zero_0_em_bin
      jal pegaregistrador #função que pega registrador
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser                  
#########################################################################
    i_sll:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar
      beq $v0, 116, i_slt #se o proximo caracter não for um 't', vai pra slt
      bne $v0, 108, undefined
      jal readchar
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $t9, s_function_sll #coloca o function do sll em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      la $s1, s_zero_0_em_bin
      jal readchar
      addi $t0, $t0, 2  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrado
      jal readchar
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal i_vetordecaracteresparadecimal
      jal converte_pra_decimal
      jal pega_valor_shamt
      move $s4, $a1 #coloca shamt em s4
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_srl:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar
      beq $v0, 97, i_srav #se o proximo caracter não for um 't', vai pra slt
      bne $v0, 108, undefined
      jal readchar
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $t9, s_function_srl #coloca o function do srl em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      la $s1, s_zero_0_em_bin
      jal readchar
      addi $t0, $t0, 2  #incrementa contador
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrado
      jal readchar
      bne $v0, 44, undefined #se o proximo caracter não for um ',', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal i_vetordecaracteresparadecimal
      jal converte_pra_decimal
      jal pega_valor_shamt
      move $s4, $a1 #coloca shamt em s4
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_slt:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_slt #coloca o function do subu em s5
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_srav:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar
      bne $v0, 118, undefined # se nao for v, undefined
      jal readchar
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_srav #coloca o function do subu em s5
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
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_mfhi:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar
      beq $v0, 108, i_mflo #se o proximo caracter não for um 'l', vai pra mflo
      bne $v0, 104, undefined # se n for h undefined
      jal readchar
      bne $v0, 105, undefined # se n for i undefined
      jal readchar
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_mfhi #coloca o function do mfhi em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      la $s1, s_zero_0_em_bin
      la $s2, s_zero_0_em_bin
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser
#########################################################################
    i_mflo:
      move $t0, $zero #contador de registrador (0 registrador rd)
      jal readchar
      bne $v0, 111, undefined #se n for o, não definido
      jal readchar
      bne $v0, 32, undefined #se o proximo caracter não for um 'espaço', instrução não definida.
      jal readchar  #le caracter
      bne $v0, 36, undefined  #se o proximo caracter não for um '$', instrução não definida
      la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
      la $s4, s_shamttipor #coloca shamt em tipos r em s4
      la $t9, s_function_mflo #coloca o function do subu em s5
      jal readchar #le caracter
      jal pegaregistrador #função que pega registrador
      la $s1, s_zero_0_em_bin
      la $s2, s_zero_0_em_bin
      la $t9, s_function_mflo #coloca o function do mflo em s5
      jal armazenanibble
      jal espacodoispontosespaco
      jal concatenate
      jal quebralinha
      j parser   
##########################################################################################      
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
      la $s3, s_t0_8_em_bin  #coloca string t0 em s3 (rd)
      j i_tnumero0continue
      i_tnumero0rs:
      la $s1, s_t0_8_em_bin  #coloca string t0 em s1 (rs)
      j i_tnumero0continue
      i_tnumero0rt:
      la $s2, s_t0_8_em_bin  #coloca string t0 em s2 (rt)
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
      la $s3, s_t1_9_em_bin  #coloca string t1 em s3 (rd)
      j i_tnumero1continue
      i_tnumero1rs:
      la $s1, s_t1_9_em_bin  #coloca string t1 em s3 (rs)
      j i_tnumero1continue
      i_tnumero1rt:
      la $s2, s_t1_9_em_bin  #coloca string t1 em s3 (rt)
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
      la $s3, s_t2_10_em_bin  #coloca string t2 em s3 (rd)
      j i_tnumero2continue
      i_tnumero2rs:
      la $s1, s_t2_10_em_bin  #coloca string t2 em s3 (rs)
      j i_tnumero2continue
      i_tnumero2rt:
      la $s2, s_t2_10_em_bin  #coloca string t2 em s3 (rt)
      j i_tnumero2continue
    i_tnumero2continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero3:

      beq $t0, 0, i_tnumero3rd
      beq $t0, 1, i_tnumero3rs
      beq $t0, 2, i_tnumero3rt
      j undefined
      i_tnumero3rd:
      la $s3, s_t3_11_em_bin  #coloca string t3 em s3 (rd)
      j i_tnumero3continue
      i_tnumero3rs:
      la $s1, s_t3_11_em_bin  #coloca string t3 em s3 (rs)
      j i_tnumero3continue
      i_tnumero3rt:
      la $s2, s_t3_11_em_bin  #coloca string t3 em s3 (rt)
      j i_tnumero3continue
    i_tnumero3continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero4:

      beq $t0, 0, i_tnumero4rd
      beq $t0, 1, i_tnumero4rs
      beq $t0, 2, i_tnumero4rt
      j undefined
      i_tnumero4rd:
      la $s3, s_t4_12_em_bin  #coloca string t4 em s3 (rd)
      j i_tnumero4continue
      i_tnumero4rs:
      la $s1, s_t4_12_em_bin  #coloca string t4 em s1 (rs)
      j i_tnumero4continue
      i_tnumero4rt:
      la $s2, s_t4_12_em_bin  #coloca string t4 em s2 (rt)
      j i_tnumero4continue
    i_tnumero4continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero5:

      beq $t0, 0, i_tnumero5rd
      beq $t0, 1, i_tnumero5rs
      beq $t0, 2, i_tnumero5rt
      j undefined
      i_tnumero5rd:
      la $s3, s_t5_13_em_bin  #coloca string t5 em s3 (rd)
      j i_tnumero5continue
      i_tnumero5rs:
      la $s1, s_t5_13_em_bin  #coloca string t5 em s1 (rs)
      j i_tnumero5continue
      i_tnumero5rt:
      la $s2, s_t5_13_em_bin  #coloca string t5 em s2 (rt)
      j i_tnumero5continue
    i_tnumero5continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero6:

      beq $t0, 0, i_tnumero6rd
      beq $t0, 1, i_tnumero6rs
      beq $t0, 2, i_tnumero6rt
      j undefined
      i_tnumero6rd:
      la $s3, s_t6_14_em_bin  #coloca string t6 em s3 (rd)
      j i_tnumero6continue
      i_tnumero6rs:
      la $s1, s_t6_14_em_bin  #coloca string t6 em s1 (rs)
      j i_tnumero6continue
      i_tnumero6rt:
      la $s2, s_t6_14_em_bin  #coloca string t6 em s2 (rt)
      j i_tnumero6continue
    i_tnumero6continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero7:

      beq $t0, 0, i_tnumero7rd
      beq $t0, 1, i_tnumero7rs
      beq $t0, 2, i_tnumero7rt
      j undefined
      i_tnumero7rd:
      la $s3, s_t7_15_em_bin  #coloca string t7 em s3 (rd)
      j i_tnumero7continue
      i_tnumero7rs:
      la $s1, s_t7_15_em_bin  #coloca string t7 em s1 (rs)
      j i_tnumero7continue
      i_tnumero7rt:
      la $s2, s_t7_15_em_bin  #coloca string t7 em s2 (rt)
      j i_tnumero7continue
    i_tnumero7continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero8:

      beq $t0, 0, i_tnumero8rd
      beq $t0, 1, i_tnumero8rs
      beq $t0, 2, i_tnumero8rt
      j undefined
      i_tnumero8rd:
      la $s3, s_t8_24_em_bin  #coloca string t8 em s3 (rd)
      j i_tnumero8continue
      i_tnumero8rs:
      la $s1, s_t8_24_em_bin  #coloca string t8 em s1 (rs)
      j i_tnumero8continue
      i_tnumero8rt:
      la $s2, s_t8_24_em_bin  #coloca string t8 em s2 (rt)
      j i_tnumero8continue
    i_tnumero8continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_tnumero9:

      beq $t0, 0, i_tnumero9rd
      beq $t0, 1, i_tnumero9rs
      beq $t0, 2, i_tnumero9rt
      j undefined
      i_tnumero9rd:
      la $s3, s_t9_25_em_bin  #coloca string t9 em s3 (rd)
      j i_tnumero9continue
      i_tnumero9rs:
      la $s1, s_t9_25_em_bin  #coloca string t9 em s1 (rs)
      j i_tnumero9continue
      i_tnumero9rt:
      la $s2, s_t9_25_em_bin  #coloca string t9 em s2 (rt)
      j i_tnumero9continue
    i_tnumero9continue:
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

      beq $t0, 0, i_snumero0rd
      beq $t0, 1, i_snumero0rs
      beq $t0, 2, i_snumero0rt
      j undefined
      i_snumero0rd:
      la $s3, s_s0_16_em_bin  #coloca string s0 em s3 (rd)
      j i_snumero0continue
      i_snumero0rs:
      la $s1, s_s0_16_em_bin  #coloca string s0 em s1 (rs)
      j i_snumero0continue
      i_snumero0rt:
      la $s2, s_s0_16_em_bin  #coloca string s0 em s2 (rt)
      j i_snumero0continue
    i_snumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero1:

      beq $t0, 0, i_snumero1rd
      beq $t0, 1, i_snumero1rs
      beq $t0, 2, i_snumero1rt
      j undefined
      i_snumero1rd:
      la $s3, s_s1_17_em_bin  #coloca string s1 em s3 (rd)
      j i_snumero1continue
      i_snumero1rs:
      la $s1, s_s1_17_em_bin  #coloca string s1 em s1 (rs)
      j i_snumero1continue
      i_snumero1rt:
      la $s2, s_s1_17_em_bin  #coloca string s1 em s2 (rt)
      j i_snumero1continue
    i_snumero1continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero2:

      beq $t0, 0, i_snumero2rd
      beq $t0, 1, i_snumero2rs
      beq $t0, 2, i_snumero2rt
      j undefined
      i_snumero2rd:
      la $s3, s_s2_18_em_bin  #coloca string s2 em s3 (rd)
      j i_snumero2continue
      i_snumero2rs:
      la $s1, s_s2_18_em_bin  #coloca string s2 em s1 (rs)
      j i_snumero2continue
      i_snumero2rt:
      la $s2, s_s2_18_em_bin  #coloca string s2 em s2 (rt)
      j i_snumero2continue
    i_snumero2continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero3:

      beq $t0, 0, i_snumero3rd
      beq $t0, 1, i_snumero3rs
      beq $t0, 2, i_snumero3rt
      j undefined
      i_snumero3rd:
      la $s3, s_s3_19_em_bin  #coloca string s3 em s3 (rd)
      j i_snumero3continue
      i_snumero3rs:
      la $s1, s_s3_19_em_bin  #coloca string s3 em s1 (rs)
      j i_snumero3continue
      i_snumero3rt:
      la $s2, s_s3_19_em_bin  #coloca string s3 em s2 (rt)
      j i_snumero3continue
    i_snumero3continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero4:

      beq $t0, 0, i_snumero4rd
      beq $t0, 1, i_snumero4rs
      beq $t0, 2, i_snumero4rt
      j undefined
      i_snumero4rd:
      la $s3, s_s4_20_em_bin  #coloca string s4 em s3 (rd)
      j i_snumero4continue
      i_snumero4rs:
      la $s1, s_s4_20_em_bin  #coloca string s4 em s1 (rs)
      j i_snumero4continue
      i_snumero4rt:
      la $s2, s_s4_20_em_bin  #coloca string s4 em s2 (rt)
      j i_snumero4continue
    i_snumero4continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero5:

      beq $t0, 0, i_snumero5rd
      beq $t0, 1, i_snumero5rs
      beq $t0, 2, i_snumero5rt
      j undefined
      i_snumero5rd:
      la $s3, s_s5_21_em_bin  #coloca string s5 em s3 (rd)
      j i_snumero5continue
      i_snumero5rs:
      la $s1, s_s5_21_em_bin  #coloca string s5 em s1 (rs)
      j i_snumero5continue
      i_snumero5rt:
      la $s2, s_s5_21_em_bin  #coloca string s5 em s2 (rt)
      j i_snumero5continue
    i_snumero5continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero6:

      beq $t0, 0, i_snumero6rd
      beq $t0, 1, i_snumero6rs
      beq $t0, 2, i_snumero6rt
      j undefined
      i_snumero6rd:
      la $s3, s_s6_22_em_bin  #coloca string s6 em s3 (rd)
      j i_snumero6continue
      i_snumero6rs:
      la $s1, s_s6_22_em_bin  #coloca string s6 em s1 (rs)
      j i_snumero6continue
      i_snumero6rt:
      la $s2, s_s6_22_em_bin  #coloca string s6 em s2 (rt)
      j i_snumero6continue
    i_snumero6continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_snumero7:

      beq $t0, 0, i_snumero7rd
      beq $t0, 1, i_snumero7rs
      beq $t0, 2, i_snumero7rt
      j undefined
      i_snumero7rd:
      la $s3, s_s7_23_em_bin  #coloca string s7 em s3 (rd)
      j i_snumero7continue
      i_snumero7rs:
      la $s1, s_s7_23_em_bin  #coloca string s7 em s1 (rs)
      j i_snumero7continue
      i_snumero7rt:
      la $s2, s_s7_23_em_bin  #coloca string s7 em s2 (rt)
      j i_snumero7continue
    i_snumero7continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradorsp:

      beq $t0, 0, i_registradorsprd
      beq $t0, 1, i_registradorsprs
      beq $t0, 2, i_registradorsprt
      j undefined
      i_registradorsprd:
      la $s3, s_sp_29_em_bin  #coloca string sp em s3 (rd)
      j i_registradorspcontinue
      i_registradorsprs:
      la $s1, s_sp_29_em_bin  #coloca string sp em s1 (rs)
      j i_registradorspcontinue
      i_registradorsprt:
      la $s2, s_sp_29_em_bin  #coloca string sp em s2 (rt)
      j i_registradorspcontinue
    i_registradorspcontinue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradora:
      jal readchar #le caracter
      beq $v0, 48, i_anumero0  #se a0, funcao que coloca string a0 no endereço s3 (rd)
      beq $v0, 49, i_anumero1  #se a1, funcao que coloca string a1 no endereço s3 (rd)
      beq $v0, 50, i_anumero2  #se a2, funcao que coloca string a2 no endereço s3 (rd)
      beq $v0, 51, i_anumero3  #se a3, funcao que coloca string a3 no endereço s3 (rd)
      j undefined

    i_anumero0:
      beq $t0, 0, i_anumero0rd
      beq $t0, 1, i_anumero0rs
      beq $t0, 2, i_anumero0rt
      j undefined
      i_anumero0rd:
      la $s3, s_a0_4_em_bin  #coloca string a0 em s3 (rd)
      j i_anumero0continue
      i_anumero0rs:
      la $s1, s_a0_4_em_bin  #coloca string a0 em s1 (rs)
      j i_anumero0continue
      i_anumero0rt:
      la $s2, s_a0_4_em_bin  #coloca string a0 em s2 (rt)
      j i_anumero0continue
    i_anumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_anumero1:
      beq $t0, 0, i_anumero1rd
      beq $t0, 1, i_anumero1rs
      beq $t0, 2, i_anumero1rt
      j undefined
      i_anumero1rd:
      la $s3, s_a1_5_em_bin  #coloca string a1 em s3 (rd)
      j i_anumero1continue
      i_anumero1rs:
      la $s1, s_a1_5_em_bin  #coloca string a1 em s1 (rs)
      j i_anumero1continue
      i_anumero1rt:
      la $s2, s_a1_5_em_bin  #coloca string a1 em s2 (rt)
      j i_anumero1continue
    i_anumero1continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_anumero2:
      beq $t0, 0, i_anumero2rd
      beq $t0, 1, i_anumero2rs
      beq $t0, 2, i_anumero2rt
      j undefined
      i_anumero2rd:
      la $s3, s_a2_6_em_bin  #coloca string a2 em s3 (rd)
      j i_anumero2continue
      i_anumero2rs:
      la $s1, s_a2_6_em_bin  #coloca string a2 em s1 (rs)
      j i_anumero2continue
      i_anumero2rt:
      la $s2, s_a2_6_em_bin  #coloca string a2 em s2 (rt)
      j i_anumero2continue
    i_anumero2continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_anumero3:
      beq $t0, 0, i_anumero3rd
      beq $t0, 1, i_anumero3rs
      beq $t0, 2, i_anumero3rt
      j undefined
      i_anumero3rd:
      la $s3, s_a3_7_em_bin_6_em_bin  #coloca string a3 em s3 (rd)
      j i_anumero3continue
      i_anumero3rs:
      la $s1, s_a3_7_em_bin_6_em_bin  #coloca string a3 em s1 (rs)
      j i_anumero3continue
      i_anumero3rt:
      la $s2, s_a3_7_em_bin_6_em_bin  #coloca string a3 em s2 (rt)
      j i_anumero3continue
    i_anumero3continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradorv:
      jal readchar #le caracter
      beq $v0, 48, i_vnumero0  #se v0, funcao que coloca string v0 no endereço s3 (rd)
      beq $v0, 49, i_vnumero1  #se v1, funcao que coloca string v1 no endereço s3 (rd)
      j undefined

    i_vnumero0:
      beq $t0, 0, i_vnumero0rd
      beq $t0, 1, i_vnumero0rs
      beq $t0, 2, i_vnumero0rt
      j undefined
      i_vnumero0rd:
      la $s3, s_v0_2_em_bin  #coloca string v0 em s3 (rd)
      j i_vnumero0continue
      i_vnumero0rs:
      la $s1, s_v0_2_em_bin  #coloca string v0 em s1 (rs)
      j i_vnumero0continue
      i_vnumero0rt:
      la $s2, s_v0_2_em_bin  #coloca string v0 em s2 (rt)
      j i_vnumero0continue
    i_vnumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_vnumero1:
      beq $t0, 0, i_vnumero1rd
      beq $t0, 1, i_vnumero1rs
      beq $t0, 2, i_vnumero1rt
      j undefined
      i_vnumero1rd:
      la $s3, s_v1_3_em_bin  #coloca string v1 em s3 (rd)
      j i_vnumero1continue
      i_vnumero1rs:
      la $s1, s_v1_3_em_bin  #coloca string v1 em s1 (rs)
      j i_vnumero1continue
      i_vnumero1rt:
      la $s2, s_v1_3_em_bin  #coloca string v1 em s2 (rt)
      j i_vnumero1continue
    i_vnumero1continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
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
      beq $t0, 0, i_znumero1rd
      beq $t0, 1, i_znumero1rs
      beq $t0, 2, i_znumero1rt
      j undefined
      i_znumero1rd:
      la $s3, s_zero_0_em_bin
      j i_znumero1continue
    i_znumero1rs:
      la $s1, s_zero_0_em_bin
      j i_znumero1continue
      i_znumero1rt:
      la $s2, s_zero_0_em_bin
      j i_znumero1continue
      i_znumero1continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradork:
      jal readchar #le caracter
      beq $v0, 48, i_knumero0  #se k0, funcao que coloca string k0 no endereço s3 (rd)
      beq $v0, 49, i_knumero1  #se k1, funcao que coloca string k1 no endereço s3 (rd)
      j undefined

    i_knumero0:
      beq $t0, 0, i_knumero0rd
      beq $t0, 1, i_knumero0rs
      beq $t0, 2, i_knumero0rt
      j undefined
      i_knumero0rd:
      la $s3, s_k0_26_em_bin  #coloca string k0 em s3 (rd)
      j i_knumero0continue
      i_knumero0rs:
      la $s1, s_k0_26_em_bin  #coloca string k0 em s3 (rd)
      j i_knumero0continue
      i_knumero0rt:
      la $s2, s_k0_26_em_bin  #coloca string k0 em s3 (rd)
      j i_knumero0continue
      i_knumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
    i_knumero1:
      beq $t0, 0, i_knumero1rd
      beq $t0, 1, i_knumero1rs
      beq $t0, 2, i_knumero1rt
      j undefined
      i_knumero1rd:
      la $s3, s_k1_27_em_bin  #coloca string k1 em s3 (rd)
      j i_knumero1continue
      i_knumero1rs:
    la $s1, s_k1_27_em_bin  #coloca string k1 em s3 (rd)
      j i_knumero1continue
      i_knumero1rt:
      la $s2, s_k1_27_em_bin  #coloca string k1 em s3 (rd)
      j i_knumero1continue
      i_knumero1continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradorgp:
      jal readchar #le caracter
      beq $v0, 112, i_gpnumero #se gp, funcao que coloca string gp, no endereço s3 (rd)
      j undefined

    i_gpnumero:
      beq $t0, 0, i_gpnumero0rd
      beq $t0, 1, i_gpnumero0rs
      beq $t0, 2, i_gpnumero0rt
      j undefined
      i_gpnumero0rd:
      la $s3, s_gp_28_em_bin  #coloca string gp em s3 (rd)
      j i_gpnumero0continue
      i_gpnumero0rs:
      la $s1, s_gp_28_em_bin  #coloca string gp em s3 (rd)
      j i_gpnumero0continue
      i_gpnumero0rt:
      la $s2, s_gp_28_em_bin  #coloca string gp em s3 (rd)
      j i_gpnumero0continue
      i_gpnumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradorfp:
      jal readchar #le caracter
      beq $v0, 112, i_fpnumero #se fp, funcao que coloca string fp, no endereço s3 (rd)
      j undefined

    i_fpnumero:
      beq $t0, 0, i_fpnumero0rd
      beq $t0, 1, i_fpnumero0rs
      beq $t0, 2, i_fpnumero0rt
      j undefined
      i_fpnumero0rd:
      la $s3, s_fp_30_em_bin  #coloca string fp em s3 (rd)
      j i_fpnumero0continue
      i_fpnumero0rs:
      la $s1, s_fp_30_em_bin  #coloca string fp em s3 (rd)
      j i_fpnumero0continue
      i_fpnumero0rt:
      la $s2, s_fp_30_em_bin  #coloca string fp em s3 (rd)
      j i_fpnumero0continue
      i_fpnumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra

    i_registradorra:
      jal readchar #le caracter
      beq $v0, 97, i_ranumero #se ra, funcao que coloca string ra, no endereço s3 (rd)
      j undefined

    i_ranumero:
      beq $t0, 0, i_ranumero0rd
      beq $t0, 1, i_ranumero0rs
      beq $t0, 2, i_ranumero0rt
      i_ranumero0rd:
      la $s3, s_fp_30_em_bin  #coloca string ra em s3 (rd)
      j i_ranumero0continue
      i_ranumero0rs:
      la $s1, s_fp_30_em_bin  #coloca string ra em s3 (rd)
      j i_ranumero0continue
      i_ranumero0rt:
      la $s2, s_fp_30_em_bin  #coloca string ra em s3 (rd)
      j i_ranumero0continue
      i_ranumero0continue:
      lw $ra, 0($sp)  #lê valor de ra que estava na pilha
      addi $sp, $sp, 4 #zera a pilha
      jr $ra
##################################################################################################################################################
  i_vetordecaracteresparadecimal: #monta vetor de caracteres em decimal em buffer_caracter_decimal
      addi $sp, $sp, -4  #prepara pilha pra receber 1 item
      sw $ra, 0($sp)     #salva o endereço de $ra em sp
      move $t0, $zero  #anda de 4 em 4
      addi $t0, $t0, 1
      move $t2, $zero  #salva quantos numeros foram lidos
      move $t1, $zero
    vetordecaracteresparadecimalstart:
    jal readchar
    beq $v0, 48, digito_0 #se digito 0
    beq $v0, 49, digito_1 #se digito 1
    beq $v0, 50, digito_2 #se digito 2
    beq $v0, 51, digito_3 #se digito 3  
    beq $v0, 52, digito_4 #se digito 4
    beq $v0, 53, digito_5 #se digito 5
    beq $v0, 54, digito_6 #se digito 6
    beq $v0, 55, digito_7 #se digito 7
    beq $v0, 56, digito_8 #se digito 8
    beq $v0, 57, digito_9 #se digito 9
    beq $v0, 44, gobackcaller #func que volta pra caler
    beq $v0, 10, gobackcaller #func que volta pra caler
    bge $t1, 64, undefined 
    j undefined
  gobackcaller:
          lw $ra, 0($sp)     #salva o endereço de $ra em sp
          addi $sp, $sp, 4  #prepara pilha pra receber 1 item
          jr $ra

   digito_0:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_1:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_2:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_3:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_4:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_5:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_6:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_7: 
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_8:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
  digito_9:
    addi $t1, $v0, -48
    sb $t1, buffer_caracter_decimal($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j vetordecaracteresparadecimalstart
    
pega_valor_shamt:
   beq $a0, 0, preenche_shamt_0
   beq $a0, 1, preenche_shamt_1
   beq $a0, 2, preenche_shamt_2
   beq $a0, 3, preenche_shamt_3
   beq $a0, 4, preenche_shamt_4
   beq $a0, 5, preenche_shamt_5
   beq $a0, 6, preenche_shamt_6
   beq $a0, 7, preenche_shamt_7
   beq $a0, 8, preenche_shamt_8
   beq $a0, 9, preenche_shamt_9
   beq $a0, 10, preenche_shamt_10
   beq $a0, 11, preenche_shamt_11
   beq $a0, 12, preenche_shamt_12
   beq $a0, 13, preenche_shamt_13
   beq $a0, 14, preenche_shamt_14
   beq $a0, 15, preenche_shamt_15
   beq $a0, 16, preenche_shamt_16
   beq $a0, 17, preenche_shamt_17
   beq $a0, 18, preenche_shamt_18
   beq $a0, 19, preenche_shamt_19
   beq $a0, 20, preenche_shamt_20
   beq $a0, 21, preenche_shamt_21
   beq $a0, 22, preenche_shamt_22
   beq $a0, 23, preenche_shamt_23
   beq $a0, 24, preenche_shamt_24
   beq $a0, 25, preenche_shamt_25
   beq $a0, 26, preenche_shamt_26
   beq $a0, 27, preenche_shamt_27
   beq $a0, 28, preenche_shamt_28
   beq $a0, 29, preenche_shamt_29
   beq $a0, 30, preenche_shamt_30
   beq $a0, 31, preenche_shamt_31
   
preenche_shamt_0:
   la $a1, s_zero_0_em_bin
   jr $ra
preenche_shamt_1:
   la $a1, s_at_1_em_bin
   jr $ra
preenche_shamt_2:
   la $a1, s_v0_2_em_bin
   jr $ra
preenche_shamt_3:
   la $a1, s_v1_3_em_bin
   jr $ra
preenche_shamt_4:
   la $a1, s_a0_4_em_bin
   jr $ra
preenche_shamt_5:
   la $a1, s_a1_5_em_bin
   jr $ra
preenche_shamt_6:
   la $a1, s_a2_6_em_bin
   jr $ra
preenche_shamt_7:
   la $a1, s_a3_7_em_bin_6_em_bin
   jr $ra
preenche_shamt_8:
   la $a1, s_t0_8_em_bin
   jr $ra
preenche_shamt_9:
   la $a1, s_t1_9_em_bin
   jr $ra
preenche_shamt_10:
   la $a1, s_t2_10_em_bin
   jr $ra
preenche_shamt_11:
   la $a1, s_t3_11_em_bin
   jr $ra
preenche_shamt_12:
   la $a1, s_t4_12_em_bin
   jr $ra
preenche_shamt_13:
   la $a1, s_t5_13_em_bin
   jr $ra
preenche_shamt_14:
   la $a1, s_t6_14_em_bin
   jr $ra
preenche_shamt_15:
   la $a1, s_t7_15_em_bin
   jr $ra
preenche_shamt_16:
   la $a1, s_s0_16_em_bin
   jr $ra
preenche_shamt_17:
   la $a1, s_s1_17_em_bin
   jr $ra
preenche_shamt_18:
   la $a1, s_s2_18_em_bin
   jr $ra
preenche_shamt_19:
   la $a1, s_s3_19_em_bin
   jr $ra
preenche_shamt_20:
   la $a1, s_s4_20_em_bin
   jr $ra
preenche_shamt_21:
   la $a1, s_s5_21_em_bin
   jr $ra
preenche_shamt_22:
   la $a1, s_s6_22_em_bin
   jr $ra
preenche_shamt_23:
   la $a1, s_s7_23_em_bin
   jr $ra
preenche_shamt_24:
   la $a1, s_t8_24_em_bin
   jr $ra
preenche_shamt_25:
   la $a1, s_t9_25_em_bin
   jr $ra
preenche_shamt_26:
   la $a1, s_k0_26_em_bin
   jr $ra
preenche_shamt_27:
   la $a1, s_k1_27_em_bin
   jr $ra
preenche_shamt_28:
   la $a1, s_gp_28_em_bin
   jr $ra
preenche_shamt_29:
   la $a1, s_sp_29_em_bin
   jr $ra
preenche_shamt_30:
   la $a1, s_fp_30_em_bin
   jr $ra
preenche_shamt_31:
   la $a1, s_ra_31_em_bin
   jr $ra
   

converte_pra_decimal: #tem que converter pra hexa. tem que adicionar criterio de parada. resultado armazenado em a0.
  #t2 tem contador de numeros em buffer
  #quando t2 for = 0, cabou os numeros em buffer
   addi $sp, $sp, -4  #prepara pilha pra receber 1 item
   sw $ra, 0($sp)     #salva o endereço de $ra em sp
   li $t3,0
   li $t4,9
   move $t0, $zero
   addi $t0, $t0, 1
   lb $t1, buffer_caracter_decimal($t0)        #Get first digit of string
   li $a0, 0            #accumulator
   move $a2, $t1         #$a2=$t1 goto checkdigit
   jal checkdigit
   add $a0, $a0, $t1      #Accumulates
   addi $t0, $t0, 4      #Advance string pointer 
   addi $t2, $t2, -1
   lb $t1, buffer_caracter_decimal($t0)        #Get next digit

buc1:   
   ble $t2, $zero, salva_valor_decimal #if $t1=10(linefeed) then print
   move $a2, $t1         #$a2=$t1 goto checkdigit
   jal checkdigit
   mul $t5, $a0, 10  #Multiply by 10
   add $a0, $t5, $t1      #Accumulates
   addi $t0, $t0, 4      #Advance string pointer
   addi $t2, $t2, -1 
   lb $t1, buffer_caracter_decimal($t0)        #Get next digit 
   b buc1

salva_valor_decimal:
   
  la $t0, buffer_decimal_salvo
  sb $a0, 1($t0)
  j gobackcaller

checkdigit:
   blt $a2, $t3, errodigito  
   bgt $a2, $t4, errodigito
   jr $ra

errodigito:
   la $a0, msgerrodigito
   li $v0, 4            #print eror
   syscall
##################################################################################################################################################      
concatenate:
addi $sp, $sp, 4
sw $ra, 0($sp)     #salva o endereço de $ra em sp
# Copy first string to result buffer
  la $a0, ($s0)
  la $a1, s_constroi1
  jal strcopier
  nop

# Concatenate second string on result buffer
  la $a0, ($s1)
  or $a1, $v0, $zero
  jal strcopier
  nop
  j concatenate2
  nop



concatenate2:
# Copy first string to result buffer
  la $a0, s_constroi1
  la $a1, s_constroi2
  jal strcopier
  nop

# Concatenate second string on result buffer
  la $a0, ($s2)
  or $a1, $v0, $zero
  jal strcopier
  nop

concatenate3:
# Copy first string to result buffer
  la $a0, s_constroi2
  la $a1, s_constroi3
  jal strcopier
  nop

# Concatenate second string on result buffer
  la $a0, ($s3)
  or $a1, $v0, $zero
  jal strcopier
  nop

concatenate4:
# Copy first string to result buffer
  la $a0, s_constroi3
  la $a1, s_constroi4
  jal strcopier
  nop

# Concatenate second string on result buffer
  la $a0, ($s4)
  or $a1, $v0, $zero
  jal strcopier
  nop

concatenate5:
# Copy first string to result buffer
  la $a0, s_constroi4
  la $a1, s_converted
  jal strcopier
  nop

# Concatenate second string on result buffer
  la $a0, ($t9)
  or $a1, $v0, $zero
  jal strcopier
  nop
  j finish_concatenate
  nop

# String copier function
strcopier:
  or $t0, $a0, $zero # Source
  or $t1, $a1, $zero # Destination

loop_concatenate:
  lb $t2, 0($t0)
  beq $t2, $zero, end_concatenate
  addiu $t0, $t0, 1
  sb $t2, 0($t1)
  addiu $t1, $t1, 1
  b loop_concatenate
  nop

end_concatenate:
  or $v0, $t1, $zero # Return last position on result buffer
  jr $ra
  nop
  #printa pra teste
finish_concatenate:
  li $v0, 4
  la $t0, s_converted
  add $a0, $t0, $zero
  syscall
  nop
  j convertehexa

#########################################################################
convertehexa:
  move $t0, $zero
  loop_conversao:
    beq $t0, 32, gobackcaller
    lb $t2, s_converted($t0)
    addi $t0, $t0, 1
    lb $t3, s_converted($t0)
    addi $t0, $t0, 1
    lb $t4, s_converted($t0)
    addi $t0, $t0, 1
    lb $t5, s_converted($t0)
    addi $t0, $t0, 1
  if: #0000
    bne $t5, 48, else_0001
    bne $t4, 48, else_0001
    bne $t3, 48, else_0001
    bne $t2, 48, else_0001
      j caracterzero
  else_0001: #0001
    bne $t5, 49, else_0010
    bne $t4, 48, else_0010
    bne $t3, 48, else_0010
    bne $t2, 48, else_0010
      j caracterum
  else_0010: #0010
    bne $t5, 48, else_0011
    bne $t4, 49, else_0011
    bne $t3, 48, else_0011
    bne $t2, 48, else_0011
      j caracterdois
  else_0011: #0011
    bne $t5, 49, else_0100
    bne $t4, 49, else_0100
    bne $t3, 48, else_0100
    bne $t2, 48, else_0100
      j caractertres
  else_0100: #0100
    bne $t5, 48, else_0101
    bne $t4, 48, else_0101
    bne $t3, 49, else_0101
    bne $t2, 48, else_0101
      j caracterquatro
  else_0101: #0101
    bne $t5, 49, else_0110
    bne $t4, 48, else_0110
    bne $t3, 49, else_0110
    bne $t2, 48, else_0110
      j caractercinco
  else_0110: #0110
    bne $t5, 48, else_0111
    bne $t4, 49, else_0111
    bne $t3, 49, else_0111
    bne $t2, 48, else_0111
      j caracterseis  
  else_0111: #0111
    bne $t5, 49, else_1000
    bne $t4, 49, else_1000
    bne $t3, 49, else_1000
    bne $t2, 48, else_1000
      j caractersete
  else_1000: #1000
    bne $t5, 48, else_1001
    bne $t4, 48, else_1001
    bne $t3, 48, else_1001
    bne $t2, 49, else_1001
      j caracteroito
  else_1001: #1001
    bne $t5, 49, else_1010
    bne $t4, 48, else_1010
    bne $t3, 48, else_1010
    bne $t2, 49, else_1010
      j caracternove
  else_1010: #1010
    bne $t5, 48, else_1011
    bne $t4, 49, else_1011
    bne $t3, 48, else_1011
    bne $t2, 49, else_1011
      j caracterdez
  else_1011: #1011
    bne $t5, 49, else_1100
    bne $t4, 49, else_1100
    bne $t3, 48, else_1100
    bne $t2, 49, else_1100
      j caracteronze
  else_1100: #1100
    bne $t5, 48, else_1101
    bne $t4, 48, else_1101
    bne $t3, 49, else_1101
    bne $t2, 49, else_1101
      j caracterdoze
  else_1101: #1101
    bne $t5, 49, else_1110
    bne $t4, 48, else_1110
    bne $t3, 49, else_1110
    bne $t2, 49, else_1110
      j caractertreze
  else_1110: #1110
    bne $t5, 48, else_1111
    bne $t4, 49, else_1111
    bne $t3, 49, else_1111
    bne $t2, 49, else_1111
      j caractercatorze
  else_1111: #1111
    bne $t5, 49, undefined_convertion
    bne $t4, 49, undefined_convertion
    bne $t3, 49, undefined_convertion
    bne $t2, 49, undefined_convertion
      j caracterquinze






  caracterzero:
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex0# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterum: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex1# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterdois: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex2# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caractertres: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex3# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterquatro:
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex4# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caractercinco: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex5# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterseis: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex6# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caractersete: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex7# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracteroito:
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex8# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracternove: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hex9# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterdez: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hexA# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracteronze: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hexB# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterdoze:
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hexC# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caractertreze: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hexD# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caractercatorze: 
     li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hexE# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  caracterquinze: 
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_hexF# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    j loop_conversao

  undefined_convertion:
    j end

#########################################################################
#########################################################################
 
armazenanibble:

move $t0, $0
move $t1, $0
move $t2, $0
move $t3, $0
move $t4, $0
move $t5, $0
move $t6, $0

addi $t6, $t6, 1
sb $t8, bufferarmazenanibble($t6)

la $t3, bufferarmazenanibble
lb $t2, 1($t3)
addi $sp, $sp, -4  #prepara pilha pra receber 1 item
sw $ra, 0($sp)     #salva o endereço de $ra em sp
t1_nible:

andi $t1, $t2, 0x0000000f
slti $t0, $t1, 10
bne  $t0, 1, cont_1t
addi $t1, $t1, 0x30
j store_1t

cont_1t:
  addi $t1, $t1, 97
  
store_1t:
 sb $t1, 7($t3)

d2_nible:

andi $t1, $t2, 0x000000f0
srl $t1, $t1, 4
slti $t0, $t1, 10
bne $t0, 1, cont_2d
addi $t1, $t1, 0x30
j store_2d

cont_2d: 
 addi $t1, $t1, 97

store_2d:
sb $t1, 15($t3)

d3_nible:

andi $t1, $t2, 0x00000f00
srl $t1, $t1, 8
slti $t0, $t1, 10
bne $t0, 1, cont_3d
addi $t1, $t1, 0x30
j store_3d

cont_3d: 
 addi $t1, $t1, 97

store_3d:
sb $t1, 23($t3)

d4_nible:

andi $t1, $t2, 0x0000f000
srl $t1, $t1, 12
slti $t0, $t1, 10
bne $t0, 1, cont_4d
addi $t1, $t1, 0x30
j store_4d

cont_4d: 
 addi $t1, $t1, 97

store_4d:
sb $t1, 31($t3)


d5_nible:

andi $t1, $t2, 0x000f0000
srl $t1, $t1, 16
slti $t0, $t1, 10
bne $t0, 1, cont_5d
addi $t1, $t1, 0x30
j store_5d

cont_5d: 
 addi $t1, $t1, 97

store_5d:
sb $t1, 39($t3)

d6_nible:

andi $t1, $t2, 0x00f00000
srl $t1, $t1, 20
slti $t0, $t1, 10
bne $t0, 1, cont_6d
addi $t1, $t1, 0x30
j store_6d

cont_6d: 
 addi $t1, $t1, 97

store_6d:
sb $t1, 47($t3)

d7_nible:

andi $t1, $t2, 0x0f000000
srl $t1, $t1, 24
slti $t0, $t1, 10
bne $t0, 1, cont_7d
addi $t1, $t1, 0x30
j store_7d

cont_7d: 
 addi $t1, $t1, 97

store_7d:
sb $t1, 55($t3)


d8_nible:

andi $t1, $t2, 0xf0000000
srl $t1, $t1, 28
slti $t0, $t1, 10
bne $t0, 1, cont_8d
addi $t1, $t1, 0x30
j store_8d

cont_8d: 
 addi $t1, $t1, 97

store_8d:
sb $t1, 63($t3)

j escreveendereco

#########################################################################

escreveendereco:
move $t3, $0
addi $t3, $t3, 63
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigito
addi $t8, $t8, 4
lw $ra, 0($sp)     #le o endereço de $ra em sp
addi $sp, $sp, 4  #prepara pilha pra receber 1 item
jr $ra


verificawdigito:
    beq $t0, 48, wdigito_0 #se digito 0
    beq $t0, 49, wdigito_1 #se digito 1
    beq $t0, 50, wdigito_2 #se digito 2
    beq $t0, 51, wdigito_3 #se digito 3  
    beq $t0, 52, wdigito_4 #se digito 4
    beq $t0, 53, wdigito_5 #se digito 5
    beq $t0, 54, wdigito_6 #se digito 6
    beq $t0, 55, wdigito_7 #se digito 7
    beq $t0, 56, wdigito_8 #se digito 8
    beq $t0, 97, wdigito_a #se digito 9
    beq $t0, 98, wdigito_b #se digito a
    beq $t0, 99, wdigito_c #se digito b
    beq $t0, 100, wdigito_d #se digito c
    beq $t0, 101, wdigito_e #se digito d
    beq $t0, 102, wdigito_f #se digito e
    j undefined

wdigito_0:

li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_1:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex1# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_2:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex2# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_3:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex3# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_4:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex4# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_5:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex5# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_6:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex6# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_7:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex7# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_8:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex8# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_9:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohex9# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_a:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohexA# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_b:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohexB# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_c:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohexC# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_d:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohexD# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_e:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohexE# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_f:
li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor for text stored in s7
la   $a1,  s_tohexF# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
 jr $ra
############################################################################
armazenanibbledata:

move $t0, $0
move $t1, $0
move $t2, $0
move $t3, $0
move $t4, $0
move $t5, $0
move $t6, $0
addi $t6, $t6, 1

sw $t8, bufferarmazenanibble($t6)

la $t3, bufferarmazenanibble
lw $t2, 1($t3)

addi $sp, $sp, -4  #prepara pilha pra receber 1 item
sw $ra, 0($sp)     #salva o endereço de $ra em sp
t1_nibledata:

andi $t1, $t2, 0x0000000f
slti $t0, $t1, 10
bne  $t0, 1, cont_1tdata
addi $t1, $t1, 0x30
j store_1tdata

cont_1tdata:
  addi $t1, $t1, 97
  
store_1tdata:
 sb $t1, 7($t3)

d2_nibledata:

andi $t1, $t2, 0x000000f0
srl $t1, $t1, 4
slti $t0, $t1, 10
bne $t0, 1, cont_2ddata
addi $t1, $t1, 0x30
j store_2ddata

cont_2ddata: 
 addi $t1, $t1, 97

store_2ddata:
sb $t1, 15($t3)

d3_nibledata:

andi $t1, $t2, 0x00000f00
srl $t1, $t1, 8
slti $t0, $t1, 10
bne $t0, 1, cont_3ddata
addi $t1, $t1, 0x30
j store_3ddata

cont_3ddata: 
 addi $t1, $t1, 97

store_3ddata:
sb $t1, 23($t3)

d4_nibledata:

andi $t1, $t2, 0x0000f000
srl $t1, $t1, 12
slti $t0, $t1, 10
bne $t0, 1, cont_4ddata
addi $t1, $t1, 0x30
j store_4ddata

cont_4ddata: 
 addi $t1, $t1, 97

store_4ddata:
sb $t1, 31($t3)


d5_nibledata:

andi $t1, $t2, 0x000f0000
srl $t1, $t1, 16
slti $t0, $t1, 10
bne $t0, 1, cont_5ddata
addi $t1, $t1, 0x30
j store_5ddata

cont_5ddata: 
 addi $t1, $t1, 97

store_5ddata:
sb $t1, 39($t3)

d6_nibledata:

andi $t1, $t2, 0x00f00000
srl $t1, $t1, 20
slti $t0, $t1, 10
bne $t0, 1, cont_6ddata
addi $t1, $t1, 0x30
j store_6ddata

cont_6ddata: 
 addi $t1, $t1, 97

store_6ddata:
sb $t1, 47($t3)

d7_nibledata:

andi $t1, $t2, 0x0f000000
srl $t1, $t1, 24
slti $t0, $t1, 10
bne $t0, 1, cont_7ddata
addi $t1, $t1, 0x30
j store_7ddata

cont_7ddata: 
 addi $t1, $t1, 97

store_7ddata:
sb $t1, 55($t3)


d8_nibledata:

andi $t1, $t2, 0xf0000000
srl $t1, $t1, 28
slti $t0, $t1, 10
bne $t0, 1, cont_8ddata
addi $t1, $t1, 0x30
j store_8ddata

cont_8ddata: 
 addi $t1, $t1, 97

store_8ddata:
sb $t1, 63($t3)

j escrevenumerodata

#######################################################################################


armazenaimediatodata:
addi $sp, $sp, -4  #prepara pilha pra receber 1 item
sw $ra, 0($sp)     #salva o endereço de $ra em sp
t1_nibledataim:

andi $t1, $t2, 0x0000000f
slti $t0, $t1, 10
bne  $t0, 1, cont_1tdataim
addi $t1, $t1, 0x30
j store_1tdataim

cont_1tdataim:
  addi $t1, $t1, 97
  
store_1tdataim:
 sb $t1, 7($t3)

d2_nibledataim:

andi $t1, $t2, 0x000000f0
srl $t1, $t1, 4
slti $t0, $t1, 10
bne $t0, 1, cont_2ddataim
addi $t1, $t1, 0x30
j store_2ddataim

cont_2ddataim: 
 addi $t1, $t1, 97

store_2ddataim:
sb $t1, 15($t3)

d3_nibledataim:

andi $t1, $t2, 0x00000f00
srl $t1, $t1, 8
slti $t0, $t1, 10
bne $t0, 1, cont_3ddataim
addi $t1, $t1, 0x30
j store_3ddataim

cont_3ddataim: 
 addi $t1, $t1, 97

store_3ddataim:
sb $t1, 23($t3)

d4_nibledataim:

andi $t1, $t2, 0x0000f000
srl $t1, $t1, 12
slti $t0, $t1, 10
bne $t0, 1, cont_4ddataim
addi $t1, $t1, 0x30
j store_4ddataim

cont_4ddataim: 
 addi $t1, $t1, 97

store_4ddataim:
sb $t1, 31($t3)


d5_nibledataim:

andi $t1, $t2, 0x000f0000
srl $t1, $t1, 16
slti $t0, $t1, 10
bne $t0, 1, cont_5ddataim
addi $t1, $t1, 0x30
j store_5ddataim

cont_5ddataim: 
 addi $t1, $t1, 97

store_5ddataim:
sb $t1, 39($t3)

d6_nibledataim:

andi $t1, $t2, 0x00f00000
srl $t1, $t1, 20
slti $t0, $t1, 10
bne $t0, 1, cont_6ddataim
addi $t1, $t1, 0x30
j store_6ddataim

cont_6ddataim: 
 addi $t1, $t1, 97

store_6ddataim:
sb $t1, 47($t3)

d7_nibledataim:

andi $t1, $t2, 0x0f000000
srl $t1, $t1, 24
slti $t0, $t1, 10
bne $t0, 1, cont_7ddataim
addi $t1, $t1, 0x30
j store_7ddataim

cont_7ddataim: 
 addi $t1, $t1, 97

store_7ddataim:
sb $t1, 55($t3)


d8_nibledataim:

andi $t1, $t2, 0xf0000000
srl $t1, $t1, 28
slti $t0, $t1, 10
bne $t0, 1, cont_8ddataim
addi $t1, $t1, 0x30
j store_8ddataim

cont_8ddataim: 
 addi $t1, $t1, 97

store_8ddataim:
sb $t1, 63($t3)

j escrevenumerodataimediato


escrevenumerodataimediato:

move $t0, $0
la $t3, buffer_decimal_salvo
lw $t2, 1($t3)
slti $t1, $t2, 16
bnez $t1, poe4zeros
slti $t1, $t2, 32
bnez $t1, poe3zeros
slti $t1, $t2, 64
bnez $t1, poe2zeros
slti $t1, $t2, 128
bnez $t1, poezero
j naopoezero

poe4zeros:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
j naopoezero

poe3zeros:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
j naopoezero

poe2zeros:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
j naopoezero

poezero:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file

naopoezero:

move $t3, $0
addi $t3, $t3, 63
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, buffer_decimal_salvo($t3)
jal verificawdigitodata
lw $ra, 0($sp)     #le o endereço de $ra em sp
addi $sp, $sp, 4  #prepara pilha pra receber 1 item
jr $ra
#####################################################################

escrevenumerodata:

move $t3, $0
addi $t3, $t3, 63
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
addi $t3, $t3, -8
lb $t0, bufferarmazenanibble($t3)
jal verificawdigitodata
lw $ra, 0($sp)     #le o endereço de $ra em sp
addi $sp, $sp, 4  #prepara pilha pra receber 1 item
jr $ra


verificawdigitodata:
    beq $t0, 0, gobackcaller
    beq $t0, 48, wdigito_0data #se digito 0
    beq $t0, 49, wdigito_1data #se digito 1
    beq $t0, 50, wdigito_2data #se digito 2
    beq $t0, 51, wdigito_3data #se digito 3  
    beq $t0, 52, wdigito_4data #se digito 4
    beq $t0, 53, wdigito_5data #se digito 5
    beq $t0, 54, wdigito_6data #se digito 6
    beq $t0, 55, wdigito_7data #se digito 7
    beq $t0, 56, wdigito_8data #se digito 8
    beq $t0, 97, wdigito_adata #se digito 9
    beq $t0, 98, wdigito_bdata #se digito a
    beq $t0, 99, wdigito_cdata #se digito b
    beq $t0, 100, wdigito_ddata #se digito c
    beq $t0, 101, wdigito_edata #se digito d
    beq $t0, 102, wdigito_fdata #se digito e
    j undefined

wdigito_0data:

li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex0# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_1data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex1# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_2data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex2# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_3data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex3# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_4data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex4# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_5data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex5# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_6data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex6# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_7data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex7# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_8data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex8# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_9data:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohex9# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_adata:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohexA# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_bdata:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohexB# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_cdata:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohexC# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_ddata:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohexD# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_edata:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohexE# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
jr $ra
wdigito_fdata:
li   $v0, 15       # system call for write to file
move $a0, $s6      # file descriptor for text stored in s6
la   $a1,  s_tohexF# address of buffer from which to write
li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
syscall            # write to file
 jr $ra
#########################################################################
quebralinha:
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_quebralinha# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    jr $ra
#########################################################################
quebralinhadata:
    li   $v0, 15       # system call for write to file
    move $a0, $s6      # file descriptor for text stored in s7
    la   $a1,  s_quebralinha# address of buffer from which to write
    li   $a2, 1       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file
    jr $ra    
#########################################################################
espacodoispontosespaco:
    li   $v0, 15       # system call for write to file
    move $a0, $s7      # file descriptor for text stored in s7
    la   $a1,  s_espacodoispontosespaco# address of buffer from which to write
    li   $a2, 3       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file  
    jr $ra  
#########################################################################
espacodoispontosespacodata:
    li   $v0, 15       # system call for write to file
    move $a0, $s6      # file descriptor for text stored in s7
    la   $a1,  s_espacodoispontosespaco# address of buffer from which to write
    li   $a2, 3       # hardcoded buffer length (size of buffer_data_init in decimal)
    syscall            # write to file  
    jr $ra      
#########################################################################
readchar:
  li $v0,14 # prepara para ler caracter do arquivo
  move $a0,$s5  # aponta pro ponteiro no arquivo
  la $a1,buffer # salva em buffer
  li $a2,1        # le um caracter
  syscall
  beq $v0, $0, close_file #eof, fim leitura
  lb $v0,buffer # le um byte armazenado em buffer
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
debug_de_pobre:

  li $v0, 4
  la $a0, s_debug_de_pobre
  syscall
