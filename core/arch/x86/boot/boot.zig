// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

const cpu = @import("../cpu.zig");
const CR0 = cpu.CR0;
const CR3 = cpu.CR3;
const CR4 = cpu.CR4;
// const XCR0 = cpu.XCR0;
const EFER = cpu.EFER;
// const MSR = cpu.MSR;
// const CPUID = cpu.CPUID;
// const CPUID_VERSION_FEATURE = cpu.CPUID_VERSION_FEATURE;
// const CPUID_EXTENDED_FEATURE = cpu.CPUID_EXTENDED_FEATURE;

const SSE = @import("../sse.zig");

const paging = @import("../memory/paging.zig");
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
    .pml4 = PageTable.create(PML4E, &[_]PML4E{
        .{
            .p = true,
            .rw = .writeable,
            .address = 0x00,
        },
    }),
    .pdpte = PageTable.create(PDPTE_1GB, &PageTable.fill(PDPTE_1GB, .{
        .p = true,
        .rw = .writeable,
        .address = 0x00,
    }, 4)),
};

const gdt = @import("../memory/gdt.zig");
const GDTR = gdt.GDTR;
const SegmentDescriptor = gdt.SegmentDescriptor;
const SegmentSelector = gdt.SegmentSelector;

export const gdt64 = [_]SegmentDescriptor{
    SegmentDescriptor.NULL,
    SegmentDescriptor.createCodeSegment(.{ .dpl = 0 }),
    SegmentDescriptor.createDataSegment(.{ .dpl = 0 }),
};

/// 32-bit boot entry function
/// @param edi      Address of the protocol dependent boot function
/// @param esi      Address of the boot information structure
///
/// Assume that:
/// - 32-bit protected mode
/// - Paging disabled
/// - A20 gate enabled
/// - GDT with descriptor for 4GB flat CS and DS segments (must have R/E, R/W permissions)
/// - Interrupts disabled
///
export fn boot32() callconv(.naked) noreturn {
    // Only inline assembly and comptime inline function calls are permitted
    // Any other operations result in undefined behavior

    // Set up page table entry address, CR3 and GDT

    // bpt.pml4[0] |= &bpt.pdpte; (&bpt.pdpte == &bpt + 0x1000)
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

    // Uses reset() only for 32-bit code
    (CR4{ .PAE = true }).reset();
    (EFER{ .LME = true }).reset();
    (CR0{
        .PE = true,
        .WP = true,
        .PG = true,
    }).reset();

    GDTR.set32(&gdt64);

    SegmentSelector.CS.set(.{ .index = 0x01 });
    SegmentSelector.DS.set(.{ .index = 0x02 });
    SegmentSelector.SS.set(.{ .index = 0x02 });
    SegmentSelector.ES.set(.{ .index = 0x02 });

    asm volatile ("call boot64");
}

/// 64-bit boot entry function
/// @param rdi       Address of the protocol dependent boot function
/// @param rsi       Address of the boot information structure
///
/// Assume that
/// - 64-bit long mode
/// - Paging enabled with identity mapped paging
/// - GDT with descriptor for flat CS and DS segments (must have R/E, R/W permissions)
/// - Interrupts disabled
///
export fn boot64() noreturn {
    asm volatile (
        \\  push %rdi
        \\  push %rsi
    );

    SSE.enable();

    // const ctx = CPUID(CPUID_VERSION_FEATURE);

    // if (ctx.testFlags(.ecx, .{ .XSAVE = true })) {
    //     var cr4 = CR4.get();
    //     cr4.OSXSAVE = true;
    //     cr4.reset();

    //     if (ctx.testFlags(.ecx, .{ .AVX = true })) {
    //         var xcr0 = XCR0.get();

    //         xcr0.X87 = true;
    //         xcr0.SSE = true;
    //         xcr0.AVX = true;

    //         if (CPUID(CPUID_EXTENDED_FEATURE).testFlags(.ebx, .{ .AVX512F = true })) {
    //             xcr0.OPMASK = true;
    //             xcr0.ZMM_HI256 = true;
    //             xcr0.HI16_ZMM = true;
    //         }

    //         xcr0.reset();
    //     }
    // }

    asm volatile (
        \\  pop %rsi
        \\  pop %rdi
        \\  call *%rdi
    );

    while (true) asm volatile (
        \\  cli
        \\  hlt
    );
}
