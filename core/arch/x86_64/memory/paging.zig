// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

pub const PageTable = struct {
    pub fn create(T: type, entries: []const T) [0x200]T {
        if (T != TableEntry and T != PDPTE_1GB and T != PDE_2MB and T != PTE_4KB)
            @compileError("The type must be one of the page table entry types");

        if (entries.len > 0x200)
            @compileError("The number of entries cannot exceed 512");

        return @constCast(entries ++ [_]T{.{ .p = false, .address = 0x00 }} ** (0x200 - entries.len)).*;
    }

    pub fn fill(T: type, entry: T, count: usize) [count]T {
        if (T != TableEntry and T != PDPTE_1GB and T != PDE_2MB and T != PTE_4KB)
            @compileError("The type must be one of the page table entry types");

        if (count > 0x200)
            @compileError("The number of entries cannot exceed 512");

        var table = [_]T{entry} ** count;
        for (&table, 0..) |*r, i| {
            r.*.address += i;
        }
        return table;
    }
};

pub const PML4E = TableEntry;

pub const PDPTE_1GB = packed struct(u64) {
    /// Present
    p: bool = true,
    /// Read/Write
    rw: enum(u1) {
        readonly = 0,
        writeable = 1,
    } = .readonly,
    /// User/Supervisor
    us: enum(u1) {
        supervisor = 0,
        user = 1,
    } = .supervisor,
    /// Page-level write-through
    pwt: bool = false,
    /// Page-level cache disable
    pcd: bool = false,
    /// Accessed
    a: bool = false,
    /// Dirty
    d: bool = false,
    /// Page Size
    ps: bool = true,
    /// Global
    g: bool = false,
    _0: u2 = 0x00,
    /// HLAT Ignore
    r: bool = false,
    /// Page Attribute Table
    pat: bool = false,
    _1: u17 = 0x00,
    /// Page Frame Address
    address: u22,
    _2: u7 = 0x00,
    /// Protection Key
    pk: u4 = 0x00,
    /// Execute Disable
    xd: bool = false,
};

pub const PDE = TableEntry;

pub const PDE_2MB = packed struct(u64) {
    /// Present
    p: bool = true,
    /// Read/Write
    rw: enum(u1) {
        readonly = 0,
        writeable = 1,
    } = .readonly,
    /// User/Supervisor
    us: enum(u1) {
        supervisor = 0,
        user = 1,
    } = .supervisor,
    /// Page-level write-through
    pwt: bool = false,
    /// Page-level cache disable
    pcd: bool = false,
    /// Accessed
    a: bool = false,
    /// Dirty
    d: bool = false,
    /// Page Size
    ps: bool = true,
    /// Global
    g: bool = false,
    _0: u2 = 0x00,
    /// HLAT Ignore
    r: bool = false,
    /// Page Attribute Table
    pat: bool = false,
    _1: u8 = 0x00,
    /// Page Frame Address
    address: u31,
    _2: u7 = 0x00,
    /// Protection Key
    pk: u4 = 0x00,
    /// Execute Disable
    xd: bool = false,
};

pub const PTE_4KB = packed struct(u64) {
    /// Present
    p: bool = true,
    /// Read/Write
    rw: enum(u1) {
        readonly = 0,
        writeable = 1,
    } = .readonly,
    /// User/Supervisor
    us: enum(u1) {
        supervisor = 0,
        user = 1,
    } = .supervisor,
    /// Page-level write-through
    pwt: bool = false,
    /// Page-level cache disable
    pcd: bool = false,
    /// Accessed
    a: bool = false,
    /// Dirty
    d: bool = false,
    /// Page Attribute Table
    pat: bool = false,
    /// Global
    g: bool = false,
    _0: u2 = 0x00,
    /// HLAT Ignore
    r: bool = false,
    /// Page Frame Address
    address: u40,
    _1: u7 = 0x00,
    /// Protection Key
    pk: u4 = 0x00,
    /// Execute Disable
    xd: bool = false,
};

pub const Page = struct {
    pub const Table = struct {
        pub const Entry = PageEntry;
    };

    pub const Directory = struct {
        pub const Entry = packed union {
            table: TableEntry,
            page: HugePageEntry(21),
        };
    };

    pub const DirectoryPointer = struct {
        pub const Entry = packed union {
            table: TableEntry,
            page: HugePageEntry(30),
        };
    };

    pub const MapLevel4 = struct {
        pub const Entry = TableEntry;
    };

    pub const MapLevel5 = struct {
        pub const Entry = TableEntry;
    };
};

const TableEntry = packed struct(u64) {
    /// Present
    p: bool = true,
    /// Read/Write
    rw: enum(u1) {
        readonly = 0,
        writeable = 1,
    } = .readonly,
    /// User/Supervisor
    us: enum(u1) {
        supervisor = 0,
        user = 1,
    } = .supervisor,
    /// Page-level write-through
    pwt: bool = false,
    /// Page-level cache disable
    pcd: bool = false,
    /// Accessed
    a: bool = false,
    _0: u1 = 0x00,
    /// Page Size
    ps: bool = false,
    _1: u3 = 0x00,
    /// HLAT Ignore
    r: bool = false,
    /// Table Address
    address: u40,
    _2: u11 = 0x00,
    /// Execute Disable
    xd: bool = false,

    pub fn create(address: u64, entry: @This()) @This() {
        entry.address = address >> 12;
        return entry;
    }

    pub fn getAddress(self: @This()) u64 {
        return self.address << 12;
    }
};

const PageEntry = packed struct(u64) {
    /// Present
    p: bool = true,
    /// Read/Write
    rw: enum(u1) {
        readonly = 0,
        writeable = 1,
    } = .readonly,
    /// User/Supervisor
    us: enum(u1) {
        supervisor = 0,
        user = 1,
    } = .supervisor,
    /// Page-level write-through
    pwt: bool = false,
    /// Page-level cache disable
    pcd: bool = false,
    /// Accessed
    a: bool = false,
    /// Dirty
    d: bool = false,
    /// Page Attribute Table
    pat: bool = false,
    /// Global
    g: bool = false,
    _0: u2 = 0x00,
    /// HLAT Ignore
    r: bool = false,
    /// Page Frame Address
    address: u40,
    _1: u7 = 0x00,
    /// Protection Key
    pk: u4 = 0x00,
    /// Execute Disable
    xd: bool = false,

    pub fn create(frame: u64, entry: @This()) @This() {
        entry.address = frame << 12;
        return entry;
    }

    pub fn getFrame(self: @This()) u64 {
        return self.address >> 12;
    }
};

fn HugePageEntry(comptime size: u64) type {
    return packed struct(u64) {
        /// Present
        p: bool = true,
        /// Read/Write
        rw: enum(u1) {
            readonly = 0,
            writeable = 1,
        } = .readonly,
        /// User/Supervisor
        us: enum(u1) {
            supervisor = 0,
            user = 1,
        } = .supervisor,
        /// Page-level write-through
        pwt: bool = false,
        /// Page-level cache disable
        pcd: bool = false,
        /// Accessed
        a: bool = false,
        /// Dirty
        d: bool = false,
        /// Page Size
        ps: bool = true,
        /// Global
        g: bool = false,
        _0: u2 = 0x00,
        /// HLAT Ignore
        r: bool = false,
        /// Page Attribute Table
        pat: bool = false,
        address: u39,
        _1: u7 = 0x00,
        /// Protection Key
        pk: u4 = 0x00,
        /// Execute Disable
        xd: bool = false,

        pub fn create(frame: u64, entry: @This()) @This() {
            entry.address = frame << size;
            return entry;
        }

        pub fn getFrame(self: @This()) u64 {
            return self.address >> size;
        }
    };
}
