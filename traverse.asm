# File:		traverse_tree.asm
# Author:	K. Reek
# Contributors:	P. White,
#		W. Carithers,
#		Colin Murphy
#
# Description:	Binary tree traversal functions.
#
# Revisions:	$Log$


# CONSTANTS
#

# traversal codes
PRE_ORDER  = 0
IN_ORDER   = 1
POST_ORDER = 2

	.text			# this is program code
	.align 2		# instructions must be on word boundaries

#***** BEGIN STUDENT CODE BLOCK 3 *****************************
#
# Put your traverse_tree subroutine here.
# 

# 
# Name:		traverse_tree
#
# Description:	Traverse through the tree and print it in the 
#		order determined by a2
#
# Arguments:	a0 The address of the tree node
#   		a1 The address of the node processing function
#		a2 A constant to specify which traversal type
# Returns:	none
#

	.globl traverse_tree

traverse_tree: 
	addi 	$sp, $sp, -8		# Grow the stack
	sw 	$ra, 4($sp)		# Store the return address
	sw	$a0, 0($sp)		# Store the node address


	li $t0, PRE_ORDER		
	bne $a2, $t0, not_pre 		# Preorder

preorder_current:
	jalr $a1			# Print this node
	lw $a0, 0($sp)			# Restore a0 from the stack
	

preorder_left:
	lw $t0, 4($a0)			# Address of the left node
	beq $t0, $zero, preorder_right	# Check if left exists
	move $a0, $t0			# Set argument
	jal traverse_tree		# Recurse left
	lw $a0, 0($sp)			# Restore a0 from the stack
	
	
preorder_right: 
	lw $t0, 8($a0)			# Address of the right node
	beq $t0, $zero, traverse_done	# Check if right exists
	move $a0, $t0			# Set argument
	jal traverse_tree		# Recurse right
	lw $a0, 0($sp)			# Restore a0 from the stack

	j traverse_done

	

not_pre:
	li $t0, IN_ORDER
	bne $a2, $t0, post_order	# In order, otherwise post order

inorder_left:
	lw $t0, 4($a0)			# Address of the left node
	beq $t0, $zero, inorder_current	# Check if left exists
	move $a0, $t0			# Set argument
	jal traverse_tree		# Recurse left
	lw $a0, 0($sp)			# Restore a0 from the stack

inorder_current:
	jalr $a1			# Print this node
	lw $a0, 0($sp)			# Restore a0 from the stack

inorder_right:
	lw $t0, 8($a0)			# Address of the right node
	beq $t0, $zero, traverse_done	# Check if right exists
	move $a0, $t0			# Set argument
	jal traverse_tree		# Recurse right
	lw $a0, 0($sp)			# Restore a0 from the stack

	j traverse_done


post_order:				# Post order

post_left:
	lw $t0, 4($a0)			# Address of the left node
	beq $t0, $zero, post_right	# Check if left exists
	move $a0, $t0			# Set argument
	jal traverse_tree		# Recurse left
	lw $a0, 0($sp)			# Restore a0 from the stack

post_right:
	lw $t0, 8($a0)			# Address of the right node
	beq $t0, $zero, post_current	# Check if right exists
	move $a0, $t0			# Set argument
	jal traverse_tree		# Recurse right
	lw $a0, 0($sp)			# Restore a0

post_current:
	jalr $a1			# Print this node
	lw $a0, 0($sp)			# Restore a0 from the stack

	j traverse_done


traverse_done: 
	lw $a0, 0($sp)			# Restore everything
	lw $ra, 4($sp)
	addi $sp, $sp, 8		# Shrink the stack
	jr $ra
	
	
#***** END STUDENT CODE BLOCK 3 *****************************
