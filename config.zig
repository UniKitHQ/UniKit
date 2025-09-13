const std = @import("std");

pub const x86_64 = struct {
    /// Enable SSE and allow further SIMD optimizations.
    sse: bool = true,

    /// Enable AVX.
    avx: bool = true,

    pub fn get(self: x86_64, b: *std.Build) *std.Build.Step.Options {
        const options = b.addOptions();

        options.addOption(x86_64, "x86_64", self);

        return options;
    }
};
