#include <unikit/essentials.h>

#define PTE_4KB     0x0C
#define PDE         0x03
#define PDE_2MB     0x15
#define PDPTE       0x03
#define PDPTE_1GB   0x1E
#define PML4E       0x03
#define PML5E       0x03

#define X86_PTE_PS   0x080

.macro pte type, addr, flags
	.if (\type == PDPTE_1GB)
		.quad \addr + \flags + X86_PTE_PS
	.elseif (\type == PDE_2MB)
		.quad \addr + \flags + X86_PTE_PS
	.else 
		.quad \addr + \flags
	.endif
.endm

.macro pte_fill type, addr, flags, cnt
	.set i, 0
	.rept \cnt
		pte \type, (\addr + (1 << \type) * i), \flags
		.set i, i + 1
	.endr
.endm

#define X86_PTE_PRESENT   0x001
#define X86_PTE_RW        0x002

/* boot page table
 */

.align 0x1000
pte:
	pte_fill PDE_2MB, 0x00, X86_PTE_PRESENT | X86_PTE_RW, 0x200

.align 0x1000
pde:
	pte PDPTE, pte, X86_PTE_PRESENT | X86_PTE_RW