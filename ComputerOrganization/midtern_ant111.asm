#University of Pittsburgh
#COE-147 Project Euler 150
#Instructor: Kartik Mohanram
#Teaching Assistants: Andrew and Sebastien
#-------------------------------------------------------



#Submitted by: Andrew Tran   
#username: ant111

#------BEGIN--------
#---Uncomment for running the actual problem (Euler 150)---
#.include "euler150_test.asm"
#--------------------------------------------------


.data

#Uncomment ONLY ONE testcase (test and sol) at a time.
#--------------------TEST CASE SUITE---------------------begin
#MY TEST 
#test: .word 25 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
#sol: .word 0

#MY TEST2
#test: .word 3, 6, 5, 4, 3, 2, 1
#sol: .word 1

#TEST-1 
#test: .word 4, 0, -3, -4, 1, 7, 2, 3, 5, 6, 7
#sol: .word -7

#TEST-2 
#test: .word 10, 273519, -153582, 450905, 5108, 288723, -97242, 394845, -488152, 83831, 341882, 301473, 466844, -200869, 366094, -237787, 180048, -408705, 439266, 88809, 499780, -104477, 451830, 381165, -313736, -409465, -17078, -113359, 13804, 455019, -388898, 359349, -355680, 89743, 127922, 30841, 229524, -480269, -345658, 163709, -166968, 310679, 194330, 70849, -516036, -411781, -491602, 523333, 293360, -262753, -235646, -181751, -477980, 275459, 459414, 332301
#sol: .word -1495491

#TEST-3 
#test: .word 7, 273519, -153582, 450905, 5108, 288723, -97242, 394845, -488152, 83831, 341882, 301473, 466844, -200869, 366094, -237787, 180048, -408705, 439266, 88809, 499780, -104477, 451830, 381165, -313736, -409465, -17078, -113359, 13804 
#sol: .word -488152

#TEST-4 
#------Test case for the example given in www.ProjectEuler.net 150---- ---Do not uncomment
#test: .word 6, 15, -14, -7, 20, -13, -5, -3, 8, 23, -26, 1, -4, -5, -18, 5, -16, 31, 2, 9, 28, 3
#sol: .word -42
#--------------------TEST CASE SUITE---------------------end




.text
la $a1, test #load the adress of the array
lw $a3, ($a1) #store depth into register $a3
sll $a3, $a3, 2 
addi $a1, $a1, 4 #set up to start reading numbers in array
lw $a0, ($a1) #set min initially to the first number
li $a2, 0 #the current "row" in the triangle
li $t2, 0 #counter for the row
main:
beq $a2, $a3, exit
	rowCounter:
	bgt $t2, $a2, nextRow
	jal createTriangles
	addi $a1, $a1, 4 #next number to start
	addi $t2, $t2, 4 #increment counter
	j rowCounter
	nextRow:
	li $t2, 0 #reset counter
addi $a2, $a2, 4 #next row
j main

createTriangles:
#saved values: starting number, starting row
la $s1, ($a1) #starting number (address)
add $s2,$zero, $a2 #starting row

li $t0, 0 #current sum, initially the apex number

li $t1, 0 #number of values to check per row
li $t3, 0 #counter for $t1
ctMain:
beq $a2, $a3, foundAll

	bases:
	bgt $t3, $t1, nextBase
	lw $t4, ($a1) #load the number that is being added to sum
	add $t0, $t0, $t4 # add to sum
	addi $t3, $t3, 4
	add $a1, $a1, 4
	j bases
	nextBase:
	#check for min
	bge $t0, $a0, minCheck
	add $a0, $zero, $t0
	minCheck:
	
	add $a1, $a1, $s2
	addi $t1, $t1, 4
	li $t3, 0
	add $a2, $a2, 4
	j ctMain
foundAll:
#restore vaules
la $a1, ($s1)
add $a2, $zero, $s2
jr $ra

exit:

#Save your final answer in the register $a0
#---------Do NOT modify anything below this line---------------
lw $s0, sol
beq $a0, $s0 pass
fail:
la $a0, fail_msg
li $v0, 4
syscall
j end
pass:
la $a0, pass_msg
li $v0, 4
syscall
end:

.data
pass_msg: .asciiz "PASS"
fail_msg: .asciiz "FAIL"
#-----END------
