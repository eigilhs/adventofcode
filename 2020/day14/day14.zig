const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var mem1 = std.AutoHashMap(u64, u64).init(&arena.allocator);
    var mem2 = std.AutoHashMap(u64, u64).init(&arena.allocator);
    var mask: Mask = undefined;

    const input = try stdin.readAllAlloc(&arena.allocator, 1 << 32);
    var lines = std.mem.tokenize(input, "\n");
    while (lines.next()) |line| switch (line[1]) {
        'a' => mask = Mask.parse(line[7..]),
        'e' => {
            var tkn = std.mem.tokenize(line[4..], "] =");
            const addr = try std.fmt.parseUnsigned(u64, tkn.next().?, 10);
            const value = try std.fmt.parseUnsigned(u64, tkn.next().?, 10);

            try mem1.put(addr, mask.value(value));
            try (Part2{
                .mem = &mem2,
                .value = value,
                .floating = mask.x,
            }).put(mask.address(addr), 0);
        },
        else => unreachable,
    };

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ sum(mem1), sum(mem2) });
}

const Mask = struct {
    on: u64,
    x: u64,

    fn value(self: @This(), val: u64) u64 {
        return val & self.x ^ self.on;
    }

    fn address(self: @This(), addr: u64) u64 {
        return addr | self.on & ~self.x;
    }

    fn parse(input: []const u8) @This() {
        var m: Mask = .{ .on = 0, .x = 0 };
        for (input) |c, i| {
            const bit = @as(u64, 1) << @intCast(u6, 35 - i);
            switch (c) {
                'X' => m.x |= bit,
                '1' => m.on |= bit,
                '0' => {},
                else => unreachable,
            }
        }
        return m;
    }
};

const Part2 = struct {
    mem: *std.AutoHashMap(u64, u64),
    value: u64,
    floating: u64,

    fn put(self: @This(), addr: u64, i: u6) error{OutOfMemory}!void {
        if (i == 36) return try self.mem.put(addr, self.value);
        const bit = @intCast(u64, 1) << (35 - i);
        if (self.floating & bit != 0)
            try self.put(addr | bit, i + 1);
        try self.put(addr, i + 1);
    }
};

fn sum(map: anytype) usize {
    var s: usize = 0;
    var mi = map.iterator();
    while (mi.next()) |e|
        s += e.value;
    return s;
}
