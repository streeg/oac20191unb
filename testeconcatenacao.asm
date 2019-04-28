.data
s_t0:   .asciiz "01000"
s_t1:   .asciiz "01001"
s_t2:   .asciiz "01010"
s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav: .asciiz "000000"
s_shamttipor: .asciiz "000000"
s_function_add: .asciiz "100000"
constroi1: .space 32
constroi2: .space 32
constroi3: .space 32
constroi4: .space 32
result:  .space 32

.text

la $s0, s_opcode_add_sub_and_or_nor_xor_jr_slt_addu_subu_sll_srl_mult_div_mfhi_mflo_srav  #coloca opcode add em s0
la $s1 s_t1 #coloca string t1 em s1 (rs)
la $s2 s_t2 #coloca string t2 em s2 (rt)
la $s3, s_t0  #coloca string t0 em s3 (rd)
la $s4, s_shamttipor #coloca shamt em tipos r em s4
la $s5, s_function_add #coloca o function do sub em s5

concatenate:
# Copy first string to result buffer
la $a0, ($s0)
la $a1, s_constroi1
jal strcopier
nop

# Concatenate second string on result buffer
la $a0, ($s3)
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
la $a0, ($s1)
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
la $a0, ($s2)
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
la $a0, ($s5)
or $a1, $v0, $zero
jal strcopier
nop
j finish
nop

# String copier function
strcopier:
or $t0, $a0, $zero # Source
or $t1, $a1, $zero # Destination

loop:
lb $t2, 0($t0)
beq $t2, $zero, end
addiu $t0, $t0, 1
sb $t2, 0($t1)
addiu $t1, $t1, 1
b loop
nop

end:
or $v0, $t1, $zero # Return last position on result buffer
jr $ra
nop

finish:
li $v0, 4
la $t0, s_converted
add $a0, $t0, $zero
syscall
nop
