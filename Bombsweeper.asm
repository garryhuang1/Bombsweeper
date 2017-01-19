##############################################################
# Homework #3
# name: Garry Huang
# sbuid: 109247416
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

smiley:
    #Define your code here
    	
    	la $t0, 0xffff0000
    	move $t4, $t0
    	li $t2, 66
    	li $t6, 69
    	la $t1, 0x0F
    	la $t5, 0xB7
    	la $t7, 0x1F
    	li $t3, 0
    	li $t9, '\0'
    	#sb $t2, 0($t0) bomb
    	initialize:
    		beq $t3, 200, done
    		sb $t9, 0($t0)
    		sb $t1, 1($t0)
    		addi $t0, $t0, 2
    		addi $t3, $t3, 2
    		j initialize
    	done:
    		move $t0, $t4
    		addi $t0, $t0, 46
    		sb $t2, 0($t0)
    		sb $t5, 1($t0)
    		addi $t0, $t0, 6
    		sb $t2, 0($t0)
    		sb $t5, 1($t0)
    		addi $t0, $t0, 14
    		sb $t2, 0($t0)
    		sb $t5, 1($t0)
    		addi $t0, $t0, 6
    		sb $t2, 0($t0)
    		sb $t5, 1($t0)
    		addi $t0, $t0, 52
    		sb $t6, 0($t0)
    		sb $t7, 1($t0)
    		addi $t0, $t0, 10
    		sb $t6, 0($t0)
    		sb $t7, 1($t0)
    		addi $t0, $t0, 12
    		sb $t6, 0($t0)
    		sb $t7, 1($t0)
    		addi $t0, $t0, 6
    		sb $t6, 0($t0)
    		sb $t7, 1($t0)
    		addi $t0, $t0, 16
    		sb $t6, 0($t0)
    		sb $t7, 1($t0)
    		addi $t0, $t0, 2
    		sb $t6, 0($t0)
    		sb $t7, 1($t0)
    	#sb $t2, 1($t0)
    	
    	
    	
    	
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

open_file:
    #Define your code here
  

    li $a1, 0
    li $a2, 0
    li $v0, 13
    syscall
     
    jr $ra

close_file:
    
    li $v0,16
    syscall 
    jr $ra

load_map:
    la $t1, 0x00 
    li $t3, 0
    move $s0, $a1 
    initialize_cells:
    	beq $t3, 100, finish_initialize
    	sb $t1, 0($s0)
    	addi $s0, $s0, 1
    	addi $t3, $t3, 1
    	j initialize_cells
    finish_initialize:
    move $s7, $a1
    
    
    li $s3, 0 #Check if reading a row or column
    #la $a1, input_buffer
    #li $a2, 1
    #li $v0, 14
    #syscall
   la $s0, input_array
   li $t3, 0
   li $t4, 0 #CHECK FOR >10
   li $t5, 0 #CHECK 0
   checkInput:

   	la $a1, input_buffer
   	li $a2, 1
   	li $v0, 14
   	syscall   	
   	beqz $v0, checkInputLoopPre
   	
   	lb $t0, 0($a1)
   	beq $t4, 1, checkNum
   	j checkSpace
   	checkNum:
   		bge $t0, 47, failedLife
   		li $t4, 0
   	checkSpace:
   	beq $t0, 48, checkZero
   	#ble $t0, 32, checkInput
   	ble $t0, 32, checkIfNumOrSpace
   	bge $t0,58, failedLife
   	ble $t0, 47, failedLife
	
	j addToArray
	checkZero:
		move $t6, $t0 #STORE PREV VALUE
		beq $t5, 1, checkIfNumOrSpace
		li $t5, 1 
		j checkInput
	checkIfNumOrSpace:
		beq $t0, 48, checkInput
		beq $t5, 0, checkInput
		li $t5, 0
		move $t0, $t6
	addToArray:
   	sb $t0, ($s0)
   	addi $s0, $s0, 1
	addi $t3, $t3, 1
	beq $t0, 48, checkInput
	li $t5, 0
	li $t4, 1 #NEXT INPUT MUST BE LESS THAN 47
   	j checkInput
   checkInputLoopPre:
   beqz $t3, failedLife
   addi $s0, $s0, 1
   li $t0, '\0'
   sb $t0, 0($s0)
   la $s0, input_array	
   li $t1, '\0'
   checkInputLoop:		
	lb $a0, 0($s0)
	beqz $a0, postCheckInput
	addi $s0, $s0, 1
	li $v0, 11
	#syscall
	
	li $a0, '\n'
	li $v0, 11
	#syscall
	
	j checkInputLoop
	
    postCheckInput:
    la $s1, input_array
    #la $s1, 0($s0) #Contains read info
    store_info:
    li $t1, '\0'
    lb $s2, 0($s1) #Contains the first byte of input
    addi $s1, $s1, 1
    beq $s2, $t1, exit_info
    blt $s2, 48, store_info
    bgt $s2, 57, store_info
    bnez $s3, is_col
    is_row:
    	move $s4, $s2 #Set row
    	addi $s4, $s4, -48
    	li $s3, 1 
    	j is_exit
    is_col:
    	move $s5, $s2 #Set col
    	addi $s5, $s5, -48
    	li $s3, 0
	li $s6, 10
	mul $s6, $s6, $s4 #row * 10
	add $s6, $s6, $s5 #row*10+col
	add $s7, $s7, $s6 #t5 position
	la $t7, 0x20
	sb $t7, 0($s7)
	
	sub $s7, $s7, $s6 #reset position to 0
    	li $s6, 20
    	mul $s4, $s4, $s6 # row
    	li $s6, 2
    	mul $s5, $s5, $s6 # col
    	add $t7, $s5, $s4
    	
    	la $s6, 0xffff0000
    	add $s6, $s6, $t7
    	la $s4, 0x07
    	li $s5, 66
    	#sb $s5, 0($s6)  #SHOWS BOMBS
    	#sb $s4, 1($s6)
    	
    is_exit:
    	j store_info
    exit_info:
    	beq $s3, 1, failedLife
    	
     	li $s1, 0
     	move $s0, $s7   
    checkBombLoop:
    	beq $s1, 100, passedLife
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	move $a0, $s0
    	move $a1, $s1
    	jal adjacent 
    	lw $ra, 0($sp)
    	lb $t0, 0($s0)
    	or $t0, $t0, $v0
    	sb $t0, 0($s0)
    	addi $s0, $s0, 1
    	addi $s1, $s1, 1
    	
    	
    	move $a0, $t0
    	li $v0, 1
    	#syscall
    	li $a0, '\n'
    	li $v0, 11
    	#syscall
    	j checkBombLoop
    failedLife:
    	li $v0, -1
    	j gaveUp
    passedLife:
    	li $t0, 0
    	sw $t0, cursor_row
    	sw $t0, cursor_col
    	li $v0, 1
    gaveUp:
    jr $ra
adjacent:
	la $t0, 0($a0)
	li $t1, 0 #Bomb counter
	move $t2, $a1 #Position
	li $t9, 10
	li $t8, 1
	li $t7, 11

	div $t2, $t9
	mfhi $t3
	sub $t4, $t3,$t8
	bltz $t4, adjCaseOne
	sub $t4, $t2, $t9
	bltz $t4, adjCaseOne 
		move $t4, $t0
		sub $t4, $t4, $t7
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseOne
		addi $t1, $t1, 1
	adjCaseOne:
	sub $t4, $t2, $t9
	bltz $t4, adjCaseTwo
		move $t4, $t0
		sub $t4, $t4, $t9
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseTwo
		addi $t1, $t1, 1
	adjCaseTwo:
	div $t2, $t9
	mfhi $t3
	add $t3, $t3, $t8
	bge $t3, 10, adjCaseThree
	sub $t3, $t2, $t9
	bltz $t3, adjCaseThree
		move $t4, $t0
		sub $t4, $t4, $t9
		addi $t4, $t4, 1
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseThree
		addi $t1, $t1, 1
	adjCaseThree:
	div $t2, $t9
	mfhi $t3
	sub $t3, $t3, $t8
	bltz $t3, adjCaseFour
		move $t4, $t0
		sub $t4, $t4, $t8
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseFour
		addi $t1, $t1, 1
	adjCaseFour:
	div $t2, $t9
	mfhi $t3
	add $t3, $t3, $t8
	bge $t3, 10, adjCaseFive
		move $t4, $t0
		add $t4, $t4, $t8
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseFive
		addi $t1, $t1, 1
	adjCaseFive:
	add $t3, $t2, $t9
	bge $t3, 100, adjCaseSix
	div $t2, $t9
	mfhi $t3
	sub $t3, $t3, $t8
	bltz $t3, adjCaseSix
		move $t4, $t0
		addi $t4, $t4, 9
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseSix
		addi $t1, $t1, 1
	adjCaseSix:
	add $t3, $t2, $t9
	bge $t3, 100, adjCaseSeven
		move $t4, $t0
		add $t4, $t4, $t9
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, adjCaseSeven
		addi $t1, $t1, 1
	adjCaseSeven:
	add $t3, $t2, $t9
	bge $t3, 100, finishCases
	div $t2, $t9
	mfhi $t3
	add $t3, $t3, $t8
	bge $t3, 10, finishCases
		move $t4, $t0
		addi $t4, $t4, 11
		lb $t4, 0($t4)
		srl $t4, $t4, 5
		andi $t4, $t4, 1
		beq $t4, 0, finishCases
		addi $t1, $t1, 1
	finishCases:
	move $v0, $t1
	jr $ra
	
##############################
# PART 3 FUNCTIONS
##############################
addi $sp, $sp, -4
sw $s0, 0($sp)
init_display:
    #Define your code here
    la $s0, 0xFFFF0000
    li $t1, 0
    la $t2, 0x77 #77
    li $t3, '\0'
    initializeMatrix:
    		beq $t1, 200, doneMatrix
    		sb $t3, 0($s0)
    		sb $t2, 1($s0)
    		addi $s0, $s0, 2
    		addi $t1, $t1, 2
    		j initializeMatrix
    
    doneMatrix:
    la $t0, 0xB0 # CURSOR COLOR
    la $t3, 0x0F # HOLD FOREGROUND COLOR
    li $t1, '\0'
    la $s0, 0xFFFF0000
    la $t4, 0xF0
    lb $t2, 1($s0)
    and $t2, $t4, $t2
    addi $sp, $sp, -4
    srl $t2, $t2, 4
    sw $t2, 0($sp)
    
    move $a0, $t2
    li $v0, 1
    #syscall
    
    lb $t2, 1($s0)
    and $t2, $t3, $t2
    or $t2, $t0, $t2
    sb $t2, 1($s0)

    lw $s0, 0($sp)
    addi $sp, $sp, 4    
    jr $ra

set_cell:
    #Define your code here
    move $t0, $a0 #row
    move $t1, $a1 #col
    move $t2, $a2 #char to be displayed
    move $t3, $a3 #foreground color
    lw $t4, 0($sp) #background color
    addi $sp, $sp, 4
    
    blt $t0, 0, setCellFail
    bge $t0, 10, setCellFail
    blt $t1, 0, setCellFail
    bge $t1, 10, setCellFail
    blt $t3, 0, setCellFail
    bgt $t3, 15, setCellFail
    blt $t4, 0, setCellFail
    bgt $t4, 15, setCellFail
    setCellSuccess:
    	li $t5, 20
    	mul $t5, $t0, $t5 #row*10
    	li $t6, 2
    	mul $t6, $t1, $t6#col*2
    	add $t5, $t5, $t6 #Pos in 2d array
    	la $t6, 0xFFFF0000
    	add $t6, $t6, $t5 #Location to store
    	sb $t2, 0($t6)	
    	sll $t4, $t4, 4
    	or $t4, $t4, $t3 #Background + foreground color
    	sb $t4, 1($t6)
    	j setCellDone
    setCellFail:
    	li $v0, -1
    	j setCellExit
    setCellDone:
    	li $v0, 1
    setCellExit:
    jr $ra

reveal_map:
    move $t0, $a0 #Game status
    move $s0, $a1 #Cell array
    #la $s0, 0x1001014d
    li $s1, 0 #COUNTER FOR FOR LOOP
    
    
    beq $t0, -1, gameLose
    beq $t0, 0, gameOngoing
    beq $t0, 1, gameWin
    
    gameWin:
    addi $sp, $sp, -4
    sw $ra, ($sp)
    jal smiley
    lw $ra, ($sp)
    li $v0, 2
    j revealMapExit
    gameLose:
    
    
    lw $a0, cursor_row
    lw $a1, cursor_col
    li $a2, 'e'
    li $a3, 15
    li $t0, 9
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $ra, 4($sp)
    jal set_cell
    lw $ra, 0($sp)
    addi $sp, $sp, 4 #SET CURSOR TO EXPLODE
    
    revealLoop:
    beq $s1, 100, setExplosion
    la $t0, 0x30
    lb $t1, 0($s0)
    and $t1, $t1, $t0
    beq $t1, $t0, flagCorrect
    la $t0, 0x10
    lb $t1, 0($s0)
    and $t1, $t1, $t0
    beq $t1, $t0, flagWrong
    la $t0, 0x20
    lb $t1, 0($s0)
    and $t1, $t1, $t0
    beq $t1, $t0, bombFound
    revealNumber:
    	la $t0, 0x0F
    	lb $t1, 0($s0)
    	move $a0, $t1
    	li $v0, 1
    	#syscall
    	and $t1, $t1, $t0
    	addi $t1, $t1, '0'
    	li $t2, 10
    	div $s1, $t2
    	mflo $a0 #ROW
    	mfhi $a1 #COL
    	move $a2, $t1
    	bne $t1, 48, notZero
    	isZero:
    	li $a2, '\0'
    	li $a3,15
    	li $t0, 0
    	j continueRevealNumber
    	notZero:
    	li $a3, 13
    	li $t0, 0
    	continueRevealNumber:
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	j counterInc
    flagCorrect:
    	li $t2, 10
    	div $s1, $t2
    	mflo $a0
    	mfhi $a1
    	li $a2, 'f'
    	la $t3, 0xFFFF0000
    	li $t4, 2
    	mul $t4, $s1, $t4
    	add $t3, $t3, $t4
    	lb $t3, 1($t3)
    	la $t4, 0x0F 
    	and $t4, $t4, $t3
    	move $a3, $t4
    	li $t0, 10
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	j counterInc	
    flagWrong:
        li $t2, 10
    	div $s1, $t2
    	mflo $a0
    	mfhi $a1
    	li $a2, 'f'
    	la $t3, 0xFFFF0000
    	li $t4, 2
    	mul $t4, $s1, $t4
    	add $t3, $t3, $t4
    	lb $t3, 1($t3)
    	la $t4, 0x0F 
    	and $t4, $t4, $t3
    	move $a3, $t4
    	li $t0, 9
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	j counterInc	
    bombFound:
    	li $t2, 10
    	div $s1, $t2
    	mflo $a0
    	mfhi $a1
    	li $a2, 'b'
    	li $a3, 7
    	li $t0, 0
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	j counterInc
    counterInc:
    	addi $s1, $s1, 1
    	addi $s0, $s0, 1
    	j revealLoop
    li $v0, 1
    j revealMapExit
    gameOngoing:
    li $v0, 0
    j revealMapExit
    setExplosion:
    lw $a0, cursor_row
    lw $a1, cursor_col
    li $a2, 'e'
    li $a3, 15
    li $t0, 9
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $ra, 4($sp)
    jal set_cell
    lw $ra, 0($sp)
    addi $sp, $sp, 4 #SET CURSOR TO EXPLODE
    revealMapExit:
    jr $ra


##############################
# PART 4 FUNCTIONS
##############################
#NEED TO DO CHANGE BITS TO REFLECT ALLC HANGES MADE
perform_action:   
addi $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $s7, 28($sp)
    move $s0, $a0 #CELL ARRAY
    move $s1, $a1 #CHAR ACTION
    
    lw $s2, cursor_row #CURSOR ROW
    lw $s3, cursor_col #CURSOR COL
    
    la $s4, 0xFFFF0000
   
    li $t0, 20
    li $t3, 10
    li $t1, 2
    
    mul $s5, $s2, $t0
    mul $t4, $s3, $t1
    add $s5, $t4, $s5 #Get position in 2d array
    add $s4, $s4, $s5
    
    lb $a2, 0($s4)
    move $a0, $s2
    move $a1, $s3
    la $t0, 0x0F
    lb $t1, 1($s4)
    and $a3, $t0, $t1
    la $t0, 0xF0
    and $t0, $t0, $t1
    
     
       
    beq $s1, 119, moveUp
    beq $s1, 87, moveUp
    beq $s1, 97, moveLeft
    beq $s1, 65, moveLeft
    beq $s1, 115, moveDown
    beq $s1, 83, moveDown
    beq $s1, 100, moveRight
    beq $s1, 68, moveRight
    beq $s1, 70, attemptFlag
    beq $s1, 102, attemptFlag
    beq $s1, 114, revealTile
    beq $s1, 82, revealTile
    j performActionFail
    moveUp:
    	addi $s2, $s2, -1
    	bltz $s2, performActionFail
    	sw $s2, cursor_row
    	move $a0, $s2
    	lb $s6, 0($s4)
    	la $t0, 0x0F
    	lb $t1, 1($s4)
    	and $s5, $t0, $t1
    	addi $s4, $s4, -20
    	lb $a2, 0($s4)
    	la $t0, 0xF0
    	lb $t1, 1($s4)
    	and $s7, $t1, $t0
    	la $t0, 0x0F
    	and $a3, $t1, $t0
    	
    	li $t0, 11
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	bne $v0, -1, moveUpDone
    	addi $s2, $s2, 1
    	sw $s2, cursor_row
    	j performActionFail
    moveUpDone: #REMOVE PREVIOUS CURSOR
    	addi $s2, $s2, 1 # row
    	move $a0, $s2
    	move $a1, $s3 #col
    	move $a2, $s6
    	move $a3, $s5
    	lw $t0, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -4
    	srl $s7, $s7, 4
    	sw $s7, 0($sp)
    	
    	j performActionSuccess
    moveLeft:
    	addi $s3, $s3, -1
    	bltz $s3, performActionFail
    	sw $s3, cursor_col
    	move $a1, $s3
    	lb $s6, 0($s4)
    	la $t0, 0x0F
    	lb $t1, 1($s4)
    	and $s5, $t0, $t1
    	addi $s4, $s4, -2
    	lb $a2, 0($s4)
    	la $t0, 0xF0
    	lb $t1, 1($s4)
    	and $s7, $t1, $t0
    	la $t0, 0x0F
    	and $a3, $t1, $t0
    	li $t0, 11
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4  
    	bne $v0, -1, moveLeftDone	
    	addi $s3, $s3, 1
    	sw $s3, cursor_col
    	j performActionFail
    moveLeftDone:
    	addi $s3, $s3, 1 # row
    	move $a0, $s2
    	move $a1, $s3 #col
    	move $a2, $s6
    	move $a3, $s5
    	lw $t0, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -4
    	srl $s7, $s7, 4
    	sw $s7, 0($sp)
    	
    	j performActionSuccess
    moveDown:
    	addi $s2, $s2, 1
    	sw $s2, cursor_row
    	move $a0, $s2
    	lb $s6, 0($s4)
    	la $t0, 0x0F
    	lb $t1, 1($s4)
    	and $s5, $t0, $t1
    	addi $s4, $s4, 20
    	lb $a2, 0($s4)
    	la $t0, 0xF0
    	lb $t1, 1($s4)
    	and $s7, $t1, $t0
    	la $t0, 0x0F
    	and $a3, $t1, $t0
    	
    	li $t0, 11
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4  
    	bne $v0, -1, moveDownDone
    	addi $s2, $s2, -1
    	sw $s2, cursor_row
    	j performActionFail
    moveDownDone:
    	addi $s2, $s2, -1 # row
    	move $a0, $s2
    	move $a1, $s3 #col
    	move $a2, $s6
    	move $a3, $s5
    	lw $t0, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -4
    	srl $s7, $s7, 4
    	sw $s7, 0($sp)
    	
    	j performActionSuccess
    moveRight:
    	addi $s3, $s3, 1
    	sw $s3, cursor_col
    	move $a1, $s3
    	lb $s6, 0($s4)
    	la $t0, 0x0F
    	lb $t1, 1($s4)
    	and $s5, $t0, $t1
	addi $s4, $s4, 2
	lb $a2, 0($s4)
	la $t0, 0xF0 #BG COLOR
	
	lb $t1, 1($s4)
	and $s7, $t1, $t0
	
	
	la $t0, 0x0F
	and $a3, $t1, $t0
	
	
    	li $t0, 11
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4 
    	bne $v0, -1, moveRightDone
    	addi $s3, $s3, -1
    	sw $s3, cursor_col
    	j performActionFail
    moveRightDone:
    	addi $s3, $s3, -1 # row
    	move $a0, $s2
    	move $a1, $s3 #col
    	move $a2, $s6
    	move $a3, $s5
    	lw $t0, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $sp, $sp, -4
    	srl $s7, $s7, 4
    	sw $s7, 0($sp)
    	
    	j performActionSuccess
    attemptFlag:
    	li $t0, 10
    	mul $t0, $t0, $s2
    	add $t0, $t0, $s3
    	add $s0, $s0, $t0
    	lb $t0, 0($s0)
    	la $t1, 0x10
    	and $t2, $t1, $t0
    	beq $t2, $t1, toggleFlag
    	la $t1, 0x40
    	and $t2, $t1, $t0
    	bne $t2, $t1, setFlag
    	la $t1, 0x40
    	and $t2, $t1, $t0
    	beq $t2, $t1, performActionFail
    	j performActionFail
    	
    toggleFlag:
    	lb $t0, 0($s0)
    	la $t1, 0xEF
    	and $t0, $t0, $t1
    	sb $t0, 0($s0)
    	
    	move $a0, $s2
    	move $a1, $s3
    	li $a2, '\0'
    	li $a3, 7
    	li $t0, 11
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp) 
    	li $t0, 7
    	addi $sp, $sp, -4
    	sw $t0, 0($sp)
    	
    j performActionSuccess
    setFlag:
    	lb $t0, 0($s0)
    	la $t1, 0x10
    	or $t0, $t0, $t1
    	sb $t0, 0($s0)
    	
    	move $a0, $s2
    	move $a1, $s3
    	li $a2, 'f'
    	li $a3, 12
    	li $t0, 11
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4 
    	li $t0, 7
    	addi $sp, $sp, -4
    	sw $t0, 0($sp)
    j performActionSuccess
    revealTile:
    	li $t0, 10
    	mul $t0, $t0, $s2
    	add $t0, $t0, $s3
    	add $s6, $s0, $t0
    	lb $t0, 0($s6)
    	la $t1, 0x40
    	and $t2, $t0, $t1
    	beq $t1, $t2, performActionFail
    	lb $t0, 0($s6)
    	la $t1, 0x10
    	and $t2, $t0, $t1
    	bne $t1, $t2, removeFlagRevealSkip
    	la $t1, 0xEF
    	and $t0, $t0, $t1
    	sb $t0 0($s6)
    	removeFlagRevealSkip:
    	lb $t0, 0($s6)
    	la $t1, 0x20
    	and $t0, $t0, $t1
    	beq $t0, $t1, bombReveal
    	move $a0, $s0
    	move $a1, $s2
    	move $a2, $s3
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal search_cells
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	move $a0, $s2
    	move $a1, $s3
    	lb $a2, 0($s4)
    	lb $t0, 1($s4)
    	la $t1, 0x0F
    	and $a3, $t0, $t1
    	li $t0, 11
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	li $t0, 0
    	addi $sp, $sp, -4
    	sw $t0, 0($sp)
    	
    	
    	j performActionSuccess
    bombReveal:	
    	lb $t0, 0($s6) #SET BOMB
    	la $t1, 0x40
    	or $t0, $t0, $t1
    	sb $t0, 0($s6)
    	move $a0, $s2
    	move $a1, $s3
    	li $a2, 'e'
    	li $a3, 15
    	li $t0, 9
    	addi $sp, $sp, -8
    	sw $t0, 0($sp)
    	sw $ra, 4($sp)
    	jal set_cell
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	li $t0, 9
    	addi $sp, $sp, -4
    	sw $t0, 0($sp)
    	j performActionSuccess
    performActionSuccess:
    	li $v0, 0
    	j performActionExit
    performActionFail:
    	li $v0, -1
    performActionExit:
    
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $s7, 28($sp)
addi $sp, $sp, 32
    jr $ra

game_status:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    
    move $s0, $a0
    li $t0, 0
    li $s1, 0 #Reveal Counter
    li $s2, 0 #Flag Counter
    gameStatusLoop:
    	beq $t0, 100, gameStatusWin
    	lb $t1, 0($s0)
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	la $t2, 0x60
    	and $t3, $t2, $t1
    	beq $t3, $t2, gameStatusLose
    	la $t2, 0x30
    	and $t3, $t2, $t1
    	beq $t3, $t2, gameStatusLoop
    	la $t2, 0x10
    	and $t3, $t2, $t1
    	beq $t3, $t2, gameWinIncrement
    	la $t2, 0x20
    	and $t3, $t2, $t1
    	beq $t3, $t2, gameWinIncrement
    	j gameStatusLoop
    flagIncrement:
    gameWinIncrement:
    	addi $s1, $s1, 1
    	
    	j gameStatusLoop
    gameStatusLose:
    li $v0, -1
    j gameStatusExit
    gameStatusWin:
    bge $s1, 1, gameStatusDone
    li $v0, 1
    j gameStatusExit    	
    gameStatusDone:
    li $v0, 0
    gameStatusExit:
    ##########################################
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addi $sp, $sp, 12
    jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    
    move $fp, $sp
    addi $sp, $sp, -8
    sw $s1, 0($sp)
    sw $s2, 4($sp)
    
    searchCellsLoop:
    	li $s4, 0
    	beq $sp, $fp, searchCellsLoopDone
	lw $s1, 0($sp) #ROW
	lw $s2, 4($sp) #COL
	addi $sp, $sp, 8
	li $t2, 10
	mul $t3, $s1, $t2
	add $t3, $t3, $s2
	
	add $s3, $t3, $s0 #CELLS ARRAY LOCATION
	la $t4,0x10
	lb $t3, 0($s3)
	and $t3, $t4, $t3
	beq $t3, $t4,skipFlag
	noFlagRevealTile:
		lb $t3, 0($s3)
		la $t4, 0x0F
		and $t3, $t3, $t4
		beq $t3, 0, revealZeroNoFlag
		addi $t3, $t3, '0'
		move $a0, $s1
		move $a1, $s2
		move $a2, $t3
		li $a3, 13
		li $t0, 0
		addi $sp, $sp, -8
    		sw $t0, 0($sp)
    		sw $ra, 4($sp)
    		jal set_cell
    		lw $ra, 0($sp)
    		addi $sp, $sp, 4
		lb $t3, 0($s3)
    		la $t4, 0x40
    		or $t3, $t3, $t4
    		sb $t3, 0($s3)
    		j skipFlag	
	revealZeroNoFlag:
		move $a0, $s1
		move $a1, $s2
		li $a2, '\0'
		li $a3, 15
		li $t0, 0
		addi $sp, $sp, -8
    		sw $t0, 0($sp)
    		sw $ra, 4($sp)
    		jal set_cell
    		lw $ra, 0($sp)
    		addi $sp, $sp, 4
    		addi $s4, $s4, 1	
	skipFlag:
	 	lb $t3, 0($s3)
	 	la $t2, 0x0F
	 	and $t3, $t2, $t3
	 	bne $t3, 0, searchCellsLoop
	 		searchCellOne:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t0, $t0, 1
	 		bge $t0, 10, searchCellTwo
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellTwo
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellTwo
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellTwo:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t1, $t1, 1
	 		bge $t1, 10, searchCellThree
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellThree
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellThree
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellThree:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t0, $t0, -1
	 		bltz $t0, searchCellFour
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellFour
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellFour
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellFour:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t1, $t1, -1
	 		bltz $t1, searchCellFive
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellFive
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellFive
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellFive:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t0, $t0, -1
	 		bltz $t0, searchCellSix
	 		addi $t1, $t1, -1
	 		bltz $t1, searchCellSix
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellSix
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellSix
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellSix:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t0, $t0, -1
	 		bltz $t0, searchCellSeven
	 		addi $t1, $t1, 1
	 		bge $t1, 10, searchCellSeven
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellSeven
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellSeven
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellSeven:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t0, $t0, 1
	 		bge $t0, 10, searchCellEight
	 		addi $t1, $t1, -1
			bltz $t1, searchCellEight
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellEight
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellEight
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 		searchCellEight:
	 		move $t0, $s1 #ROW
	 		move $t1, $s2 #COL
	 		lb $t3, 0($s3) #BYTE
	 		addi $t0, $t0, 1
	 		bge $t0, 10, searchCellDone
	 		addi $t1, $t1, 1
			bge $t1, 10, searchCellDone
	 		la $t4, 0x40
	 		and $t5, $t4, $t3
	 		beq $t4, $t5, searchCellDone
	 		la $t6, 0x10
	 		and $t7, $t6, $t3
	 		beq $t7, $t6, searchCellDone
	 		addi $sp, $sp, -8
	 		sw $t0, 0($sp)
	 		sw $t1, 4($sp)
	 		addi $s4, $s4, 1
	 	searchCellDone:
	 	beq $s4, 0, searchCellsLoopExit
	 	lb $t3, 0($s3)
    		la $t4, 0x40
    		or $t3, $t3, $t4
    		sb $t3, 0($s3)
    		searchCellsLoopExit:
	 	j searchCellsLoop
    searchCellsLoopDone:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    addi $sp, $sp, 20
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
cursor_row: .word -1
cursor_col: .word -1

#place any additional data declarations here
input_buffer: .space 1
input_array: .space 300
