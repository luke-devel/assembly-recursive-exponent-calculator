.data
    
    newLine: .asciiz "\n\n"
    promptA: .asciiz "\nEnter a: "
    promptB: .asciiz "\nEnter b: "
    promptREXP: .asciiz "\nnrexp(a, b) = "

.text
main:
aLoop:
    # print promptA
    li $v0, 4
    la $a0, promptA
    syscall

    # retrieve user input
    li $v0, 5
    syscall

    # move user input 'a' into a1
    move $a1, $v0
    
    # check if a < 1
    addi $t1, $0, 1
    blt $a1, $t1, aLoop

    # check if a > 21
    addi $t1, $0, 21
    bgt $a1, $t1, aLoop

bLoop:
    # print promptB
    li $v0, 4
    la $a0, promptB
    syscall

    # retrieve user input
    li $v0, 5
    syscall

    # move user input 'b' into $a2
    move $a2, $v0
    
    # check if b < 1
    addi $t1, $0, 1
    blt $a2, $t1, bLoop

    # check if b > 7
    addi $t1, $0, 7
    bgt $a2, $t1, bLoop

    # a and b are now stored in the stack.
    # enter rexp function
    
    # allocate 4 bytes in stack pointer to store original $ra
    addi $sp, $sp, -4
    sw $ra, ($sp)

    # jump and link call to rexp()     
    jal rexp

    # deallocate 4 bytes in stack pointer and restore original $ra
    lw $ra, ($sp)
    addi $sp, $sp, 4

    # move rexp() return value from $v0 to $s0
    move $s0, $v0

    # print result prompt
    li $v0, 4
    la $a0, promptREXP
    syscall

    # print rexp() result to screen
    li $v0, 1
    move $a0, $s0
    syscall
    
rexp:
    # allocate 12 bytes to $sp
    addi $sp, $sp, -12
    sw $ra, ($sp) # store return address
    sw $a1, 4($sp) # stores 'a' arg
    sw $a2, 8($sp) # stores 'b' arg

    # initialize $t0 == 1
    addi $t0, $0, 1
    # branch to else statement if $a2 != 1
    bne $a2, $t0, else

    # if 'b' == 1
    # return 'a'
    move $v0, $a1
    j return

else:
    # remove 1 from b (--b)
    addi $a2, $a2, -1
    # jump and link back into rexp()
    jal rexp

    # multiply: a * (rexp(a, --b)), result stored in lo
    mult $a1, $v0
    # move value from lo into $v0 and enter function return
    mflo $v0

return:
    # return function reloads the values stored in the current state of the stack pointers
    # prepares for deallocation of 12 bytes
    lw $ra, ($sp)
    lw $a1, 4($sp) # a
    lw $a2, 8($sp) # b
    # addi to $sp to deallocate 12 bytes
    addi $sp, $sp, 12

    # return to the return address in main or in recursion
    jr $ra
