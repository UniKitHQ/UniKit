// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

const config = @import("config");

const CPUID = @import("cpu.zig").CPUID;
const CPUID_VERSION_FEATURE = @import("cpu.zig").CPUID_VERSION_FEATURE;

const CR0 = @import("cpu.zig").CR0;
const CR4 = @import("cpu.zig").CR4;
const XCR0 = @import("cpu.zig").XCR0;

pub fn enable() void {
    if (config.x86_64.sse) {
        (CR0{ .MP = true, .NE = true }).set();
        (CR0{ .EM = true, .TS = true }).unset();
        (CR4{ .OSFXSR = true, .OSXMMEXCPT = true }).set();

        const ctx = CPUID(CPUID_VERSION_FEATURE);

        if (ctx.testFlags(.ecx, .{ .XSAVE = true })) {
            (CR4{ .OSXSAVE = true }).set();

            // implement set xcr0
            var xcr0 = XCR0.get();
            xcr0.X87 = true;
            xcr0.SSE = true;
            xcr0.reset();
        }
    }
}
