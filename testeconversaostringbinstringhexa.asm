.data
result: .asciiz "000000010000100101010000000100000"
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
loop:
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
bne $t5, 48, else
bne $t4, 48, else
bne $t3, 48, else
bne $t2, 48, else
	j zero
else: #0001
bne $t5, 49, else1
bne $t4, 48, else1
bne $t3, 48, else1
bne $t2, 48, else1
	j um
else1: #0010
bne $t5, 48, else2
bne $t4, 49, else2
bne $t3, 48, else2
bne $t2, 48, else2
	j dois
else2: #0011
bne $t5, 49, else3
bne $t4, 49, else3
bne $t3, 48, else3
bne $t2, 48, else3
	j tres
else3: #0100
bne $t5, 48, else4
bne $t4, 48, else4
bne $t3, 49, else4
bne $t2, 48, else4
	j quatro
else4: #0101
bne $t5, 48, else5
bne $t4, 49, else5
bne $t3, 48, else5
bne $t2, 49, else5
	j cinco
else5: #0110
bne $t5, 48, else6
bne $t4, 49, else6
bne $t3, 49, else6
bne $t2, 48, else6
	j seis	
else6: #0111
bne $t5, 48, else7
bne $t4, 49, else7
bne $t3, 49, else7
bne $t2, 49, else7
	j sete
else7: #1000
bne $t5, 49, else8
bne $t4, 48, else8
bne $t3, 48, else8
bne $t2, 48, else8
	j oito
else8: #1001
bne $t5, 49, else9
bne $t4, 48, else9
bne $t3, 48, else9
bne $t2, 49, else9
	j nove
else9: #1010
bne $t5, 49, else10
bne $t4, 48, else10
bne $t3, 49, else10
bne $t2, 48, else10
	j dez
else10: #1011
bne $t5, 49, else11
bne $t4, 48, else11
bne $t3, 49, else11
bne $t2, 49, else11
	j onze
else11: #1100
bne $t5, 49, else12
bne $t4, 49, else12
bne $t3, 48, else12
bne $t2, 48, else12
	j doze
else12: #1101
bne $t5, 49, else13
bne $t4, 49, else13
bne $t3, 48, else13
bne $t2, 49, else13
	j treze
else13: #1110
bne $t5, 49, else14
bne $t4, 49, else14
bne $t3, 49, else14
bne $t2, 48, else14
	j catorze
else14: #1111
bne $t5, 49, undefined_convertion
bne $t4, 49, undefined_convertion
bne $t3, 49, undefined_convertion
bne $t2, 49, undefined_convertion
	j quinze





zero:
li $v0, 4
la $a0, s_hex0
syscall
j loop

um: 
li $v0, 4
la $a0, s_hex1
syscall
j loop

dois: 
li $v0, 4
la $a0, s_hex2
syscall
j loop

tres: 
li $v0, 4
la $a0, s_hex3
syscall
j loop

quatro:
li $v0, 4
la $a0, s_hex4
syscall
j loop

cinco: 
li $v0, 4
la $a0, s_hex5
syscall
j loop

seis: 
li $v0, 4
la $a0, s_hex6
syscall
j loop

sete: 
li $v0, 4
la $a0, s_hex7
syscall
j loop

oito:
li $v0, 4
la $a0, s_hex8
syscall
j loop

nove: 
li $v0, 4
la $a0, s_hex9
syscall
j loop

dez: 
li $v0, 4
la $a0, s_hexA
syscall
j loop

onze: 
li $v0, 4
la $a0, s_hexB
syscall
j loop

doze:
li $v0, 4
la $a0, s_hexC
syscall
j loop

treze: 
li $v0, 4
la $a0, s_hexD
syscall
j loop

catorze: 
li $v0, 4
la $a0, s_hexE
syscall
j loop

quinze: 
li $v0, 4
la $a0, s_hexF
syscall
j loop

undefined_convertion:
end:
li $v0, 10
syscall
