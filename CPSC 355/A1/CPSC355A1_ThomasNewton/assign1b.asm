// CPSC 355 - Spring 2018 TO2
// Assignment #1 - Part 2
// Thomas Newton
// 30029307
// Calculates the maximum value of y = 5x^3 - 12x^2 - 20x + 10, on the interval [-4,3]


// Macros
define(int_x, X19)				// X19 = x counter 
define(int_y, X20)				// X20 = y value
define(int_max, X21)				// X21 = max value
define(int_ng20, X22)				// X22 = -22 (constant)
define(int_ng12, X23)				// X23 = -12 (constant)
define(int_5, X24)				// X24 = 5 (constant)
define(int_10, X25)				// X25 = 10 (constant)


top:	.string " x  |  y  |  max \n"		// Table label string
bar:	.string "------------------\n"		// Seperation bar for table
str:	.string " %d | %d | %d\n"		// printf format string

	.balign 4
	.global main

main:	stp	X29, X30, [sp, -16]!
	mov	X29, sp

	adrp	X0, top				// Set higher bits of table string
	add	X0, X0, :lo12:top		// Set lower bits of table string
	bl	printf				// Print table string
	adrp	X0, bar				// Set higer bits of bar string
	add	X0, X0, :lo12:bar		// Set lower bits of bar string
	bl	printf				// Print bar string

	mov	int_x, #-4			// X19 = x position counter
	mov	int_max, #-9999 		// Maximum counter
	mov	int_ng20, #-20			
	mov	int_ng12, #-12			
	mov	int_5, #5			
	mov	int_10, #10				

	b	check

calc:	madd	int_y, int_x, int_5, int_ng12	// int_y = 5x -12
	madd	int_y, int_y, int_x, int_ng20	// int_y = 5x^2 - 12x -20
	madd	int_y, int_y, int_x, int_10	// int_Y = 5x^3 - 12x -20x +10

	subs	XZR, int_max, X10		// See if term is bigger than old max
	bge	print				// Skip over line if not a new max
	mov	int_max, int_y			// X20 = new maximum value
	
print:	adrp	X0, str				// Set higher bits of format string for printf
	add 	X0, x0, :lo12:str		// Set lower bits of format string for printf
	mov	X1, int_x			// Set 1st magic number for printf
	mov	X2, int_y			// Set 2nd magic number for printf
	mov	X3, int_max			// Set 3rd magic number for printf
	bl	printf				// Execute printf

	add	X19, int_x, #1			// Increment x value by 1
check:	subs	XZR, int_x, #3			// Check if current x value is out of upper bound 
	ble	calc				// Break out of loop if x value is out of upper bound

	ldp  x29, x30, [sp], 16
	ret
