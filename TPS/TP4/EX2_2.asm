# EXERCICE 2
puissance : 
li $t0, 0
li $v0, 1

ploop : 
	bge $t0, $a0, pfin # condition inverse pour sortir de la boucle
	# corp de la boucle : 
	sll $v0, $v0, 1
	addi $t0, $t0, 1
	b ploop
pfin : 
