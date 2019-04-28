.data
result: .asciiz "000001000000010101001000010000000"				
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
hexa: .space 8


.text

move $t0, $zero
loop_conversao:
beq $t0, 32, end
lb $t2, result($t0)
addi $t0, $t0, 1
lb $t3, result($t0)
addi $t0, $t0, 1
lb $t4, result($t0)
addi $t0, $t0, 1
lb $t5, result($t0)
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
bne $t5, 48, else_0110
bne $t4, 49, else_0110
bne $t3, 48, else_0110
bne $t2, 49, else_0110
	j caractercinco
else_0110: #0110
bne $t5, 48, else_0111
bne $t4, 49, else_0111
bne $t3, 49, else_0111
bne $t2, 48, else_0111
	j caracterseis	
else_0111: #0111
bne $t5, 48, else_1000
bne $t4, 49, else_1000
bne $t3, 49, else_1000
bne $t2, 49, else_1000
	j caractersete
else_1000: #1000
bne $t5, 49, else_1001
bne $t4, 48, else_1001
bne $t3, 48, else_1001
bne $t2, 48, else_1001
	j caracteroito
else_1001: #1001
bne $t5, 49, else_1010
bne $t4, 48, else_1010
bne $t3, 48, else_1010
bne $t2, 49, else_1010
	j caracternove
else_1010: #1010
bne $t5, 49, else_1011
bne $t4, 48, else_1011
bne $t3, 49, else_1011
bne $t2, 48, else_1011
	j caracterdez
else_1011: #1011
bne $t5, 49, else_1100
bne $t4, 48, else_1100
bne $t3, 49, else_1100
bne $t2, 49, else_1100
	j caracteronze
else_1100: #1100
bne $t5, 49, else_1101
bne $t4, 49, else_1101
bne $t3, 48, else_1101
bne $t2, 48, else_1101
	j caracterdoze
else_1101: #1101
bne $t5, 49, delse_1110
bne $t4, 49, delse_1110
bne $t3, 48, delse_1110
bne $t2, 49, delse_1110
	j treze
delsecaracter_1110: #1110
bne $t5, 49, else_1111
bne $t4, 49, else_1111
bne $t3, 49, else_1111
bne $t2, 48, else_1111
	j caractercatorze
else_1111: #1111
bne $t5, 49, undefined_convertion
bne $t4, 49, undefined_convertion
bne $t3, 49, undefined_convertion
bne $t2, 49, undefined_convertion
	j caracterquinze





caracterzero:
li $v0, 4
la $a0, s_hex0
syscall
j loop_conversao

caracterum: 
li $v0, 4
la $a0, s_hex1
syscall
j loop_conversao

caracterdois: 
li $v0, 4
la $a0, s_hex2
syscall
j loop_conversao

caractertres: 
li $v0, 4
la $a0, s_hex3
syscall
j loop_conversao

caracterquatro:
li $v0, 4
la $a0, s_hex4
syscall
j loop_conversao

caractercinco: 
li $v0, 4
la $a0, s_hex5
syscall
j loop_conversao

caracterseis: 
li $v0, 4
la $a0, s_hex6
syscall
j loop_conversao

caractersete: 
li $v0, 4
la $a0, s_hex7
syscall
j loop_conversao

caracteroito:
li $v0, 4
la $a0, s_hex8
syscall
j loop_conversao

caracternove: 
li $v0, 4
la $a0, s_hex9
syscall
j loop_conversao

caracterdez: 
li $v0, 4
la $a0, s_hexA
syscall
j loop_conversao

caracteronze: 
li $v0, 4
la $a0, s_hexB
syscall
j loop_conversao

caracterdoze:
li $v0, 4
la $a0, s_hexC
syscall
j loop_conversao

caractertreze: 
li $v0, 4
la $a0, s_hexD
syscall
j loop_conversao

caractercatorze: 
li $v0, 4
la $a0, s_hexE
syscall
j loop_conversao

caracterquinze: 
li $v0, 4
la $a0, s_hexF
syscall
j loop_conversao

undefined_convertion:
j end
