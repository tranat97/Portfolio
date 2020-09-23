#name: Andrew Tran
#username: ant111
#COE 0147 Lab 4 Template

#This template includes testing code, but also has some support code to check
#for a common error.

.data
    part: 	4	#change this depending on which part you are working on.
    badReturnMessage:       .asciiz "A function did not properly return! \n"
    successfulQuitMessage:  .asciiz "The program has finished. \n"
    ok:		  	    .asciiz "The LED pattern matches. \n"
    notok:		    .asciiz "The LED pattern doesn’t match! \n"
    changethepart:          .asciiz "You didn't change the part value on line 8!! Read the directions!! \n"


.text:
        #This is the beginning of the testing code. You shouldn't need to alter these lines.
    main:
    	lb $a3, part
    	beq $a3, 1, part1
    	beq $a3, 2, part2
    	beq $a3, 3, part3
    	beq $a3, 4, part4
    	la $a0, changethepart
    	addi $v0, $zero, 4
    	syscall
    	j Exit
        
    part1:
        li $a0, 0xFFFF0008      #LED memory starts at this address
        li $a1, 0x7EF965BD      #Pattern to draw. It will then be disrupted.
        jal drawPattern         #Jump and link to drawPattern, to draw an
                                #initial pattern on the display.
        j Exit	
        
    part2:
	li $a0, 0xFFFF0008 #LED memory starts at this address 
	li $a1, 0x7EF965BD #LEDs to turn on
	jal drawPattern #Jump and link to drawPattern 
	jal getPattern #Jump and link to getPattern
	bne $a1, $v0, else #Return values should be in $v0 
	la $a0, ok #Load ok string if equal
	j end
     else:	
	la $a0, notok #Load not ok string if not equal 
     end:	
     	li $v0, 4 #Print the string
	syscall
	j Exit
		
   part3:
        #Jump and link to disruptPattern. This call should alter the display by
        #disrupting the pattern that was drawn via drawPattern. This will occur
        #so fast that you will not see the original pattern that was drawn.
        #Step through this code to make sure it changes!
        li $a0, 0xFFFF0008 #LED memory starts at this address 
        li $a1, 0x7EF965BD #LEDs to turn on
	jal drawPattern #Jump and link to drawPattern
	li $v0, 30 #get initial timing
	syscall
	move $t1, $a0
     timing:
     	li $v0, 30
     	syscall
     	sub $t0, $a0, $t1
     	blt $t0, 1000, timing
     	li $a0, 0xFFFF0008 #LED memory starts at this address 
        li $a1, 0x7EF965BD #LEDs to turn on
        jal disruptPattern
        j Exit			
        
      	# Add test code here to test part 4
   part4: 	
   	li $a0, 0xFFFF0008      #LED memory starts at this address
   	jal drawShape
   


   Exit:
        la $a0, successfulQuitMessage
        li $v0, 4
        syscall

        li $v0, 10             #Exit syscall
        syscall

        #This is the end of the testing code.

#========================================
# * Place your drawPattern code here    *
#========================================
    drawPattern:
        sw $a1, ($a0)
        jr $ra

#========================================
# * DO NOT ALTER THIS NEXT LINE         *
j returnErrorHappened
#========================================




#========================================
# * Place your getPattern code here     *
#========================================
    getPattern:
        lw $v0, ($a0)
	jr $ra



#========================================
# * DO NOT ALTER THIS NEXT LINE         *
j returnErrorHappened
#========================================




#========================================
# * Place your disruptPattern code here *
#========================================
    disruptPattern:
    	addi $s0, $ra, 0
    	jal getPattern
    	move $a1, $v0
        xori $a1, 0xC31601C9
        jal drawPattern
        addi $ra,$s0, 0
	jr $ra


#========================================
# * DO NOT ALTER THIS NEXT LINE         *
j returnErrorHappened
#========================================




#========================================
# * Place your drawShape code here *
#========================================
    drawShape:
        addi $s0, $ra, 0
        addi $t0, $a0, 128 #where yellow starts
        addi $t1, $a0, 260 #where pattern ends
    red:
        li $a1, 0x55555555
        j draw
    yellow:
    	addi $a0, $a0, 4
    	li $a1, 0xaaaaaaaa
    draw:
        jal drawPattern
        addi $a0, $a0, 32
        beq $a0, $t0, yellow
        beq $a0, $t1, done
        j draw
    done:
        addi $ra, $s0, 0
        jr $ra
        
#========================================
# * DO NOT ALTER THIS NEXT LINE         *
j returnErrorHappened
#========================================

returnErrorHappened:
    #If this code is executed, your function did not properly return.
    la $a0, badReturnMessage
    li $v0, 4
    syscall
    li $v0, 10
    syscall
