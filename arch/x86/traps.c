/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#include <unikit/arch/x86/traps.h>

#include <unikit/essentials.h>
#include <unikit/arch/x86/cpu.h>
#include <unikit/arch/x86/asm.h>
#include <unikit/arch/x86/gdt.h>

static __align(8)
struct x86_idt_desc idt[X86_IDT_ENTRIES];

extern void trap_stub();

static void idt_fill_entry(u8 vec, u8 ist) {
    struct x86_idt_desc *desc = &idt[vec];

    void (*stub_offset) = trap_stub + (vec * 0x10);

    desc->offset_low  = (u64)stub_offset;
    desc->offset_high = (u64)stub_offset >> 16;
    desc->ss          = GDT_OFFSET(GDT_CODE);
    desc->ist         = ist;
    desc->type        = X86_IDT_TYPE_TRAP;
    desc->dpl         = X86_DPL_KERNEL;
    desc->p           = 1;
}

#define IST_INTERRUPT 1
#define IST_TRAP      2
#define IST_CRITICAL  3

#define TRAP_GATE(vec, ist) \
        idt_fill_entry(vec, ist);

void idt_init() {
    TRAP_GATE(X86_TRAP_DIVIDE_ERROR             , IST_TRAP);
    TRAP_GATE(X86_TRAP_DEBUG_EXCEPTION          , IST_CRITICAL);
    TRAP_GATE(X86_TRAP_NMI_INTERRUPT            , IST_CRITICAL);
    TRAP_GATE(X86_TRAP_BREAKPOINT               , IST_CRITICAL);
    TRAP_GATE(X86_TRAP_OVERFLOW                 , IST_TRAP);
    TRAP_GATE(X86_TRAP_BOUND_RANGE_EXCEEDED     , IST_TRAP);
    TRAP_GATE(X86_TRAP_INVALID_OPCODE           , IST_TRAP);
    TRAP_GATE(X86_TRAP_DEVICE_NOT_AVAILABLE     , IST_TRAP);
    TRAP_GATE(X86_TRAP_DOUBLE_FAULT             , IST_CRITICAL);
    TRAP_GATE(X86_TRAP_INVALID_TSS              , IST_TRAP);
    TRAP_GATE(X86_TRAP_SEGMENT_NOT_PRESENT      , IST_TRAP);
    TRAP_GATE(X86_TRAP_STACK_SEGMENT_FAULT      , IST_TRAP);
    TRAP_GATE(X86_TRAP_GENERAL_PROTECTION       , IST_TRAP);
    TRAP_GATE(X86_TRAP_PAGE_FAULT               , IST_TRAP);
    TRAP_GATE(X86_TRAP_MATH_FAULT               , IST_TRAP);
    TRAP_GATE(X86_TRAP_ALIGNMENT_CHECK          , IST_TRAP);
    TRAP_GATE(X86_TRAP_MACHINE_CHECK            , IST_CRITICAL);
    TRAP_GATE(X86_TRAP_SIMD_EXCEPTION           , IST_TRAP);
    TRAP_GATE(X86_TRAP_VIRTUALIZATION_EXCEPTION , IST_TRAP);

    for (int i = 32; i < X86_IDT_ENTRIES; i++) {
        TRAP_GATE(i, IST_INTERRUPT);
    }
    
     struct x86_idtr idtr = {
        .limit = sizeof(idt) - 1,
        .base = (u64)&idt
    };

    lidt((u64)&idtr);
}

void trap_handler(u8 vec, struct x86_trap_frame *frame) {}
