// CPSC 355 - Spring 2018 TO2
// Assignmetn #6 - File I/O & Floating-Point Numbers
// Thomas Newton
// 30029307
/* Computes the value of sin and cos for x from an input file, within the range of 0
 to 90 degrees. Each function is computed using a Maclaurin series, and is 
 accurate to 1.0e-10.*/


// Macros & Equates
	define(fa_r, w19)
	define(nread_r, x20)
	define(buf_base_r, x21)
	define(x_r, d8)
	define(confact_r, d9)
	define(xexp_r, d19)
	define(fact_r, d20)
	define(count_r, d21)
	define(cost_r, d22)
	define(coss_r, d23)
	define(sint_r, d24)
	define(sins_r, d25)
	define(posngv_r, d26)
	define(temp_r, d17)
	define(prec_r, d17)
	define(prec_a, x22)

	buf_size = 8
	alloc = -(16 + buf_size) & -16
	dealloc = -alloc	
	buf_s = 16
	AT_FDCWD = -100

// Format Strings
err1:	.string	"ERROR: Could not open file: %s \nExiting...\n"
err2:	.string	"ERROR: Invalid arguments, usage: ./a6 <Input-File.bin>"
errag:	.string	"ERROR: X out of range, x must be in range [0,90]"
fmt:	.string	"%13.2f\t%13.10f\t%13.10f\t%13.10f\n"
head:	.string	"x(degree)\tx(rad)\t\tsin(x)\t\tcos(x)\n"

ninty:	.double	0r90
de2rd:	.double	0r0.017453292519943295769
precision:	.double 0r1.0e-10


	.balign 4
	.global	main
main:	stp	x29, x30, [sp, alloc]!			// 
	mov	x29, sp					// 

	mov	w19, w0					// Get # of args
	mov	x20, x1					// Get addr of args

	cmp	w19, 2					// Check # of args
	b.ne	argerr					// Error if wrong
	
	ldr	x22, [x20, 8]				// Load arg

	mov	w0, AT_FDCWD				// 1st cwd arg
	mov	x1, x22					// 2nd pathname arg
	mov	w2, 0					// 3rd read-only arg
	mov	w3, 0					// 4th arg unused
	mov	x8, 56					// openat I/O request
	svc	0					// call system func

	mov	fa_r, w0				// save fd

	cmp	fa_r, 0					// Check for error
	b.ge	openok					//

	adrp	x0, err1				// Print error message
	add	x0, x0, :lo12:err1			//
	mov	x1, x22					//
	bl	printf					//
	mov	w0, -1					// Load -1 for return
	b	exit					// Branch to exit


openok:	add	buf_base_r, x29, buf_s			// Get base of buffer
	adrp	x0, head				// Print heading
	add	x0, x0, :lo12:head			// 
	bl	printf					// Call printf


top:	mov	w0, fa_r				// 1st arg fd
	mov	x1, buf_base_r				// 2nd arg buf
	mov	w2, buf_size				// 3rd arg buffer size
	mov	x8, 63					// read I/O request
	svc	0					// Call system func
	mov	nread_r, x0				// Save read number

	cmp	nread_r, buf_size			// Compare # bytes read to buf size
	b.ne	end					// Branch to exit if not equa
	
// Check x
	ldr	x_r, [buf_base_r]			// Load read byte
	fmov	d18, x_r				// Save value of x in degree
	fcmp	x_r, 0.0				// Check x is in range [0,90]
	b.lt	outrg					//
	adrp	x23, ninty				// Load 90.0
	add	x23, x23, :lo12:ninty			//
	ldr	d0, [x23]				//
	fmov	temp_r, d0				//
	fcmp	x_r, temp_r				// Compare x to 90.0
	b.gt	outrg					// Branch to error if out of rnage
// Operate on X
	// Convert to rad
	adrp	x22, de2rd				// Load conversion factor to
	add	x22, x22, :lo12:de2rd			// convert to rad from degree
	ldr	confact_r, [x22]			// Load conversion factor
	fmul	x_r, x_r,confact_r			// Mul by conversion factor
	// Calculate a term for each series
	fmov	xexp_r, x_r				// Save, x^i_r = x_r
	fmov	fact_r, 1.0				// Factorial = 1.0
	fmov	count_r, 2.0				// Counter = 2.0
	fmov	posngv_r, 1.0				// Posngv_r = 1.0

	fmov	coss_r, 1.0				// cos term = 1.0
	fmov	sins_r, x_r				// sin term = x_r

loop:	fneg	posngv_r, posngv_r			// posngv_r = - posngv_r
	fmul	fact_r, fact_r, count_r			// factoral = factoral*count
	fmov	temp_r, 1.0				// temp_r = 1.0
	fadd	count_r, count_r, temp_r		// count = count + 1
	fmul	xexp_r, xexp_r, x_r			// exponent = exponent * x

	fdiv	cost_r, xexp_r, fact_r			// cos term = x^i/i!
	fmul	cost_r, cost_r, posngv_r		// set sign to correct val
	fadd	coss_r, coss_r, cost_r			// Add term to sum

	fmul	fact_r, fact_r, count_r			// calc next factoral 
	fadd	count_r, count_r, temp_r		// increment count
	fmul	xexp_r, xexp_r, x_r			// calc next exponnet

	fdiv	sint_r, xexp_r, fact_r			// sin term = x^i/i!
	fmul	sint_r, sint_r, posngv_r		// set sign to correct val
	fadd	sins_r, sins_r, sint_r			// add term to sum
	
	adrp	prec_a, precision			// Load precision
	add	prec_a, prec_a, :lo12:precision		// 
	ldr	prec_r, [prec_a]			//
	
	fabs	cost_r, cost_r				// Absolute value cos term
	fcmp	cost_r, prec_r				// Compare term to precision
	b.gt	loop					// Reenter loop if not in margin
	fabs	sint_r, sint_r				// Absolute value sin term
	fcmp	sint_r, prec_r				// Compare to precision
	b.gt	loop					// Reenter loop if not in margin

print:	adrp	x0, fmt					// Load print format
	add 	x0, x0, :lo12:fmt			// 
	fmov	d0, d18					// 1st arg, x in degrees
	fmov	d1, x_r					// 2nd arg, x in rad
	fmov	d2, sins_r				// 3rd arg, sin(x)
	fmov	d3, coss_r				// 4th arg, cos(x)
	bl	printf					// 

	b	top					// Return to top to read next byte

outrg:	adrp	x0, errag				// Error for x out of range
	add	x0, x0, :lo12:errag			//
	bl	printf					// 
	b	end					// Branch to close file & ret

argerr:	adrp	x0, err2				// Error for bad cmd arguments
	add	x0, x0, :lo12:err2			//
	bl	printf					//
	mov	w0, -1					//
	b	exit					// Branch to return

end:	mov	w0, fa_r				// Close file
	mov	x8, 57					//
	svc	0					// System call

	mov	w0, 0					// Succesful 
exit:	ldp	x29, x30, [sp], dealloc			//
	ret						//
