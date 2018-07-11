/*This program demonstrates basic usage of floats including function calls and arithmetic
*/


	.data
x_m:	.double 0r1.5
y_m:	.double 0r2e-8

	.text

	//format strings
fmt:	.string "floats = %.8f, %.8f\n"				//.8 is how many decimals to print

	.balign 4
	.global main

main:	stp x29, x30, [sp, -16]!
	mov x29, sp

	//load floats from external mem into registers
	adrp x0, x_m
	add x0, x0, :lo12:x_m
	ldr d0, [x0]						//init d0 to x

	adrp x0, y_m
	add x0, x0, :lo12:y_m
	ldr d1, [x0]						//init d1 to y

	fmov d8, d1						//save the val of y in callee saved register

	bl cube							//d0 = x^3

	fmov d9, d0						//put x in d9

	fmov d2, 0.5						//using immediates in a mov
	fadd d8, d2, d8						//add 0.5 to y

	fcmp d9, 0.0						//fcmp using an immediate
	b.eq exit						//normal branch

	//call printf on x and y
	adrp x0, fmt
	add x0, x0, :lo12:fmt
	fmov d0, d9
	fmov d1, d8
								//args go in d0 - d7
	bl printf
	

exit:	ldp x29, x30, [sp], 16
	ret

//takes in 1 float in d0 and returns the cube of it
cube:	stp x29, x30, [sp, -16]!
	mov x29, sp
	
	fmul d1, d0, d0
	fmul d1, d1, d0
	fmov d0, d1

	ldp x29, x30, [sp], 16
	ret

