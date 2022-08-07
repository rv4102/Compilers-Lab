	.file	"asgn1.c"										# name of the source file
	.text											# code starts from here
	.section	.rodata										# read-only data section
	.align 8										# align LC0 with 8-byte boundary by enforcing alignment 
													# on a memory address that is a multiple of the value 8
.LC0:														# Label of f-string - 1st printf
	.string	"Enter the string (all lowrer case): "
.LC1:														# Label of f-string - scanf 
	.string	"%s"
.LC2:														# Label of f-string - 2nd printf
	.string	"Length of the string: %d\n"
	.align 8										# align LC3 with 8-byte boundary by enforcing alignment 
													# on a memory address that is a multiple of the value 8
.LC3:														# Label of f-string - 3rd printf
	.string	"The string in descending order: %s\n"
	.text											# code starts
	.globl	main										# specifies that main is a global name
	.type	main, @function								# specifies the type of main, which is a function
main:												# start of 'main'
.LFB0:
	.cfi_startproc									# initialize internal structures and emit initial CFI for entry in .eh_frame
	endbr64										# Terminate indirect branch in 64-bit
	pushq	%rbp									# save base pointer(rbp) in stack
	.cfi_def_cfa_offset 16						# set CFA at an offset of 16 bytes from the current stack pointer
	.cfi_offset 6, -16								# set value of register 6 at offset 16 from CFA
	movq	%rsp, %rbp							# rbp <-- rsp, set new stack base pointer
	.cfi_def_cfa_register 6							# Uses new register '6' for computing CFA

# char str[20], dest[20];
	subq	$80, %rsp							# rsp <-- rsp - 80, create space for str[20], dest[20], len
	movq	%fs:40, %rax							# get canary (random variable used for protection from stack buffer overflow attack)
	movq	%rax, -8(%rbp)						# M[rbp-8] <-- rax, push canary to stack base pointer
	xorl	%eax, %eax								# destroy canary (only last 32 bits erased as only 32-bit canary was used(probably))

# printf("Enter the string (all lowrer case): ");
	leaq	.LC0(%rip), %rdi					# load address of .LCO(%rip) into rdi, rdi (starting of the format string) is the first argument of printf 
	movl	$0, %eax								# eax <-- 0 ############################
	call	printf@PLT							# call printf with rdi as argument
														# equivalent to printf("Enter the string (all lowrer case): ")

# scanf("%s", str);
	leaq	-64(%rbp), %rax						# rax <-- M[rbp - 64], load address of M[rbp - 64] into rax, which is rbp - 64 itself (rax now stores str)
	movq	%rax, %rsi								# rsi <-- rax, rsi (which is str) is the 2nd argument of the scanf function
	leaq	.LC1(%rip), %rdi					# load address of .LC1(%rip) into rdi, rdi (starting of the format string) is the first argument of printf
	movl	$0, %eax								# eax <-- 0 ############################
	call	__isoc99_scanf@PLT					# call scanf with rdi and rsi as arguments
														# equivalent to scanf("%s", str)

# len = length(str);
	leaq	-64(%rbp), %rax						# rax <-- M[rbp - 64], load address of M[rbp - 64] into rax, which is rbp - 64 itself (rax stores &str)
	movq	%rax, %rdi								# rdi <-- rax, rdi (which is &str) is the 1st argument of the length function
	call	length								# call the length function with rdi as argument
														# equivalent to length(str)

# printf("Length of the string: %d\n", len);
	movl	%eax, -68(%rbp)						# M[rbp-68] <-- eax, load address of eax into rbp - 68 (eax stores len)
	movl	-68(%rbp), %eax							# eax <-- M[rbp - 68], load address of M[rbp - 68] into eax, which is rbp - 68 itself (eax now stores len)
	movl	%eax, %esi							# esi <-- eax, esi (which is len) is the 2nd argument to printf
	leaq	.LC2(%rip), %rdi						# load address of .LC2(%rip) into rdi, rdi (starting of the format string) is the first argument of printf
	movl	$0, %eax							# eax <-- 0
	call	printf@PLT								# call the printf function with rdi, esi as arguments
															# equivalent to printf("Length of the string: %d\n", len)

# sort(str, len, dest);
	leaq	-32(%rbp), %rdx						# rdx <-- M[rbp - 32], load rbp - 32 into rdx immediately (rdx stores str), 1st argument of sort
	movl	-68(%rbp), %ecx							# ecx <-- M[rbp-68], move address of rbp - 68 which is rbp - 68 itself, to ecx (ecx stores &len)
	leaq	-64(%rbp), %rax						# rax <-- M[rbp - 64], load rbp - 64 into rax immediately (rax stores dest)
	movl	%ecx, %esi								# esi <-- ecx, move ecx to esi (esi now stores &len), 2nd argument of sort
	movq	%rax, %rdi							# rdi <-- rax, move rax to rdi (rdi now stores dest), 3rd argument of sort
	call	sort									# call the sort function with rdi, rsi and rdx as arguments
															# equivalent to sort(str, len, dest)

# printf("The string in descending order: %s\n", dest);
	leaq	-32(%rbp), %rax						# rax <-- M[rbp - 32], load rbp - 32 into rax immediately (rax stores dest)
	movq	%rax, %rsi								# rsi <-- rax, move rax to rsi (rsi now stores dest), 2nd argument of printf
	leaq	.LC3(%rip), %rdi					# load address of .LC3(%rip) into rdi, rdi (starting of the format string) is the 1st argument of printf
	movl	$0, %eax								# eax <-- 0, printf is a variable argument function, %al is expected to hold the number of vector registers, since here printf has integer argument so eax = 0 (al is the first 8 bits of eax)
	call	printf@PLT							# call the printf function with rdi, rsi as arguments
														# equivalent to printf("The string in descending order: %s\n", dest)

# return 0;
	movl	$0, %eax							# eax <-- 0, (eax stores the return value of main function)
	movq	-8(%rbp), %rcx							# rcx <-- M[rbp - 8], 
	xorq	%fs:40, %rcx						# take xor, and check if we get 0 or not, if we get 0 then that means there is no stack overflow, and everything is fine

	je	.L3											# jump to L3 if ZF(Zero Flag, which is set by arithmetic operations, i.e. the last performed XOR) is set to 1
													# this is executed if there is no stack overflow and we thus go to L3
	call	__stack_chk_fail@PLT				# if we reach here that indicates a stack overflow, hence the execution is terminated
.L3:
	leave											# set rsp to rbp, and pop top of stack into rbp
	.cfi_def_cfa 7, 8							# for computing CFA, take address from register 7 and add an offset of 8 to it 
	ret												# pop return address from stack and transfer control back to the return address
	.cfi_endproc								# close the unwind entry previously opened by .cfi_startproc. and emit it to .eh_frame
.LFE0:
	.size	main, .-main							# declares the size of 'main'

	.globl	length								# specifies that 'length' is a global name
	.type	length, @function						# specifies the type of 'length' is a function

# int length(char str[20])
length:											# start of 'length'
.LFB1:
	.cfi_startproc									# initialize internal structures and emit initial CFI for entry in .eh_frame
	endbr64												# terminate indirect branch in 64-bit
	pushq	%rbp									# save base pointer(rbp) in stack
	.cfi_def_cfa_offset 16								# set CFA at an offset of 16 bytes from the current stack pointer
	.cfi_offset 6, -16								# set value of register 6 at offset 16 from CFA
	movq	%rsp, %rbp									# rbp <-- rsp, set new stack base pointer
	.cfi_def_cfa_register 6							# use register 6 for computing CFA
	movq	%rdi, -24(%rbp)								# M[rbp-24] <-- rdi, store the 1st argument str (the string with which length was called)

# int i;
# for (i = 0; str[i] !='\0'; i++)
	movl	$0, -4(%rbp)							# M[rbp-4] <-- 0, (M[rbp-4] stores i), equivalent to i = 0
	jmp	.L5												# unconditional jump to L5
.L6:
	addl	$1, -4(%rbp)							# M[rbp-4] <-- M[rbp-4] + 1, increment rbp-4 by 1, equivalent to i = i + 1
.L5:
	movl	-4(%rbp), %eax							# eax <-- M[rbp-4], move memory at M[rbp-4] to eax (eax stores i)
	movslq	%eax, %rdx									# rdx <-- eax, move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax							# rax <-- M[rbp-24], move rbp - 24 to rax (rax now stores str)
	addq	%rdx, %rax									# rax <-- rax + rdx, add rdx to memory location rax & store this in rax (rax stores &str[i])
	movzbl	(%rax), %eax							# move a byte with zero extension into 32 bit eax register
	testb	%al, %al									# bitwise AND of al with itself
	jne	.L6											# jumps to label L6 if flag ZF is set to 0
	movl	-4(%rbp), %eax								# eax <-- rbp-4
	popq	%rbp									# popping the top of the stack to rbp register
	.cfi_def_cfa 7, 8									# rule for CFA to take address from register 7 and add offset 8 to it
	ret												# return (Pop return address from stack and jump there)
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
