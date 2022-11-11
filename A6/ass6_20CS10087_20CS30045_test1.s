	.file	"ass6_20CS10087_20CS30045_test1.c"

#	Allocation of function variables and temporaries on the stack:

#	main
#	n: -4
#	t2: -12
#	t3: -16
#	testVoid
#	t0: -8
#	t1: -12

	.comm	printInt,4,4
	.comm	printStr,4,4
	.comm	readInt,4,4
	.comm	testChar,1,1
	.comm	testCharPtr,8,8
	.comm	testInt,4,4
	.comm	testIntPtr,8,8
	.text
	.globl  testInt
	.type   testInt, @function
testInt:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $4, %rsp
	movl    %edi, -4(%rbp)
	movl    -4(%rbp), %eax
.LFE0:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   testInt, .-testInt
	.text
	.globl  testIntPtr
	.type   testIntPtr, @function
testIntPtr:
.LFB1:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $8, %rsp
	movq    %rdi, -8(%rbp)
	movq    -8(%rbp), %rax
.LFE1:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   testIntPtr, .-testIntPtr
	.text
	.globl  testChar
	.type   testChar, @function
testChar:
.LFB2:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $1, %rsp
	movb    %dil, -1(%rbp)
	movb    -1(%rbp), %al
.LFE2:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   testChar, .-testChar
	.text
	.globl  testCharPtr
	.type   testCharPtr, @function
testCharPtr:
.LFB3:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $8, %rsp
	movq    %rdi, -8(%rbp)
	movq    -8(%rbp), %rax
.LFE3:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   testCharPtr, .-testCharPtr
	.text
	.globl  testVoid
	.type   testVoid, @function
testVoid:
.LFB4:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $12, %rsp
	movq    -8(%rbp), %rdi
	call    printStr
	movl    %eax, -12(%rbp)
.LFE4:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   testVoid, .-testVoid
	.text
	.globl  main
	.type   main, @function
main:
.LFB5:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $16, %rsp
	movq    -12(%rbp), %rdi
	call    printStr
	movl    %eax, -16(%rbp)
