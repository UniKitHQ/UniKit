const std = @import("std");

const core = @import("core/build.zig");

const config = @import("config.zig");

pub fn build(b: *std.Build) !void {
    // const simd_feature_set = std.Target.x86.featureSet(&[_]std.Target.x86.Feature{
    //     .sse,
    //     .sse_unaligned_mem,
    //     .sse2,
    //     .sse3,
    //     .sse4_1,
    //     .sse4_2,
    //     .sse4a,
    //     .ssse3,
    //     .avx,
    //     .avx2,
    //     .avx512bf16,
    //     .avx512bitalg,
    //     .avx512bw,
    //     .avx512cd,
    //     .avx512dq,
    //     .avx512er,
    //     .avx512f,
    //     .avx512ifma,
    //     .avx512pf,
    //     .avx512vbmi,
    //     .avx512vbmi2,
    //     .avx512vl,
    //     .avx512vnni,
    //     .avx512vp2intersect,
    //     .avx512vpopcntdq,
    // });

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
        .abi = .none,

        // .cpu_features_add = std.Target.x86.featureSet(&[_]std.Target.x86.Feature{.soft_float}),
        // .cpu_features_sub = simd_feature_set,
    });

    var configs = config.x86_64{};

    try core.build(b, target, configs.get(b));
}
