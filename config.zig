const std = @import("std");

pub const x86_64 = struct {
    /// Enable SSE and allow further SIMD optimizations.
    sse: bool = true,

    /// Enable AVX. (SSE)
    avx: bool = true,

    pub fn get(self: x86_64, b: *std.Build) *std.Build.Step.Options {
        const options = b.addOptions();

        if (self.avx) self.sse = true;

        options.addOption(x86_64, "x86_64", self);

        return options;
    }
};
