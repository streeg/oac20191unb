.data
ask_str1:	.asciiz	"Enter the loop counter: "
result_str:	.asciiz ""
.align 2

.text
.globl __start

__start:
# ask and store the first number
# Eu coloquei o parametro como a quantidade de vezes que ele vai incrementar em 4
li	$v0, 4
la	$a0, ask_str1
syscall
li	$v0, 5
syscall
move	$a0, $v0
move $t4, $v0

jal	loop

# New Line
li	$v0, 11
li	$a0, 10
syscall

j __start

print_bin:


#addi $t4, $zero, 32	# loop counter
loop:

li $v0, 11
li $a0, 10
syscall

j print


print:	
li $v0, 34
addi $t1, $t1, 4
move $a0, $t1
syscall

srl $t3, $t3, 1
addi $t4, $t4, -1

bne	$t4, $zero, loop

jr	$ra