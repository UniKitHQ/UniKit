const std = @import("std");

pub fn build(b: *std.Build) void {
    const unikit = b.addExecutable(.{
        .name = "unikit",
        .root_source_file = b.path("core/arch/x86/boot/multiboot.zig"),
        .target = b.resolveTargetQuery(.{ .cpu_arch = .x86_64, .os_tag = .freestanding }),
    });

    unikit.entry = .{ .symbol_name = "_multiboot_entry" };

    // unikit.addAssemblyFile(b.path("core/arch/x86/boot/boot.S"));
    // unikit.addAssemblyFile(b.path("core/arch/x86/boot/multiboot/multiboot.S"));

    b.installArtifact(unikit);
}
