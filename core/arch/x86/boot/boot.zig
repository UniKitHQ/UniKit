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

const paging = @import("../paging.zig");
const PageTable = paging.PageTable;
const PML4E = paging.PML4E;
const PDPTE = paging.PDPTE;
const PDPTE_1GB = paging.PDPTE_1GB;
const PDE = paging.PDE;
const PDE_2MB = paging.PDE_2MB;
const PTE_4KB = paging.PTE_4KB;

export const bpt align(0x200) = (extern struct {
    pml4: [512]PML4E,
    pdpte: [512]PDPTE_1GB,
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

const gdt64 = [_]SegmentDescriptor{
    SegmentDescriptor.init(0, 0, null),
    SegmentDescriptor.init(0xFFFFF, 0x0000, .{
        .type = .{ .type = .code, .ec = false, .wr = true, .a = true },
        .s = .code_data,
        .dpl = 0,
        .l = false,
        .db = .bit_32,
        .g = .limit_4k,
    }),
    SegmentDescriptor.init(0xFFFFF, 0x0000, .{
        .type = .{ .type = .code, .ec = false, .wr = true, .a = true },
        .s = .code_data,
        .dpl = 0,
        .l = true,
        .db = .bit_16,
        .g = .limit_4k,
    }),
};

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
    asm volatile (".code32");

    (CR4{ .PAE = true }).set();
    (EFER{ .LME = true }).set();

    // Set up page table entry address and CR3
    // Manual initialization required because Zig does not support comptime symbol address resolution
    // bpt.pml4[0].address = bpt.pdpte;
    asm volatile (
        \\  movl $bpt, %eax
        \\  addl $0x1000, %eax
        \\
        \\  movl %eax, %ebx
        \\  shll $12, %ebx
        \\
        \\  movl bpt, %ecx
        \\  orl %ebx, %ecx
        \\  movl %ecx, bpt
        \\
        \\  movl %eax, %ebx
        \\  shrl $20, %ebx
        \\
        \\  movl bpt + 0x4, %ecx
        \\  orl %ebx, %ecx
        \\  movl %ecx, bpt + 0x4
        \\
        \\  movl $bpt, %eax
        \\  movq %rax, %cr3
        ::: "eax", "ebx", "ecx");

    (CR0{ .PE = true, .WP = true, .PG = true }).set();
}
