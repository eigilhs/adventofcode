const std = @import("std");

pub fn main() !void {
    const ir = std.io.getStdIn().reader();
    const stdin = std.io.bufferedReader(ir).reader();
    const stdout = std.io.getStdOut().writer();

    var buffer: [1 << 10]u8 = undefined;
    var part1: u64 = 0;
    var part2: u64 = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        part1 += calc(std.io.fixedBufferStream(line).reader());
        part2 += advancedCalc(std.io.fixedBufferStream(line).reader());
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ part1, part2 });
}

fn calc(reader: anytype) u64 {
    var s: u64 = 0;
    var op: enum { add, mul, init } = .init;
    return while (reader.readByte() catch null) |c| switch (c) {
        '+' => op = .add,
        '*' => op = .mul,
        '(' => {
            const x = calc(reader);
            switch (op) {
                .init => s = x,
                .mul => s *= x,
                .add => s += x,
            }
        },
        ')' => break s,
        '0'...'9' => switch (op) {
            .init => s = c - '0',
            .mul => s *= c - '0',
            .add => s += c - '0',
        },
        ' ' => {},
        else => unreachable,
    } else s;
}

fn advancedCalc(reader: anytype) u64 {
    var s: u64 = 0;
    return while (reader.readByte() catch null) |c| switch (c) {
        '*' => break s * advancedCalc(reader),
        '(' => s += advancedCalc(reader),
        ')' => break s,
        '0'...'9' => s += c - '0',
        ' ', '+' => {},
        else => unreachable,
    } else s;
}
