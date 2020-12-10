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
        if (!twoSum(nums[i .. i + 25], n)) break n;
    } else unreachable;

    var i: usize = 0;
    var j = i + 1;
    var sum = nums[i] + nums[j];
    while (sum != part1) if (sum > part1) {
        sum -= nums[i];
        i += 1;
    } else {
        j += 1;
        sum += nums[j];
    };

    var max = nums[j];
    var min = max;
    for (nums[i..j]) |n| {
        if (n < min) min = n;
        if (n > max) max = n;
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ part1, min + max });
}

fn twoSum(nums: []u64, target: u64) bool {
    for (nums) |n, i|
        for (nums[i + 1 ..]) |m|
            if (n + m == target)
                return true;
    return false;
}
