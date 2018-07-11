// CPSC 355 - Spring 2018 T02
// Assignment #3 
// Thomas Newton
// 30029307
// Creates a randomized integer array of length SIZE and then sorts it using selection sort 

// Print strings 
print1:	.string	"v[%d]: %d\n"
print2: .string "\nSorted array:\n"

//Macros
define(i_s, 16)
define(i_r, w19)
define(j_s, 20)
define(j_r, w20)
define(min_s, 24)
define(min_r, w21)
define(temp_s, 28)
define(temp_r, w22)
define(v_sr, x25)
define(v_s, 32)
define(SIZE, 50)
define(SCALE, 2)
define(FP, x29)
define(SP, x30)
define(temp1_r, w23)
define(temp2_r, w24)

	.balign 4	
	.global main
main:	stp	x29, x30, [sp, -240]!
	mov	x29, sp	
	
	mov	v_sr, v_s				// Load the v_rs register with the offset of the v array
	add	v_sr, v_sr, FP				// Add the FP to the offset of the v array so memory location is readily avaliable
	str	WZR, [FP, i_s]				// i_s = 0
	ldr	i_r, [FP, i_s]				// i_r = i_s = 0 
	b	check1					// Check and enter first loop

// First loop, where array v[SIZE] is initialized
loop1:	ldr	i_r, [FP, i_s]				// Load the value of i from memory to i_r
	bl	rand					// Generate random number
	and	w9, w0, 0xFF				// And w9 = rand & 0xFF
	str	w9, [v_sr, i_r, UXTW SCALE]		// Store random number in appropriate array location

// Print array element
	adrp	x0, print1				
	add	x0, x0, :lo12:print1
	mov	w1, i_r
	ldr	w2, [v_sr, i_r, UXTW SCALE]
	bl	printf
// Increment and store i
	add	i_r, i_r, 1				// Add one to i, i_r = i_r + 1
	str	i_r, [FP, i_s]				// Store value of i_r in stack(i_s)
// Check for first loop
check1:	cmp	i_r, SIZE				// Compare i_r to SIZE
	blt	loop1					// Reenter loop if i<SIZE


	str	WZR, [FP, i_s]				// Set i_r = 0
	ldr	i_r, [FP, i_s]				// Store i_r in storage
	b	check2					// Check and enter second loop
// Outer loop of sorting array
loop2:	ldr	i_r, [FP, i_s]				// Load value of i from i_s to i_r
	str	i_r, [FP, min_s]			// Store the value i_r to min (min_s)

	add	j_r, i_r, 1				// w9 = i_r + 1, for setting the value of j_r = i_r+1
	str	j_r, [FP, j_s]				// Store j_r to j_s 
	b	check3					// Check and enter inner loop of sorting (loop3)
// Inner sorting loop
loop3:	ldr	j_r, [FP, j_s]				// Load value of j into j_r from j_s
	ldr	min_r, [FP, min_s]			// load value of min into min_r from min_s
	ldr	temp1_r, [v_sr, j_r, UXTW SCALE]	// Load v[j_r] into temp1_r
	ldr	temp2_r, [v_sr, min_r, UXTW SCALE]	// Load v[min_r] into temp2_r
// Compare to determine minimal value of v{j_r] and v[min_r]
	cmp	temp1_r, temp2_r			// Compare v[j_r] and v[min_r]
	bge	skip					// If v[min_r] is lowest dont change
	str	j_r, [FP, min_s]			// Store value of j_r into min_s 

skip:	add	j_r, j_r, 1				// Increment j_r
	str	j_r, [FP, j_s]				// Store new value of j_r into j_s

check3:	cmp	j_r, SIZE				// Check to see if j_r<SIZE
	blt	loop3					// Renter loop if j_r<SIZE

	ldr	min_r, [FP, min_s]			// Load, min_r = min_2
	ldr	temp_r, [v_sr, min_r, UXTW SCALE]	// Load, temp_r = v[min_r]
	str	temp_r, [FP, temp_s]			// Store, temp_s = temp_r = v[min_r]
	ldr	temp2_r, [v_sr, i_r, UXTW SCALE]	// Load, temp2_r = v[i_r]
	str	temp2_r, [v_sr, min_r, UXTW SCALE]	// Store, v[min] = temp2_r = v[i_r]
	str	temp_r, [v_sr, i_r, UXTW SCALE]		// Store, v[i_r] = temp_r = v[min_r]

	add	i_r, i_r, 1				// Increment i_r by 1
	str	i_r, [FP, i_s]				// Store new value of i_r

check2:	cmp	i_r, SIZE-1				// Check to see if i_r < SIZE-1
	blt	loop2					// Reneter loop if i_r < SIZE-1

// Print "\nSorted array:\n"
	adrp	x0, print2				 
	add	x0, x0, :lo12:print2
	bl	printf

// Print each element of the sorted array
	str	WZR, [FP, i_s]				// Set i_r = 0
	ldr	i_r, [FP, i_s]				// Store, i_s = i_r = 0 
	b	check4					// Check and enter print (loop4) loop

loop4:	ldr	temp1_r, [v_sr, i_r, UXTW SCALE]	// Load, temp1_r = v[i_r]
	adrp	x0, print1				// Add higher bits of print string
	add	x0, x0, :lo12:print1			// Add lower bits of print string
	mov	w1, i_r					// Add value of i_r for print
	mov	w2, temp1_r				// Add value of v{i_r] for print
	bl	printf					// Execute print

	add	i_r, i_r, 1				// Increment i_r 
	str	i_r, [FP, i_s]				// Store, i_s = i_r

check4:	cmp	i_r, SIZE				// Check to see if i_r < SIZE
	blt	loop4					// Renter loop if i_r < SIZE

	mov	x0, 0
exit:	ldp	x29, x30, [sp], 240
	ret

