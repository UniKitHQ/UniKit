pub const RFLAGS = packed struct(u64) {
    /// Carry Flag
    CF: bool,
    _0: u1 = 0x00,
    /// Parity Flag
    PF: bool,
    _1: u1 = 0x00,
    /// Auxiliary Carry Flag
    AF: bool,
    _2: u1 = 0x00,
    /// Zero Flag
    ZF: bool,
    /// Sign Flag
    SF: bool,
    /// Trap Flag
    TF: bool,
    /// Interrupt Enable Flag
    IF: bool,
    /// Direction Flag
    DF: bool,
    /// Overflow Flag
    OF: bool,
    /// I/O Privilege Level
    IOPL: u2,
    /// Nested Task
    NT: bool,
    _3: u1 = 0x00,
    /// Resume Flag
    RF: bool,
    /// Virtual-8086 Mode
    VM: bool,
    /// Alignment Check / Access Control
    AC: bool,
    /// Virtual Interrupt Flag
    VIF: bool,
    /// Virtual Interrupt Pending
    VIP: bool,
    /// ID flag
    ID: bool,
    _4: u42 = 0x00,
};

pub const CR0 = packed struct(u64) {
    /// Protected Mode Enable
    PE: bool,
    /// Monitor Co-Processor
    MP: bool,
    /// Emulation
    EM: bool,
    /// Task Switched
    TS: bool,
    /// Extension Type
    ET: bool,
    /// Numeric Error
    NE: bool,
    _0: u10 = 0x00,
    /// Write Protect
    WP: bool,
    _1: u1 = 0x00,
    /// Alignment Mask
    AM: bool,
    _2: u10 = 0x00,
    /// Not Write-Through
    NW: bool,
    /// Cache Disable
    CD: bool,
    /// Paging
    PG: bool,
    _3: u32 = 0x00,
};

pub const CR3 = packed union {
    default: packed struct(u64) {
        _0: u3 = 0x00,
        /// Page-level Write-Through
        PWT: bool,
        /// Page-level Cache Disable
        PCD: bool,
        _1: u7 = 0x00,
        /// Page-Directory base
        PDB: u52,
    },

    pcid_enabled: packed struct(u64) {
        /// Process-Context Identifier
        PCID: u12,
        /// Page-Directory base
        PDB: u52,
    },
};

pub const CR4 = packed struct(u64) {
    /// Virtual-8086 Mode Extensions
    VME: bool,
    /// Protected-Mode Virtual Interrupts
    PVI: bool,
    /// Time Stamp Disable
    TSD: bool,
    /// Debugging Extensions
    DE: bool,
    /// Page Size Extensions
    PSE: bool,
    /// Physical Address Extension
    PAE: bool,
    /// Machine-Check Enable
    MCE: bool,
    /// Page Global Enable
    PGE: bool,
    /// Performance-Monitoring Counter Enable
    PCE: bool,
    /// Operating System Support for FXSAVE and FXRSTOR instructions
    OSFXSR: bool,
    /// Operating System Support for Unmasked SIMD Floating-Point Exceptions
    OSXMMEXCPT: bool,
    /// User-Mode Instruction Prevention
    UMIP: bool,
    /// 57-bit linear addresses
    LA57: bool,
    /// VMX-Enable Bit (Intel VMX)
    VMXE: bool,
    /// SMX-Enable Bit (Intel SMX)
    SMXE: bool,
    _0: u1 = 0x00,
    /// FSGSBASE-Enable Bit
    FSGSBASE: bool,
    /// PCID-Enable Bit
    PCIDE: bool,
    /// XSAVE and Processor Extended States-Enable Bit
    OSXSAVE: bool,
    /// Key-Locker-Enable Bit (Intel Key Locker)
    KL: bool,
    /// SMEP-Enable Bit
    SMEP: bool,
    /// SMAP-Enable Bit
    SMAP: bool,
    /// Enable protection keys for user-mode pages
    PKE: bool,
    /// Control-flow Enforcement Technology
    CET: bool,
    /// Enable protection keys for supervisor-mode pages (Intel MPK)
    PKS: bool,
    /// User Interrupts Enable Bit (Intel)
    UINTR: bool,
    _4: u38 = 0x00,
};

pub const CR8 = packed struct(u64) {
    /// Task Priority Level
    TPL: u4,
    _: u60 = 0x00,
};

pub const XCR0 = packed struct(u64) {
    /// This bit 0 must be 1. An attempt to write 0 to this bit causes a #GP exception.
    X87: bool,
    /// If 1, the XSAVE feature set can be used to manage MXCSR and the XMM registers (XMM0-XMM15 in 64-bit mode; otherwise XMM0-XMM7).
    SSE: bool,
    /// If 1, Intel AVX instructions can be executed and the XSAVE feature set can be used to manage the upper halves of the YMM registers (YMM0-YMM15 in 64-bit mode; otherwise YMM0-YMM7).
    AVX: bool,
    /// If 1, Intel MPX instructions can be executed and the XSAVE feature set can be used to manage the bounds registers BND0–BND3.
    BNDREG: bool,
    /// If 1, Intel MPX instructions can be executed and the XSAVE feature set can be used to manage the BNDCFGU and BNDSTATUS registers.
    BNDCSR: bool,
    /// If 1, Intel AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the opmask registers k0–k7.
    OPMASK: bool,
    /// If 1, Intel AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the upper halves of the lower ZMM registers (ZMM0-ZMM15 in 64-bit mode; otherwise ZMM0-ZMM7).
    ZMM_HI256: bool,
    /// If 1, Intel AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the upper ZMM registers (ZMM16-ZMM31, only in 64-bit mode).
    HI16_ZMM: bool,
    _0: u1 = 0x00,
    /// If 1, the XSAVE feature set can be used to manage the PKRU register (see Section 2.7).
    PKRU: bool,
    _1: u7 = 0x00,
    /// If 1, and if XCR0.TILEDATA is also 1, Intel AMX instructions can be executed and the XSAVE feature set can be used to manage TILECFG.
    TILECFG: bool,
    /// If 1, and if XCR0.TILECFG is also 1, Intel AMX instructions can be executed and the XSAVE feature set can be used to manage TILEDATA.
    TILEDATA: bool,
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
};

pub const EFER = packed struct(u64) {
    /// SYSCALL Enable
    SCE: bool,
    _0: u7 = 0x00,
    /// Long Mode Enable
    LME: bool,
    _1: u1 = 0x00,
    /// Long Mode Active
    LMA: bool,
    /// No-Execute Enable
    NXE: bool,
    /// Secure Virtual Machine Enable (AMD-V)
    SVME: bool,
    /// Long Mode Segment Limit Enable (AMD)
    LMSLE: bool,
    /// Fast FXSAVE/FXRSTOR (AMD)
    FFXSR: bool,
    /// Translation Cache Extension (AMD)
    TCE: bool,
    /// Enable MCOMMIT instruction (AMD)
    MCOMMIT: bool,
    /// Interruptible WBINVD/WBNOINVD enable (AMD)
    INTWB: bool,
    /// Upper Address Ignore Enable (AMD)
    UAIE: bool,
    /// Automatic IBRS Enable (AMD)
    AIBRSE: bool,

    _2: u44 = 0x00,
};

test {}
