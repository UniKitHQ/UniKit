// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

const cpu = @import("../cpu.zig");

const SegmentDescriptor = cpu.SegmentDescriptor;
const CR4 = cpu.CR4;
const EFER = cpu.EFER;
const MSR = cpu.MSR;

const gdt64 = [_]SegmentDescriptor{
    SegmentDescriptor.init(0, 0, @import("std").mem.zeroes(SegmentDescriptor)),
    SegmentDescriptor.init(0xFFFFF, 0x0000, .{
        .type = .{ .type = .code, .ec = false, .wr = true, .a = true },
        .s = .code_data,
        .dpl = 0,
        .p = true,
        .l = false,
        .db = .bit_32,
        .g = .limit_4k,
    }),
    SegmentDescriptor.init(0xFFFFF, 0x0000, .{
        .type = .{ .type = .code, .ec = false, .wr = true, .a = true },
        .s = .code_data,
        .dpl = 0,
        .p = true,
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
    cpu.setCR4(.{ .PAE = true });
    cpu.setMSR(.EFER, .{ .LME = true });
}
