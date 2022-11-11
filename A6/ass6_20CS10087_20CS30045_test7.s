	.file	"ass6_20CS10087_20CS30045_test7.c"

#	function variables and temp are allocated on the stack:

#	main
#	n1: -4
#	n2: -8
#	t0: -16
#	t1: -20
#	t10: -24
#	t11: -32
#	t12: -36
#	t13: -44
#	t14: -48
#	t15: -56
#	t16: -60
#	t17: -64
#	t18: -68
#	t19: -72
#	t2: -76
#	t20: -80
#	t21: -88
#	t22: -92
#	t23: -100
#	t24: -104
#	t25: -112
#	t26: -116
#	t27: -120
#	t28: -128
#	t29: -132
#	t3: -136
#	t30: -144
#	t31: -148
#	t32: -156
#	t33: -160
#	t34: -168
#	t35: -172
#	t36: -180
#	t37: -184
#	t38: -192
#	t39: -196
#	t4: -204
#	t40: -208
#	t41: -216
#	t42: -220
#	t43: -228
#	t44: -232
#	t45: -240
#	t46: -244
#	t47: -248
#	t48: -256
#	t49: -260
#	t5: -264
#	t50: -272
#	t51: -276
#	t52: -284
#	t53: -288
#	t54: -292
#	t55: -300
#	t56: -304
#	t57: -312
#	t58: -316
#	t59: -324
#	t6: -332
#	t60: -336
#	t61: -344
#	t62: -348
#	t63: -356
#	t64: -360
#	t65: -368
#	t66: -372
#	t67: -376
#	t68: -380
#	t69: -388
#	t7: -392
#	t70: -396
#	t71: -404
#	t72: -408
#	t73: -416
#	t74: -420
#	t75: -428
#	t76: -432
#	t77: -436
#	t8: -444
#	t9: -448
#	printInt
#	n: -4
#	printStr
#	s: -8
#	readInt
#	eP: -8

	.section	.rodata
.LC0:
	.string	"\n*********** TEST 7 ************\n"
.LC1:
	.string	"\nTesting (==) operator: "
.LC2:
	.string	"PASS"
.LC3:
	.string	"FAIL"
.LC4:
	.string	"\nTesting (!=) operator: "
.LC5:
	.string	"PASS"
.LC6:
	.string	"FAIL"
.LC7:
	.string	"\nTesting < operator: "
.LC8:
	.string	"PASS"
.LC9:
	.string	"FAIL"
.LC10:
	.string	"\nTesting < operator: "
.LC11:
	.string	"FAIL"
.LC12:
	.string	"PASS"
.LC13:
	.string	"\nTesting <= operator: "
.LC14:
	.string	"PASS"
.LC15:
	.string	"FAIL"
.LC16:
	.string	"\nTesting <= operator: "
.LC17:
	.string	"PASS"
.LC18:
	.string	"FAIL"
.LC19:
	.string	"\nTesting > operator: "
.LC20:
	.string	"PASS"
.LC21:
	.string	"FAIL"
.LC22:
	.string	"\nTesting > operator: "
.LC23:
	.string	"FAIL"
.LC24:
	.string	"PASS"
.LC25:
	.string	"\nTesting >= operator: "
.LC26:
	.string	"PASS"
.LC27:
	.string	"FAIL"
.LC28:
	.string	"\nTesting >= operator: "
.LC29:
	.string	"PASS"
.LC30:
	.string	"FAIL"
.LC31:
	.string	"\n\n"
	.text
	.globl  main
	.type   main, @function
main:
.LFB0:
	.cfi_startproc
	pushq   %rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq    %rsp, %rbp
	.cfi_def_cfa_register 6
	subq    $448, %rsp
	movq    $.LC0, -16(%rbp)
	movq    -16(%rbp), %rdi
	call    printStr
	movl    %eax, -20(%rbp)
	movl    $1, -76(%rbp)
	movl    -76(%rbp), %eax
	movl    %eax, -4(%rbp)
	movl    $1, -136(%rbp)
	movl    -136(%rbp), %eax
	movl    %eax, -8(%rbp)
	movq    $.LC1, -204(%rbp)
	movq    -204(%rbp), %rdi
	call    printStr
	movl    %eax, -264(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	je      .L1
	jmp     .L2
.L1:
	movq    $.LC2, -332(%rbp)
	movq    -332(%rbp), %rdi
	call    printStr
	movl    %eax, -392(%rbp)
	jmp     .L3
.L2:
	movq    $.LC3, -444(%rbp)
	movq    -444(%rbp), %rdi
	call    printStr
	movl    %eax, -448(%rbp)
.L3:
	movl    $2, -24(%rbp)
	movl    -24(%rbp), %eax
	movl    %eax, -8(%rbp)
	movq    $.LC4, -32(%rbp)
	movq    -32(%rbp), %rdi
	call    printStr
	movl    %eax, -36(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jne     .L4
	jmp     .L5
.L4:
	movq    $.LC5, -44(%rbp)
	movq    -44(%rbp), %rdi
	call    printStr
	movl    %eax, -48(%rbp)
	jmp     .L6
.L5:
	movq    $.LC6, -56(%rbp)
	movq    -56(%rbp), %rdi
	call    printStr
	movl    %eax, -60(%rbp)
.L6:
	movl    $6, -64(%rbp)
	movl    -64(%rbp), %eax
	negl    %eax
	movl    %eax, -68(%rbp)
	movl    -68(%rbp), %eax
	movl    %eax, -4(%rbp)
	movl    $2, -72(%rbp)
	movl    -72(%rbp), %eax
	negl    %eax
	movl    %eax, -80(%rbp)
	movl    -80(%rbp), %eax
	movl    %eax, -8(%rbp)
	movq    $.LC7, -88(%rbp)
	movq    -88(%rbp), %rdi
	call    printStr
	movl    %eax, -92(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jl      .L7
	jmp     .L8
.L7:
	movq    $.LC8, -100(%rbp)
	movq    -100(%rbp), %rdi
	call    printStr
	movl    %eax, -104(%rbp)
	jmp     .L9
.L8:
	movq    $.LC9, -112(%rbp)
	movq    -112(%rbp), %rdi
	call    printStr
	movl    %eax, -116(%rbp)
.L9:
	movl    $5, -120(%rbp)
	movl    -120(%rbp), %eax
	movl    %eax, -8(%rbp)
	movq    $.LC10, -128(%rbp)
	movq    -128(%rbp), %rdi
	call    printStr
	movl    %eax, -132(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jl      .L10
	jmp     .L11
.L10:
	movq    $.LC11, -144(%rbp)
	movq    -144(%rbp), %rdi
	call    printStr
	movl    %eax, -148(%rbp)
	jmp     .L12
.L11:
	movq    $.LC12, -156(%rbp)
	movq    -156(%rbp), %rdi
	call    printStr
	movl    %eax, -160(%rbp)
.L12:
	movq    $.LC13, -168(%rbp)
	movq    -168(%rbp), %rdi
	call    printStr
	movl    %eax, -172(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jle     .L13
	jmp     .L14
.L13:
	movq    $.LC14, -180(%rbp)
	movq    -180(%rbp), %rdi
	call    printStr
	movl    %eax, -184(%rbp)
	jmp     .L15
.L14:
	movq    $.LC15, -192(%rbp)
	movq    -192(%rbp), %rdi
	call    printStr
	movl    %eax, -196(%rbp)
.L15:
	movl    $10, -208(%rbp)
	movl    -208(%rbp), %eax
	movl    %eax, -4(%rbp)
	movq    $.LC16, -216(%rbp)
	movq    -216(%rbp), %rdi
	call    printStr
	movl    %eax, -220(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jle     .L16
	jmp     .L17
.L16:
	movq    $.LC17, -228(%rbp)
	movq    -228(%rbp), %rdi
	call    printStr
	movl    %eax, -232(%rbp)
	jmp     .L18
.L17:
	movq    $.LC18, -240(%rbp)
	movq    -240(%rbp), %rdi
	call    printStr
	movl    %eax, -244(%rbp)
.L18:
	movl    $66, -248(%rbp)
	movl    -248(%rbp), %eax
	movl    %eax, -4(%rbp)
	movq    $.LC19, -256(%rbp)
	movq    -256(%rbp), %rdi
	call    printStr
	movl    %eax, -260(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jg      .L19
	jmp     .L20
.L19:
	movq    $.LC20, -272(%rbp)
	movq    -272(%rbp), %rdi
	call    printStr
	movl    %eax, -276(%rbp)
	jmp     .L21
.L20:
	movq    $.LC21, -284(%rbp)
	movq    -284(%rbp), %rdi
	call    printStr
	movl    %eax, -288(%rbp)
.L21:
	movl    $1, -292(%rbp)
	movl    -292(%rbp), %eax
	movl    %eax, -8(%rbp)
	movq    $.LC22, -300(%rbp)
	movq    -300(%rbp), %rdi
	call    printStr
	movl    %eax, -304(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jg      .L22
	jmp     .L23
.L22:
	movq    $.LC23, -312(%rbp)
	movq    -312(%rbp), %rdi
	call    printStr
	movl    %eax, -316(%rbp)
	jmp     .L24
.L23:
	movq    $.LC24, -324(%rbp)
	movq    -324(%rbp), %rdi
	call    printStr
	movl    %eax, -336(%rbp)
.L24:
	movq    $.LC25, -344(%rbp)
	movq    -344(%rbp), %rdi
	call    printStr
	movl    %eax, -348(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jge     .L25
	jmp     .L26
.L25:
	movq    $.LC26, -356(%rbp)
	movq    -356(%rbp), %rdi
	call    printStr
	movl    %eax, -360(%rbp)
	jmp     .L27
.L26:
	movq    $.LC27, -368(%rbp)
	movq    -368(%rbp), %rdi
	call    printStr
	movl    %eax, -372(%rbp)
.L27:
	movl    $10, -376(%rbp)
	movl    -376(%rbp), %eax
	negl    %eax
	movl    %eax, -380(%rbp)
	movl    -380(%rbp), %eax
	movl    %eax, -4(%rbp)
	movq    $.LC28, -388(%rbp)
	movq    -388(%rbp), %rdi
	call    printStr
	movl    %eax, -396(%rbp)
	movl    -8(%rbp), %eax
	cmpl    %eax, -4(%rbp)
	jge     .L28
	jmp     .L29
.L28:
	movq    $.LC29, -404(%rbp)
	movq    -404(%rbp), %rdi
	call    printStr
	movl    %eax, -408(%rbp)
	jmp     .L30
.L29:
	movq    $.LC30, -416(%rbp)
	movq    -416(%rbp), %rdi
	call    printStr
	movl    %eax, -420(%rbp)
.L30:
	movq    $.LC31, -428(%rbp)
	movq    -428(%rbp), %rdi
	call    printStr
	movl    %eax, -432(%rbp)
	movl    $0, -436(%rbp)
	movl    -436(%rbp), %eax
.LFE0:
	movq    %rbp, %rsp
	popq    %rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
	.size   main, .-main
