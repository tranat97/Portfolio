.data 
input: .asciiz "Enter your string:\n"
result: .asciiz "Here is you output:\n"
errorMessage: .asciiz "Your word must be at least 10 characters long!"
inString: .space 64

.text
li $v0, 4
la $a0, input
syscall #display input message

li $v0, 8
la $a0, inString
li $a1, 63 #set max characters to 63
syscall

#count the number of characters
li $v0, 0 #number of characters stored in $v0
jal count

#replace characters
move $a1, $v0 #upper bound for the rng
li $a2, 4 #number of characters that you want to be replaced
li $t2, 0 #counter
li $a3, 0x2A #the character that is replacing letters
jal replace

#display results
li $v0, 4
la $a0, result
syscall
la $a0, inString
syscall 

Exit:
        li $v0, 10             #Exit syscall
        syscall

#=====================================
count:
	lb $t0, ($a0)
	beq $t0, 0x0a, countDone #exit when the new line is found
	beq $t0, 0x00, countDone # exit when null is found
	addi $v0, $v0, 1 # add 1 to the count
	addi $a0, $a0, 1 #add 1 to byte address
	j count
	
countDone: 
	blt $v0, 10, error
	jr $ra
error:
	li $v0, 4
	la $a0, errorMessage
	syscall
	j Exit
#===================================
replace: 
	beq $t2, $a2, replaceDone
	#rng
	li $v0, 42
	#upper bound in $a1 already set before entering function
	syscall
	
	#while loop to get to the specific byte
	la $t0, inString
	add $t0, $t0, $a0
	lb $t1, ($t0)
	beq $t1, 0x20, skipByte
	beq $t1, 0x2A, skipByte #skip the byte if it is a space or *
	sb $a3, ($t0)
	addi $t2, $t2, 1
	skipByte:
	j replace
	
replaceDone:
	jr $ra
	
	
	