.data
firstVal: .asciiz "\nWhat is the first value?\n"
secondVal: .asciiz "What is the second value?\n"
result1: .asciiz "The sum of "
result2: .asciiz " and "
result3: .asciiz " is "
result4: .asciiz " and their difference is "


.text
#prompt first value input#
addi $v0,$zero, 4
la $a0, firstVal
syscall

#first value in $t0#
addi $v0,$zero, 5
syscall 
add $t0,$v0,$zero

#prompt second value input#
addi $v0,$zero, 4
la $a0, secondVal
syscall

#second value in $t1#
addi $v0,$zero, 5
syscall 
add $t1,$v0,$zero

#first part of result#
addi $v0,$zero, 4
la $a0, result1
syscall

#print first val#
addi $v0,$zero, 1
add $a0, $t0, $zero 
syscall


addi $v0,$zero, 4
la $a0, result2
syscall

#print second val#
addi $v0,$zero, 1
add $a0, $t1, $zero 
syscall

addi $v0,$zero, 4
la $a0, result3
syscall

#put sum of values in $a0 and print sum#
addi $v0,$zero, 1
add $a0,$t0,$t1 
syscall

addi $v0,$zero, 4
la $a0, result4
syscall

#put difference of values in $a0 and print difference#
addi $v0,$zero, 1
sub $a0,$t0,$t1 
syscall

