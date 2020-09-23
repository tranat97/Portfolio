.data
some_string: .space 64
message: .asciiz "Please enter your String: \n"
result: .asciiz "Here is the output: "

.text
addi $v0,$zero, 4
la $a0, message
syscall

addi $v0,$zero, 8
la $a0, some_string
addi $a1, $zero, 100
syscall

la $t1, some_string # $t1 marks which byte is currently being modified

while: 
	lb $t0, ($t1)
	bgt $t0, 0x60, lower #branch if it is lower case
	blt $t0, 0x41, shift #if outside of range, dont modify and shift byte
	addi $t0,$t0, 0x20 #uppercase letter
	j shift
lower: #lowercase letter
	bgt $t0, 0x7A, shift
	subi $t0,$t0, 0x20 	
shift:
	
	sb $t0, ($t1)
	addi $t1, $t1, 1 #increment the byte position by 1
	beq $t0, 0x00, done #if the current byte is null then leave the loop
	j while
done:
	
#print string
addi $v0,$zero, 4
la $a0, result
syscall
la $a0, some_string
syscall
	
	