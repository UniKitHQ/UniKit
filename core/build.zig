const std = @import("std");

pub fn build(b: *std.Build, target: std.Build.ResolvedTarget, config: *std.Build.Step.Options) !void {
    const core = b.addObject(.{
        .name = "core",
        .root_module = b.addModule("core", .{
            .root_source_file = b.path("core/main.zig"),
            .target = target,
        }),
    });

    core.root_module.addImport("config", config.createModule());

    const unikit = b.addExecutable(.{
        .name = "unikit",
        .target = target,
    });

    unikit.addObject(core);
    unikit.entry = .{ .symbol_name = "_multiboot_entry" };
    unikit.setLinkerScript(b.path("core/link.x"));

    // TODO: Contribute to Zig's objcopy to support output target option
    const elf64_2_32 = b.addSystemCommand(&[_][]const u8{
        "llvm-objcopy",
        "--output-target=elf32-i386",
        b.getInstallPath(.bin, unikit.out_filename),
        b.getInstallPath(.bin, unikit.out_filename),
    });
    elf64_2_32.step.dependOn(&b.addInstallArtifact(unikit, .{
        .dest_dir = .default,
        .dest_sub_path = unikit.out_filename,
    }).step);

    b.getInstallStep().dependOn(&elf64_2_32.step);

    const debug = b.option(bool, "debug", "Enable debug flag for qemu") orelse false;
    const qemu = b.addSystemCommand(&([_][]const u8{
        "qemu-system-x86_64",
        "-nographic",
        "-kernel",
        b.getInstallPath(.bin, unikit.out_filename),
        "-initrd",
        b.getInstallPath(.bin, unikit.out_filename),
        if (debug) "-s" else "",
        if (debug) "-S" else "",
    }));
    qemu.step.dependOn(&elf64_2_32.step);
    b.step("run", "Run the kernel").dependOn(&qemu.step);
}
