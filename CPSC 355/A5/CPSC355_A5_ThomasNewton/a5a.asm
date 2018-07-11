// CPSC 355 - Spring 2018 T02
// Assignmnet #5 Part A - Global variables, and seperate compilation
// Thomas Newton
// 30029307
// Implements a reverse Polish (postfix) calculator 


// Macros
define(MAXVAL, 100)
define(NUMBER, '0')
define(TOOBIG, '9')
define(BUFSIZE, 100)


// External variables
	.data
sp_m:	.word	0
bufp_m:	.word	0
val_am:	.skip	4*MAXVAL
buf_am:	.skip	BUFSIZE

	.text
// Print strings
stkEF:	.string	"error: stack full\n"	// Error string to print for a full stack
stkEE:	.string	"error: stack empty\n"	// Error string to print for a empty stack
ungtE:	.string	"ungetch: too many character\n" // Error string to print for ungetch()

	.balign 4
// push(int f) subroutine (a) 
define(sp_a, x9)
define(sp_r, w10)
define(val_a, x11)

	.global	push
push:	stp	x29, x30, [sp, -16]!		// 
	mov	x29, sp				//
	
	adrp	sp_a, sp_m			// Get address for sp (sp_m)
	add	sp_a, sp_a, :lo12:sp_m		// Add low 12 of address for sp (sp_m)
	ldr	sp_r, [sp_a]			// Load, w12 = sp

	cmp	sp_r, MAXVAL			// Compare sp and MAXVAL
	b.ge	aElse1				// Branch if sp >= MAXVAL
	add	sp_r, sp_r, #1			// w12 = w12 + 1 = sp + 1
	str	sp_r, [sp_a]			// Store, sp_m = w12 = sp
	adrp	val_a, val_am			// Get address for val_am
	add	val_a, val_a, :lo12:val_am	// Add low 12 of addres for val_am
	str	w0, [val_a, sp_r, uxtw 2]	// Store, val[val_am + sp*4] = w0 = f
	b	aRet				// Branch to return 
	
aElse1:	adrp	x0, stkEF			// Load error string for printing
	add	x0, x0, :lo12:stkEF		// Add low 12 of print string
	bl	printf				// Execute print subroutine
	bl	clear				// Execute clear subroutine
	mov	w0, #0				// Set w0 = 0

aRet:	ldp	x29, x30, [sp], 16		//
	ret					//


// pop() subroutine (b) 
	.global	pop
pop:	stp	x29, x30, [sp, -16]!		// 
	mov	x29, sp				// 
	
	adrp	sp_a, sp_m			// Get address for sp (sp_m)
	add	sp_a, sp_a, :lo12:sp_m		// Add low 12 of address for sp (sp_m)
	ldr	sp_r, [sp_a]			// Load, w10 = sp
	
	cmp	sp_r, #0			// Compare sp and 0
	b.le	bElse1				// Branch if sp <= 0
	adrp	val_a, val_am			// Get address for val_am
	add	val_a, val_a, :lo12:val_am	// Add low 12 of addres for val_am
	ldr	w0, [val_a, sp_r, uxtw 2]	// Store, &val[val_am + sp*4] = w0 = f
	sub	sp_r, sp_r, #1			// w10 = w10 + 1 = sp + 1
	str	sp_r, [sp_a]			// Store, &sp_m = w10 = sp
	b	bRet				// Branch to return 
	
bElse1:	adrp	x0, stkEE			// Load error string for printing
	add	x0, x0, :lo12:stkEE		// Add low 12 of print string
	bl	printf				// Execute print subroutine
	bl	clear				// Execute clear subroutine
	mov	w0, #0				// Set w0 = 0

bRet:	ldp	x29, x30, [sp], 16		//
	ret					//


// clear() subroutine (3)
	.global clear
clear:	adrp	x9, sp_m
	add	x9, x9, :lo12:sp_m
	str	wzr, [x9]
	ret


// getop(char *s, int lim) subroutine (d)
define(i_s, 16)
define(i_r, w9)
define(c_s, 20)
define(c_r, w10)
define(s_r, x11)
define(s_s, 32)
define(lim_r, w12)
define(lim_s, 24)
define(temp_1, w13)
define(temp_2, w14)
define(getop_alloc, -48)
define(getop_dealloc, - getop_alloc)
	
	.global	getop
getop:	stp	x29, x30, [sp, getop_alloc]!	//
	mov	x29, sp				// 

	str	x0, [x29, s_s]			// Store, s into s_s 
	str	w1, [x29, lim_s]		// Store, lim into lim_s
	
dW1:	bl	getch				// Get new character
	str	w0, [x29, c_s]			// Store, new character into c_s
	ldr	c_r, [x29, c_s]			// Load c_s ino c_r
	
	cmp	c_r, ' '			// Retry if c = ' ' 
	b.eq	dW1				//
	cmp	c_r, '\t'			// Retry if c = '\t'
	b.eq	dW1				//
	cmp	c_r, '\n'			// Retry if c = '\n'
	b.eq	dW1				//

	cmp	c_r, '0'			// Return if c < '0'
	b.lt	dIf1				// Branch to return code
	cmp	c_r, '9'			// Return if c > '9'
	b.gt	dIf1				// Branch to return code
	b	dAft1

dIf1:	ldr	w0, [x29, c_s]			// Set return to c
	b	dRet				// Return

dAft1:	ldr	c_r, [x29, c_s]			// Load c_r 
	ldr	s_r, [x29, s_s]			// Load s_r
	str	c_r, [s_r]			// Set s[0] = c
	mov	temp_1, #1			// temp_1 = 1
	str	temp_1, [x29, i_s]		// i = temp_1 = 1

dLoop1:	
	bl	getchar				// Get char (c)
	str	w0, [x29, c_s]			// Store new char (c)
	ldr	c_r, [x29, c_s]			// Load new char (c) 
	cmp	c_r, '0'			// Break if c < '0'
	b.lt	dAft2				// Branch to after loop
	cmp	c_r, '9'			// Break if c > '9'
	b.gt	dAft2				// Branch to after loop
	
	ldr	i_r, [x29, i_s]			// Load i_r
	ldr	lim_r, [x29, lim_s]		// Load lim_r
	cmp	i_r, lim_r			// Continue if i < lim
	b.ge	dAft3				// Branch to after if, if i >= lim
	strb	c_r, [s_r, i_r, UXTW]		// Store, s[i] = c

dAft3:	add	i_r, i_r, #1			// Increment i by 1 (i++)
	str	i_r, [x29, i_s]			// Store i_r into i_s
	b	dLoop1				// Return to top of loop
// End loop1

dAft2:	ldr	i_r, [x29, i_s]			// Load i_r
	ldr	lim_r, [x29, lim_s]		// Load lim_r
	cmp	i_r, lim_r			// Execute if i < lim
	b.ge	dElse1				// Branch to else if i >= lim
	
	ldr	w0, [x29, c_s]			// Load w0 = c
	bl	ungetch				// Call ungetch
	mov	temp_1, 0			// temp_1 = '\0'
	ldr	s_r, [x29, s_s]			// Load s_r
	ldr	i_r, [x29, i_s]			// load i_r
	str	temp_1, [s_r, i_r, UXTW]	// Store s[i] = '\0'
	mov	w0, NUMBER			// Move '9' into w0
	b	dRet				// Return

dElse1:	
dW2:	ldr	c_r, [x29, c_s]			// Load c_r
	cmp	c_r, '\n'			// Compare c_r to '\n'
	b.eq	dAft4				// Break if c_r = '\n'
	cmp	c_r, -1				// Compare c_r to EOF
	b.eq	dAft4				// Break if c_r = EOF

	bl	getchar				// Call get char
	str	w0, [x29, c_s]			// Store new c in c_s
	b	dW2				// Return to top of while
	
dAft4:	ldr	lim_r, [x29, lim_s]		// Load lim_r
	ldr	s_r, [x29, s_s]			// Load s_r
	sub	temp_1, lim_r, #1		// temp_1 = lim - 1 
	mov	temp_2, 0			// temp_2 = '\0'
	strb	temp_2, [s_r, temp_1, UXTW]	// Store s[temp_1] = s[lim-1] = '\0'
	mov	w0, TOOBIG			// w0 = '9'

dRet:	
	ldp	x29, x30, [sp], getop_dealloc	// Deallocate
	ret					// Return


// getch() subroutine (e)
define(bufp_r, w9)
define(bufp_a, x11)
define(buf_a, x12) 

	.global getch
getch:	stp	x29, x30, [sp, -16]!		//
	mov	x29, sp				//
	
	adrp	bufp_a, bufp_m			// Load address of bufp into bufp_a (x10)
	add	bufp_a, bufp_a, :lo12:bufp_m	// Add low 12 of bufp 
	ldr	bufp_r, [bufp_a]		// Load bufp into bufp_r (w9)
	
	cmp	bufp_r, 0			// Compare bufp (w9) to 0
	b.le	eElse1				// Branch to get char if bufp <= 0

	adrp	buf_a, buf_am			// Load address of buf into buf_a (x11)
	add	buf_a, buf_a, :lo12:buf_am	// Add low 12 of buf 
	ldrb	w0, [buf_a, bufp_r, SXTW]	// Load, w0 = buf[bufp]
	sub	bufp_r,	bufp_r, #1		// bufp_r = bufp_r - 1 
	str	bufp_r, [bufp_a]		// Store, bufp_a = bufp_r 
	b	eRet				// Branch to return

eElse1:	bl	getchar				// Get new char

eRet:	ldp	x29, x30, [sp], 16		//
	ret					//


// ungetch(int c) subroutine (f)
	.global	ungetch
ungetch:
	stp	x29, x30, [sp, -16]!		//
	mov	x29, sp				// 

	mov	c_r, w0				// Move c into c_4

	adrp	bufp_a, bufp_m			// Load address for bufp into bufp_a
	add	bufp_a, bufp_a, :lo12:bufp_m	// Add low 12 of address to bufp_a
	ldr	bufp_r, [bufp_a]		// Load bufp into bufp_a
	
	cmp	bufp_r, BUFSIZE			// Compare bufp_r to BUFSIZE
	b.le	fElse1				// Branch if bufp <= BUFSIZE
	adrp	x0, ungtE			// Add error string to x0
	add	x0, x0, :lo12:ungtE		// Add low 12 of string to x0
	bl	printf				// Print error
	b	fRet				// Branch to return

fElse1:	add	bufp_r, bufp_r, #1		// Add, bufp = bufp + 1
	str	bufp_r, [bufp_a]		// Store, bufp = bufp_r
	adrp	buf_a, buf_am			// Get address for buf in buf_a
	add	buf_a, buf_a, :lo12:buf_am	// Add low 12 for buf
	strb	c_r, [buf_a, bufp_r, UXTW]	// Store, buf[bufp] = c
	
fRet:	ldp	x29, x30, [sp], 16		//
	ret					//
