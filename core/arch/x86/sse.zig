// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

const CR0 = @import("cpu.zig").CR0;
const CR4 = @import("cpu.zig").CR4;

pub fn enable() void {
    (CR0{
        .MP = true,
        .NE = true,
    }).set();
    (CR0{
        .EM = true,
        .TS = true,
    }).unset();
    (CR4{
        .OSFXSR = true,
        .OSXMMEXCPT = true,
    }).set();
}
