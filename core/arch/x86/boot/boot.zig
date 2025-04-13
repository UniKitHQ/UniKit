// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

const cpu = @import("../cpu.zig");
const SegmentDescriptor = cpu.SegmentDescriptor;
const CR0 = cpu.CR0;
const CR3 = cpu.CR3;
const CR4 = cpu.CR4;
const EFER = cpu.EFER;
const MSR = cpu.MSR;
const GDTR = cpu.GDTR;

const paging = @import("../paging.zig");
const PageTable = paging.PageTable;
const PML4E = paging.PML4E;
const PDPTE = paging.PDPTE;
const PDPTE_1GB = paging.PDPTE_1GB;
const PDE = paging.PDE;
const PDE_2MB = paging.PDE_2MB;
const PTE_4KB = paging.PTE_4KB;

export const bpt align(0x1000) = (extern struct {
    pml4: [0x200]PML4E,
    pdpte: [0x200]PDPTE_1GB,
}){
    .pml4 = PageTable.init(PML4E, &[_]PML4E{
        .{
            .p = true,
            .rw = .writeable,
            .address = 0x00,
        },
    }),
    .pdpte = PageTable.init(PDPTE_1GB, &PageTable.fill(PDPTE_1GB, .{
        .p = true,
        .rw = .writeable,
        .address = 0x00,
    }, 4)),
};

export const gdt64 = [_]SegmentDescriptor{
    SegmentDescriptor.init(0, 0, null),
    SegmentDescriptor.init(0xFFFFF, 0x0000, .{
        .type = .{ .type = .code, .ec = false, .wr = true, .a = false },
        .s = .code_data,
        .dpl = 0,
        .l = false,
        .db = .bit_32,
        .g = .limit_4k,
    }),
    SegmentDescriptor.init(0xFFFFF, 0x0000, .{
        .type = .{ .type = .data, .ec = false, .wr = true, .a = true },
        .s = .code_data,
        .dpl = 0,
        .l = true,
        .db = .bit_16,
        .g = .limit_4k,
    }),
};

comptime {
    asm (
        \\  gdtr:
        \\      .word (0x08 * 3) - 1
        \\      .quad gdt64
    );
}

/// 32-bit boot entry function
/// @param edi      Address of the protocol dependent boot function
/// @param esi      Address of the boot stack
/// @param edx      Address of the boot information structure
///
/// Assume that:
/// - 32-bit protected mode
/// - Paging disabled
/// - A20 gate enabled
/// - GDT with descriptor for 4GB flat CS and DS segments (must have R/E, R/W permissions)
/// - Interrupts disabled
///
pub export fn boot32() callconv(.naked) noreturn {
    // Set up gdt, page table entry address and CR3
    // Manual initialization required because Zig does not support 32-bit code generation for specific functions

    // gdtr = { .limit = 0x08 * 3 - 1, .base = &gdt64 };
    asm volatile ("lgdt gdtr");

    // bpt.pml4[0] |= &bpt.pdpte;
    // cr3 = &bpt;
    asm volatile (
        \\  .code32
        \\  movl $bpt, %eax
        \\  addl $0x1000, %eax
        \\  orl %eax, bpt
        \\
        \\  movl $bpt, %eax
        \\  movl %eax, %cr3
        ::: "eax");

    (CR4{ .PAE = true }).set();
    (EFER{ .LME = true }).set();
    (CR0{ .PE = true, .WP = true, .PG = true }).set();

    // Set up segmemts
    asm volatile (
        \\  .code32
        \\  ljmp $0x08, $wrap_up
        \\
        \\  .code64
        \\  wrap_up:
        \\      movl $0x10, %eax
        \\      movl %eax, %ds
        \\      movl %eax, %es
        \\      movl %eax, %ss
    );

    // Set up boot stack
    asm volatile("movl %edi, %esp");

    asm volatile("call boot64");
}

/// 64-bit boot entry function
/// @param rdi       Address of the protocol dependent boot function
/// @param rsi       Address of the boot stack
/// @param rdx       Address of the boot information structure
///
/// Assume that
/// - 64-bit long mode
/// - Paging enabled with identity mapped paging
/// - GDT with descriptor for flat CS and DS segments (must have R/E, R/W permissions)
/// - Interrupts disabled
///
pub export fn boot64() noreturn {
    while (true) {}
}
