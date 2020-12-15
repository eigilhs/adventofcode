const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var seen = std.AutoHashMap(u64, usize).init(&arena.allocator);
    const input = try stdin.readAllAlloc(&arena.allocator, 1 << 32);
    var nums = std.mem.tokenize(input, ",\n");

    var n = try std.fmt.parseUnsigned(u64, nums.next().?, 10);
    var i: usize = 1;
    while (nums.next()) |s| : (i += 1) {
        try seen.put(n, i);
        n = try std.fmt.parseUnsigned(u64, s, 10);
    }

    inline for ([_]usize{ 2020, 30_000_000 }) |limit, part| {
        while (i < limit) : (i += 1)
            n = if (try seen.fetchPut(n, i)) |e| i - e.value else 0;
        try stdout.print("Part {}: {}\n", .{ part + 1, n });
    }
}
