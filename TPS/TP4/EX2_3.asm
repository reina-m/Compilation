# EXERCICE 2
saisie : 
	li $v0, 5 # y = read_int()
	syscall 
	blt $v0, 0, saisie 
	bge $v0, $a0, saisie
	addi $v0, $v0, 1
