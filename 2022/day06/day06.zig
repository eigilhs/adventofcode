const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const input = try stdin.readAllAlloc(arena.allocator(), 1 << 32);

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ find_marker(4, input), find_marker(14, input) },
    );
}

fn find_marker(count: usize, data: []const u8) usize {
    var i: usize = 0;
    var seen: u32 = 0;
    while (i < data.len) : (i += 1) {
        seen ^= @as(u32, 1) << @intCast(u5, data[i] - 'a');
        if (@popCount(seen) == count)
            break;
        if (i > count - 2)
            seen ^= @as(u32, 1) << @intCast(u5, data[i - (count - 1)] - 'a');
    }
    return i + 1;
}
