// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

pub const RFLAGS = packed struct(u64) {
    /// Carry Flag
    CF: bool = false,
    _0: u1 = 0x00,
    /// Parity Flag
    PF: bool = false,
    _1: u1 = 0x00,
    /// Auxiliary Carry Flag
    AF: bool = false,
    _2: u1 = 0x00,
    /// Zero Flag
    ZF: bool = false,
    /// Sign Flag
    SF: bool = false,
    /// Trap Flag
    TF: bool = false,
    /// Interrupt Enable Flag
    IF: bool = false,
    /// Direction Flag
    DF: bool = false,
    /// Overflow Flag
    OF: bool = false,
    /// I/O Privilege Level
    IOPL: u2 = 0x00,
    /// Nested Task
    NT: bool = false,
    _3: u1 = 0x00,
    /// Resume Flag
    RF: bool = false,
    /// Virtual-8086 Mode
    VM: bool = false,
    /// Alignment Check / Access Control
    AC: bool = false,
    /// Virtual Interrupt Flag
    VIF: bool = false,
    /// Virtual Interrupt Pending
    VIP: bool = false,
    /// ID flag
    ID: bool = false,
    _4: u42 = 0x00,
};

pub const CR0 = packed struct(u64) {
    /// Protected Mode Enable
    PE: bool = false,
    /// Monitor Co-Processor
    MP: bool = false,
    /// Emulation
    EM: bool = false,
    /// Task Switched
    TS: bool = false,
    /// Extension Type
    ET: bool = false,
    /// Numeric Error
    NE: bool = false,
    _0: u10 = 0x00,
    /// Write Protect
    WP: bool = false,
    _1: u1 = 0x00,
    /// Alignment Mask
    AM: bool = false,
    _2: u10 = 0x00,
    /// Not Write-Through
    NW: bool = false,
    /// Cache Disable
    CD: bool = false,
    /// Paging
    PG: bool = false,
    _3: u32 = 0x00,
};

pub const CR3 = packed union {
    default: packed struct(u64) {
        _0: u3 = 0x00,
        /// Page-level Write-Through
        PWT: bool = false,
        /// Page-level Cache Disable
        PCD: bool = false,
        _1: u7 = 0x00,
        /// Page-Directory base
        PDB: u52 = 0x00,
    },

    pcid_enabled: packed struct(u64) {
        /// Process-Context Identifier
        PCID: u12 = 0x00,
        /// Page-Directory base
        PDB: u52 = 0x00,
    },

    pub inline fn set(self: CR3) void {
        asm volatile ("movq %[i], %%cr3"
            :
            : [i] "{rax}" (self),
        );
    }
};

pub const CR4 = packed struct(u64) {
    /// Virtual-8086 Mode Extensions
    VME: bool = false,
    /// Protected-Mode Virtual Interrupts
    PVI: bool = false,
    /// Time Stamp Disable
    TSD: bool = false,
    /// Debugging Extensions
    DE: bool = false,
    /// Page Size Extensions
    PSE: bool = false,
    /// Physical Address Extension
    PAE: bool = false,
    /// Machine-Check Enable
    MCE: bool = false,
    /// Page Global Enable
    PGE: bool = false,
    /// Performance-Monitoring Counter Enable
    PCE: bool = false,
    /// Operating System Support for FXSAVE and FXRSTOR instructions
    OSFXSR: bool = false,
    /// Operating System Support for Unmasked SIMD Floating-Point Exceptions
    OSXMMEXCPT: bool = false,
    /// User-Mode Instruction Prevention
    UMIP: bool = false,
    /// 57-bit linear addresses
    LA57: bool = false,
    /// VMX-Enable Bit (Intel VMX)
    VMXE: bool = false,
    /// SMX-Enable Bit (Intel SMX)
    SMXE: bool = false,
    _0: u1 = 0x00,
    /// FSGSBASE-Enable Bit
    FSGSBASE: bool = false,
    /// PCID-Enable Bit
    PCIDE: bool = false,
    /// XSAVE and Processor Extended States-Enable Bit
    OSXSAVE: bool = false,
    /// Key-Locker-Enable Bit (Intel Key Locker)
    KL: bool = false,
    /// SMEP-Enable Bit
    SMEP: bool = false,
    /// SMAP-Enable Bit
    SMAP: bool = false,
    /// Enable protection keys for user-mode pages
    PKE: bool = false,
    /// Control-flow Enforcement Technology
    CET: bool = false,
    /// Enable protection keys for supervisor-mode pages (Intel MPK)
    PKS: bool = false,
    /// User Interrupts Enable Bit (Intel)
    UINTR: bool = false,
    _4: u38 = 0x00,

    pub inline fn set(self: CR4) void {
        asm volatile ("movq %[i], %%cr4"
            :
            : [i] "{rax}" (self),
        );
    }
};

pub const CR8 = packed struct(u64) {
    /// Task Priority Level
    TPL: u4 = 0x00,
    _: u60 = 0x00,
};

pub const XCR0 = packed struct(u64) {
    /// This bit 0 must be 1. An attempt to write 0 to this bit causes a #GP exception.
    X87: bool = false,
    /// If 1, the XSAVE feature set can be used to manage MXCSR and the XMM registers (XMM0-XMM15 in 64-bit mode; otherwise XMM0-XMM7).
    SSE: bool = false,
    /// If 1, Intel AVX instructions can be executed and the XSAVE feature set can be used to manage the upper halves of the YMM registers (YMM0-YMM15 in 64-bit mode; otherwise YMM0-YMM7).
    AVX: bool = false,
    /// If 1, Intel MPX instructions can be executed and the XSAVE feature set can be used to manage the bounds registers BND0–BND3.
    BNDREG: bool = false,
    /// If 1, Intel MPX instructions can be executed and the XSAVE feature set can be used to manage the BNDCFGU and BNDSTATUS registers.
    BNDCSR: bool = false,
    /// If 1, Intel AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the opmask registers k0–k7.
    OPMASK: bool = false,
    /// If 1, Intel AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the upper halves of the lower ZMM registers (ZMM0-ZMM15 in 64-bit mode; otherwise ZMM0-ZMM7).
    ZMM_HI256: bool = false,
    /// If 1, Intel AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the upper ZMM registers (ZMM16-ZMM31, only in 64-bit mode).
    HI16_ZMM: bool = false,
    _0: u1 = 0x00,
    /// If 1, the XSAVE feature set can be used to manage the PKRU register (see Section 2.7).
    PKRU: bool = false,
    _1: u7 = 0x00,
    /// If 1, and if XCR0.TILEDATA is also 1, Intel AMX instructions can be executed and the XSAVE feature set can be used to manage TILECFG.
    TILECFG: bool = false,
    /// If 1, and if XCR0.TILECFG is also 1, Intel AMX instructions can be executed and the XSAVE feature set can be used to manage TILEDATA.
    TILEDATA: bool = false,
    _2: u45 = 0x00,
};

pub const MSR = enum(u64) {
    /// Extended Feature Enables
    EFER = 0xC0000080,
    /// System Call Target Address
    STAR = 0xC0000081,
    /// Long Mode SYSCALL Target
    LSTAR = 0xC0000082,
    /// System Call Flag Mask
    SFMASK = 0xC0000084,
    /// Page Attribute Table
    PAT = 0x277,

    pub inline fn set(self: MSR, msr: u64) void {
        asm volatile ("wrmsr"
            :
            : [_] "{ecx}" (self),
              [_] "{eax}" (@as(u32, @truncate(msr))),
              [_] "{edx}" (@as(u32, @truncate(msr >> 32))),
        );
    }
};

pub const EFER = packed struct(u64) {
    /// SYSCALL Enable
    SCE: bool = false,
    _0: u7 = 0x00,
    /// Long Mode Enable
    LME: bool = false,
    _1: u1 = 0x00,
    /// Long Mode Active
    LMA: bool = false,
    /// No-Execute Enable
    NXE: bool = false,
    /// Secure Virtual Machine Enable (AMD-V)
    SVME: bool = false,
    /// Long Mode Segment Limit Enable (AMD)
    LMSLE: bool = false,
    /// Fast FXSAVE/FXRSTOR (AMD)
    FFXSR: bool = false,
    /// Translation Cache Extension (AMD)
    TCE: bool = false,
    /// Enable MCOMMIT instruction (AMD)
    MCOMMIT: bool = false,
    /// Interruptible WBINVD/WBNOINVD enable (AMD)
    INTWB: bool = false,
    /// Upper Address Ignore Enable (AMD)
    UAIE: bool = false,
    /// Automatic IBRS Enable (AMD)
    AIBRSE: bool = false,

    _2: u44 = 0x00,

    pub inline fn set(self: EFER) void {
        MSR.EFER.set(@as(u64, @bitCast(self)));
    }
};

pub const GDTR = packed struct(u80) {
    size: u16,
    ptr: u64,
};

pub const SegmentDescriptor = packed struct(u64) {
    /// Low 16 bit of limit value
    limit_low: u16 = 0x00,
    /// Low 24 bit of base address
    base_low: u24 = 0x00,
    /// Segment type
    type: packed struct(u4) {
        /// Accessed
        a: bool,
        /// Writeable / Readable
        wr: bool,
        /// Expand down / Conforming
        ec: bool,
        /// Type
        type: enum(u1) {
            data = 0,
            code = 1,
        },
    } = .{ .a = false, .wr = false, .ec = false, .type = .data },
    /// Descriptor type
    s: enum(u1) {
        system = 0,
        code_data = 1,
    } = .system,
    /// Descriptor privilege level
    dpl: u2 = 0x00,
    /// Present
    p: bool = true,
    /// High 4 bit of limit value
    limit_high: u4 = 0x00,
    /// Available for use
    avl: bool = false,
    /// 64-bit code segment
    l: bool = false,
    /// Default operation size (0 = 16-bit, 1 = 32-bit)
    /// Must be cleared for 64-bit code segments,
    db: enum(u1) {
        bit_16 = 0,
        bit_32 = 1,
    } = .bit_16,
    /// Granularity (0 = limit, 1 = limit * 4KB)
    g: enum(u1) {
        limit = 0,
        limit_4k = 1,
    } = .limit,
    /// High 8 bit of base address
    base_high: u8 = 0x00,

    pub fn init(
        comptime limit: u20,
        comptime base: u32,
        comptime value: ?SegmentDescriptor,
    ) SegmentDescriptor {
        return if (value) .{
            .limit_low = @truncate(limit),
            .base_low = @truncate(base),
            .type = value.type,
            .s = value.s,
            .dpl = value.dpl,
            .p = value.p,
            .limit_high = @truncate(limit >> 16),
            .avl = value.avl,
            .l = value.l,
            .db = value.db,
            .g = value.g,
            .base_high = @truncate(base >> 24),
        } else @import("std").mem.zeroes(SegmentDescriptor);
    }
};
