	.file	"asgn1.c"										# Name of the input C file
	.text													# 
	.section	.rodata										# read-only data section
	.align 8												# align LC0 with 8-byte boundary by enforcing alignment 
															# on a memory address that is a multiple of the value 8
.LC0:														# Label of f-string - 1st printf
	.string	"Enter the string (all lowrer case): "			#
.LC1:														# Label of f-string - scanf 
	.string	"%s"											#
.LC2:														# Label of f-string - 2nd printf
	.string	"Length of the string: %d\n"					#
	.align 8												# align LC3 with 8-byte boundary by enforcing alignment 
															# on a memory address that is a multiple of the value 8
.LC3:														# Label of f-string - 3rd printf
	.string	"The string in descending order: %s\n"			#
	.text													# Code starts
	.globl	main											# main is a global name
	.type	main, @function									# main is a function:
main:														# main: starts
.LFB0:														# Local label
	.cfi_startproc											# CFI directive to start process
	endbr64													# Terminate indirect branch in 64-bit
	pushq	%rbp											# Save old base pointer
	.cfi_def_cfa_offset 16									# Offset 16 bytes from current stack pointer for CFA
	.cfi_offset 6, -16										# Previous value of register is saved at offset=offset from CFA
	movq	%rsp, %rbp										# rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6									# Uses new register '6' instead of old one from now on
	subq	$80, %rsp										# Create space for local array and variables
	movq	%fs:40, %rax									# rbp <-- fs:0+40 (here fs:0 contains the address "pointed to" by fs itself, therefore fs:40 loads value stored at fs:0+40)
	movq	%rax, -8(%rbp)									# rbp-8 <-- rax move function return value to stack base pointer
	xorl	%eax, %eax										# bitwise XOR value stored at eax by itself, to obtain 0
	leaq	.LC0(%rip), %rdi								# load LC0 label into instruction pointer register and load the effective address
															# of the register into rdi register
	movl	$0, %eax										# move 0 to last 32 bits of rax register
	call	printf@PLT										# call printf and print the LC0 string to the console from rdi register
	leaq	-64(%rbp), %rax									# rax <-- rbp-64 load immediately 64 bits from rbp(stack base pointer) to rax
	movq	%rax, %rsi										# rsi <-- rax move value stored in rax to rsi
	leaq	.LC1(%rip), %rdi								# load LC1 label into instruction pointer register and load the effective address
	movl	$0, %eax										# move 0 to eax register
	call	__isoc99_scanf@PLT								# call scanf function
	leaq	-64(%rbp), %rax									# load immediately, value of rbp-64 into rax
	movq	%rax, %rdi										# rdi <-- rax
	call	length											# call the length function
	movl	%eax, -68(%rbp)									# rbp-68 <-- eax 
	movl	-68(%rbp), %eax									# eax <-- rbp-68
	movl	%eax, %esi										# esi <-- eax
	leaq	.LC2(%rip), %rdi								# load LC2 label into instruction pointer register and load the effective address
	movl	$0, %eax										# eax <-- 0
	call	printf@PLT										# call the printf function
	leaq	-32(%rbp), %rdx									# load immediately rbp-32 to rdx
	movl	-68(%rbp), %ecx									# ecx <-- rbp-68
	leaq	-64(%rbp), %rax									# load immediately rbp-64 to rax
	movl	%ecx, %esi										# move ecx to esi
	movq	%rax, %rdi										# move rax to tdi
	call	sort											# call the sort function
	leaq	-32(%rbp), %rax									# load immediately rbp-32 to rax
	movq	%rax, %rsi										# move rax to rsi
	leaq	.LC3(%rip), %rdi								# load LC3 label into instruction pointer register and load the effective address
	movl	$0, %eax										# move 0 to eax
	call	printf@PLT										# call the printf function
	movl	$0, %eax										# move 0 to eax
	movq	-8(%rbp), %rcx									# move rbp-8 to rcx
	xorq	%fs:40, %rcx									# calculate XOR of value at fs:0+40 and rcx
	je	.L3													# Jump to L3 if ZF(Zero Flag, which is set by arithmetic operations, i.e. the last performed XOR) is set to 1
	call	__stack_chk_fail@PLT							# call the __stack_chk_fail function
.L3:														# Label L3
	leave													# Set rsp to rbp, then pop the top of the stack into rbp
	.cfi_def_cfa 7, 8										# rule for CFA to take address from register 7 and add offset 8 to it
	ret														# return (Pop return address from stack and jump there)
	.cfi_endproc											# End the CFI directive and close the unwind entry previously opened by .cfi_startproc
.LFE0:														# Label LFE0
	.size	main, .-main									# it declares that the size of the label 'main' is the number of lines from where main is defined to this line(72-19=53)
	.globl	length											# the symbol length should be global
	.type	length, @function								# length is a function
length:														# length: starts
.LFB1:														# declare label .LFB1
	.cfi_startproc											# CFI directive to start process
	endbr64													# Terminate indirect branch in 64-bit
	pushq	%rbp											# save old base pointer
	.cfi_def_cfa_offset 16									# Offset 16 bytes from current stack pointer for CFA
	.cfi_offset 6, -16										# Previous value of register is saved at offset=offset from CFA
	movq	%rsp, %rbp										# rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6									# Uses new register '6' instead of old one from now on
	movq	%rdi, -24(%rbp)									# rbp-24 <-- rdi 
	movl	$0, -4(%rbp)									# rbp-4 <-- 0
	jmp	.L5													# jump to label L5
.L6:														# Label L6
	addl	$1, -4(%rbp)									# rbp-4 <-- (rbp-4) + 1, add the value 1 to data stored at rbp-4
.L5:														# Label L5
	movl	-4(%rbp), %eax									# eax <-- rbp-4
	movslq	%eax, %rdx										# move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax									# rax <-- rbp-24
	addq	%rdx, %rax										# rax <-- rax + rdx
	movzbl	(%rax), %eax									# move a byte with zero extension into 32 bit eax register
	testb	%al, %al										# bitwise AND of al with itself
	jne	.L6													# jumps to label L6 if flag ZF is set to 0
	movl	-4(%rbp), %eax									# eax <-- rbp-4
	popq	%rbp											# popping the top of the stack to rbp register
	.cfi_def_cfa 7, 8										# rule for CFA to take address from register 7 and add offset 8 to it
	ret														# return (Pop return address from stack and jump there)
	.cfi_endproc											# End the CFI directive and close the unwind entry previously opened by .cfi_startproc
.LFE1:														# declare the label LFE1
	.size	length, .-length								# it declares that the size of the label 'length' is the number of lines from where main is defined to this line(103-75=28)
	.globl	sort											# the symbol sort should be global
	.type	sort, @function									# sort is a function
sort:														# sort: begins
.LFB2:														# declare label LFB2
	.cfi_startproc											# CFI directive to start process
	endbr64													# Terminate indirect branch in 64-bit
	pushq	%rbp											# save old base pointer
	.cfi_def_cfa_offset 16									# Offset 16 bytes from current stack pointer for CFA
	.cfi_offset 6, -16										# Previous value of register is saved at offset=offset from CFA
	movq	%rsp, %rbp										# rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6									# Uses new register '6' instead of old one from now on
	subq	$48, %rsp										# Create space for local array and variables
	movq	%rdi, -24(%rbp)									# rbp-24 <-- rdi
	movl	%esi, -28(%rbp)									# rbp-28 <-- esi
	movq	%rdx, -40(%rbp)									# rbp-40 <-- rdx
	movl	$0, -8(%rbp)									# rbp-8 <-- 0
	jmp	.L9													# jump to label L9
.L13:														# declare L13
	movl	$0, -4(%rbp)									# rbp-4 <-- 0
	jmp	.L10												# jump to label L10
.L12:														# declare L12
	movl	-8(%rbp), %eax									# eax <-- rbp-8
	movslq	%eax, %rdx										# move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax									# rax <-- rbp-24
	addq	%rdx, %rax										# rax <-- rax + rdx
	movzbl	(%rax), %edx									# move a byte with zero extension into 32 bit edx register
	movl	-4(%rbp), %eax									# eax <-- rbp-4
	movslq	%eax, %rcx										# move and sign extend a value from 32-bit eax register to 64-bit rcx register
	movq	-24(%rbp), %rax									# rax <-- rbp-24
	addq	%rcx, %rax										# rax <-- rax+rcx
	movzbl	(%rax), %eax									# move a byte with zero extension into 32 bit eax register
	cmpb	%al, %dl										# if value at dl is greater than value at al
	jge	.L11												# then jump to L11 label
	movl	-8(%rbp), %eax									# eax <-- rbp-8
	movslq	%eax, %rdx										# move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax									# rax <-- rbp-24
	addq	%rdx, %rax										# rax <-- rax + rdx
	movzbl	(%rax), %eax									# move a byte with zero extension into 32 bit eax register
	movb	%al, -9(%rbp)									# rbp-9 <-- al
	movl	-4(%rbp), %eax									# eax <-- rbp-4
	movslq	%eax, %rdx										# move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax									# rax <-- rbp-24
	addq	%rdx, %rax										# rax <-- rax + rdx
	movl	-8(%rbp), %edx									# edx <-- rbp-8
	movslq	%edx, %rcx										# move and sign extend a value from 32-bit eax register to 64-bit rcx register
	movq	-24(%rbp), %rdx									# rdx <-- rbp-24
	addq	%rcx, %rdx										# rdx <-- rdx+rcx
	movzbl	(%rax), %eax									# move a byte with zero extension into 32 bit eax register
	movb	%al, (%rdx)										# move 1 byte from al to last byte of rdx
	movl	-4(%rbp), %eax									# eax <-- rbp-4
	movslq	%eax, %rdx										# move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax									# rax <-- rbp-24
	addq	%rax, %rdx										# rdx <-- rdx + rax
	movzbl	-9(%rbp), %eax									# move a byte with zero extension into 32 bit eax register
	movb	%al, (%rdx)										# move 1 byte from al to last byte of rdx
.L11:														# label L11
	addl	$1, -4(%rbp)									# i <-- i+1
.L10:														# label L10
	movl	-4(%rbp), %eax									# 
	cmpl	-28(%rbp), %eax									# if j < len
	jl	.L12												# jump to L12
	addl	$1, -8(%rbp)									# j <-- j+1
.L9:														# label L9
	movl	-8(%rbp), %eax									# 
	cmpl	-28(%rbp), %eax									# if i < len
	jl	.L13												# jump to L13
	movq	-40(%rbp), %rdx									#
	movl	-28(%rbp), %ecx									#
	movq	-24(%rbp), %rax									#
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	reverse
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	sort, .-sort
	.globl	reverse
	.type	reverse, @function
reverse:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L15
.L20:
	movl	-28(%rbp), %eax
	subl	-8(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -4(%rbp)
	nop
	movl	-28(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	%eax, -4(%rbp)
	jl	.L18
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	je	.L23
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -9(%rbp)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movzbl	-9(%rbp), %eax
	movb	%al, (%rdx)
	jmp	.L18
.L23:
	nop
.L18:
	addl	$1, -8(%rbp)
.L15:
	movl	-28(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	%eax, -8(%rbp)
	jl	.L20
	movl	$0, -8(%rbp)
	jmp	.L21
.L22:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$1, -8(%rbp)
.L21:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L22
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	reverse, .-reverse
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
