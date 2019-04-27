.data    
msg3:.asciiz "\nSAME"  
msg4:.asciiz "\nNOT SAME"  
str1: .asciiz "add"
str2: .asciiz "addiu"

.text
.globl main

main:  
    la $a0,str1             #pass address of str1  
    la $a1,str2         #pass address of str2  
    jal methodComp      #call methodComp  

    beq $v0,$zero,ok    #check result  
    li $v0,4
    la $a0,msg4
    syscall
    j exit
ok:  
    li $v0,4  
    la $a0,msg3  
    syscall  
exit:  
    li $v0,10  
    syscall  

methodComp:  
    add $t0,$zero,$zero  
    add $t1,$zero,$a0  
    add $t2,$zero,$a1  

loop:  
    lb $t3($t1)         #load a byte from each string  
    lb $t4($t2)  
    beqz $t3,checkt2    #str1 end  
    beqz $t4,missmatch  
    slt $t5,$t3,$t4     #compare two bytes  
    bnez $t5,missmatch  
    addi $t1,$t1,1      #t1 points to the next byte of str1  
    addi $t2,$t2,1  
    j loop  

missmatch:   
    addi $v0,$zero,1  
    j endfunction  
checkt2:  
    bnez $t4,missmatch  
    add $v0,$zero,$zero  

endfunction:  
    jr $ra