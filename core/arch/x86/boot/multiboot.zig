// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

/// How many bytes from the start of the file we search for the header.
const MULTIBOOT_SEARCH = 8192;
/// Alignment of multiboot header.
const MULTIBOOT_HEADER_ALIGN = 4;

/// The magic field should contain this.
const MULTIBOOT_HEADER_MAGIC = 0x1BADB002;
/// This should be in %eax.
const MULTIBOOT_BOOTLOADER_MAGIC = 0x2BADB002;
/// Alignment of multiboot modules.
const MULTIBOOT_MOD_ALIGN = 0x00001000;
/// Alignment of the multiboot info structure.
const MULTIBOOT_INFO_ALIGN = 0x00000004;

pub const MultibootHeader = extern struct {
    /// Must be MULTIBOOT_MAGIC - see above.
    magic: u32,

    /// Feature flags.
    flags: packed struct(u32) {
        /// Align all boot modules on i386 page (4KB) boundaries.
        PAGE_ALIGN: bool = false,
        /// Must pass memory information to OS.
        MEMORY_INFO: bool = false,
        /// Must pass video information to OS.
        VIDEO_MODE: bool = false,

        _0: u13 = 0x00,

        /// This flag indicates the use of the address fields in the header.
        AOUT_KLUDGE: bool = false,

        _1: u15 = 0x00,
    },

    /// The above fields plus this one must equal 0 mod 2^32.
    checksum: u32 = 0x00,

    /// These are only valid if MULTIBOOT_AOUT_KLUDGE is set.
    header_addr: u32 = 0x00,
    load_addr: u32 = 0x00,
    load_end_addr: u32 = 0x00,
    bss_end_addr: u32 = 0x00,
    entry_addr: u32 = 0x00,

    /// These are only valid if MULTIBOOT_VIDEO_MODE is set.
    mode_type: u32 = 0x00,
    width: u32 = 0x00,
    height: u32 = 0x00,
    depth: u32 = 0x00,

    pub fn init(comptime self: MultibootHeader) MultibootHeader {
        var header = self;
        header.checksum = -%(@as(u32, @bitCast(header.flags)) + MULTIBOOT_HEADER_MAGIC);
        return header;
    }
};

pub const MultibootAoutSymbolTable = extern struct {
    tabsize: u32,
    strsize: u32,
    addr: u32,
    reserved: u32,
};

pub const MultibootElfSectionHeaderTable = extern struct {
    num: u32,
    size: u32,
    addr: u32,
    shndx: u32,
};

pub const MultibootInfo = extern struct {
    /// Multiboot info version number
    flags: packed struct(u32) {
        /// is there basic lower/upper memory information?
        MEMORY: bool = false,
        /// is there a boot device set?
        BOOTDEV: bool = false,
        /// is the command-line defined?
        CMDLINE: bool = false,
        /// are there modules to do something with?
        MODS: bool = false,
        /// is there a symbol table loaded?
        AOUT_SYMS: bool = false,
        /// is there an ELF section header table?
        ELF_SHDR: bool = false,
        /// is there a full memory map?
        MEM_MAP: bool = false,
        /// Is there drive info?
        DRIVE_INFO: bool = false,
        /// Is there a config table?
        CONFIG_TABLE: bool = false,
        /// Is there a boot loader name?
        BOOT_LOADER_NAME: bool = false,
        /// Is there an APM table?
        APM_TABLE: bool = false,
        /// Is there video information?
        VBE_INFO: bool = false,
        /// Is there framebuffer information?
        FRAMEBUFFER_INFO: bool = false,

        _: u19 = 0x00,
    },

    /// Available memory from BIOS
    mem_lower: u32,
    mem_upper: u32,

    /// "root" partition
    boot_device: u32,

    /// Kernel command line
    cmdline: u32,

    /// Boot-Module list
    mods_count: u32,
    mods_addr: u32,
    u: extern union {
        aout_sym: MultibootAoutSymbolTable,
        elf_sec: MultibootElfSectionHeaderTable,
    },

    /// Memory Mapping buffer
    mmap_length: u32,
    mmap_addr: u32,

    /// Drive Info buffer
    drives_length: u32,
    drives_addr: u32,

    /// ROM configuration table
    config_table: u32,

    /// Boot Loader Name
    boot_loader_name: u32,

    /// APM table
    apm_table: u32,

    /// Video
    vbe_control_info: u32,
    vbe_mode_info: u32,
    vbe_mode: u16,
    vbe_interface_seg: u16,
    vbe_interface_off: u16,
    vbe_interface_len: u16,

    framebuffer_addr: u64,
    framebuffer_pitch: u32,
    framebuffer_width: u32,
    framebuffer_height: u32,
    framebuffer_bpp: u8,
    framebuffer_type: enum(u8) {
        INDEXED = 0,
        RGB = 1,
        EGA_TEXT = 2,
    },

    framebuffer_data: extern union {
        indexed: extern struct {
            framebuffer_palette_addr: u32,
            framebuffer_palette_num_colors: u16,
        },
        direct: extern struct {
            framebuffer_red_field_position: u8,
            framebuffer_red_mask_size: u8,
            framebuffer_green_field_position: u8,
            framebuffer_green_mask_size: u8,
            framebuffer_blue_field_position: u8,
            framebuffer_blue_mask_size: u8,
        },
    },
};

pub const MultibootColor = extern struct {
    red: u8,
    green: u8,
    blue: u8,
};

pub const MultibootMmapEntry = packed struct {
    size: u32,
    addr: u64,
    len: u64,
    type: enum(u32) {
        AVAILABLE = 1,
        RESERVED = 2,
        ACPI_RECLAIMABLE = 3,
        NVS = 4,
        BADRAM = 5,
    },
};

pub const MultibootModList = extern struct {
    /// The memory used goes from bytes 'mod_start' to 'mod_end-1' inclusive
    mod_start: u32,
    mod_end: u32,

    /// Module command line
    cmdline: u32,

    /// Padding to take it to 16 bytes (must be zero)
    pad: u32,
};

/// APM BIOS info.
pub const MultibootApmInfo = extern struct {
    version: u16,
    cseg: u16,
    offset: u32,
    cseg_16: u16,
    dseg: u16,
    flags: u16,
    cseg_len: u16,
    cseg_16_len: u16,
    dseg_len: u16,
};

export const multiboot_header = (MultibootHeader{
    .magic = MULTIBOOT_HEADER_MAGIC,
    .flags = .{
        .PAGE_ALIGN = true,
        .MEMORY_INFO = true,
    },
}).init();

export var boot_stack: [4096]u8 = undefined;

/// 32-bit multiboot entry function
/// EAX = multiboot bootloader magic
/// EBX = 32-bit physical address of multiboot info structure
/// GDT with descriptor for 4GB flat CS and DS segments
/// Interrupts are disabled
/// DS = ES = FS = GS = SS = 0x10
export fn _multiboot_entry() callconv(.naked) noreturn {
    _ = @import("boot.zig");
    asm volatile (
        \\  .code32
        \\      cmpl %[magic], %%eax
        \\      jne magic_mismatch
        \\
        \\      movl $multibootEntry, %%edi  /* Boot function address */
        \\      movl $boot_stack, %%esi  /* Boot stack address */
        \\      movl %%ebx, %%edx      /* Multiboot information structure */
        \\      call boot32
        \\
        \\  magic_mismatch:
        \\      cli
        \\      hlt
        :
        : [magic] "i" (MULTIBOOT_BOOTLOADER_MAGIC),
    );
}

export fn multibootEntry() noreturn {
    while (true) {}
}
