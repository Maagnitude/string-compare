.data
    strg1:         .space   50
    strg2:         .space   50
    firstMessage:  .asciiz  "Enter first string: "
    secondMessage: .asciiz  "Enter second string: "
    sameMessage:   .asciiz  "\nYou entered the same string two times"
    diffMessage:   .asciiz  "\nEntered strings are not same!"
.text
    main:
        la $a0, firstMessage	# gives first message's address to $a0
        jal printf		# used printf to print the first message
        
        la $a0, strg1		# gives the address of first char array
        li $a1, 50		# max characters
        jal gets		# used gets to get user input
        
        la $a0, secondMessage	# gives second message's address to $a0
        jal printf		# used printf to print the second message
        
        la $a0, strg2		# gives the address of second char array
        li $a1, 50		# max characters
        jal gets		# used gets to get user input
        
        # Saves $t0 - $t4 to stack. It's done to demonstrate
        # the caller - callee conventions.
        addi $sp, $sp, -16	# Reserves 4 integer spaces in the stack and moves sp
        sw $t0, 12($sp)		# Saves temp registers to stack
        sw $t1, 8($sp)
        sw $t2, 4($sp)
        sw $t3, 0($sp)
        
        la $a0, strg1		# First argument for strcmp
        la $a1, strg2		# Second argument for strcmp
        jal strcmp
        
        lw $t3, 0($sp)		# Restores temp registers from stack
        lw $t2, 4($sp)		
        lw $t1, 8($sp)
        lw $t0, 12($sp)
        addi $sp, $sp, 16	# Releases reserved space from stack and moves sp back
        
        beqz $v1, true
        
        # false : strings are not equal
        la $a0 diffMessage
        jal printf
        j exit
        
        # true : strings are equal
        true:
             la $a0, sameMessage
             jal printf
            
        exit:
             li $v1, 0		# Returns 0
             li $v0, 10		# Calls program termination
             syscall
            
        # Here we print the message
        printf:
               li $v0, 4	# syscall to print string to the screen
               syscall
               jr $ra
            
        # Here we read a string from user's input
        gets:
             li $v0, 8		# syscall to read string from user's input
             syscall
             jr $ra
            
        # Here we compare character one by one for both strings
        strcmp:
               li $t3, 0	# Initializes loop counter
               
               loop:
                    beq $t3, 50, exitLoop	# Exit loop condition, after 50 loops
                   
                    lb $t0, 0($a0)		# Loads char from string char
                    lb $t1, 0($a1)
                    sub $t2, $t0, $t1		# Subtracts the binary representation 
                   				# of each char from both strings
                    add $v1, $v1, $t2		# Adds the result to $v1
                   
                    addi $a0, $a0, 1		# Advances the counter
                    addi $a1, $a1, 1		# Advances next byte-char
                    addi $t3, $t3, 1
                    j loop
                    
                    exitLoop:
                             jr $ra