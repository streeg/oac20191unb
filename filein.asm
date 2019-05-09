.data
a: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
c: .word 1, 2, 3

.text
sll $t1, $t1, 31
add $t2, $t3, $t4
xor $t0, $t1, $s0
clo $t1, $t2
add $t1, $t2, $t3
xor $t4, $t1, $t2
or $s0, $s1, $s2
sub $t0, $t1, $t7
and $t9, $s4, $k1
xor $t0, $t3, $t2
or $s1, $s4, $s3
sub $t2, $t5, $t3
