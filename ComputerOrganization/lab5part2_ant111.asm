.data
input: .asciiz "Enter the sequence index:\n"
result: .asciiz "The Fibonacci value is:\n"

.text
li $v0, 4
la $a0, input
syscall #display input message

li $v0, 5
syscall

#move unput into the argument register
move $a0, $v0
li $v0, 0

jal Fibonacci

addi $t0, $v0, 0 #store final result in $t0 and display result message
li $v0, 4
la $a0, result
syscall

#display result
add $a0, $t0, 0
li $v0, 1
syscall

li $v0, 10  #Exit syscall
syscall

Fibonacci:
	addi $sp, $sp, -8 #allocate space in stack
	sw $s0, 0($sp)
	sw $ra, 4($sp)#save return address
	move $s0, $a0
	ble $s0, 2, Count
	
	#Fibonacci(n-1)
	subi $a0, $s0, 1
	jal Fibonacci
	
	#Fibonacci(n-2)
	subi $a0, $s0, 2
	jal Fibonacci
	j Done
	
Count:
	addi $v0, $v0, 1
Done:
	lw $ra, 4($sp) #restore return adress and argument
	lw $s0, 0($sp)
	addi $sp, $sp, 8 #restore stack
	jr $ra