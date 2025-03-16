const MultibootInfo = @import("multiboot.zig").MultibootInfo;

pub fn boot32(entry: *const fn () callconv(.C) noreturn, boot_stack: [*c]u8, boot_info: *anyopaque) noreturn {
    _ = entry;
    _ = boot_stack;
    _ = boot_info;
    unreachable;
}
