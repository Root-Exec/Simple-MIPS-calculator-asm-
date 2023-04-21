	.data

multi_char: .byte '*'
add_char: .byte '+'
sub_char: .byte '-'
div_char: .byte '/'

newline: .asciiz "\n"
op1_prompt: .asciiz "Enter first operand: "
op_prompt: .asciiz "Enter operation: "
op2_prompt: .asciiz "Enter second operand: "
result_prompt: .asciiz "Result = "
continue: .asciiz "Press 'q' to exit, any key to do another calculation"
invalid_input: .asciiz "Invalid input"	
remainder_prompt: .asciiz " Remainder: "
	

.globl main
	
	.text 
	
main:
#load character encodings

lb $t4, add_char
lb $t5, sub_char
lb $t6, multi_char
lb $t7, div_char

calc_loop:

#get first operand prompt
li $v0, 4
la $a0, op1_prompt
syscall

#read integer
li $v0, 5
syscall
move $a1, $v0

#read operation prompt
li $v0, 4
la $a0, op_prompt
syscall

#read character
li $v0, 12
syscall
move $a2, $v0

jal print_newline

#print second operand prompt
li $v0, 4
la $a0, op2_prompt
syscall

#read second operand 
li $v0, 5
syscall
move $a3, $v0


#condition check for operation
beq $a2, $t4, add_func
beq $a2, $t5, sub_func
beq $a2, $t6, multi_func
beq $a2, $t7, div_func
#else print error message
li $v0, 4
la $a0, invalid_input
syscall

jal print_newline

j continue_check

continue_loop:

jal print_result

jal print_newline

j continue_check



#procedure listings
exit:
	li $v0, 17
	li $a0, 7
	syscall


add_func:
	add $v1, $a1, $a3
	j continue_loop


sub_func:
	sub $v1, $a1, $a3
	j continue_loop


multi_func:
	mult $a1, $a3
	mflo $v1
	j continue_loop


div_func:
	div $a1, $a3
	mflo $v1
	j continue_loop


print_newline:
	li $v0, 4
	la $a0, newline
	syscall
	jr $ra


print_result:
	#print result prompt and actual result
	li $v0, 4
	la $a0, result_prompt
	syscall
	li $v0, 1
	la $a0, ($v1)
	syscall
	
	#load any remainder values
	mfhi $t9
	#check for non-zero remainder and print it, if zero, skip printing and jmp to else
	beq $t9, $0, else
	li $v0, 4
	la $a0, remainder_prompt
	syscall
	li $v0, 1
	la $a0, ($t9)
	syscall
	jr $ra
	
	else:
	jr $ra

continue_check:
	li $v0, 4
	la $a0, continue
	syscall

	jal print_newline
	
	li $v0, 12
	syscall
	move $t9, $v0
	li $t8, 'q'

	jal print_newline

	beq $t9, $t8, exit

	j calc_loop
