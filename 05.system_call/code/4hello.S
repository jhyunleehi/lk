#include <asm/unistd.h>
#include <syscall.h>
	.file	"hello_sys.c"
	.section	.rodata
hello:
	.string	"hello, World!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp

    ## write
	movl	$14, %edx
	movl	$hello, %esi
	movl	$1, %edi
	movl	$SYS_write, %eax
	syscall

    ## exit 0
	movl	$0, %eax
	popq	%rbp
	ret
.size	main, .-main
	.section	.note.GNU-stack,"",@progbits

