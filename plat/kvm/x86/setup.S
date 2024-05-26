#include <unikit/arch/x86/cpu.h>

.section .text.boot.32, "a"
.code32
.globl setup_32
setup_32:
	/* Enable physical address extension (PAE) */
	mov eax, X86_CR4_PAE
	mov cr4, eax

	/* Switch to IA-32e mode (long mode) */
	mov eax, X86_EFER_LME
	mov ecx, X86_MSR_EFER
	wrmsr