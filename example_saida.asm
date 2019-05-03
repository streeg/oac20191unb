.data

str: .asciiz "123"
transhexa: .space 16
transhexa2: .space 16

.text
move $t8, $zero
la $t0, str
la $t1, transhexa($zero)
la $s0, transhexa2($zero)
lb $t2, ($t0)
addi $t0, $t0, 1
add $t3, $t2, -48
sw $t3, transhexa2($t8)
addi $t8, $t8, 4
lb $t2, ($t0)
addi $t0, $t0, 1
add $t4, $t2, -48
sw $t4, transhexa2($t8)
lb $t2, ($t0)
addi $t0, $t0, 1
add $t5, $t2, -48
sw $t5, 8($s0)

lw $t6, 0($s0)
lw $t7, 4($s0)
lw $t8, 8($s0)


