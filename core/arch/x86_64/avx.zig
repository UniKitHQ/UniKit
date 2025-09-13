// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

const config = @import("config");

const CPUID = @import("cpu.zig").CPUID;
const CPUID_VERSION_FEATURE = @import("cpu.zig").CPUID_VERSION_FEATURE;
const CPUID_EXTENDED_FEATURE = @import("cpu.zig").CPUID_EXTENDED_FEATURE;

const CR4 = @import("cpu.zig").CR4;
const XCR0 = @import("cpu.zig").XCR0;

pub fn enable() void {
    if (config.x86_64.avx) {
        const ctx = CPUID(CPUID_VERSION_FEATURE);

        if (ctx.testFlags(.ecx, .{ .AVX = true })) {
            var xcr0 = XCR0.get();

            xcr0.AVX = true;

            if (CPUID(CPUID_EXTENDED_FEATURE).testFlags(.ebx, .{ .AVX512F = true })) {
                xcr0.OPMASK = true;
                xcr0.ZMM_HI256 = true;
                xcr0.HI16_ZMM = true;
            }

            xcr0.reset();
        }
    }
}
