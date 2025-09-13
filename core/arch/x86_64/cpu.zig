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

    pub inline fn get() CR0 {
        return asm volatile ("movq %%cr0, %[i]"
            : [i] "=r" (-> CR0),
        );
    }

    pub inline fn set(self: CR0) void {
        asm volatile (
            \\  movq %%cr0, %%rax
            \\  orq %[i], %%rax
            \\  movq %%rax, %%cr0
            :
            : [i] "r" (self),
            : "rax"
        );
    }

    pub inline fn unset(self: CR0) void {
        asm volatile (
            \\  movq %%cr0, %%rax
            \\  notq %[i]
            \\  andq %[i], %%rax
            \\  movq %%rax, %%cr0
            :
            : [i] "r" (self),
            : "rax"
        );
    }

    pub inline fn reset(self: CR0) void {
        asm volatile ("movq %[i], %%cr0"
            :
            : [i] "r" (self),
        );
    }
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

    pub inline fn reset(self: CR3) void {
        asm volatile ("movq %[i], %%cr3"
            :
            : [i] "r" (self),
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

    pub inline fn get() CR4 {
        return asm volatile ("movq %%cr4, %[i]"
            : [i] "=r" (-> CR4),
        );
    }

    pub inline fn set(self: CR4) void {
        asm volatile (
            \\  movq %%cr4, %%rax
            \\  orq %[i], %%rax
            \\  movq %%rax, %%cr4
            :
            : [i] "r" (self),
            : "rax"
        );
    }

    pub inline fn unset(self: CR4) void {
        asm volatile (
            \\  movq %%cr4, %%rax
            \\  notq %[i]
            \\  andq %[i], %%rax
            \\  movq %%rax, %%cr4
            :
            : [i] "r" (self),
            : "rax"
        );
    }

    pub inline fn reset(self: CR4) void {
        asm volatile ("movq %[i], %%cr4"
            :
            : [i] "r" (self),
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

    pub inline fn get() XCR0 {
        return asm volatile (
            \\ xor %rcx, %rcx
            \\ xgetbv
            : [_] "={eax}" (-> XCR0),
            :
            : "ecx", "edx"
        );
    }

    pub inline fn reset(self: XCR0) void {
        asm volatile (
            \\ xor %rcx, %rcx
            \\ xsetbv
            :
            : [_] "{eax}" (self),
            : "ecx", "edx"
        );
    }
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

    pub inline fn reset(self: MSR, msr: u64) void {
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

    pub inline fn reset(self: EFER) void {
        MSR.EFER.reset(@as(u64, @bitCast(self)));
    }
};

pub inline fn CPUID(T: type) CPUID_CTX(T) {
    var eax: T.EAX = undefined;
    var ebx: T.EBX = undefined;
    var ecx: T.ECX = undefined;
    var edx: T.EDX = undefined;

    asm volatile ("cpuid"
        : [_] "={eax}" (eax),
          [_] "={ebx}" (ebx),
          [_] "={ecx}" (ecx),
          [_] "={edx}" (edx),
        : [_] "{eax}" (T.CODE),
          [_] "{ecx}" (T.LEAF),
    );

    return CPUID_CTX(T){
        .ctx = .{
            .eax = eax,
            .ebx = ebx,
            .ecx = ecx,
            .edx = edx,
        },
    };
}

pub fn CPUID_CTX(comptime T: type) type {
    return struct {
        ctx: struct {
            eax: T.EAX,
            ebx: T.EBX,
            ecx: T.ECX,
            edx: T.EDX,
        },

        inline fn bitTest(a: anytype, b: anytype) bool {
            return (@as(u32, @bitCast(a)) & @as(u32, @bitCast(b))) != 0;
        }

        pub inline fn testFlags(
            self: CPUID_CTX(T),
            comptime register: enum { eax, ebx, ecx, edx },
            flag: if (register == .eax) T.EAX else if (register == .ebx) T.EBX else if (register == .ecx) T.ECX else T.EDX,
        ) bool {
            return switch (register) {
                .eax => bitTest(self.ctx.eax, flag),
                .ebx => bitTest(self.ctx.ebx, flag),
                .ecx => bitTest(self.ctx.ecx, flag),
                .edx => bitTest(self.ctx.edx, flag),
            };
        }
    };
}

pub const CPUID_VERSION_FEATURE = struct {
    pub const CODE = 0x00000001;
    pub const LEAF = 0x00000000;

    pub const EAX = u32;
    pub const EBX = u32;
    pub const ECX = packed struct(u32) {
        SSE3: bool = false,
        PCLMULQDQ: bool = false,
        DTES64: bool = false,
        MONITOR: bool = false,
        DS_CPL: bool = false,
        VMX: bool = false,
        SMX: bool = false,
        EIST: bool = false,
        TM2: bool = false,
        SSSE3: bool = false,
        CNXT_ID: bool = false,
        SDBG: bool = false,
        FMA: bool = false,
        CMPXCHG16B: bool = false,
        XTPR_UPDATE_CONTROL: bool = false,
        PDCM: bool = false,
        _0: u1 = 0x00,
        PCID: bool = false,
        DCA: bool = false,
        SSE4_1: bool = false,
        SSE4_2: bool = false,
        X2APIC: bool = false,
        MOVBE: bool = false,
        POPCNT: bool = false,
        TSC_DEADLINE: bool = false,
        AES: bool = false,
        XSAVE: bool = false,
        OSXSAVE: bool = false,
        AVX: bool = false,
        F16C: bool = false,
        RDRAND: bool = false,
        _1: u1 = 0x00,
    };
    pub const EDX = packed struct(u32) {
        FPU: bool = false,
        VME: bool = false,
        DE: bool = false,
        PSE: bool = false,
        TSC: bool = false,
        MSR: bool = false,
        PAE: bool = false,
        MCE: bool = false,
        CX8: bool = false,
        APIC: bool = false,
        _0: u1 = 0x00,
        SEP: bool = false,
        MTRR: bool = false,
        PGE: bool = false,
        MCA: bool = false,
        CMOV: bool = false,
        PAT: bool = false,
        PSE_36: bool = false,
        PSN: bool = false,
        CLFSH: bool = false,
        _1: u1 = 0x00,
        DS: bool = false,
        ACPI: bool = false,
        MMX: bool = false,
        FXSR: bool = false,
        SSE: bool = false,
        SSE2: bool = false,
        SS: bool = false,
        HTT: bool = false,
        TM: bool = false,
        _2: u1 = 0x00,
        PBE: bool = false,
    };
};

pub const CPUID_EXTENDED_FEATURE = struct {
    pub const CODE = 0x00000007;
    pub const LEAF = 0x00000000;

    pub const EAX = u32;
    pub const EBX = packed struct(u32) {
        FSGSBASE: bool = false,
        IA32_TSC_ADJUST: bool = false,
        SGX: bool = false,
        BMI1: bool = false,
        HLE: bool = false,
        AVX2: bool = false,
        FDP_EXCPTN_ONLY: bool = false,
        SMEP: bool = false,
        BMI2: bool = false,
        ERMS: bool = false,
        INVPCID: bool = false,
        RTM: bool = false,
        RDT_M: bool = false,
        IGNORE_FPU_SEGMENT: bool = false,
        MPX: bool = false,
        RDT_A: bool = false,
        AVX512F: bool = false,
        AVX512DQ: bool = false,
        RDSEED: bool = false,
        ADX: bool = false,
        SMAP: bool = false,
        AVX512_IFMA: bool = false,
        _0: u1 = 0x00,
        CLFLUSHOPT: bool = false,
        CLWB: bool = false,
        INTEL_PT: bool = false,
        AVX512PF: bool = false,
        AVX512ER: bool = false,
        AVX512CD: bool = false,
        SHA: bool = false,
        AVX512BW: bool = false,
        AVX512VL: bool = false,
    };
    pub const ECX = u32;
    pub const EDX = u32;
};
