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
.globl boot_32
boot_32:
	/* Enable physical address extension (PAE) */
	mov eax, X86_CR4_PAE
	mov cr4, eax

	/* Switch to IA-32e mode (long mode) */
	mov eax, X86_EFER_LME
	mov ecx, X86_MSR_EFER
	wrmsr

	/* Set up boot page tables */
	mov eax, x86_bpt_pml4
	mov cr3, eax

	mov eax, X86_CR0_PE | X86_CR0_WP | X86_CR0_PG
	mov cr0, eax

	/* Load GDT and jump to 64-bit code segment */
	lgdt gdt64_ptr

	.att_syntax
	ljmp $(gdt64_cs - gdt64), $wrap_up

.code64
wrap_up:
	mov $(gdt64_ds - gdt64), %eax
	.intel_syntax noprefix

	mov es, eax
	mov ss, eax
	mov ds, eax

	jmp boot_64

.section .text.boot.64, "a"
.globl boot_64
boot_64:
	/* Enable FPU */
	mov rax, cr0
	or rax, X86_CR0_NE | X86_CR0_MP
	and rax, ~(X86_CR0_EM | X86_CR0_TS)
	mov cr0, rax
	fninit

	/* Enable SSE */
	mov rax, cr0
	or rax, X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT
	mov cr4, rax

	call [boot_entry]
	hlt
