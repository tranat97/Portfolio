.data
buf1: .space 64
buf2: .space 64
message: .asciiz "Please enter your String: \n"
result: .asciiz "Here is the output: "

.text
addi $v0,$zero, 4
la $a0, message
syscall

addi $v0,$zero, 8
la $a0, buf1
addi $a1, $zero, 1000
syscall


la $t1, buf1 #byte counter for buf1
la $t2, buf2 #byte counter buf2
la $t4, -1($t1) #marks byte before the string starts

length: #finding lengths for each word in the string
	lb $t0, ($t1)
	beq $t0, 0x20, load #go to reverse if a space is found
	beq $t0, 0x0a, load #go to reverse if new line is found (made when hitting enter)
	beq $t0, 0x00, final
continue:
	addi $t1, $t1, 1
	j length

load: #store current position of $t1 -1 in $t3
	la $t3, -1($t1)
reverse:
	lb $t0, ($t3)
	beq $t3, $t4, loop2Done #exit if passed first byte in the string
	beq $t0, 0x20, loop2Done
	sb $t0, ($t2)
	addi $t2, $t2, 1
skipByte:
	subi $t3, $t3, 1
	j reverse
loop2Done:
j continue

final:

#print string
addi $v0,$zero, 4
la $a0, result
syscall
la $a0, buf2
syscall




