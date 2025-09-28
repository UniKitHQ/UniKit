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

pub const PML4E = TableEntry(PDPTE_1GB);

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

fn PagingLevel(comptime T: type) type {
    return struct {
        pub const Entry = T;

        entries: [512]Entry align(0x1000),

        pub fn createLinear(frame: u64, count: usize) @This() {
            @setEvalBranchQuota(2000);

            if (count > 512) @compileError("number of entries cannot exceed 512");

            var entries = [_]Entry{undefined} ** count;
            for (&entries, frame..) |*r, i| {
                r.* = Entry.create(i, .{});
            }

            return .{
                .entries = entries ++ ([_]Entry{.{ .p = false, .address = 0x00 }} ** (512 - count)),
            };
        }

        pub fn create(frame: u64) @This() {
            return createLinear(frame, 512);
        }
    };
}

pub const Page = struct {
    pub const Table = PagingLevel(PageEntry);

    pub const Directory = PagingLevel(packed union {
        table: TableEntry(Table),
        page: HugePageEntry(21),
    });

    pub const DirectoryPointer = PagingLevel(packed union {
        table: TableEntry(Directory),
        page: HugePageEntry(30),
    });

    pub const MapLevel4 = PagingLevel(TableEntry(DirectoryPointer));

    pub const MapLevel5 = PagingLevel(TableEntry(MapLevel4));
};

fn TableEntry(comptime T: type) type {
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
        _0: u1 = 0x00,
        /// Page Size
        ps: bool = false,
        _1: u3 = 0x00,
        /// HLAT Ignore
        r: bool = false,
        /// Table Address
        address: u40 = 0x00,
        _2: u11 = 0x00,
        /// Execute Disable
        xd: bool = false,

        pub fn create(address: u64, options: @This()) @This() {
            var entry = options;
            entry.address = address >> 12;
            return entry;
        }

        pub fn getTable(self: @This()) *T {
            return @ptrFromInt(self.address << 12);
        }
    };
}

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
    address: u40 = 0x00,
    _1: u7 = 0x00,
    /// Protection Key
    pk: u4 = 0x00,
    /// Execute Disable
    xd: bool = false,

    pub fn create(frame: u64, options: PageEntry) PageEntry {
        var entry = options;
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
        address: u39 = 0x00,
        _1: u7 = 0x00,
        /// Protection Key
        pk: u4 = 0x00,
        /// Execute Disable
        xd: bool = false,

        pub fn create(frame: u64, options: @This()) @This() {
            var entry = options;
            entry.address = frame << size;
            return entry;
        }

        pub fn getFrame(self: @This()) u64 {
            return self.address >> size;
        }
    };
}
