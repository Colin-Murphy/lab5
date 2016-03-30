# File:		build.asm
# Author:	K. Reek
# Contributors:	P. White,
#		W. Carithers,
#		Colin Murphy
#
# Description:	Binary tree building functions.
#
# Revisions:	$Log$


	.text			# this is program code
	.align 2		# instructions must be on word boundaries

# 
# Name:		add_elements
#
# Description:	loops through array of numbers, adding each (in order)
#		to the tree
#
# Arguments:	a0 the address of the array
#   		a1 the number of elements in the array
#		a2 the address of the root pointer
# Returns:	none
#

	.globl	add_elements
	
add_elements:
	addi 	$sp, $sp, -16
	sw 	$ra, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

#***** BEGIN STUDENT CODE BLOCK 1 ***************************
#
# Insert your code to iterate through the array, calling build_tree
# for each value in the array.  Remember that build_tree requires
# two parameters:  the address of the variable which contains the
# root pointer for the tree, and the number to be inserted.
#

	move 	$s0, $zero		# loop counter
add_loop:
	beq	$s0, $a1, add_done	# loop over all items
	li 	$t0, 4			# word size
	mul 	$t0, $t0, $s0		# array offset
	add 	$t0, $t0, $a0		# address in array
	lw 	$a3, 0($t0)		# store the number in a3
	jal 	build_tree		# Add the number
	addi 	$s0, 1			# Incriment counter
	j 	add_loop 		# Run again

	
#***** END STUDENT CODE BLOCK 1 *****************************

add_done:

	lw 	$ra, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 16
	jr 	$ra

#***** BEGIN STUDENT CODE BLOCK 2 ***************************
#
# Put your build_tree subroutine here.
#
# 
# Name:		build_tree
#
# Description:	adds a number to a tree
#
# Arguments:	
#		a2 the address of the root pointer
#		a3 the number to add
# Returns:	none
#
	.globl allocate_mem
build_tree:

	addi 	$sp, $sp, -20
	sw 	$ra, 16($sp)		# Store arguments to the stack
	sw	$a0, 12($sp)
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$s0, 0($sp)

	lw	$s0, 0($a2)		# Address of the root node

	bne	$s0, $zero, tree_exists	# Handle null tree
	li	$a0, 3			# Need 3 words
	jal	allocate_mem		# Allocate memory for node
	sw	$a3, 0($v0)		# Store the number
	sw	$zero, 4($v0)		# No child elements
	sw	$zero, 8($v0)
	sw	$v0, 0($a2)		# Store the address of the new
					# root node


	j build_tree_done	# All done


tree_exists:	
	lw	$a2, 0($a2)	# Store the pointer to the root

	j	build_tree_recurse


# Name:		build_tree_recurse
#
# Description:	adds a number to the non root node of a tree
#
# Arguments:	
#		a2 the address of a tree
#		a3 the number to add
# Returns:	none
build_tree_recurse:
	
	lw	$t0, 0($a2)			# number at this node
	beq	$t0, $a3, build_tree_done 	# no duplicates
	sub	$t0, $t0, $a3		# If < 0 new number is greater

	bltz	$t0, build_tree_check_right	# Add to the left or right

build_tree_check_left:			# Left recursion
	lw	$t0, 4($a2)		# Get left pointer

	beq	$t0, $zero, build_tree_add_left		
					# Check if left node exists
	move	$a2, $t0		# Set argument to go left
	j	build_tree_recurse

build_tree_add_left:
	li	$a0, 3			# Need 3 words
	jal	allocate_mem		# Allocate memory for node
	sw	$a3, 0($v0)		# Store the number
	sw	$zero, 4($v0)		# No child elements
	sw	$zero, 8($v0)

	sw	$v0, 4($a2)		# Store the new left pointer
	j 	build_tree_done
	
	


build_tree_check_right:			# Right recursion
	lw	$t0, 8($a2)		# Get left pointer

	beq	$t0, $zero, build_tree_add_right		
					# Check if right node exists
	move	$a2, $t0		# Set argument to go right
	j	build_tree_recurse

build_tree_add_right:
	li	$a0, 3			# Need 3 words
	jal	allocate_mem		# Allocate memory for node
	sw	$a3, 0($v0)		# Store the number
	sw	$zero, 4($v0)		# No child elements
	sw	$zero, 8($v0)

	sw	$v0, 8($a2)		# Store the new left pointer
	j 	build_tree_done
	

build_tree_done:


	lw 	$ra, 16($sp)	# Restore and shrink the stack
	lw	$a0, 12($sp)
	lw	$a1, 8($sp)
	lw	$a2, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 20
	

	jr $ra





#***** END STUDENT CODE BLOCK 2 *****************************
