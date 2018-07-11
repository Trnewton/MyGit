/*This program reads 100 long ints from the binary file called output.bin and prints them out
Uses open, read and close system calls*/

	define(fd_r, w19)
	define(nread_r, x20)
	define(buf_base_r, x21)

	buf_size = 8
	alloc = -(16 + buf_size) & -16
	dealloc = -alloc
	buf_s = 16
	AT_FDCWD = -100

	//format strings
pn:	.string "output.bin"
fmt1:	.string "Error opening file: %s\nAborting...\n"
fmt2:	.string "long int = %ld\n"

	.balign 4
	.global main

main:	stp x29, x30, [sp, alloc]!
	mov x29, sp

	//open existing file
	mov w0, AT_FDCWD					//1st arg (cwd)
	adrp x1, pn						//2nd ard (pathname)
	add x1, x1, :lo12:pn
	mov w2, 0						//3rd arg (read only)
	mov w3, 0						//4th arg (unused)
	mov x8, 56						//openat I/O request
	svc 0							//call system function

	mov fd_r, w0						//save fd

	//error checking for openat
	cmp fd_r, 0
	b.ge openok

	adrp x0, fmt1
	add x0, x0, :lo12:fmt1
	adrp x1, pn
	add x1, x1, :lo12:pn
	bl printf

	mov w0, -1
	b exit

openok:	add buf_base_r, x29, buf_s				//base addr of buffer
	
	//read 100 long ints from binary file one buffer at a time (8 bytes)

top:	mov w0, fd_r						//1st arg (fd)
	mov x1, buf_base_r					//2nd arg (buf)
	mov w2, buf_size					//3rd arg (n)
	mov x8, 63						//read I/O request
	svc 0
	mov nread_r, x0

	//error checking
	cmp nread_r, buf_size					//if nread != 8 then
	b.ne end						//read failed so exit loop (end of file)

	//print out the long int
	adrp x0, fmt2
	add x0, x0, :lo12:fmt2
	ldr x1, [buf_base_r]					//2nd arg
	bl printf

	b top

end:	//close file
	mov w0, fd_r
	mov x8, 57
	svc 0

	mov w0, 0						//return 0
exit:	ldp x29, x30, [sp], alloc
	ret

	
