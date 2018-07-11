// CPSC 355 - Spring 2018 T02
// Assignment #2 - Part 1
// Thomas Newton
// 30029307
// Multiplies two ints together, a multiplicand and a multiplier


// Set strings for printing
init:	.string	"multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
promul:	.string	"product = 0x%08x multiplier = 0x%08x\n"
fin:	.string	"64-bit result = 0x%016lx (%ld)\n"	

// Macros
define(FALSE,0)
define(TRUE,1)
define(multd, W20)
define(multr, W21)
define(prod, W22)
define(neg, w23)
define(i, W24)
define(result, x25)
define(temp1, x9)
define(temp2, x10)

	.balign 4	
	.global main				
main:	STP	x29, x30, [sp, -16]!							
	MOV	x29, sp						

// Set initial variables
	MOV	multd, -252645136		// 
	MOV	multr, -256			// 
	MOV	prod, 0				// 
	MOV	i, 0				// 

// Print initial values
	ADRP	x0, init			// 
	ADD	x0, x0, :lo12:init		// 
	MOV	w1, multr			// 
	MOV	w2, multr			// 
	MOV	w3, multd			// 
	MOV	w4, multd			// 
	BL	printf				// 
	
// Set value of neg
	CMN	multr, 0			// Compare multr to zero
	BMI	isneg				// Branch if multr is negative
	MOV	neg, FALSE			// Set neg to false(0)
	B	loop				// Skip over setting neg to true(1)
isneg:	MOV	neg, TRUE			// Set neg to true(1)

// Add/shift loop
loop:	TST	multr, 0x1			// Test if least significant bit(lsb) is 0 or 1
	BEQ	noadd				// Skip the addition step if lsb is 0
	ADD	prod, prod, multd		// Perform addition if lsb is 1

	// Arithmetic shift right combined product and multiplier
noadd:	ASR	multr, multr, 1			// Arithmatic shift right multr by 1
	TST	prod, 0x1			// Test if lsb is 0 or 1
	BEQ	else				// Skip to else branch if lsb is 0
	ORR	multr, multr, 0x80000000	// 
	B	after				// Skip to after branch

else:	AND	multr, multr, 0x7FFFFFFF	// Bitmask multr with 0x7FFFFFFF
after:	ASR	prod, prod, 1			// Arithmetric shift right prod by 1
	ADD	i, i, 1				// Increment i by 1
	CMP	i, 32				// Check to see if i is greater than 32
	BLT	loop				// Restart loop if i is less than 32
	
// Adjust if multiplier is negative
	CBZ	neg, skip			// Skip SUBtraction if neg is equal to zero
	SUB	prod, prod, multd		// Correct prod if multr is negative
	
// Print product and multiploer
skip:	ADRP	x0, promul			// 
	ADD	x0, x0, :lo12:promul		// 
	MOV	w1, prod			// 
	MOV	w2, multr			// 
	BL	printf				// 
	
// Combine product and multiplier
	SXTW	temp1, prod			// Sign extend the producint into temp1
	AND	temp1, temp1, 0xFFFFFFFF	// Bitmask temp1 wuth oxFFFFFFFF
	LSL	temp1, temp1, 32		// Logical shift left temp1 by 32
	SXTW	temp2, multr			// Sign extend the multiplier into temp2
	AND	temp2, temp2, 0xFFFFFFFF	// Bitmask temp2 with 0xFFFFFFFF
	ADD	result, temp1, temp2		// Add temp1 and temp2 and store in result

// Print result
	ADRP	x0, fin				// 
	ADD	x0, x0, :lo12:fin		// 
	MOV	x1, result			// 
	MOV	x2, result			// 
	BL	printf				// 

	MOV	x0, 0
	LDP	x29, x30, [sp], 16					
	RET	
