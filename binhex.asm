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
# Aqui daria para passar por outro registrador, ao inves de $v
move	$a0, $v0
move $t4, $v0 # Contador do loop interno definido como entrada do usuario

jal	loop

# New Line
li	$v0, 11
li	$a0, 10
syscall

j __start

print_bin:


loop:

# nova linha
li $v0, 11
li $a0, 10
syscall

j print


print:	
li $v0, 34
addi $t1, $t1, 4 # Incrementando em 4
move $a0, $t1
syscall

srl $t3, $t3, 1
addi $t4, $t4, -1 # i--

bne	$t4, $zero, loop # while > 0

jr	$ra