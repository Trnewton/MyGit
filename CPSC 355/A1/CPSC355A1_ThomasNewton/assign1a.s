// CPSC 355 - Spring 2018 TO2
// Assignment #1 - Part 1 
// Thomas Newton
// 30029307
// Calculates the maximum value of y = 5x^3 - 12x%2 - 20x + 10 on the interval [-4,3]

top:	.string " x  |  y  |  max \n"	// Table label string
bar:	.string "------------------\n"	// Seperation bar for table
str:	.string " %d | %d | %d\n"	// printf format string

	.balign 4
	.global main

main:	stp	x29, x30, [sp, -16]!
	mov	X29, sp	

	adrp	X0, top			// Set higher bits of table string
	add	X0, X0, :lo12:top	// Set lower bits of table string
	bl	printf			// Print table string
	adrp	X0, bar			// Set higher bits of bar string
	add	X0, X0, :lo12:bar	// Set lower bits of bar string
	bl	printf			// Print bar string

	mov	X19, #-4		// X19 is the x position counter
	mov	X20, #-9999 		// Maximum counter
	mov	X22, #5		
	
check:	subs	XZR, X19, #3		// Check to see if current x value is out of upper bound 
	bgt	break			// Break out of loop if x value is out of upper bound

calc:	mul	X9, X19, X22		// X9 = 5x
	sub	X9, X9, #12		// X9 = 5x - 12
	mul	X9, X9, X19		// X9 = 5x^2 - 12x
	sub	X9, X9, #20		// X9 = 5x^2 - 12x - 20
	mul	X9, X9, X19		// X9 = 5x^3 - 12x^2 - 20x
	add	X21, X9, #10		// X21 = y = 5x^3 - 12^2 - 20x + 10

	subs	XZR, X20, X21		// See if term is bigger than old max
	bge	print			// Skip over line if not a new max
	mov	X20, X21		// X20 has the new maximum value
	
print:	adrp	X0, str			// Set higher bits of format string for printf
	add 	X0, x0, :lo12:str	// Set lower bits of format string for printf
	mov	X1, X19			// Set 1st magic number for printf
	mov	X2, X21			// Set 2nd magic number for printf
	mov	X3, X20			// Set 3rd magic number for printf
	bl	printf			// Execute printf

	add	X19, X19, #1		// Increment x value by 1
	B	check			// Return to top of loop 

break:	ldp  x29, x30, [sp], 16
	ret
