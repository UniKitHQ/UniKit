/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/arch/x86/cpu.h>
#include <unikit/arch/x86/gdt.h>

/**
 * 32-bit boot entry function
 * @param edi       Address of the protocol dependent boot function
 * @param esi       Address of the boot stack
 * @param edx       Address of the boot information structure
 *
 * Assume that:
 * - 32-bit protected mode
 * - Paging disabled
 * - A20 gate enabled
 * - GDT with descriptor for 4GB flat CS and DS segments (must have R/E, R/W permissions)
 * - Interrupts disabled
 */

.section .data.boot.32
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

.section .text.boot.32
.code32
.globl boot32
boot32:
	/* Enable physical address extension (PAE) */
	mov eax, X86_CR4_PAE
	mov cr4, eax

	/* Switch to IA-32e mode (long mode) */
	mov eax, X86_EFER_LME
	mov ecx, X86_MSR_EFER
	wrmsr

	/* Set up boot page tables */
	mov eax, offset x86_bpt_pml4
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

	jmp boot64

/*
 * 64-bit boot entry function
 * @param rdi       Address of the protocol dependent boot function
 * @param rsi       Address of the boot stack
 * @param rdx       Address of the boot information structure
 *
 * Assume that
 * - 64-bit long mode
 * - Paging enabled with identity mapped paging
 * - GDT with descriptor for flat CS and DS segments (must have R/E, R/W permissions)
 * - Interrupts disabled
 */

.section .text.boot.64
.globl boot64
boot64:
    mov rsp, rsi /* Set up boot stack */

    push rdx

    mov rax, 0x1
    cpuid

.macro if_available feature, register, label
	test \register, \feature
	jz \label
.endmacro

	/* Enable FPU */
	if_available X86_CPUID_1_EDX_FPU, rdx, no_fpu
	mov rax, cr0
	and rax, ~(X86_CR0_EM | X86_CR0_TS)
	or rax, X86_CR0_NE | X86_CR0_MP
	mov cr0, rax
	fninit
no_fpu:

	/* Enable SSE */
	if_available X86_CPUID_1_EDX_SSE, rdx, no_sse
	mov rax, cr0
	or rax, X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT
	mov cr4, rax
no_sse:

	/* Enable OSXSAVE */
	if_available X86_CPUID_1_ECX_OSXSAVE, rcx, no_osxsave
	mov rax, cr4
	or rax, X86_CR4_OSXSAVE
	mov cr4, rax
no_osxsave:

	/* Enable AVX and AVX-512 */
	if_available X86_CPUID_1_ECX_AVX, rcx, no_avx
	xor rcx, rcx
	xgetbv
	or rax, (X86_XCR0_X87 | X86_XCR0_SSE | X86_XCR0_AVX)

	if_available X86_CPUID_7_EBX_AVX512F, rbx, no_avx512
	or rax, (X86_XCR0_OPMASK | X86_XCR0_ZMM_HI256 | X86_XCR0_HI16_ZMM)

no_avx512:
	xsetbv
no_avx:

	pop rdx

	mov rax, rdi
	mov rdi, rdx /* Pass boot information structure as an argument */
	call rax

fail:
    cli
1:
	hlt
	jmp 1b
