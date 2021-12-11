const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var crabs = std.ArrayList(u32).init(&arena.allocator);

    const input = try stdin.readAllAlloc(&arena.allocator, 1 << 32);
    var splt = std.mem.tokenize(u8, input, ",\n");
    while (splt.next()) |n|
        try crabs.append(try std.fmt.parseUnsigned(u32, n, 10));

    std.sort.sort(u32, crabs.items, {}, comptime std.sort.asc(u32));

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        try part1(crabs.items),
        try part2(crabs.items),
    });
}

fn part1(crabs: []u32) !usize {
    const goal = @intCast(i64, crabs[crabs.len / 2]);

    var travel: usize = 0;
    for (crabs) |c|
        travel += @intCast(usize, try std.math.absInt(goal - c));

    return travel;
}

fn part2(crabs: []u32) !usize {
    var sum: f64 = 0;
    for (crabs) |c|
        sum += @intToFloat(f64, c);

    const mean = sum / @intToFloat(f64, crabs.len);

    const k = for (crabs) |c, i| {
        if (c > @floatToInt(usize, sum) / crabs.len)
            break @intToFloat(f64, i);
    } else unreachable;

    const goal = @floatToInt(
        i64,
        if (mean - @floor(mean) > (2 * k - 1) / @intToFloat(f64, 2 * crabs.len))
            @ceil(mean)
        else
            @floor(mean),
    );

    var travel: usize = 0;
    for (crabs) |c| {
        const cost = @intCast(usize, try std.math.absInt(goal - c));
        travel += cost * (cost + 1) / 2;
    }

    return travel;
}
