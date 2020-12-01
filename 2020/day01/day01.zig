const std = @import("std");

pub fn main() !void {
    var buffer: [4]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var expenses = std.ArrayList(i32).init(&arena.allocator);

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line|
        try expenses.append(try std.fmt.parseInt(i32, line, 10));

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ part1(expenses.items), part2(expenses.items) },
    );
}

fn part1(expenses: []i32) i32 {
    for (expenses) |a, i|
        for (expenses[i + 1 ..]) |b|
            if (a + b == 2020)
                return a * b;
    unreachable;
}

fn part2(expenses: []i32) i32 {
    for (expenses) |a, i|
        for (expenses[i + 1 ..]) |b, j|
            for (expenses[i + j + 1 ..]) |c|
                if (a + b + c == 2020)
                    return a * b * c;
    unreachable;
}
