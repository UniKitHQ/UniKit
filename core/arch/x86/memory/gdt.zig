// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

pub const SegmentSelector = packed struct(u16) {
    rpl: u2 = 0x00,
    ti: u1 = 0x00,
    index: u13,

    pub const CS = struct {
        // Available for 32-bit code only
        pub inline fn set(self: SegmentSelector) void {
            asm volatile (
                \\  .code32
                \\  ljmp %[i], $wrap_up
                \\
                \\  .code64
                \\  wrap_up:
                :
                : [i] "i" (@as(u16, @bitCast(self))),
            );
        }
    };

    inline fn Selector(comptime register: []const u8) type {
        return struct {
            pub inline fn set(self: SegmentSelector) void {
                asm volatile ("mov %[i], %%" ++ register
                    :
                    : [i] "r" (self),
                );
            }
        };
    }

    pub const DS = Selector("ds");
    pub const SS = Selector("ss");
    pub const ES = Selector("es");
    pub const FS = Selector("fs");
    pub const GS = Selector("gs");
};

pub const GDTR = packed struct(u80) {
    size: u16,
    ptr: u64,

    pub inline fn create(gdt: GDT) GDTR {
        return .{
            .size = @truncate(gdt.len - 1),
            .ptr = @intFromPtr(gdt.ptr),
        };
    }

    pub inline fn set(self: GDTR) void {
        asm volatile ("lgdt %[i]"
            :
            : [i] "m" (self),
        );
    }

    pub inline fn set32(gdt: GDT) void {
        asm volatile (
            \\  .code32
            \\  pushl $0x00
            \\  pushl %[j]
            \\  pushw %[i]
            \\  lgdt (%esp)
            \\  addl $0x0C, %esp
            :
            : [i] "{eax}" (@as(u16, @truncate((gdt.len * 0x08) - 1))),
              [j] "{ebx}" (@as(u32, @truncate(@intFromPtr(gdt.ptr)))),
        );
    }
};

pub const GDT = []const SegmentDescriptor;

pub const SegmentAccessByte = packed struct(u8) {
    pub const SegmentType = enum(u1) {
        code = 1,
        data = 0,
    };

    /// Segment type
    type: packed union {
        code: packed struct(u4) {
            /// Accessed
            accessed: bool,
            /// Readable
            readable: bool,
            /// Conforming
            conforming: bool,
            /// Type
            type: SegmentType = .code,
        },
        data: packed struct(u4) {
            /// Accessed
            accessed: bool,
            /// Writeable
            writable: bool,
            /// Expand down
            expand_down: bool,
            /// Type
            type: SegmentType = .data,
        },
    },

    /// Descriptor type
    descriptor_type: enum(u1) {
        system = 0,
        code_data = 1,
    },

    /// Descriptor privilege level
    privilege_level: u2,

    /// Present
    present: bool = true,

    pub const NULL = SegmentAccessByte{
        .type = .{ .data = .{ .accessed = false, .writable = false, .expand_down = false } },
        .descriptor_type = .system,
        .privilege_level = 0x00,
        .present = false,
    };
};

pub const SegmentFlags = packed struct(u4) {
    _: u1 = 0x00,

    /// 64-bit code segment
    long_mode: bool,

    /// Default operation size (0 = 16-bit, 1 = 32-bit)
    /// Must be cleared for 64-bit code segments,
    operation_size: enum(u1) {
        bit_16 = 0,
        bit_32 = 1,
    },

    /// Granularity (0 = limit, 1 = limit * 4KB)
    granularity: enum(u1) {
        limit = 0,
        limit_4k = 1,
    },

    pub const NULL = SegmentFlags{
        .long_mode = false,
        .operation_size = .bit_16,
        .granularity = .limit,
    };
};

pub const SegmentDescriptor = packed struct(u64) {
    /// Low 16 bit of limit value
    limit_low: u16,
    /// Low 24 bit of base address
    base_low: u24,
    /// Access byte
    access_byte: SegmentAccessByte,
    /// High 4 bit of limit value
    limit_high: u4,
    /// flags
    flags: SegmentFlags,
    /// High 8 bit of base address
    base_high: u8,

    pub fn create(
        limit: u20,
        base: u32,
        access_byte: ?SegmentAccessByte,
        flags: ?SegmentFlags,
    ) SegmentDescriptor {
        return .{
            .limit_low = @truncate(limit),
            .base_low = @truncate(base),
            .access_byte = access_byte orelse SegmentAccessByte.NULL,
            .limit_high = @truncate(limit >> 16),
            .flags = flags orelse SegmentFlags.NULL,
            .base_high = @truncate(base >> 24),
        };
    }

    pub const NULL = SegmentDescriptor.create(0x0000, 0x0000, null, null);

    pub fn createCodeSegment(comptime options: struct { dpl: u2 }) SegmentDescriptor {
        return SegmentDescriptor.create(0xFFFFF, 0x0000, .{
            .type = .{ .code = .{ .accessed = false, .readable = true, .conforming = false } },
            .descriptor_type = .code_data,
            .privilege_level = options.dpl,
        }, .{
            .long_mode = true,
            .operation_size = .bit_16,
            .granularity = .limit_4k,
        });
    }

    pub fn createDataSegment(comptime options: struct { dpl: u2 }) SegmentDescriptor {
        return SegmentDescriptor.create(0xFFFFF, 0x0000, .{
            .type = .{ .data = .{ .accessed = false, .writable = true, .expand_down = false } },
            .descriptor_type = .code_data,
            .privilege_level = options.dpl,
        }, .{
            .long_mode = false,
            .operation_size = .bit_32,
            .granularity = .limit_4k,
        });
    }
};
