n : 7
s : 1 2 4 6 8 16 32 64
# calculer la somme des éléments de s : 

	.text
somme : 
	la $t0, s # t0 <- &s (i.e. i = 0)
	la $t1, n 
	lw $t1, 0($t1)
	sll $t1, $t1, 2 # t1 <- 4n
	add $t1, $t0, $t1 # t1 <- &s + 4n 
	li $v0, 0 # res = 0 

sloop : 
	bge $t0, $t1, sfin # arret si t0 >= &s + 4n
	lw $t2, 0($t0) 
	add $v0, $v0, $t2
	addi $t0, $t0, 4 
	b sloop 
sfin : nop 
# resultat dans  v0



