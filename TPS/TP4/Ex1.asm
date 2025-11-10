li $a0, 3
# x^2 + 3x + 5
mul $t0, $a0, $a0 # t0 <- x^
li $t1, 3
mul $t1, $a0, $t1 # t1 <- 3x
add $t0, $t0, $t1 # t0 <- x^ + 3x
addi $a0, $t0, 5 # a0 <- x^ + 3x + 5
li $v0, 1
syscall

# x(x+1)(x+2)(x+3)
addi $t0, $a0, 1
addi $t1, $a0, 2
addi $t2, $a0, 3
mul $t0, $a0, $t0
mul $t0, $t0, $t1
mul $t0, $t0, $t2
move $a0, $t0
