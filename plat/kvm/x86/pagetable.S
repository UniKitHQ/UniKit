/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/essentials.h>

#define PTE_4KB     0x0C
#define PDE         0x0C
#define PDE_2MB     0x15
#define PDPTE       0x0C
#define PDPTE_1GB   0x1E
#define PML4E       0x0C
#define PML5E       0x0C

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

.macro pte_zero cnt
	.fill \cnt, 0x8, 0
.endm

#define X86_PTE_PRESENT   0x001
#define X86_PTE_RW        0x002

/* boot page table
 */

.align 0x1000
x86_bpt_pd_0:
	pte_fill PDE_2MB, 0x0000000000000000, X86_PTE_PRESENT | X86_PTE_RW, 0x200
x86_bpt_pd_1:
	pte_fill PDE_2MB, 0x0000000040000000, X86_PTE_PRESENT | X86_PTE_RW, 0x200
x86_bpt_pd_2:
	pte_fill PDE_2MB, 0x0000000080000000, X86_PTE_PRESENT | X86_PTE_RW, 0x200
x86_bpt_pd_3:
	pte_fill PDE_2MB, 0x00000000C0000000, X86_PTE_PRESENT | X86_PTE_RW, 0x200

.align 0x1000
x86_bpt_pdpt:
	pte PDPTE, x86_bpt_pd_0, X86_PTE_PRESENT | X86_PTE_RW
	pte PDPTE, x86_bpt_pd_1, X86_PTE_PRESENT | X86_PTE_RW
	pte PDPTE, x86_bpt_pd_2, X86_PTE_PRESENT | X86_PTE_RW
	pte PDPTE, x86_bpt_pd_3, X86_PTE_PRESENT | X86_PTE_RW
	pte_zero 0x200 - 0x04

.align 0x1000
.globl x86_bpt_pml4
x86_bpt_pml4:
	pte PML4E, x86_bpt_pdpt, X86_PTE_PRESENT | X86_PTE_RW
	pte_zero 0x200 - 0x01