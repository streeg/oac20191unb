.data

buffer: .space 128
.text

addi $s0, $s0, 0x00400000
sw $s0, buffer

la $t3, buffer
lw $t2, 0($t3)

t1_nible:



andi $t1, $t2, 0x0000000f
slti $t0, $t1, 10
bne  $t0, 1, cont_1t
addi $t1, $t1, 0x30
j store_1t

cont_1t:
  addi $t1, $t1, 87
  
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
 addi $t1, $t1, 87

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
 addi $t1, $t1, 87

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
 addi $t1, $t1, 87

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
 addi $t1, $t1, 87

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
 addi $t1, $t1, 87

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
 addi $t1, $t1, 87

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
 addi $t1, $t1, 87

store_8d:
sb $t1, 63($t3)

#############################
move $s3, $t3
lw $t0, 0($s3)
lb $t1, 7($s3)
lb $t2, 15($s3)
lb $t3, 23($s3)
lb $t4, 31($s3)
lb $t5, 39($s3)
lb $t6, 47($s3)
lb $t7, 55($s3)
lb $t8, 63($s3)