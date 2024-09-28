/* SPDX-License-Identifier: Elastic-2.0 */
/* Copyright (c) 2024, Pribess (Heewon Cho).
 * Licensed under the Elastic-2.0 License.
 * You may not use this file except in compliance with the License.
 */

#ifndef __UNIKIT_ARCH_X86_PAGING_H__
#define __UNIKIT_ARCH_X86_PAGING_H__

#include <unikit/essentials.h>

#define X86_TRAP_MNEMONIC_DE                    0
#define X86_TRAP_DIVIDE_ERROR                   X86_TRAP_MNEMONIC_DE

#define X86_TRAP_MNEMONIC_DB                    1
#define X86_TRAP_DEBUG_EXCEPTION                X86_TRAP_MNEMONIC_DB

#define X86_TRAP_MNEMONIC_NMI                   2
#define X86_TRAP_NMI_INTERRUPT                  X86_TRAP_MNEMONIC_NMI

#define X86_TRAP_MNEMONIC_BP                    3
#define X86_TRAP_BREAKPOINT                     X86_TRAP_MNEMONIC_BP

#define X86_TRAP_MNEMONIC_OF                    4
#define X86_TRAP_OVERFLOW                       X86_TRAP_MNEMONIC_OF

#define X86_TRAP_MNEMONIC_BR                    5
#define X86_TRAP_BOUND_RANGE_EXCEEDED           X86_TRAP_MNEMONIC_BR

#define X86_TRAP_MNEMONIC_UD                    6
#define X86_TRAP_INVALID_OPCODE                 X86_TRAP_MNEMONIC_UD

#define X86_TRAP_MNEMONIC_NM                    7
#define X86_TRAP_DEVICE_NOT_AVAILABLE           X86_TRAP_MNEMONIC_NM

#define X86_TRAP_MNEMONIC_DF                    8
#define X86_TRAP_DOUBLE_FAULT                   X86_TRAP_MNEMONIC_DF

#define X86_TRAP_MNEMONIC_TS                    10
#define X86_TRAP_INVALID_TSS                    X86_TRAP_MNEMONIC_TS

#define X86_TRAP_MNEMONIC_NP                    11
#define X86_TRAP_SEGMENT_NOT_PRESENT            X86_TRAP_MNEMONIC_NP

#define X86_TRAP_MNEMONIC_SS                    12
#define X86_TRAP_STACK_SEGMENT_FAULT            X86_TRAP_MNEMONIC_SS

#define X86_TRAP_MNEMONIC_GP                    13
#define X86_TRAP_GENERAL_PROTECTION             X86_TRAP_MNEMONIC_GP

#define X86_TRAP_MNEMONIC_PF                    14
#define X86_TRAP_PAGE_FAULT                     X86_TRAP_MNEMONIC_PF

#define X86_TRAP_MNEMONIC_MF                    16
#define X86_TRAP_MATH_FAULT                     X86_TRAP_MNEMONIC_MF

#define X86_TRAP_MNEMONIC_AC                    17
#define X86_TRAP_ALIGNMENT_CHECK                X86_TRAP_MNEMONIC_AC

#define X86_TRAP_MNEMONIC_MC                    18
#define X86_TRAP_MACHINE_CHECK                  X86_TRAP_MNEMONIC_MC

#define X86_TRAP_MNEMONIC_XM                    19
#define X86_TRAP_SIMD_EXCEPTION                 X86_TRAP_MNEMONIC_XM

#define X86_TRAP_MNEMONIC_VE                    20
#define X86_TRAP_VIRTUALIZATION_EXCEPTION       X86_TRAP_MNEMONIC_VE

/*
 * Intel CET (Control Flow Enforcement Technology)
 */
#define X86_TRAP_MNEMONIC_CP                    21
#define X86_TRAP_CONTROL_PROTECTION_EXCEPTION   X86_TRAP_MNEMONIC_CP

/*
 * AMD SEV (Secure Encrypted Virtualization),
 * AMD's implementation of VM level TEE (Trusted Execution Environment)
 */
#define X86_TRAP_MNEMONIC_HV                    28
#define X86_TRAP_HYPERVISOR_INJECTION_EXCEPTION X86_TRAP_MNEMONIC_HV

#define X86_TRAP_MNEMONIC_VC                    29
#define X86_TRAP_VMM_COMMUNICATION_EXCEPTION    X86_TRAP_MNEMONIC_VC

#define X86_TRAP_MNEMONIC_SX                    30
#define X86_TRAP_SECURITY_EXCEPTION             X86_TRAP_MNEMONIC_SX


#define X86_IDT_ENTRIES 256

#define X86_IDT_TYPE_TRAP      0xE
#define X86_IDT_TYPE_INTERRUPT 0xF

struct x86_idtr {
    u16 limit;
	u64 base;
} __packed;

struct x86_idt_desc {
    u64 offset_low  : 16; /* Bits 15:0 of the handler offset */
    u64 ss          : 16; /* Segment selector */
    u64 ist         : 3;  /* Interrupt Stack Table (IST) */
    u64             : 5;  /* Reserved (must be 0) */
    u64 type        : 4;  /* Gate type */
    u64             : 1;  /* Reserved (must be 0) */
    u64 dpl         : 2;  /* Descriptor Privilege Level (DPL) */
    u64 p           : 1;  /* Present bit */
    u64 offset_high : 48; /* Bits 63:16 of the handler offset */
    u64             : 32; /* Reserved (must be 0) */
} __packed;

struct x86_trap_frame {
    u64 rax;
    u64 rbx;
    u64 rcx;
    u64 rdx;
    u64 r8;
    u64 r9;
    u64 r10;
    u64 r11;
    u64 r12;
    u64 r13;
    u64 r14;
    u64 r15;
    u64 rbp;
    u64 rsi;
    u64 rdi;
    u64 error_code;
    u64 rip;
    u64 cs;
    u64 rflags;
    u64 rsp; /* With privilege escalation */
    u64 ss;  /* With privilege escalation */
};

void idt_init();

#endif /* __UNIKIT_ARCH_X86_TRAPS_H__ */
