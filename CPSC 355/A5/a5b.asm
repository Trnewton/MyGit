// CPSC 355 - Spring 2018 T02
// Assignmnet #5 Part A - External Pointer Arrays & Command-line Arguements 
// Thomas Newton
// 30029307
// Takes a date in the form mm dd yyyy from the command line and prints the date in the form Month day(postfix), yyyy


define(argc_r, w19)
define(argv_r, x20)


	.text
print:	.string	"%s %d%s, %d\n"
error1:	.string	"usage: a5b mm dd yyyy\n"
error2:	.string	"Error: bad date\n"

jan_m:	.string	"January"
feb_m:	.string	"Febuary"
mar_m:	.string	"March"
apr_m:	.string	"April"
may_m:	.string	"May"
jun_m:	.string	"June"
jul_m:	.string	"July"
aug_m:	.string	"August"
sep_m:	.string	"September"
oct_m:	.string	"October"
nov_m:	.string	"November"
dec_m:	.string	"December"
th_m:	.string	"th"
st_m:	.string	"st"
nd_m:	.string	"nd"
rd_m:	.string "rd"

	.data
month_m:	.dword	jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m
day_m:		.dword	th_m, st_m, nd_m, rd_m

	.text
	.balign 4
	.global main
main:	stp	x29, x30, [sp, -16]!		// 
	mov	x29, sp				// 

	mov	argc_r, w0			// Move, argc_r = w0
	mov	argv_r, x1			// Move, argv_r = x1
	
	cmp	argc_r, 4			// Check to make sure 4 arguements were supplied
	b.eq	noerr1				// Skip error code if 4 arguments 
	adrp	x0, error1			// Load error message
	add	x0, x0, :lo12:error1		// Add low 12 bits of error message
	bl	printf				// Executre print statement
	b	ret				// Break to return
	
noerr1:	ldr	x0, [argv_r, 8]			// Load the first argument (mm)
	bl	atoi				// Convert to integer
	mov	w21, w0				// Move result into w21
	cmp	w21, 1				// Make sure mm is greater than or equal to 1
	b.lt	err2				// Error if not
	cmp	w21, 12				// Check mm is less than or equal to 12
	b.gt	err2				// Error if not

	ldr	x0, [argv_r, 16]		// Load second argument (dd)
	bl	atoi				// Convert to integer
	mov	w22, w0				// Move result into w22
	cmp	w22, 1				// Check dd is greater than 0
	b.lt	err2				// Error if not
	cmp	w22, 31				// Check dd is less than 32
	b.gt	err2				// Error if not

	ldr	x0, [argv_r, 24]		// Load third argument (yyyy)
	bl	atoi				// Convert to integer
	mov	w23, w0				// Move result into w23
	cmp	w23, 0				// Check yyyy is greater than or equal to 0
	b.lt	err2				// Error if not

	adrp	x0, print			// Get print string int x0
	add	x0, x0, :lo12:print		// Add low 12 of print string to x0
	adrp	x24, month_m			// Get month_m address int ox24
	add	x24, x24, :lo12:month_m		// Add low 12 of month_m address to x24
	sub	w21, w21, 1			// Subtracte one from mm to get correct indexing
	ldr	X1, [x24, w21, SXTW 3]		// Load name of month string into x1
	mov	w2, w22				// Move dd into w2

	mov	w25, #10			// Move 10 into w25 to find last digit of dd
	SDIV	w3, w22, w25			// Divide dd by 10, store result in w3
	MSUB	w3, w25, w3, w22		// Find remainder of division, store result in w3
	cmp	w3, 3				// Compare result to 3
	b.le	skip				// If w3 is less than 3 skip
	mov	w3, 0				// If w3 is greater than 3, set w3 = 0
skip:	adrp	x26, day_m			// Get day_m array address in x26
	add	x26, x26, :lo12:day_m		// Add low 12 of address to x26
	ldr	x3, [x26, w3, SXTW 3]		// Load correct post fix for dd into x3
	mov	w4, w23				// Move yyyy into w4
	bl	printf				// Execute print 
	b	ret				// Branch to return
	

err2:	adrp	x0, error2			// Load "Error: bad date\n" string into x0
	add	x0, x0, :lo12:error2		// Add low 12 of string to x0
	bl	printf				// Executre print

ret:	mov	x0, 0				// Move 0 into x0
	ldp	x29, x30, [sp], 16		// 
	ret					// 
