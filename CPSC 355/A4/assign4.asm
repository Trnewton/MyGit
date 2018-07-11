// CPSC 355 - Spring 2018 T02
// Assignment #4
// Thomas Newton
// 30029307
// Creates a box structure and performs manipulations on it using subroutines, and prints out results

// Print Strings
pbox:	.string	"Box %s origin = (%d, %d) width = %d height = %d area = %d\n"
pint:	.string	"Initial box values:\n"
pchg:	.string	"\nChanged box values:\n"
first:	.string "first"
second:	.string "second"

// Macros
define(FP, x29)
define(FALSE, 0)
define(TRUE, 1)
define(x, 0)
define(y, 4)
define(width, 0)
define(height, 4)
define(b_origin, 0)
define(b_size, origin_size)
define(b_area, origin_size + dim_size)

define(fst_s, 16)
define(snd_s, -(-(box_size + fst_s) & -16))
define(box_alloc, -48)
define(box_dealloc, -box_alloc)
define(origin_size, 8)
define(dim_size, 8)
define(box_size, origin_size + dim_size + 4)
define(main_alloc, -80)
define(main_dealloc, - main_alloc)

.balign 4

// newBox subroutine
newBox:	stp	x29, x30, [sp, box_alloc]!		// Allocate enough space for box (b) object
	mov	x29, sp					//
	
	mov	w9, #1					// Store #1 into w9 to allow for storing
	str	WZR, [FP, 16 + b_origin + x]		// b.origin.x = 0
	str	WZR, [FP, 16 + b_origin + y]		// b.origin.y = 0
	str	w9, [FP, 16 + b_size + width]		// b.size.width = 1
	str	w9, [FP, 16 + b_size + height]		// b.size.height = 1
	ldr	w9, [FP, 16 + b_size + width]		// load width to calculate area
	ldr 	w10, [FP, 16 + b_size + height]		// load height to calculate area
	mul	w9, w9, w10 				// w9 = width * height = area
	str	w9, [FP, 16 + b_area]			// b.area = width * height = area
	
	ldr	w0, [FP, 16 + b_origin + x]		// w0 = b.origin.x
	ldr	w1, [FP, 16 + b_origin + y]		// w1 = b.origin.y
	ldr 	w2, [FP, 16 + b_size + width]		// w2 = b.size.width
	ldr	w3, [FP, 16 + b_size + height]		// w3 = b.size.height 
	ldr	w4, [FP, 16 + b_area]			// w4 = b.area
	
	ldp	x29, x30, [sp], box_dealloc		// Deallocate space
	ret						// Return box values

// move subroutine
move:	stp	x29, x30, [sp, -16]!			// 
	mov	x29, sp					//

	ldr	w9, [x0, b_origin + x]			// Load, w9 = b.origin.x
	ldr	w10, [x0, b_origin + y]			// Load, w10 = b.origin.y
	add	w9, w9, w1				// w9 = w9 + w1 = b.origin.x + deltax
	add	w10, w10, w2				// w10 = w10 + w2 = b.origin.y + deltay
	str	w9, [x0, b_origin + x]			// Store, b.origin.x = w9 = b.origin.x + deltax
	str	w10, [x0, b_origin + y]			// Store, b.origin.y = w10 = b.origin.y + detlay
 
	ldp	x29, x30, [sp], 16			// Deallocate
	ret						// 

// expand subroutine
expand:	stp	x29, x30, [sp, -16]!			// 
	mov	x29, sp					// 

	ldr	w9, [x0, b_size + width]		// Load, w9 = b.size.width
	mul	w9, w9, w1				// w9 = w9 * w1 = b.size.width * factor
	str	w9, [x0, b_size + width]		// Store, b.size.width = w9 = b.size.width*factor
	ldr	w10, [x0, b_size + height]		// Load, w10 = b.size.height
	mul	w10, w10, w1				// w10 = w10*w1 = b.size.heigh*factor
	str	w10, [x0, b_size + height]		// Store, b.size.height=w10=b.size.height*factor
	mul	w9, w9, w10				// w9 = w9 * w10 = area
	str	w9, [x0, b_area]			// Store, b.area = w9 = area

	ldp	x29, x30, [sp], 16			// 
	ret						// 

// printBox subroutine
prtBox:	stp	x29, x30, [sp, -16]!			// 
	mov	x29, sp					// 

	mov	x9, x1					// x9 = &b
	mov	x1, x0					// x1 = &name

	adrp	x0, pbox				// Load print string into x0
	add	x0, x0, :lo12:pbox			// Load low 12 into x0
	ldr	w2, [x9, b_origin + x]			// w2 = b.origin.x
	ldr	w3, [x9, b_origin + y]			// w3 = b.origin.y
	ldr	w4, [x9, b_size + width]		// w4 = b.size.width
	ldr	w5, [x9, b_size + height]		// w5 = b.size.height
	ldr	w6, [x9, b_area]			// w6 = b.area
	bl	printf					// Print box string

	ldp	x29, x30, [sp], 16			// 
	ret						// 

// equal subroutine
equal:	stp	x29, x30, [sp, -32]!			//
	mov	x29, sp					//
		
	mov	x9, x0					// x9 = &b1
	mov	x10, x1					// x10 = &b2
	mov	x11, FALSE				// x11 = FALSE = 0
	str	x11, [FP, 16]				// result = x11 = FALSE = 0
	
	// First if
	ldr	w12, [x9, b_origin + x]			// Load, w12 = b1.origin.x
	ldr	w13, [x10, b_origin + x]		// Load, w13 = b2.origin.x
	cmp	w12, w13				// Compare b1.origin.x and b1.origin.x
	b.ne	break					// Break if not equal
	
	// Second if
	ldr	w12, [x9, b_origin + y]			// Load, w12 = b1.origin.y
	ldr	w13, [x10, b_origin + y]		// Load, w13 = b2.origin.y
	cmp	w12, w13				// Compare b1.origin.y and b2.origin.y
	b.ne	break					// Break if not equal

	// Third if
	ldr	w12, [x9, b_size + width]		// Load, w12 = b1.size.width
	ldr	w13, [x10, b_size + width]		// Load, w13 = b2.size.width
	cmp	w12, w13				// Compare b1.size.width and b2.size.width
	b.ne	break					// Break if not equal
	
	// Fourth if
	ldr	w12, [x9, b_size + height]		// Load, w12 = b1.size.height
	ldr	w13, [x10, b_size + height]		// Load, w13 = b2.size.height
	cmp	w12, w13				// Compare b1.size.height and b2.size.height
	b.ne	break					// Break if not equal
	
	mov	x11, TRUE				// x11 = TRUE(1)
	str	x11, [FP, 16]				// result = x11 = TRUE(1)

break:	ldr	x0, [FP, 16]				// Load result into x0 for return
	ldp	x29, x30, [sp], 32			// Deallocate space & restore SP & FP
	ret						// Return result
	
.global main
// main function
main:	stp	x29, x30, [sp, main_alloc]!
	mov	x29, sp
	
	bl	newBox
	str	w0, [FP, 16 + b_origin + x]
	str	w1, [FP, 16 + b_origin + y]
	str 	w2, [FP, 16 + b_size + width]
	str	w3, [FP, 16 + b_size + height]
	str	w4, [FP, 16 + b_area]

	bl	newBox
	str	w0, [FP, snd_s + b_origin + x]
	str	w1, [FP, snd_s + b_origin + y]
	str 	w2, [FP, snd_s + b_size + width]
	str	w3, [FP, snd_s + b_size + height]
	str	w4, [FP, snd_s + b_area]

	adrp	x0, pint
	add	x0, x0, :lo12:pint
	bl	printf
	
	adrp	x0, first
	add	x0, x0, :lo12:first
	add	x1, FP, fst_s
	bl	prtBox

	adrp	x0, second
	add	x0, x0, :lo12:second
	add	x1, FP, snd_s
	bl	prtBox

	add	x0, FP, #16
	add	x1, FP, snd_s
	bl	equal
	cbz	x0, noteq
	
	add	x0, FP, #16
	mov	w1, #-5
	mov	w2, #7
	bl	move
	
	add	x0, FP, snd_s
	mov	w1, #3
	bl	expand

noteq:	adrp	x0, pchg
	add	x0, x0, :lo12:pchg
	bl	printf

	adrp	x0, first
	add	x0, x0, :lo12:first
	add	x1, FP, #16
	bl	prtBox

	adrp	x0, second
	add	x0, x0, :lo12:second
	add	x1, FP, snd_s
	bl	prtBox

	mov	x0, XZR
	ldp	x29, x30, [sp], main_dealloc
	ret
