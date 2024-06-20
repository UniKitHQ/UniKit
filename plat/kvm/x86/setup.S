/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/arch/x86/cpu.h>
#include <unikit/arch/x86/gdt.h>

.section .data.boot.32, "a"
gdt64:
gdt64_null:
	.quad 0x0000000000000000 /* null segment */
gdt64_cs:
	.quad GDT_SEGMENT_CODE64 /* 64-bit CS */
gdt64_ds:
	.quad GDT_SEGMENT_DATA64 /* 64-bit DS */
gdt64_ptr:
	.word gdt64_ptr - gdt64 - 1
	.quad gdt64

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

	mov eax, x86_bpt_pml4
	mov cr3, eax

	mov eax, X86_CR0_PE | X86_CR0_WP | X86_CR0_PG
	mov cr0, eax

	lgdt gdt64_ptr

	.att_syntax
	ljmp $(gdt64_cs - gdt64), $setup_64
	.intel_syntax noprefix

.section .text.boot.64, "a"
.code64
.globl setup_64
setup_64:
