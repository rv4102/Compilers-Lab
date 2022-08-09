	.file	"asgn1.c"										# name of the source file
	.text											# ro data starts from here
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
# int len;
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
	movq	-8(%rbp), %rcx							# rcx <-- M[rbp - 8], (rcx now stores canary)
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
	testb	%al, %al									# bitwise AND of al with itself, (if al & al == 0, set ZF = 1)
	jne	.L6											# jump to L6 if ZF != 0, (equivalent to if i != 0, jump to L6)

# return i;
	movl	-4(%rbp), %eax								# eax <-- M[rbp-4] (eax stores i)
	popq	%rbp									# pop top of stack into rbp
	.cfi_def_cfa 7, 8									# for computing CFA, take address from register 7 and add an offset of 8 to it
	ret												# transfer control back to the return address
	.cfi_endproc										# close the unwind entry previously opened by .cfi_startproc. and emit it to .eh_frame
.LFE1:
	.size	length, .-length						# declares the size of 'length'
	.globl	sort										# specifies that 'sort' is a global name
	.type	sort, @function							# specifies the type of 'sort', which is a function

# void sort(char str[20], int len, char dest[20])
sort:												# sort: begins
.LFB2:
	.cfi_startproc									# initialize internal structures and emit initial CFI for entry in .eh_frame
	endbr64												# terminate indirect branch in 64-bit
	pushq	%rbp									# save base pointer(rbp) in stack
	.cfi_def_cfa_offset 16								# set CFA at an offset of 16 bytes from the current stack pointer
	.cfi_offset 6, -16								# set value of register 6 at offset 16 from CFA
	movq	%rsp, %rbp									# rbp <-- rsp, set new stack base pointer
	.cfi_def_cfa_register 6							# use register 6 for computing CFA

# int i, j;
# char temp;
	subq	$48, %rsp								# rsp <-- rsp - 48, create space for i, j, temp
	movq	%rdi, -24(%rbp)								# M[rbp - 24] <-- rdi, (rbp - 24 now stores str)
	movl	%esi, -28(%rbp)							# M[rbp - 28] <-- esi, (rbp - 28 now stores len)
	movq	%rdx, -40(%rbp)								# M[rbp - 40] <-- rdx, (rbp - 40 now stores dest)

# for (i = 0; i < len; i++)
	movl	$0, -8(%rbp)							# M[rbp - 8] <-- 0, equivalent to i = 0 (rbp - 8 stores i)
	jmp	.L9												# jump to label L9

# for (j = 0; j < len; j++)
.L13:
	movl	$0, -4(%rbp)							# M[rbp - 4] <-- 0, equivalent to j = 0 (rbp - 4 stores j)
	jmp	.L10											# jump to label L10

.L12:
# if (str[i] < str[j])
	movl	-8(%rbp), %eax							# eax <-- M[rbp - 8], (eax now stores i)
	movslq	%eax, %rdx									# move and sign extend a value from 32-bit eax register to 64-bit rdx register 
														# (rdx stores i)
	movq	-24(%rbp), %rax							# rax <-- M[rbp - 24], (rax now stores str)
	addq	%rdx, %rax									# rax <-- rax + rdx, (rax stores str + i or str[i])
	movzbl	(%rax), %edx							# move a byte with zero extension into 32 bit edx register (edx stores str + i or str[i])
	movl	-4(%rbp), %eax								# eax <-- M[rbp - 4], (eax stores j)
	movslq	%eax, %rcx								# move and sign extend a value from 32-bit eax register to 64-bit rcx register
													# (rcx stores j)
	movq	-24(%rbp), %rax								# rax <-- M[rbp - 24], (rax stores str)
	addq	%rcx, %rax								# rax <-- rax + rcx, (rax stores str + j or str[j])
	movzbl	(%rax), %eax								# move a byte with zero extension into 32 bit eax register (eax stores &str[j])
	cmpb	%al, %dl								# compare first byte of edx (str[i]) with eax (str[j])
	jge	.L11											# jump to L11 if first byte of edx >= eax (str[i] >= str[j])

# temp = str[i];
	movl	-8(%rbp), %eax							# eax <-- M[rbp - 8], (eax now stores i)
	movslq	%eax, %rdx									# move and sign extend a value from 32-bit eax register to 64-bit rdx register, (rdx now stores i)
	movq	-24(%rbp), %rax							# rax <-- M[rbp - 24], (rax now stores str)
	addq	%rdx, %rax									# rax <-- rax + rdx, (rax now stores str + i or str[i])
	movzbl	(%rax), %eax							# move a byte with zero extension into 32-bit eax register
	movb	%al, -9(%rbp)								# M[rbp - 9] <-- al, 1st byte of eax is moved to rbp - 9, (push str[i] to rbp - 9)

# str[i] = str[j];
	movl	-4(%rbp), %eax							# eax <-- M[rbp - 4], (eax now stores j)
	movslq	%eax, %rdx									# move and sign extend a value from 32-bit eax register to 64-bit rdx register 
														# (rdx stores j)
	movq	-24(%rbp), %rax							# rax <-- M[rbp - 24], (rax now stores str)
	addq	%rdx, %rax									# rax <-- rax + rdx, (rax now stores str[j])
	movl	-8(%rbp), %edx							# edx <-- M[rbp - 8], (edx now stores i)
	movslq	%edx, %rcx									# move and sign extend a value from 32-bit eax register to 64-bit rcx register 
														# (rcx stores i)
	movq	-24(%rbp), %rdx							# rdx <-- M[rbp - 24], (rdx stores str)
	addq	%rcx, %rdx									# rdx <-- rdx + rcx, (rdx stores str + i or str[i])
	movzbl	(%rax), %eax							# move a byte with zero extension into 32 bit eax register (eax stores str[i])
	movb	%al, (%rdx)									# move 1 byte from al(str[j]) to last byte of rdx(str[i])
														# (str[i] = str[j])

# str[j] = temp;
	movl	-4(%rbp), %eax							# eax <-- M[rbp - 4], (eax now stores j)
	movslq	%eax, %rdx									# move and sign extend a value from 32-bit eax register to 64-bit rdx register
	movq	-24(%rbp), %rax							# rax <-- M[rbp - 24], (rax stores str)
	addq	%rax, %rdx									# rdx <-- rdx + rax, (rdx stores str + i or str[i])
	movzbl	-9(%rbp), %eax							# move a byte with zero extension into 32 bit eax register (eax now stores temp)
	movb	%al, (%rdx)									# move 1 byte from al to last byte of rdx (M[rdx] stores address of temp)


.L11:
	addl	$1, -4(%rbp)							# j <-- j+1
.L10:
	movl	-4(%rbp), %eax								# eax <-- M[rbp - 4], (eax now stores j)
	cmpl	-28(%rbp), %eax							# if j < len
	jl	.L12										# jump to L12
	addl	$1, -8(%rbp)								# i <-- i+1
.L9:
	movl	-8(%rbp), %eax							# eax <-- M[rbp - 8], (eax now stores i) 
	cmpl	-28(%rbp), %eax								# if i < len
	jl	.L13											# jump to L13

# reverse(str, len, dest);
	movq	-40(%rbp), %rdx							# rdx <-- M[rbp - 40], (rdx now stores dest)
	movl	-28(%rbp), %ecx								# ecx <-- M[rbp - 28], (ecx now stores len) 
	movq	-24(%rbp), %rax							# rax <-- M[rbp - 24], (rax now stores str)
	movl	%ecx, %esi									# esi <-- ecx, (esi stores len)
	movq	%rax, %rdi								# rdi <-- rax, (rdi stores str)
	call	reverse										# call reverse with 1st, 2nd and 3rd args as str, len and dest
	nop												# do nothing
	leave												# set rsp to rbp, and pop top of stack into rbp
	.cfi_def_cfa 7, 8								# for computing CFA, take address from register 7 and add an offset of 8 to it 
	ret													# pop return address from stack and transfer control back to the return address
	.cfi_endproc									# close the unwind entry previously opened by .cfi_startproc. and emit it to .eh_frame
.LFE2:
	.size	sort, .-sort								# declares the size of sort
	.globl	reverse									# specifies that 'reverse' is a global name
	.type	reverse, @function						# specifies the type of 'reverse', which is a function

# void reverse(char str[20], int len, char dest[20])
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
