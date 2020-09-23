.data
message: .asciiz "Please enter your integer: "
result: .asciiz "Here is the output: "

.text
#print prompt message
addi $v0,$zero, 4
la $a0, message
syscall

addi $v0,$zero, 5
syscall 

#shift right 
sll $t0, $v0, 10
#shift left
srl $t0, $t0, 29

#print result line
addi $v0,$zero, 4
la $a0, result
syscall

addi $v0,$zero, 1
add $a0,$zero, $t0
syscall 
