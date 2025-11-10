# EXERCICE 2
main: 
	li $a0, 32
	jal encadrement
	move $a0, $v0
	li $v0, 1
	syscall 
	li $v0, 10
	syscall
encadrement: 
	blt $a0, 27, er1
	bgt $a0, 38, er2
	li $v0, 3
	b efin
er1: 
	li $v0, 1
	b efin # pour ne pas rentrer dans le deuxième if
er2: 
	li $v0, 2
efin: 
