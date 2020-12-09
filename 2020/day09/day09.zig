const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var buffer: [20]u8 = undefined;
    var al = std.ArrayList(u64).init(&arena.allocator);
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line|
        try al.append(try std.fmt.parseUnsigned(u64, line, 10));
    const nums = al.items;

    const part1 = for (nums[25..]) |n, i| {
        if (!twosum(nums[i .. i + 25], n)) break n;
    } else unreachable;

    const part2 = outer: for (nums) |n, i| {
        var sum = n;
        var min = n;
        var max = n;
        for (nums[i + 1 ..]) |m| {
            if (m < min) min = m;
            if (m > max) max = m;
            sum += m;
            if (sum == part1)
                break :outer min + max;
        }
    } else unreachable;

    try stdout.print("Part 1: {}\nPart2: {}\n", .{ part1, part2 });
}

fn twosum(nums: []u64, target: u64) bool {
    for (nums) |n, i|
        for (nums[i + 1 ..]) |m|
            if (n + m == target)
                return true;
    return false;
}
