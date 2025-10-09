// SPDX-License-Identifier: Elastic-2.0
//
// Copyright (c) 2024, Pribess (Heewon Cho).
// Licensed under the Elastic-2.0 License.
// You may not use this file except in compliance with the License.
//

fn PagingLevel(comptime T: type, comptime huge: bool) type {
    return extern struct {
        pub const Entry = T;

        entries: [512]Entry align(0x1000),

        pub fn createPartial(frame: u64, count: usize, options: Entry) @This() {
            @setEvalBranchQuota(2000);

            if (count > 512) @compileError("number of entries cannot exceed 512");

            var entries = [_]Entry{undefined} ** count;
            for (&entries, frame..) |*r, i| {
                if (huge) {
                    const constructor = @typeInfo(Entry).@"union";
                    if (!options.table.ps)
                        r.*.table = constructor.fields[0].type.create(i, options.table)
                    else
                        r.*.page = constructor.fields[1].type.create(i, options.page);
                } else r.* = Entry.create(i, options);
            }

            return .{ .entries = entries ++
                (if (!huge) [_]Entry{.{ .p = false, .address = 0x00 }} else [_]Entry{.{ .table = .{ .p = false, .address = 0x00 } }}) ** (512 - count) };
        }

        pub fn create(frame: u64, options: Entry) @This() {
            return createPartial(frame, 512, options);
        }
    };
}

pub const Page = struct {
    const TableType = PageEntry;
    pub const Table = PagingLevel(TableType, false);

    const DirecotryType = packed union {
        table: TableEntry(TableType),
        page: HugePageEntry(21),
    };
    pub const Directory = PagingLevel(DirecotryType, true);

    const DirectoryPointerType = packed union {
        table: TableEntry(DirecotryType),
        page: HugePageEntry(30),
    };
    pub const DirectoryPointer = PagingLevel(DirectoryPointerType, true);

    const MapLevel4Type = TableEntry(DirectoryPointerType);
    pub const MapLevel4 = PagingLevel(MapLevel4Type, false);

    const MapLevel5Type = TableEntry(MapLevel4Type);
    pub const MapLevel5 = PagingLevel(MapLevel5Type, false);
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

        pub fn get(self: @This()) *T {
            return @ptrFromInt(self.address << 12);
        }

        pub fn insert(self: @This(), table: *T) void {
            self.address = @intFromPtr(table) >> 12;
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

    pub fn get(self: @This()) u64 {
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

        pub fn get(self: @This()) u64 {
            return self.address >> size;
        }
    };
}
